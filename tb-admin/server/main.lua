TBCore = nil

TriggerEvent('tb-core:server:getObject', function(obj) TBCore = obj end)

--CODE

TriggerEvent('tb-core:server:addCommand', 'admin', function(source, args, user)
    TriggerClientEvent('tb-admin:client:openMenu', source)
end, {help = "Set cash amount of a player"})


