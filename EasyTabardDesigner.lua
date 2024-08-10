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
        EasyTabardDesignerFrame:Show()
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
    EasyTabardDesigner_TabardModel:SetUnit("player");
end

-- X button
EasyTabardDesigner_CloseButton = function()
    EasyTabardDesignerFrame:Hide();
    --Needs to stop Tabard Creation
end

-- EasyTabardDesigner_IconSelectButton_Click = function(tabardIconId) ?
-- EasyTabardDesigner_IconColorButton_Click = function(TabardIconColor) ?
-- EasyTabardDesigner_BorderSelectButton_Click = function(BorderId) ?
-- EasyTabardDesigner_BorderColorSelectButton_Click = function(BorderColor) ?
-- EasyTabardDesigner_BackgroundColorSelectButton_Click = function(BackgroundColor) ?