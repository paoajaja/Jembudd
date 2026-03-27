--[[
    ZONE XD MOBILE V5 ULTIMATE
    LIMIT SPEED 200 | JUMP 200
    ESP PRO + INVISIBLE + PROFILE
    ALL FITUR FIX
    CREATED BY: APIS
--]]

-- ==================== INITIALIZATION ====================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")
local TextService = game:GetService("TextChatService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

-- SETTINGS DENGAN LIMIT BARU
local Settings = {
    Speed = 16,
    JumpPower = 50,
    FlySpeed = 100,
    Flying = false,
    NoClip = false,
    GodMode = false,
    InfiniteJump = false,
    AutoClick = false,
    ESP = false,
    Aimbot = false,
    Invisible = false,
    SpeedEnabled = true,
    JumpEnabled = true,
    ClickDelay = 0.1,
    -- FITUR BARU
    TeleportEnabled = false,
    AutoFarm = false,
    AutoCollect = false,
    TeamESP = false,
    SilentAim = false,
    AntiStun = false,
    AutoHeal = false,
    WalkOnWater = false,
    NoFallDamage = false,
    -- FITUR INVISIBLE
    InvisibleMode = false,
    OriginalTransparency = {}
}

-- LIMIT BARU (DITINGKATIN)
local MAX_SPEED = 200
local MAX_JUMP = 200
local MAX_FLY_SPEED = 150

-- Original Values
local OriginalSpeed = 16
local OriginalJump = 50

-- Fly Variables
local FlyingActive = false
local FlyBodyVelocity = nil
local FlyBodyGyro = nil
local FlyControls = {
    Forward = false,
    Backward = false,
    Left = false,
    Right = false,
    Up = false,
    Down = false
}

-- ESP Variables
local ESPGui = nil
local ESPFrames = {}

-- Connections
local AutoClickConnection = nil
local AimbotConnection = nil
local InfiniteJumpConnection = nil
local AutoFarmConnection = nil
local AutoCollectConnection = nil
local AntiStunConnection = nil
local AutoHealConnection = nil
local NoFallDamageConnection = nil
local WalkOnWaterConnection = nil
local InvisibleConnection = nil

-- Touch Fly Controls
local TouchJoystick = nil

-- Teleport History
local TeleportHistory = {}
local TeleportIndex = 0

-- User Profile
local UserProfile = {
    Username = LocalPlayer.Name,
    DisplayName = LocalPlayer.DisplayName,
    UserId = LocalPlayer.UserId,
    Team = nil,
    AccountAge = nil,
    JoinDate = nil
}

-- ==================== UTILITY FUNCTIONS ====================

local function SendAutoReply(msg)
    pcall(function()
        if TextService and TextService.TextChannels then
            for _, channel in pairs(TextService.TextChannels:GetChildren()) do
                if channel:IsA("TextChannel") then
                    channel:SendAsync(msg)
                    break
                end
            end
        end
    end)
    print("[ZONE XD] " .. msg)
end

local function Notify(title, text, duration)
    duration = duration or 3
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "ZONE XD",
            Text = text or "",
            Duration = duration,
            Icon = "rbxassetid://4483345998"
        })
    end)
end

local function GetHumanoid()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        return LocalPlayer.Character.Humanoid
    end
    return nil
end

local function GetRootPart()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return LocalPlayer.Character.HumanoidRootPart
    end
    return nil
end

-- ==================== PROFILE SYSTEM ====================
local function ShowProfile()
    -- Update profile info
    UserProfile.Username = LocalPlayer.Name
    UserProfile.DisplayName = LocalPlayer.DisplayName
    UserProfile.UserId = LocalPlayer.UserId
    UserProfile.Team = LocalPlayer.Team and LocalPlayer.Team.Name or "No Team"
    
    -- Get account age (estimated)
    local accountAge = "Unknown"
    pcall(function()
        local accountAgeDays = os.time() - LocalPlayer.AccountAge
        accountAge = math.floor(accountAgeDays / 86400) .. " days"
    end)
    UserProfile.AccountAge = accountAge
    
    -- Status fitur aktif
    local activeFeatures = {}
    if Settings.Speed ~= 16 then table.insert(activeFeatures, "⚡ Speed: " .. Settings.Speed) end
    if Settings.JumpPower ~= 50 then table.insert(activeFeatures, "🦘 Jump: " .. Settings.JumpPower) end
    if Settings.Flying then table.insert(activeFeatures, "🕊️ Fly") end
    if Settings.NoClip then table.insert(activeFeatures, "🔓 NoClip") end
    if Settings.GodMode then table.insert(activeFeatures, "🛡️ GodMode") end
    if Settings.InfiniteJump then table.insert(activeFeatures, "♾️ InfJump") end
    if Settings.ESP then table.insert(activeFeatures, "👁️ ESP") end
    if Settings.InvisibleMode then table.insert(activeFeatures, "👻 Invisible") end
    if Settings.AutoFarm then table.insert(activeFeatures, "🌾 AutoFarm") end
    
    local activeText = #activeFeatures > 0 and table.concat(activeFeatures, " | ") or "Tidak ada"
    
    -- Send profile to chat
    SendAutoReply("/me ╔════════════════════════════════════════════════╗")
    wait(0.15)
    SendAutoReply("/me ║           👤 ZONE XD USER PROFILE 👤           ║")
    wait(0.15)
    SendAutoReply("/me ╠════════════════════════════════════════════════╣")
    wait(0.15)
    SendAutoReply("/me ║ 📛 Username   : " .. UserProfile.Username)
    wait(0.15)
    SendAutoReply("/me ║ 🏷️ Display    : " .. UserProfile.DisplayName)
    wait(0.15)
    SendAutoReply("/me ║ 🔢 User ID    : " .. UserProfile.UserId)
    wait(0.15)
    SendAutoReply("/me ║ 👥 Team       : " .. UserProfile.Team)
    wait(0.15)
    SendAutoReply("/me ║ 📅 Account    : " .. UserProfile.AccountAge)
    wait(0.15)
    SendAutoReply("/me ╠════════════════════════════════════════════════╣")
    wait(0.15)
    SendAutoReply("/me ║ ⚙️ ACTIVE FEATURES:                           ║")
    wait(0.15)
    SendAutoReply("/me ║ " .. activeText)
    wait(0.15)
    SendAutoReply("/me ╠════════════════════════════════════════════════╣")
    wait(0.15)
    SendAutoReply("/me ║ 💀 ZONE XD V5 ULTIMATE 💀                      ║")
    wait(0.15)
    SendAutoReply("/me ║ CREATED BY: APIS                               ║")
    wait(0.15)
    SendAutoReply("/me ╚════════════════════════════════════════════════╝")
    
    Notify("👤 PROFILE", UserProfile.Username .. " | " .. (#activeFeatures) .. " fitur aktif", 4)
end

-- ==================== INVISIBLE SYSTEM ====================
local function ToggleInvisible()
    Settings.InvisibleMode = not Settings.InvisibleMode
    
    local char = LocalPlayer.Character
    if not char then
        SendAutoReply("/me ❌ GAGAL! Character tidak ditemukan ❌")
        return
    end
    
    if Settings.InvisibleMode then
        -- Simpan original transparency dan set invisible
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                Settings.OriginalTransparency[part] = part.Transparency
                part.Transparency = 1
            elseif part:IsA("MeshPart") then
                Settings.OriginalTransparency[part] = part.Transparency
                part.Transparency = 1
            end
        end
        -- Bikin humanoid invisible juga
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            for _, part in pairs(humanoid:GetDescendants()) do
                if part:IsA("Part") or part:IsA("MeshPart") then
                    Settings.OriginalTransparency[part] = part.Transparency
                    part.Transparency = 1
                end
            end
        end
        SendAutoReply("/me 👻 INVISIBLE MODE AKTIF! Ga keliatan player lain 👻")
        Notify("👻 INVISIBLE", "Kamu sekarang tidak terlihat!", 3)
    else
        -- Restore original transparency
        for part, trans in pairs(Settings.OriginalTransparency) do
            pcall(function() part.Transparency = trans end)
        end
        Settings.OriginalTransparency = {}
        SendAutoReply("/me 👁️ INVISIBLE MODE NONAKTIF 👁️")
        Notify("👁️ INVISIBLE", "Mode invisible dimatikan", 2)
    end
end

-- Auto refresh invisible (kalo character respawn)
LocalPlayer.CharacterAdded:Connect(function(char)
    if Settings.InvisibleMode then
        wait(0.5)
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("MeshPart") then
                part.Transparency = 1
            end
        end
    end
end)

-- ==================== SPEED & JUMP (LIMIT 200) ====================
local function SetSpeed(value)
    value = tonumber(value)
    if not value then
        SendAutoReply("/me ⚠️ FORMAT SALAH! Ketik /speed [1-200] ⚠️")
        return
    end
    if value > MAX_SPEED then
        SendAutoReply("/me ⛔ LIMIT! Speed max " .. MAX_SPEED .. " ⛔")
        value = MAX_SPEED
    end
    if value < 10 then value = 10 end
    Settings.Speed = value
    local humanoid = GetHumanoid()
    if humanoid then
        humanoid.WalkSpeed = value
        SendAutoReply("/me ⚡ SPEED SET KE: " .. value .. " ⚡")
        Notify("⚡ SPEED", "Kecepatan: " .. value, 2)
    end
end

local function SetJump(value)
    value = tonumber(value)
    if not value then
        SendAutoReply("/me ⚠️ FORMAT SALAH! Ketik /jump [30-200] ⚠️")
        return
    end
    if value > MAX_JUMP then
        SendAutoReply("/me ⛔ LIMIT! Jump max " .. MAX_JUMP .. " ⛔")
        value = MAX_JUMP
    end
    if value < 30 then value = 30 end
    Settings.JumpPower = value
    local humanoid = GetHumanoid()
    if humanoid then
        humanoid.JumpPower = value
        SendAutoReply("/me 🦘 JUMP SET KE: " .. value .. " 🦘")
        Notify("🦘 JUMP", "Lompatan: " .. value, 2)
    end
end

-- ==================== FLY SYSTEM (FIXED) ====================
local function StopFly()
    if FlyBodyVelocity then 
        pcall(function() FlyBodyVelocity:Destroy() end)
        FlyBodyVelocity = nil
    end
    if FlyBodyGyro then 
        pcall(function() FlyBodyGyro:Destroy() end)
        FlyBodyGyro = nil
    end
    
    local humanoid = GetHumanoid()
    if humanoid then
        humanoid.PlatformStand = false
    end
    
    if not Settings.NoClip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = true
            end
        end
    end
    
    FlyingActive = false
    
    if TouchJoystick then 
        pcall(function() TouchJoystick:Destroy() end)
        TouchJoystick = nil
    end
    
    SendAutoReply("/me 🕊️ FLY MODE NONAKTIF 🕊️")
    Notify("🕊️ FLY", "Mode terbang dimatikan", 2)
end

local function StartFly()
    if FlyingActive then
        StopFly()
        return
    end
    
    local char = LocalPlayer.Character
    if not char then
        SendAutoReply("/me ❌ GAGAL! Tunggu character spawn ❌")
        return
    end
    
    local humanoid = GetHumanoid()
    local rootPart = GetRootPart()
    
    if not humanoid or not rootPart then
        SendAutoReply("/me ❌ GAGAL! Humanoid/RootPart tidak ditemukan ❌")
        return
    end
    
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end
    
    humanoid.PlatformStand = true
    
    FlyBodyVelocity = Instance.new("BodyVelocity")
    FlyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    FlyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    FlyBodyVelocity.Parent = rootPart
    
    FlyBodyGyro = Instance.new("BodyGyro")
    FlyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    FlyBodyGyro.CFrame = rootPart.CFrame
    FlyBodyGyro.Parent = rootPart
    
    FlyingActive = true
    
    FlyControls.Forward = false
    FlyControls.Backward = false
    FlyControls.Left = false
    FlyControls.Right = false
    FlyControls.Up = false
    FlyControls.Down = false
    
    CreateTouchJoystick()
    
    SendAutoReply("/me 🕊️ FLY MODE AKTIF! Speed max " .. MAX_FLY_SPEED .. " 🕊️")
    Notify("🕊️ FLY", "Mode terbang aktif!", 3)
end

-- Joystick untuk HP
local function CreateTouchJoystick()
    if TouchJoystick then pcall(function() TouchJoystick:Destroy() end) end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ZoneXDFlyJoystick"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local JoystickBg = Instance.new("Frame")
    JoystickBg.Size = UDim2.new(0, 140, 0, 140)
    JoystickBg.Position = UDim2.new(0, 15, 1, -160)
    JoystickBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    JoystickBg.BackgroundTransparency = 0.5
    JoystickBg.BorderSizePixel = 2
    JoystickBg.BorderColor3 = Color3.fromRGB(255, 100, 0)
    JoystickBg.BorderRadius = UDim.new(1, 70)
    JoystickBg.Parent = ScreenGui
    
    local Joystick = Instance.new("Frame")
    Joystick.Size = UDim2.new(0, 60, 0, 60)
    Joystick.Position = UDim2.new(0.5, -30, 0.5, -30)
    Joystick.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
    Joystick.BackgroundTransparency = 0.3
    Joystick.BorderSizePixel = 0
    Joystick.BorderRadius = UDim.new(1, 30)
    Joystick.Parent = JoystickBg
    
    local Hint = Instance.new("TextLabel")
    Hint.Size = UDim2.new(0, 140, 0, 25)
    Hint.Position = UDim2.new(0, 0, 1, 5)
    Hint.BackgroundTransparency = 1
    Hint.Text = "🕊️ GESER UNTUK TERBANG"
    Hint.TextColor3 = Color3.fromRGB(255, 255, 255)
    Hint.TextSize = 12
    Hint.TextScaled = true
    Hint.Parent = JoystickBg
    
    local StopButton = Instance.new("TextButton")
    StopButton.Size = UDim2.new(0, 75, 0, 75)
    StopButton.Position = UDim2.new(1, -90, 0, 15)
    StopButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    StopButton.BackgroundTransparency = 0.3
    StopButton.BorderSizePixel = 2
    StopButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
    StopButton.BorderRadius = UDim.new(1, 37.5)
    StopButton.Text = "🛑"
    StopButton.TextSize = 35
    StopButton.Parent = ScreenGui
    
    StopButton.MouseButton1Click:Connect(function()
        StopFly()
    end)
    
    local UpButton = Instance.new("TextButton")
    UpButton.Size = UDim2.new(0, 80, 0, 80)
    UpButton.Position = UDim2.new(1, -95, 0.5, -90)
    UpButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    UpButton.BackgroundTransparency = 0.3
    UpButton.BorderSizePixel = 2
    UpButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
    UpButton.BorderRadius = UDim.new(1, 40)
    UpButton.Text = "⬆️"
    UpButton.TextSize = 40
    UpButton.Parent = ScreenGui
    
    local DownButton = Instance.new("TextButton")
    DownButton.Size = UDim2.new(0, 80, 0, 80)
    DownButton.Position = UDim2.new(1, -95, 0.85, -40)
    DownButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    DownButton.BackgroundTransparency = 0.3
    DownButton.BorderSizePixel = 2
    DownButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
    DownButton.BorderRadius = UDim.new(1, 40)
    DownButton.Text = "⬇️"
    DownButton.TextSize = 40
    DownButton.Parent = ScreenGui
    
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    JoystickBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Joystick.Position
        end
    end)
    
    JoystickBg.InputEnded:Connect(function()
        dragging = false
        TweenService:Create(Joystick, TweenInfo.new(0.2), {Position = UDim2.new(0.5, -30, 0.5, -30)}):Play()
        FlyControls.Forward = false
        FlyControls.Backward = false
        FlyControls.Left = false
        FlyControls.Right = false
    end)
    
    JoystickBg.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            local newX = math.clamp(startPos.X.Offset + delta.X, -70, 70)
            local newY = math.clamp(startPos.Y.Offset + delta.Y, -70, 70)
            Joystick.Position = UDim2.new(0.5, newX, 0.5, newY)
            
            local normX = newX / 70
            local normY = newY / 70
            
            FlyControls.Forward = normY < -0.3
            FlyControls.Backward = normY > 0.3
            FlyControls.Left = normX < -0.3
            FlyControls.Right = normX > 0.3
        end
    end)
    
    UpButton.MouseButton1Down:Connect(function()
        FlyControls.Up = true
    end)
    UpButton.MouseButton1Up:Connect(function()
        FlyControls.Up = false
    end)
    
    DownButton.MouseButton1Down:Connect(function()
        FlyControls.Down = true
    end)
    DownButton.MouseButton1Up:Connect(function()
        FlyControls.Down = false
    end)
    
    TouchJoystick = ScreenGui
end

-- Fly movement
RunService.RenderStepped:Connect(function()
    if not FlyingActive or not FlyBodyVelocity then return end
    
    local rootPart = GetRootPart()
    if not rootPart then return end
    
    local moveDirection = Vector3.new(0, 0, 0)
    
    if FlyControls.Forward then moveDirection = moveDirection + rootPart.CFrame.LookVector end
    if FlyControls.Backward then moveDirection = moveDirection - rootPart.CFrame.LookVector end
    if FlyControls.Right then moveDirection = moveDirection + rootPart.CFrame.RightVector end
    if FlyControls.Left then moveDirection = moveDirection - rootPart.CFrame.RightVector end
    if FlyControls.Up then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
    if FlyControls.Down then moveDirection = moveDirection - Vector3.new(0, 1, 0) end
    
    FlyBodyVelocity.Velocity = moveDirection * MAX_FLY_SPEED
    if FlyBodyGyro then FlyBodyGyro.CFrame = rootPart.CFrame end
end)

-- ==================== ESP PRO ====================
local function CreateESPPro()
    if ESPGui then pcall(function() ESPGui:Destroy() end) end
    
    ESPGui = Instance.new("ScreenGui")
    ESPGui.Name = "ZoneXD_ESP_Pro"
    ESPGui.Parent = game.CoreGui
    
    local myTeam = LocalPlayer.Team
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 80, 0, 80)
            frame.BackgroundTransparency = 0.4
            frame.BorderSizePixel = 3
            frame.Parent = ESPGui
            
            -- Warna berdasarkan team dan jarak
            if player.Team == myTeam then
                frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                frame.BorderColor3 = Color3.fromRGB(0, 255, 0)
            else
                frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
            end
            
            -- Nama player dengan background
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Text = player.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            nameLabel.BackgroundTransparency = 0.5
            nameLabel.TextScaled = true
            nameLabel.Size = UDim2.new(1, 0, 0, 20)
            nameLabel.Parent = frame
            
            -- Health bar
            local healthBar = Instance.new("Frame")
            healthBar.Size = UDim2.new(1, 0, 0, 6)
            healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            healthBar.BorderSizePixel = 0
            healthBar.Position = UDim2.new(0, 0, 1, -8)
            healthBar.Parent = frame
            
            -- Distance text
            local distanceLabel = Instance.new("TextLabel")
            distanceLabel.Text = ""
            distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            distanceLabel.BackgroundTransparency = 1
            distanceLabel.TextSize = 12
            distanceLabel.Position = UDim2.new(0, 0, 1, 2)
            distanceLabel.Size = UDim2.new(1, 0, 0, 15)
            distanceLabel.Parent = frame
            
            ESPFrames[player] = {frame = frame, healthBar = healthBar, distanceLabel = distanceLabel}
        end
    end
    
    Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer then
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 80, 0, 80)
            frame.BackgroundTransparency = 0.4
            frame.BorderSizePixel = 3
            frame.Parent = ESPGui
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Text = player.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            nameLabel.BackgroundTransparency = 0.5
            nameLabel.TextScaled = true
            nameLabel.Size = UDim2.new(1, 0, 0, 20)
            nameLabel.Parent = frame
            
            local healthBar = Instance.new("Frame")
            healthBar.Size = UDim2.new(1, 0, 0, 6)
            healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            healthBar.BorderSizePixel = 0
            healthBar.Position = UDim2.new(0, 0, 1, -8)
            healthBar.Parent = frame
            
            local distanceLabel = Instance.new("TextLabel")
            distanceLabel.Text = ""
            distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            distanceLabel.BackgroundTransparency = 1
            distanceLabel.TextSize = 12
            distanceLabel.Position = UDim2.new(0, 0, 1, 2)
            distanceLabel.Size = UDim2.new(1, 0, 0, 15)
            distanceLabel.Parent = frame
            
            ESPFrames[player] = {frame = frame, healthBar = healthBar, distanceLabel = distanceLabel}
        end
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        if ESPFrames[player] then
            pcall(function() ESPFrames[player].frame:Destroy() end)
            ESPFrames[player] = nil
        end
    end)
    
    -- Update ESP setiap frame
    RunService.RenderStepped:Connect(function()
        if not Settings.ESP then return end
        
        local camera = workspace.CurrentCamera
        local myTeam = LocalPlayer.Team
        local rootPart = GetRootPart()
        
        for player, data in pairs(ESPFrames) do
            if player.Character and player.Character:FindFirstChild("Head") then
                -- Update warna berdasarkan team
                if player.Team == myTeam then
                    data.frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                    data.frame.BorderColor3 = Color3.fromRGB(0, 255, 0)
                else
                    data.frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                    data.frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
                end
                
                -- Hitung posisi dan jarak
                local headPos = player.Character.Head.Position
                local pos, onScreen = camera:WorldToViewportPoint(headPos)
                local distance = rootPart and (rootPart.Position - headPos).Magnitude or 100
                
                if onScreen then
                    local scale = 100 / math.max(distance, 10)
                    local size = math.clamp(70 * scale, 40, 120)
                    data.frame.Size = UDim2.new(0, size, 0, size)
                    data.frame.Position = UDim2.new(0, pos.X - (size/2), 0, pos.Y - (size/2))
                    data.frame.Visible = true
                    
                    -- Update distance text
                    data.distanceLabel.Text = math.floor(distance) .. "m"
                    
                    -- Update health bar
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        local healthPercent = humanoid.Health / humanoid.MaxHealth
                        data.healthBar.Size = UDim2.new(healthPercent, 0, 0, 6)
                        if healthPercent > 0.6 then
                            data.healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                        elseif healthPercent > 0.3 then
                            data.healthBar.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
                        else
                            data.healthBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                        end
                    end
                    
                    -- Ubah warna border berdasarkan jarak
                    if distance < 20 then
                        data.frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
                    elseif distance < 50 then
                        data.frame.BorderColor3 = Color3.fromRGB(255, 255, 0)
                    else
                        data.frame.BorderColor3 = data.frame.BackgroundColor3
                    end
                else
                    data.frame.Visible = false
                end
            else
                data.frame.Visible = false
            end
        end
    end)
end

local function ToggleESP()
    Settings.ESP = not Settings.ESP
    
    if Settings.ESP then
        if not ESPGui then
            CreateESPPro()
        else
            ESPGui.Enabled = true
        end
        SendAutoReply("/me 👁️ ESP PRO AKTIF! Nama | Health | Distance 👁️")
        Notify("👁️ ESP PRO", "ESP dengan health bar & jarak aktif!", 2)
    else
        if ESPGui then
            ESPGui.Enabled = false
        end
        SendAutoReply("/me ❌ ESP NONAKTIF ❌")
        Notify("❌ ESP", "Dimatikan", 2)
    end
end

-- ==================== NOCLIP ====================
local function ToggleNoClip()
    Settings.NoClip = not Settings.NoClip
    
    local char = LocalPlayer.Character
    if char then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = not Settings.NoClip
            end
        end
    end
    
    if Settings.NoClip then
        SendAutoReply("/me 🔓 NOCLIP AKTIF! 🔓")
        Notify("🔓 NOCLIP", "Mode tembus tembok aktif", 2)
    else
        SendAutoReply("/me 🔒 NOCLIP NONAKTIF 🔒")
        Notify("🔒 NOCLIP", "Mode tembus tembok dimatikan", 2)
    end
end

-- ==================== GODMODE ====================
local function ToggleGodMode()
    Settings.GodMode = not Settings.GodMode
    
    if Settings.GodMode then
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
            humanoid.BreakJointsOnDeath = false
        end
        SendAutoReply("/me 🛡️ GOD MODE AKTIF! 🛡️")
        Notify("🛡️ GOD MODE", "Kamu sekarang abadi!", 2)
    else
        SendAutoReply("/me ❌ GOD MODE NONAKTIF ❌")
        Notify("❌ GOD MODE", "Mode abadi dimatikan", 2)
    end
end

-- ==================== INFINITE JUMP ====================
local function ToggleInfiniteJump()
    Settings.InfiniteJump = not Settings.InfiniteJump
    
    if Settings.InfiniteJump then
        if InfiniteJumpConnection then InfiniteJumpConnection:Disconnect() end
        InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
            local humanoid = GetHumanoid()
            if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        SendAutoReply("/me ♾️ INFINITE JUMP AKTIF! ♾️")
        Notify("♾️ INFINITE JUMP", "Lompat tanpa batas aktif!", 2)
    else
        if InfiniteJumpConnection then
            InfiniteJumpConnection:Disconnect()
            InfiniteJumpConnection = nil
        end
        SendAutoReply("/me ❌ INFINITE JUMP NONAKTIF ❌")
        Notify("❌ INFINITE JUMP", "Dimatikan", 2)
    end
end

-- ==================== TELEPORT ====================
local function TeleportTo(position)
    local rootPart = GetRootPart()
    if rootPart then
        TeleportIndex = TeleportIndex + 1
        TeleportHistory[TeleportIndex] = rootPart.CFrame
        rootPart.CFrame = CFrame.new(position)
        SendAutoReply("/me ✨ TELEPORT KE: " .. tostring(position) .. " ✨")
        Notify("✨ TELEPORT", "Berhasil teleport!", 2)
    end
end

local function TeleportBack()
    if TeleportIndex > 0 then
        local rootPart = GetRootPart()
        if rootPart and TeleportHistory[TeleportIndex] then
            rootPart.CFrame = TeleportHistory[TeleportIndex]
            TeleportHistory[TeleportIndex] = nil
            TeleportIndex = TeleportIndex - 1
            SendAutoReply("/me ↩️ TELEPORT BACK! ↩️")
            Notify("↩️ TELEPORT", "Kembali ke posisi sebelumnya", 2)
        end
    else
        SendAutoReply("/me ⚠️ TIDAK ADA HISTORY TELEPORT! ⚠️")
    end
end

local function TeleportToPlayer(playerName)
    for _, player in pairs(Players:GetPlayers()) do
        if string.lower(player.Name):find(string.lower(playerName)) and player ~= LocalPlayer then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                TeleportTo(player.Character.HumanoidRootPart.Position)
                return
            end
        end
    end
    SendAutoReply("/me ❌ PLAYER TIDAK DITEMUKAN! ❌")
end

-- ==================== AUTO FARM ====================
local function StartAutoFarm()
    Settings.AutoFarm = not Settings.AutoFarm
    
    if Settings.AutoFarm then
        if AutoFarmConnection then AutoFarmConnection:Disconnect() end
        AutoFarmConnection = RunService.RenderStepped:Connect(function()
            if not Settings.AutoFarm then return end
            local rootPart = GetRootPart()
            if not rootPart then return end
            
            local nearestObject = nil
            local nearestDistance = 50
            
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Part") or obj:IsA("MeshPart") then
                    if obj:FindFirstChildOfClass("ClickDetector") or 
                       obj.Name:find("Farm") or obj.Name:find("Crop") or 
                       obj.Name:find("Node") or obj.Name:find("Ore") or
                       obj.Name:find("Block") or obj.Name:find("Resource") or
                       obj.Name:find("Tree") then
                        
                        local objPos = obj.Position
                        if objPos then
                            local distance = (rootPart.Position - objPos).Magnitude
                            if distance < nearestDistance then
                                nearestDistance = distance
                                nearestObject = obj
                            end
                        end
                    end
                end
            end
            
            if nearestObject and nearestDistance < 50 then
                local clickDetector = nearestObject:FindFirstChildOfClass("ClickDetector")
                if clickDetector then
                    pcall(function() fireclickdetector(clickDetector) end)
                end
                if nearestDistance > 5 then
                    rootPart.CFrame = CFrame.new(nearestObject.Position + Vector3.new(0, 2, 0))
                end
            end
        end)
        SendAutoReply("/me 🌾 AUTO FARM AKTIF! 🌾")
        Notify("🌾 AUTO FARM", "Aktif mencari resource!", 2)
    else
        if AutoFarmConnection then
            AutoFarmConnection:Disconnect()
            AutoFarmConnection = nil
        end
        SendAutoReply("/me ❌ AUTO FARM NONAKTIF ❌")
        Notify("❌ AUTO FARM", "Dimatikan", 2)
    end
end

-- ==================== AUTO COLLECT ====================
local function StartAutoCollect()
    Settings.AutoCollect = not Settings.AutoCollect
    
    if Settings.AutoCollect then
        if AutoCollectConnection then AutoCollectConnection:Disconnect() end
        AutoCollectConnection = RunService.RenderStepped:Connect(function()
            if not Settings.AutoCollect then return end
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Part") and obj:FindFirstChildOfClass("ClickDetector") then
                    if obj.BrickColor == BrickColor.new("Bright yellow") or 
                       obj.Name:find("Coin") or obj.Name:find("Gem") or
                       obj.Name:find("Item") or obj.Name:find("Drop") or
                       obj.Name:find("Money") then
                        local distance = (GetRootPart() and GetRootPart().Position - obj.Position).Magnitude or 999
                        if distance < 20 then
                            pcall(function() fireclickdetector(obj:FindFirstChildOfClass("ClickDetector")) end)
                        end
                    end
                end
            end
        end)
        SendAutoReply("/me 💰 AUTO COLLECT AKTIF! 💰")
        Notify("💰 AUTO COLLECT", "Auto collect item aktif!", 2)
    else
        if AutoCollectConnection then
            AutoCollectConnection:Disconnect()
            AutoCollectConnection = nil
        end
        SendAutoReply("/me ❌ AUTO COLLECT NONAKTIF ❌")
        Notify("❌ AUTO COLLECT", "Dimatikan", 2)
    end
end

-- ==================== SILENT AIM ====================
local function ToggleSilentAim()
    Settings.SilentAim = not Settings.SilentAim
    
    if Settings.SilentAim then
        if AimbotConnection then AimbotConnection:Disconnect() end
        AimbotConnection = RunService.RenderStepped:Connect(function()
            if not Settings.SilentAim then return end
            
            local camera = workspace.CurrentCamera
            local closestPlayer = nil
            local closestDistance = 500
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                    local headPos = player.Character.Head.Position
                    local screenPoint = camera:WorldToViewportPoint(headPos)
                    local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - 
                                      Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
                    if screenPoint.Z > 0 and distance < closestDistance then
                        closestDistance = distance
                        closestPlayer = player
                    end
                end
            end
            
            if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("Head") then
                camera.CFrame = CFrame.new(camera.CFrame.Position, closestPlayer.Character.Head.Position)
            end
        end)
        SendAutoReply("/me 🎯 SILENT AIM AKTIF! 🎯")
        Notify("🎯 SILENT AIM", "Auto aim aktif!", 2)
    else
        if AimbotConnection then
            AimbotConnection:Disconnect()
            AimbotConnection = nil
        end
        SendAutoReply("/me ❌ SILENT AIM NONAKTIF ❌")
        Notify("❌ SILENT AIM", "Dimatikan", 2)
    end
end

-- ==================== ANTI STUN ====================
local function ToggleAntiStun()
    Settings.AntiStun = not Settings.AntiStun
    
    if Settings.AntiStun then
        if AntiStunConnection then AntiStunConnection:Disconnect() end
        AntiStunConnection = RunService.RenderStepped:Connect(function()
            if not Settings.AntiStun then return end
            local humanoid = GetHumanoid()
            if humanoid then
                if humanoid:GetState() == Enum.HumanoidStateType.FallingDown or
                   humanoid:GetState() == Enum.HumanoidStateType.Ragdoll or
                   humanoid:GetState() == Enum.HumanoidStateType.Stunned then
                    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                end
                humanoid.Sit = false
            end
        end)
        SendAutoReply("/me 💪 ANTI STUN AKTIF! 💪")
        Notify("💪 ANTI STUN", "Tidak bisa di-stun!", 2)
    else
        if AntiStunConnection then
            AntiStunConnection:Disconnect()
            AntiStunConnection = nil
        end
        SendAutoReply("/me ❌ ANTI STUN NONAKTIF ❌")
        Notify("❌ ANTI STUN", "Dimatikan", 2)
    end
end

-- ==================== AUTO HEAL ====================
local function ToggleAutoHeal()
    Settings.AutoHeal = not Settings.AutoHeal
    
    if Settings.AutoHeal then
        if AutoHealConnection then AutoHealConnection:Disconnect() end
        AutoHealConnection = RunService.RenderStepped:Connect(function()
            if not Settings.AutoHeal then return end
            local humanoid = GetHumanoid()
            if humanoid and humanoid.Health < humanoid.MaxHealth * 0.7 then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
        SendAutoReply("/me 💚 AUTO HEAL AKTIF! 💚")
        Notify("💚 AUTO HEAL", "Auto heal saat darah turun!", 2)
    else
        if AutoHealConnection then
            AutoHealConnection:Disconnect()
            AutoHealConnection = nil
        end
        SendAutoReply("/me ❌ AUTO HEAL NONAKTIF ❌")
        Notify("❌ AUTO HEAL", "Dimatikan", 2)
    end
end

-- ==================== WALK ON WATER ====================
local function ToggleWalkOnWater()
    Settings.WalkOnWater = not Settings.WalkOnWater
    
    if Settings.WalkOnWater then
        if WalkOnWaterConnection then WalkOnWaterConnection:Disconnect() end
        WalkOnWaterConnection = RunService.RenderStepped:Connect(function()
            if not Settings.WalkOnWater then return end
            local rootPart = GetRootPart()
            if rootPart and rootPart.Position.Y < 5 then
                local ray = Ray.new(rootPart.Position, Vector3.new(0, -3, 0))
                local hit, pos = wo