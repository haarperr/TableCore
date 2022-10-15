TBCore = nil

TriggerEvent('tb-core:server:getObject', function(obj) TBCore = obj end)

--CODE

local houseprices = {
	["mirrorpark01"] = 200000,
	["mirrorpark02"] = 250000,
}

local houseowneridentifier = {}
local houseownercid = {}

RegisterServerEvent('tb-houses:server:viewHouse')
AddEventHandler('tb-houses:server:viewHouse', function(house)
	local src     		= source
	local pData 		= TBCore.Functions.getPlayer(src)

	local houseprice   	= houseprices[house]
	local brokerfee 	= (houseprice / 100 * 5)
	local bankfee 		= (houseprice / 100 * 10)
	local taxes 		= (houseprice / 100 * 6)

	TriggerClientEvent('tb-houses:client:viewHouse', src, houseprice, brokerfee, bankfee, taxes, pData.Data.firstname, pData.Data.lastname)
end)

RegisterServerEvent('tb-houses:server:buyHouse')
AddEventHandler('tb-houses:server:buyHouse', function(house)
	local src     	= source
	local pData 	= TBCore.Functions.getPlayer(src)
	local balance 	= pData.Data.bank
	local price   	= houseprices[house]

	if balance > price then
		pData.Functions.removeBank(price)
		exports['ghmattimysql']:execute('INSERT INTO player_houses (`house`, `identifier`, `cid`) VALUES (@house, @identifier, @cid)', {
			['house'] = house, 
			['identifier'] = pData.Data.identifier, 
			['cid'] = pData.Data.cid
		})
		houseowneridentifier[house] = pData.Data.identifier
		houseownercid[house] = pData.Data.cid
		print('Gefeliciteerd met je osso e neef')
		TriggerClientEvent('tb-houses:client:SetClosestHouse', src)
	else
		local resterend = price - balance
		print("Je hebt niet voldoende geld, je mist: €"..resterend..",-")
	end
end)

RegisterServerEvent('tb-houses:server:lockHouse')
AddEventHandler('tb-houses:server:lockHouse', function(bool, house)
	TriggerClientEvent('tb-houses:client:lockHouse', -1, bool, house)
end)

--------------------------------------------------------------

--------------------------------------------------------------

TBCore.Functions.RegisterServerCallback('tb-houses:server:hasKey', function(source, cb, house)
	local src = source
	local pData = TBCore.Functions.getPlayer(src)

	if pData then
		local identifier = pData.Data.identifier
		local CharId = pData.Data.cid
		cb(hasKey(identifier, CharId, house))
	end
end)

TBCore.Functions.RegisterServerCallback('tb-houses:server:isOwned', function(source, cb, house)
	if houseowneridentifier[house] ~= nil and houseownercid[house] ~= nil then
		cb(true)
	else
		cb(false)
	end
end)

function hasKey(identifier, cid, house)
	if houseowneridentifier[house] ~= nil and houseownercid[house] ~= nil then
		if houseowneridentifier[house] == identifier and houseownercid[house] == cid then
			return true
		end
	end
	return false
end

function typeof(var)
    local _type = type(var);
    if(_type ~= "table" and _type ~= "userdata") then
        return _type;
    end
    local _meta = getmetatable(var);
    if(_meta ~= nil and _meta._NAME ~= nil) then
        return _meta._NAME;
    else
        return _type;
    end
end

local housesLoaded = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if not housesLoaded then
			exports['ghmattimysql']:execute('SELECT * FROM player_houses', function(houses)
				if houses ~= nil then
					for _,house in pairs(houses) do
						houseowneridentifier[house.house] = house.identifier
						houseownercid[house.house] = house.cid
					end
				end
			end)
			housesLoaded = true
		end
	end
end) 

TBCore.Functions.RegisterServerCallback('tb-houses:server:getHouseInventory', function(source, cb)
	local pData = TBCore.Functions.getPlayer(target)

	if pData ~= nil then
		cb({inventory = pData.inventory, weapons = pData.weapons})
	else
		cb(nil)
	end
end)

TBCore.Functions.RegisterServerCallback('tb-houses:server:getOwnedHouses', function(source, cb)
	local pData = TBCore.Functions.getPlayer(source)

	if pData then
		local id = pData.Data.identifier
		local cid = pData.Data.cid

		exports['ghmattimysql']:execute('SELECT * FROM player_houses WHERE identifier = @identifier AND cid = @cid', {['@identifier'] = id, ['@cid'] = cid}, function(houses)
			local ownedHouses = {}

			for i=1, #houses, 1 do
				table.insert(ownedHouses, houses[i].house)
			end

			if houses ~= nil then
				cb(ownedHouses)
			else
				cb(nil)
			end
		end)
	end
end)

TriggerEvent('tb-core:server:addCommand', 'sell', function(source, args, user)
	TriggerClientEvent('tb-houses:client:sellHouse', source)
end, {help = "Set cash amount of a player", params = {{name = "id", help = "Player ID"}, {name = "amount", help = "The amount of money"}}})

-- ESX.RegisterServerCallback('tb-houses:server:getStashLoc', function(source, cb, house)
-- 	local currenthouse  = MySQL.Sync.fetchAll('SELECT * FROM houses WHERE name = @name', {['@name'] = house})

-- 	if currenthouse[1].stash ~= nil then
-- 		cb(json.decode(currenthouse[1].stash))
-- 	else
-- 		cb(nil)
-- 	end
-- end)

-- ESX.RegisterServerCallback('tb-houses:server:getClosetLoc', function(source, cb, house)
-- 	local currenthouse  = MySQL.Sync.fetchAll('SELECT * FROM houses WHERE name = @name', {['@name'] = house})

-- 	if currenthouse[1].closet ~= nil then
-- 		cb(json.decode(currenthouse[1].closet))
-- 	else
-- 		cb(nil)
-- 	end
-- end)

-- ESX.RegisterServerCallback('tb-houses:server:getPlayerDressing', function(source, cb)
-- 	local xPlayer  = ESX.GetPlayerFromId(source)

-- 	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
-- 		local count  = store.count('dressing')
-- 		local labels = {}

-- 		for i=1, count, 1 do
-- 			local entry = store.get('dressing', i)
-- 			table.insert(labels, entry.label)
-- 		end

-- 		cb(labels)
-- 	end)
-- end)

-- ESX.RegisterServerCallback('tb-houses:server:getPlayerOutfit', function(source, cb, num)
-- 	local xPlayer  = ESX.GetPlayerFromId(source)

-- 	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
-- 		local outfit = store.get('dressing', num)
-- 		cb(outfit.skin)
-- 	end)
-- end)

--------------------------------------------------------------
-- Commands
--------------------------------------------------------------

-- TriggerEvent('es:addCommand', 'huis', function(source, args, user)
-- 	local src 	     = source
-- 	local xPlayer    = ESX.GetPlayerFromId(src)
-- 	local identifier = xPlayer.identifier

-- 	if args[1] ~= nil then
-- 		if args[1] == "add" then
-- 			if args[2] == "stash" then
-- 				TriggerClientEvent('tb-houses:client:addLocation', src, "stash")
-- 			elseif args[2] == "closet" then
-- 				TriggerClientEvent('tb-houses:client:addLocation', src, "closet")
-- 			elseif args[2] ~= "closet" or args[2] ~= "stash" or args[2] == nil then
-- 				TriggerClientEvent('tb-houses:client:sendAlert', src, 'error', 'Je moet een object meegeven, (stash / closet)')
-- 			end

-- 		elseif args[1] == "remove" then

-- 			if args[2] == "stash" then
-- 				TriggerClientEvent('tb-houses:client:removeLocation', src, "stash")
-- 			elseif args[2] == "closet" then
-- 				TriggerClientEvent('tb-houses:client:removeLocation', src, "closet")
-- 			elseif args[2] ~= "closet" or args[2] ~= "stash" or args[2] == nil then
-- 				TriggerClientEvent('tb-houses:client:sendAlert', src, 'error', 'Je moet een object meegeven, (stash / closet)')
-- 			end
-- 		end
-- 	else
-- 		TriggerClientEvent('tb-houses:client:sendAlert', src, 'error', 'Je moet een opdracht meegeven, (add / remove)')
-- 	end
-- end, {help = "Huis", params = {{name = "Actie", help = "add, remove"}, {name = "Wat", help = "stash, closet"}}})

--------------------------------------------------------------
-- Command Events
--------------------------------------------------------------

-- RegisterNetEvent('tb-houses:server:addStash')
-- AddEventHandler('tb-houses:server:addStash', function(playerpos, house)
-- 	local src        		= source
-- 	local xPlayer    		= ESX.GetPlayerFromId(src)
-- 	local identifier 		= xPlayer.identifier
-- 	local currenthouse      = MySQL.Sync.fetchAll('SELECT * FROM houses WHERE name = @name', {['@name'] = house})

-- 	if currenthouse[1].stash == nil then
-- 		MySQL.Async.execute('UPDATE houses SET stash = @stash WHERE name = @name',{['@stash'] = json.encode(playerpos), ['@name'] = house })
-- 		TriggerClientEvent('tb-houses:client:sendAlert', src, 'success', 'Stash succesvol geplaatst')
-- 		TriggerClientEvent('tb-houses:client:setClosetStash', src)
-- 	else
-- 		TriggerClientEvent('tb-houses:client:sendAlert', src, 'error', 'Je hebt al een stash')
-- 	end
-- end)

-- RegisterNetEvent('tb-houses:server:addCloset')
-- AddEventHandler('tb-houses:server:addCloset', function(playerpos, house)
-- 	local src        		= source
-- 	local xPlayer    		= ESX.GetPlayerFromId(src)
-- 	local identifier 		= xPlayer.identifier
-- 	local currenthouse      = MySQL.Sync.fetchAll('SELECT * FROM houses WHERE name = @name', {['@name'] = house})

-- 	if currenthouse[1].closet == nil then
-- 		MySQL.Async.execute('UPDATE houses SET closet = @closet WHERE name = @name',{['@closet'] = json.encode(playerpos), ['@name'] = house })
-- 		TriggerClientEvent('tb-houses:client:sendAlert', src, 'success', 'Closet succesvol geplaatst')
-- 		TriggerClientEvent('tb-houses:client:setClosetStash', src)
-- 	else
-- 		TriggerClientEvent('tb-houses:client:sendAlert', src, 'error', 'Je hebt al een closet')
-- 	end
-- end)

-- RegisterNetEvent('tb-houses:server:removeStash')
-- AddEventHandler('tb-houses:server:removeStash', function(house)
-- 	local src        		= source
-- 	local xPlayer    		= ESX.GetPlayerFromId(src)
-- 	local identifier 		= xPlayer.identifier
-- 	local currenthouse      = MySQL.Sync.fetchAll('SELECT * FROM houses WHERE name = @name', {['@name'] = house})

-- 	if currenthouse[1].stash ~= nil then
-- 		MySQL.Async.execute('UPDATE houses SET stash = @stash WHERE name = @name',{['@stash'] = nil, ['@name'] = house })
-- 		TriggerClientEvent('tb-houses:client:sendAlert', src, 'success', 'Stash succesvol verwijderd')
-- 		TriggerClientEvent('tb-houses:client:setClosetStash', src)
-- 	else
-- 		TriggerClientEvent('tb-houses:client:sendAlert', src, 'error', 'Je hebt nog geen stash geplaatst')
-- 	end
-- end)

-- RegisterNetEvent('tb-houses:server:removeCloset')
-- AddEventHandler('tb-houses:server:removeCloset', function(house)
-- 	local src        		= source
-- 	local xPlayer    		= ESX.GetPlayerFromId(src)
-- 	local identifier 		= xPlayer.identifier
-- 	local currenthouse      = MySQL.Sync.fetchAll('SELECT * FROM houses WHERE name = @name', {['@name'] = house})

-- 	if currenthouse[1].closet ~= nil then
-- 		MySQL.Async.execute('UPDATE houses SET closet = @closet WHERE name = @name',{['@closet'] = nil, ['@name'] = house })
-- 		TriggerClientEvent('tb-houses:client:sendAlert', src, 'success', 'Closet succesvol verwijderd')
-- 		TriggerClientEvent('tb-houses:client:setClosetStash', src)
-- 	else
-- 		TriggerClientEvent('tb-houses:client:sendAlert', src, 'error', 'Je hebt nog geen closet geplaatst')
-- 	end
-- end)