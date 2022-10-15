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
local inGarage = false
local menu = false

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
    TriggerEvent('tb-garage:client:setupGarages')
end)

-- CODE

local playerVehicles = {
    ["lwgtr"] = {
        plate = "lwgtr",
        vehicle = "lwgtr",
        name = "Nissan GTR",
        fuel = 50,
        bodyhp = 60,
        enginehp = 40
    },
    ["porsche"] = {
        plate = "porsche",
        vehicle = "porsche",
        name = "Porsche 911",
        fuel = 50,
        bodyhp = 60,
        enginehp = 40
    },
    ["c63s"] = {
        plate = "c63s",
        vehicle = "c63s",
        name = "Mercedes C63s AMG",
        fuel = 50,
        bodyhp = 60,
        enginehp = 40
    },
    ["m2"] = {
        plate = "m2",
        vehicle = "m2",
        name = "BMW M2",
        fuel = 50,
        bodyhp = 60,
        enginehp = 40
    },
}

function getOutVehicle(vehicle)
	local myPed = GetPlayerPed(-1)
	local player = PlayerId()
	local vehicle = GetHashKey(vehicle)

    RequestModel(vehicle)

	while not HasModelLoaded(vehicle) do
		Wait(1)
	end

	local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 5.0, 0)
	local spawned_car = CreateVehicle(vehicle, coords, 64.55118,116.613,78.69622, true, false)
	SetVehicleOnGroundProperly(spawned_car)
	SetPedIntoVehicle(myPed, spawned_car, - 1)
	SetModelAsNoLongerNeeded(vehicle)
end

-- BLIPS
Citizen.CreateThread(function()
    for k, v in pairs(Config.Garages) do
        Garage = AddBlipForCoord(Config.Garages[k].x, Config.Garages[k].y, Config.Garages[k].z)

        SetBlipSprite (Garage, 357)
        SetBlipDisplay(Garage, 4)
        SetBlipScale  (Garage, 0.65)
        SetBlipAsShortRange(Garage, true)
        SetBlipColour(Garage, 3)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.Garages[k].label)
        EndTextCommandSetBlipName(Garage)
    end
end)

Citizen.CreateThread(function()
    while isLoggedIn do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)

        for k, v in pairs(Config.Garages) do
            local dist = GetDistanceBetweenCoords(GetEntityCoords(ped), Config.Garages[k].x, Config.Garages[k].y, Config.Garages[k].z, false)

            if dist < 1.5 then
                if not IsPedInAnyVehicle(ped, false) then
                    TBCore.Functions.DrawText3D(Config.Garages[k].x, Config.Garages[k].y, Config.Garages[k].z + 0.5, '[~g~E~w~] Om voertuig te pakken')
                    if IsControlJustPressed(0, Keys["E"]) then
                        menu = not menu
                        print('yeet')
                        -- setupPlayerVehicles()
                        -- openGarage(true)
                    end
                end
            end

            if dist < 50 then
                DrawMarker(2, Config.Garages[k].x, Config.Garages[k].y, Config.Garages[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 200, 0, 0, 155, false, false, false, true, false, false, false)
            end
        end
    end
end)

RegisterNUICallback('exit', function()
    openGarage(false)
end)

function openGarage(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "garage",
        open = bool
    })
    inGarage = bool
end

function setupPlayerVehicles()
    SendNUIMessage({
        action = "setupPlayerVehicles",
        vehicles = playerVehicles
    })
end

RegisterNetEvent("GUI:Option")
AddEventHandler("GUI:Option", function(option, cb)
	cb(Menu.Option(option))
end)

RegisterNetEvent("GUI:Update")
AddEventHandler("GUI:Update", function()
	Menu.updateSelection()
end)

Citizen.CreateThread(function()
	TriggerServerEvent("player_join")
	
	while true do
        if(menu) then
            for k, v in pairs(playerVehicles) do
                TriggerEvent("GUI:Option", playerVehicles[k].name, function(cb)
                    if(cb) then
                        print('yeet')
                    end
                end)
            end

            TriggerEvent("GUI:Option", "Sluiten", function(cb)
                if(cb) then
                    menu = not menu
                end
            end)

			TriggerEvent("GUI:Update")
		end
		Wait(0)
	end
end)