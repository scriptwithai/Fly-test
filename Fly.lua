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
screenGui.Name = "Sc1zyyFly"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 290, 0, 220)
mainFrame.Position = UDim2.new(0.5, -145, 0.18, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 18)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 2
mainStroke.Color = Color3.fromRGB(0, 180, 255)
mainStroke.Transparency = 0.4
mainStroke.Parent = mainFrame

local mainGradient = Instance.new("UIGradient")
mainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 10))
}
mainGradient.Rotation = 90
mainGradient.Parent = mainFrame

-- Top Bar
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = Color3.fromRGB(5, 5, 7)
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 18)
topCorner.Parent = topBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.65, 0, 1, 0)
title.Position = UDim2.new(0, 20, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Script by Sc1zyy"
title.TextColor3 = Color3.fromRGB(0, 220, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 19
title.Parent = topBar

local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(0, 44, 1, 0)
hideBtn.Position = UDim2.new(1, -88, 0, 0)
hideBtn.BackgroundTransparency = 1
hideBtn.Text = "−"
hideBtn.TextColor3 = Color3.fromRGB(170, 170, 170)
hideBtn.TextSize = 30
hideBtn.Font = Enum.Font.Gotham
hideBtn.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 44, 1, 0)
closeBtn.Position = UDim2.new(1, -42, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(255, 85, 85)
closeBtn.TextSize = 30
closeBtn.Font = Enum.Font.Gotham
closeBtn.Parent = topBar

-- Mini Button
local miniButton = Instance.new("TextButton")
miniButton.Size = UDim2.new(0, 100, 0, 62)
miniButton.Position = UDim2.new(0.5, -50, 0.22, 0)
miniButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
miniButton.Text = "SCRIPT"
miniButton.TextColor3 = Color3.fromRGB(255, 255, 255)
miniButton.TextSize = 16
miniButton.Font = Enum.Font.GothamBold
miniButton.Visible = false
miniButton.Draggable = true
miniButton.Active = true
miniButton.Parent = screenGui

local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(0, 16)
miniCorner.Parent = miniButton

local miniStroke = Instance.new("UIStroke")
miniStroke.Thickness = 2.5
miniStroke.Color = Color3.fromRGB(60, 60, 60)
miniStroke.Parent = miniButton

-- Fly Button
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0.88, 0, 0, 44)
flyButton.Position = UDim2.new(0.06, 0, 0.24, 0)
flyButton.BackgroundColor3 = Color3.fromRGB(0, 145, 0)
flyButton.Text = "FLY: OFF"
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextSize = 17
flyButton.Font = Enum.Font.GothamBold
flyButton.Parent = mainFrame

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 12)
flyCorner.Parent = flyButton

-- Noclip Button
local noclipButton = Instance.new("TextButton")
noclipButton.Size = UDim2.new(0.88, 0, 0, 38)
noclipButton.Position = UDim2.new(0.06, 0, 0.48, 0)
noclipButton.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
noclipButton.Text = "NOCLIP: OFF"
noclipButton.TextColor3 = Color3.fromRGB(210, 210, 210)
noclipButton.TextSize = 15.5
noclipButton.Font = Enum.Font.GothamSemibold
noclipButton.Parent = mainFrame

local noclipCorner = Instance.new("UICorner")
noclipCorner.CornerRadius = UDim.new(0, 12)
noclipCorner.Parent = noclipButton

-- Speed Control
local speedFrame = Instance.new("Frame")
speedFrame.Size = UDim2.new(0.88, 0, 0, 52)
speedFrame.Position = UDim2.new(0.06, 0, 0.69, 0)
speedFrame.BackgroundTransparency = 1
speedFrame.Parent = mainFrame

local minusBtn = Instance.new("TextButton")
minusBtn.Size = UDim2.new(0, 48, 0, 38)
minusBtn.Position = UDim2.new(0, 0, 0.5, -19)
minusBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
minusBtn.Text = "−"
minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minusBtn.TextSize = 26
minusBtn.Font = Enum.Font.GothamBold
minusBtn.Parent = speedFrame

local minusCorner = Instance.new("UICorner")
minusCorner.CornerRadius = UDim.new(0, 10)
minusCorner.Parent = minusBtn

local speedContainer = Instance.new("Frame")
speedContainer.Size = UDim2.new(0.5, 0, 0, 38)
speedContainer.Position = UDim2.new(0.22, 0, 0.5, -19)
speedContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
speedContainer.Parent = speedFrame

local speedContainerCorner = Instance.new("UICorner")
speedContainerCorner.CornerRadius = UDim.new(0, 10)
speedContainerCorner.Parent = speedContainer

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.48, 0, 1, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed"
speedLabel.TextColor3 = Color3.fromRGB(130, 130, 155)
speedLabel.TextSize = 16.5
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextXAlignment = Enum.TextXAlignment.Right
speedLabel.Parent = speedContainer

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0.48, 0, 1, 0)
speedBox.Position = UDim2.new(0.5, 0, 0, 0)
speedBox.BackgroundTransparency = 1
speedBox.Text = "60"
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.TextSize = 21
speedBox.Font = Enum.Font.GothamBold
speedBox.TextXAlignment = Enum.TextXAlignment.Left
speedBox.Parent = speedContainer

local plusBtn = Instance.new("TextButton")
plusBtn.Size = UDim2.new(0, 48, 0, 38)
plusBtn.Position = UDim2.new(0.74, 0, 0.5, -19)
plusBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
plusBtn.Text = "+"
plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
plusBtn.TextSize = 26
plusBtn.Font = Enum.Font.GothamBold
plusBtn.Parent = speedFrame

local plusCorner = Instance.new("UICorner")
plusCorner.CornerRadius = UDim.new(0, 10)
plusCorner.Parent = plusBtn

local function updateSpeed(val)
    speed = math.clamp(math.floor(tonumber(val) or 60), 20, 500)
    speedBox.Text = tostring(speed)
end

minusBtn.MouseButton1Click:Connect(function() updateSpeed(speed - 1) end)
plusBtn.MouseButton1Click:Connect(function() updateSpeed(speed + 1) end)

speedBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        updateSpeed(speedBox.Text)
    end
end)

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
    linearVel.MaxForce = 1200000
    linearVel.VectorVelocity = Vector3.new(0,0,0)
    linearVel.Parent = root

    alignOri = Instance.new("AlignOrientation")
    alignOri.Attachment0 = att
    alignOri.MaxTorque = 1200000
    alignOri.Responsiveness = 250
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

    local camCFrame = camera.CFrame
    local moveDir = hum.MoveDirection

    -- Исправленная логика: W - вперёд, S - назад, D - вправо, A - влево
    local forward = camCFrame.LookVector * -moveDir.Z
    local right = camCFrame.RightVector * moveDir.X
    local velocity = (forward + right) * speed

    if linearVel then
        linearVel.VectorVelocity = velocity
    end
    if alignOri then
        alignOri.CFrame = CFrame.lookAt(root.Position, root.Position + camCFrame.LookVector)
    end
end

local function toggleNoclip()
    noclip = not noclip
    noclipButton.Text = "NOCLIP: " .. (noclip and "ON" or "OFF")
    noclipButton.BackgroundColor3 = noclip and Color3.fromRGB(0, 165, 0) or Color3.fromRGB(48, 48, 48)
end

flyButton.MouseButton1Click:Connect(function()
    flying = not flying
    flyButton.Text = "FLY: " .. (flying and "ON" or "OFF")
    flyButton.BackgroundColor3 = flying and Color3.fromRGB(0, 205, 0) or Color3.fromRGB(0, 145, 0)
    if flying then 
        startFlying() 
    else 
        stopFlying() 
    end
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

RunService.RenderStepped:Connect(function()
    updateFly()

    if noclip and player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

player.CharacterAdded:Connect(function()
    task.wait(0.8)
    if flying then startFlying() end
end)
