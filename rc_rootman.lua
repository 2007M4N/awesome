----------------------------------------------
-- awesome.lua - main config of my window manager
-- version: v3.4.3 (Engines)
-- D-Bus support: x
-- os: ubuntu server x68_64
-- cpu: Intel Pentium Dual Merom CPU T7200 2.00GHz
-- grapic: Intel Graphics Media Accelerator 950
-- screen: 1400x1040
----------------------------------------------
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("vicious")
-- Load Debian menu entries
require("debian.menu")
-- Load Xcompmgr
-- awful.util.spawn_with_shell("xcompmgr -cF &")

   -- {{{ Variable definitions
   -- Themes define colours, icons, and wallpapers
--only disabled wallpaper
 beautiful.init("/usr/share/awesome/themes/default/theme.lua")
-- This is used later as the default terminal and editor to run.
 terminal = "xterm -bg black -fg green"
editor = os.getenv("EDITOR") or "-e gvim"
editor_cmd = terminal .. " -e vim " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.horizontal,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.tile.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
 tags = {
   names  = { "main", "www", "sec", "htc", "system", "vm", "vm-dev", "mail", "im" },
   layout = { layouts[3], layouts[4], layouts[2], layouts[2], layouts[3],
              layouts[3], layouts[3], layouts[4], layouts[3]
 }}
 for s = 1, screen.count() do
     -- Each screen has its own tag table.
     tags[s] = awful.tag(tags.names, s, tags.layout)
 end
 -- }}}

-- {{{ Menu

myshutdownmenu = { 
	{ "Shutdown", "gksudo halt" },
	{ "Reboot", "gksudo reboot" },
	{ "LockScreen", "slock" },
	{ "Screensaver", "xscreensaver-command -lock" },
	{ "Susbend", "gksudo acpitool -s" }
}
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
  { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "Debian", debian.menu.Debian_menu.Debian },
                                    { "open terminal", terminal },
				    { "shutdown", myshutdownmenu }
                                  }
                        })


mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox WIDGETS

-- Network usage widget
--Initialize widget
netwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(netwidget, vicious.widgets.net, '<span color="#CC9393">${wlan0 down_kb}</span> <span color="#7F9F7F">${wlan0 up_kb}</span>', 3)

-- Memory widget
memwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(memwidget, vicious.widgets.mem, '<span color="#ff9933">{$1% ($2MB/$3MB)}</span>', 13)

-- { Acpitool-based battery widget
mybattmon = widget({ type = "textbox", name = "mybattmon", align = "right" })
function battery_status ()
    local output={} --output buffer
    local fd=io.popen("acpitool -b", "r") --list present batteries
    local line=fd:read()
    while line do --there might be several batteries.
        local battery_num = string.match(line, "Battery \#(%d+)")
        local battery_load = string.match(line, " (%d*\.%d+)%%")
        local time_rem = string.match(line, "(%d+\:%d+)\:%d+")
	local discharging
	if string.match(line, "discharging")=="discharging" then --discharging: always red
		discharging="<span color=\"#CC7777\">"
	elseif tonumber(battery_load)>85 then --almost charged
		discharging="<span color=\"#77CC77\">"
	else --charging
		discharging="<span color=\"#CCCC77\">"
	end
        if battery_num and battery_load and time_rem then
            table.insert(output,discharging.."BAT#"..battery_num.." "..battery_load.."%% "..time_rem.."</span>")
        elseif battery_num and battery_load then --remaining time unavailable
            table.insert(output,discharging.."BAT#"..battery_num.." "..battery_load.."%%</span>")
        end --even more data unavailable: we might be getting an unexpected output format, so let's just skip this line.
        line=fd:read() --read next line
    end
    return table.concat(output," ") 
-- FIXME: better separation for several batteries. maybe a pipe?
end
mybattmon.text = " " .. battery_status() .. " "
my_battmon_timer=timer({timeout=30})
my_battmon_timer:add_signal("timeout", function()
    --mytextbox.text = " " .. os.date() .. " "
    mybattmon.text = " " .. battery_status() .. " "
end)
my_battmon_timer:start()
-- } end acpitool battery widget

--graphical CPU Widget
-- Initialize widget
-- cpuwidget = awful.widget.graph()
-- Graph properties
-- cpuwidget:set_width(50)
-- cpuwidget:set_background_color("#494B4F")
-- cpuwidget:set_color("#FF5656")
-- cpuwidget:set_gradient_colors({ "#FF5656", "#88A175", "#AECF96" })

-- text CPU Widget
cpuwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(cpuwidget, vicious.widgets.cpu, '<span color="#ff0000">{$1%}</span>')

--Seperators Widget
seperator = widget({ type = "textbox" })
 seperator.text  = " :: "

--Text clock widget
mytextclock = awful.widget.textclock({ align = "right" })

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        mytextclock,
	mybattmon,
	seperator,
	netwidget,
	seperator,
	cpuwidget,
	memwidget,
	seperator,
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ "Mod4", "Control" },"l", 
	function ()
		awful.util.spawn("xscrrensaver-command -lock") 
	end),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show(true)        end),

-- Xscreensaver lock
	awful.key({ modkey, "Control" }, "l", 
		function () awful.util.spawn("xscreensaver-command -lock") 
	end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)

-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
  { rule = { class = "Evolution" },
          properties = { tag = tags[1][8] } },
  { rule = { class = "Pidgin" },
          properties = { tag = tags[1][9] } },
  { rule = { class = "Firefox" },
          properties = { tag = tags[1][2] } },
        -- spezial rules for Transparency 
  { rule = {class = "XTerm"},
        proberties = {opacity = 0.7} },

  {rule = {class = "Mplayer"},
         properties = {opacity = 1} },

}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)


        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)
-- Added transperency
 client.add_signal("focus", function(c) c.border_color = beautiful.border_focus c.opacity = 1.0 end)
 client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal c.opacity = 0.7 end)
-- }}}


-- {{{ Autostart

-- Run Once Funktion
function run_once(prg,arg_string,screen)
    if not prg then
        do return nil end
    end
    if not arg_string then 
        awful.util.spawn_with_shell("pgrep -f -u $USER -x " .. prg .. " || (" .. prg .. ")",screen)
    else
        awful.util.spawn_with_shell("pgrep -f -u $USER -x " .. prg .. " || (" .. prg .. " " .. arg_string .. ")",screen)
    end
end
-- FUNCTION ENDE
-- wich Programms should be started
run_once("xscreensaver","-no-splash")
run_once("pidgin",nil,1)
run_once("firefox-bin")
run_once("evolution")
run_once("blueman-applet")
run_once("nm-applet")
run_once("keepassx")
run_once("/usr/bin/perl /usr/bin/shutter","--min_at_startup",nil,1)
-- }}}

--{{{ Screensaver

-- Random effect
--  seed and "pop a few"
 math.randomseed( os.time())
 for i=1,1000 do tmp=math.random(0,1000) end
 x = 0
-- Change Wallpaper randomly after time:
-- setup the timer
 mytimer = timer { timeout = x }
mytimer:add_signal("timeout", function()

--  -- tell awsetbg to randomly choose a wallpaper from your wallpaper directory
--   os.execute("awsetbg -f -R /usr/share/wallpapers/1280&")
	os.execute  ( "habak -hi /usr/share/wallpapers/1280" )

-- os.execute("awsetbg -f /usr/share/wallpapers/25_1280x1024.jpg")
  -- stop the timer (we don't need multiple instances running at the same time)
 mytimer:stop()
  -- define the interval in which the next wallpaper change should occur in seconds
  -- (in this case anytime between 10 and 20 minutes)
  x = math.random( 5, 20)

  --restart the timer
 mytimer.timeout = x
 mytimer:start()
end)
-- initial start when rc.lua is first run
mytimer:start()
--}}}
-- Standard awes in *.jpg; do convert $i -resize 1280x1024\! 1280/$i; done me library
