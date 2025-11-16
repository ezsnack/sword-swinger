GiantSwingState = Class{__includes = BaseState}

function GiantSwingState:init(giant)
	self.giant = giant
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
	self.spinOrderIndex = 1 --determines the initial and following positions of the animation & hitbox
	self.spinOrderCounter = 0 --to keep track of elapsed stages of spin
	self.interval = 0.1
	self.nextTimer = self.interval
	self.diagonalHitboxLength = math.sin(45) * self.giant.swordlength
	self.makeHitbox = {
		["down"] = (function() self.giant.attackHitbox.position.x = self.giant.position.x;
			self.giant.attackHitbox.position.y = self.giant.position.y + self.giant.height;
			self.giant.attackHitbox.height = self.giant.swordlength;
			self.giant.attackHitbox.width = self.giant.width;
			self.giant.direction = "down" end),
		["downleft"] = (function() self.giant.attackHitbox.position.x = self.giant.position.x - self.diagonalHitboxLength;
			self.giant.attackHitbox.position.y = self.giant.position.y + self.giant.height;
			self.giant.attackHitbox.height = self.diagonalHitboxLength;
			self.giant.attackHitbox.width = self.diagonalHitboxLength end),
		["left"] = (function() self.giant.attackHitbox.position.x = self.giant.position.x - self.giant.swordlength;
			self.giant.attackHitbox.position.y = self.giant.position.y;
			self.giant.attackHitbox.height = self.giant.height;
			self.giant.attackHitbox.width = self.giant.swordlength;
			self.giant.direction = "left" end),
		["upleft"] = (function() self.giant.attackHitbox.position.x = self.giant.position.x - self.diagonalHitboxLength;
			self.giant.attackHitbox.position.y = self.giant.position.y - self.diagonalHitboxLength;
			self.giant.attackHitbox.height = self.diagonalHitboxLength;
			self.giant.attackHitbox.width = self.diagonalHitboxLength end),
		["up"] = (function() self.giant.attackHitbox.x = self.giant.position.x;
			self.giant.attackHitbox.position.x = self.giant.position.y - self.giant.swordlength;
			self.giant.attackHitbox.height = self.giant.swordlength;
			self.giant.attackHitbox.width = self.giant.width;
			self.giant.direction = "up" end),
		["upright"] = (function() self.giant.attackHitbox.position.x = self.giant.position.x + self.giant.width;
			self.giant.attackHitbox.position.y = self.giant.position.y - self.diagonalHitboxLength;
			self.giant.attackHitbox.height = self.diagonalHitboxLength;
			self.giant.attackHitbox.width = self.diagonalHitboxLength end),
		["right"] = (function() self.giant.attackHitbox.position.x = self.giant.position.x + self.giant.width;
			self.giant.attackHitbox.position.y = self.giant.position.y;
			self.giant.attackHitbox.height = self.giant.height;
			self.giant.attackHitbox.width = self.giant.swordlength;
			self.giant.direction = "right" end),
		["downright"] = (function() self.giant.attackHitbox.position.x = self.giant.position.x + self.giant.width;
			self.giant.attackHitbox.position.y = self.giant.position.y + self.giant.height;
			self.giant.attackHitbox.height = self.diagonalHitboxLength;
			self.giant.attackHitbox.width = self.diagonalHitboxLength end),
	}
end

function GiantSwingState:enter()
	self.giant.damage = 3
	self.giant:changeAnimation("attack")
	self.giant.attacking = true
	self.nextTimer = self.interval
	self.spinOrderCounter = 0
	--need the opposite direction of the giant, for him to pick up the sword behind him and start the spin from there
	--could probably make this more efficient
	local targetDirection = (self.giant.direction == "left" and "right" or
		self.giant.direction == "right" and "left" or
		self.giant.direction == "down" and "up" or
		self.giant.direction == "up" and "down")
	for k,v in pairs(self.spinOrder) do
		if v == targetDirection then
			self.spinOrderIndex = k
			self.giant.currentAnimation.currentFrame = k
			break
		end
	end
	self.makeHitbox[self.spinOrder[self.spinOrderIndex]]()
	self.giant.hitsound = gSounds["giant-swing-hit"]
	gSounds["giant-swing"]:play()
end

function GiantSwingState:exit()
	self.giant.attacking = false
	self.giant.damage = 1
	self.giant.hitsound = gSounds["placeholder-silence"]
end

function GiantSwingState:update(dt)
	if self.nextTimer <= 0 then
		self.makeHitbox[self.spinOrder[self.spinOrderIndex]]()
		Enemy.update(self.giant, dt)
		self.spinOrderCounter = self.spinOrderCounter + 1
		self.spinOrderIndex = self.spinOrderIndex + 1
		if self.spinOrderIndex > 8 then--there are only 8 entries in the list
			self.spinOrderIndex = 1
		end
		if self.spinOrderCounter == 9 then--= 1 full revolution has passed, with the last frame the same as the first one
			self.giant.stateMachine:change("normal")
		end
		self.nextTimer = self.interval
	end
	self.nextTimer = self.nextTimer - dt
end