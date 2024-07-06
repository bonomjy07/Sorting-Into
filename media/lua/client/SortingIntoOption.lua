SortingInto = SortingInto or {}

SortingInto.Options = SortingInto.Options or {}
SortingInto.Options.key = 1

SortingInto.IsKeyPressed = function()
    -- Define key options using a table
    local KeyOptions = {
        CTRL = 1,
        SHIFT = 2,
        CTRL_SHIFT = 3,
    }

    -- Get the key option from SortingInto.Options
    local selectedKeyOption = SortingInto.Options.key

    -- Check which key option is selected and return the appropriate result
    if selectedKeyOption == KeyOptions.CTRL then
        return isCtrlKeyDown()
    elseif selectedKeyOption == KeyOptions.SHIFT then
        return isShiftKeyDown()
    elseif selectedKeyOption == KeyOptions.CTRL_SHIFT then
        return isCtrlKeyDown() and isShiftKeyDown()
    else
        return false
    end
end

-- [Option Setting]
if ModOptions and ModOptions.getInstance then
    -- Update on value change
    local function onModOptionsApply(optionValues)
        SortingInto.Options.key = optionValues.settings.options.key
    end

    -- Settings
    local settings = {
        options_data = {
            key = {
                getText('UI_optionscreen_CycleContainerKey1'),
                getText('UI_optionscreen_CycleContainerKey2'),
                getText('UI_optionscreen_CycleContainerKey3'),
                name = 'UI_SortingInto_Key',
                tooltip = 'UI_SortingInto_Key_Tooltip',
                default = 1,
                OnApplyMainMenu = onModOptionsApply,
                OnApplyInGame = onModOptionsApply,
            },
        },

        mod_id = 'SortingInto',
        mod_shortname = 'Sorting Into',
        mod_fullname = 'Sorting Into',
    }

    -- Load settings
    ModOptions:getInstance(settings)
    ModOptions:loadFile()
end