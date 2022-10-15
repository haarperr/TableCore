TBCore = nil
local display = false


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

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(6)

        if IsControlJustPressed(0, Config.keyOpen) then
            if not display then
                openPhone(true)
            end
        end
    end
end)

-- ITEM USABLE

local bankAccounts = {
    ["payaccount"] = { name = "Betaal Rekening", balance = 800 },
    ["saveaccount"] = { name = "Spaar Rekening", balance = 854098 },
    ["buisnessacount"] = { name = "Zakelijke Rekening", balance = 9359359 },
}

RegisterNUICallback("exit", function(data)
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "ui",
        status = false
    })
    display = false
end)

function openPhone(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end

RegisterNUICallback('getBankAccounts', function()
    TBCore.Functions.TriggerServerCallback('tb-banking:server:getBankAccounts', function(data)
        SendNUIMessage({
            type = "setupBankAccounts",
            accounts = data,
        })
    end)
end)

function openBank(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
        name = GetPlayerName(PlayerId()),
    })
end

Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)

        DisableControlAction(0, 1, display) -- LookLeftRight
        DisableControlAction(0, 2, display) -- LookUpDown
        DisableControlAction(0, 142, display) -- MeleeAttackAlternate
        DisableControlAction(0, 18, display) -- Enter
        DisableControlAction(0, 322, display) -- ESC
        DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
    end
end)