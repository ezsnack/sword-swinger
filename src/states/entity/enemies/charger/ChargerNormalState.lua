ChargerNormalState = Class{__includes = BaseState}

--move towards player, slowly
function ChargerNormalState:init(charger)
	self.charger = charger
	self.chargeTimer = 5--after this many seconds, will start charging
end

function ChargerNormalState:enter()
	self.chargeTimer = 5
end

function ChargerNormalState:update(dt)
	if self.chargeTimer <= 0 then self.charger.stateMachine:change("charging") end
	
	local previousDirection = self.charger.direction
	self.charger.movementVector = PLAYER_POSITION - self.charger.position
	self.charger:move(dt)
	if previousDirection ~= self.charger.direction then
		self.charger:changeAnimation("walk-" .. self.charger.direction)
	end
	Enemy.update(self.charger, dt)
	
	self.chargeTimer = self.chargeTimer - dt
end