Charger = Class{__includes = Enemy}

--this enemy can charge at the player

function Charger:init(def)
	Enemy.init(self, def)
	self.stateMachine = StateMachine{
		["seeking"] = function() return ChargerNormalState(self) end,
		["charging"] = function() return ChargerChargingState(self) end,--"charging up" before charging at player
		["charge"] = function() return ChargerChargeState(self) end,--charging at player, until a wall is hit
		["recover"] = function() return ChargerRecoverState(self) end
	}
	self.height = 40
	self.width = 40
	self.health = 3
	self.damage = 1
	self.baseSpeed = 25
	self.chargeSpeed = 600
	self.speed = self.baseSpeed
	self.basePushbackForce = 300
	self.chargePushbackForce = 600
	self.pushbackForce = self.basePushbackForce
	
	self.animations = self:createAnimations(ANIMATION_DEFS["charger"])
	self.currentAnimation = self.animations["walk-down"]
	self.stateMachine:change("seeking")
	
	self.deathsound = gSounds["charger-death"]
	self.bloodstainSprite = gTextures["bloodstain-m"]
end

function Charger:update(dt)
	self.stateMachine:update(dt)
	Enemy.update(self, dt)
end