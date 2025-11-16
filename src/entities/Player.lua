Player = Class{__includes = Entity}

function Player:init(def)
	Entity.init(self, def)
	self.height = 25
	self.width = 25
	self.health = 10
	self.damage = 1
	self.rage = 0
	self.rageMax = 10
	self.rageNeededToSpin = 10
	self.speed = 300
	self.swordlength = 25
	self.attackDuration = 0.2
	self.attackTimer = self.attackDuration
	self.attackDirection = "down"
	self.invulnerableDuration = 1
	self.attackHitbox = Hitbox{width = self.swordlength, height = self.swordlength}
	self.pushbackDuration = 0.3
	
	self.animations = self:createAnimations(ANIMATION_DEFS["player"])
	self.currentAnimation = self.animations["idle-down"]
	self.swordAnimations = self:createAnimations(ANIMATION_DEFS["sword"])
	self.currentSwordAnimation = self.swordAnimations["sword-down"]
	
	self.deathsound = gSounds["player-death"]
	self.hitsound = gSounds["player-sword-hit"]
	
	--the player state machine is set up in PlayState
end

function Player:update(dt)
	self.stateMachine:update(dt)
end

function Player:render()
	self.stateMachine:render()
end

function Player:death()
	self.deathsound:play()
	gStateMachine:change("gameover")
end

function Player:attack(direction)
	if not self.attacking then
		self.attackDirection = direction
		self.attacking = true
		self.attackTimer = self.attackDuration
		self.currentSwordAnimation = self.swordAnimations["sword-" .. self.attackDirection]
		self.currentSwordAnimation:reset()
		gSounds["player-sword-swing"]:play()
	end
end