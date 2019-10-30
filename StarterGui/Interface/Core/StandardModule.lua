local Module = {}
local Events, Interface, Client
local playerData

function Module.UpdateData(data)
    playerData = data
    print("got data")
end

function Module.BeforeStart(player_data)
    Module.UpdateData(player_data)
end

function Module:ConnectDataUpdate(event)
    event.Event:Connect(function(data)
        Module.UpdateData(data)
    end)
end

function Module:Start(self)
    Events = self.Events
    Interface = self.Interface
    Client = self.Client
end

return Module
