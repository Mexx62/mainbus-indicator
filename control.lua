require('__stdlib__/stdlib/utils/defines/color')
local Color = require('__stdlib__/stdlib/utils/color')

function drawLinesOnAllIndicators()
    for _, v in pairs(game.surfaces["nauvis"].find_entities_filtered{name = "mainbus-indicator"}) do
        drawLineOnIndicator(v)
        addSpritesOnLine(v)
    end
end

function drawLineOnIndicator(entity)
    rendering.draw_line{
        color = Color.set(defines.color.yellow, 0.5),
        width = 12,
        gap_length = 1,
        dash_length = 2,
        from = entity,
        to = calculateShiftedPosition(entity.position, entity.direction, 100),
        surface = "nauvis",
        draw_on_ground = true
    }
end

function addSpritesOnLine(entity)
    if (entityHasSignal(entity)) then
        for i = 4, 100, 3 do
            rendering.draw_sprite{
                sprite = convertSignalToSpritePath(entity.get_control_behavior().get_signal(1)),
                orientation = entity.direction,
                target = calculateShiftedPosition(entity.position, entity.direction, i),
                surface = "nauvis",
                x_scale = 0.85,
                y_scale = 0.85
            }
        end
    end
end

function entityHasSignal(entity)
    return entity.get_control_behavior().get_signal(1)['signal'] ~= nil
end

function convertSignalToSpritePath(signal) return signal.signal.type .. "/" .. signal.signal.name end

function calculateShiftedPosition(position, direction, distance)
    if direction == defines.direction.east then
        return {position.x + distance, position.y}
    elseif direction == defines.direction.north then
        return {position.x, position.y + distance}
    elseif direction == defines.direction.west then
        return {position.x - distance, position.y}
    elseif direction == defines.direction.south then
        return {position.x, position.y - distance}
    end
end

script.on_init(drawLinesOnAllIndicators)

script.on_event(
    {defines.events.on_built_entity},
    function(e)
        if e.entity.name == "mainbus-indicator" then
            drawLineOnIndicator(e.entity)
            addSpritesOnLine(e.entity)
        end
    end
)

script.on_event(
    {defines.events.on_player_rotated_entity},
    function(e)
        if e.entity.name == "mainbus-indicator" then
            rendering.clear()
            drawLinesOnAllIndicators()
        end
    end
)
