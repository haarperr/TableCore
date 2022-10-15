TBCore = nil

TriggerEvent('tb-core:server:getObject', function(obj) TBCore = obj end)

TBCore.Functions.RegisterServerCallback('tb-banking:server:getBankAccounts', function(source, cb)
    local src               = source
    local player            = TBCore.Functions.getPlayer(src)
    local identifier        = player.Data.identifier
    local cid               = player.Data.cid

    exports['ghmattimysql']:execute('SELECT * FROM player_bankaccounts WHERE identifier = @identifier AND cid = @cid', {['@identifier'] = identifier, ['@cid'] = cid}, function(result)
        local accounts = {}
        local debitaccount = {name= player.Data.firstname..' '..player.Data.lastname, type = "Betaal Rekening", balance = 1, banknumber = "NLYEET01234"}

        table.insert(accounts, debitaccount)
        for i = 1, #result, 1 do
            table.insert(accounts, result[i])
        end

        cb(accounts)
    end)
end)

RegisterServerEvent('tb-newphone:server:addContact', function(cData, cColor)
    local src               = source
    local player            = TBCore.Functions.getPlayer(src)
    local identifier        = player.Data.identifier
    local cid               = player.Data.cid

    exports['ghmattimysql']:execute('INSERT INTO player_contacts (`identifier`, `cid`, `name`, `number`, `color`) VALUES (@identifier, @cid, @name, @number, @color)', {
        ['identifier'] = identifier,
        ['cid'] = cid,
        ['name'] = cData.name,
        ['number'] = cData.number,
        ['color'] = json.encode(cColor)
    })
end)

TBCore.Functions.RegisterServerCallback('tb-banking:server:getPlayerContacts', function(source, cb)
    local src               = source
    local player            = TBCore.Functions.getPlayer(src)
    local identifier        = player.Data.identifier
    local cid               = player.Data.cid

    exports['ghmattimysql']:execute('SELECT * FROM player_contacts WHERE identifier = @identifier AND cid = @cid', {['@identifier'] = identifier, ['@cid'] = cid}, function(result)
        local playerContacts = {}

        table.insert(playerContacts, playerContacts)
        for i = 1, #result, 1 do
            table.insert(playerContacts, result[i])
        end

        cb(playerContacts)
    end)
end)