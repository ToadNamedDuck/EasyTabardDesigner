-- Written by ToadNamedDuck/Jason Harris in (August) 2024
-- Blizzard's current Tabard UI is terrible, and I want it to look a little more like the collections panel with each option showing up.

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

function EasyTabardDesigner_SetEmblemButtonIcon(parentNameIndex)
    local trueIndex = tonumber(string.sub(parentNameIndex, 12, -1));
    local targetTextFrame = _G[parentNameIndex .. "_IconName"];
    local targetTopLeft = _G[parentNameIndex .. "_TabardFrameEmblemTopLeft"];
    local targetTopRight = _G[parentNameIndex .. "_TabardFrameEmblemTopRight"];
    local targetBottomLeft = _G[parentNameIndex .. "_TabardFrameEmblemBottomLeft"];
    local targetBottomRight = _G[parentNameIndex .. "_TabardFrameEmblemBottomRight"];
    targetTextFrame:SetText(EasyTabardDesigner_TabardTable[trueIndex].Name);
    targetTopLeft:SetTexture(EasyTabardDesigner_TabardTable[trueIndex].ID + 33);
    targetTopRight:SetTexture(EasyTabardDesigner_TabardTable[trueIndex].ID + 33);
    targetBottomLeft:SetTexture(EasyTabardDesigner_TabardTable[trueIndex].ID + 32);
    targetBottomRight:SetTexture(EasyTabardDesigner_TabardTable[trueIndex].ID + 32);
end

function EasyTabardDesigner_OnEvent(self, event, ...)
    if event == "UNIT_MODEL_CHANGED" then EasyTabardDesigner_TabardModel:SetUnit("player") end
end

-- EasyTabardDesigner_IconSelectButton_Click = function(tabardIconId) ?
-- EasyTabardDesigner_IconColorButton_Click = function(TabardIconColor) ?
-- EasyTabardDesigner_BorderSelectButton_Click = function(BorderId) ?
-- EasyTabardDesigner_BorderColorSelectButton_Click = function(BorderColor) ?
-- EasyTabardDesigner_BackgroundColorSelectButton_Click = function(BackgroundColor) ?
