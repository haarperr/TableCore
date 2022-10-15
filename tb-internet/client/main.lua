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

-- Cellucar Costs

-- Citizen.CreateThread(function()
--     -- Check voor laptop of telefoon
--     local cellularCosts = TBConfig.cellularCosts.cellularCost
--     local costsTimeout = TBConfig.cellularCosts.timeout
--     local hasElectronics = pData.getInventoryItem("laptop")
--     local electronicCount = hasElectronics.amount
--     while true do
--         if electronicCount > 0 then
--             -- Keiharde rekeningen betalen voor internetgebruik
--         end
--     end
-- end)


-- ORDER 

RegisterNUICallback("order", function(item, price, amount)
    print(item.. " : " ..amount.. ": $ " ..price)
    -- TriggerServerEvent met item, price & amount data
end)

-- ITEM USABLE

RegisterNetEvent('tb-inventory:usableItem:laptop')
AddEventHandler('tb-inventory:usableItem:laptop', function(itemData)
    Citizen.Wait(1000)
    openLaptop(true)
end)

RegisterNUICallback("exit", function(data)
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "ui",
        status = false
    })
    display = false
end)

function openLaptop(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
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