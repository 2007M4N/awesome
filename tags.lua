tags = {}
-- {{{ Tags
-- Define a tag table which hold all screen tags.
 tags = {
   names = { "main", "www", "sec", "htc", "system", "vm", "vm-dev", "mail", "im" },
   layout = { layouts[3], layouts[4], layouts[2], layouts[2], layouts[3],
              layouts[3], layouts[3], layouts[4], layouts[3]
 }}
 for s = 1, screen.count() do
     -- Each screen has its own tag table.
     tags[s] = awful.tag(tags.names, s, tags.layout)
 end
-- }}}
return tags
