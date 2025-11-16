Hitbox = Class{}

function Hitbox:init(def)
	self.position = def.position or Vector(0, 0)
	self.width = def.width or 0
	self.height = def.height or 0
end