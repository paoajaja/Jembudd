--[[
    🔥 ZONE XD - ROBLOX AUTO KLIKER SUPER LENGKAP 🔥
    Created by: APIS (KING OWNER)
    Kecepatan: 0.0001 detik
    Fitur: Menu minimalis + Double Click Title Bar (udah include!)
]]

-- Variable utama
local autoClickEnabled = false
local clickSpeed = 0.0001
local clickConnection = nil
local minimized = false
local lastClick = 0  --> Buat deteksi double click

-- Bikin ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZoneXDAutoClicker"
screenGui.Parent = game.CoreGui

-- Bikin frame utama (PENDEK LEBAR)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 140)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -70)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Shadow
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.6
shadow.Parent = mainFrame

-- Background gradient
local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 20))
})
bgGradient.Parent = mainFrame

-- Border
local border = Instance.new("UIStroke")
border.Thickness = 2
border.Color = Color3.fromRGB(255, 50, 50)
border.Transparency = 0.3
border.Parent = mainFrame

-- Title bar (buat drag & minimize & DOUBLE CLICK!)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 25)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 0, 0))
})
titleGradient.Parent = titleBar

-- Title text
local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -40, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "🔥 ZONE XD CLICKER"
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

-- Status label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: 🔴 MATI"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = contentContainer

-- Speed indicator
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 20)
speedLabel.Position = UDim2.new(0, 0, 0, 25)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "⚡ 0.0001 detik"
speedLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = contentContainer

-- Tombol ON
local onButton = Instance.new("TextButton")
onButton.Size = UDim2.new(0.45, -5, 0, 30)
onButton.Position = UDim2.new(0, 0, 0, 50)
onButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
onButton.Text = "🔥 NYALA"
onButton.TextColor3 = Color3.fromRGB(255, 255, 255)
onButton.TextScaled = true
onButton.Font = Enum.Font.GothamBold
onButton.Parent = contentContainer

-- Tombol OFF
local offButton = Instance.new("TextButton")
offButton.Size = UDim2.new(0.45, -5, 0, 30)
offButton.Position = UDim2.new(0.55, 0, 0, 50)
offButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
offButton.Text = "⭕ MATI"
offButton.TextColor3 = Color3.fromRGB(255, 255, 255)
offButton.TextScaled = true
offButton.Font = Enum.Font.GothamBold
offButton.Parent = contentContainer

-- Hotkey indicator
local hotkeyLabel = Instance.new("TextLabel")
hotkeyLabel.Size = UDim2.new(1, 0, 0, 20)
hotkeyLabel.Position = UDim2.new(0, 0, 0, 85)
hotkeyLabel.BackgroundTransparency = 1
hotkeyLabel.Text = "🔑 F7"
hotkeyLabel.TextColor3 = Color3.fromRGB(150, 150, 255)
hotkeyLabel.TextScaled = true
hotkeyLabel.Font = Enum.Font.Gotham
hotkeyLabel.TextXAlignment = Enum.TextXAlignment.Left
hotkeyLabel.Parent = contentContainer

-- Watermark
local watermark = Instance.new("TextLabel")
watermark.Size = UDim2.new(0, 150, 0, 20)
watermark.Position = UDim2.new(1, -155, 1, -25)
watermark.BackgroundTransparency = 0.5
watermark.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
watermark.Text = "🔥 APIS | ZONE XD"
watermark.TextColor3 = Color3.fromRGB(255, 100, 100)
watermark.TextScaled = true
watermark.Font = Enum.Font.Gotham
watermark.Parent = screenGui

-- ============= FUNGSI AUTO KLIK =============
local function startAutoClick()
    if autoClickEnabled then
        local VirtualInput = game:GetService("VirtualInputManager")
        
        clickConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if autoClickEnabled then
                VirtualInput:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                VirtualInput:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                
                local VirtualUser = game:GetService("VirtualUser")
                VirtualUser:ClickButton1(Vector2.new(0, 0), game.Workspace.CurrentCamera)
            end
        end)
    end
end

local function stopAutoClick()
    if clickConnection then
        clickConnection:Disconnect()
        clickConnection = nil
    end
end

-- ============= EVENT TOMBOL =============
onButton.MouseButton1Click:Connect(function()
    autoClickEnabled = true
    stopAutoClick()
    startAutoClick()
    statusLabel.Text = "Status: 🟢 NYALA"
    onButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    offButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
end)

offButton.MouseButton1Click:Connect(function()
    autoClickEnabled = false
    stopAutoClick()
    statusLabel.Text = "Status: 🔴 MATI"
    onButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    offButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
end)

-- ============= MINIMIZE BUTTON =============
minButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        mainFrame.Size = UDim2.new(0, 250, 0, 25)
        contentContainer.Visible = false
        minButton.Text = "□"
    else
        mainFrame.Size = UDim2.new(0, 250, 0, 140)
        contentContainer.Visible = true
        minButton.Text = "─"
    end
end)

-- ============= FITUR TERSEMBUNYI: DOUBLE CLICK TITLE BAR (SUDAH 1 SCRIPT!) =============
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        -- Deteksi double click (0.3 detik)
        if tick() - lastClick < 0.3 then
            minimized = not minimized
            if minimized then
                mainFrame.Size = UDim2.new(0, 250, 0, 25)
                contentContainer.Visible = false
                minButton.Text = "□"
            else
                mainFrame.Size = UDim2.new(0, 250, 0, 140)
                contentContainer.Visible = true
                minButton.Text = "─"
            end
        end
        lastClick = tick()
    end
end)

-- ============= HOTKEY SYSTEM =============
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F7 then
        autoClickEnabled = not autoClickEnabled
        if autoClickEnabled then
            stopAutoClick()
            startAutoClick()
            statusLabel.Text = "Status: 🟢 NYALA"
            onButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            offButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        else
            stopAutoClick()
            statusLabel.Text = "Status: 🔴 MATI"
            onButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            offButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        end
    end
end)

print("🔥 ZONE XD AUTO CLICKER SUPER LENGKAP LOADED!")
print("✅ Fitur: Minimize button + Double click title bar (rahasia) + Hotkey F7")