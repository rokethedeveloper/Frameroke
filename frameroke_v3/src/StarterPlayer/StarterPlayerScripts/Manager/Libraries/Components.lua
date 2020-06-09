local Engine
local Components = {
    ["TestObject"] = {
        onLoad = function(self)
            
            self.Dragged = Engine:Get("MouseBehavior").new(self.Element, "Drag")
            self.Dragged:Connect(function(originalPos)
                self.Element.Position = originalPos
            end)
        end,

        Scope = "General"
    }
}

function Components:init(eng)
    Engine = eng
end


function Components.cloneComponent(table)
    local function search(tbl)
        local assign = {}
        for i,v in pairs(tbl) do
            if type(v) == "table" then
                assign[i] = {}
                search(v, assign[i])
            else
                assign[i] = v
            end
        end

        return assign
    end

    return search(table)
end

function Components:GetComponent(component)
    if Components[component] then
        local component = Components.cloneComponent(Components[component])
        return component
    end
end


return Components