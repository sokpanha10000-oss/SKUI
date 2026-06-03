-- [[ Optimized Roblox Executor GUI Interface ]] --
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- Create ScreenGui (Protected under CoreGui for executors)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomAimbotMenu"
ScreenGui.ResetOnSpawn = false
pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- State Variables
local AimbotSettings = {
    CircleActive = false,
    CircleSize = 100,
    CameraAimActive = false,
    Speed = 16,
    Jump = 50
}

local IsClicking = false

-- FOV Circle Configuration (Locked to Center of Screen)
local FOVCircle = nil
if drawing or Drawing then
    FOVCircle = (drawing or Drawing).new("Circle")
    FOVCircle.Visible = false
    FOVCircle.Color = Color3.fromRGB(255, 0, 0)
    FOVCircle.Thickness = 1
    FOVCircle.NumSides = 64
    FOVCircle.Radius = AimbotSettings.CircleSize
    FOVCircle.Filled = false
end

-- Smart Target Selection (Prioritizes players crossing in front)
local function GetClosestPlayerToCenter()
    local ClosestTarget = nil
    local Closest3DDistance = math.huge
    local ScreenCenter = Camera.ViewportSize / 2

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local Hum = player.Character:FindFirstChildOfClass("Humanoid")
            if Hum and Hum.Health > 0 then
                local ScreenPos, OnScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
                if OnScreen then
                    local FOVDistance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - ScreenCenter).Magnitude
                    
                    -- Verify target is inside the circle frame
                    if FOVDistance < AimbotSettings.CircleSize then
                        -- Check 3D Distance: anyone walking/running in front will be closer to the camera
                        local Target3DDistance = (player.Character.Head.Position - Camera.CFrame.Position).Magnitude
                        if Target3DDistance < Closest3DDistance then
                            Closest3DDistance = Target3DDistance
                            ClosestTarget = player.Character.Head
                        end
                    end
                end
            end
        end
    end
    return ClosestTarget
end

-- Core Loop: Updates Circle Position & Handles Camera Lock Aimbot
RunService.RenderStepped:Connect(function()
    local CenterScreen = Camera.ViewportSize / 2
    
    if FOVCircle then
        FOVCircle.Position = CenterScreen
    end

    if AimbotSettings.CameraAimActive and IsClicking then
        local Target = GetClosestPlayerToCenter()
        if Target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Position)
        end
    end
end)

-- Mouse/Touch Fire Input Handlers
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        IsClicking = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        IsClicking = false
    end
end)

-- Robust Mouse-Based Dragging Functionality Helper
local function MakeDraggable(frame, dragHandle)
    local dragging = false
    local startPos, dragStart
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = Vector2.new(Mouse.X, Mouse.Y)
            startPos = frame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local currMouse = Vector2.new(Mouse.X, Mouse.Y)
            local delta = currMouse - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

----------------------------------------------------------------
-- 1. FLOATING TOGGLE BUTTON
----------------------------------------------------------------
local FloatingButton = Instance.new("TextButton")
FloatingButton.Name = "FloatingToggle"
FloatingButton.Size = UDim2.new(0, 60, 0, 60)
FloatingButton.Position = UDim2.new(0, 20, 0.5, -30)
FloatingButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
FloatingButton.Text = "MENU"
FloatingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingButton.Font = Enum.Font.SourceSansBold
FloatingButton.TextSize = 14
FloatingButton.Parent = ScreenGui

local FloatingCorner = Instance.new("UICorner")
FloatingCorner.CornerRadius = UDim.new(0, 12)
FloatingCorner.Parent = FloatingButton

local FloatingStroke = Instance.new("UIStroke")
FloatingStroke.Color = Color3.fromRGB(0, 170, 255)
FloatingStroke.Thickness = 1.5
FloatingStroke.Parent = FloatingButton

MakeDraggable(FloatingButton, FloatingButton)

----------------------------------------------------------------
-- 2. MAIN GUI WINDOW
----------------------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 330, 0, 420)
MainFrame.Position = UDim2.new(0.5, -165, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -20, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "AIMBOT CONFIG PANEL"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Font = Enum.Font.SourceSansBold
TitleText.TextSize = 16
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

MakeDraggable(MainFrame, TitleBar)

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -55)
ContentFrame.Position = UDim2.new(0, 10, 0, 50)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 12)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = ContentFrame

FloatingButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

----------------------------------------------------------------
-- UI COMPONENTS COMPILER FUNCTIONS
----------------------------------------------------------------

-- Create Toggle Component
local function CreateToggle(name, text, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 45)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 33)
    ToggleFrame.Parent = ContentFrame
    Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 40, 0, 22)
    Button.Position = UDim2.new(1, -52, 0.5, -11)
    Button.BackgroundColor3 = default and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(50, 50, 60)
    Button.Text = ""
    Button.Parent = ToggleFrame
    Instance.new("UICorner", Button).CornerRadius = UDim.new(1, 0)

    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 16, 0, 16)
    Indicator.Position = default and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    Indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Indicator.Parent = Button
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

    local state = default
    Button.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(50, 50, 60)}):Play()
        TweenService:Create(Indicator, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)}):Play()
        callback(state)
    end)
end

-- Create Input Component
local function CreateInput(name, text, placeholder, default, callback)
    local InputFrame = Instance.new("Frame")
    InputFrame.Size = UDim2.new(1, 0, 0, 45)
    InputFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 33)
    InputFrame.Parent = ContentFrame
    Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -100, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = InputFrame

    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(0, 80, 0, 26)
    TextBox.Position = UDim2.new(1, -92, 0.5, -13)
    TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    TextBox.Text = tostring(default)
    TextBox.PlaceholderText = placeholder
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.Font = Enum.Font.SourceSans
    TextBox.TextSize = 14
    TextBox.Parent = InputFrame
    Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 4)

    TextBox.FocusLost:Connect(function()
        callback(TextBox.Text)
    end)
end

-- Create Slider Component (Absolute Mouse Translation Fixed)
local function CreateSlider(name, text, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 60)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 33)
    SliderFrame.Parent = ContentFrame
    Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -80, 0, 25)
    Label.Position = UDim2.new(0, 12, 0, 4)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 60, 0, 25)
    ValueLabel.Position = UDim2.new(1, -72, 0, 4)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
    ValueLabel.Font = Enum.Font.SourceSansBold
    ValueLabel.TextSize = 14
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = SliderFrame

    local SliderTrack = Instance.new("TextButton")
    SliderTrack.Size = UDim2.new(1, -24, 0, 6)
    SliderTrack.Position = UDim2.new(0, 12, 0, 40)
    SliderTrack.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    SliderTrack.Text = ""
    SliderTrack.AutoButtonColor = false
    SliderTrack.Parent = SliderFrame
    Instance.new("UICorner", SliderTrack).CornerRadius = UDim.new(1, 0)

    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    SliderFill.Parent = SliderTrack
    Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)

    local Sliding = false
    
    local function UpdateSlider()
        local relativeX = Mouse.X - SliderTrack.AbsolutePosition.X
        local percentage = math.clamp(relativeX / SliderTrack.AbsoluteSize.X, 0, 1)
        local value = math.round(min + (percentage * (max - min)))
        
        SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        ValueLabel.Text = tostring(value)
        callback(value)
    end

    SliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Sliding = true
            UpdateSlider()
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if Sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider()
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Sliding = false
        end
    end)
end

----------------------------------------------------------------
-- 3. INITIALIZING THE INTERFACE OBJECTS
----------------------------------------------------------------

-- Toggle 1: Show/Hide Center FOV Circle Frame
CreateToggle("Toggle1", "Center FOV Circle Frame", false, function(state)
    AimbotSettings.CircleActive = state
    if FOVCircle then
        FOVCircle.Visible = state
    end
end)

-- Toggle 2: Camera Dynamic Face Player on Fire Click
CreateToggle("Toggle2", "Camera Lock on Fire Click", false, function(state)
    AimbotSettings.CameraAimActive = state
end)

-- Input: Size of circle frame
CreateInput("Input1", "Circle Frame Size:", "Size", 100, function(value)
    local num = tonumber(value)
    if num then
        AimbotSettings.CircleSize = num
        if FOVCircle then
            FOVCircle.Radius = num
        end
    end
end)

-- Slider 1: Speed changer (Max 300, default 16)
CreateSlider("Slider1", "Character Speed Changer", 0, 300, 16, function(value)
    AimbotSettings.Speed = value
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = value
    end
end)

-- Slider 2: Jump changer (Max 350, default 50)
CreateSlider("Slider2", "Character Jump Changer", 0, 350, 50, function(value)
    AimbotSettings.Jump = value
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum.UseJumpPower then
            hum.JumpPower = value
        else
            hum.JumpHeight = value / 7.14
        end
    end
end)

-- Multi-Enforcement Reset Loop
task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum.WalkSpeed ~= AimbotSettings.Speed then
                    hum.WalkSpeed = AimbotSettings.Speed
                end
                if hum.UseJumpPower then
                    if hum.JumpPower ~= AimbotSettings.Jump then hum.JumpPower = AimbotSettings.Jump end
                else
                    local expectedHeight = AimbotSettings.Jump / 7.14
                    if math.abs(hum.JumpHeight - expectedHeight) > 0.1 then hum.JumpHeight = expectedHeight end
                end
            end
        end)
    end
end)
