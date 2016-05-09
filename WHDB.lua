--------------------------------------------------------
-- Wowhead DB By: UniRing
--------------------------------------------------------
-- Wowhead DB Continued By: Muehe
--------------------------------------------------------

WHDB_Debug = 2;
WHDB_MinDropChance = 0;
WHDB_MAP_NOTES = {};
WHDB_Notes = 0;
WHDB_QuestZoneInfo = {};
WHDB_Player = "";
WHDB_Player_Race = "";
WHDB_Player_Sex = "";
WHDB_Player_Class = "";
WHDB_Player_Faction = "";
WHDB_Version = "Continued WHDB for Classic WoW";

-- Cartographer related stuff
-- New Icons
Cartographer_Notes:RegisterIcon("QuestionMark", {
	text = "QuestionMark",
	path = "Interface\\GossipFrame\\ActiveQuestIcon",
	width = 12,
	height = 12,
})
Cartographer_Notes:RegisterIcon("ExclamationMark", {
	text = "ExclamationMark",
	path = "Interface\\GossipFrame\\AvailableQuestIcon",
	width = 12,
	height = 12,
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
WHDB_cMark = "WHDB_mk1";
Cartographer_Notes:RegisterIcon("WHDB_mk1", {
	text = "Mark 1",
	path = "Interface\\AddOns\\WHDB\\symbols\\mk1",
	width = 8,
	height = 8,
})
Cartographer_Notes:RegisterIcon("WHDB_mk2", {
	text = "Mark 2",
	path = "Interface\\AddOns\\WHDB\\symbols\\mk2",
	width = 8,
	height = 8,
})
Cartographer_Notes:RegisterIcon("WHDB_mk3", {
	text = "Mark 3",
	path = "Interface\\AddOns\\WHDB\\symbols\\mk7",
	width = 8,
	height = 8,
})
Cartographer_Notes:RegisterIcon("WHDB_mk4", {
	text = "Mark 4",
	path = "Interface\\AddOns\\WHDB\\symbols\\mk4",
	width = 8,
	height = 8,
})
Cartographer_Notes:RegisterIcon("WHDB_mk5", {
	text = "Mark 5",
	path = "Interface\\AddOns\\WHDB\\symbols\\mk5",
	width = 8,
	height = 8,
})
Cartographer_Notes:RegisterIcon("WHDB_mk6", {
	text = "Mark 6",
	path = "Interface\\AddOns\\WHDB\\symbols\\mk6",
	width = 8,
	height = 8,
})
Cartographer_Notes:RegisterIcon("WHDB_mk7", {
	text = "Mark 7",
	path = "Interface\\AddOns\\WHDB\\symbols\\mk3",
	width = 8,
	height = 8,
})
Cartographer_Notes:RegisterIcon("WHDB_mk8", {
	text = "Mark 8",
	path = "Interface\\AddOns\\WHDB\\symbols\\mk8",
	width = 8,
	height = 8,
})

function WHDB_cycleMarks()
	if WHDB_cMark == "WHDB_mk1" then WHDB_cMark = "WHDB_mk2";
	elseif WHDB_cMark == "WHDB_mk2" then WHDB_cMark = "WHDB_mk3";
	elseif WHDB_cMark == "WHDB_mk3" then WHDB_cMark = "WHDB_mk4";
	elseif WHDB_cMark == "WHDB_mk4" then WHDB_cMark = "WHDB_mk5";
	elseif WHDB_cMark == "WHDB_mk5" then WHDB_cMark = "WHDB_mk6";
	elseif WHDB_cMark == "WHDB_mk6" then WHDB_cMark = "WHDB_mk7";
	elseif WHDB_cMark == "WHDB_mk7" then WHDB_cMark = "WHDB_mk8";
	elseif WHDB_cMark == "WHDB_mk8" then WHDB_cMark = "WHDB_mk1";
	else WHDB_cMark = "WHDB_mk1";
	end
end -- WHDB_cycleMarks()

-- End of Cartographer stuff

-- MinimapButton. Credits to ShaguDB.

-- {{{ Minimap
WHDB_MMB = CreateFrame("Frame",nil,UIParent)
WHDB_MMB:RegisterEvent("PLAYER_ENTERING_WORLD");
WHDB_MMB:SetScript("OnEvent", function(self, event, ...)
	WHDB_MMB.minimapButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52-(80*cos(WHDB_MinimapPosition)),(80*sin(WHDB_MinimapPosition))-52)
end)

WHDB_MMB.minimapButton = CreateFrame('Button', "WHDB_Minimap", Minimap)
if (WHDB_MinimapPosition == nil) then
	WHDB_MinimapPosition = 60
end

WHDB_MMB.minimapButton:SetMovable(true)
WHDB_MMB.minimapButton:EnableMouse(true)
WHDB_MMB.minimapButton:RegisterForDrag('LeftButton')
WHDB_MMB.minimapButton:SetScript("OnDragStop", function()
    local xpos,ypos = GetCursorPosition()
    local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom()

    xpos = xmin-xpos/UIParent:GetScale()+70
    ypos = ypos/UIParent:GetScale()-ymin-70

    WHDB_MinimapPosition = math.deg(math.atan2(ypos,xpos))
    WHDB_MMB.minimapButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52-(80*cos(WHDB_MinimapPosition)),(80*sin(WHDB_MinimapPosition))-52)
  end)

WHDB_MMB.minimapButton:SetFrameStrata('HIGH')
WHDB_MMB.minimapButton:SetWidth(31)
WHDB_MMB.minimapButton:SetHeight(31)
WHDB_MMB.minimapButton:SetFrameLevel(9)
WHDB_MMB.minimapButton:SetHighlightTexture('Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight')
WHDB_MMB.minimapButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52-(80*cos(WHDB_MinimapPosition)),(80*sin(WHDB_MinimapPosition))-52)
WHDB_MMB.minimapButton:SetScript("OnClick", function()
    if ( arg1 == "LeftButton" ) then
      if (WHDB_Frame:IsShown()) then
        WHDB_Frame:Hide()
      else
        WHDB_Frame:Show()
      end
    end
  end)

-- {{{ Highlight
WHDB_MMB.minimapButton.overlay = WHDB_MMB.minimapButton:CreateTexture(nil, 'OVERLAY')
WHDB_MMB.minimapButton.overlay:SetWidth(53)
WHDB_MMB.minimapButton.overlay:SetHeight(53)
WHDB_MMB.minimapButton.overlay:SetTexture('Interface\\Minimap\\MiniMap-TrackingBorder')
WHDB_MMB.minimapButton.overlay:SetPoint('TOPLEFT', 0,0)
-- }}}
-- {{{ Icon
WHDB_MMB.minimapButton.icon = WHDB_MMB.minimapButton:CreateTexture(nil, 'BACKGROUND')
WHDB_MMB.minimapButton.icon:SetWidth(20)
WHDB_MMB.minimapButton.icon:SetHeight(20)
WHDB_MMB.minimapButton.icon:SetTexture('Interface\\GossipFrame\\AvailableQuestIcon')
WHDB_MMB.minimapButton.icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
WHDB_MMB.minimapButton.icon:SetPoint('CENTER',1,1)
-- }}}
-- }}}

-- Debug print function. Credits to Questie.
function WHDB_Debug_Print(...)
	local debugWin = 0;
	local name, shown;
	for i=1, NUM_CHAT_WINDOWS do
		name,_,_,_,_,_,shown = GetChatWindowInfo(i);
		if (string.lower(name) == "whdbdebug") then debugWin = i; break; end
	end
	if (debugWin == 0) or (WHDB_Debug == 0) or (arg[1] > WHDB_Debug) then return end
	local out = "";
	for i = 2, arg.n, 1 do
		if (i > 2) then out = out .. ", "; end
		local t = type(arg[i]);
		if (t == "string") then
			out = out .. '"'..arg[i]..'"';
		elseif (t == "number") then
			out = out .. arg[i];
		else
			out = out .. "nil";
		end
	end
	getglobal("ChatFrame"..debugWin):AddMessage(out, 1.0, 1.0, 0.3);
end

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
	WHDB_Frame:SetFrameStrata("HIGH");
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
	WHDB_Debug_Print(2, "WHDB_Event(event, arg1) called");
	if (event == "PLAYER_LOGIN") then
		WHDB_Debug_Print(1, "Event: PLAYER_LOGIN");
		if (Cartographer_Notes ~= nil) then
			WHDBDB = {}; WHDBDBH = {};
			Cartographer_Notes:RegisterNotesDatabase("WHDB",WHDBDB,WHDBDBH);
			WHDB_Debug_Print(1, "Cartographer Database Registered.");
		end
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
		WHDB_Debug_Print(2, string.gsub(stringX, "2", "Male"));
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
		if (WHDB_Settings[WHDB_Player]["questStarts"] == nil) then
			WHDB_Settings[WHDB_Player]["questStarts"] = 0;
		end
		WHDB_Frame:Show();
		WHDB_Print("WHDB Loaded.");
	elseif (event == "QUEST_LOG_UPDATE") then
		if (WHDB_Settings[WHDB_Player]["auto_plot"] == 1) then
			WHDB_Debug_Print(2, "Event: QUEST_LOG_UPDATE");
			WHDB_PlotAllQuests();
		end
	elseif (event == "WORLD_MAP_UPDATE") and (WorldMapFrame:IsVisible()) and (WHDB_Settings[WHDB_Player]["questStarts"] == 1) then
		WHDB_Debug_Print(2, zone);
		WHDB_GetQuestStartNotes();
	end
end -- WHDB_Event(event, arg1)

function WHDB_Slash(input)
	if (string.sub(input,1,4) == "help" or input == "") then
		WHDB_Print("Commands available:");
		WHDB_Print("-------------------------------------------------------");
		WHDB_Print("/whdb help | This help.");
		WHDB_Print("/whdb version | Show WHDB version.");
		WHDB_Print("/whdb com <quest name> | Get quest comments by name.");
		WHDB_Print("/whdb item <item name> | Show item drop info on map.");
		WHDB_Print("/whdb min [0, 101] | Minimum drop chance for items. 0 shows all, 101 none.");
		WHDB_Print("/whdb mob <npc name> | Show NPC location on map.");
		WHDB_Print("/whdb obj <object name> | Show object location on map.");
		WHDB_Print("/whdb clean | Clean map notes.");
		WHDB_Print("/whdb auto | Enable/Disable: Automatically plot uncompleted objectives on map.");
		WHDB_Print("/whdb waypoint | Enable/Disable: Plot waypoints on map.");
		WHDB_Print("/whdb starts | Enable/Disable: Plot quest starts on map.");
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
		if (itemName ~= "") then
			if (itemData[itemName] ~= nil) then
				WHDB_GetItemNotes(itemName, itemName, "", 0);
				WHDB_PlotNotesOnMap();
			end
		end
	elseif (string.sub(input,1,3) == "min") then
		number = tonumber(string.sub(input, 5));
		if number then
			local value = abs(number);
			if value > 101 then
				value = 101;
			end
			WHDB_MinDropChance = value;
			WHDB_Print("Minimum Drop Chance set to: "..value.."%");
		else
			WHDB_Print("Minimum Drop Chance is: "..WHDB_MinDropChance.."%");
		end
	elseif (string.sub(input,1,3) == "mob") then
		local monsterName = string.sub(input, 5);
		if (monsterName ~= "") then
			WHDB_Print("Location for: "..monsterName);
			if (monsterName ~= nil) then
				npcID = WHDB_GetNPCID(monsterName)
				if (npcData[npcID] ~= nil) then
					zoneName = zoneData[npcData[npcID]["zone"]];
					if (zoneName == nil) then zoneName = npcData[npcID]["zone"]; end
					WHDB_Print_Indent("Zone: " .. zoneName);
					if (WHDB_GetNPCNotes(monsterName, monsterName, WHDB_GetNPCStatsComment(monsterName), 0)) then
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
				if (WHDB_GetObjNotes(objName, objName, "This object can be found here", 0)) then
					WHDB_ShowMap();
				else
					WHDB_Print("No locations found.");
				end
			end
		end
	elseif (string.sub(input,1,5) == "clean") then
		WHDB_CleanMap();
	elseif (string.sub(input,1,4) == "auto") then
		WHDB_SwitchSetting("auto_plot");
	elseif (string.sub(input,1,8) == "waypoint") then
		WHDB_SwitchSetting("waypoints");
	elseif (string.sub(input,1,6) == "questStarts") then
		WHDB_SwitchSetting("questStarts");
	elseif (string.sub(input,1,5) == "reset") then
		WHDB_Frame:SetPoint("TOPLEFT", 0, 0);
		WHDB_Frame:Show();
	end
end -- WHDB_Slash(input)

function WHDB_PlotAllQuests()
	WHDB_Debug_Print(2, "WHDB_PlotAllQuests() called");
	local questLogID=1;
	WHDB_MAP_NOTES = {};
	while (GetQuestLogTitle(questLogID) ~= nil) do
		questLogID = questLogID + 1;
		WHDB_GetQuestNotes(questLogID)
	end
	WHDB_CleanMap();
	WHDB_PlotNotesOnMap();
end -- WHDB_PlotAllQuests()

function WHDB_Print( str )
	DEFAULT_CHAT_FRAME:AddMessage("|c110000AAWHDB:|r " .. str, 0.95, 0.95, 0.5);
end -- WHDB_Print( str )

function WHDB_Print_Indent( str )
	DEFAULT_CHAT_FRAME:AddMessage("					   " .. str, 0.95, 0.95, 0.5);
end -- WHDB_Print_Indent( str )

function WHDB_PlotNotesOnMap()
	WHDB_Debug_Print(2, "WHDB_PlotNotesOnMap() called");

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
		local notes = table.getn(WHDB_MAP_NOTES);
		if notes ~= WHDB_Notes then
			WHDB_Print(notes.." notes plotted.");
			WHDB_Notes = notes;
		end
	end
	WHDB_MAP_NOTES = {}
	return zone, title, noteID;
end -- WHDB_PlotNotesOnMap()

function WHDB_GetMapIDFromZone(zoneText)
	WHDB_Debug_Print(2, "WHDB_GetMapIDFromZone(zoneText) called");
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
	WHDB_Debug_Print(2, "WHDB_GetComments(questTitle, questObjectives) called");
	-- Update for new functionality
	local multi, qIDs = WHDB_GetQuestIDs(questTitle, questObjectives);
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
	WHDB_Debug_Print(2, "WHDB_ShowMap() called");
	local ShowMapZone, ShowMapTitle, ShowMapID = WHDB_PlotNotesOnMap();
	if (Cartographer) then
		if (ShowMapZone ~= nil) then
			WorldMapFrame:Show();
			--SetMapZoom(WHDB_GetMapIDFromZone(ShowMapZone));
		end
	end
end -- WHDB_ShowMap()

function WHDB_CleanMap()
	WHDB_Debug_Print(2, "WHDB_CleanMap() called");
	if (Cartographer_Notes ~= nil) then
		Cartographer_Notes:UnregisterNotesDatabase("WHDB");
		WHDBDB = {}; WHDBDBH = {};
		Cartographer_Notes:RegisterNotesDatabase("WHDB",WHDBDB,WHDBDBH);
	end
end -- WHDB_CleanMap()

-- called from xml
function WHDB_DoCleanMap()
	WHDB_Debug_Print(2, "WHDB_DoCleanMap() called");
	if (WHDB_Settings[WHDB_Player]["auto_plot"] == 1) then
		WHDB_Settings[WHDB_Player]["auto_plot"] = 0;
		WHDB_CheckSetting("auto_plot")
		WHDB_Print("Auto plotting disabled.");
	end
	WHDB_CleanMap();
end -- WHDB_DoCleanMap()

function WHDB_SearchEndNPC(questID)
	WHDB_Debug_Print(2, "WHDB_SearchEndNPC("..questID..") called");
	for npc, data in pairs(npcData) do
		if (data["ends"] ~= nil) then
			for line, entry in pairs(data["ends"]) do
				if (entry == questID) then return npc; end
			end
		end
	end
	return nil;
end -- WHDB_SearchEndNPC(questID)

function WHDB_SearchEndObj(questID)
	WHDB_Debug_Print(2, "WHDB_SearchEndObj("..questID..") called");
	for obj, data in pairs(objData) do
		if (data["ends"] ~= nil) then
			for line, entry in pairs(data["ends"]) do
				if (entry == questID) then return obj; end
			end
		end
	end
	return nil;
end -- WHDB_SearchEndObj(questID)

function WHDB_GetQuestEndNotes(questLogID)
	WHDB_Debug_Print(2, "WHDB_GetQuestEndNotes("..questLogID..") called");
	local questTitle = GetQuestLogTitle(questLogID);
	SelectQuestLogEntry(questLogID);
	local questDescription, questObjectives = GetQuestLogQuestText();
	if (questObjectives == nil) then questObjectives = ''; end
	local multi, qIDs = WHDB_GetQuestIDs(questTitle, questObjectives);
	if multi ~= false then
		WHDB_Debug_Print(2, "    "..table.getn(qIDs));
	end
	if (qIDs ~= false) then
		if (multi ~= false) then
			local npcIDs = {}
			for n, qID in pairs(qIDs) do
				local npcID = WHDB_SearchEndNPC(qID);
				if (npcID) then
					local done = false;
					for n, IDInside in pairs(npcIDs) do
						if (npcID == IDInsidemn) then 
							done = true;
						end
					end
					if not (done) then
						table.insert(npcIDs, npcID);
					end
				end
			end
			if (table.getn(npcIDs) > 0) then
				if (table.getn(npcIDs) > 1) then
					for n, npcID in pairs(npcIDs) do
						local commentTitle = "|cFF33FF00"..questTitle.." (Complete)|r".." - "..n.."/"..table.getn(npcIDs).." NPCs";
						local comment = npcData[npcID].name.."\n("..multi.." quests with this name)"
						WHDB_GetNPCNotes(npcID, commentTitle, "Finished by: |cFFa6a6a6"..comment.."|r", 2);
					end
				else
					local npcID = npcIDs[1]
					local comment = npcData[npcID].name.."\n(Ends "..multi.." quests with this name)"
					return WHDB_GetNPCNotes(npcID, "|cFF33FF00"..questTitle.." (Complete)|r", "Finished by: |cFFa6a6a6"..comment.."|r", 2);
				end
			else
				local objIDs = {}
					for n, qID in pairs(qIDs) do
					local objID = WHDB_SearchEndObj(qID);
					if (objID) then
						local done = false;
						for n, IDInside in pairs(objIDs) do
							if (objID == IDInside) then 
								done = true;
							end
						end
						if not (done) then
							table.insert(objIDs, objID);
						end
					end
				end
				if (table.getn(objIDs) > 0) then
					if (table.getn(objIDs) > 1) then
						for n, objID in pairs(objIDs) do
							local commentTitle = "|cFF33FF00"..questTitle.." (Complete)|r".." - "..n.."/"..table.getn(objIDs).." NPCs";
							local comment = objData[objID].name.."\n("..multi.." quests with this name)"
							WHDB_GetObjNotes(objID, commentTitle, "Finished by: |cFFa6a6a6"..comment.."|r", 2);
						end
					else
						local objID = objIDs[1]
						local comment = objData[objID].name.."\n(Ends "..multi.." quests with this name)"
						return WHDB_GetObjNotes(objID, "|cFF33FF00"..questTitle.." (Complete)|r", "Finished by: |cFFa6a6a6"..comment.."|r", 2);
					end
				else
					return false;
				end
			end
			return true;
		elseif (multi == false) then
			local npcID = WHDB_SearchEndNPC(qIDs);
			if npcID and npcData[npcID] then
				local name = npcData[npcID].name;
				return WHDB_GetNPCNotes(npcID, "|cFF33FF00"..questTitle.." (Complete)|r", "Finished by: |cFFa6a6a6"..name.."|r", 2);
			else
				local objID = WHDB_SearchEndObj(qIDs);
				if objID and objData[objID] then
					local name = objData[objID].name;
					return WHDB_GetObjNotes(objID, "|cFF33FF00"..questTitle.." (Complete)|r", "Finished by: |cFFa6a6a6"..name.."|r", 2);
				else
					return false;
				end
			end
		end
	else
		return false;
	end
end -- WHDB_GetQuestEndNotes(questLogID)

-- TODO check objectives text
function WHDB_GetQuestIDs(questName, objectives)
	local qIDs = {};
	if (objectives == nil) then objectives = ''; end
	WHDB_Debug_Print(2, "WHDB_GetQuestIDs("..questName..", "..objectives..")");
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
	WHDB_Debug_Print(2, "Possible questIDs: ", table.getn(qIDs));
	length = table.getn(qIDs);
	if (length == nil) then
		return false, false;
	elseif (length == 1) then
		return false, qIDs[1];
	else
		return length, qIDs;
	end
end -- WHDB_GetQuestIDs(questName, objectives)

-- TODO 19 npc names are used twice. first found is chosen atm
function WHDB_GetNPCID(npcName)
	WHDB_Debug_Print(2, "WHDB_GetNPCID("..npcName..") called");
	for npcid, data in pairs(npcData) do
		if (data['name'] == npcName) then return npcid; end
	end
	return false;
end -- WHDB_GetNPCID(npcName)

function WHDB_GetObjID(objName)
	WHDB_Debug_Print(2, "WHDB_GetObjID("..objName..") called");
	local objIDs = {};
	for objID, data in pairs(objData) do
		if (data['name'] == objName) then 
			table.insert(objIDs, objID);
		end
	end
	if objIDs == {} then return false;
	else return objIDs;
	end
end -- WHDB_GetObjID(objName)

function WHDB_SwitchSetting(setting)
	text = {
		["waypoints"] = "Waypoint plotting",
		["auto_plot"] = "Auto plotting",
		["questStarts"] = "Quest start plotting"
	};
	if (WHDB_Settings[WHDB_Player][setting] == 0) then
		WHDB_Settings[WHDB_Player][setting] = 1;
		WHDB_Print(text[setting].." enabled.");
	else
		WHDB_Settings[WHDB_Player][setting] = 0;
		WHDB_Print(text[setting].." disabled.");
	end
	WHDB_CheckSetting(setting);
	if (setting == "auto_plot") and (WHDB_Settings[WHDB_Player][setting] == 1) then
		WHDB_PlotAllQuests();
	end
end -- WHDB_SwitchSetting(setting)

function WHDB_CheckSetting(setting)
	if (WHDB_Settings[WHDB_Player][setting] == 1) then
		getglobal(setting):SetChecked(true);
	else
		getglobal(setting):SetChecked(false);
	end
end -- WHDB_CheckSetting(setting)

-- tries to get locations for an NPC and inserts them in WHDB_MAP_NOTES if found
function WHDB_GetNPCNotes(npcNameOrID, commentTitle, comment, icon)
	if (npcNameOrID ~= nil) then
		WHDB_Debug_Print(2, "WHDB_GetNPCNotes("..npcNameOrID..") called");
		local npcID;
		if (type(npcNameOrID) == "string") then
			npcID = WHDB_GetNPCID(npcNameOrID);
		else
			npcID = npcNameOrID;
		end
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
						table.insert(WHDB_MAP_NOTES,{zoneName, coordx, coordy, commentTitle, comment, 3});
						showMap = true;
					end
				end
			end
			if (npcData[npcID]["zones"]) then
				for zoneID, coordsdata in pairs(npcData[npcID]["zones"]) do
					if (zoneID ~= 5 and zoneID ~= 6) then
						zoneName = zoneData[zoneID];
						for cID, coords in pairs(coordsdata) do
							if (coords[1] == -1) and (instanceData[zoneID]) then
								for id, data in pairs(instanceData[zoneID]) do
									noteZone = zoneData[data[1]];
									coordx = data[2];
									coordy = data[3];
									table.insert(WHDB_MAP_NOTES,{noteZone, coordx, coordy, commentTitle, "|cFF00FF00Instance Entry to "..zoneName.."|r\n"..comment, icon});
								end
							end
							coordx = coords[1];
							coordy = coords[2];
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
end -- WHDB_GetNPCNotes(npcNameOrID, commentTitle, comment, icon)

-- tries to get locations for an (ingame) object and inserts them in WHDB_MAP_NOTES if found
function WHDB_GetObjNotes(objNameOrID, commentTitle, comment, icon)
	WHDB_Debug_Print(2, "WHDB_GetObjNotes(objNameOrID, commentTitle, comment, icon) called");
	if (objNameOrID ~= nil) then
		local objIDs;
		if (type(objNameOrID) == "string") then
			objIDs = WHDB_GetObjID(objNameOrID);
		else
			objIDs = {objNameOrID};
		end
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
end -- WHDB_GetObjNotes(objNameOrID, commentTitle, comment, icon)

function WHDB_GetItemNotes(itemName, commentTitle, comment, icon)
	WHDB_Debug_Print(2, "WHDB_GetItemNotes("..itemName..") called");
	if (itemData[itemName]) then
		local showMap = false;
		if (itemData[itemName].npcs) then
			for key, value in pairs(itemData[itemName].npcs) do
				if npcData[value[1]] then
					local show = true;
					if (WHDB_MinDropChance > 0) and (value[2] < WHDB_MinDropChance) then
						show = false;
					end
					if show then
						local dropComment = "Drop chance: "..value[2].."%\n".."Dropped by:\n"..npcData[value[1]].name.."\n"..WHDB_GetNPCStatsComment(value[1]);
						showMap = WHDB_GetNPCNotes(value[1], commentTitle, comment..dropComment, icon) or showMap;
					end
				end
			end
		end
		if (itemData[itemName].objects) then
			for key, value in pairs(itemData[itemName].objects) do
				if objData[value[1]] then
					local show = true;
					if (WHDB_MinDropChance > 0) and (value[2] < WHDB_MinDropChance) then
						show = false;
					end
					if show then
						local dropComment = "Drop chance: "..value[2].."%\n".."Dropped by:\n"..objData[value[1]].name;
						showMap = WHDB_GetObjNotes(objData[value[1]].name, commentTitle, comment..dropComment, icon) or showMap;
					end
				end
			end
		end
		-- TODO: itemData[itemName].items
		return showMap;
	else
		return false;
	end
end -- WHDB_GetItemNotes(itemName, commentTitle, comment, icon)

function WHDB_GetQuestNotes(questLogID)
	WHDB_Debug_Print(2, "WHDB_GetQuestNotes("..questLogID..") called");
	local questTitle, level, questTag, isHeader, isCollapsed, isComplete = GetQuestLogTitle(questLogID);
	local showMap = false;
	if (not isHeader and questTitle ~= nil) then
		WHDB_Debug_Print(2, "    questTitle = ", questTitle);
		WHDB_Debug_Print(2, "    level = ", level);
		WHDB_Debug_Print(2, "    isComplete = ", isComplete);
		local numObjectives = GetNumQuestLeaderBoards(questLogID);
		if (numObjectives ~= nil) then
			WHDB_Debug_Print(2, "    numObjectives = "..numObjectives);
		end
		if (numObjectives ~= nil) then
			for i=1, numObjectives, 1 do
				local text, type, finished = GetQuestLogLeaderBoard(i, questLogID);
				local i, j, itemName, numItems, numNeeded = strfind(text, "(.*):%s*([%d]+)%s*/%s*([%d]+)");
				if (not finished) then
					if (type == "monster") then
						WHDB_Debug_Print(2, "    type = monster");
						local i, j, monsterName = strfind(itemName, "(.*) slain");
						if monsterName then
							local comment = "|cFF00FF00"..monsterName.." "..numItems.."/"..numNeeded.."|r\n"
							local npcID = WHDB_GetNPCID(monsterName);
							showMap = WHDB_GetNPCNotes(npcID, questTitle, comment..WHDB_GetNPCStatsComment(npcID), WHDB_cMark) or showMap;
						end
					elseif (type == "item") then
						WHDB_Debug_Print(2, "    type = item");
						if (itemData[itemName] ~= nil) then
							local comment = "|cFF00FF00"..itemName.." "..numItems.."/"..numNeeded.."|r\n"
							showMap = WHDB_GetItemNotes(itemName, questTitle, comment, WHDB_cMark) or showMap;
						end
					-- checks for objective type other than item or monster, e.g. objective, reputation, event
					-- TODO: object check is WIP, most objects can't be found easily by checking item name
					elseif (type == "object") then
						local i, j, objectName = strfind(itemName, "(.*) ")
						local comment = "|cFF00FF00"..itemName.." "..numItems.."/"..numNeeded.."|r\n"
						showMap = WHDB_GetObjNotes(objectName, questTitle, comment, WHDB_cMark) or showMap;
					elseif (type ~= "item" and type ~= "monster") then
						WHDB_Debug_Print(1, "    "..type.." quest objective-type not supported yet");
					end
				end
			end
		end
		-- added numObjectives condition due to some quests not showing "isComplete" though having nothing to do but turn it in
		if (isComplete or numObjectives == 0) then
			WHDB_GetQuestEndNotes(questLogID);
		end
	end
	if showMap then
		WHDB_cycleMarks();
	end
	return showMap;
end -- WHDB_GetQuestNotes(questLogID)

-- returns level and hp values with prefix for provided NPC name as string
function WHDB_GetNPCStatsComment(npcNameOrID)
	WHDB_Debug_Print(2, "WHDB_GetNPCStatsComment("..npcNameOrID..") called");
	local npcID;
	if (type(npcNameOrID) == "string") then
		npcID = WHDB_GetNPCID(npcNameOrID);
	else
		npcID = npcNameOrID;
	end
	if (npcData[npcID] ~= nil) then
		local level = npcData[npcID].level;
		local hp = npcData[npcID].hp;
		if (level == nil) then
			level = "Unknown";
		end
		if (hp == nil) then
			hp = "Unknown";
		end
		return "Level: "..level.."\nHealth: "..hp;
	else
		WHDB_Debug_Print(2, "    NPC not found: "..npcNameOrID);
		return "NPC not found: "..npcNameOrID;
	end
end -- WHDB_GetNPCStatsComment(npcNameOrID)

-- returns dropRate value with prefix for provided NPC name as string
-- TODO: fix for new item data
function WHDB_GetNPCDropComment(itemName, npcName)
	WHDB_Debug_Print(2, "WHDB_GetNPCDropComment("..itemName..", "..npcName..") called");
	local dropRate = itemData[itemName][npcName];
	if (dropRate == "" or dropRate == nil) then
		dropRate = "Unknown";
	end
	return "Drop chance: "..dropRate.."%";
end -- WHDB_GetNPCDropComment(itemName, npcName)

function WHDB_GetQuestStartNotes(zoneName)
	local zoneID = 0;
	if zoneName == nil then
		zoneID = WHDB_GetCurrentZoneID();
	end
	if (zoneID == 0) and (zoneName) then
		for k,v in pairs(zoneData) do
			if v == zoneName then
				zoneID = k;
			end
		end
	end
	if zoneID ~= 0 then
		-- TODO: add quests to tooltip and add hide option to right click menu
		for id, data in pairs(npcData) do
			if (data.zones[zoneID] ~= nil) and (data.starts ~= nil) then
				WHDB_GetNPCNotes(data.name, data.name, "Queststarts", 5)
			end
		end
		for id, data in pairs(objData) do
			if (data.zones[zoneID] ~= nil) and (data.starts ~= nil) then
				WHDB_GetObjNotes(data.name, data.name, "Queststarts", 5)
			end
		end
		local _,_,_ = WHDB_PlotNotesOnMap();
	end
end -- WHDB_GetQuestStartNotes(zoneName)

function WHDB_GetCurrentZoneID()
	local zoneXY = {GetMapZones(GetCurrentMapContinent())};
	local zoneName = zoneXY[GetCurrentMapZone()];
	for k,v in pairs(zoneData) do
		if v == zoneName then
			return k;
		end
	end
	return 0;
end -- WHDB_GetCurrentZoneID()

-- called from xml
function WHDB_GetSelectionQuestNotes()
	WHDB_GetQuestNotes(GetQuestLogSelection())
	WHDB_PlotNotesOnMap();
end -- WHDB_GetSelectionQuestNotes()
