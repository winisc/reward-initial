
fx_version "bodacious"
author 'Wini and Leo'
game "gta5"

ui_page "web-side/index.html"

client_scripts {
	"@vrp/lib/utils.lua",
	"client-side/*"
}

server_scripts {
	"@vrp/lib/itemlist.lua",
	"@vrp/lib/utils.lua",
	"server-side/*"
}

files {
	"web-side/*",
	'web-side/**/*'
}