_G.love = require('love')


function love.load()
    love.graphics.setBackgroundColor(100/255, 100/255, 100/255)
    _G.pacman = {}
    pacman.x = 250  
    pacman.y = 250
    pacman.eat = false

    _G.food_x = 650
end

function love.update(dt)
    pacman.x = pacman.x + 1
    
    if pacman.x >= food_x then
        pacman.eat = true
    end
end

function love.draw()
    -- love.graphics.setColor(0, 0, 1) -- caso pegue um rgb por fora, dividir por 255 se ele n for entre 0 e 1
    -- love.graphics.rectangle('fill', 0, 0, 100, 100)
    
    if not pacman.eat then
        love.graphics.setColor(0, 1, 0) -- caso pegue um rgb por fora, dividir por 255 se ele n for entre 0 e 1
        love.graphics.circle('fill', food_x, 250, 50)        
    end

    love.graphics.setColor(1, 1, 0) -- caso pegue um rgb por fora, dividir por 255 se ele n for entre 0 e 1
    love.graphics.arc('fill', pacman.x, pacman.y, 100, 1, 5)
end