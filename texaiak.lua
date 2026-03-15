--[[
    🔥 ZONE XD - ULTIMATE REWIND (FALL DETECTOR + MANUAL) 🔥
    COPYRIGHT: APIS (USER 01) - ZONE XD V1
    FITUR: Auto deteksi jatuh + Tombol manual, balik pelan ke posisi sebelum jatuh
]]

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- ==================================================
-- SETTINGS LENGKAP
-- ==================================================
local settings = {
    -- FITUR OTOMATIS
    autoDetectFall = true,           -- Otomatis deteksi jatuh ON/OFF
    fallDistance = 30,                -- Jarak jatuh (studs) sebelum trigger
    
    -- MANUAL BUTTON
    manualRewind = true,              -- Aktifin tombol manual
    
    -- HISTORY SETTINGS
    maxHistory = 600,                  -- Max frame disimpan (20 detik di 30fps)
    
    -- FLIGHT SETTINGS
    returnSpeed = 0.03,                -- Kecepatan balik (makin kecil makin lambat)
    smoothMovement = 0.2,               -- Smoothness gerakan
    
    -- VISUAL
    effects = true,
    
    -- STATUS
    isRewinding = false,
    isFalling = false,
    lastStableY = 0,
    fallStartY = 0,
    returnProgress = 0,
    returnStartPos = nil,
    returnTargetPos = nil,
    
    -- HISTORY DATA (FIFO)
    positionHistory = {},              -- Nyimpen posisi terakhir
    historyIndex = 1,
    
    -- GUI
    tableMinimized = false
}

-- ==================================================
-- CREATE GUI LENGKAP
-- ==================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UltimateRewind"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

-- MAIN FRAME
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 280)
mainFrame.Position = UDim2.new(0, 20, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 15)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true

-- CORNER & STROKE
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 20)
uiCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(0, 200, 255)
uiStroke.Thickness = 2
uiStroke.Parent = mainFrame

-- TITLE
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🌀 ULTIMATE REWIND"
titleLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.Parent = mainFrame

-- STATUS PANEL
local statusFrame = Instance.new("Frame")
statusFrame.Size = UDim2.new(0.9, 0, 0, 45)
statusFrame.Position = UDim2.new(0.05, 0, 0, 60)
statusFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
statusFrame.BackgroundTransparency = 0.3
statusFrame.Parent = mainFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 10)
statusCorner.Parent = statusFrame

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(0.4, 0, 1, 0)
statusText.Position = UDim2.new(0.05, 0, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "STATUS:"
statusText.TextColor3 = Color3.fromRGB(200, 200, 200)
statusText.TextScaled = true
statusText.Font = Enum.Font.GothamBold
statusText.Parent = statusFrame

local statusValue = Instance.new("TextLabel")
statusValue.Size = UDim2.new(0.5, 0, 1, 0)
statusValue.Position = UDim2.new(0.45, 0, 0, 0)
statusValue.BackgroundTransparency = 1
statusValue.Text = "🟢 AMAN"
statusValue.TextColor3 = Color3.fromRGB(0, 255, 0)
statusValue.TextScaled = true
statusValue.Font = Enum.Font.GothamBlack
statusValue.Parent = statusFrame

-- AUTO FALL TOGGLE
local autoFrame = Instance.new("Frame")
autoFrame.Size = UDim2.new(0.9, 0, 0, 35)
autoFrame.Position = UDim2.new(0.05, 0, 0, 115)
autoFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
autoFrame.BackgroundTransparency = 0.3
autoFrame.Parent = mainFrame

local autoCorner = Instance.new("UICorner")
autoCorner.CornerRadius = UDim.new(0, 8)
autoCorner.Parent = autoFrame

local autoLabel = Instance.new("TextLabel")
autoLabel.Size = UDim2.new(0.6, 0, 1, 0)
autoLabel.Position = UDim2.new(0.05, 0, 0, 0)
autoLabel.BackgroundTransparency = 1
autoLabel.Text = "AUTO DETECT:"
autoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
autoLabel.TextScaled = true
autoLabel.Font = Enum.Font.GothamBold
autoLabel.Parent = autoFrame

local autoToggle = Instance.new("TextButton")
autoToggle.Size = UDim2.new(0.25, 0, 0.7, 0)
autoToggle.Position = UDim2.new(0.7, 0, 0.15, 0)
autoToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
autoToggle.Text = "ON"
autoToggle.TextColor3 = Color3.fromRGB(0, 0, 0)
autoToggle.TextScaled = true
autoToggle.Font = Enum.Font.GothamBlack
autoToggle.Parent = autoFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = autoToggle

-- BUTTONS PANEL
local buttonFrame = Instance.new("Frame")
buttonFrame.Size = UDim2.new(0.9, 0, 0, 45)
buttonFrame.Position = UDim2.new(0.05, 0, 0, 160)
buttonFrame.BackgroundTransparency = 1
buttonFrame.Parent = mainFrame

-- REWIND BUTTON (MANUAL)
local rewindButton = Instance.new("TextButton")
rewindButton.Size = UDim2.new(0.7, 0, 1, 0)
rewindButton.Position = UDim2.new(0, 0, 0, 0)
rewindButton.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
rewindButton.Text = "🌀 REWIND MANUAL"
rewindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
rewindButton.TextScaled = true
rewindButton.Font = Enum.Font.GothamBlack
rewindButton.Parent = buttonFrame

local rewCorner = Instance.new("UICorner")
rewCorner.CornerRadius = UDim.new(0, 15)
rewCorner.Parent = rewindButton

-- MINIMIZE BUTTON
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -40, 0, 10)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
minimizeBtn.Text = "🔼"
minimizeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
minimizeBtn.TextScaled = true
minimizeBtn.Font = Enum.Font.GothamBlack
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = mainFrame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 10)
minCorner.Parent = minimizeBtn

-- INFO TEXT
local infoText = Instance.new("TextLabel")
infoText.Size = UDim2.new(0.9, 0, 0, 40)
infoText.Position = UDim2.new(0.05, 0, 0, 215)
infoText.BackgroundTransparency = 1
infoText.Text = "📊 History: 0 | Auto: ON"
infoText.TextColor3 = Color3.fromRGB(150, 150, 150)
infoText.TextScaled = true
infoText.Font = Enum.Font.Gotham
infoText.Parent = mainFrame

-- ==================================================
-- FUNGSI REWIND (MANUAL & OTOMATIS)
-- ==================================================
local function startRewind(targetFrame)
    if settings.isRewinding then return end
    if #settings.positionHistory < 10 then 
        infoText.Text = "⚠️ History kurang! Tunggu bentar..."
        return 
    end
    
    -- Pilih target frame (default: frame sebelum jatuh)
    local targetIndex = targetFrame or math.max(1, #settings.positionHistory - 60)  -- 2 detik sebelum
    
    settings.isRewinding = true
    settings.returnStartPos = nil
    settings.returnTargetPos = settings.positionHistory[targetIndex].position
    settings.returnProgress = 0
    
    -- Update UI
    statusValue.Text = "⏪ REWIND"
    statusValue.TextColor3 = Color3.fromRGB(255, 200, 0)
    rewindButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    rewindButton.Text = "⏳..."
    
    -- Matikan physics
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = true
            humanoid.AutoRotate = false
        end
    end
end

local function stopRewind()
    settings.isRewinding = false
    settings.returnProgress = 0
    settings.returnStartPos = nil
    settings.returnTargetPos = nil
    
    -- Update UI
    statusValue.Text = "🟢 AMAN"
    statusValue.TextColor3 = Color3.fromRGB(0, 255, 0)
    rewindButton.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
    rewindButton.Text = "🌀 REWIND MANUAL"
    
    -- Aktifin physics lagi
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
            humanoid.AutoRotate = true
        end
    end
end

-- ==================================================
-- DETEKSI JATUH OTOMATIS
-- ==================================================
local function checkFall()
    local character = player.Character
    if not character then return false end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    
    local currentY = root.Position.Y
    
    -- Simpan posisi stabil (saat ga jatuh)
    if not settings.isFalling then
        settings.lastStableY = currentY
    end
    
    -- Deteksi jatuh (Y turun drastis)
    if settings.autoDetectFall and not settings.isRewinding then
        if currentY < settings.lastStableY - settings.fallDistance then
            if not settings.isFalling then
                settings.isFalling = true
                settings.fallStartY = currentY
                statusValue.Text = "⚠️ JATUH!"
                statusValue.TextColor3 = Color3.fromRGB(255, 0, 0)
            end
            
            -- Kalo jatuh terlalu dalam, trigger rewind
            if currentY < settings.lastStableY - (settings.fallDistance * 2) then
                -- Cari frame sebelum jatuh
                local preFallFrame = nil
                for i = #settings.positionHistory, 1, -1 do
                    if settings.positionHistory[i].position.Y > settings.lastStableY - 5 then
                        preFallFrame = i
                        break
                    end
                end
                
                if preFallFrame then
                    startRewind(preFallFrame)
                    settings.isFalling = false
                end
            end
        else
            settings.isFalling = false
        end
    end
end

-- ==================================================
-- BUTTON EVENTS
-- ==================================================
rewindButton.MouseButton1Click:Connect(function()
    startRewind()
end)

autoToggle.MouseButton1Click:Connect(function()
    settings.autoDetectFall = not settings.autoDetectFall
    if settings.autoDetectFall then
        autoToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        autoToggle.Text = "ON"
        infoText.Text = "📊 History: " .. #settings.positionHistory .. " | Auto: ON"
    else
        autoToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        autoToggle.Text = "OFF"
        infoText.Text = "📊 History: " .. #settings.positionHistory .. " | Auto: OFF"
    end
end)

minimizeBtn.MouseButton1Click:Connect(function()
    settings.tableMinimized = not settings.tableMinimized
    
    local targetSize = settings.tableMinimized and UDim2.new(0, 250, 0, 60) or UDim2.new(0, 250, 0, 280)
    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = targetSize})
    tween:Play()
    
    -- Hide/show elements
    titleLabel.Visible = not settings.tableMinimized
    statusFrame.Visible = not settings.tableMinimized
    autoFrame.Visible = not settings.tableMinimized
    buttonFrame.Visible = not settings.tableMinimized
    infoText.Visible = not settings.tableMinimized
    
    minimizeBtn.Text = settings.tableMinimized and "🔽" or "🔼"
end)

-- ==================================================
-- MAIN LOOP - RECORD + REWIND + DETEKSI JATUH
-- ==================================================
RunService.Heartbeat:Connect(function()
    local character = player.Character
    if not character then return end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    if not root or not humanoid then return end
    
    -- ===== RECORD POSISI (FIFO) =====
    table.insert(settings.positionHistory, {
        position = root.Position,
        rotation = root.Orientation,
        time = tick()
    })
    
    -- Batasi jumlah history
    if #settings.positionHistory > settings.maxHistory then
        table.remove(settings.positionHistory, 1)
    end
    
    -- ===== DETEKSI JATUH =====
    checkFall()
    
    -- ===== UPDATE INFO =====
    if not settings.isRewinding then
        infoText.Text = "📊 History: " .. #settings.positionHistory .. " | Auto: " .. (settings.autoDetectFall and "ON" or "OFF")
    end
    
    -- ===== PROSES REWIND (GERAK PELAN) =====
    if settings.isRewinding and settings.returnTargetPos then
        if not settings.returnStartPos then
            settings.returnStartPos = root.Position
        end
        
        -- Hitung progress
        settings.returnProgress = settings.returnProgress + settings.returnSpeed
        
        -- Lerp position (smooth)
        local newPos = settings.returnStartPos:Lerp(settings.returnTargetPos, settings.returnProgress)
        root.CFrame = CFrame.new(newPos) * CFrame.Angles(0, math.rad(root.Orientation.Y), 0)
        
        -- Efek visual
        if settings.effects then
            root.Transparency = 0.2 + (0.3 * math.sin(settings.returnProgress * 20))
        end
        
        -- Kalo udah sampe
        if settings.returnProgress >= 1 then
            stopRewind()
            root.Transparency = 0
        end
    end
end)

-- ==================================================
-- NOTIFICATION AWAL
-- ==================================================
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🔥 ZONE XD - ULTIMATE REWIND";
    Text = "Auto detect jatuh + Tombol manual! Balik pelan!";
    Duration = 5;
})

print([[
╔══════════════════════════════════════════════════════════╗
║   🔥 ZONE XD - ULTIMATE REWIND 🔥                        ║
║   ✅ AUTO DETEKSI JATUH + TOMBOL MANUAL                  ║
║   ✅ BALIK PELAN KE POSISI SEBELUM JATUH                 ║
║   ✅ SMOOTH MOVEMENT + EFFECTS                           ║
║   ✅ HISTORY 600 FRAME (20 DETIK)                        ║
║   👑 COPYRIGHT: APIS - ZONE XD V1                        ║
╚══════════════════════════════════════════════════════════╝
]])