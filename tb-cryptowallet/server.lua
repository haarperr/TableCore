TBCore = nil

TriggerEvent('tb-core:server:getObject', function(obj) TBCore = obj end)

--CODE

TBCore.Functions.RegisterServerCallback('tb-cryptowallet:server:getCrypto', function(source, cb)
	local src 			= source
	local player 		= TBCore.Functions.getPlayer(src)
    local identifier    = player.Data.identifier

    exports['ghmattimysql']:execute('SELECT * FROM player_cryptos WHERE identifier = @identifier AND crypto = @crypto', {['@identifier'] = identifier, ['@crypto'] = 'tbcoin'}, function(result)
        exports['ghmattimysql']:execute('SELECT * FROM cryptos WHERE crypto = @crypto', {['@crypto'] = result[1].crypto}, function(result2)
            cb(result[1], result2[1])
        end)
    end)
end)

TriggerEvent('tb-core:server:addCommand', 'cryptowallet', function(source, args, user)
	local src 			= source
	local player 		= TBCore.Functions.getPlayer(src)
    local identifier    = player.Data.identifier
    
    TriggerClientEvent('tb-cryptowallet:client:open', source)
end, {help = "Open your cryptowallet"})

RegisterServerEvent('tb-cryptowallet:server:buyCrypto')
AddEventHandler('tb-cryptowallet:server:buyCrypto', function(Data)
    local src 			= source
	local Player 		= TBCore.Functions.getPlayer(src)
    local identifier    = Player.Data.identifier

    exports['ghmattimysql']:execute('SELECT * FROM cryptos WHERE crypto = @crypto', {['@crypto'] = 'tbcoin'}, function(result)
        local costs = Data.amount * result[1].value
        
        if Player.Data.bank < costs then
            TriggerClientEvent('tb-core:client:notify', src, 'error', 'You dont have enough balance on your bank', 2000)
        else
            Player.Functions.removeBank(costs)
            Player.Functions.addCrypto('tbcoin', Data.amount)
            TriggerClientEvent('tb-core:client:notify', src, 'success', 'You\'ve bought '..Data.amount..' TBCoins', 2000)
        end
    end)
end)

RegisterServerEvent('tb-cryptowallet:server:sellCrypto')
AddEventHandler('tb-cryptowallet:server:sellCrypto', function(Data)
    local src 			= source
	local Player 		= TBCore.Functions.getPlayer(src)
    local identifier    = Player.Data.identifier

    exports['ghmattimysql']:execute('SELECT * FROM cryptos WHERE crypto = @crypto', {['@crypto'] = 'tbcoin'}, function(result)
        local costs = Data.amount * result[1].value

        exports['ghmattimysql']:execute('SELECT * FROM player_cryptos WHERE identifier = @id AND crypto = @crypto', {['@id'] = identifier, ['@crypto'] = 'tbcoin'}, function(crypto)
            if crypto[1].amount < Data.amount then
                TriggerClientEvent('tb-core:client:notify', src, 'error', 'You dont have enough TBCoins', 2000)
            else
                Player.Functions.addBank(costs)
                Player.Functions.removeCrypto('tbcoin', Data.amount)
                TriggerClientEvent('tb-core:client:notify', src, 'success', 'You\'ve sold '..Data.amount..' TBCoins', 2000)
            end
        end)
    end)
end)