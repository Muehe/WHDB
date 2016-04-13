--------------------------------------------------------
-- Wowhead DB By: UniRing
--------------------------------------------------------
-- Wowhead DB Continued By: Muehe
--------------------------------------------------------

WHDB_Debug = 0;
WHDB_MAP_NOTES = {};
WHDB_QuestZoneInfo = {};
WHDB_Player = "";
WHDB_Player_Race = "";
WHDB_Player_Sex = "";
WHDB_Player_Class = "";
WHDB_Player_Faction = "";
WHDB_Version = "Continued WHDB for Classic WoW";

-- Cartographer related functions and variables

-- Overwriting these three seems unnecessary but WTH
Cartographer.options.args.LookNFeel.args.scale.max = 7; -- Cartographer default: 1
Cartographer.options.args.Notes.args.size.min = 0.05; -- 0.5
Cartographer.options.args.Notes.args.size.max = 5; -- 2

-- Add Alt-MouseWheel to Cartographer help
Cartographer:AddToMagnifyingGlass("Alt-MouseWheel to change icon size")

-- New Icons
Cartographer_Notes:RegisterIcon("QuestionMark", {
	text = "QuestionMark",
	path = "Interface\\GossipFrame\\ActiveQuestIcon",
	width = 8,
	height = 8,
})
Cartographer_Notes:RegisterIcon("ExclamationMark", {
	text = "ExclamationMark",
	path = "Interface\\GossipFrame\\AvailableQuestIcon",
	width = 8,
	height = 8,
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

-- Icons from ShaguDB, thanks fam.
-- Switched 3 and 7 for better contrast of colors follwing each other
cMark = "mk1";
Cartographer_Notes:RegisterIcon("mk1", {
	text = "Mark 1",
	path = "Interface\\AddOns\\ShaguDB\\symbols\\mk1",
	width = 8,
	height = 8,
})
Cartographer_Notes:RegisterIcon("mk2", {
	text = "Mark 2",
	path = "Interface\\AddOns\\ShaguDB\\symbols\\mk2",
	width = 8,
	height = 8,
})
Cartographer_Notes:RegisterIcon("mk3", {
	text = "Mark 3",
	path = "Interface\\AddOns\\ShaguDB\\symbols\\mk7",
	width = 8,
	height = 8,
})
Cartographer_Notes:RegisterIcon("mk4", {
	text = "Mark 4",
	path = "Interface\\AddOns\\ShaguDB\\symbols\\mk4",
	width = 8,
	height = 8,
})
Cartographer_Notes:RegisterIcon("mk5", {
	text = "Mark 5",
	path = "Interface\\AddOns\\ShaguDB\\symbols\\mk5",
	width = 8,
	height = 8,
})
Cartographer_Notes:RegisterIcon("mk6", {
	text = "Mark 6",
	path = "Interface\\AddOns\\ShaguDB\\symbols\\mk6",
	width = 8,
	height = 8,
})
Cartographer_Notes:RegisterIcon("mk7", {
	text = "Mark 7",
	path = "Interface\\AddOns\\ShaguDB\\symbols\\mk3",
	width = 8,
	height = 8,
})
Cartographer_Notes:RegisterIcon("mk8", {
	text = "Mark 8",
	path = "Interface\\AddOns\\ShaguDB\\symbols\\mk8",
	width = 8,
	height = 8,
})

function cycleMarks()
	if cMark == "mk1" then cMark = "mk2";
	elseif cMark == "mk2" then cMark = "mk3";
	elseif cMark == "mk3" then cMark = "mk4";
	elseif cMark == "mk4" then cMark = "mk5";
	elseif cMark == "mk5" then cMark = "mk6";
	elseif cMark == "mk6" then cMark = "mk7";
	elseif cMark == "mk7" then cMark = "mk8";
	elseif cMark == "mk8" then cMark = "mk1";
	end
end

function cycleMarksBack()
	if cMark == "mk1" then cMark = "mk8";
	elseif cMark == "mk2" then cMark = "mk7";
	elseif cMark == "mk3" then cMark = "mk6";
	elseif cMark == "mk4" then cMark = "mk5";
	elseif cMark == "mk5" then cMark = "mk4";
	elseif cMark == "mk6" then cMark = "mk3";
	elseif cMark == "mk7" then cMark = "mk2";
	elseif cMark == "mk8" then cMark = "mk1";
	end
end

-- Replacement for the script set by Cartographer_LookNFeel:OnEnable() for "OnMouseWheel"
function WHDB_MapScroll(...)
	-- This was in Cartographer. Slightly changed.
	local up = (arg1 == 1)

	if IsControlKeyDown() then
		local scale = Cartographer_LookNFeel:GetScale()
		if up then
			scale = scale + 0.1
			if scale > 10 then -- 1
				scale = 10 -- 1
			end
		else
			scale = scale - 0.1
			if scale < 0.2 then
				scale = 0.2
			end
		end
		Cartographer_LookNFeel:SetScale(scale)
	elseif IsShiftKeyDown() then
		local alpha = Cartographer_LookNFeel:GetAlpha()
		if up then
			alpha = alpha + 0.1
			if alpha > 1 then
				alpha = 1
			end
		else
			alpha = alpha - 0.1
			if alpha < 0 then
				alpha = 0
			end
		end
		Cartographer_LookNFeel:SetAlpha(alpha)
	-- This was not in Cartographer
	elseif IsAltKeyDown() then
		local size = Cartographer_Notes:GetIconSize()
		if up then
			size = size + 0.05
			if size > 5 then
				size = 5
			end
		else
			size = size - 0.05
			if size < 0.05 then
				size = 0.05
			end
		end
		Cartographer_Notes:SetIconSize(size)
	end
end -- WHDB_MapScroll(...)

function WHDB_OnMouseDown(arg1)
	if (arg1 == "LeftButton") then
		WHDB_Frame:StartMoving();
	end
end -- WHDB_OnMouseDown(arg1)

function WHDB_OnMouseUp(arg1)
	if (arg1 == "LeftButton") then
		WHDB_Frame:StopMovingOrSizing();
	end
end -- WHDB_OnMouseUp(arg1)

function WHDB_OnFrameShow()
	-- ?
end-- WHDB_OnFrameShow()

function WHDB_Init()
	this:RegisterEvent("PLAYER_LOGIN");
	this:RegisterEvent("QUEST_WATCH_UPDATE");
	this:RegisterEvent("QUEST_LOG_UPDATE");
	this:RegisterEvent("UNIT_QUEST_LOG_CHANGED");
	this:RegisterEvent("WORLD_MAP_UPDATE");
	SlashCmdList["WHDB"] = WHDB_Slash;
	SLASH_WHDB1 = "/whdb";
end -- WHDB_Init()

function WHDB_Event(event, arg1)
	if (WHDB_Debug > 0) then
		if event then
			DEFAULT_CHAT_FRAME:AddMessage("WHDB_Event("..event..", arg1) called");
		else
			DEFAULT_CHAT_FRAME:AddMessage("WHDB_Event(event, arg1) called");
		end
	end
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
		-- Replace Cartographer mouse wheel script
		WorldMapFrame:SetScript("OnMouseWheel", WHDB_MapScroll)
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
		WHDB_Player = UnitName("player");
		WHDB_Player_Race = UnitRace("player");
		WHDB_Player_Sex = UnitSex("player");
		WHDB_Player_Class = UnitClass("player");
		stringX = WHDB_Player_Race..WHDB_Player_Sex..WHDB_Player_Class;
		if (WHDB_Debug == 2) then 
			DEFAULT_CHAT_FRAME:AddMessage(string.gsub(stringX, "2", "Male"));
		end
		if (WHDB_Settings == nil) then
			WHDB_Settings = {};
			WHDB_Settings[WHDB_Player] = {};
			if (Cartographer_Notes ~= nil) then
				WHDB_Settings[WHDB_Player]["auto_plot"] = 1;
			else
				WHDB_Settings[WHDB_Player]["auto_plot"] = 0;
			end
			WHDB_Settings[WHDB_Player]["waypoints"] = 1;
		else
			if (WHDB_Settings[WHDB_Player] == nil) then
				WHDB_Settings[WHDB_Player] = {};
				WHDB_Settings[WHDB_Player]["auto_plot"] = 0;
				WHDB_Settings[WHDB_Player]["waypoints"] = 1;
			end
		end
		if (WHDB_Settings[WHDB_Player]["auto_plot"] == 1) then
			WHDB_Settings[WHDB_Player]["auto_plot"] = 0;
		end
		if (WHDB_Settings[WHDB_Player]["waypoints"] == nil) then
			WHDB_Settings[WHDB_Player]["waypoints"] = 1;
		end
		if (WHDB_Settings[WHDB_Player]["starts"] == nil) then
			WHDB_Settings[WHDB_Player]["starts"] = 1;
		end
		WHDB_Frame:Show();
		WHDB_Print("WHDB Loaded.");
	elseif (event == "QUEST_LOG_UPDATE") then
		if (WHDB_Settings[WHDB_Player]["auto_plot"] == 1) then
			if (WHDB_Debug == 2) then
				DEFAULT_CHAT_FRAME:AddMessage("Event: QUEST_LOG_UPDATE");
			end
			WHDB_Print("Plots updated.");
			WHDB_PlotAllQuests();
		end
	elseif (event == "WORLD_MAP_UPDATE") and (WorldMapFrame:IsVisible()) and (WHDB_Settings[WHDB_Player]["starts"] == 1) then
		if (WHDB_Debug == 2) then
			DEFAULT_CHAT_FRAME:AddMessage(zone);
		end
		GetQuestStartNotes();
	end
end -- WHDB_Event(event, arg1)

function WHDB_ShowUsingInfo()
	if (Cartographer_Notes ~= nil) then
		WHDB_Print("Cartographer plotter enabled.");
	end
end -- WHDB_ShowUsingInfo()

function WHDB_Slash(input)
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
		WHDB_Print("/whdb auto | Enable/Disable: Automatically plot uncompleted objectives on map.");
		WHDB_Print("/whdb waypoint | Enable/Disable: Plot waypoints on map.");
		WHDB_Print("/whdb starts | Enable/Disable: Plot quest starts on map.");
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
	elseif (string.sub(input,1,6) == "starts") then
		SwitchSetting("starts");
	elseif (string.sub(input,1,5) == "reset") then
		WHDB_Frame:SetPoint("TOPLEFT", 0, 0);
		WHDB_Frame:Show();
	end
end -- WHDB_Slash(input)

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
end -- WHDB_PlotAllQuests()

function WHDB_Print( string )
	DEFAULT_CHAT_FRAME:AddMessage("|cAA0000FFC-WHDB:|r " .. string, 0.95, 0.95, 0.5);
end -- WHDB_Print( string )

function WHDB_Print_Indent( string )
	DEFAULT_CHAT_FRAME:AddMessage("					   " .. string, 0.95, 0.95, 0.5);
end -- WHDB_Print_Indent( string )

function WHDB_PlotNotesOnMap()
	if (WHDB_Debug > 0) then 
		DEFAULT_CHAT_FRAME:AddMessage("WHDB_PlotNotesOnMap() called");
	end

	local zone = nil;
	local title = nil;
	local noteID = nil;

	local firstNote = 1;
	if WHDB_MAP_NOTES == {} then
		return false, false, false
	end

	for nKey, nData in ipairs(WHDB_MAP_NOTES) do
		-- C nData[1] is zone name/number
		-- C nData[2] is x coordinate
		-- C nData[3] is y coordinate
		-- C nData[4] is comment title
		-- C nData[5] is comment body
		-- C nData[6] is icon number
		local instance = nil;
		if nData[2] == -1 then
			instance = true;
		end
		if (Cartographer_Notes ~= nil) and (not instance) then
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
			elseif (nData[6] == 5) then
				Cartographer_Notes:SetNote(nData[1], nData[2]/100, nData[3]/100, "ExclamationMark", "WHDB", 'title', nData[4], 'info', nData[5]);
			elseif (nData[6] ~= nil) then
				Cartographer_Notes:SetNote(nData[1], nData[2]/100, nData[3]/100, nData[6], "WHDB", 'title', nData[4], 'info', nData[5]);
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
end -- WHDB_PlotNotesOnMap()

function WHDB_GetMapIDFromZone(zoneText)
	if (WHDB_Debug > 1) then 
		DEFAULT_CHAT_FRAME:AddMessage("WHDB_GetMapIDFromZone(zoneText) called");
	end
	for cKey, cName in ipairs{GetMapContinents()} do
		for zKey,zName in ipairs{GetMapZones(cKey)} do
			if(zoneText == zName) then
				return cKey, zKey;
			end
		end
	end
	return -1, zoneText;
end -- WHDB_GetMapIDFromZone(zoneText)

function WHDB_GetComments(questTitle, questObjectives)
	if (WHDB_Debug > 1) then 
		DEFAULT_CHAT_FRAME:AddMessage("WHDB_GetComments(questTitle, questObjectives) called");
	end
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
end -- WHDB_GetComments(questTitle, questObjectives)

function WHDB_ShowMap()
	if (WHDB_Debug > 1) then 
		DEFAULT_CHAT_FRAME:AddMessage("WHDB_ShowMap() called");
	end
	local ShowMapZone, ShowMapTitle, ShowMapID = WHDB_PlotNotesOnMap();
	if (Cartographer) then
		if (ShowMapZone ~= nil) then
			WorldMapFrame:Show();
			--SetMapZoom(WHDB_GetMapIDFromZone(ShowMapZone));
		end
	end
end -- WHDB_ShowMap()

function WHDB_CleanMap()
	if (WHDB_Debug > 1) then 
		DEFAULT_CHAT_FRAME:AddMessage("WHDB_CleanMap() called");
	end
	if (Cartographer_Notes ~= nil) then
		Cartographer_Notes:UnregisterNotesDatabase("WHDB");
		WHDBDB = {}; WHDBDBH = {};
		Cartographer_Notes:RegisterNotesDatabase("WHDB",WHDBDB,WHDBDBH);
	end
end -- WHDB_CleanMap()

function WHDB_DoCleanMap()
	if (WHDB_Debug > 1) then 
		DEFAULT_CHAT_FRAME:AddMessage("WHDB_DoCleanMap() called");
	end
	if (WHDB_Settings[WHDB_Player]["auto_plot"] == 1) then
		WHDB_Settings[WHDB_Player]["auto_plot"] = 0;
		CheckSetting("auto_plot")
		WHDB_Print("Auto plotting disabled.");
	end
	WHDB_CleanMap();
end -- WHDB_DoCleanMap()

function WHDB_PopulateZones()
	if (WHDB_Debug > 1) then 
		DEFAULT_CHAT_FRAME:AddMessage("WHDB_PopulateZones() called");
	end
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
end -- WHDB_PopulateZones()

function SearchEndNPC(quest)
	if (WHDB_Debug > 0) then 
		DEFAULT_CHAT_FRAME:AddMessage("SearchEndNPC("..quest..") called");
	end
	for npc, data in pairs(npcData) do
		if (data["ends"] ~= nil) then
			for line, entry in pairs(data["ends"]) do
				if (entry == quest) then return data["name"]; end
			end
		end
	end
	return nil;
end -- SearchEndNPC(quest)

function GetQuestEndNotes(questLogID)
	if (WHDB_Debug > 0) then 
		DEFAULT_CHAT_FRAME:AddMessage("GetQuestEndNotes("..questLogID..") called");
	end
	local questTitle = GetQuestLogTitle(questLogID);
	SelectQuestLogEntry(questLogID);
	local questDescription, questObjectives = GetQuestLogQuestText();
	if (questObjectives == nil) then questObjectives = ''; end
	local multi, qIDs = GetQuestIDs(questTitle, questObjectives);
	if (WHDB_Debug > 1) then
		if multi ~= false then
			DEFAULT_CHAT_FRAME:AddMessage("    "..table.getn(qIDs));
		end
	end
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
						GetNPCNotes(name, commentTitle, comment, 2);
					end
				else
					local name = names[1]
					local comment = name.."\n(Ends "..multi.." quests with this name)"
					return GetNPCNotes(name, "END: "..questTitle, comment, 2);
				end
			end
			return true;
		elseif (multi == false) then
			local name = SearchEndNPC(qIDs);
			return GetNPCNotes(name, "END: "..questTitle, name, 2);
		end
	else
		return false;
	end
end -- GetQuestEndNotes(questLogID)

-- C TODO check objectives text
function GetQuestIDs(questName, objectives)
	local qIDs = {};
	if (objectives == nil) then objectives = ''; end
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
	if (WHDB_Debug == 2) then
		DEFAULT_CHAT_FRAME:AddMessage("Possible questIDs: "..table.getn(qIDs));
	end
	length = table.getn(qIDs);
	if (length == nil) then
		return false, false;
	elseif (length == 1) then
		return false, qIDs[1];
	else
		return length, qIDs;
	end
end -- GetQuestIDs(questName, objectives)

-- C TODO 19 npc names are used twice. first found is chosen atm
function GetNPCID(npcName)
	if (WHDB_Debug > 0) then 
		DEFAULT_CHAT_FRAME:AddMessage("GetNPCID("..npcName..") called");
	end
	for npcid, data in pairs(npcData) do
		if (data['name'] == npcName) then return npcid; end
	end
	return false;
end -- GetNPCID(npcName)

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
end -- GetObjID(objName)

function SwitchSetting(setting)
	text = {
		["waypoints"] = "Waypoint plotting",
		["auto_plot"] = "Auto plotting",
		["starts"] = "Quest start plotting"
	};
	if (WHDB_Settings[WHDB_Player][setting] == 0) then
		WHDB_Settings[WHDB_Player][setting] = 1;
		WHDB_Print(text[setting].." enabled.");
	else
		WHDB_Settings[WHDB_Player][setting] = 0;
		WHDB_Print(text[setting].." disabled.");
	end
	CheckSetting(setting);
	if (setting == "auto_plot") and (WHDB_Settings[WHDB_Player][setting] == 1) then
		WHDB_PlotAllQuests();
	end
end -- SwitchSetting(setting)

function CheckSetting(setting)
	if (WHDB_Settings[WHDB_Player][setting] == 1) then
		getglobal(setting):SetChecked(true);
	else
		getglobal(setting):SetChecked(false);
	end
end -- CheckSetting(setting)

-- C tries to get locations for an NPC and inserts them in WHDB_MAP_NOTES if found
function GetNPCNotes(npcName, commentTitle, comment, icon)
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
end -- GetNPCNotes(npcName, commentTitle, comment, icon)

-- C tries to get locations for an (ingame) object and inserts them in WHDB_MAP_NOTES if found
function GetObjNotes(objName, commentTitle, comment, icon)
	if (WHDB_Debug > 1) then 
		DEFAULT_CHAT_FRAME:AddMessage("GetObjNotes(objName, commentTitle, comment, icon) called");
	end
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
end -- GetObjNotes(objName, commentTitle, comment, icon)

function GetQuestNotes(questLogID)
	if (WHDB_Debug >0) then
		DEFAULT_CHAT_FRAME:AddMessage("GetQuestNotes("..questLogID..") called");
	end
	local questTitle, level, questTag, isHeader, isCollapsed, isComplete = GetQuestLogTitle(questLogID);
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
						showMap = GetNPCNotes(monsterName, questTitle, monsterName.."\n"..GetNPCStatsComment(monsterName), cMark) or showMap;
					elseif (type == "item") then
						if (WHDB_Debug == 2) then
							DEFAULT_CHAT_FRAME:AddMessage("    type = item");
						end
						if (itemData[itemName] ~= nil) then
							for monsterName, monsterDrop in pairs(itemData[itemName]) do
								local comment = monsterName..": "..itemName.."\n"..GetNPCDropComment(itemName, monsterName).."\n"..GetNPCStatsComment(monsterName);
								showMap = GetNPCNotes(monsterName, questTitle, comment, cMark) or showMap;
							end
						end
					-- C checks for objective type other than item or monster, e.g. objective, reputation, event
					--elseif (type == "object") then
						--GetObjNotes(itemName, questTitle, comment, icon);
					elseif (type ~= "item" and type ~= "monster") then
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
	if showMap then
		cycleMarks();
	end
	return showMap;
end -- GetQuestNotes(questLogID)

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
end -- GetNPCStatsComment(npcName)

-- C returns dropRate value with prefix for provided NPC name as string
function GetNPCDropComment(itemName, npcName)
	local dropRate = itemData[itemName][npcName];
	if (dropRate == "" or dropRate == nil) then
		dropRate = "Unknown";
	end
	return "Drop chance: "..dropRate.."%";
end -- GetNPCDropComment(itemName, npcName)

function GetQuestStartNotes(zoneName)
	local zoneID = 0;
	if zoneName == nil then
		zoneID = GetCurrentZoneID();
	end
	if (zoneID == 0) and (zoneName) then
		for k,v in pairs(zoneData) do
		if v == zoneName then
			zoneID = k;
		end
	end
	end
	if zoneID ~= 0 then
		for id, data in pairs(npcData) do
			if (data.zones[zoneID] ~= nil) and (data.starts ~= nil) then
				GetNPCNotes(data.name, data.name, "Queststarts", 5)
			end
		end
		for id, data in pairs(objData) do
			if (data.zones[zoneID] ~= nil) and (data.starts ~= nil) then
				GetObjNotes(data.name, data.name, "Queststarts", 5)
			end
		end
		local _,_,_ = WHDB_PlotNotesOnMap();
	end
end -- GetQuestStartNotes(zoneName)

function GetCurrentZoneID()
	local zoneXY = {GetMapZones(GetCurrentMapContinent())};
	local zoneName = zoneXY[GetCurrentMapZone()];
	for k,v in pairs(zoneData) do
		if v == zoneName then
			return k;
		end
	end
	return 0;
end
