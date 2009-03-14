
--------------------------------------------------------------------------------------------------
-- Global SuicideKings variables
--------------------------------------------------------------------------------------------------

SUICIDEKINGS_VERSION = GetAddOnMetadata("SuicideKings", "Version"); -- get version number direct from .toc

SUICIDEKINGS_ITEM_HEIGHT = 16;
SUICIDEKINGS_ITEMS_SHOWN = 23;
SUICIDEKINGS_JUNK_LABEL = "Junk";
SUICIDEKINGS_ROLL_MIN = 1;
SUICIDEKINGS_ROLL_MAX = 1000;
SUICIDEKINGS_POPUP = "SUICIDEKINGS_EDIT";
SUICIDEKINGS_CONFIRM="SUICIDEKINGS_CONFIRM";
SUICIDEKINGS_DEBUG = false;
SUICIDEKINGS_CHANNEL_PREFIX = "SuicKing";

-- UIPanelWindows["SuicideKingsFrame"] =		{ area = "left",	pushable = 11 };

local l_isCaptureActive = 0;
local l_currentRollList = { };
local l_loadedList = nil;
local l_undoList = { };
local l_reserveList = { };
local l_supervisor = false;
local l_bidOpen = false;
local l_highBidders = { };
local l_inRaid = false;

StaticPopupDialogs[SUICIDEKINGS_POPUP] = {
	text = SUICIDEKINGS_MSG_SAVE,
	button1 = TEXT(ACCEPT),
	button2 = TEXT(CANCEL),
	hasEditBox = 1,
	maxLetters = 16,
	OnAccept = function()
		local editBox = getglobal(this:GetParent():GetName().."EditBox");
		SuicideKings_OnMessageBoxAccept(editBox:GetText());
	end,
	OnShow = function()
		getglobal(this:GetName().."EditBox"):SetFocus();
		getglobal(this:GetName().."EditBox"):SetText("");
	end,
	OnHide = function()
		if ( ChatFrameEditBox:IsVisible() ) then
			ChatFrameEditBox:SetFocus();
		end
		getglobal(this:GetName().."EditBox"):SetText("");
	end,
	EditBoxOnEnterPressed = function()
		local editBox = getglobal(this:GetParent():GetName().."EditBox");
		SuicideKings_OnMessageBoxAccept(editBox:GetText());
		this:GetParent():Hide();
	end,
	EditBoxOnEscapePressed = function()
		this:GetParent():Hide();
	end,
	timeout = 0,
	exclusive = 1,
	whileDead = 1
};

StaticPopupDialogs[SUICIDEKINGS_CONFIRM] = {
	text = "Placeholder",
	button1 = TEXT(ACCEPT),
	button2 = TEXT(CANCEL),
	hasEditBox = false,
	maxLetters = 16,
	OnAccept = function()
                      SuicideKings_OnConfirm(StaticPopupDialogs[SUICIDEKINGS_CONFIRM].arg1, 
                                             StaticPopupDialogs[SUICIDEKINGS_CONFIRM].arg2, 
                                             StaticPopupDialogs[SUICIDEKINGS_CONFIRM].arg3);
                   end,
	timeout = 0,
	exclusive = 1,
	whileDead = 1
};


SavedRollLists = { };
SuicideKingsOptions = {
   auto = false,
   prefix = nil,
   prefix_filter = false,
   use_prefix = false
};

--------------------------------------------------------------------------------------------------
-- Internal functions
--------------------------------------------------------------------------------------------------

--
-- Uncategorized functions; will sort later
--

-- Sea has this exact function in it, but in the interest
-- of minimizing dependencies, and since this function is so
-- damn simple, here it is again.
function SK_format(format, ...)
   local ret = format;
   local args = { ... };

   for index, arg in ipairs(args) do
      ret = string.gsub(ret, "<"..index..">", tostring(arg));
   end
   return ret;
end

function SK_confirmDialog(prompt, handler, arg1, arg2, arg3)
   StaticPopupDialogs[SUICIDEKINGS_CONFIRM].text = prompt;
   SuicideKings_OnConfirm = handler;
   StaticPopupDialogs[SUICIDEKINGS_CONFIRM].arg1 = arg1;
   StaticPopupDialogs[SUICIDEKINGS_CONFIRM].arg2 = arg2;
   StaticPopupDialogs[SUICIDEKINGS_CONFIRM].arg3 = arg3;
   StaticPopup_Show(SUICIDEKINGS_CONFIRM);
end

local function SK_print(msg)
   if( DEFAULT_CHAT_FRAME ) then
      DEFAULT_CHAT_FRAME:AddMessage(msg);
   end
end

function SuicideKings_Debug(msg)
   if (SUICIDEKINGS_DEBUG) then
      SK_print(msg);
   end
end

local function isLeader()
   -- Return true if the player is the raid leader or an assist,
   -- or if a raid is not active, true if the player is the party leader
   if (GetNumRaidMembers() > 0) then
      return (IsRaidLeader() or IsRaidOfficer());
   elseif (GetNumPartyMembers() > 0) then
      return IsPartyLeader();
   end
   return false;
end

local function isInGroup()
   -- Return true if the player is in a party or raid
   return ((GetNumPartyMembers() > 0) or (GetNumRaidMembers() > 0));
end

local function getClassColor(class)
   return RAID_CLASS_COLORS[string.upper(class)];
end

local function SK_sortRolls(rollList)
   -- Make sure all rolls in the supplied list
   -- are in sorted order.
   local sorted = { };

   for idx, rollInfo in ipairs(rollList) do
      table.insert(sorted, rollInfo.roll);
   end
   table.sort(sorted);

   -- We want descending order...
   for idx, rollNumber in ipairs(sorted) do
      rollList[(#sorted) - idx + 1].roll = sorted[idx];
   end
end

local function SK_prefixizeList(listName)
   if(SuicideKingsOptions.prefix and SuicideKingsOptions.use_prefix) then
      return SuicideKingsOptions.prefix.." - "..listName;
   end
   return listName
end

local function SuicideKingsFrameDropDown_Initialize()
   local info;
   local index = 1;
   local selected = nil;

   for saveName, _ in pairs(SavedRollLists) do
      if (index > UIDROPDOWNMENU_MAXBUTTONS) then
         SK_print(SUICIDEKINGS_MSG_TOO_MANY_LISTS);
         break;
      end
      -- Skip this list if we are filtering the drop down
      -- for only lists of the configured prefix.
      if (not SuicideKingsOptions.prefix_filter or 
          not SuicideKingsOptions.prefix or
          SuicideKingsOptions.prefix == 
             string.sub(saveName, 1, 
                        string.len(SuicideKingsOptions.prefix))) then
         info = { };
         info.text = saveName;
         info.func = SuicideKingsFrameDropDownButton_OnClick;
         UIDropDownMenu_AddButton(info);
         if (saveName == l_loadedList) then
            selected = index;
         end
         index = index + 1;
      end
   end

   UIDropDownMenu_SetSelectedID(SuicideKingsFrameDropDown, selected);
end

local function SuicideKings_VariablesLoaded()
   SuicideKingsTitleText:SetText(string.format(SUICIDEKINGS_TITLE, SUICIDEKINGS_VERSION));

   -- Make sure we are sorted from previous versions that were not.
   for _, rollList in pairs(SavedRollLists) do
      SK_sortRolls(rollList);
   end

   SuicideKingsUsePrefix:SetChecked(SuicideKingsOptions.use_prefix);
   SuicideKingsAutoToggle:SetChecked(SuicideKingsOptions.auto);
   SuicideKingsFilterToggle:SetChecked(SuicideKingsOptions.prefix_filter);
   
   if (SuicideKingsOptions.prefix) then
      SuicideKingsPrefixEditBox:SetText(SuicideKingsOptions.prefix);
   else
      SuicideKingsPrefixEditBox:SetText("");
   end

   SuicideKingsUseCustomChannel:SetChecked(SuicideKingsOptions.useCustomChannel);

   if (not SuicideKingsOptions.syncChannel) then
      SuicideKingsOptions.syncChannel = "MC1";
   end
   SuicideKingsChannelEditBox:SetText(SuicideKingsOptions.syncChannel);
   SuicideKingsRaidWarn:SetChecked(SuicideKingsOptions.raidWarn);
   SuicideKingsSendPosition:SetChecked(SuicideKingsOptions.sendPosition);
   SuicideKingsSpamAll:SetChecked(SuicideKingsOptions.spamAll);

   SuicideKings_Net_VariablesLoaded();
   SuicideKingsOptions.lastSavedVersion = SUICIDEKINGS_VERSION;

   -- Perform any fixups for the roll list for version compatibility.
   for listName, list in pairs(SavedRollLists) do
      for _, rollInfo in ipairs(list) do
         if (not rollInfo.fixupVersion or
             rollInfo.fixupVersion < SUICIDEKINGS_VERSION) then
            -- Clear a class name if it's accidentally localized.
            if (rollInfo.class and
                RAID_CLASS_COLORS[string.upper(rollInfo.class)] == nil) then
               rollInfo.class = nil;
            end

            -- Set the fixup version
            rollInfo.fixupVersion = SUICIDEKINGS_VERSION
         end
      end
   end
end

local function copyRollList(rollList)
   local ret = { };

   for _, rollInfo in ipairs(rollList) do
      local newRollInfo = { };

      for key, val in pairs(rollInfo) do
         newRollInfo[key] = val;
      end
      table.insert(ret, newRollInfo);
   end
   return ret;
end

local function addUndo(undoToken)
   undoToken.internal_listAsOfUndo = l_currentRollList;
   table.insert(l_undoList, undoToken);
   if (#l_undoList > 32) then
      table.remove(l_undoList, 1);
   end
end

local function updateFrozenPlayers(list)
   local people = { };
   local theList = list;

   if (not theList) then
      theList = l_currentRollList;
   end

   people[UnitName("player")] = 1;
   if (GetNumRaidMembers() > 0) then
      for index = 1, 40, 1 do
         local name = UnitName("raid"..index);

         if (name) then
            people[name] = 1;
         end
      end
   end

   if (GetNumPartyMembers() > 0) then
      for index = 1, 5, 1 do
         local name = UnitName("party"..index);

         if (name) then
            people[name] = 1;
         end
      end
   end

   for _, rollInfo in ipairs(theList) do
      if (people[rollInfo.player] == nil and
          not l_reserveList[rollInfo.player]) then
         rollInfo.frozen = 1;
      else
         rollInfo.frozen = 0;
      end
   end
end

local function checkSupervisor()
   if (isInGroup() and 
       not l_supervisor) then
      SK_print(SUICIDEKINGS_MASTER_NEEDED);
      return false;
   end
   return true;
end

local function checkLoadedList()
   if (not l_loadedList) then
      SK_print(SUICIDEKINGS_LIST_NEEDED);
      return false;
   end
   return true;
end

local function getUnitId(player)
   if (GetNumRaidMembers() > 0) then
      for index = 1, 40, 1 do
         if (UnitName("raid"..index) == player) then
            return "raid"..index;
         end
      end
   end
   if (GetNumPartyMembers() > 0) then
      for index = 1, 5, 1 do
         if (UnitName("party"..index) == player) then
            return "party"..index;
         end
      end
   end
   if (player == UnitName("player")) then
      return "player";
   end
end

local function checkRaidStatus()
   if (isInGroup()) then
-- The following code is causing spurious un-masters.
--      if (l_supervisor and not isLeader()) then
--         SK_print(SUICIDEKINGS_MSG_NO_LEADER);
--         l_supervisor = false;
--         SuicideKings_Net_IAmNotTheMaster(UnitName("player"));
--      end
      if (l_supervisor and (GetNumPartyMembers() > 1 or
                            GetNumRaidMembers() > 1)) then
         SuicideKings_Net_IAmTheMaster(UnitName("player"));
      end
   else
      SuicideKings_Debug("No longer in a group.");
      l_inRaid = false;
      l_supervisor = false;
      SuicideKings_Net_NotInRaid();
   end
end

local function get_auto_channel()
	-- Return an appropriate channel in order of preference: /raid, /p, /s
	local channel = "SAY"
	if (GetNumPartyMembers() > 0) then
		channel = "PARTY"
	end
	if (GetNumRaidMembers() > 0) then
		channel = "RAID"
	end
	return channel
end

local function chat(msg)
   -- Send a chat message
   local channel = get_auto_channel()
   SendChatMessage(msg, channel)
end

local function tellPlayer(player, msg, noecho)
   if (noecho) then
      SendChatMessage("<SuicideKings> "..msg, "WHISPER", nil, player);
   else
      SendChatMessage("[SuicideKings] "..msg, "WHISPER", nil, player);
   end
end

local function loadList(listName)
   l_loadedList = listName;
   UIDropDownMenu_SetText(SuicideKingsFrameDropDown, listName);
   l_currentRollList = SavedRollLists[listName];
   SuicideKingsListScrollFrame.selected = nil;
   SuicideKings_Update();
end

local function doSetAutoRollList(unitId)
   local rollList = SavedRollLists[SK_prefixizeList("Raid")];
   local found = false;

   if (rollList == nil) then
      rollList = { };
      SavedRollLists[SK_prefixizeList("Raid")] = rollList;
   end
   
   for _, rollInfo in ipairs(rollList) do
      if (rollInfo.player == UnitName(unitId)) then
         found = true;
         break
      end
   end

   if (not found) then
      loadList(SK_prefixizeList("Raid"));
      return true;
   end

   rollList = SavedRollLists[SK_prefixizeList(UnitClass(unitId))];
   found = false;

   if (rollList == nil) then
      rollList = { };
      SavedRollLists[SK_prefixizeList(UnitClass(unitId))] = rollList;
   end
   
   for _, rollInfo in ipairs(rollList) do
      if (rollInfo.player == UnitName(unitId)) then
         found = true;
         break
      end
   end

   if (not found) then
      loadList(SK_prefixizeList(UnitClass(unitId)));
      return true;
   end
   return false;
end

local function setAutoRollList(player)
   local unitId = getUnitId(player);

   if (unitId) then
      return doSetAutoRollList(getUnitId(player));
   end
   return false;
end

local function doNewList(listName)
   if (SavedRollLists[listName]) then
      local undoToken = {
         undo = function(this)
                   SavedRollLists[this.listName] = this.savedList;
                end,
         listName = listName,
         savedList = SavedRollLists[listName],
         actionName = SK_format(SUICIDEKINGS_FMT_ACTION_SAVE, listName);
      };
      addUndo(undoToken);
   end

   SavedRollLists[listName] = { };
end

local function itemLinkClicked(linkText)
   if (not checkSupervisor()) then
      return;
   end
   
   if (not checkLoadedList()) then
      return;
   end

   SuicideKings_OpenBidding(linkText);
end

-- Global UI functions

function SuicideKings_OnMessageBoxAccept(msg)
   if (not checkSupervisor()) then
      return;
   end

   doNewList(msg);

   if (l_isCaptureActive ~= 0) then
      SuicideKings_CaptureToggle();
   end
   loadList(msg);
   SuicideKings_Net_NewList(l_loadedList);
end

-- Nemes 01/10/2007 - item is now passed to the method, rather than the button
function SuicideKings_HandleModifiedItemClick(item)
   if (IsAltKeyDown() and 
       not IsShiftKeyDown() and 
          not IsControlKeyDown()) then
      itemLinkClicked(item);
   end
end

function SuicideKings_New()
   StaticPopup_Show(SUICIDEKINGS_POPUP);
end

function SuicideKings_ChatFrame_OnEvent(self, event)
   -- Intercept messages before they make them to the chat frame.
   if (event == "CHAT_MSG_WHISPER_INFORM" and
          (string.sub(arg1, 1, 14) == "<SuicideKings>" or
           string.sub(arg1, 1, 18) == "<<<SuicideKings>>>")) then
      return;
   end

   if (event == "CHAT_MSG_WHISPER" and
       string.sub(arg1, 1, 18) == "<<<SuicideKings>>>") then
      return;
   end

   if (string.sub(event, 1, 16) == "CHAT_MSG_CHANNEL" and
       SuicideKingsOptions.useCustomChannel and
          arg9 == SuicideKingsOptions.syncChannel) then
      return;
   end

   -- Some mods that hook the chat frame expect all these durn args.
   SuicideKings_originalChatFrame_OnEvent(self, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11);
end

function SuicideKings_ChatFrame_OnHyperlinkShow(link, text, button)
    if (IsAltKeyDown() and 
       not IsShiftKeyDown() and 
          not IsControlKeyDown()) then

      itemLinkClicked(text);
   end
end

function SuicideKings_OnLoad()
   local index;
   local value;

   this:RegisterEvent("VARIABLES_LOADED");
   this:RegisterEvent("CHAT_MSG_SYSTEM");
   this:RegisterEvent("CHAT_MSG_CHANNEL");
   this:RegisterEvent("CHAT_MSG_WHISPER");
   this:RegisterEvent("CHAT_MSG_ADDON");

   if (isInGroup()) then
      checkRaidStatus();
   end

   this:RegisterEvent("RAID_ROSTER_UPDATE");
   this:RegisterEvent("PARTY_MEMBERS_CHANGED");

   -- Register our slash command
   SLASH_SUICIDEKINGS1 = "/sk";
   SlashCmdList["SUICIDEKINGS"] = function(msg)
                                     SuicideKings_SlashCommandHandler(msg);
                                  end

   -- Hook the ChatFrame OnEvent function
   SuicideKings_originalChatFrame_OnEvent = ChatFrame_OnEvent;
   ChatFrame_OnEvent = SuicideKings_ChatFrame_OnEvent;

   hooksecurefunc("HandleModifiedItemClick",
                  SuicideKings_HandleModifiedItemClick);

   -- Set the position to the last saved value if any
   if (SuicideKingsOptions.xpos and
       SuicideKingsOptions.ypos) then
      SuicideKingsFrame:SetPoint("TOPLEFT","UIParent","BOTTOMLEFT",
                                 SuicideKingsOptions.xpos,
                                 SuicideKingsOptions.ypos);
   end

   SK_print(string.format(SUICIDEKINGS_LOADED_MSG, SUICIDEKINGS_VERSION));
end

local function SuicideKings_ProcessRoll(player, roll)
   local newRoll = { };
   local inserted = false;

   if (SuicideKingsOptions.auto) then
      if (not setAutoRollList(player)) then
         SK_print(SK_format(SUICIDEKINGS_FMT_NO_AUTO_ADD, player));
         return
      end
   end
      
   for _, rollInfo in ipairs(l_currentRollList) do
      if (rollInfo.player == player) then
         return
      end
   end
      
   if (l_loadedList) then
      SK_print(SK_format(SUICIDEKINGS_FMT_ADD, player, l_loadedList));
   else
      SK_print(SK_format(SUICIDEKINGS_FMT_ADD, player, SUICIDEKINGS_MSG_CURRENT_LIST));
   end
   
   local undoToken = { undo = function(this)
                                 table.remove(this.rollList,
                                              this.rollIndex);
                              end,
      rollList = l_currentRollList,
      actionName = SK_format(SUICIDEKINGS_FMT_ACTION_ADD, player)
   };
   
   if (roll and roll ~= 0) then
      newRoll.roll = roll;
   else
      newRoll.roll = 0;
      newRoll.insert_bottom = true;
   end
   
   newRoll.player = player;
   newRoll.frozen = 0;
   
   local firstPossibleIndex, lastPossibleIndex;
   
   -- Find the first and last possible positions where we can
   -- insert the roll.  Normally, the first possible position is
   -- before the first person with an equal or lesser roll than us, and
   -- the last possible position is after the last person with 
   -- an equal or greater roll than us.
   -- However, if the roll argument to this function is nil, we will
   -- only be inserted at the bottom, and can only have tie breakers with
   -- other rolls that have been inserted at the bottom since the last suicide.
   for index, rollInfo in ipairs(l_currentRollList) do
      if (newRoll.insert_bottom) then
         if (rollInfo.insert_bottom and not firstPossibleIndex) then
            firstPossibleIndex = index;
            break
         end
      else
         if (roll == rollInfo.roll and not firstPossibleIndex) then
            firstPossibleIndex = index;
         elseif (roll > rollInfo.roll) then
            lastPossibleIndex = index;
            break
         end
      end
   end
   
   if (not lastPossibleIndex) then
      lastPossibleIndex = #l_currentRollList + 1;
   end
   if (not firstPossibleIndex) then
      firstPossibleIndex = lastPossibleIndex;
   end
   
   local realIndex = firstPossibleIndex;
   
   if (lastPossibleIndex - firstPossibleIndex > 0) then
      -- Note: possible exploit by having the tie breaker number generated on
      -- the client side.  TODO: use an in-game /random roll.
      realIndex = math.random(firstPossibleIndex, lastPossibleIndex);
      SK_print(SK_format(SUICIDEKINGS_FMT_TIE,
                         player,
                         (lastPossibleIndex - firstPossibleIndex) + 1,
                         realIndex));
   end

   table.insert(l_currentRollList, realIndex, newRoll);
   undoToken.rollIndex = realIndex;
   addUndo(undoToken);
   SK_sortRolls(l_currentRollList);
   SuicideKings_Update();

   SuicideKings_Debug("(2) Processing roll ("..newRoll.player.."): "..newRoll.roll.." new = "..tostring(newRoll.insert_bottom));

   if (l_supervisor) then
      SuicideKings_Net_InsertPlayer(l_loadedList, realIndex, newRoll);
   end
end

function SuicideKings_MsgReceived()
   local msg = arg1
   ---- Check to see if it's a /random roll:
   if (l_isCaptureActive == 1) then
      local pattern = SUICIDEKINGS_ROLL_PATTERN
      local player, roll, min_roll, max_roll, report
      _, _, player, roll, min_roll, max_roll = string.find(msg, pattern)
      if (player and min_roll == ""..SUICIDEKINGS_ROLL_MIN and max_roll == ""..SUICIDEKINGS_ROLL_MAX) then
         if (not checkLoadedList()) then
            return;
         end
         SuicideKings_ProcessRoll(player, tonumber(roll));
      end
   end
end

function SuicideKings_OnEvent()
   if( event == "VARIABLES_LOADED" ) then
      SuicideKings_VariablesLoaded();
   elseif ( event == "CHAT_MSG_SYSTEM" ) then
      SuicideKings_MsgReceived();
   elseif ( event == "CHAT_MSG_CHANNEL") then
      if (not SuicideKingsOptions.useCustomChannel or
          arg9 ~= SuicideKingsOptions.syncChannel) then
         return -- not our channel
      end
      SuicideKings_Net_OnEvent();
   elseif (event == "CHAT_MSG_ADDON") then
      if (arg1 == SUICIDEKINGS_CHANNEL_PREFIX and
          not SuicideKingsOptions.useCustomChannel) then
         SuicideKings_Net_MessageIn(arg4, arg2);
      end
   elseif ( event == "RAID_ROSTER_UPDATE" or
           event == "PARTY_MEMBERS_CHANGED" ) then
      checkRaidStatus();
   elseif ( event == "CHAT_MSG_WHISPER" ) then
      if(string.sub(arg1, 1, 18) == "<<<SuicideKings>>>") then
         SuicideKings_Net_OnEvent();
      elseif(string.lower(arg1) == "suicide") then
         SuicideKings_Lookup(arg2, true);
      elseif (string.lower(arg1) == "bid") then
         SuicideKings_Bid(arg2);
      elseif (string.lower(arg1) == "retract") then
         SuicideKings_RetractBid(arg2);
      end
   end
end

function SuicideKingsItemButton_OnClick(button)
   if( button == "LeftButton" ) then
      SuicideKingsListScrollFrame.selected = this:GetID() + FauxScrollFrame_GetOffset(SuicideKingsListScrollFrame);
      SuicideKings_Debug("selection set to: "..SuicideKingsListScrollFrame.selected);
      SuicideKings_Update();
   end
end

function SuicideKings_OnShow()
   PlaySound("igMainMenuOpen");
   SuicideKings_Update();
end

function SuicideKings_OnHide()
   PlaySound("igMainMenuClose");
end

function SuicideKingsItemButton_OnEnter()	
end

function SuicideKingsItemButton_OnLeave()
end

function SuicideKingsFrameDropDown_OnLoad()
   local index = 1;
   UIDropDownMenu_Initialize(SuicideKingsFrameDropDown, SuicideKingsFrameDropDown_Initialize);
   UIDropDownMenu_SetWidth(SuicideKingsFrameDropDown, 80);
   UIDropDownMenu_SetButtonWidth(SuicideKingsFrameDropDown, 24);
   UIDropDownMenu_JustifyText(SuicideKingsFrameDropDown, "LEFT")
end

function SuicideKingsFrameDropDownButton_OnClick()
   local oldID = UIDropDownMenu_GetSelectedID(SuicideKingsFrameDropDown);

   if (l_isCaptureActive ~= 0 and not SuicideKingsOptions.auto) then
      SuicideKings_CaptureToggle();
   end
   UIDropDownMenu_SetSelectedID(SuicideKingsFrameDropDown, this:GetID());
   if( oldID ~= this:GetID() ) then
      loadList(this:GetText());
   end
end

function SuicideKings_Refresh()
   FauxScrollFrame_SetOffset(SuicideKingsListScrollFrame, 0);
   getglobal("SuicideKingsListScrollFrameScrollBar"):SetValue(0);
   SuicideKings_Update();
end

function SuicideKings_AmITheMaster()
   return l_supervisor;
end

function SuicideKings_OpenBidding(lootLink)
   if (not checkSupervisor()) then
      return
   end

   if (l_biddingOpen) then
      SK_print(SUICIDEKINGS_MSG_BID_OPEN);
      return
   end

   chat(SK_format(SUICIDEKINGS_FMT_BID_NOW_OPEN, lootLink));
   if (SuicideKingsOptions.raidWarn and
       isLeader()) then
      SendChatMessage(SK_format(SUICIDEKINGS_RAID_WARN_TEXT, lootLink),
                      "RAID_WARNING");
   end
   l_biddingOpen = true;
   l_highBidders = {};
end

function SuicideKings_CloseBidding()
   if (not checkSupervisor()) then
      return
   end

   if (not l_biddingOpen) then
      SK_print(SUICIDEKINGS_MSG_NOTOPEN);
      return
   end

   chat(SUICIDEKINGS_MSG_BID_CLOSED);
   if (#l_highBidders == 0) then
      chat(SUICIDEKINGS_MSG_NO_BIDDERS);
   else
      chat(SK_format(SUICIDEKINGS_FMT_WINNER,
                     l_highBidders[1]));
      SuicideKings_SuicideByName(l_highBidders[1]);
   end
   l_biddingOpen = false;
end

local function enterBid(player)
   local index = 1;
   local rollIndex, rollInfo;

   for rollIndex, rollInfo in ipairs(l_currentRollList) do
      if (l_highBidders[index] == player) then
         if (index == 1) then
            tellPlayer(player, SUICIDEKINGS_MSG_ALREADY_BIDDER);
         else
            tellPlayer(player, SK_format(SUICIDEKINGS_FMT_NOT_HIGH_BIDDER, l_highBidders[1]));
         end
         return
      end
      if (rollInfo.player == player) then
         table.insert(l_highBidders, index, player);

         if (index == 1) then
            chat(SK_format(SUICIDEKINGS_FMT_NEW_HIGH_BIDDER, player, rollIndex));
         else
            tellPlayer(player, SK_format(SUICIDEKINGS_FMT_NOT_HIGH_BIDDER, l_highBidders[1]));
         end
         return
      end
      if (rollInfo.player == l_highBidders[index]) then
         index = index + 1;
      end
   end
   tellPlayer(player, SUICIDEKINGS_MSG_NOT_ON_LIST);
end

function SuicideKings_RetractBid(player)
   for index, bidder in ipairs(l_highBidders) do
      if (bidder == player) then
         table.remove(l_highBidders, index);
         if (index == 1 and #l_highBidders ~= 0) then
            local myIndex, rollInfo;

            for myIndex, rollInfo in ipairs(l_currentRollList) do
               if (rollInfo.player == l_highBidders[1]) then
                  chat(SK_format(SUICIDEKINGS_FMT_NEW_HIGH_BIDDER, l_highBidders[1], 
                                 myIndex));
                  break
               end
            end
         end
         tellPlayer(player, SUICIDEKINGS_MSG_BID_RETRACT);
         if (#l_highBidders == 0) then
            chat(SUICIDEKINGS_MSG_BID_ALL_RETRACT);
         end
         return
      end
   end
   tellPlayer(player, SUICIDEKINGS_MSG_BID_NO_RETRACT);
end
      
function SuicideKings_Bid(player)
   if (not l_supervisor) then
      SK_print(SUICIDEKINGS_MSG_NOT_MASTER);
      return;
   end

   if (not l_biddingOpen) then
      tellPlayer(player, SUICIDEKINGS_MSG_NOTOPEN, true);
   elseif (not l_loadedList) then
      tellPlayer(player, SUICIDEKINGS_MSG_NO_LIST_SELECTED);
   else
      enterBid(player);
   end
end

--------------------------------------------------------------------------------------------------
-- Callback functions
--------------------------------------------------------------------------------------------------
function SuicideKings_CaptureToggle()
   if(l_isCaptureActive == 1) then
      l_isCaptureActive = 0;
      SuicideKingsFrameCaptureButton:SetText(SUICIDEKINGS_INACTIVE_LABEL);
   elseif (checkSupervisor()) then
      l_isCaptureActive = 1;
      SuicideKingsFrameCaptureButton:SetText(SUICIDEKINGS_ACTIVE_LABEL);
   end
end

function SuicideKings_ModeToggle(autoMode)
   SuicideKingsOptions.auto = autoMode;
end

function ToggleSuicideKings()
   if( SuicideKingsFrame:IsVisible() ) then
      if(l_isCaptureActive) then
         SuicideKings_CaptureToggle();
      end
      SuicideKingsFrame:Hide();
   else
      SuicideKingsFrame:Show();
   end
end

function SuicideKings_SlashCommandHandler(msg)
   local first, max, player, roll;

   if (not msg or msg == "") then
      ToggleSuicideKings();
   else
      local lowerMsg = string.lower(msg);
      if (lowerMsg == SUICIDEKINGS_SPAM_CMD) then
         SuicideKings_SpamChat();
         return
      elseif (lowerMsg == SUICIDEKINGS_NOROLL_CMD) then
         SuicideKings_SpamNotRolled();
         return
      elseif (lowerMsg == SUICIDEKINGS_HELP_CMD) then
         SK_print(SUICIDEKINGS_HELP);
         return
      elseif (string.sub(lowerMsg, 1, string.len(SUICIDEKINGS_SYNC_CMD)) == 
              SUICIDEKINGS_SYNC_CMD) then
         local args = strtrim(string.sub(msg, string.len(SUICIDEKINGS_SYNC_CMD) + 1));
         
         if (args == "" and checkSupervisor()) then
            SuicideKings_Net_StartFullSync();
         else
            -- Form /sk sync <player>
            local arglist = { strsplit(" ", args) };

            if (#arglist == 1) then
               SuicideKings_Debug("Synching to '"..arglist[1].."'");
               SuicideKings_Net_StartFullSync(arglist[1]);
            else
               -- Form /sk sync <player> <list1> [list2, ...]
               -- Only sends specific lists
               local playerName = arglist[1];

               table.remove(arglist, 1);
               SuicideKings_Net_StartFullSync(playerName, arglist);
            end
         end
         return;
      elseif (lowerMsg == SUICIDEKINGS_MASTER_CMD) then
         if (not isInGroup()) then
            SK_print(SUICIDEKINGS_MSG_RAID_REQUIRED);
         elseif (isLeader()) then
            SK_print(SUICIDEKINGS_NEW_MASTER);
            l_supervisor = true;
            SuicideKings_Net_Enable(true);
            SuicideKings_Net_IAmTheMaster(UnitName("player"));
         else
            SK_print(SUICIDEKINGS_OFFICER_NEEDED);
         end
         return
      elseif (lowerMsg == SUICIDEKINGS_CLOSE_CMD) then
         SuicideKings_CloseBidding();
         return;
      end

      _, _, first, max = string.find(lowerMsg, SUICIDEKINGS_SPAM_CMD_PATTERN1);
      if (first) then
         first = tonumber(first);
         max = tonumber(max);
         if (first ~= nil and max ~= nil) then
            SuicideKings_SpamChat(first, max);
            return
         end
         _, _, max = string.find(lowerMsg, SUICIDEKINGS_SPAM_CMD_PATTERN2);
         max = tonumber(max);
         if (max ~= nil) then
            SuicideKings_SpamChat(1, max);
            return
         end
      end

      _, _, player, roll = string.find(lowerMsg, SUICIDEKINGS_INSERT_CMD_PATTERN);
      if (player and roll) then
         if (not checkSupervisor() or
             not checkLoadedList()) then
            return;
         end

         player = string.upper(string.sub(player, 1, 1))..string.lower(string.sub(player, 2))
         SuicideKings_ProcessRoll(player, tonumber(roll));
         return
      end

      _, _, player = string.find(lowerMsg, SUICIDEKINGS_INSERT_CMD_PATTERN2);
      if (player) then
         if (not checkSupervisor() or
             not checkLoadedList()) then
            return;
         end

         player = string.upper(string.sub(player, 1, 1))..string.lower(string.sub(player, 2));
         SuicideKings_ProcessRoll(player);
         return
      end

      -- necrotic 1.19a
      _, _, player = string.find(lowerMsg, SUICIDEKINGS_SEARCH_CMD);
      if (player) then
         SuicideKings_Lookup(player);
         return
      end

      _, _, player = string.find(lowerMsg, SUICIDEKINGS_SUICIDE_CMD_PATTERN);
      if (player)then
         if (not checkSupervisor() or
             not checkLoadedList()) then
            return;
         end
         SuicideKings_SuicideByName(player);
         return
      end

      _, _, listName = string.find(msg, SUICIDEKINGS_LIST_CMD_PATTERN);
      if (listName) then
         if (SavedRollLists[listName]) then
            loadList(listName);
            SK_print(SK_format(SUICIDEKINGS_FMT_LIST_SELECTED, listName));
         else
            SK_print(SK_format(SUICIDEKINGS_FMT_LIST_NOT_FOUND, listName));
         end
         return;
      end

      -- If all else fails RTFM.
      SK_print(SUICIDEKINGS_HELP);
   end
end

function SuicideKings_Update()
   local iItem;
   
   FauxScrollFrame_Update(SuicideKingsListScrollFrame, #l_currentRollList, 
                          SUICIDEKINGS_ITEMS_SHOWN, SUICIDEKINGS_ITEM_HEIGHT);

   -- Show non-present players as blue
   updateFrozenPlayers();
   for iItem = 1, SUICIDEKINGS_ITEMS_SHOWN, 1 do
      local itemIndex = iItem + FauxScrollFrame_GetOffset(SuicideKingsListScrollFrame);
      local item = getglobal("SuicideKingsItem"..iItem);
      local fontString = item:CreateFontString(nil, nil, "GameFontNormalSmall")
      
      if( itemIndex <= #l_currentRollList ) then
         item:Show();

         local itemText = itemIndex..". "..l_currentRollList[itemIndex].player;
         
         if (l_currentRollList[itemIndex].roll ~= 0) then
            itemText = itemText.." ("..l_currentRollList[itemIndex].roll..")";
         end

         if (l_currentRollList[itemIndex].insert_bottom) then
            itemText = itemText.." ("..SUICIDEKINGS_NEW_INSERT..")";
         end

         --item:SetText(itemText);
         fontString:SetText(itemText);
         
         if (itemIndex == SuicideKingsListScrollFrame.selected) then
            if (l_currentRollList[itemIndex].frozen == 0) then
               --item:SetTextColor(0.8, 0, 0);
               fontString:SetTextColor(0.8, 0, 0);
            elseif (l_reserveList[l_currentRollList[itemIndex].player]) then
               --item:SetTextColor(0.5, 0.0, 0.0);
               fontString:SetTextColor(0.5, 0.0, 0.0);
            else
               --item:SetTextColor(0.8, 0.8, 0);
               fontString:SetTextColor(0.8, 0.8, 0);
            end
         else
            local classColor =
               {r=0.8, g=0.8, b=0.8};

            if (l_currentRollList[itemIndex].class) then
               classColor = getClassColor(l_currentRollList[itemIndex].class);
            else
               local unitId = getUnitId(l_currentRollList[itemIndex].player);

               if (unitId) then
                  _, l_currentRollList[itemIndex].class = UnitClass(unitId);
                  classColor = getClassColor(l_currentRollList[itemIndex].class);
               end
            end

            if (l_currentRollList[itemIndex].frozen == 0) then
               if (classColor) then
                  --item:SetTextColor(classColor.r, classColor.g, classColor.b);
                  fontString:SetTextColor(classColor.r, classColor.g, classColor.b);
               else
                  --item:SetTextColor(0.8, 0.8, 0.8);
                  fontString:SetTextColor(0.8, 0.8, 0.8);
               end
            elseif (l_reserveList[l_currentRollList[itemIndex].player]) then
               if (classColor) then
                  --item:SetTextColor(classColor.r * 0.7, classColor.g * 0.7, classColor.b * 0.7);
                  fontString:SetTextColor(classColor.r * 0.7, classColor.g * 0.7, classColor.b * 0.7);
               else
                  --item:SetTextColor(0.5, 0.5, 0.5);
                  fontString:SetTextColor(0.5, 0.5, 0.5);
               end
            else
               --item:SetTextColor(0, 0.5, 0.5);
               fontString:SetTextColor(0, 0.5, 0.5);
            end
         end
         
         item:SetFontString(fontString)

         --SuicideKings_Debug("Refreshing scroll item "..itemIndex.." text: "..item:GetText());
         SuicideKings_Debug("Refreshing scroll item " .. itemIndex);
         SuicideKings_Debug("text: " .. item:GetText());
      else
         item:Hide();
      end
   end
end

local function doUndo(fromUi)
   local message = nil;

   if (#l_undoList > 0) then
      local undoToken = l_undoList[#l_undoList];
      undoToken:undo();
      table.remove(l_undoList);
      if(undoToken.actionName) then
         if (fromUi) then
            SK_print(SUICIDEKINGS_UNDID_ACTION..undoToken.actionName);
         end
      end

      SK_sortRolls(l_currentRollList);
      SuicideKings_Update();

      if (fromUi) then
         if (undoToken.internal_listAsOfUndo) then
            for listName, rollList in pairs(SavedRollLists) do
               if (rollList == undoToken.internal_listAsOfUndo) then
                  if (rollList ~= l_currentRollList) then
                     loadList(listName);
                     return
                  end
                  break
               end
            end
         end
      end
   elseif (fromUi) then
      SK_print(SUICIDEKINGS_NO_UNDO);
   end

   return message;
end

function SuicideKings_Undo()
   if (not checkSupervisor()) then
      return
   end

   doUndo(true);
   SuicideKings_Net_Undo();
end

local function doRemovePlayer(listName, index)
   local undoToken = { undo = function(this)
                                    table.insert(this.rollList, 
                                                 this.rollIndex, 
                                                 this.rollInfo);
                                 end,
      rollList = SavedRollLists[listName],
      rollInfo = SavedRollLists[listName][index],
      rollIndex = index,
      actionName = SUICIDEKINGS_ACTION_REMOVE };
   local theList = SavedRollLists[listName];

   addUndo(undoToken);
   table.remove(theList, index);
   SuicideKingsListScrollFrame.selected = nil;
   SK_sortRolls(theList);
   SuicideKings_Update();
end

function SuicideKings_Remove()
   if (not checkSupervisor()) then
      return
   end

   if (SuicideKingsListScrollFrame.selected ~= nil) then
      local index = SuicideKingsListScrollFrame.selected
      doRemovePlayer(l_loadedList, SuicideKingsListScrollFrame.selected);
      SuicideKings_Net_RemovePlayer(l_loadedList, 
                                    index);
   end
end

function SuicideKings_Freeze()
   updateFrozenPlayers();
   SuicideKings_Update();
end

function SuicideKings_Insert()
   if (not checkSupervisor()) then
      return;
   end

   if (not checkLoadedList()) then
      return;
   end

   if (UnitIsPlayer("target")) then
      SuicideKings_ProcessRoll(UnitName("target"));
      if(SuicideKingsOptions.auto) then
         -- Insert twice in auto mode for class and raid list.
         SuicideKings_ProcessRoll(UnitName("target"));
      end
      SuicideKingsListScrollFrame.selected = nil;
      SuicideKings_Update();
   end
end

local function findNextUnfrozen(index, suicide, list)
   if (index > #list) then
      return suicide
   end

   for iItem = index, #list, 1 do
      if (list[iItem].frozen == 0) then
         return list[iItem];
      end
   end
   return suicide;
end

local function doSuicide(suicide, listName)
   local theList;

   if (not listName) then
      listName = l_loadedList;
      theList = l_currentRollList;
   else
      theList = SavedRollLists[listName];
      if (not theList) then
         SK_print("Internal error: suiciding non existant list: "..listName);
         return;
      end
   end

   local movingPlayers = { };

   -- Suicide the player represented by the
   -- supplied index into theList
   SK_print(SK_format(SUICIDEKINGS_SUICIDE, theList[suicide].player));
   updateFrozenPlayers(theList);
   if (theList[suicide].frozen ~= 0 and
       not l_reserveList[theList[suicide].player]) then
      SK_print(SUICIDEKINGS_MSG_NO_SUICIDE_FROZEN);
   else
      local undoToken = { 
         undo = function(this)
                   for idx=1, #this.rollList, 1 do
                      this.rollList[idx] = nil;
                   end
                   for _, rollInfo in ipairs(this.oldList) do
                      table.insert(this.rollList, rollInfo);
                   end
                end,
         rollList = theList,
         oldList = copyRollList(theList),
         actionName = SK_format(SUICIDEKINGS_FMT_ACTION_SUICIDE,
                                theList[suicide].player) };
      
      addUndo(undoToken);

      local suicideInfo = theList[suicide];

      for iItem = 1, #theList, 1 do
         theList[iItem].insert_bottom = nil;
         
         if (iItem >= suicide and
             (theList[iItem].frozen == 0 or
              l_reserveList[theList.player])) then
            table.insert(movingPlayers, iItem);
            theList[iItem] = findNextUnfrozen(iItem + 1, suicideInfo, theList);
         end
      end
   end
   SK_sortRolls(theList);
   SuicideKings_Update();

   if (l_supervisor) then
      SuicideKings_Net_Suicide(listName, suicide);
      if (SuicideKingsOptions.useCustomChannel) then
         -- We might be synching across groups, use the verbose
         -- suicide command.
         SuicideKings_Net_VerboseSuicide(listName, movingPlayers);
      end
   end

end

function SuicideKings_SuicideByName(playerName)
   if (not checkSupervisor()) then
      return;
   end

   for idx, rollInfo in ipairs(l_currentRollList) do
      if (string.lower(playerName) == string.lower(rollInfo.player)) then
         doSuicide(idx);
         return
      end
   end
   SK_print(SK_format(SUICIDEKINGS_FMT_PLAYER_NOT_FOUND, playerName));
end

function SuicideKings_Suicide()
   if (not checkSupervisor()) then
      return;
   end

   if (SuicideKingsListScrollFrame.selected ~= nil) then
      doSuicide(SuicideKingsListScrollFrame.selected);
   end
end

function SuicideKings_Delete()
   if (not checkSupervisor()) then
      return;
   end

   if (l_loadedList ~= nil) then
      SK_confirmDialog(SUICIDEKINGS_MSG_DELETE_CONFIRM, SuicideKings_DoDelete);
   end
end

local function doDeleteList(listName)
   local undoToken = {
      undo = function(this)
                SavedRollLists[this.listName] = this.savedList;
             end,
      listName = listName,
      savedList = SavedRollLists[listName],
      actionName = SK_format(SUICIDEKINGS_FMT_ACTION_DELETE, listName);
   };

   addUndo(undoToken);
   SavedRollLists[listName] = nil;

   if (l_loadedList == listName) then
      l_currentRollList = { };
      l_loadedList = nil;
      SuicideKingsListScrollFrame.selected = nil;
      UIDropDownMenu_SetSelectedID(SuicideKingsFrameDropDown, 0);
      UIDropDownMenu_SetText(SuicideKingsFrameDropDown, "");
   end

   if (l_isCaptureActive ~= 0) then
      SuicideKings_CaptureToggle();
   end

   SuicideKings_Update();
end

function SuicideKings_DoDelete()
   if (not checkSupervisor()) then
      return;
   end

   if (l_loadedList ~= nil) then
      local listName = l_loadedList;

      doDeleteList(l_loadedList);
      SuicideKings_Net_DeleteList(listName);
   end
end

local function getPlayerTable()
   local allPlayers = { };
   local index, playerName;

   allPlayers[UnitName("player")] = "player";
   if (GetNumPartyMembers() > 0) then
      for index=1, 5, 1 do
         playerName = UnitName("party"..index)
         if(playerName) then
            allPlayers[playerName] = "party"..index;
         end
      end
   end
   if (GetNumRaidMembers() > 0) then
      for index=1, 40, 1 do
         playerName = UnitName("raid"..index)
         if(playerName) then
            allPlayers[playerName] = "raid"..index;
         end
      end
   end
   return allPlayers;
end

local function getAllPlayersInGroup()
   local allPlayers = getPlayerTable();
   local ret = { };

   for playerName, _ in pairs(allPlayers) do
      table.insert(ret, playerName);
   end
   return ret;
end

local function getPlayersRolled(rollListName, playerMap)
   local myRollList;

   if(not playerMap) then
      playerMap = { };
   end

   if (rollListName) then
      myRollList = SavedRollLists[rollListName];
      if(not myRollList) then
         return playerMap;
      end
   else
      myRollList = l_currentRollList;
   end

   for _, rollInfo in ipairs(myRollList) do
      if (not playerMap[rollInfo.player]) then
         playerMap[rollInfo.player] = 1;
      else
         playerMap[rollInfo.player] = playerMap[rollInfo.player] + 1;
      end
   end
   return playerMap;
end

function SuicideKings_SpamNotRolled()
   -- Spam to chat players that have not rolled yet.
   local stillNeedRolls = false;
   local alreadyRolled = { };
   local autoLists = { };
   local allPlayers, playerName, listName;

   for idx, listName in ipairs(SUICIDEKINGS_AUTO_LISTS) do
      table.insert(autoLists, SK_prefixizeList(listName));
   end

   if(SuicideKingsOptions.auto) then
      allPlayers = getAllPlayersInGroup();

      for _, listName in ipairs(autoLists) do
         alreadyRolled = getPlayersRolled(listName, alreadyRolled);
      end

      for _, playerName in ipairs(allPlayers) do
         if (not alreadyRolled[playerName]) then
            chat(playerName..SUICIDEKINGS_MSG_ROLL_TWICE);
            stillNeedRolls = true;
         elseif (alreadyRolled[playerName] == 1) then
            chat(playerName..SUICIDEKINGS_MSG_ROLL_ONCE);
            stillNeedRolls = true;
         end
      end
   else
      alreadyRolled = getPlayersRolled();
      allPlayers = getAllPlayersInGroup();
      
      for _, playerName in ipairs(allPlayers) do
         if (not alreadyRolled[playerName]) then
            chat(playerName..SUICIDEKINGS_MSG_STILL_ROLL);
            stillNeedRolls = true;
         end
      end
   end

   if (not stillNeedRolls) then
      SK_print(SUICIDEKINGS_MSG_EVERYONE_ROLLED);
   end
end

function SuicideKings_SpamChat(first, max)
   if (not first or first < 1) then
      first = 1;
   end
   if (not max) then
      if SuicideKingsOptions.spamAll then  -- RPR G1209
         max = 40;
      else
         max = 10;
      end
   end

   local allPlayers = getPlayerTable();
   local index = first;
   local display = { };

   while (index <= #l_currentRollList) do
      if (allPlayers[l_currentRollList[index].player]) then
         table.insert(display, { index=index, player=l_currentRollList[index].player });
      end
      if (#display >= max) then
         break
      end
      index = index + 1;
   end
   
   if(#display < 1) then
      SK_print(SUICIDEKINGS_MSG_NO_NAMES);
      return
   end

   if (first == 1) then
      if (l_loadedList ~= nil) then
         chat(SK_format(SUICIDEKINGS_FMT_TOP_LIST, #display,
                        l_loadedList));
      else
         chat(SK_format(SUICIDEKINGS_FMT_TOP, #display));
      end
   else
      if (l_loadedList ~= nil) then
         chat(SK_format(SUICIDEKINGS_FMT_INDEX_LIST, first, 
                        first+ #display -1, l_loadedList));
      else
         chat(SK_format(SUICIDEKINGS_FMT_INDEX, first,
                        first+ #display - 1));
      end
   end

   local rollInfo;

   for _, rollInfo in ipairs(display) do
      chat(rollInfo.index..": "..rollInfo.player.." ("..UnitClass(allPlayers[rollInfo.player])..")");
   end
   -- RPR G1209
   if SuicideKingsOptions.sendPosition then
      for _, rollInfo in ipairs(display) do
         tellPlayer(rollInfo.player,
                    SUICIDEKINGS_SEND_POSITION_MESSAGE1..rollInfo.index..SUICIDEKINGS_SEND_POSITION_MESSAGE2 ,
                    true);  -- The final "true" keeps it from echoing to you.
      end
   end
end

function SuicideKings_Reserve()
   if (not checkSupervisor()) then
      return;
   end

   if (SuicideKingsListScrollFrame.selected ~= nil) then
      local rollInfo = l_currentRollList[SuicideKingsListScrollFrame.selected];
      
      if (l_reserveList[rollInfo.player]) then
         SK_print(SK_format(SUICIDEKINGS_FMT_UNRESERVE, rollInfo.player));
         l_reserveList[rollInfo.player] = nil;
      else
         SK_print(SK_format(SUICIDEKINGS_FMT_RESERVE, rollInfo.player));
         l_reserveList[rollInfo.player] = true;
      end
      SuicideKings_Update();
      SuicideKings_Net_Reserve(rollInfo.player, l_reserveList[rollInfo.player]);
   end
end

-- necrotic
-- additions for a higher order

-- *** update to SKIP FROZENS?	 ***
local function doMoveImpl(list, idx, places, fromUi)
   if (#list > 1) then
      local thisGuy = list[idx];

      if ((idx + places) >= 1 and (idx + places) <= #list) then
         local undoToken = {
            undo = function(this)
                      table.remove(this.rollList, this.firstIndex);
                      table.insert(this.rollList, this.secondIndex, this.rollInfo);
                      this.rollInfo.insert_bottom = this.wasAtBottom;
                      SuicideKingsListScrollFrame.selected = nil;
                   end,
            rollList = list,
            firstIndex = idx + places,
            secondIndex = idx,
            rollInfo = thisGuy,
            wasAtBottom = thisGuy.insert_bottom
         };
         
         if(places > 0) then
            undoToken.actionName = SUICIDEKINGS_ACTION_MOVE_DOWN;
         else
            undoToken.actionName = SUICIDEKINGS_ACTION_MOVE_UP;
         end
         addUndo(undoToken);
         
         table.remove(list, idx)
         table.insert(list, idx + places, thisGuy)
         
         -- Check whether this guy is being moved above the group
         -- of players marked as newly-inserted at the bottom.  If so,
         -- remove his "bottom" status

         if(#list >= (idx+places+1) and 
            not list[idx+places+1].insert_bottom) then
            -- thisGuy is out of the group of bottom-inserted people.
            thisGuy.insert_bottom = nil;
         elseif ((idx + places) > 1 and list[idx + places - 1].insert_bottom) then
            -- thisGuy is into the group of bottom-inserted people.
            thisGuy.insert_bottom = true;
         end
         
         if(fromUi) then
            SuicideKingsListScrollFrame.selected = idx + places;
         end
         SK_sortRolls(list)
         SuicideKings_Update();
         return idx + places;
      end
   end
end

local function doMove(places)
   if (not checkSupervisor()) then
      return;
   end

   local selected = SuicideKingsListScrollFrame.selected;

   if (SuicideKingsListScrollFrame.selected ~= nil) then
      doMoveImpl(l_currentRollList, SuicideKingsListScrollFrame.selected,
                 places, true);
      SuicideKings_Net_MovePlayer(l_loadedList,
                                  selected, selected + places);
   end
end

function SuicideKings_MoveUp()
   if (not checkSupervisor()) then
      return;
   end

   doMove(-1);
end

function SuicideKings_MoveDown()
   if (not checkSupervisor()) then
      return;
   end
   doMove(1);
end

function SuicideKings_Lookup(lookupName, whisper)	
   local listName, rollList, idx, rollInfo
   local numMatch =0
   for listName, rollList in pairs(SavedRollLists) do
      for idx, rollInfo in ipairs(rollList) do				
         if (string.lower(rollInfo.player) == string.lower(lookupName)) then
            local message = rollInfo.player.." "..idx..": "..listName;
            if(whisper) then
               tellPlayer(rollInfo.player, message, true);
            else
               SK_print(message);
            end
            numMatch=numMatch+1
         end
      end
   end
   if (numMatch==0) then
      if(whisper) then
         tellPlayer(lookupName, SK_format(SUICIDEKINGS_FMT_PLAYER_NOT_FOUND, 
                                          lookupName), true);
      else
         SK_print(SK_format(SUICIDEKINGS_FMT_PLAYER_NOT_FOUND, lookupName));
      end
   end

   if (whisper) then
      SK_print(SK_format(SUICIDEKINGS_FMT_PLAYER_INFORMED, lookupName));
   end
end

function SuicideKings_Options()
   SuicideKingsOptionsFrame:Show();
end

function SuicideKings_SetPrefix(prefix)
   if (string.gsub(prefix, "%s", "") == "") then
      -- All white space means no prefix.
      prefix = nil;
   end
   SuicideKingsOptions.prefix = prefix;
   SuicideKings_Update();
end

function SuicideKings_PrefixFilterToggle(filterOn)
   SuicideKingsOptions.prefix_filter = filterOn;
   SuicideKings_Update();
end

function SuicideKings_UsePrefixToggle(usePrefix)
   SuicideKingsOptions.use_prefix = usePrefix;
end

function SuicideKings_OnMouseDown(arg1)
   if arg1=="LeftButton" then
      this:StartMoving()
   end
end

function SuicideKings_OnMouseUp(arg1)
   if arg1=="LeftButton" then
      this:StopMovingOrSizing();
      SuicideKingsOptions.xpos = SuicideKingsFrame:GetLeft();
      SuicideKingsOptions.ypos = SuicideKingsFrame:GetTop();
   end
end

function SuicideKings_RaidWarnToggle(raidWarn)
   SuicideKingsOptions.raidWarn = raidWarn;
end

-- RPR G1209
function SuicideKings_SendPositionToggle(sendPosition)
   SuicideKingsOptions.sendPosition = sendPosition;
end

-- RPR G1209
function SuicideKings_SpamAllToggle(spamAll)
   SuicideKingsOptions.spamAll = spamAll;
end

-- Network interface

function SuicideKings_NetInterface_NewMaster(player)
   if (l_supervisor and UnitName("player") ~= player) then
      l_supervisor = false;
      if (l_isCaptureActive ~= 0) then
         SuicideKings_CaptureToggle();
      end
      SK_print(player.." is now the SK master.  You are no longer master.");
   end
end

function SuicideKings_NetInterface_FullSync(syncLists, syncKey, reserveList)
   for listName, rollList in pairs(syncLists) do
      SavedRollLists[listName] = rollList;
   end
   SuicideKingsSyncKey = syncKey;
   l_reserveList = reserveList;

   SuicideKingsListScrollFrame.selected = nil;
   SuicideKings_Debug("Full sync received.  New sync key is: "..syncKey);
   if (l_loadedList and SavedRollLists[l_loadedList]) then
      l_currentRollList = SavedRollLists[l_loadedList];
      SuicideKings_Update();
   else
      l_currentRollList = { };
      l_loadedList = nil;
      UIDropDownMenu_SetSelectedID(SuicideKingsFrameDropDown, 0);
      UIDropDownMenu_SetText(SuicideKingsFrameDropDown, "");
      SuicideKings_Update();
   end
   l_undoList = { };
end

function SuicideKings_NetInterface_DeleteList(list)
   doDeleteList(list);
end

function SuicideKings_NetInterface_GetReservedPlayers()
   return l_reserveList;
end

function SuicideKings_NetInterface_InsertPlayer(list, index, player, 
                                                roll, frozen, 
                                                insert_bottom)
   if (not SavedRollLists[list]) then
      SavedRollLists[list] = { };
   end
   local theList = SavedRollLists[list];

   if (#theList < (index - 1)) then
      SuicideKings_Net_RequestSync();
   else
      local undoToken = {
         undo = function(this)
                   table.remove(this.rollList, this.listIndex);
                end,
         rollList = theList,
         rollIndex = index,
         actionName = SK_format(SUICIDEKINGS_FMT_ACTION_ADD, player)
      };
      addUndo(undoToken);

      table.insert(theList, index,
                   {
                      player = player,
                      roll = roll,
                      frozen = frozen,
                      insert_bottom = insert_bottom
                   });
      SuicideKings_Update();
   end
end

function SuicideKings_NetInterface_NewList(list)
   doNewList(list);
end

function SuicideKings_NetInterface_MovePlayer(list, oldIdx, newIdx)
   if (not SavedRollLists[list]) then
      SuicideKings_Net_RequestSync();
   else
      doMoveImpl(SavedRollLists[list], oldIdx, newIdx - oldIdx);
   end
end

function SuicideKings_NetInterface_ReservePlayer(player, reserve)
   if (reserve) then
      l_reserveList[player] = true;
   else
      l_reserveList[player] = nil;
   end
end

function SuicideKings_NetInterface_SuicidePlayer(list, index)
   doSuicide(index, list);
end
 
function SuicideKings_NetInterface_Undo()
   doUndo();
end

function SuicideKings_NetInterface_RemovePlayer(list, index)
   doRemovePlayer(list, index);
end

function SuicideKings_NetInterface_VerboseSuicide(list, movingPlayers)
   if (not SavedRollLists[list]) then
      SuicideKings_Net_RequestSync();
   else
      local theList = SavedRollLists[list];
      local undoToken = { 
         undo = function(this)
                   for idx=1, #this.rollList, 1 do
                      this.rollList[idx] = nil;
                   end
                   for _, rollInfo in ipairs(this.oldList) do
                      table.insert(this.rollList, rollInfo);
                   end
                end,
         rollList = theList,
         oldList = copyRollList(theList),
         actionName = SK_format(SUICIDEKINGS_FMT_ACTION_SUICIDE,
                                theList[movingPlayers[1]].player) };
      
      addUndo(undoToken);

      local theFirst = theList[movingPlayers[1]];

      for idx, playerIndex in ipairs(movingPlayers) do
         if (idx < #movingPlayers) then
            theList[playerIndex] = theList[movingPlayers[idx + 1]];
         else
            theList[playerIndex] = theFirst;
         end
      end
      SK_sortRolls(theList);
      SuicideKings_Update();
   end
end
