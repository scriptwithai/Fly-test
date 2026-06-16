local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local flying = false
local noclip = false
local speed = 60
local linearVel, alignOri = nil, nil

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 180)
mainFrame.Position = UDim2.new(0.5, -125, 0.25, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
topBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.6, 0, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Fly v2.6"
title.TextColor3 = Color3.fromRGB(0, 210, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = topBar

local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(0, 40, 1, 0)
hideBtn.Position = UDim2.new(1, -85, 0, 0)
hideBtn.BackgroundTransparency = 1
hideBtn.Text = "−"
hideBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
hideBtn.TextSize = 24
hideBtn.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 1, 0)
closeBtn.Position = UDim2.new(1, -40, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(255, 70, 70)
closeBtn.TextSize = 24
closeBtn.Parent = topBar

-- Mini Button
local miniButton = Instance.new("TextButton")
miniButton.Size = UDim2.new(0, 100, 0, 50)
miniButton.Position = UDim2.new(0.5, -50, 0.15, 0)
miniButton.BackgroundColor3 = Color3.fromRGB(0, 110, 230)
miniButton.Text = "SCRIPT"
miniButton.TextColor3 = Color3.fromRGB(255, 255, 255)
miniButton.TextSize = 16
miniButton.Font = Enum.Font.SourceSansBold
miniButton.Visible = false
miniButton.Draggable = true
miniButton.Active = true
miniButton.Parent = screenGui

-- Fly Button
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0.9, 0, 0, 36)
flyButton.Position = UDim2.new(0.05, 0, 0.2, 0)
flyButton.BackgroundColor3 = Color3.fromRGB(0, 140, 0)
flyButton.Text = "FLY: OFF"
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextSize = 17
flyButton.Font = Enum.Font.SourceSansBold
flyButton.Parent = mainFrame

-- Noclip Button
local noclipButton = Instance.new("TextButton")
noclipButton.Size = UDim2.new(0.9, 0, 0, 32)
noclipButton.Position = UDim2.new(0.05, 0, 0.42, 0)
noclipButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
noclipButton.Text = "NOCLIP: OFF"
noclipButton.TextColor3 = Color3.fromRGB(200, 200, 200)
noclipButton.TextSize = 15
noclipButton.Parent = mainFrame

-- Speed Control
local speedFrame = Instance.new("Frame")
speedFrame.Size = UDim2.new(0.9, 0, 0, 40)
speedFrame.Position = UDim2.new(0.05, 0, 0.62, 0)
speedFrame.BackgroundTransparency = 1
speedFrame.Parent = mainFrame

local minusBtn = Instance.new("TextButton")
minusBtn.Size = UDim2.new(0, 40, 1, 0)
minusBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minusBtn.Text = "-"
minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minusBtn.TextSize = 20
minusBtn.Parent = speedFrame

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0.4, 0, 1, 0)
speedBox.Position = UDim2.new(0.2, 0, 0, 0)
speedBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
speedBox.Text = "60"
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.TextSize = 18
speedBox.Font = Enum.Font.SourceSansBold
speedBox.Parent = speedFrame

local plusBtn = Instance.new("TextButton")
plusBtn.Size = UDim2.new(0, 40, 1, 0)
plusBtn.Position = UDim2.new(0.7, 0, 0, 0)
plusBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
plusBtn.Text = "+"
plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
plusBtn.TextSize = 20
plusBtn.Parent = speedFrame

local function updateSpeed(val)
    speed = math.clamp(math.floor(val), 20, 400)
    speedBox.Text = tostring(speed)
end

minusBtn.MouseButton1Click:Connect(function()
    updateSpeed(speed - 1)
end)

plusBtn.MouseButton1Click:Connect(function()
    updateSpeed(speed + 1)
end)

speedBox.FocusLost:Connect(function(enter)
    if enter then
        updateSpeed(tonumber(speedBox.Text) or 60)
    end
end)

local verticalInput = 0

local function startFlying()
    local character = player.Character
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hum = character:FindFirstChild("Humanoid")
    if hum then hum.PlatformStand = true end

    local att = root:FindFirstChild("RootAttachment") or Instance.new("Attachment", root)

    linearVel = Instance.new("LinearVelocity")
    linearVel.Attachment0 = att
    linearVel.MaxForce = 500000
    linearVel.VectorVelocity = Vector3.new(0,0,0)
    linearVel.Parent = root

    alignOri = Instance.new("AlignOrientation")
    alignOri.Attachment0 = att
    alignOri.MaxTorque = 500000
    alignOri.Responsiveness = 300
    alignOri.Parent = root
end

local function stopFlying()
    if linearVel then linearVel:Destroy() linearVel = nil end
    if alignOri then alignOri:Destroy() alignOri = nil end
    local character = player.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.PlatformStand = false
    end
end

local function updateFly()
    local character = player.Character
    if not character or not flying then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    local hum = character:FindFirstChild("Humanoid")
    if not root or not hum then return end

    local moveDir = hum.MoveDirection * speed
    moveDir = moveDir + Vector3.new(0, verticalInput * speed, 0)

    if linearVel then
        linearVel.VectorVelocity = moveDir
        if alignOri then
            alignOri.CFrame = CFrame.lookAt(root.Position, root.Position + camera.CFrame.LookVector)
        end
    end
end

local function toggleNoclip()
    noclip = not noclip
    noclipButton.Text = "NOCLIP: " .. (noclip and "ON" or "OFF")
    noclipButton.BackgroundColor3 = noclip and Color3.fromRGB(0, 160, 0) or Color3.fromRGB(60, 60, 60)
end

flyButton.MouseButton1Click:Connect(function()
    flying = not flying
    flyButton.Text = "FLY: " .. (flying and "ON" or "OFF")
    flyButton.BackgroundColor3 = flying and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(0, 140, 0)
    if flying then startFlying() else stopFlying() end
end)

noclipButton.MouseButton1Click:Connect(toggleNoclip)

UserInputService.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.KeyCode == Enum.KeyCode.Space then
        verticalInput = 1
    elseif inp.KeyCode == Enum.KeyCode.LeftControl then
        verticalInput = -1
    end
end)

UserInputService.InputEnded:Connect(function(inp)
    if inp.KeyCode == Enum.KeyCode.Space or inp.KeyCode == Enum.KeyCode.LeftControl then
        verticalInput = 0
    end
end)

hideBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    miniButton.Visible = true
end)

miniButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    miniButton.Visible = false
end)

closeBtn.MouseButton1Click:Connect(function()
    stopFlying()
    screenGui:Destroy()
end)

RunService.RenderStepped:Connect(function()
    updateFly()

    if noclip and player.Character then
        for _, v in ipairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

player.CharacterAdded:Connect(function()
    task.wait(1)
    if flying then startFlying() end
end)
