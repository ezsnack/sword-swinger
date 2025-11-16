Class = require "src/class"

require "src/Vector"
require "src/StateMachine"
require "src/Entity"
require "src/Hitbox"
require "src/Animation"
require "src/Bloodstain"

require "src/world/Field"
require "src/world/waves"
require "src/states/BaseState"
require "src/states/game/StartState"
require "src/states/game/PlayState"
require "src/states/game/GameOverState"
require "src/states/game/GameWinState"

require "src/entities/Player"
	require "src/states/entity/player/NormalState"
	require "src/states/entity/player/SpinAttackState"
	require "src/states/entity/player/PushedBackState"
require "src/entities/Enemy"
require "src/entities/enemies/Goblin"
require "src/entities/enemies/Roach"
require "src/entities/enemies/Charger"
	require "src/states/entity/enemies/charger/ChargerNormalState"
	require "src/states/entity/enemies/charger/ChargerChargingState"
	require "src/states/entity/enemies/charger/ChargerChargeState"
	require "src/states/entity/enemies/charger/ChargerRecoverState"
require "src/entities/enemies/Giant"
	require "src/states/entity/enemies/giant/GiantNormalState"
	require "src/states/entity/enemies/giant/GiantWindupState"
	require "src/states/entity/enemies/giant/GiantSwingState"

require "src/defAnimations"

function makeQuads(source, tilewidth, tileheight)
	local width = source:getWidth() / tilewidth --how many sprites per line
	local height = source:getHeight() / tileheight --how many sprites per column

	local sprites = {}
	local counter = 1
	
	for y = 0, height - 1 do
		for x = 0, width - 1 do
			sprites[counter] = love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth, tileheight, source:getWidth(), source:getHeight())
			counter = counter + 1
		end
	end
	return sprites
end

gTextures = {
	--entities
	["player"] = love.graphics.newImage("sprites/player/player-spritesheet.png"),
	["sword"] = love.graphics.newImage("sprites/player/sword-spritesheet.png"),
	["spin"] = love.graphics.newImage("sprites/player/player-spin-spritesheet.png"),
	["goblin"] = love.graphics.newImage("sprites/enemies/goblin/goblin-spritesheet.png"),
	["roach"] = love.graphics.newImage("sprites/enemies/roach/roach-spritesheet.png"),
	["charger"] = love.graphics.newImage("sprites/enemies/charger/charger-spritesheet.png"),
	["charger-recover"] = love.graphics.newImage("sprites/enemies/charger/charger-recover-spritesheet.png"),
	["giant"] = love.graphics.newImage("sprites/enemies/giant/giant-spritesheet.png"),
	["giant-spin"] = love.graphics.newImage("sprites/enemies/giant/giant-spin-spritesheet.png"),
	--blood
	["bloodstain-s"] = love.graphics.newImage("sprites/blood/bloodstain-s.png"),
	["bloodstain-m"] = love.graphics.newImage("sprites/blood/bloodstain-m.png"),
	["bloodstain-l"] = love.graphics.newImage("sprites/blood/bloodstain-l.png")
}

gFrames = {
	["player"] = makeQuads(gTextures["player"], 25, 25),
	["sword"] = makeQuads(gTextures["sword"], 25, 25),
	["spin"] = makeQuads(gTextures["spin"], 75, 75),
	["goblin"] = makeQuads(gTextures["goblin"], 25, 25),
	["roach"] = makeQuads(gTextures["roach"], 15, 15),
	["charger"] = makeQuads(gTextures["charger"], 40, 40),
	["charger-recover"] = makeQuads(gTextures["charger-recover"], 40, 40),
	["giant"] = makeQuads(gTextures["giant"], 250, 250),
	["giant-spin"] = makeQuads(gTextures["giant-spin"], 250, 250)
}
gSounds = {
	["player-hurt"] = love.audio.newSource("sounds/player/player-hurt.wav", "static"),
	["player-sword-swing"] = love.audio.newSource("sounds/player/player-sword-swing.wav", "static"),
	["player-sword-hit"] = love.audio.newSource("sounds/player/player-sword-hit.wav", "static"),
	["player-spin"] = love.audio.newSource("sounds/player/player-spin.wav", "static"),--looping
	--["player-spin-warcry"] = love.audio.newSource("sounds/player/player-spin-warcry.wav", "static"),--looping
	["player-death"] = love.audio.newSource("sounds/player/player-death.wav", "static"),
	["roach-death"] = love.audio.newSource("sounds/enemies/roach-death.wav", "static"),
	["goblin-hit"] = love.audio.newSource("sounds/enemies/goblin-hit.wav", "static"),--a ripping sound
	["goblin-death"] = love.audio.newSource("sounds/enemies/goblin-death.wav", "static"),
	["charger-windup-nyeee"] = love.audio.newSource("sounds/enemies/charger-windup-nyeee.wav", "static"),
	["charger-rush"] = love.audio.newSource("sounds/enemies/charger-rush.wav", "static"), --looping
	["charger-rush-hit"] = love.audio.newSource("sounds/enemies/charger-rush-hit.wav", "static"),--when hitting player while rushing
	["charger-death"] = love.audio.newSource("sounds/enemies/charger-death.wav", "static"),
	--["giant-drag-sword"] = love.audio.newSource("sounds/enemies/giant-drag-sword.wav", "static"),--looping
	["giant-pickup-grunt"] = love.audio.newSource("sounds/enemies/giant-pickup-grunt.wav", "static"),
	["giant-swing"] = love.audio.newSource("sounds/enemies/giant-swing.wav", "static"),
	["giant-swing-hit"] = love.audio.newSource("sounds/enemies/giant-swing-hit.wav", "static"),
	--["giant-swing-warcry"] = love.audio.newSource("sounds/enemies/giant-swing-warcry.wav", "static"),
	["giant-death"] = love.audio.newSource("sounds/enemies/giant-death.wav", "static"),
	["placeholder-silence"] = love.audio.newSource("sounds/placeholder-silence.wav", "static")
}
gSounds["player-spin"]:setLooping(true)
gSounds["charger-rush"]:setLooping(true)
--gSounds["giant-drag-sword"]:setLooping(true)
--gSounds["player-spin-warcry"]:setLooping(true)
--gSounds["giant-swing-warcry"]:setLooping(true)
--gFonts = {}