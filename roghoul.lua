-- Load UI Library (Obfuscated Name)
local L0xB = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

-- Services (Obfuscated Names)
local S1x = game:GetService("Players")
local S2x = game:GetService("RunService")
local S3x = game:GetService("UserInputService")
local S4x = game:GetService("Workspace")

-- Local Player
local P1x = S1x.LocalPlayer

-- Settings Table (Obfuscated Names)
local S5x = {
    E1x = true,  -- ESP Enabled
    B1x = true,  -- Box ESP
    N1x = true,  -- Name ESP
    H1x = true,  -- Health Color ESP
    A1x = false, -- AutoFarm Enabled
    T1x = nil    -- Target NPC
}

-- ESP Table
local E2x = {}

-- Function to Create ESP (Obfuscated)
local function F1x(p)
    if p == P1x then return end
    
    local function U1x()
        if not p.Character then return end
        local H1x = p.Character:FindFirstChild("Head")
        if not H1x then return end
        
        local S6x, V1x = S4x.CurrentCamera:WorldToViewportPoint(H1x.Position)
        if V1x and S5x.E1x then
            if S5x.B1x then
                if not E2x[p] then
                    E2x[p] = {
                        B2x = Drawing.new("Square"),
                        N2x = Drawing.new("Text")
                    }
                end
                local B3x = E2x[p].B2x
                local N3x = E2x[p].N2x
                
                B3x.Visible = true
                B3x.Size = Vector2.new(50, 80)
                B3x.Position = Vector2.new(S6x.X - 25, S6x.Y - 40)
                B3x.Color = Color3.new(1, 0, 0)
                B3x.Thickness = 2
                B3x.Filled = false
                
                if S5x.H1x and p.Character:FindFirstChild("Humanoid") then
                    local H2x = p.Character.Humanoid.Health
                    local H3x = p.Character.Humanoid.MaxHealth
                    local R1x = H2x / H3x
                    B3x.Color = Color3.fromRGB(255 * (1 - R1x), 255 * R1x, 0)
                end
                
                if S5x.N1x then
                    N3x.Visible = true
                    N3x.Text = p.Name
                    N3x.Size = 16
                    N3x.Color = Color3.new(1, 1, 1)
                    N3x.Position = Vector2.new(S6x.X, S6x.Y - 50)
                    N3x.Center = true
                end
            end
        else
            if E2x[p] then
                E2x[p].B2x.Visible = false
                E2x[p].N2x.Visible = false
            end
        end
    end
    
    S2x.RenderStepped:Connect(U1x)
end

-- Apply ESP
for _, P2x in pairs(S1x:GetPlayers()) do
    F1x(P2x)
end
S1x.PlayerAdded:Connect(F1x)

-- Detect NPCs
local N4x = {}
for _, N5x in pairs(S4x:GetChildren()) do
    if N5x:IsA("Model") and N5x:FindFirstChild("Humanoid") then
        table.insert(N4x, N5x)
    end
end

-- Teleport Function
local function T2x(N6x)
    if N6x and N6x:FindFirstChild("HumanoidRootPart") then
        P1x.Character.HumanoidRootPart.CFrame = N6x.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
    end
end

-- AutoFarm (Obfuscated Execution)
local function A2x()
    while S5x.A1x and S5x.T1x do
        if S5x.T1x:FindFirstChild("HumanoidRootPart") then
            P1x.Character.HumanoidRootPart.CFrame = S5x.T1x.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        end
        wait(0.1)
        S3x:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
        wait(0.1)
        S3x:SendKeyEvent(true, Enum.KeyCode.X, false, game)
        wait(0.1)
        S3x:SendKeyEvent(true, Enum.KeyCode.C, false, game)
        wait(0.1)
        S3x:SendKeyEvent(true, Enum.KeyCode.ButtonR2, false, game)
    end
end

-- UI Setup
local W1x = L0xB:MakeWindow({Name = "ESP Panel", HidePremium = false, SaveConfig = true, ConfigFolder = "ESPData"})
local T3x = W1x:MakeTab({Name = "ESP", Icon = "rbxassetid://4483345998", PremiumOnly = false})

T3x:AddToggle({Name = "Enable ESP", Default = true, Callback = function(v) S5x.E1x = v end})
T3x:AddToggle({Name = "Box ESP", Default = true, Callback = function(v) S5x.B1x = v end})
T3x:AddToggle({Name = "Name ESP", Default = true, Callback = function(v) S5x.N1x = v end})
T3x:AddToggle({Name = "Health Color", Default = true, Callback = function(v) S5x.H1x = v end})

local T4x = W1x:MakeTab({Name = "NPCs", Icon = "rbxassetid://4483345998", PremiumOnly = false})

for _, N7x in pairs(N4x) do
    T4x:AddButton({Name = "TP to " .. N7x.Name, Callback = function() T2x(N7x) end})
end

T4x:AddDropdown({
    Name = "Select NPC to Farm",
    Options = (function()
        local O1x = {}
        for _, N8x in pairs(N4x) do table.insert(O1x, N8x.Name) end
        return O1x
    end)(),
    Callback = function(S8x)
        for _, N9x in pairs(N4x) do if N9x.Name == S8x then S5x.T1x = N9x break end end
    end
})

T4x:AddToggle({Name = "AutoFarm", Default = false, Callback = function(v) S5x.A1x = v if v then A2x() end end})

L0xB:Init()
