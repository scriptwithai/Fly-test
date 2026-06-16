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
mainFrame.Size = UDim2.new(0, 250, 0, 210)
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
title.Text = "Fly v2.4"
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
flyButton.Position = UDim2.new(0.05, 0, 0.18, 0)
flyButton.BackgroundColor3 = Color3.fromRGB(0, 140, 0)
flyButton.Text = "FLY: OFF"
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextSize = 17
flyButton.Font = Enum.Font.SourceSansBold
flyButton.Parent = mainFrame

-- Noclip Button
local noclipButton = Instance.new("TextButton")
noclipButton.Size = UDim2.new(0.9, 0, 0, 32)
noclipButton.Position = UDim2.new(0.05, 0, 0.38, 0)
noclipButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
noclipButton.Text = "NOCLIP: OFF"
noclipButton.TextColor3 = Color3.fromRGB(200, 200, 200)
noclipButton.TextSize = 15
noclipButton.Parent = mainFrame

-- Vertical control buttons
local upButton = Instance.new("TextButton")
upButton.Size = UDim2.new(0.4, 0, 0, 36)
upButton.Position = UDim2.new(0.05, 0, 0.55, 0)
upButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
upButton.Text = "↑ UP"
upButton.TextColor3 = Color3.fromRGB(0, 255, 100)
upButton.TextSize = 16
upButton.Parent = mainFrame

local downButton = Instance.new("TextButton")
downButton.Size = UDim2.new(0.4, 0, 0, 36)
downButton.Position = UDim2.new(0.55, 0, 0.55, 0)
downButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
downButton.Text = "↓ DOWN"
downButton.TextColor3 = Color3.fromRGB(0, 255, 100)
downButton.TextSize = 16
downButton.Parent = mainFrame

-- Slider
local sliderFrame = Instance.new("Frame")
sliderFrame.Size = UDim2.new(0.9, 0, 0, 28)
sliderFrame.Position = UDim2.new(0.05, 0, 0.78, 0)
sliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
sliderFrame.Parent = mainFrame

local sliderBar = Instance.new("Frame")
sliderBar.Size = UDim2.new(0.5, 0, 1, 0)
sliderBar.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
sliderBar.Parent = sliderFrame

local sliderKnob = Instance.new("Frame")
sliderKnob.Size = UDim2.new(0, 18, 0, 34)
sliderKnob.Position = UDim2.new(0.5, -9, 0.5, -17)
sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderKnob.Parent = sliderFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 20)
speedLabel.Position = UDim2.new(0, 0, 0.9, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: 60"
speedLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
speedLabel.TextSize = 15
speedLabel.Parent = mainFrame

local function updateSlider(val)
    speed = math.clamp(math.floor(val), 20, 300)
    local percent = (speed - 20) / 280
    sliderBar.Size = UDim2.new(percent, 0, 1, 0)
    sliderKnob.Position = UDim2.new(percent, -9, 0.5, -17)
    speedLabel.Text = "Speed: " .. speed
end

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

upButton.MouseButton1Down:Connect(function() verticalInput = 1 end)
upButton.MouseButton1Up:Connect(function() verticalInput = 0 end)
downButton.MouseButton1Down:Connect(function() verticalInput = -1 end)
downButton.MouseButton1Up:Connect(function() verticalInput = 0 end)

UserInputService.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.KeyCode == Enum.KeyCode.Space or inp.KeyCode == Enum.KeyCode.E then
        verticalInput = 1
    elseif inp.KeyCode == Enum.KeyCode.LeftControl or inp.KeyCode == Enum.KeyCode.Q then
        verticalInput = -1
    end
end)

UserInputService.InputEnded:Connect(function(inp)
    if inp.KeyCode == Enum.KeyCode.Space or inp.KeyCode == Enum.KeyCode.E or inp.KeyCode == Enum.KeyCode.LeftControl or inp.KeyCode == Enum.KeyCode.Q then
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

local draggingSlider = false

sliderKnob.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = true
    end
end)

UserInputService.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = false
    end
end)

RunService.RenderStepped:Connect(function()
    if draggingSlider then
        local mousePos = UserInputService:GetMouseLocation()
        local relX = mousePos.X - sliderFrame.AbsolutePosition.X
        local percent = math.clamp(relX / sliderFrame.AbsoluteSize.X, 0, 1)
        updateSlider(20 + percent * 280)
    end

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

updateSlider(60)
