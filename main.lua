_G.love = require('love')


function love.load()
    love.graphics.setBackgroundColor(100/255, 100/255, 100/255)
    _G.pacman = {
        size = 50,
        x = 250,
        y = 250,
        angle1 = 1,
        angle2 = 5
    }

    _G.food = {
        x = 350,
        eaten = false
    }
end

function love.update(dt)
    if love.keyboard.isDown("down") then
        pacman.angle2 = pacman.angle2 + math.pi * dt
        pacman.angle1 = pacman.angle1 + math.pi * dt
    elseif love.keyboard.isDown("up") then
        pacman.angle1 = pacman.angle1 - math.pi * dt
        pacman.angle2 = pacman.angle2 - math.pi * dt
    end


    if love.keyboard.isDown("a") then
        pacman.x = pacman.x - 5
    end
    if love.keyboard.isDown("d") then
        pacman.x = pacman.x + 5 
    end
    if love.keyboard.isDown("w") then
        pacman.y = pacman.y - 5
    end
    if love.keyboard.isDown("s") then
        pacman.y = pacman.y + 5
    end 

    if pacman.x >= food.x then
        food.eaten = true
    end
end

function love.draw()
    -- love.graphics.setColor(0, 0, 1) -- caso pegue um rgb por fora, dividir por 255 se ele n for entre 0 e 1
    -- love.graphics.rectangle('fill', 0, 0, 100, 100)
    
    if not food.eaten then
        love.graphics.setColor(0, 1, 0) -- caso pegue um rgb por fora, dividir por 255 se ele n for entre 0 e 1
        love.graphics.circle('fill', food.x, 250, 50)        
    end

    love.graphics.setColor(1, 1, 0) -- caso pegue um rgb por fora, dividir por 255 se ele n for entre 0 e 1
    love.graphics.arc('fill', pacman.x, pacman.y, pacman.size, pacman.angle1, pacman.angle2)
end