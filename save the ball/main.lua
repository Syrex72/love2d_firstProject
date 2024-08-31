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
    },
    levels = {15, 30, 60, 120}
}

local player = {
    x = 30,
    y = 30,
    radius = 20,
    points = 0
}

local enemies = {}

local buttons = {
    menu_state = {},
}

local function changeGameState(state)
    game.state["menu"] = (state == "menu")
    game.state["pause"] = (state == "paused")
    game.state["running"] = (state == "running")
    game.state["ended"] = (state == "ended")
end


local function startGame()
    changeGameState("running")
    player.points = 0

    enemies = {
        enemy(1),
    }
end

function love.load()
    love.window.setTitle("bolas")
    love.mouse.setVisible(false)

    buttons.menu_state.play_game = button("Play game", startGame, nil)
    buttons.menu_state.settings = button("Settings", nil, nil)
    buttons.menu_state.exit_game = button("Exit", love.event.quit, nil)
end

function love.update(dt)
    player.x, player.y = love.mouse.getPosition()
    
    if game.state["running"] then
        for i = 1, #enemies do
            if not enemies[i]:checkTouched(player.x, player.y, player.radius) then
                player.points = player.points + dt
                
                for l = 1, #game.levels do
                    if math.floor(player.points) == game.levels[l] then
                        table.insert(enemies, 1, enemy(game.difficulty * (l + 1)))
                        player.points = player.points + 1
                    end
                end
            else
                changeGameState("menu")
            end
            enemies[i]:move(player.x, player.y)
        end
    end
end


function love.mousepressed(x, y, button, istouch, presses)
    if not game.state["running"] then
        if button == 1 then
            if game.state["menu"] then
                for index in pairs(buttons.menu_state) do
                    buttons.menu_state[index]:checkPressed(x, y, player.radius)
                end
            end
        end
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
        love.graphics.print(math.floor(player.points), love.graphics.newFont(24), love.graphics.getWidth() / 2, 0)
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
