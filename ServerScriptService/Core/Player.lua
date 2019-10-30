local Player = {}
Player.__index = Player
local Events
local Players = game:GetService("Players")

local savedPlayers = {}

function Player:Get(player)
    if savedPlayers[player] then
        return savedPlayers[player]
    end
end

function Player:Update()
    Events.UpdatePlayer:FireClient(self.Player, self)
end

function Player:Start(self)
    Events = self.Events

    local function playerAdded(player)

        local playerData = {
            Player = player,
        }
        local playerMeta = setmetatable(playerData, Player)

        savedPlayers[player] = playerMeta
        Events.UpdatePlayer:FireClient(player, playerMeta)
    end

    Players.PlayerAdded:Connect(playerAdded)

    for _, player in pairs(Players:GetPlayers()) do
        if not savedPlayers[player] then
            playerAdded(player)
        end
    end
end

return Player
