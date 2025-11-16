require "src/dependencies"


WINDOW_WIDTH = 700
WINDOW_HEIGHT = 700
FONTSIZE = 12
MOVEMENT_KEYS = {"w", "a", "s", "d"}
ATTACK_KEYS = {"up", "down", "right", "left"}
PLAYER_POSITION = Vector(0,0)--to make player position available to enemies

function love.load()
	love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {fullscreen=false, resizable=false, vsync=0})
	love.window.setTitle("sword swinger")
	love.graphics.setDefaultFilter("nearest", "nearest", 0)
	
	math.randomseed(os.time())
	
	gStateMachine = StateMachine( --the g stands for global
		{
			["start"] = function() return StartState() end,
			["play"] = function() return PlayState() end,
			["gameover"] = function() return GameOverState() end,
			["win"] = function() return GameWinState() end
		}
	)
	gStateMachine:change("start")
end

function love.update(dt)
	gStateMachine:update(dt)
end

function love.draw()
	gStateMachine:render()
	--love.graphics.print(tostring(love.timer.getFPS(),WINDOW_WIDTH - 20,WINDOW_HEIGHT - 20))--fps counter for testing
end