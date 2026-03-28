--[[
    ZONE XD - FISH IT ULTIMATE SCRIPT
    FITUR:
    - AUTO FISH (INSTANT CATCH)
    - AUTO SELL ALL
    - TELEPORT KE SEMUA LOKASI
    - WEATHER CONTROL
    - GUI TABLE (BISA DIPERKECIL/DIPERBESAR)
    - MOBILE/PC SUPPORT
    CREATED BY: APIS
]]

-- ==================== CEK GAME ====================
local gameId = game.PlaceId
local isFishIt = (gameId == 121864768012064) -- Fish It game ID

if not isFishIt then
    warn("Game bukan Fish It! Script ini khusus untuk Fish It.")
    -- Tetap jalan tapi mungkin ga work
end

-- ==================== LOAD LIBRARY ====================
-- Pake Mercury Library untuk GUI yang bagus
local Mercury = nil
local libraryLoaded = false

pcall(function()
    Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/main/src.lua"))()
    libraryLoaded = true
end)

if not libraryLoaded then
    -- Fallback: buat GUI sederhana
    Mercury = nil
end

-- ==================== SERVICES ====================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- ==================== NETWORK EVENTS ====================
local net = nil
local RFPurchaseWeatherEvent = nil
local RFSellAllItems = nil
local RFChargeFishingRod = nil
local RFRequestFishingMinigameStarted = nil
local REFishingCompleted = nil
local REEquipToolFromHotbar = nil

pcall(function()
    local netFolder = ReplicatedStorage:FindFirstChild("Packages")
    if netFolder then
        local sleitnick = netFolder:FindFirstChild("_Index")
        if sleitnick then
            local netPackage = sleitnick:FindFirstChild("sleitnick_net@0.2.0")
            if netPackage then
                net = netPackage:FindFirstChild("net")
            end
        end
    end
    
    if not net then
        -- Coba cari langsung
        for _, v in pairs(ReplicatedStorage:GetDescendants()) do
            if v.Name == "net" or v.Name == "RF" or v.Name == "RE" then
                net = v
                break
            end
        end
    end
    
    if net then
        RFPurchaseWeatherEvent = net:FindFirstChild("RF/PurchaseWeatherEvent")
        RFSellAllItems = net:FindFirstChild("RF/SellAllItems")
        RFChargeFishingRod = net:FindFirstChild("RF/ChargeFishingRod")
        RFRequestFishingMinigameStarted = net:FindFirstChild("RF/RequestFishingMinigameStarted")
        REFishingCompleted = net:FindFirstChild("RE/FishingCompleted")
        REEquipToolFromHotbar = net:FindFirstChild("RE/EquipToolFromHotbar")
    end
end)

-- ==================== VARIABLES ====================
local isAutoFishing = false
local isAutoSelling = false
local currentWeather = nil
local fishingLoop = nil
local sellLoop = nil
local currentCharacter = LocalPlayer.Character
local humanoid = nil

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

-- ==================== FUNGSI UTAMA ====================

-- Instant Fishing (No Delay + No Animation)
local function startAutoFish()
    if fishingLoop then task.cancel(fishingLoop) end
    
    isAutoFishing = true
    
    fishingLoop = task.spawn(function()
        while isAutoFishing do
            pcall(function()
                -- Disable animation untuk instant catch
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                    humanoid:Move(Vector3.new(0,0,0))
                end
                
                -- Equip fishing rod
                if REEquipToolFromHotbar then
                    REEquipToolFromHotbar:FireServer()
                end
                
                -- Charge rod (instant)
                if RFChargeFishingRod then
                    RFChargeFishingRod:InvokeServer(1)
                end
                
                -- Start fishing minigame (instant)
                if RFRequestFishingMinigameStarted then
                    RFRequestFishingMinigameStarted:InvokeServer(1, 1)
                end
                
                -- Complete fishing (instant)
                if REFishingCompleted then
                    REFishingCompleted:FireServer()
                end
            end)
            
            -- Delay super cepat (0.01 detik) untuk farming maksimal [citation:2]
            task.wait(0.01)
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

-- Auto Sell All Items
local function startAutoSell()
    if sellLoop then task.cancel(sellLoop) end
    
    isAutoSelling = true
    
    sellLoop = task.spawn(function()
        while isAutoSelling do
            pcall(function()
                if RFSellAllItems then
                    RFSellAllItems:InvokeServer()
                end
            end)
            task.wait(0.5) -- Sell setiap 0.5 detik
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

-- ==================== TELEPORT LOCATIONS ====================
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

-- ==================== WEATHER EVENTS ====================
local weatherList = {
    {Name = "🌬️ Wind", Price = 10000},
    {Name = "❄️ Snow", Price = 15000},
    {Name = "☁️ Cloudy", Price = 20000},
    {Name = "⛈️ Storm", Price = 35000},
    {Name = "☀️ Radiant", Price = 50000},
    {Name = "🦈 Shark Hunt", Price = 300000}
}

-- ==================== CREATE GUI ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZoneXDFishIt"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

-- Main Frame (bisa di-resize)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 380, 0, 500)
mainFrame.Position = UDim2.new(0.02, 0, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Shadow
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.7
shadow.BorderSizePixel = 0
shadow.Parent = mainFrame

-- Header (bisa drag)
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
header.BackgroundTransparency = 0.2
header.BorderSizePixel = 0
header.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🎣 ZONE XD - FISH IT ULTIMATE"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = header

-- Tombol close
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.BackgroundTransparency = 0.3
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.Parent = header
closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

-- Tombol minimize/resize
local resizeBtn = Instance.new("TextButton")
resizeBtn.Size = UDim2.new(0, 30, 0, 30)
resizeBtn.Position = UDim2.new(1, -70, 0, 5)
resizeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
resizeBtn.BackgroundTransparency = 0.3
resizeBtn.Text = "□"
resizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
resizeBtn.Font = Enum.Font.GothamBold
resizeBtn.TextSize = 16
resizeBtn.Parent = header

local isMinimized = false
local originalSize = mainFrame.Size
resizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        mainFrame:TweenSize(UDim2.new(0, 380, 0, 60), "Out", "Quad", 0.3)
        resizeBtn.Text = "□"
    else
        mainFrame:TweenSize(UDim2.new(0, 380, 0, 500), "Out", "Quad", 0.3)
        resizeBtn.Text = "□"
    end
end)

-- Draggable header
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

header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        local newX = startPos.X.Offset + delta.X
        local newY = startPos.Y.Offset + delta.Y
        mainFrame.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
    end
end)

-- Scroll Frame untuk konten
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, -40)
scrollFrame.Position = UDim2.new(0, 0, 0, 40)
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

-- ==================== AUTO FARM SECTION ====================
local farmSection = Instance.new("Frame")
farmSection.Size = UDim2.new(1, -16, 0, 100)
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
farmTitle.TextSize = 14
farmTitle.Parent = farmSection

-- Auto Fish Toggle
local autoFishBtn = Instance.new("TextButton")
autoFishBtn.Size = UDim2.new(0.48, -5, 0, 30)
autoFishBtn.Position = UDim2.new(0, 0, 0, 35)
autoFishBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 100)
autoFishBtn.Text = "🎣 AUTO FISH (OFF)"
autoFishBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoFishBtn.Font = Enum.Font.Gotham
autoFishBtn.TextSize = 12
autoFishBtn.Parent = farmSection

local autoFishActive = false
autoFishBtn.MouseButton1Click:Connect(function()
    autoFishActive = not autoFishActive
    if autoFishActive then
        startAutoFish()
        autoFishBtn.Text = "🎣 AUTO FISH (ON)"
        autoFishBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 150)
    else
        stopAutoFish()
        autoFishBtn.Text = "🎣 AUTO FISH (OFF)"
        autoFishBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 100)
    end
end)

-- Auto Sell Toggle
local autoSellBtn = Instance.new("TextButton")
autoSellBtn.Size = UDim2.new(0.48, -5, 0, 30)
autoSellBtn.Position = UDim2.new(0.52, 0, 0, 35)
autoSellBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 0)
autoSellBtn.Text = "💰 AUTO SELL (OFF)"
autoSellBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoSellBtn.Font = Enum.Font.Gotham
autoSellBtn.TextSize = 12
autoSellBtn.Parent = farmSection

local autoSellActive = false
autoSellBtn.MouseButton1Click:Connect(function()
    autoSellActive = not autoSellActive
    if autoSellActive then
        startAutoSell()
        autoSellBtn.Text = "💰 AUTO SELL (ON)"
        autoSellBtn.BackgroundColor3 = Color3.fromRGB(150, 150, 0)
    else
        stopAutoSell()
        autoSellBtn.Text = "💰 AUTO SELL (OFF)"
        autoSellBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 0)
    end
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
teleportTitle.TextSize = 14
teleportTitle.Parent = teleportSection

-- Grid untuk teleport buttons
local teleportGrid = Instance.new("Frame")
teleportGrid.Size = UDim2.new(1, 0, 0, 0)
teleportGrid.BackgroundTransparency = 1
teleportGrid.Parent = teleportSection

local gridLayout = Instance.new("UIGridLayout")
gridLayout.CellSize = UDim2.new(0, 110, 0, 35)
gridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
gridLayout.FillDirection = Enum.FillDirection.Horizontal
gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
gridLayout.Parent = teleportGrid

for _, loc in ipairs(teleportLocations) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 110, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    btn.Text = loc.Name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 10
    btn.Parent = teleportGrid
    
    btn.MouseButton1Click:Connect(function()
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(loc.Pos)
            end
        end)
    end)
end

-- Update teleport section height
task.defer(function()
    local count = #teleportLocations
    local rows = math.ceil(count / 3)
    local height = 30 + (rows * 40) + 10
    teleportSection.Size = UDim2.new(1, -16, 0, height)
    teleportGrid.Size = UDim2.new(1, 0, 0, rows * 40)
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
weatherTitle.TextSize = 14
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
    btn.BackgroundColor3 = Color3.fromRGB(70, 50, 50)
    btn.Text = weather.Name .. "\n💰" .. weather.Price
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 9
    btn.Parent = weatherGrid
    
    btn.MouseButton1Click:Connect(function()
        pcall(function()
            local weatherName = weather.Name:gsub("[🌬️❄️☁️⛈️☀️🦈]",""):gsub(" ","")
            if RFPurchaseWeatherEvent then
                RFPurchaseWeatherEvent:InvokeServer(weatherName)
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

-- ==================== INFO SECTION ====================
local infoSection = Instance.new("Frame")
infoSection.Size = UDim2.new(1, -16, 0, 80)
infoSection.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
infoSection.BackgroundTransparency = 0.3
infoSection.BorderSizePixel = 0
infoSection.Parent = scrollFrame

local infoTitle = Instance.new("TextLabel")
infoTitle.Size = UDim2.new(1, 0, 0, 25)
infoTitle.BackgroundTransparency = 1
infoTitle.Text = "ℹ️ INFO"
infoTitle.TextColor3 = Color3.fromRGB(0, 255, 255)
infoTitle.Font = Enum.Font.GothamBold
infoTitle.TextSize = 14
infoTitle.Parent = infoSection

local infoText = Instance.new("TextLabel")
infoText.Size = UDim2.new(1, -10, 0, 45)
infoText.Position = UDim2.new(0, 5, 0, 25)
infoText.BackgroundTransparency = 1
infoText.Text = "🎣 AUTO FISH: Instant catch tanpa delay\n💰 AUTO SELL: Jual semua ikan otomatis\n📍 TELEPORT: Klik untuk pindah lokasi\n🌦️ WEATHER: Beli event cuaca"
infoText.TextColor3 = Color3.fromRGB(200, 200, 200)
infoText.Font = Enum.Font.Gotham
infoText.TextSize = 10
infoText.TextXAlignment = Enum.TextXAlignment.Left
infoText.TextYAlignment = Enum.TextYAlignment.Top
infoText.Parent = infoSection

-- ==================== UPDATE CANVAS SIZE ====================
task.defer(function()
    local totalHeight = 100 + teleportSection.AbsoluteSize.Y + weatherSection.AbsoluteSize.Y + 80 + 20
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 20)
end)

-- ==================== NOTIFIKASI ====================
local function Notify(title, text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title or "ZONE XD",
            Text = text or "",
            Duration = 3,
            Icon = "rbxassetid://4483345998"
        })
    end)
end

Notify("🎣 ZONE XD", "Fish It Ultimate Script Loaded!\nGUI bisa di-drag dan di-resize")

-- ==================== KEYBINDS ====================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        autoFishActive = not autoFishActive
        if autoFishActive then
            startAutoFish()
            autoFishBtn.Text = "🎣 AUTO FISH (ON)"
            autoFishBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 150)
            Notify("🎣 AUTO FISH", "Aktif! Tekan F lagi untuk matikan")
        else
            stopAutoFish()
            autoFishBtn.Text = "🎣 AUTO FISH (OFF)"
            autoFishBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 100)
            Notify("🎣 AUTO FISH", "Nonaktif")
        end
    end
    
    if input.KeyCode == Enum.KeyCode.G then
        autoSellActive = not autoSellActive
        if autoSellActive then
            startAutoSell()
            autoSellBtn.Text = "💰 AUTO SELL (ON)"
            autoSellBtn.BackgroundColor3 = Color3.fromRGB(150, 150, 0)
            Notify("💰 AUTO SELL", "Aktif! Tekan G lagi untuk matikan")
        else
            stopAutoSell()
            autoSellBtn.Text = "💰 AUTO SELL (OFF)"
            autoSellBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 0)
            Notify("💰 AUTO SELL", "Nonaktif")
        end
    end
    
    if input.KeyCode == Enum.KeyCode.RightControl then
        screenGui.Enabled = not screenGui.Enabled
        Notify("🎮 GUI", screenGui.Enabled and "Ditampilkan" or "Disembunyikan")
    end
end)

print("🔥 ZONE XD - FISH IT ULTIMATE SCRIPT LOADED!")
print("🎣 Fitur: Auto Fish (F) | Auto Sell (G) | Teleport | Weather")
print("📱 GUI bisa di-drag dan di-resize | Tekan Ctrl Kanan untuk hide/show")