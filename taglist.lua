-- ~/.config/awesome/custom_taglist.lua

local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

-- Custom taglist item
local function create_taglist_item(tag, i, num_cols)
    local row_index = math.floor((i - 1) / num_cols) + 1
    local col_index = (i - 1) % num_cols + 1

    local widget = wibox.widget {
        widget = wibox.container.background,
        shape = gears.shape.circle,
        forced_height = 15,
        forced_width = 15,
        row_index = row_index,
        col_index = col_index
    }

    -- Define default and selected colors
    local default_bg = "#ffffff"
    local selected_bg = "#ff0000"
    local hover_bg = '#ff1111'

    -- Set the background color initially
    widget.bg = default_bg

    -- Connect to signals to change color on tag focus
    tag:connect_signal("property::selected", function()
        if tag.selected then
            widget.bg = selected_bg
        else
            widget.bg = default_bg
        end
    end)

    -- Update color if tag is selected on creation
    if tag.selected then
        widget.bg = selected_bg
    end

    -- Update appearance based on tag properties
    widget:connect_signal("mouse::enter", function()
        widget.bg = hover_bg  -- Change background color on hover
    end)
    widget:connect_signal("mouse::leave", function()
        widget.bg = default_bg  -- Reset background color
        if tag.selected then
            widget.bg = selected_bg
        end
    end)
    widget:connect_signal("button::press", function(_, _, _, button)
        if button == 1 then
            tag:view_only()
        elseif button == 3 then
            awful.menu.client_list({theme = {width = 250}})
        end
    end)

    return widget
end

-- Custom taglist using grid layout
local function custom_taglist(s)
    local tags = s.tags
    local num_cols = 2  -- Number of columns in the grid

    -- local grid_layout = wibox.layout.grid.vertical()
    -- grid_layout:setup {
    --     layout = wibox.layout.grid.vertical,
    --     homogeneous = true,
    --     column_count = 2,
    -- }
    local grid = wibox.widget {
        layout = wibox.layout.grid.vertical,
        column_count = 2,
        spacing = 5,
        homogeneous  = true
    }
      

    local txt = wibox.widget{
        markup = "o",
        halign = "center",
        valign = "center",
        widget = wibox.widget.textbox
    }

    -- Add each tag widget to the grid
    for i = 1, 9 do       
        local tag_widget = create_taglist_item(tags[i], i, num_cols)
        grid:add(tag_widget)
    end

    local grid_container = wibox.container.rotate(grid, 'east')

    return grid_container
end

return custom_taglist
