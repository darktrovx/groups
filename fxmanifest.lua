fx_version 'cerulean'
game 'gta5'
use_experimental_fxv2_oal 'yes'
lua54 'yes'

author 'devyn'

-- Manifest
ui_page 'html/index.html'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/*.lua',
}

client_scripts {
    'client/main.lua',
    'client/*.lua',
}

server_scripts {
    'server/main.lua',
    'server/*.lua',
}

files {
	'html/**',
	'web/**',
}