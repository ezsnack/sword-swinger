Animation = Class{}

function Animation:init(def)
	self.texture = def.texture
	self.frames = def.frames
	self.interval = def.interval
	self.timer = self.interval
	self.currentFrame = 1
	self.looping = def.looping or true
end

function Animation:update(dt)
	if #self.frames > 1 then
		self.timer = self.timer - dt
		if self.timer <= 0 and self.looping then
			self.currentFrame = self.currentFrame + 1
			if self.currentFrame > #self.frames then
				self.currentFrame = 1
			end
			self.timer = self.timer + self.interval
		end
	end
end

function Animation:reset()
	self.currentFrame = 1
	self.timer = self.interval
end

function Animation:getCurrentFrame()
	return self.frames[self.currentFrame]
end