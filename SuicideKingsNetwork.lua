-- Functions for communicating over the CT Raid channel

-- Current sync master
local l_currMaster;

-- Queue of outgoing messages
local l_messageQueue = { };

-- Queue of received messages
local l_incomingQueue = { };

-- True if we are to save incoming messages pending a user's decision
-- whether or not to process them
local l_queueIncoming = false; 

-- Time since last message sent.
local l_elapsed = 0.0;

-- True if we are on the network listening
local l_netEnable = false;

local l_updateRunning = false;

-- True if the user has decided not to receive sunc messages for this
-- raid.
local l_syncDialogGiven = false;

-- Number of seconds between messages
-- Should increase this if disconnects are too common.
local l_messageInterval = 0.1;

-- This is the player from which we are currently receiving a full sync.
-- May be different than l_currMaster if we are receiving a "directed"
-- sync via /sk sync <player>
local l_syncGiver;

-- True if the user has accepted the sync that is being transmitted to us.
-- This is automatically set to true for the /sk master; it's only an issue
-- for directed synchs from players that are not master.
local l_syncAccepted = false;

-- Stuff for receiving a full sync
local l_receivingSync = false;
local l_syncLists = { };
local l_syncKey;
local l_syncListName;
local l_syncInProgress = false;
local l_syncReserveList = { };

-- Current sync channel (null if using inter-mod channel)
local l_syncChannel;

-- The saved Sync Key
SuicideKingsSyncKey = nil;

local function print(msg)
   if( DEFAULT_CHAT_FRAME ) then
      DEFAULT_CHAT_FRAME:AddMessage(msg);
   end
end

local function queueMessage(msg, callFunction, recipient)
   -- if toPlayer is nil we use the normal sync channel, else we use
   -- a tell
   local msgInfo = {
      message = msg,
      callAfter = callFunction,
      toPlayer = recipient
   };

   table.insert(l_messageQueue, msgInfo);
   if (not l_updateRunning) then
      -- This starts giving us updates.
      l_elapsed = l_messageInterval; -- Make the first message go out immediately.
      l_updateRunning = true;
      SuicideKingsDummyFrame:Show();
   end
end

local function newSyncKey()
   if (SuicideKingsSyncKey) then
      SuicideKingsSyncKey = SuicideKingsSyncKey + 1;
   else
      SuicideKingsSyncKey = math.random(1, 1000000000);
   end
end

-- Queue a message that will change a clients list(s).  Auto-inserts
-- the sync key as the first argument, then increments it.
local function queueSyncMessage(msg)
   newSyncKey();
   msg = "SyncMessage::"..SuicideKingsSyncKey.."::"..msg;
   queueMessage(msg);
end

local function getNextArg(netStr)
   -- Return the next argument in the arg list, and the rest of the
   -- string to be processed, if any.
   local divider = string.find(netStr, "::");

   if (divider) then
      return string.sub(netStr, 1, divider-1), string.sub(netStr, divider+2);
   end
   return netStr, nil;
end

-- Checks to see if we are in sync with the server.
-- Returns the message if so, requests a sync if not.
local function getSyncMessage(msg)
   local key, rest = getNextArg(msg);

   newSyncKey();
   SuicideKings_Debug("Getting sync message, their key = "..key.." my key = "..tostring(SuicideKingsSyncKey));
   if(tonumber(key) == SuicideKingsSyncKey) then
      return rest;
   end
   -- Request a full sync.
   SuicideKings_Debug("Requesting full sync.");
   queueMessage("SyncChallengeFail");
   return false;
end

local function queueIncomingMessage(player, message)
   if (l_queueIncoming) then
      table.insert(l_incomingQueue, {
                      player = player,
                      msg = message
                   });
      if (#l_incomingQueue > 200) then
         -- Received 200 incoming messages, which means the user
         -- waited for at least 20 seconds before accepting or
         -- cancelling.  Guess what, he doesn't get any messages!
         l_incomingQueue = { };
         l_queueIncoming = false;
      end
   end
end

local function updateChannelFromSettings()
   if (not SuicideKingsOptions.useCustomChannel) then
      if (l_syncChannel) then
         LeaveChannelByName(l_syncChannel);
         SuicideKings_Debug("Left channel "..l_syncChannel);
         l_syncChannel = nil;

         if (l_receivingSync) then
            -- Cancel a sync in progress if any.
            l_receivingSync = false;
            print(SUICIDEKINGS_SYNC_ABORT);
         end
      end
   else
      if (l_syncChannel and l_syncChannel ~= 
          SuicideKingsOptions.syncChannel) then
         SuicideKings_Debug("Left channel "..l_syncChannel);
         LeaveChannelByName(l_syncChannel);
      end

      local id = GetChannelName(SuicideKingsOptions.syncChannel);

      if (id == 0) then
         JoinChannelByName(SuicideKingsOptions.syncChannel, nil,
                           DEFAULT_CHAT_FRAME:GetID());
         id = GetChannelName(SuicideKingsOptions.syncChannel);
         if (id == 0) then
            print(SK_format(SUICIDEKINGS_FMT_CANNOT_JOIN_CHANNEL,
                            SuicideKingsOptions.syncChannel));
            l_syncChannel = nil;
         else
            l_syncChannel = SuicideKingsOptions.syncChannel;
            SuicideKings_Debug("Joined channel: "..SuicideKingsOptions.syncChannel.." id = "..id);
            if (l_receivingSync) then
               -- Cancel a sync in progress if any.
               l_receivingSync = false;
               print(SUICIDEKINGS_SYNC_ABORT);
            end
         end
      else
         SuicideKings_Debug("Already in channel: "..
                            SuicideKingsOptions.syncChannel.." id = "..id);
      end
   end
end

function SuicideKings_Net_SendMessage(Message)
   local channelnumber;

   if SuicideKingsOptions.useCustomChannel then
      channelnumber = GetChannelName(SuicideKingsOptions.syncChannel);
      if (channelnumber and channelnumber > 0) then
         SendChatMessage("<<<SuicideKings>>> " .. Message, "CHANNEL", nil, channelnumber);
         SuicideKings_Debug("Command sent via chat: "..Message);
         return true
      end
   else
      if (GetNumRaidMembers() > 0) then
         SendAddonMessage(SUICIDEKINGS_CHANNEL_PREFIX, Message, "RAID" );
      else
         SendAddonMessage(SUICIDEKINGS_CHANNEL_PREFIX, Message, "PARTY" );
      end
      SuicideKings_Debug("Command sent via addon: "..Message);
   end   
end

function SuicideKings_IsPlayerInGroup(PlayerName)

   if GetNumRaidMembers() > 0 then
      for x = 1, 40 do
         if UnitName("raid" .. x) == PlayerName then
            return true
         end
      end
      
   elseif GetNumPartyMembers() > 0 then
      for x = 1, 4 do
         if UnitName("party" .. x) == PlayerName then
            return true
         end
      end
      
      if PlayerName == UnitName("player") then
         return true
      end
   end
   
   if PlayerName == UnitName("player") then
      return true
   end

end

function SuicideKings_Net_OnEvent()   
   if string.sub(arg1, 1, 19) ~= "<<<SuicideKings>>> " then
      return -- not a SuicideKings message
   end

   -- to get here, it's fine
   SuicideKings_Net_MessageIn(arg2, string.sub(arg1, 20));
end

function SuicideKings_Net_OnUpdate(dt)
   if (#l_messageQueue > 0) then
      l_elapsed = l_elapsed + dt;
      if (l_elapsed >= l_messageInterval) then
         l_elapsed = 0.0;

         if (l_messageQueue[1].toPlayer) then
            SendChatMessage("<<<SuicideKings>>> "..l_messageQueue[1].message, "WHISPER", nil, 
                            l_messageQueue[1].toPlayer);
         else
            SuicideKings_Net_SendMessage(l_messageQueue[1].message);
         end

         if (l_messageQueue[1].callAfter) then
            l_messageQueue[1].callAfter();
         end
         table.remove(l_messageQueue, 1);
      end
   else
      -- Shut off updates to save CPU
      SuicideKings_Debug("Update off");
      SuicideKingsDummyFrame:Hide();
      l_updateRunning = false;
   end
end

function SuicideKings_Net_MessageIn(player, msg)
   if (UnitName("player") == player) then
      return -- Disregard messages from ourself.
   end
   
   if (not l_netEnable and not l_syncDialogGiven) then
      l_syncDialogGiven = true;

      -- Tell the net layer to save incoming messages and use them
      -- if the user chooses that he wants to listen for them.
      l_incomingQueue = { };
      l_queueIncoming = true;

      SK_confirmDialog(SK_format(SUICIDEKINGS_MSG_NEW_RAID, player), 
                       SuicideKings_Net_Enable, true);

      -- Prevents double dialog by assuming this guy is the master
      l_currMaster = player;
   end

   if (not l_netEnable) then
      queueIncomingMessage(player, msg);
      return
   end

   local command, rest = getNextArg(msg);

   SuicideKings_Debug("Net message: "..msg.." Command extracted: '"..command.."'");
   if (command == "NewMaster") then
      local player = getNextArg(rest);

      SuicideKings_NetInterface_NewMaster(player);
      if (player ~= l_currMaster) then
         SuicideKings_Debug("Master changed, resetting sync machine.");
         SuicideKings_Net_Enable(false);
         l_syncDialogGiven = false;
         l_currMaster = player;
      end
   elseif (command == "SyncChallengeFail" and
           SuicideKings_AmITheMaster()) then
      SuicideKings_Net_StartFullSync();
   elseif (command == "FullSyncBegin") then
      local syncKey = getNextArg(rest);

      if (player ~= l_currMaster) then
         -- Must be a directed sync from someone who's not the boss
         -- of us.  Make sure we want to receive this sync.
         l_syncAccepted = false;
         SK_confirmDialog(SK_format(SUICIDEKINGS_FMT_ACCEPT_SYNC,
                                    player),
                          SuicideKings_Net_AcceptSync,
                          player);
      else
         print("Receiving full sync from "..player);
         l_syncAccepted = true;
      end
          
      l_syncGiver = player;
      l_syncKey = tonumber(syncKey);
      l_syncLists = { };
      l_syncListName = nil;
      l_syncReserveList = { };
      l_receivingSync = true;
   elseif (command == "FullSyncList" and
           player == l_syncGiver and
           not SuicideKings_AmITheMaster()) then
      local listName = getNextArg(rest);

      l_syncListName = listName;
      l_syncLists[listName] = { };
   elseif (command == "FullSync" and
           player == l_syncGiver and
           not SuicideKings_AmITheMaster()) then
      local player, roll, frozen, insert_bottom;

      player, rest = getNextArg(rest);
      roll, rest = getNextArg(rest);
      frozen, rest = getNextArg(rest);
      insert_bottom, rest = getNextArg(rest);
      
      if (insert_bottom == "true") then
         insert_bottom = true;
      else
         insert_bottom = false;
      end
      if (frozen == "true" or frozen == "1") then
         frozen = 1;
      else
         frozen = 0;
      end
      table.insert(l_syncLists[l_syncListName],
                   {
                      player = player,
                      frozen = frozen,
                      insert_bottom = insert_bottom,
                      roll = tonumber(roll)
                   });
      SuicideKings_Debug("Received sync for player "..player.." in list "..l_syncListName);
   elseif (command == "FullSyncReserve" and
           player == l_syncGiver) then
      local player = getNextArg(rest);
      
      l_syncReserveList[player] = true;
   elseif (command == "FullSyncEnd" and
           player == l_syncGiver and
              l_receivingSync) then
      if (l_syncAccepted) then
         print(SK_format(SUICIDEKINGS_FMT_SYNC_RECEIVED, player));
         SuicideKings_NetInterface_FullSync(l_syncLists, l_syncKey, l_syncReserveList);
      end
      l_receivingSync = false;
   elseif (command == "SyncMessage" and
           player == l_currMaster) then
      command = getSyncMessage(rest);

      SuicideKings_Debug("Got sync command: "..tostring(command));
      if (command) then
         command, rest = getNextArg(command);

         if (command == "RemovePlayer") then    
            local index, list;

            list, rest = getNextArg(rest);
            index = tonumber(getNextArg(rest));
            SuicideKings_NetInterface_RemovePlayer(list, index);
         elseif (command == "DeleteList") then
            local list = getNextArg(rest);

            SuicideKings_NetInterface_DeleteList(list);
         elseif (command == "InsertPlayer") then
            local list, index, player, roll, frozen, insert_bottom;

            list, rest = getNextArg(rest);
            index, rest = getNextArg(rest);
            player, rest = getNextArg(rest);
            roll, rest = getNextArg(rest);
            frozen, rest = getNextArg(rest);
            insert_bottom = getNextArg(rest);

            index = tonumber(index);
            roll = tonumber(roll);
            if (frozen == "true" or frozen == "1") then
               frozen = 1;
            else
               frozen = 0;
            end
            if (insert_bottom == "true") then
               insert_bottom = true;
            else
               insert_bottom = false;
            end
            SuicideKings_NetInterface_InsertPlayer(list, index, player, 
                                                   roll, frozen, 
                                                   insert_bottom);
         elseif (command == "NewList") then
            local list = getNextArg(rest);

            SuicideKings_NetInterface_NewList(list);
         elseif (command == "MovePlayer") then
            local list, oldIdx, newIdx, insert_bottom;

            list, rest = getNextArg(rest);
            oldIdx, rest = getNextArg(rest);
            newIdx = getNextArg(rest);

            oldIdx = tonumber(oldIdx);
            newIdx = tonumber(newIdx);

            SuicideKings_NetInterface_MovePlayer(list, oldIdx, newIdx);
         elseif (command == "ReservePlayer") then
            local player, reserve;

            player, rest = getNextArg(rest);
            reserve = getNextArg(rest);

            if (reserve == "true") then
               reserve = true;
            else
               reserve = false;
            end
            SuicideKings_NetInterface_ReservePlayer(player);
         elseif (command == "SuicidePlayer" and
                 SuicideKings_IsPlayerInGroup(player)) then
            local list, index;

            list, rest = getNextArg(rest);
            index = getNextArg(rest);
            index = tonumber(index);
            SuicideKings_NetInterface_SuicidePlayer(list, index);
         elseif (command == "VerboseSuicide" and
                 not SuicideKings_IsPlayerInGroup(player)) then
            local list, index;
            local movingPlayers = { };

            list, rest = getNextArg(rest);
            while rest do
               index, rest = getNextArg(rest);
               table.insert(movingPlayers, tonumber(index));
            end
            SuicideKings_NetInterface_VerboseSuicide(list, movingPlayers);
         elseif (command == "Undo") then
            SuicideKings_NetInterface_Undo();
         end
      end
   end
end

function SuicideKings_Net_IAmTheMaster(player)
   queueMessage("NewMaster::"..player);
   l_currMaster = player;
end

function SuicideKings_Net_IAmNotTheMaster(player)
   queueMessage("UnMaster::"..player);
   if (l_currMaster == player) then
      l_currMaster = nil;
   end
end

function SuicideKings_Net_DeleteList(listName)
   queueSyncMessage("DeleteList::"..listName);
end

function SuicideKings_Net_ChallengeForSync()
   if (SuicideKings_AmITheMaster() and
       not l_syncInProgress) then
      queueMessage("SyncChallenge::"..SuicideKingsSyncKey);
   end
end

function SuicideKings_Net_StartFullSync(player, listFilter)
   if (l_syncInProgress) then
      SuicideKings_Debug("Not syncing, in progress.");
      if (player) then
         print(SUICIDEKINGS_MSG_SYNC_IN_PROGRESS);
      end
      return false;
   end

   local listsToSend = { };

   -- Transform the list for O(1) lookup
   if (listFilter) then
      for _, listName in ipairs(listFilter) do
         listsToSend[string.lower(listName)] = true;
      end
   else
      listsToSend = nil;
   end

   l_syncInProgress = true;
   print("Sending out full sync...");

   if (not SuicideKingsSyncKey) then
      newSyncKey();
   end

   queueMessage("FullSyncBegin::"..SuicideKingsSyncKey, nil, player);

   for listName, skList in pairs(SavedRollLists) do
      if (not listsToSend or
          listsToSend[string.lower(listName)]) then
         queueMessage("FullSyncList::"..listName, nil, player);
         for _, rollInfo in ipairs(skList) do
            local msg = "FullSync::"..rollInfo.player.."::"..rollInfo.roll.."::"..tostring(rollInfo.frozen).."::";
            
            if (rollInfo.insert_bottom) then
               msg = msg.."true";
            else
               msg = msg.."false";
            end
            queueMessage(msg, nil, player);
         end
      end
   end

   for player, reserve in pairs(SuicideKings_NetInterface_GetReservedPlayers()) do
      if (reserve) then
         queueMessage("FullSyncReserve::"..player, nil, player);
      end
   end

   queueMessage("FullSyncEnd", SuicideKings_Net_SyncDone, player);
   return true;
end

function SuicideKings_Net_SyncDone()
   l_syncInProgress = false;
   print("Full sync sent.");
end

function SuicideKings_Net_RequestSync()
   queueMessage("SyncChallengeFail");
end 

function SuicideKings_Net_InsertPlayer(listName, index, rollInfo)
   local insert_bottom = "true";

   if (not rollInfo.insert_bottom) then
      insert_bottom = "false";
   end
   
   -- Fix up for a bug that was corrupting lists from the network layer
   if (not rollInfo.frozen or rollInfo.frozen == 0) then
      rollInfo.frozen = 0;
   else
      rollInfo.frozen = 1;
   end

   queueSyncMessage("InsertPlayer::"..listName.."::"..index.."::"..rollInfo.player.."::"..rollInfo.roll.."::"..rollInfo.frozen.."::"..insert_bottom);
end

function SuicideKings_Net_NewList(listName)
   queueSyncMessage("NewList::"..listName);
end

function SuicideKings_Net_MovePlayer(listName, oldIdx, newIdx)
   queueSyncMessage("MovePlayer::"..listName.."::"..oldIdx.."::"..newIdx);
end

function SuicideKings_Net_Reserve(player, reserve)
   if (reserve) then
      queueSyncMessage("ReservePlayer::"..player.."::true");
   else
      queueSyncMessage("ReservePlayer::"..player.."::false");
   end
end

function SuicideKings_Net_RemovePlayer(listName, index)
   queueSyncMessage("RemovePlayer::"..listName.."::"..index);
end

function SuicideKings_Net_Suicide(listName, suicideIndex)
   queueSyncMessage("SuicidePlayer::"..listName.."::"..suicideIndex);
end

function SuicideKings_Net_Undo()
   queueSyncMessage("Undo");
end

function SuicideKings_Net_Enable(enable)
   SuicideKings_Debug("Setting net enable to: "..tostring(enable));
   l_netEnable = enable;

   if (enable) then
      for _, msgInfo in ipairs(l_incomingQueue) do
         SuicideKings_Net_MessageIn(msgInfo.player, msgInfo.msg);
      end
      l_incomingQueue = { };
      l_queueIncoming = false;
   end
end

function SuicideKings_Net_IsEnabled()
   return l_netEnable;
end

function SuicideKings_Net_NotInRaid()
   SuicideKings_Net_Enable(false);
   l_syncDialogGiven = false;
   SuicideKings_Debug("No longer in a raid, net layer notified.");
end

function SuicideKings_Net_UseCustomToggle(checked)
   SuicideKingsOptions.useCustomChannel = checked;
   SuicideKingsOptions.syncChannel = SuicideKingsChannelEditBox:GetText();
   updateChannelFromSettings();
end

function SuicideKings_Net_SetChannel(channelName)
   SuicideKingsOptions.syncChannel = channelName;
   updateChannelFromSettings();
end

function SuicideKings_Net_VariablesLoaded()
   updateChannelFromSettings();
   
end

function SuicideKings_Net_VerboseSuicide(listName, movingPlayers)
   local msg = "VerboseSuicide::"..listName;
   
   for _, playerIndex in ipairs(movingPlayers) do
      msg = msg.."::"..playerIndex;
   end
   queueSyncMessage(msg);
end 

function SuicideKings_Net_AcceptSync(player)
   if (l_syncGiver ~= player) then
      print(SK_format(SUICIDEKINGS_FMT_ERROR_NOSYNC, player));
      return
   end

   if (l_receivingSync) then
      l_syncAccepted = true;
   else
      -- We waited a while, and the sync is already done, so use the data
      -- we have queued up.
      print(SK_format(SUICIDEKINGS_FMT_SYNC_RECEIVED, player));
      SuicideKings_NetInterface_FullSync(l_syncLists, l_syncKey, l_syncReserveList);
   end
end