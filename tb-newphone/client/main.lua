local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

TBCore = nil
local onPhone = false
local isLoggedIn = false

Citizen.CreateThread(function()
    while TBCore == nil do
        TriggerEvent('tb-core:client:getObject', function(obj) TBCore = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('tb-core:client:setCharacterData')
AddEventHandler('tb-core:client:setCharacterData', function(Player)
    pData = Player
end)

RegisterNetEvent('tb-core:client:PlayerLoaded')
AddEventHandler('tb-core:client:PlayerLoaded', function()
    isLoggedIn = true
end)

-- Code

function CalculateTimeToDisplay()
	hour = GetClockHours()
    minute = GetClockMinutes()
    
    local obj = {}

    if hour <= 12 then
        obj.ampm = 'AM'
    elseif hour >= 13 then
        obj.ampm = 'PM'
        hour = hour - 12
    end
    
	if minute <= 9 then
		minute = "0" .. minute
    end
    
    obj.hour = hour
    obj.minute = minute

    return obj
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        if onPhone then
            local time = CalculateTimeToDisplay()
            SendNUIMessage({
                type = "updateTime",
                time = time
            })
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(6)

        if IsControlJustPressed(0, Keys["M"]) then
            displayPhone(true)
        end
    end
end)

function displayPhone(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "phone",
        toggle = bool
    })
    onPhone = bool
end

RegisterNUICallback('exit', function()
    displayPhone(false)
end)

local playerContacts = {}

RegisterNUICallback('getBankAccounts', function()
    TBCore.Functions.TriggerServerCallback('tb-banking:server:getBankAccounts', function(data)
        local total = 0
        for i = 1, #data, 1 do
            total = total + data[i].balance
        end

        SendNUIMessage({
            type = "setupBankAccounts",
            accounts = data,
            totalbalance = total
        })
    end)
end)

RegisterNUICallback('getPlayerContacts', function()
    TBCore.Functions.TriggerServerCallback('tb-banking:server:getPlayerContacts', function(pContacts)
        SendNUIMessage({
            type = "setupPlayerContacts",
            contacts = pContacts,
        })
    end)
end)

RegisterNUICallback('addContact', function(data)
    local contact = data
    local color = math.random(0, 7)
    local cTable = {
        [1] =   {r = 240, g = 176, b = 0},
        [2] =   {r = 240, g = 52,  b = 0},
        [3] =   {r = 112, g = 189, b = 6},
        [4] =   {r = 69,  g = 196, b = 49},
        [5] =   {r = 43,  g = 120, b = 227},
        [6] =   {r = 161, g = 48,  b = 242},
        [7] =   {r = 240, g = 55,  b = 181},
    }

    TriggerServerEvent('tb-newphone:server:addContact', contact, cTable[color])

    TBCore.Functions.TriggerServerCallback('tb-banking:server:getPlayerContacts', function(pContacts)
        SendNUIMessage({
            type = "setupPlayerContacts",
            contacts = pContacts,
        })

        print(pContacts)
    end)

    -- table.insert(playerContacts, {
    --     name = contact.name,
    --     number = contact.nr,
    --     color = {
    --         r = cTable[color].r,
    --         g = cTable[color].g,
    --         b = cTable[color].b
    --     }
    -- })
end)