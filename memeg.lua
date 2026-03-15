--[[
    🔥 ZONE XD - TRUE REWIND REVIVE 🔥
    COPYRIGHT: APIS (USER 01) - ZONE XD V1
    FITUR: Merekam gerakan jatuh, lalu memutar mundur persis kayak video replay!
]]

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- ==================================================
-- SETTINGS
-- ==================================================
local settings = {
    isRecording = false,
    isRewinding = false,
    recordData = {},           -- Nyimpen posisi & rotasi tiap frame
    recordStartTime = 0,
    currentRewindFrame = 1,
    tableMinimized = false
}

-- ==================================================
-- CREATE GUI
-- ==================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TrueRewind"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

-- MAIN FRAME
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 140)
mainFrame.Position = UDim2.new(0, 20, 0.5, -70)
mainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 15)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 15)
uiCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(0, 255, 200)
uiStroke.Thickness = 2
uiStroke.Parent = mainFrame

-- TITLE
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 35)
titleLabel.Position = UDim2.new(0, 0, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⏪ TRUE REWIND"
titleLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.Parent = mainFrame

-- STATUS
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0, 25)
statusLabel.Position = UDim2.new(0.05, 0, 0, 45)
statusLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
statusLabel.BackgroundTransparency = 0.5
statusLabel.Text = "⏸️ STAND BY"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.GothamBold
statusLabel.Parent = mainFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 8)
statusCorner.Parent = statusLabel

-- RECORD BUTTON
local recordButton = Instance.new("TextButton")
recordButton.Size = UDim2.new(0.4, 0, 0, 35)
recordButton.Position = UDim2.new(0.05, 0, 0, 80)
recordButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
recordButton.Text = "⏺️ REC"
recordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
recordButton.TextScaled = true
recordButton.Font = Enum.Font.GothamBlack
recordButton.Parent = mainFrame

local recCorner = Instance.new("UICorner")
recCorner.CornerRadius = UDim.new(0, 10)
recCorner.Parent = recordButton

-- REWIND BUTTON
local rewindButton = Instance.new("TextButton")
rewindButton.Size = UDim2.new(0.4, 0, 0, 35)
rewindButton.Position = UDim2.new(0.55, 0, 0, 80)
rewindButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
rewindButton.Text = "⏪ REWIND"
rewindButton.TextColor3 = Color3.fromRGB(0, 0, 0)
rewindButton.TextScaled = true
rewindButton.Font = Enum.Font.GothamBlack
rewindButton.Parent = mainFrame

local rewCorner = Instance.new("UICorner")
rewCorner.CornerRadius = UDim.new(0, 10)
rewCorner.Parent = rewindButton

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

-- ==================================================
-- FUNGSI MEREKAM GERAKAN
-- ==================================================
local function startRecording()
    if settings.isRewinding then return end
    
    settings.isRecording = true
    settings.recordData = {}
    settings.recordStartTime = tick()
    
    statusLabel.Text = "⏺️ RECORDING..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    recordButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    recordButton.Text = "⏹️ STOP"
    
    print("🔥 MULAI MEREKAM GERAKAN!")
end

local function stopRecording()
    settings.isRecording = false
    statusLabel.Text = "⏸️ RECORDED (" .. #settings.recordData .. " frames)"
    statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    recordButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    recordButton.Text = "⏺️ REC"
    
    print("✅ REKAMAN SELESAI! Total frame: " .. #settings.recordData)
end

-- ==================================================
-- FUNGSI REWIND (MUTER MUNDUR PERSIS KAYA GERAKAN ASLI)
-- ==================================================
local function startRewind()
    if settings.isRecording or settings.isRewinding or #settings.recordData == 0 then
        if #settings.recordData == 0 then
            statusLabel.Text = "❌ GA ADA REKAMAN!"
            task.wait(1)
            statusLabel.Text = "⏸️ STAND BY"
        end
        return
    end
    
    settings.isRewinding = true
    settings.currentRewindFrame = #settings.recordData  -- Mulai dari frame terakhir
    
    statusLabel.Text = "⏪ REWINDING..."
    statusLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    rewindButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    rewindButton.Text = "⏸️ PAUSE"
    
    -- Matikan physics selama rewind
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = true
            humanoid.AutoRotate = false
        end
    end
    
    print("⏪ MULAI REWIND! Frame: " .. #settings.recordData)
end

local function stopRewind()
    settings.isRewinding = false
    statusLabel.Text = "⏸️ REWIND DONE"
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    rewindButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    rewindButton.Text = "⏪ REWIND"
    
    -- Aktifin physics lagi
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
            humanoid.AutoRotate = true
        end
    end
    
    print("✅ REWIND SELESAI!")
end

-- ==================================================
-- BUTTON EVENTS
-- ==================================================
recordButton.MouseButton1Click:Connect(function()
    if settings.isRecording then
        stopRecording()
    else
        startRecording()
    end
end)

rewindButton.MouseButton1Click:Connect(function()
    if settings.isRewinding then
        stopRewind()
    else
        startRewind()
    end
end)

minimizeBtn.MouseButton1Click:Connect(function()
    settings.tableMinimized = not settings.tableMinimized
    
    local targetSize = settings.tableMinimized and UDim2.new(0, 200, 0, 50) or UDim2.new(0, 200, 0, 140)
    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = targetSize})
    tween:Play()
    
    titleLabel.Visible = not settings.tableMinimized
    statusLabel.Visible = not settings.tableMinimized
    recordButton.Visible = not settings.tableMinimized
    rewindButton.Visible = not settings.tableMinimized
    
    minimizeBtn.Text = settings.tableMinimized and "🔽" or "🔼"
end)

-- ==================================================
-- MAIN LOOP - REKAM & PUTAR ULANG
-- ==================================================
RunService.Heartbeat:Connect(function()
    local character = player.Character
    if not character then return end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    
    if not root or not humanoid then return end
    
    -- ===== REKAM GERAKAN =====
    if settings.isRecording then
        table.insert(settings.recordData, {
            position = root.Position,
            rotation = root.Orientation,
            time = tick() - settings.recordStartTime,
            velocity = root.Velocity,
            humanoidState = humanoid:GetState()
        })
    end
    
    -- ===== PUTAR ULANG MUNDUR (REWIND) =====
    if settings.isRewinding and #settings.recordData > 0 then
        local frame = settings.recordData[settings.currentRewindFrame]
        
        if frame then
            -- Set posisi dan rotasi sesuai rekaman
            root.CFrame = CFrame.new(frame.position) * CFrame.Angles(0, math.rad(frame.rotation.Y), 0)
            root.Velocity = Vector3.new(0, 0, 0)  -- Stop velocity pas rewind
            
            -- Efek visual biar keliatan lagi rewind
            root.Transparency = 0.3 + (0.2 * math.sin(settings.currentRewindFrame * 0.5))
            
            -- Mundur ke frame sebelumnya
            settings.currentRewindFrame = settings.currentRewindFrame - 1
            
            -- Kalau udah sampai awal, berhenti
            if settings.currentRewindFrame < 1 then
                stopRewind()
                root.Transparency = 0
            end
            
            task.wait(0.03)  -- Delay biar keliatan muter mundurnya
        else
            stopRewind()
        end
    end
end)

-- ==================================================
-- NOTIFICATION
-- ==================================================
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🔥 ZONE XD - TRUE REWIND";
    Text = "Tekan REC buat rekam jatuh, lalu REWIND buat muter mundur!";
    Duration = 5;
})

print([[
╔══════════════════════════════════════════════════╗
║   🔥 ZONE XD - TRUE REWIND REVIVE 🔥            ║
║   ✅ REKAM gerakan jatuh lu                      ║
║   ✅ PUTAR MUNDUR persis kayak video             ║
║   ✅ Gerakan asli balik ke atas                  ║
║   👑 COPYRIGHT: APIS - ZONE XD V1                ║
╚══════════════════════════════════════════════════╝
]])