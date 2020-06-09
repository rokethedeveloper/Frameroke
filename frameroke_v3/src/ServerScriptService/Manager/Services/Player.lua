local Player = {}
Player.__index = Player
local Engine

function Player:init(eng)
    Engine = eng
    local function playerAdded(player)
        local playerClass = setmetatable({
            Player = player,
            Banana = 3
        }, Player)

        Engine.Events.Update:FireClient(player, playerClass)
        print("fired")
        return playerClass
    end

    Engine:Get("Players").PlayerAdded:Connect(playerAdded)
end

return Player