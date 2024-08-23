local wibox = require("wibox")
local awful = require("awful")

local date = wibox.widget {
    format = '%d %m',
    widget = wibox.widget.textclock,
    font = 'ProFont IIx Nerd Font Mono 8',
    halign = 'center',
    forced_height = 10
}

local date_rotated = wibox.container.rotate(date, 'east')

local hours = wibox.widget {
    format = '%I',
    widget = wibox.widget.textclock,
    font = 'ProFont IIx Nerd Font Mono 12',
}

local minutes = wibox.widget {
    format = '%M',
    widget = wibox.widget.textclock,
    font = 'ProFont IIx Nerd Font Mono 12',
}

local time = wibox.widget {
    layout = wibox.layout.grid.vertical,
    column_count = 1,
    homogeneous = false,
    children = {
        hours,
        minutes
    }
}

local date_time = wibox.widget {
    widget = wibox.container.margin,
    margins = {
        left = 3,
        top = 5,
        bottom = 2
    },
    {
        layout = wibox.layout.grid.horizontal,
        column_count = 2,
        row_count = 1,
        forced_width = 40,
        homogeneous = false,
        valign = 'center',
        halign = 'center',
        spacing = 2,
        children = {
            date_rotated,
            time
        }
    }
}

local date_time_rotated = wibox.container.rotate(date_time, 'east')

local myclock_t = awful.tooltip {
    objects        = { date_time_rotated },
    timer_function = function()
        return os.date("Today is %A %B %d %Y\nThe time is %T")
    end,
}

return date_time_rotated
