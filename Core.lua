-- Core.lua
local Renderer = loadstring(game:HttpGet("https://raw.githubusercontent.com/HURACLUB/MM2/main/Renderer.lua"))()
local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/HURACLUB/MM2/main/Config.lua"))()
local Modules = {
    Combat = loadstring(game:HttpGet("https://raw.githubusercontent.com/HURACLUB/MM2/main/Modules/Combat.lua"))(),
    Visual = loadstring(game:HttpGet("https://raw.githubusercontent.com/HURACLUB/MM2/main/Modules/Visual.lua"))()
}

local HuracubGUI = {}
HuracubGUI.__index = HuracubGUI

function HuracubGUI.new()
    local self = setmetatable({}, HuracubGUI)
    self.renderer = Renderer.new(Config)
    self.modules = Modules
    self.isOpen = false
    self.notifications = {}
    return self
end

function HuracubGUI:Toggle()
    self.isOpen = not self.isOpen
    self.renderer:ToggleUI(self.isOpen)
    if self.isOpen then
        self:AddNotification("GUI Activated", Color3.fromRGB(0, 255, 0))
    end
end

function HuracubGUI:AddNotification(text, color)
    table.insert(self.notifications, {
        text = text,
        color = color,
        time = tick()
    })
end

function HuracubGUI:Update()
    self.renderer:Update({
        fps = math.floor(1/workspace:GetRealPhysicsFPS()),
        ping = math.random(20, 50), 
        time = os.date("%H:%M:%S")
    })
    
    for _, module in pairs(self.modules) do
        module:Update()
    end
    
    self:DrawNotifications()
end

function HuracubGUI:DrawNotifications()
    local currentTime = tick()
    for i = #self.notifications, 1, -1 do
        local notif = self.notifications[i]
        if currentTime - notif.time > 5 then
            table.remove(self.notifications, i)
        else
            self.renderer:DrawNotification(i, notif)
        end
    end
end

-- Инициализация
local GUI = HuracubGUI.new()
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if input.KeyCode == Enum.KeyCode.LeftControl and not processed then
        GUI:Toggle()
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if GUI.isOpen then
        GUI:Update()
    end
end)

return GUI
