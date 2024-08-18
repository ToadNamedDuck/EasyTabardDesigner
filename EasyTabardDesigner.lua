-- Written by ToadNamedDuck/Jason Harris in (August) 2024
-- Blizzard's current Tabard UI is terrible, and I want it to look a little more like the collections panel with each option showing up.

-- Slash command which makes the xml frame visible
SLASH_TABARDSHOW1 = "/tabardshow"
SlashCmdList["TABARDSHOW"] = function(msg, editBox)
    if EasyTabardDesignerFrame:IsVisible() then
        EasyTabardDesignerFrame:CloseButton();
    else
        EasyTabardDesigner_Open();
    end
end

EasyTabardDesigner_OnLoad = function(self)
    EasyTabardDesignerFrame:Hide();
    -- Register Events we want to listen for, which are just copied from the original tabard frame
    self:RegisterEvent("TABARD_CANSAVE_CHANGED");
	self:RegisterEvent("TABARD_SAVE_PENDING");
	self:RegisterEvent("UNIT_MODEL_CHANGED");
	self:RegisterEvent("DISPLAY_SIZE_CHANGED");
	self:RegisterEvent("UI_SCALE_CHANGED");
    -- Text at top should change based on if you are editing guild tabard or personal tabard. Needs to be inside of the open function
    EasyTabardDesigner_TabardModeText:SetText("Editing Guild Tabard")
end

-- X button
EasyTabardDesigner_CloseButton = function()
    EasyTabardDesignerFrame:Hide();
    --Needs to stop Tabard Creation
end

EasyTabardDesigner_Open = function()
    EasyTabardDesignerFrame:Show();
    EasyTabardDesigner_TabardModel:InitializeTabardColors();
end

--Populates all of the emblem icons in the emblem select list.


--Sets the Emblem in each of the display buttons <NEEDS REWORK>
function EasyTabardDesigner_SetEmblemButtonIcon(parentNameIndex)
    local trueIndex = tonumber(string.sub(parentNameIndex, 12, -1));
    local targetTextFrame = _G[parentNameIndex .. "_IconName"];
    local targetTopLeft = _G[parentNameIndex .. "_TabardFrameEmblemTopLeft"];
    local targetTopRight = _G[parentNameIndex .. "_TabardFrameEmblemTopRight"];
    local targetBottomLeft = _G[parentNameIndex .. "_TabardFrameEmblemBottomLeft"];
    local targetBottomRight = _G[parentNameIndex .. "_TabardFrameEmblemBottomRight"];
    targetTextFrame:SetText(EasyTabardDesigner_TabardTable[trueIndex].Name);
    targetTopLeft:SetTexture(EasyTabardDesigner_TabardTable[trueIndex].RangeEnd);
    targetTopRight:SetTexture(EasyTabardDesigner_TabardTable[trueIndex].RangeEnd);
    targetBottomLeft:SetTexture(EasyTabardDesigner_TabardTable[trueIndex].RangeEnd - 1);
    targetBottomRight:SetTexture(EasyTabardDesigner_TabardTable[trueIndex].RangeEnd - 1);
end

--Determines which emblem index is currently used by the player, used for calculating the offset
function EasyTabardDesigner_GetCurrentEmblemIndex()
    local emblemUpperID = EasyTabardDesigner_TabardModel:GetUpperEmblemFile();
    --Loop through the table of emblem IDs until we find which emblem this file sits between (inclusively) the objects ID and the RangeEnd
    local n = 1;
    while(n < 197) do
        if EasyTabardDesigner_TabardTable[n].ID <= emblemUpperID and emblemUpperID <= EasyTabardDesigner_TabardTable[n].RangeEnd
            then return n
        else
            n = n + 1;
        end
    end
end

--OnValueChanged for slider
function EasyTabardDesigner_SliderUpdate()
    
end

--Function that calculates which icons are shown on the rows. 33 rows total, 6 icons per row. 5 rows shown. 
function EasyTabardDesigner_UpdateRows(sliderValue)
    --sliderValue determines which row to show at the top.
    EasyTabardDesigner_SetRow(1, sliderValue);
    EasyTabardDesigner_SetRow(2, sliderValue);
    EasyTabardDesigner_SetRow(3, sliderValue);
    EasyTabardDesigner_SetRow(4, sliderValue);
    EasyTabardDesigner_SetRow(5, sliderValue);
end

--Update a row of buttons in the slider menu
function EasyTabardDesigner_SetRow(rowValue, sliderValue)
    
end

function EasyTabardDesigner_OnEvent(self, event, ...)
    if event == "UNIT_MODEL_CHANGED" then EasyTabardDesigner_TabardModel:SetUnit("player") end
end

-- EasyTabardDesigner_IconSelectButton_Click = function(tabardIconId) ?
-- EasyTabardDesigner_IconColorButton_Click = function(TabardIconColor) ?
-- EasyTabardDesigner_BorderSelectButton_Click = function(BorderId) ?
-- EasyTabardDesigner_BorderColorSelectButton_Click = function(BorderColor) ?
-- EasyTabardDesigner_BackgroundColorSelectButton_Click = function(BackgroundColor) ?
