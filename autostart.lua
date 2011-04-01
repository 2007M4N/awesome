-- {{{ Autostart

autostart = {}
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
-- }}}
return autostart
