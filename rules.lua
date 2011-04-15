rules = {}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
		     maximized_vertical   = false,
		     maximized_horizontal = false,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "Keepassx" },
      properties = { floating = true } },
    { rule = { class = "Proxmark3" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
  { rule = { class = "Evolution" },
          properties = { tag = tags[1][8] } },
  { rule = { class = "Pidgin" },
          properties = { tag = tags[1][9] } },
  { rule = { class = "XTerm" },
          properties = { tag = tags[1][3] } },
--  { rule = { class = "Namoroka" },
 --         properties = { tag = tags[1][2] } },
        -- spezial rules for Transparency
 -- { rule = {class = "XTerm"},
   --     proberties = {opacity = 0.7} },

 -- {rule = {class = "Mplayer"},
   --      properties = {opacity = 1} },
	-- Controll Titlebars
	{ rule = { class = "Gimp" },
		callback = awful.titlebar.add },
	{ rule = { class = "Keepassx" },
		callback = awful.titlebar.add },
}
-- }}}
return rules
