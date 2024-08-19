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

local topRowButton1ID = 1;
local previousSliderValue = 1;

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


--Sets the Emblem in each of the display buttons
function EasyTabardDesigner_SetEmblemButtonIcon(button)
    local tabardID = button:GetID();
    local frameName = button:GetName();
    local buttonLabel = _G[frameName .. "_IconName"]
    local buttonTopLeft = _G[frameName .. "_TabardFrameEmblemTopLeft"];
    local buttonTopRight = _G[frameName .. "_TabardFrameEmblemTopRight"];
    local buttonBottomLeft = _G[frameName .. "_TabardFrameEmblemBottomLeft"];
    local buttonBottomRight = _G[frameName .. "_TabardFrameEmblemBottomRight"];
    local tableObj;
    if tabardID > 0 then
        tableObj = EasyTabardDesigner_TabardTable[tabardID];
    else
        tableObj = EasyTabardDesigner_TabardTable[1];
    end
    buttonLabel:SetText(tableObj.Name);
    buttonTopLeft:SetTexture(tableObj.RangeEnd);
    buttonTopRight:SetTexture(tableObj.RangeEnd);
    buttonBottomLeft:SetTexture(tableObj.RangeEnd - 1);
    buttonBottomRight:SetTexture(tableObj.RangeEnd - 1);
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
    local value = math.floor(EasyTabardDesigner_SliderTrack:GetValue());
    EasyTabardDesigner_UpdateRows(value);
end

--Function that calculates which icons are shown on the rows. 33 rows total, 6 icons per row. 5 rows shown. 
function EasyTabardDesigner_UpdateRows(sliderValue)
    EasyTabardDesigner_SetRow(1, sliderValue);
    EasyTabardDesigner_SetRow(2, sliderValue);
    EasyTabardDesigner_SetRow(3, sliderValue);
    EasyTabardDesigner_SetRow(4, sliderValue);
    EasyTabardDesigner_SetRow(5, sliderValue);
end

--Update a row of buttons in the slider menu
function EasyTabardDesigner_SetRow(rowValue, sliderValue)

    if rowValue > 5 then rowValue = 5 end;
    if rowValue < 1 then rowValue = 1 end;

    local button1 = _G["EasyTabardDesigner_IconFrame_Row"..tostring(rowValue).."_Icon1"]
    local button2 = _G["EasyTabardDesigner_IconFrame_Row"..tostring(rowValue).."_Icon2"]
    local button3 = _G["EasyTabardDesigner_IconFrame_Row"..tostring(rowValue).."_Icon3"]
    local button4 = _G["EasyTabardDesigner_IconFrame_Row"..tostring(rowValue).."_Icon4"]
    local button5 = _G["EasyTabardDesigner_IconFrame_Row"..tostring(rowValue).."_Icon5"]
    local button6 = _G["EasyTabardDesigner_IconFrame_Row"..tostring(rowValue).."_Icon6"]

    --Check if sliderValue is > or < previousSliderValue to determine whether to add or subtract 6 from topRowButton1ID
    local offset = topRowButton1ID;
    if(sliderValue > previousSliderValue) then offset = offset + 6
    else offset = offset - 6 end;
    if(rowValue ~= 1) then offset = offset + (6*rowValue) end;
    if previousSliderValue == 0 then offset = 1 end;

    if (previousSliderValue == sliderValue) and (previousSliderValue ~= 1) then return 0 end;
    EasyTabardDesigner_SetRowButtonsIdAndIcon(button1, button2, button3, button4, button5, button6, offset)
    if rowValue == 1 then topRowButton1ID = button1:GetID()
         print(topRowButton1ID);
    end;
    if rowValue == 5 then previousSliderValue = sliderValue end;

end

function EasyTabardDesigner_SetRowButtonsIdAndIcon(button1, button2, button3, button4, button5, button6, IdToSet)

    local button1ID = IdToSet;
    local button2ID = IdToSet + 1;
    local button3ID = IdToSet + 2;
    local button4ID = IdToSet + 3;
    local button5ID = IdToSet + 4;
    local button6ID = IdToSet + 5;

    if button1ID > 196 then button1ID = 196 end;
    if button1ID < 1 then button1ID = 1 end;
    if button2ID > 196 then button2ID = 196 end;
    if button2ID < 2 then button2ID = 2 end;
    if button3ID > 196 then button3ID = 196 end;
    if button3ID < 3 then button3ID = 3 end;
    if button4ID > 196 then button4ID = 196 end;
    if button4ID < 4 then button4ID = 4 end;
    if button5ID > 196 then button5ID = 196 end;
    if button5ID < 5 then button5ID = 5 end;
    if button6ID > 196 then button6ID = 196 end;
    if button6ID < 6 then button6ID = 6 end;

    button1:SetID(button1ID);
    EasyTabardDesigner_SetEmblemButtonIcon(button1);
    button2:SetID(button2ID)
    EasyTabardDesigner_SetEmblemButtonIcon(button2);
    button3:SetID(button3ID)
    EasyTabardDesigner_SetEmblemButtonIcon(button3);
    button4:SetID(button4ID)
    EasyTabardDesigner_SetEmblemButtonIcon(button4);
    button5:SetID(button5ID)
    EasyTabardDesigner_SetEmblemButtonIcon(button5);
    button6:SetID(button6ID)
    EasyTabardDesigner_SetEmblemButtonIcon(button6);
end

function EasyTabardDesigner_OnEvent(self, event, ...)
    if event == "UNIT_MODEL_CHANGED" then EasyTabardDesigner_TabardModel:SetUnit("player") end
end

-- EasyTabardDesigner_IconSelectButton_Click = function(tabardIconId) ?
-- EasyTabardDesigner_IconColorButton_Click = function(TabardIconColor) ?
-- EasyTabardDesigner_BorderSelectButton_Click = function(BorderId) ?
-- EasyTabardDesigner_BorderColorSelectButton_Click = function(BorderColor) ?
-- EasyTabardDesigner_BackgroundColorSelectButton_Click = function(BackgroundColor) ?
