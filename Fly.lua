-- MORN :: Roblox Fly Script v1.0
-- LocalScript → StarterPlayer → StarterPlayerScripts

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

local flying = false
local speed = 50  -- базовая скорость
local bv, bg

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MORN_Fly"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 120)
mainFrame.Position = UDim2.new(0.5, -110, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Top Bar
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 25)
topBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(0.7, 0, 1, 0)
title.Position = UDim2.new(0, 8, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Fly"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.Parent = topBar

-- Hide button (полоска)
local hideBtn = Instance.new("TextButton")
hideBtn.Name = "HideBtn"
hideBtn.Size = UDim2.new(0, 30, 0, 25)
hideBtn.Position = UDim2.new(1, -65, 0, 0)
hideBtn.BackgroundTransparency = 1
hideBtn.Text = "−"
hideBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
hideBtn.TextSize = 20
hideBtn.Font = Enum.Font.SourceSans
hideBtn.Parent = topBar

-- Close button (крест)
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 30, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.Parent = topBar

-- Speed Slider
local sliderFrame = Instance.new("Frame")
sliderFrame.Name = "SliderFrame"
sliderFrame.Size = UDim2.new(0.9, 0, 0, 20)
sliderFrame.Position = UDim2.new(0.05, 0, 0.45, 0)
sliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
sliderFrame.BorderSizePixel = 0
sliderFrame.Parent = mainFrame

local sliderBar = Instance.new("Frame")
sliderBar.Name = "SliderBar"
sliderBar.Size = UDim2.new(1, 0, 1, 0)
sliderBar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
sliderBar.BorderSizePixel = 0
sliderBar.Parent = sliderFrame

local sliderKnob = Instance.new("Frame")
sliderKnob.Name = "Knob"
sliderKnob.Size = UDim2.new(0, 12, 0, 24)
sliderKnob.Position = UDim2.new(0.5, -6, 0.5, -12)
sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderKnob.BorderSizePixel = 0
sliderKnob.Parent = sliderFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "SpeedLabel"
speedLabel.Size = UDim2.new(1, 0, 0, 20)
speedLabel.Position = UDim2.new(0, 0, 0.75, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: 50"
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.TextSize = 14
speedLabel.Font = Enum.Font.SourceSans
speedLabel.Parent = mainFrame

-- Fly Toggle Button
local flyButton = Instance.new("TextButton")
flyButton.Name = "FlyButton"
flyButton.Size = UDim2.new(0.9, 0, 0, 30)
flyButton.Position = UDim2.new(0.05, 0, 0.1, 0)
flyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
flyButton.Text = "FLY: OFF"
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextSize = 16
flyButton.Font = Enum.Font.SourceSansBold
flyButton.Parent = mainFrame

-- Логика
local function updateSlider(value)
    speed = math.clamp(value, 0, 100)
    sliderBar.Size = UDim2.new(speed / 100, 0, 1, 0)
    sliderKnob.Position = UDim2.new(speed / 100, -6, 0.5, -12)
    speedLabel.Text = "Speed: " .. math.floor(speed)
end

local function startFlying()
    local character = player.Character
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
    
    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(400000, 400000, 400000)
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.Parent = root
    
    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(400000, 400000, 400000)
    bg.P = 3000
    bg.Parent = root
end

local function stopFlying()
    if bv then bv:Destroy() bv = nil end
    if bg then bg:Destroy() bg = nil end
end

local function updateFly()
    local character = player.Character
    if not character or not flying then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root or not bv then return end
    
    local moveDir = Vector3.new()
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0,1,0) end
    
    if moveDir.Magnitude > 0 then
        moveDir = moveDir.Unit * speed
    end
    bv.Velocity = moveDir
    bg.CFrame = camera.CFrame
end

-- Подключения
flyButton.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        flyButton.Text = "FLY: ON"
        flyButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        startFlying()
    else
        flyButton.Text = "FLY: OFF"
        flyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        stopFlying()
    end
end)

-- Slider drag
local dragging = false
sliderKnob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if dragging then
        local mouseX = mouse.X
        local sliderPos = sliderFrame.AbsolutePosition.X
        local sliderWidth = sliderFrame.AbsoluteSize.X
        local percent = math.clamp((mouseX - sliderPos) / sliderWidth, 0, 1)
        updateSlider(percent * 100)
    end
    updateFly()
end)

hideBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

closeBtn.MouseButton1Click:Connect(function()
    stopFlying()
    screenGui:Destroy()
end)

-- Инициализация
updateSlider(50)

[Morn] :: модуль собран, готов к запуску
