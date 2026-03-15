--[[
    🔥 ZONE XD - HP VERSION (TOMBOL T DI LAYAR) 🔥
    COPYRIGHT: APIS 2026
    FITUR: ESP + Teleport pake tombol layar
]]

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ==================================================
-- CREATE GUI UTAMA
-- ==================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZoneXD_HP"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- STATUS PANEL (POJOK KIRI ATAS)
local statusFrame = Instance.new("Frame")
statusFrame.Size = UDim2.new(0, 180, 0, 70)
statusFrame.Position = UDim2.new(0, 10, 0, 10)
statusFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
statusFrame.BackgroundTransparency = 0.3
statusFrame.BorderSizePixel = 0
statusFrame.Parent = screenGui
statusFrame.Active = true
statusFrame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = statusFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 25)
titleLabel.Position = UDim2.new(0, 0, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚡ ZONE XD HP"
titleLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.Parent = statusFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 0, 35)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "✅ ESP AKTIF"
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
titleLabel.Parent = statusFrame

-- ==================================================
-- TOMBOL T BESAR DI LAYAR (BUAT HP)
-- ==================================================
local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(0, 80, 0, 80)
teleportButton.Position = UDim2.new(0.5, -40, 0.8, -40)  -- Tengah bawah
teleportButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
teleportButton.Text = "T"
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.TextScaled = true
teleportButton.Font = Enum.Font.GothamBlack
teleportButton.BorderSizePixel = 0
teleportButton.Parent = screenGui

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 40)  -- Bikin bulat
buttonCorner.Parent = teleportButton

local buttonStroke = Instance.new("UIStroke")
buttonStroke.Color = Color3.fromRGB(255, 255, 255)
buttonStroke.Thickness = 3
buttonStroke.Parent = teleportButton

-- LABEL DI BAWAH TOMBOL
local buttonLabel = Instance.new("TextLabel")
buttonLabel.Size = UDim2.new(0, 100, 0, 20)
buttonLabel.Position = UDim2.new(0.5, -50, 0.8, 45)
buttonLabel.BackgroundTransparency = 1
buttonLabel.Text = "TELEPORT"
buttonLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
buttonLabel.TextScaled = true
buttonLabel.Font = Enum.Font.GothamBold
buttonLabel.Parent = screenGui

-- ==================================================
-- ESP SYSTEM (NAMA + DARAH)
-- ==================================================
local espHolder = {}

local function createESP(plr)
    if espHolder[plr] then return end
    if not plr.Character then return end
    
    task.wait(0.5)
    
    local head = plr.Character:FindFirstChild("Head")
    local humanoid = plr.Character:FindFirstChild("Humanoid")
    
    if not head or not humanoid then return end
    
    -- BILLBOARD GUI
    local mainGui = Instance.new("BillboardGui")
    mainGui.Name = "ZoneXD_ESP_" .. plr.Name
    mainGui.Adornee = head
    mainGui.Size = UDim2.new(0, 200, 0, 70)
    mainGui.StudsOffset = Vector3.new(0, 3, 0)
    mainGui.AlwaysOnTop = true
    mainGui.Parent = plr.Character
    
    -- NAME
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 25)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = plr.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = mainGui
    
    -- HEALTH BAR BACKGROUND
    local healthBg = Instance.new("Frame")
    healthBg.Size = UDim2.new(0.9, 0, 0, 10)
    healthBg.Position = UDim2.new(0.05, 0, 0, 30)
    healthBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    healthBg.BorderSizePixel = 0
    healthBg.Parent = mainGui
    
    -- HEALTH BAR FILL
    local healthFill = Instance.new("Frame")
    healthFill.Name = "HealthFill"
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthBg
    
    -- HEALTH TEXT
    local healthText = Instance.new("TextLabel")
    healthText.Size = UDim2.new(1, 0, 0, 20)
    healthText.Position = UDim2.new(0, 0, 0, 45)
    healthText.BackgroundTransparency = 1
    healthText.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
    healthText.TextColor3 = Color3.fromRGB(255, 255, 255)
    healthText.TextScaled = true
    healthText.Font = Enum.Font.Gotham
    healthText.Parent = mainGui
    
    espHolder[plr] = {
        main = mainGui,
        healthFill = healthFill,
        healthText = healthText,
        humanoid = humanoid
    }
end

-- Update ESP
RunService.RenderStepped:Connect(function()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player then
            if not espHolder[v] and v.Character then
                createESP(v)
            end
            
            if espHolder[v] and v.Character and v.Character:FindFirstChild("Humanoid") then
                local data = espHolder[v]
                local hum = v.Character.Humanoid
                local healthPercent = hum.Health / hum.MaxHealth
                
                if data.healthFill then
                    data.healthFill.Size = UDim2.new(healthPercent, 0, 1, 0)
                    
                    if healthPercent > 0.6 then
                        data.healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                    elseif healthPercent > 0.3 then
                        data.healthFill.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
                    else
                        data.healthFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                    end
                end
                
                if data.healthText then
                    data.healthText.Text = math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth)
                end
            end
        end
    end
end)

-- ==================================================
-- TELEPORT FUNCTION
-- ==================================================
local function getClosestPlayer()
    local closest = nil
    local shortest = math.huge
    
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
            if dist < shortest then
                shortest = dist
                closest = v
            end
        end
    end
    return closest
end

local function teleportToTarget(target)
    if not target or not target.Character then return end
    
    local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    
    player.Character.HumanoidRootPart.CFrame = targetRoot.CFrame * CFrame.new(0, 5, 5)
    
    -- Efek kedip pas teleport
    teleportButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    task.wait(0.2)
    teleportButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    
    statusLabel.Text = "➡️ KE " .. target.Name
    task.wait(2)
    statusLabel.Text = "✅ ESP AKTIF"
end

-- EVENT TOMBOL T (DI LAYAR)
teleportButton.MouseButton1Click:Connect(function()
    local target = getClosestPlayer()
    if target then
        teleportToTarget(target)
    else
        statusLabel.Text = "❌ GAK ADA PLAYER"
        task.wait(2)
        statusLabel.Text = "✅ ESP AKTIF"
    end
end)

-- ==================================================
-- VERIFIKASI
-- ==================================================
print("🔥 ZONE XD HP - BERHASIL LOAD!")
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "ZONE XD HP",
    Text = "Tekan tombol T di layar buat teleport!",
    Duration = 5
})