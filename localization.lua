if ( GetLocale() == "deDE" ) then
   -- TODO: translate
   SUICIDEKINGS_SEND_POSITION_LABEL = "Send tells with position spam"
   SUICIDEKINGS_SEND_POSITION_MESSAGE1 = "Your position is "
   SUICIDEKINGS_SEND_POSITION_MESSAGE2 = "."
   SUICIDEKINGS_SPAM_ALL_LABEL = "Spam entire list"
   SUICIDEKINGS_ALREADY_MASTER = "You are already the loot master."
   SUICIDEKINGS_WAITING_FOR_MASTER = "Still waiting for confirmation of master request.  Please wait."
   SUICIDEKINGS_USE_RAID_LABEL = "Raid/Party";
   SUICIDEKINGS_USE_GUILD_LABEL = "Guild";

   -- Already translated
   SUICIDEKINGS_SUICIDE_LABEL="Suicide!"
   SUICIDEKINGS_INSERT_LABEL="Einfg"
   SUICIDEKINGS_DELETE_LABEL="L\195\182schen"
   SUICIDEKINGS_UNDO_LABEL="R\195\188ckg"
   SUICIDEKINGS_ACTIVE_LABEL="Aktiv"
   SUICIDEKINGS_INACTIVE_LABEL="Inaktiv"
   SUICIDEKINGS_SAVE_LABEL="Speichern"
   SUICIDEKINGS_ROLL_PATTERN = "(.+) w\195\188rfelt. Ergebnis: (%d+) %((%d+)%-(%d+)%)";
   SUICIDEKINGS_TITLE = "Suicide Kings v%s"
   SUICIDEKINGS_NEW_LABEL = "Neu"
   SUICIDEKINGS_REMOVE_LABEL = "Entf"
   SUICIDEKINGS_SPAM_LABEL="Spam"
   SUICIDEKINGS_MANUAL_LABEL="Manuell"
   SUICIDEKINGS_MSG_ROLL_TWICE=" muss noch 2-mal w\195\188rfeln.";
   SUICIDEKINGS_MSG_ROLL_ONCE=" muss noch einmal w\195\188rfeln.";
   SUICIDEKINGS_MSG_STILL_ROLL=" muss noch w\195\188rfeln.";
   SUICIDEKINGS_FMT_NO_AUTO_ADD="Spieler: <1> kann zu keiner Liste automatisch hinzugef\195\188gt werden.";

   SUICIDEKINGS_MSG_DELETE_CONFIRM="M\195\182chtst Du wirklich diese Liste l\195\182schen?";
   SUICIDEKINGS_MSG_SAVE="Trage einen Namen ein, um diese Liste zu speichern.";
   SUICIDEKINGS_FMT_ADD="F\195\188gt <1> zu der <2> Liste hinzu.";
   SUICIDEKINGS_MSG_IGNORE_SYNC="Ignoriert SuicideKings Synchronisation von einer \195\164lteren Mod Version.";
   SUICIDEKINGS_FMT_ACCEPT_SYNC="Synchronisation von <1> akzeptieren?";
   SUICIDEKINGS_MSG_NEED_CHRONOS="Du musst den Timex oder Chronos Mod installieren, um eine Synchronisierung durchzuf\195\188hren.";
   SUICIDEKINGS_MSG_NO_SUICIDE_FROZEN="Du kannst an einem eingefrorenen Spieler kein Suicide ausf\195\188hren!";
   SUICIDEKINGS_MSG_CAPTURE_ACTIVE="W\195\188rfel Aufzeichnung aktiviert.";
   SUICIDEKINGS_MSG_EVERYONE_ROLLED="Jeder hat gew\195\188rfelt.";
   SUICIDEKINGS_MSG_NO_NAMES="Keine Namen zum Anzeigen vorhanden.";
   SUICIDEKINGS_FMT_TOP_LIST="Top <1> Spieler in der <2> Liste sind:";
   SUICIDEKINGS_FMT_TOP="Top <1> Spieler sind:";
   SUICIDEKINGS_FMT_INDEX_LIST="Spieler <1>-<2> in der <3> Liste sind:";
   SUICIDEKINGS_FMT_INDEX="Spieler <1>-<2> sind:";
   SUICIDEKINGS_MSG_SYNC_IN_PROGRESS="Eine Synchronisation wird schon durchgef\195\188hrt.";
   SUICIDEKINGS_MSG_SYNC_START="Starte Synchronisation...";
   SUICIDEKINGS_MSG_SYNC_DONE="Synchronisation fertig gestellt.";
   SUICIDEKINGS_SPAM_CMD_PATTERN1 = "spam (%d+) (%d+)"
   SUICIDEKINGS_SPAM_CMD_PATTERN2 = "spam (%d+)"
   SUICIDEKINGS_SPAM_CMD = "spam"
   SUICIDEKINGS_NOROLL_CMD = "noroll"
   SUICIDEKINGS_HELP_CMD = "help"
   SUICIDEKINGS_SYNC_CMD = "sync";
   SUICIDEKINGS_CLOSE_CMD = "close";
   SUICIDEKINGS_MASTER_CMD = "master";
   SUICIDEKINGS_INSERT_CMD_PATTERN = "insert ([^%s]+) ([^%s]+) (%d+)";
   SUICIDEKINGS_INSERT_CMD_PATTERN2 = "insert (.+)";
   SUICIDEKINGS_LIST_CMD_PATTERN = "list (.+)";

   SUICIDEKINGS_NEW_INSERT = "Neu";
   SUICIDEKINGS_FMT_ERROR_NOSYNC = "Fehler: Kann Sync von <1> nicht akzeptieren, da ein ein anderer Sync gestartet wurde.";
   SUICIDEKINGS_FMT_SYNC_RECEIVED = "Kompletter Sync von <1> erhalten.";
   SUICIDEKINGS_MSG_NO_LEADER = "Du bist nicht mehr der SK Master.";
   SUICIDEKINGS_USE_CUSTOM_LABEL = "Benutze den custom chat channel";
   SUICIDEKINGS_FMT_LIST_NOT_FOUND = "Liste '<1>' nicht gefunden. Auf Gross-/Kleinschreibung achten!";
   SUICIDEKINGS_NEW_MASTER = "Du bist jetzt der SK Master.";
   SUICIDEKINGS_OFFICER_NEEDED = "Du musst Leader oder Assistent sein, um das zu tun.";
   SUICIDEKINGS_LIST_NEEDED = "Du musst eine Suicide Kings Liste ausw\195\164hlen, um das zu tun.";
   SUICIDEKINGS_MASTER_NEEDED = "Du musst der SK Master sein, um das zu tun (/sk master).";
   SUICIDEKINGS_FMT_LIST_SELECTED = "<1> Liste ausgew\195\164hlt.";
   SUICIDEKINGS_MSG_TOO_MANY_LISTS = "Es k\195\182nnen nicht alle Listen im Drop Down angezeigt werden. Benutze das 'filter by list prefix'-Feature oder den /sk list Befehl, um eine Liste auszuw\195\164hlen."
   SUICIDEKINGS_MSG_RAID_REQUIRED = "Dazu musst Du in einer Gruppe sein.";
   SUICIDEKINGS_RAID_WARN_TEXT = "Gebotannahme f\195\188r: <1>";
   SUICIDEKINGS_RAID_WARN_LABEL = "Benutze Raidwarnung bei Geboter\195\182ffnung";
   SUICIDEKINGS_SYNC_ABORT = "Kompletter Sync abgebrochen, da der Sync-Channel ge\195\164ndert wurde.";
   SUICIDEKINGS_CHANNEL_LABEL = "Sync Channel";
   SUICIDEKINGS_FMT_PLAYER_INFORMED = "<1> wurde \195\188ber ihre/seine Position in der Liste informiert.";
   SUICIDEKINGS_FMT_CANNOT_JOIN_CHANNEL = "Konnte Channel '<1>' nicht finden. M\195\182glicherweise falscher Channel Name. Dieser darf keine Leerzeichen enthalten.";
   SUICIDEKINGS_MSG_BID_ALL_RETRACT = "Alle Gebote wurden zur\195\188ckgezogen und es gibt keinen H\195\182chstbieter."
   SUICIDEKINGS_MSG_BID_NO_RETRACT = "Du hast nicht geboten und kannst nicht zur\195\188ckziehen.";
   SUICIDEKINGS_MSG_BID_RETRACT = "Dein Gebot wurde zur\195\188ckgezogen.";
   SUICIDEKINGS_MSG_NEW_RAID = "SuicideKings Sync Message von <1> erhalten. Akzeptieren?";
   SUICIDEKINGS_MSG_NOTOPEN = "Im Moment werden keine Items versteigert.";
   SUICIDEKINGS_MSG_NOT_MASTER = "SK: Wenn Du Gebote erhalten willst, musst Du der SK Master sein (/sk master)";
   SUICIDEKINGS_MSG_BID_CLOSED = "Auktion ist beendet.";
   SUICIDEKINGS_MSG_NO_BIDDERS = "Keine Bieter. Item kann entzaubert werden.";
   SUICIDEKINGS_FMT_WINNER = "Der Gewinner ist <1>. GRATZ!!!";
   SUICIDEKINGS_MSG_BID_OPEN = "Auktion ist bereits er\195\182ffnet.";
   SUICIDEKINGS_FMT_BID_NOW_OPEN = "Gebotannahme f\195\188r <1>. Fl\195\188stere mir 'BID', wenn Du das Item haben m\195\182chtest, 'RETRACT', um Dein Gebot zur\195\188ckzuziehen, 'SUICIDE', um Deine Position zu erfahren."
   SUICIDEKINGS_MSG_ALREADY_BIDDER = "Du bist bereits H\195\182chstbieter.";
   SUICIDEKINGS_MSG_NO_LIST_SELECTED = "Der SK Master hat keine Liste ausgew\195\164hlt und kann keine Gebote annehmen.";
   SUICIDEKINGS_FMT_NOT_HIGH_BIDDER = "<1> ist der H\195\182chstbieter. Du stehst weiter unten in der Liste und kannst sie/ihn nicht \195\188berbieten.";
   SUICIDEKINGS_FMT_NEW_HIGH_BIDDER = "<1> ist der neue H\195\182chstbieter auf Position <2>";
   SUICIDEKINGS_MSG_NOT_ON_LIST = "Du bist nicht auf der Liste, die der SK Master ausgew\195\164hlt hat und kannst nicht mitbieten.";
   SUICIDEKINGS_USE_PREFIX_LABEL="Benutze auto-list prefix";
   SUICIDEKINGS_CLOSE_LABEL="Schlie\195\159en";
   SUICIDEKINGS_AUTO_LABEL="Auto-list mode";
   SUICIDEKINGS_PREFIX_LABEL="Auto-list prefix";
   SUICIDEKINGS_PREFIX_FILTER_LABEL="Filter lists by prefix";
   SUICIDEKINGS_OPTIONS_LABEL="Optionen";
   SUICIDEKINGS_NO_UNDO="Keine Aktionen vorhanden, die R\195\188ckg\195\164ngig gemacht werden k\195\182nnen.";
   SUICIDEKINGS_UNDID_ACTION="R\195\188ckg\195\164ngig: ";
   SUICIDEKINGS_ACTION_REMOVE="Entferne Spieler aus Liste";
   SUICIDEKINGS_FMT_ACTION_SUICIDE="Suicide Spieler <1>";
   SUICIDEKINGS_ACTION_NEW="Neue Liste erstellen";
   SUICIDEKINGS_FMT_ACTION_DELETE="L\195\182sche Liste <1>";
   SUICIDEKINGS_FMT_ACTION_SAVE="Gespeicherte Liste <1>";
   SUICIDEKINGS_FMT_ACTION_ADD="<1> zur Liste hinzuf\195\188gen";
   SUICIDEKINGS_SUICIDE="Spieler <1> wurde suicided!";
   SUICIDEKINGS_ACTION_MOVE_DOWN="Spieler nach unten schieben";
   SUICIDEKINGS_ACTION_MOVE_UP="Spieler nach oben schieben";
   SUICIDEKINGS_FMT_UNRESERVE="Spieler <1> wurde eingefroren.";
   SUICIDEKINGS_FMT_RESERVE="Spieler <1> wurde aktiviert.";
   SUICIDEKINGS_RESERVE_LABEL="Reserve";
   SUICIDEKINGS_SEARCH_CMD = "find (.+)";
   SUICIDEKINGS_SUICIDE_CMD_PATTERN = "suicide (.+)";
   SUICIDEKINGS_FMT_PLAYER_NOT_FOUND = "Konnte Spieler <1> nicht finden.";
   SUICIDEKINGS_AUTO_LISTS = { "Raid", "Mage", "Druid", "Paladin", "Warrior", "Rogue", "Hunter", "Warlock", "Priest", "Shaman" };
   SUICIDEKINGS_FMT_TIE="Inserting <1> resulted in a <2>-way tie.  Tie breaker roll places <1> at position <3> in the list.";
   SUICIDEKINGS_MSG_CURRENT_LIST="Aktuelle Liste";
   SUICIDEKINGS_LOADED_MSG="SuicideKings v%s loaded by The Black Company, Whisperwind";
   SUICIDEKINGS_HELP="SuicideKings Loot mod by The Black Company, Whisperwind\
/sk spam    Spam die Top Spieler der momentanen Liste\
/sk spam <first> <max>    Spam die Spieler von <first>, <max> Zahl\
/sk noroll    Spam die Spieler die noch w\195\188rfeln m\195\188ssen.\
/sk sync    Synchronisiert deine W\195\188rfel Liste.\
/sk sync <player>    Schickt einen Sync deiner Listen zu <player>.\
/sk sync <player> <list1> [list2 ...]    Schickt einen Sync deiner angegebenen Liste zum angegebenen Spieler.\
/sk insert <player> <roll>    F\195\188gt den Spieler mit dem entsprechenden Wurf der Liste hinzu.\
/sk insert <player>     F\195\188gt den Spieler ans Ende der Liste hinzu.\
/sk search <player>     Gibt die Position von <player> in der aktuellen Liste bekannt.\
/sk find <player>    Finde <player> in aktuellen Liste.\
/sk close     Schlie\195\159t die Gebotsrunde f\195\188r ein Item.\
/sk master    Sich selbst als SK Master f\195\188r den Raid ernennen.\
/sk suicide <player>   <player> manuell suiciden.\
/sk list <list>    <list> im Fenster anzeigen, just like selecting from the drop down.\
/sk help    Diese Mitteilung.";
elseif (GetLocale() == "frFR") then

   -- TODO: Needs translation
   SUICIDEKINGS_USE_RAID_LABEL = "Raid/Party";
   SUICIDEKINGS_USE_GUILD_LABEL = "Guild";
   SUICIDEKINGS_ALREADY_MASTER = "You are already the loot master."
   SUICIDEKINGS_WAITING_FOR_MASTER = "Still waiting for confirmation of master request.  Please wait."

   -- LABEL
   
   SUICIDEKINGS_SUICIDE_LABEL="Suicider !"
   SUICIDEKINGS_FREEZE_LABEL="Bloquer"
   SUICIDEKINGS_INSERT_LABEL="Ins\195\169rer"
   SUICIDEKINGS_DELETE_LABEL="Supprimer"
   SUICIDEKINGS_UNDO_LABEL="Annuler"
   SUICIDEKINGS_ACTIVE_LABEL="Actif"
   SUICIDEKINGS_INACTIVE_LABEL="Inactif"
   SUICIDEKINGS_SAVE_LABEL="Sauver"
   SUICIDEKINGS_ROLL_PATTERN = "(.+) obtient un (%d+) %((%d+)%-(%d+)%)"
   SUICIDEKINGS_TITLE = "Suicide Kings v%s"
   SUICIDEKINGS_NEW_LABEL = "Nouveau"
   SUICIDEKINGS_REMOVE_LABEL = "Enlever"
   SUICIDEKINGS_SPAM_LABEL="Lister"
   SUICIDEKINGS_AUTO_LABEL="Auto"
   SUICIDEKINGS_MANUAL_LABEL="Manuelle"
   SUICIDEKINGS_SEND_POSITION_LABEL = "Affiche les positions"; -- "Send tells with position spam";
   SUICIDEKINGS_SPAM_ALL_LABEL = "Affiche la liste enti\195\168re"; -- "Spam entire list";
   SUICIDEKINGS_USE_CUSTOM_LABEL = "Utiliser le canal personnalis\195\169"; -- "Use custom chat channel";
   
   -- COMMANDES
   
   SUICIDEKINGS_SPAM_CMD_PATTERN1 = "lister (%d+) (%d+)";
   SUICIDEKINGS_SPAM_CMD_PATTERN2 = "lister (%d+)";
   SUICIDEKINGS_CLOSE_CMD = "fermer";
   SUICIDEKINGS_SPAM_CMD = "lister";
   SUICIDEKINGS_NOROLL_CMD = "nonlistes";
   SUICIDEKINGS_HELP_CMD = "aide";
   SUICIDEKINGS_SYNC_CMD = "sync";
   SUICIDEKINGS_MASTER_CMD = "maitre";
   SUICIDEKINGS_INSERT_CMD_PATTERN = "inserer ([^%s]+) (%d+)";
   SUICIDEKINGS_INSERT_CMD_PATTERN2 = "inserer (.+)";
   SUICIDEKINGS_SEARCH_CMD = "Chercher (.+)";
   SUICIDEKINGS_SUICIDE_CMD_PATTERN = "suicider (.+)";
   SUICIDEKINGS_LIST_CMD_PATTERN = "liste (.+)"; -- "list (.+)";
   
   -- MESSAGES
   
   SUICIDEKINGS_LOADED_MSG="SuicideKings v%s loaded by The Black Company, Whisperwind";
   SUICIDEKINGS_MSG_ROLL_TWICE=" doit encore \195\170tre ajout\195\169(e) aux listes de Raid et de Classe.";
   SUICIDEKINGS_MSG_ROLL_ONCE=" doit encore \195\170tre ajout\195\169(e) \195\160 la liste de Classe.";
   SUICIDEKINGS_MSG_STILL_ROLL=" doit encore \195\170tre ajout\195\169(e) \195\160 la liste.";
   SUICIDEKINGS_MSG_FROZEN=" n'est pas pr\195\169sent(e) et va \195\170tre bloqu\195\169(e).";
   SUICIDEKINGS_FMT_NO_AUTO_ADD="Joueur: <1> ne peut pas \195\170tre ajout\195\169(e) automatiquement aux listes.";
   SUICIDEKINGS_FMT_ADD="Ajout de <1> \195\160 la liste <2>.";
   SUICIDEKINGS_MSG_DELETE_CONFIRM="Voulez vous vraiment supprimer cette liste ?";
   SUICIDEKINGS_MSG_SAVE="Entrez un nom pour sauvegarder cette liste.";
   SUICIDEKINGS_MSG_IGNORE_SYNC="La synchronisation en provenance d'anciennes versions du mod est ignor\195\169e.";
   SUICIDEKINGS_FMT_ACCEPT_SYNC="Acceptez vous la synchronisation venant de <1> ?";
   SUICIDEKINGS_MSG_NEED_CHRONOS="Vous devez installer le mod Timex ou Chronos pour effectuer une synchronisation.";
   SUICIDEKINGS_MSG_SYNC_IN_PROGRESS="Une synchronisation est d\195\169j\195\160 en cours.";
   SUICIDEKINGS_MSG_SYNC_START="D\195\169but de la synchronisation...";
   SUICIDEKINGS_MSG_SYNC_DONE="Synchronisation termin\195\169e.";
   SUICIDEKINGS_MSG_NO_SUICIDE_FROZEN="On ne peut pas suicider un joueur absent !";
   SUICIDEKINGS_MSG_CAPTURE_ACTIVE="La capture des jets de d\195\169s est activ\195\169e.";
   SUICIDEKINGS_MSG_EVERYONE_ROLLED="Tout le monde a jet\195\169 les d\195\169s.";
   SUICIDEKINGS_MSG_NO_NAMES="Pas de nom \195\160 afficher.";
   SUICIDEKINGS_FMT_TOP_LIST="Le top <1> joueurs dans la liste <2> sont :";
   SUICIDEKINGS_FMT_TOP="Le top <1> joueurs sont :";
   SUICIDEKINGS_FMT_INDEX_LIST="Joueurs <1>-<2> dans la liste <3> sont :";
   SUICIDEKINGS_FMT_INDEX="Joueurs <1>-<2> sont :";
   SUICIDEKINGS_NO_UNDO="Il n\'y a plus d'action \195\160 annuler.";
   SUICIDEKINGS_UNDID_ACTION="Annuler l'action : ";
   SUICIDEKINGS_ACTION_REMOVE="Enlever le joueur de la liste";
   SUICIDEKINGS_FMT_ACTION_SUICIDE="Suicide du joueur <1>";
   SUICIDEKINGS_ACTION_NEW="Cr\195\169er une nouvelle liste";
   SUICIDEKINGS_FMT_ACTION_DELETE="Liste <1> supprim\195\169e";
   SUICIDEKINGS_FMT_ACTION_SAVE="Liste <1> sauv\195\169e";
   SUICIDEKINGS_FMT_ACTION_ADD="Ajouter <1> \195\160 la liste";
   SUICIDEKINGS_SUICIDE="Le joueur <1> s'est suicid\195\169(e) !";
   SUICIDEKINGS_ACTION_MOVE_DOWN="D\195\169placer le joueur vers le bas";
   SUICIDEKINGS_ACTION_MOVE_UP="D\195\169placer le joueur vers le haut";
   SUICIDEKINGS_FMT_UNRESERVE="Le joueur <1> a \195\169t\195\169 enlev\195\169 de la r\195\169serve";
   SUICIDEKINGS_FMT_RESERVE="Le joueur <1> a \195\169t\195\169 mis dans la r\195\169serve";
   SUICIDEKINGS_RESERVE_LABEL="R\195\169serve";
   SUICIDEKINGS_AUTO_LISTS = { "Raid", "Mage", "Druide", "Paladin", "Guerrier", "Voleur", "Chasseur", "D\195\169moniste", "Pr\195\170tre", "Chaman" };

   SUICIDEKINGS_RAID_WARN_TEXT = "Ench\195\168res ouvertes: <1>";
   SUICIDEKINGS_RAID_WARN_LABEL = "Utiliser /ar pour annoncer les ench\195\168res";
   SUICIDEKINGS_SYNC_ABORT = "Synchro annul\195\169e pour cause de changement du canal de synchronisation.";
   SUICIDEKINGS_CHANNEL_LABEL = "Canal de synchronisation";
   SUICIDEKINGS_FMT_PLAYER_INFORMED = "<1> a \195\169t\195\169 inform\195\169 de ses positions dans les listes";
   SUICIDEKINGS_FMT_CANNOT_JOIN_CHANNEL = "Impossible de rejoindre le canal '<1>'. Le nom du canal peut \195\170tre \195\169rron\195\169. Il ne peut contenir d'espaces.";
   SUICIDEKINGS_MSG_BID_ALL_RETRACT = "Toutes les Ench\195\168res ont \195\169t\195\169 retir\195\169es, il n'y a donc plus d'offre maximale.";
   SUICIDEKINGS_MSG_BID_NO_RETRACT = "Vous n'avez pas fait d'offre, vous ne pouvez vous retirer.";
   SUICIDEKINGS_MSG_BID_RETRACT = "Votre offre a \195\169t\195\169 retir\195\169e.";
   SUICIDEKINGS_MSG_NEW_RAID = "Message de synchronisation re\195\167u de <1>.  Voulez vous accepter ?";
   SUICIDEKINGS_NEW_INSERT = "nouveau";
   
   SUICIDEKINGS_SEND_POSITION_MESSAGE1 = "Vous \195\170tes en position "; -- "Your position is ";
   SUICIDEKINGS_SEND_POSITION_MESSAGE2 = ".";
   SUICIDEKINGS_FMT_ERROR_NOSYNC = "Erreur: impossible de synchroniser avec <1>, une autre synchronisation est en cours."; -- "Error: cannot accept sync from <1> because another sync was started.";
   SUICIDEKINGS_FMT_SYNC_RECEIVED = "Synchronisation avec <1> termin\195\169e"; -- "Full sync received from <1>";
   SUICIDEKINGS_MSG_NO_LEADER = "Vous n'\195\170tes plus le ma\195\174tre du SK."; -- "You are no longer the SK loot master.";
   SUICIDEKINGS_MSG_RAID_REQUIRED = "Vous devez \195\170tre dans un groupe pour effectuer cette action."; -- "You must be in a group to do that.";
   SUICIDEKINGS_FMT_LIST_NOT_FOUND = "Liste <1> inconnue. V\195\169rifiez la casse (majuscule/minuscule)."; -- "List '<1>' not found.  List names are case-sensitive.";
   SUICIDEKINGS_NEW_MASTER = "Vous \195\170tes maintenant le ma\195\174tre du SK"; -- "You are now the master";
   SUICIDEKINGS_LIST_NEEDED = "Vous devez s\195\169lectionner une liste avant d'effectuer cette action."; -- "You must select a Suicide Kings list for that operation.";
   SUICIDEKINGS_MSG_TOO_MANY_LISTS = "Toutes les listes ne peuvent pas être affich\195\169e dans la fenêtre. Utilisez la fonction de 'filtre par pr\195\169fixe' ou la commande '/sk list <liste>' pour s\195\169lectionner une liste qui n'est pas affich\195\169e."; -- "There are too many lists to be displayed in the drop down.  Either use the 'filter by list prefix' feature or use the /sk list command to select a list that is not displayed."
   SUICIDEKINGS_FMT_LIST_SELECTED = "Liste <1> s\195\169lectionn\195\169e."; -- "<1> list selected.";
   SUICIDEKINGS_MASTER_NEEDED = "Vous devez \195\170tre ma\195\174tre du SK pour effectuer cette action (commande '/sk maitre')"; -- "You must be the master to perform this action (type /sk master)";
   SUICIDEKINGS_OFFICER_NEEDED = "Vous devez \195\170tre le chef de raid ou un de ses assistants pour effectuer ces actions."; -- "You must be the leader or an assistant to do that.";

   -- MESSAGE D'AIDE (has some English still in it)
   
   SUICIDEKINGS_HELP = "SuicideKings Loot mod by The Black Company, Whisperwind\
      Traduction par Feroth, guilde Le Clandestin, serveur Eitrigg (EU) et F\195\171as\195\174r, serveur Kirin Tor (FR)\
      /sk lister Annnoncer les 10 premiers joueurs de la liste s\195\169lectionn\195\169e\
      /sk lister <premier> <max> Annoncer les <max> joueurs \195\160 partir du <premier>\
      /sk nonlistes Annoncer les joueurs qui n'ont pas encore fait leurs jets de d\195\169s pour l'instance en cours\
      /sk sync Synchroniser toutes les listes SK avec les personnes actuellement group\195\169es - n\195\169cessite d'\195\170tre en raid et en mode master-\
      /sk sync <joueur> Synchroniser toutes les listes SK avec le <joueur>.\
      /sk sync <joueur> <liste1> [liste2 ...] Synchroniser uniquement les listes mentionn\195\169es avec le <joueur>\
      /sk inserer <joueur> <jet de d\195\169s> Ins\195\169rer le <joueur> avec le <jet de d\195\169s> sp\195\169cifi\195\169\
      /sk inserer <joueur>     Ins\195\168rer le <joueur> en bas de liste\
      /sk chercher <joueur>     Afficher la position du <joueur> dans la liste actuellement s\195\169lectionn\195\169e\
      /sk suicider <joueur>    Suicider le <joueur> dans la liste actuellement s\195\169lectionn\195\169e\
      /sk maitre    Vous passe en mode ma\195\174tre du raid en cours (vous seul pouvez ajouter des joueurs, synchroniser et suicider pour le raid en cours)\
      /sk fermer     Fermer les ench\195\168res pour un objet.\
      /sk liste <liste> Afficher la <liste> dans la fen\195\170tre SK (idem lors de la s\195\168lection \195\160 partir de la liste d\195\168roulante)\
      /sk aide Ce message\
   ";
   
   SUICIDEKINGS_USE_PREFIX_LABEL="Utiliser le pr\195\169fixe de liste automatique";
   SUICIDEKINGS_CLOSE_LABEL="Fermer";
   SUICIDEKINGS_AUTO_LABEL="Mode d'\195\169coute auto";
   SUICIDEKINGS_PREFIX_LABEL="Pr\195\169fixe de liste automatique";
   SUICIDEKINGS_PREFIX_FILTER_LABEL="Filter les listes par pr\195\169fixe";
   SUICIDEKINGS_OPTIONS_LABEL="Options";
   SUICIDEKINGS_FMT_PLAYER_NOT_FOUND = "Ne peut trouver le joueur <1>";
   SUICIDEKINGS_MSG_CURRENT_LIST="Liste actuelle";
   SUICIDEKINGS_MSG_NOTOPEN = "Les offres ne sont actuellement ouvertes pour aucun objet.";
   SUICIDEKINGS_MSG_NOT_MASTER = "SK: veuillez noter que pour recevoir des offres, vous devez \195\170tre en mode ma\195\174tre (/sk maitre)";
   SUICIDEKINGS_MSG_BID_CLOSED = "Les ench\195\168res sont actuellement ferm\195\169es.";
   SUICIDEKINGS_MSG_NO_BIDDERS = "Pas d'ench\195\168risseurs.";
   SUICIDEKINGS_FMT_WINNER = "Le gagnant est <1>.  Bravo !";
   SUICIDEKINGS_MSG_BID_OPEN = "Les ench\195\168res sont d\195\169j\195\160 ouvertes.";
   SUICIDEKINGS_FMT_BID_NOW_OPEN = "Les ench\195\168res sont maintenant ouvertes pour <1>.  Envoyez moi 'bid' en /w si vous voulez l'objet, 'retract' pour retirer votre offre, 'suicide' pour avoir votre place dans la liste.";
   SUICIDEKINGS_MSG_ALREADY_BIDDER = "Vous \195\170tes d\195\169j\195\160 le meilleur ench\195\168risseur.";
   SUICIDEKINGS_MSG_NO_LIST_SELECTED = "Le pr\195\169pos\195\169 au SK n'a pas s\195\169lectionn\195\169 de liste et ne peut donc pas recevoir d'offres.";
   SUICIDEKINGS_FMT_NOT_HIGH_BIDDER = "Le meilleur ench\195\168risseur est <1>.  Vous \195\170tes plus bas dans la liste et ne pouvez lui surench\195\168rir.";
   SUICIDEKINGS_FMT_NEW_HIGH_BIDDER = "Le nouveau meilleur ench\195\168risseur est <1> en position <2>";
   SUICIDEKINGS_MSG_NOT_ON_LIST = "Vous n'\195\170tes pas sur la liste s\195\169lectionn\195\169e par le pr\195\169pos\195\169 au SK et ne pouvez faire d'offre.";
   SUICIDEKINGS_FMT_TIE="L'insertion de <1> le place \195\160 \195\169galit\195\169 avec <2>.  Le jet de d\195\169partage place <1> en position <3> dans la liste."; 

else
   SUICIDEKINGS_SUICIDE_LABEL="Suicide!"
   SUICIDEKINGS_FREEZE_LABEL="Freeze"
   SUICIDEKINGS_INSERT_LABEL="Insert"
   SUICIDEKINGS_DELETE_LABEL="Delete"
   SUICIDEKINGS_UNDO_LABEL="Undo"
   SUICIDEKINGS_ACTIVE_LABEL="Active"
   SUICIDEKINGS_INACTIVE_LABEL="Inactive"
   SUICIDEKINGS_SAVE_LABEL="Save"
   SUICIDEKINGS_ROLL_PATTERN = "(.+) rolls (%d+) %((%d+)%-(%d+)%)"
   SUICIDEKINGS_TITLE = "Suicide Kings v%s"
   SUICIDEKINGS_NEW_LABEL = "New"
   SUICIDEKINGS_REMOVE_LABEL = "Remove"
   SUICIDEKINGS_SPAM_LABEL="Spam"
   SUICIDEKINGS_AUTO_LABEL="Auto"
   SUICIDEKINGS_MANUAL_LABEL="Manual"
   SUICIDEKINGS_SPAM_CMD_PATTERN1 = "spam (%d+) (%d+)"
   SUICIDEKINGS_SPAM_CMD_PATTERN2 = "spam (%d+)"
   SUICIDEKINGS_SPAM_CMD = "spam"
   SUICIDEKINGS_CLOSE_CMD = "close";
   SUICIDEKINGS_NOROLL_CMD = "noroll"
   SUICIDEKINGS_HELP_CMD = "help"
   SUICIDEKINGS_HELP="SuicideKings Loot mod by The Black Company, Whisperwind\
/sk spam    Spam top players in current list\
/sk spam <first> <max>    Spam players starting at <first>, <max> number\
/sk noroll    Spam players that still need to roll\
/sk sync    Sync your roll list to all players in the raid\
/sk sync <player> Send a synchronization of all your lists to <player>.\
/sk sync <player> <list1> [list2 ...] Send a sync of only the specified lists to the specified player\
/sk insert <player> <roll>    Insert player with the specified roll\
/sk insert <player>     Insert player at the bottom of the list\
/sk find <player>     Print out the position of <player> in the current list\
/sk suicide <player>    Suicide <player> in the current list\
/sk master    Set yourself as the SK master for the raid\
/sk close     Close bidding on an item.\
/sk list <list> Display <list> in the window, just like selecting from the drop down\
/sk help    This message\
   ";
   SUICIDEKINGS_SYNC_CMD = "sync";
   SUICIDEKINGS_MASTER_CMD = "master";
   SUICIDEKINGS_INSERT_CMD_PATTERN = "insert (%a+) (%d+)";
   SUICIDEKINGS_INSERT_CMD_PATTERN2 = "insert (.+)";
   SUICIDEKINGS_LOADED_MSG="SuicideKings v%s loaded by The Black Company, Whisperwind";
   SUICIDEKINGS_MSG_ROLL_TWICE=" still needs to be added to the Raid and Class lists.";
   SUICIDEKINGS_MSG_ROLL_ONCE=" still needs to be added to the Class list.";
   SUICIDEKINGS_MSG_STILL_ROLL=" still needs to be added to the list.";
   SUICIDEKINGS_FMT_NO_AUTO_ADD="Player: <1> cannot be auto-added to any lists.";
   SUICIDEKINGS_FMT_ADD="Adding <1> to <2> list.";
   SUICIDEKINGS_MSG_DELETE_CONFIRM="Do you want to delete this list?";
   SUICIDEKINGS_MSG_SAVE="Enter a name to save this list to.";
   SUICIDEKINGS_MSG_IGNORE_SYNC="Ignored SuicideKings sync from older mod version.";
   SUICIDEKINGS_FMT_ACCEPT_SYNC="Accept synch from <1>?";
   SUICIDEKINGS_MSG_NEED_CHRONOS="You must install the Timex or Chronos mod to perform a sync.";
   SUICIDEKINGS_MSG_SYNC_IN_PROGRESS="A sync is already in progress.";
   SUICIDEKINGS_MSG_SYNC_START="Staring sync...";
   SUICIDEKINGS_MSG_SYNC_DONE="Done with sync.";
   SUICIDEKINGS_MSG_NO_SUICIDE_FROZEN="Cannot suicide a frozen player!";
   SUICIDEKINGS_MSG_CAPTURE_ACTIVE="Roll capture activated.";
   SUICIDEKINGS_MSG_EVERYONE_ROLLED="Everyone has rolled.";
   SUICIDEKINGS_MSG_NO_NAMES="No names to print.";
   SUICIDEKINGS_FMT_TOP_LIST="Top <1> players in <2> list are:";
   SUICIDEKINGS_FMT_TOP="Top <1> players are:";
   SUICIDEKINGS_FMT_INDEX_LIST="Players <1>-<2> in <3> list are:";
   SUICIDEKINGS_FMT_INDEX="Players <1>-<2> are:";
   SUICIDEKINGS_NO_UNDO="No actions left to undo.";
   SUICIDEKINGS_UNDID_ACTION="Undo action: ";
   SUICIDEKINGS_ACTION_REMOVE="Remove player from list";
   SUICIDEKINGS_FMT_ACTION_SUICIDE="Suicide player <1>";
   SUICIDEKINGS_ACTION_NEW="Create new list";
   SUICIDEKINGS_FMT_ACTION_DELETE="Deleted list <1>";
   SUICIDEKINGS_FMT_ACTION_SAVE="Saved list <1>";
   SUICIDEKINGS_FMT_ACTION_ADD="Add <1> to list";
   SUICIDEKINGS_SUICIDE="Player <1> commits suicide!";
   SUICIDEKINGS_ACTION_MOVE_DOWN="Move player down";
   SUICIDEKINGS_ACTION_MOVE_UP="Move player up";
   SUICIDEKINGS_FMT_UNRESERVE="Player <1> has been taken off reserve";
   SUICIDEKINGS_FMT_RESERVE="Player <1> has been put on reserve";
   SUICIDEKINGS_RESERVE_LABEL="Reserve";
   SUICIDEKINGS_SEARCH_CMD = "find (.+)";
   SUICIDEKINGS_SUICIDE_CMD_PATTERN = "suicide (.+)";
   SUICIDEKINGS_FMT_PLAYER_NOT_FOUND = "Cannot find player <1>";
   SUICIDEKINGS_AUTO_LABEL="Auto-list mode";
   SUICIDEKINGS_PREFIX_LABEL="Auto-list prefix";
   SUICIDEKINGS_PREFIX_FILTER_LABEL="Filter lists by prefix";
   SUICIDEKINGS_OPTIONS_LABEL="Options";
   SUICIDEKINGS_CLOSE_LABEL="Close";
   SUICIDEKINGS_USE_PREFIX_LABEL="Use auto-list prefix";
   SUICIDEKINGS_FMT_TIE="Inserting <1> resulted in a <2>-way tie.  Tie breaker roll places <1> at position <3> in the list.";
   SUICIDEKINGS_MSG_CURRENT_LIST="current list";
   SUICIDEKINGS_AUTO_LISTS = { "Raid", "Mage", "Druid", "Paladin", "Warrior", "Rogue", "Hunter", "Warlock", "Priest", "Shaman", "Death Knight" };

   SUICIDEKINGS_MSG_NOTOPEN = "Bidding is not currently open on any item.";
   SUICIDEKINGS_MSG_NOT_MASTER = "SK: note that if you want to receive bids, you must be the master (/sk master)";
   SUICIDEKINGS_MSG_BID_CLOSED = "Bidding is now closed.";
   SUICIDEKINGS_MSG_NO_BIDDERS = "No bidders found.";
   SUICIDEKINGS_FMT_WINNER = "The winner is <1>.  Gratz!!!";
   SUICIDEKINGS_MSG_BID_OPEN = "Bidding is already open.";
   SUICIDEKINGS_FMT_BID_NOW_OPEN = "Bidding now open for <1>."; --  Whisper 'bid' to me if you would like the item.  Whisper 'retract' to retract bid.  Whisper 'suicide' to find your place on the list."
   SUICIDEKINGS_MSG_ALREADY_BIDDER = "You are already the high bidder.";
   SUICIDEKINGS_MSG_NO_LIST_SELECTED = "The master has no list selected and cannot accept bids.";
   SUICIDEKINGS_FMT_NOT_HIGH_BIDDER = "<1> is the high bidder.  You are lower on the list and cannot outbid him/her.";
   SUICIDEKINGS_FMT_NEW_HIGH_BIDDER = "<1> is the new high bidder at position <2>";
   SUICIDEKINGS_MSG_NOT_ON_LIST = "You are not on the list that the master has selected, and cannot enter a bid.";
   SUICIDEKINGS_MSG_NEW_RAID = "SuicideKings sync message received from <1>.  Do you want to accept?";
   SUICIDEKINGS_MSG_BID_RETRACT = "Your bid has been retracted.";
   SUICIDEKINGS_MSG_BID_NO_RETRACT = "You have not bid and cannot retract.";
   SUICIDEKINGS_MSG_BID_ALL_RETRACT = "All bids have been retracted, and there is no longer a high bidder."
   SUICIDEKINGS_CHANNEL_LABEL = "Sync Channel";
   SUICIDEKINGS_FMT_PLAYER_INFORMED = "<1> has been notified of his/her list position(s)";
   SUICIDEKINGS_FMT_CANNOT_JOIN_CHANNEL = "Could not join channel '<1>'.  Possible invalid channel name.  They cannot have spaces.";
   SUICIDEKINGS_SYNC_ABORT = "Full sync aborted due to sync channel switch.";
   SUICIDEKINGS_RAID_WARN_LABEL = "Use Raid Warning to announce bids";
   SUICIDEKINGS_RAID_WARN_TEXT = "Bidding open: <1>";
   SUICIDEKINGS_MSG_RAID_REQUIRED = "You must be in a group to do that.";
   SUICIDEKINGS_MSG_TOO_MANY_LISTS = "There are too many lists to be displayed in the drop down.  Either use the 'filter by list prefix' feature or use the /sk list command to select a list that is not displayed."
   SUICIDEKINGS_LIST_CMD_PATTERN = "list (.+)";
   SUICIDEKINGS_FMT_LIST_SELECTED = "<1> list selected.";
   SUICIDEKINGS_MASTER_NEEDED = "You must be the master to perform this action (type /sk master)";
   SUICIDEKINGS_LIST_NEEDED = "You must select a Suicide Kings list for that operation.";
   SUICIDEKINGS_OFFICER_NEEDED = "You must be the leader or an assistant to do that.";
   SUICIDEKINGS_NEW_MASTER = "You are now the master";
   SUICIDEKINGS_FMT_LIST_NOT_FOUND = "List '<1>' not found.  List names are case-sensitive.";
   SUICIDEKINGS_USE_CUSTOM_LABEL = "Use custom chat channel";
   SUICIDEKINGS_MSG_NO_LEADER = "You are no longer the SK loot master.";
   SUICIDEKINGS_FMT_SYNC_RECEIVED = "Full sync received from <1>";
   SUICIDEKINGS_FMT_ERROR_NOSYNC = "Error: cannot accept sync from <1> because another sync was started.";
   SUICIDEKINGS_NEW_INSERT = "new";
   SUICIDEKINGS_SEND_POSITION_LABEL = "Send tells with position spam"
   SUICIDEKINGS_SEND_POSITION_MESSAGE1 = "Your position is "
   SUICIDEKINGS_SEND_POSITION_MESSAGE2 = "."
   SUICIDEKINGS_SPAM_ALL_LABEL = "Spam entire list"
   SUICIDEKINGS_ALREADY_MASTER = "You are already the loot master."
   SUICIDEKINGS_WAITING_FOR_MASTER = "Still waiting for confirmation of master request.  Please wait."
   SUICIDEKINGS_USE_RAID_LABEL = "Raid/Party";
   SUICIDEKINGS_USE_GUILD_LABEL = "Guild";
end


