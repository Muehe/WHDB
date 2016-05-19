DBGUI_SpawnButtons = {}
DBGUI_ItemButtons = {}
DBGUI_VendorButtons = {}
DBGUI_FavouritesEdit = {}
-- {{{ Favourite List
if DBGUI_Favourites == nil then
  DBGUI_Favourites = {
    ["spawn"] = {
      [1] = '',
      [2] = '',
      [3] = '',
      [4] = '',
      [5] = '',
      [6] = '',
      [7] = '',
      [8] = '',
      [9] = '',
      [10] = '',
      [11] = '',
      [12] = '',
      [13] = '',
    },
    ["item"] = {
      [1] = '',
      [2] = '',
      [3] = '',
      [4] = '',
      [5] = '',
      [6] = '',
      [7] = '',
      [8] = '',
      [9] = '',
      [10] = '',
      [11] = '',
      [12] = '',
      [13] = '',
    },
    ["vendor"] = {
      [1] = '',
      [2] = '',
      [3] = '',
      [4] = '',
      [5] = '',
      [6] = '',
      [7] = '',
      [8] = '',
      [9] = '',
      [10] = '',
      [11] = '',
      [12] = '',
      [13] = '',
    },
  }
end
-- }}}

local backdrop = {
  bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", tile = true, tileSize = 16,
  edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", edgeSize = 16,
  insets = {left = 4, right = 4, top = 4, bottom = 4},
}

DBGUI = CreateFrame("Frame",nil,UIParent)
DBGUI:RegisterEvent("PLAYER_ENTERING_WORLD");
DBGUI:SetScript("OnEvent", function(self, event, ...)
    DBGUI.minimapButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52-(80*cos(WHDBMinimapPosition)),(80*sin(WHDBMinimapPosition))-52)
  end)

-- {{{ Main Frame
DBGUI:Hide()
DBGUI:SetFrameStrata("TOOLTIP")
DBGUI:SetWidth(600)
DBGUI:SetHeight(425)

DBGUI:SetBackdrop(backdrop)
DBGUI:SetBackdropColor(0,0,0,0.9);
DBGUI:SetPoint("CENTER",0,0)
DBGUI:SetMovable(true)
DBGUI:EnableMouse(true)
DBGUI:SetScript("OnMouseDown",function()
    DBGUI:StartMoving()
  end)
DBGUI:SetScript("OnMouseUp",function()
    DBGUI:StopMovingOrSizing()
  end)

-- {{{ title bar
DBGUI.titleBar = CreateFrame("Frame", nil, DBGUI)
DBGUI.titleBar:SetPoint("TOP", 0, -5);
DBGUI.titleBar:SetWidth(590);
DBGUI.titleBar:SetHeight(30);
DBGUI.titleBar.color = DBGUI.titleBar:CreateTexture("BACKGROUND");
DBGUI.titleBar.color:SetAllPoints();
DBGUI.titleBar.color:SetTexture(0.4, 0.4, 0.4, 0.1);
-- }}}
-- {{{ Title
DBGUI.text = DBGUI:CreateFontString("Status", "LOW", "GameFontNormal")
DBGUI.text:SetFontObject(GameFontWhite)
DBGUI.text:SetFont("Fonts\\FRIZQT__.TTF", 14)
DBGUI.text:SetPoint("TOPLEFT", 15, -15)
DBGUI.text:SetText("|cff33ffccWHDB|r")
-- }}}
-- {{{ bottom bar
DBGUI.bottomBar = CreateFrame("Frame", nil, DBGUI)
DBGUI.bottomBar:SetPoint("BOTTOM", 0, 5);
DBGUI.bottomBar:SetWidth(590);
DBGUI.bottomBar:SetHeight(40);
DBGUI.bottomBar.color = DBGUI.bottomBar:CreateTexture("BACKGROUND");
DBGUI.bottomBar.color:SetAllPoints();
DBGUI.bottomBar.color:SetTexture(0.4, 0.4, 0.4, 0.1);
-- }}}
-- {{{ Header: Spawn
DBGUI.titleSpawn = DBGUI:CreateFontString("Status", "LOW", "GameFontNormal")
DBGUI.titleSpawn:SetFontObject(GameFontWhite)
DBGUI.titleSpawn:SetFont("Fonts\\FRIZQT__.TTF", 12)
DBGUI.titleSpawn:SetWidth(200)
DBGUI.titleSpawn:SetPoint("TOPLEFT", 0, -55)
DBGUI.titleSpawn:SetTextColor(1,1,1,0.3)
DBGUI.titleSpawn:SetText("Spawn")
-- }}}
-- {{{ Header: Item
DBGUI.titleItem = DBGUI:CreateFontString("Status", "LOW", "GameFontNormal")
DBGUI.titleItem:SetFontObject(GameFontWhite)
DBGUI.titleItem:SetFont("Fonts\\FRIZQT__.TTF", 12)
DBGUI.titleItem:SetWidth(200)
DBGUI.titleItem:SetPoint("TOP", 0, -55)
DBGUI.titleItem:SetTextColor(1,1,1,0.3)
DBGUI.titleItem:SetText("Loot")
-- }}}
-- {{{ Header: Vendor
DBGUI.titleVendor = DBGUI:CreateFontString("Status", "LOW", "GameFontNormal")
DBGUI.titleVendor:SetFontObject(GameFontWhite)
DBGUI.titleVendor:SetFont("Fonts\\FRIZQT__.TTF", 12)
DBGUI.titleVendor:SetWidth(200)
DBGUI.titleVendor:SetPoint("TOPRIGHT", 0, -55)
DBGUI.titleVendor:SetTextColor(1,1,1,0.3)
DBGUI.titleVendor:SetText("Vendor")
-- }}}
-- {{{ Seperatorline: 1
DBGUI.vertLine1 = CreateFrame("Frame", nil, DBGUI)
DBGUI.vertLine1:SetPoint("TOP", 95, -50);
DBGUI.vertLine1:SetWidth(1);
DBGUI.vertLine1:SetHeight(320);
DBGUI.vertLine1.color = DBGUI.vertLine1:CreateTexture("BACKGROUND");
DBGUI.vertLine1.color:SetAllPoints();
DBGUI.vertLine1.color:SetTexture(0.1, 0.1, 0.1, 1);
-- }}}
-- {{{ Seperatorline: 2
DBGUI.vertLine2 = CreateFrame("Frame", nil, DBGUI)
DBGUI.vertLine2:SetPoint("TOP", -95, -50);
DBGUI.vertLine2:SetWidth(1);
DBGUI.vertLine2:SetHeight(320);
DBGUI.vertLine2.color = DBGUI.vertLine2:CreateTexture("BACKGROUND");
DBGUI.vertLine2.color:SetAllPoints();
DBGUI.vertLine2.color:SetTexture(0.1, 0.1, 0.1, 1);
-- }}}
-- {{{ Button: Close
DBGUI.closeButton = CreateFrame("Button", nil, DBGUI, "UIPanelCloseButton")
DBGUI.closeButton:SetWidth(30)
DBGUI.closeButton:SetHeight(30) -- width, height
DBGUI.closeButton:SetPoint("TOPRIGHT", -5,-5)
DBGUI.closeButton:SetScript("OnClick", function()
    DBGUI:Hide()
  end)
-- }}}
-- {{{ Text: Search
DBGUI.searchText = DBGUI:CreateFontString("Status", "LOW", "GameFontNormal")
DBGUI.searchText:SetFontObject(GameFontWhite)
DBGUI.searchText:SetFont("Fonts\\FRIZQT__.TTF", 11)
DBGUI.searchText:SetPoint("BOTTOMLEFT", 15, 20)
DBGUI.searchText:SetTextColor(0.5,0.5,0.5)
DBGUI.searchText:SetText("Search")
-- }}}
-- {{{ Text: caseSensitive
DBGUI.caseSensitive = DBGUI:CreateFontString("Status", "LOW", "GameFontNormal")
DBGUI.caseSensitive:SetFontObject(GameFontWhite)
DBGUI.caseSensitive:SetFont("Fonts\\FRIZQT__.TTF", 11)
DBGUI.caseSensitive:SetPoint("BOTTOM", 0, 20)
DBGUI.caseSensitive:SetTextColor(0.5,0.5,0.5)
DBGUI.caseSensitive:SetText("Note: Favourite editboxes are case sensitive and saved automatically.")
DBGUI.caseSensitive:Hide()
-- }}}

-- {{{ Input: Search
DBGUI.inputField = CreateFrame("EditBox", "InputBoxTemplate", DBGUI, "InputBoxTemplate")
InputBoxTemplateLeft:SetTexture(0.4, 0.4, 0.4, 0.1);
InputBoxTemplateMiddle:SetTexture(0.4, 0.4, 0.4, 0.1);
InputBoxTemplateRight:SetTexture(0.4, 0.4, 0.4, 0.1);
DBGUI.inputField:SetWidth(450)
DBGUI.inputField:SetHeight(20)
DBGUI.inputField:SetPoint("BOTTOMLEFT", 68, 15)
DBGUI.inputField:SetFontObject(GameFontNormal)
DBGUI.inputField:SetAutoFocus(false)
DBGUI.inputField:SetScript("OnTextChanged", function(self)
    DBGUI_Query(DBGUI.inputField:GetText())
  end)
-- }}}
-- {{{ Button: Clean
DBGUI.cleanButton = CreateFrame("Button", nil, DBGUI, "UIPanelButtonTemplate")
DBGUI.cleanButton:SetWidth(60)
DBGUI.cleanButton:SetHeight(22) -- width, height
DBGUI.cleanButton:SetPoint("BOTTOMRIGHT", -14,14)
DBGUI.cleanButton:SetText("Clean")
DBGUI.cleanButton:SetScript("OnClick", function()
    WHDB_DoCleanMap()
  end)
-- }}}
-- {{{ Button: Fav
DBGUI.favButton = CreateFrame("Button", nil, DBGUI, "UIPanelButtonTemplate")
DBGUI.favButton:SetNormalTexture("Interface\\AddOns\\WHDB\\symbols\\fav")
DBGUI.favButton:SetPushedTexture(nil)

DBGUI.favButton:SetWidth(26)
DBGUI.favButton:SetHeight(26) -- width, height
DBGUI.favButton:SetPoint("TOPRIGHT", -30,-5)
DBGUI.favButton:SetText("")
DBGUI.favButton:SetScript("OnClick", function()
    if not DBGUI.cleanButton:IsShown() then
      DBGUI_HideFavEdit()
      DBGUI.searchText:Show()
      DBGUI.inputField:Show()
      DBGUI.cleanButton:Show()
      DBGUI.caseSensitive:Hide()
      DBGUI_Query("")
    else
      DBGUI_EditFavourites()
    end
  end)
-- }}}
-- }}}
-- {{{ Minimap
DBGUI.minimapButton = CreateFrame('Button', "WHDB_Minimap", Minimap)
if (WHDBMinimapPosition == nil) then
  WHDBMinimapPosition = 125
end

DBGUI.minimapButton:SetMovable(true)
DBGUI.minimapButton:EnableMouse(true)
DBGUI.minimapButton:RegisterForDrag('LeftButton')
DBGUI.minimapButton:SetScript("OnDragStop", function()
    local xpos,ypos = GetCursorPosition()
    local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom()

    xpos = xmin-xpos/UIParent:GetScale()+70
    ypos = ypos/UIParent:GetScale()-ymin-70

    WHDBMinimapPosition = math.deg(math.atan2(ypos,xpos))
    DBGUI.minimapButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52-(80*cos(WHDBMinimapPosition)),(80*sin(WHDBMinimapPosition))-52)
  end)

DBGUI.minimapButton:SetFrameStrata('LOW')
DBGUI.minimapButton:SetWidth(31)
DBGUI.minimapButton:SetHeight(31)
DBGUI.minimapButton:SetFrameLevel(9)
DBGUI.minimapButton:SetHighlightTexture('Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight')
DBGUI.minimapButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52-(80*cos(WHDBMinimapPosition)),(80*sin(WHDBMinimapPosition))-52)
DBGUI.minimapButton:SetScript("OnClick", function()
    if ( arg1 == "LeftButton" ) then
      if (DBGUI:IsShown()) then
        DBGUI:Hide()
      else
        DBGUI:Show()
      end
    end
  end)

-- {{{ Highlight
DBGUI.minimapButton.overlay = DBGUI.minimapButton:CreateTexture(nil, 'OVERLAY')
DBGUI.minimapButton.overlay:SetWidth(53)
DBGUI.minimapButton.overlay:SetHeight(53)
DBGUI.minimapButton.overlay:SetTexture('Interface\\Minimap\\MiniMap-TrackingBorder')
DBGUI.minimapButton.overlay:SetPoint('TOPLEFT', 0,0)
-- }}}
-- {{{ Icon
DBGUI.minimapButton.icon = DBGUI.minimapButton:CreateTexture(nil, 'BACKGROUND')
DBGUI.minimapButton.icon:SetWidth(20)
DBGUI.minimapButton.icon:SetHeight(20)
DBGUI.minimapButton.icon:SetTexture('Interface\\GossipFrame\\AvailableQuestIcon')
DBGUI.minimapButton.icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
DBGUI.minimapButton.icon:SetPoint('CENTER',1,1)
-- }}}
-- }}}

-- {{{ HideButtons
function DBGUI_HideButtons()
  for i=1,13 do
    if (DBGUI_SpawnButtons["Button_"..i]) then
      DBGUI_SpawnButtons["Button_"..i]:Hide();
    end
    if (DBGUI_ItemButtons["Button_"..i]) then
      DBGUI_ItemButtons["Button_"..i]:Hide();
    end
    if (DBGUI_VendorButtons["Button_"..i]) then
      DBGUI_VendorButtons["Button_"..i]:Hide();
    end
  end
end
-- }}}
-- {{{ HideFavEdit
function DBGUI_HideFavEdit()
  for i=1,13 do
    if (DBGUI_FavouritesEdit["SpawnEdit"..i]) then
      DBGUI_FavouritesEdit["SpawnEdit"..i]:Hide();
    end
    if (DBGUI_FavouritesEdit["ItemEdit"..i]) then
      DBGUI_FavouritesEdit["ItemEdit"..i]:Hide();
    end
    if (DBGUI_FavouritesEdit["VendorEdit"..i]) then
      DBGUI_FavouritesEdit["VendorEdit"..i]:Hide();
    end
  end
end
-- }}}
-- {{{ SearchSpawn
function DBGUI_SearchSpawn(search)
  local spawnCount = 1;
  for id, npc in pairs(npcData) do
    if (strfind(strlower(npc.name), strlower(search))) then
      if ( spawnCount <= 13) then
        DBGUI_SpawnButtons["Button_"..spawnCount] = CreateFrame("Button","mybutton",DBGUI,"UIPanelButtonTemplate")
        DBGUI_SpawnButtons["Button_"..spawnCount]:SetPoint("TOPLEFT", 10, -spawnCount*22-55)
        DBGUI_SpawnButtons["Button_"..spawnCount]:SetWidth(200)
        DBGUI_SpawnButtons["Button_"..spawnCount]:SetHeight(20)
        DBGUI_SpawnButtons["Button_"..spawnCount]:SetFont("Fonts\\FRIZQT__.TTF", 10)
        DBGUI_SpawnButtons["Button_"..spawnCount]:SetNormalTexture(nil)
        DBGUI_SpawnButtons["Button_"..spawnCount]:SetPushedTexture(nil)
        DBGUI_SpawnButtons["Button_"..spawnCount]:SetTextColor(1,1,1)
        DBGUI_SpawnButtons["Button_"..spawnCount]:SetText(npc.name)
        DBGUI_SpawnButtons["Button_"..spawnCount]:SetScript("OnClick", function(self)
            WHDB_MAP_NOTES = {};
			local name = this:GetText()
            WHDB_GetNPCNotes(name, name, "Spawnpoint".."\n"..WHDB_GetNPCStatsComment(name), 0);
            WHDB_ShowMap();
          end)
        spawnCount = spawnCount + 1
      end
    end
  end
end
-- }}}
-- {{{ SearchItem
function DBGUI_SearchItem(search)
  local itemCount = 1;
  for item in pairs(itemLookup) do
    if (strfind(strlower(item), strlower(search))) then
      if ( itemCount <= 13) then
        DBGUI_ItemButtons["Button_"..itemCount] = CreateFrame("Button","mybutton",DBGUI,"UIPanelButtonTemplate")
        DBGUI_ItemButtons["Button_"..itemCount]:SetPoint("TOP", 0, -itemCount*22-55)
        DBGUI_ItemButtons["Button_"..itemCount]:SetWidth(200)
        DBGUI_ItemButtons["Button_"..itemCount]:SetHeight(20)
        DBGUI_ItemButtons["Button_"..itemCount]:SetFont("Fonts\\FRIZQT__.TTF", 10)
        DBGUI_ItemButtons["Button_"..itemCount]:SetNormalTexture(nil)
        DBGUI_ItemButtons["Button_"..itemCount]:SetPushedTexture(nil)
        DBGUI_ItemButtons["Button_"..itemCount]:SetTextColor(1,1,1)
        DBGUI_ItemButtons["Button_"..itemCount]:SetText(item)
        DBGUI_ItemButtons["Button_"..itemCount]:SetScript("OnClick", function(self)
            WHDB_MAP_NOTES = {};
			local name = this:GetText();
            WHDB_GetItemNotes(name, name, "", 0)
            WHDB_ShowMap();
          end)
        itemCount = itemCount + 1
      end
    end
  end
end
-- }}}
-- {{{ SearchVenador
function DBGUI_SearchVendor(search)
  local vendorCount = 1;
  --[[
  for spawn in pairs(vendorDB) do
    if (strfind(strlower(spawn), strlower(search))) then
      if ( vendorCount <= 13) then
        DBGUI_VendorButtons["Button_"..vendorCount] = CreateFrame("Button","mybutton",DBGUI,"UIPanelButtonTemplate")
        DBGUI_VendorButtons["Button_"..vendorCount]:SetPoint("TOPRIGHT", -10, -vendorCount*22-55)
        DBGUI_VendorButtons["Button_"..vendorCount]:SetWidth(200)
        DBGUI_VendorButtons["Button_"..vendorCount]:SetHeight(20)
        DBGUI_VendorButtons["Button_"..vendorCount]:SetFont("Fonts\\FRIZQT__.TTF", 10)
        DBGUI_VendorButtons["Button_"..vendorCount]:SetNormalTexture(nil)
        DBGUI_VendorButtons["Button_"..vendorCount]:SetPushedTexture(nil)
        DBGUI_VendorButtons["Button_"..vendorCount]:SetTextColor(1,1,1)
        DBGUI_VendorButtons["Button_"..vendorCount]:SetText(spawn)
        DBGUI_VendorButtons["Button_"..vendorCount]:SetScript("OnClick", function(self)
            WHDB_MAP_NOTES = {};
            WHDB_searchVendor(this:GetText(),nil)
            WHDB_ShowMap();
          end)
        vendorCount = vendorCount + 1
      end
    end
  end
  --]]
end
-- }}}
-- {{{ ShowFavourites
function DBGUI_ShowFavourites()
  for i = 1,13 do
    if ( DBGUI_Favourites["spawn"][i] ~= '' ) then
      DBGUI_SpawnButtons["Button_"..i] = CreateFrame("Button","mybutton",DBGUI,"UIPanelButtonTemplate")
      DBGUI_SpawnButtons["Button_"..i]:SetPoint("TOPLEFT", 10, -i*22-55)
      DBGUI_SpawnButtons["Button_"..i]:SetWidth(200)
      DBGUI_SpawnButtons["Button_"..i]:SetHeight(20)
      DBGUI_SpawnButtons["Button_"..i]:SetFont("Fonts\\FRIZQT__.TTF", 10)
      DBGUI_SpawnButtons["Button_"..i]:SetNormalTexture(nil)
      DBGUI_SpawnButtons["Button_"..i]:SetPushedTexture(nil)
      DBGUI_SpawnButtons["Button_"..i]:SetTextColor(0.2,1,0.9,0.7)
      DBGUI_SpawnButtons["Button_"..i]:SetText(DBGUI_Favourites["spawn"][i])
      DBGUI_SpawnButtons["Button_"..i]:SetScript("OnClick", function(self)
          WHDB_MAP_NOTES = {};
          WHDB_searchMonster(this:GetText(),nil)
          WHDB_ShowMap();
        end)
    end

    if ( DBGUI_Favourites["item"][i] ~= '') then
      DBGUI_ItemButtons["Button_"..i] = CreateFrame("Button","mybutton",DBGUI,"UIPanelButtonTemplate")
      DBGUI_ItemButtons["Button_"..i]:SetPoint("TOP", 0, -i*22-55)
      DBGUI_ItemButtons["Button_"..i]:SetWidth(200)
      DBGUI_ItemButtons["Button_"..i]:SetHeight(20)
      DBGUI_ItemButtons["Button_"..i]:SetFont("Fonts\\FRIZQT__.TTF", 10)
      DBGUI_ItemButtons["Button_"..i]:SetNormalTexture(nil)
      DBGUI_ItemButtons["Button_"..i]:SetPushedTexture(nil)
      DBGUI_ItemButtons["Button_"..i]:SetTextColor(0.2,1,0.9,0.7)
      DBGUI_ItemButtons["Button_"..i]:SetText(DBGUI_Favourites["item"][i])
      DBGUI_ItemButtons["Button_"..i]:SetScript("OnClick", function(self)
          WHDB_MAP_NOTES = {};
          WHDB_searchItem(this:GetText(),nil)
          WHDB_ShowMap();
        end)
    end

    if ( DBGUI_Favourites["vendor"][i] ~= '' ) then
      DBGUI_VendorButtons["Button_"..i] = CreateFrame("Button","mybutton",DBGUI,"UIPanelButtonTemplate")
      DBGUI_VendorButtons["Button_"..i]:SetPoint("TOPRIGHT", -10, -i*22-55)
      DBGUI_VendorButtons["Button_"..i]:SetWidth(200)
      DBGUI_VendorButtons["Button_"..i]:SetHeight(20)
      DBGUI_VendorButtons["Button_"..i]:SetFont("Fonts\\FRIZQT__.TTF", 10)
      DBGUI_VendorButtons["Button_"..i]:SetNormalTexture(nil)
      DBGUI_VendorButtons["Button_"..i]:SetPushedTexture(nil)
      DBGUI_VendorButtons["Button_"..i]:SetTextColor(0.2,1,0.9,0.7)
      DBGUI_VendorButtons["Button_"..i]:SetText(DBGUI_Favourites["vendor"][i])
      DBGUI_VendorButtons["Button_"..i]:SetScript("OnClick", function(self)
          WHDB_MAP_NOTES = {};
          WHDB_searchVendor(this:GetText(),nil)
          WHDB_ShowMap();
        end)
    end
  end
end
-- }}}
-- {{{ EditFavourites
function DBGUI_EditFavourites()
  DBGUI_HideFavEdit()
  DBGUI_HideButtons()
  DBGUI.cleanButton:Hide()
  DBGUI.searchText:Hide()
  DBGUI.caseSensitive:Show()
  DBGUI.inputField:Hide()
  DBGUI.cleanButton:Hide()
  for i = 1,13 do

    DBGUI_FavouritesEdit["SpawnEdit"..i] = CreateFrame("EditBox", "InputBoxTemplateS"..i, DBGUI)
    DBGUI_FavouritesEdit["SpawnEdit"..i]:SetBackdrop(backdrop)
    DBGUI_FavouritesEdit["SpawnEdit"..i]:SetBackdropBorderColor(0.2,0.2,0.2,1)
    DBGUI_FavouritesEdit["SpawnEdit"..i]:SetText(DBGUI_Favourites["spawn"][i])
    DBGUI_FavouritesEdit["SpawnEdit"..i]:SetJustifyH("CENTER")
    DBGUI_FavouritesEdit["SpawnEdit"..i]:SetTextColor(0.2,1,0.9,0.7)
    DBGUI_FavouritesEdit["SpawnEdit"..i]:SetFont("Fonts\\FRIZQT__.TTF", 10)
    DBGUI_FavouritesEdit["SpawnEdit"..i]:SetWidth(180)
    DBGUI_FavouritesEdit["SpawnEdit"..i]:SetHeight(25)
    DBGUI_FavouritesEdit["SpawnEdit"..i]:SetPoint("TOPLEFT", 20, -i*22-53)
    DBGUI_FavouritesEdit["SpawnEdit"..i]:SetFontObject(GameFontNormal)
    DBGUI_FavouritesEdit["SpawnEdit"..i]:SetAutoFocus(false)
    DBGUI_FavouritesEdit["SpawnEdit"..i].editID = i
    DBGUI_FavouritesEdit["SpawnEdit"..i]:SetTextInsets(8,8,0,0)
    DBGUI_FavouritesEdit["SpawnEdit"..i]:SetScript("OnTextChanged", function(self)
        DBGUI_Favourites["spawn"][this.editID] = this:GetText()
      end)
    DBGUI_FavouritesEdit["SpawnEdit"..i]:SetScript("OnEscapePressed", function(self)
        this:ClearFocus()
      end)

    DBGUI_FavouritesEdit["ItemEdit"..i] = CreateFrame("EditBox", "InputBoxTemplateI"..i, DBGUI)
    DBGUI_FavouritesEdit["ItemEdit"..i]:SetBackdrop(backdrop)
    DBGUI_FavouritesEdit["ItemEdit"..i]:SetBackdropBorderColor(0.2,0.2,0.2,1)
    DBGUI_FavouritesEdit["ItemEdit"..i]:SetText(DBGUI_Favourites["item"][i])
    DBGUI_FavouritesEdit["ItemEdit"..i]:SetJustifyH("CENTER")
    DBGUI_FavouritesEdit["ItemEdit"..i]:SetTextColor(0.2,1,0.9,0.7)
    DBGUI_FavouritesEdit["ItemEdit"..i]:SetFont("Fonts\\FRIZQT__.TTF", 10)
    DBGUI_FavouritesEdit["ItemEdit"..i]:SetWidth(180)
    DBGUI_FavouritesEdit["ItemEdit"..i]:SetHeight(25)
    DBGUI_FavouritesEdit["ItemEdit"..i]:SetPoint("TOP", 0, -i*22-53)
    DBGUI_FavouritesEdit["ItemEdit"..i]:SetFontObject(GameFontNormal)
    DBGUI_FavouritesEdit["ItemEdit"..i]:SetAutoFocus(false)
    DBGUI_FavouritesEdit["ItemEdit"..i].editID = i
    DBGUI_FavouritesEdit["ItemEdit"..i]:SetTextInsets(8,8,0,0)
    DBGUI_FavouritesEdit["ItemEdit"..i]:SetScript("OnTextChanged", function(self)
        DBGUI_Favourites["item"][this.editID] = this:GetText()
      end)
    DBGUI_FavouritesEdit["ItemEdit"..i]:SetScript("OnEscapePressed", function(self)
        this:ClearFocus()
      end)

    DBGUI_FavouritesEdit["VendorEdit"..i] = CreateFrame("EditBox", "InputBoxTemplateV"..i, DBGUI)
    DBGUI_FavouritesEdit["VendorEdit"..i]:SetBackdrop(backdrop)
    DBGUI_FavouritesEdit["VendorEdit"..i]:SetBackdropBorderColor(0.2,0.2,0.2,1)
    DBGUI_FavouritesEdit["VendorEdit"..i]:SetText(DBGUI_Favourites["vendor"][i])
    DBGUI_FavouritesEdit["VendorEdit"..i]:SetJustifyH("CENTER")
    DBGUI_FavouritesEdit["VendorEdit"..i]:SetTextColor(0.2,1,0.9,0.7)
    DBGUI_FavouritesEdit["VendorEdit"..i]:SetFont("Fonts\\FRIZQT__.TTF", 10)
    DBGUI_FavouritesEdit["VendorEdit"..i]:SetWidth(180)
    DBGUI_FavouritesEdit["VendorEdit"..i]:SetHeight(25)
    DBGUI_FavouritesEdit["VendorEdit"..i]:SetPoint("TOPRIGHT", -20, -i*22-53)
    DBGUI_FavouritesEdit["VendorEdit"..i]:SetFontObject(GameFontNormal)
    DBGUI_FavouritesEdit["VendorEdit"..i]:SetAutoFocus(false)
    DBGUI_FavouritesEdit["VendorEdit"..i].editID = i
    DBGUI_FavouritesEdit["VendorEdit"..i]:SetTextInsets(8,8,0,0)
    DBGUI_FavouritesEdit["VendorEdit"..i]:SetScript("OnTextChanged", function(self)
        DBGUI_Favourites["vendor"][this.editID] = this:GetText()
      end)
    DBGUI_FavouritesEdit["VendorEdit"..i]:SetScript("OnEscapePressed", function(self)
        this:ClearFocus()
      end)
  end
end

-- }}}
-- {{{ Query
function DBGUI_Query(search)
  DBGUI_HideButtons()
  if (strlen(search) >= 3) then
    DBGUI_SearchSpawn(search)
    DBGUI_SearchItem(search)
    DBGUI_SearchVendor(search)
  else
    DBGUI_ShowFavourites()
  end
end
-- }}}
