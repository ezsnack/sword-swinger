StateMachine = Class{}

function StateMachine:init(states)
	--initialize first with empty states
	self.empty = {
		enter = function() end,
		exit = function() end,
		update = function() end,
		render = function() end
	}
	self.states = states or {}
	self.current = self.empty
end

function StateMachine:change(state, ...)
	assert(self.states[state], "invalid state passed to StateMachine:change") --assert checks if first statement is not false/nil, if it is, shows error message from second statement
	self.current:exit() --call a function that should be triggered every time a certain state is exited
	self.current = self.states[state]()
	self.current:enter(...) --call a function that should be triggered every time this state is entered, can take parameters. ... are the parameters
end

function StateMachine:update(dt)
	self.current:update(dt)
end

function StateMachine:render()
	self.current:render()
end