--[[

Awesome

--]]

-- {{{ Required libraries
local gears     = require("gears")
local awful     = require("awful")
awful.rules     = require("awful.rules")
require("awful.autofocus")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local naughty   = require("naughty")
--local drop      = require("scratchdrop")
local lain      = require("lain")
local layout_indicator = require("fleet/keyboard-layout-indicator")
local clientcountbox = require("fleet/client-count")
-- }}}

-- {{{ External library config
naughty.config.defaults.timeout = 0
-- }}}

-- {{{ Error handling
if awesome.startup_errors then
	naughty.notify({ preset = naughty.config.presets.critical,
	title = "Oops, there were errors during startup!",
	text = awesome.startup_errors })
end

do
	local in_error = false
	awesome.connect_signal("debug::error", function (err)
		if in_error then return end
		in_error = true

		naughty.notify({ preset = naughty.config.presets.critical,
		title = "Oops, an error happened!",
		text = err })
		in_error = false
	end)
end
-- }}}

-- {{{ Autostart applications
function run_once(cmd)
	findme = cmd
	firstspace = cmd:find(" ")
	if firstspace then
		findme = cmd:sub(0, firstspace-1)
	end
	awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

run_once("xcompmgr")
run_once("unclutter -not Boxes")
run_once("nm-applet")
-- }}}

-- {{{ Variable definitions
-- localization
--os.setlocale(os.getenv("LANG"))

-- beautiful init
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/fleet/theme.lua")

-- common
modkey     = "Mod4"
altkey     = "Mod1"
terminal   = "urxvt" or "terminology" or "gnome-terminal" or "xterm"
editor     = os.getenv("EDITOR") or "vim" or "vi"
editor_cmd = terminal .. " -e " .. editor

-- user defined
browser    = "tabbed -d surf -e"

inifile = '/home/pmartella/.config/awesome/aw.ini'

local layouts = {
	awful.layout.suit.floating,
	awful.layout.suit.max,
	awful.layout.suit.tile,
	awful.layout.suit.tile.left,
	awful.layout.suit.tile.top,
	awful.layout.suit.tile.bottom,
	--awful.layout.suit.fair,
}

-- }}}

-- {{{ Desktop Functions

_awesome_quit = awesome.quit
_awesome_restart = awesome.restart
awesome.quit = function()
	clear_conf(inifile)

	if os.getenv("DESKTOP_SESSION") == "awesome-gnome" then
		os.execute("/usr/bin/gnome-session-quit --logout --no-prompt")
	else
		_awesome_quit()
	end
end

awesome.restart = function()
	_awesome_restart()
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
		local clienticon_margin = wibox.layout.margin(myclienticon, 0, 0, 5, 5)
		local clienttitle_margin = wibox.layout.margin(myclientname, 0, 0, 4, 4)

		clientname_layout:set_strategy("max")
		clientname_layout:set_width(256)
		clientname_layout:set_widget(clienttitle_margin)

		clientbuttons_layout:add(spr_small_empty)
		clientbuttons_layout:add(clienticon_margin)
		clientbuttons_layout:add(spr_small_empty)
		clientbuttons_layout:add(clientname_layout)
		clientbuttons_layout:add(spr_empty)
		clientbuttons_layout:add(bar_empty)
		clientbuttons_layout:add(spr_small_empty)
		clientbuttons_layout:add(button_float)
		clientbuttons_layout:add(spr_small_empty)
		clientbuttons_layout:add(button_maximize)
		clientbuttons_layout:add(spr_small_empty)
		clientbuttons_layout:add(button_sticky)
		clientbuttons_layout:add(spr_small_empty)
		clientbuttons_layout:add(button_ontop)
		clientbuttons_layout:add(spr_small_empty)
		clientbuttons_layout:add(bar_empty)
		clientbuttons_layout:add(spr_small_empty)
		clientbuttons_layout:add(button_close)
	end

	return clientbuttons_layout
end

function update_clientborders ( c )
	if c == client.focus then
		c.border_color = beautiful.border_focus
	else
		c.border_color = beautiful.border_normal
	end

	-- No border for maximized clients
	if c.maximized_horizontal == true and c.maximized_vertical == true then
		c.border_width = 0
	else
		c.border_width = beautiful.border_width
	end
end

function get_conky()
	local clients = client.get()
	local conky = nil
	local i = 1

	while clients[i] do
		if clients[i].class == "Conky" then
			conky = clients[i]
		end
		i = i + 1
	end

	return conky
end

function raise_conky()
	local conky = get_conky()

	if conky then
		conky.ontop = true
	end
end

function lower_conky()
	local conky = get_conky()

	if conky then
		conky.ontop = false
	end
end

function toggle_conky()
	local conky = get_conky()

	if conky then
		if conky.ontop then
			conky.ontop = false
		else
			conky.ontop = true
		end
	end
end

function file_exists ( file )
	local f = io.open(file, "rb")
	if f then f:close() end
	return f ~= nil
end

function lines_from ( file )
	if not file_exists(file) then return {} end
	lines = {}
	for line in io.lines(file) do
		lines[#lines + 1] = line
	end
	return lines
end

function file_make ( file )
	local f = io.open(file, "w")
	f:write("Hello World")
	f:close()
end

function string:split ( sSeparator, nMax, bRegexp )
	assert(sSeparator ~= '')
	assert(nMax == nil or nMax >= 1)

	local aRecord = {}

	if self:len() > 0 then
		local bPlain = not bRegexp
		nMax = nMax or -1

		local nField, nStart = 1, 1
		local nFirst,nLast = self:find(sSeparator, nStart, bPlain)
		while nFirst and nMax ~= 0 do
			aRecord[nField] = self:sub(nStart, nFirst-1)
			nField = nField+1
			nStart = nLast+1
			nFirst,nLast = self:find(sSeparator, nStart, bPlain)
			nMax = nMax-1
		end
		aRecord[nField] = self:sub(nStart)
	end

	return aRecord
end

function write_conf ( file, conf, screen, key, value )
	local newconf = {}

	opt_name = conf .. '-' .. math.floor(screen) .. '-' .. key
	newconf[opt_name] = value

	for k,v in pairs(lines_from(file)) do
		local fkey, fvalue = unpack(v:split("="))

		if opt_name ~= fkey then
			newconf[fkey] = fvalue
		end
	end

	local f = io.open(file, "w")

	for k,v in pairs(newconf) do
		f:write(k .. "=" .. v .. "\n")
	end

	f:close()
end

function read_conf ( file, confkey, screen, key, default )
	local configs = {}

	opt_name = confkey .. '-' .. math.floor(screen) .. '-' .. key

	if next(configs) == nil then
		for k,v in pairs(lines_from(inifile)) do
			local fkey, fvalue = unpack(v:split("="))
			configs[fkey] = fvalue
		end
	end

	if configs[opt_name] == nil then
		return default
	else
		return configs[opt_name]
	end
end

function clear_conf ( file )
	local f = io.open(file, "w")
	f:write("")
	f:close()
end

-- }}}

-- {{{ Tags
tags = {
	names = { " 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 " },
	layout = { layouts[1], layouts[1], layouts[1], layouts[1], layouts[1], layouts[1], layouts[1], layouts[1], layouts[1] }
}
for s = 1, screen.count() do
	local tag_names = {}
	local tag_count = 0

	for _ in pairs(tags.names) do
		tag_count = tag_count + 1
		tag_names[tag_count] = read_conf(inifile, 'tag', s, tag_count, tags.names[tag_count])
	end

	tags[s] = awful.tag(tag_names, s, tags.layout)
end
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
	for s = 1, screen.count() do
		if s == screen.count() then
			gears.wallpaper.maximized(beautiful.wallpaper, s, true)
		else
			gears.wallpaper.centered(beautiful.wallpaper, s)
		end
	end
end
-- }}}

-- {{{ Menu
--[[
mymainmenu = awful.menu.new({
	items = require("menugen").build_menu(),
	theme = { height = 16, width = 130 }
})

mylauncher = awful.widget.launcher({
	image = beautiful.awesome_icon,
	menu = mymainmenu
})
--]]
-- }}}

-- {{{ Wibox

-- Separators
last = wibox.widget.imagebox()
last:set_image(beautiful.last)

spr = wibox.widget.imagebox()
spr:set_image(beautiful.spr)

spr_small = wibox.widget.imagebox()
spr_small:set_image(beautiful.spr_small)

spr_very_small = wibox.widget.imagebox()
spr_very_small:set_image(beautiful.spr_very_small)

spr_right = wibox.widget.imagebox()
spr_right:set_image(beautiful.spr_right)

spr_left = wibox.widget.imagebox()
spr_left:set_image(beautiful.spr_left)

spr_empty = wibox.widget.imagebox()
spr_empty:set_image(beautiful.spr_empty)

spr_small_empty = wibox.widget.imagebox()
spr_small_empty:set_image(beautiful.spr_small_empty)

bar = wibox.widget.imagebox()
bar:set_image(beautiful.bar)

bar_empty = wibox.widget.imagebox()
bar_empty:set_image(beautiful.bar_empty)

-- Keyboard Layout
kbdcfg = layout_indicator({
	layouts = {
		{ name = "colemak", layout = "us", variant = "colemak", color = "#80CCE6" },
		{ name = "dvorak", layout = "us", variant = "dvorak", color = "#FF9F9F" },
		{ name = "qwerty", layout = "us", variant = nil }
	},
	keys = {
		{ name = " 1 ", key = "Num_Lock", led = "Num Lock" },
		{ name = " A ", key = "Caps_Lock", led = "Caps Lock" }
	},
	dividers = {
		section = bar
	}
})
kbdwidget = wibox.widget.background()
kbdicon = wibox.widget.imagebox()
kbdicon:set_image(beautiful.keyboard)
kbdwidget:set_widget(kbdcfg.widget)
kbdwidget:set_bgimage(beautiful.widget_bg)

-- Clock
mytextclock = awful.widget.textclock("<span foreground='#FFFFFF'><span font='Monospace Regular 5'> </span>%H:%M<span font='Monospace Regular 5'> </span></span>")
clock_icon = wibox.widget.imagebox()
clock_icon:set_image(beautiful.clock)
clockwidget = wibox.widget.background()
clockwidget:set_widget(mytextclock)
clockwidget:set_bgimage(beautiful.widget_bg)

-- Calendar
mytextcalendar = awful.widget.textclock("<span foreground='#FFFFFF'><span font='Monospace Regular 5'> </span>%d %b<span font='Monospace Regular 5'> </span></span>")
calendar_icon = wibox.widget.imagebox()
calendar_icon:set_image(beautiful.calendar)
calendarwidget = wibox.widget.background()
calendarwidget:set_widget(mytextcalendar)
calendarwidget:set_bgimage(beautiful.widget_bg)
lain.widgets.calendar:attach(calendarwidget, { fg = "#FFFFFF", position = "bottom_right", font = "Monospace Regular", font_size = "12" })

-- MPD
mpd_icon = wibox.widget.imagebox()
mpd_icon:set_image(beautiful.mpd)

-- ALSA volume bar
myvolumebar = lain.widgets.alsabar({
	ticks  = true,
	width  = 80,
	height = 10,
	colors = {
		background = "#383838",
		unmute     = "#80CCE6",
		mute       = "#FF9F9F"
	},
	notifications = {
		font      = "Monospace Regular",
		font_size = "12",
		bar_size  = 32
	}
})
alsamargin = wibox.layout.margin(myvolumebar.bar, 5, 8, 80)
wibox.layout.margin.set_top(alsamargin, 12)
wibox.layout.margin.set_bottom(alsamargin, 12)
volumewidget = wibox.widget.background()
volumewidget:set_widget(alsamargin)
volumewidget:set_bgimage(beautiful.widget_bg)

-- CPU
cpu_widget = lain.widgets.cpu({
	settings = function()
		widget:set_markup(cpu_now.usage .. "%")
	end
})
cpuwidget = wibox.widget.background()
cpuwidget:set_widget(cpu_widget)
cpuwidget:set_bgimage(beautiful.widget_bg)
cpu_icon = wibox.widget.imagebox()
cpu_icon:set_image(beautiful.cpu)


-- Create a wibox for each screen and add it
mywibox = {}
mybottomwibox = {}
mywbuttonbox = {}
mylayoutbox = {}
mytaglist = {}
myclientcount = {}
mytaglist.buttons = awful.util.table.join(
	awful.button({ }, 1, awful.tag.viewonly),
	awful.button({ modkey }, 1, awful.client.movetotag),
	awful.button({ }, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, awful.client.toggletag),
	awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
	awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)

--[[
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
awful.button({ }, 1, function (c)
if c == client.focus then
c.minimized = true
else
-- Without this, the following
-- :isvisible() makes no sense
c.minimized = false
if not c:isvisible() then
awful.tag.viewonly(c:tags()[1])
end
-- This will also un-minimize
-- the client, if needed
client.focus = c
c:raise()
end
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

Create a tasklist widget
mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)
]]

for s = 1, screen.count() do
	-- Create a wbuttonbox for each screen
	mywbuttonbox[s] = wibox.widget.background()
	mywbuttonbox[s]:set_widget(get_clientbuttons(nil, s))

	-- Create an imagebox widget which will contains an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	mylayoutbox[s] = awful.widget.layoutbox(s)
	mylayoutbox[s]:buttons(awful.util.table.join(
	awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
	awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
	awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
	awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
	-- Create a taglist widget
	mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

	-- Create client count widget
	myclientcount[s] = clientcountbox(s)

	-- Create the wibox
	mywibox[s] = awful.wibox({ position = "top", screen = s, height = 32 })

	-- Widgets that are aligned to the upper left
	local screentag_layout = wibox.layout.fixed.horizontal()
	screentag_layout:add(spr_small_empty)
	screentag_layout:add(mytaglist[s])
	screentag_layout:add(spr_small_empty)
	screentag_layout:add(bar_empty)
	screentag_layout:add(spr_small_empty)
	screentag_layout:add(mylayoutbox[s])
	screentag_layout:add(spr_small_empty)
	screentag_layout:add(myclientcount[s])
	screentag_layout:add(spr_small_empty)

	local screentag_widget = wibox.widget.background()
	screentag_widget:set_widget(screentag_layout)
	--screentag_widget:set_bgimage(beautiful.widget_bg)

	local left_layout = wibox.layout.fixed.horizontal()

	left_layout:add(screentag_widget)
	left_layout:add(spr_empty)

	-- Widgets that are aligned to the upper right
	local right_layout = wibox.layout.fixed.horizontal()

	right_layout:add(spr_small_empty)
	right_layout:add(mywbuttonbox[s])
	right_layout:add(spr_empty)

	-- Now bring it all together (with the tasklist in the middle)
	local layout = wibox.layout.align.horizontal()
	layout:set_left(left_layout)
	layout:set_right(right_layout)
	layout:set_middle(spr_empty)

	mywibox[s]:set_widget(layout)

	-- Set proper backgrounds, instead of beautiful.bg_normal
	mywibox[s]:set_bg("#000000")

	if s == 1 then
		-- Create the bottom wibox
		mybottomwibox[s] = awful.wibox({ position = "bottom", screen = s, border_width = 0, height = 32 })

		-- Widgets that are aligned to the bottom left
		bottom_left_layout = wibox.layout.fixed.horizontal()
		-- bottom_left_layout:add(mylauncher)
		-- bottom_left_layout:add(spr_small_empty)

		systray_widget = wibox.layout.margin(wibox.widget.systray(), 0, 0, 32)
		wibox.layout.margin.set_top(systray_widget, 5)
		wibox.layout.margin.set_bottom(systray_widget, 5)

		-- bottom_left_layout:add(mylauncher)
		bottom_left_layout:add(spr_small_empty)
		bottom_left_layout:add(systray_widget)
		bottom_left_layout:add(spr_small_empty)

		-- Widgets that are aligned to the bottom right
		bottom_right_layout = wibox.layout.fixed.horizontal()

		--right_layout:add(batwidget)

		bottom_right_layout:add(spr_left)
		bottom_right_layout:add(cpu_icon)
		bottom_right_layout:add(bar)
		bottom_right_layout:add(spr_very_small)
		bottom_right_layout:add(cpuwidget)
		bottom_right_layout:add(spr_right)

		bottom_right_layout:add(spr_left)
		bottom_right_layout:add(mpd_icon)
		bottom_right_layout:add(bar)
		bottom_right_layout:add(volumewidget)
		bottom_right_layout:add(spr_right)

		keymap_widget = wibox.layout.fixed.horizontal();
		keymap_widget:add(spr_left)
		keymap_widget:add(kbdicon)
		keymap_widget:add(bar)
		keymap_widget:add(kbdwidget)
		keymap_widget:add(spr_right)

		bottom_right_layout:add(keymap_widget);

		bottom_right_layout:add(spr_left)
		bottom_right_layout:add(calendar_icon)
		bottom_right_layout:add(bar)
		bottom_right_layout:add(spr_very_small)
		bottom_right_layout:add(calendarwidget)
		bottom_right_layout:add(spr_right)

		bottom_right_layout:add(spr_left)
		bottom_right_layout:add(clock_icon)
		bottom_right_layout:add(bar)
		bottom_right_layout:add(spr_very_small)
		bottom_right_layout:add(clockwidget)
		bottom_right_layout:add(last)

		-- Now bring it all together (with the tasklist in the middle)
		bottom_layout = wibox.layout.align.horizontal()
		bottom_layout:set_left(bottom_left_layout)
		bottom_layout:set_right(bottom_right_layout)
		-- bottom_layout:set_middle(mytasklist[s])

		mybottomwibox[s]:set_widget(bottom_layout)
	end
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
awful.button({ }, 3, function () mymainmenu:toggle() end)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
-- awful.key({ altkey }, "p", function() os.execute("gnome-screenshot") end),

-- Rename tag
awful.key({ modkey }, "F2", function ()
	currScreen = mouse.screen
	currTag = awful.tag.getidx(awful.tag.selected())
	currText = awful.tag.selected().name:gsub("^%s*(.-)%s*$", "%1")
	currText = currText:gsub('%[' .. currTag .. '%]', '')
	currText = currText:gsub("^%s*(.-)%s*$", "%1")

	local dprompt = io.popen("echo "..currText.." | dmenu -m "..(currScreen - 1).." -fn 'Source Code Pro-14' -nb '#333333' -nf '#cccccc' -sb '#285577' -sf '#ffffff' -p 'Tag Name'", "r")
	local dpromptOut = dprompt:read("*a"):gsub("^%s*(.-)%s*$", "%1")
	dprompt:close()

	if string.len(dpromptOut) == 0 then
		tagName = ' '.. currTag ..' '
		write_conf(inifile, 'tag', currScreen, currTag, tagName)
		awful.tag.selected().name = tagName
	else
		tagName = ' [' .. currTag .. '] ' .. dpromptOut .. ' '
		write_conf(inifile, 'tag', currScreen, currTag, tagName)
		awful.tag.selected().name = tagName
	end
end),

-- Tag browsing
awful.key({ modkey }, "Left",   awful.tag.viewprev),
awful.key({ modkey }, "Right",  awful.tag.viewnext),
awful.key({ modkey }, "Escape", awful.tag.history.restore),
awful.key({ modkey, "Shift" }, ",", awful.tag.viewprev),
awful.key({ modkey, "Shift" }, ".", awful.tag.viewnext),
awful.key({ modkey }, ",", function () lain.util.tag_view_nonempty(-1) end),
awful.key({ modkey }, ".", function () lain.util.tag_view_nonempty(1) end),

-- Screen browsing
awful.key({ modkey }, "h", function () awful.screen.focus_bydirection("left") end),
awful.key({ modkey }, "n", function () awful.screen.focus_bydirection("down") end),
awful.key({ modkey }, "e", function () awful.screen.focus_bydirection("up") end),
awful.key({ modkey }, "i", function () awful.screen.focus_bydirection("right") end),

-- Focus client by direction
awful.key({ modkey }, "w",
function ()
	awful.client.focus.bydirection("up")
	if client.focus then client.focus:raise() end
end),
awful.key({ modkey }, "a",
function ()
	awful.client.focus.bydirection("left")
	if client.focus then client.focus:raise() end
end),
awful.key({ modkey }, "r",
function ()
	awful.client.focus.bydirection("down")
	if client.focus then client.focus:raise() end
end),
awful.key({ modkey }, "s",
function ()
	awful.client.focus.bydirection("right")
	if client.focus then client.focus:raise() end
end),

-- Cycle client focus
awful.key({ modkey }, "Tab", function ()
	awful.client.focus.byidx(-1)
	if client.focus then
		client.focus:raise()
	end
end),
awful.key({ modkey, "Shift" }, "Tab", function ()
	awful.client.focus.byidx(1)
	if client.focus then
		client.focus:raise()
	end
end),

-- Urgent client jump
awful.key({ modkey }, "u", awful.client.urgent.jumpto),

-- Show/Hide Bottom Wibox
awful.key({ modkey }, "b", function ()
	if mybottomwibox[mouse.screen] then
		mybottomwibox[mouse.screen].visible = not mybottomwibox[mouse.screen].visible
		screen[mouse.screen]:emit_signal("arrange")
	end
end),

-- Layout manipulation

--[[
awful.key({ modkey, altkey    }, "i",      function () awful.tag.incmwfact( 0.05)     end),
awful.key({ modkey, altkey    }, "h",      function () awful.tag.incmwfact(-0.05)     end),
awful.key({ modkey, "Shift"   }, "i",      function () awful.tag.incnmaster(-1)       end),
awful.key({ modkey, "Shift"   }, "h",      function () awful.tag.incnmaster( 1)       end),
awful.key({ modkey, "Control" }, "i",      function () awful.tag.incncol(-1)          end),
awful.key({ modkey, "Control" }, "h",      function () awful.tag.incncol( 1)          end),
--]]
awful.key({ modkey,           }, "space",  function () awful.layout.inc(layouts,  1)  end),
awful.key({ modkey, "Shift"   }, "space",  function () awful.layout.inc(layouts, -1)  end),

-- Standard program
awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
awful.key({ modkey, "Control" }, "BackSpace", awesome.restart),
awful.key({ modkey, "Control" }, "Escape", awesome.quit),

-- Dropdown terminal
--awful.key({ modkey,	          }, "z",      function () drop(terminal) end),
--awful.key({ modkey,	          }, "g",      function () drop(browser, "top", "center", 1, 1, false) end),

-- ALSA volume control
awful.key({ modkey }, "Up",
function ()
	awful.util.spawn("amixer -q set " .. myvolumebar.channel .. " " .. myvolumebar.step .. "+")
	myvolumebar.notify()
end),
awful.key({ modkey }, "Down",
function ()
	awful.util.spawn("amixer -q set " .. myvolumebar.channel .. " " .. myvolumebar.step .. "-")
	myvolumebar.notify()
end),
awful.key({ }, "#123",
function ()
	awful.util.spawn("amixer -q set " .. myvolumebar.channel .. " " .. myvolumebar.step .. "+")
	myvolumebar.notify()
end),
awful.key({ }, "#122",
function ()
	awful.util.spawn("amixer -q set " .. myvolumebar.channel .. " " .. myvolumebar.step .. "-")
	myvolumebar.notify()
end),
awful.key({  }, "#121",
function ()
	awful.util.spawn("amixer -q set " .. myvolumebar.channel .. " playback toggle")
	myvolumebar.notify()
end),

-- Prompt
awful.key({modkey }, "p", function()
	local curr_screen = awful.screen.focused()
	awful.util.spawn_with_shell("exe=`dmenu_path | dmenu -m "..(curr_screen.index - 1).." -fn 'Source Code Pro-14' -nb '#333333' -nf '#cccccc' -sb '#285577' -sf '#ffffff' -p 'Run'` && exec $exe")
end),
awful.key({ modkey }, "x", function ()
	local curr_screen = awful.screen.focused()
	local cachePath = awful.util.getdir("cache") .. "/history_eval"
	local dprompt = io.popen("cat "..cachePath.." 2>/dev/null | dmenu -m "..(curr_screen.index - 1).." -l 5 -fn 'Source Code Pro-14' -nb '#333333' -nf '#cccccc' -sb '#881133' -sf '#ffffff' -p 'Eval'", "r")
	local dpromptOut = dprompt:read("*a")
	dprompt:close()
	awful.util.eval(dpromptOut)
end)
)

clientkeys = awful.util.table.join(
	awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
	awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
	awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
	awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
	awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
	awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
	awful.key({ modkey, "Control" }, "k",      awful.client.restore),
	awful.key({ modkey,           }, "k",
	function (c)
		-- The client currently has the input focus, so it cannot be
		-- minimized, since minimized clients can't have the focus.
		c.minimized = true
	end),
	awful.key({ modkey,           }, "m",
	function (c)
		c.maximized_horizontal = not c.maximized_horizontal
		c.maximized_vertical   = not c.maximized_vertical
	end)
)

-- Bind keypad to move and resize client
NumericPad = { "KP_End", "KP_Down", "KP_Next", "KP_Left", "KP_Begin", "KP_Right", "KP_Home", "KP_Up", "KP_Prior" }
NumericPadMap = {
	{-16,16,16,16}, {0,16,0,16,"down"}, {16,16,16,16},
	{-16,0,16,0,"left"}, {0,0,0,0}, {16,0,16,0,"right"},
	{-16,-16,16,16}, {0,-16,0,16,"up"}, {16,-16,16,16}
}

for i = 1, 9 do
	globalkeys = awful.util.table.join(globalkeys,
	awful.key({ modkey }, NumericPad[i],
	function ()
		local c = client.focus
		if awful.client.floating.get(c) or awful.layout.get(c.screen) == awful.layout.suit.floating then
			awful.client.moveresize(NumericPadMap[i][1], NumericPadMap[i][2], 0, 0, c)
		elseif NumericPadMap[i][5] then
			awful.client.swap.bydirection(NumericPadMap[i][5], c)
		end
	end),
	awful.key({ modkey, "Shift" }, NumericPad[i],
	function ()
		local c = client.focus
		if not awful.client.isfixed(c) then
			local x = NumericPadMap[i][1]
			local y = NumericPadMap[i][2]
			if x > 0 then x = 0 end
			if y > 0 then y = 0 end
			awful.client.moveresize(x, y, NumericPadMap[i][3], NumericPadMap[i][4], c)
		end
	end),
	awful.key({ modkey, "Control" }, NumericPad[i],
	function ()
		local c = client.focus
		if not awful.client.isfixed(c) then
			local x = NumericPadMap[i][1] * -1
			local y = NumericPadMap[i][2] * -1
			if x < 0 then x = 0 end
			if y < 0 then y = 0 end
			awful.client.moveresize(x, y, NumericPadMap[i][3] * -1, NumericPadMap[i][4] * -1, c)
		end
	end))
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	globalkeys = awful.util.table.join(globalkeys,
	awful.key({ modkey }, "#" .. i + 9,
	function ()
		local screen = mouse.screen
		if screen then
			local tag = awful.tag.gettags(screen)[i]
			if tag then
				awful.tag.viewonly(tag)
			end
		end
	end),
	awful.key({ modkey, "Control" }, "#" .. i + 9,
	function ()
		local screen = mouse.screen
		if screen then
			local tag = awful.tag.gettags(screen)[i]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end
	end),
	awful.key({ modkey, "Shift" }, "#" .. i + 9,
	function ()
		if client.focus then
			local tag = awful.tag.gettags(client.focus.screen)[i]
			 if tag then
				awful.client.movetotag(tag)
			end
		end
	end),
	awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
	function ()
		if client.focus then
			local tag = awful.tag.gettags(client.focus.screen)[i]
			 if tag then
				awful.client.toggletag(tag)
			end
		end
	end))
end

clientbuttons = awful.util.table.join(
awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
awful.button({ modkey }, 1, awful.mouse.client.move),
awful.button({ modkey }, 2, awful.mouse.client.resize),
awful.button({ modkey }, 3, awful.mouse.client.resize)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
	{
		rule = { },
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			keys = clientkeys,
			buttons = clientbuttons,
			size_hints_honor = true,
		}
	},

	{
		rule = {
			class = "Conky"
		},
		properties = {
			--floating = true,
			--sticky = true,
			--ontop = false,
			--focusable = false,
			size_hints = {"program_position", "program_size"}
		}
	},

	{
		rule = {
		class = "MPlayer"
	},
		properties = {
			floating = true
		}
	},

	{
		rule = {
			class = "Gtk-recordMyDesktop"
		},
		properties = {
			floating = true
		}
	},

	{
		rule = {
			class = "Dwb"
		},
		properties = {
			tag = tags[1][1]
		}
	},

	{
		rule = {
			class = "Iron"
		},
		properties = {
			tag = tags[1][1]
		}
	},

	{
		rule = {
			class = "Gimp",
			role = "gimp-image-window"
		},
		properties = {
			maximized_horizontal = true,
			maximized_vertical = true
		}
	},
}
-- }}}

-- {{{ Signals

-- Signal function to execute when a new client appears.
function update_clientbuttons ( c, s )
	if s and mywbuttonbox[s] then
		mywbuttonbox[s]:set_widget(get_clientbuttons(c,s))
	end
end

client.connect_signal("manage", function (c, startup)
	-- Enable sloppy focus
	c:connect_signal("mouse::enter", function(c)
		if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
			and awful.client.focus.filter(c) then
			client.focus = c
		end
	end)

	c:connect_signal("property::screen", function ( c )
		for s = 1, screen.count() do
			oc = awful.client.focus.history.get(s, 0)

			if oc then
				-- update_clientbuttons(oc, oc.screen)
			else
				-- update_clientbuttons(nil, s)
			end
		end
	end)

	if not startup and not c.size_hints.user_position
		and not c.size_hints.program_position then
		awful.placement.no_overlap(c)
		awful.placement.no_offscreen(c)
	end
end)

client.connect_signal("unmanage", function ( c )
	if not client.focus then
		-- update_clientbuttons(nil, c.screen)
	end
end)

client.connect_signal("focus", function ( c )
	-- update_clientbuttons(c, c.screen)
	-- update_clientborders(c)
end)

client.connect_signal("unfocus", function ( c )
	-- update_clientborders(c)
end)

tag.connect_signal("property::selected", function ( t )
	-- update_clientbuttons(client.focus, awful.tag.getscreen(t))
end)
-- }}}

-- {{{ Arrange signal handler
for s = 1, screen.count() do screen[s]:connect_signal("arrange", function ()
	local clients = awful.client.visible(s)
	local layout  = awful.layout.getname(awful.layout.get(s))

	if #clients > 0 then
		for _, c in pairs(clients) do
			update_clientborders(c)
		end
	end
end)
end
-- }}}
