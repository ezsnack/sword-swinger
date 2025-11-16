ChargerChargingState = Class{__includes = BaseState}

--"charge up" for a bit before charging towards player
function ChargerChargingState:init(charger)
	self.charger = charger
	self.timer = 2
end

function ChargerChargingState:enter()
	self.charger:changeAnimation("windup-" .. self.charger.direction)
	self.charger.moving = false
	gSounds["charger-windup-nyeee"]:play()
end

function ChargerChargingState:update(dt)
	if self.timer <= 0 then self.charger.stateMachine:change("charge", PLAYER_POSITION) end
	Enemy.update(self.charger, dt)
	self.timer = self.timer - dt
end