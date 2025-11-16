Roach = Class{__includes = Enemy}

--this enemy moves around randomly
function Roach:init(def)
	Enemy.init(self, def)
	self.width = 15
	self.height = 15
	self.speed = 100
	self.health = 1
	self.damage = 1
	self.pushbackForce = 100
	self.timer = math.random(5)
	self.animations = self:createAnimations(ANIMATION_DEFS["roach"])
	self:chooseNewDirection()
	self.currentAnimation = self.animations["walk-" .. self.direction]
	
	self.deathsound = gSounds["roach-death"]
	self.bloodstainSprite = gTextures["bloodstain-s"]
end

function Roach:update(dt)
	self.timer = self.timer - dt
	if self.timer <= 0 then
		self:chooseNewDirection()
		self:changeAnimation("walk-" .. self.direction)
		self.timer = math.random(5)
	end
	Enemy.update(self, dt)
	self:move(dt)
end