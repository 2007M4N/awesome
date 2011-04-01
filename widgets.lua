widgets = {}

-- {{{ Wibox WIDGETS

-- Network usage widget
--Initialize widget
netwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(netwidget, vicious.widgets.net, '<span color="#CC9393">${wlan0 down_kb}</span> <span color="#7F9F7F">${wlan0 up_kb}</span>', 3)

-- Memory widget
memwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(memwidget, vicious.widgets.mem, '<span color="#00FF00">Mem=></span><span color="#FF0000">$1%</span>', 13)

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
vicious.register(cpuwidget, vicious.widgets.cpu, '<span color="#00FF00">CPU=></span><span color="#FF0000">$1%</span>')

--Seperators Widget
seperator = widget({ type = "textbox" })
 seperator.text = " :: "

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
seperator,
memwidget,
seperator,
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}
return widgets
