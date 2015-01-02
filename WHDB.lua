----------------------------------------------------------------------------------------------------------------------
-- Wowhead DB By: UniRing
----------------------------------------------------------------------------------------------------------------------
-- Wowhead DB Enhanced By: Redshadowz, me
-- E = WHDB Enhanced comment header
-- EWHDB = comments on original code, to explain it to myself or disable it
-- E
-- E changes on the original WHDB code by Redshadowz (see link below) have been commented
-- E in order to divide the code in original Rapid Quest Pack, Redshadow's and mine
-- E http://www.wow-one.com/forum/topic/4430-quest-helper-for-1121/page__st__60__p__482768#entry482768
----------------------------------------------------------------------------------------------------------------------
WHDB_MAP_NOTES = {};
WHDB_QuestZoneInfo = {};
WHDB_Player = "";

function WHDB_Init()
	-- E changed VARIABLES_LOADED to PLAYER_LOGIN
	this:RegisterEvent("PLAYER_LOGIN");
	-- E events registered for testing purposes. until ...
	--this:RegisterEvent("ZONE_CHANGED");
	--this:RegisterEvent("ZONE_CHANGED_INDOORS");
	--this:RegisterEvent("ZONE_CHANGED_NEW_AREA");
	-- E ... here
	SlashCmdList["WHDB"] = WHDB_Slash;
	SLASH_WHDB1 = "/whdb";
end

function WHDB_Event(event)
	if (event == "PLAYER_LOGIN") then
		if (Cartographer_Notes ~= nil) then
			WHDBDB = {}; WHDBDBH = {};
			Cartographer_Notes:RegisterNotesDatabase("WHDB",WHDBDB,WHDBDBH);
			WHDB_Print("Cartographer Database Registered.");
		end
		--Free the oposite faction database. -- not working in 1.12.1 UnitFactionGroup not init yet
		-- E Bullshit. UnitFactionGroup is working, but not initialised when VARIABLES_LOADED event fires,
		-- E so changed to PLAYER_LOGIN event and modified it a bit (else-if and else). changes until...
		fac = UnitFactionGroup("player")
		if (fac == "Alliance") then
			qData["Horde"] = nil;
			WHDB_Print("Horde data cleared.");
		elseif (fac == "Horde") then
			qData["Alliance"] = nil;
			WHDB_Print("Alliance data cleared.");
		else
			WHDB_Print("Use /reloadUI to dump opposite faction quests.");
		end
		-- E ... here
		WHDB_Player = UnitName("player");
		if (WHDB_Settings == nil) then
			WHDB_Settings = {};
			WHDB_Settings[WHDB_Player] = {};
			WHDB_Settings[WHDB_Player]["UseColors"] = 1;
		else
			if (WHDB_Settings[WHDB_Player] == nil) then
				WHDB_Settings[WHDB_Player] = {};
				WHDB_Settings[WHDB_Player]["UseColors"] = 1;
			end
		end
		WHDB_ShowUsingInfo();
		WHDB_Print("WHDB Loaded.");
	-- E debug until ...
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
	-- E ... here
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
	local params = {};
	
	-- E fixed by exchanging returns from string.gmatch()-function on top
	-- E with string.sub()-function in the if-statements and writing a
	-- E workaround in the section for comments display
	
	-- EWHDB for v in string.gmatch(input, "[^ ]+") do
	-- EWHDB	    tinsert(params, v);
	-- EWHDB end
	if (string.sub(input,1,4) == "help" or input == "") then
		WHDB_Print("Commands available:");
		WHDB_Print("-------------------------------------------------------");
		WHDB_Print("/whdb help | This help.");
		WHDB_Print("/whdb com <quest name> | Get quest comments by quest name.");
		WHDB_Print("/whdb item <item name> | Get item drop info and show map if possible.");
		WHDB_Print("/whdb mob <monster name> | Get monser location and show map if possible.");
		WHDB_Print("/whdb clean | Clean map notes.");
		WHDB_Print("/whdb colors <0 or 1>| Enable/Disable coloring of text in the quest log.");
		WHDB_Print("/whdb copy <character>| Copy characters config to current one.");
		WHDB_Print("");
		WHDB_Print("Note: All parameters are case sensitive!");
	end
	if (string.sub(input,1,3) == "com") then
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
			-- E commented because string.gmatch is not working
			-- EWHDB for v in string.gmatch(QuestComments, "[^\n]+") do
			-- EWHDB 	WHDB_Print(v);
			-- EWHDB end
			
			-- E replacement for gmatch code. calls WHDB_Print too much. changes until ...
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
			t = string.sub(QuestComments, i);
			WHDB_Print(t);
			-- E ... here
		end
	end
	if (string.sub(input,1,4) == "item") then
		local itemName = string.sub(input, 6);
		if (string.sub(itemName,1,1) == "|") then
			_, _, _, itemName = string.find(itemName, "^|c%x+|H(.+)|h%[(.+)%]")
		end
		WHDB_Print("Drops for: "..itemName);
		WHDB_Print("---------------------------------------------------");
		if (itemName ~= "") then
			if (itemData[itemName] ~= nil) then
				local showmax = 5;
				for monsterName, monsterDrop in pairs(itemData[itemName]) do
					zoneName = zoneData[npcData[monsterName]["zone"]];
					if (zoneName == nil) then zoneName = npcData[monsterName]["zone"]; end
					local dropRate = monsterDrop;
					if (dropRate == nil) then dropRate = ""; else dropRate = dropRate .. "%"; end
					WHDB_Print("Dropped by: " .. monsterName);
					WHDB_Print_Indent("Drop Rate: " .. dropRate);
					WHDB_Print_Indent("Zone: " .. zoneName);
					WHDB_Print_Indent("Coords: " .. npcData[monsterName]["coords"][1]);
					-- Map plotting
					if (MetaMapNotes_AddNewNote ~= nil or MapNotes_Data_Notes ~= nil or Cartographer_Notes ~= nil) then
						local showMap = false;
						WHDB_MAP_NOTES = {};
						for cid, cdata in pairs(npcData[monsterName]["coords"]) do
							local f, t, coordx, coordy = strfind(npcData[monsterName]["coords"][cid], "(.*),(.*)");
							table.insert(WHDB_MAP_NOTES,{zoneName, coordx, coordy, itemName, monsterName .. "\nDrop: " .. dropRate, 0});
							if (MetaMapNotes_AddNewNote ~= nil or MapNotes_Data_Notes ~= nil or Cartographer_Notes ~= nil) then 
								showMap = true;
							end
						end
						if (showMap) then
							WHDB_ShowMap();
						end
					end					
					showmax = showmax - 1;
					if (showmax == 0) then
						WHDB_Print("Showing only the 5 first results.");
						break;
					end
				end
			end
		end
	end
	if (string.sub(input,1,3) == "mob") then
		local monsterName = string.sub(input, 5);
		if (monsterName ~= "") then
			WHDB_Print("Location for: "..monsterName);
			if (monsterName ~= nil) then
				if (npcData[monsterName] ~= nil) then
					zoneName = zoneData[npcData[monsterName]["zone"]];
					if (zoneName == nil) then zoneName = npcData[monsterName]["zone"]; end
					WHDB_Print_Indent("Zone: " .. zoneName);
					WHDB_Print_Indent("Coords: " .. npcData[monsterName]["coords"][1]);
					-- Map plotting
					if (MetaMapNotes_AddNewNote ~= nil or MapNotes_Data_Notes ~= nil or Cartographer_Notes ~= nil) then
						local showMap = false;
						WHDB_MAP_NOTES = {};
						for cid, cdata in pairs(npcData[monsterName]["coords"]) do
							local f, t, coordx, coordy = strfind(npcData[monsterName]["coords"][cid], "(.*),(.*)");
							table.insert(WHDB_MAP_NOTES,{zoneName, coordx, coordy, monsterName, coordx..","..coordy, 0});
							if (MetaMapNotes_AddNewNote ~= nil or MapNotes_Data_Notes ~= nil or Cartographer_Notes ~= nil) then							
								showMap = true;
							end
						end
						if (showMap) then
							WHDB_ShowMap();
						end
					end
				end
			end			
		end
	end
	if (string.sub(input,1,5) == "clean") then
		WHDB_CleanMap();
	end
	if (string.sub(input,1,6) == "colors") then
		if (string.sub(input,8) == "1") then
			WHDB_Settings[WHDB_Player]["UseColors"] = 1;
			WHDB_Print("Text colors enabled.");
		end
		if (string.sub(input,8) == "0") then
			WHDB_Settings[WHDB_Player]["UseColors"] = 0;
			WHDB_Print("Text colors disabled.");
		end
	end
	if (string.sub(input,1,4) == "copy") then
		if (WHDB_Settings[string.sub(input,6)] ~= nil) then
			for k,v in pairs(WHDB_Settings[string.sub(input,6)]) do
				WHDB_Settings[WHDB_Player][k] = v;
			end
			WHDB_Print("Settings loaded.");
		else
			WHDB_Print("There are no settings for this character.");
		end
	end
end

function WHDB_Print( string )
	DEFAULT_CHAT_FRAME:AddMessage("|cFF006699[BSK]|cFF990099 WHDB:|r " .. string, 0.95, 0.95, 0.5);
end

function WHDB_Print_Indent( string )
	DEFAULT_CHAT_FRAME:AddMessage("                       " .. string, 0.95, 0.95, 0.5);
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

-- EWHDB Kind of the main function, most stuff happens here.
-- EWHDB It updates the Quest-Log with buttons, target info, comments, etc.,
-- EWHDB so nearly everything for Rapid Quest Pack functionality is in here.
function WHDB_QuestLog_UpdateQuestDetails(prefix, doNotScroll)
	if (getglobal(prefix.."QuestLogFrame"):IsVisible()) then
	WHDB_MAP_NOTES = {};
	local questID = GetQuestLogSelection();
	local questTitle = GetQuestLogTitle(questID);
	if ( not questTitle ) then
		questTitle = "";
	end
	if ( IsCurrentQuestFailed() ) then
		questTitle = questTitle.." - ("..TEXT(FAILED)..")";
	end
	getglobal(prefix.."QuestLogQuestTitle"):SetText(questTitle);

	local questDescription;
	local questObjectives;
	questDescription, questObjectives = GetQuestLogQuestText();
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
	-- E debug
	-- E DEFAULT_CHAT_FRAME:AddMessage(numObjectives);
	
	local monsterName, zoneName, noteAdded, showMap, noteID;
	for i=1, numObjectives, 1 do
		local string = getglobal(prefix.."QuestLogObjective"..i);
		local text;
		local type;
		local finished;
		text, type, finished = GetQuestLogLeaderBoard(i);
		-- E debug
		-- E DEFAULT_CHAT_FRAME:AddMessage(text);
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
		
		-- EWHDB checks objectives and saves map notes if coordinates are found
		if (type == "monster") then
			-- E debug
			-- E DEFAULT_CHAT_FRAME:AddMessage(type);
			local i, j, monsterName = strfind(itemName, "(.*) slain");
			if (monsterName ~= nil) then
				if (npcData[monsterName] ~= nil) then
					if (npcData[monsterName]["zone"] ~= nil) then
						zoneName = zoneData[npcData[monsterName]["zone"]];
					else
						zoneName = WHDB_QuestZoneInfo[questTitle];
					end
					Level = npcData[monsterName]["level"];
					HP = npcData[monsterName]["hp"];
					if (Level == nil) then Level = "Unknown"; end
					if (HP == nil) then HP = "Unknown"; end
					if (zoneName == nil) then zoneName = npcData[monsterName]["zone"]; end
					text = text.."\n";
					if (WHDB_Settings[WHDB_Player]["UseColors"] == 1) then
						text = text.."|cFF442200    Zone: " .. zoneName .. "\n|r";
						text = text.."|cFF002244    Level: " .. Level .. "\n|r";
						text = text.."|cFF002244    Health: " .. HP .. "\n|r";
						text = text.."|cFF224400    Coords: " .. npcData[monsterName]["coords"][1] .. "\n|r";
					else
						text = text.."    Zone: " .. zoneName .. "\n";
						text = text.."    Level: " .. Level .. "\n";
						text = text.."    Health: " .. HP .. "\n";
						text = text.."    Coords: " .. npcData[monsterName]["coords"][1] .. "\n";
					end
					if (MetaMapNotes_AddNewNote ~= nil or MapNotes_Data_Notes ~= nil or Cartographer_Notes ~= nil) then
						-- E Change by Redshadowz:
						-- E Not sure what it does exactly, seems to make map notes. Goes until ...
						if (npcData[monsterName]["coords"]) then
							for cid, cdata in pairs(npcData[monsterName]["coords"]) do
								local f, t, coordx, coordy = strfind(npcData[monsterName]["coords"][cid], "(.*),(.*)");
								table.insert(WHDB_MAP_NOTES,{zoneName, coordx, coordy, questTitle, monsterName, 0});
								if (MetaMapNotes_AddNewNote ~= nil or MapNotes_Data_Notes ~= nil or Cartographer_Notes ~= nil) then							
									showMap = true;
								end
							-- E ...here
							end
						end
					end
				end
			end
		-- E Change by Redshadowz:
		-- E if statement changed to elseif
		elseif (type == "item") then
			-- E debug
			-- E DEFAULT_CHAT_FRAME:AddMessage(type);
			if (itemData[itemName] ~= nil) then
				for monsterName, monsterDrop in pairs(itemData[itemName]) do
					if (npcData[monsterName] ~= nil) then
						if (npcData[monsterName]["zone"] ~= nil) then
							zoneName = zoneData[npcData[monsterName]["zone"]];
						else
							zoneName = WHDB_QuestZoneInfo[questTitle];
						end
						Level = npcData[monsterName]["level"];
						HP = npcData[monsterName]["hp"];
						if (Level == nil) then Level = "Unknown"; end
						if (HP == nil) then HP = "Unknown"; end
						if (zoneName == nil) then zoneName = npcData[monsterName]["zone"]; end
						local dropRate = monsterDrop;
						if (dropRate == nil) then dropRate = ""; else dropRate = dropRate .. "%"; end
						text = text.."\n";

							text = text.."    Dropped by: " .. monsterName .. "\n";
							text = text.."        Drop Rate: " .. dropRate .. "\n";
							text = text.."        Zone: " .. zoneName .. "\n";
							text = text.."        Level: " .. Level .. "\n";
							text = text.."        Health: " .. HP .. "\n";
							text = text.."        Coords: " .. npcData[monsterName]["coords"][1] .. "\n";
						
						if (MetaMapNotes_AddNewNote ~= nil or MapNotes_Data_Notes ~= nil or Cartographer_Notes ~= nil) then
							for cid, cdata in pairs(npcData[monsterName]["coords"]) do
								local f, t, coordx, coordy = strfind(npcData[monsterName]["coords"][cid], "(.*),(.*)");
								table.insert(WHDB_MAP_NOTES,{zoneName, coordx, coordy, questTitle, monsterName .. "\nDrop: " .. dropRate, 0});
								if (MetaMapNotes_AddNewNote ~= nil or MapNotes_Data_Notes ~= nil or Cartographer_Notes ~= nil) then 
									showMap = true;
								end
							end
						end
					end
				end
			end
		-- E check for objective type other than item or monster, e.g. objective, reputation
		elseif type ~= "item" and type ~= "monster" then
			-- E debug
			DEFAULT_CHAT_FRAME:AddMessage(type.."-quest objectives not supported yet by WHDB");
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
	
	local questComments = WHDB_GetComments(questTitle);

	if (getglobal(prefix.."QuestLogMapButtonsTitle") == nil) then
		getglobal(prefix.."QuestLogDetailScrollChildFrame"):CreateFontString(prefix.."QuestLogMapButtonsTitle","","QuestTitleFont");
		getglobal(prefix.."QuestLogDetailScrollChildFrame"):CreateFontString(prefix.."QuestLogCommentsTitle","","QuestTitleFont");
		getglobal(prefix.."QuestLogDetailScrollChildFrame"):CreateFontString(prefix.."QuestLogCommentsDescription","","QuestFont");
	end

	-- Copy description font color. (for skinner like addons)
	local r, g, b, a = getglobal(prefix.."QuestLogQuestDescription"):GetTextColor();
	
	getglobal(prefix.."QuestLogMapButtonsTitle"):SetHeight(0);
	getglobal(prefix.."QuestLogMapButtonsTitle"):SetWidth(285);
	getglobal(prefix.."QuestLogMapButtonsTitle"):SetPoint("TOPLEFT", prefix.."QuestLogQuestDescription", "BOTTOMLEFT", 0, -15);
	getglobal(prefix.."QuestLogMapButtonsTitle"):SetJustifyH("LEFT");
	getglobal(prefix.."QuestLogMapButtonsTitle"):SetText("Map Plots");
	getglobal(prefix.."QuestLogMapButtonsTitle"):SetTextColor(r, g, b, a);
	
	-- E code moved from further down and edited
	-- E quest rewards show before comments now
	-- E <<
	
	local numRewards = GetNumQuestLogRewards();
	local numChoices = GetNumQuestLogChoices();
	local money = GetQuestLogRewardMoney();
	local ttexture, tname, tisTradeskillSpell, tisSpellLearned = GetQuestLogRewardSpell();
	if ( (numRewards + numChoices + money) > 0 ) or (tname ~= nil) then
		-- E anchor reward text below map buttons
		getglobal(prefix.."QuestLogRewardTitleText"):SetPoint("TOPLEFT", prefix.."QuestLogMapButtonsTitle", "BOTTOMLEFT", 0, -40);
		-- E calculate space needed between rewards and comments in quest log
		local offs = 0;
		if numRewards > 0 then
			-- E two items display in a row in quest log so a third item would need a new row a fourth not
			-- E therefore divide numItems/2, which results in .5 values for uneven numbers, ...
			y = (numRewards/2);
			-- E ... which we round upwards, in case an uneven number was given, and we got the number of Rows we need
			x = math.floor(y + .5);
			-- E x*45 is for item rows, + 20 for text, modify these (50/20) if display is bugged
			offs = (x*45) + 25;
		end
		if numChoices > 0 then
			-- E see above
			y = (numChoices/2);
			x = math.floor(y + .5);
			-- E + 35 due to 2 rows of text being displayed for choices
			offs = offs + (x*45) + 35;
		end
		-- E money row if there are no rewards
		if money > 0 and numRewards == 0 then
			offs = offs + 25;
		end
		-- E check for spell reward
		if (tname ~= nil) then
			if (numRewards + money) == 0 then
				offs = offs + 25;
			end
			offs = offs + 50;
		end
		-- E offset has to be negative
		offs = offs * (-1);
		-- E anchor comments with offset (offs)
		getglobal(prefix.."QuestLogCommentsTitle"):SetPoint("TOPLEFT", prefix.."QuestLogRewardTitleText", "BOTTOMLEFT", 0, offs);
		getglobal(prefix.."QuestLogRewardTitleText"):Show();
		QuestFrame_SetAsLastShown(getglobal(prefix.."QuestLogRewardTitleText"));
	else
		getglobal(prefix.."QuestLogCommentsTitle"):SetPoint("TOPLEFT", prefix.."QuestLogMapButtonsTitle", "BOTTOMLEFT", 0, -50);
		getglobal(prefix.."QuestLogRewardTitleText"):Hide();
	end

	
	-- E >>
	
	getglobal(prefix.."QuestLogCommentsTitle"):SetHeight(0);
	getglobal(prefix.."QuestLogCommentsTitle"):SetWidth(285);
	-- EWHDB getglobal(prefix.."QuestLogCommentsTitle"):SetPoint("TOPLEFT", prefix.."QuestLogMapButtonsTitle", "BOTTOMLEFT", 0, -50);
	getglobal(prefix.."QuestLogCommentsTitle"):SetJustifyH("LEFT");
	getglobal(prefix.."QuestLogCommentsTitle"):SetText("Comments");
	getglobal(prefix.."QuestLogCommentsTitle"):SetTextColor(r, g, b, a);

	getglobal(prefix.."QuestLogCommentsDescription"):SetHeight(0);
	getglobal(prefix.."QuestLogCommentsDescription"):SetWidth(270);
	getglobal(prefix.."QuestLogCommentsDescription"):SetPoint("TOPLEFT", prefix.."QuestLogCommentsTitle", "BOTTOMLEFT", 0, -5);
	getglobal(prefix.."QuestLogCommentsDescription"):SetJustifyH("LEFT");
	getglobal(prefix.."QuestLogCommentsDescription"):SetText(questComments);
	getglobal(prefix.."QuestLogCommentsDescription"):SetTextColor(r, g, b, a);
	

	-- EWHDB getglobal(prefix.."QuestLogRewardTitleText"):SetPoint("TOPLEFT", prefix.."QuestLogCommentsDescription", "BOTTOMLEFT", 0, -15);

	QuestFrame_SetAsLastShown(getglobal(prefix.."QuestLogCommentsDescription"));
	if (MetaMapNotes_AddNewNote ~= nil or MapNotes_Data_Notes ~= nil or Cartographer_Notes ~= nil) then
		if (qData[UnitFactionGroup("player")][questTitle] ~= nil) then
			for id, comment in ipairs(qData[UnitFactionGroup("player")][questTitle]['comments']) do
				local f = 0;
				while f ~= nil do
					f, t, coordx, coordy = strfind(comment, "%[([0-9]*) ([0-9]*)%]", f+1);
					if (coordx ~= nil and coordy ~= nil) then
						WHDB_PopulateZones();
						if (WHDB_QuestZoneInfo[questTitle] ~= nil) then
							if (WHDB_GetMapIDFromZome(WHDB_QuestZoneInfo[questTitle]) ~= -1) then
								if (string.len(comment) > 150) then
									comment = string.sub(comment,1,150) .. "...";
								end
								table.insert(WHDB_MAP_NOTES,{WHDB_QuestZoneInfo[questTitle], coordx, coordy, questTitle, comment, 1});
								if (MetaMapNotes_AddNewNote ~= nil or MapNotes_Data_Notes ~= nil or Cartographer_Notes ~= nil) then
									showMap = true;
								end
							end
						end
					end
				end
			end
		end
		endq = SearchEndNPC(questTitle);
		if (endq ~= nil) then
			monsterName = endq;
			if (npcData[monsterName] ~= nil) then
				zoneName = zoneData[npcData[monsterName]["zone"]];
				if (zoneName == nil) then zoneName = npcData[monsterName]["zone"]; end
				if (MetaMapNotes_AddNewNote ~= nil or MapNotes_Data_Notes ~= nil or Cartographer_Notes ~= nil) then
					for cid, cdata in pairs(npcData[monsterName]["coords"]) do
						local f, t, coordx, coordy = strfind(npcData[monsterName]["coords"][cid], "(.*),(.*)");
						table.insert(WHDB_MAP_NOTES,{zoneName, coordx, coordy, "END: "..questTitle, monsterName, 2});
						if (MetaMapNotes_AddNewNote ~= nil or MapNotes_Data_Notes ~= nil or Cartographer_Notes ~= nil) then							
							showMap = true;
						end
					end
				end
			end
		end
	end

	if (getglobal(prefix.."QuestLogShowMap") == nil) then
		CreateFrame("Button", prefix.."QuestLogShowMap", getglobal(prefix.."QuestLogDetailScrollChildFrame"), "UIPanelButtonTemplate");
		CreateFrame("Button", prefix.."QuestLogCleanMap", getglobal(prefix.."QuestLogDetailScrollChildFrame"), "UIPanelButtonTemplate");
	end
	
	getglobal(prefix.."QuestLogShowMap"):SetText("Show Map");
	getglobal(prefix.."QuestLogShowMap"):SetPoint("TOPLEFT", prefix.."QuestLogMapButtonsTitle", "BOTTOMLEFT", 0, -10);
	getglobal(prefix.."QuestLogShowMap"):SetHeight(25);
	getglobal(prefix.."QuestLogShowMap"):SetWidth(105);
	getglobal(prefix.."QuestLogShowMap"):RegisterForClicks("LeftButtonUp");
	getglobal(prefix.."QuestLogShowMap"):SetScript("OnClick", WHDB_ShowMap);
	
	getglobal(prefix.."QuestLogCleanMap"):SetText("Clean Map");
	getglobal(prefix.."QuestLogCleanMap"):SetPoint("TOPLEFT", prefix.."QuestLogMapButtonsTitle", "BOTTOMLEFT", 110, -10);
	getglobal(prefix.."QuestLogCleanMap"):SetHeight(25);
	getglobal(prefix.."QuestLogCleanMap"):SetWidth(105);
	getglobal(prefix.."QuestLogCleanMap"):RegisterForClicks("LeftButtonUp");
	getglobal(prefix.."QuestLogCleanMap"):SetScript("OnClick", WHDB_CleanMap);

	-- E moved some code further up from here myself
	
	-- E Change by Redshadowz:
	-- E if and else statements uncommented until ...
	if (not showMap) then
		getglobal(prefix.."QuestLogShowMap"):Disable();
		getglobal(prefix.."QuestLogCleanMap"):Disable();
	else
		getglobal(prefix.."QuestLogShowMap"):Enable();
		getglobal(prefix.."QuestLogCleanMap"):Enable();
	end
	-- E ... here
	
	QuestFrameItems_Update("QuestLog");
	if ( not doNotScroll ) then
		getglobal(prefix.."QuestLogDetailScrollFrameScrollBar"):SetValue(0);
	end
	getglobal(prefix.."QuestLogDetailScrollFrame"):UpdateScrollChildRect();	
	end
end

function WHDB_PlotNotesOnMap()
	local zone = nil;
	local title = nil;
	local noteID = nil;
	
	local firstNote = 1;
	
	for nKey, nData in ipairs(WHDB_MAP_NOTES) do
		-- E WHDB_Print(nData[1]);
		
		-- E check for zoneId's instead of names
		if type(nData[1]) == number then
			nData[1] = zoneData[nData[1]]
		end
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
				Cartographer_Notes:SetNote(nData[1], nData[2]/100, nData[3]/100, "Star", "WHDB", 'title', nData[4], 'info', nData[5]);			
			elseif (nData[6] == 1) then
				Cartographer_Notes:SetNote(nData[1], nData[2]/100, nData[3]/100, "Diamond", "WHDB", 'title', nData[4], 'info', nData[5]);			
			elseif (nData[6] == 2) then
				Cartographer_Notes:SetNote(nData[1], nData[2]/100, nData[3]/100, "Circle", "WHDB", 'title', nData[4], 'info', nData[5]);			
			end
		end
		if (MapNotes_Data_Notes ~= nil) then
			local c, z = WHDB_GetMapIDFromZome(nData[1]);
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
	return zone, title, noteID;
end

function WHDB_GetMapIDFromZome(zoneText)
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
	local questComments = "";
	
	if (qData[UnitFactionGroup("player")][questTitle] ~= nil) then
		for id, comment in ipairs(qData[UnitFactionGroup("player")][questTitle]['comments']) do
			questComments = questComments .. comment .."\n\n";
		end
	else
		questComments = questComments  .. "No comments for this quest.\n\n";
	end
	questComments = questComments .. "";
	return questComments;
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
			SetMapZoom(WHDB_GetMapIDFromZome(ShowMapZone));
		end
	end
	if (MapNotes_Data_Notes ~= nil) then
		WorldMapFrame:Show();
		SetMapZoom(WHDB_GetMapIDFromZome(ShowMapZone));
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

function WHDB_PopulateZones()
	local numEntries, numQuests = GetNumQuestLogEntries();
	local lastZone, questLogTitleText, suggestedGroup, level, questTag, isHeader, isCollapsed, isComplete;
	for i=1, numEntries, 1 do
		questLogTitleText, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete = GetQuestLogTitle(i);
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
			if (data["ends"][1] == quest or data["ends"][2] == quest or data["ends"][3] == quest or data["ends"][4] == quest or data["ends"][5] == quest) then
				return npc;
			end
		end
	end
	return nil;
end
