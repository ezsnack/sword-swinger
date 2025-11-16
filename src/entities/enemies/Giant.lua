Giant = Class{__includes = Enemy}

--walks around slowly. when player is in range, attacks with a giant sword spin
function Giant:init(def)
	Enemy.init(self, def)
	self.width = 50
	self.height = 50
	self.health = 6
	self.speed = 25
	self.damage = 1
	self.stateMachine = StateMachine{
		["normal"] = function() return GiantNormalState(self) end,--walk around, attack if player in range
		["starting-attack"] = function() return GiantWindupState(self) end,--the delay before attacking
		["attack"] = function() return GiantSwingState(self) end--giant sword swing in a circle
	}
	self.swordlength = 100
	self.attackHitbox = Hitbox{}
	self.pushbackForce = 300
	
	self.offsetx = self.swordlength
	self.offsety = self.swordlength
	
	self.animations = self:createAnimations(ANIMATION_DEFS["giant"])
	self.currentAnimation = self.animations["walk-down"]--use an idle state?
	self.stateMachine:change("normal")
	
	self.deathsound = gSounds["giant-death"]
	self.bloodstainSprite = gTextures["bloodstain-l"]
end

function Giant:update(dt)
	self.stateMachine:update(dt)
	Enemy.update(self, dt)
end