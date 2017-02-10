local theme = {}

--{{{ Default variable
theme.font                     = 'sans 10'
theme.wallpaper                = nil
theme.thickness                = 5
theme.bg_normal                = '#000000FF'
theme.bg_focus                 = '#000000FF'
theme.bg_minimize              = '#000000FF'
theme.bg_urgent                = '#FF0000FF'
theme.fg_normal                = '#FFFFFFFF'
theme.fg_focus                 = '#FFFFFFFF'
theme.fg_minimize              = '#FFFFFFFF'
theme.fg_urgent                = '#000000FF'
theme.border_normal            = '#ff7700FF'
theme.border_focus             = '#0099CCFF'
theme.border_marked            = nil
theme.border_width             = 1
theme.useless_gap              = 0
theme.gap_single_client        = false
theme.column_count             = nil
--}}}

--{{{ cursor
theme.cursor_mouse_resize = nil
theme.cursor_mouse_move = nil
--}}}

--{{{ snap
theme.snap_bg = nil
theme.snap_border_width = nil
theme.snap_shape = nil
--}}}

--{{{ icon
theme.icon_theme = nil
--}}}

--{{{ awesome
theme.awesome_icon = nil
--}}}

--{{{ layout
theme.layout_fairh = nil
theme.layout_fairv = nil
theme.layout_magnifier = nil
theme.layout_cornernw = nil
theme.layout_cornerne = nil
theme.layout_cornersw = nil
theme.layout_cornerse = nil
theme.layout_spiral = nil
theme.layout_dwindle = nil
theme.layout_tile = nil
theme.layout_tiletop = nil
theme.layout_tilebottom = nil
theme.layout_tileleft = nil
theme.layout_floating = nil
theme.layout_max = nil
theme.layout_fullscreen = nil
--}}}

--{{{ menu
theme.menu_submenu_icon = nil
theme.menu_height = nil
theme.menu_width = nil
theme.menu_border_color = nil
theme.menu_border_width = nil
theme.menu_fg_focus = nil
theme.menu_bg_focus = nil
theme.menu_fg_normal = nil
theme.menu_bg_normal = nil
theme.menu_submenu = nil
--}}}

--{{{ systray
theme.bg_systray               = '#000000'
theme.systray_icon_spacing     = nil
--}}}

--{{{ taglist
theme.taglist_fg_focus = nil
theme.taglist_bg_focus = nil
theme.taglist_fg_urgent = nil
theme.taglist_bg_urgent = nil
theme.taglist_bg_occupied = nil
theme.taglist_fg_occupied = nil
theme.taglist_bg_empty = nil
theme.taglist_fg_empty = nil
theme.taglist_squares_sel = nil
theme.taglist_squares_unsel = nil
theme.taglist_squares_sel_empty = nil
theme.taglist_squares_unsel_empty = nil
theme.taglist_squares_resize = nil
theme.taglist_disable_icon = nil
theme.taglist_font = nil
theme.taglist_shape = nil
theme.taglist_shape_border_width = nil
theme.taglist_shape_border_color = nil
theme.taglist_shape_empty = nil
theme.taglist_shape_border_width_empty = nil
theme.taglist_shape_border_color_empty = nil
theme.taglist_shape_focus = nil
theme.taglist_shape_border_width_focus = nil
theme.taglist_shape_border_color_focus = nil
theme.taglist_shape_urgent = nil
theme.taglist_shape_border_width_urgent = nil
theme.taglist_shape_border_color_urgent = nil
--}}}

--{{{ tasklist
theme.tasklist_fg_normal = nil
theme.tasklist_bg_normal = nil
theme.tasklist_fg_focus = nil
theme.tasklist_bg_focus = nil
theme.tasklist_fg_urgent = nil
theme.tasklist_bg_urgent = nil
theme.tasklist_fg_minimize = nil
theme.tasklist_bg_minimize = nil
theme.tasklist_bg_image_normal = nil
theme.tasklist_bg_image_focus = nil
theme.tasklist_bg_image_urgent = nil
theme.tasklist_bg_image_minimize = nil
theme.tasklist_tasklist_disable_icon = nil
theme.tasklist_plain_task_name = nil
theme.tasklist_font = nil
theme.tasklist_align = nil
theme.tasklist_font_focus = nil
theme.tasklist_font_minimized = nil
theme.tasklist_font_urgent = nil
theme.tasklist_spacing = nil
theme.tasklist_shape = nil
theme.tasklist_shape_border_width = nil
theme.tasklist_shape_border_color = nil
theme.tasklist_shape_focus = nil
theme.tasklist_shape_border_width_focus = nil
theme.tasklist_shape_border_color_focus = nil
theme.tasklist_shape_minimized = nil
theme.tasklist_shape_border_width_minimized = nil
theme.tasklist_shape_border_color_minimized = nil
theme.tasklist_shape_urgent = nil
theme.tasklist_shape_border_width_urgent = nil
theme.tasklist_shape_border_color_urgent = nil
--}}}

--{{{ titlebar
theme.titlebar_fg_normal = nil
theme.titlebar_bg_normal = nil
theme.titlebar_bgimage_normal = nil
theme.titlebar_fg = nil
theme.titlebar_bg = nil
theme.titlebar_bgimage = nil
theme.titlebar_fg_focus = nil
theme.titlebar_bg_focus = nil
theme.titlebar_bgimage_focus = nil
theme.titlebar_floating_button_normal = nil
theme.titlebar_maximized_button_normal = nil
theme.titlebar_minimize_button_normal = nil
theme.titlebar_close_button_normal = nil
theme.titlebar_ontop_button_normal = nil
theme.titlebar_sticky_button_normal = nil
theme.titlebar_floating_button_focus = nil
theme.titlebar_maximized_button_focus = nil
theme.titlebar_minimize_button_focus = nil
theme.titlebar_close_button_focus = nil
theme.titlebar_ontop_button_focus = nil
theme.titlebar_sticky_button_focus = nil
theme.titlebar_floating_button_normal_active = nil
theme.titlebar_maximized_button_normal_active = nil
theme.titlebar_ontop_button_normal_active = nil
theme.titlebar_sticky_button_normal_active = nil
theme.titlebar_floating_button_focus_active = nil
theme.titlebar_maximized_button_focus_active = nil
theme.titlebar_ontop_button_focus_active = nil
theme.titlebar_sticky_button_focus_active = nil
theme.titlebar_floating_button_normal_inactive = nil
theme.titlebar_maximized_button_normal_inactive = nil
theme.titlebar_ontop_button_normal_inactive = nil
theme.titlebar_sticky_button_normal_inactive = nil
theme.titlebar_floating_button_focus_inactive = nil
theme.titlebar_maximized_button_focus_inactive = nil
theme.titlebar_ontop_button_focus_inactive = nil
theme.titlebar_sticky_button_focus_inactive = nil
--}}}

--{{{ tooltip
theme.tooltip_border_color = nil
theme.tooltip_bg = nil
theme.tooltip_fg = nil
theme.tooltip_font = nil
theme.tooltip_border_width = nil
theme.tooltip_opacity = nil
theme.tooltip_shape = nil
theme.tooltip_align = nil
--}}}

--{{{ master
theme.master_width_factor = nil
theme.master_fill_policy = nil
theme.master_count = nil
--}}}

--{{{ arcchart
theme.arcchart_border_color = nil
theme.arcchart_color = nil
theme.arcchart_border_width = nil
theme.arcchart_paddings = nil
--}}}

--{{{ checkbox
theme.checkbox_border_width = nil
theme.checkbox_bg = nil
theme.checkbox_border_color = nil
theme.checkbox_check_border_color = nil
theme.checkbox_check_border_width = nil
theme.checkbox_check_color = nil
theme.checkbox_shape = nil
theme.checkbox_check_shape = nil
theme.checkbox_paddings = nil
theme.checkbox_color = nil
--}}}

--{{{ graph
theme.graph_bg = nil
theme.graph_fg = nil
theme.graph_border_color = nil
--}}}

--{{{ piechart
theme.piechart_border_color = nil
theme.piechart_border_width = nil
theme.piechart_colors = nil
--}}}

--{{{ progressbar
theme.progressbar_bg = nil
theme.progressbar_fg = nil
theme.progressbar_shape = nil
theme.progressbar_border_color = nil
theme.progressbar_border_width = nil
theme.progressbar_bar_shape = nil
theme.progressbar_bar_border_width = nil
theme.progressbar_bar_border_color = nil
theme.progressbar_margins = nil
theme.progressbar_paddings = nil
--}}}

--{{{ radialprogressbar
theme.radialprogressbar_border_color = nil
theme.radialprogressbar_color = nil
theme.radialprogressbar_border_width = nil
theme.radialprogressbar_paddings = nil
--}}}

--{{{ slider
theme.slider_bar_border_width = nil
theme.slider_bar_border_color = nil
theme.slider_handle_border_color = nil
theme.slider_handle_border_width = nil
theme.slider_handle_width = nil
theme.slider_handle_color = nil
theme.slider_handle_shape = nil
theme.slider_bar_shape = nil
theme.slider_bar_height = nil
theme.slider_bar_margins = nil
theme.slider_handle_margins = nil
theme.slider_bar_color = nil
--}}}

return theme
