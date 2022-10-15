resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'TBCore UI'
version '1.0'

ui_page 'html/index.html'

client_scripts {
	'client/main.lua'
}

server_scripts {
	'server/main.lua'
}

files {
	'html/index.html',
	'html/index.js',
	'html/style.css',
	'html/pdown.ttf'
}