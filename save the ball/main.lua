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
    ended_state = {},
    pause_state = {}
}

local fonts = {
    medium = {
        font = love.graphics.newFont(16),
        size = 16
    },
    large = {
        font = love.graphics.newFont(24),
        size = 24
    },
    gigant = {
        font = love.graphics.newFont(60),
        size = 60
    },
}

local function changeGameState(state)
    game.state["menu"] = (state == "menu")
    game.state["pause"] = (state == "pause")
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

    -- menu padrão
    buttons.menu_state.play_game = button("Play game", startGame, nil)
    buttons.menu_state.settings = button("Settings", nil, nil)
    buttons.menu_state.exit_game = button("Exit", love.event.quit, nil)

    -- menu derrota
    buttons.ended_state.replay_game = button("Replay game", startGame, nil)
    buttons.ended_state.menu = button("Menu ", changeGameState, "menu")
    buttons.ended_state.exit_game = button("Exit", love.event.quit, nil)

    -- menu pausa
    buttons.pause_state.pause = button("Pause", changeGameState, "pause", 50, 30)
    buttons.pause_state.return_game = button("Return game", changeGameState, "running")
    buttons.pause_state.menu = button("Menu", changeGameState, "menu")
    buttons.pause_state.exit_game = button("Exit", love.event.quit, nil)
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
                changeGameState("ended")
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
            elseif game.state["ended"] then
                for index in pairs(buttons.ended_state) do
                    buttons.ended_state[index]:checkPressed(x, y, player.radius)
                end
            elseif game.state["paused"] then
                for index in pairs(buttons.pause_state) do
                    buttons.pause_state[index]:checkPressed(x, y, player.radius)
                end
            end
        end
    end
    if game.state["running"] then
        if button == 1 then
            buttons.pause_state.pause:checkPressed(x, y, player.radius)
        end
    end
end 

function love.draw()
    love.graphics.setFont(fonts.medium.font)
    love.graphics.printf(
        "FPS: " .. love.timer.getFPS(), 
        love.graphics.newFont(16),
        0, 0,
        love.graphics.getWidth()
    )

    if game.state["running"] then
        buttons.pause_state.pause:draw(love.graphics.getWidth() - buttons.pause_state.pause.width, 0)
        love.graphics.print(math.floor(player.points), fonts.large.font , love.graphics.getWidth() / 2, 0)
        love.graphics.circle("fill", player.x, player.y, player.radius)
        for i = 1, #enemies do
            enemies[i]:draw()
        end
    elseif game.state["menu"] then
        buttons.menu_state.play_game:draw(love.graphics.getWidth() / 2 - buttons.menu_state.play_game.width / 2, 200, 30, 15)
        buttons.menu_state.settings:draw(love.graphics.getWidth() / 2 - buttons.menu_state.settings.width / 2, 245, 30, 15)
        buttons.menu_state.exit_game:draw(love.graphics.getWidth() / 2 - buttons.menu_state.exit_game.width / 2, 290, 30, 15)
    elseif game.state["ended"] then 
        buttons.ended_state.replay_game:draw(love.graphics.getWidth() / 2 - buttons.ended_state.replay_game.width / 2, 245, 30, 15)
        buttons.ended_state.menu:draw(love.graphics.getWidth() / 2 - buttons.ended_state.menu.width / 2, 290, 30, 15)
        buttons.ended_state.exit_game:draw(love.graphics.getWidth() / 2 - buttons.ended_state.exit_game.width / 2, 335, 30, 15)
    elseif game.state["pause"] then 
        buttons.pause_state.return_game:draw(love.graphics.getWidth() / 2 - buttons.ended_state.replay_game.width / 2, 245, 30, 15)
        buttons.pause_state.menu:draw(love.graphics.getWidth() / 2 - buttons.ended_state.menu.width / 2, 290, 30, 15)
        buttons.pause_state.exit_game:draw(love.graphics.getWidth() / 2 - buttons.ended_state.exit_game.width / 2, 335, 30, 15)
    end

    if not game.state["running"] then 
        love.graphics.circle("fill", player.x, player.y, player.radius / 2)
    end
end
