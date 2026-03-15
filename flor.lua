--[[
    🔥 ZONE XD - STEPPING STONES PRO (DENGAN ANIMASI) 🔥
    COPYRIGHT: APIS 2026
    FITUR: Lantai otomatis + Infinite jump + Toggle + Animasi Title
]]

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- ==================================================
-- SETTINGS
-- ==================================================
local settings = {
    stepping = {
        enabled = false,  -- MULAI OFF
        platformSize = Vector3.new(5, 0.5, 5),
        platformDuration = 2,
        platformTransparency = 0.4,
        infiniteJump = true,
    },
    gui = {
        minimized = false,
    }
}

-- ==================================================
-- ANIMASI TITLE (MUNCUL HURUF PER HURUF)
-- ==================================================
local titleGui = Instance.new("ScreenGui")
titleGui.Name = "ZoneXD_Animation"
titleGui.Parent = playerGui
titleGui.ResetOnSpawn = false
titleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
titleGui.IgnoreGuiInset = true

local titleFrame = Instance.new("Frame")
titleFrame.Size = UDim2.new(0, 500, 0, 150)
titleFrame.Position = UDim2.new(0.5, -250, 0.5, -75)
titleFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
titleFrame.BackgroundTransparency = 0.3
titleFrame.BorderSizePixel = 0
titleFrame.Parent = titleGui

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 20)
titleCorner.Parent = titleFrame

local titleStroke = Instance.new("UIStroke")
titleStroke.Color = Color3.fromRGB(255, 50, 50)
titleStroke.Thickness = 3
titleStroke.Parent = titleFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = ""
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.Parent = titleFrame

-- ANIMASI HURUF PER HURUF
local fullText = "SELAMAT MEMAKAI ZONEXD"
local currentChar = 0

spawn(function()
    for i = 1, #fullText do
        currentChar = i
        titleLabel.Text = string.sub(fullText, 1, i)
        
        -- Efek getar dikit
        titleFrame.Position = titleFrame.Position + UDim2.new(0, math.random(-2,2), 0, math.random(-2,2))
        task.wait(0.05)
        titleFrame.Position = UDim2.new(0.5, -250, 0.5, -75)
        
        task.wait(0.1)
    end
    
    -- Kedip-kedip setelah selesai
    for i = 1, 5 do
        titleFrame.BackgroundTransparency = 0.5
        task.wait(0.1)
        titleFrame.BackgroundTransparency = 0.3
        task.wait(0.1)
    end
    
    -- Ilangin animasi
    task.wait(1)
    titleGui:Destroy()
end)

-- ==================================================
-- CREATE GUI UTAMA
-- ==================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZoneXD_Stepping"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true

-- MAIN FRAME
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 220)
mainFrame.Position = UDim2.new(0.5, -140, 0.1, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 15)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(0, 200, 255)
mainStroke.Thickness = 2
mainStroke.Parent = mainFrame

-- TITLE BAR
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
titleBar.BackgroundTransparency = 0.3
titleBar.Parent = mainFrame

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0, 15)
barCorner.Parent = titleBar

local titleLabel2 = Instance.new("TextLabel")
titleLabel2.Size = UDim2.new(0.6, 0, 1, 0)
titleLabel2.Position = UDim2.new(0.05, 0, 0, 0)
titleLabel2.BackgroundTransparency = 1
titleLabel2.Text = "🪜 STEPPING STONES"
titleLabel2.TextColor3 = Color3.fromRGB(0, 200, 255)
titleLabel2.TextScaled = true
titleLabel2.Font = Enum.Font.GothamBlack
titleLabel2.TextXAlignment = Enum.TextXAlignment.Left
titleLabel2.Parent = titleBar

-- MINIMIZE BUTTON
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 25, 0, 25)
minBtn.Position = UDim2.new(1, -60, 0, 7.5)
minBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
minBtn.Text = "🗕"
minBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
minBtn.TextScaled = true
minBtn.Font = Enum.Font.GothamBlack
minBtn.BorderSizePixel = 0
minBtn.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = minBtn

-- CLOSE BUTTON
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 7.5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBlack
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- ==================================================
-- KONTEN UTAMA
-- ==================================================
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -50)
contentFrame.Position = UDim2.new(0, 10, 0, 45)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- STATUS PANEL
local statusFrame = Instance.new("Frame")
statusFrame.Size = UDim2.new(1, 0, 0, 50)
statusFrame.Position = UDim2.new(0, 0, 0, 0)
statusFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
statusFrame.BackgroundTransparency = 0.3
statusFrame.Parent = contentFrame

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
toggleButton.Position = UDim2.new(0.1, 0, 0, 60)
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
toggleButton.Text = "🔴 HIDUPKAN"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBlack
toggleButton.BorderSizePixel = 0
toggleButton.Parent = contentFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 15)
toggleCorner.Parent = toggleButton

-- SETTINGS PANEL
local settingsFrame = Instance.new("Frame")
settingsFrame.Size = UDim2.new(1, 0, 0, 45)
settingsFrame.Position = UDim2.new(0, 0, 0, 115)
settingsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
settingsFrame.BackgroundTransparency = 0.3
settingsFrame.Parent = contentFrame

local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0, 10)
settingsCorner.Parent = settingsFrame

local durationLabel = Instance.new("TextLabel")
durationLabel.Size = UDim2.new(0.5, 0, 1, 0)
durationLabel.Position = UDim2.new(0.05, 0, 0, 0)
durationLabel.BackgroundTransparency = 1
durationLabel.Text = "DURASI:"
durationLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
durationLabel.TextScaled = true
durationLabel.Font = Enum.Font.GothamBold
durationLabel.Parent = settingsFrame

local durationValue = Instance.new("TextLabel")
durationValue.Size = UDim2.new(0.3, 0, 1, 0)
durationValue.Position = UDim2.new(0.55, 0, 0, 0)
durationValue.BackgroundTransparency = 1
durationValue.Text = settings.stepping.platformDuration .. "s"
durationValue.TextColor3 = Color3.fromRGB(0, 255, 255)
durationValue.TextScaled = true
durationValue.Font = Enum.Font.GothamBlack
durationValue.Parent = settingsFrame

-- INFO LABEL
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 20)
infoLabel.Position = UDim2.new(0, 0, 0, 170)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Loncat untuk memunculkan lantai"
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
infoLabel.TextScaled = true
infoLabel.Font = Enum.Font.Gotham
infoLabel.Parent = contentFrame

-- ==================================================
-- FUNGSI MINIMIZE
-- ==================================================
local function toggleMinimize()
    settings.gui.minimized = not settings.gui.minimized
    local targetSize = settings.gui.minimized and UDim2.new(0, 280, 0, 40) or UDim2.new(0, 280, 0, 220)
    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = targetSize})
    tween:Play()
    contentFrame.Visible = not settings.gui.minimized
    minBtn.Text = settings.gui.minimized and "🗖" or "🗕"
end

minBtn.MouseButton1Click:Connect(toggleMinimize)

-- ==================================================
-- STEPPING STONES SYSTEM
-- ==================================================
local platforms = {}

-- Fungsi bikin platform
local function spawnPlatform(position)
    if not settings.stepping.enabled then return end
    
    local platform = Instance.new("Part")
    platform.Size = settings.stepping.platformSize
    platform.Position = position - Vector3.new(0, 2.5, 0)
    platform.Anchored = true
    platform.CanCollide = true
    platform.Transparency = settings.stepping.platformTransparency
    platform.BrickColor = BrickColor.new("Cyan")
    platform.Material = Enum.Material.Glass
    platform.Parent = workspace
    
    -- Efek spawn
    spawn(function()
        for i = 1, 3 do
            platform.Transparency = platform.Transparency - 0.1
            task.wait(0.05)
        end
    end)
    
    -- Hapus setelah durasi
    task.delay(settings.stepping.platformDuration, function()
        -- Efek ilang
        for i = 1, 3 do
            platform.Transparency = platform.Transparency + 0.1
            task.wait(0.05)
        end
        platform:Destroy()
    end)
    
    table.insert(platforms, platform)
end

-- Fungsi loncat
local function doJump()
    if not settings.stepping.enabled then return end
    if not player.Character then return end
    
    local humanoid = player.Character:FindFirstChild("Humanoid")
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    
    if humanoid and root then
        -- Buat platform di posisi saat ini
        spawnPlatform(root.Position)
        
        -- Infinite jump
        if settings.stepping.infiniteJump then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end

-- Deteksi input jump
UserInputService.JumpRequest:Connect(function()
    doJump()
end)

-- Deteksi dari Jumping event
player.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.Jumping:Connect(doJump)
    end
end)

if player.Character then
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.Jumping:Connect(doJump)
    end
end

-- ==================================================
-- FUNGSI TOGGLE
-- ==================================================
local function toggleStepping()
    settings.stepping.enabled = not settings.stepping.enabled
    
    if settings.stepping.enabled then
        -- UBAH KE ON
        statusValue.Text = "🟢 ON"
        statusValue.TextColor3 = Color3.fromRGB(0, 255, 0)
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        toggleButton.Text = "🟢 MATIKAN"
        infoLabel.Text = "✅ Lantai muncul tiap loncat!"
    else
        -- UBAH KE OFF
        statusValue.Text = "🔴 OFF"
        statusValue.TextColor3 = Color3.fromRGB(255, 0, 0)
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        toggleButton.Text = "🔴 HIDUPKAN"
        infoLabel.Text = "⏸️ Stepping stones mati"
    end
end

-- Event tombol toggle
toggleButton.MouseButton1Click:Connect(toggleStepping)

-- Hover effect
toggleButton.MouseEnter:Connect(function()
    if settings.stepping.enabled then
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

toggleButton.MouseLeave:Connect(function()
    if settings.stepping.enabled then
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    else
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

-- ==================================================
-- NOTIFIKASI
-- ==================================================
print([[
╔══════════════════════════════════════════════╗
║   🔥 ZONE XD - STEPPING STONES PRO 🔥        ║
╠══════════════════════════════════════════════╣
║   ✅ ANIMASI TITLE (huruf per huruf)        ║
║   ✅ STEPPING STONES (lantai otomatis)       ║
║   ✅ INFINITE JUMP                           ║
║   ✅ TOMBOL ON/OFF + TABEL STATUS            ║
║   ✅ MINIMIZE BUTTON                          ║
╠══════════════════════════════════════════════╣
║   👑 COPYRIGHT: APIS 2026                    ║
╚══════════════════════════════════════════════╝
]])

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "ZONE XD - STEPPING STONES",
    Text = "Animasi title muncul! Tekan tombol buat ON",
    Duration = 4
})