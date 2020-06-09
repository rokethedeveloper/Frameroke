local MouseBehavior = {
    MovementListeners = {},
    DragListeners = {},
    ExistingConnections = {}
}
local Engine

function MouseBehavior:init(eng)
    Engine = eng
    local mouse = Engine.package.Client:GetMouse()
    Engine:Get("RunService").Heartbeat:Connect(function()
        for i = 1, #MouseBehavior.MovementListeners do
            local packet = MouseBehavior.MovementListeners[i]
            local object = packet.Object
            if not packet.Inside then
                if (mouse.X >= object.AbsolutePosition.X) and (mouse.X <= object.AbsolutePosition.X + object.AbsoluteSize.X) then
                    if (mouse.Y >= object.AbsolutePosition.Y) and (mouse.Y <= object.AbsolutePosition.Y + object.AbsoluteSize.Y) then
                        packet.Inside = true
                        packet.Events.MouseEnter:Fire()
                        MouseBehavior.HoveringFrame = object
                    end
                end
            else
                if (mouse.X < object.AbsolutePosition.X) or (mouse.X > object.AbsolutePosition.X + object.AbsoluteSize.X) then
                    packet.Inside = false
                    packet.Events.MouseLeave:Fire()

                    if MouseBehavior.HoveringFrame == object then
                        MouseBehavior.HoveringFrame = nil
                    end
                elseif (mouse.Y < object.AbsolutePosition.Y) or (mouse.Y > object.AbsolutePosition.Y + object.AbsoluteSize.Y) then
                    packet.Inside = false
                    packet.Events.MouseLeave:Fire()

                    if MouseBehavior.HoveringFrame == object then
                        MouseBehavior.HoveringFrame = nil
                    end
                end
            end
        end

        if MouseBehavior.DragFrame then
            MouseBehavior.DragFrame.Position = UDim2.fromOffset(mouse.X, mouse.Y)
        end
    end)

    Engine:Get("UserInputService").InputBegan:Connect(function(input, gp)
        if gp then return end

        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            for i = 1, #MouseBehavior.DragListeners do
                local packet = MouseBehavior.DragListeners[i]
                if not MouseBehavior.DragFrame then
                    if MouseBehavior.HoveringFrame == packet.Object then 
                        packet.OriginalPosition = packet.Object.Position
                        MouseBehavior.DragFrame = packet.Object

                        break
                    end
                end
            end
        end
    end)

    Engine:Get("UserInputService").InputEnded:Connect(function(input, gp)
        if gp then return end

        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if MouseBehavior.DragFrame then

                for i = 1, #MouseBehavior.DragListeners do
                    local drag = MouseBehavior.DragListeners[i]
                    if drag.Object == MouseBehavior.DragFrame then
                        print(drag.OriginalPosition)
                        drag.Events.Dragged:Fire(drag.OriginalPosition)
                        MouseBehavior.DragFrame = nil
                        break
                    end
                end
            end
        end
    end)
end

function MouseBehavior:GetHoveringFrame()
    return MouseBehavior.HoveringFrame
end

function MouseBehavior.new(object, type, ...)
    if MouseBehavior.ExistingConnections[object] then
        if MouseBehavior.ExistingConnections[object][type] then
            if type == "Movement" then
                return MouseBehavior.ExistingConnections[object][type][1], MouseBehavior.ExistingConnections[object][type][2]
            else
                return  MouseBehavior.ExistingConnections[object][type]
            end
        end
    else
        MouseBehavior.ExistingConnections[object] = {}
    end

    if type == "Movement" then
        local MouseEnter = Engine:Get("Connections").new()
        local MouseLeave = Engine:Get("Connections").new()
        local packet = {
            Events = {
                MouseEnter = MouseEnter,
                MouseLeave = MouseLeave,
            },
            Object = object,
            Inside = false
        }
        table.insert(MouseBehavior.MovementListeners, packet)
        MouseBehavior.ExistingConnections[object][type] = {mouseEnter, mouseLeave}
        return mouseEnter, mouseLeave
    elseif type == "Drag" then
        local Dragged = Engine:Get("Connections").new()
        local packet = {
            Events = {
                Dragged = Dragged
            },
            Object = object,
            OriginalPosition = object.Position,
            Dragging = false
        }
        table.insert(MouseBehavior.DragListeners, packet)

        MouseBehavior.new(object, "Movement")
        MouseBehavior.ExistingConnections[object][type] = Dragged
        return Dragged
    end
end

return MouseBehavior