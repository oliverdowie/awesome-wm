local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

local date = wibox.widget.textclock('%d/%m')

local hours = wibox.widget.textclock('%I')

local minutes = wibox.widget.textclock('%M')

local clock = wibox.widget {
    layout = wibox.layout.grid.vertical,
    column_count = 1,
    children = {
        date,
        hours,
        minutes
    }
}

local clock_rotated = wibox.container.rotate(clock, 'east')

return clock_rotated