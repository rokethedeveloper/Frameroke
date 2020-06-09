local UI = {}
UI.__index = UI
local Engine

function UI:init(eng)
    Engine = eng
end

function UI.getObject(name)
    local object = Engine:Get("ReplicatedStorage"):FindFirstChild("GUIs"):FindFirstChild(name)
    if object then
        return object:Clone()
    else
        return nil
    end
end

function UI.new(componentName, parent, existingObject)
    if not existingObject then
        existingObject = UI.getObject(componentName)
    end

    if not parent then
        parent = Engine.package.Interface
    end

    local component = Engine:Get("Components"):GetComponent("TestObject")

    local object = setmetatable({
        Element = existingObject,
        Scope = component.Scope
    }, UI)

    component.onLoad(object)
    object.Element.Parent = parent
    return object
end

function UI:Animate(animation, ...)
    local animation = Engine:Get("Animations"):GetAnimation(self.Scope, animation)
    animation(self, ...)
end

return UI