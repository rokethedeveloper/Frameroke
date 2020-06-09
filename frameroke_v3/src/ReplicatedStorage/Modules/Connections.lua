local Connections = {}
Connections.__index = Connections

function Connections.new()
	return setmetatable({
		Func = {}
	}, Connections)
end

function Connections:Connect(func)
	table.insert(self.Func, func)
	local index = #self.Func
	return {
		Disconnect = function()
			table.remove(self.Func, index)
		end
	}
end

function Connections:Fire(...)
	for i = 1, #self.Func do
		self.Func[i](...)
	end
end

function Connections:Disconnect()
	self = nil
end

return Connections