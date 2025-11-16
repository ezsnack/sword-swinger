Field = Class{}

FIELD_WIDTH = 700
FIELD_HEIGHT = 700

function Field:init(player)
	self.player = player
	self.enemies = {}
	self.bloodstains = {}
	self.spawnpoints = {
		Vector(50, 50),--1, top left
		Vector(FIELD_WIDTH - 100, 50),--2, top right
		Vector(50, FIELD_HEIGHT - 100),--3, bottom left
		Vector(FIELD_WIDTH - 100, FIELD_HEIGHT - 100),--4, bottom right
		Vector(FIELD_WIDTH / 2 - 50, 50),--5, top center
		Vector(FIELD_WIDTH / 2 - 50, FIELD_HEIGHT - 100)--6, bottom center
	}
	
	self.currentWave = 1
	self.finalWave = 5
	self.waveTimer = 0
	self.totalEnemiesThisWave = #WAVES[self.currentWave]
	self.waveAllSpawned = false
	self.spawnIndex = 1
end

function Field:update(dt)
	if not self.waveAllSpawned and self.waveTimer >= WAVES[self.currentWave][self.spawnIndex].time then
		self:spawnEnemy(WAVES[self.currentWave][self.spawnIndex].enemy, WAVES[self.currentWave][self.spawnIndex].spawnpoint)
		self.spawnIndex = self.spawnIndex + 1
	end
	if self.spawnIndex > self.totalEnemiesThisWave then self.waveAllSpawned = true end
	self.waveTimer = self.waveTimer + dt
	if self.waveAllSpawned and #self.enemies == 0 then
		self:nextWave()
	end
	self:processEnemies(dt)
	self:processPlayer(dt)
	self:clear()
	self:updateBloodstains(dt)
end

function Field:render()
	for _, bloodstain in pairs(self.bloodstains) do
		bloodstain:render()
	end
	for _, enemy in pairs(self.enemies) do
		enemy:render()
	end
	self.player:render()
end

function Field:spawnEnemy(enemyType, location)
	if enemyType == "roach" then
		table.insert(self.enemies, Roach({position = self.spawnpoints[location]}))
	elseif enemyType == "goblin" then
		table.insert(self.enemies, Goblin({position = self.spawnpoints[location]}))
	elseif enemyType == "charger" then
		table.insert(self.enemies, Charger({position = self.spawnpoints[location]}))
	elseif enemyType == "giant" then
		table.insert(self.enemies, Giant({position = self.spawnpoints[location]}))
	end
end

function Field:processPlayer(dt)
	self.player:update(dt)
	PLAYER_POSITION = self.player.position
	for _, enemy in pairs(self.enemies) do
		if self.player:collides(enemy) or enemy.attacking and self.player:collides(enemy.attackHitbox) then
			if not self.player.invulnerable then
				self.player:takeDamage(enemy.damage)
				self.player.stateMachine:change("pushback", enemy.position, enemy.pushbackForce)
				love.audio.play(enemy.hitsound)
				gSounds["player-hurt"]:play()
			end
			if not enemy.dead and self.player:collides(enemy) then
				local v = enemy.position - self.player.position
				if math.abs(v.x) > math.abs(v.y) then
					if v.x > 0 then
						self.player.position.x = enemy.position.x - self.player.width
					else
						self.player.position.x = enemy.position.x + enemy.width
					end
				else --also triggers if abs(v.x) == abs(v.y)
					if v.y > 0 then
						self.player.position.y = enemy.position.y - self.player.height
					else
						self.player.position.y = enemy.position.y + enemy.height
					end
				end
			end
		end
	end
end

function Field:processEnemies(dt)
	for i, enemy in pairs(self.enemies) do
		if not enemy.dead then
			enemy:update(dt)
			for j, other in pairs(self.enemies) do
				--check for collision with other enemies, and make it so enemies dont overlap
				if i ~= j then --don't check for collision with itself
					if not other.dead and enemy:collides(other) then
						local v = other.position - enemy.position
						if math.abs(v.x) > math.abs(v.y) then
							if v.x > 0 then
								enemy.position.x = other.position.x - enemy.width
							else
								enemy.position.x = other.position.x + other.width
							end
						else --also triggers if abs(v.x) == abs(v.y)
							if v.y > 0 then
								enemy.position.y = other.position.y - enemy.height
							else
								enemy.position.y = other.position.y + other.height
							end
						end
					end
				end
				--check if colliding with the player's attack hitbox, if the player is currently attacking
				if self.player.attacking and not enemy.invulnerable and not enemy.dead and enemy:collides(self.player.attackHitbox) then
					enemy:takeDamage(self.player.damage)
					if enemy.dead then table.insert(self.bloodstains, Bloodstain{sprite = enemy.bloodstainSprite, position = enemy.position}) end
					love.audio.play(self.player.hitsound)
					self.player.rage = math.min(self.player.rage + 1, self.player.rageMax)
				end
			end
		end
	end
end

--remove dead entities and nil references
function Field:clear()
	for i = #self.enemies, 1, -1 do --from #self.enemies down to 1, in steps of -1
		if not self.enemies[i] or self.enemies[i].dead then
			table.remove(self.enemies, i)
		end
	end
end

function Field:updateBloodstains(dt)
	for i = #self.bloodstains, 1, -1 do
		if self.bloodstains[i].timer <= 0 then
			table.remove(self.bloodstains, i)
		else
			self.bloodstains[i]:update(dt)
		end
	end
end

function Field:nextWave()
	if self.currentWave == self.finalWave then
		gStateMachine:change("win")
	else
		self.currentWave = self.currentWave + 1
		self.spawnIndex = 1
		self.waveTimer = 1
		self.totalEnemiesThisWave = #WAVES[self.currentWave]
		self.waveAllSpawned = false
	end
end