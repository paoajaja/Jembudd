-- ZONE XD V7.1 - FIXED FOR ALL EXECUTORS
-- UNLOCK: /zonexd111
-- BY: APIS

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- PASSWORD
local PASSWORD = "zonexd111"
local isUnlocked = false
local unlockedMessageSent = false

-- SETTINGS
local Settings = {
    Speed = 16, JumpPower = 50, FlySpeed = 100, Flying = false,
    NoClip = false, GodMode = false, InfiniteJump = false, AutoClick = false,
    ESP = false, InvisibleMode = false, Aimlock = false, AutoPunch = false,
    AutoParry = false, Chams = false, FOV = 150, SpeedEnabled = true,
    JumpEnabled = true, ClickDelay = 0.1, AutoFarm = false, AutoCollect = false,
    SilentAim = false, AntiStun = false, AutoHeal = false, WalkOnWater = false,
    NoFallDamage = false, OriginalTransparency = {}
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
local FlyControls = {Forward=false, Backward=false, Left=false, Right=false, Up=false, Down=false}
local FlyRenderConnection = nil

-- ESP
local ESPGui = nil
local ESPFrames = {}

-- Chams
local ChamsObjects = {}

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
local AimlockConnection = nil
local AutoPunchConnection = nil
local AutoParryConnection = nil

-- Joystick
local TouchJoystick = nil

-- Teleport
local TeleportHistory = {}
local TeleportIndex = 0

-- ==================== UTILITY ====================

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

local function SendChat(msg)
    pcall(function()
        -- Method 1: ReplicatedStorage
        local rs = game:GetService("ReplicatedStorage")
        local chatEvent = rs:FindFirstChild("DefaultChatSystemChatEvents") or rs:FindFirstChild("SayMessageRequest")
        if chatEvent then
            local sayEvent = chatEvent:FindFirstChild("SayMessageRequest")
            if sayEvent then
                sayEvent:FireServer(msg, "All")
                return
            end
        end
        -- Method 2: TextChatService
        local tcs = game:GetService("TextChatService")
        if tcs and tcs.TextChannels then
            for _, ch in pairs(tcs.TextChannels:GetChildren()) do
                if ch:IsA("TextChannel") then
                    ch:SendAsync(msg)
                    break
                end
            end
        end
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

-- ==================== PASSWORD SYSTEM ====================

local function ShowLockedMessage()
    SendChat("/me ╔════════════════════════════════════════╗")
    wait(0.3)
    SendChat("/me ║     🔒 ZONE XD V7 - TERKUNCI 🔒       ║")
    wait(0.3)
    SendChat("/me ╠════════════════════════════════════════╣")
    wait(0.3)
    SendChat("/me ║  🛡️ SILAKAN MASUKKAN PASSWORD 🛡️     ║")
    wait(0.3)
    SendChat("/me ║                                        ║")
    wait(0.3)
    SendChat("/me ║  KETIK: /zonexd111                    ║")
    wait(0.3)
    SendChat("/me ║                                        ║")
    wait(0.3)
    SendChat("/me ║  (PASSWORD TIDAK DITAMPILKAN)         ║")
    wait(0.3)
    SendChat("/me ╚════════════════════════════════════════╝")
    Notify("🔒 TERKUNCI", "Ketik /zonexd111 untuk unlock", 5)
end

local function Unlock()
    isUnlocked = true
    SendChat("/me ╔════════════════════════════════════════╗")
    wait(0.2)
    SendChat("/me ║     ✅ PASSWORD BENAR! ✅              ║")
    wait(0.2)
    SendChat("/me ║     🔓 ZONE XD V7 UNLOCKED 🔓          ║")
    wait(0.2)
    SendChat("/me ╠════════════════════════════════════════╣")
    wait(0.2)
    SendChat("/me ║  💀 SCRIPT AKTIF! 💀                   ║")
    wait(0.2)
    SendChat("/me ║  KETIK /menu UNTUK LIHAT FITUR        ║")
    wait(0.2)
    SendChat("/me ║  KETIK /profile UNTUK DATA AKUN       ║")
    wait(0.2)
    SendChat("/me ╚════════════════════════════════════════╝")
    Notify("🔓 UNLOCKED", "Zone XD V7 aktif!", 4)
end

-- ==================== PROFILE ====================
local function ShowProfile()
    if not isUnlocked then ShowLockedMessage() return end
    
    local active = {}
    if Settings.Speed ~= 16 then table.insert(active, "⚡ Speed: "..Settings.Speed) end
    if Settings.JumpPower ~= 50 then table.insert(active, "🦘 Jump: "..Settings.JumpPower) end
    if Settings.Flying then table.insert(active, "🕊️ Fly") end
    if Settings.NoClip then table.insert(active, "🔓 NoClip") end
    if Settings.GodMode then table.insert(active, "🛡️ GodMode") end
    if Settings.InfiniteJump then table.insert(active, "♾️ InfJump") end
    if Settings.ESP then table.insert(active, "👁️ ESP") end
    if Settings.InvisibleMode then table.insert(active, "👻 Invisible") end
    if Settings.Aimlock then table.insert(active, "🎯 Aimlock") end
    if Settings.AutoPunch then table.insert(active, "👊 AutoPunch") end
    if Settings.AutoParry then table.insert(active, "🛡️ AutoParry") end
    if Settings.Chams then table.insert(active, "✨ Chams") end
    
    local activeText = #active > 0 and table.concat(active, " | ") or "Tidak ada"
    
    SendChat("/me ╔════════════════════════════════════════╗")
    wait(0.1)
    SendChat("/me ║        👤 ZONE XD PROFILE 👤          ║")
    wait(0.1)
    SendChat("/me ╠════════════════════════════════════════╣")
    wait(0.1)
    SendChat("/me ║ 📛 Nama   : " .. LocalPlayer.Name)
    wait(0.1)
    SendChat("/me ║ 🏷️ Display: " .. LocalPlayer.DisplayName)
    wait(0.1)
    SendChat("/me ║ 🔢 User ID: " .. LocalPlayer.UserId)
    wait(0.1)
    SendChat("/me ║ 👥 Team   : " .. (LocalPlayer.Team and LocalPlayer.Team.Name or "No Team"))
    wait(0.1)
    SendChat("/me ╠════════════════════════════════════════╣")
    wait(0.1)
    SendChat("/me ║ ⚙️ ACTIVE: " .. activeText)
    wait(0.1)
    SendChat("/me ╚════════════════════════════════════════╝")
    Notify("👤 PROFILE", LocalPlayer.Name, 3)
end

-- ==================== SPEED & JUMP ====================
local function SetSpeed(v)
    if not isUnlocked then ShowLockedMessage() return end
    v = tonumber(v)
    if not v then SendChat("/me ⚠️ Format: /speed [1-200] ⚠️") return end
    if v > 200 then v = 200 end
    if v < 10 then v = 10 end
    Settings.Speed = v
    local hum = GetHumanoid()
    if hum then
        hum.WalkSpeed = v
        SendChat("/me ⚡ SPEED SET KE: " .. v .. " ⚡")
        Notify("⚡ SPEED", "Kecepatan: "..v, 2)
    end
end

local function SetJump(v)
    if not isUnlocked then ShowLockedMessage() return end
    v = tonumber(v)
    if not v then SendChat("/me ⚠️ Format: /jump [30-200] ⚠️") return end
    if v > 200 then v = 200 end
    if v < 30 then v = 30 end
    Settings.JumpPower = v
    local hum = GetHumanoid()
    if hum then
        hum.JumpPower = v
        SendChat("/me 🦘 JUMP SET KE: " .. v .. " 🦘")
        Notify("🦘 JUMP", "Lompatan: "..v, 2)
    end
end

-- ==================== FLY ====================
local function StopFly()
    if FlyBodyVelocity then pcall(function() FlyBodyVelocity:Destroy() end) end
    if FlyBodyGyro then pcall(function() FlyBodyGyro:Destroy() end) end
    if FlyRenderConnection then FlyRenderConnection:Disconnect() end
    local hum = GetHumanoid()
    if hum then hum.PlatformStand = false end
    FlyingActive = false
    if TouchJoystick then pcall(function() TouchJoystick:Destroy() end) end
    TouchJoystick = nil
    SendChat("/me 🕊️ FLY MODE NONAKTIF 🕊️")
    Notify("🕊️ FLY", "Mode terbang dimatikan", 2)
end

local function StartFly()
    if not isUnlocked then ShowLockedMessage() return end
    if FlyingActive then StopFly() return end
    
    local char = LocalPlayer.Character
    if not char then SendChat("/me ❌ GAGAL! Tunggu character spawn ❌") return end
    
    local hum = GetHumanoid()
    local root = GetRootPart()
    if not hum or not root then SendChat("/me ❌ GAGAL! Humanoid/RootPart tidak ditemukan ❌") return end
    
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then v.CanCollide = false end
    end
    
    hum.PlatformStand = true
    
    FlyBodyVelocity = Instance.new("BodyVelocity")
    FlyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    FlyBodyVelocity.Parent = root
    
    FlyBodyGyro = Instance.new("BodyGyro")
    FlyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    FlyBodyGyro.CFrame = root.CFrame
    FlyBodyGyro.Parent = root
    
    FlyingActive = true
    FlyControls = {Forward=false, Backward=false, Left=false, Right=false, Up=false, Down=false}
    
    FlyRenderConnection = RunService.RenderStepped:Connect(function()
        if not FlyingActive or not FlyBodyVelocity then return end
        local r = GetRootPart()
        if not r then return end
        local dir = Vector3.new(0,0,0)
        if FlyControls.Forward then dir = dir + r.CFrame.LookVector end
        if FlyControls.Backward then dir = dir - r.CFrame.LookVector end
        if FlyControls.Right then dir = dir + r.CFrame.RightVector end
        if FlyControls.Left then dir = dir - r.CFrame.RightVector end
        if FlyControls.Up then dir = dir + Vector3.new(0,1,0) end
        if FlyControls.Down then dir = dir - Vector3.new(0,1,0) end
        FlyBodyVelocity.Velocity = dir * MAX_FLY_SPEED
        if FlyBodyGyro then FlyBodyGyro.CFrame = r.CFrame end
    end)
    
    -- Simple joystick
    local gui = Instance.new("ScreenGui")
    gui.Name = "ZoneFly"
    gui.Parent = CoreGui
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0, 100, 0, 100)
    bg.Position = UDim2.new(0, 20, 1, -120)
    bg.BackgroundColor3 = Color3.fromRGB(40,40,50)
    bg.BackgroundTransparency = 0.5
    bg.BorderRadius = UDim.new(1,50)
    bg.Parent = gui
    
    local stick = Instance.new("Frame")
    stick.Size = UDim2.new(0, 45, 0, 45)
    stick.Position = UDim2.new(0.5, -22.5, 0.5, -22.5)
    stick.BackgroundColor3 = Color3.fromRGB(255,100,0)
    stick.BackgroundTransparency = 0.3
    stick.BorderRadius = UDim.new(1,22.5)
    stick.Parent = bg
    
    local stop = Instance.new("TextButton")
    stop.Size = UDim2.new(0, 55, 0, 55)
    stop.Position = UDim2.new(1, -70, 0, 15)
    stop.BackgroundColor3 = Color3.fromRGB(255,50,50)
    stop.BackgroundTransparency = 0.3
    stop.BorderRadius = UDim.new(1,27.5)
    stop.Text = "🛑"
    stop.TextSize = 30
    stop.Parent = gui
    stop.MouseButton1Click:Connect(StopFly)
    
    local up = Instance.new("TextButton")
    up.Size = UDim2.new(0, 60, 0, 60)
    up.Position = UDim2.new(1, -75, 0.5, -80)
    up.BackgroundColor3 = Color3.fromRGB(0,150,255)
    up.BackgroundTransparency = 0.3
    up.BorderRadius = UDim.new(1,30)
    up.Text = "⬆️"
    up.TextSize = 35
    up.Parent = gui
    
    local down = Instance.new("TextButton")
    down.Size = UDim2.new(0, 60, 0, 60)
    down.Position = UDim2.new(1, -75, 0.85, -30)
    down.BackgroundColor3 = Color3.fromRGB(0,150,255)
    down.BackgroundTransparency = 0.3
    down.BorderRadius = UDim.new(1,30)
    down.Text = "⬇️"
    down.TextSize = 35
    down.Parent = gui
    
    up.MouseButton1Down:Connect(function() FlyControls.Up = true end)
    up.MouseButton1Up:Connect(function() FlyControls.Up = false end)
    down.MouseButton1Down:Connect(function() FlyControls.Down = true end)
    down.MouseButton1Up:Connect(function() FlyControls.Down = false end)
    
    local drag = false
    local dragStart, startPos
    bg.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch then
            drag = true
            dragStart = inp.Position
            startPos = stick.Position
        end
    end)
    bg.InputEnded:Connect(function()
        drag = false
        TweenService:Create(stick, TweenInfo.new(0.2), {Position = UDim2.new(0.5, -22.5, 0.5, -22.5)}):Play()
        FlyControls.Forward, FlyControls.Backward, FlyControls.Left, FlyControls.Right = false, false, false, false
    end)
    bg.InputChanged:Connect(function(inp)
        if drag and inp.UserInputType == Enum.UserInputType.Touch then
            local delta = inp.Position - dragStart
            local nx = math.clamp(startPos.X.Offset + delta.X, -45, 45)
            local ny = math.clamp(startPos.Y.Offset + delta.Y, -45, 45)
            stick.Position = UDim2.new(0.5, nx, 0.5, ny)
            local normX, normY = nx/45, ny/45
            FlyControls.Forward = normY < -0.3
            FlyControls.Backward = normY > 0.3
            FlyControls.Left = normX < -0.3
            FlyControls.Right = normX > 0.3
        end
    end)
    
    TouchJoystick = gui
    SendChat("/me 🕊️ FLY MODE AKTIF! 🕊️")
    Notify("🕊️ FLY", "Mode terbang aktif!", 3)
end

-- ==================== AIMLOCK ====================
local function ToggleAimlock()
    if not isUnlocked then ShowLockedMessage() return end
    Settings.Aimlock = not Settings.Aimlock
    if Settings.Aimlock then
        if AimlockConnection then AimlockConnection:Disconnect() end
        AimlockConnection = RunService.RenderStepped:Connect(function()
            if not Settings.Aimlock then return end
            local cam = workspace.CurrentCamera
            local closest, closestDist = nil, Settings.FOV
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    local pos, on = cam:WorldToViewportPoint(p.Character.Head.Position)
                    local d = (Vector2.new(pos.X, pos.Y) - Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)).Magnitude
                    if on and d < closestDist then closestDist, closest = d, p end
                end
            end
            if closest and closest.Character and closest.Character:FindFirstChild("Head") then
                cam.CFrame = CFrame.new(cam.CFrame.Position, closest.Character.Head.Position)
            end
        end)
        SendChat("/me 🎯 AIMLOCK AKTIF! FOV: " .. Settings.FOV .. " 🎯")
        Notify("🎯 AIMLOCK", "Auto aim aktif!", 2)
    else
        if AimlockConnection then AimlockConnection:Disconnect() end
        AimlockConnection = nil
        SendChat("/me ❌ AIMLOCK NONAKTIF ❌")
        Notify("❌ AIMLOCK", "Dimatikan", 2)
    end
end

local function SetFOV(v)
    if not isUnlocked then ShowLockedMessage() return end
    v = tonumber(v)
    if not v then SendChat("/me ⚠️ Format: /fov [50-200] ⚠️") return end
    if v > 200 then v = 200 end
    if v < 50 then v = 50 end
    Settings.FOV = v
    SendChat("/me 🎚️ FOV SET KE: " .. v .. " 🎚️")
    Notify("🎚️ FOV", "FOV: "..v, 2)
end

-- ==================== AUTO PUNCH ====================
local function ToggleAutoPunch()
    if not isUnlocked then ShowLockedMessage() return end
    Settings.AutoPunch = not Settings.AutoPunch
    if Settings.AutoPunch then
        if AutoPunchConnection then AutoPunchConnection:Disconnect() end
        AutoPunchConnection = RunService.RenderStepped:Connect(function()
            if not Settings.AutoPunch then return end
            local root = GetRootPart()
            if not root then return end
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (root.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if d < 5 then
                        pcall(function() VirtualUser:ClickButton1(Vector2.new(500,500)) end)
                        wait(0.3)
                        break
                    end
                end
            end
        end)
        SendChat("/me 👊 AUTO PUNCH AKTIF! 👊")
        Notify("👊 AUTO PUNCH", "Auto punch aktif!", 2)
    else
        if AutoPunchConnection then AutoPunchConnection:Disconnect() end
        AutoPunchConnection = nil
        SendChat("/me ❌ AUTO PUNCH NONAKTIF ❌")
        Notify("❌ AUTO PUNCH", "Dimatikan", 2)
    end
end

-- ==================== AUTO PARRY ====================
local function ToggleAutoParry()
    if not isUnlocked then ShowLockedMessage() return end
    Settings.AutoParry = not Settings.AutoParry
    if Settings.AutoParry then
        if AutoParryConnection then AutoParryConnection:Disconnect() end
        AutoParryConnection = RunService.RenderStepped:Connect(function()
            if not Settings.AutoParry then return end
            local root = GetRootPart()
            if not root then return end
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Part") and (v.Name:find("Projectile") or v.Name:find("Attack")) then
                    if (root.Position - v.Position).Magnitude < 5 then
                        pcall(function() VirtualUser:ClickButton1(Vector2.new(500,500)) end)
                        break
                    end
                end
            end
        end)
        SendChat("/me 🛡️ AUTO PARRY AKTIF! 🛡️")
        Notify("🛡️ AUTO PARRY", "Auto parry aktif!", 2)
    else
        if AutoParryConnection then AutoParryConnection:Disconnect() end
        AutoParryConnection = nil
        SendChat("/me ❌ AUTO PARRY NONAKTIF ❌")
        Notify("❌ AUTO PARRY", "Dimatikan", 2)
    end
end

-- ==================== CHAMS ====================
local function ToggleChams()
    if not isUnlocked then ShowLockedMessage() return end
    Settings.Chams = not Settings.Chams
    if Settings.Chams then
        for _, obj in pairs(ChamsObjects) do pcall(function() obj:Destroy() end) end
        ChamsObjects = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                for _, part in pairs(p.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        local h = Instance.new("Highlight")
                        h.Parent = part
                        h.Adornee = part
                        h.FillColor = Color3.fromRGB(255,0,0)
                        h.FillTransparency = 0.5
                        h.OutlineColor = Color3.fromRGB(255,255,255)
                        table.insert(ChamsObjects, h)
                    end
                end
            end
        end
        SendChat("/me ✨ CHAMS AKTIF! ✨")
        Notify("✨ CHAMS", "Player highlight aktif!", 2)
    else
        for _, obj in pairs(ChamsObjects) do pcall(function() obj:Destroy() end) end
        ChamsObjects = {}
        SendChat("/me ❌ CHAMS NONAKTIF ❌")
        Notify("❌ CHAMS", "Dimatikan", 2)
    end
end

-- ==================== ESP ====================
local function ToggleESP()
    if not isUnlocked then ShowLockedMessage() return end
    Settings.ESP = not Settings.ESP
    if Settings.ESP then
        if ESPGui then ESPGui:Destroy() end
        ESPGui = Instance.new("ScreenGui")
        ESPGui.Name = "ZoneESP"
        ESPGui.Parent = CoreGui
        
        local function add(p)
            if p == LocalPlayer then return end
            local f = Instance.new("Frame")
            f.Size = UDim2.new(0, 70, 0, 70)
            f.BackgroundTransparency = 0.4
            f.BorderSizePixel = 2
            f.Parent = ESPGui
            
            local name = Instance.new("TextLabel")
            name.Text = p.Name
            name.TextColor3 = Color3.fromRGB(255,255,255)
            name.BackgroundColor3 = Color3.fromRGB(0,0,0)
            name.BackgroundTransparency = 0.5
            name.TextScaled = true
            name.Size = UDim2.new(1,0,0,20)
            name.Parent = f
            
            local health = Instance.new("Frame")
            health.Size = UDim2.new(1,0,0,5)
            health.BackgroundColor3 = Color3.fromRGB(0,255,0)
            health.Position = UDim2.new(0,0,1,-7)
            health.Parent = f
            
            local dist = Instance.new("TextLabel")
            dist.Text = ""
            dist.TextColor3 = Color3.fromRGB(255,255,255)
            dist.BackgroundTransparency = 1
            dist.TextSize = 11
            dist.Position = UDim2.new(0,0,1,2)
            dist.Size = UDim2.new(1,0,0,15)
            dist.Parent = f
            
            ESPFrames[p] = {frame=f, health=health, dist=dist}
        end
        
        for _, p in pairs(Players:GetPlayers()) do add(p) end
        Players.PlayerAdded:Connect(add)
        Players.PlayerRemoving:Connect(function(p) if ESPFrames[p] then ESPFrames[p].frame:Destroy() end end)
        
        RunService.RenderStepped:Connect(function()
            if not Settings.ESP then return end
            local cam = workspace.CurrentCamera
            local root = GetRootPart()
            for p, data in pairs(ESPFrames) do
                if p.Character and p.Character:FindFirstChild("Head") then
                    local pos, on = cam:WorldToViewportPoint(p.Character.Head.Position)
                    local dist = root and (root.Position - p.Character.Head.Position).Magnitude or 100
                    if on then
                        local sz = math.clamp(70 * (90/math.max(dist,10)), 40, 110)
                        data.frame.Size = UDim2.new(0, sz, 0, sz)
                        data.frame.Position = UDim2.new(0, pos.X - sz/2, 0, pos.Y - sz/2)
                        data.frame.Visible = true
                        data.dist.Text = math.floor(dist) .. "m"
                        if p.Team == LocalPlayer.Team then
                            data.frame.BackgroundColor3 = Color3.fromRGB(0,200,0)
                            data.frame.BorderColor3 = Color3.fromRGB(0,200,0)
                        else
                            data.frame.BackgroundColor3 = Color3.fromRGB(200,0,0)
                            data.frame.BorderColor3 = Color3.fromRGB(200,0,0)
                        end
                        local hum = p.Character:FindFirstChildOfClass("Humanoid")
                        if hum then
                            local hp = hum.Health / hum.MaxHealth
                            data.health.Size = UDim2.new(hp, 0, 0, 5)
                            if hp > 0.6 then data.health.BackgroundColor3 = Color3.fromRGB(0,255,0)
                            elseif hp > 0.3 then data.health.BackgroundColor3 = Color3.fromRGB(255,255,0)
                            else data.health.BackgroundColor3 = Color3.fromRGB(255,0,0) end
                        end
                    else
                        data.frame.Visible = false
                    end
                end
            end
        end)
        SendChat("/me 👁️ ESP PRO AKTIF! 👁️")
        Notify("👁️ ESP", "ESP aktif!", 2)
    else
        if ESPGui then ESPGui:Destroy() end
        ESPGui = nil
        SendChat("/me ❌ ESP NONAKTIF ❌")
        Notify("❌ ESP", "Dimatikan", 2)
    end
end

-- ==================== TOGGLE FUNCTIONS ====================
local function ToggleNoClip()
    if not isUnlocked then ShowLockedMessage() return end
    Settings.NoClip = not Settings.NoClip
    local char = LocalPlayer.Character
    if char then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = not Settings.NoClip end
        end
    end
    if Settings.NoClip then SendChat("/me 🔓 NOCLIP AKTIF! 🔓") Notify("🔓 NOCLIP", "Tembus tembok aktif", 2)
    else SendChat("/me 🔒 NOCLIP NONAKTIF 🔒") Notify("🔒 NOCLIP", "Dimatikan", 2) end
end

local function ToggleGodMode()
    if not isUnlocked then ShowLockedMessage() return end
    Settings.GodMode = not Settings.GodMode
    local hum = GetHumanoid()
    if hum then
        if Settings.GodMode then hum.MaxHealth, hum.Health, hum.BreakJointsOnDeath = math.huge, math.huge, false
        else hum.MaxHealth, hum.Health, hum.BreakJointsOnDeath = 100, 100, true end
    end
    if Settings.GodMode then SendChat("/me 🛡️ GOD MODE AKTIF! 🛡️") Notify("🛡️ GOD MODE", "Abadi!", 2)
    else SendChat("/me ❌ GOD MODE NONAKTIF ❌") Notify("❌ GOD MODE", "Dimatikan", 2) end
end

local function ToggleInfiniteJump()
    if not isUnlocked then ShowLockedMessage() return end
    Settings.InfiniteJump = not Settings.InfiniteJump
    if Settings.InfiniteJump then
        if InfiniteJumpConnection then InfiniteJumpConnection:Disconnect() end
        InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
            local hum = GetHumanoid()
            if hum and hum:GetState() ~= Enum.HumanoidStateType.Jumping then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
        SendChat("/me ♾️ INFINITE JUMP AKTIF! ♾️") Notify("♾️ INFINITE JUMP", "Lompat tanpa batas!", 2)
    else
        if InfiniteJumpConnection then InfiniteJumpConnection:Disconnect() end
        InfiniteJumpConnection = nil
        SendChat("/me ❌ INFINITE JUMP NONAKTIF ❌") Notify("❌ INFINITE JUMP", "Dimatikan", 2)
    end
end

local function ToggleInvisible()
    if not isUnlocked then ShowLockedMessage() return end
    Settings.InvisibleMode = not Settings.InvisibleMode
    local char = LocalPlayer.Character
    if not char then SendChat("/me ❌ GAGAL! Character tidak ditemukan ❌") return end
    if Settings.InvisibleMode then
        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") or p:IsA("MeshPart") then
                Settings.OriginalTransparency[p] = p.Transparency
                p.Transparency = 1
            end
        end
        SendChat("/me 👻 INVISIBLE MODE AKTIF! 👻") Notify("👻 INVISIBLE", "Kamu tidak terlihat!", 3)
    else
        for p, t in pairs(Settings.OriginalTransparency) do pcall(function() p.Transparency = t end) end
        Settings.OriginalTransparency = {}
        SendChat("/me 👁️ INVISIBLE MODE NONAKTIF 👁️") Notify("👁️ INVISIBLE", "Dimatikan", 2)
    end
end

local function ToggleSilentAim()
    if not isUnlocked then ShowLockedMessage() return end
    Settings.SilentAim = not Settings.SilentAim
    if Settings.SilentAim then
        if AimbotConnection then AimbotConnection:Disconnect() end
        AimbotConnection = RunService.RenderStepped:Connect(function()
            if not Settings.SilentAim then return end
            local cam = workspace.CurrentCamera
            local closest, cd = nil, 500
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    local pos, on = cam:WorldToViewportPoint(p.Character.Head.Position)
                    local d = (Vector2.new(pos.X, pos.Y) - Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)).Magnitude
                    if on and d < cd then cd, closest = d, p end
                end
            end
            if closest and closest.Character and closest.Character:FindFirstChild("Head") then
                cam.CFrame = CFrame.new(cam.CFrame.Position, closest.Character.Head.Position)
            end
        end)
        SendChat("/me 🎯 SILENT AIM AKTIF! 🎯") Notify("🎯 SILENT AIM", "Auto aim aktif!", 2)
    else
        if AimbotConnection then AimbotConnection:Disconnect() end
        AimbotConnection = nil
        SendChat("/me ❌ SILENT AIM NONAKTIF ❌") Notify("❌ SILENT AIM", "Dimatikan", 2)
    end
end

local function ToggleAntiStun()
    if not isUnlocked then ShowLockedMessage() return end
    Settings.AntiStun = not Settings.AntiStun
    if Settings.AntiStun then
        if AntiStunConnection then AntiStunConnection:Disconnect() end
        AntiStunConnection = RunService.RenderStepped:Connect(function()
            if not Settings.AntiStun then return end
            local hum = GetHumanoid()
            if hum then
                local s = hum:GetState()
                if s == Enum.HumanoidStateType.FallingDown or s == Enum.HumanoidStateType.Ragdoll or s == Enum.HumanoidStateType.Stunned then
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                end
                hum.Sit = false
            end
        end)
        SendChat("/me 💪 ANTI STUN AKTIF! 💪") Notify("💪 ANTI STUN", "Tidak bisa di-stun!", 2)
    else
        if AntiStunConnection then AntiStunConnection:Disconnect() end
        AntiStunConnection = nil
        SendChat("/me ❌ ANTI STUN NONAKTIF ❌") Notify("❌ ANTI STUN", "Dimatikan", 2)
    end
end

local function ToggleAutoHeal()
    if not isUnlocked then ShowLockedMessage() return end
    Settings.AutoHeal = not Settings.AutoHeal
    if Settings.AutoHeal then
        if AutoHealConnection then AutoHealConnection:Disconnect() end
        AutoHealConnection = RunService.RenderStepped:Connect(function()
            if not Settings.AutoHeal then return end
            local hum = GetHumanoid()
            if hum and hum.Health < hum.MaxHealth * 0.7 then hum.Health = hum.MaxHealth end
        end)
        SendChat("/me 💚 AUTO HEAL AKTIF! 💚") Notify("💚 AUTO HEAL", "Auto heal aktif!", 2)
    else
        if AutoHealConnection then AutoHealConnection:Disconnect() end
        AutoHealConnection = nil
        SendChat("/me ❌ AUTO HEAL NONAKTIF ❌") Notify("❌ AUTO HEAL", "Dimatikan", 2)
    end
end

local function ToggleAutoFarm()
    if not isUnlocked then ShowLockedMessage() return end
    Settings.AutoFarm = not Settings.AutoFarm
    if Settings.AutoFarm then
        if AutoFarmConnection then AutoFarmConnection:Disconnect() end
        AutoFarmConnection = RunService.RenderStepped:Connect(function()
            if not Settings.AutoFarm then return end
            local root = GetRootPart()
            if not root then return end
            local nearest, nd = nil, 50
            for _, obj in pairs(workspace:GetDescendants()) do
                if (obj:IsA("Part") or obj:IsA("MeshPart")) and (obj:FindFirstChildOfClass("ClickDetector") or obj.Name:find("Farm") or obj.Name:find("Crop")) then
                    local d = (root.Position - obj.Position).Magnitude
                    if d < nd then nd, nearest = d, obj end
                end
            end
            if nearest and nd < 50 then
                local cd = nearest:FindFirstChildOfClass("ClickDetector")
                if cd then pcall(function() fireclickdetector(cd) end) end
                if nd > 4 then root.CFrame = CFrame.new(nearest.Position + Vector3.new(0,2,0)) end
            end
        end)
        SendChat("/me 🌾 AUTO FARM AKTIF! 🌾") Notify("🌾 AUTO FARM", "Auto farming aktif!", 2)
    else
        if AutoFarmConnection then AutoFarmConnection:Disconnect() end
        AutoFarmConnection = nil
        SendChat("/me ❌ AUTO FARM NONAKTIF ❌") Notify("❌ AUTO FARM", "Dimatikan", 2)
    end
end

local function ToggleAutoCollect()
    if not isUnlocked then ShowLockedMessage() return end
    Settings.AutoCollect = not Settings.AutoCollect
    if Settings.AutoCollect then
        if AutoCollectConnection then AutoCollectConnection:Disconnect() end
        AutoCollectConnection = RunService.RenderStepped:Connect(function()
            if not Settings.AutoCollect then return end
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Part") and obj:FindFirstChildOfClass("ClickDetector") then
                    if obj.Name:find("Coin") or obj.Name:find("Gem") or obj.Name:find("Item") then
                        local d = (GetRootPart() and GetRootPart().Position - obj.Position).Magnitude or 999
                        if d < 20 then pcall(function() fireclickdetector(obj:FindFirstChildOfClass("ClickDetector")) end) end
                    end
                end
            end
        end)
        SendChat("/me 💰 AUTO COLLECT AKTIF! 💰") Notify("💰 AUTO COLLECT", "Auto collect aktif!", 2)
    else
        if AutoCollectConnection then AutoCollectConnection:Disconnect() end
        AutoCollectConnection = nil
        SendChat("/me ❌ AUTO COLLECT NONAKTIF ❌") Notify("❌ AUTO COLLECT", "Dimatikan", 2)
    end
end

local function ToggleWalkOnWater()
    if not isUnlocked then ShowLockedMessage() return end
    Settings.WalkOnWater = not Settings.WalkOnWater
    if Settings.WalkOnWater then
        if WalkOnWaterConnection then WalkOnWaterConnection:Disconnect() end
        WalkOnWaterConnection = RunService.RenderStepped:Connect(function()
            if not Settings.WalkOnWater then return end
            local root = GetRootPart()
            if root and root.Position.Y < 5 then
                local ray = Ray.new(root.Position, Vector3.new(0,-3,0))
                local hit = workspace:FindPartOnRay(ray, root)
                if hit and hit.Material == Enum.Material.Water then
                    root.CFrame = CFrame.new(root.Position.X, 5, root.Position.Z)
                end
            end
        end)
        SendChat("/me 💧 WALK ON WATER AKTIF! 💧") Notify("💧 WALK ON WATER", "Bisa jalan di air!", 2)
    else
        if WalkOnWaterConnection then WalkOnWaterConnection:Disconnect() end
        WalkOnWaterConnection = nil
        SendChat("/me ❌ WALK ON WATER NONAKTIF ❌") Notify("❌ WALK ON WATER", "Dimatikan", 2)
    end
end

local function ToggleNoFallDamage()
    if not isUnlocked then ShowLockedMessage() return end
    Settings.NoFallDamage = not Settings.NoFallDamage
    if Settings.NoFallDamage then
        if NoFallDamageConnection then NoFallDamageConnection:Disconnect() end
        NoFallDamageConnection = RunService.RenderStepped:Connect(function()
            if not Settings.NoFallDamage then return end
            local hum = GetHumanoid()
            if hum then hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false) end
        end)
        SendChat("/me 🪂 NO FALL DAMAGE AKTIF! 🪂") Notify("🪂 NO FALL DAMAGE", "Jatuh ga mati!", 2)
    else
        if NoFallDamageConnection then NoFallDamageConnection:Disconnect() end
        NoFallDamageConnection = nil
        local hum = GetHumanoid()
        if hum then hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true) end
        SendChat("/me ❌ NO FALL DAMAGE NONAKTIF ❌") Notify("❌ NO FALL DAMAGE", "Dimatikan", 2)
    end
end

local function ToggleAutoClick()
    if not isUnlocked then ShowLockedMessage() return end
    Settings.AutoClick = not Settings.AutoClick
    if Settings.AutoClick then
        if AutoClickConnection then AutoClickConnection:Disconnect() end
        AutoClickConnection = RunService.RenderStepped:Connect(function()
            if Settings.AutoClick then
                pcall(function() VirtualUser:ClickButton1(Vector2.new(500,500)) end)
                task.wait(Settings.ClickDelay)
            end
        end)
        SendChat("/me 🖱️ AUTO CLICK AKTIF! 🖱️") Notify("🖱️ AUTO CLICK", "Auto click aktif!", 2)
    else
        if AutoClickConnection then AutoClickConnection:Disconnect() end
        AutoClickConnection = nil
        SendChat("/me ❌ AUTO CLICK NONAKTIF ❌") Notify("❌ AUTO CLICK", "Dimatikan", 2)
    end
end

-- ==================== TELEPORT ====================
local function TeleportTo(pos)
    if not isUnlocked then ShowLockedMessage() return end
    local root = GetRootPart()
    if root then
        TeleportIndex = TeleportIndex + 1
        TeleportHistory[TeleportIndex] = root.CFrame
        root.CFrame = CFrame.new(pos)
        SendChat("/me ✨ TELEPORT BERHASIL! ✨")
        Notify("✨ TELEPORT", "Berhasil teleport!", 2)
    end
end

local function TeleportBack()
    if not isUnlocked then ShowLockedMessage() return end
    if TeleportIndex > 0 then
        local root = GetRootPart()
        if root and TeleportHistory[TeleportIndex] then
            root.CFrame = TeleportHistory[TeleportIndex]
            TeleportHistory[TeleportIndex] = nil
            TeleportIndex = TeleportIndex - 1
            SendChat("/me ↩️ TELEPORT BACK! ↩️")
            Notify("↩️ TELEPORT", "Kembali ke posisi sebelumnya", 2)
        end
    else
        SendChat("/me ⚠️ TIDAK ADA HISTORY! ⚠️")
    end
end

local function TeleportToPlayer(name)
    if not isUnlocked then ShowLockedMessage() return end
    for _, p in pairs(Players:GetPlayers()) do
        if string.lower(p.Name):find(string.lower(name)) and p ~= LocalPlayer then
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                TeleportTo(p.Character.HumanoidRootPart.Position)
                return
            end
        end
    end
    SendChat("/me ❌ PLAYER TIDAK DITEMUKAN! ❌")
end

-- ==================== RESET ====================
local function ResetAll()
    if not isUnlocked then ShowLockedMessage() return end
    
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
        for p, t in pairs(Settings.OriginalTransparency) do pcall(function() p.Transparency = t end) end
        Settings.OriginalTransparency = {}
    end
    
    for _, obj in pairs(ChamsObjects) do pcall(function() obj:Destroy() end) end
    ChamsObjects = {}
    
    Settings = {
        Speed = OriginalSpeed, JumpPower = OriginalJump, FlySpeed = 100, Flying = false, NoClip = false,
        GodMode = false, InfiniteJump = false, AutoClick = false, ESP = false, InvisibleMode = false,
        SpeedEnabled = true, JumpEnabled = true, ClickDelay = 0.1, AutoFarm = false, AutoCollect = false,
        SilentAim = false, AntiStun = false, AutoHeal = false, WalkOnWater = false, NoFallDamage = false,
        Aimlock = false, AutoPunch = false, AutoParry = false, Chams = false, FOV = 150, OriginalTransparency = {}
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
    if AimlockConnection then AimlockConnection:Disconnect() end
    if AutoPunchConnection then AutoPunchConnection:Disconnect() end
    if AutoParryConnection then AutoParryConnection:Disconnect() end
    
    ESPGui, TouchJoystick = nil, nil
    ESPFrames = {}
    TeleportHistory, TeleportIndex = {}, 0
    
    SendChat("/me 🔄 SEMUA FITUR DI RESET! 🔄")
    Notify("🔄 RESET", "Semua fitur dinonaktifkan", 3)
end

-- ==================== MENU ====================
local function ShowMenu()
    if not isUnlocked then ShowLockedMessage() return end
    
    SendChat("/me ╔════════════════════════════════════════════════╗")
    wait(0.08)
    SendChat("/me ║     🔥 ZONE XD V7 ULTIMATE EDITION 🔥        ║")
    wait(0.08)
    SendChat("/me ║     CREATED BY: APIS                         ║")
    wait(0.08)
    SendChat("/me ╠════════════════════════════════════════════════╣")
    wait(0.08)
    SendChat("/me ║ 👤 /profile   - Lihat profil akun              ║")
    wait(0.08)
    SendChat("/me ║ ⚡ /speed 1-200 - Set kecepatan                ║")
    wait(0.08)
    SendChat("/me ║ 🦘 /jump 30-200 - Set kekuatan lompat          ║")
    wait(0.08)
    SendChat("/me ║ 🕊️ /fly        - Mode terbang + joystick       ║")
    wait(0.08)
    SendChat("/me ║ 🔓 /noclip     - Tembus tembok                 ║")
    wait(0.08)
    SendChat("/me ║ 🛡️ /god        - Mode abadi                     ║")
    wait(0.08)
    SendChat("/me ║ ♾️ /infjump    - Lompat tanpa batas             ║")
    wait(0.08)
    SendChat("/me ║ 👁️ /esp        - ESP PRO (health + jarak)       ║")
    wait(0.08)
    SendChat("/me ║ 👻 /invisible  - Mode tidak terlihat           ║")
    wait(0.08)
    SendChat("/me ╠════════════════════════════════════════════════╣")
    wait(0.08)
    SendChat("/me ║ 🆕 FITUR BARU V7:                              ║")
    wait(0.08)
    SendChat("/me ║ 🎯 /aimlock    - Auto aim ke musuh              ║")
    wait(0.08)
    SendChat("/me ║ 👊 /autopunch  - Auto punch/kick musuh         ║")
    wait(0.08)
    SendChat("/me ║ 🛡️ /autoparry  - Auto parry/block serangan     ║")
    wait(0.08)
    SendChat("/me ║ ✨ /chams      - Highlight player              ║")
    wait(0.08)
    SendChat("/me ║ 🎚️ /fov 50-200 - Set FOV aimlock               ║")
    wait(0.08)
    SendChat("/me ║ ⚡ /flyspeed   - Set kecepatan terbang         ║")
    wait(0.08)
    SendChat("/me ╠════════════════════════════════════════════════╣")
    wait(0.08)
    SendChat("/me ║ 🎯 /silentaim  - Silent aim                     ║")
    wait(0.08)
    SendChat("/me ║ 💪 /antistun   - Anti stun/ragdoll             ║")
    wait(0.08)
    SendChat("/me ║ 💚 /autoheal   - Auto heal                      ║")
    wait(0.08)
    SendChat("/me ║ 🌾 /autofarm   - Auto farming                   ║")
    wait(0.08)
    SendChat("/me ║ 💰 /autocollect- Auto collect item              ║")
    wait(0.08)
    SendChat("/me ║ ✨ /tp X Y Z   - Teleport ke koordinat          ║")
    wait(0.08)
    SendChat("/me ║ ✨ /tp Nama    - Teleport ke player             ║")
    wait(0.08)
    SendChat("/me ║ ↩️ /tpback     - Kembali ke posisi sebelumnya   ║")
    wait(0.08)
    SendChat("/me ║ 💧 /walkwater  - Jalan di atas air              ║")
    wait(0.08)
    SendChat("/me ║ 🪂 /nofalldmg  - No fall damage                 ║")
    wait(0.08)
    SendChat("/me ║ 🖱️ /autoclick  - Auto klik                      ║")
    wait(0.08)
    SendChat("/me ║ 🔄 /reset      - Reset semua fitur              ║")
    wait(0.08)
    SendChat("/me ╚════════════════════════════════════════════════╝")
    Notify("🎮 ZONE XD V7", "Menu ditampilkan di chat!", 6)
end

-- ==================== FLY SPEED ====================
local function SetFlySpeed(v)
    if not isUnlocked then ShowLockedMessage() return end
    v = tonumber(v)
    if not v then SendChat("/me ⚠️ Format: /flyspeed [50-200] ⚠️") return end
    if v > 200 then v = 200 end
    if v < 50 then v = 50 end
    MAX_FLY_SPEED = v
    SendChat("/me ⚡ FLY SPEED SET KE: " .. v .. " ⚡")
    Notify("⚡ FLY SPEED", "Kecepatan terbang: "..v, 2)
end

-- ==================== COMMAND PROCESSOR ====================
local function ProcessCommand(msg)
    local lower = string.lower(msg)
    
    -- UNLOCK COMMAND
    if lower == "/zonexd111" then
        Unlock()
        return true
    end
    
    if not isUnlocked then
        ShowLockedMessage()
        return true
    end
    
    if lower == "/menu" then ShowMenu() return true end
    if lower == "/profile" then ShowProfile() return true end
    if lower == "/fly" then StartFly() return true end
    if lower == "/noclip" then ToggleNoClip() return true end
    if lower == "/god" then ToggleGodMode() return true end
    if lower == "/infjump" then ToggleInfiniteJump() return true end
    if lower == "/esp" then ToggleESP() return true end
    if lower == "/invisible" then ToggleInvisible() return true end
    if lower == "/aimlock" then ToggleAimlock() return true end
    if lower == "/autopunch" then ToggleAutoPunch() return true end
    if lower == "/autoparry" then ToggleAutoParry() return true end
    if lower == "/chams" then ToggleChams() return true end
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
        if v then SetSpeed(v) else SendChat("/me ⚠️ Format: /speed [1-200] ⚠️") end
        return true
    end
    if string.match(lower, "^/jump") then
        local v = string.match(lower, "%d+")
        if v then SetJump(v) else SendChat("/me ⚠️ Format: /jump [30-200] ⚠️") end
        return true
    end
    if string.match(lower, "^/fov") then
        local v = string.match(lower, "%d+")
        if v then SetFOV(v) else SendChat("/me ⚠️ Format: /fov [50-200] ⚠️") end
        return true
    end
    if string.match(lower, "^/flyspeed") then
        local v = string.match(lower, "%d+")
        if v then SetFlySpeed(v) else SendChat("/me ⚠️ Format: /flyspeed [50-200] ⚠️") end
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
        else SendChat("/me ⚠️ Format: /tp X Y Z ⚠️") end
        return true
    end
    return false
end

-- ==================== CHAT LISTENER (FIXED) ====================
local function SetupChatListener()
    -- METHOD 1: ReplicatedStorage Chat Event
    pcall(function()
        local rs = game:GetService("ReplicatedStorage")
        local chatEvent = rs:FindFirstChild("DefaultChatSystemChatEvents")
        if chatEvent then
            local onMessage = chatEvent:FindFirstChild("OnMessageDoneFiltering")
            if onMessage then
                onMessage.OnClientEvent:Connect(function(data)
                    if data.FromSpeaker == LocalPlayer.Name then
                        ProcessCommand(data.Message)
                    end
                end)
                return
            end
        end
    end)
    
    -- METHOD 2: TextChatService
    pcall(function()
        local tcs = game:GetService("TextChatService")
        if tcs and tcs.TextChannels then
            for _, ch in pairs(tcs.TextChannels:GetChildren()) do
                if ch:IsA("TextChannel") then
                    ch.MessageReceived:Connect(function(msg)
                        if msg.TextSource and msg.TextSource.UserId == LocalPlayer.UserId then
                            ProcessCommand(msg.Text)
                        end
                    end)
                    break
                end
            end
        end
    end)
    
    -- METHOD 3: PlayerChatted (Legacy)
    pcall(function()
        LocalPlayer.Chatted:Connect(function(msg)
            ProcessCommand(msg)
        end)
    end)
    
    -- METHOD 4: Simple Chat Input (Fallback)
    pcall(function()
        local chatFrame = LocalPlayer.PlayerGui:FindFirstChild("Chat")
        if chatFrame then
            local textBox = chatFrame:FindFirstChild("Frame") and chatFrame.Frame:FindFirstChild("ChatBarParentFrame")
            if textBox then
                local box = textBox:FindFirstChild("Frame") and textBox.Frame:FindFirstChild("BoxFrame")
                if box then
                    local input = box:FindFirstChild("Frame") and box.Frame:FindFirstChild("TextLabel")
                    if input then
                        input:GetPropertyChangedSignal("Text"):Connect(function()
                            local txt = input.Text
                            if string.sub(txt, 1, 1) == "/" then
                                ProcessCommand(txt)
                            end
                        end)
                    end
                end
            end
        end
    end)
end

-- ==================== AUTO UPDATE ====================
RunService.RenderStepped:Connect(function()
    if not isUnlocked then return end
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
    Notify("🔒 ZONE XD V7.1", "Ketik /zonexd111 untuk unlock", 5)
    task.wait(1)
    SetupChatListener()
    ShowLockedMessage()
end

Init()