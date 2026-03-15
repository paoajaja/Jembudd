--[[
    🔥 ZONE XD - TELEPORT MANUAL (TEKAN T) 🔥
    COPYRIGHT: APIS 2026
    FITUR: Tekan T buat teleport ke player terdekat
]]

local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Fungsi cari player terdekat
local function getClosestPlayer()
    local closest = nil
    local shortest = math.huge
    
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
            if dist < shortest then
                shortest = dist
                closest = v
            end
        end
    end
    return closest
end

-- Fungsi teleport
local function teleportToTarget(target)
    if not target or not target.Character then return end
    
    local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    
    -- Teleport di samping target (biar gak nempel)
    player.Character.HumanoidRootPart.CFrame = targetRoot.CFrame * CFrame.new(0, 5, 5)
    
    -- Notifikasi
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ZONE XD",
        Text = "Teleport ke " .. target.Name,
        Duration = 1
    })
end

-- Event pas pencet tombol
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end  -- Gak jalan kalo lagi chat
    
    if input.KeyCode == Enum.KeyCode.T then
        local target = getClosestPlayer()
        if target then
            teleportToTarget(target)
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "ZONE XD",
                Text = "Gak ada player lain!",
                Duration = 1
            })
        end
    end
end)

print("✅ TELEPORT AKTIF! Tekan T buat pindah ke player terdekat")