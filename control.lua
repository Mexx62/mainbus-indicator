local items = {}

script.on_event(
    {defines.events.on_tick},
    function(e)
        if e.tick % 60 == 0 then
            for _, v in pairs(game.surfaces["nauvis"].find_entities_filtered{name = "mainbus-indicator"}) do
                rendering.draw_line{
                    color = {r = 1, g = 1, b = 0, a = 0.5},
                    width = 12,
                    gap_length = 1,
                    dash_length = 2,
                    from = v,
                    to = calculateEndLinePosition(v.position, v.direction),
                    surface = "nauvis",
                    draw_on_ground = true
                }
            end
        end
    end
)

script.on_event(
    {defines.events.on_player_rotated_entity},
    function(e)
        if e.entity.name == "mainbus-indicator" then rendering.clear() end
    end
)

script.on_event(
    {defines.events.on_built_entity},
    function(e)
        if e.created_entity.name == 'mainbus-indicator' then
            table.insert(items, e.created_entity)
            local first_player = game.players[1]
            first_player.print('Entity: ' .. e.created_entity.name)
            first_player.print('Direction: ' .. e.created_entity.direction)
            first_player.print('Position: ' .. serpent.block(e.created_entity.position))
        end
    end
)

function calculateEndLinePosition(position, direction)
    local distance = 100
    if direction == defines.direction.east then
        return {position.x + distance, position.y}
    elseif direction == defines.direction.north then
        return {position.x, position.y + distance}
    elseif direction == defines.direction.west then
        return {position.x - distance, position.y}
    elseif direction == defines.direction.south then
        return {position.x, position.y - distance}
        -- elseif direction == defines.direction.northwest then return position + {-0.71*distance, distance}
        -- elseif direction == defines.direction.southwest then return position + {-0.71*distance, -0.71*distance}
        -- elseif direction == defines.direction.northeast then return position + {0.71*distance, 0.71*distance}
        -- elseif direction == defines.direction.southeast then return position + {0.71*distance, -0.71*distance}
    end
end
