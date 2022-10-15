TBCore = nil

TriggerEvent('tb-core:server:getObject', function(obj) TBCore = obj end)

TBCore.Functions.RegisterServerCallback('tb-banking:server:getBankAccounts', function(source, cb)
    local src               = source
    local player            = TBCore.Functions.getPlayer(src)
    local identifier        = player.Data.identifier
    local cid               = player.Data.cid

    exports['ghmattimysql']:execute('SELECT * FROM player_bankaccounts WHERE identifier = @identifier AND cid = @cid', {['@identifier'] = identifier, ['@cid'] = cid}, function(result)
        local accounts = {}
        local debitaccount = {name="Betaal Rekening", balance = player.Data.bank}

        table.insert(accounts, debitaccount)
        for i = 1, #result, 1 do
            table.insert(accounts, result[i])
        end

        cb(accounts)
    end)
end)