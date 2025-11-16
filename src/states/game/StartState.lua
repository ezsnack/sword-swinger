StartState = Class{__includes = BaseState}

function StartState:update(dt)
	if love.keyboard.isScancodeDown("escape") then
		love.event.quit()
	end
	if love.keyboard.isScancodeDown("space") then
		gStateMachine:change("play")
	end
end

function StartState:render()
	love.graphics.printf("press space to play!!", 0, WINDOW_HEIGHT / 2, WINDOW_WIDTH, "center")
end