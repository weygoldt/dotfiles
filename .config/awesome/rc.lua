-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

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
local hotkeys_popup = require("awful.hotkeys_popup")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
local theme = require("theme")

-- local brightness_widget = require("awesome-wm-widgets.brightness-widget.brightness")
local logout_menu_widget = require("awesome-wm-widgets.logout-menu-widget.logout-menu")
-- local volume_widget = require('awesome-wm-widgets.pactl-widget.volume')

-- ERROR HANDLING

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
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err) })
        in_error = false
    end)
end


-- VARIABLE DEFINITIONS
-- Themes define colours, icons, font and wallpapers.
beautiful.init("~/.config/awesome/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor
browser = "firefox"
files = "ranger"
mail = "thunderbird"
colorpicker = "gpick -p"
screenshot = "scrot -s"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.fair,
    awful.layout.suit.floating,
    awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}



-- RIGHT CLICK MENU -----------------------------------------------------------

-- Create a launcher widget and a main menu
myawesomemenu = {
    { "Hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "Manual", terminal .. " -e man awesome" },
    { "Edit config", editor_cmd .. " " .. awesome.conffile },
    { "Restart", awesome.restart },
    { "Quit", function() awesome.quit() end },
}

-- coustom color theme for right click menu
beautiful.menu_bg_normal = "#191724"
beautiful.menu_bg_focus = "#191724"
beautiful.menu_fg_normal = "#908caa"
beautiful.menu_fg_focus = "#e0def4"
beautiful.menu_height = 20
beautiful.menu_width = 200

mymainmenu = awful.menu({ items = { { "Awesome", myawesomemenu, beautiful.awesome_icon },
    { "Open terminal", terminal },
    { "Browser", browser },
    { "Files", files }
}
})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
    menu = mymainmenu })



-- MENUBAR CONFIGURATION ------------------------------------------------------

menubar.utils.terminal = terminal -- Set the terminal for applications that require it



-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)



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

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)


---------------------------------
-- Global Variables
---------------------------------

local widget_fg = "#908caa"
local widget_bg = "#191724"

---------------------------------
-- Cutom Widgets
---------------------------------

-- -- audio volume widget
-- local volume_widget = require('awesome-wm-widgets.pactl-widget.volume')

-- -- Storage widget
-- local container_storage_widget = wibox.container

-- local storage_widget_root = wibox.widget {
--     align  = 'center',
--     valign = 'center',
--     widget = wibox.widget.textbox
-- }

-- local update_storage_root = function(st_root)
--     storage_widget_root.text = "  " .. st_root
-- end

-- local storage_widget_home = wibox.widget {
--     align  = 'center',
--     valign = 'center',
--     widget = wibox.widget.textbox
-- }

-- local update_storage_home = function(st_home)
--     storage_widget_home.text = "  " .. st_home
-- end

-- local storage_root = awful.widget.watch('bash -c "df -h | awk \'NR==4 {print $4}\'"', 60, function(self, stdout)
--     local st_root = stdout
--     update_storage_root(st_root)
-- end)

-- local storage_home = awful.widget.watch('bash -c "df -h | awk \'NR==6 {print $4}\'"', 60, function(self, stdout)
--     local st_home = stdout
--     update_storage_home(st_home)
-- end)

-- container_storage_widget = {
--     {
--         {
--             {
--                 {
--                     {
--                         widget = storage_widget_root,
--                     },
--                     {
--                         widget = storage_widget_home,
--                     },
--                     layout = wibox.layout.flex.horizontal
--                 },
--                 left   = 0,
--                 right  = 0,
--                 top    = 0,
--                 bottom = 0,
--                 widget = wibox.container.margin
--             },
--             shape  = gears.shape.rounded_bar,
--             fg     = widget_fg,
--             bg     = widget_bg,
--             widget = wibox.container.background
--         },
--         left   = 10,
--         right  = 10,
--         top    = 0,
--         bottom = 0,
--         widget = wibox.container.margin
--     },
--     layout = wibox.layout.fixed.horizontal,
-- }

-- -- Memory progressbar widget
-- local container_mem_widget = wibox.container
-- local memory_progressbar = wibox.widget {
-- 	max_value        = 16000,
-- 	value            = 0.5, -- very hugly -- minimum value to handle to make it look good
-- 	margins          = 2,
-- 	forced_width     = 80,
-- 	shape            = gears.shape.rounded_bar,
-- 	border_width     = 0.5,
-- 	border_color     = "#b4befe",
-- 	color            = "#b4befe",
-- 	background_color = widget_bg,
-- 	widget           = wibox.widget.progressbar,
-- }

-- local update_memory_widget = function(mem)
-- 	memory_progressbar.value = mem
-- end

-- awful.widget.watch('bash -c "free -m | awk \'/Mem/{print $3}\'"', 2, function(self, stdout)
-- 	local mem = tonumber(stdout)
-- 	update_memory_widget(mem)
-- end)

-- container_mem_widget = {
-- 	{
-- 		{
-- 			{
-- 				{
-- 					{
-- 						text   = "  ",
-- 						font   = "JetBrainsMono Nerd Font 9",
-- 						widget = wibox.widget.textbox,
-- 					},
-- 					{
-- 						widget = memory_progressbar,
-- 					},
-- 					layout = wibox.layout.fixed.horizontal
-- 				},
-- 				left   = 12,
-- 				right  = 12,
-- 				top    = 2,
-- 				bottom = 2,
-- 				widget = wibox.container.margin
-- 			},
-- 			shape  = gears.shape.rounded_bar,
-- 			fg     = "#b4befe",
-- 			bg     = widget_bg,
-- 			widget = wibox.container.background
-- 		},
-- 		left   = 5,
-- 		right  = 5,
-- 		top    = 4,
-- 		bottom = 4,
-- 		widget = wibox.container.margin
-- 	},
-- 	spacing = 0,
-- 	layout  = wibox.layout.fixed.horizontal,
-- }

-- -- Cpu progressbar widget
-- local container_cpu_widget = wibox.container

-- local cpu_progressbar = wibox.widget {
-- 	max_value        = 100,
-- 	value            = 0.5, -- very hugly -- minimum value to handle to make it look good
-- 	margins          = 2,
-- 	forced_width     = 80,
-- 	shape            = gears.shape.rounded_bar,
-- 	border_width     = 0.5,
-- 	border_color     = "#fab387",
-- 	color            = "#fab387",
-- 	background_color = widget_bg,
-- 	widget           = wibox.widget.progressbar,
-- }

-- local update_cpu_widget = function(cpu)
-- 	cpu_progressbar.value = cpu
-- end

-- awful.widget.watch('/home/weygoldt/.config/awesome/scripts/cpu.sh', 60, function(self, stdout)
-- 	local cpu = tonumber(stdout)
-- 	update_cpu_widget(cpu)
-- end)

-- container_cpu_widget = {
-- 	{
-- 		{
-- 			{
-- 				{
-- 					{
-- 						text   = "  ",
-- 						font   = "JetBrainsMono Nerd Font 9",
-- 						widget = wibox.widget.textbox,
-- 					},
-- 					{
-- 						widget = cpu_progressbar,
-- 					},
-- 					layout = wibox.layout.fixed.horizontal
-- 				},
-- 				left   = 12,
-- 				right  = 12,
-- 				top    = 2,
-- 				bottom = 2,
-- 				widget = wibox.container.margin
-- 			},
-- 			shape  = gears.shape.rounded_bar,
-- 			fg     = "#fab387",
-- 			bg     = widget_bg,
-- 			widget = wibox.container.background
-- 		},
-- 		left   = 5,
-- 		right  = 5,
-- 		top    = 4,
-- 		bottom = 4,
-- 		widget = wibox.container.margin
-- 	},
-- 	spacing = 0,
-- 	layout  = wibox.layout.fixed.horizontal,
-- }

-- Brightness widget
-- local container_brightness_widget = wibox.container

-- local brightness_widget = wibox.widget {
--   align  = 'center',
--   valign = 'center',
--   widget = wibox.widget.textbox
-- }

-- local update_brightness_widget = function(brightness)
--   brightness_widget.text = "  " .. brightness
-- end

-- local br, br_signal = awful.widget.watch('/home/stevevdv/Scripts/Scripts-AwesomeWM/brightness-bar.sh', 60, function(self, stdout)
--   local brightness = stdout
--   update_brightness_widget(brightness)
-- end)


-- container_brightness_widget = {
--   {
--     {
--       {
--         widget = brightness_widget,
--       },
--       left   = 12,
--       right  = 10,
--       top    = 0,
--       bottom = 0,
--       widget = wibox.container.margin
--     },
--     shape  = gears.shape.rounded_bar,
--     fg     = widget_fg,
--     bg     = widget_bg,
--     widget = wibox.container.background
--   },
--   spacing = 5,
--   layout  = wibox.layout.fixed.horizontal,
-- }

-- -- Volume widget
-- local container_vol_widget = wibox.container

-- local vol_widget = wibox.widget {
--   align  = 'center',
--   valign = 'center',
--   widget = wibox.widget.textbox
-- }

-- local update_vol_widget = function(vol)
--   vol_widget.text = "  " .. vol
-- end

-- local vo, vo_signal = awful.widget.watch('/home/stevevdv/Scripts/Scripts-AwesomeWM/volume-bar.sh', 60, function(self, stdout)
--   local vol = stdout
--   update_vol_widget(vol)
-- end)

-- container_vol_widget = {
--   {
--     {
--       {
--         widget = vol_widget,
--       },
--       left   = 12,
--       right  = 10,
--       top    = 0,
--       bottom = 0,
--       widget = wibox.container.margin
--     },
--     shape  = gears.shape.rounded_bar,
--     fg     = widget_fg,
--     bg     = widget_bg,
--     widget = wibox.container.background
--   },
--   spacing = 5,
--   layout  = wibox.layout.fixed.horizontal,
-- }

-- Temp widget
local container_mem_widget = wibox.container

local mem_widget = wibox.widget {
    align  = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
}

local update_mem_widget = function(mem)
    mem_widget.text = " " .. mem .. "G"
end

function round(number, precision)
    local fmtStr = string.format('%%0.%sf', precision)
    number = string.format(fmtStr, number)
    return number
end

awful.widget.watch('bash -c "free -m | awk \'/Mem/{print($3"M")}\'"', 2, function(self, stdout)
    local mem = round(stdout / 1000, 1)
    update_mem_widget(mem)
end)

container_mem_widget = {
    {
        {
            {
                widget = mem_widget,
            },
            left   = 20,
            right  = 0,
            top    = 0,
            bottom = 0,
            widget = wibox.container.margin
        },
        shape  = gears.shape.rounded_bar,
        fg     = widget_fg,
        bg     = widget_bg,
        widget = wibox.container.background
    },
    spacing = 5,
    layout  = wibox.layout.fixed.horizontal,
}
-- Temp widget
local container_temp_widget = wibox.container

local temp_widget = wibox.widget {
    align  = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
}

local update_temp_widget = function(temp)
    temp_widget.text = "  " .. temp
end

awful.widget.watch('bash -c "sensors | grep \'Package\' | awk \'{print $4}\'"', 2, function(self, stdout)
    local temp = stdout
    update_temp_widget(temp)
end)

container_temp_widget = {
    {
        {
            {
                widget = temp_widget,
            },
            left   = 20,
            right  = 0,
            top    = 0,
            bottom = 0,
            widget = wibox.container.margin
        },
        shape  = gears.shape.rounded_bar,
        fg     = widget_fg,
        bg     = widget_bg,
        widget = wibox.container.background
    },
    spacing = 5,
    layout  = wibox.layout.fixed.horizontal,
}
-- Batery widget
local container_battery_widget = wibox.container

local battery_widget = wibox.widget {
    align  = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
}

local update_battery_widget = function(bat)
    battery_widget.text = "  " .. bat .. "%"
end

awful.widget.watch('bash -c "cat /sys/class/power_supply/BAT0/capacity"', 60, function(self, stdout)
    local bat = tonumber(stdout)
    update_battery_widget(bat)
end)

container_battery_widget = {
    {
        {
            {
                widget = battery_widget,
            },
            left   = 20,
            right  = 0,
            top    = 0,
            bottom = 0,
            widget = wibox.container.margin
        },
        shape  = gears.shape.rounded_bar,
        fg     = widget_fg,
        bg     = widget_bg,
        widget = wibox.container.background
    },
    spacing = 5,
    layout  = wibox.layout.fixed.horizontal,
}

-- Arch widget
-- container_arch_widget = {
--   {
--     {
--       text = "  ",
--       font = "JetBrainsMono Nerd Font 11",
--       widget = wibox.widget.textbox,
--     },
--     left   = 0,
--     right  = 0,
--     top    = 2,
--     bottom = 3,
--     widget = wibox.container.margin
--   },
--   fg     = widget_fg,
--   widget = wibox.container.background
-- }

-- Clock widget
container_clock_widget = {
    {
        {
            {
                widget = mytextclock,
            },
            left   = 20,
            right  = 0,
            top    = 0,
            bottom = 0,
            widget = wibox.container.margin
        },
        shape  = gears.shape.rounded_bar,
        fg     = widget_fg,
        bg     = widget_bg,
        widget = wibox.container.background
    },
    spacing = 5,
    layout  = wibox.layout.fixed.horizontal,
}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

container_keyboard_widget = {
    {
        {
            {
                widget = mykeyboardlayout,
            },
            left   = 20,
            right  = 0,
            top    = 0,
            bottom = 0,
            widget = wibox.container.margin
        },
        shape  = gears.shape.rounded_bar,
        fg     = widget_fg,
        bg     = widget_bg,
        widget = wibox.container.background
    },
    spacing = 5,
    layout  = wibox.layout.fixed.horizontal,
}

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end),
        awful.button({}, 4, function() awful.layout.inc(1) end),
        awful.button({}, 5, function() awful.layout.inc(-1) end)))
    local layoutbox = wibox.widget({
        s.mylayoutbox,
        top    = 4,
        bottom = 5,
        left   = 5,
        right  = 10,
        widget = wibox.container.margin,
    })

    s.mytaglist = require("taglist")(s)
    s.mytasklist = require("tasklist")(s)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", border_width = 0, border_color = "#00000000", height = 22,
        input_passthrough = true, screen = s, bg = widget_bg, fg = widget_fg })

    -- Add widgets to the wibox
    s.mywibox:setup {
        {
            layout = wibox.layout.align.horizontal,
            { -- Left widgets
                -- container_arch_widget,
                layout = wibox.layout.fixed.horizontal,
                s.mytaglist,
                s.mytasklist,
                --mylauncher,
                -- s.mypromptbox
            },
            { -- Middle widgets
                layout = wibox.layout.fixed.horizontal,
            },
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                container_keyboard_widget,
                -- volume_widget {
                --     widget_type = 'icon_and_text'
                -- },
                -- brightness_widget {
                --     type = 'icon_and_text',
                --     program = 'brightnessctl',
                --     step = 2,
                --     font = "JetBrainsMono Nerd Font 9",
                -- },
                container_mem_widget,
                container_temp_widget,
                container_battery_widget,
                container_clock_widget,
                wibox.widget.systray(),
                logout_menu_widget {
                    font = 'JetBrainsMono Nerd Font 9',
                    onlock = function() awful.spawn.with_shell('~/.config/awesome/lock-screen.sh') end
                },
                layoutbox,
                -- container_cpu_widget,
                -- container_mem_widget,
                -- container_storage_widget,
                -- container_brightness_widget,
                -- container_vol_widget,
                -- wibox.layout.margin(wibox.widget.systray(), 5, 5, 5, 5),
                -- systray(),
                -- volume_widget{
                --     widget_type = 'icon'
                -- },
            }
        },
        top = 0, -- don't forget to increase wibar height
        color = widget_bg,
        widget = wibox.container.margin,
    }
end)
-- s.mywibox:setup {
--     layout = wibox.layout.align.horizontal,
--     { -- Left widgets
--         layout = wibox.layout.fixed.horizontal,
--         mylauncher,
--         s.mytaglist,
--         s.mypromptbox,
--     },
--     s.mytasklist, -- Middle widget
--     { -- Right widgets
--         layout = wibox.layout.fixed.horizontal,
--         mykeyboardlayout,
--         wibox.widget.systray(),
--         mytextclock,
--         s.mylayoutbox,
--     },
-- }
-- end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({}, 3, function() mymainmenu:toggle() end),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(

    awful.key({ modkey, }, "s", hotkeys_popup.show_help,
        { description = "show help", group = "awesome" }),

    awful.key({ modkey, }, "Left", awful.tag.viewprev,
        { description = "view previous", group = "tag" }),

    awful.key({ modkey, }, "Right", awful.tag.viewnext,
        { description = "view next", group = "tag" }),

    awful.key({ modkey, }, "Escape", awful.tag.history.restore,
        { description = "go back", group = "tag" }),

    awful.key({ modkey, }, "j",
        function()
            awful.client.focus.byidx(1)
        end,
        { description = "focus next by index", group = "client" }
    ),
    awful.key({ modkey, }, "k",
        function()
            awful.client.focus.byidx(-1)
        end,
        { description = "focus previous by index", group = "client" }
    ),
    awful.key({ modkey, }, "w", function() mymainmenu:show() end,
        { description = "show main menu", group = "awesome" }),

    -- Layout manipulation
    awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end,
        { description = "swap with next client by index", group = "client" }),

    awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end,
        { description = "swap with previous client by index", group = "client" }),

    awful.key({ modkey, "Control" }, "j", function() awful.screen.focus_relative(1) end,
        { description = "focus the next screen", group = "screen" }),

    awful.key({ modkey, "Control" }, "k", function() awful.screen.focus_relative(-1) end,
        { description = "focus the previous screen", group = "screen" }),

    awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
        { description = "jump to urgent client", group = "client" }),

    awful.key({ modkey, }, "Tab",
        function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        { description = "go back", group = "client" }),

    -- Standard program
    awful.key({ modkey, }, "Return", function() awful.spawn(terminal) end,
        { description = "open a terminal", group = "launcher" }),

    awful.key({ modkey, "Control" }, "r", awesome.restart,
        { description = "reload awesome", group = "awesome" }),

    awful.key({ modkey, "Shift" }, "q", awesome.quit,
        { description = "quit awesome", group = "awesome" }),

    awful.key({ modkey, }, "l", function() awful.tag.incmwfact(0.05) end,
        { description = "increase master width factor", group = "layout" }),

    awful.key({ modkey, }, "h", function() awful.tag.incmwfact(-0.05) end,
        { description = "decrease master width factor", group = "layout" }),

    awful.key({ modkey, "Shift" }, "h", function() awful.tag.incnmaster(1, nil, true) end,
        { description = "increase the number of master clients", group = "layout" }),

    awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster(-1, nil, true) end,
        { description = "decrease the number of master clients", group = "layout" }),

    awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol(1, nil, true) end,
        { description = "increase the number of columns", group = "layout" }),

    awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1, nil, true) end,
        { description = "decrease the number of columns", group = "layout" }),

    -- awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
    --           {description = "select next", group = "layout"}),

    awful.key({ modkey, "Shift" }, "space", function() awful.layout.inc(-1) end,
        { description = "select previous", group = "layout" }),

    awful.key({ modkey, "Control" }, "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal(
                    "request::activate", "key.unminimize", { raise = true }
                )
            end
        end,
        { description = "restore minimized", group = "client" }),

    -- Prompt
    awful.key({ modkey }, "space", function()
        awful.util.spawn("dmenu_run -i -nb '#191724' -nf '#908caa' -sb '#191724' -sf '#e0def4' -fn 'JetBrainsMono Nerd Font:regular:pixelsize=12'")
    end,
        { description = "run dmenu", group = "weygoldt" }),

    -- Firefox
    awful.key({ modkey }, "b", function()
        awful.util.spawn(browser)
    end,
        { description = "run default browser", group = "weygoldt" }),

    awful.key({ modkey }, "e", function()
        awful.util.spawn(files)
    end,
        { description = "run file explorer", group = "weygoldt" }),

    awful.key({ modkey }, "m", function()
        awful.util.spawn(mail)
    end,
        { description = "run mail client", group = "weygoldt" }),

    awful.key({ modkey }, "p", function()
        awful.util.spawn(colorpicker)
    end,
        { description = "run color picker", group = "weygoldt" }),

    awful.key({ modkey, "Shift" }, "s", function()
        awful.util.spawn(screenshot)
    end,
        { description = "take a screenshot", group = "weygoldt" }),

    awful.key({ modkey }, "x",
        function()
            awful.prompt.run {
                prompt       = "Run Lua code: ",
                textbox      = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
        { description = "lua execute prompt", group = "awesome" })
-- Menubar
-- awful.key({ modkey }, "p", function() menubar.show() end,
--     { description = "show the menubar", group = "launcher" })
)

clientkeys = gears.table.join(

    awful.key({ modkey, }, "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }),

    awful.key({ modkey, }, "q", function(c) c:kill() end,
        { description = "close", group = "client" }),

    awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }),

    awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end,
        { description = "move to master", group = "client" }),

    awful.key({ modkey, }, "o", function(c) c:move_to_screen() end,
        { description = "move to screen", group = "client" }),

    awful.key({ modkey, }, "t", function(c) c.ontop = not c.ontop end,
        { description = "toggle keep on top", group = "client" }),

    awful.key({ modkey, }, "n",
        function(c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end,
        { description = "minimize", group = "client" }),
    awful.key({ modkey, }, "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        { description = "(un)maximize", group = "client" }),
    awful.key({ modkey, "Control" }, "m",
        function(c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end,
        { description = "(un)maximize vertically", group = "client" }),
    awful.key({ modkey, "Shift" }, "m",
        function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end,
        { description = "(un)maximize horizontally", group = "client" })

-- Configure these when time
-- awful.key({}, "XF86AudioRaiseVolume", function() volume_widget:inc(5) end),
-- awful.key({}, "XF86AudioLowerVolume", function() volume_widget:dec(5) end),
-- awful.key({}, "XF86AudioMute", function() volume_widget:toggle() end),
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            { description = "view tag #" .. i, group = "tag" }),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            { description = "toggle tag #" .. i, group = "tag" }),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            { description = "move focused client to tag #" .. i, group = "tag" }),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            { description = "toggle focused client on tag #" .. i, group = "tag" })
    )
end

clientbuttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({ modkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).

awful.rules.rules = {
    -- All clients will match this rule.
    { rule = {},
        properties = { border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen
        }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
            "DTA", -- Firefox addon DownThemAll.
            "copyq", -- Includes session name in class.
            "pinentry",
        },
        class = {
            "Arandr",
            "Blueman-manager",
            "Gpick",
            "Kruler",
            "MessageWin", -- kalarm.
            "Sxiv",
            "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
            "Wpa_gui",
            "veromix",
            "xtightvncviewer"
        },

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
            "Event Tester", -- xev.
        },
        role = {
            "AlarmWindow", -- Thunderbird's calendar.
            "ConfigManager", -- Thunderbird's about:config.
            "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
        }
    }, properties = { floating = true } },

    -- Add titlebars to normal clients and dialogs
    -- { rule_any = {type = { "normal", "dialog" }
    --   }, properties = { titlebars_enabled = true }
    -- },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)



-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({}, 1, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({}, 3, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c):setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton(c),
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Only use the word firefox for firefox windows
client.connect_signal("property::name", function(c)
    if c.class == "Firefox" then
        if c.name ~= "Firefox" then
            c.name = "Firefox"
        end
    end
end)


-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
--     c:emit_signal("request::activate", "mouse_enter", {raise = false})
-- end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}


-- What I changed
-- Autostart applications

-- loads a session, still not exactly sure what this means
awful.spawn.with_shell("XDG_CURRENT_DESKTOP=KDE")
awful.spawn.with_shell("lxsession")

-- loads picom compositor from default config
awful.spawn.with_shell("picom --experimental-backends --config ~/.config/awesome/picom.conf")

-- reloads default monitor config set with arandr
awful.spawn.with_shell("autorandr --change")

-- loads wallpaper manager, restores wallpaper before boot
-- awful.spawn.with_shell("nitrogen --restore")
awful.spawn.with_shell("feh --bg-fill --randomize /home/weygoldt/.wallpapers")

-- loads keyring for auto wifi login
awful.spawn.with_shell("dbus-update-activation-environment --all")
awful.spawn.with_shell("gnome-keyring-daemon --start --components=secrets")

-- opens apps in systray (bluetooth and wifi)
awful.util.spawn("nm-applet", false)
awful.util.spawn("blueman-applet", false)

-- hides cursors that are ide for more than a second
awful.spawn.with_shell("unclutter -idle 1")

-- mask plasma services to stop fucking krunner from opening
awful.spawn.with_shell("systemctl --user mask plasma-kglobalaccel.service")

-- make gaps between windows
beautiful.useless_gap = 0

collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
