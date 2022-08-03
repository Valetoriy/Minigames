function love.load()
    Screen_width = 1920
    Screen_height = 1080
    love.window.setMode(Screen_width, Screen_height, {fullscreen=true})
    math.randomseed(os.time())
    GameFont = love.graphics.newFont(100)
    love.graphics.setFont(GameFont)

    Player = {
        width = 10,
        height = 200,
        speed = 1000,
    }

    Ball = {
        radius = 30,
    }

    Enemy = {
        width = 10,
        height = 200,
    }

    Timer = 0

    Wins = 0
    Losses = 0

    ResetGame()
end

function love.update(dt)
    Timer = Timer + dt

    if love.keyboard.isDown('up') and Player.y > Player.height / 2 then
        Player.y = Player.y - Player.speed * dt
    end

    if love.keyboard.isDown('down') and Player.y < Screen_height - Player.height / 2 then
        Player.y = Player.y + Player.speed * dt
    end

    if love.keyboard.isDown('space') then
        ResetGame()
    end

    Ball.x = Ball.x + Ball.dx
    Ball.y = Ball.y + Ball.dy

    if Ball.y > Enemy.height / 2 and Ball.y < Screen_height - Enemy.height / 2 then
        local diff = Ball.y - Enemy.y
        Enemy.y = Enemy.y + 15 * diff * dt
    end

    -- Отскок мяча от вехрней и нижней частей экрана
    if Ball.y < Ball.radius or Ball.y > Screen_height - Ball.radius then
        Ball.dy = Ball.dy * -1
    end

    -- Проверка на столкновение мяча с игроками
    for _, rect in pairs({Player, Enemy}) do
        local distX = math.abs(Ball.x - rect.x)
        local distY = math.abs(Ball.y - rect.y)

        if Timer > 0.3 then
            local hit = false
            -- Л и П
            if distX <= rect.width / 2 + Ball.radius and distY <= rect.height / 2 then
                Ball.dx = Ball.dx * -1
                hit = true
            -- В и Н
            elseif distY <= rect.height / 2 + Ball.radius and distX <= rect.width / 2 then
                Ball.dy = Ball.dy * -1
                hit = true
            -- Углы
            elseif (distX - rect.width / 2)^2 + (distY - rect.height / 2)^2 <= Ball.radius then
                Ball.dx = Ball.dx * -1
                Ball.dy = Ball.dy * -1
                hit = true
            end

            if hit then
                Timer = 0

                -- При отскоке от игрока мяч случайно отклоняется
                local rand_deg = math.random(-30, 30)
                Ball.dx = Ball.dx * math.cos(rand_deg / 180 * math.pi)
                    - Ball.dy * math.sin(rand_deg / 180 * math.pi)
                Ball.dy = Ball.dy * math.cos(rand_deg / 180 * math.pi)
                    + Ball.dx * math.sin(rand_deg / 180 * math.pi)
                -- И ускоряется
                Ball.dx = Ball.dx * 1.05
                Ball.dy = Ball.dy * 1.05
            end
        end
    end

    if Ball.x < Player.x + Player.width / 2 then
        Losses = Losses + 1
        ResetGame()
    end
    if Ball.x > Enemy.x - Enemy.width / 2 then
        Wins = Wins + 1
        ResetGame()
    end
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", Player.x - Player.width / 2,
        Player.y - Player.height / 2, Player.width, Player.height)

    love.graphics.circle("fill", Ball.x, Ball.y, Ball.radius)

    love.graphics.rectangle("fill", Enemy.x - Enemy.width / 2,
        Enemy.y - Enemy.height / 2, Enemy.width, Enemy.height)

    love.graphics.setColor(0, 1, 0)
    love.graphics.print(Wins, 0, 0)
    love.graphics.setColor(1, 0, 0)
    love.graphics.print(Losses, 0, 100)
end

function ResetGame()
    Player.x = Screen_width / 10
    Player.y = Screen_height / 2

    Ball.x = Screen_width / 2
    Ball.y = Screen_height / 2
    local rand_deg = math.random(-30, 30)
    Ball.dx = math.cos(rand_deg / 180 * math.pi) * 10
    Ball.dy = -math.sin(rand_deg / 180 * math.pi) * 10

    Enemy.x = Screen_width - Screen_width / 10
    Enemy.y = Screen_height / 2
end
