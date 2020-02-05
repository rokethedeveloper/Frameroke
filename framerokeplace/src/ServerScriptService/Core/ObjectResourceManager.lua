local ObjectResourceManager = {}
local Events

local ServerStorage = game:GetService("ServerStorage")
local Objects = ServerStorage:WaitForChild("Objects")
local ObjectTable = {}

function ObjectResourceManager:Start(self)

    -- // load all of the objects for quicker access

    local objs = Objects:GetDescendants()
    for i = 1, #objs do
        local selectedObj = objs[i]
        if selectedObj:IsA("Model") or selectedObj:IsA("Tool") then
            ObjectTable[selectedObj.Name] = selectedObj
        end
    end

    local function returnObject(player, objectName)
        if ObjectTable[objectName] then
            return ObjectTable[objectName]
        else
            return nil
        end
    end
end


return ObjectResourceManager