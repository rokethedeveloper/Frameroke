local Players = game:GetService("Players")
local Client = Players.LocalPlayer
local PlayerGui = Client:WaitForChild("PlayerGui")
local Interface = PlayerGui:WaitForChild("Interface")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local ReplicatedEvents = ReplicatedStorage:WaitForChild("Events")
local Objects = ReplicatedStorage:WaitForChild("Objects")
local StarterGui = game:GetService("StarterGui")
local Events = {}
local ClientModules = {}
local ReplicatedModules = {}

local initializedModules = false


for _, module in pairs(Modules:GetChildren()) do
	if module:IsA("ModuleScript") then
		local requiredModule = require(module)
		ReplicatedModules[module.Name] = requiredModule
	end
end

for index, obj in pairs(ReplicatedEvents:GetChildren()) do
	if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
		Events[obj.Name] = obj
	end
end

for index, module in pairs(script:GetChildren()) do
	if module:IsA("ModuleScript") then
		local requiredModule = require(module)
		ClientModules[module.Name] = requiredModule
	end
end

local client_information = {
	Interface = Interface,
	Events = Events,
	Client = Client,
	Character = Client.Character or Client.CharacterAdded:Wait(),
	ReplicatedModules = ReplicatedModules,
	Modules = ClientModules,
}

Events.UpdatePlayer.OnClientEvent:Connect(function(data)
    if not initializedModules then
        for index, module in pairs(ClientModules) do
            if module.BeforeStart then
                module.BeforeStart(data)
            end

            if module.Start then
                module:ConnectDataUpdate(script.Parent.DistributeData)
                module:Start(client_information)
            end
        end
        initializedModules = true
    else
        script.Parent.DistributeData:Fire(data)
    end
end)
