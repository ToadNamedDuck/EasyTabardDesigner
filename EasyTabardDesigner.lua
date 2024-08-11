-- Written by ToadNamedDuck/Jason Harris in (August) 2024
-- Blizzard's current Tabard UI is terrible, and I want it to look a little more like the collections panel with each option showing up.

-- When changing Icons, the right side panels should show a TabardModel for each available icon, each of which keeps the icon color, 
-- current border, border color, and background color.

-- Slash command which makes the xml frame visible
SLASH_TABARDSHOW1 = "/tabardshow"
SlashCmdList["TABARDSHOW"] = function(msg, editBox)
    if EasyTabardDesignerFrame:IsVisible() then
        EasyTabardDesignerFrame:Hide();
    else
        EasyTabardDesigner_Open();
    end
end
-- OnLoad Function, which just makes sure the frame is not visible when you log in for now.
EasyTabardDesigner_OnLoad = function(self)
    EasyTabardDesignerFrame:Hide();
    -- Register Events we want to listen for, which are just copied from the original tabard frame
    self:RegisterEvent("TABARD_CANSAVE_CHANGED");
	self:RegisterEvent("TABARD_SAVE_PENDING");
	self:RegisterEvent("UNIT_MODEL_CHANGED");
	self:RegisterEvent("DISPLAY_SIZE_CHANGED");
	self:RegisterEvent("UI_SCALE_CHANGED");
    -- Text at top should change based on if you are editing guild tabard or personal tabard
    EasyTabardDesigner_TabardModeText:SetText("Editing Guild Tabard")
end

-- X button
EasyTabardDesigner_CloseButton = function()
    EasyTabardDesignerFrame:Hide();
    --Needs to stop Tabard Creation
end

EasyTabardDesigner_Open = function()
    EasyTabardDesignerFrame:Show();
    EasyTabardDesigner_UpdateTextures();
    EasyTabardDesigner_TabardModel:InitializeTabardColors();
end

-- There are supposed to be 4 elements which hold a quadrant of the guild emblem. The param is the name of the quadrant, and updatetextures sets all 4 of those, and that should theoretically be in a frames overlay level.
function EasyTabardDesigner_UpdateTextures()
	EasyTabardDesigner_TabardModel:GetUpperEmblemTexture(TabardFrameEmblemTopLeft);
	EasyTabardDesigner_TabardModel:GetUpperEmblemTexture(TabardFrameEmblemTopRight);
	EasyTabardDesigner_TabardModel:GetLowerEmblemTexture(TabardFrameEmblemBottomLeft);
	EasyTabardDesigner_TabardModel:GetLowerEmblemTexture(TabardFrameEmblemBottomRight);
end

function EasyTabardDesigner_OnEvent(self, event, ...)
    if event == "UNIT_MODEL_CHANGED" then EasyTabardDesigner_TabardModel:SetUnit("player") end
end

-- Supposedly, every file has an ID, so in theory it is possible to get the name of the file or the id or something, and compile a list of the ids or names. I also kind of want to give them a label, which means naming all 196 icons.
-- I wonder if I can do a get emblem texture from the functions above with a getfile or something
function EasyTabardDesigner_GetTabardIconIds()
    local tabardIconIDs = {};
    local i = 1;
    --Need to initialize tabard colors so we have a starting point.
    EasyTabardDesigner_TabardModel:InitializeTabardColors();
    local IconID = EasyTabardDesigner_TabardModel:GetUpperEmblemFileName(TabardFrameEmblemTopLeft)

    while(true) do
        if (not tabardIconIDs[i])
        then
            tabardIconIDs[i] = {ID = IconID, Name = ""};
            EasyTabardDesignerTabardModel:CycleVariation(1,1);
            i = i + 1;
        else
            break;
        end
    end

    table.sort(tabardIconIDs, function(a,b) return a.ID < b.ID end)
    return tabardIconIDs;
end

-- EasyTabardDesigner_IconSelectButton_Click = function(tabardIconId) ?
-- EasyTabardDesigner_IconColorButton_Click = function(TabardIconColor) ?
-- EasyTabardDesigner_BorderSelectButton_Click = function(BorderId) ?
-- EasyTabardDesigner_BorderColorSelectButton_Click = function(BorderColor) ?
-- EasyTabardDesigner_BackgroundColorSelectButton_Click = function(BackgroundColor) ?


-- local object1 =  {ID = 01, IconName = ""};
-- local object2 = {ID = 01, IconName = ""};
-- local table = {};
-- table[1] = object1;
-- table[2] = object2;
-- print(table[1].ID == table[2].ID);