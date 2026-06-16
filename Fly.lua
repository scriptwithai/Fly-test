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
mainFrame.Size = UDim2.new(0, 280, 0, 210)
mainFrame.Position = UDim2.new(0.5, -140, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 1.5
mainStroke.Color = Color3.fromRGB(0, 170, 255)
mainStroke.Transparency = 0.6
mainStroke.Parent = mainFrame

-- Top Bar
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 38)
topBar.BackgroundColor3 = Color3.fromRGB(6, 6, 8)
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 16)
topCorner.Parent = topBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.65, 0, 1, 0)
title.Position = UDim2.new(0, 18, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Script by Sc1zyy"
title.TextColor3 = Color3.fromRGB(0, 210, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = topBar

local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(0, 42, 1, 0)
hideBtn.Position = UDim2.new(1, -84, 0, 0)
hideBtn.BackgroundTransparency = 1
hideBtn.Text = "−"
hideBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
hideBtn.TextSize = 28
hideBtn.Font = Enum.Font.Gotham
hideBtn.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 42, 1, 0)
closeBtn.Position = UDim2.new(1, -40, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
closeBtn.TextSize = 28
closeBtn.Font = Enum.Font.Gotham
closeBtn.Parent = topBar

-- Mini Button
local miniButton = Instance.new("TextButton")
miniButton.Size = UDim2.new(0, 95, 0, 58)
miniButton.Position = UDim2.new(0.5, -47.5, 0.25, 0)
miniButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
miniButton.Text = "SCRIPT"
miniButton.TextColor3 = Color3.fromRGB(255, 255, 255)
miniButton.TextSize = 15
miniButton.Font = Enum.Font.GothamBold
miniButton.Visible = false
miniButton.Draggable = true
miniButton.Active = true
miniButton.Parent = screenGui

local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(0, 14)
miniCorner.Parent = miniButton

local miniStroke = Instance.new("UIStroke")
miniStroke.Thickness = 2
miniStroke.Color = Color3.fromRGB(80, 80, 80)
miniStroke.Parent = miniButton

-- Fly Button
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0.88, 0, 0, 42)
flyButton.Position = UDim2.new(0.06, 0, 0.23, 0)
flyButton.BackgroundColor3 = Color3.fromRGB(0, 140, 0)
flyButton.Text = "FLY: OFF"
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextSize = 16
flyButton.Font = Enum.Font.GothamBold
flyButton.Parent = mainFrame

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 10)
flyCorner.Parent = flyButton

-- Noclip Button
local noclipButton = Instance.new("TextButton")
noclipButton.Size = UDim2.new(0.88, 0, 0, 36)
noclipButton.Position = UDim2.new(0.06, 0, 0.46, 0)
noclipButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
noclipButton.Text = "NOCLIP: OFF"
noclipButton.TextColor3 = Color3.fromRGB(210, 210, 210)
noclipButton.TextSize = 15
noclipButton.Font = Enum.Font.GothamSemibold
noclipButton.Parent = mainFrame

local noclipCorner = Instance.new("UICorner")
noclipCorner.CornerRadius = UDim.new(0, 10)
noclipCorner.Parent = noclipButton

-- Speed Control
local speedFrame = Instance.new("Frame")
speedFrame.Size = UDim2.new(0.88, 0, 0, 48)
speedFrame.Position = UDim2.new(0.06, 0, 0.68, 0)
speedFrame.BackgroundTransparency = 1
speedFrame.Parent = mainFrame

local minusBtn = Instance.new("TextButton")
minusBtn.Size = UDim2.new(0, 46, 0, 36)
minusBtn.Position = UDim2.new(0, 0, 0.5, -18)
minusBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minusBtn.Text = "−"
minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minusBtn.TextSize = 24
minusBtn.Font = Enum.Font.GothamBold
minusBtn.Parent = speedFrame

local minusCorner = Instance.new("UICorner")
minusCorner.CornerRadius = UDim.new(0, 8)
minusCorner.Parent = minusBtn

local speedContainer = Instance.new("Frame")
speedContainer.Size = UDim2.new(0.48, 0, 0, 36)
speedContainer.Position = UDim2.new(0.22, 0, 0.5, -18)
speedContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
speedContainer.Parent = speedFrame

local speedContainerCorner = Instance.new("UICorner")
speedContainerCorner.CornerRadius = UDim.new(0, 8)
speedContainerCorner.Parent = speedContainer

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.45, 0, 1, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed"
speedLabel.TextColor3 = Color3.fromRGB(140, 140, 160)
speedLabel.TextSize = 16
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextXAlignment = Enum.TextXAlignment.Right
speedLabel.Parent = speedContainer

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0.5, 0, 1, 0)
speedBox.Position = UDim2.new(0.48, 0, 0, 0)
speedBox.BackgroundTransparency = 1
speedBox.Text = "60"
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.TextSize = 20
speedBox.Font = Enum.Font.GothamBold
speedBox.TextXAlignment = Enum.TextXAlignment.Left
speedBox.Parent = speedContainer

local plusBtn = Instance.new("TextButton")
plusBtn.Size = UDim2.new(0, 46, 0, 36)
plusBtn.Position = UDim2.new(0.72, 0, 0.5, -18)
plusBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
plusBtn.Text = "+"
plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
plusBtn.TextSize = 24
plusBtn.Font = Enum.Font.GothamBold
plusBtn.Parent = speedFrame

local plusCorner = Instance.new("UICorner")
plusCorner.CornerRadius = UDim.new(0, 8)
plusCorner.Parent = plusBtn

local function updateSpeed(val)
    speed = math.clamp(math.floor(tonumber(val) or 60), 20, 500)
    speedBox.Text = tostring(speed)
end

minusBtn.MouseButton1Click:Connect(function() updateSpeed(speed - 5) end)
plusBtn.MouseButton1Click:Connect(function() updateSpeed(speed + 5) end)

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
    linearVel.MaxForce = 1000000
    linearVel.VectorVelocity = Vector3.new(0,0,0)
    linearVel.Parent = root

    alignOri = Instance.new("AlignOrientation")
    alignOri.Attachment0 = att
    alignOri.MaxTorque = 1000000
    alignOri.Responsiveness = 200
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

    local forward = camCFrame.LookVector * moveDir.Z
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
    noclipButton.BackgroundColor3 = noclip and Color3.fromRGB(0, 160, 0) or Color3.fromRGB(50, 50, 50)
end

flyButton.MouseButton1Click:Connect(function()
    flying = not flying
    flyButton.Text = "FLY: " .. (flying and "ON" or "OFF")
    flyButton.BackgroundColor3 = flying and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(0, 140, 0)
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
