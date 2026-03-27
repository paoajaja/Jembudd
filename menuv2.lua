--[[
    ZONE XD MOBILE V5.1 - EXECUTOR COMPATIBLE
    LIMIT SPEED 200 | JUMP 200
    ESP PRO + INVISIBLE + PROFILE
    FIXED FOR ALL EXECUTORS
    CREATED BY: APIS
--]]

-- ==================== INITIALIZATION ====================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")

-- Cek TextService (biar ga error)
local TextService = pcall(function() return game:GetService("TextChatService") end) and game:GetService("TextChatService") or nil

-- SETTINGS
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
    InvisibleMode = false,
    SpeedEnabled = true,
    JumpEnabled = true,
    ClickDelay = 0.1,
    AutoFarm = false,
    AutoCollect = false,
    SilentAim = false,
    AntiStun = false,
    AutoHeal = false,
    WalkOnWater = false,
    NoFallDamage = false,
    OriginalTransparency = {}
}

-- LIMIT
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
    Forward = false, Backward = false, Left = false, Right = false, Up = false, Down = false
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

-- Touch Fly Controls
local TouchJoystick = nil

-- Teleport History
local TeleportHistory = {}
local TeleportIndex = 0

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
    
    SendAutoReply("/me ╔════════════════════════════════════════════════╗")
    wait(0.1)
    SendAutoReply("/me ║           👤 ZONE XD USER PROFILE 👤           ║")
    wait(0.1)
    SendAutoReply("/me ╠════════════════════════════════════════════════╣")
    wait(0.1)
    SendAutoReply("/me ║ 📛 Username   : " .. LocalPlayer.Name)
    wait(0.1)
    SendAutoReply("/me ║ 🏷️ Display    : " .. LocalPlayer.DisplayName)
    wait(0.1)
    SendAutoReply("/me ║ 🔢 User ID    : " .. LocalPlayer.UserId)
    wait(0.1)
    SendAutoReply("/me ║ 👥 Team       : " .. (LocalPlayer.Team and LocalPlayer.Team.Name or "No Team"))
    wait(0.1)
    SendAutoReply("/me ╠════════════════════════════════════════════════╣")
    wait(0.1)
    SendAutoReply("/me ║ ⚙️ ACTIVE FEATURES:                           ║")
    wait(0.1)
    SendAutoReply("/me ║ " .. activeText)
    wait(0.1)
    SendAutoReply("/me ╠════════════════════════════════════════════════╣")
    wait(0.1)
    SendAutoReply("/me ║ 💀 ZONE XD V5.1 ULTIMATE 💀                    ║")
    wait(0.1)
    SendAutoReply("/me ║ CREATED BY: APIS                               ║")
    wait(0.1)
    SendAutoReply("/me ╚════════════════════════════════════════════════╝")
    
    Notify("👤 PROFILE", LocalPlayer.Name .. " | " .. (#activeFeatures) .. " fitur aktif", 4)
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
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("Part") then
                Settings.OriginalTransparency[part] = part.Transparency
                part.Transparency = 1
            end
        end
        SendAutoReply("/me 👻 INVISIBLE MODE AKTIF! 👻")
        Notify("👻 INVISIBLE", "Kamu tidak terlihat!", 3)
    else
        for part, trans in pairs(Settings.OriginalTransparency) do
            pcall(function() part.Transparency = trans end)
        end
        Settings.OriginalTransparency = {}
        SendAutoReply("/me 👁️ INVISIBLE MODE NONAKTIF 👁️")
        Notify("👁️ INVISIBLE", "Mode invisible dimatikan", 2)
    end
end

-- Auto refresh invisible
LocalPlayer.CharacterAdded:Connect(function(char)
    if Settings.InvisibleMode then
        task.wait(0.5)
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("MeshPart") then
                part.Transparency = 1
            end
        end
    end
end)

-- ==================== SPEED & JUMP ====================
local function SetSpeed(value)
    value = tonumber(value)
    if not value then
        SendAutoReply("/me ⚠️ FORMAT: /speed [1-200] ⚠️")
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
        SendAutoReply("/me ⚠️ FORMAT: /jump [30-200] ⚠️")
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

-- ==================== FLY SYSTEM ====================
local function StopFly()
    if FlyBodyVelocity then pcall(function() FlyBodyVelocity:Destroy() end) end
    if FlyBodyGyro then pcall(function() FlyBodyGyro:Destroy() end) end
    FlyBodyVelocity = nil
    FlyBodyGyro = nil
    
    local humanoid = GetHumanoid()
    if humanoid then humanoid.PlatformStand = false end
    
    FlyingActive = false
    if TouchJoystick then pcall(function() TouchJoystick:Destroy() end) end
    TouchJoystick = nil
    
    SendAutoReply("/me 🕊️ FLY MODE NONAKTIF 🕊️")
    Notify("🕊️ FLY", "Mode terbang dimatikan", 2)
end

local function StartFly()
    if FlyingActive then StopFly(); return end
    
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
        if v:IsA("BasePart") then v.CanCollide = false end
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
    FlyControls = {Forward=false, Backward=false, Left=false, Right=false, Up=false, Down=false}
    
    -- Joystick sederhana
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ZoneXDFly"
    ScreenGui.Parent = game.CoreGui
    
    local JoystickBg = Instance.new("Frame")
    JoystickBg.Size = UDim2.new(0, 120, 0, 120)
    JoystickBg.Position = UDim2.new(0, 15, 1, -140)
    JoystickBg.BackgroundColor3 = Color3.fromRGB(30,30,40)
    JoystickBg.BackgroundTransparency = 0.5
    JoystickBg.BorderSizePixel = 2
    JoystickBg.BorderRadius = UDim.new(1,60)
    JoystickBg.Parent = ScreenGui
    
    local Joystick = Instance.new("Frame")
    Joystick.Size = UDim2.new(0, 50, 0, 50)
    Joystick.Position = UDim2.new(0.5, -25, 0.5, -25)
    Joystick.BackgroundColor3 = Color3.fromRGB(255,100,0)
    Joystick.BackgroundTransparency = 0.3
    Joystick.BorderRadius = UDim.new(1,25)
    Joystick.Parent = JoystickBg
    
    local StopBtn = Instance.new("TextButton")
    StopBtn.Size = UDim2.new(0, 60, 0, 60)
    StopBtn.Position = UDim2.new(1, -75, 0, 15)
    StopBtn.BackgroundColor3 = Color3.fromRGB(255,50,50)
    StopBtn.BackgroundTransparency = 0.3
    StopBtn.BorderRadius = UDim.new(1,30)
    StopBtn.Text = "🛑"
    StopBtn.TextSize = 30
    StopBtn.Parent = ScreenGui
    StopBtn.MouseButton1Click:Connect(function() StopFly() end)
    
    local UpBtn = Instance.new("TextButton")
    UpBtn.Size = UDim2.new(0, 65, 0, 65)
    UpBtn.Position = UDim2.new(1, -80, 0.5, -80)
    UpBtn.BackgroundColor3 = Color3.fromRGB(0,150,255)
    UpBtn.BackgroundTransparency = 0.3
    UpBtn.BorderRadius = UDim.new(1,32.5)
    UpBtn.Text = "⬆️"
    UpBtn.TextSize = 35
    UpBtn.Parent = ScreenGui
    
    local DownBtn = Instance.new("TextButton")
    DownBtn.Size = UDim2.new(0, 65, 0, 65)
    DownBtn.Position = UDim2.new(1, -80, 0.85, -32.5)
    DownBtn.BackgroundColor3 = Color3.fromRGB(0,150,255)
    DownBtn.BackgroundTransparency = 0.3
    DownBtn.BorderRadius = UDim.new(1,32.5)
    DownBtn.Text = "⬇️"
    DownBtn.TextSize = 35
    DownBtn.Parent = ScreenGui
    
    UpBtn.MouseButton1Down:Connect(function() FlyControls.Up = true end)
    UpBtn.MouseButton1Up:Connect(function() FlyControls.Up = false end)
    DownBtn.MouseButton1Down:Connect(function() FlyControls.Down = true end)
    DownBtn.MouseButton1Up:Connect(function() FlyControls.Down = false end)
    
    local dragging = false
    local dragStart, startPos
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
        FlyControls.Forward, FlyControls.Backward, FlyControls.Left, FlyControls.Right = false, false, false, false
    end)
    JoystickBg.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            local newX = math.clamp(startPos.X.Offset + delta.X, -55, 55)
            local newY = math.clamp(startPos.Y.Offset + delta.Y, -55, 55)
            Joystick.Position = UDim2.new(0.5, newX, 0.5, newY)
            local normX, normY = newX/55, newY/55
            FlyControls.Forward = normY < -0.3
            FlyControls.Backward = normY > 0.3
            FlyControls.Left = normX < -0.3
            FlyControls.Right = normX > 0.3
        end
    end)
    
    TouchJoystick = ScreenGui
    
    SendAutoReply("/me 🕊️ FLY MODE AKTIF! 🕊️")
    Notify("🕊️ FLY", "Mode terbang aktif!", 3)
end

-- Fly movement
RunService.RenderStepped:Connect(function()
    if not FlyingActive or not FlyBodyVelocity then return end
    local rootPart = GetRootPart()
    if not rootPart then return end
    local moveDirection = Vector3.new(0,0,0)
    if FlyControls.Forward then moveDirection = moveDirection + rootPart.CFrame.LookVector end
    if FlyControls.Backward then moveDirection = moveDirection - rootPart.CFrame.LookVector end
    if FlyControls.Right then moveDirection = moveDirection + rootPart.CFrame.RightVector end
    if FlyControls.Left then moveDirection = moveDirection - rootPart.CFrame.RightVector end
    if FlyControls.Up then moveDirection = moveDirection + Vector3.new(0,1,0) end
    if FlyControls.Down then moveDirection = moveDirection - Vector3.new(0,1,0) end
    FlyBodyVelocity.Velocity = moveDirection * MAX_FLY_SPEED
    if FlyBodyGyro then FlyBodyGyro.CFrame = rootPart.CFrame end
end)

-- ==================== ESP PRO ====================
local function ToggleESP()
    Settings.ESP = not Settings.ESP
    if Settings.ESP then
        if ESPGui then pcall(function() ESPGui:Destroy() end) end
        ESPGui = Instance.new("ScreenGui")
        ESPGui.Name = "ZoneXD_ESP"
        ESPGui.Parent = game.CoreGui
        
        local myTeam = LocalPlayer.Team
        local function AddPlayer(player)
            if player == LocalPlayer then return end
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 70, 0, 70)
            frame.BackgroundTransparency = 0.4
            frame.BorderSizePixel = 2
            frame.Parent = ESPGui
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Text = player.Name
            nameLabel.TextColor3 = Color3.fromRGB(255,255,255)
            nameLabel.BackgroundColor3 = Color3.fromRGB(0,0,0)
            nameLabel.BackgroundTransparency = 0.5
            nameLabel.TextScaled = true
            nameLabel.Size = UDim2.new(1,0,0,20)
            nameLabel.Parent = frame
            
            local healthBar = Instance.new("Frame")
            healthBar.Size = UDim2.new(1,0,0,5)
            healthBar.BackgroundColor3 = Color3.fromRGB(0,255,0)
            healthBar.BorderSizePixel = 0
            healthBar.Position = UDim2.new(0,0,1,-7)
            healthBar.Parent = frame
            
            local distLabel = Instance.new("TextLabel")
            distLabel.Text = ""
            distLabel.TextColor3 = Color3.fromRGB(255,255,255)
            distLabel.BackgroundTransparency = 1
            distLabel.TextSize = 11
            distLabel.Position = UDim2.new(0,0,1,2)
            distLabel.Size = UDim2.new(1,0,0,15)
            distLabel.Parent = frame
            
            ESPFrames[player] = {frame=frame, healthBar=healthBar, distLabel=distLabel}
        end
        
        for _, p in pairs(Players:GetPlayers()) do AddPlayer(p) end
        Players.PlayerAdded:Connect(AddPlayer)
        Players.PlayerRemoving:Connect(function(p) if ESPFrames[p] then ESPFrames[p].frame:Destroy() ESPFrames[p]=nil end end)
        
        RunService.RenderStepped:Connect(function()
            if not Settings.ESP then return end
            local camera = workspace.CurrentCamera
            local myTeam = LocalPlayer.Team
            local rootPart = GetRootPart()
            for p, data in pairs(ESPFrames) do
                if p.Character and p.Character:FindFirstChild("Head") then
                    local headPos = p.Character.Head.Position
                    local pos, onScreen = camera:WorldToViewportPoint(headPos)
                    local dist = rootPart and (rootPart.Position - headPos).Magnitude or 100
                    if onScreen then
                        local scale = 90 / math.max(dist, 10)
                        local size = math.clamp(70 * scale, 40, 110)
                        data.frame.Size = UDim2.new(0, size, 0, size)
                        data.frame.Position = UDim2.new(0, pos.X - size/2, 0, pos.Y - size/2)
                        data.frame.Visible = true
                        data.distLabel.Text = math.floor(dist) .. "m"
                        if p.Team == myTeam then
                            data.frame.BackgroundColor3 = Color3.fromRGB(0,200,0)
                            data.frame.BorderColor3 = Color3.fromRGB(0,200,0)
                        else
                            data.frame.BackgroundColor3 = Color3.fromRGB(200,0,0)
                            data.frame.BorderColor3 = Color3.fromRGB(200,0,0)
                        end
                        local hum = p.Character:FindFirstChildOfClass("Humanoid")
                        if hum then
                            local hp = hum.Health / hum.MaxHealth
                            data.healthBar.Size = UDim2.new(hp, 0, 0, 5)
                            if hp > 0.6 then data.healthBar.BackgroundColor3 = Color3.fromRGB(0,255,0)
                            elseif hp > 0.3 then data.healthBar.BackgroundColor3 = Color3.fromRGB(255,255,0)
                            else data.healthBar.BackgroundColor3 = Color3.fromRGB(255,0,0) end
                        end
                    else
                        data.frame.Visible = false
                    end
                else
                    data.frame.Visible = false
                end
            end
        end)
        SendAutoReply("/me 👁️ ESP PRO AKTIF! 👁️")
        Notify("👁️ ESP PRO", "ESP dengan health bar & jarak aktif!", 2)
    else
        if ESPGui then ESPGui:Destroy() end
        ESPGui = nil
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
            if v:IsA("BasePart") then v.CanCollide = not Settings.NoClip end
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
        local hum = GetHumanoid()
        if hum then hum.MaxHealth, hum.Health, hum.BreakJointsOnDeath = math.huge, math.huge, false end
        SendAutoReply("/me 🛡️ GOD MODE AKTIF! 🛡️")
        Notify("🛡️ GOD MODE", "Kamu abadi!", 2)
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
            local hum = GetHumanoid()
            if hum and hum:GetState() ~= Enum.HumanoidStateType.Jumping then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        SendAutoReply("/me ♾️ INFINITE JUMP AKTIF! ♾️")
        Notify("♾️ INFINITE JUMP", "Lompat tanpa batas!", 2)
    else
        if InfiniteJumpConnection then InfiniteJumpConnection:Disconnect() end
        InfiniteJumpConnection = nil
        SendAutoReply("/me ❌ INFINITE JUMP NONAKTIF ❌")
        Notify("❌ INFINITE JUMP", "Dimatikan", 2)
    end
end

-- ==================== TELEPORT ====================
local function TeleportTo(pos)
    local root = GetRootPart()
    if root then
        TeleportIndex = TeleportIndex + 1
        TeleportHistory[TeleportIndex] = root.CFrame
        root.CFrame = CFrame.new(pos)
        SendAutoReply("/me ✨ TELEPORT BERHASIL! ✨")
        Notify("✨ TELEPORT", "Berhasil teleport!", 2)
    end
end

local function TeleportBack()
    if TeleportIndex > 0 then
        local root = GetRootPart()
        if root and TeleportHistory[TeleportIndex] then
            root.CFrame = TeleportHistory[TeleportIndex]
            TeleportHistory[TeleportIndex] = nil
            TeleportIndex = TeleportIndex - 1
            SendAutoReply("/me ↩️ TELEPORT BACK! ↩️")
            Notify("↩️ TELEPORT", "Kembali ke posisi sebelumnya", 2)
        end
    else
        SendAutoReply("/me ⚠️ TIDAK ADA HISTORY! ⚠️")
    end
end

local function TeleportToPlayer(name)
    for _, p in pairs(Players:GetPlayers()) do
        if string.lower(p.Name):find(string.lower(name)) and p ~= LocalPlayer then
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                TeleportTo(p.Character.HumanoidRootPart.Position)
                return
            end
        end
    end
    SendAutoReply("/me ❌ PLAYER TIDAK DITEMUKAN! ❌")
end

-- ==================== AUTO FARM ====================
local function ToggleAutoFarm()
    Settings.AutoFarm = not Settings.AutoFarm
    if Settings.AutoFarm then
        if AutoFarmConnection then AutoFarmConnection:Disconnect() end
        AutoFarmConnection = RunService.RenderStepped:Connect(function()
            if not Settings.AutoFarm then return end
            local root = GetRootPart()
            if not root then return end
            local nearest, dist = nil, 50
            for _, obj in pairs(workspace:GetDescendants()) do
                if (obj:IsA("Part") or obj:IsA("MeshPart")) and (obj:FindFirstChildOfClass("ClickDetector") or obj.Name:find("Farm") or obj.Name:find("Crop") or obj.Name:find("Node") or obj.Name:find("Ore")) then
                    local d = (root.Position - obj.Position).Magnitude
                    if d < dist then dist, nearest = d, obj end
                end
            end
            if nearest and dist < 50 then
                local cd = nearest:FindFirstChildOfClass("ClickDetector")
                if cd then pcall(function() fireclickdetector(cd) end) end
                if dist > 4 then root.CFrame = CFrame.new(nearest.Position + Vector3.new(0,2,0)) end
            end
        end)
        SendAutoReply("/me 🌾 AUTO FARM AKTIF! 🌾")
        Notify("🌾 AUTO FARM", "Auto farming aktif!", 2)
    else
        if AutoFarmConnection then AutoFarmConnection:Disconnect() end
        AutoFarmConnection = nil
        SendAutoReply("/me ❌ AUTO FARM NONAKTIF ❌")
        Notify("❌ AUTO FARM", "Dimatikan", 2)
    end
end

-- ==================== AUTO COLLECT ====================
local function ToggleAutoCollect()
    Settings.AutoCollect = not Settings.AutoCollect
    if Settings.AutoCollect then
        if AutoCollectConnection then AutoCollectConnection:Disconnect() end
        AutoCollectConnection = RunService.RenderStepped:Connect(function()
            if not Settings.AutoCollect then return end
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Part") and obj:FindFirstChildOfClass("ClickDetector") then
                    if obj.Name:find("Coin") or obj.Name:find("Gem") or obj.Name:find("Item") or obj.Name:find("Drop") then
                        local d = (GetRootPart() and GetRootPart().Position - obj.Position).Magnitude or 999
                        if d < 20 then pcall(function() fireclickdetector(obj:FindFirstChildOfClass("ClickDetector")) end) end
                    end
                end
            end
        end)
        SendAutoReply("/me 💰 AUTO COLLECT AKTIF! 💰")
        Notify("💰 AUTO COLLECT", "Auto collect aktif!", 2)
    else
        if AutoCollectConnection then AutoCollectConnection:Disconnect() end
        AutoCollectConnection = nil
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
            local cam = workspace.CurrentCamera
            local closest, closestDist = nil, 500
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    local pos, onScreen = cam:WorldToViewportPoint(p.Character.Head.Position)
                    local d = (Vector2.new(pos.X, pos.Y) - Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)).Magnitude
                    if onScreen and d < closestDist then closestDist, closest = d, p end
                end
            end
            if closest and closest.Character and closest.Character:FindFirstChild("Head") then
                cam.CFrame = CFrame.new(cam.CFrame.Position, closest.Character.Head.Position)
            end
        end)
        SendAutoReply("/me 🎯 SILENT AIM AKTIF! 🎯")
        Notify("🎯 SILENT AIM", "Auto aim aktif!", 2)
    else
        if AimbotConnection then AimbotConnection:Disconnect() end
        AimbotConnection = nil
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
            local hum = GetHumanoid()
            if hum then
                if hum:GetState() == Enum.HumanoidStateType.FallingDown or hum:GetState() == Enum.HumanoidStateType.Ragdoll or hum:GetState() == Enum.HumanoidStateType.Stunned then
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                end
                hum.Sit = false
            end
        end)
        SendAutoReply("/me 💪 ANTI STUN AKTIF! 💪")
        Notify("💪 ANTI STUN", "Tidak bisa di-stun!", 2)
    else
        if AntiStunConnection then AntiStunConnection:Disconnect() end
        AntiStunConnection = nil
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
            local hum = GetHumanoid()
            if hum and hum.Health < hum.MaxHealth * 0.7 then hum.Health = hum.MaxHealth end
        end)
        SendAutoReply("/me 💚 AUTO HEAL AKTIF! 💚")
        Notify("💚 AUTO HEAL", "Auto heal aktif!", 2)
    else
        if AutoHealConnection then AutoHealConnection:Disconnect() end
        AutoHealConnection = nil
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
            local root = GetRootPart()
            if root and root.Position.Y < 5 then
                local ray = Ray.new(root.Position, Vector3.new(0, -3, 0))
                local hit = workspace:FindPartOnRay(ray, root)
                if hit and hit.Material == Enum.Material.Water then
                    root.CFrame = CFrame.new(root.Position.X, 5, root.Position.Z)
                end
            end
        end)
        SendAutoReply("/me 💧 WALK ON WATER AKTIF! 💧")
        Notify("💧 WALK ON WATER", "Bisa jalan di air!", 2)
    else
        if WalkOnWaterConnection then WalkOnWaterConnection:Disconnect() end
        WalkOnWaterConnection = nil
        SendAutoReply("/me ❌ WALK ON WATER NONAKTIF ❌")
        Notify("❌ WALK ON WATER", "Dimatikan", 2)
    end
end

-- ==================== NO FALL DAMAGE ====================
local function ToggleNoFallDamage()
    Settings.NoFallDamage = not Settings.NoFallDamage
    if Settings.NoFallDamage then
        if NoFallDamageConnection then NoFallDamageConnection:Disconnect() end
        NoFallDamageConnection = RunService.RenderStepped:Connect(function()
            if not Settings.NoFallDamage then return end
            local hum = GetHumanoid()
            if hum then hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false) end
        end)
        SendAutoReply("/me 🪂 NO FALL DAMAGE AKTIF! 🪂")
        Notify("🪂 NO FALL DAMAGE", "Jatuh ga mati!", 2)
    else
        if NoFallDamageConnection then NoFallDamageConnection:Disconnect() end
        NoFallDamageConnection = nil
        local hum = GetHumanoid()
        if hum then hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true) end
        SendAutoReply("/me ❌ NO FALL DAMAGE NONAKTIF ❌")
        Notify("❌ NO FALL DAMAGE", "Dimatikan", 2)
    end
end

-- ==================== AUTO CLICK ====================
local function ToggleAutoClick()
    Settings.AutoClick = not Settings.AutoClick
    if Settings.AutoClick then
        if AutoClickConnection then AutoClickConnection:Disconnect() end
        AutoClickConnection = RunService.RenderStepped:Connect(function()
            if Settings.AutoClick then
                pcall(function() VirtualUser:ClickButton1(Vector2.new(500,500)) end)
                task.wait(Settings.ClickDelay)
            end
        end)
        SendAutoReply("/me 🖱️ AUTO CLICK AKTIF! 🖱️")
        Notify("🖱️ AUTO CLICK", "Auto click aktif!", 2)
    else
        if AutoClickConnection then AutoClickConnection:Disconnect() end
        AutoClickConnection = nil
        SendAutoReply("/me ❌ AUTO CLICK NONAKTIF ❌")
        Notify("❌ AUTO CLICK", "Dimatikan", 2)
    end
end

-- ==================== RESET ====================
local function ResetAll()
    local hum = GetHumanoid()
    if hum then
        hum.WalkSpeed, hum.JumpPower, hum.MaxHealth, hum.Health, hum.BreakJointsOnDeath = OriginalSpeed, OriginalJump, 100, 100, true
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        hum.PlatformStand = false
    end
    
    if FlyingActive then StopFly() end
    
    if LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = true end
        end
    end
    
    if TouchJoystick then pcall(function() TouchJoystick:Destroy() end) end
    if ESPGui then ESPGui:Destroy() end
    
    if Settings.InvisibleMode then
        for part, trans in pairs(Settings.OriginalTransparency) do
            pcall(function() part.Transparency = trans end)
        end
        Settings.OriginalTransparency = {}
    end
    
    Settings = {
        Speed = OriginalSpeed, JumpPower = OriginalJump, FlySpeed = 100, Flying = false, NoClip = false,
        GodMode = false, InfiniteJump = false, AutoClick = false, ESP = false, InvisibleMode = false,
        SpeedEnabled = true, JumpEnabled = true, ClickDelay = 0.1, AutoFarm = false, AutoCollect = false,
        SilentAim = false, AntiStun = false, AutoHeal = false, WalkOnWater = false, NoFallDamage = false,
        OriginalTransparency = {}
    }
    
    if AutoClickConnection then AutoClickConnection:Disconnect() end
    if AimbotConnection then AimbotConnection:Disconnect() end
    if InfiniteJumpConnection then InfiniteJumpConnection:Disconnect() end
    if AutoFarmConnection then AutoFarmConnection:Disconnect() end
    if AutoCollectConnection then AutoCollectConnection:Disconnect() end
    if AntiStunConnection then AntiStunConnection:Disconnect() end
    if AutoHealConnection then AutoHealConnection:Disconnect() end
    if NoFallDamageConnection then NoFallDamageConnection:Disconnect() end
    if WalkOnWaterConnection then WalkOnWaterConnection:Disconnect() end
    
    ESPGui, TouchJoystick = nil, nil
    ESPFrames = {}
    TeleportHistory, TeleportIndex = {}, 0
    
    SendAutoReply("/me 🔄 SEMUA FITUR DI RESET! 🔄")
    Notify("🔄 RESET", "Semua fitur dinonaktifkan", 3)
end

-- ==================== MENU ====================
local function ShowMenu()
    SendAutoReply("/me ╔════════════════════════════════════════════════╗")
    wait(0.1)
    SendAutoReply("/me ║     🔥 ZONE XD V5.1 ULTIMATE 🔥               ║")
    wait(0.1)
    SendAutoReply("/me ║     CREATED BY: APIS                          ║")
    wait(0.1)
    SendAutoReply("/me ╠════════════════════════════════════════════════╣")
    wait(0.1)
    SendAutoReply("/me ║ 👤 /profile   - Lihat profil akun              ║")
    wait(0.1)
    SendAutoReply("/me ║ ⚡ /speed 1-200 - Set kecepatan                ║")
    wait(0.1)
    SendAutoReply("/me ║ 🦘 /jump 30-200 - Set kekuatan lompat          ║")
    wait(0.1)
    SendAutoReply("/me ║ 🕊️ /fly        - Mode terbang + joystick       ║")
    wait(0.1)
    SendAutoReply("/me ║ 🔓 /noclip     - Tembus tembok                 ║")
    wait(0.1)
    SendAutoReply("/me ║ 🛡️ /god        - Mode abadi                     ║")
    wait(0.1)
    SendAutoReply("/me ║ ♾️ /infjump    - Lompat tanpa batas             ║")
    wait(0.1)
    SendAutoReply("/me ║ 👁️ /esp        - ESP PRO (health + jarak)       ║")
    wait(0.1)
    SendAutoReply("/me ║ 👻 /invisible  - Mode tidak terlihat           ║")
    wait(0.1)
    SendAutoReply("/me ║ 🎯 /silentaim  - Auto aim                       ║")
    wait(0.1)
    SendAutoReply("/me ║ 💪 /antistun   - Anti stun                      ║")
    wait(0.1)
    SendAutoReply("/me ║ 💚 /autoheal   - Auto heal                      ║")
    wait(0.1)
    SendAutoReply("/me ║ 🌾 /autofarm   - Auto farming                   ║")
    wait(0.1)
    SendAutoReply("/me ║ 💰 /autocollect- Auto collect item              ║")
    wait(0.1)
    SendAutoReply("/me ║ ✨ /tp X Y Z   - Teleport ke koordinat          ║")
    wait(0.1)
    SendAutoReply("/me ║ ✨ /tp Nama    - Teleport ke player             ║")
    wait(0.1)
    SendAutoReply("/me ║ ↩️ /tpback     - Kembali ke posisi sebelumnya   ║")
    wait(0.1)
    SendAutoReply("/me ║ 💧 /walkwater  - Jalan di atas air              ║")
    wait(0.1)
    SendAutoReply("/me ║ 🪂 /nofalldmg  - No fall damage                 ║")
    wait(0.1)
    SendAutoReply("/me ║ 🖱️ /autoclick  - Auto klik                      ║")
    wait(0.1)
    SendAutoReply("/me ║ 🔄 /reset      - Reset semua fitur              ║")
    wait(0.1)
    SendAutoReply("/me ╚════════════════════════════════════════════════╝")
    Notify("🎮 ZONE XD V5.1", "Menu ditampilkan di chat!", 5)
end

-- ==================== COMMAND PROCESSOR ====================
local function ProcessCommand(msg)
    local lower = string.lower(msg)
    if lower == "/menu" then ShowMenu() return true end
    if lower == "/profile" then ShowProfile() return true end
    if lower == "/fly" then StartFly() return true end
    if lower == "/noclip" then ToggleNoClip() return true end
    if lower == "/god" then ToggleGodMode() return true end
    if lower == "/infjump" then ToggleInfiniteJump() return true end
    if lower == "/esp" then ToggleESP() return true end
    if lower == "/invisible" then ToggleInvisible() return true end
    if lower == "/silentaim" then ToggleSilentAim() return true end
    if lower == "/antistun" then ToggleAntiStun() return true end
    if lower == "/autoheal" then ToggleAutoHeal() return true end
    if lower == "/autofarm" then ToggleAutoFarm() return true end
    if lower == "/autocollect" then ToggleAutoCollect() return true end
    if lower == "/walkwater" then ToggleWalkOnWater() return true end
    if lower == "/nofalldmg" then ToggleNoFallDamage() return true end
    if lower == "/autoclick" then ToggleAutoClick() return true end
    if lower == "/reset" then ResetAll() return true end
    if lower == "/tpback" then TeleportBack() return true end
    
    if string.match(lower, "^/speed") then
        local v = string.match(lower, "%d+")
        if v then SetSpeed(v) else SendAutoReply("/me ⚠️ Format: /speed [1-200] ⚠️") end
        return true
    end
    if string.match(lower, "^/jump") then
        local v = string.match(lower, "%d+")
        if v then SetJump(v) else SendAutoReply("/me ⚠️ Format: /jump [30-200] ⚠️") end
        return true
    end
    if string.match(lower, "^/tp [%a_]+") then
        local name = string.match(lower, "^/tp (.+)")
        if name then TeleportToPlayer(name) end
        return true
    end
    if string.match(lower, "^/tp [%d%-]+") then
        local coords = {}
        for x in string.gmatch(lower, "[-]?%d+") do table.insert(coords, tonumber(x)) end
        if #coords >= 3 then TeleportTo(Vector3.new(coords[1], coords[2], coords[3]))
        else SendAutoReply("/me ⚠️ Format: /tp X Y Z ⚠️") end
        return true
    end
    return false
end

-- ==================== CHAT LISTENER ====================
local function SetupChatListener()
    pcall(function()
        if TextService and TextService.TextChannels then
            for _, ch in pairs(TextService.TextChannels:GetChildren()) do
                if ch:IsA("TextChannel") then
                    ch.MessageReceived:Connect(function(msg)
                        if msg.TextSource and msg.TextSource.UserId == LocalPlayer.UserId then
                            ProcessCommand(msg.Text)
                        end
                    end)
                end
            end
        end
    end)
end

-- ==================== AUTO UPDATE ====================
RunService.RenderStepped:Connect(function()
    local hum = GetHumanoid()
    if not hum then return end
    if Settings.SpeedEnabled and hum.WalkSpeed ~= Settings.Speed then hum.WalkSpeed = Settings.Speed end
    if Settings.JumpEnabled and hum.JumpPower ~= Settings.JumpPower then hum.JumpPower = Settings.JumpPower end
    if Settings.GodMode then hum.MaxHealth, hum.Health, hum.BreakJointsOnDeath = math.huge, math.huge, false end
    if Settings.NoClip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- ==================== INIT ====================
local function Init()
    Notify("🔥 ZONE XD V5.1", "Loading...", 2)
    task.wait(1)
    SetupChatListener()
    SendAutoReply("/me ╔════════════════════════════════════════╗")
    task.wait(0.15)
    SendAutoReply("/me ║  🔥 ZONE XD V5.1 ULTIMATE 🔥          ║")
    task.wait(0.15)
    SendAutoReply("/me ║  CREATED BY: APIS                     ║")
    task.wait(0.15)
    SendAutoReply("/me ║  SPEED MAX: 200 | JUMP MAX: 200       ║")
    task.wait(0.15)
    SendAutoReply("/me ║  ESP PRO | INVISIBLE | PROFILE        ║")
    task.wait(0.15)
    SendAutoReply("/me ╠════════════════════════════════════════╣")
    task.wait(0.15)
    SendAutoReply("/me ║  💀 SCRIPT AKTIF! 💀                   ║")
    task.wait(0.15)
    SendAutoReply("/me ║  KETIK /menu UNTUK LIHAT FITUR        ║")
    task.wait(0.15)
    SendAutoReply("/me ║  KETIK /profile UNTUK DATA AKUN       ║")
    task.wait(0.15)
    SendAutoReply("/me ╚════════════════════════════════════════╝")
    Notify("✅ ZONE XD V5.1", "Aktif! Ketik /menu atau /profile", 4)
end

Init()