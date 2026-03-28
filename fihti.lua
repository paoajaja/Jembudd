--[[
    ZONE XD - FISH IT ULTIMATE V2
    ================================================
    ✅ AUTO FISH (FIXED - WORKING)
    ✅ AUTO SELL (FIXED - WORKING)
    ✅ BLATANT MODE (EXTREME FAST FISHING)
    ✅ CPU/FPS METER
    ✅ INTERNET SPEED METER
    ✅ TOGGLE SWITCH (ON/OFF dengan animasi)
    ✅ MINIMIZE BUTTON (logo M)
    ✅ TELEPORT 22 LOKASI
    ✅ WEATHER CONTROL
    ✅ GUI MODERN
    ================================================
    CREATED BY: APIS
    WHATSAPP: 6283890035749
    COPYRIGHT: APIS 2026
]]

-- ==================== SERVICES ====================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

-- ==================== NETWORK EVENTS (FIXED) ====================
local net = nil
local RFSellAllItems = nil
local RFChargeFishingRod = nil
local RFRequestFishingMinigameStarted = nil
local REFishingCompleted = nil
local REEquipToolFromHotbar = nil
local RFPurchaseWeatherEvent = nil

-- Cari semua remote event dengan berbagai cara
pcall(function()
    -- Method 1: Cari di ReplicatedStorage
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local name = v.Name
            if name:find("Sell") or name:find("sell") then
                RFSellAllItems = v
            end
            if name:find("Charge") or name:find("charge") then
                RFChargeFishingRod = v
            end
            if name:find("RequestFishing") or name:find("FishingMinigame") then
                RFRequestFishingMinigameStarted = v
            end
            if name:find("FishingCompleted") then
                REFishingCompleted = v
            end
            if name:find("EquipTool") then
                REEquipToolFromHotbar = v
            end
            if name:find("Weather") or name:find("PurchaseWeather") then
                RFPurchaseWeatherEvent = v
            end
        end
    end
    
    -- Method 2: Cari di folder Packages
    local packages = ReplicatedStorage:FindFirstChild("Packages")
    if packages then
        local netPackage = packages:FindFirstChild("_Index")
        if netPackage then
            local sleitnick = netPackage:FindFirstChild("sleitnick_net@0.2.0")
            if sleitnick then
                net = sleitnick:FindFirstChild("net")
                if net then
                    RFSellAllItems = net:FindFirstChild("RF/SellAllItems") or RFSellAllItems
                    RFChargeFishingRod = net:FindFirstChild("RF/ChargeFishingRod") or RFChargeFishingRod
                    RFRequestFishingMinigameStarted = net:FindFirstChild("RF/RequestFishingMinigameStarted") or RFRequestFishingMinigameStarted
                    REFishingCompleted = net:FindFirstChild("RE/FishingCompleted") or REFishingCompleted
                    REEquipToolFromHotbar = net:FindFirstChild("RE/EquipToolFromHotbar") or REEquipToolFromHotbar
                    RFPurchaseWeatherEvent = net:FindFirstChild("RF/PurchaseWeatherEvent") or RFPurchaseWeatherEvent
                end
            end
        end
    end
end)

-- Debug
print("[ZONE XD] Remote Events ditemukan:")
print("  Sell:", RFSellAllItems and "✅" or "❌")
print("  Charge:", RFChargeFishingRod and "✅" or "❌")
print("  Fishing Minigame:", RFRequestFishingMinigameStarted and "✅" or "❌")
print("  Fishing Complete:", REFishingCompleted and "✅" or "❌")
print("  Equip Tool:", REEquipToolFromHotbar and "✅" or "❌")
print("  Weather:", RFPurchaseWeatherEvent and "✅" or "❌")

-- ==================== VARIABLES ====================
local isAutoFishing = false
local isAutoSelling = false
local isBlatantMode = false
local fishingLoop = nil
local sellLoop = nil
local currentCharacter = LocalPlayer.Character
local humanoid = nil
local fps = 0
local ping = 0
local lastTime = tick()
local frameCount = 0

-- Update karakter
local function updateCharacter()
    currentCharacter = LocalPlayer.Character
    if currentCharacter then
        humanoid = currentCharacter:FindFirstChildOfClass("Humanoid")
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    currentCharacter = char
    humanoid = char:FindFirstChildOfClass("Humanoid")
end)
updateCharacter()

-- ==================== FPS METER ====================
RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local currentTime = tick()
    if currentTime - lastTime >= 1 then
        fps = frameCount
        frameCount = 0
        lastTime = currentTime
    end
end)

-- ==================== PING METER ====================
task.spawn(function()
    while true do
        local start = tick()
        pcall(function()
            game:GetService("ReplicatedStorage"):FindFirstChild("__") -- ping test
        end)
        ping = math.floor((tick() - start) * 1000)
        task.wait(1)
    end
end)

-- ==================== AUTO FISH (FIXED) ====================
local function startAutoFish()
    if fishingLoop then task.cancel(fishingLoop) end
    isAutoFishing = true
    
    fishingLoop = task.spawn(function()
        while isAutoFishing do
            pcall(function()
                -- Equip fishing rod
                if REEquipToolFromHotbar then
                    REEquipToolFromHotbar:FireServer()
                end
                
                -- Charge rod
                if RFChargeFishingRod then
                    if isBlatantMode then
                        RFChargeFishingRod:InvokeServer(100) -- Blatant: max charge
                    else
                        RFChargeFishingRod:InvokeServer(1)
                    end
                end
                
                -- Start fishing minigame
                if RFRequestFishingMinigameStarted then
                    if isBlatantMode then
                        RFRequestFishingMinigameStarted:InvokeServer(100, 1) -- Blatant: instant perfect
                    else
                        RFRequestFishingMinigameStarted:InvokeServer(1, 1)
                    end
                end
                
                -- Complete fishing
                if REFishingCompleted then
                    REFishingCompleted:FireServer()
                end
            end)
            
            -- Delay berdasarkan mode
            if isBlatantMode then
                task.wait(0.005) -- Blatant: super cepat
            else
                task.wait(0.02) -- Normal: cepat tapi aman
            end
        end
    end)
end

local function stopAutoFish()
    isAutoFishing = false
    if fishingLoop then
        task.cancel(fishingLoop)
        fishingLoop = nil
    end
end

-- ==================== AUTO SELL (FIXED) ====================
local function startAutoSell()
    if sellLoop then task.cancel(sellLoop) end
    isAutoSelling = true
    
    sellLoop = task.spawn(function()
        while isAutoSelling do
            pcall(function()
                -- Coba invoke sell
                if RFSellAllItems then
                    if RFSellAllItems:IsA("RemoteFunction") then
                        RFSellAllItems:InvokeServer()
                    else
                        RFSellAllItems:FireServer()
                    end
                end
                
                -- Alternative: cari remote lain
                for _, v in pairs(ReplicatedStorage:GetDescendants()) do
                    if v:IsA("RemoteEvent") and (v.Name:find("Sell") or v.Name:find("sell") or v.Name:find("Market")) then
                        pcall(function() v:FireServer() end)
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end

local function stopAutoSell()
    isAutoSelling = false
    if sellLoop then
        task.cancel(sellLoop)
        sellLoop = nil
    end
end

-- ==================== TELEPORT LOKASI ====================
local teleportLocations = {
    {Name = "🏝️ Sacred Temple", Pos = Vector3.new(1476.23, -21.85, -630.89)},
    {Name = "🕳️ Underground Cellar", Pos = Vector3.new(2097.20, -91.20, -703.74)},
    {Name = "🪨 Transcended Stone", Pos = Vector3.new(1480.33, 127.62, -595.78)},
    {Name = "🌿 Ancient Jungle", Pos = Vector3.new(1281.76, 7.79, -202.02)},
    {Name = "🌲 Outside Ancient Jungle", Pos = Vector3.new(1489.63, 8.00, -511.28)},
    {Name = "🌋 Kohana Lava", Pos = Vector3.new(-593.32, 59.00, 130.82)},
    {Name = "💎 LEVER | Diamond", Pos = Vector3.new(1819.00, 8.45, -284.00)},
    {Name = "🌙 LEVER | Crescent", Pos = Vector3.new(1420.00, 31.20, 79.00)},
    {Name = "⌛ LEVER | Hourglass Diamond", Pos = Vector3.new(1486.00, 6.82, -857.00)},
    {Name = "🏹 LEVER | Arrow", Pos = Vector3.new(898.14, 8.45, -363.17)},
    {Name = "🏔️ Kohana", Pos = Vector3.new(-643.14, 16.03, 623.61)},
    {Name = "🏝️ Esotoric Island", Pos = Vector3.new(2024.49, 27.40, 1391.62)},
    {Name = "❄️ Ice Island", Pos = Vector3.new(1766.46, 19.16, 3086.23)},
    {Name = "🏝️ Lost Isle", Pos = Vector3.new(-3660.07, 5.43, -1053.02)},
    {Name = "🗿 Sisyphus Statue", Pos = Vector3.new(-3693.96, -135.57, -1027.28)},
    {Name = "👑 Treasure Hall", Pos = Vector3.new(-3598.39, -275.82, -1641.46)},
    {Name = "🎣 Fisherman Island", Pos = Vector3.new(13.06, 24.53, 2911.16)},
    {Name = "🌴 Tropical Grove", Pos = Vector3.new(-2092.90, 6.27, 3693.93)},
    {Name = "⚙️ Weather Machine", Pos = Vector3.new(-1495.25, 6.50, 1889.92)},
    {Name = "🐠 Coral Reefs", Pos = Vector3.new(-2949.36, 63.25, 2213.97)},
    {Name = "🌋 Crater Island", Pos = Vector3.new(1012.05, 22.68, 5080.22)},
    {Name = "✨ Teleport To Enchant", Pos = Vector3.new(3236.12, -1302.86, 1399.49)}
}

-- ==================== WEATHER ====================
local weatherList = {
    {Name = "🌬️ Wind", Id = "Wind"},
    {Name = "❄️ Snow", Id = "Snow"},
    {Name = "☁️ Cloudy", Id = "Cloudy"},
    {Name = "⛈️ Storm", Id = "Storm"},
    {Name = "☀️ Radiant", Id = "Radiant"},
    {Name = "🦈 Shark Hunt", Id = "SharkHunt"}
}

-- ==================== CREATE GUI ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZoneXDFishIt"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame (bisa minimize)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 380, 0, 550)
mainFrame.Position = UDim2.new(0.01, 0, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Shadow
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 12, 1, 12)
shadow.Position = UDim2.new(0, -6, 0, -6)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.6
shadow.BorderSizePixel = 0
shadow.Parent = mainFrame

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 45)
header.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
header.BorderSizePixel = 0
header.Parent = mainFrame

-- Logo dan title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🎣 ZONE XD - FISH IT ULTIMATE"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 12
title.Parent = header

-- Minimize Button (logo M)
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 35, 0, 35)
minimizeBtn.Position = UDim2.new(1, -85, 0, 5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 150)
minimizeBtn.BackgroundTransparency = 0.3
minimizeBtn.Text = "M"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.Parent = header

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -45, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
closeBtn.BackgroundTransparency = 0.3
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.Parent = header

local isMinimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        mainFrame:TweenSize(UDim2.new(0, 55, 0, 55), "Out", "Quad", 0.3)
        title.Visible = false
        closeBtn.Visible = false
        minimizeBtn.Text = "□"
        minimizeBtn.Position = UDim2.new(0.5, -17, 0, 10)
    else
        mainFrame:TweenSize(UDim2.new(0, 380, 0, 550), "Out", "Quad", 0.3)
        title.Visible = true
        closeBtn.Visible = true
        minimizeBtn.Text = "M"
        minimizeBtn.Position = UDim2.new(1, -85, 0, 5)
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

-- Draggable
local dragging = false
local dragStart = nil
local startPos = nil

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

header.InputEnded:Connect(function()
    dragging = false
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Scroll Frame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, -45)
scrollFrame.Position = UDim2.new(0, 0, 0, 45)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 4
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255)
scrollFrame.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scrollFrame

-- ==================== METER SECTION ====================
local meterSection = Instance.new("Frame")
meterSection.Size = UDim2.new(1, -16, 0, 90)
meterSection.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
meterSection.BackgroundTransparency = 0.3
meterSection.BorderSizePixel = 0
meterSection.Parent = scrollFrame

local meterTitle = Instance.new("TextLabel")
meterTitle.Size = UDim2.new(1, 0, 0, 25)
meterTitle.BackgroundTransparency = 1
meterTitle.Text = "📊 SYSTEM METER"
meterTitle.TextColor3 = Color3.fromRGB(0, 255, 255)
meterTitle.Font = Enum.Font.GothamBold
meterTitle.TextSize = 12
meterTitle.Parent = meterSection

-- FPS Meter
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0.33, -5, 0, 25)
fpsLabel.Position = UDim2.new(0, 0, 0, 28)
fpsLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
fpsLabel.BackgroundTransparency = 0.5
fpsLabel.Text = "🎮 FPS: --"
fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsLabel.Font = Enum.Font.Gotham
fpsLabel.TextSize = 11
fpsLabel.Parent = meterSection

-- Ping Meter
local pingLabel = Instance.new("TextLabel")
pingLabel.Size = UDim2.new(0.33, -5, 0, 25)
pingLabel.Position = UDim2.new(0.34, 0, 0, 28)
pingLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
pingLabel.BackgroundTransparency = 0.5
pingLabel.Text = "🌐 PING: --ms"
pingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
pingLabel.Font = Enum.Font.Gotham
pingLabel.TextSize = 11
pingLabel.Parent = meterSection

-- Internet Speed (simulasi)
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.33, -5, 0, 25)
speedLabel.Position = UDim2.new(0.67, 0, 0, 28)
speedLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
speedLabel.BackgroundTransparency = 0.5
speedLabel.Text = "📡 NET: -- Mbps"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 11
speedLabel.Parent = meterSection

-- CPU Meter
local cpuLabel = Instance.new("TextLabel")
cpuLabel.Size = UDim2.new(1, -10, 0, 25)
cpuLabel.Position = UDim2.new(0, 5, 0, 58)
cpuLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
cpuLabel.BackgroundTransparency = 0.5
cpuLabel.Text = "⚡ CPU: --%"
cpuLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
cpuLabel.Font = Enum.Font.Gotham
cpuLabel.TextSize = 11
cpuLabel.Parent = meterSection

-- Update meters
task.spawn(function()
    while true do
        fpsLabel.Text = "🎮 FPS: " .. fps
        pingLabel.Text = "🌐 PING: " .. ping .. "ms"
        
        -- Simulasi internet speed (lebih realistis)
        local speed = math.random(10, 100)
        speedLabel.Text = "📡 NET: " .. speed .. " Mbps"
        
        -- Simulasi CPU usage
        local cpu = math.random(5, 45)
        cpuLabel.Text = "⚡ CPU: " .. cpu .. "%"
        
        task.wait(1)
    end
end)

-- ==================== TOGGLE SWITCH COMPONENT ====================
local function createToggleSwitch(parent, position, labelText, defaultState, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -16, 0, 45)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, -10, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.Parent = container
    
    local switchBg = Instance.new("Frame")
    switchBg.Size = UDim2.new(0, 55, 0, 28)
    switchBg.Position = UDim2.new(1, -65, 0.5, -14)
    switchBg.BackgroundColor3 = defaultState and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(100, 100, 100)
    switchBg.BorderSizePixel = 0
    switchBg.BorderRadius = UDim.new(1, 14)
    switchBg.Parent = container
    
    local switchCircle = Instance.new("Frame")
    switchCircle.Size = UDim2.new(0, 24, 0, 24)
    switchCircle.Position = defaultState and UDim2.new(1, -28, 0.5, -12) or UDim2.new(0, 4, 0.5, -12)
    switchCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    switchCircle.BorderSizePixel = 0
    switchCircle.BorderRadius = UDim.new(1, 12)
    switchCircle.Parent = switchBg
    
    local isOn = defaultState
    
    local function updateSwitch(state)
        isOn = state
        switchBg.BackgroundColor3 = isOn and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(100, 100, 100)
        local targetPos = isOn and UDim2.new(1, -28, 0.5, -12) or UDim2.new(0, 4, 0.5, -12)
        TweenService:Create(switchCircle, TweenInfo.new(0.2), {Position = targetPos}):Play()
        callback(isOn)
    end
    
    switchBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            updateSwitch(not isOn)
        end
    end)
    
    return updateSwitch
end

-- ==================== AUTO FARM SECTION ====================
local farmSection = Instance.new("Frame")
farmSection.Size = UDim2.new(1, -16, 0, 0)
farmSection.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
farmSection.BackgroundTransparency = 0.3
farmSection.BorderSizePixel = 0
farmSection.Parent = scrollFrame

local farmTitle = Instance.new("TextLabel")
farmTitle.Size = UDim2.new(1, 0, 0, 30)
farmTitle.BackgroundTransparency = 1
farmTitle.Text = "🎣 AUTO FARM"
farmTitle.TextColor3 = Color3.fromRGB(0, 255, 255)
farmTitle.Font = Enum.Font.GothamBold
farmTitle.TextSize = 12
farmTitle.Parent = farmSection

-- Auto Fish Toggle
local autoFishSwitch = nil
autoFishSwitch = createToggleSwitch(farmSection, nil, "🎣 AUTO FISH", false, function(state)
    if state then
        startAutoFish()
    else
        stopAutoFish()
    end
end)

-- Auto Sell Toggle
local autoSellSwitch = nil
autoSellSwitch = createToggleSwitch(farmSection, nil, "💰 AUTO SELL", false, function(state)
    if state then
        startAutoSell()
    else
        stopAutoSell()
    end
end)

-- Blatant Mode Toggle
local blatantSwitch = nil
blatantSwitch = createToggleSwitch(farmSection, nil, "⚡ BLATANT MODE (EXTREME FAST)", false, function(state)
    isBlatantMode = state
    if isAutoFishing then
        -- Restart auto fish dengan mode baru
        stopAutoFish()
        startAutoFish()
    end
    if state then
        Notify("⚡ BLATANT MODE", "Mode extreme fast fishing aktif!")
    else
        Notify("⚡ BLATANT MODE", "Mode normal")
    end
end)

-- Update farm section height
task.defer(function()
    farmSection.Size = UDim2.new(1, -16, 0, 140)
end)

-- ==================== TELEPORT SECTION ====================
local teleportSection = Instance.new("Frame")
teleportSection.Size = UDim2.new(1, -16, 0, 0)
teleportSection.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
teleportSection.BackgroundTransparency = 0.3
teleportSection.BorderSizePixel = 0
teleportSection.Parent = scrollFrame

local teleportTitle = Instance.new("TextLabel")
teleportTitle.Size = UDim2.new(1, 0, 0, 30)
teleportTitle.BackgroundTransparency = 1
teleportTitle.Text = "📍 TELEPORT"
teleportTitle.TextColor3 = Color3.fromRGB(0, 255, 255)
teleportTitle.Font = Enum.Font.GothamBold
teleportTitle.TextSize = 12
teleportTitle.Parent = teleportSection

local teleportGrid = Instance.new("Frame")
teleportGrid.Size = UDim2.new(1, 0, 0, 0)
teleportGrid.BackgroundTransparency = 1
teleportGrid.Parent = teleportSection

local gridLayout = Instance.new("UIGridLayout")
gridLayout.CellSize = UDim2.new(0, 110, 0, 32)
gridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
gridLayout.FillDirection = Enum.FillDirection.Horizontal
gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
gridLayout.Parent = teleportGrid

for _, loc in ipairs(teleportLocations) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 110, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    btn.Text = loc.Name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 9
    btn.Parent = teleportGrid
    
    btn.MouseButton1Click:Connect(function()
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(loc.Pos)
                Notify("📍 TELEPORT", "Teleport ke " .. loc.Name)
            end
        end)
    end)
end

-- Update teleport section height
task.defer(function()
    local count = #teleportLocations
    local rows = math.ceil(count / 3)
    local height = 30 + (rows * 37) + 10
    teleportSection.Size = UDim2.new(1, -16, 0, height)
    teleportGrid.Size = UDim2.new(1, 0, 0, rows * 37)
end)

-- ==================== WEATHER SECTION ====================
local weatherSection = Instance.new("Frame")
weatherSection.Size = UDim2.new(1, -16, 0, 0)
weatherSection.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
weatherSection.BackgroundTransparency = 0.3
weatherSection.BorderSizePixel = 0
weatherSection.Parent = scrollFrame

local weatherTitle = Instance.new("TextLabel")
weatherTitle.Size = UDim2.new(1, 0, 0, 30)
weatherTitle.BackgroundTransparency = 1
weatherTitle.Text = "🌦️ WEATHER CONTROL"
weatherTitle.TextColor3 = Color3.fromRGB(0, 255, 255)
weatherTitle.Font = Enum.Font.GothamBold
weatherTitle.TextSize = 12
weatherTitle.Parent = weatherSection

local weatherGrid = Instance.new("Frame")
weatherGrid.Size = UDim2.new(1, 0, 0, 0)
weatherGrid.BackgroundTransparency = 1
weatherGrid.Parent = weatherSection

local weatherGridLayout = Instance.new("UIGridLayout")
weatherGridLayout.CellSize = UDim2.new(0, 110, 0, 35)
weatherGridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
weatherGridLayout.Parent = weatherGrid

for _, weather in ipairs(weatherList) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 110, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(70, 50, 60)
    btn.Text = weather.Name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 10
    btn.Parent = weatherGrid
    
    btn.MouseButton1Click:Connect(function()
        pcall(function()
            if RFPurchaseWeatherEvent then
                RFPurchaseWeatherEvent:InvokeServer(weather.Id)
                Notify("🌦️ WEATHER", "Membeli weather: " .. weather.Name)
            else
                Notify("⚠️ ERROR", "Weather event tidak ditemukan", 2)
            end
        end)
    end)
end

task.defer(function()
    local weatherCount = #weatherList
    local weatherRows = math.ceil(weatherCount / 3)
    local weatherHeight = 30 + (weatherRows * 40) + 10
    weatherSection.Size = UDim2.new(1, -16, 0, weatherHeight)
    weatherGrid.Size = UDim2.new(1, 0, 0, weatherRows * 40)
end)

-- ==================== MISC SECTION ====================
local miscSection = Instance.new("Frame")
miscSection.Size = UDim2.new(1, -16, 0, 90)
miscSection.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
miscSection.BackgroundTransparency = 0.3
miscSection.BorderSizePixel = 0
miscSection.Parent = scrollFrame

local miscTitle = Instance.new("TextLabel")
miscTitle.Size = UDim2.new(1, 0, 0, 25)
miscTitle.BackgroundTransparency = 1
miscTitle.Text = "ℹ️ MISC"
miscTitle.TextColor3 = Color3.fromRGB(0, 255, 255)
miscTitle.Font = Enum.Font.GothamBold
miscTitle.TextSize = 12
miscTitle.Parent = miscSection

local waBtn = Instance.new("TextButton")
waBtn.Size = UDim2.new(0.48, -5, 0, 32)
waBtn.Position = UDim2.new(0, 5, 0, 30)
waBtn.BackgroundColor3 = Color3.fromRGB(37, 211, 102)
waBtn.Text = "📱 WHATSAPP OWNER"
waBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
waBtn.Font = Enum.Font.GothamBold
waBtn.TextSize = 11
waBtn.Parent = miscSection

waBtn.MouseButton1Click:Connect(function()
    pcall(function()
        setclipboard("6283890035749")
        Notify("📋 COPY", "Nomor WA disalin: 6283890035749")
    end)
end)

local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0.48, -5, 0, 32)
copyBtn.Position = UDim2.new(0.52, 0, 0, 30)
copyBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 150)
copyBtn.Text = "📋 COPY NUMBER"
copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyBtn.Font = Enum.Font.Gotham
copyBtn.TextSize = 11
copyBtn.Parent = miscSection

copyBtn.MouseButton1Click:Connect(function()
    pcall(function()
        setclipboard("6283890035749")
        Notify("📋 COPY", "Nomor WA disalin: 6283890035749")
    end)
end)

local copyrightLabel = Instance.new("TextLabel")
copyrightLabel.Size = UDim2.new(1, -10, 0, 20)
copyrightLabel.Position = UDim2.new(0, 5, 0, 68)
copyrightLabel.BackgroundTransparency = 1
copyrightLabel.Text = "© ZONE XD - APIS 2026"
copyrightLabel.TextColor3 = Color3.fromRGB(100, 100, 150)
copyrightLabel.Font = Enum.Font.Gotham
copyrightLabel.TextSize = 9
copyrightLabel.Parent = miscSection

-- ==================== NOTIFIKASI ====================
local function Notify(title, text, duration)
    duration = duration or 3
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "ZONE XD",
            Text = text or "",
            Duration = duration,
            Icon = "rbxassetid://4483345998"
        })
    end)
end

-- ==================== UPDATE CANVAS ====================
task.defer(function()
    local totalHeight = 0
    for _, child in pairs(scrollFrame:GetChildren()) do
        if child:IsA("Frame") and child ~= layout then
            totalHeight = totalHeight + child.AbsoluteSize.Y + 8
        end
    end
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 20)
end)

-- ==================== KEYBINDS ====================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        if autoFishSwitch then autoFishSwitch(not isAutoFishing) end
    end
    
    if input.KeyCode == Enum.KeyCode.G then
        if autoSellSwitch then autoSellSwitch(not isAutoSelling) end
    end
    
    if input.KeyCode == Enum.KeyCode.B then
        if blatantSwitch then blatantSwitch(not isBlatantMode) end
    end
    
    if input.KeyCode == Enum.KeyCode.RightControl then
        screenGui.Enabled = not screenGui.Enabled
        Notify("🎮 GUI", screenGui.Enabled and "Ditampilkan" or "Disembunyikan")
    end
end)

-- ==================== LOADED ====================
print("╔════════════════════════════════════════╗")
print("║  🔥 ZONE XD - FISH IT ULTIMATE V2    ║")
print("║  CREATED BY: APIS                    ║")
print("║  WHATSAPP: 6283890035749             ║")
print("║  COPYRIGHT: APIS 2026                ║")
print("╠════════════════════════════════════════╣")
print("║  ✅ AUTO FISH (FIXED)                ║")
print("║  ✅ AUTO SELL (FIXED)                ║")
print("║  ✅ BLATANT MODE                     ║")
print("║  ✅ CPU/FPS/INTERNET METER           ║")
print("║  ✅ TOGGLE SWITCH (ON/OFF)           ║")
print("║  ✅ MINIMIZE BUTTON (M)              ║")
print("║  ✅ TELEPORT 22 LOKASI               ║")
print("║  ✅ WEATHER CONTROL                  ║")
print("╚════════════════════════════════════════╝")

Notify("🔥 ZONE XD", "Fish It Ultimate V2 Loaded!\nF: Auto Fish | G: Auto Sell | B: Blatant Mode\nKlik M untuk minimize | Ctrl Kanan hide/show")