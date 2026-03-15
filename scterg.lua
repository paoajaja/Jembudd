--[[
    🔥 ZONE XD - ANIME KNOCKOUT MEGA HACK 🔥
    COPYRIGHT: APIS (USER 01) - ZONE XD V1
    FITUR: ESP + INFINITE HEALTH + INFINITE SKILL + TELEPORT FARM
]]

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ==================================================
-- SETTINGS
-- ==================================================
local settings = {
    esp = {
        enabled = true,
        box = true,
        name = true,
        health = true,
        distance = true,
        tracer = true,
        boxColor = Color3.fromRGB(255, 0, 0),
        teamColor = false,
    },
    infinite = {
        health = true,
        skill = true,
    },
    teleport = {
        enabled = true,
        key = Enum.KeyCode.T,  -- Tekan T buat teleport ke player terdekat
        farmMode = true,        -- Auto teleport ke player terus
    }
}

-- ==================================================
-- INFINITE HEALTH (GOD MODE)
-- ==================================================
if settings.infinite.health then
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
        end
    end
    
    -- Loop buat jaga-jaga kalo health turun
    game:GetService("RunService").Heartbeat:Connect(function()
        local char = player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum and hum.Health < hum.MaxHealth then
                hum.Health = hum.MaxHealth
            end
        end
    end)
end

-- ==================================================
-- INFINITE SKILL (NO COOLDOWN)
-- ==================================================
if settings.infinite.skill then
    local mt = getrawmetatable(game)
    local old_namecall = mt.__namecall
    setreadonly(mt, false)
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        -- Block semua remote cooldown
        if method == "FireServer" and (tostring(self):match("Cooldown") or tostring(self):match("CD")) then
            return nil
        end
        
        return old_namecall(self, ...)
    end)
    
    setreadonly(mt, true)
end

-- ==================================================
-- ESP SYSTEM (BOX + NAMA + DARAH + JARAK + TRACER)
-- ==================================================
local espObjects = {}

local function createESP(plr)
    if espObjects[plr] then return end
    if not plr.Character then return end
    
    local esp = {
        box = Instance.new("BoxHandleAdornment"),
        nameTag = Instance.new("BillboardGui"),
        healthBar = Instance.new("BillboardGui"),
        distanceTag = Instance.new("BillboardGui"),
        tracer = Instance.new("Part")
    }
    
    -- BOX ESP
    esp.box.Name = "ESP_Box"
    esp.box.Adornee = plr.Character
    esp.box.Size = Vector3.new(4, 6, 1)
    esp.box.Color3 = settings.esp.boxColor
    esp.box.Transparency = 0.5
    esp.box.ZIndex = 10
    esp.box.AlwaysOnTop = true
    esp.box.Parent = plr.Character
    
    -- NAME TAG
    esp.nameTag = Instance.new("BillboardGui")
    esp.nameTag.Name = "ESP_Name"
    esp.nameTag.Adornee = plr.Character:FindFirstChild("Head")
    esp.nameTag.Size = UDim2.new(0, 150, 0, 30)
    esp.nameTag.StudsOffset = Vector3.new(0, 3, 0)
    esp.nameTag.AlwaysOnTop = true
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = plr.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = esp.nameTag
    
    esp.nameTag.Parent = plr.Character
    
    -- HEALTH BAR
    esp.healthBar = Instance.new("BillboardGui")
    esp.healthBar.Name = "ESP_Health"
    esp.healthBar.Adornee = plr.Character:FindFirstChild("Head")
    esp.healthBar.Size = UDim2.new(0, 80, 0, 8)
    esp.healthBar.StudsOffset = Vector3.new(0, 2, 0)
    esp.healthBar.AlwaysOnTop = true
    
    local healthFrame = Instance.new("Frame")
    healthFrame.Size = UDim2.new(1, 0, 1, 0)
    healthFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    healthFrame.BackgroundTransparency = 0.5
    healthFrame.Parent = esp.healthBar
    
    local healthFill = Instance.new("Frame")
    healthFill.Name = "HealthFill"
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthFrame
    
    esp.healthBar.Parent = plr.Character
    
    -- DISTANCE TAG
    esp.distanceTag = Instance.new("BillboardGui")
    esp.distanceTag.Name = "ESP_Distance"
    esp.distanceTag.Adornee = plr.Character:FindFirstChild("Head")
    esp.distanceTag.Size = UDim2.new(0, 100, 0, 20)
    esp.distanceTag.StudsOffset = Vector3.new(0, 1, 0)
    esp.distanceTag.AlwaysOnTop = true
    
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 1, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = "0m"
    distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    distanceLabel.TextStrokeTransparency = 0
    distanceLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    distanceLabel.TextScaled = true
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.Parent = esp.distanceTag
    
    esp.distanceTag.Parent = plr.Character
    
    -- TRACER PART
    esp.tracer.Name = "ESP_Tracer"
    esp.tracer.Anchored = true
    esp.tracer.CanCollide = false
    esp.tracer.Transparency = 0.5
    esp.tracer.BrickColor = BrickColor.new("Bright red")
    esp.tracer.Material = Enum.Material.Neon
    esp.tracer.Size = Vector3.new(0.1, 0.1, 1)
    esp.tracer.Parent = workspace
    
    espObjects[plr] = esp
end

local function updateESP()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") then
            -- Create ESP kalo belum ada
            if not espObjects[v] then
                createESP(v)
            end
            
            local esp = espObjects[v]
            if esp then
                -- Update health bar
                local humanoid = v.Character.Humanoid
                local healthPercent = humanoid.Health / humanoid.MaxHealth
                local healthFill = esp.healthBar:FindFirstChild("Frame"):FindFirstChild("HealthFill")
                if healthFill then
                    healthFill.Size = UDim2.new(healthPercent, 0, 1, 0)
                    healthFill.BackgroundColor3 = Color3.fromRGB(
                        255 * (1 - healthPercent),
                        255 * healthPercent,
                        0
                    )
                end
                
                -- Update distance
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (player.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                    local distLabel = esp.distanceTag:FindFirstChild("TextLabel")
                    if distLabel then
                        distLabel.Text = math.floor(dist) .. "m"
                    end
                end
                
                -- Update tracer (garis dari bawah layar ke player)
                if settings.esp.tracer then
                    local screenPos = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                    -- Gua tambahin nanti klo butuh tracer beneran
                end
            end
        end
    end
end

-- ==================================================
-- TELEPORT FARM SYSTEM
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

local function teleportToPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    
    player.Character.HumanoidRootPart.CFrame = targetRoot.CFrame * CFrame.new(0, 5, 5)  -- Teleport di sampingnya
end

-- Teleport manual (tekan T)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == settings.teleport.key then
        local target = getClosestPlayer()
        if target then
            teleportToPlayer(target)
            game.StarterGui:SetCore("SendNotification", {
                Title = "ZONE XD",
                Text = "Teleport ke " .. target.Name,
                Duration = 1
            })
        end
    end
end)

-- Auto teleport farm mode
if settings.teleport.farmMode then
    spawn(function()
        while true do
            task.wait(3)  -- Teleport tiap 3 detik
            local target = getClosestPlayer()
            if target then
                teleportToPlayer(target)
            end
        end
    end)
end

-- ==================================================
-- AUTO ATTACK (SETELAH TELEPORT)
-- ==================================================
local attackRemote = nil
for _, v in pairs(ReplicatedStorage:GetDescendants()) do
    if v:IsA("RemoteEvent") and (v.Name:match("Attack") or v.Name:match("Damage") or v.Name:match("Hit")) then
        attackRemote = v
        break
    end
end

if attackRemote then
    spawn(function()
        while true do
            task.wait(0.3)
            local target = getClosestPlayer()
            if target and target.Character then
                attackRemote:FireServer(target.Character.HumanoidRootPart)
            end
        end
    end)
end

-- ==================================================
-- MAIN LOOP
-- ==================================================
RunService.RenderStepped:Connect(function()
    if settings.esp.enabled then
        updateESP()
    end
end)

-- ==================================================
-- CREATE SIMPLE GUI
-- ==================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZoneXDHack"
screenGui.Parent = player.PlayerGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 100)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚡ ZONE XD HACK"
titleLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.Parent = mainFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 0, 35)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "✅ ESP | 💪 INF | 📍 TP"
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 20)
infoLabel.Position = UDim2.new(0, 0, 0, 60)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Tekan T untuk teleport"
infoLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
infoLabel.TextScaled = true
infoLabel.Font = Enum.Font.Gotham
infoLabel.Parent = mainFrame

-- ==================================================
-- INIT
-- ==================================================
print([[
╔══════════════════════════════════════════════╗
║   🔥 ZONE XD - ANIME KNOCKOUT MEGA 🔥       ║
╠══════════════════════════════════════════════╣
║   ✅ ESP LENGKAP (Box, Nama, Darah, Jarak)  ║
║   ✅ INFINITE HEALTH (God Mode)              ║
║   ✅ INFINITE SKILL (No Cooldown)            ║
║   ✅ TELEPORT FARM (Tekan T)                  ║
╠══════════════════════════════════════════════╣
║   👑 COPYRIGHT: APIS - ZONE XD V1            ║
╚══════════════════════════════════════════════╝
]])