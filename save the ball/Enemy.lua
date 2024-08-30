local love = require "love"

function Enemy(level)
    local side = math.random(1, 4)
    local _x, _y
    local _radius = 20

    if side == 1 then
        _x = math.random(_radius, love.graphics.getWidth())
        _y = -_radius * 4
    elseif side == 2 then
        _x = love.graphics.getWidth() + (_radius * 4)
        _y = math.random(_radius, love.graphics.getHeight())
    elseif side == 3 then
        _x = math.random(_radius, love.graphics.getWidth())
        _y = love.graphics.getHeight() + (_radius * 4)
    else
        _x = -_radius * 4
        _y = math.random(_radius, love.graphics.getHeight())
    end

    return{
        level = level or 1,
        radius = _radius,
        x = _x,
        y = _y, 

        move = function (self, p_x, p_y)
            if p_x - self.x > 0 then
                self.x = self.x + self.level
            elseif p_x - self.x < 0 then
                self.x = self.x - self.level
            end

            if p_y - self.y > 0 then
                self.y = self.y + self.level
            elseif p_y - self.y < 0 then
                self.y = self.y - self.level
            end
        end,
        draw = function (self)
            love.graphics.setColor(1, 0, 0)
            love.graphics.circle("fill", self.x, self.y, self.radius)
            love.graphics.setColor(1, 1, 1)
        end
    }
end

return Enemy