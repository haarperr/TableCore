resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'TBCore Menu'

ui_page 'html/ui.html'

client_script { 
    'client/main.lua',
}

exports {
    'CreateMenu',
    'DestroyMenus',
    'RefreshMenu',
    'AddButton',
    'AddAdvancedButton',
    'AddStoreButton',
    'AddCheckButton',
    'AddSlider',
    'AddSubMenu',
    'AddSubMenuBack',
    'OpenMenu',
}

files {
    'html/ui.html',
    'html/css/style.css',
    'html/js/app.js',

    'html/libs/bootstrap.min.css',
    'html/libs/all.min.css',
    'html/libs/jquery.min.js',
    'html/libs/all.min.js',
}

dependencies {
	'tb-core'
}