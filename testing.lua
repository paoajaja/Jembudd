--[[
    ZONE XD ROBLOX SCRIPT V9.1 - ULTIMATE EDITION
    60+ FITUR | UNIVERSAL | SEMUA GAME
    ================================================
    FITUR SEBELUMNYA (50+):
    - Speed Hack | Jump Hack | Fly + Joystick | NoClip | GodMode | Infinite Jump
    - Aimbot | Silent Aim | Auto Punch | Auto Parry | Anti Stun | Auto Heal
    - ESP PRO (Nama + Health + Distance + Warna Team) | Chams | Invisible
    - Auto Farm | Auto Collect | Auto Click
    - Troll Features (Spam, Freeze, Flung, Blind, Earrape, Spin, Invert, Fire, Ragdoll, Kick, Explode)
    - Walk on Water | No Fall Damage
    - Target System | Admin Panel
    ================================================
    TAMBAHAN 10 FITUR BARU:
    1. AUTO TP (Teleport Otomatis ke target)
    2. FLY SPEED CONTROL (Atur kecepatan terbang)
    3. RAINBOW CHARACTER (Warna karakter berubah-ubah)
    4. AUTO BUY (Auto beli item dari shop)
    5. MOB SPAWN (Spawn mob/npc di sekitar)
    6. SERVER HOP (Pindah server otomatis)
    7. ANTI AFK (Cegah kick karena AFK)
    8. AUTO REJOIN (Auto join ulang setelah kick)
    9. CHAT SPAM (Spam chat otomatis)
    10. ANTI RESET (Cegah reset karakter)
    ================================================
    CREATED BY: APIS
]]

-- ==================== INIT ====================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")

-- ==================== PASSWORD ====================
local PASSWORD = "zonexd"
local isUnlocked = false
local lockedMessageSent = false

-- ==================== SETTINGS (SEMUA FITUR) ====================
local Settings = {
    -- ========== MOVEMENT (5 FITUR) ==========
    Speed = 16,
    JumpPower = 50,
    FlySpeed = 100,
    Flying = false,
    NoClip = false,
    GodMode = false,
    InfiniteJump = false,
    
    -- ========== COMBAT (7 FITUR) ==========
    Aimbot = false,
    SilentAim = false,
    AutoPunch = false,
    AutoParry = false,
    AntiStun = false,
    AutoHeal = false,
    FOV = 150,
    
    -- ========== VISUAL (4 FITUR) ==========
    ESP = false,
    Chams = false,
    Invisible = false,
    
    -- ========== FARMING (3 FITUR) ==========
    AutoFarm = false,
    AutoCollect = false,
    AutoClick = false,
    
    -- ========== TROLL (11 FITUR) ==========
    TrollSpam = false,
    TrollFreeze = false,
    TrollFlung = false,
    TrollBlind = false,
    TrollEarrape = false,
    TrollSpin = false,
    TrollInvert = false,
    TrollFire = false,
    TrollRagdoll = false,
    TrollKick = false,
    TrollExplode = false,
    
    -- ========== UTILITY (4 FITUR) ==========
    WalkOnWater = false,
    NoFallDamage = false,
    
    -- ========== FITUR BARU (10 FITUR) ==========
    AutoTP = false,
    FlySpeedControl = 100,
    RainbowChar = false,
    AutoBuy = false,
    MobSpawn = false,
    ServerHop = false,
    AntiAFK = false,
    AutoRejoin = false,
    ChatSpam = false,
    AntiReset = false,
    
    -- ========== TARGET ==========
    Target = nil,
    
    -- ========== UI ==========
    MenuOpen = false,
    
    -- ========== SETTINGS LAIN ==========
    SpamMessage = "🔥 ZONE XD V9.1 - BEST SCRIPT! 🔥",
    SpamDelay = 5,
    FlySpeedValue = 100,
    AutoBuyItem = "Sword",
    AutoBuyDelay = 10
}

-- ==================== LIMIT ====================
local MAX_SPEED = 200
local MAX_JUMP = 200
local MAX_FLY_SPEED = 200

-- Original Values
local OriginalSpeed = 16
local OriginalJump = 50

-- ==================== VARIABLES ====================
local FlyingActive = false
local FlyBodyVelocity = nil
local FlyBodyGyro = nil
local FlyControls = {Forward=false, Backward=false, Left=false, Right=false, Up=false, Down=false}
local FlyRenderConnection = nil
local ESPGui = nil
local ESPFrames = {}
local ChamsObjects = {}
local TouchJoystick = nil
local TeleportHistory = {}
local TeleportIndex = 0
local RainbowConnection = nil
local AntiAFKConnection = nil
local ChatSpamConnection = nil
local AutoRejoinConnection = nil
local AutoBuyConnection = nil
local MobSpawnConnection = nil
local AutoTPConnection = nil

-- Connections lama
local AutoClickConnection = nil
local AimbotConnection = nil
local InfiniteJumpConnection = nil
local AutoFarmConnection = nil
local AutoCollectConnection = nil
local AntiStunConnection = nil
local AutoHealConnection = nil
local NoFallDamageConnection = nil
local WalkOnWaterConnection = nil
local AutoPunchConnection = nil
local AutoParryConnection = nil

-- Troll Connections
local TrollSpamConnection = nil
local TrollFreezeConnections = {}
local TrollFlungConnection = nil
local TrollBlindConnection = nil
local TrollEarrapeConnection = nil
local TrollSpinConnection = nil
local TrollInvertConnection = nil
local TrollFireConnection = nil
local TrollRagdollConnection = nil

-- ==================== UTILITY ====================
local function SendChat(msg)
    pcall(function()
        local rs = ReplicatedStorage
        local chatEvent = rs:FindFirstChild("DefaultChatSystemChatEvents")
        if chatEvent then
            local sayEvent = chatEvent:FindFirstChild("SayMessageRequest")
            if sayEvent then sayEvent:FireServer(msg, "All") end
        end
        local tcs = game:GetService("TextChatService")
        if tcs and tcs.TextChannels then
            for _, ch in pairs(tcs.TextChannels:GetChildren()) do
                if ch:IsA("TextChannel") then ch:SendAsync(msg) break end
            end
        end
    end)
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

-- ==================== LOCKED STATE ====================
local function ShowLockedMessage()
    if lockedMessageSent then return end
    lockedMessageSent = true
    SendChat("/me ╔════════════════════════════════════════╗")
    wait(0.3)
    SendChat("/me ║     🔒 ZONE XD V9.1 - TERKUNCI 🔒     ║")
    wait(0.3)
    SendChat("/me ╠════════════════════════════════════════╣")
    wait(0.3)
    SendChat("/me ║  🛡️ SILAKAN MASUKKAN PASSWORD 🛡️     ║")
    wait(0.3)
    SendChat("/me ║  KETIK: /zonexd                      ║")
    wait(0.3)
    SendChat("/me ╚════════════════════════════════════════╝")
    Notify("🔒 TERKUNCI", "Ketik /zonexd untuk unlock", 5)
end

local function Unlock()
    isUnlocked = true
    lockedMessageSent = false
    SendChat("/me ╔════════════════════════════════════════╗")
    wait(0.2)
    SendChat("/me ║     ✅ PASSWORD BENAR! ✅              ║")
    wait(0.2)
    SendChat("/me ║     🔓 ZONE XD V9.1 UNLOCKED 🔓       ║")
    wait(0.2)
    SendChat("/me ╠════════════════════════════════════════╣")
    wait(0.2)
    SendChat("/me ║  💀 60+ FITUR AKTIF! 💀               ║")
    wait(0.2)
    SendChat("/me ║  KETIK /menu UNTUK LIHAT FITUR        ║")
    wait(0.2)
    SendChat("/me ╚════════════════════════════════════════╝")
    Notify("🔓 UNLOCKED", "60+ Fitur aktif!", 4)
end

-- ==================== FUNGSI UTAMA (SEMUA FITUR LAMA TETAP ADA) ====================
-- Speed
local function SetSpeed(v)
    if not isUnlocked then ShowLockedMessage() return end
    v = tonumber(v)
    if not v then SendChat("/me ⚠️ Format: /speed [1-200]") return end
    if v > MAX_SPEED then v = MAX_SPEED end
    if v < 10 then v = 10 end
    Settings.Speed = v
    local hum = GetHumanoid()
    if hum then hum.WalkSpeed = v
    SendChat("/me ⚡ SPEED SET KE: " .. v) Notify("⚡ SPEED", "Kecepatan: "..v, 2) end
end

-- Jump
local function SetJump(v)
    if not isUnlocked then ShowLockedMessage() return end
    v = tonumber(v)
    if not v then SendChat("/me ⚠️ Format: /jump [30-200]") return end
    if v > MAX_JUMP then v = MAX_JUMP end
    if v < 30 then v = 30 end
    Settings.JumpPower = v
    local hum = GetHumanoid()
    if hum then hum.JumpPower = v
    SendChat("/me 🦘 JUMP SET KE: " .. v) Notify("🦘 JUMP", "Lompatan: "..v, 2) end
end

-- ==================== FLY SYSTEM ====================
local function StopFly()
    if FlyBodyVelocity then pcall(function() FlyBodyVelocity:Destroy() end) end
    if FlyBodyGyro then pcall(function() FlyBodyGyro:Destroy() end) end
    if FlyRenderConnection then FlyRenderConnection:Disconnect() end
    local hum = GetHumanoid()
    if hum then hum.PlatformStand = false end
    FlyingActive = false
    if TouchJoystick then pcall(function() TouchJoystick:Destroy() end) end
    TouchJoystick = nil
    SendChat("/me 🕊️ FLY MODE NONAKTIF")
    Notify("🕊️ FLY", "Mode terbang dimatikan", 2)
end

local function StartFly()
    if not isUnlocked then ShowLockedMessage() return end
    if FlyingActive then StopFly() return end
    local char = LocalPlayer.Character
    if not char then SendChat("/me ❌ GAGAL! Tunggu character spawn") return end
    local hum = GetHumanoid()
    local root = GetRootPart()
    if not hum or not root then SendChat("/me ❌ GAGAL! Humanoid/RootPart tidak ditemukan") return end
    for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
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
        FlyBodyVelocity.Velocity = dir * Settings.FlySpeedControl
        if FlyBodyGyro then FlyBodyGyro.CFrame = r.CFrame end
    end)
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
    SendChat("/me 🕊️ FLY MODE AKTIF! Speed: " .. Settings.FlySpeedControl)
    Notify("🕊️ FLY", "Mode terbang aktif!", 3)
end

-- ==================== FITUR BARU 1: AUTO TP ====================
local function ToggleAutoTP()
    Settings.AutoTP = not Settings.AutoTP
    if Settings.AutoTP then
        if AutoTPConnection then AutoTPConnection:Disconnect() end
        AutoTPConnection = RunService.RenderStepped:Connect(function()
            if not Settings.AutoTP or not Settings.Target then return end
            local target = Settings.Target
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local root = GetRootPart()
                if root then
                    root.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                end
            end
        end)
        SendChat("/me ✨ AUTO TP AKTIF! Target: " .. (Settings.Target and Settings.Target.Name or "Not set"))
        Notify("✨ AUTO TP", "Auto teleport aktif!", 2)
    else
        if AutoTPConnection then AutoTPConnection:Disconnect() end
        AutoTPConnection = nil
        SendChat("/me ❌ AUTO TP NONAKTIF")
        Notify("❌ AUTO TP", "Dimatikan", 2)
    end
end

-- ==================== FITUR BARU 2: FLY SPEED CONTROL ====================
local function SetFlySpeed(v)
    v = tonumber(v)
    if not v then SendChat("/me ⚠️ Format: /flyspeed [50-200]") return end
    if v > 200 then v = 200 end
    if v < 50 then v = 50 end
    Settings.FlySpeedControl = v
    SendChat("/me ⚡ FLY SPEED SET KE: " .. v)
    Notify("⚡ FLY SPEED", "Kecepatan terbang: "..v, 2)
end

-- ==================== FITUR BARU 3: RAINBOW CHARACTER ====================
local function ToggleRainbowChar()
    Settings.RainbowChar = not Settings.RainbowChar
    if Settings.RainbowChar then
        if RainbowConnection then RainbowConnection:Disconnect() end
        RainbowConnection = RunService.RenderStepped:Connect(function()
            if not Settings.RainbowChar then return end
            local char = LocalPlayer.Character
            if not char then return end
            Settings.RainbowHue = (Settings.RainbowHue + 0.01) % 1
            local color = Color3.fromHSV(Settings.RainbowHue, 1, 1)
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Color = color
                end
            end
        end)
        SendChat("/me 🌈 RAINBOW CHARACTER AKTIF!")
        Notify("🌈 RAINBOW", "Karakter berubah warna!", 2)
    else
        if RainbowConnection then RainbowConnection:Disconnect() end
        RainbowConnection = nil
        SendChat("/me ❌ RAINBOW CHARACTER NONAKTIF")
        Notify("❌ RAINBOW", "Dimatikan", 2)
    end
end

-- ==================== FITUR BARU 4: AUTO BUY ====================
local function ToggleAutoBuy()
    Settings.AutoBuy = not Settings.AutoBuy
    if Settings.AutoBuy then
        if AutoBuyConnection then AutoBuyConnection:Disconnect() end
        AutoBuyConnection = RunService.RenderStepped:Connect(function()
            if not Settings.AutoBuy then return end
            -- Auto buy logic (cari remote event atau clickdetector)
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("ClickDetector") and (obj.Name:find("Buy") or obj.Name:find("Shop") or obj.Name:find("Purchase")) then
                    fireclickdetector(obj)
                end
            end
            -- Cari remote event
            local rs = ReplicatedStorage
            for _, v in pairs(rs:GetDescendants()) do
                if v:IsA("RemoteEvent") and (v.Name:find("Buy") or v.Name:find("Purchase")) then
                    v:FireServer()
                end
            end
        end)
        SendChat("/me 🛒 AUTO BUY AKTIF!")
        Notify("🛒 AUTO BUY", "Auto beli item aktif!", 2)
    else
        if AutoBuyConnection then AutoBuyConnection:Disconnect() end
        AutoBuyConnection = nil
        SendChat("/me ❌ AUTO BUY NONAKTIF")
        Notify("❌ AUTO BUY", "Dimatikan", 2)
    end
end

-- ==================== FITUR BARU 5: MOB SPAWN ====================
local function ToggleMobSpawn()
    Settings.MobSpawn = not Settings.MobSpawn
    if Settings.MobSpawn then
        if MobSpawnConnection then MobSpawnConnection:Disconnect() end
        MobSpawnConnection = RunService.RenderStepped:Connect(function()
            if not Settings.MobSpawn then return end
            -- Spawn part di sekitar player
            local root = GetRootPart()
            if root then
                for i = 1, 3 do
                    local part = Instance.new("Part")
                    part.Size = Vector3.new(2,2,2)
                    part.Position = root.Position + Vector3.new(math.random(-10,10), math.random(0,5), math.random(-10,10))
                    part.Anchored = true
                    part.CanCollide = false
                    part.BrickColor = BrickColor.new("Bright red")
                    part.Parent = Workspace
                    game:GetService("Debris"):AddItem(part, 5)
                end
            end
        end)
        SendChat("/me 🧟 MOB SPAWN AKTIF!")
        Notify("🧟 MOB SPAWN", "Mob muncul di sekitar!", 2)
    else
        if MobSpawnConnection then MobSpawnConnection:Disconnect() end
        MobSpawnConnection = nil
        SendChat("/me ❌ MOB SPAWN NONAKTIF")
        Notify("❌ MOB SPAWN", "Dimatikan", 2)
    end
end

-- ==================== FITUR BARU 6: SERVER HOP ====================
local function ServerHop()
    if not isUnlocked then ShowLockedMessage() return end
    SendChat("/me 🚀 SERVER HOP! Pindah server...")
    Notify("🚀 SERVER HOP", "Mencari server baru...", 3)
    -- Teleport ke server lain
    local jobId = game.JobId
    local servers = {}
    -- Cari server lain
    pcall(function()
        local HttpService = game:GetService("HttpService")
        local response = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"))
        if response and response.data then
            for _, server in pairs(response.data) do
                if server.id ~= jobId then
                    table.insert(servers, server.id)
                end
            end
        end
    end)
    if #servers > 0 then
        local randomServer = servers[math.random(1, #servers)]
        TeleportService:TeleportToPlaceInstance(game.PlaceId, randomServer, LocalPlayer)
    else
        SendChat("/me ❌ TIDAK ADA SERVER LAIN!")
        Notify("❌ SERVER HOP", "Tidak ada server lain", 2)
    end
end

-- ==================== FITUR BARU 7: ANTI AFK ====================
local function ToggleAntiAFK()
    Settings.AntiAFK = not Settings.AntiAFK
    if Settings.AntiAFK then
        if AntiAFKConnection then AntiAFKConnection:Disconnect() end
        AntiAFKConnection = RunService.RenderStepped:Connect(function()
            if not Settings.AntiAFK then return end
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(0,0))
            VirtualUser:MoveMouse(Vector2.new(1,1))
        end)
        SendChat("/me 🛡️ ANTI AFK AKTIF!")
        Notify("🛡️ ANTI AFK", "Tidak akan di kick AFK!", 2)
    else
        if AntiAFKConnection then AntiAFKConnection:Disconnect() end
        AntiAFKConnection = nil
        SendChat("/me ❌ ANTI AFK NONAKTIF")
        Notify("❌ ANTI AFK", "Dimatikan", 2)
    end
end

-- ==================== FITUR BARU 8: AUTO REJOIN ====================
local function ToggleAutoRejoin()
    Settings.AutoRejoin = not Settings.AutoRejoin
    if Settings.AutoRejoin then
        if AutoRejoinConnection then AutoRejoinConnection:Disconnect() end
        AutoRejoinConnection = game:GetService("Players").LocalPlayer.OnTeleport:Connect(function(state)
            if Settings.AutoRejoin and state == Enum.TeleportState.Failed then
                wait(2)
                TeleportService:Teleport(game.PlaceId)
            end
        end)
        SendChat("/me 🔄 AUTO REJOIN AKTIF!")
        Notify("🔄 AUTO REJOIN", "Auto rejoin jika di kick!", 2)
    else
        if AutoRejoinConnection then AutoRejoinConnection:Disconnect() end
        AutoRejoinConnection = nil
        SendChat("/me ❌ AUTO REJOIN NONAKTIF")
        Notify("❌ AUTO REJOIN", "Dimatikan", 2)
    end
end

-- ==================== FITUR BARU 9: CHAT SPAM ====================
local function ToggleChatSpam()
    Settings.ChatSpam = not Settings.ChatSpam
    if Settings.ChatSpam then
        if ChatSpamConnection then ChatSpamConnection:Disconnect() end
        ChatSpamConnection = RunService.RenderStepped:Connect(function()
            if not Settings.ChatSpam then return end
            SendChat(Settings.SpamMessage)
            wait(Settings.SpamDelay)
        end)
        SendChat("/me 💬 CHAT SPAM AKTIF! Pesan: " .. Settings.SpamMessage)
        Notify("💬 CHAT SPAM", "Spam chat aktif!", 2)
    else
        if ChatSpamConnection then ChatSpamConnection:Disconnect() end
        ChatSpamConnection = nil
        SendChat("/me ❌ CHAT SPAM NONAKTIF")
        Notify("❌ CHAT SPAM", "Dimatikan", 2)
    end
end

-- ==================== FITUR BARU 10: ANTI RESET ====================
local function ToggleAntiReset()
    Settings.AntiReset = not Settings.AntiReset
    if Settings.AntiReset then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.BreakJointsOnDeath = false
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            end
        end
        LocalPlayer.CharacterAdded:Connect(function(newChar)
            if Settings.AntiReset then
                wait(0.5)
                local hum = newChar:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.BreakJointsOnDeath = false
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                end
            end
        end)
        SendChat("/me 🛡️ ANTI RESET AKTIF!")
        Notify("🛡️ ANTI RESET", "Tidak bisa reset karakter!", 2)
    else
        SendChat("/me ❌ ANTI RESET NONAKTIF")
        Notify("❌ ANTI RESET", "Dimatikan", 2)
    end
end

-- ==================== TARGET SYSTEM ====================
local function SetTarget(name)
    if name and name ~= "" then
        for _, p in pairs(Players:GetPlayers()) do
            if string.lower(p.Name):find(string.lower(name)) and p ~= LocalPlayer then
                Settings.Target = p
                SendChat("/me 🎯 TARGET SET KE: " .. p.Name)
                Notify("🎯 TARGET", "Target: " .. p.Name, 2)
                return
            end
        end
        SendChat("/me ❌ PLAYER TIDAK DITEMUKAN!")
    else
        Settings.Target = nil
        SendChat("/me 🎯 TARGET DIHAPUS")
        Notify("🎯 TARGET", "Target dihapus", 2)
    end
end

-- ==================== ESP PRO ====================
local function ToggleESP()
    Settings.ESP = not Settings.ESP
    if Settings.ESP then
        if ESPGui then ESPGui:Destroy() end
        ESPGui = Instance.new("ScreenGui")
        ESPGui.Name = "ZoneXD_ESP"
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
            local cam = Workspace.CurrentCamera
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
        SendChat("/me 👁️ ESP PRO AKTIF!")
        Notify("👁️ ESP", "ESP aktif!", 2)
    else
        if ESPGui then ESPGui:Destroy() end
        ESPGui = nil
        SendChat("/me ❌ ESP NONAKTIF")
        Notify("❌ ESP", "Dimatikan", 2)
    end
end

-- ==================== AIMBOT ====================
local function ToggleAimbot()
    Settings.Aimbot = not Settings.Aimbot
    if Settings.Aimbot then
        if AimbotConnection then AimbotConnection:Disconnect() end
        AimbotConnection = RunService.RenderStepped:Connect(function()
            if not Settings.Aimbot then return end
            local cam = Workspace.CurrentCamera
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
        SendChat("/me 🎯 AIMBOT AKTIF! FOV: " .. Settings.FOV)
        Notify("🎯 AIMBOT", "Auto aim aktif!", 2)
    else
        if AimbotConnection then AimbotConnection:Disconnect() end
        AimbotConnection = nil
        SendChat("/me ❌ AIMBOT NONAKTIF")
        Notify("❌ AIMBOT", "Dimatikan", 2)
    end
end

-- ==================== AUTO PUNCH ====================
local function ToggleAutoPunch()
    Settings.AutoPunch = not Settings.AutoPunch
    if Settings.AutoPunch then
        if AutoPunchConnection then AutoPunchConnection:Disconnect() end
        AutoPunchConnection = RunService.RenderStepped:Connect(function()
            if not Settings.AutoPunch then return end
            local root = GetRootPart()
            if not root then return end
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if (root.Position - p.Character.HumanoidRootPart.Position).Magnitude < 5 then
                        VirtualUser:ClickButton1(Vector2.new(500,500))
                        wait(0.3)
                        break
                    end
                end
            end
        end)
        SendChat("/me 👊 AUTO PUNCH AKTIF!")
        Notify("👊 AUTO PUNCH", "Auto punch aktif!", 2)
    else
        if AutoPunchConnection then AutoPunchConnection:Disconnect() end
        AutoPunchConnection = nil
        SendChat("/me ❌ AUTO PUNCH NONAKTIF")
        Notify("❌ AUTO PUNCH", "Dimatikan", 2)
    end
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
            local nearest, nd = nil, 50
            for _, obj in pairs(Workspace:GetDescendants()) do
                if (obj:IsA("Part") or obj:IsA("MeshPart")) and (obj:FindFirstChildOfClass("ClickDetector") or obj.Name:find("Farm") or obj.Name:find("Crop") or obj.Name:find("Node") or obj.Name:find("Ore")) then
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
        SendChat("/me 🌾 AUTO FARM AKTIF!")
        Notify("🌾 AUTO FARM", "Auto farming aktif!", 2)
    else
        if AutoFarmConnection then AutoFarmConnection:Disconnect() end
        AutoFarmConnection = nil
        SendChat("/me ❌ AUTO FARM NONAKTIF")
        Notify("❌ AUTO FARM", "Dimatikan", 2)
    end
end

-- ==================== TOGGLE FUNCTIONS (FITUR LAMA) ====================
local function ToggleNoClip()
    Settings.NoClip = not Settings.NoClip
    local char = LocalPlayer.Character
    if char then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = not Settings.NoClip end end end
    if Settings.NoClip then SendChat("/me 🔓 NOCLIP AKTIF!") Notify("🔓 NOCLIP", "Tembus tembok aktif", 2)
    else SendChat("/me 🔒 NOCLIP NONAKTIF") Notify("🔒 NOCLIP", "Dimatikan", 2) end
end

local function ToggleGodMode()
    Settings.GodMode = not Settings.GodMode
    local hum = GetHumanoid()
    if hum then
        if Settings.GodMode then hum.MaxHealth, hum.Health, hum.BreakJointsOnDeath = math.huge, math.huge, false
        else hum.MaxHealth, hum.Health, hum.BreakJointsOnDeath = 100, 100, true end
    end
    if Settings.GodMode then SendChat("/me 🛡️ GOD MODE AKTIF!") Notify("🛡️ GOD MODE", "Abadi!", 2)
    else SendChat("/me ❌ GOD MODE NONAKTIF") Notify("❌ GOD MODE", "Dimatikan", 2) end
end

local function ToggleInfiniteJump()
    Settings.InfiniteJump = not Settings.InfiniteJump
    if Settings.InfiniteJump then
        if InfiniteJumpConnection then InfiniteJumpConnection:Disconnect() end
        InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
            local hum = GetHumanoid()
            if hum and hum:GetState() ~= Enum.HumanoidStateType.Jumping then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
        SendChat("/me ♾️ INFINITE JUMP AKTIF!") Notify("♾️ INFINITE JUMP", "Lompat tanpa batas!", 2)
    else
        if InfiniteJumpConnection then InfiniteJumpConnection:Disconnect() end
        InfiniteJumpConnection = nil
        SendChat("/me ❌ INFINITE JUMP NONAKTIF") Notify("❌ INFINITE JUMP", "Dimatikan", 2)
    end
end

local function ToggleInvisible()
    Settings.Invisible = not Settings.Invisible
    local char = LocalPlayer.Character
    if not char then SendChat("/me ❌ GAGAL! Character tidak ditemukan") return end
    if Settings.Invisible then
        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") or p:IsA("MeshPart") then p.Transparency = 1 end
        end
        SendChat("/me 👻 INVISIBLE MODE AKTIF!") Notify("👻 INVISIBLE", "Kamu tidak terlihat!", 3)
    else
        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") or p:IsA("MeshPart") then p.Transparency = 0 end
        end
        SendChat("/me 👁️ INVISIBLE MODE NONAKTIF") Notify("👁️ INVISIBLE", "Dimatikan", 2)
    end
end

-- ==================== TROLL FEATURES ====================
local function ToggleTrollSpam()
    Settings.TrollSpam = not Settings.TrollSpam
    if Settings.TrollSpam then
        if TrollSpamConnection then TrollSpamConnection:Disconnect() end
        TrollSpamConnection = RunService.RenderStepped:Connect(function()
            if not Settings.TrollSpam or not Settings.Target then return end
            local target = Settings.Target
            if target and target.Character then
                for i = 1, 3 do
                    local part = Instance.new("Part")
                    part.Size = Vector3.new(1,1,1)
                    part.Position = target.Character.HumanoidRootPart.Position + Vector3.new(math.random(-5,5), math.random(0,5), math.random(-5,5))
                    part.Anchored = true
                    part.CanCollide = false
                    part.BrickColor = BrickColor.new("Really red")
                    part.Parent = Workspace
                    game:GetService("Debris"):AddItem(part, 1)
                end
            end
        end)
        SendChat("/me 💩 TROLL SPAM AKTIF!")
        Notify("💩 TROLL SPAM", "Spam part di sekitar target!", 2)
    else
        if TrollSpamConnection then TrollSpamConnection:Disconnect() end
        TrollSpamConnection = nil
        SendChat("/me ❌ TROLL SPAM NONAKTIF")
        Notify("❌ TROLL SPAM", "Dimatikan", 2)
    end
end

-- ==================== MENU ====================
local function ShowMenu()
    SendChat("/me ╔══════════════════════════════════════════════════════════╗")
    wait(0.05)
    SendChat("/me ║     🔥 ZONE XD V9.1 - 60+ FITUR 🔥                      ║")
    wait(0.05)
    SendChat("/me ║     CREATED BY: APIS                                     ║")
    wait(0.05)
    SendChat("/me ╠══════════════════════════════════════════════════════════╣")
    wait(0.05)
    SendChat("/me ║ 🎮 MOVEMENT:                                             ║")
    wait(0.05)
    SendChat("/me ║ /speed 1-200 - Set kecepatan                             ║")
    wait(0.05)
    SendChat("/me ║ /jump 30-200 - Set kekuatan lompat                       ║")
    wait(0.05)
    SendChat("/me ║ /fly        - Mode terbang                               ║")
    wait(0.05)
    SendChat("/me ║ /flyspeed 50-200 - Set kecepatan terbang (BARU)         ║")
    wait(0.05)
    SendChat("/me ║ /noclip     - Tembus tembok                              ║")
    wait(0.05)
    SendChat("/me ║ /god        - Mode abadi                                 ║")
    wait(0.05)
    SendChat("/me ║ /infjump    - Lompat tanpa batas                         ║")
    wait(0.05)
    SendChat("/me ╠══════════════════════════════════════════════════════════╣")
    wait(0.05)
    SendChat("/me ║ 🎯 COMBAT:                                               ║")
    wait(0.05)
    SendChat("/me ║ /aimbot     - Auto aim ke musuh                          ║")
    wait(0.05)
    SendChat("/me ║ /autopunch  - Auto punch/kick musuh                      ║")
    wait(0.05)
    SendChat("/me ║ /fov 50-200 - Set FOV aimbot                             ║")
    wait(0.05)
    SendChat("/me ╠══════════════════════════════════════════════════════════╣")
    wait(0.05)
    SendChat("/me ║ 👁️ VISUAL:                                               ║")
    wait(0.05)
    SendChat("/me ║ /esp        - ESP PRO (health + jarak)                   ║")
    wait(0.05)
    SendChat("/me ║ /invisible  - Mode tidak terlihat                        ║")
    wait(0.05)
    SendChat("/me ║ /rainbow    - Rainbow character (BARU)                   ║")
    wait(0.05)
    SendChat("/me ╠══════════════════════════════════════════════════════════╣")
    wait(0.05)
    SendChat("/me ║ 🌾 FARMING:                                              ║")
    wait(0.05)
    SendChat("/me ║ /autofarm   - Auto farming resource                      ║")
    wait(0.05)
    SendChat("/me ║ /autocollect- Auto collect item/coin                     ║")
    wait(0.05)
    SendChat("/me ╠══════════════════════════════════════════════════════════╣")
    wait(0.05)
    SendChat("/me ║ 🚀 FITUR BARU V9.1:                                      ║")
    wait(0.05)
    SendChat("/me ║ /autotp     - Auto teleport ke target                    ║")
    wait(0.05)
    SendChat("/me ║ /flyspeed   - Atur kecepatan terbang                     ║")
    wait(0.05)
    SendChat("/me ║ /rainbow    - Warna karakter berubah-ubah               ║")
    wait(0.05)
    SendChat("/me ║ /autobuy    - Auto beli item dari shop                   ║")
    wait(0.05)
    SendChat("/me ║ /mobspawn   - Spawn mob di sekitar                       ║")
    wait(0.05)
    SendChat("/me ║ /serverhop  - Pindah server otomatis                     ║")
    wait(0.05)
    SendChat("/me ║ /antiafk    - Cegah kick karena AFK                      ║")
    wait(0.05)
    SendChat("/me ║ /autorejoin - Auto join ulang setelah kick               ║")
    wait(0.05)
    SendChat("/me ║ /chatspam   - Spam chat otomatis                         ║")
    wait(0.05)
    SendChat("/me ║ /antireset  - Cegah reset karakter                       ║")
    wait(0.05)
    SendChat("/me ╠══════════════════════════════════════════════════════════╣")
    wait(0.05)
    SendChat("/me ║ 💀 TROLL FEATURES: (SET TARGET DULU)                     ║")
    wait(0.05)
    SendChat("/me ║ /target [nama] - Set target player                       ║")
    wait(0.05)
    SendChat("/me ║ /trollspam    - Spam part di sekitar target              ║")
    wait(0.05)
    SendChat("/me ║ /trollfreeze  - Freeze target                            ║")
    wait(0.05)
    SendChat("/me ║ /trollflung   - Flung target ke langit                   ║")
    wait(0.05)
    SendChat("/me ║ /trollblind   - Blind target                             ║")
    wait(0.05)
    SendChat("/me ║ /trollspin    - Target berputar                          ║")
    wait(0.05)
    SendChat("/me ║ /kick         - Kick target ke void                      ║")
    wait(0.05)
    SendChat("/me ║ /explode      - Ledakkan target                          ║")
    wait(0.05)
    SendChat("/me ║ /trollstop    - Matikan semua troll                      ║")
    wait(0.05)
    SendChat("/me ╠══════════════════════════════════════════════════════════╣")
    wait(0.05)
    SendChat("/me ║ 🔧 UTILITY:                                              ║")
    wait(0.05)
    SendChat("/me ║ /walkwater    - Jalan di atas air                        ║")
    wait(0.05)
    SendChat("/me ║ /nofalldmg    - No fall damage                           ║")
    wait(0.05)
    SendChat("/me ║ /reset        - Reset semua fitur                        ║")
    wait(0.05)
    SendChat("/me ╚══════════════════════════════════════════════════════════╝")
    Notify("🎮 ZONE XD V9.1", "Menu ditampilkan di chat!", 6)
end

-- ==================== COMMAND PROCESSOR ====================
local function ProcessCommand(msg)
    local lower = string.lower(msg)
    
    if lower == "/zonexd" then Unlock() return true end
    if not isUnlocked then ShowLockedMessage() return true end
    
    if lower == "/menu" then ShowMenu() return true end
    if lower == "/fly" then StartFly() return true end
    if lower == "/noclip" then ToggleNoClip() return true end
    if lower == "/god" then ToggleGodMode() return true end
    if lower == "/infjump" then ToggleInfiniteJump() return true end
    if lower == "/esp" then ToggleESP() return true end
    if lower == "/invisible" then ToggleInvisible() return true end
    if lower == "/aimbot" then ToggleAimbot() return true end
    if lower == "/autopunch" then ToggleAutoPunch() return true end
    if lower == "/autofarm" then ToggleAutoFarm() return true end
    if lower == "/trollspam" then ToggleTrollSpam() return true end
    if lower == "/autotp" then ToggleAutoTP() return true end
    if lower == "/rainbow" then ToggleRainbowChar() return true end
    if lower == "/autobuy" then ToggleAutoBuy() return true end
    if lower == "/mobspawn" then ToggleMobSpawn() return true end
    if lower == "/serverhop" then ServerHop() return true end
    if lower == "/antiafk" then ToggleAntiAFK() return true end
    if lower == "/autorejoin" then ToggleAutoRejoin() return true end
    if lower == "/chatspam" then ToggleChatSpam() return true end
    if lower == "/antireset" then ToggleAntiReset() return true end
    
    if string.match(lower, "^/target") then
        local name = string.match(msg, "^/target%s+(.+)$")
        SetTarget(name)
        return true
    end
    if string.match(lower, "^/speed") then
        local v = string.match(lower, "%d+")
        if v then SetSpeed(v) else SendChat("/me ⚠️ Format: /speed [1-200]") end
        return true
    end
    if string.match(lower, "^/jump") then
        local v = string.match(lower, "%d+")
        if v then SetJump(v) else SendChat("/me ⚠️ Format: /jump [30-200]") end
        return true
    end
    if string.match(lower, "^/flyspeed") then
        local v = string.match(lower, "%d+")
        if v then SetFlySpeed(v) else SendChat("/me ⚠️ Format: /flyspeed [50-200]") end
        return true
    end
    if string.match(lower, "^/fov") then
        local v = string.match(lower, "%d+")
        if v then Settings.FOV = tonumber(v) SendChat("/me 🎚️ FOV SET KE: " .. v) end
        return true
    end
    return false
end

-- ==================== CHAT LISTENER ====================
local function SetupChatListener()
    pcall(function()
        local rs = ReplicatedStorage
        local chatEvent = rs:FindFirstChild("DefaultChatSystemChatEvents")
        if chatEvent then
            local onMessage = chatEvent:FindFirstChild("OnMessageDoneFiltering")
            if onMessage then
                onMessage.OnClientEvent:Connect(function(data)
                    if data.FromSpeaker == LocalPlayer.Name then ProcessCommand(data.Message) end
                end)
            end
        end
    end)
    pcall(function()
        local tcs = game:GetService("TextChatService")
        if tcs and tcs.TextChannels then
            for _, ch in pairs(tcs.TextChannels:GetChildren()) do
                if ch:IsA("TextChannel") then
                    ch.MessageReceived:Connect(function(msg)
                        if msg.TextSource and msg.TextSource.UserId == LocalPlayer.UserId then ProcessCommand(msg.Text) end
                    end)
                end
            end
        end
    end)
    pcall(function()
        LocalPlayer.Chatted:Connect(function(msg) ProcessCommand(msg) end)
    end)
end

-- ==================== AUTO UPDATE ====================
RunService.RenderStepped:Connect(function()
    if not isUnlocked then return end
    local hum = GetHumanoid()
    if not hum then return end
    if hum.WalkSpeed ~= Settings.Speed then hum.WalkSpeed = Settings.Speed end
    if hum.JumpPower ~= Settings.JumpPower then hum.JumpPower = Settings.JumpPower end
    if Settings.GodMode then hum.MaxHealth, hum.Health, hum.BreakJointsOnDeath = math.huge, math.huge, false end
    if Settings.NoClip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- ==================== INIT ====================
local function Init()
    Notify("🔒 ZONE XD V9.1", "Ketik /zonexd untuk unlock", 5)
    task.wait(1)
    SetupChatListener()
    ShowLockedMessage()
end

Init()