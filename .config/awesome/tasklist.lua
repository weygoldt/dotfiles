local awful = require("awful")
local gears = require("gears")
-- local gfs = gears.filesystem
local wibox = require("wibox")
-- local beautiful = require("beautiful")
-- local xresources = require("beautiful.xresources")
-- local dpi = xresources.apply_dpi
------------------------------------

local get_tasklist = function(s)

    local tasklist_buttons = gears.table.join(
        awful.button({}, 1, function(c)
            if c == client.focus then
                c.minimized = true
            else
                c:emit_signal(
                    "request::activate",
                    "tasklist",
                    { raise = true }
                )
            end
        end),
        awful.button({}, 3, function()
            awful.menu.client_list({ theme = { width = 250 } })
        end),
        awful.button({}, 4, function()
            awful.client.focus.byidx(1)
        end),
        awful.button({}, 5, function()
            awful.client.focus.byidx(-1)
        end))

    local tasklist = awful.widget.tasklist {
        screen          = s,
        filter          = awful.widget.tasklist.filter.currenttags,
        buttons         = tasklist_buttons,
        style           = {
            shape_border_width = 0,
            shape_border_color = '#00000000',
            shape              = gears.shape.rounded_bar,
        },
        layout          = {
            spacing = 5,

            layout = wibox.layout.flex.horizontal
        },
        -- Notice that there is *NO* wibox.wibox prefix, it is a template,
        -- not a widget instance.
        widget_template = {
            {
                {
                    {
                        id     = 'text_role',
                        font   = "JetBrainsMono Nerd Font:regular:pixelsize=14",
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left   = 10,
                right  = 10,
                widget = wibox.container.margin
            },
            id     = 'background_role',
            widget = wibox.container.background,
        },
    }
    return tasklist
end

return get_tasklist
