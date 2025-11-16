Enemy = Class{__includes = Entity}

function Enemy:init(def)
	Entity.init(self, def)
	self.damage = def.damage or 1
	self.pushbackForce = 0 --force with which a colliding entity will be pushed back
	self.bloodstainSprite = def.bloodstainSprite or gTextures["bloodstain-m"]
end

function Enemy:update(dt)
	Entity.update(self, dt)
end

function Enemy:render()
	Entity.render(self)
end

function Enemy:chooseNewDirection()
	local x = math.random(4)
	if x == 1 then
		self.movementVector = Vector(0, 1)
		self.direction = "down"
	elseif x == 2 then
		self.movementVector = Vector(1, 0)
		self.direction = "right"
	elseif x == 3 then
		self.movementVector = Vector(-1, 0)
		self.direction = "left"
	elseif x == 4 then
		self.movementVector = Vector(0, -1)
		self.direction = "up"
	end
end