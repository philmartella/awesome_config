---------------------------------------------------------------------------
--- Client Control for fleet.
---------------------------------------------------------------------------

local capi = {
	screen = screen,
	client = client
}
local ipairs = ipairs
local setmetatable = setmetatable
local table = table
local awful = require("awful")
local common = require("awful.widget.common")
local util = require("awful.util")
local tag = require("awful.tag")
local timer = require("gears.timer")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")

local clientcontrol = {
	widget = {}
}

--- Show tooltips when hover on client control buttons (defaults to 'true')
clientcontrol.enable_tooltip = true

local instances

local function get_screen(s)
    return s and screen[s]
end

local function get_lists (args)
	local wlist = {}
	local flist = {}

	for _, d in pairs(args) do
		local id = d.id or _

		if d.widget then
			wlist[id] = d.widget
		end

		if d.update and 'function' == type(d.update) then
			flist[id] = d.update
		end
	end

	return wlist, flist
end

local function widget_update(w, c, s, filter, data, uf)
	if uf and c and s and c.screen == s and filter(c, s) then
		uf(w, c, s)
	end
end

local function new(screen, args, filter)
	screen = get_screen(screen)
	local filter = filter or awful.widget.tasklist.filter.currenttags
	local args = args or {}
	local sw = { widget = {} }

	local wlist, flist = get_lists(args)

	local data = setmetatable({}, { __mode = 'k' })

	for id, w in pairs(wlist) do
		local queued_update = false

		function w._do_widget_update(c)
			-- Add a delayed callback for the first update.
			if not queued_update then
				timer.delayed_call(function()
					queued_update = false
					if screen.valid then
						local uf = flist[id] or clientcontrol.update_function
						widget_update(w, c, screen, filter, data, uf)
					end
				end)
				queued_update = true
			end
		end

		function w._unmanage(c)
			data[c] = nil
		end
	end

	if instances == nil then
		instances = setmetatable({}, { __mode = "k" })

		local function uw (s, c)
			local i = instances[get_screen(s)]

			if i then
				for _, w in pairs(i) do
					w._do_widget_update(c)
				end
			end
		end

		local function u (c)
			for s in pairs(instances) do
				if s.valid then
					uw(s, c)
				end
			end
		end

		--tag.attached_connect_signal(nil, "property::selected", u)
		--tag.attached_connect_signal(nil, "property::activated", u)
		capi.client.connect_signal("property::urgent", u)
		capi.client.connect_signal("property::sticky", u)
		capi.client.connect_signal("property::ontop", u)
		capi.client.connect_signal("property::above", u)
		capi.client.connect_signal("property::below", u)
		capi.client.connect_signal("property::floating", u)
		capi.client.connect_signal("property::maximized_horizontal", u)
		capi.client.connect_signal("property::maximized_vertical", u)
		capi.client.connect_signal("property::minimized", u)
		capi.client.connect_signal("property::name", u)
		capi.client.connect_signal("property::icon_name", u)
		capi.client.connect_signal("property::icon", u)
		--capi.client.connect_signal("property::skip_taskbar", u)
		--capi.client.connect_signal("property::hidden", u)
		capi.client.connect_signal("tagged", u)
		capi.client.connect_signal("untagged", u)
		capi.client.connect_signal("list", u)
		capi.client.connect_signal("focus", u)
		--capi.client.connect_signal("unfocus", u)
		capi.client.connect_signal("property::screen", function(c, old_screen)
			uw(c.screen, c)
			uw(old_screen, c)
		end)
		capi.client.connect_signal("unmanage", function(c)
			u(c)
			for _, i in pairs(instances) do
				for _, w in pairs(i) do
					w._unmanage(c)
				end
			end
		end)
		capi.screen.connect_signal("removed", function(s)
			instances[get_screen(s)] = nil
		end)
	end

	local list = instances[screen]

	if not list then
		list = setmetatable({}, { __mode = "v" })
		instances[screen] = list
	end

	for id, w in pairs(wlist) do
		table.insert(list, w)
		sw.widget[id] = w
	end

	return sw
end


function clientcontrol.update_function (w, c)
	--naughty.notify({text = 'update'})
end

function clientcontrol.button_img (button, c)
	local prefix = 'normal'
	local state = 'inactive'

	if c.screen == awful.screen.focused() then
		prefix = 'focus'
	end

	if c[button] then
		state = 'active'
	end

	local img = beautiful['titlebar_' .. button .. '_button_' .. prefix .. '_' .. state]
		or beautiful.none_normal or nil

	return img
end

return setmetatable(clientcontrol, { __call = function(_, ...) return new(...) end})

