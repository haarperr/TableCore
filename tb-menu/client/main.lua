--[[ General Variables ]]--
local isMenuOpen = false
local menus = {}

function CreateMenu(title, subtitle, optionChange, close)
    local Menu = {}

    Menu = {}
    Menu.title = title
    Menu.subtitle = subtitle
    Menu.optionCb = optionChange
    Menu.closeCb = close
    Menu.buttons = {}

    table.insert(menus, Menu)

    return #menus
end

function RefreshMenu(index)
    SendNUIMessage({
        action = "refreshCurrentMenu",
        data = menus[index]
    })
end

function DestroyMenus()
    menus = {}
    SendNUIMessage({
        action = "destroyMenus"
    })
end
 
function AddButton(index, label, data, disabled, select)
    table.insert(menus[index].buttons, {
        type = 1,
        label = label,
        disabled = disabled,
        data = data,
        select = select
    })
end

function AddAdvancedButton(index, label, right, data, disabled, select)
    table.insert(menus[index].buttons, {
        type = 4,
        label = label,
        right = right,
        disabled = disabled,
        data = data,
        select = select
    })
end

function AddStoreButton(index, label, right, data, disabled, select)
    table.insert(menus[index].buttons, {
        type = 6,
        label = label,
        right = right,
        disabled = disabled,
        data = data,
        select = select
    })
end

function AddCheckButton(index, label, data, disabled, select)
    table.insert(menus[index].buttons, {
        type = 5,
        label = label,
        disabled = disabled,
        data = data,
        select = select
    })
end

function AddSlider(index, label, data, max, disabled, select, valChange)
    table.insert(menus[index].buttons, {
        type = 2,
        label = label,
        max = max,
        disabled = disabled,
        data = data,
        select = select,
        slideChange = valChange
    })
end

function AddSubMenu(index, label, menu, disabled)
    table.insert(menus[index].buttons, {
        type = 0,
        label = label,
        disabled = disabled,
        data = menu
    })
end

function AddSubMenuBack(index, label)
    table.insert(menus[index].buttons, {
        type = -1,
        label = label
    })
end

function OpenMenu(resource)
    SendNUIMessage({
        action = "display",
        resource = resource,
        data = menus
    })

    SetNuiFocus(true, false)
    DisableControls()
    isMenuOpen = true
end

function DisableControls()
    Citizen.CreateThread(function()
        local ped = PlayerPedId()
        while isMenuOpen do
            DisableControlAction(0, 75, true) -- disable exit vehicle
            DisablePlayerFiring(PlayerId(), true) -- Disable weapon firing
            DisableControlAction(0, 24, true) -- disable attack
            DisableControlAction(0, 25, true) -- disable aim
            DisableControlAction(1, 37, true) -- disable weapon select
            DisableControlAction(0, 47, true) -- disable weapon
            DisableControlAction(0, 58, true) -- disable weapon
            DisableControlAction(0, 140, true) -- disable melee
            DisableControlAction(0, 141, true) -- disable melee
            DisableControlAction(0, 142, true) -- disable melee
            DisableControlAction(0, 143, true) -- disable melee
            DisableControlAction(0, 263, true) -- disable melee
            DisableControlAction(0, 264, true) -- disable melee
            DisableControlAction(0, 257, true) -- disable melee
            Citizen.Wait(1)
        end
    end)
end

RegisterNUICallback("CloseUI", function(data, cb)
    PlaySoundFrontend(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    SetNuiFocus(false, false)
    isMenuOpen = false
    menus = {}
    SendNUIMessage({
        action = "destroyMenus"
    })
    cb('ok')
end)

RegisterNUICallback("CloseCb", function(data, cb)
    TriggerEvent(data.resource .. ':client:' .. data.callback)
    cb('ok')
end)

RegisterNUICallback("SelectItem", function(data, cb)
    TriggerEvent(data.resource .. ':client:' .. data.callback, data.data, cb)
end)

RegisterNUICallback("SlideValueChange", function(data, cb)
    TriggerEvent(data.resource .. ':client:' .. data.callback, data.data, data.index)
    cb('ok')
end)

RegisterNUICallback("MenuOptionChange", function(data, cb)
    TriggerEvent(data.resource .. ':client:' .. data.callback, data.data)
    cb('ok')
end)

RegisterNUICallback("MenuUpDown", function(data, cb)
    PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    cb('ok')
end)

RegisterNUICallback("MenuSelect", function(data, cb)
    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    cb('ok')
end)

RegisterNUICallback("MenuSelectDisabled", function(data, cb)
    PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    cb('ok')
end)

RegisterNUICallback("MenuSlideChange", function(data, cb)
    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    cb('ok')
end)

RegisterNUICallback("MenuBack", function(data, cb)
    PlaySoundFrontend(-1, "CANCEL", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    cb('ok')
end)