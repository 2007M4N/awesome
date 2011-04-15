wallpaper = {}
--{{{ Screensaver

-- Random effect
-- seed and "pop a few"
 math.randomseed( os.time())
 for i=1,1000 do tmp=math.random(0,1000) end
 x = 0

-- Change Wallpaper randomly after time:
-- setup the timer
 mytimer = timer { timeout = x }
mytimer:add_signal("timeout", function()

-- -- tell awsetbg to randomly choose a wallpaper from your wallpaper directory
 os.execute("awsetbg -f -R /usr/share/wallpapers/1280&", "awsetbg -f -R /usr/share/wallpapers/1280&" )
--theme.wallpaper_cmd = { "awsetbg /usr/share/awesome/themes/default/background.png",
--			"awsetbg /usr/share/awesome/themes/default/background.png" }
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

return wallpaper
