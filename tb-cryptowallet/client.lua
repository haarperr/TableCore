TBCore = nil

Citizen.CreateThread(function()
	while TBCore == nil do
		TriggerEvent('tb-core:client:getObject', function(obj) TBCore = obj end)
		Citizen.Wait(0)
    end
end)

RegisterNetEvent('tb-core:client:setCharacterData')
AddEventHandler('tb-core:client:setCharacterData', function(Player)
    PlayerData = Player
end)

--CODE

local display = false

RegisterNetEvent("tb-cryptowallet:client:open")
AddEventHandler("tb-cryptowallet:client:open", function(pData, cData)
    TBCore.Functions.TriggerServerCallback('tb-cryptowallet:server:getCrypto', function(pData, cData)
        SetDisplay(not display, pData, cData)
    end)
end)

RegisterNUICallback("exit", function(data)
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "ui",
        status = false
    })
    display = false
end)

RegisterNUICallback("buy", function(data)
    TriggerServerEvent('tb-cryptowallet:server:buyCrypto', data)
    Citizen.Wait(100)
    TBCore.Functions.TriggerServerCallback('tb-cryptowallet:server:getCrypto', function(pData, cData)
        refresh(pData, cData)
    end)
end)

RegisterNUICallback("sell", function(data)
    TriggerServerEvent('tb-cryptowallet:server:sellCrypto', data)
    Citizen.Wait(100)
    TBCore.Functions.TriggerServerCallback('tb-cryptowallet:server:getCrypto', function(pData, cData)
        refresh(pData, cData)
    end)
end)

function SetDisplay(bool, pData, cData)
    local amount = pData.amount * cData.value
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
        totalvalue = amount,
        curvalue = cData.value,
        amount = pData.amount
    })
end

function refresh(pData, cData)
    local amount = pData.amount * cData.value
    SendNUIMessage({
        totalvalue = amount,
        curvalue = cData.value,
        amount = pData.amount
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