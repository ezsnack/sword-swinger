BaseState = Class{}

--used to avoid defining empty methods in every state

function BaseState:init() end
function BaseState:enter() end
function BaseState:exit() end
function BaseState:update(dt) end
function BaseState:render() end