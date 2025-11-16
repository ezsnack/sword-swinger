ChargerRecoverState = Class{__includes = BaseState}

function ChargerRecoverState:init(charger)
	self.charger = charger
	self.recoverDuration = 2
	self.timer = self.recoverDuration
end

function ChargerRecoverState:enter()
	self.charger:changeAnimation("recover-" .. self.charger.direction)
	self.timer = self.recoverDuration
end

function ChargerRecoverState:update(dt)
	if self.timer <= 0 then self.charger.stateMachine:change("seeking") end
	Enemy.update(self.charger, dt)
	self.timer = self.timer - dt
end