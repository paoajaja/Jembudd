--[[
    🔥 ZONE XD - STEPPING STONES (MANUAL JUMP) 🔥
    COPYRIGHT: APIS 2026
    FITUR: 1x loncat manual = 1x lantai (BUKAN LOOP)
]]

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- ==================================================
-- SETTINGS
-- ==================================================
local settings = {
    enabled = false,  -- MULAI OFF
    platformDuration = 3,  -- Lantai ilang setelah 3 detik
}

-- ==================================================
-- CREATE GUI
-- ==================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZoneXD_Manual"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

-- MAIN FRAME
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 180)
mainFrame.Position = UDim2.new(0.5, -125, 0.1, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 15)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(0, 200, 255)
mainStroke.Thickness = 2
mainStroke.Parent = mainFrame

-- TITLE
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🪜 STEPPING STONES"
titleLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.Parent = mainFrame

-- STATUS PANEL
local statusFrame = Instance.new("Frame")
statusFrame.Size = UDim2.new(0.9, 0, 0, 50)
statusFrame.Position = UDim2.new(0.05, 0, 0, 50)
statusFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
statusFrame.BackgroundTransparency = 0.3
statusFrame.Parent = mainFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 10)
statusCorner.Parent = statusFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.5, 0, 1, 0)
statusLabel.Position = UDim2.new(0.05, 0, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "STATUS:"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.GothamBold
statusLabel.Parent = statusFrame

local statusValue = Instance.new("TextLabel")
statusValue.Size = UDim2.new(0.4, 0, 1, 0)
statusValue.Position = UDim2.new(0.55, 0, 0, 0)
statusValue.BackgroundTransparency = 1
statusValue.Text = "🔴 OFF"
statusValue.TextColor3 = Color3.fromRGB(255, 0, 0)
statusValue.TextScaled = true
statusValue.Font = Enum.Font.GothamBlack
statusValue.Parent = statusFrame

-- TOMBOL TOGGLE
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.8, 0, 0, 45)
toggleButton.Position = UDim2.new(0.1, 0, 0, 110)
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
toggleButton.Text = "🔴 HIDUPKAN"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBlack
toggleButton.BorderSizePixel = 0
toggleButton.Parent = mainFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 15)
toggleCorner.Parent = toggleButton

-- ==================================================
-- STEPPING STONES SYSTEM (MANUAL JUMP)
-- ==================================================

-- Fungsi bikin lantai
local function spawnPlatform(position)
    if not settings.enabled then return end
    
    local platform = Instance.new("Part")
    platform.Size = Vector3.new(5, 0.5, 5)  -- Lantai ukuran 5x5
    platform.Position = position - Vector3.new(0, 2.5, 0)  -- Pas di bawah kaki
    platform.Anchored = true
    platform.CanCollide = true
    platform.Transparency = 0.4
    platform.BrickColor = BrickColor.new("Cyan")
    platform.Material = Enum.Material.Glass
    platform.Parent = workspace
    
    -- Efek spawn
    platform.Transparency = 0.8
    for i = 1, 4 do
        platform.Transparency = platform.Transparency - 0.1
        task.wait(0.02)
    end
    
    -- Hapus setelah durasi
    task.delay(settings.platformDuration, function()
        -- Efek ilang
        for i = 1, 4 do
            platform.Transparency = platform.Transparency + 0.1
            task.wait(0.02)
        end
        platform:Destroy()
    end)
end

-- DETEKSI LONCAT MANUAL (BUKAN LOOP)
local function onManualJump()
    if not settings.enabled then return end
    if not player.Character then return end
    
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if root then
        spawnPlatform(root.Position)
    end
end

-- Event pas pencet tombol loncat (spasi)
UserInputService.JumpRequest:Connect(function()
    onManualJump()
end)

-- ==================================================
-- FUNGSI TOGGLE
-- ==================================================
local function toggleSystem()
    settings.enabled = not settings.enabled
    
    if settings.enabled then
        statusValue.Text = "🟢 ON"
        statusValue.TextColor3 = Color3.fromRGB(0, 255, 0)
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        toggleButton.Text = "🟢 MATIKAN"
    else
        statusValue.Text = "🔴 OFF"
        statusValue.TextColor3 = Color3.fromRGB(255, 0, 0)
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        toggleButton.Text = "🔴 HIDUPKAN"
    end
end

toggleButton.MouseButton1Click:Connect(toggleSystem)

-- Hover effect
toggleButton.MouseEnter:Connect(function()
    if settings.enabled then
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

toggleButton.MouseLeave:Connect(function()
    if settings.enabled then
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    else
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

-- ==================================================
-- NOTIFIKASI
-- ==================================================
print("🔥 STEPPING STONES (MANUAL JUMP) READY!")
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "ZONE XD",
    Text = "1 loncat manual = 1 lantai (bukan loop!)",
    Duration = 4
})