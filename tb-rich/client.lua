Citizen.CreateThread(function()
	while true do
        --This is the Application ID (Replace this with you own)
		SetDiscordAppId(123456788967867867)

        --Here you will have to put the image name for the "large" icon.
		SetDiscordRichPresenceAsset('logo')
        
        --(11-11-2018) New Natives:

        --Here you can add hover text for the "large" icon.
        SetDiscordRichPresenceAssetText('TBCore - invite.gg/tbcore')
       
        --Here you will have to put the image name for the "small" icon.
        SetDiscordRichPresenceAssetSmall('logo_name')

        --Here you can add hover text for the "small" icon.
        SetDiscordRichPresenceAssetSmallText('TBCore is a Custom Framework')

        --It updates every one minute just in case.
		Citizen.Wait(60000)
	end
end)