--[[
    🔥 ZONE XD - TSUNAMI BRAINROT HUB (BAGIAN 1) 🔥
    COPYRIGHT: APIS 2026
]]

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

-- SETTINGS
local settings = {
    autoFarm = { enabled = false, secret = true, celestial = true, divine = true, infinity = true },
    tsunami = { enabled = false, autoHide = true, detected = false },
    teleport = { enabled = false, zone = "AUTO" },
    fly = { enabled = false, speed = 50, y = -50 },
    gui = { minimized = false, full = UDim2.new(0, 400, 0, 300), mini = UDim2.new(0, 400, 0, 40) }
}

-- CREATE GUI
local gui = Instance.new("ScreenGui")
gui.Name = "TsunamiHub"
gui.Parent = playerGui
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

local frame = Instance.new("Frame")
frame.Size = settings.gui.full
frame.Position = UDim2.new(0.5, -200, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
frame.BackgroundTransparency = 0.1
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = frame

-- TITLE BAR
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
titleBar.BackgroundTransparency = 0.3
titleBar.Parent = frame

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0, 15)
barCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.6, 0, 1, 0)
title.Position = UDim2.new(0.05, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🌊 TSUNAMI HUB"
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBlack
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 25, 0, 25)
minBtn.Position = UDim2.new(1, -55, 0, 5)
minBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
minBtn.Text = "🗕"
minBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
minBtn.TextScaled = true
minBtn.Font = Enum.Font.GothamBlack
minBtn.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -27, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBlack
closeBtn.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = minBtn

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
end)

-- CONTENT FRAME
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -20, 1, -45)
content.Position = UDim2.new(0, 10, 0, 40)
content.BackgroundTransparency = 1
content.Parent = frame
--[[
    🔥 ZONE XD - TSUNAMI BRAINROT HUB (BAGIAN 2) 🔥
    COPYRIGHT: APIS 2026
]]

-- AUTO FARM SECTION
local farmLabel = Instance.new("TextLabel")
farmLabel.Size = UDim2.new(1, 0, 0, 25)
farmLabel.Position = UDim2.new(0, 0, 0, 0)
farmLabel.BackgroundTransparency = 1
farmLabel.Text = "⚡ AUTO FARM"
farmLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
farmLabel.TextXAlignment = Enum.TextXAlignment.Left
farmLabel.TextScaled = true
farmLabel.Font = Enum.Font.GothamBlack
farmLabel.Parent = content

local farmBtn = Instance.new("TextButton")
farmBtn.Size = UDim2.new(0.25, 0, 0, 22)
farmBtn.Position = UDim2.new(0.75, 0, 0, 0)
farmBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
farmBtn.Text = "OFF"
farmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
farmBtn.TextScaled = true
farmBtn.Font = Enum.Font.GothamBlack
farmBtn.Parent = content

local farmCorner = Instance.new("UICorner")
farmCorner.CornerRadius = UDim.new(0, 8)
farmCorner.Parent = farmBtn

-- Secret Toggle
local secretLabel = Instance.new("TextLabel")
secretLabel.Size = UDim2.new(0.8, 0, 0, 20)
secretLabel.Position = UDim2.new(0.1, 0, 0, 30)
secretLabel.BackgroundTransparency = 1
secretLabel.Text = "  ├─ Secret"
secretLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
secretLabel.TextXAlignment = Enum.TextXAlignment.Left
secretLabel.TextScaled = true
secretLabel.Font = Enum.Font.Gotham
secretLabel.Parent = content

local secretBtn = Instance.new("TextButton")
secretBtn.Size = UDim2.new(0.2, 0, 0, 18)
secretBtn.Position = UDim2.new(0.8, 0, 0, 31)
secretBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
secretBtn.Text = "ON"
secretBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
secretBtn.TextScaled = true
secretBtn.Font = Enum.Font.GothamBlack
secretBtn.Parent = content

local secretCorner = Instance.new("UICorner")
secretCorner.CornerRadius = UDim.new(0, 6)
secretCorner.Parent = secretBtn

-- Celestial Toggle
local celestialLabel = Instance.new("TextLabel")
celestialLabel.Size = UDim2.new(0.8, 0, 0, 20)
celestialLabel.Position = UDim2.new(0.1, 0, 0, 55)
celestialLabel.BackgroundTransparency = 1
celestialLabel.Text = "  ├─ Celestial"
celestialLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
celestialLabel.TextXAlignment = Enum.TextXAlignment.Left
celestialLabel.TextScaled = true
celestialLabel.Font = Enum.Font.Gotham
celestialLabel.Parent = content

local celestialBtn = Instance.new("TextButton")
celestialBtn.Size = UDim2.new(0.2, 0, 0, 18)
celestialBtn.Position = UDim2.new(0.8, 0, 0, 56)
celestialBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
celestialBtn.Text = "ON"
celestialBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
celestialBtn.TextScaled = true
celestialBtn.Font = Enum.Font.GothamBlack
celestialBtn.Parent = content

local celestialCorner = Instance.new("UICorner")
celestialCorner.CornerRadius = UDim.new(0, 6)
celestialCorner.Parent = celestialBtn

-- Divine Toggle
local divineLabel = Instance.new("TextLabel")
divineLabel.Size = UDim2.new(0.8, 0, 0, 20)
divineLabel.Position = UDim2.new(0.1, 0, 0, 80)
divineLabel.BackgroundTransparency = 1
divineLabel.Text = "  ├─ Divine"
divineLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
divineLabel.TextXAlignment = Enum.TextXAlignment.Left
divineLabel.TextScaled = true
divineLabel.Font = Enum.Font.Gotham
divineLabel.Parent = content

local divineBtn = Instance.new("TextButton")
divineBtn.Size = UDim2.new(0.2, 0, 0, 18)
divineBtn.Position = UDim2.new(0.8, 0, 0, 81)
divineBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
divineBtn.Text = "ON"
divineBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
divineBtn.TextScaled = true
divineBtn.Font = Enum.Font.GothamBlack
divineBtn.Parent = content

local divineCorner = Instance.new("UICorner")
divineCorner.CornerRadius = UDim.new(0, 6)
divineCorner.Parent = divineBtn

-- Infinity Toggle
local infinityLabel = Instance.new("TextLabel")
infinityLabel.Size = UDim2.new(0.8, 0, 0, 20)
infinityLabel.Position = UDim2.new(0.1, 0, 0, 105)
infinityLabel.BackgroundTransparency = 1
infinityLabel.Text = "  └─ Infinity"
infinityLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
infinityLabel.TextXAlignment = Enum.TextXAlignment.Left
infinityLabel.TextScaled = true
infinityLabel.Font = Enum.Font.Gotham
infinityLabel.Parent = content

local infinityBtn = Instance.new("TextButton")
infinityBtn.Size = UDim2.new(0.2, 0, 0, 18)
infinityBtn.Position = UDim2.new(0.8, 0, 0, 106)
infinityBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
infinityBtn.Text = "ON"
infinityBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
infinityBtn.TextScaled = true
infinityBtn.Font = Enum.Font.GothamBlack
infinityBtn.Parent = content

local infinityCorner = Instance.new("UICorner")
infinityCorner.CornerRadius = UDim.new(0, 6)
infinityCorner.Parent = infinityBtn

-- TSUNAMI SECTION
local tsunamiLabel = Instance.new("TextLabel")
tsunamiLabel.Size = UDim2.new(1, 0, 0, 25)
tsunamiLabel.Position = UDim2.new(0, 0, 0, 135)
tsunamiLabel.BackgroundTransparency = 1
tsunamiLabel.Text = "🌊 TSUNAMI DETECTOR"
tsunamiLabel.TextColor3 = Color3.fromRGB(255, 100, 0)
tsunamiLabel.TextXAlignment = Enum.TextXAlignment.Left
tsunamiLabel.TextScaled = true
tsunamiLabel.Font = Enum.Font.GothamBlack
tsunamiLabel.Parent = content

local tsunamiBtn = Instance.new("TextButton")
tsunamiBtn.Size = UDim2.new(0.25, 0, 0, 22)
tsunamiBtn.Position = UDim2.new(0.75, 0, 0, 135)
tsunamiBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
tsunamiBtn.Text = "OFF"
tsunamiBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tsunamiBtn.TextScaled = true
tsunamiBtn.Font = Enum.Font.GothamBlack
tsunamiBtn.Parent = content

local tsunamiCorner = Instance.new("UICorner")
tsunamiCorner.CornerRadius = UDim.new(0, 8)
tsunamiCorner.Parent = tsunamiBtn

-- Auto Hide Toggle
local hideLabel = Instance.new("TextLabel")
hideLabel.Size = UDim2.new(0.8, 0, 0, 20)
hideLabel.Position = UDim2.new(0.1, 0, 0, 165)
hideLabel.BackgroundTransparency = 1
hideLabel.Text = "  Auto Hide"
hideLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
hideLabel.TextXAlignment = Enum.TextXAlignment.Left
hideLabel.TextScaled = true
hideLabel.Font = Enum.Font.Gotham
hideLabel.Parent = content

local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(0.2, 0, 0, 18)
hideBtn.Position = UDim2.new(0.8, 0, 0, 166)
hideBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
hideBtn.Text = "ON"
hideBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
hideBtn.TextScaled = true
hideBtn.Font = Enum.Font.GothamBlack
hideBtn.Parent = content

local hideCorner = Instance.new("UICorner")
hideCorner.CornerRadius = UDim.new(0, 6)
hideCorner.Parent = hideBtn

-- TELEPORT SECTION
local teleLabel = Instance.new("TextLabel")
teleLabel.Size = UDim2.new(1, 0, 0, 25)
teleLabel.Position = UDim2.new(0, 0, 0, 195)
teleLabel.BackgroundTransparency = 1
teleLabel.Text = "📍 TELEPORT ZONE"
teleLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
teleLabel.TextXAlignment = Enum.TextXAlignment.Left
teleLabel.TextScaled = true
teleLabel.Font = Enum.Font.GothamBlack
teleLabel.Parent = content

local teleBtn = Instance.new("TextButton")
teleBtn.Size = UDim2.new(0.25, 0, 0, 22)
teleBtn.Position = UDim2.new(0.75, 0, 0, 195)
teleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
teleBtn.Text = "OFF"
teleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
teleBtn.TextScaled = true
teleBtn.Font = Enum.Font.GothamBlack
teleBtn.Parent = content

local teleCorner = Instance.new("UICorner")
teleCorner.CornerRadius = UDim.new(0, 8)
teleCorner.Parent = teleBtn

-- FLY SECTION
local flyLabel = Instance.new("TextLabel")
flyLabel.Size = UDim2.new(1, 0, 0, 25)
flyLabel.Position = UDim2.new(0, 0, 0, 225)
flyLabel.BackgroundTransparency = 1
flyLabel.Text = "🕳️ UNDERGROUND FLY"
flyLabel.TextColor3 = Color3.fromRGB(200, 100, 255)
flyLabel.TextXAlignment = Enum.TextXAlignment.Left
flyLabel.TextScaled = true
flyLabel.Font = Enum.Font.GothamBlack
flyLabel.Parent = content

local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0.25, 0, 0, 22)
flyBtn.Position = UDim2.new(0.75, 0, 0, 225)
flyBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
flyBtn.Text = "OFF"
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.TextScaled = true
flyBtn.Font = Enum.Font.GothamBlack
flyBtn.Parent = content

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 8)
flyCorner.Parent = flyBtn
--[[
    🔥 ZONE XD - TSUNAMI BRAINROT HUB (BAGIAN 3) 🔥
    COPYRIGHT: APIS 2026
]]

-- MINIMIZE FUNCTION
local function toggleMinimize()
    settings.gui.minimized = not settings.gui.minimized
    local target = settings.gui.minimized and settings.gui.mini or settings.gui.full
    local tween = TweenService:Create(frame, TweenInfo.new(0.3), {Size = target})
    tween:Play()
    content.Visible = not settings.gui.minimized
    minBtn.Text = settings.gui.minimized and "🗖" or "🗕"
end
minBtn.MouseButton1Click:Connect(toggleMinimize)

-- TOGGLE HANDLERS
farmBtn.MouseButton1Click:Connect(function()
    settings.autoFarm.enabled = not settings.autoFarm.enabled
    farmBtn.BackgroundColor3 = settings.autoFarm.enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    farmBtn.Text = settings.autoFarm.enabled and "ON" or "OFF"
end)

secretBtn.MouseButton1Click:Connect(function()
    settings.autoFarm.secret = not settings.autoFarm.secret
    secretBtn.BackgroundColor3 = settings.autoFarm.secret and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    secretBtn.Text = settings.autoFarm.secret and "ON" or "OFF"
end)

celestialBtn.MouseButton1Click:Connect(function()
    settings.autoFarm.celestial = not settings.autoFarm.celestial
    celestialBtn.BackgroundColor3 = settings.autoFarm.celestial and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    celestialBtn.Text = settings.autoFarm.celestial and "ON" or "OFF"
end)

divineBtn.MouseButton1Click:Connect(function()
    settings.autoFarm.divine = not settings.autoFarm.divine
    divineBtn.BackgroundColor3 = settings.autoFarm.divine and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    divineBtn.Text = settings.autoFarm.divine and "ON" or "OFF"
end)

infinityBtn.MouseButton1Click:Connect(function()
    settings.autoFarm.infinity = not settings.autoFarm.infinity
    infinityBtn.BackgroundColor3 = settings.autoFarm.infinity and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    infinityBtn.Text = settings.autoFarm.infinity and "ON" or "OFF"
end)

tsunamiBtn.MouseButton1Click:Connect(function()
    settings.tsunami.enabled = not settings.tsunami.enabled
    tsunamiBtn.BackgroundColor3 = settings.tsunami.enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    tsunamiBtn.Text = settings.tsunami.enabled and "ON" or "OFF"
end)

hideBtn.MouseButton1Click:Connect(function()
    settings.tsunami.autoHide = not settings.tsunami.autoHide
    hideBtn.BackgroundColor3 = settings.tsunami.autoHide and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    hideBtn.Text = settings.tsunami.autoHide and "ON" or "OFF"
end)

teleBtn.MouseButton1Click:Connect(function()
    settings.teleport.enabled = not settings.teleport.enabled
    teleBtn.BackgroundColor3 = settings.teleport.enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    teleBtn.Text = settings.teleport.enabled and "ON" or "OFF"
end)

flyBtn.MouseButton1Click:Connect(function()
    settings.fly.enabled = not settings.fly.enabled
    flyBtn.BackgroundColor3 = settings.fly.enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    flyBtn.Text = settings.fly.enabled and "ON" or "OFF"
end)

-- AUTO FARM FUNCTION
local function findBrainrots()
    local targets = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") and v.Name:match("Brainrot") then
            local include = (settings.autoFarm.secret and v.Name:match("Secret")) or
                           (settings.autoFarm.celestial and v.Name:match("Celestial")) or
                           (settings.autoFarm.divine and v.Name:match("Divine")) or
                           (settings.autoFarm.infinity and v.Name:match("Infinity"))
            if include then table.insert(targets, v) end
        end
    end
    return targets
end

-- TSUNAMI DETECT
local function detectTsunami()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") and v.Name:match("Tsunami|Wave") then
            return true
        end
    end
    return false
end

local function findSafeZone()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") and v.Name:match("Safe|Trench|Zone") then
            return v
        end
    end
    return nil
end

-- MAIN LOOP
RunService.Heartbeat:Connect(function()
    if settings.autoFarm.enabled then
        for _, b in pairs(findBrainrots()) do
            if b and b.Position then
                player.Character.HumanoidRootPart.CFrame = CFrame.new(b.Position)
                task.wait(0.1)
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new())
            end
        end
    end
    
    if settings.tsunami.enabled and settings.tsunami.autoHide then
        if detectTsunami() and not settings.tsunami.detected then
            settings.tsunami.detected = true
            local safe = findSafeZone()
            if safe then player.Character.HumanoidRootPart.CFrame = CFrame.new(safe.Position) end
        elseif not detectTsunami() then
            settings.tsunami.detected = false
        end
    end
    
    if settings.fly.enabled and player.Character then
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.Position = Vector3.new(root.Position.X, settings.fly.y, root.Position.Z)
        end
    end
end)

-- ANTI AFK
player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

print("✅ TSUNAMI BRAINROT HUB LOADED!")
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "ZONE XD",
    Text = "Tsunami Brainrot Hub Siap!",
    Duration = 3
})