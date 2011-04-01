menu = {}

-- {{{ Menu
myartmenu = {
{ "GIMP", "gimp" },
{ "Geeqie (Pictures)", "geeqie" },
{ "Gvim", "gvim" }
}

mycomm = {
{ "Firefox", "firefox" },
{ "Evolution", "evolution" },
{ "Pidgin", "pidgin" },
{ "QBittorrent", "qbittorrent" },
}

mymedia = {
{ "DeaDBeaF (Music)", "deadbeef" },
{ "VLC", "vlc" },
{ "NVLC", "nvlc" }
}

mygames = {
	{ "XMahjongg", "xmahjongg" },
	{ "Frozen-Bubble", "frozen-bubble" },
	{ "XMoto", "xmoto" },
	{ "Supertux", "supertux" }
}

mysystem = {
{ "Midnight Commander", terminal .. " -e mc" },
{ "Qalculate", "qalculate" },
{ "PcmanFM", "pcmanfm" },
{ "FileZilla", "filezilla" },
{ "Alsa Mixer", terminal .. "-e alsamixer"},
{ "LUA", "lua" },
{ "Linguist", "linguist" },
{ "CHEESE", "cheese" },
{ "Terminal", terminal }
}



myshutdownmenu = {
{ "Shutdown", "gksudo halt" },
{ "Reboot", "gksudo reboot" },
{ "LockScreen", "slock" },
{ "Screensaver", "xscreensaver-command -lock" },
{ "Susbend", "gksudo pm-suspend" },
{ "restart Awesome", awesome.restart },
{ "quiti Awesome", awesome.quit }
}
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
  { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "Media", mymedia },
      				    { "Art", myartmenu },
     				    { "Communication", mycomm },
   			            { "Games", mygames },
       				    { "SYSTEM", mysystem },
				    { "open terminal", terminal },
				    { "shutdown", myshutdownmenu }
                                  }
                        })


mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

return menu
