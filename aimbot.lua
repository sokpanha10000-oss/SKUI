-- [[ Premium Roblox Executor GUI Master Suite ]] --
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
ScreenGui.Name = "PremiumAimbotSuite"
ScreenGui.ResetOnSpawn = false
pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Comprehensive Feature Configurations
local AimbotSettings = {
    CircleActive = false,
    CircleSize = 100,
    CameraAimActive = false,
    Speed = 16,
    Jump = 50,
    ESPActive = false,
    HitboxActive = false,
    HitboxSize = 10,
    GodModeActive = false,
    PremiumUnlocked = false
}

local IsClicking = false
local SecretKey = "AIMBOTPREMIUM"

-- FOV Circle Drawing Setup
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

----------------------------------------------------------------
-- BACKEND BEHAVIOR MODIFICATION ENGINES
----------------------------------------------------------------

-- Smart Proximity Target Fetcher
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
                    if FOVDistance < AimbotSettings.CircleSize then
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

-- Core Render Loop Handling
RunService.RenderStepped:Connect(function()
    if FOVCircle then
        FOVCircle.Position = Camera.ViewportSize / 2
    end

    if AimbotSettings.CameraAimActive and IsClicking then
        local Target = GetClosestPlayerToCenter()
        if Target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Position)
        end
    end
end)

-- Main Modification Processing Loop (ESP, Hitbox, GodMode Loops combined)
task.spawn(function()
    while task.wait(0.4) do
        pcall(function()
            -- Manage Godmode Hooks
            if AimbotSettings.GodModeActive and LocalPlayer.Character then
                local Hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if Hum then
                    Hum.MaxHealth = math.huge
                    Hum.Health = math.huge
                    Hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                end
            end

            -- Manage Player Attributes (Speed & Jump Loop Safety)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum.WalkSpeed ~= AimbotSettings.Speed then hum.WalkSpeed = AimbotSettings.Speed end
                if hum.UseJumpPower then
                    if hum.JumpPower ~= AimbotSettings.Jump then hum.JumpPower = AimbotSettings.Jump end
                else
                    local targetH = AimbotSettings.Jump / 7.14
                    if math.abs(hum.JumpHeight - targetH) > 0.1 then hum.JumpHeight = targetH end
                end
            end

            -- Process Opponents (ESP & Hitboxes)
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    -- Process ESP Highlights
                    local Highlight = player.Character:FindFirstChild("SuiteHighlight")
                    if AimbotSettings.ESPActive then
                        if not Highlight then
                            Highlight = Instance.new("Highlight")
                            Highlight.Name = "SuiteHighlight"
                            Highlight.Parent = player.Character
                        end
                        Highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        Highlight.FillTransparency = 0.4
                    else
                        if Highlight then Highlight:Destroy() end
                    end

                    -- Process Hitbox Scaling
                    local HRP = player.Character:FindFirstChild("HumanoidRootPart")
                    if HRP then
                        if AimbotSettings.HitboxActive then
                            HRP.Size = Vector3.new(AimbotSettings.HitboxSize, AimbotSettings.HitboxSize, AimbotSettings.HitboxSize)
                            HRP.Transparency = 0.7
                            HRP.CanCollide = false
                        else
                            HRP.Size = Vector3.new(2, 2, 1)
                            HRP.Transparency = 1
                            HRP.CanCollide = true
                        end
                    end
                end
            end
        end)
    end
end)

-- Fire Detection Inputs
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

-- Window Dragging Handler Engine
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
-- INTERFACE FRAME COMPOSITION
----------------------------------------------------------------

-- Floating Trigger Node
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
Instance.new("UICorner", FloatingButton).CornerRadius = UDim.new(0, 12)
local FloatStroke = Instance.new("UIStroke", FloatingButton)
FloatStroke.Color = Color3.fromRGB(0, 170, 255)
FloatStroke.Thickness = 1.5

MakeDraggable(FloatingButton, FloatingButton)

-- Main Content Window Panel
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 340, 0, 430)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -215)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Visible = false
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -20, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "PREMIUM SYSTEM PANEL"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Font = Enum.Font.SourceSansBold
TitleText.TextSize = 15
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

MakeDraggable(MainFrame, TitleBar)

-- Scrolling Container Layer for configuration modular blocks
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(1, -20, 1, -55)
ContentFrame.Position = UDim2.new(0, 10, 0, 50)
ContentFrame.BackgroundTransparency = 1
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentFrame.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
ContentFrame.ScrollBarThickness = 3
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
ContentFrame.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 10)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = ContentFrame

FloatingButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

----------------------------------------------------------------
-- COMPONENT GENERATOR INTERFACE LOGIC
----------------------------------------------------------------

local function CreateToggle(text, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -6, 0, 45)
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
    
    local function updateVisuals(targetState)
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = targetState and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(50, 50, 60)}):Play()
        TweenService:Create(Indicator, TweenInfo.new(0.2), {Position = targetState and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)}):Play()
    end

    Button.MouseButton1Click:Connect(function()
        state = not state
        callback(state, updateVisuals)
    end)
end

local function CreateInput(text, placeholder, default, callback)
    local InputFrame = Instance.new("Frame")
    InputFrame.Size = UDim2.new(1, -6, 0, 45)
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

local function CreateSlider(text, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -6, 0, 60)
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
-- PREMIUM GATE MODAL POPUP DESIGN
----------------------------------------------------------------
local KeyModal = Instance.new("Frame")
KeyModal.Name = "KeyModal"
KeyModal.Size = UDim2.new(1, 0, 1, -40)
KeyModal.Position = UDim2.new(0, 0, 1, 0)
KeyModal.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
KeyModal.BorderSizePixel = 0
KeyModal.ZIndex = 5
KeyModal.Parent = MainFrame

local ModalTitle = Instance.new("TextLabel")
ModalTitle.Size = UDim2.new(1, 0, 0, 40)
ModalTitle.Position = UDim2.new(0, 0, 0, 20)
ModalTitle.BackgroundTransparency = 1
ModalTitle.Text = "ENTER PREMIUM PRODUCT KEY"
ModalTitle.TextColor3 = Color3.fromRGB(255, 0, 80)
ModalTitle.Font = Enum.Font.SourceSansBold
ModalTitle.TextSize = 15
ModalTitle.ZIndex = 5
ModalTitle.Parent = KeyModal

local KeyTextBox = Instance.new("TextBox")
KeyTextBox.Size = UDim2.new(0, 220, 0, 35)
KeyTextBox.Position = UDim2.new(0.5, -110, 0.35, 0)
KeyTextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
KeyTextBox.PlaceholderText = "Input Key Here..."
KeyTextBox.Text = ""
KeyTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTextBox.Font = Enum.Font.SourceSans
KeyTextBox.TextSize = 14
KeyTextBox.ZIndex = 5
KeyTextBox.Parent = KeyModal
Instance.new("UICorner", KeyTextBox).CornerRadius = UDim.new(0, 6)

local KeySubmit = Instance.new("TextButton")
KeySubmit.Size = UDim2.new(0, 120, 0, 32)
KeySubmit.Position = UDim2.new(0.5, -60, 0.55, 0)
KeySubmit.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
KeySubmit.Text = "SUBMIT KEY"
KeySubmit.TextColor3 = Color3.fromRGB(255, 255, 255)
KeySubmit.Font = Enum.Font.SourceSansBold
KeySubmit.TextSize = 14
KeySubmit.ZIndex = 5
KeySubmit.Parent = KeyModal
Instance.new("UICorner", KeySubmit).CornerRadius = UDim.new(0, 6)

local ModalClose = Instance.new("TextButton")
ModalClose.Size = UDim2.new(0, 120, 0, 25)
ModalClose.Position = UDim2.new(0.5, -60, 0.70, 10)
ModalClose.BackgroundTransparency = 1
ModalClose.Text = "Cancel"
ModalClose.TextColor3 = Color3.fromRGB(150, 150, 150)
ModalClose.Font = Enum.Font.SourceSans
ModalClose.TextSize = 13
ModalClose.ZIndex = 5
ModalClose.Parent = KeyModal

local currentToggleFunc = nil

local function PromptKeySystem(onSuccessFunc)
    currentToggleFunc = onSuccessFunc
    KeyTextBox.Text = ""
    KeyModal:TweenPosition(UDim2.new(0, 0, 0, 40), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true)
end

local function CloseKeySystem()
    KeyModal:TweenPosition(UDim2.new(0, 0, 1, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quart, 0.3, true)
end

KeySubmit.MouseButton1Click:Connect(function()
    if KeyTextBox.Text == SecretKey then
        AimbotSettings.PremiumUnlocked = true
        CloseKeySystem()
        if currentToggleFunc then currentToggleFunc() end
    else
        KeyTextBox.Text = ""
        KeyTextBox.PlaceholderText = "INVALID KEY CRITICAL"
        task.wait(1)
        KeyTextBox.PlaceholderText = "Input Key Here..."
    end
end)

ModalClose.MouseButton1Click:Connect(function()
    CloseKeySystem()
end)

----------------------------------------------------------------
-- INTERFACE INITIALIZATION EXECUTION
----------------------------------------------------------------

-- Toggle 1: Center FOV Frame
CreateToggle("Center FOV Circle Frame", false, function(state, updateVisuals)
    AimbotSettings.CircleActive = state
    if FOVCircle then FOVCircle.Visible = state end
    updateVisuals(state)
end)

-- Toggle 2: Camera Proximity Lock on Click
CreateToggle("Camera Lock on Fire Click", false, function(state, updateVisuals)
    AimbotSettings.CameraAimActive = state
    updateVisuals(state)
end)

-- Input 1: Circle Frame Size Config
CreateInput("Circle Frame Size:", "Size", 100, function(value)
    local num = tonumber(value)
    if num then
        AimbotSettings.CircleSize = num
        if FOVCircle then FOVCircle.Radius = num end
    end
end)

-- Slider 1: Speed Config
CreateSlider("Character Speed Changer", 0, 300, 16, function(value)
    AimbotSettings.Speed = value
end)

-- Slider 2: Jump Power Config
CreateSlider("Character Jump Changer", 0, 350, 50, function(value)
    AimbotSettings.Jump = value
end)

-- Toggle 3: Player Silhouette ESP Red
CreateToggle("Player ESP (Red Visuals)", false, function(state, updateVisuals)
    AimbotSettings.ESPActive = state
    updateVisuals(state)
end)

-- Toggle 4: Hitbox Optimization Active
CreateToggle("Expanded Player Hitbox", false, function(state, updateVisuals)
    AimbotSettings.HitboxActive = state
    updateVisuals(state)
end)

-- Input 2: Hitbox Radius Boundary Allocation
CreateInput("Hitbox Frame Size:", "Dimension", 10, function(value)
    local num = tonumber(value)
    if num then AimbotSettings.HitboxSize = num end
end)

-- Toggle 5: Key Gated Premium Local Godmode
CreateToggle("Premium God Mode Engine", false, function(state, updateVisuals)
    if state then
        if AimbotSettings.PremiumUnlocked then
            AimbotSettings.GodModeActive = true
            updateVisuals(true)
        else
            updateVisuals(false)
            PromptKeySystem(function()
                AimbotSettings.GodModeActive = true
                updateVisuals(true)
            end)
        end
    else
        AimbotSettings.GodModeActive = false
        updateVisuals(false)
    end
end)
