----------------------------------------------------------------------------------------------------------------------
-- Wowhead DB By: UniRing
----------------------------------------------------------------------------------------------------------------------
-- Wowhead DB Continued By: me
-- C = WHDB Continued comment header
-- WHDB = comments on original code, to explain it to myself or disable it
-- C
-- C changes on the original WHDB code by Redshadowz (see link below) have been commented
-- C in order to divide the code in original Rapid Quest Pack, Redshadow's and mine
-- C http://www.wow-one.com/forum/topic/4430-quest-helper-for-1121/page__st__60__p__482768#entry482768
-- C included some changes from WHDB 2.0 (functionality) and 2.1.1 (data)
----------------------------------------------------------------------------------------------------------------------
WHDB_MAP_NOTES = {};
WHDB_QuestZoneInfo = {};
WHDB_Player = "";
WHDB_Player_Race = "";
WHDB_Player_Sex = "";
WHDB_Player_Class = "";
WHDB_Player_Faction = "";
WHDB_PlotUpdate = 0;
WHDB_CommentParts = 0;
WHDB_Version = "Continued-WHDB for Rapid Quest Pack";

function WHDB_Init()
	-- C changed VARIABLES_LOADED to PLAYER_LOGIN
	this:RegisterEvent("PLAYER_LOGIN");
	this:RegisterEvent("QUEST_WATCH_UPDATE");
	this:RegisterEvent("QUEST_LOG_UPDATE");
	this:RegisterEvent("UNIT_QUEST_LOG_CHANGED");
	-- C events registered for testing purposes. until ...
	--this:RegisterEvent("ZONE_CHANGED");
	--this:RegisterEvent("ZONE_CHANGED_INDOORS");
	--this:RegisterEvent("ZONE_CHANGED_NEW_AREA");
	-- C ... here
	SlashCmdList["WHDB"] = WHDB_Slash;
	SLASH_WHDB1 = "/whdb";
end

function WHDB_Event(event, arg1)
	-- C changed VARIABLES_LOADED to PLAYER_LOGIN
	if (event == "PLAYER_LOGIN") then
		if (Cartographer_Notes ~= nil) then
			WHDBDB = {}; WHDBDBH = {};
			Cartographer_Notes:RegisterNotesDatabase("WHDB",WHDBDB,WHDBDBH);
			WHDB_Print("Cartographer Database Registered.");
		end
		WHDB_ShowUsingInfo();
		
		--Free the oposite faction database. -- not working in 1.12.1 UnitFactionGroup not init yet
		-- C Bullshit. UnitFactionGroup is working on some servers, but isn't initialised when VARIABLES_LOADED event triggers,
		-- C so changed to PLAYER_LOGIN event and modified it a bit (else-if and else). changes until...
		WHDB_Player_Faction = UnitFactionGroup("player");
		if (WHDB_Player_Faction == "Alliance") then
			qData["Horde"] = nil;
			WHDB_Print("Horde data cleared.");
		elseif (WHDB_Player_Faction == "Horde") then
			qData["Alliance"] = nil;
			WHDB_Print("Alliance data cleared.");
		else
			WHDB_Print("Unable to use UnitFactionGroup(\"player\"). Try making yourself visible and then use the chat-command /reloadUI.");
		end
		-- C ... here
		WHDB_Player = UnitName("player");
		WHDB_Player_Race = UnitRace("player");
		WHDB_Player_Sex = UnitSex("player");
		WHDB_Player_Class = UnitClass("player");
		stringX = WHDB_Player_Race..WHDB_Player_Sex..WHDB_Player_Class;
		DEFAULT_CHAT_FRAME:AddMessage(string.gsub(stringX, "2", "Male"));
		
		-- Initial settings configuration
		if (WHDB_Settings == nil) then
			WHDB_Settings = {};
			WHDB_Settings[WHDB_Player] = {};
			WHDB_Settings[WHDB_Player]["UseColors"] = 1;
			if (Cartographer_Notes ~= nil or MetaMap_DeleteNotes ~= nil) then
				WHDB_Settings[WHDB_Player]["auto_plot"] = 1;
			else
				WHDB_Settings[WHDB_Player]["auto_plot"] = 0;
			end
			WHDB_Settings[WHDB_Player]["waypoints"] = 1
		else
			if (WHDB_Settings[WHDB_Player] == nil) then
				WHDB_Settings[WHDB_Player] = {};
				WHDB_Settings[WHDB_Player]["UseColors"] = 1;
				WHDB_Settings[WHDB_Player]["auto_plot"] = 0;
				WHDB_Settings[WHDB_Player]["waypoints"] = 1
			end
		end
		-- New version settings update
		-- C default to 0, autoplot doesn't work on login (tough strangely on /rl it would)
		if (WHDB_Settings[WHDB_Player]["auto_plot"] == 1) then
			WHDB_Settings[WHDB_Player]["auto_plot"] = 0;
		end
		if (WHDB_Settings[WHDB_Player]["waypoints"] == nil) then
			WHDB_Settings[WHDB_Player]["waypoints"] = 1
		end
		-- WHDB if (WHDB_Settings[WHDB_Player]["auto_plot"] == 1) then
		-- WHDB 	WHDB_PlotAllQuests();
		-- WHDB end
		WHDB_Print("WHDB Loaded.");
	-- C debug until ...
	--elseif (event == "ZONE_CHANGED") then
	--	DEFAULT_CHAT_FRAME:AddMessage("ZONE_CHANGED");
	--	DEFAULT_CHAT_FRAME:AddMessage(GetRealZoneText());
	--	DEFAULT_CHAT_FRAME:AddMessage(GetSubZoneText());
	--elseif (event == "ZONE_CHANGED_INDOORS") then
	--	DEFAULT_CHAT_FRAME:AddMessage("ZONE_CHANGED_INDOORS");
	--	DEFAULT_CHAT_FRAME:AddMessage(GetRealZoneText());
	--	DEFAULT_CHAT_FRAME:AddMessage(GetSubZoneText());
	--elseif (event == "ZONE_CHANGED_NEW_AREA") then
	--	DEFAULT_CHAT_FRAME:AddMessage("ZONE_CHANGED_NEW_AREA");
	--	DEFAULT_CHAT_FRAME:AddMessage(GetRealZoneText());
	--	DEFAULT_CHAT_FRAME:AddMessage(GetSubZoneText());
	-- C ... here
	
	-- C changed to elseif
	elseif (event == "QUEST_WATCH_UPDATE") then
		-- WHDB WHDB_Print("QUEST_WATCH_UPDATE");
		WHDB_PlotUpdate = 1;
	elseif (event == "QUEST_LOG_UPDATE") then
		if (WHDB_Settings[WHDB_Player]["auto_plot"] == 1 and WHDB_PlotUpdate == 1) then
			-- WHDB WHDB_Print("Plots updated.");
			WHDB_PlotAllQuests();
			WHDB_PlotUpdate = 0;
		end
	elseif (event == "UNIT_QUEST_LOG_CHANGED") then
		-- WHDB WHDB_Print("UNIT_QUEST_LOG_CHANGED");
		if (WHDB_Settings[WHDB_Player]["auto_plot"] == 1 and arg1 == "player") then
			WHDB_PlotUpdate = 1;
		end
	end
end

function WHDB_ShowUsingInfo()
	if (EQL3_QuestLogFrame ~= nil) then
		WHDB_Print("Using EQL3.");
	elseif (QuestGuru_QuestLogFrame ~= nil) then
		WHDB_Print("Using QuestGuru.");
	else
		WHDB_Print("Using default quest log.");
	end
	if (MetaMap_DeleteNotes ~= nil) then
		WHDB_Print("MetaMap plotter enabled.");
	end
	if (Cartographer_Notes ~= nil) then
		WHDB_Print("Cartographer plotter enabled.");
	end
	if (MapNotes_Data_Notes ~= nil) then
		WHDB_Print("MapNotes plotter enabled.");
	end
end

function WHDB_Slash(input)
	--local params = {};
	
	-- C fixed by exchanging returns from string.gmatch()-function on top
	-- C with string.sub()-function in the if-statements and writing a
	-- C workaround in the section for comments display
	
	-- WHDB for v in string.gmatch(input, "[^ ]+") do
	-- WHDB		tinsert(params, v);
	-- WHDB end
	if (string.sub(input,1,4) == "help" or input == "") then
		WHDB_Print("Commands available:");
		WHDB_Print("-------------------------------------------------------");
		WHDB_Print("/whdb help | This help.");
		WHDB_Print("/whdb version | Show WHDB version.");
		WHDB_Print("/whdb com <quest name> | Get quest comments by name.");
		WHDB_Print("/whdb item <item name> | Show item drop info on map.");
		WHDB_Print("/whdb mob <npc name> | Show NPC location onm map.");
		WHDB_Print("/whdb clean | Clean map notes.");
		WHDB_Print("/whdb colors | Enable/Disable: Coloring of text in the quest log.");
		WHDB_Print("/whdb auto | Enable/Disable: Automatically plot uncompleted objectives on map.");
		WHDB_Print("/whdb waypoint | Enable/Disable: Plot waypoints on map.");
		WHDB_Print("/whdb copy <character> | Copy characters config to current one.");
		DEFAULT_CHAT_FRAME:AddMessage("\n");
		WHDB_Print("Note: All parameters are case sensitive!");
	elseif (string.sub(input,1,7) == "version") then
		WHDB_Print("Version: "..WHDB_Version);
	elseif (string.sub(input,1,3) == "com") then
		local questName = string.sub(input, 5);
		if (string.sub(questName,1,1) == "[") then
			if (string.sub(questName,3,3) == "]") then
				questName = string.sub(questName,4);
			else
				questName = string.sub(questName,5);
			end
		end
		if (questName ~= "") then
			WHDB_Print("Quest Comments");
			WHDB_Print("---------------------------------------------------");
			local QuestComments = WHDB_GetComments(questName);
			-- C commented because string.gmatch is not working
			-- WHDB for v in string.gmatch(QuestComments, "[^\n]+") do
			-- WHDB	 WHDB_Print(v);
			-- WHDB end
			
			-- C replacement for gmatch code. calls WHDB_Print too much. changes until ...
			local i = 0;
			while string.find(QuestComments, "\n", i) ~= nil do
				j = string.find(QuestComments, "\n", i);
				t = string.sub(QuestComments, i, j);
				if (t == "\n") then
					WHDB_Print("---------------------------------------------------");
				else
					WHDB_Print(t);
				end
				i = j+1;
			end
			-- C ... here
		end
	elseif (string.sub(input,1,4) == "item") then
		local itemName = string.sub(input, 6);
		if (string.sub(itemName,1,1) == "|") then
			_, _, _, itemName = string.find(itemName, "^|c%x+|H(.+)|h%[(.+)%]")
		end
		WHDB_Print("Drops for: "..itemName);
		WHDB_Print("---------------------------------------------------");
		if (itemName ~= "") then
			if (itemData[itemName] ~= nil) then
				local showmax = 1000;
				for monsterName, monsterDrop in pairs(itemData[itemName]) do
					npcID = GetNPCID(monsterName)
					zoneName = zoneData[npcData[npcID]["zone"]];
					if (zoneName == nil) then zoneName = npcData[npcID]["zone"]; end
					WHDB_Print("Dropped by: " .. monsterName);
					WHDB_Print_Indent(GetNPCDropComment(itemName, monsterName));
					WHDB_Print_Indent("Zone: " .. zoneName);
					-- Map plotting
					local comment = monsterName.."\n"..GetNPCDropComment(itemName, monsterName).."\n"..GetNPCStatsComment(monsterName);
					if (GetNPCNotes(monsterName, itemName, comment, 0)) then
						WHDB_ShowMap();
					else
						WHDB_Print_Indent("No locations found for: "..monsterName);
					end			
					showmax = showmax - 1;
					if (showmax == 0) then
						WHDB_Print("Showing only the 1000 first results.");
						break;
					end
				end
			end
		end
	elseif (string.sub(input,1,3) == "mob") then
		local monsterName = string.sub(input, 5);
		if (monsterName ~= "") then
			WHDB_Print("Location for: "..monsterName);
			if (monsterName ~= nil) then
				npcID = GetNPCID(monsterName)
				if (npcData[npcID] ~= nil) then
					zoneName = zoneData[npcData[npcID]["zone"]];
					if (zoneName == nil) then zoneName = npcData[npcID]["zone"]; end
					WHDB_Print_Indent("Zone: " .. zoneName);
					-- Map plotting
					if (GetNPCNotes(monsterName, monsterName, GetNPCStatsComment(monsterName), 0)) then
						WHDB_ShowMap();
					end
				else
					WHDB_Print("No location found.");
				end
			end			
		end
	elseif (string.sub(input,1,5) == "clean") then
		WHDB_CleanMap();
	elseif (string.sub(input,1,6) == "colors") then
		if (WHDB_Settings[WHDB_Player]["UseColors"] == 0) then
			WHDB_Settings[WHDB_Player]["UseColors"] = 1;
			WHDB_Print("Text colors enabled.");
		else
			WHDB_Settings[WHDB_Player]["UseColors"] = 0;
			WHDB_Print("Text colors disabled.");
		end
	elseif (string.sub(input,1,4) == "copy") then
		if (WHDB_Settings[string.sub(input,6)] ~= nil) then
			for k,v in pairs(WHDB_Settings[string.sub(input,6)]) do
				WHDB_Settings[WHDB_Player][k] = v;
			end
			WHDB_Print("Settings loaded.");
		else
			WHDB_Print("There are no settings for this character.");
		end
	elseif (string.sub(input,1,4) == "auto") then
		if (MetaMap_SetNewNote ~= nil or MapNotes_Data_Notes ~= nil or Cartographer_Notes ~= nil) then
			if (WHDB_Settings[WHDB_Player]["auto_plot"] == 1) then
				WHDB_Settings[WHDB_Player]["auto_plot"] = 0;
				WHDB_Print("Auto plotting disabled.");
				WHDB_CleanMap();
			else
				WHDB_Settings[WHDB_Player]["auto_plot"] = 1;
				WHDB_Print("Auto plotting enabled.");
				WHDB_PlotAllQuests();
			end
		else
			WHDB_Print("A map mod is needed to autoplot quests.");
		end
	elseif (string.sub(input,1,8) == "waypoint") then
		SwitchWP();
	-- C disable else
		-- C disable if (input == nil) then input = ""; end
		-- C disable WHDB_Print("Unknown command: \""..input.."\"");
	end
end

function WHDB_PlotAllQuests()
	local questLogID=1;
	WHDB_MAP_NOTES = {};
	while (GetQuestLogTitle(questLogID) ~= nil) do
		questLogID = questLogID + 1;
		GetQuestNotes(questLogID)
	end
	WHDB_CleanMap();
	WHDB_PlotNotesOnMap();
end

function WHDB_Print( string )
	DEFAULT_CHAT_FRAME:AddMessage("|cFF000099E-WHDB:|r " .. string, 0.95, 0.95, 0.5);
end

function WHDB_Print_Indent( string )
	DEFAULT_CHAT_FRAME:AddMessage("					   " .. string, 0.95, 0.95, 0.5);
end

function QuestLog_UpdateQuestDetails(doNotScroll)
	if (EQL3_QuestLogFrame ~= nil) then
		WHDB_QuestLog_UpdateQuestDetails("EQL3_", doNotScroll);
	elseif (QuestGuru_QuestLogFrame ~= nil) then
		WHDB_QuestLog_UpdateQuestDetails("QuestGuru_", doNotScroll);
	else
		WHDB_QuestLog_UpdateQuestDetails("", doNotScroll);
	end
end

-- WHDB Kind of the main function, most stuff happens here.
-- WHDB It updates the Quest-Log with buttons, target info, comments, etc.,
-- WHDB so nearly everything for Rapid Quest Pack functionality is in here.
function WHDB_QuestLog_UpdateQuestDetails(prefix, doNotScroll)
	if (getglobal(prefix.."QuestLogFrame"):IsVisible()) then
	local questLogID = GetQuestLogSelection();
	WHDB_MAP_NOTES = {};
	showMap = false or GetQuestNotes(questLogID);
	if ( not questTitle ) then
		questTitle = "";
	end
	local questTitle = GetQuestLogTitle(questLogID);
	-- C debug
	DEFAULT_CHAT_FRAME:AddMessage("questTitle: "..questTitle);
	local questComments = WHDB_GetComments(questTitle);
	if ( IsCurrentQuestFailed() ) then
		questTitle = questTitle.." - ("..TEXT(FAILED)..")";
	end
	getglobal(prefix.."QuestLogQuestTitle"):SetText(questTitle);

	local questDescription;
	local questObjectives;
	questDescription, questObjectives = GetQuestLogQuestText();
	-- C debug
	-- C DEFAULT_CHAT_FRAME:AddMessage(questObjectives);
	-- C if (questObjectives == nil) then DEFAULT_CHAT_FRAME:AddMessage("questObjectives = nil"); end
	-- C if (questObjectives == '') then DEFAULT_CHAT_FRAME:AddMessage("questObjectives = ''"); end
	getglobal(prefix.."QuestLogObjectivesText"):SetText(questObjectives);
	
	local questTimer = GetQuestLogTimeLeft();
	if ( questTimer ) then
		getglobal(prefix.."QuestLogFrame").hasTimer = 1;
		getglobal(prefix.."QuestLogFrame").timePassed = 0;
		getglobal(prefix.."QuestLogTimerText"):Show();
		getglobal(prefix.."QuestLogTimerText"):SetText(TEXT(TIME_REMAINING).." "..SecondsToTime(questTimer));
		getglobal(prefix.."QuestLogObjective1"):SetPoint("TOPLEFT", prefix.."QuestLogTimerText", "BOTTOMLEFT", 0, -10);
	else
		getglobal(prefix.."QuestLogFrame").hasTimer = nil;
		getglobal(prefix.."QuestLogTimerText"):Hide();
		getglobal(prefix.."QuestLogObjective1"):SetPoint("TOPLEFT", prefix.."QuestLogObjectivesText", "BOTTOMLEFT", 0, -10);
	end
	
	-- Show Quest Watch if track quest is checked
	local numObjectives = GetNumQuestLeaderBoards();
	-- C debug
	-- C DEFAULT_CHAT_FRAME:AddMessage(numObjectives);
	
	local monsterName, zoneName, noteAdded, showMap, noteID;
	for i=1, numObjectives, 1 do
		local string = getglobal(prefix.."QuestLogObjective"..i);
		local text, type, finished = GetQuestLogLeaderBoard(i);
		-- C debug
		-- C DEFAULT_CHAT_FRAME:AddMessage(text);
		if ( not text or strlen(text) == 0 ) then
			text = type;
		end
		local i, j, itemName, numItems, numNeeded = strfind(text, "(.*):%s*([%d]+)%s*/%s*([%d]+)");
		
		if ( finished ) then
			string:SetTextColor(0.2, 0.2, 0.2);
			text = text.." ("..TEXT(COMPLETE)..")";
		else
			string:SetTextColor(0, 0, 0);
		end
		text = "___________________________________________\n"..text;
		-- WHDB checks objectives and saves map notes if coordinates are found
		if ((type == "monster") and (not finished)) then
			-- C debug
			-- C DEFAULT_CHAT_FRAME:AddMessage(type);
			local i, j, monsterName = strfind(itemName, "(.*) slain");
			if (monsterName ~= nil) then
				npcID = GetNPCID(monsterName)
				if (npcData[monsterName] ~= nil) then
					if (npcData[monsterName]["zone"] ~= nil) then
						zoneName = zoneData[npcData[monsterName]["zone"]];
					else
						zoneName = WHDB_QuestZoneInfo[questTitle];
					end
					if (zoneName == nil) then zoneName = npcData[monsterName]["zone"]; end
					text = text.."\n\n";
					local comment = GetNPCStatsComment(monsterName);
					if (WHDB_Settings[WHDB_Player]["UseColors"] == 1) then
						text = text.."|c00442200Zone: "..zoneName.."\n|r";
						text = text.."|cFF002244"..comment.."\n|r";
					else
						text = text.."Zone: "..zoneName.."\n";
						text = text..comment.."\n";
					end
					text = text.."\n";
				end
			end
		-- C Change by Redshadowz:
		-- C if statement changed to elseif
		elseif ((type == "item") and (not finished)) then
			-- C debug
			-- C DEFAULT_CHAT_FRAME:AddMessage(type);
			if (itemData[itemName] ~= nil) then
				text = text.."\n\n";
				for monsterName, monsterDrop in pairs(itemData[itemName]) do
					npcID = GetNPCID(monsterName)
					if (npcData[npcID] ~= nil) then
						if (npcData[npcID]["zone"] ~= nil) then
							zoneName = zoneData[npcData[npcID]["zone"]];
						else
							zoneName = WHDB_QuestZoneInfo[questTitle];
						end
						if (zoneName == nil) then zoneName = npcData[npcID]["zone"]; end
						local comment = GetNPCStatsComment(monsterName);
						local commentDrop = GetNPCDropComment(itemName, monsterName);
						if (WHDB_Settings[WHDB_Player]["UseColors"] == 1) then
							text = text.."|c00444444Dropped by: ".. monsterName.."\n|r";
							text = text.."|c00220044"..commentDrop.."\n|r";
							text = text.."|cFF442200Zone: "..zoneName.."\n|r";
							text = text.."|cFF002244"..comment.."\n|r";
						else
							text = text.."Dropped by: ".. monsterName.."\n";
							text = text.."Drop Rate: ".. commentDrop.."\n";
							text = text.."Zone: ".. zoneName.."\n";
							text = text..comment.."\n";
						end
						text = text.."\n";
					end
				end
			end
		-- C check for objective type other than item or monster, e.g. object, reputation, event
		elseif (type ~= "item" and type ~= "monster") then
			-- C debug
			DEFAULT_CHAT_FRAME:AddMessage(type.." quest objective-type not supported yet by WHDB");
		end

		string:SetText(text);
		string:Show();
		QuestFrame_SetAsLastShown(string);
	end

	for i=numObjectives + 1, MAX_OBJECTIVES, 1 do
		getglobal(prefix.."QuestLogObjective"..i):Hide();
	end

	-- If there's money required then anchor and display it
	if ( GetQuestLogRequiredMoney() > 0 ) then
		if ( numObjectives > 0 ) then
			getglobal(prefix.."QuestLogRequiredMoneyText"):SetPoint("TOPLEFT", "QuestLogObjective"..numObjectives, "BOTTOMLEFT", 0, -4);
		else
			getglobal(prefix.."QuestLogRequiredMoneyText"):SetPoint("TOPLEFT", "QuestLogObjectivesText", "BOTTOMLEFT", 0, -10);
		end
		
		MoneyFrame_Update(prefix.."QuestLogRequiredMoneyFrame", GetQuestLogRequiredMoney());
		
		if ( GetQuestLogRequiredMoney() > GetMoney() ) then
			-- Not enough money
			getglobal(prefix.."QuestLogRequiredMoneyText"):SetTextColor(0, 0, 0);
			SetMoneyFrameColor(prefix.."QuestLogRequiredMoneyFrame", 1.0, 0.1, 0.1);
		else
			getglobal(prefix.."QuestLogRequiredMoneyText"):SetTextColor(0.2, 0.2, 0.2);
			SetMoneyFrameColor(prefix.."QuestLogRequiredMoneyFrame", 1.0, 1.0, 1.0);
		end
		getglobal(prefix.."QuestLogRequiredMoneyText"):Show();
		getglobal(prefix.."QuestLogRequiredMoneyFrame"):Show();
	else
		getglobal(prefix.."QuestLogRequiredMoneyText"):Hide();
		getglobal(prefix.."QuestLogRequiredMoneyFrame"):Hide();
	end

	if ( GetQuestLogRequiredMoney() > 0 ) then
		getglobal(prefix.."QuestLogDescriptionTitle"):SetPoint("TOPLEFT", prefix.."QuestLogRequiredMoneyText", "BOTTOMLEFT", 0, -10);
	elseif ( numObjectives > 0 ) then
		getglobal(prefix.."QuestLogDescriptionTitle"):SetPoint("TOPLEFT", prefix.."QuestLogObjective"..numObjectives, "BOTTOMLEFT", 0, -10);
	else
		if ( questTimer ) then
			getglobal(prefix.."QuestLogDescriptionTitle"):SetPoint("TOPLEFT", prefix.."QuestLogTimerText", "BOTTOMLEFT", 0, -10);
		else
			getglobal(prefix.."QuestLogDescriptionTitle"):SetPoint("TOPLEFT", prefix.."QuestLogObjectivesText", "BOTTOMLEFT", 0, -10);
		end
	end
	if ( questDescription ) then
		getglobal(prefix.."QuestLogQuestDescription"):SetText(questDescription);
		QuestFrame_SetAsLastShown(getglobal(prefix.."QuestLogQuestDescription"));
	end	
	
	local questSet = {};
	if (string.len(questComments) > 3900) then
		local questComment = questComments
		while (string.len(questComment) > 3900) do
			local part = string.sub(questComment, 1, 3900);
			questComment = string.sub(questComment, 3901);
			table.insert(questSet, part);
		end
		table.insert(questSet, questComment);
	else
		table.insert(questSet, questComments);
	end
	
	if (getglobal(prefix.."QuestLogMapButtonsTitle") == nil) then
		getglobal(prefix.."QuestLogDetailScrollChildFrame"):CreateFontString(prefix.."QuestLogMapButtonsTitle","","QuestTitleFont");
	end
	getglobal(prefix.."QuestLogDetailScrollChildFrame"):CreateFontString(prefix.."QuestLogCommentsTitle","","QuestTitleFont");
	-- C changed for correct comment display, still bugged
	getglobal(prefix.."QuestLogDetailScrollChildFrame"):CreateFontString(prefix.."QuestLogCommentsDescription_0","","QuestFont");
	for n, set in pairs(questSet) do
		-- C debug
		-- C DEFAULT_CHAT_FRAME:AddMessage(n);
		getglobal(prefix.."QuestLogDetailScrollChildFrame"):CreateFontString(prefix.."QuestLogCommentsDescription_"..n,"","QuestFont");
	end

	-- C opy description font color. (for skinner like addons)
	local r, g, b, a = getglobal(prefix.."QuestLogQuestDescription"):GetTextColor();
	
	getglobal(prefix.."QuestLogMapButtonsTitle"):SetHeight(0);
	getglobal(prefix.."QuestLogMapButtonsTitle"):SetWidth(285);
	getglobal(prefix.."QuestLogMapButtonsTitle"):SetPoint("TOPLEFT", prefix.."QuestLogQuestDescription", "BOTTOMLEFT", 0, -15);
	getglobal(prefix.."QuestLogMapButtonsTitle"):SetJustifyH("LEFT");
	getglobal(prefix.."QuestLogMapButtonsTitle"):SetText("Map Plots");
	getglobal(prefix.."QuestLogMapButtonsTitle"):SetTextColor(r, g, b, a);
	
	-- C code moved from further down below and edited it
	-- C quest rewards show before comments now
	-- C <<
	-- C fix below here
	
	local numRewards = GetNumQuestLogRewards();
	local numChoices = GetNumQuestLogChoices();
	local money = GetQuestLogRewardMoney();
	-- C added check for spell rewards
	local ttexture, tname, tisTradeskillSpell, tisSpellLearned = GetQuestLogRewardSpell();
	if ( (numRewards + numChoices + money) > 0 ) or (tname ~= nil) then
		-- C anchor reward text below map buttons
		getglobal(prefix.."QuestLogRewardTitleText"):SetPoint("TOPLEFT", prefix.."QuestLogMapButtonsTitle", "BOTTOMLEFT", 0, -40);
		-- C calculate space needed between rewards and comments in quest log
		local offs = 0;
		if numRewards > 0 then
			-- C two items display in a row in quest log so a third item would need a new row a fourth not
			-- C therefore divide numItems/2, which results in .5 values for uneven numbers, ...
			y = (numRewards/2);
			-- C ... which we round upwards, in case an uneven number was given, and we got the number of Rows we need
			x = math.floor(y + .5);
			-- C x*45 is for item rows, + 25 for text, modify these (45/25) if display is bugged
			offs = (x*45) + 25;
		end
		if numChoices > 0 then
			-- C see above
			y = (numChoices/2);
			x = math.floor(y + .5);
			-- C + 35 due to 2 rows of text being displayed for choices
			offs = offs + (x*45) + 35;
		end
		-- C money row if there are no other rewards
		if (money > 0 and numRewards == 0 and tname == nil) then
			offs = offs + 25;
		end
		-- C check for spell reward
		if (tname ~= nil) then
			offs = offs + 50;
			-- C check if spell is the only reward
			if ((numRewards + money) == 0) then
				offs = offs + 25;
			end
		end
		-- C offset has to be negative
		offs = offs * (-1);
		-- C anchor comments with offset (offs)
		getglobal(prefix.."QuestLogCommentsTitle"):SetPoint("TOPLEFT", prefix.."QuestLogRewardTitleText", "BOTTOMLEFT", 0, offs);
		getglobal(prefix.."QuestLogRewardTitleText"):Show();
		QuestFrame_SetAsLastShown(getglobal(prefix.."QuestLogRewardTitleText"));
	-- C for quests without reward
	else
		getglobal(prefix.."QuestLogCommentsTitle"):SetPoint("TOPLEFT", prefix.."QuestLogMapButtonsTitle", "BOTTOMLEFT", 0, -40);
		getglobal(prefix.."QuestLogRewardTitleText"):Hide();
	end

	-- C >>
	
	getglobal(prefix.."QuestLogCommentsTitle"):SetHeight(0);
	getglobal(prefix.."QuestLogCommentsTitle"):SetWidth(285);
	-- WHDB getglobal(prefix.."QuestLogCommentsTitle"):SetPoint("TOPLEFT", prefix.."QuestLogMapButtonsTitle", "BOTTOMLEFT", 0, -50);
	getglobal(prefix.."QuestLogCommentsTitle"):SetJustifyH("LEFT");
	getglobal(prefix.."QuestLogCommentsTitle"):SetText("Comments");
	getglobal(prefix.."QuestLogCommentsTitle"):SetTextColor(r, g, b, a);
	-- C debug
	-- C DEFAULT_CHAT_FRAME:AddMessage(string.len(questComments));
	
	getglobal(prefix.."QuestLogCommentsDescription_0"):SetHeight(0);
	getglobal(prefix.."QuestLogCommentsDescription_0"):SetWidth(270);
	getglobal(prefix.."QuestLogCommentsDescription_0"):SetPoint("TOPLEFT", prefix.."QuestLogCommentsTitle", "BOTTOMLEFT", 0, -5);
	getglobal(prefix.."QuestLogCommentsDescription_0"):SetJustifyH("LEFT");
	getglobal(prefix.."QuestLogCommentsDescription_0"):SetTextColor(r, g, b, a);
	getglobal(prefix.."QuestLogCommentsDescription_0"):SetText(table.getn(questSet).." parts");
	QuestFrame_SetAsLastShown(getglobal(prefix.."QuestLogCommentsDescription_0"));
	
	-- C delete old quest comments
	local x = WHDB_CommentParts;
	if (WHDB_CommentParts > 0) then
		while ((getglobal(prefix.."QuestLogCommentsDescription_"..x):GetText() ~= nil) and (x > 0)) do
			-- C debug
			-- C DEFAULT_CHAT_FRAME:AddMessage("WHDB_CommentParts "..x);
			getglobal(prefix.."QuestLogCommentsDescription_"..x):SetText(nil);
			x = x - 1;
		end
		WHDB_CommentParts = x
	end

	for n, part in pairs(questSet) do
		-- C debug
		-- C DEFAULT_CHAT_FRAME:AddMessage(n);
		getglobal(prefix.."QuestLogCommentsDescription_"..n):SetHeight(0);
		getglobal(prefix.."QuestLogCommentsDescription_"..n):SetWidth(270);
		local t = n - 1;
		getglobal(prefix.."QuestLogCommentsDescription_"..n):SetPoint("TOPLEFT", prefix.."QuestLogCommentsDescription_"..t, "BOTTOMLEFT", 0, -5);
		getglobal(prefix.."QuestLogCommentsDescription_"..n):SetJustifyH("LEFT");
		getglobal(prefix.."QuestLogCommentsDescription_"..n):SetTextColor(r, g, b, a);
		getglobal(prefix.."QuestLogCommentsDescription_"..n):SetText(part);
		QuestFrame_SetAsLastShown(getglobal(prefix.."QuestLogCommentsDescription_"..n));
		WHDB_CommentParts = n;
	end
	local questSet = nil;
	local questComments = nil;
	
	if (getglobal(prefix.."QuestLogShowMap") == nil) then
		CreateFrame("Button", prefix.."QuestLogShowMap", getglobal(prefix.."QuestLogDetailScrollChildFrame"), "UIPanelButtonTemplate");
		CreateFrame("Button", prefix.."QuestLogCleanMap", getglobal(prefix.."QuestLogDetailScrollChildFrame"), "UIPanelButtonTemplate");
		CreateFrame("Button", prefix.."QuestLogAutoMap", getglobal(prefix.."QuestLogDetailScrollChildFrame"), "UIPanelButtonTemplate");
	end
	
	getglobal(prefix.."QuestLogShowMap"):SetText("Show Map");
	getglobal(prefix.."QuestLogShowMap"):SetPoint("TOPLEFT", prefix.."QuestLogMapButtonsTitle", "BOTTOMLEFT", 0, -10);
	getglobal(prefix.."QuestLogShowMap"):SetHeight(25);
	getglobal(prefix.."QuestLogShowMap"):SetWidth(85);
	getglobal(prefix.."QuestLogShowMap"):RegisterForClicks("LeftButtonUp");
	getglobal(prefix.."QuestLogShowMap"):SetScript("OnClick", function()
		getglobal(prefix.."QuestLogAutoMap"):Enable();
		getglobal(prefix.."QuestLogCleanMap"):Enable();
		this:Disable();
		WHDB_PlotNotesOnMap();
	end);
	
	getglobal(prefix.."QuestLogCleanMap"):SetText("Clean Map");
	getglobal(prefix.."QuestLogCleanMap"):SetPoint("TOPLEFT", prefix.."QuestLogMapButtonsTitle", "BOTTOMLEFT", 90, -10);
	getglobal(prefix.."QuestLogCleanMap"):SetHeight(25);
	getglobal(prefix.."QuestLogCleanMap"):SetWidth(85);
	getglobal(prefix.."QuestLogCleanMap"):RegisterForClicks("LeftButtonUp");
	getglobal(prefix.."QuestLogCleanMap"):SetScript("OnClick", function()
		getglobal(prefix.."QuestLogAutoMap"):Enable();
		WHDB_DoCleanMap();
	end);

	getglobal(prefix.."QuestLogAutoMap"):SetText("Autoplot");
	getglobal(prefix.."QuestLogAutoMap"):SetPoint("TOPLEFT", prefix.."QuestLogMapButtonsTitle", "BOTTOMLEFT", 180, -10);
	getglobal(prefix.."QuestLogAutoMap"):SetHeight(25);
	getglobal(prefix.."QuestLogAutoMap"):SetWidth(85);
	getglobal(prefix.."QuestLogAutoMap"):RegisterForClicks("LeftButtonUp");
	getglobal(prefix.."QuestLogAutoMap"):SetScript("OnClick", function()
		WHDB_SwitchAuto();
	end);

	-- C moved some code further up from here and modified it
	
	-- C redundant
	-- C showMap =  GetCommentNotes(questTitle) or showMap;
	
	-- C Change by Redshadowz:
	-- C if and else statements uncommented until ...
	if (not showMap) then
		getglobal(prefix.."QuestLogShowMap"):Disable();
		getglobal(prefix.."QuestLogCleanMap"):Disable();
	else
		getglobal(prefix.."QuestLogShowMap"):Enable();
		getglobal(prefix.."QuestLogCleanMap"):Enable();
	end
	-- C ... here	
	if (WHDB_Settings[WHDB_Player]["auto_plot"] == 1 and showMap) then
		getglobal(prefix.."QuestLogAutoMap"):Disable();
	else
		getglobal(prefix.."QuestLogAutoMap"):Enable();
	end
	
	QuestFrameItems_Update("QuestLog");
	if ( not doNotScroll ) then
		getglobal(prefix.."QuestLogDetailScrollFrameScrollBar"):SetValue(0);
	end
	getglobal(prefix.."QuestLogDetailScrollFrame"):UpdateScrollChildRect();
	end
end

--E New Icons from mpq files
Cartographer_Notes:RegisterIcon("Wasanderes", {
    text = "Wasanderes",
    path = "Interface\\GossipFrame\\ActiveQuestIcon",
})
Cartographer_Notes:RegisterIcon("NPC", {
    text = "NPC",
    path = "Interface\\WorldMap\\WorldMapPartyIcon",
})
Cartographer_Notes:RegisterIcon("Waypoint", {
    text = "Waypoint",
    path = "Interface\\WorldMap\\WorldMapPlayerIcon",
})

function WHDB_PlotNotesOnMap()
	local zone = nil;
	local title = nil;
	local noteID = nil;
	
	local firstNote = 1;
	
	for nKey, nData in ipairs(WHDB_MAP_NOTES) do
		-- C debug
		-- C WHDB_Print(nData[1]);
		
		-- C check for zoneId's instead of names and change if necessary.
		-- C until ...
		if type(nData[1]) == number then
			nData[1] = zoneData[nData[1]]
		end
		-- C ... here
		if (MetaMapNotes_AddNewNote ~= nil) then
			if (nData[6] == 0) then
				local continent, zone = MetaMap_NameToZoneID(nData[1]);
				noteAdded, noteID = MetaMapNotes_AddNewNote(continent,zone, nData[2]/100, nData[3]/100, nData[4], nData[5], "", "WHDB", 2, 7, 0, 0, 1);
			elseif (nData[6] == 1) then
				local continent, zone = MetaMap_NameToZoneID(nData[1]);
				noteAdded, noteID = MetaMapNotes_AddNewNote(continent,zone, nData[2]/100, nData[3]/100, nData[4], nData[5], "", "WHDB", 1, 2, 0, 0, 1);
			elseif (nData[6] == 2) then
				local continent, zone = MetaMap_NameToZoneID(nData[1]);
				noteAdded, noteID = MetaMapNotes_AddNewNote(continent,zone, nData[2]/100, nData[3]/100, nData[4], nData[5], "", "WHDB", 3, 8, 0, 0, 1);
			end
			
			local continent, zone = MetaMap_NameToZoneID(nData[1]);
			
			if (BWP_Destination ~= nil) then
				if (firstNote == 1) then 
				BWP_Destination = {};
				BWP_Destination.name = nData[4];
				BWP_Destination.x = nData[2]/100;
				BWP_Destination.y = nData[3]/100;
				BWP_Destination.zone = MetaMap_ZoneNames[continent][zone];
				BWPDestText:SetText("("..BWP_Destination.name..")");
				BWPDistanceText:SetText(BWP_GetDistText())
				BWP_DisplayFrame:Show();
				firstNote = 0;
				end
			end
			
			
			
			
		end
		if (Cartographer_Notes ~= nil) then
			if (nData[6] == 0) then
				Cartographer_Notes:SetNote(nData[1], nData[2]/100, nData[3]/100, "NPC", "WHDB", 'title', nData[4], 'info', nData[5]);			
			elseif (nData[6] == 1) then
				Cartographer_Notes:SetNote(nData[1], nData[2]/100, nData[3]/100, "Diamond", "WHDB", 'title', nData[4], 'info', nData[5]);			
			elseif (nData[6] == 2) then
				Cartographer_Notes:SetNote(nData[1], nData[2]/100, nData[3]/100, "Wasanderes", "WHDB", 'title', nData[4], 'info', nData[5]);
			elseif (nData[6] == 3) then
				Cartographer_Notes:SetNote(nData[1], nData[2]/100, nData[3]/100, "Waypoint", "WHDB", 'title', nData[4], 'info', nData[5]);
			end
		end
		if (MapNotes_Data_Notes ~= nil) then
			local c, z = WHDB_GetMapIDFromZone(nData[1]);
			if (key ~= -1) then
				SetMapZoom(c, z);
				key = MapNotes_GetMapKey();
				if (MapNotes_Data_Notes[key] ~= nil) then
					local Id = MapNotes_GetZoneTableSize(MapNotes_Data_Notes[key]) + 1;
					MapNotes_Data_Notes[key][Id] = {};
					MapNotes_Data_Notes[key][Id].name = nData[4];
					MapNotes_Data_Notes[key][Id].ncol = 7;
					MapNotes_Data_Notes[key][Id].inf1 = nData[5];
					MapNotes_Data_Notes[key][Id].in1c = 8;
					MapNotes_Data_Notes[key][Id].inf2 = "";
					MapNotes_Data_Notes[key][Id].in2c = 8;
					MapNotes_Data_Notes[key][Id].creator = "WHDB";
					if (nData[6] == 0) then
						MapNotes_Data_Notes[key][Id].icon = 7;
					else
						MapNotes_Data_Notes[key][Id].icon = 0;
					end
					MapNotes_Data_Notes[key][Id].xPos = nData[2]/100;
					MapNotes_Data_Notes[key][Id].yPos = nData[3]/100;
				else
					WHDB_Print("Error: MapNotes can't find the map.");
				end
			else
				WHDB_Print("Error: Map doesn't exist!");
			end
		end
		if (nData[1] ~= nil) then
			zone = nData[1];
			title = nData[4];
		end
	end
	WHDB_MAP_NOTES = {}
	return zone, title, noteID;
end

function WHDB_GetMapIDFromZone(zoneText)
	for cKey, cName in ipairs{GetMapContinents()} do
		for zKey,zName in ipairs{GetMapZones(cKey)} do
			if(zoneText == zName) then
				return cKey, zKey;
			end
		end
	end
	return -1, zoneText;
end

function WHDB_GetComments(questTitle)
	local questCom = "";
	if (qData[WHDB_Player_Faction][questTitle] ~= nil) then
		for id, comment in ipairs(qData[WHDB_Player_Faction][questTitle]['comments']) do
			questCom = questCom .. comment .."\n____________________\n";
		end
	elseif (qData['Common'][questTitle] ~= nil) then
		for id, comment in ipairs(qData['Common'][questTitle]['comments']) do
			questCom = questCom .. comment .."\n____________________\n";
		end
	else
		questCom = questCom  .. "No comments for this quest.\n\n";
	end
	return questCom;
end

function WHDB_GetReqLevel(questTitle)
	if (qData[WHDB_Player_Faction][questTitle] ~= nil) then
		return qData[WHDB_Player_Faction][questTitle]['reqlevel'];
	elseif (qData['Common'][questTitle] ~= nil) then
		return qData['Common'][questTitle]['reqlevel'];
	else
		return "?";
	end
end

function WHDB_ShowMap()
	local ShowMapZone, ShowMapTitle, ShowMapID = WHDB_PlotNotesOnMap();
	if (MetaMap_ShowLocation ~= nil) then
		if (ShowMapZone ~= nil and ShowMapID ~= nil) then
			MetaMap_ShowLocation(ShowMapZone, ShowMapTitle, ShowMapID);
		end
	end
	if (Cartographer) then
		if (ShowMapZone ~= nil) then
			WorldMapFrame:Show();								
			SetMapZoom(WHDB_GetMapIDFromZone(ShowMapZone));
		end
	end
	if (MapNotes_Data_Notes ~= nil) then
		WorldMapFrame:Show();
		SetMapZoom(WHDB_GetMapIDFromZone(ShowMapZone));
	end
end

function WHDB_CleanMap()
	if (MetaMap_DeleteNotes ~= nil) then
		MetaMap_DeleteNotes("WHDB");
	end
	if (Cartographer_Notes ~= nil) then
		Cartographer_Notes:UnregisterNotesDatabase("WHDB");
		WHDBDB = {}; WHDBDBH = {};
		Cartographer_Notes:RegisterNotesDatabase("WHDB",WHDBDB,WHDBDBH);
	end
	if (MapNotes_Data_Notes ~= nil) then
		MapNotes_DeleteNotesByCreatorAndName("WHDB");
	end
end

function WHDB_DoCleanMap()
	if (WHDB_Settings[WHDB_Player]["auto_plot"] == 1) then
		WHDB_Settings[WHDB_Player]["auto_plot"] = 0;
		WHDB_Print("Auto plotting disabled.");
	end
	WHDB_CleanMap();
end

function WHDB_SwitchAuto()
	if (WHDB_Settings[WHDB_Player]["auto_plot"] == 0) then
		WHDB_Settings[WHDB_Player]["auto_plot"] = 1;
		WHDB_Print("Auto plotting enabled.");
		WHDB_PlotAllQuests();
	else
		WHDB_DoCleanMap();
	end
end

function WHDB_PopulateZones()
	local numEntries, numQuests = GetNumQuestLogEntries();
	local lastZone, questLogTitleText, level, questTag, isHeader, isCollapsed, isComplete;
	for i=1, numEntries, 1 do
		questLogTitleText, level, questTag, isHeader, isCollapsed, isComplete = GetQuestLogTitle(i);
		if (isHeader) then
			lastZone = questLogTitleText;
		else
			WHDB_QuestZoneInfo[questLogTitleText] = lastZone;
		end
	end
end

function SearchEndNPC(quest)
	for npc, data in pairs(npcData) do
		if (data["ends"] ~= nil) then
			-- C searches whole table instead of just 5 entries now
			for line, entry in pairs(data["ends"]) do
				if (entry == quest) then return data["name"]; end
			end
		end
	end
	return nil;
end

-- C new functions below here
-- C ingame test
-- C /script GetQuestEndNotes(2); WHDB_PlotNotesOnMap();

function GetQuestEndNotes(questLogID)
	local questTitle = GetQuestLogTitle(questLogID);
	local questDescription, questObjectives = GetQuestLogQuestText();
	if (questObjectives == nil) then questObjectives = ''; end
	local multi, qIDs = GetQuestIDs(questTitle, questObjectives);
	-- C debug
	-- C DEFAULT_CHAT_FRAME:AddMessage(table.getn(qIDs));
	if (qIDs ~= false) then
		if (multi ~= false) then
			local names = {}
			for n, qID in pairs(qIDs) do
				local name = SearchEndNPC(qID);
				if (name) then
					local done = false;
					for n, nameIn in pairs(names) do
						if (name == nameIn) then 
							done = true;
						end
					end
					if not (done) then
						table.insert(names, name);
					end
				end
			end
			if (table.getn(names) > 0) then
				for n, name in pairs(names) do
					commentTitle = "END: "..questTitle.." - "..n.."/"..table.getn(names).." NPCs";
					GetNPCNotes(name, commentTitle, name.."\n("..multi.." quests with this name)", 2, questTitle);
				end
			end
			return true;
		elseif (multi == false) then
			local name = SearchEndNPC(qIDs);
			return GetNPCNotes(name, "END: "..questTitle, name, 2, questTitle);
		end
	else
		return false;
	end
end

function GetQuestIDs(questName, objectives)
	local qIDs = {};
	if (questObjectives == nil) then questObjectives = ''; end
	-- C debug
	DEFAULT_CHAT_FRAME:AddMessage("questName: "..questName);
	DEFAULT_CHAT_FRAME:AddMessage("objectives text: "..objectives);
	
	if ((qData[WHDB_Player_Faction][questName] ~= nil)) then
		for n, o in pairs(qData[WHDB_Player_Faction][questName]['IDs']) do
			table.insert(qIDs, n);
		end
	end
	
	if((qData['Common'][questName] ~= nil)) then
		for n, o in pairs(qData['Common'][questName]['IDs']) do
			table.insert(qIDs, n);
		end
	end
	
	--[[
	if ((qData[WHDB_Player_Faction][questName] ~= nil) and (objectives == '')) then
		for n, o in pairs(qData[WHDB_Player_Faction][questName]['IDs']) do
			table.insert(qIDs, n);
		end
	elseif((qData[WHDB_Player_Faction][questName] ~= nil) and (objectives ~= '')) then
		for n, o in pairs(qData[WHDB_Player_Faction][questName]['IDs']) do
			if (o == objectives) then table.insert(qIDs, n); end
		end
	end
	if ((qData['Common'][questName] ~= nil) and (objectives == '')) then
		for n, o in pairs(qData['Common'][questName]['IDs']) do
			table.insert(qIDs, n);
		end
	elseif((qData['Common'][questName] ~= nil) and (objectives ~= '')) then
		for n, o in pairs(qData['Common'][questName]['IDs']) do
			if (o == objectives) then table.insert(qIDs, n); end
		end
	end
	]]--
	-- C debug
	-- C DEFAULT_CHAT_FRAME:AddMessage("Possible questIDs: "..table.getn(qIDs));
	length = table.getn(qIDs);
	if (length == nil) then return false, false;
	elseif (length == 1) then return false, qIDs[1];
	else return length, qIDs; end
end

function GetNPCID(npcName)
	for npcid, data in pairs(npcData) do
		if (data['name'] == npcName) then return npcid; end
	end
end

function SwitchWP()
	if (WHDB_Settings[WHDB_Player]["waypoints"] == 0) then
		WHDB_Settings[WHDB_Player]["waypoints"] = 1;
		WHDB_Print("Waypoint plotting enabled.");
	else
		WHDB_Settings[WHDB_Player]["waypoints"] = 0;
		WHDB_Print("Waypoint plotting disabled.");
	end
end

-- C tries to get locations for an NPC and inserts them in WHDB_MAP_NOTES if found
function GetNPCNotes(npcName, commentTitle, comment, icon, questTitle)
	if (npcName ~= nil) then
		npcID = GetNPCID(npcName);
		if (npcData[npcID] ~= nil) then
			if (npcData[npcID]["zone"] ~= nil) then
				zoneName = zoneData[npcData[npcID]["zone"]];
			-- C elseif just kept in case it was needed for something I missed
			elseif (questTitle ~= nil) then
				zoneName = WHDB_QuestZoneInfo[questTitle];
			else
				return false;
			end
			local showMap = false;
			if (npcData[npcID]["waypoints"] and WHDB_Settings[WHDB_Player]["waypoints"] == 1) then
				for zoneID, coordsdata in pairs(npcData[npcID]["waypoints"]) do
					zoneName = zoneData[zoneID]
					for cID, coords in pairs(coordsdata) do
						coordx = coords[1]
						coordy = coords[2]
						table.insert(WHDB_MAP_NOTES,{zoneName, coordx, coordy, commentTitle, "|cFF0000FFWaypoint|r\n"..comment, 3});
						showMap = true;
					end
				end
			end
			if (npcData[npcID]["zones"]) then
				for zoneID, coordsdata in pairs(npcData[npcID]["zones"]) do
					if (zoneID ~= 5 and zoneID ~= 6) then
						zoneName = zoneData[zoneID]
						for cID, coords in pairs(coordsdata) do
							coordx = coords[1]
							coordy = coords[2]
							table.insert(WHDB_MAP_NOTES,{zoneName, coordx, coordy, commentTitle, comment, icon});
							showMap = true;
						end
					end
				end
			end
			return showMap;
		end
	end
	return false;
end

function GetQuestNotes(questLogID)
	local questTitle, level, questTag, isHeader, isCollapsed, isComplete = GetQuestLogTitle(questLogID);
	-- C debug
	-- C DEFAULT_CHAT_FRAME:AddMessage(questTitle);
	-- C DEFAULT_CHAT_FRAME:AddMessage(isComplete);
	local showMap = false;
	if (not header and questTitle ~= nil) then
		local numObjectives = GetNumQuestLeaderBoards(questLogID);
		-- C debug
		-- C DEFAULT_CHAT_FRAME:AddMessage(numObjectives);
		if (numObjectives ~= nil) then
			local monsterName, zoneName, noteAdded, showMap, noteID;
			for i=1, numObjectives, 1 do
				local text, type, finished = GetQuestLogLeaderBoard(i, questLogID);
				local i, j, itemName, numItems, numNeeded = strfind(text, "(.*):%s*([%d]+)%s*/%s*([%d]+)");
				if (not finished) then
					if (type == "monster") then
						local i, j, monsterName = strfind(itemName, "(.*) slain");
						showMap = GetNPCNotes(monsterName, questTitle, monsterName.."\n"..GetNPCStatsComment(monsterName), 0, questTitle) or showMap;
					elseif (type == "item") then
						if (itemData[itemName] ~= nil) then
							for monsterName, monsterDrop in pairs(itemData[itemName]) do
								local comment = monsterName..": "..itemName.."\n"..GetNPCDropComment(itemName, monsterName).."\n"..GetNPCStatsComment(monsterName);
								showMap = GetNPCNotes(monsterName, questTitle, comment, 0, questTitle) or showMap;
							end
						end
					-- C check for objective type other than item or monster, e.g. objective, reputation, event
					elseif (type ~= "item" and type ~= "monster") then
						-- C debug
						DEFAULT_CHAT_FRAME:AddMessage(type.." quest objective-type not supported yet by WHDB");
					end
				end
			end
			if ((not isComplete) and (numObjectives ~= 0)) then 
				showMap = GetCommentNotes(questTitle) or showMap;
			end
		end
		-- C added numObjectives condition due to some quests not showing "isComplete" though having nothing to do but turn it in
		-- C debug
		-- C DEFAULT_CHAT_FRAME:AddMessage("numObjectives: "..numObjectives);
		if (isComplete or numObjectives == 0) then
			GetQuestEndNotes(questLogID);
		end
	end
	return showMap;
end

-- C returns level and hp values with prefix for provided NPC name as string
function GetNPCStatsComment(npcName)
	npcID = GetNPCID(npcName)
	local level = npcData[npcID]["level"];
	local hp = npcData[npcID]["hp"];
	if (level == nil) then
		level = "Unknown";
	end
	if (hp == nil) then
		hp = "Unknown";
	end
	return "Level: "..level.."\nHealth: "..hp;
end

-- C returns dropRate value with prefix for provided NPC name as string
function GetNPCDropComment(itemName, npcName)
	local dropRate = itemData[itemName][npcName];
	if (dropRate == "" or dropRate == nil) then
		dropRate = "Unknown";
	end
	return "Drop chance: "..dropRate.."%";
end

-- C breaks comments (inserts a new line character) on every last space in 80 chars
-- C TODO: invisible (to player) characters are counted, e.g. text coloring
-- C minor bug though, at least compared to before
function LineFeedComment(comment)
	if (string.len(comment) > 80) then
		temp = {};
		pointer = 1;
		while (string.len(string.sub(comment, pointer)) > 80) do
			local space = string.find(comment, "%s", pointer + 70);
			if (space ~= nil) then
				table.insert(temp, string.sub(comment, pointer, space-1));
				pointer =  1 + space;
			else
				break;
			end
		end
		table.insert(temp, string.sub(comment, pointer));
		local s = table.concat(temp, "\n");
		return s;
	else
		return comment;
	end
end

function GetCommentNotes(questName)
	if (qData[WHDB_Player_Faction][questName]) then
		questKind = qData[WHDB_Player_Faction];
	elseif (qData['Common'][questName]) then
		questKind = qData['Common'];
	else
		questKind = nil;
		return false;
	end
	local showMap = false;
	for id, comment in ipairs(questKind[questName]['comments']) do
		local f = 0;
		while f ~= nil do
			f, t, coordx, coordy = strfind(comment, "%[([0-9]*) ([0-9]*)%]", f+1);
			if (coordx ~= nil and coordy ~= nil) then
				WHDB_PopulateZones();
				if (WHDB_QuestZoneInfo[questName] ~= nil) then
					if (WHDB_GetMapIDFromZone(WHDB_QuestZoneInfo[questName]) ~= -1) then
						table.insert(WHDB_MAP_NOTES,{WHDB_QuestZoneInfo[questName], coordx, coordy, questName, LineFeedComment(comment), 1});
						showMap = true;
					end
				end
			end
		end
	end
	return showMap
end

-- C from http://stackoverflow.com/questions/2705793/how-to-get-number-of-entries-in-a-lua-table
function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end
