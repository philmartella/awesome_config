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

--- Client count widget.
local clientcountbox = { mt = {} }

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

--- Create a clientcountbox widget.
-- @param screen The screen number that the layout will be represented for.
-- @return textbox with number of clients on screen
function clientcountbox.new ( s )
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

function clientcountbox.mt:__call(...)
    return clientcountbox.new(...)
end

return setmetatable(clientcountbox, clientcountbox.mt)

