GameOverState = Class({ __includes = BaseState })

function GameOverState:init()
	self.soundTimeout = 3
end

function GameOverState:update(dt)
	if love.keyboard.isScancodeDown("escape") then
		love.event.quit()
	end
	self.soundTimeout = self.soundTimeout - dt
	if self.soundTimeout <= 0 then
		love.audio.stop()
	end
end

function GameOverState:render()
	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.printf("YOU DIED", 0, WINDOW_HEIGHT / 2, WINDOW_WIDTH, "center")
end

