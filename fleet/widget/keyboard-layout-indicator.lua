local pairs = pairs
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")

-- Keyboard Layout Switcher
-- Keyboard map indicator and changer

-- indicator.mt: module (class) metatable
-- indicator.wmt: widget (instance) metatable
local indicator = { mt = {}, wmt = {} }
indicator.wmt.__index = indicator

local notification_id = 0

function indicator:toggleKey ( key )
	awful.spawn.easy_async("xdotool key "..key, function (out, err, reason, code)
		if 'exit' == reason and 0 == code then
			self:updateKey(false, key)
		end
	end)
end

function indicator:updateKey ( startup, key )
	awful.spawn.easy_async("xset -q", function (out, err, reason, code)
		for _, k in pairs(self.keys) do
			if k.led then
				local color = '#FF0000FF'
				local led_status = string.match(out, k.led..":([^\\t{0}]+)"):gsub("^%s*(.-)%s*$", "%1")

				if led_status then
					if 'on' == led_status then
						color = '#77FF77FF'
					elseif 'off' == led_status then
						color = '#777777FF'
					end

					if not startup and key and k.key == key then
						notification_id = naughty.notify({
							text = tostring(led_status),
							title = tostring(k.led),
							icon = beautiful.icon_dir..'/key_'..k.key..'_'..led_status..'.png',
							position = "bottom_right",
							ontop = true,
							fg = color,
							bg = "#000000FF",
							border_width = 2,
							border_color = color,
							preset = naughty.config.presets.low,
							replaces_id = notification_id,
						}).id
					end
				end

				self.keywidgets[_]:set_markup('<span color="'..color..'">'..k.name..'</span>')
			else
				self.keywidgets[_]:set_markup('<span>'..k.name..'</span>')
			end
		end
	end)
end

function indicator:statKeyWidget ()
	for _, k in pairs(self.keys) do
		awful.key({}, k.key, function () end, function () self:updateKey(false, k.key) end)

		self.keywidgets[_] = wibox.widget.textbox(k.name)

		self.keywidgets[_]:buttons(awful.util.table.join(
			awful.button({ }, 1, function() self:toggleKey(k.key) end),
			awful.button({ }, 2, function() self:toggleKey(k.key) end)
		))

		if self.dividers.keys then
			self.widget:add(self.dividers.keys)
		end

		self.widget:add(self.keywidgets[_])
	end

	self:updateKey(true)
end

function indicator.new ( args )
	local sw = setmetatable({}, indicator.wmt)

	sw.keywidgets = {}

	sw.cmd = "setxkbmap"
	sw.layouts = args.layouts or {}
	sw.keys = args.keys or {}
	sw.dividers = args.dividers or {}

	sw.index = 1
	sw.current = nil

	sw.widget = wibox.layout.fixed.horizontal()

	sw.layoutwidget = wibox.widget.textbox()
	sw.layoutwidget.set_align("right")

	sw.layoutwidget:buttons(awful.util.table.join(
		awful.button({ }, 1, function() sw:next() end),
		awful.button({ }, 3, function() sw:prev() end),
		awful.button({ }, 4, function() sw:prev() end),
		awful.button({ }, 5, function() sw:next() end)
	))

	sw.widget:add(sw.layoutwidget)

	if sw.dividers.section then
		sw.widget:add(sw.dividers.section)
	end

	sw:statKeyWidget()
--[[
	sw.timer = timer({ timeout = args.timeout or 10 })
	sw.timer:connect_signal("timeout", function() sw:get() end)
	sw.timer:start()
]]
	sw:set(sw.index)

	return sw
end

function indicator:set(i)
	-- set current index
	self.index = ((i-1)+#(self.layouts)) % #(self.layouts) + 1
	self.current = self.layouts[self.index]
	self:update()
	-- execute command
	local cmd
	if self.current.command then
		cmd = self.current.command
	else
		cmd = self.cmd .. " " .. self.current.layout
		if self.current.variant then
			cmd = cmd .. " " .. self.current.variant
		end
	end
	os.execute( cmd )
	os.execute("xmodmap ~/.Xmodmap")
end

function indicator:update()
	-- update layoutwidget text
	local text = "" .. self.current.name .. ""
	if self.current.color and self.current.color ~= nil then
		local w_markup = '<span color="' .. self.current.color .. '">' .. text ..'</span>'
		self.layoutwidget:set_markup(w_markup)
	else
		self.layoutwidget:set_text(text)
	end
end

function indicator:get(i)
	-- parse current layout from setxkbmap
	local status_cmd = io.popen(self.cmd .. " -query")
	local status = status_cmd:read("*a")
	local layout = string.match(status, "layout:([^\n]*)")
	local variant = string.match(status, "variant:([^\n]*)")
	-- find layout in self.layouts
	local index = findindex(self.layouts,
	function (v)
		return v.layout==layout and v.variant == variant
	end)
	if index == nil then
		self.current = {color="yellow"}
		if variant then
			self.current.name = layout.."/"..variant
		else
			self.current.name = layout
		end
	else
		self.index = tonumber(index)
		self.current = self.layouts[index]
	end
	-- update layoutwidget
	self:update()
end

function indicator:next()
	self:set(self.index + 1)
end

function indicator:prev()
	self:set(self.index - 1)
end

function indicator.mt:__call(...)
	return indicator.new(...)
end

return setmetatable(indicator, indicator.mt)
