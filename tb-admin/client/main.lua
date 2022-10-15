local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

TBCore = nil

Citizen.CreateThread(function()
	while TBCore == nil do
		TriggerEvent('tb-core:client:getObject', function(obj) TBCore = obj end)
		Citizen.Wait(0)
    end
    
    TBCore.pData = TBCore.Functions.GetPlayerData()
end)

--CODE

ketchup = false
dish = "Banana"
quantity = 1
_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("TBCore Admin")
_menuPool:Add(mainMenu)

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function PlayerManagement(menu)
    local submenu = _menuPool:AddSubMenu(menu, "Player Management")
    for i = 1, 1 do
        players = {}
        local localplayers = {}
        for i = 0, 255 do
            if NetworkIsPlayerActive( i ) then
                table.insert( localplayers, GetPlayerServerId(i) )
            end
        end
        
        table.sort(localplayers)
        for i,thePlayer in ipairs(localplayers) do
            table.insert(players, GetPlayerFromServerId(thePlayer))
        end
        for i,thePlayer in ipairs(players) do
            local name = GetPlayerName(thePlayer)
            local data = {name = GetPlayerName(thePlayer), id = GetPlayerServerId(thePlayer)}
            local submenu = _menuPool:AddSubMenu(menu, "Player Management")
            submenu.SubMenu:AddItem(NativeUI.CreateItem("["..GetPlayerServerId(thePlayer).."] "..GetPlayerName(thePlayer), "Manage "..GetPlayerName(thePlayer)))
        end
    end
end

PlayerManagement(mainMenu)
_menuPool:RefreshIndex()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        _menuPool:ProcessMenus()
    end
end)

RegisterNetEvent('tb-admin:client:openMenu')
AddEventHandler('tb-admin:client:openMenu', function()
    _menuPool:ProcessMenus()
    mainMenu:Visible(not mainMenu:Visible())
end)