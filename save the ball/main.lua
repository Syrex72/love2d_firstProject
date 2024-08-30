local love = require 'love'
local enemy = require 'Enemy'
local button = require 'Button'

math.randomseed(os.time())

local game = {
    difficulty = 1,
    state = {
        menu = true,
        pause = false,
        running = false,
        ended = false
    }
}

local player = {
    x = 30,
    y = 30,
    radius = 20
}

local enemies = {}

local buttons = {
    menu_state = {},
}


function love.mousepressed(x, y, button, istouch, presses)
    if not game.state["running"] then
        if button == 1 then
            if game.state["menu"] then
                for index in ipairs(buttons.menu_state) do
                    buttons.menu_state[index]:checkPressed(x, y, player.radius)
                end
            end
        end
    end   
end

function love.load()
    love.window.setTitle("bolas")
    love.mouse.setVisible(false)

    buttons.menu_state.play_game = button("Play game", nil, nil)
    buttons.menu_state.settings = button("Settings", nil, nil)
    buttons.menu_state.exit_game = button("Exit", love.event.quit, nil)
    table.insert(enemies, 1, enemy())
end

function love.update(dt)
    player.x, player.y = love.mouse.getPosition()

    for i = 1, #enemies do
        enemies[i]:move(player.x, player.y)
    end
end

function love.draw()
    
    local x, y = love.mouse.getPosition()
    love.graphics.print("x: ".. x .. " y: " .. y , 100, 100)
    love.graphics.printf(
        "FPS: " .. love.timer.getFPS(), 
        love.graphics.newFont(16),
        0, 0,
        love.graphics.getWidth()
    )

    if game.state["runni1ng"] then 
        love.graphics.circle("fill", player.x, player.y, player.radius)
        for i = 1, #enemies do
            enemies[i]:draw()
        end
    elseif game.state["menu"] then
        buttons.menu_state.play_game:draw(love.graphics.getWidth() / 2 - buttons.menu_state.play_game.width / 2, 200, 30, 15)
        buttons.menu_state.settings:draw(love.graphics.getWidth() / 2 - buttons.menu_state.play_game.width / 2, 245, 30, 15)
        buttons.menu_state.exit_game:draw(love.graphics.getWidth() / 2 - buttons.menu_state.play_game.width / 2, 290, 30, 15)
    end 

    if not game.state["running"] then 
        love.graphics.circle("fill", player.x, player.y, player.radius / 2)
    end
end