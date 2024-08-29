local love = require 'love'
local enemy = require 'Enemy'

math.randomseed(os.time())

local game = {
    difficulty = 1,
    state = {
        menu = false,
        pause = false,
        running = true,
        ended = false
    }
}

local player = {
    x = 30,
    y = 30,
    radius = 20
}

local enemies = {}
 
function love.load()
    love.window.setTitle("bolas")
    love.mouse.setVisible(false)

    table.insert(enemies, 1, enemy())
end

function love.update(dt)
    player.x, player.y = love.mouse.getPosition()

    for i = 1, #enemies do
        enemies[i]:move(player.x, player.y)
    end
end

function love.draw()
    love.graphics.printf(
        "FPS: " .. love.timer.getFPS(), 
        love.graphics.newFont(16),
        0, 0,
        love.graphics.getWidth()
    )

    if game.state["running"] then 
        love.graphics.circle("fill", player.x, player.y, player.radius)
        for i = 1, #enemies do
            enemies[i]:draw()
        end
    end

    if not game.state["running"] then 
        love.graphics.circle("fill", player.x, player.y, player.radius / 2)
    end
end