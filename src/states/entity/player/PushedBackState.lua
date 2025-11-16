PushedBackState = Class{__includes = BaseState}

function PushedBackState:init(player)
	self.player = player
	self.pushbackTimer = 0
	self.from = Vector(0, 0)
	self.pushForce = 0
end

function PushedBackState:enter(from, pushForce)
	self.player.attacking = false
	self.from = from
	self.pushForce = pushForce
	self.pushbackTimer = self.player.pushbackDuration
	self.player:changeAnimation("knocked-back")
end

function PushedBackState:update(dt)
	if self.pushbackTimer <= 0 then
		self.player.stateMachine:change("normal")
	end
	self.pushbackTimer = self.pushbackTimer - dt
	self.player.position = self.player.position + -(self.from - self.player.position):normalize():scalarMult(self.pushForce * dt)
	self.player:wallCheck()
	Entity.update(self.player, dt)
end

function PushedBackState:render()
	Entity.render(self.player)
end