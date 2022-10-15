TBCore = nil

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

--CODE

local choosingSpawn = false

RegisterNetEvent('tb-spawnlocation:client:openUI')
AddEventHandler('tb-spawnlocation:client:openUI', function(value)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 195.17, -933.77, 29.7 + 150, -85.00, 0.00, 0.00, 100.00, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
    Citizen.Wait(500)
    SetDisplay(value)
end)

RegisterNUICallback("exit", function(data)
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "ui",
        status = false
    })
    choosingSpawn = false
end)

local cam = nil

RegisterNUICallback('setCam', function(data)
    local location = tostring(data.posname)

    if location == "current" then
        local campos = pData.lastPosition

        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", campos.x, campos.y, campos.z + 150, -85.00, 0.00, 0.00, 100.00, false, 0)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
    else
        local campos = TB.Locations[location].coords

        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", campos.x, campos.y, campos.z + 150, -85.00, 0.00, 0.00, 100.00, false, 0)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
    end
end)

RegisterNUICallback('spawnplayer', function(data)
    local location = tostring(data.spawnloc)
    local ped = GetPlayerPed(-1)

    if location == "current" then
        SetDisplay(false)
        DoScreenFadeOut(500)
        Citizen.Wait(1000)
        SetEntityCoords(ped, pData.lastPosition.x, pData.lastPosition.y, pData.lastPosition.z)
        FreezeEntityPosition(ped, false)
        RenderScriptCams(false, true, 500, true, true)
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        Citizen.Wait(500)
        DoScreenFadeIn(250)
    else
        local pos = TB.Locations[location].coords
        SetDisplay(false)
        DoScreenFadeOut(500)
        Citizen.Wait(1000)
        SetEntityCoords(ped, pos.x, pos.y, pos.z)
        SetEntityHeading(ped, pos.h)
        FreezeEntityPosition(ped, false)
        RenderScriptCams(false, true, 500, true, true)
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        Citizen.Wait(500)
        DoScreenFadeIn(250)
    end
end)

function SetDisplay(bool)
    choosingSpawn = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool
    })
end

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(0)

--         if IsDisabledControlJustPressed(0, TBCore.Functions.getKey("H")) then
--             SetDisplay(true)
--             Citizen.Wait(3000)
--         end
--     end
-- end)

Citizen.CreateThread(function()
    while choosingSpawn do
        Citizen.Wait(0)

        DisableAllControlActions(0)
    end
end)