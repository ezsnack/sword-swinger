NormalState = Class{__includes = BaseState}

function NormalState:init(player)
	self.player = player
	self.wasMoving = player.moving --for updating animations
	self.previousDirection = self.player.direction --for checking whether to switch animations
end
function NormalState:enter()
	self.player:changeAnimation("idle-" .. self.player.direction)
end

function NormalState:update(dt)
	
	for k, v in ipairs(ATTACK_KEYS) do
		if love.keyboard.isScancodeDown(v) then
			self.player:attack(v)
		end
	end
	
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
	
	self.player:move(dt)--this will set player.direction to match the movement
	if self.player.attacking then self.player.direction = self.player.attackDirection end--but if attacking, face in the direction of the attack
	if not self.player.moving and (self.wasMoving or self.previousDirection ~= self.player.direction) then
		self.player:changeAnimation("idle-" .. self.player.direction)
	elseif self.player.moving and (not self.wasMoving or self.previousDirection ~= self.player.direction) then
		self.player:changeAnimation("walk-" .. self.player.direction)
	end
	
	if self.player.attacking then
		if self.player.attackTimer <= 0 then
			self.player.attacking = false
		else--update attack hitbox
			if self.player.attackDirection == "up" then
				self.player.attackHitbox.position.x = self.player.position.x
				self.player.attackHitbox.position.y = self.player.position.y - self.player.swordlength
			elseif self.player.attackDirection == "down" then
				self.player.attackHitbox.position.x = self.player.position.x
				self.player.attackHitbox.position.y = self.player.position.y + self.player.height
			elseif self.player.attackDirection == "left" then
				self.player.attackHitbox.position.x = self.player.position.x - self.player.swordlength
				self.player.attackHitbox.position.y = self.player.position.y
			elseif self.player.attackDirection == "right" then
				self.player.attackHitbox.position.x = self.player.position.x + self.player.width
				self.player.attackHitbox.position.y = self.player.position.y
			end
			Animation.update(self.player.currentSwordAnimation, dt)
			self.player.attackTimer = self.player.attackTimer - dt
		end
	end
	
	self.player.movementVector:reset()
	self.wasMoving = self.player.moving
	self.previousDirection = self.player.direction
	
	Entity.update(self.player, dt)
	
	if love.keyboard.isScancodeDown("space") and self.player.rage >= self.player.rageNeededToSpin then
		self.player.stateMachine:change("spin")
	end
end

function NormalState:render()
	Entity.render(self.player)
	if self.player.attacking then
		love.graphics.draw(gTextures[self.player.currentSwordAnimation.texture], gFrames[self.player.currentSwordAnimation.texture][self.player.currentSwordAnimation:getCurrentFrame()], self.player.attackHitbox.position.x, self.player.attackHitbox.position.y)
	end
end