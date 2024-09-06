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

local previousSliderValue = 1;

EasyTabardDesigner_OnLoad = function(self)
    _G["TabardFrame_Open"] = EasyTabardDesigner_Open;
    EasyTabardDesignerFrame:Hide();
    -- Register Events we want to listen for, which are just copied from the original tabard frame
    self:RegisterEvent("TABARD_CANSAVE_CHANGED");
	self:RegisterEvent("TABARD_SAVE_PENDING");
	self:RegisterEvent("UNIT_MODEL_CHANGED");
	self:RegisterEvent("DISPLAY_SIZE_CHANGED");
	self:RegisterEvent("UI_SCALE_CHANGED");
    self:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_HIDE");
end

-- X button
EasyTabardDesigner_CloseButton = function()
    EasyTabardDesignerFrame:Hide();
    CloseTabardCreation();
end

EasyTabardDesigner_Open = function()
    EasyTabardDesigner_TabardModel:InitializeTabardColors();
    EasyTabardDesigner_UpdateButtons()

    if (EasyTabardDesigner_TabardModel:IsGuildTabard()) then
        EasyTabardDesigner_TabardModeText:SetText("Editing Guild Tabard")
    else
        EasyTabardDesigner_TabardModeText:SetText("Editing Personal Tabard")
    end

    EasyTabardDesignerFrame:Show();
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
    if (tabardID == 197 or tabardID == 198) then 
        buttonLabel:SetText("");
        buttonTopLeft:SetTexture(nil);
        buttonTopRight:SetTexture(nil);
        buttonBottomLeft:SetTexture(nil);
        buttonBottomRight:SetTexture(nil);
    else
        buttonLabel:SetText(tableObj.Name);
        buttonTopLeft:SetTexture(tableObj.RangeEnd);
        buttonTopRight:SetTexture(tableObj.RangeEnd);
        buttonBottomLeft:SetTexture(tableObj.RangeEnd - 1);
        buttonBottomRight:SetTexture(tableObj.RangeEnd - 1);
    end
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

    local offset = 1 + (sliderValue - 1) * 6 + (rowValue - 1) * 6;--Thanks ChatGPT
    if previousSliderValue < 1 then offset = 1 end;

    if (previousSliderValue == sliderValue) and (previousSliderValue ~= 1) then return 0 end;
    EasyTabardDesigner_SetRowButtonsIdAndIcon(button1, button2, button3, button4, button5, button6, offset)

    if rowValue == 5 then previousSliderValue = sliderValue end;

end

function EasyTabardDesigner_SetRowButtonsIdAndIcon(button1, button2, button3, button4, button5, button6, IdToSet)

    local button1ID = IdToSet;
    local button2ID = IdToSet + 1;
    local button3ID = IdToSet + 2;
    local button4ID = IdToSet + 3;
    local button5ID = IdToSet + 4;
    local button6ID = IdToSet + 5;

    if button1ID > 198 then button1ID = 198 end;
    if button1ID < 1 then button1ID = 1 end;
    if button2ID > 198 then button2ID = 198 end;
    if button2ID < 2 then button2ID = 2 end;
    if button3ID > 198 then button3ID = 198 end;
    if button3ID < 3 then button3ID = 3 end;
    if button4ID > 198 then button4ID = 198 end;
    if button4ID < 4 then button4ID = 4 end;
    if button5ID > 198 then button5ID = 198 end;
    if button5ID < 5 then button5ID = 5 end;
    if button6ID > 198 then button6ID = 198 end;
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

--Function that checks the current tabard id, and then calcs the offset of the clicked button
function EasyTabardDesigner_IconButtonOnClick(iconID)
    if (iconID == nil or iconID > 196) then return 0 end;
    local currentIndex = EasyTabardDesigner_GetCurrentEmblemIndex();
    EasyTabardDesigner_TabardModel:CycleVariation(1,iconID - currentIndex)
end

function EasyTabardDesigner_OnEvent(self, event, ...)
    if (event == "UNIT_MODEL_CHANGED" or event == "DISPLAY_SIZE_CHANGED" or event == "UI_SCALE_CHANGED") then EasyTabardDesigner_TabardModel:SetUnit("player") end;
    if (event == "TABARD_CANSAVE_CHANGED" or event == "TABARD_SAVE_PENDING") then EasyTabardDesigner_UpdateButtons() end;
    if (event == "PLAYER_INTERACTION_MANAGER_FRAME_HIDE" and (... == 14 or ... == 65)) then EasyTabardDesignerFrame:Hide(); end;
end

function EasyTabardDesigner_UpdateButtons()
    local guildName, rankName, rank = GetGuildInfo("player");
    if (EasyTabardDesigner_TabardModel:IsGuildTabard() and (guildName == nil or rankName == nil or (rank > 0))) then
        EasyTabardDesigner_AcceptButton:Disable();
    else
        if (EasyTabardDesigner_TabardModel:CanSaveTabardNow()) then
            EasyTabardDesigner_AcceptButton:Enable();
        else
            EasyTabardDesigner_AcceptButton:Disable();
        end
    end
end


