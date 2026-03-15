--[[
    🔥 ZONE XD - AUTO REWIND (SMOOTH) 🔥
    COPYRIGHT: APIS (USER 01) - ZONE XD V1
    FITUR: Nyimpen koordinat tiap detik, tinggal pencet tombol buat rewind
]]

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- ==================================================
-- SETTINGS
-- ==================================================
local settings = {
    isRewinding = false,
    positionHistory = {},           -- Nyimpen history posisi
    maxHistory = 300,                -- Max 300 frame (10 detik kalo 30fps)
    currentRewindIndex = 1,
    tableMinimized = false
}

-- ==================================================
-- CREATE GUI MINIMALIS
-- ==================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SimpleRewind"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

-- MAIN FRAME (UKURAN KECIL)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 180, 0, 100)
mainFrame.Position = UDim2.new(0, 20, 0.5, -50)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 15)
uiCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(0, 200, 255)
uiStroke.Thickness = 2
uiStroke.Parent = mainFrame

-- TITLE
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⏪ SMOOTH REWIND"
titleLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.Parent = mainFrame

-- TOMBOL REWIND (BESAR)
local rewindButton = Instance.new("TextButton")
rewindButton.Size = UDim2.new(0.8, 0, 0, 40)
rewindButton.Position = UDim2.new(0.1, 0, 0, 45)
rewindButton.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
rewindButton.Text = "🌀 REWIND"
rewindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
rewindButton.TextScaled = true
rewindButton.Font = Enum.Font.GothamBlack
rewindButton.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 20)
btnCorner.Parent = rewindButton

-- MINIMIZE BUTTON
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
minimizeBtn.Position = UDim2.new(1, -30, 0, 5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
minimizeBtn.Text = "🔼"
minimizeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
minimizeBtn.TextScaled = true
minimizeBtn.Font = Enum.Font.GothamBlack
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = mainFrame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = minimizeBtn

-- STATUS TEXT (KECIL)
local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, 0, 0, 15)
statusText.Position = UDim2.new(0, 0, 1, -18)
statusText.BackgroundTransparency = 1
statusText.Text = "📊 History: 0 frame"
statusText.TextColor3 = Color3.fromRGB(150, 150, 150)
statusText.TextScaled = true
statusText.Font = Enum.Font.Gotham
statusText.Parent = mainFrame

-- ==================================================
-- FUNGSI REWIND (SMOOTH)
-- ==================================================
local function startRewind()
    if settings.isRewinding then return end
    if #settings.positionHistory < 10 then 
        statusText.Text = "⚠️ History kurang!"
        return 
    end
    
    settings.isRewinding = true
    settings.currentRewindIndex = #settings.positionHistory
    
    rewindButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    rewindButton.Text = "⏳..."
    statusText.Text = "⏪ REWINDING..."
    
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
    rewindButton.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
    rewindButton.Text = "🌀 REWIND"
    statusText.Text = "📊 History: " .. #settings.positionHistory .. " frame"
    
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
-- BUTTON EVENTS
-- ==================================================
rewindButton.MouseButton1Click:Connect(startRewind)

-- Hover effect
rewindButton.MouseEnter:Connect(function()
    if not settings.isRewinding then
        rewindButton.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
    end
end)

rewindButton.MouseLeave:Connect(function()
    if not settings.isRewinding then
        rewindButton.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
    end
end)

minimizeBtn.MouseButton1Click:Connect(function()
    settings.tableMinimized = not settings.tableMinimized
    
    local targetSize = settings.tableMinimized and UDim2.new(0, 180, 0, 45) or UDim2.new(0, 180, 0, 100)
    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = targetSize})
    tween:Play()
    
    titleLabel.Visible = not settings.tableMinimized
    rewindButton.Visible = not settings.tableMinimized
    statusText.Visible = not settings.tableMinimized
    
    minimizeBtn.Text = settings.tableMinimized and "🔽" or "🔼"
end)

-- ==================================================
-- MAIN LOOP - RECORD OTOMATIS + REWIND
-- ==================================================
RunService.Heartbeat:Connect(function()
    local character = player.Character
    if not character then return end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    -- ===== RECORD POSISI SETIAP FRAME (O TOMATIS) =====
    table.insert(settings.positionHistory, {
        position = root.Position,
        rotation = root.Orientation
    })
    
    -- Batasi jumlah history (FIFO - First In First Out)
    if #settings.positionHistory > settings.maxHistory then
        table.remove(settings.positionHistory, 1)
    end
    
    -- Update status
    if not settings.isRewinding then
        statusText.Text = "📊 History: " .. #settings.positionHistory .. " frame"
    end
    
    -- ===== REWIND (MUNDUR SMOOTH) =====
    if settings.isRewinding and #settings.positionHistory > 0 then
        local frame = settings.positionHistory[settings.currentRewindIndex]
        
        if frame then
            -- Interpolasi smooth (lerp)
            local targetCF = CFrame.new(frame.position) * CFrame.Angles(0, math.rad(frame.rotation.Y), 0)
            root.CFrame = root.CFrame:Lerp(targetCF, 0.3)  -- Smooth movement
            
            -- Efek transparan
            root.Transparency = 0.2 + (0.3 * math.sin(settings.currentRewindIndex * 0.1))
            
            -- Mundur pelan-pelan
            settings.currentRewindIndex = settings.currentRewindIndex - 0.5  -- Lebih smooth
            
            -- Kalau udah awal atau kehabisan data
            if settings.currentRewindIndex < 1 or settings.currentRewindIndex > #settings.positionHistory then
                stopRewind()
                root.Transparency = 0
            end
        else
            stopRewind()
        end
    end
end)

-- ==================================================
-- NOTIFICATION AWAL
-- ==================================================
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🔥 ZONE XD - SMOOTH REWIND";
    Text = "Otomatis record posisi, tinggal pencet REWIND!";
    Duration = 4;
})

print([[
╔══════════════════════════════════════════════════╗
║   🔥 ZONE XD - SMOOTH REWIND 🔥                  ║
║   ✅ OTOMATIS record posisi tiap detik           ║
║   ✅ Tinggal PENCET tombol, LANGSUNG rewind      ║
║   ✅ Smooth movement (lerp), gak patah-patah     ║
║   ✅ History tetep nyimpen walau mati/fall       ║
║   👑 COPYRIGHT: APIS - ZONE XD V1                ║
╚══════════════════════════════════════════════════╝
]])