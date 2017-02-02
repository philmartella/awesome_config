---------------------------------------------------------------------------
-- @author Phil Martella
-- @copyright 2016 Phil Martella
-- @release v1.0.1
---------------------------------------------------------------------------

-- Grab environment we need
local setmetatable = setmetatable
local pairs = pairs
local ipairs = ipairs
local wibox = require("wibox")
local awful = require("awful")
local tag = require("awful.tag")
local beautiful = require("beautiful")
local naughty = require("naughty")

-- client.mt: module (class) metatable
-- client.wmt: widget (instance) metatable
local client = { mt = {}, wmt = {} }
client.wmt.__index = tag

function client.focusbyidx (inc)
	awful.client.focus.byidx(inc)
	if client.focus then
		client.focus:raise()
	end
end

function client.focusnext ()
	client.focusbyidx(1)
end

function client.focusprev ()
	client.focusbyidx(-1)
end

--- Create a clientcountbox widget.
-- @param screen The screen number that the layout will be represented for.
-- @return textbox with number of clients on screen
--[[
function client.countbox.new ( s )
	local s = s or 1
	local w = wibox.widget.textbox()

	update(w, s)

	local function update_on_tag_selection ( t )
		return update(w, awful.tag.getscreen(t))
	end

	local function update_on_screen_arrange ( screen )
		return update(w, screen.index)
	end

	awful.tag.attached_connect_signal(s, "property::selected", update_on_tag_selection)
	screen[s]:connect_signal("arrange", update_on_screen_arrange)

	return w
end

local function update ( w, s )
    if w and s then
        local count = 0
        local tags = awful.tag.selectedlist(s)

        for _, t in pairs(tags) do
            count = count + #t.clients(t)
        end

        w:set_text(count)
    end
end

function client.mt:__call(...)
	return client.countbox.new(...)
end
--]]

return setmetatable(client, client.mt)
