---------------------------------------------------------------------------
--- Clientbox widget module for fleet.
---------------------------------------------------------------------------

-- Grab environment we need
local capi = { screen = screen,
               client = client }
local ipairs = ipairs
local setmetatable = setmetatable
local table = table
local common = require("awful.widget.common")
local beautiful = require("beautiful")
local util = require("awful.util")
local tag = require("awful.tag")
local flex = require("wibox.layout.flex")
local timer = require("gears.timer")

local function get_screen(s)
    return s and screen[s]
end

local clientbox = { mt = {} }

local instances

local function clientbox_label(c, args, tb)
    if not args then args = {} end
    local theme = beautiful.get()
    local align = args.align or theme.tasklist_align or "left"
    local fg_normal = util.ensure_pango_color(args.fg_normal or theme.tasklist_fg_normal or theme.fg_normal, "white")
    local bg_normal = args.bg_normal or theme.tasklist_bg_normal or theme.bg_normal or "#000000"
    local fg_focus = util.ensure_pango_color(args.fg_focus or theme.tasklist_fg_focus or theme.fg_focus, fg_normal)
    local bg_focus = args.bg_focus or theme.tasklist_bg_focus or theme.bg_focus or bg_normal
    local fg_urgent = util.ensure_pango_color(args.fg_urgent or theme.tasklist_fg_urgent or theme.fg_urgent, fg_normal)
    local bg_urgent = args.bg_urgent or theme.tasklist_bg_urgent or theme.bg_urgent or bg_normal
    local fg_minimize = util.ensure_pango_color(args.fg_minimize or theme.tasklist_fg_minimize or theme.fg_minimize, fg_normal)
    local bg_minimize = args.bg_minimize or theme.tasklist_bg_minimize or theme.bg_minimize or bg_normal
    local bg_image_normal = args.bg_image_normal or theme.bg_image_normal
    local bg_image_focus = args.bg_image_focus or theme.bg_image_focus
    local bg_image_urgent = args.bg_image_urgent or theme.bg_image_urgent
    local bg_image_minimize = args.bg_image_minimize or theme.bg_image_minimize
    local tasklist_disable_icon = args.tasklist_disable_icon or theme.tasklist_disable_icon or false
    local font = args.font or theme.tasklist_font or theme.font or ""
    local font_focus = args.font_focus or theme.tasklist_font_focus or theme.font_focus or font or ""
    local font_minimized = args.font_minimized or theme.tasklist_font_minimized or theme.font_minimized or font or ""
    local font_urgent = args.font_urgent or theme.tasklist_font_urgent or theme.font_urgent or font or ""
    local text = ""
    local name = ""
    local bg
    local bg_image
    local shape              = args.shape or theme.tasklist_shape
    local shape_border_width = args.shape_border_width or theme.tasklist_shape_border_width
    local shape_border_color = args.shape_border_color or theme.tasklist_shape_border_color

    tb:set_align(align)

    name = name .. (util.escape(c.name) or util.escape("<untitled>"))

    local focused = capi.client.focus == c
    -- Handle transient_for: the first parent that does not skip the taskbar
    -- is considered to be focused, if the real client has skip_taskbar.
    if not focused and capi.client.focus and capi.client.focus.skip_taskbar
        and capi.client.focus:get_transient_for_matching(function(cl) return not cl.skip_taskbar end) == c then
        focused = true
    end

    if focused then
        bg = bg_focus
        text = text .. "<span color='"..fg_focus.."'>"..name.."</span>"
        bg_image = bg_image_focus
        font = font_focus

        if args.shape_focus or theme.tasklist_shape_focus then
            shape = args.shape_focus or theme.tasklist_shape_focus
        end

        if args.shape_border_width_focus or theme.tasklist_shape_border_width_focus then
            shape_border_width = args.shape_border_width_focus or theme.tasklist_shape_border_width_focus
        end

        if args.shape_border_color_focus or theme.tasklist_shape_border_color_focus then
            shape_border_color = args.shape_border_color_focus or theme.tasklist_shape_border_color_focus
        end
    elseif c.urgent then
        bg = bg_urgent
        text = text .. "<span color='"..fg_urgent.."'>"..name.."</span>"
        bg_image = bg_image_urgent
        font = font_urgent

        if args.shape_urgent or theme.tasklist_shape_urgent then
            shape = args.shape_urgent or theme.tasklist_shape_urgent
        end

        if args.shape_border_width_urgent or theme.tasklist_shape_border_width_urgent then
            shape_border_width = args.shape_border_width_urgent or theme.tasklist_shape_border_width_urgent
        end

        if args.shape_border_color_urgent or theme.tasklist_shape_border_color_urgent then
            shape_border_color = args.shape_border_color_urgent or theme.tasklist_shape_border_color_urgent
        end
    else
        bg = bg_normal
        text = text .. "<span color='"..fg_normal.."'>"..name.."</span>"
        bg_image = bg_image_normal
    end

    tb:set_font(font)

    local other_args = {
        shape              = shape,
        shape_border_width = shape_border_width,
        shape_border_color = shape_border_color,
    }

    return text, bg, bg_image, not tasklist_disable_icon and c.icon or nil, other_args
end

local function tasklist_update(s, w, buttons, filter, data, style, update_function)
    local clients = {}
    for _, c in ipairs(capi.client.get()) do
        if not (c.skip_taskbar or c.hidden
            or c.type == "splash" or c.type == "dock" or c.type == "desktop")
            and filter(c, s) then
            table.insert(clients, c)
        end
    end

    local function label(c, tb) return tasklist_label(c, style, tb) end

    update_function(w, buttons, label, data, clients)
end

--- Create a new tasklist widget. The last two arguments (update_function
-- and base_widget) serve to customize the layout of the tasklist (eg. to
-- make it vertical). For that, you will need to copy the
-- awful.widget.common.list_update function, make your changes to it
-- and pass it as update_function here. Also change the base_widget if the
-- default is not what you want.
-- @param screen The screen to draw tasklist for.
-- @param filter Filter function to define what clients will be listed.
-- @param buttons A table with buttons binding to set.
-- @tparam[opt={}] table style The style overrides default theme.
-- @tparam[opt=nil] string|pattern style.fg_normal
-- @tparam[opt=nil] string|pattern style.bg_normal
-- @tparam[opt=nil] string|pattern style.fg_focus
-- @tparam[opt=nil] string|pattern style.bg_focus
-- @tparam[opt=nil] string|pattern style.fg_urgent
-- @tparam[opt=nil] string|pattern style.bg_urgent
-- @tparam[opt=nil] string|pattern style.fg_minimize
-- @tparam[opt=nil] string|pattern style.bg_minimize
-- @tparam[opt=nil] string style.bg_image_normal
-- @tparam[opt=nil] string style.bg_image_focus
-- @tparam[opt=nil] string style.bg_image_urgent
-- @tparam[opt=nil] string style.bg_image_minimize
-- @tparam[opt=nil] boolean style.tasklist_disable_icon
-- @tparam[opt=nil] string style.font
-- @tparam[opt=left] string style.align *left*, *right* or *center*
-- @tparam[opt=nil] string style.font_focus
-- @tparam[opt=nil] string style.font_minimized
-- @tparam[opt=nil] string style.font_urgent
-- @tparam[opt=nil] number style.spacing The spacing between tags.
-- @tparam[opt=nil] gears.shape style.shape
-- @tparam[opt=nil] number style.shape_border_width
-- @tparam[opt=nil] string|color style.shape_border_color
-- @tparam[opt=nil] gears.shape style.shape_focus
-- @tparam[opt=nil] number style.shape_border_width_focus
-- @tparam[opt=nil] string|color style.shape_border_color_focus
-- @tparam[opt=nil] gears.shape style.shape_minimized
-- @tparam[opt=nil] number style.shape_border_width_minimized
-- @tparam[opt=nil] string|color style.shape_border_color_minimized
-- @tparam[opt=nil] gears.shape style.shape_urgent
-- @tparam[opt=nil] number style.shape_border_width_urgent
-- @tparam[opt=nil] string|color style.shape_border_color_urgent
-- @param[opt] update_function Function to create a tag widget on each
--   update. See `awful.widget.common.list_update`.
-- @tparam[opt] table base_widget Container widget for tag widgets. Default
--   is `wibox.layout.flex.horizontal`.
-- @function awful.tasklist
function tasklist.new(screen, filter, buttons, style, update_function, base_widget)
    screen = get_screen(screen)
    local uf = update_function or common.list_update
    local w = base_widget or flex.horizontal()

    local data = setmetatable({}, { __mode = 'k' })

    if w.set_spacing and (style and style.spacing or beautiful.taglist_spacing) then
        w:set_spacing(style and style.spacing or beautiful.taglist_spacing)
    end

    local queued_update = false
    function w._do_tasklist_update()
        -- Add a delayed callback for the first update.
        if not queued_update then
            timer.delayed_call(function()
                queued_update = false
                if screen.valid then
                    tasklist_update(screen, w, buttons, filter, data, style, uf)
                end
            end)
            queued_update = true
        end
    end
    function w._unmanage(c)
        data[c] = nil
    end
    if instances == nil then
        instances = setmetatable({}, { __mode = "k" })
        local function us(s)
            local i = instances[get_screen(s)]
            if i then
                for _, tlist in pairs(i) do
                    tlist._do_tasklist_update()
                end
            end
        end
        local function u()
            for s in pairs(instances) do
                if s.valid then
                    us(s)
                end
            end
        end

        tag.attached_connect_signal(nil, "property::selected", u)
        tag.attached_connect_signal(nil, "property::activated", u)
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
        capi.client.connect_signal("property::skip_taskbar", u)
        capi.client.connect_signal("property::screen", function(c, old_screen)
            us(c.screen)
            us(old_screen)
        end)
        capi.client.connect_signal("property::hidden", u)
        capi.client.connect_signal("tagged", u)
        capi.client.connect_signal("untagged", u)
        capi.client.connect_signal("unmanage", function(c)
            u(c)
            for _, i in pairs(instances) do
                for _, tlist in pairs(i) do
                    tlist._unmanage(c)
                end
            end
        end)
        capi.client.connect_signal("list", u)
        capi.client.connect_signal("focus", u)
        capi.client.connect_signal("unfocus", u)
        capi.screen.connect_signal("removed", function(s)
            instances[get_screen(s)] = nil
        end)
    end
    w._do_tasklist_update()
    local list = instances[screen]
    if not list then
        list = setmetatable({}, { __mode = "v" })
        instances[screen] = list
    end
    table.insert(list, w)
    return w
end

function tasklist.mt:__call(...)
    return tasklist.new(...)
end

return setmetatable(tasklist, tasklist.mt)

