local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedEvents = ReplicatedStorage:WaitForChild("Events")
local Events = {}
local ReplicatedModules = {}
local Objects = {}

shared.Modules = {}

for index, obj in pairs(ReplicatedStorage:WaitForChild("Objects"):GetDescendants()) do
	if obj:IsA("Model") then
		Objects[obj.Name] = obj
	end
end

for index, obj in  pairs(ReplicatedEvents:GetDescendants()) do
	if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
		Events[obj.Name] = obj
	end
end

for index, obj in pairs(ReplicatedStorage:WaitForChild("Modules"):GetDescendants()) do
	if obj:IsA("ModuleScript") then
		local requiredModule = require(obj)
		ReplicatedModules[obj.Name] = requiredModule
	end
end

for index, module in pairs(script:GetChildren()) do
	if module:IsA("ModuleScript") then
		local requiredModule = require(module)
		shared.Modules[module.Name] = requiredModule
	end
end

local server_info = {
	Events = Events,
	Modules = shared.Modules,
	ReplicatedModules = ReplicatedModules,
	Objects = Objects,
}

for _, module in pairs(shared.Modules) do
	if module.Start then
		module:Start(server_info)
	end
end
