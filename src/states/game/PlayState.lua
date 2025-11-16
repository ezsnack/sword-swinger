PlayState = Class{__includes = BaseState}

function PlayState:init()
	self.player = Player({position = Vector(FIELD_WIDTH / 2, FIELD_HEIGHT / 2)})
	self.field = Field(self.player)
	self.player.stateMachine = StateMachine{
		["normal"] = function() return NormalState(self.player) end,
		["spin"] = function() return SpinAttackState(self.player) end,
		["pushback"] = function() return PushedBackState(self.player) end
	}
	self.player.stateMachine:change("normal")
	self.hpBarPosition = Vector(WINDOW_WIDTH / 2 - 100, WINDOW_HEIGHT - 40)
	self.rageBarPosition = Vector(WINDOW_WIDTH /2 - 100, WINDOW_HEIGHT - 20)
end

function PlayState:update(dt)
	if love.keyboard.isScancodeDown("escape") then
		love.event.quit()
	end
	self.field:update(dt)
end

function PlayState:render()
	self.field:render()
	love.graphics.setColor(255,0,0,255)
	love.graphics.print("HP", self.hpBarPosition.x - 20, self.hpBarPosition.y - 3)
	for i = 0, self.player.health - 1 do
		love.graphics.rectangle("fill", self.hpBarPosition.x + 10 * i, self.hpBarPosition.y, 8, 8)
	end
	if self.player.rage == self.player.rageMax then--when rage at max, make the bar green
		love.graphics.setColor(0,255,0,255)
	else
		love.graphics.setColor(255,255,0,255)
	end
	love.graphics.print("RAGE", self.rageBarPosition.x - 40, self.rageBarPosition.y - 3)
	for i = 0, self.player.rage - 1 do
		love.graphics.rectangle("fill", self.rageBarPosition.x + 10 * i, self.rageBarPosition.y, 8, 8)
	end
	love.graphics.reset()
end
