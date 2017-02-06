-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
-- Alternative widget libraries
local vicious = require("vicious")
local fleet = require("fleet")
--local volume_control = require("volume-control")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({ preset = naughty.config.presets.critical,
	title = "Oops, there were errors during startup!",
	text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function (err)
		-- Make sure we don't go into an endless error loop
		if in_error then return end
		in_error = true

		naughty.notify({ preset = naughty.config.presets.critical,
		title = "Oops, an error happened!",
		text = tostring(err) })
		in_error = false
	end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(awful.util.get_themes_dir() .. "default/theme.lua")
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/fleet/theme.lua")

terminal = "urxvt" or "terminology" or "gnome-terminal" or "xterm"
editor = os.getenv("EDITOR") or "vim" or "vi" or "nano"

editor_cmd = terminal .. " -e " .. editor
lockscreen_cmd = "xlock -mode space"

filemanager = "nautilus" or "pcmanfm"
browser = "chromium" or "firefox" or "opera" or "surf" or "dwb" or "netsurf"
email = "xdg-email"

-- Default modkey.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
	awful.layout.suit.floating,
	awful.layout.suit.max,
	-- awful.layout.suit.max.fullscreen,
	awful.layout.suit.tile,
	awful.layout.suit.tile.left,
	awful.layout.suit.tile.top,
	awful.layout.suit.tile.bottom,
	-- awful.layout.suit.fair,
	-- awful.layout.suit.fair.horizontal,
	-- awful.layout.suit.spiral,
	-- awful.layout.suit.spiral.dwindle,
	-- awful.layout.suit.magnifier,
	-- awful.layout.suit.corner.nw,
	-- awful.layout.suit.corner.ne,
	-- awful.layout.suit.corner.sw,
	-- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ External library config
awful.titlebar.enable_tooltip = false
naughty.config.defaults.timeout = 0
naughty.config.presets.low.timeout = 4
-- }}}

-- {{{ Helper functions
_awesome_quit = awesome.quit
_awesome_restart = awesome.restart

awesome.quit = function()
	if os.getenv("XDG_CURRENT_DESKTOP") == "GNOME" then
		os.execute("/usr/bin/gnome-session-quit --logout --no-prompt")
	else
		_awesome_quit()
	end
end

awesome.restart = function()
	_awesome_restart()
end

function run_once ( cmd )
	findme = cmd
	firstspace = cmd:find(" ")

	if firstspace then
		findme = cmd:sub(0, firstspace - 1)
	end

	awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

local function client_menu_toggle_fn()
	local instance = nil

	return function ()
		if instance and instance.wibox.visible then
			instance:hide()
			instance = nil
		else
			instance = awful.menu.clients({ theme = { width = 250 } })
		end
	end
end

local function set_wallpaper(s)
	-- Wallpaper
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end

function get_clientbuttons ( c, s )
	local clientbuttons_layout = wibox.layout.fixed.horizontal()
	local clientname_layout = wibox.layout.constraint()
	local myclienticon = nil
	local myclientname = wibox.widget.textbox()
	local button_float = nil
	local button_maximize = nil
	local button_sticky = nil
	local button_ontop = nil
	local button_close = nil

	if c and s and s == c.screen then
		if ( c.name ) then
			myclientname = awful.titlebar.widget.titlewidget(c)
		elseif ( c.class ) then
			myclientname:set_text(c.class)
		else
			myclientname:set_markup("<i>&lt;application&gt;</i>")
		end

		myclientname:set_align("right")
		myclientname:set_ellipsize("middle")
		myclientname:set_wrap("WORD")

		myclientname:buttons(awful.util.table.join(
		awful.button({ }, 1, function ()
			--[[
			if c == client.focus then
				c.minimized = true
			else
				c.minimized = false
				if not c:isvisible() then
					awful.tag.viewonly(c:tags()[1])
				end
				client.focus = c
				c:raise()
			end
			--]]
		end),
		awful.button({ }, 3, function ()
			if instance then
				instance:hide()
				instance = nil
			else
				instance = awful.menu.clients({ width=300 })
			end
		end)
		))

		clientbuttons_layout:buttons(awful.util.table.join(
			awful.button({ }, 4, function ()
				awful.client.focus.byidx(1)
				if client.focus then client.focus:raise() end
			end),
			awful.button({ }, 5, function ()
				awful.client.focus.byidx(-1)
				if client.focus then client.focus:raise() end
			end)
		))

		if ( c.icon ) then
			myclienticon = awful.titlebar.widget.iconwidget(c)
		else
			myclienticon = wibox.widget.imagebox()
			myclienticon:set_image(beautiful.application_icon)
		end

		button_float = awful.titlebar.widget.floatingbutton(c)
		button_maximize = awful.titlebar.widget.maximizedbutton(c)
		button_sticky = awful.titlebar.widget.stickybutton(c)
		button_ontop = awful.titlebar.widget.ontopbutton(c)
		button_close = awful.titlebar.widget.closebutton(c)
	elseif s then
		myclientname:set_markup('<span foreground="red">~</span>')
		myclienticon = wibox.widget.imagebox()
		myclienticon:set_image(beautiful.application_icon)

		local nonebutton = wibox.widget.imagebox()
		nonebutton:set_image(beautiful.none_normal)

		button_float = nonebutton
		button_maximize = nonebutton
		button_sticky = nonebutton
		button_ontop = nonebutton
		button_close = nonebutton
	end

	if s then
		local clienticon_margin = wibox.layout.margin(myclienticon, 0, 0, 0, 0)
		local clienttitle_margin = wibox.layout.margin(myclientname, 0, 0, 2, 2)

		clientname_layout:set_strategy("max")
		clientname_layout:set_width(256)
		clientname_layout:set_widget(clienttitle_margin)

		clientbuttons_layout:add(spr_small_empty)
		clientbuttons_layout:add(clienticon_margin)
		clientbuttons_layout:add(spr_small_empty)
		clientbuttons_layout:add(clientname_layout)
		clientbuttons_layout:add(bar)
		clientbuttons_layout:add(button_float)
		clientbuttons_layout:add(spr_small_empty)
		clientbuttons_layout:add(button_maximize)
		clientbuttons_layout:add(spr_small_empty)
		clientbuttons_layout:add(button_sticky)
		clientbuttons_layout:add(spr_small_empty)
		clientbuttons_layout:add(button_ontop)
		clientbuttons_layout:add(bar)
		clientbuttons_layout:add(button_close)
	end

	return clientbuttons_layout
end
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
	{ "hotkeys", function() return false, hotkeys_popup.show_help end},
	{ "manual", terminal .. " -e man awesome" },
	{ "edit config", editor_cmd .. " " .. awesome.conffile }
}

mysysmenu = {
	{ "reboot", "systemctl reboot"},
	{ "poweroff", "systemctl poweroff"}
}

mywmmenu = {
	{ "toggle wibox", function () fleet.layout.toggle_wibox({awful.screen.focused().mywibox, awful.screen.focused().mybotwibox}) end },
	{ "toggle top wibox", function () fleet.layout.toggle_wibox({awful.screen.focused().mywibox}) end },
	{ "toggle bottom wibox", function () fleet.layout.toggle_wibox({awful.screen.focused().mybotwibox}) end },
	{ "change wallpaper", function () end },
	{ "lock screen", lockscreen_cmd },
}

mymainmenu = awful.menu({
	items = {
		{ "open terminal", terminal },
		{ "open editor", editor_cmd },
		{ "open files", filemanager },
		{ "open browser", browser },
		{ "send email", email },
		{ "layout", mywmmenu },
		{ "awesome", myawesomemenu, beautiful.awesome_icon },
	}
})

mysessionmenu = awful.menu({
	items = {
		{ "lock", lockscreen_cmd },
		{ "restart", function() awesome.restart() end },
		{ "quit", function() awesome.quit() end},
		{ "system", mysysmenu },
	}
})

myrootmenu = awful.menu({
	items = mywmmenu
})

mylauncher = awful.widget.launcher({
	image = beautiful.awesome_icon,
	menu = mymainmenu
})

mysesslauncher = awful.widget.launcher({
	image = beautiful.power_icon,
	menu = mysessionmenu
})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
menubar.geometry = { y = 0, height = 22 }
-- }}}

-- {{{ Wibar Widgets
-- Separators
spr_small_empty = wibox.widget.imagebox()
spr_small_empty:set_image(beautiful.spr_small_empty)

bar = wibox.widget.imagebox()
bar:set_image(beautiful.bar)

-- Keyboard map indicator and switcher
kbdcfg = fleet.widget.keyboardlayoutindicator(
	{
		{ name = "colemak", layout = "us", variant = "colemak", color = "#81B7E1" },
		{ name = "dvorak", layout = "us", variant = "dvorak", color = "#E18181" },
		{ name = "qwerty", layout = "us", variant = nil }
	},
	{
		{ name = "[1]", key = "Num_Lock", led = "Num Lock" },
		{ name = "[A]", key = "Caps_Lock", led = "Caps Lock" }
	},
	{
		section = bar,
		keys = spr_small_empty
	}
)

keyboardwidget = wibox.widget {
	{
		image = beautiful.keyboard,
		widget = wibox.widget.imagebox,
	},
	bar,
	kbdcfg,
	layout = wibox.layout.fixed.horizontal
}

-- Date
datewidget = wibox.widget {
	{
		image = beautiful.calendar,
		widget = wibox.widget.imagebox,
	},
	bar,
	{
		id = "date",
		widget = wibox.widget.textbox,
	},
	layout = wibox.layout.fixed.horizontal
}

vicious.register(datewidget.date, vicious.widgets.date, '%a, %b %d', 60)

-- time
timewidget = wibox.widget {
	{
		image = beautiful.clock,
		widget = wibox.widget.imagebox,
	},
	bar,
	{
		id = "time",
		widget = wibox.widget.textbox,
	},
	layout = wibox.layout.fixed.horizontal
}

vicious.register(timewidget.time, vicious.widgets.date, '%H:%M', 60)

-- Volume control
--volumecfg = volume_control({channel="Master"})

volumewidget = wibox.widget {
	{
		image = beautiful.mpd,
		widget = wibox.widget.imagebox,
	},
	bar,
	{
		id = "prog",
		max_value = 1,
		value = 0,
		forced_height = 20,
		forced_width = 100,
		paddings = 1,
		border_width = 1,
		margins = {
			top = 2,
			bottom = 2,
		},
		widget = wibox.widget.progressbar,
	},
	layout = wibox.layout.fixed.horizontal
}

vicious.register(volumewidget.prog, vicious.widgets.volume, function(widget, args)
	local color = { ["♫"] = "#81B7E1", ["♩"] = "#E18181" }

	widget.color = color[args[2]]

	return args[1]
end, 10, "Master")

-- CPU
cpuwidget = wibox.widget {
	{
		image = beautiful.cpu,
		widget = wibox.widget.imagebox,
	},
	bar,
	{
		id = "perc",
		markup = '<span color="#FFFFFF">**</span>',
		widget = wibox.widget.textbox,
	},
	layout = wibox.layout.fixed.horizontal
}

vicious.register(cpuwidget.perc, vicious.widgets.cpu, function (widget, args)
	local color = '#8AE181'
	local perc = tostring(args[1])

	if args[1] < 10 then
		perc = '0'..tostring(args[1])
	elseif args[1] > 70 then
		color = '#E18181'
	elseif args[1] > 40 then
		color = '#E1C381'
	end

	return '<span color="'..color..'">'..perc..'</span> %'
end, 1)

-- Memory
memwidget = wibox.widget {
	{
		image = beautiful.mem,
		widget = wibox.widget.imagebox,
	},
	bar,
	{
		id = "usage",
		markup = '<span color="#FFFFFF">**</span>',
		widget = wibox.widget.textbox,
	},
	layout = wibox.layout.fixed.horizontal
}

vicious.register(memwidget.usage, vicious.widgets.mem, function (widget, args)
	local color = '#8AE181'
	local usage = 0
	local metric = 'B'
	local used = ''

	if args[1] > 70 then
		color = '#E18181'
	elseif args[1] > 40 then
		color = '#E1C381'
	end

	if args[9] > 999999 then
		usage = args[9] / 1048576
		metric = 'TB'
	elseif args[9] > 999 then
		usage = args[9] / 1024
		metric = 'GB'
	else
		usage = args[9]
		metric = 'MB'
	end

	if usage > 99.9 then
		used = tostring(math.ceil(usage))..'.'
	elseif usage > 9.99 then
		used = string.format("%.1f", usage)
	else
		used = string.format("%.2f", usage)
	end

	return '<span color="'..color..'">'..used..'</span> '..metric
end, 2)

-- Disk IO
diowidget = wibox.widget {
	{
		image = beautiful.hdd,
		widget = wibox.widget.imagebox,
	},
	bar,
	{
		id = "disk",
		markup = '<span color="#FFFFFF"></span>',
		widget = wibox.widget.textbox,
	},
	bar,
	{
		id = "reads",
		markup = '<span color="#FFFFFF">0.00</span>',
		widget = wibox.widget.textbox,
	},
	bar,
	{
		id = "writes",
		markup = '<span color="#FFFFFF">0.00</span>',
		widget = wibox.widget.textbox,
	},
	layout = wibox.layout.fixed.horizontal
}

vicious.register(diowidget, vicious.widgets.dio, function (widget, args)
	local dev = 'sda'
	local d_c = '#777777'
	local r_s = 0
	local w_s = 0
	local r_m = 'B'
	local w_m = 'B'
	local r_c = '#8AE181'
	local w_c = '#8AE181'
	local reads = '0.00'
	local writes = '0.00'
	local r_kb = tonumber(args['{'..dev..' read_kb}'])
	local w_kb = tonumber(args['{'..dev..' write_kb}'])

	if r_kb > 999999999 then
		r_s = r_kb / 1073741824
		r_m = 'TB'
	elseif r_kb > 999999 then
		r_s = r_kb / 1048576
		r_m = 'GB'
	elseif r_kb > 999 then
		r_s = r_kb / 1024
		r_m = 'MB'
	else
		r_s = r_kb
		r_m = 'KB'
	end

	if r_s > 99.9 then
		reads = tostring(math.ceil(r_s))..'.'
	elseif r_s > 9.99 then
		reads = string.format("%.1f", r_s)
	else
		reads = string.format("%.2f", r_s)
	end

	if w_kb > 10240 then
		w_c = '#E18181'
	elseif w_kb > 5120 then
		w_c = '#E1C381'
	end

	if w_kb > 999999999 then
		w_s = w_kb / 1073741824
		w_m = 'TB'
	elseif w_kb > 999999 then
		w_s = w_kb / 1048576
		w_m = 'GB'
	elseif w_kb > 999 then
		w_s = w_kb / 1024
		w_m = 'MB'
	else
		w_s = w_kb
		w_m = 'KB'
	end

	if w_s > 99.9 then
		writes = tostring(math.ceil(w_s))..'.'
	elseif w_s > 9.99 then
		writes = string.format('%.1f', w_s)
	else
		writes = string.format('%.2f', w_s)
	end

	if w_kb > 10240 then
		w_c = '#E18181'
	elseif w_kb > 5120 then
		w_c = '#E1C381'
	end

	if r_kb > 1 or w_kb > 1 then
		d_c = '#FFFFFF'
	end

	widget.disk:set_markup('<span color="'..d_c..'">'..dev..'</span>')
	widget.reads:set_markup('<span color="'..r_c..'">'..reads..'</span> '..r_m..'s')
	widget.writes:set_markup('<span color="'..w_c..'">'..writes..'</span> '..w_m..'s')
	return
end, 1)

-- Taglist
local taglist_buttons = awful.util.table.join(
	awful.button({ }, 1, function(t) t:view_only() end),
	awful.button({ modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({ }, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
	awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

-- Tasklist
local tasklist_buttons = awful.util.table.join(
	awful.button({ }, 1, function (c)
		if c == client.focus then
			c.minimized = true
		else
			-- Without this, the following
			-- :isvisible() makes no sense
			c.minimized = false
			if not c:isvisible() and c.first_tag then
				c.first_tag:view_only()
			end
			-- This will also un-minimize
			-- the client, if needed
			client.focus = c
			c:raise()
		end
	end),
	awful.button({ }, 3, client_menu_toggle_fn()),
	awful.button({ }, 4, function ()
		awful.client.focus.byidx(1)
	end),
	awful.button({ }, 5, function ()
		awful.client.focus.byidx(-1)
	end)
)
-- }}}

-- {{{ Wibar
-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s)
	-- Wallpaper
	set_wallpaper(s)

	-- Each screen has its own tag table.
	awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()

	-- Create an imagebox widget which will contains an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)

	s.mylayoutbox:buttons(awful.util.table.join(
	awful.button({ }, 1, function () awful.layout.inc( 1) end),
	awful.button({ }, 3, function () awful.layout.inc(-1) end),
	awful.button({ }, 4, function () awful.layout.inc( 1) end),
	awful.button({ }, 5, function () awful.layout.inc(-1) end)))

	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons, {spacing = 4})

	-- Create a tasklist widget
	s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons, {align = "right"})

	-- Create the wibox
	s.mywibox = awful.wibar({ position = "top", height = 22, ontop = true, screen = s })

	-- Add widgets to the wibox
	s.mywibox:setup {
		layout = wibox.layout.align.horizontal,
		{ -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			wibox.container.margin(s.mytaglist, 1, 1, 2, 2),
			wibox.container.margin(s.mylayoutbox, 2, 2, 2, 2),
			s.mypromptbox,
		},
		s.mytasklist, -- Middle widget
		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			wibox.container.margin(get_clientbuttons(nil, s), 4, 4, 2, 2),
		},
	}

	if 1 == s.index then
		-- Create the bottom wibox
		s.mybotwibox = awful.wibar({ position = "bottom", height = 32, ontop = true, bg = "transparent", screen = s })

		s.mybotwibox:setup {
			layout = wibox.layout.align.horizontal,
			{ -- Left widgets
				layout = wibox.layout.fixed.horizontal,
				wibox.container.margin(wibox.container.background(wibox.container.margin(mylauncher, 5, 5, 2, 2), "#333333"), 2, 2, 5, 5),
				wibox.container.margin(wibox.container.background(wibox.container.margin(mysesslauncher, 5, 5, 2, 2), "#333333"), 2, 2, 5, 5),
				wibox.container.margin(wibox.container.background(wibox.container.margin(keyboardwidget, 5, 5, 2, 2), "#333333"), 2, 2, 5, 5),
				wibox.container.margin(wibox.container.background(wibox.container.margin(volumewidget, 5, 5, 2, 2), "#333333"), 2, 2, 5, 5),
				wibox.container.margin(wibox.container.background(wibox.container.margin(wibox.widget.systray(), 5, 5, 0, 0), "#000000"), 2, 2, 5, 5),
			},
			{ -- Middle widgets
				layout = wibox.layout.fixed.horizontal,
			},
			{ -- Right widgets
				layout = wibox.layout.fixed.horizontal,
				wibox.container.margin(wibox.container.background(wibox.container.margin(cpuwidget, 5, 5, 2, 2), "#333333"), 2, 2, 5, 5),
				wibox.container.margin(wibox.container.background(wibox.container.margin(memwidget, 5, 5, 2, 2), "#333333"), 2, 2, 5, 5),
				wibox.container.margin(wibox.container.background(wibox.container.margin(diowidget, 5, 5, 2, 2), "#333333"), 2, 2, 5, 5),
				wibox.container.margin(wibox.container.background(wibox.container.margin(datewidget, 5, 5, 2, 2), "#333333"), 2, 2, 5, 5),
				wibox.container.margin(wibox.container.background(wibox.container.margin(timewidget, 5, 5, 2, 2), "#333333"), 2, 2, 5, 5),
			},
		}
	end
end)
-- }}}

-- {{{ Root mouse bindings
root.buttons(awful.util.table.join(
	awful.button({ }, 3, function () myrootmenu:toggle() end)
))
-- }}}

-- {{{ Client mouse bindings
clientbuttons = awful.util.table.join(
	awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
	awful.button({ modkey }, 1, awful.mouse.client.move),
	awful.button({ modkey }, 3, awful.mouse.client.resize)
)
-- }}}

-- {{{ Global key bindings
globalkeys = awful.util.table.join(
	awful.key({ modkey }, "F2", function ()
		currScreen = awful.screen.focused().index or 1
		currTag = awful.tag.getidx(awful.tag.selected())
		currText = awful.tag.selected().name:gsub("^%s*(.-)%s*$", "%1")
		currText = currText:gsub('%[' .. currTag .. '%]', '')
		currText = currText:gsub("^%s*(.-)%s*$", "%1")

		local dprompt = io.popen("echo "..currText.." | dmenu -m "..(currScreen - 1).." -fn 'Source Code Pro-14' -nb '#333333' -nf '#cccccc' -sb '#285577' -sf '#ffffff' -p 'Tag Name'", "r")
		local dpromptOut = dprompt:read("*a"):gsub("^%s*(.-)%s*$", "%1")
		dprompt:close()

		if string.len(dpromptOut) == 0 then
			tagName = ''.. currTag ..''
			awful.tag.selected().name = tagName
		else
			tagName = '[' .. currTag .. '] ' .. dpromptOut .. ''
			awful.tag.selected().name = tagName
		end
	end, {description = "Rename current tag", group = "tag"}),

	-- Screen browsing
	awful.key({ modkey }, "h", function () awful.screen.focus_bydirection("left") end,
	{description = "focus screen to left", group = "screen"}),

	awful.key({ modkey }, "n", function () awful.screen.focus_bydirection("down") end,
	{description = "focus screen down", group = "screen"}),

	awful.key({ modkey }, "e", function () awful.screen.focus_bydirection("up") end,
	{description = "focus screen up", group = "screen"}),

	awful.key({ modkey }, "i", function () awful.screen.focus_bydirection("right") end,
	{description = "focus screen to right", group = "screen"}),

	-- Tag browsing
	awful.key({ modkey }, "Left", awful.tag.viewprev,
	{description = "view previous", group = "tag"}),

	awful.key({ modkey }, "Right", awful.tag.viewnext,
	{description = "view next", group = "tag"}),

	awful.key({ modkey }, "Escape", awful.tag.history.restore,
	{description = "go back", group = "tag"}),

	awful.key({ modkey, "Shift" }, ",", awful.tag.viewprev,
	{description = "view previous", group = "tag"}),

	awful.key({ modkey, "Shift" }, ".", awful.tag.viewnext,
	{description = "view next", group = "tag"}),

	awful.key({ modkey }, ",", fleet.tag.viewprev_with_clients,
	{description = "view previous with clients", group = "tag"}),

	awful.key({ modkey }, ".", fleet.tag.viewnext_with_clients,
	{description = "view next with clients", group = "tag"}),

	-- Client browsing
	awful.key({ modkey }, "Tab", function () awful.client.focus.byidx(1) end,
	{description = "focus previous", group = "client"}),

	awful.key({ modkey, "Shift" }, "Tab", function () awful.client.focus.byidx(-1) end,
	{description = "focus next", group = "client"}),

	awful.key({ modkey }, "u", awful.client.urgent.jumpto,
	{description = "jump to urgent client", group = "client"}),

	-- Layout manipulation
	awful.key({ modkey }, "space", function () awful.layout.inc(1) end,
	{description = "select next", group = "layout"}),

	awful.key({ modkey, "Shift" }, "space", function () awful.layout.inc(-1) end,
	{description = "select previous", group = "layout"}),

	awful.key({ modkey }, "equal", function () awful.tag.incgap(1) end,
	{description = "increase useless gap", group = "layout"}),

	awful.key({ modkey }, "minus", function () awful.tag.incgap(-1) end,
	{description = "decrease useless gap", group = "layout"}),

	awful.key({ modkey }, "l", function () awful.tag.incmwfact(0.05) end,
	{description = "increase master width factor", group = "layout"}),

	awful.key({ modkey, "Control" }, "l", function () awful.tag.incncol(-1, nil, true) end,
	{description = "decrease the number of columns", group = "layout"}),

	--[[
	awful.key({ modkey }, "h", function () awful.tag.incmwfact(-0.05) end,
	{description = "decrease master width factor", group = "layout"}),

	awful.key({ modkey, "Shift" }, "h", function () awful.tag.incnmaster( 1, nil, true) end,
	{description = "increase the number of master clients", group = "layout"}),

	awful.key({ modkey, "Shift" }, "l", function () awful.tag.incnmaster(-1, nil, true) end,
	{description = "decrease the number of master clients", group = "layout"}),

	awful.key({ modkey, "Control" }, "h", function () awful.tag.incncol( 1, nil, true) end,
	{description = "increase the number of columns", group = "layout"}),
	--]]

	-- Client geometry
	awful.key({ modkey, "Shift" }, "j", function () awful.client.swap.byidx(1) end,
	{description = "swap with next client by index", group = "client"}),

	awful.key({ modkey, "Shift" }, "k", function () awful.client.swap.byidx(-1) end,
	{description = "swap with previous client by index", group = "client"}),

	--[[
	awful.key({ modkey, "Control" }, "n",
	function ()
		local c = awful.client.restore()

		-- Focus restored client
		if c then
			client.focus = c
			c:raise()
		end
	end,
	{description = "restore minimized", group = "client"}),
	--]]

	-- Menus
	awful.key({ modkey }, "w", function () mymainmenu:show() end,
	{description = "show main menu", group = "awesome"}),

	awful.key({ modkey }, "p", function() menubar.show() end,
	{description = "show the menubar", group = "launcher"}),

	-- Prompts
	awful.key({ modkey }, "r", function () awful.screen.focused().mypromptbox:run() end,
	{description = "run prompt", group = "launcher"}),

	awful.key({ modkey }, "x",
	function ()
		awful.prompt.run {
			prompt       = "Run Lua code: ",
			textbox      = awful.screen.focused().mypromptbox.widget,
			exe_callback = awful.util.eval,
			history_path = awful.util.get_cache_dir() .. "/history_eval"
		}
	end,
	{description = "lua execute prompt", group = "awesome"}),

	awful.key({ modkey }, "b", function () fleet.layout.toggle_wibox({
		awful.screen.focused().mywibox, awful.screen.focused().mybotwibox}) end,
	{description = "hide the wibars", group = "layout"}),

	-- Help window
	awful.key({ modkey }, "s", hotkeys_popup.show_help,
	{description="show help", group="awesome"}),

	-- Standard program
	--awful.key({}, "XF86AudioRaiseVolume", function() volumecfg:up() end),
	--awful.key({}, "XF86AudioLowerVolume", function() volumecfg:down() end),
	--awful.key({}, "XF86AudioMute", function() volumecfg:toggle() end),

	-- Awesome
	awful.key({ modkey }, "Return", function () awful.spawn(terminal) end,
	{description = "open a terminal", group = "launcher"}),

	awful.key({ modkey, "Control" }, "BackSpace", awesome.restart,
	{description = "reload awesome", group = "awesome"}),

	awful.key({ modkey, "Control" }, "Escape", awesome.quit,
	{description = "quit awesome", group = "awesome"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	globalkeys = awful.util.table.join(globalkeys,
	-- View tag only.
	awful.key({ modkey }, "#" .. i + 9,
	function ()
		local screen = awful.screen.focused()
		local tag = screen.tags[i]
		if tag then
			tag:view_only()
		end
	end,
	{description = "view tag #"..i, group = "tag"}),
	-- Toggle tag display.
	awful.key({ modkey, "Control" }, "#" .. i + 9,
	function ()
		local screen = awful.screen.focused()
		local tag = screen.tags[i]
		if tag then
			awful.tag.viewtoggle(tag)
		end
	end,
	{description = "toggle tag #" .. i, group = "tag"}),
	-- Move client to tag.
	awful.key({ modkey, "Shift" }, "#" .. i + 9,
	function ()
		if client.focus then
			local tag = client.focus.screen.tags[i]
			if tag then
				client.focus:move_to_tag(tag)
			end
		end
	end,
	{description = "move focused client to tag #"..i, group = "tag"}),
	-- Toggle tag on focused client.
	awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
	function ()
		if client.focus then
			local tag = client.focus.screen.tags[i]
			if tag then
				client.focus:toggle_tag(tag)
			end
		end
	end,
	{description = "toggle focused client on tag #" .. i, group = "tag"})
	)
end

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Client key bindings
clientkeys = awful.util.table.join(
	awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
	{description = "move to master", group = "client"}),

	awful.key({ modkey }, "o", function (c) c:move_to_screen() end,
	{description = "move to screen", group = "client"}),

	awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle,
	{description = "toggle floating", group = "client"}),

	--[[
	awful.key({ modkey,           }, "n",
	function (c)
	-- The client currently has the input focus, so it cannot be
	-- minimized, since minimized clients can't have the focus.
		c.minimized = true
	end ,
	{description = "minimize", group = "client"}),
	--]]

	awful.key({ modkey }, "m", function (c)
			c.maximized = not c.maximized
			c:raise()
		end ,
	{description = "maximize", group = "client"}),

	awful.key({ modkey }, "f", function (c)
		c.fullscreen = not c.fullscreen
		c:raise()
	end,
	{description = "toggle fullscreen", group = "client"}),

	awful.key({ modkey }, "t", function (c) c.ontop = not c.ontop end,
	{description = "toggle keep on top", group = "client"}),

	awful.key({ modkey, "Shift"   }, "c", function (c) c:kill() end,
	{description = "close", group = "client"})
)

-- Bind keypad to move and resize client
NumericPad = { "KP_End", "KP_Down", "KP_Next", "KP_Left", "KP_Begin", "KP_Right", "KP_Home", "KP_Up", "KP_Prior" }
NumericPadMap = {
	{-16,16,16,16}, {0,16,0,16,"down"}, {16,16,16,16},
	{-16,0,16,0,"left"}, {0,0,0,0}, {16,0,16,0,"right"},
	{-16,-16,16,16}, {0,-16,0,16,"up"}, {16,-16,16,16}
}

for i = 1, 9 do
	clientkeys = awful.util.table.join(clientkeys,
	awful.key({ modkey }, NumericPad[i],
	function (c)
		if awful.client.floating.get(c) or awful.layout.get(c.screen) == awful.layout.suit.floating then
			awful.client.moveresize(NumericPadMap[i][1], NumericPadMap[i][2], 0, 0, c)
		elseif NumericPadMap[i][5] then
			awful.client.swap.bydirection(NumericPadMap[i][5], c)
		end
	end, {description = "move client", group = "client"}),
	awful.key({ modkey, "Shift" }, NumericPad[i],
	function (c)
		if not awful.client.isfixed(c) then
			local x = NumericPadMap[i][1]
			local y = NumericPadMap[i][2]
			if x > 0 then x = 0 end
			if y > 0 then y = 0 end
			awful.client.moveresize(x, y, NumericPadMap[i][3], NumericPadMap[i][4], c)
		end
	end, {description = "grow client", group = "client"}),
	awful.key({ modkey, "Control" }, NumericPad[i],
	function (c)
		if not awful.client.isfixed(c) then
			local x = NumericPadMap[i][1] * -1
			local y = NumericPadMap[i][2] * -1
			if x < 0 then x = 0 end
			if y < 0 then y = 0 end
			awful.client.moveresize(x, y, NumericPadMap[i][3] * -1, NumericPadMap[i][4] * -1, c)
		end
	end, {description = "shrink client", group = "client"}))
end
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{ rule = { },
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap+awful.placement.no_offscreen,
			titlebars_enabled = false
		}
	},

	-- Add titlebars to normal clients
	{ rule = { type = "normal" },
		properties = { titlebars_enabled = true } },

	-- Center placement of dialog clients
	{ rule = { type = "dialog" },
		properties = { placement = awful.placement.centered } },

	-- Floating clients.
	{ rule_any = {
			instance = {
				"DTA",  -- Firefox addon DownThemAll.
				"copyq",  -- Includes session name in class.
			},
			class = {
				"Arandr",
				"Gpick",
				"Kruler",
				"MessageWin",  -- kalarm.
				"Sxiv",
				"Wpa_gui",
				"pinentry",
				"veromix",
				"xtightvncviewer",
				"MPlayer",
				"Gtk-recordMyDesktop"
			},
			name = {
				"Event Tester",  -- xev.
			},
			role = {
				"AlarmWindow",  -- Thunderbird's calendar.
				"pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
			}
		},
		properties = {
			floating = true
		},
	},

	-- No titlebar clients
	{ rule_any = {
			instance = {
				"gnome",
				"gpk",
			},
			class = {
				"Geary",
				"Chromium",
				"Nautilus",
				"Kruler",
				"MessageWin",
				"Gtk-recordMyDesktop",
				"Wallp"
			},
			name = {
				"Event Tester",
			},
			role = {
				"AlarmWindow",
			}
		},
		properties = {
			titlebars_enabled = false
		}
	}
}
-- }}}

-- {{{ Signals
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

screen.connect_signal("arrange", function ()
	local clients = awful.client.visible(s)

	if #clients > 0 then
		for _, c in pairs(clients) do
			if c.maximized_horizontal == true and c.maximized_vertical == true then
				c.titlebars_enabled = false
				c.border_width = 0
			else
				c.border_width = beautiful.border_width
			end
		end
	end
end)

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- if not awesome.startup then awful.client.setslave(c) end

	if awesome.startup and
		not c.size_hints.user_position
		and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
	-- buttons for the titlebar
	local buttons = awful.util.table.join(
		awful.button({ }, 1, function()
			client.focus = c
			c:raise()
			awful.mouse.client.move(c)
		end),
		awful.button({ }, 3, function()
			client.focus = c
			c:raise()
			awful.mouse.client.resize(c)
		end)
	)

	awful.titlebar(c, {size = 18}) : setup
	{
		layout = wibox.layout.align.horizontal,
		{ -- Left
			layout = wibox.layout.fixed.horizontal,
			buttons = buttons,
			awful.titlebar.widget.iconwidget(c),
		},
		{ -- Middle
			layout = wibox.layout.flex.horizontal,
			buttons = buttons,
			{align = "left", widget = awful.titlebar.widget.titlewidget(c) },
		},
		{ -- Right
			layout = wibox.layout.fixed.horizontal(),
			awful.titlebar.widget.floatingbutton(c),
			spr_small_empty,
			awful.titlebar.widget.maximizedbutton(c),
			spr_small_empty,
			awful.titlebar.widget.stickybutton(c),
			spr_small_empty,
			awful.titlebar.widget.ontopbutton(c),
			bar,
			awful.titlebar.widget.closebutton(c),
		},
	}
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
		and awful.client.focus.filter(c) then
		client.focus = c
	end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
