GameWinState = Class({ __includes = BaseState })

function GameWinState:init()
	self.soundTimeout = 3
end

function GameWinState:update(dt)
	if love.keyboard.isScancodeDown("escape") then
		love.event.quit()
	end
	self.soundTimeout = self.soundTimeout - dt
	if self.soundTimeout <= 0 then
		love.audio.stop()
	end
end

function GameWinState:render()
	love.graphics.setColor(0, 255, 0, 255)
	love.graphics.printf("YOU WIN!!!!!!!!!!!!!\nNICE!!", 0, WINDOW_HEIGHT / 2, WINDOW_WIDTH, "center")
end

