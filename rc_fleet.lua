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
-- Fleet widget libraries
local keyboardlayoutindicator = require("fleet/keyboard-layout-indicator")
local clientcountbox = require("fleet/client-count")

-- {{{ External library config
awful.titlebar.enable_tooltip = false
naughty.config.defaults.timeout = 0
-- }}}

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

-- This is used later as the default terminal and editor to run.
terminal = "urxvt" or "terminology" or "gnome-terminal" or "xterm"
editor = os.getenv("EDITOR") or "vim" or "vi" or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
modkey = "Mod4"

-- Stateful tab name storage.
inifile = '/home/pmartella/.config/awesome/aw.ini'

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

-- {{{ Helper functions
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
		local clienticon_margin = wibox.layout.margin(myclienticon, 0, 0, 3, 3)
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
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
	{ "hotkeys", function() return false, hotkeys_popup.show_help end},
	{ "manual", terminal .. " -e man awesome" },
	{ "edit config", editor_cmd .. " " .. awesome.conffile }
}

mysessionmenu = {
	{ "lock", "xlock -mode space" },
	{ "restart", awesome.restart },
	{ "quit", function() awesome.quit() end},
	{ "reboot", "systemctl reboot"},
	{ "poweroff", "systemctl poweroff"}
}

mymainmenu = awful.menu({
	items = {
		{ "session", mysessionmenu, beautiful.awesome_icon },
		{ "awesome", myawesomemenu, beautiful.awesome_icon },
		{ "open terminal", terminal }
	}
})

mylauncher = awful.widget.launcher({
	image = beautiful.awesome_icon,
	menu = mymainmenu
})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
--menubar.geometry = { x = 0, y = 0 }
-- }}}

-- {{{ Wibar Widgets
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

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Clock
mytextclock = wibox.widget.textclock("<span foreground='#FFFFFF'>%H:%M</span>")
clock_icon = wibox.widget.imagebox()
clock_icon:set_image(beautiful.clock)
clockwidget = wibox.widget.background()
clockwidget:set_widget(mytextclock)
clockwidget:set_bgimage(beautiful.widget_bg)

-- Calendar
mytextcalendar = wibox.widget.textclock("<span foreground='#FFFFFF'>%a, %b %d</span>")
calendar_icon = wibox.widget.imagebox()
calendar_icon:set_image(beautiful.calendar)
calendarwidget = wibox.widget.background()
calendarwidget:set_widget(mytextcalendar)
calendarwidget:set_bgimage(beautiful.widget_bg)
--lain.widgets.calendar:attach(calendarwidget, { fg = "#FFFFFF", position = "bottom_right", font = "Monospace Regular", font_size = "12" })

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
	s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

	-- Create a clientbutton widget
	s.myclientbox = wibox.widget.background()
	s.myclientbox:set_widget(get_clientbuttons(nil, s))

	-- Create the wibox
	s.mywibox = awful.wibar({ position = "top", height = 22, screen = s })

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
			s.myclientbox,
			spr_small_empty
		},
	}

	if 1 == s.index then
		-- Create the bottom wibox
		s.mybotwibox = awful.wibar({ position = "bottom", height = 32, screen = s })

		s.mybotwibox:setup {
			layout = wibox.layout.align.horizontal,
			{ -- Left widgets
				layout = wibox.layout.fixed.horizontal,
				mylauncher,
				wibox.widget.systray(),
			},
			{ -- Middle widgets
				layout = wibox.layout.fixed.horizontal,
			},
			{ -- Right widgets
				layout = wibox.layout.fixed.horizontal,
				spr_left,
				spr_small,
				mykeyboardlayout,
				spr_small,
				spr_right,

				spr_left,
				calendar_icon,
				bar,
				spr_small,
				calendarwidget,
				spr_small,
				spr_right,

				spr_left,
				clock_icon,
				bar,
				spr_small,
				clockwidget,
				spr_small,
				spr_right,
			},
		}
	end
end)
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

awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
{description="show help", group="awesome"}),

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
		-- write_conf(inifile, 'tag', currScreen, currTag, tagName)
		awful.tag.selected().name = tagName
	else
		tagName = '[' .. currTag .. ']' .. dpromptOut .. ''
		-- write_conf(inifile, 'tag', currScreen, currTag, tagName)
		awful.tag.selected().name = tagName
	end
end, {description = "Rename current tag", group = "tag"}),

-- Screen browsing
awful.key({ modkey }, "h", function () awful.screen.focus_bydirection("left") end),
awful.key({ modkey }, "n", function () awful.screen.focus_bydirection("down") end),
awful.key({ modkey }, "e", function () awful.screen.focus_bydirection("up") end),
awful.key({ modkey }, "i", function () awful.screen.focus_bydirection("right") end),

-- Tag browsing
awful.key({ modkey }, "Left",   awful.tag.viewprev,
{description = "view previous", group = "tag"}),

awful.key({ modkey }, "Right",  awful.tag.viewnext,
{description = "view next", group = "tag"}),

awful.key({ modkey }, "Escape", awful.tag.history.restore,
{description = "go back", group = "tag"}),

awful.key({ modkey, "Shift" }, ",", awful.tag.viewprev,
{description = "view previous", group = "tag"}),

awful.key({ modkey, "Shift" }, ".", awful.tag.viewnext,
{description = "view next", group = "tag"}),

awful.key({ modkey }, ",", function ()
	local scr = awful.screen.focused()
	for i = 1, #scr.tags do
		awful.tag.viewidx(-1)
		if #awful.client.visible(scr) > 0 then
			 return
		end
	end
end,
{description = "view previous with clients", group = "tag"}),

awful.key({ modkey }, ".", function ()
	local scr = awful.screen.focused()
	for i = 1, #scr.tags do
		awful.tag.viewidx(1)
		if #awful.client.visible(scr) > 0 then
			 return
		end
	end
end,
{description = "view next with clients", group = "tag"}),

awful.key({ modkey }, "equal", function ()
	awful.tag.incgap(1)
end,
{description = "increase useless gap", group = "tag"}),

awful.key({ modkey }, "minus", function ()
	awful.tag.incgap(-1)
end,
{description = "decrease useless gap", group = "tag"}),

-- Client browsing
awful.key({ modkey,           }, "j",
function ()
	awful.client.focus.byidx( 1)
end,
{description = "focus next by index", group = "client"}
),
awful.key({ modkey,           }, "k",
function ()
	awful.client.focus.byidx(-1)
end,
{description = "focus previous by index", group = "client"}
),
awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
{description = "show main menu", group = "awesome"}),


-- Layout manipulation
awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
{description = "swap with next client by index", group = "client"}),
awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
{description = "swap with previous client by index", group = "client"}),
awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
{description = "focus the next screen", group = "screen"}),
awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
{description = "focus the previous screen", group = "screen"}),
awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
{description = "jump to urgent client", group = "client"}),

awful.key({ modkey }, "Tab",
function ()
	--awful.client.focus.history.previous()
	awful.client.focus.byidx(-1)
	if client.focus then
		client.focus:raise()
	end
end,
{description = "focus previous", group = "client"}),

awful.key({ modkey, "Shift" }, "Tab",
function ()
	awful.client.focus.byidx(1)
	if client.focus then
		client.focus:raise()
	end
end,
{description = "focus next", group = "client"}),

-- Standard program
awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
{description = "open a terminal", group = "launcher"}),
awful.key({ modkey, "Control" }, "BackSpace", awesome.restart,
{description = "reload awesome", group = "awesome"}),
awful.key({ modkey, "Control"   }, "Escape", awesome.quit,
{description = "quit awesome", group = "awesome"}),




awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
{description = "increase master width factor", group = "layout"}),

--awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
--{description = "decrease master width factor", group = "layout"}),

--awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
--{description = "increase the number of master clients", group = "layout"}),

--awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
--{description = "decrease the number of master clients", group = "layout"}),

--awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
--{description = "increase the number of columns", group = "layout"}),

awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
{description = "decrease the number of columns", group = "layout"}),

awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
{description = "select next", group = "layout"}),

awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
{description = "select previous", group = "layout"}),


--awful.key({ modkey, "Control" }, "n",
--function ()
--	local c = awful.client.restore()
	-- Focus restored client
--	if c then
--		client.focus = c
--		c:raise()
--	end
--end,
--{description = "restore minimized", group = "client"}),

-- Prompt
awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
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

-- Menubar
awful.key({ modkey }, "p", function() menubar.show() end,
{description = "show the menubar", group = "launcher"})
)

clientkeys = awful.util.table.join(
awful.key({ modkey,           }, "f",
function (c)
	c.fullscreen = not c.fullscreen
	c:raise()
end,
{description = "toggle fullscreen", group = "client"}),
awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
{description = "close", group = "client"}),
awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
{description = "toggle floating", group = "client"}),
awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
{description = "move to master", group = "client"}),
awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
{description = "move to screen", group = "client"}),
awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
{description = "toggle keep on top", group = "client"}),

--awful.key({ modkey,           }, "n",
--function (c)
	-- The client currently has the input focus, so it cannot be
	-- minimized, since minimized clients can't have the focus.
--	c.minimized = true
--end ,
--{description = "minimize", group = "client"}),

awful.key({ modkey,           }, "m",
function (c)
	c.maximized = not c.maximized
	c:raise()
end ,
{description = "maximize", group = "client"})
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

clientbuttons = awful.util.table.join(
awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
awful.button({ modkey }, 1, awful.mouse.client.move),
awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
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
		placement = awful.placement.no_overlap+awful.placement.no_offscreen
	}
},

-- Add titlebars to normal clients and dialogs
{ rule_any = {
		type = {
			"normal",
			"dialog"
		}
	},
	properties = {
		titlebars_enabled = true
	}
},

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
		},
		class = {
			"Chromium",
			"Nautilus",
			"Kruler",
			"MessageWin",
			"Gtk-recordMyDesktop"
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
-- Set Firefox to always map on the tag named "2" on screen 1.
-- { rule = { class = "Firefox" },
--   properties = { screen = 1, tag = "2" } },
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
			spr_small_empty,
			bar_empty,
			spr_small_empty,
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
