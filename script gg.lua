--[[
    ZONE XD UNIVERSAL COMMAND HUB
    AKTIFKAN DENGAN KETIK /menu DI CHAT
    PAKAI FORMAT: /command value
    WORK DI SEMUA GAME ROBLOX
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

-- Default Settings
local Settings = {
    Speed = 16,
    JumpPower = 50,
    FlySpeed = 100,
    Flying = false,
    NoClip = false,
    GodMode = false,
    InfiniteJump = false,
    AutoClick = false,
    AutoFarm = false,
    ESP = false,
    Aimbot = false,
    SpeedEnabled = true,
    JumpEnabled = true,
    ClickDelay = 0.1,
    FarmRadius = 50
}

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

-- Auto Farm Variables
local AutoFarmActive = false
local AutoFarmConnection = nil

-- ==================== UTILITY FUNCTIONS ====================

-- Send Chat Message
local function SendChatMessage(msg)
    local success, err = pcall(function()
        if TextService and TextService.TextChannels then
            for _, channel in pairs(TextService.TextChannels:GetChildren()) do
                if channel:IsA("TextChannel") then
                    channel:SendAsync(msg)
                    break
                end
            end
        end
    end)
    if not success then
        print("[ZONE XD] " .. msg)
    end
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
    print("[ZONE XD] " .. title .. ": " .. text)
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

-- ==================== SPEED SYSTEM ====================
local function SetSpeed(value)
    value = tonumber(value)
    if not value then
        Notify("⚠️ ERROR", "Format: /speed [angka]", 2)
        return
    end
    
    if value > 250 then
        Notify("⚠️ WARNING", "Speed terlalu tinggi! Turunkan ke 250", 2)
        value = 250
    end
    
    Settings.Speed = value
    
    if Settings.SpeedEnabled then
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.WalkSpeed = value
            SendChatMessage("/me ⚡ SPEED SET KE: " .. value .. " ⚡")
            Notify("⚡ SPEED", "Kecepatan: " .. value, 2)
        end
    end
end

-- ==================== JUMP SYSTEM ====================
local function SetJump(value)
    value = tonumber(value)
    if not value then
        Notify("⚠️ ERROR", "Format: /jump [angka]", 2)
        return
    end
    
    if value > 200 then
        Notify("⚠️ WARNING", "Jump terlalu tinggi! Turunkan ke 200", 2)
        value = 200
    end
    
    Settings.JumpPower = value
    
    if Settings.JumpEnabled then
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.JumpPower = value
            SendChatMessage("/me 🦘 JUMP POWER SET KE: " .. value .. " 🦘")
            Notify("🦘 JUMP", "Lompatan: " .. value, 2)
        end
    end
end

-- ==================== FLY SYSTEM ====================
local function StopFly()
    if FlyBodyVelocity then FlyBodyVelocity:Destroy() end
    if FlyBodyGyro then FlyBodyGyro:Destroy() end
    
    local humanoid = GetHumanoid()
    if humanoid then
        humanoid.PlatformStand = false
    end
    
    FlyingActive = false
    FlyBodyVelocity = nil
    FlyBodyGyro = nil
    
    SendChatMessage("/me 🕊️ FLY MODE NONAKTIF 🕊️")
    Notify("🕊️ FLY", "Mode terbang dimatikan", 2)
end

local function StartFly()
    if FlyingActive then
        StopFly()
        return
    end
    
    local char = LocalPlayer.Character
    if not char then
        Notify("⚠️ ERROR", "Character not found", 2)
        return
    end
    
    local humanoid = GetHumanoid()
    local rootPart = GetRootPart()
    
    if not humanoid or not rootPart then
        Notify("⚠️ ERROR", "Humanoid or RootPart not found", 2)
        return
    end
    
    -- NoClip
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
    
    SendChatMessage("/me 🕊️ FLY MODE AKTIF! Tekan X untuk matikan 🕊️")
    Notify("🕊️ FLY", "Mode terbang aktif! Gunakan WASD + Space/Ctrl", 3)
end

-- ==================== NOCLIP SYSTEM ====================
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
        SendChatMessage("/me 🔓 NOCLIP AKTIF! Bisa tembus tembok 🔓")
        Notify("🔓 NOCLIP", "Mode tembus tembok aktif", 2)
    else
        SendChatMessage("/me 🔒 NOCLIP NONAKTIF 🔒")
        Notify("🔒 NOCLIP", "Mode tembus tembok dimatikan", 2)
    end
end

-- ==================== GODMODE SYSTEM ====================
local function ToggleGodMode()
    Settings.GodMode = not Settings.GodMode
    
    if Settings.GodMode then
        SendChatMessage("/me 🛡️ GOD MODE AKTIF! Tidak bisa mati 🛡️")
        Notify("🛡️ GOD MODE", "Kamu sekarang abadi!", 2)
    else
        SendChatMessage("/me ❌ GOD MODE NONAKTIF ❌")
        Notify("❌ GOD MODE", "Mode abadi dimatikan", 2)
    end
end

-- ==================== INFINITE JUMP SYSTEM ====================
local InfiniteJumpConnection = nil

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
        
        SendChatMessage("/me ♾️ INFINITE JUMP AKTIF! Lompat terus ♾️")
        Notify("♾️ INFINITE JUMP", "Lompat tanpa batas aktif!", 2)
    else
        if InfiniteJumpConnection then
            InfiniteJumpConnection:Disconnect()
            InfiniteJumpConnection = nil
        end
        SendChatMessage("/me ❌ INFINITE JUMP NONAKTIF ❌")
        Notify("❌ INFINITE JUMP", "Dimatikan", 2)
    end
end

-- ==================== ESP SYSTEM ====================
local function CreateESP()
    if ESPGui then ESPGui:Destroy() end
    
    ESPGui = Instance.new("ScreenGui")
    ESPGui.Name = "ZoneXD_ESP"
    ESPGui.Parent = game.CoreGui
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 100, 0, 100)
            frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            frame.BackgroundTransparency = 0.5
            frame.BorderSizePixel = 2
            frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
            frame.Parent = ESPGui
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Text = player.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.BackgroundTransparency = 1
            nameLabel.TextStrokeTransparency = 0
            nameLabel.TextScaled = true
            nameLabel.Size = UDim2.new(1, 0, 0, 20)
            nameLabel.Parent = frame
            
            ESPFrames[player] = frame
        end
    end
    
    Players.PlayerAdded:Connect(function(player)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 100, 0, 100)
        frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        frame.BackgroundTransparency = 0.5
        frame.BorderSizePixel = 2
        frame.Parent = ESPGui
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextScaled = true
        nameLabel.Size = UDim2.new(1, 0, 0, 20)
        nameLabel.Parent = frame
        
        ESPFrames[player] = frame
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        if ESPFrames[player] then
            ESPFrames[player]:Destroy()
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
                    local scale = 150 / distance
                    frame.Size = UDim2.new(0, 100 * scale, 0, 100 * scale)
                    frame.Position = UDim2.new(0, pos.X - (50 * scale), 0, pos.Y - (50 * scale))
                    frame.Visible = true
                    
                    -- Change color based on distance
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
        SendChatMessage("/me 👁️ ESP AKTIF! Bisa lihat player lain 👁️")
        Notify("👁️ ESP", "Wallhack aktif!", 2)
    else
        if ESPGui then
            ESPGui.Enabled = false
        end
        SendChatMessage("/me ❌ ESP NONAKTIF ❌")
        Notify("❌ ESP", "Dimatikan", 2)
    end
end

-- ==================== AUTO CLICK SYSTEM ====================
local AutoClickConnection = nil

local function ToggleAutoClick()
    Settings.AutoClick = not Settings.AutoClick
    
    if Settings.AutoClick then
        AutoClickConnection = RunService.RenderStepped:Connect(function()
            if Settings.AutoClick then
                VirtualUser:ClickButton1(Vector2.new(500, 500))
                wait(Settings.ClickDelay)
            end
        end)
        SendChatMessage("/me 🖱️ AUTO CLICK AKTIF! Klik otomatis setiap " .. Settings.ClickDelay .. " detik 🖱️")
        Notify("🖱️ AUTO CLICK", "Aktif! Delay: " .. Settings.ClickDelay .. "s", 2)
    else
        if AutoClickConnection then
            AutoClickConnection:Disconnect()
            AutoClickConnection = nil
        end
        SendChatMessage("/me ❌ AUTO CLICK NONAKTIF ❌")
        Notify("❌ AUTO CLICK", "Dimatikan", 2)
    end
end

-- ==================== AUTO FARM SYSTEM ====================
local function StartAutoFarm()
    if AutoFarmActive then
        if AutoFarmConnection then
            AutoFarmConnection:Disconnect()
            AutoFarmConnection = nil
        end
        AutoFarmActive = false
        SendChatMessage("/me ❌ AUTO FARM NONAKTIF ❌")
        Notify("❌ AUTO FARM", "Dimatikan", 2)
        return
    end
    
    AutoFarmActive = true
    SendChatMessage("/me 🌾 AUTO FARM AKTIF! Mencari object terdekat 🌾")
    Notify("🌾 AUTO FARM", "Aktif! Mencari object dalam radius " .. Settings.FarmRadius, 2)
    
    AutoFarmConnection = RunService.RenderStepped:Connect(function()
        if not AutoFarmActive then return end
        
        local rootPart = GetRootPart()
        if not rootPart then return end
        
        local nearestObject = nil
        local nearestDistance = Settings.FarmRadius
        
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("Model") then
                if obj:FindFirstChildOfClass("ClickDetector") or 
                   obj.Name:find("Farm") or obj.Name:find("Crop") or 
                   obj.Name:find("Node") or obj.Name:find("Ore") then
                    
                    local objPos = obj:IsA("Model") and obj.PrimaryPart and obj.PrimaryPart.Position or 
                                   (obj:IsA("BasePart") and obj.Position or nil)
                    
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
        
        if nearestObject and nearestDistance < Settings.FarmRadius then
            local clickDetector = nearestObject:FindFirstChildOfClass("ClickDetector")
            if clickDetector then
                fireclickdetector(clickDetector)
            end
            
            if nearestDistance > 5 then
                rootPart.CFrame = CFrame.new(nearestObject:IsA("BasePart") and nearestObject.Position or 
                                              (nearestObject.PrimaryPart and nearestObject.PrimaryPart.Position or rootPart.Position))
            end
        end
    end)
end

-- ==================== AIMBOT SYSTEM ====================
local AimbotConnection = nil

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
        
        SendChatMessage("/me 🎯 AIMBOT AKTIF! Auto aim ke player terdekat 🎯")
        Notify("🎯 AIMBOT", "Aktif!", 2)
    else
        if AimbotConnection then
            AimbotConnection:Disconnect()
            AimbotConnection = nil
        end
        SendChatMessage("/me ❌ AIMBOT NONAKTIF ❌")
        Notify("❌ AIMBOT", "Dimatikan", 2)
    end
end

-- ==================== RESET SYSTEM ====================
local function ResetAll()
    -- Reset Speed
    local humanoid = GetHumanoid()
    if humanoid then
        humanoid.WalkSpeed = OriginalSpeed
        humanoid.JumpPower = OriginalJump
    end
    
    -- Stop Fly
    if FlyingActive then StopFly() end
    
    -- Turn off all toggles
    Settings.SpeedEnabled = true
    Settings.JumpEnabled = true
    Settings.NoClip = false
    Settings.GodMode = false
    Settings.InfiniteJump = false
    Settings.AutoClick = false
    Settings.AutoFarm = false
    Settings.ESP = false
    Settings.Aimbot = false
    Settings.Speed = OriginalSpeed
    Settings.JumpPower = OriginalJump
    
    -- Disable ESP
    if ESPGui then ESPGui:Destroy() end
    ESPGui = nil
    
    -- Disable Auto Click
    if AutoClickConnection then
        AutoClickConnection:Disconnect()
        AutoClickConnection = nil
    end
    
    -- Disable Auto Farm
    if AutoFarmConnection then
        AutoFarmConnection:Disconnect()
        AutoFarmConnection = nil
    end
    AutoFarmActive = false
    
    -- Disable Aimbot
    if AimbotConnection then
        AimbotConnection:Disconnect()
        AimbotConnection = nil
    end
    
    -- Disable Infinite Jump
    if InfiniteJumpConnection then
        InfiniteJumpConnection:Disconnect()
        InfiniteJumpConnection = nil
    end
    
    SendChatMessage("/me 🔄 SEMUA SETTING DI RESET KE DEFAULT! 🔄")
    Notify("🔄 RESET", "Semua fitur dinonaktifkan", 3)
end

-- ==================== HELP MENU ====================
local function ShowHelp()
    SendChatMessage("/me ╔════════════════════════════════════════╗")
    wait(0.3)
    SendChatMessage("/me ║     🔥 ZONE XD COMMAND LIST 🔥        ║")
    wait(0.3)
    SendChatMessage("/me ╠════════════════════════════════════════╣")
    wait(0.3)
    SendChatMessage("/me ║ /menu     - Tampilkan menu ini         ║")
    wait(0.3)
    SendChatMessage("/me ║ /speed 50 - Set kecepatan              ║")
    wait(0.3)
    SendChatMessage("/me ║ /jump 80  - Set kekuatan lompat        ║")
    wait(0.3)
    SendChatMessage("/me ║ /fly      - Mode terbang (Tekan X)     ║")
    wait(0.3)
    SendChatMessage("/me ║ /noclip   - Tembus tembok              ║")
    wait(0.3)
    SendChatMessage("/me ║ /god      - Mode abadi                 ║")
    wait(0.3)
    SendChatMessage("/me ║ /infjump  - Lompat tak terbatas        ║")
    wait(0.3)
    SendChatMessage("/me ║ /esp      - Wallhack lihat player      ║")
    wait(0.3)
    SendChatMessage("/me ║ /aimbot   - Auto aim ke musuh          ║")
    wait(0.3)
    SendChatMessage("/me ║ /autoclick- Klik otomatis              ║")
    wait(0.3)
    SendChatMessage("/me ║ /autofarm - Auto farming               ║")
    wait(0.3)
    SendChatMessage("/me 🔄 RESET SEMUA - /reset")
    wait(0.3)
    SendChatMessage("/me 📝 KETIK /help UNTUK CARA LENGKAP 📝")
    
    Notify("🎮 ZONE XD", "Menu ditampilkan di chat!", 3)
end

-- ==================== FLY CONTROL SYSTEM ====================
local function SetupFlyControls()
    local inputBegan = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if not FlyingActive then return end
        
        if input.KeyCode == Enum.KeyCode.W then FlyControls.Forward = true end
        if input.KeyCode == Enum.KeyCode.S then FlyControls.Backward = true end
        if input.KeyCode == Enum.KeyCode.A then FlyControls.Left = true end
        if input.KeyCode == Enum.KeyCode.D then FlyControls.Right = true end
        if input.KeyCode == Enum.KeyCode.Space then FlyControls.Up = true end
        if input.KeyCode == Enum.KeyCode.LeftControl then FlyControls.Down = true end
        if input.KeyCode == Enum.KeyCode.X then StopFly() end
    end)
    
    local inputEnded = UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if not FlyingActive then return end
        
        if input.KeyCode == Enum.KeyCode.W then FlyControls.Forward = false end
        if input.KeyCode == Enum.KeyCode.S then FlyControls.Backward = false end
        if input.KeyCode == Enum.KeyCode.A then FlyControls.Left = false end
        if input.KeyCode == Enum.KeyCode.D then FlyControls.Right = false end
        if input.KeyCode == Enum.KeyCode.Space then FlyControls.Up = false end
        if input.KeyCode == Enum.KeyCode.LeftControl then FlyControls.Down = false end
    end)
    
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
        
        FlyBodyVelocity.Velocity = moveDirection * Settings.FlySpeed
        if FlyBodyGyro then FlyBodyGyro.CFrame = rootPart.CFrame end
    end)
end

-- ==================== AUTO UPDATE SPEED & JUMP ====================
RunService.RenderStepped:Connect(function()
    local humanoid = GetHumanoid()
    if not humanoid then return end
    
    -- Auto apply speed
    if Settings.SpeedEnabled and humanoid.WalkSpeed ~= Settings.Speed then
        humanoid.WalkSpeed = Settings.Speed
    end
    
    -- Auto apply jump
    if Settings.JumpEnabled and humanoid.JumpPower ~= Settings.JumpPower then
        humanoid.JumpPower = Settings.JumpPower
    end
    
    -- Auto apply GodMode
    if Settings.GodMode then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        humanoid.BreakJointsOnDeath = false
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    end
    
    -- Auto apply NoClip
    if Settings.NoClip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- ==================== COMMAND PROCESSOR ====================
local function ProcessCommand(msg)
    msg = string.lower(msg)
    
    -- Command: /menu
    if msg == "/menu" then
        ShowSimpleMenu()
        return true
    end
    
    -- Command: /help
    if msg == "/help" then
        ShowHelp()
        return true
    end
    
    -- Command: /speed [value]
    if string.match(msg, "^/speed%d+$") or string.match(msg, "^/speed %d+$") then
        local value = string.match(msg, "%d+")
        SetSpeed(value)
        return true
    end
    
    -- Command: /jump [value]
    if string.match(msg, "^/jump%d+$") or string.match(msg, "^/jump %d+$") then
        local value = string.match(msg, "%d+")
        SetJump(value)
        return true
    end
    
    -- Command: /fly
    if msg == "/fly" then
        StartFly()
        return true
    end
    
    -- Command: /noclip
    if msg == "/noclip" then
        ToggleNoClip()
        return true
    end
    
    -- Command: /god
    if msg == "/god" then
        ToggleGodMode()
        return true
    end
    
    -- Command: /infjump
    if msg == "/infjump" then
        ToggleInfiniteJump()
        return true
    end
    
    -- Command: /esp
    if msg == "/esp" then
        ToggleESP()
        return true
    end
    
    -- Command: /aimbot
    if msg == "/aimbot" then
        ToggleAimbot()
        return true
    end
    
    -- Command: /autoclick
    if msg == "/autoclick" then
        ToggleAutoClick()
        return true
    end
    
    -- Command: /autofarm
    if msg == "/autofarm" then
        StartAutoFarm()
        return true
    end
    
    -- Command: /reset
    if msg == "/reset" then
        ResetAll()
        return true
    end
    
    return false
end

-- ==================== CHAT LISTENER ====================
local function SetupChatListener()
    -- Method 1: TextChatService (New Roblox Chat)
    local success, err = pcall(function()
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
    
    -- Method 2: Legacy Chat (Old Roblox Chat)
    pcall(function()
        local PlayersChat = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Chat")
        if PlayersChat then
            local ChatBar = PlayersChat:FindFirstChild("Frame"):FindFirstChild("ChatBarParentFrame"):FindFirstChild("Frame"):FindFirstChild("BoxFrame"):FindFirstChild("Frame"):FindFirstChild("TextLabel")
            if ChatBar then
                ChatBar:GetPropertyChangedSignal("Text"):Connect(function()
                    if string.sub(ChatBar.Text, 1, 1) == "/" then
                        ProcessCommand(ChatBar.Text)
                    end
                end)
            end
        end
    end)
end

-- ==================== INITIALIZATION ====================
local function Init()
    Notify("🔥 ZONE XD HUB", "Loading...", 2)
    wait(1)
    
    SetupFlyControls()
    SetupChatListener()
    
    SendChatMessage("/me ╔════════════════════════════════════════╗")
    wait(0.3)
    SendChatMessage("/me ║   🔥 ZONE XD UNIVERSAL HUB 🔥         ║")
    wait(0.3)
    SendChatMessage("/me ║   CREATED BY: APIS                    ║")
    wait(0.3)
    SendChatMessage("/me ║   VERSION: 1.0 - FULL COMMAND         ║")
    wait(0.3)
    SendChatMessage("/me ╠════════════════════════════════════════╣")
    wait(0.3)
    SendChatMessage("/me ║   💀 SCRIPT AKTIF! 💀                  ║")
    wait(0.3)
    SendChatMessage("/me ║   KETIK /menu UNTUK LIHAT FITUR        ║")
    wait(0.3)
    SendChatMessage("/me ╚════════════════════════════════════════╝")
    
    Notify("✅ ZONE XD HUB", "Aktif! Ketik /menu di chat", 3)
end

-- Run
Init()