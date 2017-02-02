
mykiller = wibox.widget.imagebox()
mykiller:set_image(beautiful.net_down)
mykiller:buttons(awful.util.table.join(awful.button({ }, 1, function ()
	c = client.focus
	if c then
		c:kill()
	end
end
)))

