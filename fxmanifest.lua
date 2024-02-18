fx_version 'cerulean'
game 'gta5'
use_experimental_fxv2_oal 'yes'
lua54 'yes'

author 'devyn'

ui_page 'html/index.html'

files {
    -- UI
	'html/**',
    
    -- CONFIG
    'config/client.lua',
    'config/server.lua',
	'config/shared.lua',

    -- GROUP4

    -- [server]
    'server/util.lua',
    'server/blips.lua',
    'server/task.lua',

    -- [client]
    'client/util.lua',
    'client/blips.lua',
    'client/task.lua',
}

shared_scripts {
    '@ox_lib/init.lua',
}

client_scripts {
    'client/main.lua',
    'client/group.lua',
    'client/reputation.lua',
    'client/util.lua',
    'client/task.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/group.lua',
    'server/reputation.lua',
    'server/util.lua',
    'server/task.lua',
}