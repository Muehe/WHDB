--------------------------------------------------------
-- Wowhead DB By: UniRing
--------------------------------------------------------
-- Wowhead DB Continued By: Muehe
--------------------------------------------------------


-- Globals
-- Note that there are other globals in the DB files.
WHDB_Debug = 2;
WHDB_PREPARE = {{},{},{}};
WHDB_MARKED = {{},{},{}};
WHDB_MARKED_ZONES = {};
WHDB_MARKED_ZONE = "";
WHDB_QUEST_START_ZONES = {};
WHDB_MAP_NOTES = {};
WHDB_Notes = 0;
WHDB_InEvent = false;
WHDB_Version = "Continued WHDB for Classic WoW";

DB_NAME, DB_NPC, NOTE_TITLE = 1, 1, 1;
DB_STARTS, DB_OBJ, NOTE_COMMENT, DB_MIN_LEVEL_HEALTH = 2, 2, 2, 2;
DB_ENDS, DB_ITM, NOTE_ICON, DB_TRIGGER_MARKED, DB_MAX_LEVEL_HEALTH = 3, 3, 3, 3, 3;
DB_MIN_LEVEL, DB_ZONES, DB_VENDOR, DB_OBJ_SPAWNS = 4, 4, 4, 4;
DB_LEVEL, DB_ITM_NAME = 5, 5;
DB_REQ_RACE, DB_RANK = 6, 6;
DB_REQ_CLASS, DB_NPC_SPAWNS = 7, 7;
DB_OBJECTIVES, DB_NPC_WAYPOINTS = 8, 8;
DB_TRIGGER, DB_ZONE = 9, 9;
DB_REQ_NPC_OR_OBJ_OR_ITM, DB_NPC_STARTS = 10, 10;
DB_SRC_ITM, DB_NPC_ENDS = 11, 11;

-- Cartographer related stuff
-- New Icons
Cartographer_Notes:RegisterIcon("NPC", {
    text = "NPC",
    path = "Interface\\WorldMap\\WorldMapPartyIcon",
    width = 12,
    height = 12,
})
Cartographer_Notes:RegisterIcon("Waypoint", {
    text = "Waypoint",
    path = "Interface\\WorldMap\\WorldMapPlayerIcon",
    width = 12,
    height = 12,
})
Cartographer_Notes:RegisterIcon("QuestionMark", {
    text = "QuestionMark",
    path = "Interface\\AddOns\\WHDB\\symbols\\complete",
    width = 16,
    height = 16,
})
Cartographer_Notes:RegisterIcon("ExclamationMark", {
    text = "ExclamationMark",
    path = "Interface\\AddOns\\WHDB\\symbols\\available",
    width = 16,
    height = 16,
})
Cartographer_Notes:RegisterIcon("AreaTrigger", {
    text = "AreaTrigger",
    path = "Interface\\AddOns\\WHDB\\symbols\\event",
    width = 16,
    height = 16,
})
Cartographer_Notes:RegisterIcon("Vendor", {
    text = "Vendor",
    path = "Interface\\AddOns\\WHDB\\symbols\\vendor",
    width = 16,
    height = 16,
})


-- Icons from ShaguDB, thanks fam.
-- Switched 3 and 7 for better contrast of colors follwing each other
WHDB_cMark = "WHDB_mk1";
Cartographer_Notes:RegisterIcon("WHDB_mk1", {
    text = "Mark 1",
    path = "Interface\\AddOns\\WHDB\\symbols\\mk1",
    width = 16,
    height = 16,
})
Cartographer_Notes:RegisterIcon("WHDB_mk2", {
    text = "Mark 2",
    path = "Interface\\AddOns\\WHDB\\symbols\\mk2",
    width = 16,
    height = 16,
})
Cartographer_Notes:RegisterIcon("WHDB_mk3", {
    text = "Mark 3",
    path = "Interface\\AddOns\\WHDB\\symbols\\mk7",
    width = 16,
    height = 16,
})
Cartographer_Notes:RegisterIcon("WHDB_mk4", {
    text = "Mark 4",
    path = "Interface\\AddOns\\WHDB\\symbols\\mk4",
    width = 16,
    height = 16,
})
Cartographer_Notes:RegisterIcon("WHDB_mk5", {
    text = "Mark 5",
    path = "Interface\\AddOns\\WHDB\\symbols\\mk5",
    width = 16,
    height = 16,
})
Cartographer_Notes:RegisterIcon("WHDB_mk6", {
    text = "Mark 6",
    path = "Interface\\AddOns\\WHDB\\symbols\\mk6",
    width = 16,
    height = 16,
})
Cartographer_Notes:RegisterIcon("WHDB_mk7", {
    text = "Mark 7",
    path = "Interface\\AddOns\\WHDB\\symbols\\mk3",
    width = 16,
    height = 16,
})
Cartographer_Notes:RegisterIcon("WHDB_mk8", {
    text = "Mark 8",
    path = "Interface\\AddOns\\WHDB\\symbols\\mk8",
    width = 16,
    height = 16,
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

function WHDB_CycleMarkedZones()
    if WHDB_MARKED_ZONE ~= "" then
        local found = false;
        for k, v in pairs(WHDB_MARKED_ZONES) do
            if found then
                WHDB_MARKED_ZONE = k;
                SetMapZoom(WHDB_GetMapIDFromZone(k));
                return;
            end
            if k == WHDB_MARKED_ZONE then
                found = true;
            end
        end
        if found then
            for k, v in pairs(WHDB_MARKED_ZONES) do
                WHDB_MARKED_ZONE = k;
                SetMapZoom(WHDB_GetMapIDFromZone(k));
                return;
            end
        end
    else
        for k, v in pairs(WHDB_MARKED_ZONES) do
            WHDB_MARKED_ZONE = k;
            SetMapZoom(WHDB_GetMapIDFromZone(k));
            return;
        end
    end
end -- WHDB_CycleMarkedZones()

-- End of Cartographer stuff

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
            out = out..arg[i];
        elseif (t == "number") then
            out = out .. arg[i];
        elseif (t == "boolean") then
            if t == true then
                out = out .. "true";
            else
                out = out .. "false";
            end
        else
            out = out .. "\"nil or table or smth\"";
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
    --
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
        if (WHDB_FinishedQuests == nil) then
            WHDB_FinishedQuests = {};
        end
        if (WHDB_Settings == nil) then
            WHDB_Settings = {};
        end
        WHDB_Settings["auto_plot"] = false;
        WHDB_Settings["item_item"] = false;
        if (WHDB_Settings["minDropChance"] == nil) then
            WHDB_Settings["minDropChance"] = 0;
        end
        if (WHDB_Settings["dbMode"] == nil) then
            WHDB_Settings["dbMode"] = false;
        end
        if (WHDB_Settings["waypoints"] == nil) then
            WHDB_Settings["waypoints"] = false;
        end
        if (WHDB_Settings["questStarts"] == nil) then
            WHDB_Settings["questStarts"] = false;
        end
        if (WHDB_Settings["filterReqLevel"] == nil) then
            WHDB_Settings["filterReqLevel"] = true;
        end
        if (WHDB_Settings["questIds"] == nil) then
            WHDB_Settings["questIds"] = true;
        end
        if (WHDB_Settings["reqLevel"] == nil) then
            WHDB_Settings["reqLevel"] = true;
        end
        if (WHDB_Settings["player"] == nil) then
            WHDB_Settings["player"] = UnitName("player");
        end
        if (WHDB_Settings["race"] == nil) then
            WHDB_Settings["race"] = UnitRace("player");
        end
        if (WHDB_Settings["sex"] == nil) then
            local temp = UnitSex("player");
            if (temp == 3) then
                WHDB_Settings["sex"] = "Female";
            elseif (temp == 2) then
                WHDB_Settings["sex"] = "Male";
            else
                WHDB_Settings["sex"] = nil;
            end
        end
        if (WHDB_Settings["class"] == nil) then
            WHDB_Settings["class"] = UnitClass("player");
        end
        if (WHDB_Settings["faction"] == nil) then
            local temp = UnitFactionGroup("player");
            if (temp) then
                WHDB_Settings["faction"] = temp;
            end
        end
        if (WHDB_Settings.faction == "Alliance" and not WHDB_Settings.dbMode) then
            deleteFaction("H");
            WHDB_Print("Horde data cleared.");
        elseif (WHDB_Settings.faction == "Horde" and not WHDB_Settings.dbMode) then
            deleteFaction("A");
            WHDB_Print("Alliance data cleared.");
        else
            WHDB_Print("DB Mode active, no quest data cleared.");
        end
        if not WHDB_Settings.dbMode then
            deleteClasses();
        end
        fillQuestLookup();
        WHDB_Frame:Show();
        WHDB_Print("WHDB Loaded.");
    elseif (event == "QUEST_LOG_UPDATE") then
        if (WHDB_Settings.auto_plot) then
            WHDB_InEvent = true;
            WHDB_Debug_Print(2, "Event: QUEST_LOG_UPDATE");
            WHDB_PlotAllQuests();
            WHDB_InEvent = false;
        end
    elseif (event == "WORLD_MAP_UPDATE") and (WorldMapFrame:IsVisible()) and (WHDB_Settings.questStarts) then
        WHDB_Debug_Print(2, zone);
        WHDB_InEvent = true;
        WHDB_GetQuestStartNotes();
        WHDB_InEvent = false;
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
        WHDB_Print("/whdb hide <questID> | Prevent the given quest ID from being plotted to quest starts.");
        WHDB_Print("/whdb reset | Reset positon of the Interface.");
        WHDB_Print("/whdb clear | !This reloads the UI! Delete WHDB Settings.");
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
            if ((itemLookup[itemName]) and (itemData[itemLookup[itemName]])) then
                WHDB_MarkForPlotting(DB_ITM, itemName, itemName, "", 0);
                WHDB_ShowMap();
            end
        end
    elseif (string.sub(input,1,3) == "min") then
        number = tonumber(string.sub(input, 5));
        if number then
            local value = abs(number);
            if value > 101 then
                value = 101;
            end
            WHDB_Settings.minDropChance = value;
            WHDB_Print("Minimum Drop Chance set to: "..value.."%");
        else
            WHDB_Print("Minimum Drop Chance is: "..WHDB_Settings.minDropChance.."%");
        end
    elseif (string.sub(input,1,3) == "mob") then
        local monsterName = string.sub(input, 5);
        if (monsterName ~= "") then
            WHDB_Print("Location for: "..monsterName);
            if (monsterName ~= nil) then
                npcID = WHDB_GetNPCID(monsterName)
                if (npcData[npcID] ~= nil) then
                    zoneName = zoneData[npcData[npcID][DB_ZONE]];
                    if (zoneName == nil) then zoneName = npcData[npcID][DB_ZONE]; end
                    WHDB_Print_Indent("Zone: " .. zoneName);
                    if (WHDB_MarkForPlotting(DB_NPC, monsterName, monsterName, WHDB_GetNPCStatsComment(monsterName, true), 0)) then
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
                if (WHDB_MarkForPlotting(DB_OBJ, objName, objName, "This object can be found here", 0)) then
                    WHDB_ShowMap();
                else
                    WHDB_Print("No locations found.");
                end
            end
        end
    elseif (string.sub(input,1,5) == "clean") then
        WHDB_DoCleanMap();
    elseif (string.sub(input,1,4) == "auto") then
        WHDB_SwitchSetting("auto_plot");
    elseif (string.sub(input,1,8) == "waypoint") then
        WHDB_SwitchSetting("waypoints");
    elseif (string.sub(input,1,6) == "starts") then
        WHDB_SwitchSetting("questStarts");
    elseif (string.sub(input,1,4) == "hide") then
        local questId = tonumber(string.sub(input, 6));
        if qData[questId] then
            WHDB_FinishedQuests[questId] = true;
        end
    elseif (string.sub(input,1,5) == "reset") then
        WHDB_ResetGui();
    elseif (string.sub(input,1,5) == "clear") then
        WHDB_Settings = nil;
        ReloadUI();
    end
end -- WHDB_Slash(input)

function WHDB_ResetGui()
    DBGUI:ClearAllPoints();
    DBGUI:SetPoint("CENTER", 0, 0);
    WHDB_Frame:ClearAllPoints();
    WHDB_Frame:SetPoint("BOTTOMLEFT", "DBGUI", "BOTTOMRIGHT", 0, 0);
    DBGUI:Show();
    WHDB_Frame:Show();
end

function WHDB_PlotAllQuests()
    WHDB_Debug_Print(2, "WHDB_PlotAllQuests() called");
    local questLogID=1;
    WHDB_MAP_NOTES = {};
    while (GetQuestLogTitle(questLogID) ~= nil) do
        questLogID = questLogID + 1;
        WHDB_GetQuestNotes(questLogID)
    end
    WHDB_QUEST_START_ZONES = {};
    WHDB_CleanMap();
    if WHDB_InEvent == true then
        WHDB_PlotNotesOnMap();
    else
        WHDB_ShowMap();
    end
end -- WHDB_PlotAllQuests()

function WHDB_Print( str )
    DEFAULT_CHAT_FRAME:AddMessage("|c110000AAWHDB:|r " .. str, 0.95, 0.95, 0.5);
end -- WHDB_Print( str )

function WHDB_Print_Indent( str )
    DEFAULT_CHAT_FRAME:AddMessage("                       " .. str, 0.95, 0.95, 0.5);
end -- WHDB_Print_Indent( str )

function WHDB_PlotNotesOnMap()
    WHDB_Debug_Print(2, "WHDB_PlotNotesOnMap() called");

    if WHDB_PREPARE[DB_NPC] then
        for k, npcMarks in WHDB_PREPARE[DB_NPC] do
            local noteTitle, comment, icon = '', '', -1;
            if WHDB_GetTableLength(npcMarks) > 1 then
                noteTitle = npcData[k][DB_NAME];
                for key, note in pairs(npcMarks) do
                    comment = comment.."\n"..note[NOTE_TITLE].."\n"..note[NOTE_COMMENT].."\n";
                    if icon ~= -1 then
                        if icon ~= note[NOTE_ICON] then
                            if (icon == 2 or note[NOTE_ICON] == 2) then
                                icon = 2;
                            else
                                icon = 0;
                            end
                        end
                    else
                        icon = note[NOTE_ICON];
                    end
                end
                if (icon ~= 2) and (icon ~= 5) and (icon ~= 6) then
                    comment = WHDB_GetNPCStatsComment(k, true)..comment;
                    local st, en = string.find(comment, "|c.-|r");
                    noteTitle = string.sub(comment, st, en);
                    comment = string.sub(comment, en+2);
                end
                WHDB_GetNPCNotes(k, noteTitle, comment, icon);
            else
                for key, v in pairs(npcMarks) do
                    if (v[NOTE_ICON] ~= 2) and (v[NOTE_ICON] ~= 5) and (v[NOTE_ICON] ~= 6) then
                        comment = WHDB_GetNPCStatsComment(k, true)..comment;
                    end
                    WHDB_GetNPCNotes(k, v[NOTE_TITLE], comment..v[NOTE_COMMENT], v[NOTE_ICON]);
                end
            end
        end
    end
    if WHDB_PREPARE[DB_OBJ] then
        for k, objMarks in WHDB_PREPARE[DB_OBJ] do
            local noteTitle, comment, icon = '', '', -1;
            if WHDB_GetTableLength(objMarks) > 1 then
                noteTitle = objData[k][DB_NAME];
                for key, note in pairs(objMarks) do
                    comment = comment.."\n"..note[NOTE_TITLE].."\n"..note[NOTE_COMMENT].."\n";
                    if icon ~= -1 then
                        if icon ~= note[NOTE_ICON] then
                            if (icon == 2 or note[NOTE_ICON] == 2) then
                                icon = 2;
                            else
                                icon = 0;
                            end
                        end
                    else
                        icon = note[NOTE_ICON];
                    end
                end
                WHDB_GetObjNotes(k, noteTitle, comment, icon);
            else
                for key, v in pairs(objMarks) do
                    WHDB_GetObjNotes(k, v[NOTE_TITLE], v[NOTE_COMMENT], v[NOTE_ICON]);
                end
            end
        end
    end
    if WHDB_PREPARE[DB_TRIGGER_MARKED] then
        for questId, _ in WHDB_PREPARE[DB_TRIGGER_MARKED] do
            local color = WHDB_GetDifficultyColor(qData[questId][DB_LEVEL]);
            local level = qData[questId][DB_LEVEL];
            if level == -1 then level = UnitLevel("player"); end
            local title = color.."Location for: ".."["..level.."] "..qData[questId][DB_NAME].."|r";
            for zoneId, coords in pairs(qData[questId][DB_TRIGGER][2]) do
                for _, coord in pairs(coords) do
                    table.insert(WHDB_MAP_NOTES,{zoneData[zoneId], coord[1], coord[2], title, "|cFF00FF00"..qData[questId][DB_TRIGGER][1].."|r", 7});
                end
            end
        end
    end
    WHDB_MARKED = WHDB_PREPARE;
    WHDB_PREPARE = {{},{},{}};

    if WHDB_MAP_NOTES == {} then
        return false, false, false;
    end
    local firstNote = 1;

    local zone = nil;
    local title = nil;
    local noteID = nil;

    for nKey, nData in ipairs(WHDB_MAP_NOTES) do
        -- C nData[1] is zone name/number
        -- C nData[2] is x coordinate
        -- C nData[3] is y coordinate
        -- C nData[4] is comment title
        -- C nData[5] is comment body
        -- C nData[6] is icon number/string
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
            elseif (nData[6] == 6) then
                Cartographer_Notes:SetNote(nData[1], nData[2]/100, nData[3]/100, "Vendor", "WHDB", 'title', nData[4], 'info', nData[5]);
            elseif (nData[6] == 7) then
                Cartographer_Notes:SetNote(nData[1], nData[2]/100, nData[3]/100, "AreaTrigger", "WHDB", 'title', nData[4], 'info', nData[5]);
            elseif (nData[6] ~= nil) then
                Cartographer_Notes:SetNote(nData[1], nData[2]/100, nData[3]/100, nData[6], "WHDB", 'title', nData[4], 'info', nData[5]);
            end
        end
        if (nData[1] ~= nil) and (not instance) then
            zone = nData[1];
            if nData[6] ~= 5 then
                WHDB_MARKED_ZONES[zone] = true;
            end
            title = nData[4];
        end
    end
    if (table.getn(WHDB_MAP_NOTES) ~= nil) and (not WHDB_InEvent) then
        local notes = table.getn(WHDB_MAP_NOTES);
        if (notes ~= WHDB_Notes) then
            WHDB_Print(notes.." notes plotted.");
            WHDB_Notes = notes;
        end
        WHDB_Print("Marked zones:");
        for k, v in pairs(WHDB_MARKED_ZONES) do
            WHDB_Print(k);
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

function WHDB_ShowMap()
    WHDB_Debug_Print(2, "WHDB_ShowMap() called");
    local ShowMapZone, ShowMapTitle, ShowMapID = WHDB_PlotNotesOnMap();
    if (Cartographer) then
        if (ShowMapZone ~= nil) then
            WorldMapFrame:Show();
            if (ShowMapZone) then
                SetMapZoom(WHDB_GetMapIDFromZone(ShowMapZone));
            end
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
    if (WHDB_Settings.auto_plot) then
        WHDB_Settings.auto_plot = false;
        WHDB_CheckSetting("auto_plot")
        WHDB_Print("Auto plotting disabled.");
    end
    if (WHDB_Settings.questStarts) then
        WHDB_Settings.questStarts = false;
        WHDB_CheckSetting("questStarts")
        WHDB_Print("Quest start plotting disabled.");
    end
    if (ShaguDB_MAP_NOTES) then
        ShaguDB_CleanMap();
    end
    WHDB_CleanMap();
    WHDB_MARKED_ZONES = {};
    WHDB_QUEST_START_ZONES = {};
    WHDB_MARKED = {{},{},{}};
end -- WHDB_DoCleanMap()

function WHDB_SearchEndNPC(questID)
    WHDB_Debug_Print(2, "WHDB_SearchEndNPC("..questID..") called");
    for npc, data in pairs(npcData) do
        if (data[DB_NPC_ENDS] ~= nil) then
            for line, entry in pairs(data[DB_NPC_ENDS]) do
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
    local questTitle, level = GetQuestLogTitle(questLogID);
    SelectQuestLogEntry(questLogID);
    local questDescription, questObjectives = GetQuestLogQuestText();
    if (questObjectives == nil) then questObjectives = ''; end
    local qIDs = WHDB_GetQuestIDs(questTitle, questObjectives, level);
    if qIDs ~= false then
        WHDB_Debug_Print(2, "    "..type(qIDs));
    end
    if (qIDs ~= false) then
        if (type(qIDs) == "table") then
            local multi = 0;
            local npcIDs = {}
            for n, qID in pairs(qIDs) do
                multi = multi + 1;
                local npcID = WHDB_SearchEndNPC(qID);
                if (npcID) then
                    local done = false;
                    for n, IDInside in pairs(npcIDs) do
                        if (npcID == IDInside) then
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
                        local comment = npcData[npcID][DB_NAME].."\n("..multi.." quests with this name)"
                        WHDB_MarkForPlotting(DB_NPC, npcID, commentTitle, "Finished by: |cFFa6a6a6"..comment.."|r", 2);
                    end
                else
                    local npcID = npcIDs[1]
                    local comment = npcData[npcID][DB_NAME].."\n(Ends "..multi.." quests with this name)"
                    return WHDB_MarkForPlotting(DB_NPC, npcID, "|cFF33FF00"..questTitle.." (Complete)|r", "Finished by: |cFFa6a6a6"..comment.."|r", 2);
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
                            local comment = objData[objID][DB_NAME].."\n("..multi.." quests with this name)"
                            WHDB_MarkForPlotting(DB_OBJ, objID, commentTitle, "Finished by: |cFFa6a6a6"..comment.."|r", 2);
                        end
                    else
                        local objID = objIDs[1]
                        local comment = objData[objID][DB_NAME].."\n(Ends "..multi.." quests with this name)"
                        return WHDB_MarkForPlotting(DB_OBJ, objID, "|cFF33FF00"..questTitle.." (Complete)|r", "Finished by: |cFFa6a6a6"..comment.."|r", 2);
                    end
                else
                    return false;
                end
            end
            return true;
        elseif (type(qIDs) == "number") then
            local npcID = WHDB_SearchEndNPC(qIDs);
            if npcID and npcData[npcID] then
                local name = npcData[npcID][DB_NAME];
                return WHDB_MarkForPlotting(DB_NPC, npcID, "|cFF33FF00"..questTitle.." (Complete)|r", "Finished by: |cFFa6a6a6"..name.."|r", 2);
            else
                local objID = WHDB_SearchEndObj(qIDs);
                if objID and objData[objID] then
                    local name = objData[objID][DB_NAME];
                    return WHDB_MarkForPlotting(DB_OBJ, objID, "|cFF33FF00"..questTitle.." (Complete)|r", "Finished by: |cFFa6a6a6"..name.."|r", 2);
                else
                    return false;
                end
            end
        end
    else
        return false;
    end
end -- WHDB_GetQuestEndNotes(questLogID)

function WHDB_GetQuestIDs(questName, objectives, ...)
    if not qLookup[questName] then
        return false;
    end
    local qIDs = {};
    if (objectives == nil) then objectives = ''; end
    WHDB_Debug_Print(2, "WHDB_GetQuestIDs('"..questName.."', '"..objectives.."')", arg[1]);
    if (WHDB_GetTableLength(qLookup[questName]) == 1) then
        for k, v in pairs(qLookup[questName]) do
            WHDB_Debug_Print(2, "    Possible questIDs: 1");
            return k;
        end
    else
        if (objectives ~= '') then
            for k, v in pairs(qLookup[questName]) do
                if v == objectives then -- implicit nil ~= string
                    table.insert(qIDs, k);
                end
            end
        end
        if (table.getn(qIDs) == 0) then
            for k, v in pairs(qLookup[questName]) do
                table.insert(qIDs, k);
            end
        end
        if (WHDB_GetTableLength(qIDs) > 1) then
            local level = arg[1];
            if level then
                for k, v in pairs(qIDs) do
                    if qData[v][DB_LEVEL] ~= level and level ~= UnitLevel("player") then
                        qIDs[k] = nil;
                    end
                end
            end
        end
    end
    local length = WHDB_GetTableLength(qIDs);
    WHDB_Debug_Print(2, "    Possible questIDs: ", length);
    if (length == nil) then
        return false;
    elseif (length == 1) then
        for k, v in pairs(qIDs) do
            return v;
        end
    else
        return qIDs;
    end
end -- WHDB_GetQuestIDs(questName, objectives)

-- TODO 19 npc names are used twice. first found is chosen atm
function WHDB_GetNPCID(npcName)
    WHDB_Debug_Print(2, "WHDB_GetNPCID("..npcName..") called");
    for npcid, data in pairs(npcData) do
        if (data[DB_NAME] == npcName) then return npcid; end
    end
    return false;
end -- WHDB_GetNPCID(npcName)

function WHDB_GetObjID(objName)
    WHDB_Debug_Print(2, "WHDB_GetObjID("..objName..") called");
    local objIDs = {};
    for objID, data in pairs(objData) do
        if (data[DB_NAME] == objName) then
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
        ["questStarts"] = "Quest start plotting",
        ["questIds"] = "Quest IDs in tooltips"
    };
    if (WHDB_Settings[setting] == false) then
        WHDB_Settings[setting] = true;
        WHDB_Print(text[setting].." enabled.");
    else
        WHDB_Settings[setting] = false;
        WHDB_Print(text[setting].." disabled.");
    end
    WHDB_CheckSetting(setting);
    if (setting == "auto_plot") and (WHDB_Settings[setting]) then
        WHDB_PlotAllQuests();
    elseif (setting == "auto_plot") and (not WHDB_Settings[setting]) then
        WHDB_CleanMap();
    end
end -- WHDB_SwitchSetting(setting)

function WHDB_CheckSetting(setting)
    if (WHDB_Settings[setting] == true) then
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
            if (npcData[npcID][DB_NPC_WAYPOINTS] and WHDB_Settings.waypoints == true) then
                for zoneID, coordsdata in pairs(npcData[npcID][DB_NPC_WAYPOINTS]) do
                    zoneName = zoneData[zoneID];
                    for cID, coords in pairs(coordsdata) do
                        if (coords[1] == -1) then
                            for id, data in pairs(instanceData[zoneID]) do
                                noteZone = zoneData[data[1] ];
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
            if (npcData[npcID][DB_NPC_SPAWNS]) then
                for zoneID, coordsdata in pairs(npcData[npcID][DB_NPC_SPAWNS]) do
                    if (zoneID ~= 5 and zoneID ~= 6) then
                        zoneName = zoneData[zoneID];
                        for cID, coords in pairs(coordsdata) do
                            if (coords[1] == -1) and (instanceData[zoneID]) then
                                for id, data in pairs(instanceData[zoneID]) do
                                    noteZone = zoneData[data[1] ];
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
                if (objData[objID][DB_OBJ_SPAWNS]) then
                    for zoneID, coordsdata in pairs(objData[objID][DB_OBJ_SPAWNS]) do
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

function WHDB_PrepareItemNotes(itemNameOrID, commentTitle, comment, icon)
    WHDB_Debug_Print(2, "WHDB_PrepareItemNotes("..itemNameOrID..") called");
    local itemID = 0;
    if (type(itemNameOrID) == "number") then
        itemID = itemNameOrID;
    elseif (type(itemNameOrID) == "string") then
        itemID = itemLookup[itemNameOrID];
    end
    -- if recursively called
    if (type(commentTitle) == "number") then
        for name, id in pairs(itemLookup) do
            if (id == commentTitle) then
                commentTitle = name;
                break;
            end
        end
    end
    if (itemData[itemID]) then
        local showMap = false;
        if (itemData[itemID][DB_NPC]) then
            for key, value in pairs(itemData[itemID][DB_NPC]) do
                if npcData[value[1]] then
                    local show = true;
                    if (WHDB_Settings.minDropChance > 0) and (value[2] < WHDB_Settings.minDropChance) then
                        show = false;
                    end
                    if show then
                        local dropComment = " ("..value[2].."%)";
                        showMap = WHDB_MarkForPlotting(DB_NPC, value[1], commentTitle, comment..dropComment, icon) or showMap;
                    end
                end
            end
        end
        if (itemData[itemID][DB_OBJ]) then
            for key, value in pairs(itemData[itemID][DB_OBJ]) do
                if objData[value[1]] then
                    local show = true;
                    if (WHDB_Settings.minDropChance > 0) and (value[2] < WHDB_Settings.minDropChance) then
                        show = false;
                    end
                    if show then
                        local dropComment = objData[value[1]][DB_NAME].."\n"..comment.." ("..value[2].."%)";
                        showMap = WHDB_MarkForPlotting(DB_OBJ, objData[value[1]][DB_NAME], commentTitle, dropComment, icon) or showMap;
                    end
                end
            end
        end
        if (itemData[itemID][DB_ITM]) and (WHDB_Settings.item_item) then
            for key, value in pairs(itemData[itemID][DB_ITM]) do
                local show = true;
                if (WHDB_Settings.minDropChance > 0) and (value[2] < WHDB_Settings.minDropChance) then
                    show = false;
                end
                if show then
                    local dropComment = "|cFF00FF00"..value[2].."% chance of containing "..commentTitle.."|r\n"
                    showMap = WHDB_PrepareItemNotes(value[1], commentTitle, dropComment..comment, icon) or showMap;
                end
            end
        end
        if (itemData[itemID][DB_VENDOR]) then
            for key, value in pairs(itemData[itemID][DB_VENDOR]) do
                local npc, maxcount, increaseTime = value[1], value[2], value[3];
                if npcData[npc] then
                    local sellComment = '';
                    if maxcount then
                        sellComment = "Sold by: "..npcData[npc][DB_NAME].."\nMax available: "..maxcount.."\nRestock time: "..WHDB_GetTimeString(increaseTime).."\n"..comment;
                    else
                        sellComment = "Sold by: "..npcData[npc][DB_NAME].."\n"..comment;
                    end
                    showMap = WHDB_MarkForPlotting(DB_NPC, npc, commentTitle, sellComment, 6) or showMap;
                else
                    WHDB_Debug_Print(2, "Spawn Error for NPC", npc);
                end
            end
        end
        return showMap;
    else
        return false;
    end
end -- WHDB_PrepareItemNotes(itemNameOrID, commentTitle, comment, icon)

function WHDB_GetTimeString(seconds)
    local hour, minute, second;
    hour = math.floor(seconds/(60*60));
    minute = math.floor(mod(seconds/60, 60));
    second = mod(seconds, 60);
    return string.format("%.2d:%.2d:%.2d", hour, minute, second);
end

function WHDB_GetSpecialNpcNotes(qId, objectiveText, numItems, numNeeded, title)
    local showMap = false;
    for _, v in pairs(qData[qId][DB_REQ_NPC_OR_OBJ_OR_ITM][DB_NPC]) do
        if v[2] ~= nil and v[2] == objectiveText then
            local comment = "|cFF00FF00"..objectiveText..":  "..numItems.."/"..numNeeded.."|r";
            showMap = WHDB_MarkForPlotting(DB_NPC, v[1], title, comment, WHDB_cMark) or showMap;
        end
    end
    return showMap;
end

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
        SelectQuestLogEntry(questLogID);
        local questDescription, questObjectives = GetQuestLogQuestText();
        local qIDs = WHDB_GetQuestIDs(questTitle, questObjectives, level);
        local title = "";
        if (type(qIDs) == "number") then
            WHDB_Debug_Print(2, "    qID = "..qIDs);
            local level = qData[qIDs][DB_LEVEL];
            if level == -1 then level = UnitLevel("player"); end
            title = WHDB_GetDifficultyColor(qData[qIDs][DB_LEVEL]).."["..level.."] "..questTitle.."|r";
        elseif (type(qIDs) == "table") then
            numQuests = 0;
            for k, qID in pairs(qIDs) do
                WHDB_Debug_Print(2, "    qID["..k.."] = "..qID);
                numQuests = numQuests + 1;
            end
            title = questTitle.."|cFFa6a6a6 (there are "..numQuests.." Quests with this name)|r";
        else
            WHDB_Debug_Print(1, "Failed to find Quest ID for: "..questTitle)
            title = questTitle
        end
        if (numObjectives ~= nil) then
            for i=1, numObjectives, 1 do
                local text, objectiveType, finished = GetQuestLogLeaderBoard(i, questLogID);
                local i, j, itemName, numItems, numNeeded = strfind(text, "(.*):%s*([%d]+)%s*/%s*([%d]+)");
                if itemName then
                    WHDB_Debug_Print(2, "    objectiveText = "..itemName);
                end
                if (not finished) then
                    if (objectiveType == "monster") then
                        WHDB_Debug_Print(2, "    type = monster");
                        local i, j, monsterName = strfind(itemName, "(.*) slain");
                        if monsterName then
                            local npcID = WHDB_GetNPCID(monsterName);
                            if npcID then
                                local comment = "|cFF00FF00"..itemName..":  "..numItems.."/"..numNeeded.."|r";
                                showMap = WHDB_MarkForPlotting(DB_NPC, npcID, title, comment, WHDB_cMark) or showMap;
                            end
                        else
                            if (type(qIDs) == "number") then
                                showMap = WHDB_GetSpecialNpcNotes(qIDs, itemName, numItems, numNeeded, title) or showMap;
                            elseif (type(qIDs) == "table") then
                                for _, qId in pairs(qIDs) do
                                    showMap = WHDB_GetSpecialNpcNotes(qId, itemName, numItems, numNeeded, title) or showMap;
                                end
                            end
                        end
                    elseif (objectiveType == "item") then
                        WHDB_Debug_Print(2, "    type = item");
                        local itemID = itemLookup[itemName];
                        if (itemID and (itemData[itemID])) then
                            local comment = "|cFF00FF00"..itemName..": "..numItems.."/"..numNeeded.."|r"
                            showMap = WHDB_PrepareItemNotes(itemID, title, comment, WHDB_cMark) or showMap;
                        end
                    elseif (objectiveType == "object") then
                        WHDB_Debug_Print(2, "    type = object");
                        if (type(qIDs) == "number") then
                            if qData[qIDs][DB_REQ_NPC_OR_OBJ_OR_ITM][DB_OBJ] then
                                for key, data in pairs(qData[qIDs][DB_REQ_NPC_OR_OBJ_OR_ITM][DB_OBJ]) do
                                    local objectId, objectiveText = data[1], data[2];
                                    if (objData[objectId] and objectiveText == itemName) then
                                        local comment = "|cFF00FF00";
                                        if (numNeeded == "1") then
                                            comment = comment..objectiveText.."|r\n";
                                        else
                                            comment = comment..objectiveText..": "..numItems.."/"..numNeeded.."|r\n";
                                        end
                                        showMap = WHDB_MarkForPlotting(DB_OBJ, objectId, title, comment, WHDB_cMark) or showMap;
                                    end
                                end
                            end
                        elseif (type(qIDs) == "table") then
                            for k, qID in pairs(qIDs) do
                                if qData[qID][DB_REQ_NPC_OR_OBJ_OR_ITM][DB_OBJ] then
                                    for key, data in pairs(qData[qID][DB_REQ_NPC_OR_OBJ_OR_ITM][DB_OBJ]) do
                                        local objectId, objectiveText = data[1], data[2];
                                        if (objData[objectId] and objectiveText == itemName) then
                                            local comment = "|cFF00FF00";
                                            if (numItems == "1") then
                                                comment = comment..objectiveText.."|r\n";
                                            else
                                                comment = comment..objectiveText..": "..numItems.."/"..numNeeded.."|r\n";
                                            end
                                            showMap = WHDB_MarkForPlotting(DB_OBJ, objectId, title, comment, WHDB_cMark) or showMap;
                                        end
                                    end
                                end
                            end
                        end
                    elseif (objectiveType == "event") then
                        if (type(qIDs) == "number") then
                            if qData[qIDs][DB_TRIGGER] then
                                WHDB_PREPARE[DB_TRIGGER_MARKED][qIDs] = true;
                            end
                        elseif (type(qIDs) == "table") then
                            for k, qID in pairs(qIDs) do
                                if qData[qIDs][DB_TRIGGER] then
                                    WHDB_PREPARE[DB_TRIGGER_MARKED][qID] = true;
                                end
                            end
                        end
                    -- checks for objective type other than item/monster/object, e.g. reputation, event
                    elseif (objectiveType ~= "item" and objectiveType ~= "monster" and objectiveType ~= "object" and objectiveType ~= "event") then
                        WHDB_Debug_Print(1, "    "..objectiveType.." quest objective-type not supported yet");
                    end
                end
            end
            if (type(qIDs) == "number") then
                if qData[qIDs][DB_REQ_NPC_OR_OBJ_OR_ITM][DB_ITM] then
                    for k, itemID in pairs(qData[qIDs][DB_REQ_NPC_OR_OBJ_OR_ITM][DB_ITM]) do
                        local comment = "Drop for quest related item:\n"..itemData[itemID][DB_ITM_NAME];
                        showMap = WHDB_PrepareItemNotes(itemID, title, comment, WHDB_cMark) or showMap;
                    end
                end
            end
            if (type(qIDs) == "table") then
                for k, qID in pairs(qIDs) do
                    if qData[qIDs][DB_REQ_NPC_OR_OBJ_OR_ITM][DB_ITM] then
                        for k, itemID in pairs(qData[qIDs][DB_REQ_NPC_OR_OBJ_OR_ITM][DB_ITM]) do
                            local comment = "Drop for quest related item:\n"..itemData[itemID][DB_ITM_NAME];
                            showMap = WHDB_PrepareItemNotes(itemID, title, comment, WHDB_cMark) or showMap;
                        end
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
function WHDB_GetNPCStatsComment(npcNameOrID, ...)
    local color = arg[1];
    local colorStringMin = "|cFFFFFFFF";
    local colorStringMax = "|cFFFFFFFF";
    if (color) and (type(color) ~= "boolean") and (type(color)  ~= "string") then
        if (bit.band(36, bit.lshift(1, color))) ~= 0 then
            color = false;
        end
    elseif (type(color) == "string") then
        color = true;
    else
        color = true;
    end
    WHDB_Debug_Print(2, "WHDB_GetNPCStatsComment("..npcNameOrID..") called");
    local npcID = 0;
    if (type(npcNameOrID) == "string") then
        npcID = WHDB_GetNPCID(npcNameOrID);
    else
        npcID = npcNameOrID;
    end
    if (npcID ~= 0) and (npcData[npcID] ~= nil) then
        local rank = "";
        if npcData[npcID][DB_RANK] ~= 0 then
            if npcData[npcID][DB_RANK] == 1 then rank = "Elite";
            elseif npcData[npcID][DB_RANK] == 2 then rank = "Rare Elite";
            elseif npcData[npcID][DB_RANK] == 3 then rank = "World Boss";
            elseif npcData[npcID][DB_RANK] == 4 then rank = "Rare";
            end
        end
        if npcData[npcID][DB_LEVEL] ~= npcData[npcID][DB_MIN_LEVEL] then
            local maxLevel = npcData[npcID][DB_LEVEL];
            local minLevel = npcData[npcID][DB_MIN_LEVEL];
            local colorStringMax = WHDB_GetDifficultyColor(maxLevel);
            local colorStringMin = WHDB_GetDifficultyColor(minLevel);
            return colorStringMax..npcData[npcID][DB_NAME].."|r\nLevel: "..colorStringMin..minLevel.."|r - "..colorStringMax..maxLevel.." "..rank.."|r\n".."Health: "..colorStringMin..npcData[npcID][DB_MIN_LEVEL_HEALTH].."|r - "..colorStringMax..npcData[npcID][DB_MAX_LEVEL_HEALTH].."|r\n";
        else
            local colorString = WHDB_GetDifficultyColor(npcData[npcID][DB_LEVEL]);
            return colorString..npcData[npcID][DB_NAME].."|r\nLevel: "..colorString..npcData[npcID][DB_MIN_LEVEL].." "..rank.."|r\n".."Health: "..colorString..npcData[npcID][DB_MIN_LEVEL_HEALTH].."|r\n";
        end
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
        if WHDB_QUEST_START_ZONES[zoneID] == true then
            return;
        else
            WHDB_QUEST_START_ZONES[zoneID] = true;
        end
        WHDB_PREPARE = WHDB_MARKED;
        -- TODO: add hide option to right click menu
        for id, data in pairs(npcData) do
            if (data[DB_NPC_SPAWNS][zoneID] ~= nil) and (data[DB_NPC_STARTS] ~= nil) then
                local comment = WHDB_GetQuestStartComment(data[DB_NPC_STARTS]);
                if (comment ~= "") then -- (comment == "") => other faction quest
                    WHDB_MarkForPlotting(DB_NPC, id, data[DB_NAME], "Starts quests:\n"..comment, 5);
                end
            end
        end
        for id, data in pairs(objData) do
            if (data[DB_OBJ_SPAWNS][zoneID] ~= nil) and (data[DB_STARTS] ~= nil) then
                local comment = WHDB_GetQuestStartComment(data[DB_STARTS]);
                if (comment ~= "") then
                    WHDB_MarkForPlotting(DB_OBJ, id, data[DB_NAME], "Starts quests:\n"..comment, 5);
                end
            end
        end
        local _,_,_ = WHDB_PlotNotesOnMap();
    end
end -- WHDB_GetQuestStartNotes(zoneName)

function WHDB_GetQuestStartComment(npcOrGoStarts)
    local tooltipText = "";
    for key, questID in npcOrGoStarts do
        if (qData[questID]) and (WHDB_FinishedQuests[questID] ~= true) then
            local tooHigh = false;
            if (WHDB_Settings.filterReqLevel == true) and (qData[questID][DB_MIN_LEVEL] > UnitLevel("player")) then
                tooHigh = true;
            end
            local colorString = WHDB_GetDifficultyColor(qData[questID][DB_LEVEL]);
            local level = qData[questID][DB_LEVEL];
            if level == -1 then level = UnitLevel("player"); end
            if not tooHigh then
                tooltipText = tooltipText..colorString.."["..level.."] "..qData[questID][DB_NAME].."|r\n";
                if WHDB_Settings.questIds and WHDB_Settings.reqLevel then
                    tooltipText = tooltipText.."|cFFa6a6a6(ID: "..questID..") | |r";
                elseif WHDB_Settings.questIds and not toHigh then
                    tooltipText = tooltipText.."|cFFa6a6a6(ID: "..questID..")|r\n";
                end
                if WHDB_Settings.reqLevel then
                    tooltipText = tooltipText.."|cFFa6a6a6Requires level: "..qData[questID][DB_MIN_LEVEL].."|r\n";
                end
            end
        end
    end
    return tooltipText;
end

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
    WHDB_PREPARE = WHDB_MARKED;
    WHDB_GetQuestNotes(GetQuestLogSelection())
    WHDB_ShowMap();
end -- WHDB_GetSelectionQuestNotes()

function WHDB_GetTableLength(tab)
    if tab then
        local count = 0;
        for k, v in pairs(tab) do
            count = count + 1;
        end
        return count;
    else
        return 0;
    end
end -- WHDB_GetTableLength()

function WHDB_CompareTables(tab1, tab2)
    for k, v in pairs(tab1) do
        if (type(v) == "table") then
            if not WHDB_CompareTables(v, tab2[k]) then
                return false;
            end
        else
            if not (v == tab2[k]) then
                return false;
            end
        end
    end
    return true;
end

function WHDB_PrintTable(tab, indent)
    local iString = "";
    local ind = indent;
    while (ind > 0) do
        iString = iString.."-";
        ind = ind -1;
    end
    for k, v in pairs(tab) do
        if (type(v) == "table") then
            WHDB_Print(iString..k..":");
            WHDB_PrintTable(v, indent+1);
        else
            if (v) then
                WHDB_Print(iString..k..": "..v);
            else
                WHDB_Print(iString..k..": ".."nil");
            end
        end
    end
end

function WHDB_GetDifficultyColor(level1, ...)
    if level1 == -1 then
        level1 = UnitLevel("player");
    end
    local level2 = 0;
    if type(arg[1]) ~= "number" then
        level2 = UnitLevel("player");
    end
    if (level1 > (level2 + 4)) then
        return "|cFFFF1A1A"; -- Red
    elseif (level1 > (level2 + 2)) then
        return "|cFFFF8040"; -- Orange
    elseif (level1 <= (level2 + 2)) and (level1 >= (level2 - 2)) then
        return "|cFFFFFF00"; -- Yellow
    elseif (level1 > WHDB_GetGreyLevel(level2)) then
        return "|cFF40C040"; -- Green
    else
        return "|cFFC0C0C0"; -- Grey
    end
    return "|cFFffffff";
end

function WHDB_GetGreyLevel(level)
    if (level <= 5) then
        return 0;
    elseif (level <= 39) then
        return (level - math.floor(level/10) - 5);
    else
        return (level - math.floor(level/5) - 1);
    end
end

function WHDB_MarkForPlotting(kind, nameOrId, title, comment, icon, ...)
    WHDB_Debug_Print(2, "WHDB_MarkForPlotting("..kind..", "..nameOrId..") called");
    if kind == DB_NPC then
        local npcID = 0;
        if type(nameOrId) == "number" then
            npcID = nameOrId;
        else
            npcID = WHDB_GetNPCID(nameOrId);
        end
        if npcID and npcID ~=0 then
            if not WHDB_PREPARE[DB_NPC][npcID] then WHDB_PREPARE[DB_NPC][npcID] = {}; end
            WHDB_FillPrepare(WHDB_PREPARE[DB_NPC][npcID], title, comment, icon);
            return true;
        end
    elseif kind == DB_OBJ then
        local objIDs = 0;
        if type(nameOrId) == "number" then
            objIDs = {nameOrId};
        else
            objIDs = WHDB_GetObjID(nameOrId);
        end
        if objIDs and objIDs ~= 0 then
            for k, objID in pairs(objIDs) do
                if not WHDB_PREPARE[DB_OBJ][objID] then WHDB_PREPARE[DB_OBJ][objID] = {}; end
                WHDB_FillPrepare(WHDB_PREPARE[DB_OBJ][objID], title, comment, icon);
            end
            return true;
        end
    elseif kind == DB_ITM then
        local itmID = 0;
        if type(nameOrId) == "number" then
            itmID = nameOrId;
        else
            itmID = itemLookup[nameOrId];
        end
        if itmID and itmID ~=0 then
            WHDB_PrepareItemNotes(itmID, title, comment, icon);
            return true;
        end
    end
    return false;
end

function WHDB_FillPrepare(tab, title, comment, icon)
    WHDB_Debug_Print(2, title.." - "..comment.." - "..icon..tostring(tab))
    if tab then
        local added = false;
        for k, v in tab do
            if v[NOTE_TITLE] == title then
                if v[NOTE_ICON] ~= icon then
                    if (v[NOTE_ICON] == 2) or (icon == 2) then
                        v[NOTE_ICON] = 2;
                    else
                        v[NOTE_ICON] = 0;
                    end
                end
                v[NOTE_COMMENT] = v[NOTE_COMMENT].."\n"..comment;
                added = true;
            end
        end
        if not added then
            table.insert(tab, {title, comment, icon})
        end
    else
        tab = {{title, comment, icon}};
    end
    return true;
end
