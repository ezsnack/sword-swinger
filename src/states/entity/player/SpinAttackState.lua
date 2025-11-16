SpinAttackState = Class{__includes = BaseState}

function SpinAttackState:init(player)
	self.player = player
	self.spinTimer = 5
	self.spinOrder = {
		"down",
		"downleft",
		"left",
		"upleft",
		"up",
		"upright",
		"right",
		"downright"
	}
	self.spinOrderCounter = 1
	self.makeHitbox = {
		["down"] = (function() self.player.attackHitbox.position.x = self.player.position.x;
			self.player.attackHitbox.position.y = self.player.position.y + self.player.height;
			self.player.direction = "down" end),
		["downleft"] = (function() self.player.attackHitbox.position.x = self.player.position.x - self.player.swordlength;
			self.player.attackHitbox.position.y = self.player.position.y + self.player.height end),
		["left"] = (function() self.player.attackHitbox.position.x = self.player.position.x - self.player.swordlength;
			self.player.attackHitbox.position.y = self.player.position.y;
			self.player.direction = "left" end),
		["upleft"] = (function() self.player.attackHitbox.position.x = self.player.position.x - self.player.swordlength;
			self.player.attackHitbox.position.y = self.player.position.y - self.player.swordlength end),
		["up"] = (function() self.player.attackHitbox.x = self.player.position.x;
			self.player.attackHitbox.position.x = self.player.position.y - self.player.swordlength;
			self.player.direction = "up" end),
		["upright"] = (function() self.player.attackHitbox.position.x = self.player.position.x + self.player.width;
			self.player.attackHitbox.position.y = self.player.position.y - self.player.swordlength end),
		["right"] = (function() self.player.attackHitbox.position.x = self.player.position.x + self.player.width;
			self.player.attackHitbox.position.y = self.player.position.y;
			self.player.direction = "right" end),
		["downright"] = (function() self.player.attackHitbox.position.x = self.player.position.x + self.player.width;
			self.player.attackHitbox.position.y = self.player.position.y + self.player.height end)
	}
	self.interval = 0.03
	self.nextTimer = self.interval
end

function SpinAttackState:enter()
	self.player:changeAnimation("spin")
	self.player.attacking = true
	self.player.invulnerable = true
	self.nextTimer = self.interval
	for k,v in pairs(self.spinOrder) do
		if v == self.player.direction then
			self.spinOrderCounter = k
			self.player.currentAnimation.currentFrame = k
			break
		end
	end
	gSounds["player-spin"]:play()
end

function SpinAttackState:exit()
	self.player.attacking = false
	self.player.invulnerable = false
	self.player.rage = 0
	gSounds["player-spin"]:stop()
end

function SpinAttackState:update(dt)
	--movement
	if love.keyboard.isScancodeDown('w') then
		self.player.movementVector = self.player.movementVector + Vector(0, -1)
	end
	if love.keyboard.isScancodeDown('s') then
		self.player.movementVector = self.player.movementVector + Vector(0, 1)
	end
	if love.keyboard.isScancodeDown('a') then
		self.player.movementVector = self.player.movementVector + Vector(-1, 0)
	end
	if love.keyboard.isScancodeDown('d') then
		self.player.movementVector = self.player.movementVector + Vector(1, 0)
	end
	self.player:move(dt)
	self.player.movementVector:reset()
	
	--exit when spinTimer runs out
	if self.spinTimer <= 0 then
		self.player.stateMachine:change("normal")
	end
	--update next direction when nextTimer runs out
	if self.nextTimer <= 0 then
		if self.spinOrder[self.spinOrderCounter + 1] then
			self.spinOrderCounter = self.spinOrderCounter + 1
		else
			self.spinOrderCounter = 1
		end
		self.nextTimer = self.interval
	end
	self.makeHitbox[self.spinOrder[self.spinOrderCounter]]()--update hitbox
	self.nextTimer = self.nextTimer - dt
	self.spinTimer = self.spinTimer - dt
	self.player.currentAnimation:update(dt)--instead of Entity:update(), so the invulnerability wont tick down
end

function SpinAttackState:render()
	love.graphics.draw(gTextures[self.player.currentAnimation.texture], gFrames[self.player.currentAnimation.texture][self.player.currentAnimation:getCurrentFrame()],
	self.player.position.x, self.player.position.y,
	0,1,1,--orientation and scale factor, defaults
	self.player.width, self.player.height--x and y offsets for the spin sprites
	)
end
