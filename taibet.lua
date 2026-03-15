--[[
    🔥 ZONE XD - ESP + TELEPORT (FIX MUNCUL) 🔥
    COPYRIGHT: APIS 2026
    FITUR: ESP Nama + Darah + Teleport Tekan T
]]

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ==================================================
-- CREATE GUI (SUPAYA KELIATAN KALO SCRIPT JALAN)
-- ==================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZoneXD_ESP"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local statusFrame = Instance.new("Frame")
statusFrame.Size = UDim2.new(0, 200, 0, 80)
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
titleLabel.Text = "⚡ ZONE XD AKTIF"
titleLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.Parent = statusFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 0, 35)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "✅ ESP | ✅ TELEPORT (T)"
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = statusFrame

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 20)
infoLabel.Position = UDim2.new(0, 0, 0, 55)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Tekan T untuk teleport"
infoLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
infoLabel.TextScaled = true
infoLabel.Font = Enum.Font.Gotham
infoLabel.Parent = statusFrame

-- ==================================================
-- ESP SYSTEM (NAMA + DARAH)
-- ==================================================
local espHolder = {}

local function createESP(plr)
    if espHolder[plr] then return end
    if not plr.Character then return end
    
    -- Tunggu bentar biar character ke-load
    task.wait(0.5)
    
    local head = plr.Character:FindFirstChild("Head")
    local humanoid = plr.Character:FindFirstChild("Humanoid")
    
    if not head or not humanoid then return end
    
    -- MAIN BILLBOARD GUI (buat wadah)
    local mainGui = Instance.new("BillboardGui")
    mainGui.Name = "ZoneXD_ESP_" .. plr.Name
    mainGui.Adornee = head
    mainGui.Size = UDim2.new(0, 200, 0, 80)
    mainGui.StudsOffset = Vector3.new(0, 3, 0)
    mainGui.AlwaysOnTop = true
    mainGui.Parent = plr.Character
    
    -- NAME LABEL
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 30)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
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
    healthBg.Size = UDim2.new(0.9, 0, 0, 15)
    healthBg.Position = UDim2.new(0.05, 0, 0, 35)
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
    healthText.Position = UDim2.new(0, 0, 0, 55)
    healthText.BackgroundTransparency = 1
    healthText.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
    healthText.TextColor3 = Color3.fromRGB(255, 255, 255)
    healthText.TextScaled = true
    healthText.Font = Enum.Font.Gotham
    healthText.Parent = mainGui
    
    -- Simpan data ESP
    espHolder[plr] = {
        main = mainGui,
        healthFill = healthFill,
        healthText = healthText,
        humanoid = humanoid
    }
end

-- Update ESP tiap frame
RunService.RenderStepped:Connect(function()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player then
            -- Buat ESP kalo belum ada
            if not espHolder[v] and v.Character then
                createESP(v)
            end
            
            -- Update health bar
            if espHolder[v] and v.Character and v.Character:FindFirstChild("Humanoid") then
                local data = espHolder[v]
                local hum = v.Character.Humanoid
                local healthPercent = hum.Health / hum.MaxHealth
                
                if data.healthFill then
                    data.healthFill.Size = UDim2.new(healthPercent, 0, 1, 0)
                    
                    -- Warna berubah sesuai health
                    if healthPercent > 0.6 then
                        data.healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)  -- Hijau
                    elseif healthPercent > 0.3 then
                        data.healthFill.BackgroundColor3 = Color3.fromRGB(255, 255, 0)  -- Kuning
                    else
                        data.healthFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- Merah
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
-- TELEPORT SYSTEM (TEKAN T)
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
    
    -- Teleport di samping target
    player.Character.HumanoidRootPart.CFrame = targetRoot.CFrame * CFrame.new(0, 5, 5)
    
    -- Notifikasi di GUI
    statusLabel.Text = "✅ TELEPORT KE " .. target.Name
    task.wait(2)
    statusLabel.Text = "✅ ESP | ✅ TELEPORT (T)"
end

-- Event pencet T
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.T then
        local target = getClosestPlayer()
        if target then
            teleportToTarget(target)
        else
            statusLabel.Text = "❌ GAK ADA PLAYER LAIN"
            task.wait(2)
            statusLabel.Text = "✅ ESP | ✅ TELEPORT (T)"
        end
    end
end)

-- ==================================================
-- VERIFIKASI SCRIPT JALAN
-- ==================================================
print("🔥 ZONE XD - ESP + TELEPORT BERHASIL LOAD!")
print("✅ Tekan T untuk teleport ke player terdekat")
print("✅ ESP Nama & Darah aktif untuk semua player")

-- Notifikasi di game
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "ZONE XD",
    Text = "ESP + TELEPORT AKTIF! Tekan T untuk teleport",
    Duration = 5
})