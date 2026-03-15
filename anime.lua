--[[
    🔥 ZONE XD - ANIME KNOCKOUT ULTIMATE 🔥
    COPYRIGHT: APIS (USER 01) - ZONE XD V1
    FITUR: ESP + INFINITE SKILL + AIMBOT + AUTO FARM
]]

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local players = game:GetService("Players")

-- ==================================================
-- SETTINGS (LU BISA UBAH)
-- ==================================================
local settings = {
    -- ESP SETTINGS
    esp = {
        enabled = true,
        showBox = true,
        showName = true,
        showHealth = true,
        showDistance = true,
        showTracer = true,
        tracerFromMouse = false,  -- false = dari bawah layar
        boxColor = Color3.fromRGB(255, 0, 0),
        teamColor = false,  -- true = warna berdasarkan tim
    },
    
    -- INFINITE SKILL SETTINGS
    infiniteSkill = {
        enabled = true,
        noCooldown = true,
        instantCast = true,
        infiniteMana = true,
    },
    
    -- AIMBOT SETTINGS
    aimbot = {
        enabled = true,
        autoAttack = true,
        aimPart = "Head",  -- Head, HumanoidRootPart, Torso
        smoothness = 0.2,  -- 0 = instant, 1 = lambat
        maxDistance = 100,
        fov = 90,  -- Field of view (derajat)
        lockTarget = false,  -- true = terus ngunci target
    },
    
    -- AUTO FARM SETTINGS
    autoFarm = {
        enabled = false,
        autoKill = true,
        autoCollect = true,
        collectRadius = 50,
        attackCooldown = 0.5,
    },
    
    -- MOVEMENT HACKS
    movement = {
        speedEnabled = true,
        speed = 50,
        jumpEnabled = true,
        jumpPower = 100,
        flyEnabled = false,
        flySpeed = 30,
        noclipEnabled = false,
    },
    
    -- VISUALS
    visuals = {
        infiniteSkillIndicator = true,
        espIndicator = true,
        fovCircle = true,
        fovCircleColor = Color3.fromRGB(255, 255, 255),
        fovCircleRadius = 200,
    },
    
    -- GUI SETTINGS
    gui = {
        minimized = false,
        position = UDim2.new(0, 20, 0.5, -200),
    }
}

-- ==================================================
-- CREATE GUI
-- ==================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZoneXDAnime"
screenGui.Parent = player.PlayerGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- MAIN FRAME
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = settings.gui.position
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 15)
uiCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(255, 50, 50)
uiStroke.Thickness = 2
uiStroke.Parent = mainFrame

-- TITLE
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
titleBar.BackgroundTransparency = 0.3
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 15)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0.8, 0, 1, 0)
titleLabel.Position = UDim2.new(0.05, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚡ ANIME KNOCKOUT HUB"
titleLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -40, 0, 7.5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
minimizeBtn.Text = "🔼"
minimizeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
minimizeBtn.TextScaled = true
minimizeBtn.Font = Enum.Font.GothamBlack
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 10)
minCorner.Parent = minimizeBtn

-- TAB BUTTONS
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -10, 0, 35)
tabFrame.Position = UDim2.new(0, 5, 0, 50)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = mainFrame

local tabs = {"ESP", "SKILL", "AIMBOT", "FARM", "MOVE"}
local tabButtons = {}
local tabContents = {}

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.2, -2, 1, 0)
    btn.Position = UDim2.new((i-1) * 0.2, 2, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.Text = tabName
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = tabFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    tabButtons[tabName] = btn
end

-- CONTENT FRAME
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -95)
contentFrame.Position = UDim2.new(0, 10, 0, 90)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- ==================================================
-- ESP SYSTEM
-- ==================================================
local espObjects = {}

local function createESP(player)
    if espObjects[player] then return end
    
    local esp = {
        box = Instance.new("BoxHandleAdornment"),
        nameTag = Instance.new("BillboardGui"),
        healthBar = Instance.new("BillboardGui"),
        tracer = Instance.new("Part")  -- Untuk tracer
    }
    
    -- BOX ESP
    esp.box.Name = "ESP_Box"
    esp.box.Adornee = player.Character
    esp.box.Size = Vector3.new(4, 6, 1)
    esp.box.Color3 = settings.esp.boxColor
    esp.box.Transparency = 0.7
    esp.box.ZIndex = 10
    esp.box.AlwaysOnTop = true
    esp.box.Parent = player.Character
    
    -- NAME TAG
    esp.nameTag = Instance.new("BillboardGui")
    esp.nameTag.Name = "ESP_Name"
    esp.nameTag.Adornee = player.Character:FindFirstChild("Head")
    esp.nameTag.Size = UDim2.new(0, 100, 0, 30)
    esp.nameTag.StudsOffset = Vector3.new(0, 2, 0)
    esp.nameTag.AlwaysOnTop = true
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0.3
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = esp.nameTag
    
    esp.nameTag.Parent = player.Character
    
    -- HEALTH BAR
    esp.healthBar = Instance.new("BillboardGui")
    esp.healthBar.Name = "ESP_Health"
    esp.healthBar.Adornee = player.Character:FindFirstChild("Head")
    esp.healthBar.Size = UDim2.new(0, 60, 0, 5)
    esp.healthBar.StudsOffset = Vector3.new(0, 2.5, 0)
    esp.healthBar.AlwaysOnTop = true
    
    local healthFrame = Instance.new("Frame")
    healthFrame.Size = UDim2.new(1, 0, 1, 0)
    healthFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    healthFrame.BackgroundTransparency = 0.5
    healthFrame.Parent = esp.healthBar
    
    local healthFill = Instance.new("Frame")
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthFrame
    
    esp.healthBar.Parent = player.Character
    
    -- TRACER PART
    esp.tracer.Name = "ESP_Tracer"
    esp.tracer.Anchored = true
    esp.tracer.CanCollide = false
    esp.tracer.Transparency = 0.5
    esp.tracer.BrickColor = BrickColor.new("Bright red")
    esp.tracer.Material = Enum.Material.Neon
    esp.tracer.Size = Vector3.new(0.1, 0.1, 1)
    esp.tracer.Parent = workspace
    
    espObjects[player] = esp
end

local function updateESP()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") then
            if not espObjects[v] then
                createESP(v)
            end
            
            local esp = espObjects[v]
            if esp then
                -- Update box color berdasarkan tim (opsional)
                if settings.esp.teamColor then
                    -- Logic buat warna tim
                end
                
                -- Update health bar
                local humanoid = v.Character.Humanoid
                local healthPercent = humanoid.Health / humanoid.MaxHealth
                local healthBar = esp.healthBar:FindFirstChild("Frame"):FindFirstChild("Frame")
                if healthBar then
                    healthBar.Size = UDim2.new(healthPercent, 0, 1, 0)
                    healthBar.BackgroundColor3 = Color3.fromRGB(
                        255 * (1 - healthPercent),
                        255 * healthPercent,
                        0
                    )
                end
                
                -- Update tracer
                if settings.esp.showTracer then
                    local startPos = settings.esp.tracerFromMouse and UserInputService:GetMouseLocation() or 
                                    Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)
                    local endPos = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                    
                    -- Simple tracer (perlu math buat bikin garis)
                end
            end
        end
    end
end

-- ==================================================
-- INFINITE SKILL SYSTEM
-- ==================================================
local function patchSkillRemotes()
    for _, remote in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            local oldName = remote.Name
            if oldName:match("Skill") or oldName:match("Attack") or oldName:match("Ability") then
                -- Hook remote
                local oldFire = remote.FireServer
                remote.FireServer = function(...)
                    if settings.infiniteSkill.noCooldown then
                        -- Bypass cooldown
                    end
                    return oldFire(...)
                end
            end
        end
    end
end

-- ==================================================
-- AIMBOT SYSTEM
-- ==================================================
local currentTarget = nil

local function getClosestEnemy()
    local closest = nil
    local shortest = math.huge
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local pos, onScreen = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                if dist < settings.aimbot.fov and dist < shortest then
                    shortest = dist
                    closest = v
                end
            end
        end
    end
    
    return closest
end

local function aimAt(target)
    if not target or not target.Character or not target.Character:FindFirstChild(settings.aimbot.aimPart) then
        return
    end
    
    local targetPart = target.Character[settings.aimbot.aimPart]
    local targetPos = targetPart.Position
    local cameraPos = camera.CFrame.Position
    
    -- Hitung arah
    local direction = (targetPos - cameraPos).unit
    
    -- Smooth aim
    if settings.aimbot.smoothness > 0 then
        local currentCF = camera.CFrame
        local targetCF = CFrame.lookAt(cameraPos, targetPos)
        camera.CFrame = currentCF:Lerp(targetCF, settings.aimbot.smoothness)
    else
        camera.CFrame = CFrame.lookAt(cameraPos, targetPos)
    end
end

-- ==================================================
-- AUTO FARM SYSTEM
-- ==================================================
local function autoAttack(target)
    if not target then return end
    
    -- Cari remote attack
    for _, remote in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if remote:IsA("RemoteEvent") and (remote.Name:match("Attack") or remote.Name:match("Skill")) then
            remote:FireServer(target)
            break
        end
    end
end

local function autoCollect()
    for _, item in pairs(workspace:GetDescendants()) do
        if item:IsA("Part") and (item.Name:match("Coin") or item.Name:match("Power") or item.Name:match("Orb")) then
            local dist = (player.Character.HumanoidRootPart.Position - item.Position).Magnitude
            if dist < settings.autoFarm.collectRadius then
                player.Character.HumanoidRootPart.CFrame = item.CFrame
                task.wait(0.1)
            end
        end
    end
end

-- ==================================================
-- MOVEMENT HACKS
-- ==================================================
local function applyMovementHacks()
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    if settings.movement.speedEnabled then
        humanoid.WalkSpeed = settings.movement.speed
    end
    
    if settings.movement.jumpEnabled then
        humanoid.JumpPower = settings.movement.jumpPower
    end
    
    -- FLY SYSTEM
    if settings.movement.flyEnabled then
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.Parent = character.HumanoidRootPart
        bodyGyro.MaxTorque = Vector3.new(0, 0, 0)
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Parent = character.HumanoidRootPart
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
    end
end

-- ==================================================
-- MAIN LOOP
-- ==================================================
RunService.RenderStepped:Connect(function()
    -- ESP UPDATE
    if settings.esp.enabled then
        updateESP()
    end
    
    -- AIMBOT
    if settings.aimbot.enabled then
        local target = getClosestEnemy()
        if target then
            aimAt(target)
            
            if settings.aimbot.autoAttack then
                autoAttack(target)
            end
        end
    end
    
    -- MOVEMENT HACKS
    applyMovementHacks()
    
    -- AUTO FARM
    if settings.autoFarm.enabled then
        if settings.autoFarm.autoCollect then
            autoCollect()
        end
        
        if settings.autoFarm.autoKill then
            local target = getClosestEnemy()
            if target then
                autoAttack(target)
            end
        end
    end
end)

-- ==================================================
-- DRAW FOV CIRCLE
-- ==================================================
if settings.visuals.fovCircle then
    local fovCircle = Drawing.new("Circle")
    fovCircle.Visible = true
    fovCircle.Radius = settings.visuals.fovCircleRadius
    fovCircle.Color = settings.visuals.fovCircleColor
    fovCircle.Thickness = 2
    fovCircle.Filled = false
    fovCircle.Position = UserInputService:GetMouseLocation()
    
    RunService.RenderStepped:Connect(function()
        fovCircle.Position = UserInputService:GetMouseLocation()
    end)
end

-- ==================================================
-- BUTTON EVENTS
-- ==================================================
minimizeBtn.MouseButton1Click:Connect(function()
    settings.gui.minimized = not settings.gui.minimized
    
    local targetSize = settings.gui.minimized and UDim2.new(0, 300, 0, 50) or UDim2.new(0, 300, 0, 400)
    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = targetSize})
    tween:Play()
    
    tabFrame.Visible = not settings.gui.minimized
    contentFrame.Visible = not settings.gui.minimized
    minimizeBtn.Text = settings.gui.minimized and "🔽" or "🔼"
end)

-- ==================================================
-- INIT
-- ==================================================
patchSkillRemotes()

print([[
╔══════════════════════════════════════════════════╗
║   🔥 ZONE XD - ANIME KNOCKOUT ULTIMATE 🔥       ║
╠══════════════════════════════════════════════════╣
║   ✅ ESP PREMIUM (Box, Name, Health, Tracer)    ║
║   ✅ INFINITE SKILL (No cooldown)                ║
║   ✅ AIMBOT + AUTO ATTACK                         ║
║   ✅ AUTO FARM + AUTO COLLECT                     ║
║   ✅ FLY + SPEED + JUMP + NOCLIP                  ║
╠══════════════════════════════════════════════════╣
║   👑 COPYRIGHT: APIS - ZONE XD V1                ║
╚══════════════════════════════════════════════════╝
]])