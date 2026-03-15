--[[
    🔥 ZONE XD - UNIVERSAL SELECTOR (DENGAN MINIMIZE) 🔥
    COPYRIGHT: APIS 2026
    FITUR: List player + Random + Minimize button + Universal
]]

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- ==================================================
-- SETTINGS MINIMIZE
-- ==================================================
local isMinimized = false
local fullSize = UDim2.new(0, 260, 0, 380)
local minimizedSize = UDim2.new(0, 260, 0, 50)

-- ==================================================
-- CREATE GUI UTAMA
-- ==================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZoneXD_Universal"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true

-- MAIN FRAME
local mainFrame = Instance.new("Frame")
mainFrame.Size = fullSize
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 15)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true  -- Biar kontennya ilang pas minimize

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(255, 50, 50)
mainStroke.Thickness = 2
mainStroke.Parent = mainFrame

-- TITLE BAR (BUAT TEMPAT TOMBOL)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
titleBar.BackgroundTransparency = 0.3
titleBar.Parent = mainFrame

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0, 15)
barCorner.Parent = titleBar

-- TITLE
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0.6, 0, 1, 0)
titleLabel.Position = UDim2.new(0.05, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚡ ZONE XD"
titleLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- TOMBOL MINIMIZE (_)
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -75, 0, 10)
minBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
minBtn.Text = "🗕"  -- Ikon minimize
minBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
minBtn.TextScaled = true
minBtn.Font = Enum.Font.GothamBlack
minBtn.BorderSizePixel = 0
minBtn.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = minBtn

-- TOMBOL CLOSE (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBlack
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- ==================================================
-- KONTEN UTAMA (YANG DI-MINIMIZE)
-- ==================================================
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -50)
contentFrame.Position = UDim2.new(0, 0, 0, 50)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame
contentFrame.ClipsDescendants = true

-- LIST PLAYER
local playerList = Instance.new("ScrollingFrame")
playerList.Size = UDim2.new(0.9, 0, 0, 200)
playerList.Position = UDim2.new(0.05, 0, 0, 10)
playerList.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
playerList.BackgroundTransparency = 0.5
playerList.BorderSizePixel = 0
playerList.CanvasSize = UDim2.new(0, 0, 0, 0)
playerList.ScrollBarThickness = 5
playerList.Parent = contentFrame

local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 10)
listCorner.Parent = playerList

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, 5)
uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiListLayout.SortOrder = Enum.SortOrder.Name
uiListLayout.Parent = playerList

-- TOMBOL RANDOM
local randomButton = Instance.new("TextButton")
randomButton.Size = UDim2.new(0.8, 0, 0, 45)
randomButton.Position = UDim2.new(0.1, 0, 0, 225)
randomButton.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
randomButton.Text = "🎲 TELEPORT RANDOM"
randomButton.TextColor3 = Color3.fromRGB(255, 255, 255)
randomButton.TextScaled = true
randomButton.Font = Enum.Font.GothamBlack
randomButton.BorderSizePixel = 0
randomButton.Parent = contentFrame

local randomCorner = Instance.new("UICorner")
randomCorner.CornerRadius = UDim.new(0, 15)
randomCorner.Parent = randomButton

-- LABEL INFO
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 25)
infoLabel.Position = UDim2.new(0, 0, 0, 280)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Pilih player di atas atau klik RANDOM"
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
infoLabel.TextScaled = true
infoLabel.Font = Enum.Font.Gotham
infoLabel.Parent = contentFrame

-- ==================================================
-- FUNGSI MINIMIZE
-- ==================================================
local function toggleMinimize()
    isMinimized = not isMinimized
    
    local targetSize = isMinimized and minimizedSize or fullSize
    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = targetSize})
    tween:Play()
    
    -- Sembunyikan/tampilkan konten
    contentFrame.Visible = not isMinimized
    
    -- Ubah ikon tombol
    minBtn.Text = isMinimized and "🗖" or "🗕"
end

minBtn.MouseButton1Click:Connect(toggleMinimize)

-- ==================================================
-- ESP SYSTEM (SEDERHANA)
-- ==================================================
local espHolder = {}

local function createESP(plr)
    if espHolder[plr] then return end
    if not plr.Character then return end
    
    local head = plr.Character:FindFirstChild("Head")
    local humanoid = plr.Character:FindFirstChild("Humanoid")
    
    if not head or not humanoid then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ZoneXD_ESP_" .. plr.Name
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 120, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = plr.Character
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = plr.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = billboard
    
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Size = UDim2.new(1, 0, 0, 10)
    healthLabel.Position = UDim2.new(0, 0, 0, 20)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
    healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    healthLabel.TextScaled = true
    healthLabel.Font = Enum.Font.Gotham
    healthLabel.Parent = billboard
    
    espHolder[plr] = {billboard = billboard, healthLabel = healthLabel}
end

-- Update ESP
RunService.RenderStepped:Connect(function()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player then
            if not espHolder[v] and v.Character then
                createESP(v)
            end
            
            if espHolder[v] and v.Character and v.Character:FindFirstChild("Humanoid") then
                local hum = v.Character.Humanoid
                espHolder[v].healthLabel.Text = math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth)
                
                if hum.Health / hum.MaxHealth > 0.6 then
                    espHolder[v].healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                elseif hum.Health / hum.MaxHealth > 0.3 then
                    espHolder[v].healthLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                else
                    espHolder[v].healthLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                end
            end
        end
    end
end)

-- ==================================================
-- TELEPORT FUNCTION
-- ==================================================
local function teleportToPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then 
        return false 
    end
    
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return false end
    
    player.Character.HumanoidRootPart.CFrame = targetRoot.CFrame * CFrame.new(0, 5, 5)
    
    infoLabel.Text = "✅ TELEPORT KE " .. targetPlayer.Name
    task.wait(2)
    infoLabel.Text = "Pilih player di atas atau klik RANDOM"
    
    return true
end

-- ==================================================
-- UPDATE PLAYER LIST
-- ==================================================
local function updatePlayerList()
    for _, child in pairs(playerList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player then
            local plrButton = Instance.new("TextButton")
            plrButton.Size = UDim2.new(0.95, 0, 0, 35)
            plrButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            plrButton.Text = plr.Name
            plrButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            plrButton.TextScaled = true
            plrButton.Font = Enum.Font.GothamBold
            plrButton.Parent = playerList
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 8)
            btnCorner.Parent = plrButton
            
            plrButton.MouseButton1Click:Connect(function()
                teleportToPlayer(plr)
            end)
            
            plrButton.MouseEnter:Connect(function()
                plrButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            end)
            
            plrButton.MouseLeave:Connect(function()
                plrButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            end)
        end
    end
    
    playerList.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
end

-- ==================================================
-- RANDOM TELEPORT
-- ==================================================
randomButton.MouseButton1Click:Connect(function()
    local targets = {}
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player then
            table.insert(targets, plr)
        end
    end
    
    if #targets > 0 then
        local randomTarget = targets[math.random(1, #targets)]
        teleportToPlayer(randomTarget)
    else
        infoLabel.Text = "❌ TIDAK ADA PLAYER LAIN"
        task.wait(2)
        infoLabel.Text = "Pilih player di atas atau klik RANDOM"
    end
end)

-- ==================================================
-- EVENT PLAYER MASUK/KELUAR
-- ==================================================
game.Players.PlayerAdded:Connect(updatePlayerList)
game.Players.PlayerRemoving:Connect(updatePlayerList)

task.wait(1)
updatePlayerList()

-- ==================================================
-- NOTIFIKASI
-- ==================================================
print("🔥 ZONE XD - UNIVERSAL READY!")
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "ZONE XD",
    Text = "Tekan _ buat minimize, pilih player atau RANDOM!",
    Duration = 5
})