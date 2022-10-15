TBCore = nil

TriggerEvent('tb-core:server:getObject', function(obj) TBCore = obj end)

--CODE

TBCore.Functions.RegisterServerCallback('tb-status:server:getStatus', function(source, cb)
    local src    = source
    local pData  = TBCore.Functions.getPlayer(src)

    if pData ~= nil then
        local id     = pData.Data.identifier
        local cid    = pData.Data.cid

        exports['ghmattimysql']:execute('SELECT status FROM players WHERE identifier = @identifier AND cid = @cid', {['@identifier'] = id, ['@cid'] = cid}, function(result)
            cb(result[1].status)
        end)
    end
end)

RegisterServerEvent('tb-status:server:setupStatus')
AddEventHandler('tb-status:server:setupStatus', function()
    local src    = source
    local pData  = TBCore.Functions.getPlayer(src)
    local id     = pData.Data.identifier
    local cid    = pData.Data.cid
    local status = { hunger = 100000, thirst = 100000 }

    exports['ghmattimysql']:execute('UPDATE players SET status = @status WHERE identifier = @identifier AND cid = @cid', {
        ['@identifier'] = id,
        ['@cid'] = cid, 
        ['@status'] = json.encode(status)
    })
end)

function getStatus(player, cb)
    local id = player.Data.identifier
    local cid = player.Data.cid
    local status

    exports['ghmattimysql']:execute('SELECT * FROM players WHERE identifier = @identifier AND cid = @cid', {['@identifier'] = id,['@cid'] = cid}, function(result)
    end)
end

RegisterServerEvent('tb-status:server:addHunger')
AddEventHandler('tb-status:server:addHunger', function(amount)
    local src    = source
    local pData  = TBCore.Functions.getPlayer(src)
    local id     = pData.Data.identifier
    local cid    = pData.Data.cid

    exports['ghmattimysql']:execute('SELECT status FROM players WHERE identifier = @identifier AND cid = @cid', {['@identifier'] = id,['@cid'] = cid}, function(result)
        local currentStatus = {}
        if result[1].status then
            currentStatus = json.decode(result[1].status)
            newHunger = currentStatus.hunger + amount

            TriggerClientEvent('tb-status:client:updateStatusOnEat', src, newHunger)

            if currentStatus.hunger == 100000 then
                TriggerClientEvent('chat:addMessage', src, {
                    template = '<div style="padding: 8px; font-weight: bold; margin: 0.1vw; background-color: rgba(54, 185, 204, 0.75); border-radius: 6px;"><b>{0}</b> | {1}</div>',
                    args = {'STATUS', 'Je hebt momenteel geen honger'}
                })
            else
                if newHunger > 100000 then
                    currentStatus.hunger = 100000
                    exports['ghmattimysql']:execute('UPDATE players SET status = @status WHERE identifier = @identifier AND cid = @cid', {
                        ['@identifier'] = id,
                        ['@cid'] = cid, 
                        ['@status'] = json.encode(currentStatus)
                    })
                else
                    currentStatus.hunger = newHunger
                    exports['ghmattimysql']:execute('UPDATE players SET status = @status WHERE identifier = @identifier AND cid = @cid', {
                        ['@identifier'] = id,
                        ['@cid'] = cid, 
                        ['@status'] = json.encode(currentStatus)
                    })
                end
            end
        end
    end)
end)

RegisterServerEvent('tb-status:server:addThirst')
AddEventHandler('tb-status:server:addThirst', function(amount)
    local src    = source
    local pData  = TBCore.Functions.getPlayer(src)
    local id     = pData.Data.identifier
    local cid    = pData.Data.cid

    exports['ghmattimysql']:execute('SELECT status FROM players WHERE identifier = @identifier AND cid = @cid', {['@identifier'] = id,['@cid'] = cid}, function(result)
        local currentStatus = {}
        if result[1].status then
            currentStatus = json.decode(result[1].status)
            newThirst = currentStatus.thirst + amount

            TriggerClientEvent('tb-status:client:updateStatusOnDrink', src, newThirst)

            if newThirst > 100000 then
                currentStatus.thirst = 100000
                exports['ghmattimysql']:execute('UPDATE players SET status = @status WHERE identifier = @identifier AND cid = @cid', {
                    ['@identifier'] = id,
                    ['@cid'] = cid, 
                    ['@status'] = json.encode(currentStatus)
                })
            else
                currentStatus.thirst = newThirst
                exports['ghmattimysql']:execute('UPDATE players SET status = @status WHERE identifier = @identifier AND cid = @cid', {
                    ['@identifier'] = id,
                    ['@cid'] = cid, 
                    ['@status'] = json.encode(currentStatus)
                })
            end
        end
    end)
end)

RegisterServerEvent('tb-status:server:updateHunger')
AddEventHandler('tb-status:server:updateHunger', function()
    local src    = source
    local pData  = TBCore.Functions.getPlayer(src)

    if pData ~= nil then
        local id     = pData.Data.identifier
        local cid    = pData.Data.cid

        
        exports['ghmattimysql']:execute('SELECT status FROM players WHERE identifier = @identifier AND cid = @cid', {['@identifier'] = id,['@cid'] = cid}, function(result)
            local currentStatus = {}

            if result[1].status then
                currentStatus = json.decode(result[1].status)
                currentStatus.hunger = (currentStatus.hunger - 33)
                
                if currentStatus.hunger > 0 then
                    exports['ghmattimysql']:execute('UPDATE players SET status = @status WHERE identifier = @identifier AND cid = @cid', {
                        ['@identifier'] = id,
                        ['@cid'] = cid, 
                        ['@status'] = json.encode(currentStatus)
                    })
                end
            end
        end)
    end
end)

RegisterServerEvent('tb-status:server:updateThirst')
AddEventHandler('tb-status:server:updateThirst', function()
    local src    = source
    local pData  = TBCore.Functions.getPlayer(src)

    if pData ~= nil then
        local id     = pData.Data.identifier
        local cid    = pData.Data.cid
        
        exports['ghmattimysql']:execute('SELECT status FROM players WHERE identifier = @identifier AND cid = @cid', {['@identifier'] = id,['@cid'] = cid}, function(result)
            local currentStatus = {}

            if result[1].status then
                currentStatus = json.decode(result[1].status)
                currentStatus.thirst = (currentStatus.thirst - 33)
                
                if currentStatus.thirst > 0 then
                    exports['ghmattimysql']:execute('UPDATE players SET status = @status WHERE identifier = @identifier AND cid = @cid', {
                        ['@identifier'] = id,
                        ['@cid'] = cid, 
                        ['@status'] = json.encode(currentStatus)
                    })
                end
            end
        end)
    end
end)

TriggerEvent('tb-core:server:addGroupCommand', 'heal', 'admin', function(source, args, user)
    local Player 	= TBCore.Functions.getPlayer(user)
    
    TriggerClientEvent('tb-status:client:heal', source)

end, function(source, args, user)
	TBCore.Functions.addMessage('DANGER', source, 'SYSTEM', nil, 'You dont have enough permissions')
end, {help = "Heal yourself"})

TriggerEvent('tb-core:server:addGroupCommand', 'tpcoord', 'admin', function(source, args, user)
    local Player 	= TBCore.Functions.getPlayer(user)
    local target = tonumber(args[1])
    local x = tonumber(args[2])
    local y = tonumber(args[3])
    local z = tonumber(args[4])
    
    TriggerClientEvent('tb-status:client:tpcoords', target, x, y, z)

end, function(source, args, user)
	TBCore.Functions.addMessage('DANGER', source, 'SYSTEM', nil, 'You dont have enough permissions')
end, {help = "Heal yourself"})