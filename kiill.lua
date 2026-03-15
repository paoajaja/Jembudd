--[[
    🔥 ZONE XD - LOOP KILL (DENGAN TOGGLE) 🔥
    COPYRIGHT: APIS 2026
    FITUR: Kill semua player tiap 0.5 detik + Bisa ON/OFF
]]

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- ==================================================
-- SETTINGS
-- ==================================================
local settings = {
    loopKill = {
        enabled = false,  -- MULAI DALAM KEADAAN MATI
        interval = 0.5,    -- Kill tiap 0.5 detik
        fakeMode = true,   -- TRUE = universal, FALSE = pake remote (kalo tau)
    },
    gui = {
        minimized = false,
    }
}

-- ==================================================
-- CREATE GUI
-- ==================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZoneXD_LoopKill"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true

-- MAIN FRAME
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 180)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -90)
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
mainStroke.Color = Color3.fromRGB(255, 0, 0)
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

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0.6, 0, 1, 0)
titleLabel.Position = UDim2.new(0.05, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "💀 LOOP KILL"
titleLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

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
toggleButton.Text = "🔴 MATIKAN"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBlack
toggleButton.BorderSizePixel = 0
toggleButton.Parent = contentFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 15)
toggleCorner.Parent = toggleButton

-- INFO LABEL
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 25)
infoLabel.Position = UDim2.new(0, 0, 0, 115)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Kill semua player tiap 0.5 detik"
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
infoLabel.TextScaled = true
infoLabel.Font = Enum.Font.Gotham
infoLabel.Parent = contentFrame

-- ==================================================
-- FUNGSI MINIMIZE
-- ==================================================
local function toggleMinimize()
    settings.gui.minimized = not settings.gui.minimized
    local targetSize = settings.gui.minimized and UDim2.new(0, 250, 0, 40) or UDim2.new(0, 250, 0, 180)
    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = targetSize})
    tween:Play()
    contentFrame.Visible = not settings.gui.minimized
    minBtn.Text = settings.gui.minimized and "🗖" or "🗕"
end

minBtn.MouseButton1Click:Connect(toggleMinimize)

-- ==================================================
-- LOOP KILL SYSTEM
-- ==================================================

-- Fungsi kill semua player
local function killAllPlayers()
    if not settings.loopKill.enabled then return end
    
    for _, target in pairs(game.Players:GetPlayers()) do
        if target ~= player and target.Character then
            local humanoid = target.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                -- FAKE KILL (universal - cuma efek client)
                if settings.loopKill.fakeMode then
                    humanoid.Health = 0
                else
                    -- MODE REAL (kalo tau remote)
                    -- Lu bisa isi remote kalo udah tau
                end
            end
        end
    end
end

-- Loop kill (jalan terus tapi cuma ngekill kalo enabled = true)
spawn(function()
    while true do
        task.wait(settings.loopKill.interval)
        killAllPlayers()
    end
end)

-- ==================================================
-- FUNGSI TOGGLE
-- ==================================================
local function toggleLoopKill()
    settings.loopKill.enabled = not settings.loopKill.enabled
    
    if settings.loopKill.enabled then
        -- UBAH KE ON
        statusValue.Text = "🟢 ON"
        statusValue.TextColor3 = Color3.fromRGB(0, 255, 0)
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        toggleButton.Text = "🟢 MATIKAN"
        infoLabel.Text = "✅ LOOP KILL AKTIF - Semua player mati"
    else
        -- UBAH KE OFF
        statusValue.Text = "🔴 OFF"
        statusValue.TextColor3 = Color3.fromRGB(255, 0, 0)
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        toggleButton.Text = "🔴 HIDUPKAN"
        infoLabel.Text = "⏸️ LOOP KILL MATI - Tekan tombol buat hidupkan"
    end
end

-- Event tombol toggle
toggleButton.MouseButton1Click:Connect(toggleLoopKill)

-- Hover effect
toggleButton.MouseEnter:Connect(function()
    if settings.loopKill.enabled then
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

toggleButton.MouseLeave:Connect(function()
    if settings.loopKill.enabled then
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    else
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

-- ==================================================
-- NOTIFIKASI
-- ==================================================
print([[
╔════════════════════════════════════╗
║   🔥 ZONE XD - LOOP KILL 🔥        ║
╠════════════════════════════════════╣
║   ✅ FAKE KILL MODE (universal)    ║
║   ✅ TOMBOL ON/OFF (toggle)        ║
║   ✅ STATUS ON/OFF di GUI          ║
║   ✅ MINIMIZE BUTTON                ║
╠════════════════════════════════════╣
║   👑 COPYRIGHT: APIS 2026           ║
╚════════════════════════════════════╝
]])

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "ZONE XD - LOOP KILL",
    Text = "Tekan tombol buat ON/OFF loop kill!",
    Duration = 4
})