---------------------------------------------------------------------------
--- Client Control for fleet.
---------------------------------------------------------------------------

local error = error
local type = type
local util = require("awful.util")
local wibox = require("wibox")
local beautiful = require("beautiful")

local clientcontrol = {
	widget = {}
}

--- Show tooltips when hover on client control buttons (defaults to 'true')
clientcontrol.enable_tooltip = true

local all_clientcontrols = setmetatable({}, { __mode = 'k' })

local function new(s, args)
	local args = args or {}
	local sw = {
		widget = clientcontrol.widget
	}

		-- Update the colors when focus changes
		--c:connect_signal("focus", update_colors)
		--c:connect_signal("unfocus", update_colors)

		-- Inform the drawable when it becomes invisible
		--c:connect_signal("unmanage", function() ret:_inform_visible(false) end)

	return sw
end

function clientcontrol.widget.button (name)
	local button = wibox.widget.imagebox()
	button:set_image(beautiful.none_normal)

	return button
end

function clientcontrol.widget.closebutton ()
	local widget = clientcontrol.widget.button("close")
	return widget
end

function clientcontrol.widget.floatingbutton ()
    local widget = clientcontrol.widget.button("floating")
    --c:connect_signal("property::floating", widget.update)
    return widget
end

function clientcontrol.widget.maximizedbutton ()
    local widget = clientcontrol.widget.button("maximized")
    --c:connect_signal("property::maximized_vertical", widget.update)
    --c:connect_signal("property::maximized_horizontal", widget.update)
    return widget
end

function clientcontrol.widget.minimizebutton ()
    local widget = clientcontrol.widget.button("minimize")
    --c:connect_signal("property::minimized", widget.update)
    return widget
end

function clientcontrol.widget.ontopbutton ()
    local widget = clientcontrol.widget.button("ontop")
    --c:connect_signal("property::ontop", widget.update)
    return widget
end

function clientcontrol.widget.stickybutton ()
    local widget = clientcontrol.widget.button("sticky")
    --c:connect_signal("property::sticky", widget.update)
    return widget
end

function clientcontrol.widget.title ()
	local myclientname = wibox.widget.textbox()
	myclientname:set_align("right")
	myclientname:set_ellipsize("middle")
	myclientname:set_wrap("WORD")
	--myclientname:set_forced_width(200)
	myclientname:set_markup('<span foreground="red">~</span>')

	return myclientname
end

function clientcontrol.widget.class ()
end

function clientcontrol.widget.icon ()
	local myclienticon = wibox.widget.imagebox()
	myclienticon:set_image(beautiful.application_icon)

	return myclienticon
end

return setmetatable(clientcontrol, { __call = function(_, ...) return new(...) end})

