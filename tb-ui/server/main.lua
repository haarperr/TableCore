TBCore = nil

TriggerEvent('tb-core:server:getObject', function(obj) TBCore = obj end)

TBCore.Functions.RegisterServerCallback('tb-ui:server:getMoney', function(source, cb)
	local src 			= source
    local player 		= TBCore.Functions.getPlayer(src)
    
    if player ~= nil then
        local identifier    = player.Data.identifier
        local pCid          = player.Data.cid

        exports['ghmattimysql']:execute('SELECT * FROM players WHERE identifier = @identifier AND cid = @cid', {['@identifier'] = identifier, ['@cid'] = pCid}, function(result)
            cb(result[1].cash, result[1].bank)
        end)
    end
end)