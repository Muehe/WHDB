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
WHDB_Debug = 2;
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

function WHDB_OnMouseDown(arg1)
	if (arg1 == "LeftButton") then
		WHDB_Frame:StartMoving();
	end
end
function WHDB_OnMouseUp(arg1)
	if (arg1 == "LeftButton") then
		WHDB_Frame:StopMovingOrSizing();
	end
end
function WHDB_OnFrameShow()
	
end

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
		if (WHDB_Debug == 2) then 
			DEFAULT_CHAT_FRAME:AddMessage("Event: PLAYER_LOGIN");
		end
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
		if (WHDB_Debug == 2) then 
			DEFAULT_CHAT_FRAME:AddMessage(string.gsub(stringX, "2", "Male"));
		end
		
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
			WHDB_Settings[WHDB_Player]["waypoints"] = 1;
			WHDB_Settings[WHDB_Player]["commentNotes"] = 1;
			WHDB_Settings[WHDB_Player]["updateNotes"] = 0;
			WHDB_Settings[WHDB_Player]["sortOverlay"] = 1;
		else
			if (WHDB_Settings[WHDB_Player] == nil) then
				WHDB_Settings[WHDB_Player] = {};
				WHDB_Settings[WHDB_Player]["UseColors"] = 1;
				WHDB_Settings[WHDB_Player]["auto_plot"] = 0;
				WHDB_Settings[WHDB_Player]["waypoints"] = 1;
				WHDB_Settings[WHDB_Player]["commentNotes"] = 1;
				WHDB_Settings[WHDB_Player]["updateNotes"] = 0;
				WHDB_Settings[WHDB_Player]["sortOverlay"] = 1;
			end
		end
		-- New version settings update
		-- C default to 0, autoplot doesn't work on login (tough strangely on /rl it would)
		if (WHDB_Settings[WHDB_Player]["auto_plot"] == 1) then
			WHDB_Settings[WHDB_Player]["auto_plot"] = 0;
		end
		if (WHDB_Settings[WHDB_Player]["waypoints"] == nil) then
			WHDB_Settings[WHDB_Player]["waypoints"] = 1;
		end
		if (WHDB_Settings[WHDB_Player]["commentNotes"] == nil) then
			WHDB_Settings[WHDB_Player]["commentNotes"] = 1;
		end
		if (WHDB_Settings[WHDB_Player]["updateNotes"] == nil) then
			WHDB_Settings[WHDB_Player]["updateNotes"] = 0;
		end
		if (WHDB_Settings[WHDB_Player]["sortOverlay"] == nil) then
			WHDB_Settings[WHDB_Player]["sortOverlay"] = 1;
		end
		-- WHDB if (WHDB_Settings[WHDB_Player]["auto_plot"] == 1) then
		-- WHDB 	WHDB_PlotAllQuests();
		-- WHDB end
		WHDB_Frame:Show();
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
	-- C elseif (event == "QUEST_WATCH_UPDATE") and (WHDB_Settings[WHDB_Player]["updateNotes"] == 1) then
		-- C WHDB_Print("QUEST_WATCH_UPDATE");
		-- C WHDB_PlotUpdate = 1;
	elseif (event == "QUEST_LOG_UPDATE") then
		if (WHDB_Settings[WHDB_Player]["auto_plot"] == 1) then
			if (WHDB_Debug == 2) then
				DEFAULT_CHAT_FRAME:AddMessage("Event: QUEST_LOG_UPDATE");
			end
			WHDB_Print("Plots updated.");
			WHDB_PlotAllQuests();
		end
	-- C elseif ((event == "UNIT_QUEST_LOG_CHANGED") and (WHDB_Settings[WHDB_Player]["updateNotes"] == 1)) then
		-- C WHDB_Print("UNIT_QUEST_LOG_CHANGED");
		-- C if (WHDB_Settings[WHDB_Player]["auto_plot"] == 1 and arg1 == "player") then
		-- C 	WHDB_PlotUpdate = 1;
		-- C end
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
		WHDB_Print("/whdb mob <npc name> | Show NPC location on map.");
		WHDB_Print("/whdb obj <object name> | Show object location on map.");
		WHDB_Print("/whdb clean | Clean map notes.");
		WHDB_Print("/whdb colors | Enable/Disable: Coloring of text in the quest log.");
		WHDB_Print("/whdb auto | Enable/Disable: Automatically plot uncompleted objectives on map.");
		WHDB_Print("/whdb waypoint | Enable/Disable: Plot waypoints on map.");
		WHDB_Print("/whdb cnotes | Enable/Disable: Plot comments on map.");
		WHDB_Print("/whdb update | Enable/Disable: Automatically update notes. (Very slow right now)");
		WHDB_Print("/whdb copy <character> | Copy characters config to current one.");
		WHDB_Print("/whdb reset | Reset positon of the Interface.");
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
			local QuestComments = WHDB_GetComments(questName, '');
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
					if (npcData[npcID] ~= nil) then
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
					else
						WHDB_Print("No data for NPC named "..monsterName);
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
	elseif (string.sub(input,1,3) == "obj") then
		local objName = string.sub(input, 5);
		if (objName ~= "") then
			WHDB_Print("Locations for: "..objName);
			if (objName ~= nil) then
				if (GetObjNotes(objName, objName, "This object can be found here", 0)) then
					WHDB_ShowMap();
				else
					WHDB_Print("No locations found.");
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
		SwitchSetting("auto_plot");
	elseif (string.sub(input,1,8) == "waypoint") then
		SwitchSetting("waypoints");
	elseif (string.sub(input,1,6) == "cnotes") then
		SwitchSetting("commentNotes");
	elseif (string.sub(input,1,6) == "update") then
		SwitchSetting("updateNotes");
	elseif (string.sub(input,1,5) == "reset") then
		WHDB_Frame:SetPoint("TOPLEFT", 0, 0);
	-- C disable else 
		-- C disable if (input == nil) then input = ""; end
		-- C disable WHDB_Print("Unknown command: \""..input.."\"");
	end
end

function WHDB_PlotAllQuests()
	if (WHDB_Debug > 0) then 
		DEFAULT_CHAT_FRAME:AddMessage("WHDB_PlotAllQuests() called");
	end
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
	DEFAULT_CHAT_FRAME:AddMessage("|cAA0000FFC-WHDB:|r " .. string, 0.95, 0.95, 0.5);
end

function WHDB_Print_Indent( string )
	DEFAULT_CHAT_FRAME:AddMessage("					   " .. string, 0.95, 0.95, 0.5);
end

-- C New Icons from mpq files
Cartographer_Notes:RegisterIcon("QuestionMark", {
    text = "QuestionMark",
    path = "Interface\\GossipFrame\\ActiveQuestIcon",
	width = 16,
	height = 16,
})
Cartographer_Notes:RegisterIcon("NPC", {
    text = "NPC",
    path = "Interface\\WorldMap\\WorldMapPartyIcon",
	width = 8,
	height = 8,
})
Cartographer_Notes:RegisterIcon("Waypoint", {
    text = "Waypoint",
    path = "Interface\\WorldMap\\WorldMapPlayerIcon",
	width = 8,
	height = 8,
})

function WHDB_PlotNotesOnMap()
	if (WHDB_Debug > 0) then 
		DEFAULT_CHAT_FRAME:AddMessage("WHDB_PlotNotesOnMap() called");
	end
	if (WHDB_Settings[WHDB_Player]["sortOverlay"] == 1) then
		sortOverlayingMapNotes();
	end
	
	local zone = nil;
	local title = nil;
	local noteID = nil;
	
	local firstNote = 1;
	
	for nKey, nData in ipairs(WHDB_MAP_NOTES) do
		-- C nData[1] is zone name/number
		-- C nData[2] is x coordinate
		-- C nData[3] is y coordinate
		-- C nData[4] is comment title
		-- C nData[5] is comment body
		-- C nData[6] is icon number
		-- C debug
		-- C WHDB_Print(nData[1].."\n"..nData[2]..":"..nData[3].."\n"..nData[4].."\n"..nData[5]);
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
				Cartographer_Notes:SetNote(nData[1], nData[2]/100, nData[3]/100, "QuestionMark", "WHDB", 'title', nData[4], 'info', nData[5]);
			elseif (nData[6] == 3) then
				Cartographer_Notes:SetNote(nData[1], nData[2]/100, nData[3]/100, "Waypoint", "WHDB", 'title', nData[4], 'info', nData[5]);
			elseif (nData[6] == 4) then
				Cartographer_Notes:SetNote(nData[1], nData[2]/100, nData[3]/100, "Cross", "WHDB", 'title', nData[4], 'info', nData[5]);
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
	if table.getn(WHDB_MAP_NOTES) ~= nil then
		WHDB_Print(table.getn(WHDB_MAP_NOTES).." notes plotted.")
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

function WHDB_GetComments(questTitle, questObjectives)
	-- C Update for new functionality
	local multi, qIDs = GetQuestIDs(questTitle, questObjectives);
	local questCom = "";
	if (qIDs) then
		if (qData[WHDB_Player_Faction][questTitle] ~= nil) then
			for id, oc in pairs(qData[WHDB_Player_Faction][questTitle]['IDs']) do
				if (oc[2] ~= nil) then
					for n, comment in pairs(oc[2]) do
						questCom = questCom .. comment .."\n____________________\n"; 
					end
				end
			end
		end
		if (qData['Common'][questTitle] ~= nil) then
			for id, oc in pairs(qData['Common'][questTitle]['IDs']) do
				if (oc[2] ~= nil) then
					for n, comment in pairs(oc[2]) do
						questCom = questCom .. comment .."\n____________________\n"; 
					end
				end
			end
		end
		if (questCom == "") then
			questCom = "No comments for this quest.\n\n";
		end
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
	WHDB_Print("Map cleaned.");
end

function WHDB_DoCleanMap()
	if (WHDB_Settings[WHDB_Player]["auto_plot"] == 1) then
		WHDB_Settings[WHDB_Player]["auto_plot"] = 0;
		CheckSetting("auto_plot")
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
	if (WHDB_Debug > 0) then 
		DEFAULT_CHAT_FRAME:AddMessage("SearchEndNPC("..quest..") called");
	end
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

-- C ######################## new functions below here ########################

function sortOverlayingMapNotes()
	local ICONS_TEXT = {
		[0] = '',
		[1] = '',
		[2] = '',
		[3] = ''
	};
	if (WHDB_MAP_NOTES ~= {}) then
		local notes = {};
		local doneIndex = {};
		for n, nData in pairs(WHDB_MAP_NOTES) do
			local done = false;
			for index, number in pairs(doneIndex) do
				if (number == n) then done = true; end
			end
			if not (done) then
			-- C legacy check, shouldn't be needed
			if type(nData[1]) == number then
				nData[1] = zoneData[nData[1]]
			end
			-- C nData[1] = zone name, nData[2] = x coordinate, nData[3] = y coordinate, nData[4] = comment title, nData[5] = comment body, nData[6] = icon number
			table.insert(doneIndex, n);
			local temp = {};
			local multi = false;
			local icon = nData[6]
			
			-- C check for overlaying notes
			for n2, nData2 in pairs(WHDB_MAP_NOTES) do
				local done = false;
				for index, number in pairs(doneIndex) do
					if (number == n2) then done = true; end
				end
				if not (done) then
					-- C determine here which notes should be merged, only exact match right now
					if ((nData[1] == nData2[1]) and (nData[2] == nData2[2]) and (nData[3] == nData2[3])) then
						table.insert(temp, nData2);
						table.insert(doneIndex, n2);
						multi = true;
						if ( nData[6] ~= nData2[6]) then icon = 4; end
					end
				end
			end
			
			-- C merge tooltip displays
			if (multi) then
				local zone = nData[1];
				local x = nData[2];
				local y = nData[3];
				local length = table.getn(temp) + 1;
				local commentTitle = "Showing "..length.." notes for this coordinates";
				local comment = ICONS_TEXT[nData[6]]..nData[4]..":\n"..nData[5].."\n_____________\n";
				for n, nData3 in pairs(temp) do
					comment = comment.."\n"..ICONS_TEXT[nData3[6]]..nData3[4]..":\n"..nData3[5].."\n_____________";
				end
				local merge = {nData[1], nData[2], nData[3], commentTitle, comment, icon}
				table.insert(notes, merge);
			-- C single tooltip
			else
				table.insert(notes, nData);
			end
			end
		end
		WHDB_MAP_NOTES = notes;
	end
end

-- C ingame test
-- C /script GetQuestEndNotes(2); WHDB_PlotNotesOnMap();

function GetQuestEndNotes(questLogID)
	if (WHDB_Debug > 0) then 
		DEFAULT_CHAT_FRAME:AddMessage("GetQuestEndNotes("..questLogID..") called");
	end
	local questTitle = GetQuestLogTitle(questLogID);
	SelectQuestLogEntry(questLogID);
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
				if (table.getn(names) > 1) then
					for n, name in pairs(names) do
						local commentTitle = "END: "..questTitle.." - "..n.."/"..table.getn(names).." NPCs";
						local comment = name.."\n("..multi.." quests with this name)"
						GetNPCNotes(name, commentTitle, comment, 2, questTitle);
					end
				else
					local name = names[1]
					local comment = name.."\n(Ends "..multi.." quests with this name)"
					return GetNPCNotes(name, "END: "..questTitle, comment, 2, questTitle);
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

-- C TODO check objectives text
function GetQuestIDs(questName, objectives)
	local qIDs = {};
	if (objectives == nil) then objectives = ''; end
	-- C debug
	if (WHDB_Debug > 0) then
		DEFAULT_CHAT_FRAME:AddMessage("GetQuestIDs("..questName..", "..objectives..")");
	end
	
	if ((qData[WHDB_Player_Faction][questName] ~= nil) and (objectives == '')) then
		for n, o, c in pairs(qData[WHDB_Player_Faction][questName]['IDs']) do
			table.insert(qIDs, n);
		end
	elseif((qData[WHDB_Player_Faction][questName] ~= nil) and (objectives ~= '')) then
		for n, o in pairs(qData[WHDB_Player_Faction][questName]['IDs']) do
			if (o[1] == objectives) then table.insert(qIDs, n); end
		end
	end
	if ((qData['Common'][questName] ~= nil) and (objectives == '')) then
		for n, o, c in pairs(qData['Common'][questName]['IDs']) do
			table.insert(qIDs, n);
		end
	elseif((qData['Common'][questName] ~= nil) and (objectives ~= '')) then
		for n, o in pairs(qData['Common'][questName]['IDs']) do
			if (o[1] == objectives) then table.insert(qIDs, n); end
		end
	end
	if (table.getn(qIDs) == 0) then
		if ((qData[WHDB_Player_Faction][questName] ~= nil)) then
			for n, o, c in pairs(qData[WHDB_Player_Faction][questName]['IDs']) do
				table.insert(qIDs, n);
			end
		end
	
		if((qData['Common'][questName] ~= nil)) then
			for n, o, c in pairs(qData['Common'][questName]['IDs']) do
				table.insert(qIDs, n);
			end
		end
	end
	-- C debug
	if (WHDB_Debug == 2) then
		DEFAULT_CHAT_FRAME:AddMessage("Possible questIDs: "..table.getn(qIDs));
	end
	length = table.getn(qIDs);
	if (length == nil) then return false, false;
	elseif (length == 1) then return false, qIDs[1];
	else return length, qIDs; end
end

-- C TODO 19 npc names are used twice. first found is chosen atm
function GetNPCID(npcName)
	if (WHDB_Debug > 0) then 
		DEFAULT_CHAT_FRAME:AddMessage("GetNPCID("..npcName..") called");
	end
	for npcid, data in pairs(npcData) do
		if (data['name'] == npcName) then return npcid; end
	end
	return false;
end

function GetObjID(objName)
	local objIDs = {};
	for objID, data in pairs(objData) do
		if (data['name'] == objName) then 
			table.insert(objIDs, objID);
		end
	end
	
	if objIDs == {} then return false;
	else return objIDs;
	end
end

function SwitchSetting(setting)
	text = {
		["waypoints"] = "Waypoint plotting",
		["updateNotes"] = "Automatic note updating",
		["auto_plot"] = "Auto plotting",
		["sortOverlay"] = "Merge Overlay",
	};
	if (WHDB_Settings[WHDB_Player][setting] == 0) then
		WHDB_Settings[WHDB_Player][setting] = 1;
		WHDB_Print(text[setting].." enabled.");
	else
		WHDB_Settings[WHDB_Player][setting] = 0;
		WHDB_Print(text[setting].." disabled.");
	end
end

function CheckSetting(setting)
	if (WHDB_Settings[WHDB_Player][setting] == 1) then
		getglobal(setting):SetChecked(true);
	else
		getglobal(setting):SetChecked(false);
	end
end

-- C tries to get locations for an NPC and inserts them in WHDB_MAP_NOTES if found
function GetNPCNotes(npcName, commentTitle, comment, icon, questTitle)
	if (npcName ~= nil) then
		if (WHDB_Debug > 0) then 
			DEFAULT_CHAT_FRAME:AddMessage("GetNPCNotes("..npcName..") called");
		end
		npcID = GetNPCID(npcName);
		if (npcData[npcID] ~= nil) then
			local showMap = false;
			if (npcData[npcID]["waypoints"] and WHDB_Settings[WHDB_Player]["waypoints"] == 1) then
				for zoneID, coordsdata in pairs(npcData[npcID]["waypoints"]) do
					zoneName = zoneData[zoneID];
					for cID, coords in pairs(coordsdata) do
						if (coords[1] == -1) then
								for id, data in pairs(instanceData[zoneID]) do
									noteZone = zoneData[data[1]];
									coordx = data[2];
									coordy = data[3];
									table.insert(WHDB_MAP_NOTES,{noteZone, coordx, coordy, commentTitle, "|cFF00FF00Instance Entry to "..zoneName.."|r\n"..comment, icon});
								end
								break;
							end
						coordx = coords[1];
						coordy = coords[2];
						table.insert(WHDB_MAP_NOTES,{zoneName, coordx, coordy, commentTitle, "|cFF0000FFWaypoint|r\n"..comment, 3});
						showMap = true;
					end
				end
			end
			if (npcData[npcID]["zones"]) then
				for zoneID, coordsdata in pairs(npcData[npcID]["zones"]) do
					if (zoneID ~= 5 and zoneID ~= 6) then
						zoneName = zoneData[zoneID];
						for cID, coords in pairs(coordsdata) do
							if (coords[1] == -1) then
								for id, data in pairs(instanceData[zoneID]) do
									noteZone = zoneData[data[1]];
									coordx = data[2];
									coordy = data[3];
									table.insert(WHDB_MAP_NOTES,{noteZone, coordx, coordy, commentTitle, "|cFF00FF00Instance Entry to "..zoneName.."|r\n"..comment, icon});
								end
								break;
							end
							coordx = coords[1];
							coordy = coords[2];
							table.insert(WHDB_MAP_NOTES,{zoneName, coordx, coordy, commentTitle, "|cFF00FF00Spawnpoint|r\n"..comment, icon});
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

-- C tries to get locations for an (ingame) object and inserts them in WHDB_MAP_NOTES if found
function GetObjNotes(objName, commentTitle, comment, icon, questTitle)
	if (objName ~= nil) then
		objIDs = GetObjID(objName); -- C TODO
		local showMap = false;
		local count = 0;
		for n, objID in pairs(objIDs) do
			if (objData[objID] ~= nil) then
				if (objData[objID]["zones"]) then
					for zoneID, coordsdata in pairs(objData[objID]["zones"]) do
						if (zoneID ~= 5 and zoneID ~= 6) then -- C legacy, unused, kept for future (world map coords)
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
			end
		end
		return showMap;
	end
	return false;
end

function GetQuestNotes(questLogID)
	-- C debug
	if (WHDB_Debug >0) then
		DEFAULT_CHAT_FRAME:AddMessage("GetQuestNotes("..questLogID..") called");
	end
	local questTitle, level, questTag, isHeader, isCollapsed, isComplete = GetQuestLogTitle(questLogID);
	-- C debug
	if (WHDB_Debug == 2) then 
		if (questTitle ~= nil) then
			DEFAULT_CHAT_FRAME:AddMessage("    questTitle = "..questTitle);
		end
		if (isComplete ~= nil) then
			DEFAULT_CHAT_FRAME:AddMessage("    isComplete = "..isComplete);
		end
	end
	local showMap = false;
	if (not isHeader and questTitle ~= nil) then
		local numObjectives = GetNumQuestLeaderBoards(questLogID);
		-- C debug
		if (WHDB_Debug == 2) then
			if (numObjectives ~= nil) then
				DEFAULT_CHAT_FRAME:AddMessage("    numObjectives = "..numObjectives);
			end
		end
		if (numObjectives ~= nil) then
			for i=1, numObjectives, 1 do
				local text, type, finished = GetQuestLogLeaderBoard(i, questLogID);
				local i, j, itemName, numItems, numNeeded = strfind(text, "(.*):%s*([%d]+)%s*/%s*([%d]+)");
				if (not finished) then
					if (type == "monster") then
						if (WHDB_Debug == 2) then
							DEFAULT_CHAT_FRAME:AddMessage("    type = monster");
						end
						local i, j, monsterName = strfind(itemName, "(.*) slain");
						showMap = GetNPCNotes(monsterName, questTitle, monsterName.."\n"..GetNPCStatsComment(monsterName), 0, questTitle) or showMap;
					elseif (type == "item") then
						if (WHDB_Debug == 2) then
							DEFAULT_CHAT_FRAME:AddMessage("    type = item");
						end
						if (itemData[itemName] ~= nil) then
							for monsterName, monsterDrop in pairs(itemData[itemName]) do
								local comment = monsterName..": "..itemName.."\n"..GetNPCDropComment(itemName, monsterName).."\n"..GetNPCStatsComment(monsterName);
								showMap = GetNPCNotes(monsterName, questTitle, comment, 0, questTitle) or showMap;
							end
						end
					-- C checks for objective type other than item or monster, e.g. objective, reputation, event
					--elseif (type == "object") then
						--GetObjNotes(itemName, questTitle, comment, icon, questTitle);
					elseif (type ~= "item" and type ~= "monster") then
						-- C debug
						if (WHDB_Debug == 2) then 
							DEFAULT_CHAT_FRAME:AddMessage("    "..type.." quest objective-type not supported yet");
						end
					end
				end
			end
		end
		-- C added numObjectives condition due to some quests not showing "isComplete" though having nothing to do but turn it in
		if (isComplete or numObjectives == 0) then
			GetQuestEndNotes(questLogID);
		end
	end
	return showMap;
end

-- C returns level and hp values with prefix for provided NPC name as string
function GetNPCStatsComment(npcName)
	npcID = GetNPCID(npcName)
	if (npcData[npcID] ~= nil) then
		local level = npcData[npcID]["level"];
		local hp = npcData[npcID]["hp"];
		if (level == nil) then
			level = "Unknown";
		end
		if (hp == nil) then
			hp = "Unknown";
		end
		return "Level: "..level.."\nHealth: "..hp;
	else
		return "NPC not found: "..npcName;
	end
end

-- C returns dropRate value with prefix for provided NPC name as string
function GetNPCDropComment(itemName, npcName)
	local dropRate = itemData[itemName][npcName];
	if (dropRate == "" or dropRate == nil) then
		dropRate = "Unknown";
	end
	return "Drop chance: "..dropRate.."%";
end

-- C from http://stackoverflow.com/questions/2705793/how-to-get-number-of-entries-in-a-lua-table
function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end
