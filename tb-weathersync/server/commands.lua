TriggerEvent('tb-core:server:addGroupCommand', 'freeze', 'admin', function(source, args, user)
    if args[1]:lower() == 'weather' or args[1]:lower() == 'time' then
        FreezeElement(args[1])
    end
end, function(source, args, user)
	TBCore.Functions.addMessage('DANGER', source, 'SYSTEM', nil, 'You dont have enough permissions')
end, {help = "Set a player's usergroup"})

TriggerEvent('tb-core:server:addGroupCommand', 'weather', 'admin', function(source, args, user)
    for _, v in pairs(AvailableWeatherTypes) do
        if args[1]:upper() == v then
            SetWeather(args[1])
            return
        end
    end
end, function(source, args, user)
	TBCore.Functions.addMessage('DANGER', source, 'SYSTEM', nil, 'You dont have enough permissions')
end, {help = "Set a player's usergroup"})

TriggerEvent('tb-core:server:addGroupCommand', 'time', 'admin', function(source, args, user)
    for _, v in pairs(AvailableTimeTypes) do
        if args[1]:upper() == v then
            SetTime(args[1])
            return
        end
    end
end, function(source, args, user)
	TBCore.Functions.addMessage('DANGER', source, 'SYSTEM', nil, 'You dont have enough permissions')
end, {help = "Set a player's usergroup"})

TriggerEvent('tb-core:server:addGroupCommand', 'clock', 'admin', function(source, args, user)
    if tonumber(args[1]) ~= nil and tonumber(args[2]) ~= nil then
        SetExactTime(args[1], args[2])
    end
end, function(source, args, user)
	TBCore.Functions.addMessage('DANGER', source, 'SYSTEM', nil, 'You dont have enough permissions')
end, {help = "Set a player's usergroup"})
    
TriggerEvent('tb-core:server:addGroupCommand', 'blackout', 'admin', function(source, args, user)
    ToggleBlackout()
end, function(source, args, user)
	TBCore.Functions.addMessage('DANGER', source, 'SYSTEM', nil, 'You dont have enough permissions')
end, {help = "Set a player's usergroup"})