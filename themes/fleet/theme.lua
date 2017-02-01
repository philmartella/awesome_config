--[[
     Fleet Theme for Awesome WM 4.0
--]]

theme                               = {}
theme.icon_dir                      = os.getenv("HOME") .. "/.config/awesome/themes/fleet/icons"
theme.titlebar_path                 = theme.icon_dir .. "/titlebar/"

-- {{{ Fonts & Colors
theme.wallpaper                     = os.getenv("HOME") .. "/.config/awesome/themes/fleet/wallpaper.png"
theme.font                          = "sans 10"
theme.fg_normal                     = "#FFFFFF"
theme.bg_normal                     = "#000000"
theme.fg_focus                      = "#0099CC"
theme.bg_focus                      = "#000000"
theme.fg_urgent                     = "#CC9393"
theme.bg_urgent                     = "#2A1F1E"
-- }}}

-- {{{ Borders
theme.border_width                  = "1"
theme.border                        = "#0099CC"
theme.border_normal                 = "#ff7700"
theme.border_focus                  = "#0099CC"
-- }}}

-- {{{ Widgets
theme.textbox_widget_margin_top     = 1
theme.awful_widget_height           = 16
theme.awful_widget_margin_top       = 2
theme.widget_bg                     = theme.icon_dir .. "/bg_focus_noline.xpm"
-- }}}

-- {{{ Menu
theme.menu_height                   = "32"
theme.menu_width                    = "200"
theme.submenu_icon                  = theme.icon_dir .. "/submenu.xpm"
theme.menu_fg_focus                 = "#111111"
theme.menu_bg_focus                 = "#0099CC"
theme.menu_fg_normal                = "#EFEFEF"
theme.menu_bg_normal                = "#333333"
theme.menu_border_color             = "#FFFFFF"
theme.menu_border_width             = "2"
-- }}}

-- {{{ Spacers
theme.spr                           = theme.icon_dir .. "/spr.xpm"
theme.spr_small                     = theme.icon_dir .. "/spr_small.xpm"
theme.spr_very_small                = theme.icon_dir .. "/spr_very_small.xpm"
theme.spr_right                     = theme.icon_dir .. "/spr_right.xpm"
theme.spr_left                      = theme.icon_dir .. "/spr_left.xpm"
theme.spr_empty											= theme.icon_dir .. "/spr_empty.xpm"
theme.spr_small_empty								= theme.icon_dir .. "/spr_small_empty.xpm"
theme.last                          = theme.icon_dir .. "/last.xpm"
-- }}}

-- {{{ Widget Icons
theme.awesome_icon                  = theme.icon_dir .. "/awesome_icon.xpm"
theme.application_icon              = theme.icon_dir .. "/application_icon.xpm"
theme.power_icon                    = theme.icon_dir .. "/power.xpm"
theme.keyboard											= theme.icon_dir .. "/keyboard.xpm"
theme.vol_bg                        = theme.icon_dir .. "/vol_bg.xpm"
theme.bar                           = theme.icon_dir .. "/bar.xpm"
theme.bar_empty                     = theme.icon_dir .. "/bar_empty.xpm"
theme.mpd                           = theme.icon_dir .. "/mpd.xpm"
theme.mpd_on                        = theme.icon_dir .. "/mpd_on.xpm"
theme.prev                          = theme.icon_dir .. "/prev.xpm"
theme.nex                           = theme.icon_dir .. "/next.xpm"
theme.stop                          = theme.icon_dir .. "/stop.xpm"
theme.pause                         = theme.icon_dir .. "/pause.xpm"
theme.play                          = theme.icon_dir .. "/play.xpm"
theme.clock                         = theme.icon_dir .. "/clock.xpm"
theme.calendar                      = theme.icon_dir .. "/cal.xpm"
theme.cpu                           = theme.icon_dir .. "/cpu.xpm"
theme.net_up                        = theme.icon_dir .. "/net_up.xpm"
theme.net_down                      = theme.icon_dir .. "/net_down.xpm"
theme.widget_mail_notify            = theme.icon_dir .. "/mail_notify.xpm"
-- }}}

-- {{{ Taglist
theme.taglist_fg_focus              = "#FFFFFF"
theme.taglist_bg_focus              = "png:" .. theme.icon_dir .. "/taglist_bg_focus.png"
theme.taglist_squares_sel           = theme.icon_dir .. "/square_sel.xpm"
theme.taglist_squares_unsel         = theme.icon_dir .. "/square_unsel.xpm"
-- }}}

-- {{{ Layout Icons
theme.layout_tile                   = theme.icon_dir .. "/tile.xpm"
theme.layout_tilegaps               = theme.icon_dir .. "/tilegaps.xpm"
theme.layout_tileleft               = theme.icon_dir .. "/tileleft.xpm"
theme.layout_tilebottom             = theme.icon_dir .. "/tilebottom.xpm"
theme.layout_tiletop                = theme.icon_dir .. "/tiletop.xpm"
theme.layout_fairv                  = theme.icon_dir .. "/fairv.xpm"
theme.layout_fairh                  = theme.icon_dir .. "/fairh.xpm"
theme.layout_spiral                 = theme.icon_dir .. "/spiral.xpm"
theme.layout_dwindle                = theme.icon_dir .. "/dwindle.xpm"
theme.layout_max                    = theme.icon_dir .. "/max.xpm"
theme.layout_fullscreen             = theme.icon_dir .. "/fullscreen.xpm"
theme.layout_magnifier              = theme.icon_dir .. "/magnifier.xpm"
theme.layout_floating               = theme.icon_dir .. "/floating.xpm"
-- }}}

-- {{{ Tasklist
theme.tasklist_bg_normal            = "#000000"
theme.tasklist_fg_focus             = "#4CB7DB"
theme.tasklist_bg_focus             = "png:" .. theme.icon_dir .. "/bg_focus.png"
theme.tasklist_disable_icon         = true
theme.tasklist_maximized            = "⠲"
theme.tasklist_sticky								= "⠶"
theme.tasklist_floating             = "⠺"
-- }}}

-- {{{ Titlebar
--theme.titlebar_bg_focus  = "xpm:" .. theme.titlebar_path .. "bg_left_focus.xpm"
--theme.titlebar_bg_normal = "xpm:" .. theme.titlebar_path .. "bg_left_normal.xpm"
theme.titlebar_bg_focus  = "#000000"
theme.titlebar_bg_normal = "#000000"

theme.titlebar_close_button_focus               = theme.titlebar_path .. "close_focus.xpm"
theme.titlebar_close_button_normal              = theme.titlebar_path .. "close_normal.xpm"

theme.titlebar_ontop_button_focus_active        = theme.titlebar_path .. "ontop_focus_active.xpm"
theme.titlebar_ontop_button_normal_active       = theme.titlebar_path .. "ontop_normal_active.xpm"
theme.titlebar_ontop_button_focus_inactive      = theme.titlebar_path .. "ontop_focus_inactive.xpm"
theme.titlebar_ontop_button_normal_inactive     = theme.titlebar_path .. "ontop_normal_inactive.xpm"

theme.titlebar_sticky_button_focus_active       = theme.titlebar_path .. "sticky_focus_active.xpm"
theme.titlebar_sticky_button_normal_active      = theme.titlebar_path .. "sticky_normal_active.xpm"
theme.titlebar_sticky_button_focus_inactive     = theme.titlebar_path .. "sticky_focus_inactive.xpm"
theme.titlebar_sticky_button_normal_inactive    = theme.titlebar_path .. "sticky_normal_inactive.xpm"

theme.titlebar_floating_button_focus_active     = theme.titlebar_path .. "floating_focus_active.xpm"
theme.titlebar_floating_button_normal_active    = theme.titlebar_path .. "floating_normal_active.xpm"
theme.titlebar_floating_button_focus_inactive   = theme.titlebar_path .. "floating_focus_inactive.xpm"
theme.titlebar_floating_button_normal_inactive  = theme.titlebar_path .. "floating_normal_inactive.xpm"

theme.titlebar_maximized_button_focus_active    = theme.titlebar_path .. "maximized_focus_active.xpm"
theme.titlebar_maximized_button_normal_active   = theme.titlebar_path .. "maximized_normal_active.xpm"
theme.titlebar_maximized_button_focus_inactive  = theme.titlebar_path .. "maximized_focus_inactive.xpm"
theme.titlebar_maximized_button_normal_inactive = theme.titlebar_path .. "maximized_normal_inactive.xpm"

theme.none_normal 									=	theme.titlebar_path .. "none_normal.xpm"
-- }}}

return theme
