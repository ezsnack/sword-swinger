GiantNormalState = Class{__includes = BaseState}

function GiantNormalState:init(giant)
	self.giant = giant
	self.timer = 5
	self.searchDistance = self.giant.swordlength
end

function GiantNormalState:enter()
	self.giant:chooseNewDirection()
	self.timer = math.random(5, 10)
	self.giant:changeAnimation("walk-" .. self.giant.direction)
end

function GiantNormalState:update(dt)
	if (PLAYER_POSITION - self.giant.position):len() < self.searchDistance then
		self.giant.stateMachine:change("starting-attack")
	end
	
	self.timer = self.timer - dt
	if self.giant.collidedWithWall or self.timer <= 0 then
		self.giant:chooseNewDirection()
		self.giant:changeAnimation("walk-" .. self.giant.direction)
		self.timer = math.random(5, 10)
	end
	self.giant:move(dt)
	Enemy.update(self.giant, dt)
end