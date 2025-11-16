Entity = Class{}

function Entity:init(def)
	--position & size
	self.position = def.position
	self.width = def.width
	self.height = def.height
	self.direction = "down" --used for attack direction & animation
	--stats
	self.speed = def.speed
	self.health = def.health
	self.damage = def.damage
	self.stateMachine = {}
	--flags
	self.dead = false
	self.attacking = false
	self.invulnerable = false
	self.moving = false
	self.collidedWithWall = false
	
	self.movementVector = Vector(0, 0)
	self.invulnerableDuration = def.invulnerableDuration or 1
	self.invulnerableTimer = 0
	self.invulnerableFlashingInterval = 0.06
	self.invulnerableFlashingTimer = 0
	self.pushbackDuration = 0 --how long this entity will be pushed back for if it collides & takes damage
	--animations
	self.animations = {}
	self.currentAnimation = nil
	self.offsetx = def.offsetx or 0
	self.offsety = def.offsety or 0
	--sounds
	self.deathsound = def.deathsound or gSounds["placeholder-silence"]
	self.hitsound = def.hitsound or gSounds["placeholder-silence"]
end

function Entity:update(dt)
	if self.invulnerable then
		if self.invulnerableFlashingTimer <= 0 then
			self.invulnerableFlashingTimer = self.invulnerableFlashingInterval
		end
		self.invulnerableTimer = self.invulnerableTimer - dt
		self.invulnerableFlashingTimer = self.invulnerableFlashingTimer - dt
		if self.invulnerableTimer <= 0 then
			self.invulnerable = false
		end
	end
	self.currentAnimation:update(dt)
end

function Entity:render()
	if self.invulnerable and self.invulnerableFlashingTimer <= 0.03 then
		love.graphics.setColor(1,1,1,64/255)--make sprite flash transparent when invulnerable. taken from games50/zelda
	end
	love.graphics.draw(gTextures[self.currentAnimation.texture], gFrames[self.currentAnimation.texture][self.currentAnimation:getCurrentFrame()],
		self.position.x, self.position.y,
		0,1,1,
		self.offsetx, self.offsety)
	love.graphics.setColor(1,1,1,1)
end

function Entity:move(dt)
	self.collidedWithWall = false
	--update direction according to movementVector
	if self.movementVector == Vector(0, 0) then
		self.moving = false
		return--to avoid division by zero in the normalize function. also no movement needed in this case
	end
	if math.abs(self.movementVector.x) > math.abs(self.movementVector.y) then
		if self.movementVector.x > 0 then
			self.direction = "right"
		else
			self.direction = "left"
		end
	else
		if self.movementVector.y > 0 then
			self.direction = "down"
		else
			self.direction = "up"
		end
	end
	
	self.movementVector = self.movementVector:normalize()
	self.position = self.position + self.movementVector:scalarMult(self.speed * dt)
	self:wallCheck()
	self.moving = true
end

function Entity:wallCheck() --dont let entity move past walls
	if self.position.x <= 0 then
		self.position.x = 0
		self.collidedWithWall = true
	elseif self.position.x + self.width >= FIELD_WIDTH then
		self.position.x = FIELD_WIDTH - self.width
		self.collidedWithWall = true
	end
	if self.position.y <= 0 then
		self.position.y = 0
		self.collidedWithWall = true
	elseif self.position.y + self.height >= FIELD_HEIGHT then
		self.position.y = FIELD_HEIGHT - self.height
		self.collidedWithWall = true
	end
end

function Entity:collides(target) --simple aabb collision, all entities are non rotated rectangles
	--if only one of these is true, self and target do not collide
	return not (self.position.x + self.width < target.position.x --self right edge is left of target left edge = outside
		or self.position.x > target.position.x + target.width --self left edge is right of target right edge = outside
		or self.position.y + self.height < target.position.y --self bottom edge is above target top edge = outside
		or self.position.y > target.position.y + target.height) --self top edge is below target bottom edge = outside
end

function Entity:takeDamage(damage)
	self.health = self.health - damage
	if self.health <= 0 then
		self:death()
	else
		self:becomeInvulnerable()
	end
end

function Entity:becomeInvulnerable()
	self.invulnerable = true
	self.invulnerableTimer = self.invulnerableDuration
	self.invulnerableFlashingTimer = self.invulnerableFlashingInterval
end

function Entity:death()
	self.dead = true
	--assert(self.deathsound, "tried to play a non existing sound (on entity death)")
	love.audio.play(self.deathsound)
end

function Entity:createAnimations(animations) --since each entity needs a separate copy of the animations to run independently of the others
	local animationtable = {}
	for i, animation in pairs(animations) do
		animationtable[i] = Animation{texture = animation.texture, frames = animation.frames, interval = animation.interval, looping = animation.looping}
	end
	return animationtable
end

function Entity:changeAnimation(name)
	self.currentAnimation = self.animations[name]
	self.currentAnimation:reset()
end