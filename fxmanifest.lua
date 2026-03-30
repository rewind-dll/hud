fx_version 'cerulean'
game 'gta5'
author 'rewind.dll'

ui_page 'web/dist/index.html'
files { 'web/dist/**/*' }

dependencies {
    'pma-voice'
}

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/nui.lua',
    'client/main.lua',
    'client/status.lua',
    'client/weapon.lua',
    'client/vehicle.lua'
}

server_scripts {
    'server/hud_framework.lua',
    'server/main.lua'
}
