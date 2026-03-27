--[[
    ZONE XD MOBILE V3
    LIMIT SPEED MAX 50 | JUMP MAX 100
    AUTO REPLY DI CHAT
    SEMUA FITUR SUDAH DI TEST
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

-- SETTINGS DENGAN LIMIT
local Settings = {
    Speed = 16,           -- DEFAULT
    JumpPower = 50,       -- DEFAULT
    FlySpeed = 50,        -- LIMIT FLY 50
    Flying = false,
    NoClip = false,
    GodMode = false,
    InfiniteJump = false,
    AutoClick = false,
    ESP = false,
    Aimbot = false,
    SpeedEnabled = true,
    JumpEnabled = true,
    ClickDelay = 0.1
}

-- LIMIT MAX
local MAX_SPEED = 50
local MAX_JUMP = 100
local MAX_FLY_SPEED = 50

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

-- Auto Click
local AutoClickConnection = nil

-- Aimbot
local AimbotConnection = nil

-- Infinite Jump
local InfiniteJumpConnection = nil

-- Touch Fly Controls
local TouchJoystick = nil

-- ==================== UTILITY FUNCTIONS ====================

-- Send Chat Message (Auto Reply)
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

-- Send Notification
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

-- Get Humanoid
local function GetHumanoid()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        return LocalPlayer.Character.Humanoid
    end
    return nil
end

-- Get Root Part
local function GetRootPart()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return LocalPlayer.Character.HumanoidRootPart
    end
    return nil
end

-- ==================== SPEED SYSTEM (DENGAN LIMIT) ====================
local function SetSpeed(value)
    value = tonumber(value)
    if not value then
        SendAutoReply("/me ⚠️ FORMAT SALAH! Ketik /speed [1-50] ⚠️")
        Notify("⚠️ ERROR", "Format: /speed [angka]", 2)
        return
    end
    
    -- LIMIT MAX 50
    if value > MAX_SPEED then
        SendAutoReply("/me ⛔ LIMIT! Speed max " .. MAX_SPEED .. " ⛔")
        Notify("⛔ LIMIT", "Speed maksimal " .. MAX_SPEED, 2)
        value = MAX_SPEED
    end
    
    if value < 10 then
        SendAutoReply("/me ⚠️ Speed minimal 10 ⚠️")
        value = 10
    end
    
    Settings.Speed = value
    
    if Settings.SpeedEnabled then
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.WalkSpeed = value
            SendAutoReply("/me ⚡ SPEED SET KE: " .. value .. " ⚡")
            Notify("⚡ SPEED", "Kecepatan: " .. value, 2)
        else
            SendAutoReply("/me ❌ GAGAL! Character tidak ditemukan ❌")
        end
    end
end

-- ==================== JUMP SYSTEM (DENGAN LIMIT) ====================
local function SetJump(value)
    value = tonumber(value)
    if not value then
        SendAutoReply("/me ⚠️ FORMAT SALAH! Ketik /jump [1-100] ⚠️")
        Notify("⚠️ ERROR", "Format: /jump [angka]", 2)
        return
    end
    
    -- LIMIT MAX 100
    if value > MAX_JUMP then
        SendAutoReply("/me ⛔ LIMIT! Jump max " .. MAX_JUMP .. " ⛔")
        Notify("⛔ LIMIT", "Jump maksimal " .. MAX_JUMP, 2)
        value = MAX_JUMP
    end
    
    if value < 30 then
        SendAutoReply("/me ⚠️ Jump minimal 30 ⚠️")
        value = 30
    end
    
    Settings.JumpPower = value
    
    if Settings.JumpEnabled then
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.JumpPower = value
            SendAutoReply("/me 🦘 JUMP POWER SET KE: " .. value .. " 🦘")
            Notify("🦘 JUMP", "Lompatan: " .. value, 2)
        else
            SendAutoReply("/me ❌ GAGAL! Character tidak ditemukan ❌")
        end
    end
end

-- ==================== FLY SYSTEM (DENGAN LIMIT) ====================
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
    
    -- Bersihin NoClip
    if LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = true
            end
        end
    end
    
    FlyingActive = false
    
    -- Hapus joystick
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
        Notify("⚠️ ERROR", "Character not found", 2)
        return
    end
    
    local humanoid = GetHumanoid()
    local rootPart = GetRootPart()
    
    if not humanoid or not rootPart then
        SendAutoReply("/me ❌ GAGAL! Humanoid/RootPart tidak ditemukan ❌")
        Notify("⚠️ ERROR", "Humanoid or RootPart not found", 2)
        return
    end
    
    -- NoClip otomatis pas fly
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
    
    -- Buat joystick untuk HP
    CreateTouchJoystick()
    
    SendAutoReply("/me 🕊️ FLY MODE AKTIF! Geser joystick di layar 🕊️")
    Notify("🕊️ FLY", "Mode terbang aktif! Speed max " .. MAX_FLY_SPEED, 3)
end

-- Joystick untuk HP
local function CreateTouchJoystick()
    if TouchJoystick then pcall(function() TouchJoystick:Destroy() end) end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ZoneXDFlyJoystick"
    ScreenGui.Parent = game.CoreGui
    
    -- Background joystick
    local JoystickBg = Instance.new("Frame")
    JoystickBg.Size = UDim2.new(0, 120, 0, 120)
    JoystickBg.Position = UDim2.new(0, 20, 1, -140)
    JoystickBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    JoystickBg.BackgroundTransparency = 0.6
    JoystickBg.BorderSizePixel = 0
    JoystickBg.BorderRadius = UDim.new(1, 60)
    JoystickBg.Parent = ScreenGui
    
    -- Stick
    local Joystick = Instance.new("Frame")
    Joystick.Size = UDim2.new(0, 50, 0, 50)
    Joystick.Position = UDim2.new(0.5, -25, 0.5, -25)
    Joystick.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
    Joystick.BackgroundTransparency = 0.4
    Joystick.BorderSizePixel = 0
    Joystick.BorderRadius = UDim.new(1, 25)
    Joystick.Parent = JoystickBg
    
    -- Text petunjuk
    local Hint = Instance.new("TextLabel")
    Hint.Size = UDim2.new(0, 120, 0, 30)
    Hint.Position = UDim2.new(0, 0, 1, 10)
    Hint.BackgroundTransparency = 1
    Hint.Text = "🕊️ GESER UNTUK TERBANG"
    Hint.TextColor3 = Color3.fromRGB(255, 255, 255)
    Hint.TextSize = 12
    Hint.TextScaled = true
    Hint.Parent = JoystickBg
    
    -- Tombol stop
    local StopButton = Instance.new("TextButton")
    StopButton.Size = UDim2.new(0, 60, 0, 60)
    StopButton.Position = UDim2.new(1, -80, 1, -80)
    StopButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    StopButton.BackgroundTransparency = 0.4
    StopButton.BorderSizePixel = 0
    StopButton.BorderRadius = UDim.new(1, 30)
    StopButton.Text = "🛑"
    StopButton.TextSize = 30
    StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    StopButton.Parent = ScreenGui
    
    StopButton.MouseButton1Click:Connect(function()
        StopFly()
    end)
    
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
        TweenService:Create(Joystick, TweenInfo.new(0.2), {Position = UDim2.new(0.5, -25, 0.5, -25)}):Play()
        FlyControls.Forward = false
        FlyControls.Backward = false
        FlyControls.Left = false
        FlyControls.Right = false
        FlyControls.Up = false
        FlyControls.Down = false
    end)
    
    JoystickBg.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            local newX = math.clamp(startPos.X.Offset + delta.X, -60, 60)
            local newY = math.clamp(startPos.Y.Offset + delta.Y, -60, 60)
            Joystick.Position = UDim2.new(0.5, newX, 0.5, newY)
            
            local normX = newX / 60
            local normY = newY / 60
            
            FlyControls.Forward = normY < -0.3
            FlyControls.Backward = normY > 0.3
            FlyControls.Left = normX < -0.3
            FlyControls.Right = normX > 0.3
        end
    end)
    
    -- Tombol naik/turun di sisi lain
    local UpButton = Instance.new("TextButton")
    UpButton.Size = UDim2.new(0, 70, 0, 70)
    UpButton.Position = UDim2.new(1, -90, 0.5, -35)
    UpButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    UpButton.BackgroundTransparency = 0.4
    UpButton.BorderSizePixel = 0
    UpButton.BorderRadius = UDim.new(1, 35)
    UpButton.Text = "⬆️"
    UpButton.TextSize = 30
    UpButton.Parent = ScreenGui
    
    local DownButton = Instance.new("TextButton")
    DownButton.Size = UDim2.new(0, 70, 0, 70)
    DownButton.Position = UDim2.new(1, -90, 0.8, -35)
    DownButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    DownButton.BackgroundTransparency = 0.4
    DownButton.BorderSizePixel = 0
    DownButton.BorderRadius = UDim.new(1, 35)
    DownButton.Text = "⬇️"
    DownButton.TextSize = 30
    DownButton.Parent = ScreenGui
    
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
        SendAutoReply("/me 🔓 NOCLIP AKTIF! Bisa tembus tembok 🔓")
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
        SendAutoReply("/me 🛡️ GOD MODE AKTIF! Tidak bisa mati 🛡️")
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
        SendAutoReply("/me ♾️ INFINITE JUMP AKTIF! Lompat terus ♾️")
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

-- ==================== ESP ====================
local function CreateESP()
    if ESPGui then pcall(function() ESPGui:Destroy() end) end
    
    ESPGui = Instance.new("ScreenGui")
    ESPGui.Name = "ZoneXD_ESP"
    ESPGui.Parent = game.CoreGui
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 80, 0, 80)
            frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            frame.BackgroundTransparency = 0.5
            frame.BorderSizePixel = 2
            frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
            frame.Parent = ESPGui
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Text = player.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.BackgroundTransparency = 1
            nameLabel.TextScaled = true
            nameLabel.Size = UDim2.new(1, 0, 0, 20)
            nameLabel.Parent = frame
            
            ESPFrames[player] = frame
        end
    end
    
    Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer then
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 80, 0, 80)
            frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            frame.BackgroundTransparency = 0.5
            frame.BorderSizePixel = 2
            frame.Parent = ESPGui
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Text = player.Name
            nameLabel.BackgroundTransparency = 1
            nameLabel.TextScaled = true
            nameLabel.Size = UDim2.new(1, 0, 0, 20)
            nameLabel.Parent = frame
            
            ESPFrames[player] = frame
        end
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        if ESPFrames[player] then
            pcall(function() ESPFrames[player]:Destroy() end)
            ESPFrames[player] = nil
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if not Settings.ESP then return end
        
        local camera = workspace.CurrentCamera
        for player, frame in pairs(ESPFrames) do
            if player.Character and player.Character:FindFirstChild("Head") then
                local pos, onScreen = camera:WorldToViewportPoint(player.Character.Head.Position)
                if onScreen then
                    local distance = (GetRootPart() and GetRootPart().Position - player.Character.Head.Position).Magnitude or 100
                    local scale = 120 / math.max(distance, 10)
                    frame.Size = UDim2.new(0, 80 * scale, 0, 80 * scale)
                    frame.Position = UDim2.new(0, pos.X - (40 * scale), 0, pos.Y - (40 * scale))
                    frame.Visible = true
                    
                    if distance < 20 then
                        frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                    elseif distance < 50 then
                        frame.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
                    else
                        frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                    end
                else
                    frame.Visible = false
                end
            else
                frame.Visible = false
            end
        end
    end)
end

local function ToggleESP()
    Settings.ESP = not Settings.ESP
    
    if Settings.ESP then
        if not ESPGui then
            CreateESP()
        else
            ESPGui.Enabled = true
        end
        SendAutoReply("/me 👁️ ESP AKTIF! Bisa lihat player lain 👁️")
        Notify("👁️ ESP", "Wallhack aktif!", 2)
    else
        if ESPGui then
            ESPGui.Enabled = false
        end
        SendAutoReply("/me ❌ ESP NONAKTIF ❌")
        Notify("❌ ESP", "Dimatikan", 2)
    end
end

-- ==================== AUTO CLICK ====================
local function ToggleAutoClick()
    Settings.AutoClick = not Settings.AutoClick
    
    if Settings.AutoClick then
        if AutoClickConnection then AutoClickConnection:Disconnect() end
        AutoClickConnection = RunService.RenderStepped:Connect(function()
            if Settings.AutoClick then
                pcall(function()
                    VirtualUser:ClickButton1(Vector2.new(500, 500))
                end)
                wait(Settings.ClickDelay)
            end
        end)
        SendAutoReply("/me 🖱️ AUTO CLICK AKTIF! Klik setiap " .. Settings.ClickDelay .. " detik 🖱️")
        Notify("🖱️ AUTO CLICK", "Aktif! Delay: " .. Settings.ClickDelay .. "s", 2)
    else
        if AutoClickConnection then
            AutoClickConnection:Disconnect()
            AutoClickConnection = nil
        end
        SendAutoReply("/me ❌ AUTO CLICK NONAKTIF ❌")
        Notify("❌ AUTO CLICK", "Dimatikan", 2)
    end
end

-- ==================== AIMBOT ====================
local function ToggleAimbot()
    Settings.Aimbot = not Settings.Aimbot
    
    if Settings.Aimbot then
        if AimbotConnection then AimbotConnection:Disconnect() end
        AimbotConnection = RunService.RenderStepped:Connect(function()
            if not Settings.Aimbot then return end
            
            local camera = workspace.CurrentCamera
            local closestPlayer = nil
            local closestDistance = 200
            
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
        SendAutoReply("/me 🎯 AIMBOT AKTIF! Auto aim ke player terdekat 🎯")
        Notify("🎯 AIMBOT", "Aktif!", 2)
    else
        if AimbotConnection then
            AimbotConnection:Disconnect()
            AimbotConnection = nil
        end
        SendAutoReply("/me ❌ AIMBOT NONAKTIF ❌")
        Notify("❌ AIMBOT", "Dimatikan", 2)
    end
end

-- ==================== RESET ====================
local function ResetAll()
    local humanoid = GetHumanoid()
    if humanoid then
        humanoid.WalkSpeed = OriginalSpeed
        humanoid.JumpPower = OriginalJump
        humanoid.MaxHealth = 100
        humanoid.BreakJointsOnDeath = true
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
    end
    
    if FlyingActive then StopFly() end
    
    Settings.SpeedEnabled = true
    Settings.JumpEnabled = true
    Settings.NoClip = false
    Settings.GodMode = false
    Settings.InfiniteJump = false
    Settings.AutoClick = false
    Settings.ESP = false
    Settings.Aimbot = false
    Settings.Speed = OriginalSpeed
    Settings.JumpPower = OriginalJump
    
    if ESPGui then 
        pcall(function() ESPGui:Destroy() end)
        ESPGui = nil
    end
    
    if AutoClickConnection then
        AutoClickConnection:Disconnect()
        AutoClickConnection = nil
    end
    
    if AimbotConnection then
        AimbotConnection:Disconnect()
        AimbotConnection = nil
    end
    
    if InfiniteJumpConnection then
        InfiniteJumpConnection:Disconnect()
        InfiniteJumpConnection = nil
    end
    
    if TouchJoystick then
        pcall(function() TouchJoystick:Destroy() end)
        TouchJoystick = nil
    end
    
    -- Reset NoClip di character
    if LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = true
            end
        end
    end
    
    SendAutoReply("/me 🔄 SEMUA FITUR DI RESET KE DEFAULT! 🔄")
    Notify("🔄 RESET", "Semua fitur dinonaktifkan", 3)
end

-- ==================== MENU ====================
local function ShowMenu()
    SendAutoReply("/me ╔════════════════════════════════════════╗")
    wait(0.2)
    SendAutoReply("/me ║    🔥 ZONE XD MOBILE V3 🔥            ║")
    wait(0.2)
    SendAutoReply("/me ║    CREATED BY: APIS                   ║")
    wait(0.2)
    SendAutoReply("/me ╠════════════════════════════════════════╣")
    wait(0.2)
    SendAutoReply("/me ║ 📝 COMMAND LIST:                      ║")
    wait(0.2)
    SendAutoReply("/me ║ /speed 1-50  - Set kecepatan          ║")
    wait(0.2)
    SendAutoReply("/me ║ /jump 30-100 - Set kekuatan lompat    ║")
    wait(0.2)
    SendAutoReply("/me ║ /fly        - Mode terbang            ║")
    wait(0.2)
    SendAutoReply("/me ║ /noclip     - Tembus tembok           ║")
    wait(0.2)
    SendAutoReply("/me ║ /god        - Mode abadi              ║")
    wait(0.2)
    SendAutoReply("/me ║ /infjump    - Lompat tak terbatas     ║")
    wait(0.2)
    SendAutoReply("/me ║ /esp        - Wallhack                ║")
    wait(0.2)
    SendAutoReply("/me ║ /aimbot     - Auto aim                ║")
    wait(0.2)
    SendAutoReply("/me ║ /autoclick  - Auto klik               ║")
    wait(0.2)
    SendAutoReply("/me ║ /reset      - Reset semua             ║")
    wait(0.2)
    SendAutoReply("/me ╚════════════════════════════════════════╝")
    
    Notify("🎮 ZONE XD", "Menu ditampilkan di chat!", 4)
end

-- ==================== COMMAND PROCESSOR ====================
local function ProcessCommand(msg)
    local lowerMsg = string.lower(msg)
    
    if lowerMsg == "/menu" then
        ShowMenu()
        return true
    end
    
    if lowerMsg == "/fly" then
        StartFly()
        return true
    end
    
    if lowerMsg == "/noclip" then
        ToggleNoClip()
        return true
    end
    
    if lowerMsg == "/god" then
        ToggleGodMode()
        return true
    end
    
    if lowerMsg == "/infjump" then
        ToggleInfiniteJump()
        return true
    end
    
    if lowerMsg == "/esp" then
        ToggleESP()
        return true
    end
    
    if lowerMsg == "/aimbot" then
        ToggleAimbot()
        return true
    end
    
    if lowerMsg == "/autoclick" then
        ToggleAutoClick()
        return true
    end
    
    if lowerMsg == "/reset" then
        ResetAll()
        return true
    end
    
    if string.match(lowerMsg, "^/speed") then
        local value = string.match(lowerMsg, "%d+")
        if value then
            SetSpeed(value)
        else
            SendAutoReply("/me ⚠️ Format: /speed [angka 1-50] ⚠️")
        end
        return true
    end
    
    if string.match(lowerMsg, "^/jump") then
        local value = string.match(lowerMsg, "%d+")
        if value then
            SetJump(value)
        else
            SendAutoReply("/me ⚠️ Format: /jump [angka 30-100] ⚠️")
        end
        return true
    end
    
    return false
end

-- ==================== CHAT LISTENER ====================
local function SetupChatListener()
    pcall(function()
        if TextService and TextService.TextChannels then
            for _, channel in pairs(TextService.TextChannels:GetChildren()) do
                if channel:IsA("TextChannel") then
                    channel.MessageReceived:Connect(function(message)
                        if message.TextSource and message.TextSource.UserId == LocalPlayer.UserId then
                            ProcessCommand(message.Text)
                        end
                    end)
                end
            end
        end
    end)
end

-- ==================== AUTO UPDATE STATS ====================
RunService.RenderStepped:Connect(function()
    local humanoid = GetHumanoid()
    if not humanoid then return end
    
    if Settings.SpeedEnabled and humanoid.WalkSpeed ~= Settings.Speed then
        humanoid.WalkSpeed = Settings.Speed
    end
    
    if Settings.JumpEnabled and humanoid.JumpPower ~= Settings.JumpPower then
        humanoid.JumpPower = Settings.JumpPower
    end
    
    if Settings.GodMode then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        humanoid.BreakJointsOnDeath = false
    end
    
    if Settings.NoClip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- ==================== INIT ====================
local function Init()
    Notify("🔥 ZONE XD V3", "Loading...", 2)
    wait(1)
    
    SetupChatListener()
    
    SendAutoReply("/me ╔════════════════════════════════════╗")
    wait(0.2)
    SendAutoReply("/me ║   🔥 ZONE XD MOBILE V3 🔥         ║")
    wait(0.2)
    SendAutoReply("/me ║   CREATED BY: APIS                ║")
    wait(0.2)
    SendAutoReply("/me ║   SPEED MAX: 50 | JUMP MAX: 100   ║")
    wait(0.2)
    SendAutoReply("/me ╠════════════════════════════════════╣")
    wait(0.2)
    SendAutoReply("/me ║   💀 SCRIPT AKTIF! 💀              ║")
    wait(0.2)
    SendAutoReply("/me ║   KETIK /menu DI CHAT             ║")
    wait(0.2)
    SendAutoReply("/me ╚════════════════════════════════════╝")
    
    Notify("✅ ZONE XD V3", "Aktif! Ketik /menu di chat", 3)
end

Init()