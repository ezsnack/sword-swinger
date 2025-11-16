GiantWindupState = Class{__includes = BaseState}

function GiantWindupState:init(giant)
	self.giant = giant
	self.windupTimer = 1
end

function GiantWindupState:enter()
	self.windupTimer = 1
	self.giant:changeAnimation("windup-" .. self.giant.direction)
	gSounds["giant-pickup-grunt"]:play()
end

function GiantWindupState:update(dt)
	if self.windupTimer <= 0 then self.giant.stateMachine:change("attack") end
	self.windupTimer = self.windupTimer - dt
	Enemy.update(self.giant, dt)
end