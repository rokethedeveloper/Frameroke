local Engine = {}

function Engine:ProtectedModuleStart(module, scope)
    local thread = coroutine.create(function()
        local success, result = pcall(function()
            local required = require(module)
            if required.init then
                required:init(Engine)
            end
            return required
        end)
        if not success then
            table.insert(Engine._failures, "Client | ".. module.Name.. " | ".. result)
        else
            if scope then
                Engine[scope][module.Name] = result
            end
        end
        coroutine.yield()
    end)
    coroutine.resume(thread)
end

function Engine:Get(service)
    if Engine._FRServices[service] then
        return Engine._FRServices[service]
    elseif Engine._shared[service] then
        return Engine._shared[service]
    elseif Engine._libs[service] then
        return Engine._libs[service]
    elseif Engine._services[service] then
        return Engine._services[service]
    end
end

function Engine:init()
    Engine._shared = {}
    Engine._libs = {}
    Engine._FRServices = {}
    Engine._data = {}

    Engine.package = {}
    Engine.Events = {}

    Engine._failures = {}
    -- // ROBLOX Services
    Engine._services = setmetatable({}, {__index = function(self, serviceName)
        local service = game:GetService(serviceName)
        self[serviceName] = service
        return self[serviceName]
    end})

    -- // Shared Modules
    local Modules = Engine._services.ReplicatedStorage.Modules:GetChildren()
    for i = 1, #Modules do 
        local module = Modules[i]
        Engine:ProtectedModuleStart(module, "_shared")
    end

    Engine.LoadState = Engine._shared.Connections.new()
    Engine.DataUpdate = Engine._shared.Connections.new()
    Engine.LoadState:Connect(function(state)
        print(state)
    end)
    Engine.LoadState:Fire("Loaded shared modules.")

     -- // Events
     local Events = Engine._services.ReplicatedStorage.Events:GetDescendants()
     for i = 1, #Events do
         local event = Events[i]
         if event:IsA("RemoteEvent") or event:IsA("RemoteFunction") then
             Engine.Events[event.Name] = event
         end
     end

    Engine.LoadState:Fire("Loaded events.")

    -- // Setup Package

    Engine.package.Client = Engine._services.Players.LocalPlayer
    local PlayerGui = Engine.package.Client:WaitForChild("PlayerGui")
    Engine.package.Interface = PlayerGui:WaitForChild("Interface")

    Engine.LoadState:Fire("Loaded client package.")

    -- // FR Libraries
    local Libraries = script.Parent.Libraries:GetChildren()
    for i = 1, #Libraries do
        local library = Libraries[i]
        Engine:ProtectedModuleStart(library, "_libs")
    end

    Engine.LoadState:Fire("Loaded frameroke libraries.")

    -- // FR Services
    local Services = script.Parent.Services:GetChildren()
    for i = 1, #Services do
        local service = Services[i]
        Engine:ProtectedModuleStart(service, "_FRServices")
    end

    Engine.LoadState:Fire("Loaded frameroke services.")

    local Main = script.Parent.Main:GetChildren()
    for i = 1, #Main do
        local main = Main[i]
        Engine:ProtectedModuleStart(main)
    end


    if #Engine._failures > 0 then
        warn("Module failures detected.")
        for i = 1, #Engine._failures do
            local failure = Engine._failures[i]
            warn(failure)
        end
    end

    Engine.LoadState:Fire("Waiting for server response...")
    local playerData = Engine.Events.Update.OnClientEvent:Wait()
    Engine.LoadState:Fire("Got server response!")
    -- // Setup Data Distribution
    Engine.DataUpdate:Fire("PlayerData", playerData)

    Engine.Events.Update.OnClientEvent:Connect(function()
        Engine.DataUpdate:Fire("PlayerData", playerData)
    end)

    Engine.LoadState:Fire("frameroke™ Engine Version 3.0 initialization completed.")
end


return Engine