Bloodstain = Class{}

function Bloodstain:init(def)
	self.sprite = def.sprite
	self.position = def.position
	self.timer = 5
end

function Bloodstain:update(dt)
	self.timer = self.timer - dt
end

function Bloodstain:render()
	love.graphics.draw(self.sprite, self.position.x, self.position.y)
end