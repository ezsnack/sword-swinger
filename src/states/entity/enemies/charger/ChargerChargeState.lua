ChargerChargeState = Class{__includes = BaseState}

--charge towards player
function ChargerChargeState:init(charger)
	self.charger = charger
end

function ChargerChargeState:enter()
	self.charger.damage = 3
	self.charger.movementVector = (PLAYER_POSITION - self.charger.position)
	if math.abs(self.charger.movementVector.x) > math.abs(self.charger.movementVector.y) then
		if self.charger.movementVector.x > 0 then
			self.charger.direction = "right"
		else
			self.charger.direction = "left"
		end
	else
		if self.charger.movementVector.y > 0 then
			self.charger.direction = "down"
		else
			self.charger.direction = "up"
		end
	end
	self.charger.speed = self.charger.chargeSpeed
	self.charger.pushbackForce = self.charger.chargePushbackForce
	self.charger:changeAnimation("charge-" .. self.charger.direction)
	self.charger.hitsound = gSounds["charger-rush-hit"]
	gSounds["charger-rush"]:play()
end

function ChargerChargeState:exit()
	self.charger.speed = self.charger.baseSpeed
	self.charger.pushbackForce = self.charger.basePushbackForce
	self.charger.damage = 1
	self.charger.hitsound = gSounds["placeholder-silence"]
	gSounds["charger-rush"]:stop()
end

function ChargerChargeState:update(dt)
	self.charger:move(dt)
	Enemy.update(self.charger, dt)
	if self.charger.collidedWithWall then
		self.charger.stateMachine:change("recover")
	end
end