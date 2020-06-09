local ExampleController = {}
local Engine = {}

function ExampleController:init(eng)
    Engine = eng
    local newObject = Engine:Get("UI").new("TestObject")
    newObject:Animate("tweenCenter")
end


return ExampleController