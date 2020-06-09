local Engine
local Animations = {
    ["General"] = {
        ["tweenCenter"] = function(self)
            self:Animate("tween")
        end,
        ["tween"] = function(self)
            Engine:Get("TweenService"):Create(self.Element, TweenInfo.new(0.5), {Position = UDim2.fromScale(0.5, 0.5)}):Play()
        end
    }
}

function Animations:init(eng)
    Engine = eng
end

function Animations:GetAnimation(scope, animation, ...)
    if Animations[scope] then
        return Animations[scope][animation]
    elseif Animations["General"][animation] then
        return Animations["General"][animation]
    end
end

return Animations