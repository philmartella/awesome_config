
local	icon_dir = os.getenv("HOME") .. "/.config/awesome/themes/fleet/icons/"
local layout_icon_dir = icon_dir .. "layout/"
local titlebar_icon_dir = icon_dir .. "titlebar/"
local widget_icon_dir = icon_dir .. "widget/"
local tag_icon_dir = icon_dir .. "tag/"

local theme = {}
theme.icon_dir                              = icon_dir

--{{{ Default variable
theme.bar                                   = icon_dir .. "bar.xpm"
theme.none_normal                           =	titlebar_icon_dir .. "none_normal.xpm"

theme.font                                  = 'sans 10'
theme.wallpaper                             = os.getenv("HOME") .. "/.config/awesome/wallpaper.png"
theme.icon_theme                            = nil
theme.thickness                             = 5
theme.bg_normal                             = "#31393E"
theme.bg_focus                              = "#31393E"
theme.bg_minimize                           = "#000000"
theme.bg_urgent                             = "#FF0000"
theme.fg_normal                             = "#FFFFFF"
theme.fg_focus                              = "#FFFFFF"
theme.fg_minimize                           = "#FFFFFF"
theme.fg_urgent                             = "#000000"
theme.border_normal                         = "#FF7700"
theme.border_focus                          = "#0099CC"
theme.border_marked                         = nil
theme.border_width                          = 1
theme.useless_gap                           = 0
theme.gap_single_client                     = false
theme.column_count                          = nil
--}}}

--{{{ cursor
theme.cursor_mouse_resize                   = nil
theme.cursor_mouse_move                     = nil
--}}}

--{{{ snap
theme.snap_bg                               = "#0099CC77"
theme.snap_border_width                     = 10
theme.snap_shape                            = nil
--}}}

--{{{ menu
theme.submenu_icon                          = theme.icon_dir .. "submenu.xpm"
theme.menu_height                           = "32"
theme.menu_width                            = "200"
theme.menu_border_color                     = "#FFFFFF"
theme.menu_border_width                     = "2"
theme.menu_fg_focus                         = "#111111"
theme.menu_bg_focus                         = "#0099CC"
theme.menu_fg_normal                        = "#EFEFEF"
theme.menu_bg_normal                        = "#31393E"
theme.menu_submenu                          = nil
--}}}

--{{{ systray
theme.bg_systray                            = "#31393E"
theme.systray_icon_spacing                  = 4
--}}}

--{{{ taglist
theme.taglist_fg_focus                      = "#FFFFFF"
theme.taglist_bg_focus                      = "png:" .. icon_dir .. "taglist_bg_focus.png"
theme.taglist_fg_urgent                     = "#000000"
theme.taglist_bg_urgent                     = "#FF0000"
theme.taglist_bg_occupied                   = "transparent"
theme.taglist_fg_occupied                   = "#FFFFFF"
theme.taglist_bg_empty                      = "transparent"
theme.taglist_fg_empty                      = "#FFFFFF"
theme.taglist_squares_sel                   = theme.icon_dir .. "square_sel.xpm"
theme.taglist_squares_unsel                 = theme.icon_dir .. "square_unsel.xpm"
theme.taglist_squares_sel_empty             = nil
theme.taglist_squares_unsel_empty           = nil
theme.taglist_squares_resize                = false
theme.taglist_disable_icon                  = false
theme.taglist_font                          = nil
theme.taglist_shape                         = nil
theme.taglist_shape_border_width            = nil
theme.taglist_shape_border_color            = nil
theme.taglist_shape_empty                   = nil
theme.taglist_shape_border_width_empty      = nil
theme.taglist_shape_border_color_empty      = nil
theme.taglist_shape_focus                   = nil
theme.taglist_shape_border_width_focus      = nil
theme.taglist_shape_border_color_focus      = nil
theme.taglist_shape_urgent                  = nil
theme.taglist_shape_border_width_urgent     = nil
theme.taglist_shape_border_color_urgent     = nil
--}}}

--{{{ layout
theme.layout_fairh                          = layout_icon_dir .. "fairh.xpm"
theme.layout_fairv                          = layout_icon_dir .. "fairv.xpm"
theme.layout_magnifier                      = layout_icon_dir .. "magnifier.xpm"
theme.layout_cornernw                       = nil
theme.layout_cornerne                       = nil
theme.layout_cornersw                       = nil
theme.layout_cornerse                       = nil
theme.layout_spiral                         = layout_icon_dir .. "spiral.xpm"
theme.layout_dwindle                        = layout_icon_dir .. "dwindle.xpm"
theme.layout_tile                           = layout_icon_dir .. "tile.xpm"
theme.layout_tiletop                        = layout_icon_dir .. "tiletop.xpm"
theme.layout_tilebottom                     = layout_icon_dir .. "tilebottom.xpm"
theme.layout_tileleft                       = layout_icon_dir .. "tileleft.xpm"
theme.layout_floating                       = layout_icon_dir .. "floating.xpm"
theme.layout_max                            = layout_icon_dir .. "max.xpm"
theme.layout_fullscreen                     = nil
--}}}

--{{{ tasklist
theme.tasklist_fg_normal                    = "#777777"
theme.tasklist_bg_normal                    = "transparent"
theme.tasklist_fg_focus                     = "#FFFFFF"
theme.tasklist_bg_focus                     = "transparent"
theme.tasklist_fg_urgent                    = "#000000"
theme.tasklist_bg_urgent                    = "#FF0000"
theme.tasklist_fg_minimize                  = nil
theme.tasklist_bg_minimize                  = nil
theme.tasklist_bg_image_normal              = nil
theme.tasklist_bg_image_focus               = nil
theme.tasklist_bg_image_urgent              = nil
theme.tasklist_bg_image_minimize            = nil
theme.tasklist_tasklist_disable_icon        = true
theme.tasklist_plain_task_name              = nil
theme.tasklist_font                         = nil
theme.tasklist_align                        = nil
theme.tasklist_font_focus                   = nil
theme.tasklist_font_minimized               = nil
theme.tasklist_font_urgent                  = nil
theme.tasklist_spacing                      = nil
theme.tasklist_shape                        = nil
theme.tasklist_shape_border_width           = nil
theme.tasklist_shape_border_color           = nil
theme.tasklist_shape_focus                  = nil
theme.tasklist_shape_border_width_focus     = nil
theme.tasklist_shape_border_color_focus     = nil
theme.tasklist_shape_minimized              = nil
theme.tasklist_shape_border_width_minimized = nil
theme.tasklist_shape_border_color_minimized = nil
theme.tasklist_shape_urgent                 = nil
theme.tasklist_shape_border_width_urgent    = nil
theme.tasklist_shape_border_color_urgent    = nil
--}}}

--{{{ titlebar
theme.titlebar_fg_normal                         = "#777777"
theme.titlebar_bg_normal                         = "#31393E"
theme.titlebar_bgimage_normal                    = nil
theme.titlebar_fg                                = "#FFFFFF"
theme.titlebar_bg                                = "#31393E"
theme.titlebar_bgimage                           = nil
theme.titlebar_fg_focus                          = "#FFFFFF"
theme.titlebar_bg_focus                          = "#31393E"
theme.titlebar_bgimage_focus                     = nil
theme.titlebar_floating_button_normal            = titlebar_icon_dir .. "floating_normal_inactive.xpm"
theme.titlebar_maximized_button_normal           = titlebar_icon_dir .. "maximized_normal_inactive.xpm"
theme.titlebar_minimize_button_normal            = titlebar_icon_dir .. "minimize_normal.xpm"
theme.titlebar_close_button_normal               = titlebar_icon_dir .. "close_normal.xpm"
theme.titlebar_ontop_button_normal               = titlebar_icon_dir .. "ontop_normal_inactive.xpm"
theme.titlebar_sticky_button_normal              = titlebar_icon_dir .. "sticky_normal_inactive.xpm"
theme.titlebar_floating_button_focus             = titlebar_icon_dir .. "floating_focus_inactive.xpm"
theme.titlebar_maximized_button_focus            = titlebar_icon_dir .. "maximized_focus_inactive.xpm"
theme.titlebar_minimize_button_focus             = titlebar_icon_dir .. "minimize_focus.xpm"
theme.titlebar_close_button_focus                = titlebar_icon_dir .. "close_focus.xpm"
theme.titlebar_ontop_button_focus                = titlebar_icon_dir .. "ontop_focus_inactive.xpm"
theme.titlebar_sticky_button_focus               = titlebar_icon_dir .. "sticky_focus_inactive.xpm"
theme.titlebar_floating_button_normal_active     = titlebar_icon_dir .. "floating_normal_active.xpm"
theme.titlebar_maximized_button_normal_active    = titlebar_icon_dir .. "maximized_normal_active.xpm"
theme.titlebar_ontop_button_normal_active        = titlebar_icon_dir .. "ontop_normal_active.xpm"
theme.titlebar_sticky_button_normal_active       = titlebar_icon_dir .. "sticky_normal_active.xpm"
theme.titlebar_floating_button_focus_active      = titlebar_icon_dir .. "floating_focus_active.xpm"
theme.titlebar_maximized_button_focus_active     = titlebar_icon_dir .. "maximized_focus_active.xpm"
theme.titlebar_ontop_button_focus_active         = titlebar_icon_dir .. "ontop_focus_active.xpm"
theme.titlebar_sticky_button_focus_active        = titlebar_icon_dir .. "sticky_focus_active.xpm"
theme.titlebar_floating_button_normal_inactive   = titlebar_icon_dir .. "floating_normal_inactive.xpm"
theme.titlebar_maximized_button_normal_inactive  = titlebar_icon_dir .. "maximized_normal_inactive.xpm"
theme.titlebar_ontop_button_normal_inactive      = titlebar_icon_dir .. "ontop_normal_inactive.xpm"
theme.titlebar_sticky_button_normal_inactive     = titlebar_icon_dir .. "sticky_normal_inactive.xpm"
theme.titlebar_floating_button_focus_inactive    = titlebar_icon_dir .. "floating_focus_inactive.xpm"
theme.titlebar_maximized_button_focus_inactive   = titlebar_icon_dir .. "maximized_focus_inactive.xpm"
theme.titlebar_ontop_button_focus_inactive       = titlebar_icon_dir .. "ontop_focus_inactive.xpm"
theme.titlebar_sticky_button_focus_inactive      = titlebar_icon_dir .. "sticky_focus_inactive.xpm"
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
theme.progressbar_bg                        = "#222222FF"
theme.progressbar_fg                        = "#81B7E1FF"
theme.progressbar_shape                     = nil
theme.progressbar_border_color              = "#777777FF"
theme.progressbar_border_width              = nil
theme.progressbar_bar_shape                 = nil
theme.progressbar_bar_border_width          = nil
theme.progressbar_bar_border_color          = "#AAAAAAFF"
theme.progressbar_margins                   = nil
theme.progressbar_paddings                  = nil
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

--{{{ icons
theme.awesome_icon                               = widget_icon_dir .. "awesome_icon.xpm"
theme.application_icon                           = widget_icon_dir .. "application_icon.xpm"
theme.power_icon                                 = widget_icon_dir .. "power.xpm"
theme.keyboard_icon								               = widget_icon_dir .. "keyboard.xpm"
theme.mpd_icon                                   = widget_icon_dir .. "mpd.xpm"
theme.mpd_on_icon                                = widget_icon_dir .. "mpd_on.xpm"
theme.prev_icon                                  = widget_icon_dir .. "prev.xpm"
theme.next_icon                                  = widget_icon_dir .. "next.xpm"
theme.stop_icon                                  = widget_icon_dir .. "stop.xpm"
theme.pause_icon                                 = widget_icon_dir .. "pause.xpm"
theme.play_icon                                  = widget_icon_dir .. "play.xpm"
theme.clock_icon                                 = widget_icon_dir .. "clock.xpm"
theme.calendar_icon                              = widget_icon_dir .. "calendar.xpm"
theme.cpu_icon                                   = widget_icon_dir .. "cpu.xpm"
theme.mem_icon                                   = widget_icon_dir .. "mem.xpm"
theme.hdd_icon                                   = widget_icon_dir .. "hdd.xpm"
theme.net_up_icon                                = widget_icon_dir .. "net_up.xpm"
theme.net_down_icon                              = widget_icon_dir .. "net_down.xpm"
theme.mail_notify_icon                           = widget_icon_dir .. "mail_notify.xpm"
--}}}

--{{{ tag icons
theme.tag_icon = {}
theme.tag_icon[1]                                = tag_icon_dir .. "1.png"
theme.tag_icon[2]                                = tag_icon_dir .. "2.png"
theme.tag_icon[3]                                = tag_icon_dir .. "3.png"
theme.tag_icon[4]                                = tag_icon_dir .. "4.png"
theme.tag_icon[5]                                = tag_icon_dir .. "5.png"
theme.tag_icon[6]                                = tag_icon_dir .. "6.png"
theme.tag_icon[7]                                = tag_icon_dir .. "7.png"
theme.tag_icon[8]                                = tag_icon_dir .. "8.png"
theme.tag_icon[9]                                = tag_icon_dir .. "9.png"
theme.tag_icon[10]                               = tag_icon_dir .. "10.png"
theme.tag_icon[11]                               = tag_icon_dir .. "11.png"
theme.tag_icon[12]                               = tag_icon_dir .. "12.png"
theme.tag_icon[13]                               = tag_icon_dir .. "13.png"
theme.tag_icon[14]                               = tag_icon_dir .. "14.png"
theme.tag_icon[15]                               = tag_icon_dir .. "15.png"
theme.tag_icon[16]                               = tag_icon_dir .. "16.png"
theme.tag_icon[17]                               = tag_icon_dir .. "17.png"
theme.tag_icon[18]                               = tag_icon_dir .. "18.png"
theme.tag_icon[19]                               = tag_icon_dir .. "19.png"
theme.tag_icon[20]                               = tag_icon_dir .. "20.png"
--}}}

return theme
