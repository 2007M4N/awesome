----------------------------------------------
-- awesome.lua - main config of my window manager
-- version: v3.4.9 (Smack)
-- Build: Mar 26 2011 21:52:27 for x86_64 by gcc version 4.5.2 (rootman@ivirtualkitchen)
-- D-Bus support: x
-- os: Arch Linux 2.6.37-ARCH  x68_64
-- cpu: Intel Pentium Dual Merom CPU T7200 2.00GHz
-- grapic: Intel Graphics Media Accelerator 950
-- screen: 1400x1040
----------------------------------------------
-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
-- Notification libary
require ("vicious")

--{{{ Autostart Daemons
--}}}
--
-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/home/rootman/.config/awesome/themes/rootman/theme.lua")
-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "e- gvim"
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
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}
--{{{ dot Files
tags = dofile(awful.util.getdir("config").."/tags.lua")
menu = dofile(awful.util.getdir("config").."/menu.lua")
widgets = dofile(awful.util.getdir("config").."/widgets.lua")
bindings = dofile(awful.util.getdir("config").."/bindings.lua")
rules = dofile(awful.util.getdir("config").."/rules.lua")
autostart = dofile(awful.util.getdir("config").."/autostart.lua")
--wallpaper = dofile(awful.util.getdir("config").."/wallpaper.lua")
signals = dofile(awful.util.getdir("config").."/signals.lua")
--}}}
