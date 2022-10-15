TBCore = nil

local status    = nil
local healthBar = false
local PlayerLoaded = true

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
    PlayerLoaded = true
end)

Citizen.CreateThread(function()
    while true do

        if status ~= nil then
            local ped = GetPlayerPed(-1)
            local health = GetEntityHealth(ped)
            local armor = GetPedArmour(ped)
            SendNUIMessage({
                show 	= IsPauseMenuActive(),
                health 	= (GetEntityHealth(GetPlayerPed(-1))-100),
                armor 	= armor,
                hunger  = status.hunger,
                thirst  = status.thirst

            });
            SendNUIMessage({action = "show"});
        end

        Citizen.Wait(100)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        if status ~= nil then
            if status.hunger < 30000 then
                local bericht = math.random(1, 4)
                if bericht == 1 then
                    TriggerEvent('chat:addMessage', {
                        template = '<div style="padding: 8px; font-weight: bold; margin: 0.1vw; background-color: rgba(54, 185, 204, 0.75); border-radius: 6px;"><b>{0}</b> | {1}</div>',
                        args = {'STATUS', 'Je voelt je licht in je hoofd'}
                    })
                elseif bericht == 2 then
                    TriggerEvent('chat:addMessage', {
                        template = '<div style="padding: 8px; font-weight: bold; margin: 0.1vw; background-color: rgba(54, 185, 204, 0.75); border-radius: 6px;"><b>{0}</b> | {1}</div>',
                        args = {'STATUS', 'Je buik is aan het rommelen'}
                    })
                elseif bericht == 3 then
                    TriggerEvent('chat:addMessage', {
                        template = '<div style="padding: 8px; font-weight: bold; margin: 0.1vw; background-color: rgba(54, 185, 204, 0.75); border-radius: 6px;"><b>{0}</b> | {1}</div>',
                        args = {'STATUS', 'Je voelt je slapjes'}
                    })
                elseif bericht == 4 then
                    TriggerEvent('chat:addMessage', {
                        template = '<div style="padding: 8px; font-weight: bold; margin: 0.1vw; background-color: rgba(54, 185, 204, 0.75); border-radius: 6px;"><b>{0}</b> | {1}</div>',
                        args = {'STATUS', 'Je hebt weinig energie'}
                    })
                end 
            end
            Citizen.Wait(5 * 60 * 1000)
        end
    end
end)

Citizen.CreateThread(function()
    while PlayerLoaded do
        Citizen.Wait(7)

        if status ~= nil then
            if status.hunger < 30000 then
                local ped = GetPlayerPed(-1)
                local currentHP = GetEntityHealth(ped)
                local newHP = currentHP - 1

                SetEntityHealth(ped, newHP)
                Citizen.Wait(6000)
            end
        end
    end
end)

RegisterNetEvent('tb-status:client:updateStatusOnDrink')
AddEventHandler('tb-status:client:updateStatusOnDrink', function(thirst)
    SendNUIMessage({
        thirst  = thirst
    });
end)

RegisterNetEvent('tb-status:client:updateStatusOnEat')
AddEventHandler('tb-status:client:updateStatusOnEat', function(eat)
    SendNUIMessage({
        hunger  = eat
    });
end)

-- GET STATUS
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if PlayerLoaded then
            TBCore.Functions.TriggerServerCallback('tb-status:server:getStatus', function(data)
                if data ~= nil then
                    status = json.decode(data)
                else
                    TriggerServerEvent('tb-status:server:setupStatus')
                end
            end)
        end
        Citizen.Wait(5000)
    end
end)

-- UPDATE HUNGER / THIRST
Citizen.CreateThread(function()
    while true do
        if PlayerLoaded then
            TriggerServerEvent('tb-status:server:updateHunger')
        end
        Citizen.Wait(2500)
    end
end)

Citizen.CreateThread(function()
    while true do
        if PlayerLoaded then
            TriggerServerEvent('tb-status:server:updateThirst')
        end
        Citizen.Wait(1000)
    end
end)

RegisterNetEvent('tb-status:client:openUI:multichar')
AddEventHandler('tb-status:client:openUI:multichar', function()
    SendNUIMessage({action = "show"});
    healthBar = true
end)

RegisterNetEvent('tb-inventory:usableItem:bread')
AddEventHandler('tb-inventory:usableItem:bread', function(item)
    TriggerServerEvent('tb-core:server:removeUsedItem', item, 1)
    TriggerServerEvent('tb-status:server:addHunger', 20000)
end)

RegisterNetEvent('tb-inventory:usableItem:water')
AddEventHandler('tb-inventory:usableItem:water', function(item)
    print(item)
    TriggerServerEvent('tb-core:server:removeUsedItem', item, 1)
    TriggerServerEvent('tb-status:server:addThirst', 20000)
end)

RegisterNetEvent('tb-status:client:heal')
AddEventHandler('tb-status:client:heal', function()
    local ped = GetPlayerPed(-1)

    SetEntityHealth(ped, 200)
    TriggerServerEvent('tb-status:server:addThirst', 100000)
    Citizen.Wait(500)
    TriggerServerEvent('tb-status:server:addHunger', 100000)
end)

RegisterNetEvent('tb-status:client:tpcoords')
AddEventHandler('tb-status:client:tpcoords', function(x, y, z)
    local ped = GetPlayerPed(-1)

    SetEntityCoords(ped, x, y, z)
end)