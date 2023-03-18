function love.load()
    JSON = require "json"
    HELPERS = require "helpers"
    CLASSES = require "classes"

    tile = CLASSES.tile

    WINDOW_WIDTH, WINDOW_HEIGHT = love.graphics.getDimensions()

    OBJECT = JSON.decode(love.filesystem.read('maps/map_1.json'))

    function spriteMaker(image, width, height)
        local animation = {}
        animation.spriteSheet = image;
        animation.quads = {};

        for y = 0, image:getHeight() - height, height do
            for x = 0, image:getWidth() - width, width do
                table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
            end
        end

        animation.maxFrames = (image:getWidth()/width) * (image:getHeight()/height)
        return animation
    end

    function updateFrame(self, dt)
        self.timer = self.timer + dt * self.animationSpeed
        if (self.timer >= self.animation.maxFrames + 1) then
                self.timer = 1
            end
        self.frame = math.floor(self.timer)
    end

    character = {
        x = WINDOW_WIDTH / 2,
        y = WINDOW_HEIGHT / 2,
        wx = 32,
        wy = 32,
        v = 200,
        inputs = { w = 0, s = 0, a = 0, d = 0 },
        image = love.graphics.newImage("images/little_farmer_sprite-Sheet.png"),
        angle = 0,
        timer = 1,
        frame = 1,
        animationSpeed = 12,
        updateFrame = updateFrame,
        animation = spriteMaker(love.graphics.newImage("images/little_farmer_sprite-Sheet.png"), 32, 32),
        
        move = function(self, dt)
            if (self.inputs.w - self.inputs.s ~= 0 or self.inputs.a - self.inputs.d ~= 0) then
                character:updateFrame(dt)
                self.angle = math.atan2((self.inputs.w - self.inputs.s), (self.inputs.d - self.inputs.a))

                self.x = self.x + self.v * dt * math.cos(self.angle)
                self.y = self.y + self.v * dt * -math.sin(self.angle)
            else
                self.timer, self.frame = 1, 1
            end
        end,
        
        draw = function(self)
            local flip = 1
            if (self.angle < math.pi / 2 and self.angle > -math.pi / 2) then flip = -1 end
            love.graphics.draw(self.image, self.animation.quads[self.frame], self.x, self.y, 0, flip, 1, self.wx/2, self.wy/2)
        end
    }

end

function love.keypressed(key, scancode, isrepeat)

end

function love.mousepressed(x, y, button, istouch, presses)

end

function love.update(dt)

    character.inputs = { w = 0, s = 0, a = 0, d = 0 }

    if (love.keyboard.isDown("w")) then character.inputs.w = 1 end
    if (love.keyboard.isDown("a")) then character.inputs.a = 1 end
    if (love.keyboard.isDown("s")) then character.inputs.s = 1 end
    if (love.keyboard.isDown("d")) then character.inputs.d = 1 end

    character:move(dt)
end

function love.draw()
    -- love.graphics.print(tostring(character.timer), 0, 0)

    character:draw()
end
