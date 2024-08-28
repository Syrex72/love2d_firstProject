_G.love = require('love')

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    _G.uganda = {
        x = 0,
        y = 0,
        -- 36w x 72h
        sprite = {
            image = love.graphics.newImage("assets/uganda.png"),
            w = 36,
            h = 72
        },
        animation = {
            direction = "down",
            direction_sprite = 1,
            idle = true, 
            frame = 1,
            max_frames = 3,
            speed = 2,
            timer = 0.1
        }
        
    }

    _G.sprite_size = {
        w = 12,
        h = 18
    }

    _G.quads = {}
    for i = 1, 4 do
        quads[i] = {}
        for j = 1, 3 do
            quads[i][j] = love.graphics.newQuad(sprite_size.w * (j-1), sprite_size.h * (i-1), sprite_size.w, sprite_size.h, uganda.sprite.w, uganda.sprite.h)
        end
    end

    
end

function love.update(dt)
    -- ativando e desativando a iddle animation e definindo a direção que meu player está indo 
    if love.keyboard.isDown("w") then
        uganda.animation.idle = false
        uganda.animation.direction = "up"
    elseif love.keyboard.isDown("d") then
        uganda.animation.idle = false
        uganda.animation.direction = "right"
    elseif love.keyboard.isDown("a") then
        uganda.animation.idle = false
        uganda.animation.direction = "left"
    elseif love.keyboard.isDown("s") then
        uganda.animation.idle = false
        uganda.animation.direction = "down"
    else
        uganda.animation.idle = true
        uganda.animation.frame = 1
    end

    -- define o tempo para executar a animação
    if not uganda.animation.idle then
        uganda.animation.timer = uganda.animation.timer + dt
        
        -- fica resetando o time sla pq 
        if uganda.animation.timer > 0.2 then
            uganda.animation.timer = 0.1 
            -- passa para o proximo frame
            uganda.animation.frame = uganda.animation.frame + 1

            if uganda.animation.direction == "right" then
                uganda.x = uganda.x + uganda.animation.speed
                uganda.animation.direction_sprite = 3
            elseif uganda.animation.direction == "up"  then
                uganda.y = uganda.y - uganda.animation.speed
                uganda.animation.direction_sprite = 2

            elseif uganda.animation.direction == "down" then
                uganda.y = uganda.y + uganda.animation.speed
                uganda.animation.direction_sprite = 1
                
            elseif uganda.animation.direction == "left" then
                uganda.x = uganda.x - uganda.animation.speed
                uganda.animation.direction_sprite = 4

            end
            -- reseta os frames quando chega no tamanho máximo
            if uganda.animation.frame > uganda.animation.max_frames then
                uganda.animation.frame = 1
            end
        end
    end

end

function love.draw()
    
    love.graphics.scale(10)
    love.graphics.draw(uganda.sprite.image, quads[uganda.animation.direction_sprite][uganda.animation.frame], uganda.x, uganda.y)
end


