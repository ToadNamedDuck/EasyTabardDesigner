-- Written by ToadNamedDuck/Jason Harris in (August) 2024
-- Blizzard's current Tabard UI is terrible, and I want it to look a little more like the collections panel with each option showing up.

-- When changing Icons, the right side panels should show a TabardModel for each available icon, each of which keeps the current border, border color, and background color.

-- Slash command which makes the xml frame visible
SLASH_TABARDSHOW = "/tabardshow"
SlashCmdList["TABARDSHOW"] = function()
    if EasyTabardDesignerFrame:IsVisible() then
        EasyTabardDesignerFrame:Show();
    else
        EasyTabardDesignerFrame:Hide()
    end
end