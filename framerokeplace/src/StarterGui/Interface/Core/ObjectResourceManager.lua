-- // The point of this module is to conserve as much loading time as possible by only requesting objects once, and then once they are requested they may be used indefinitely
local ObjectResourceManager = {}
local Events
local cachedObjects = {}

function ObjectResourceManager:Start(self)
    Events = self.Events
end

function ObjectResourceManager:RequestObject(objectName)
    if not cachedObjects[objectName] then
        -- // first time request for this object
        local request = Events.ObjectRequest:InvokeServer(objectName)

        if request then
            cachedObjects[objectName] = request
            return request
        end
    elseif cachedObjects[objectName] then
        return cachedObjects[objectName]
    end
end

return ObjectResourceManager