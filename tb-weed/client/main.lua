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
local isLoggedIn = true
local housePlants = {}
local plantSpawned = false
local insideHouse = false
local currentHouse = nil

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

RegisterNetEvent('tb-houses:client:insideHouse')
AddEventHandler('tb-houses:client:insideHouse', function(bool)
    insideHouse = bool

    if bool == true then
        TriggerEvent('tb-weed:client:spawnPlants')
        Citizen.Wait(100)
        TriggerEvent('tb-weed:client:setPlantInfo')
    end
end)

RegisterNetEvent('tb-weed:client:getHousePlants')
AddEventHandler('tb-weed:client:getHousePlants', function(house)
    if currentHouse == nil then
        currentHouse = house
    end
    TBCore.Functions.TriggerServerCallback('tb-weed:server:getHousePlants', function(plants)
        housePlants = plants
        print(json.encode(housePlants))
    end, house)
end)

RegisterNetEvent('tb-weed:client:spawnPlants')
AddEventHandler('tb-weed:client:spawnPlants', function()
    Citizen.CreateThread(function()
        Citizen.Wait(500)
        if not plantSpawned then
            for k, v in pairs(housePlants) do
                local prop = Config.Props[housePlants[k].stage]
                local plantCoords = json.decode(housePlants[k].coords)

                local plantModel = GetHashKey(prop.model)
                plantObject = CreateObject(plantModel, plantCoords.x, plantCoords.y, plantCoords.z - 3.5, false, false, false)
                FreezeEntityPosition(plantObject, true)
                SetEntityAsMissionEntity(enplantObject, false, false)
            end
            plantSpawned = true
        end
    end)
end)

RegisterNetEvent('tb-weed:client:setPlantInfo')
AddEventHandler('tb-weed:client:setPlantInfo', function()
    Citizen.CreateThread(function()
        while insideHouse do
            Citizen.Wait(3)
            if plantSpawned then
                local ped = GetPlayerPed(-1)

                for k, v in pairs(housePlants) do
                    local plantCoords = json.decode(housePlants[k].coords)
                    local dist = GetDistanceBetweenCoords(GetEntityCoords(ped), plantCoords.x, plantCoords.y, plantCoords.z, false)

                    if dist < 1.0 then
                        if housePlants[k].harvestable == "true" then
                            TBCore.Functions.DrawText3D(plantCoords.x, plantCoords.y, plantCoords.z + 0.5, '[~g~E~w~] To harvest plant')
                            TBCore.Functions.DrawText3D(plantCoords.x, plantCoords.y, plantCoords.z, 'Plant: ~g~'..Config.Plants[housePlants[k].type].label..'~w~ | Food: ~b~'..housePlants[k].food..'%')
                            if IsControlJustPressed(0, Keys["E"]) then
                                harvestPlant(housePlants[k])
                            end
                        else
                            TBCore.Functions.DrawText3D(plantCoords.x, plantCoords.y, plantCoords.z, 'Plant: ~g~'..Config.Plants[housePlants[k].type].label..'~w~ | Food: ~b~'..housePlants[k].food..'%')
                        end
                    end
                end
            end
        end
    end)
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(100)
    end
end

function harvestPlant(plant)
    local plantId = plant.plantid
    local ad = "anim@amb@business@weed@weed_inspecting_high_dry@"
    local playerPed = GetPlayerPed(-1)

    TBCore.Functions.ProgressBar('Bezig met oogsten', Config.HarvestTime)
    loadAnimDict(ad)
    TaskPlayAnim(playerPed, ad, 'weed_inspecting_high_base_inspector', 8.0, 8.0, -1, 50, 0, true, true, true)
    Citizen.Wait(Config.HarvestTime)
    TaskPlayAnim(playerPed, ad, 'exit', 8.0, 8.0, -1, 50, 0, false, false, false)
    if plant.tops ~= 0 then
        TriggerServerEvent('tb-weed:server:addTop', plant)
        TriggerServerEvent('tb-weed:server:updatePlantTop', plant, plant.tops)
    else
        TriggerServerEvent('tb-weed:server:addTop', plant)
        TriggerServerEvent('tb-weed:server:harvestPlant', plant, currentHouse)
    end
end

RegisterNetEvent('tb-weed:client:removePlant')
AddEventHandler('tb-weed:client:removePlant', function(plant, house)
    local plantCoords = json.decode(plant.coords)
    local plantModel = Config.Props[plant.stage].model
    local plantObject = GetClosestObjectOfType(plantCoords.x, plantCoords.y, plantCoords.z, 1.0, GetHashKey(plantModel), true, false, false)
    DeleteEntity(plantObject)

    if insideHouse and currentHouse == house then
        housePlants = {}
        TriggerEvent('tb-weed:client:getHousePlants', house)
    end
end)

RegisterNetEvent('tb-weed:client:refreshHousePlants')
AddEventHandler('tb-weed:client:refreshHousePlants', function()
    if insideHouse then
        TriggerEvent('tb-weed:client:getHousePlants', currentHouse)
    end
end)

RegisterNetEvent('tb-weed:client:placePlant')
AddEventHandler('tb-weed:client:placePlant', function()
    local ped = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ped)
    local house = currentHouse
    local plantcoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 0.75, 0)
    local coords = { x = plantcoords.x, y = plantcoords.y, z = plantcoords.z }
    TriggerServerEvent('tb-weed:server:placePlant', house, json.encode(coords))
    Citizen.Wait(100)
    local prop = Config.Props["stage-b"]
    local plantModel = GetHashKey(prop.model)
    plantObject = CreateObject(plantModel, plantcoords.x, plantcoords.y, plantcoords.z - 3.5, false, false, false)
    FreezeEntityPosition(plantObject, true)
    SetEntityAsMissionEntity(enplantObject, false, false)
end)
