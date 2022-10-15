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

local carhud = false

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

function getCardinalDirectionFromHeading(heading)
    if ((heading >= 0 and heading < 45) or (heading >= 315 and heading < 360)) then
        return "Noord"
    elseif (heading >= 45 and heading < 135) then
        return "Oost"
    elseif (heading >=135 and heading < 225) then
        return "Zuid"
    elseif (heading >= 225 and heading < 315) then
        return "West"
    end
end


Citizen.CreateThread(function()
    while true do
        if carhud then
            local ped = GetPlayerPed(-1)
            local time = CalculateTimeToDisplay()
            local heading = getCardinalDirectionFromHeading(GetEntityHeading(ped))
            local pos = GetEntityCoords(ped)
            local var1, var2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
            local current_zone = GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z))
            local kmh = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) * 3.6
            local speed = math.ceil(kmh)
            local fuel = exports['LegacyFuel']:GetFuel(GetVehiclePedIsIn(ped, false))

            SendNUIMessage({
                action = "update",
                time = time,
                heading = heading,
                street1 = GetStreetNameFromHashKey(var1),
                street2 = GetStreetNameFromHashKey(var2),
                area = current_zone,
                speed = speed,
                fuel = fuel
            })
        end
        Citizen.Wait(400)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local ped = GetPlayerPed(-1)

        if IsPedInAnyVehicle(ped, false) then
            if not carhud then
                SendNUIMessage({
                    action = "enableCarHud"
                })
                carhud = true
            end
        else
            if carhud then
                SendNUIMessage({
                    action = "disableCarHud"
                })
                carhud = false
                seatbeltIsOn = false
            end
        end
    end
end)