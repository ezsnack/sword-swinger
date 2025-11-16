Goblin = Class{__includes = Enemy}

--this enemy is just running toward the player

function Goblin:init(def)
	Enemy.init(self, def)
	self.width = 25
	self.height = 25
	self.speed = 50
	self.health = 3
	self.damage = 1
	self.invulnerableDuration = 1
	self.pushbackForce = 300
	
	self.animations = self:createAnimations(ANIMATION_DEFS["goblin"])
	self.currentAnimation = self.animations["walk-down"]
	
	self.deathsound = gSounds["goblin-death"]
	self.hitsound = gSounds["goblin-hit"]
	self.bloodstainSprite = gTextures["bloodstain-m"]
end

function Goblin:update(dt)
	local previousDirection = self.direction
	self.movementVector = PLAYER_POSITION - self.position--will be normalized in Entity.move()
	self:move(dt)
	if previousDirection ~= self.direction then
		self:changeAnimation("walk-" .. self.direction)
	end
	Enemy.update(self, dt)
end