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
local loaded = false

Citizen.CreateThread(function()
	while TBCore == nil do
		TriggerEvent('tb-core:client:getObject', function(obj) TBCore = obj end)
		Citizen.Wait(0)
    end

    SendNUIMessage({action = "show"})
    TBCore.Functions.TriggerServerCallback('tb-ui:server:getMoney', function(cash, bank)
        SendNUIMessage({action = "setValue", key = "cash", value = cash})
    end)
end)
          
RegisterNetEvent('tb-ui:client:openUI:multichar')
AddEventHandler('tb-ui:client:openUI:multichar', function()
    SendNUIMessage({action = "show"})
    TBCore.Functions.TriggerServerCallback('tb-ui:server:getMoney', function(cash, bank)
        SendNUIMessage({action = "setValue", key = "cash", value = cash})
    end)
end)

RegisterNetEvent('tb-ui:client:closeUI:multichar')
AddEventHandler('tb-ui:client:closeUI:multichar', function()
    SendNUIMessage({action = "hide"})
end)

RegisterNetEvent('tb-ui:client:updateCash')
AddEventHandler('tb-ui:client:updateCash', function(amount, change, val)
    SendNUIMessage({action = "updateValue", key = "cash", value = amount})
    if change == "add" then
        SendNUIMessage({action = "addcash", value = val})
    elseif change == "remove" then
        SendNUIMessage({action = "removecash", value = val})
    end
end)

Citizen.CreateThread(function()
    while true do
    	Citizen.Wait(0)

        if IsControlJustPressed(0, Keys["F1"]) then
            SendNUIMessage({action = "toggle"})
        end
    end
end)
