Vector = Class{}

function Vector:init(x, y)
	self.x = x
	self.y = y
	local metatable = getmetatable(self)
	metatable.__add = function(self, other) return Vector(self.x + other.x, self.y + other.y) end
	metatable.__sub = function(self, other) return Vector(self.x - other.x, self.y - other.y) end
	metatable.__unm = function(self) return Vector(-self.x, -self.y) end
	metatable.__eq = function(self, other) return self.x == other.x and self.y == other.y end
	--metatable.__mul =
end

function Vector:len()
	return (self.x^2 + self.y^2)^0.5 --^0.5 = square root
end

function Vector:normalize() --get unit vector
	return self:scalarDiv(self:len())
end

function Vector:scalarMult(i)
	return Vector(self.x * i, self.y * i)
end

function Vector:scalarDiv(i)
	return Vector(self.x / i, self.y / i)
end

function Vector:reset()
	self.x, self.y = 0, 0
end