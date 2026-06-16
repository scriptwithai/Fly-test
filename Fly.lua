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
mainFrame.Size = UDim2.new(0, 260, 0, 190)
mainFrame.Position = UDim2.new(0.5, -130, 0.25, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainFrame

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 34)
topBar.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 12)
topCorner.Parent = topBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.6, 0, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Script by Sc1zyy"
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 17
title.Parent = topBar

local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(0, 40, 1, 0)
hideBtn.Position = UDim2.new(1, -80, 0, 0)
hideBtn.BackgroundTransparency = 1
hideBtn.Text = "−"
hideBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
hideBtn.TextSize = 26
hideBtn.Font = Enum.Font.Gotham
hideBtn.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 1, 0)
closeBtn.Position = UDim2.new(1, -38, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.TextSize = 26
closeBtn.Font = Enum.Font.Gotham
closeBtn.Parent = topBar

-- Mini Button
local miniButton = Instance.new("TextButton")
miniButton.Size = UDim2.new(0, 90, 0, 55)
miniButton.Position = UDim2.new(0.5, -45, 0.2, 0)
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
miniCorner.CornerRadius = UDim.new(0, 10)
miniCorner.Parent = miniButton

-- Fly Button
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0.9, 0, 0, 38)
flyButton.Position = UDim2.new(0.05, 0, 0.22, 0)
flyButton.BackgroundColor3 = Color3.fromRGB(0, 130, 0)
flyButton.Text = "FLY: OFF"
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextSize = 16
flyButton.Font = Enum.Font.GothamBold
flyButton.Parent = mainFrame

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 8)
flyCorner.Parent = flyButton

-- Noclip Button
local noclipButton = Instance.new("TextButton")
noclipButton.Size = UDim2.new(0.9, 0, 0, 34)
noclipButton.Position = UDim2.new(0.05, 0, 0.43, 0)
noclipButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
noclipButton.Text = "NOCLIP: OFF"
noclipButton.TextColor3 = Color3.fromRGB(200, 200, 200)
noclipButton.TextSize = 15
noclipButton.Font = Enum.Font.GothamSemibold
noclipButton.Parent = mainFrame

local noclipCorner = Instance.new("UICorner")
noclipCorner.CornerRadius = UDim.new(0, 8)
noclipCorner.Parent = noclipButton

-- Speed Control
local speedFrame = Instance.new("Frame")
speedFrame.Size = UDim2.new(0.9, 0, 0, 42)
speedFrame.Position = UDim2.new(0.05, 0, 0.63, 0)
speedFrame.BackgroundTransparency = 1
speedFrame.Parent = mainFrame

local minusBtn = Instance.new("TextButton")
minusBtn.Size = UDim2.new(0, 42, 1, 0)
minusBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
minusBtn.Text = "-"
minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minusBtn.TextSize = 22
minusBtn.Font = Enum.Font.GothamBold
minusBtn.Parent = speedFrame

local minusCorner = Instance.new("UICorner")
minusCorner.CornerRadius = UDim.new(0, 8)
minusCorner.Parent = minusBtn

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0.42, 0, 1, 0)
speedBox.Position = UDim2.new(0.2, 0, 0, 0)
speedBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
speedBox.Text = "60"
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.TextSize = 18
speedBox.Font = Enum.Font.GothamBold
speedBox.Parent = speedFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 16)
speedLabel.Position = UDim2.new(0, 0, -0.4, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed"
speedLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
speedLabel.TextSize = 14
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = speedFrame

local speedBoxCorner = Instance.new("UICorner")
speedBoxCorner.CornerRadius = UDim.new(0, 8)
speedBoxCorner.Parent = speedBox

local plusBtn = Instance.new("TextButton")
plusBtn.Size = UDim2.new(0, 42, 1, 0)
plusBtn.Position = UDim2.new(0.68, 0, 0, 0)
plusBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
plusBtn.Text = "+"
plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
plusBtn.TextSize = 22
plusBtn.Font = Enum.Font.GothamBold
plusBtn.Parent = speedFrame

local plusCorner = Instance.new("UICorner")
plusCorner.CornerRadius = UDim.new(0, 8)
plusCorner.Parent = plusBtn

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

    local camCFrame = camera.CFrame
    local move = hum.MoveDirection
    local forward = camCFrame.LookVector * move.Z
    local right = camCFrame.RightVector * move.X
    local velocity = (forward + right) * speed

    if linearVel then
        linearVel.VectorVelocity = velocity
        if alignOri then
            alignOri.CFrame = CFrame.lookAt(root.Position, root.Position + camCFrame.LookVector)
        end
    end
end

local function toggleNoclip()
    noclip = not noclip
    noclipButton.Text = "NOCLIP: " .. (noclip and "ON" or "OFF")
    noclipButton.BackgroundColor3 = noclip and Color3.fromRGB(0, 155, 0) or Color3.fromRGB(55, 55, 55)
end

flyButton.MouseButton1Click:Connect(function()
    flying = not flying
    flyButton.Text = "FLY: " .. (flying and "ON" or "OFF")
    flyButton.BackgroundColor3 = flying and Color3.fromRGB(0, 190, 0) or Color3.fromRGB(0, 130, 0)
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
