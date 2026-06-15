local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local flying = false
local noclip = false
local speed = 60
local linearVel, alignOri

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 240, 0, 180)
mainFrame.Position = UDim2.new(0.5, -120, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 28)
topBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
topBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.65, 0, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Fly v2.3"
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.SourceSansBold
title.TextSize = 17
title.Parent = topBar

local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(0, 35, 0, 28)
hideBtn.Position = UDim2.new(1, -78, 0, 0)
hideBtn.BackgroundTransparency = 1
hideBtn.Text = "−"
hideBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
hideBtn.TextSize = 22
hideBtn.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 28)
closeBtn.Position = UDim2.new(1, -40, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(255, 60, 60)
closeBtn.TextSize = 22
closeBtn.Parent = topBar

-- Mini Button
local miniButton = Instance.new("TextButton")
miniButton.Size = UDim2.new(0, 90, 0, 45)
miniButton.Position = UDim2.new(0.5, -45, 0.1, 0)
miniButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
miniButton.Text = "SCRIPT"
miniButton.TextColor3 = Color3.fromRGB(255, 255, 255)
miniButton.TextSize = 15
miniButton.Font = Enum.Font.SourceSansBold
miniButton.Visible = false
miniButton.Active = true
miniButton.Draggable = true
miniButton.Parent = screenGui

local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0.9, 0, 0, 34)
flyButton.Position = UDim2.new(0.05, 0, 0.13, 0)
flyButton.BackgroundColor3 = Color3.fromRGB(0, 140, 0)
flyButton.Text = "FLY: OFF"
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextSize = 16
flyButton.Font = Enum.Font.SourceSansBold
flyButton.Parent = mainFrame

local noclipButton = Instance.new("TextButton")
noclipButton.Size = UDim2.new(0.9, 0, 0, 28)
noclipButton.Position = UDim2.new(0.05, 0, 0.38, 0)
noclipButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
noclipButton.Text = "NOCLIP: OFF"
noclipButton.TextColor3 = Color3.fromRGB(200, 200, 200)
noclipButton.TextSize = 14
noclipButton.Parent = mainFrame

local sliderFrame = Instance.new("Frame")
sliderFrame.Size = UDim2.new(0.9, 0, 0, 25)
sliderFrame.Position = UDim2.new(0.05, 0, 0.58, 0)
sliderFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
sliderFrame.Parent = mainFrame

local sliderBar = Instance.new("Frame")
sliderBar.Size = UDim2.new(0.5, 0, 1, 0)
sliderBar.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
sliderBar.Parent = sliderFrame

local sliderKnob = Instance.new("Frame")
sliderKnob.Size = UDim2.new(0, 16, 0, 30)
sliderKnob.Position = UDim2.new(0.5, -8, 0.5, -15)
sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderKnob.Parent = sliderFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 20)
speedLabel.Position = UDim2.new(0, 0, 0.78, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: 60"
speedLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
speedLabel.TextSize = 14
speedLabel.Parent = mainFrame

local function updateSlider(val)
    speed = math.clamp(math.floor(val), 20, 250)
    local percent = (speed - 20) / 230
    sliderBar.Size = UDim2.new(percent, 0, 1, 0)
    sliderKnob.Position = UDim2.new(percent, -8, 0.5, -15)
    speedLabel.Text = "Speed: " .. speed
end

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
    linearVel.MaxForce = 250000
    linearVel.VectorVelocity = Vector3.new(0,0,0)
    linearVel.Parent = root

    alignOri = Instance.new("AlignOrientation")
    alignOri.Attachment0 = att
    alignOri.MaxTorque = 250000
    alignOri.Responsiveness = 250
    alignOri.Parent = root
end

local function stopFlying()
    if linearVel then linearVel:Destroy() linearVel = nil end
    if alignOri then alignOri:Destroy() alignOri = nil end
    local character = player.Character
    if character then
        local hum = character:FindFirstChild("Humanoid")
        if hum then hum.PlatformStand = false end
    end
end

local function updateFly()
    local character = player.Character
    if not character or not flying then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    local hum = character:FindFirstChild("Humanoid")
    if not root or not hum then return end

    local moveDir = hum.MoveDirection * speed

    -- Вертикаль
    local vertical = 0
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) or UserInputService:IsKeyDown(Enum.KeyCode.E) then
        vertical = speed
    elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.Q) then
        vertical = -speed
    end
    moveDir = moveDir + Vector3.new(0, vertical, 0)

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
    noclipButton.BackgroundColor3 = noclip and Color3.fromRGB(0, 140, 0) or Color3.fromRGB(60, 60, 60)
end

flyButton.MouseButton1Click:Connect(function()
    flying = not flying
    flyButton.Text = "FLY: " .. (flying and "ON" or "OFF")
    flyButton.BackgroundColor3 = flying and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(0, 140, 0)
    if flying then startFlying() else stopFlying() end
end)

noclipButton.MouseButton1Click:Connect(toggleNoclip)

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

-- Slider Drag (изолирован)
local dragging = false
sliderKnob.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        dragging = true
    end
end)

UserInputService.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging then
        local mousePos = UserInputService:GetMouseLocation()
        local relX = mousePos.X - sliderFrame.AbsolutePosition.X
        local percent = math.clamp(relX / sliderFrame.AbsoluteSize.X, 0, 1)
        updateSlider(20 + percent * 230)
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
    task.wait(0.8)
    if flying then startFlying() end
end)

updateSlider(60)
