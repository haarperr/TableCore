TBCore = nil

TriggerEvent('tb-core:server:getObject', function(obj) TBCore = obj end)

--CODE

TBCore.Functions.RegisterServerCallback('tb-weed:server:getHousePlants', function(source, cb, house)
    local housePlants = {}

    exports['ghmattimysql']:execute('SELECT * FROM house_plants WHERE house = @house', {['@house'] = house}, function(plants)
        for i = 1, #plants, 1 do
            table.insert(housePlants, plants[i])
        end

        if housePlants ~= nil then
            cb(housePlants)
        else    
            cb(nil)
        end
    end)
end)

RegisterServerEvent('tb-weed:server:harvestPlant')
AddEventHandler('tb-weed:server:harvestPlant', function(plant, house)
    TriggerClientEvent('tb-weed:client:removePlant', -1, plant, house)
    exports['ghmattimysql']:execute('DELETE FROM house_plants WHERE plantid = @plantid AND house = @house', {['@plantid'] = plant.plantid, ['@house'] = house})
end)

RegisterServerEvent('tb-weed:server:updatePlantTop')
AddEventHandler('tb-weed:server:updatePlantTop', function(plant)
    exports['ghmattimysql']:execute('SELECT * FROM house_plants WHERE plantid = @plantid', {['@plantid'] = plant.plantid}, function(result)
        if result[1].tops - 1 >= 0 then
            exports['ghmattimysql']:execute('UPDATE house_plants SET tops = @tops WHERE plantid = @plantid', {
                ['@plantid'] = plant.plantid, 
                ['@tops'] = (result[1].tops - 1)
            })
            TriggerClientEvent('tb-weed:client:refreshHousePlants', -1)
        end
    end)
end)

RegisterServerEvent('tb-weed:server:addTop')
AddEventHandler('tb-weed:server:addTop', function(plant)
    local src           = source
    local player        = TBCore.Functions.getPlayer(src)
    local identifier    = player.Data.identifier
    local cid           = player.Data.cid
    local item          = Config.Plants[plant.type].item

    player.Functions.giveItem(item, 1)
end)

TriggerEvent('tb-core:server:addCommand', 'planttest', function(source, args, user)
    local src           = source
    local player        = TBCore.Functions.getPlayer(src)
    local identifier    = player.Data.identifier
    local cid           = player.Data.cid

    TriggerClientEvent('tb-weed:client:placePlant', src)
end, {help = "Test to plant a OG Kush plant"})

RegisterServerEvent('tb-weed:server:placePlant')
AddEventHandler('tb-weed:server:placePlant', function(currentHouse, coords)
    exports['ghmattimysql']:execute('INSERT INTO house_plants (`house`, `coords`, `plantid`, `type`) VALUES (@house, @coords, @plantid, @type)', { 
        ['house'] = currentHouse, 
        ['coords'] = coords, 
        ['plantid'] = math.random(000000,999999),
        ['type'] = "og-kush",
    })

    TriggerClientEvent('tb-weed:client:refreshHousePlants', -1)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(6)

        exports['ghmattimysql']:execute('SELECT * FROM house_plants', function(plants)
            for k, v in pairs(plants) do
                if plants[k].food > 90 then
                    exports['ghmattimysql']:execute('UPDATE house_plants SET food = @food WHERE plantid = @plantid', {
                        ['@food'] = plants[k].food - 1,
                        ['@plantid'] = plants[k].plantid
                    })
                else
                    if plants[k].health - 1 > 0 then
                        exports['ghmattimysql']:execute('UPDATE house_plants SET health = @health WHERE plantid = @plantid', {
                            ['@health'] = plants[k].health - 1,
                            ['@plantid'] = plants[k].plantid
                        })
                    else
                        if (plants[k].tops - plants[k].tops / 2) > 0 then
                            exports['ghmattimysql']:execute('UPDATE house_plants SET tops = @tops WHERE plantid = @plantid', {
                                ['@tops'] = (plants[k].tops / 2),
                                ['@plantid'] = plants[k].plantid
                            })
                        end
                    end

                    if plants[k].food - 1 > 0 then
                        exports['ghmattimysql']:execute('UPDATE house_plants SET food = @food WHERE plantid = @plantid', {
                            ['@food'] = plants[k].food - 1,
                            ['@plantid'] = plants[k].plantid
                        })
                    end
                end

                TriggerClientEvent('tb-weed:client:refreshHousePlants', -1)
            end
        end)
        Citizen.Wait(840 * 1000)
    end
end)