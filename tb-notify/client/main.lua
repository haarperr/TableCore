RegisterNetEvent('tb-notify:client:SendAlert')
AddEventHandler('tb-notify:client:SendAlert', function(data)
	Notification(data.type, data.text, data.length, data.style)
end)

function Notification(type, text, length, style)
	SendNUIMessage({
		type = type,
		text = text,
		length = length,
		style = style
	})
end
