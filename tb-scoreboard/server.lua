local connectedPlayers = {}

TBCore = nil

TriggerEvent('tb-core:server:getObject', function(obj) TBCore = obj end)

ESX.RegisterServerCallback('esx_scoreboard:getConnectedPlayers', function(source, cb)
	cb(connectedPlayers)
end)