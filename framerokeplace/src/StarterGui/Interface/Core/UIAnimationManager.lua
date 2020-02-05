local UIAnimationManager = {}

local UIAnimationTags = {
    ["Test"] = function(obj)
        obj.Activated:Connect(function()
            print("works!")
        end)
    end
}

function UIAnimationManager:AppendTag(object, tag)
    if object:IsA("GuiObject") then
        if UIAnimationTags[tag] then
            UIAnimationTags[tag](object)
        else
            warn("No tag found for: ".. tag)
        end
    end
end


return UIAnimationManager