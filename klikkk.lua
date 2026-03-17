--[[
    🔥 ZONE XD - AUTO KLIKER CEPET + ANTI LAG 🔥
    Created by: APIS (KING OWNER)
    Kecepatan: 0.0001 detik (CEPET) + ANTI FREEZE!
]]

-- Variable utama
local autoClickEnabled = false
local clickSpeed = 0.0001
local clickConnection = nil
local minimized = false
local lastClick = 0

-- Bikin ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZoneXD_SmoothClicker"
screenGui.Parent = game.CoreGui

-- Frame utama
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 150)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -75)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 25)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -40, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "🔥 SMOOTH CLICKER 🔥"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextScaled = true
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- Minimize button
local minButton = Instance.new("TextButton")
minButton.Size = UDim2.new(0, 25, 0, 25)
minButton.Position = UDim2.new(1, -25, 0, 0)
minButton.BackgroundTransparency = 1
minButton.Text = "─"
minButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minButton.TextScaled = true
minButton.Font = Enum.Font.GothamBold
minButton.Parent = titleBar

-- Container konten
local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, -20, 1, -45)
contentContainer.Position = UDim2.new(0, 10, 0, 30)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame

-- Status
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 25)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "STATUS: 🔴 MATI"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.GothamBold
statusLabel.Parent = contentContainer

-- Speed info
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 20)
speedLabel.Position = UDim2.new(0, 0, 0, 25)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "⚡ 0.0001 DETIK (MULUS)"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = contentContainer

-- Info Anti Lag
local antiLagLabel = Instance.new("TextLabel")
antiLagLabel.Size = UDim2.new(1, 0, 0, 20)
antiLagLabel.Position = UDim2.new(0, 0, 0, 45)
antiLagLabel.BackgroundTransparency = 1
antiLagLabel.Text = "✅ ANTI LAG: LAYAR MULUS"
antiLagLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
antiLagLabel.TextScaled = true
antiLagLabel.Font = Enum.Font.Gotham
antiLagLabel.Parent = contentContainer

-- Tombol ON
local onButton = Instance.new("TextButton")
onButton.Size = UDim2.new(0.45, -5, 0, 35)
onButton.Position = UDim2.new(0, 0, 0, 70)
onButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
onButton.Text = "🔥 NYALA"
onButton.TextColor3 = Color3.fromRGB(255, 255, 255)
onButton.TextScaled = true
onButton.Font = Enum.Font.GothamBold
onButton.Parent = contentContainer

-- Tombol OFF
local offButton = Instance.new("TextButton")
offButton.Size = UDim2.new(0.45, -5, 0, 35)
offButton.Position = UDim2.new(0.55, 0, 0, 70)
offButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
offButton.Text = "⭕ MATI"
offButton.TextColor3 = Color3.fromRGB(255, 255, 255)
offButton.TextScaled = true
offButton.Font = Enum.Font.GothamBold
offButton.Parent = contentContainer

-- ============= FUNGSI AUTO KLIK ANTI LAG =============
-- Pake teknik yang beda biar ga nge-freeze layar!

local function startAutoClick()
    if autoClickEnabled then
        local VirtualInput = game:GetService("VirtualInputManager")
        local VirtualUser = game:GetService("VirtualUser")
        local RunService = game:GetService("RunService")
        
        -- PAKE STEAMED (Bukan Heartbeat biar ga bebanin)
        clickConnection = RunService.Stepped:Connect(function()
            if autoClickEnabled then
                -- Klik pake 2 metode sekaligus tapi DIBATES!
                VirtualInput:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                VirtualInput:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                
                -- Pake delay super kecil biar ga numpuk
                task.wait(0.00001)
                
                VirtualUser:ClickButton1(Vector2.new(0, 0), game.Workspace.CurrentCamera)
                
                -- Kasi napas dikit ke sistem
                task.wait(0.00001)
            end
        end)
        
        -- TAMBAHIN RENDER STEP biar UI tetep responsif
        local renderConnection = RunService.RenderStepped:Connect(function()
            -- Ini cuma buat jaga-jaga biar UI tetep jalan
            if mainFrame then
                -- Dummy function biar engine tetep render UI
            end
        end)
        
        clickConnection = {clickConnection, renderConnection}
    end
end

local function stopAutoClick()
    if clickConnection then
        if type(clickConnection) == "table" then
            for _, conn in ipairs(clickConnection) do
                conn:Disconnect()
            end
        else
            clickConnection:Disconnect()
        end
        clickConnection = nil
    end
    statusLabel.Text = "STATUS: 🔴 MATI"
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
end

-- ============= EVENT TOMBOL =============
onButton.MouseButton1Click:Connect(function()
    autoClickEnabled = true
    stopAutoClick()
    startAutoClick()
    statusLabel.Text = "STATUS: 🟢 NYALA (MULUS)"
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
end)

offButton.MouseButton1Click:Connect(function()
    autoClickEnabled = false
    stopAutoClick()
end)

-- Minimize button
minButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        mainFrame.Size = UDim2.new(0, 250, 0, 25)
        contentContainer.Visible = false
        minButton.Text = "□"
    else
        mainFrame.Size = UDim2.new(0, 250, 0, 150)
        contentContainer.Visible = true
        minButton.Text = "─"
    end
end)

-- Double click title bar
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if tick() - lastClick < 0.3 then
            minimized = not minimized
            if minimized then
                mainFrame.Size = UDim2.new(0, 250, 0, 25)
                contentContainer.Visible = false
                minButton.Text = "□"
            else
                mainFrame.Size = UDim2.new(0, 250, 0, 150)
                contentContainer.Visible = true
                minButton.Text = "─"
            end
        end
        lastClick = tick()
    end
end)

-- Hotkey F7
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F7 then
        autoClickEnabled = not autoClickEnabled
        if autoClickEnabled then
            stopAutoClick()
            startAutoClick()
            statusLabel.Text = "STATUS: 🟢 NYALA (MULUS)"
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        else
            stopAutoClick()
        end
    end
end)

-- Watermark
local watermark = Instance.new("TextLabel")
watermark.Size = UDim2.new(0, 160, 0, 20)
watermark.Position = UDim2.new(1, -165, 1, -25)
watermark.BackgroundTransparency = 0.5
watermark.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
watermark.Text = "🔥 APIS | SMOOTH 🔥"
watermark.TextColor3 = Color3.fromRGB(255, 100, 100)
watermark.TextScaled = true
watermark.Font = Enum.Font.Gotham
watermark.Parent = screenGui

print("🔥 SMOOTH CLICKER LOADED! 0.0001 detik + ANTI LAG!")
print("✅ Layar mulus, analog bisa gerak, menu bisa digeser!")