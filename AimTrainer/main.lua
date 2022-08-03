function love.load()
    math.randomseed(os.time())

    Screen_width = 1920
    Screen_height = 1080

    love.window.setMode(Screen_width, Screen_height, {fullscreen=true})

    Target = {}
    Target.x = 300
    Target.y = 300
    Target.radius = 100

    Hits = 0
    Misses = 0
    Timer = 0

    GameFont = love.graphics.newFont(40)
end

function love.update(dt)
    Timer = Timer + dt
end

function love.draw()
    love.graphics.setColor(0, 1, 0)
    love.graphics.setFont(GameFont)
    love.graphics.print(Hits, 0, 0)

    love.graphics.setColor(1, 0, 0)
    love.graphics.circle("fill", Target.x, Target.y, Target.radius)
    love.graphics.print(Misses, 0, 40)
end

function love.mousepressed(x, y, button)
    local dx = x - Target.x
    local dy = y - Target.y
    if button == 1 then
        if dx^2 + dy^2 <= Target.radius^2 then
            Target.x = math.random(Target.radius, Screen_width - Target.radius)
            Target.y = math.random(Target.radius, Screen_height - Target.radius)
            Hits = Hits + 1
        else
            Misses = Misses + 1
        end
    end

    if Hits + Misses >= 30 then
        print(string.format("Количество попаданий: %d", Hits))
        print(string.format("Ваше время: %.1f секунд", Timer))
        love.event.quit()
    end
end
