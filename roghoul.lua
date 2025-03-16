-- Load Orion UI Library
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- Settings Table
local ESPSettings = {
    Enabled = true,
    BoxESP = true,
    NameESP = true,
    HealthColor = true,
    AutoFarm = false,
    SelectedNPC = nil
}

-- Store ESP Drawings
local ESPObjects = {}

-- Function to Create ESP
local function createESP(player)
    if player == LocalPlayer then return end  -- Don't ESP yourself
    
    local function update()
        if not player.Character then return end
        local head = player.Character:FindFirstChild("Head")
        if not head then return end
        
        local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
        if onScreen and ESPSettings.Enabled then
            -- Create Box ESP
            if ESPSettings.BoxESP then
                if not ESPObjects[player] then
                    ESPObjects[player] = {
                        Box = Drawing.new("Square"),
                        Name = Drawing.new("Text")
                    }
                end
                local box = ESPObjects[player].Box
                local name = ESPObjects[player].Name
                
                box.Visible = true
                box.Size = Vector2.new(50, 80) -- Adjust based on character size
                box.Position = Vector2.new(screenPos.X - 25, screenPos.Y - 40)
                box.Color = Color3.new(1, 0, 0)
                box.Thickness = 2
                box.Filled = false
                
                -- Health-Based Color
                if ESPSettings.HealthColor and player.Character:FindFirstChild("Humanoid") then
                    local health = player.Character.Humanoid.Health
                    local maxHealth = player.Character.Humanoid.MaxHealth
                    local healthRatio = health / maxHealth
                    box.Color = Color3.fromRGB(255 * (1 - healthRatio), 255 * healthRatio, 0)
                end
                
                -- Name ESP
                if ESPSettings.NameESP then
                    name.Visible = true
                    name.Text = player.Name
                    name.Size = 16
                    name.Color = Color3.new(1, 1, 1)
                    name.Position = Vector2.new(screenPos.X, screenPos.Y - 50)
                    name.Center = true
                end
            end
        else
            if ESPObjects[player] then
                ESPObjects[player].Box.Visible = false
                ESPObjects[player].Name.Visible = false
            end
        end
    end
    
    RunService.RenderStepped:Connect(update)
end

-- Apply ESP to all players
for _, player in pairs(Players:GetPlayers()) do
    createESP(player)
end
Players.PlayerAdded:Connect(createESP)

-- NPC Detection
local NPCs = {}
for _, npc in pairs(Workspace:GetChildren()) do
    if npc:IsA("Model") and npc:FindFirstChild("Humanoid") then
        table.insert(NPCs, npc)
    end
end

-- Teleport Function
local function teleportToNPC(npc)
    if npc and npc:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
    end
end

-- AutoFarm Function (ignores walls, instant teleport)
local function autoFarm()
    while ESPSettings.AutoFarm and ESPSettings.SelectedNPC do
        if ESPSettings.SelectedNPC:FindFirstChild("HumanoidRootPart") then
            -- Instantly move to NPC, ignoring obstacles
            LocalPlayer.Character.HumanoidRootPart.CFrame = ESPSettings.SelectedNPC.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        end
        wait(0.1)
        UserInputService:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        wait(0.1)
        UserInputService:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        wait(0.1)
        UserInputService:SendKeyEvent(true, Enum.KeyCode.C, false, game)
        wait(0.1)
        UserInputService:SendKeyEvent(true, Enum.KeyCode.ButtonR2, false, game) -- M1 Attack
    end
end

-- UI Setup
local Window = OrionLib:MakeWindow({Name = "ESP Menu", HidePremium = false, SaveConfig = true, ConfigFolder = "ESPConfig"})
local ESPTab = Window:MakeTab({Name = "ESP", Icon = "rbxassetid://4483345998", PremiumOnly = false})

ESPTab:AddToggle({
    Name = "Enable ESP",
    Default = true,
    Callback = function(value)
        ESPSettings.Enabled = value
    end
})

ESPTab:AddToggle({
    Name = "Box ESP",
    Default = true,
    Callback = function(value)
        ESPSettings.BoxESP = value
    end
})

ESPTab:AddToggle({
    Name = "Name ESP",
    Default = true,
    Callback = function(value)
        ESPSettings.NameESP = value
    end
})

ESPTab:AddToggle({
    Name = "Health-Based Color",
    Default = true,
    Callback = function(value)
        ESPSettings.HealthColor = value
    end
})

-- NPC Features
local NPCTab = Window:MakeTab({Name = "NPCs", Icon = "rbxassetid://4483345998", PremiumOnly = false})

for _, npc in pairs(NPCs) do
    NPCTab:AddButton({
        Name = "Teleport to " .. npc.Name,
        Callback = function()
            teleportToNPC(npc)
        end
    })
end

NPCTab:AddDropdown({
    Name = "Select NPC to Farm",
    Options = (function()
        local options = {}
        for _, npc in pairs(NPCs) do
            table.insert(options, npc.Name)
        end
        return options
    end)(),
    Callback = function(selected)
        for _, npc in pairs(NPCs) do
            if npc.Name == selected then
                ESPSettings.SelectedNPC = npc
                break
            end
        end
    end
})

NPCTab:AddToggle({
    Name = "AutoFarm",
    Default = false,
    Callback = function(value)
        ESPSettings.AutoFarm = value
        if value then
            autoFarm()
        end
    end
})

OrionLib:Init()
