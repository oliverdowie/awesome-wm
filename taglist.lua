local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

-- Custom taglist item
local function create_taglist_item(tag, i, num_cols)
    local row_index = math.floor((i - 1) / num_cols) + 1
    local col_index = (i - 1) % num_cols + 1
    
    local circle_size = 15
    local stagger_spacing = 15
    local margin_top = 0
    local margin_bottom = stagger_spacing
    if col_index == 2 then
        margin_top = stagger_spacing
    end
    if col_index == 2 then
        margin_bottom = 0
    end

    local tag_circle = wibox.widget {
        widget = wibox.container.background,
        shape = gears.shape.circle,
        border_width = 2,
        border_color = "#ffffff",
        forced_height = circle_size,
        forced_width = circle_size,
    }

    local widget = wibox.widget {
        widget = wibox.container.background,
        row_index = row_index,
        col_index = col_index,
        -- bg = "#bbbbbb",
        {
            widget = wibox.container.margin,
            margins = {
                top = margin_top,
                bottom = margin_bottom
            },
            {
                widget = wibox.container.place,
                halign = "center",
                valign = "center",
                tag_circle,
            },
        }
    }

    -- Define default and selected colors
    local default_bg = "#ffffff"
    local selected_bg = "#ff0000"
    local urgent_bg = '#ff1111'
    local hover_bg = '#ff1111'

    local function update_tag_color()
        if tag.urgent then
            tag_circle.border_color = urgent_bg
        elseif tag.selected then
            tag_circle.border_color = selected_bg
        else
            tag_circle.border_color = default_bg
        end
    end

    tag:connect_signal("property::selected", update_tag_color)
    tag:connect_signal("property::urgent", update_tag_color)
    tag_circle:connect_signal("mouse::enter", function()
        tag_circle.border_color = hover_bg
    end)
    tag_circle:connect_signal("mouse::leave", function()
        update_tag_color()
    end)

    update_tag_color()

    tag_circle:connect_signal("button::press", function(_, _, _, button)
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
    local num_cols = 2

    local grid = wibox.widget {
        layout = wibox.layout.grid.vertical,
        column_count = 2,
        homogeneous  = true,
    }

    local container = wibox.widget {
        widget = wibox.container.margin,
        margins = {
            left = 5,
            top = 5
        },
        grid
    }

    -- Add each tag widget to the grid
    for i = 1, 9 do       
        local tag_widget = create_taglist_item(tags[i], i, num_cols)
        grid:add(tag_widget)
    end

    local rotated_container = wibox.container.rotate(container, 'east')

    return rotated_container
end

return custom_taglist
