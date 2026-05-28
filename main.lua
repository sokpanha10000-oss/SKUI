--[=[
    SKBUILDER AI - PREMIUM EXECUTOR UI LIBRARY
    Features:
    - Object-Oriented Luau Architecture
    - Dynamic Neon Theme (Electric Blue & Magenta Gradient)
    - Safe CoreGui / PlayerGui Execution Guard
    - Smooth UI Dragging (With UserInputService)
    - Full Set of Elements: Tabs, Buttons, Toggles, Sliders, Dropdowns, Inputs
    - Auto-Scrolling Canvas Handlers
]=]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Determine safe execution parent
local ParentGui
local success, err = pcall(function()
    ParentGui = game:GetService("CoreGui")
end)
if not success or not ParentGui then
    ParentGui = PlayerGui
end

-- Clear previous instances of our UI
local existing = ParentGui:FindFirstChild("SKBuilderUI_Library")
if existing then existing:Destroy() end

local Library = {
    CurrentTab = nil,
    Tabs = {},
    AccentGradient = {Color3.fromRGB(0, 180, 255), Color3.fromRGB(150, 0, 255)}
}

-- Utility: Smooth Dragging Function
local function makeDraggable(frame, dragHandle)
    local dragging, dragInput, dragStart, startPos

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            local targetPos = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
            TweenService:Create(frame, TweenInfo.new(0.15, Enum.EasingStyle.OutQuad), {Position = targetPos}):Play()
        end
    end)
end

-- Utility: Apply Soft Ripple Visual Effect
local function rippleEffect(button)
    button.ClipsDescendants = true
    button.MouseButton1Down:Connect(function()
        local mousePos = UserInputService:GetMouseLocation()
        local relativePos = mousePos - button.AbsolutePosition - Vector2.new(0, 36) -- Topbar offset correction
        
        local ripple = Instance.new("Frame")
        ripple.Name = "Ripple"
        ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ripple.BackgroundTransparency = 0.8
        ripple.Position = UDim2.new(0, relativePos.X, 0, relativePos.Y)
        ripple.Size = UDim2.new(0, 0, 0, 0)
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = ripple
        ripple.Parent = button
        
        local targetSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 1.5
        TweenService:Create(ripple, TweenInfo.new(0.5, Enum.EasingStyle.OutQuad), {
            Size = UDim2.new(0, targetSize, 0, targetSize),
            BackgroundTransparency = 1
        }):Play()
        Debris:AddItem(ripple, 0.6)
    end)
end

-- Create Window Class
function Library:CreateWindow(titleText, subtitleText)
    local Window = {
        Tabs = {},
        CurrentTab = nil
    }

    -- Root ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SKBuilderUI_Library"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = ParentGui

    -- Main Container Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = UDim2.new(0, 560, 0, 380)
    MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    -- Rounding Corners
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    -- Premium UI Border Stroke
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(35, 35, 45)
    MainStroke.Thickness = 1
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MainStroke.Parent = MainFrame

    -- Drag Header Bar
    local HeaderBar = Instance.new("Frame")
    HeaderBar.Name = "HeaderBar"
    HeaderBar.Size = UDim2.new(1, 0, 0, 45)
    HeaderBar.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    HeaderBar.BorderSizePixel = 0
    HeaderBar.Parent = MainFrame

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 10)
    HeaderCorner.Parent = HeaderBar

    -- Cover rounding corner on bottom of HeaderBar
    local HeaderCover = Instance.new("Frame")
    HeaderCover.Name = "HeaderCover"
    HeaderCover.Position = UDim2.new(0, 0, 1, -5)
    HeaderCover.Size = UDim2.new(1, 0, 0, 5)
    HeaderCover.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    HeaderCover.BorderSizePixel = 0
    HeaderCover.Parent = HeaderBar

    -- Enable Dragging
    makeDraggable(MainFrame, HeaderBar)

    -- Brand/Accent Line under header
    local AccentLine = Instance.new("Frame")
    AccentLine.Name = "AccentLine"
    AccentLine.Position = UDim2.new(0, 0, 1, 0)
    AccentLine.Size = UDim2.new(1, 0, 0, 1)
    AccentLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    AccentLine.BorderSizePixel = 0
    AccentLine.Parent = HeaderBar

    local LineGradient = Instance.new("UIGradient")
    LineGradient.Color = ColorSequence.new(Library.AccentGradient[1], Library.AccentGradient[2])
    LineGradient.Parent = AccentLine

    -- Title Label
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Position = UDim2.new(0, 15, 0.5, -12)
    TitleLabel.Size = UDim2.new(0, 200, 0, 16)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = titleText or "SKBUILDER AI"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = HeaderBar

    -- Subtitle Label
    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Name = "SubtitleLabel"
    SubtitleLabel.Position = UDim2.new(0, 15, 0.5, 4)
    SubtitleLabel.Size = UDim2.new(0, 200, 0, 12)
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Text = subtitleText or "v1.0.0 • Premium Executor Library"
    SubtitleLabel.TextColor3 = Color3.fromRGB(120, 120, 135)
    SubtitleLabel.Font = Enum.Font.GothamSemibold
    SubtitleLabel.TextSize = 9
    SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubtitleLabel.Parent = HeaderBar

    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Position = UDim2.new(1, -35, 0.5, -10)
    CloseBtn.Size = UDim2.new(0, 20, 0, 20)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 160)
    CloseBtn.TextSize = 14
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = HeaderBar

    CloseBtn.MouseEnter:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 80, 80)}):Play()
    end)
    CloseBtn.MouseLeave:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150, 150, 160)}):Play()
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Sidebar (Tabs navigation container)
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Name = "Sidebar"
    Sidebar.Position = UDim2.new(0, 0, 0, 46)
    Sidebar.Size = UDim2.new(0, 140, 1, -46)
    Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 0
    Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    Sidebar.Parent = MainFrame

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Padding = UDim.new(0, 5)
    SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Parent = Sidebar

    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.PaddingTop = UDim.new(0, 12)
    SidebarPadding.Parent = Sidebar

    -- Container Frame (where tab screens live)
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Position = UDim2.new(0, 140, 0, 46)
    ContentContainer.Size = UDim2.new(1, -140, 1, -46)
    ContentContainer.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Parent = MainFrame

    -- Inner boundary border stroke for Sidebar division
    local SidebarDiv = Instance.new("Frame")
    SidebarDiv.Name = "SidebarDiv"
    SidebarDiv.Position = UDim2.new(0, 140, 0, 46)
    SidebarDiv.Size = UDim2.new(0, 1, 1, -46)
    SidebarDiv.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    SidebarDiv.BorderSizePixel = 0
    SidebarDiv.Parent = MainFrame

    -- Window Methods
    function Window:CreateTab(tabName)
        local Tab = {
            Active = false,
            Instances = {}
        }

        -- Scrollable Canvas Page
        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Name = tabName .. "_Page"
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.BorderSizePixel = 0
        TabPage.ScrollBarThickness = 3
        TabPage.ScrollBarImageColor3 = Color3.fromRGB(50, 50, 60)
        TabPage.Visible = false
        TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabPage.Parent = ContentContainer

        local TabPadding = Instance.new("UIPadding")
        TabPadding.PaddingTop = UDim.new(0, 12)
        TabPadding.PaddingBottom = UDim.new(0, 12)
        TabPadding.PaddingLeft = UDim.new(0, 12)
        TabPadding.PaddingRight = UDim.new(0, 12)
        TabPadding.Parent = TabPage

        local TabListLayout = Instance.new("UIListLayout")
        TabListLayout.Padding = UDim.new(0, 8)
        TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabListLayout.Parent = TabPage

        -- Dynamic canvas sizing
        TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 25)
        end)

        -- Tab Navigation Button in Sidebar
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = tabName .. "_Btn"
        TabBtn.Size = UDim2.new(0, 120, 0, 32)
        TabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
        TabBtn.Text = ""
        TabBtn.AutoButtonColor = false
        TabBtn.Parent = Sidebar

        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, 6)
        TabBtnCorner.Parent = TabBtn

        local TabBtnStroke = Instance.new("UIStroke")
        TabBtnStroke.Color = Color3.fromRGB(28, 28, 36)
        TabBtnStroke.Thickness = 1
        TabBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        TabBtnStroke.Parent = TabBtn

        local TabBtnLabel = Instance.new("TextLabel")
        TabBtnLabel.Name = "Label"
        TabBtnLabel.Position = UDim2.new(0, 10, 0, 0)
        TabBtnLabel.Size = UDim2.new(1, -20, 1, 0)
        TabBtnLabel.BackgroundTransparency = 1
        TabBtnLabel.Text = tabName
        TabBtnLabel.TextColor3 = Color3.fromRGB(140, 140, 155)
        TabBtnLabel.Font = Enum.Font.GothamSemibold
        TabBtnLabel.TextSize = 11
        TabBtnLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabBtnLabel.Parent = TabBtn

        -- Highlight Pill Indicator
        local TabPill = Instance.new("Frame")
        TabPill.Name = "Pill"
        TabPill.Position = UDim2.new(0, 3, 0.5, -8)
        TabPill.Size = UDim2.new(0, 3, 0, 16)
        TabPill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabPill.BackgroundTransparency = 1
        TabPill.Parent = TabBtn

        local PillCorner = Instance.new("UICorner")
        PillCorner.CornerRadius = UDim.new(1, 0)
        PillCorner.Parent = TabPill

        local PillGradient = Instance.new("UIGradient")
        PillGradient.Color = ColorSequence.new(Library.AccentGradient[1], Library.AccentGradient[2])
        PillGradient.Parent = TabPill

        -- Activation Functionality
        local function activate()
            if Window.CurrentTab then
                Window.CurrentTab.TabPage.Visible = false
                TweenService:Create(Window.CurrentTab.TabBtnLabel, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(140, 140, 155)}):Play()
                TweenService:Create(Window.CurrentTab.TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 20, 26)}):Play()
                TweenService:Create(Window.CurrentTab.TabBtnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(28, 28, 36)}):Play()
                TweenService:Create(Window.CurrentTab.TabPill, TweenInfo.new(0.2), {BackgroundTransparency = 1, Size = UDim2.new(0, 3, 0, 0)}):Play()
            end
            
            TabPage.Visible = true
            Window.CurrentTab = Tab
            TweenService:Create(TabBtnLabel, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 35)}):Play()
            TweenService:Create(TabBtnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(45, 45, 55)}):Play()
            TweenService:Create(TabPill, TweenInfo.new(0.2), {BackgroundTransparency = 0, Size = UDim2.new(0, 3, 0, 16)}):Play()
        end

        TabBtn.MouseButton1Click:Connect(activate)
        
        -- Store pointers internally
        Tab.TabPage = TabPage
        Tab.TabBtn = TabBtn
        Tab.TabBtnLabel = TabBtnLabel
        Tab.TabBtnStroke = TabBtnStroke
        Tab.TabPill = TabPill

        if not Window.CurrentTab then
            activate()
        end

        -- =========================================
        -- [ELEMENT CREATORS]
        -- =========================================

        -- 1. BUTTON
        function Tab:CreateButton(text, callback)
            local callback = callback or function() end
            
            local BtnFrame = Instance.new("TextButton")
            BtnFrame.Name = text .. "_Button"
            BtnFrame.Size = UDim2.new(1, 0, 0, 34)
            BtnFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
            BtnFrame.AutoButtonColor = false
            BtnFrame.Text = ""
            BtnFrame.Parent = TabPage

            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 6)
            BtnCorner.Parent = BtnFrame

            local BtnStroke = Instance.new("UIStroke")
            BtnStroke.Color = Color3.fromRGB(35, 35, 45)
            BtnStroke.Thickness = 1
            BtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            BtnStroke.Parent = BtnFrame

            local BtnLabel = Instance.new("TextLabel")
            BtnLabel.Size = UDim2.new(1, 0, 1, 0)
            BtnLabel.BackgroundTransparency = 1
            BtnLabel.Text = text
            BtnLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
            BtnLabel.Font = Enum.Font.GothamSemibold
            BtnLabel.TextSize = 11
            BtnLabel.Parent = BtnFrame

            -- Custom Interaction Visuals
            rippleEffect(BtnFrame)

            BtnFrame.MouseEnter:Connect(function()
                TweenService:Create(BtnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 35)}):Play()
                TweenService:Create(BtnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(50, 50, 65)}):Play()
            end)

            BtnFrame.MouseLeave:Connect(function()
                TweenService:Create(BtnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 20, 26)}):Play()
                TweenService:Create(BtnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(35, 35, 45)}):Play()
            end)

            BtnFrame.MouseButton1Down:Connect(function()
                TweenService:Create(BtnFrame, TweenInfo.new(0.1), {Size = UDim2.new(0.98, 0, 0, 32)}):Play()
                task.spawn(callback)
            end)

            BtnFrame.MouseButton1Up:Connect(function()
                TweenService:Create(BtnFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 34)}):Play()
            end)

            return BtnFrame
        end

        -- 2. TOGGLE
        function Tab:CreateToggle(text, defaultState, callback)
            local toggled = defaultState or false
            local callback = callback or function() end

            local TglFrame = Instance.new("TextButton")
            TglFrame.Name = text .. "_Toggle"
            TglFrame.Size = UDim2.new(1, 0, 0, 36)
            TglFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
            TglFrame.AutoButtonColor = false
            TglFrame.Text = ""
            TglFrame.Parent = TabPage

            local TglCorner = Instance.new("UICorner")
            TglCorner.CornerRadius = UDim.new(0, 6)
            TglCorner.Parent = TglFrame

            local TglStroke = Instance.new("UIStroke")
            TglStroke.Color = Color3.fromRGB(35, 35, 45)
            TglStroke.Thickness = 1
            TglStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            TglStroke.Parent = TglFrame

            local TglLabel = Instance.new("TextLabel")
            TglLabel.Position = UDim2.new(0, 12, 0, 0)
            TglLabel.Size = UDim2.new(1, -60, 1, 0)
            TglLabel.BackgroundTransparency = 1
            TglLabel.Text = text
            TglLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
            TglLabel.Font = Enum.Font.GothamSemibold
            TglLabel.TextSize = 11
            TglLabel.TextXAlignment = Enum.TextXAlignment.Left
            TglLabel.Parent = TglFrame

            -- Toggle Slide Housing
            local Switch = Instance.new("Frame")
            Switch.Name = "Switch"
            Switch.Position = UDim2.new(1, -44, 0.5, -9)
            Switch.Size = UDim2.new(0, 32, 0, 18)
            Switch.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            Switch.Parent = TglFrame

            local SwitchCorner = Instance.new("UICorner")
            SwitchCorner.CornerRadius = UDim.new(1, 0)
            SwitchCorner.Parent = Switch

            local SwitchStroke = Instance.new("UIStroke")
            SwitchStroke.Color = Color3.fromRGB(50, 50, 65)
            SwitchStroke.Thickness = 1
            SwitchStroke.Parent = Switch

            -- Knob
            local Knob = Instance.new("Frame")
            Knob.Name = "Knob"
            Knob.Position = UDim2.new(0, 2, 0.5, -7)
            Knob.Size = UDim2.new(0, 14, 0, 14)
            Knob.BackgroundColor3 = Color3.fromRGB(150, 150, 160)
            Knob.Parent = Switch

            local KnobCorner = Instance.new("UICorner")
            KnobCorner.CornerRadius = UDim.new(1, 0)
            KnobCorner.Parent = Knob

            -- State Handler Animation
            local function updateState(animate)
                local targetPos = toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                local targetColor = toggled and Library.AccentGradient[1] or Color3.fromRGB(30, 30, 40)
                local targetKnobColor = toggled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 160)
                local targetStroke = toggled and Library.AccentGradient[2] or Color3.fromRGB(50, 50, 65)

                if animate then
                    TweenService:Create(Knob, TweenInfo.new(0.2, Enum.EasingStyle.OutQuad), {Position = targetPos, BackgroundColor3 = targetKnobColor}):Play()
                    TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
                    TweenService:Create(SwitchStroke, TweenInfo.new(0.2), {Color = targetStroke}):Play()
                else
                    Knob.Position = targetPos
                    Knob.BackgroundColor3 = targetKnobColor
                    Switch.BackgroundColor3 = targetColor
                    SwitchStroke.Color = targetStroke
                end
            end

            updateState(false)

            TglFrame.MouseButton1Click:Connect(function()
                toggled = not toggled
                updateState(true)
                task.spawn(callback, toggled)
            end)

            TglFrame.MouseEnter:Connect(function()
                TweenService:Create(TglStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(50, 50, 65)}):Play()
            end)
            TglFrame.MouseLeave:Connect(function()
                TweenService:Create(TglStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(35, 35, 45)}):Play()
            end)

            return TglFrame
        end

        -- 3. SLIDER
        function Tab:CreateSlider(text, min, max, default, callback)
            local callback = callback or function() end
            local dragging = false

            local SldFrame = Instance.new("Frame")
            SldFrame.Name = text .. "_Slider"
            SldFrame.Size = UDim2.new(1, 0, 0, 45)
            SldFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
            SldFrame.Parent = TabPage

            local SldCorner = Instance.new("UICorner")
            SldCorner.CornerRadius = UDim.new(0, 6)
            SldCorner.Parent = SldFrame

            local SldStroke = Instance.new("UIStroke")
            SldStroke.Color = Color3.fromRGB(35, 35, 45)
            SldStroke.Thickness = 1
            SldStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            SldStroke.Parent = SldFrame

            local SldLabel = Instance.new("TextLabel")
            SldLabel.Position = UDim2.new(0, 12, 0, 6)
            SldLabel.Size = UDim2.new(1, -80, 0, 14)
            SldLabel.BackgroundTransparency = 1
            SldLabel.Text = text
            SldLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
            SldLabel.Font = Enum.Font.GothamSemibold
            SldLabel.TextSize = 11
            SldLabel.TextXAlignment = Enum.TextXAlignment.Left
            SldLabel.Parent = SldFrame

            -- Numeric Readout Display
            local ValLabel = Instance.new("TextLabel")
            ValLabel.Position = UDim2.new(1, -72, 0, 6)
            ValLabel.Size = UDim2.new(0, 60, 0, 14)
            ValLabel.BackgroundTransparency = 1
            ValLabel.Text = tostring(default or min)
            ValLabel.TextColor3 = Color3.fromRGB(160, 160, 175)
            ValLabel.Font = Enum.Font.Code
            ValLabel.TextSize = 11
            ValLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValLabel.Parent = SldFrame

            -- Background Track Bar
            local Track = Instance.new("TextButton")
            Track.Name = "Track"
            Track.Position = UDim2.new(0, 12, 0, 26)
            Track.Size = UDim2.new(1, -24, 0, 6)
            Track.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            Track.Text = ""
            Track.AutoButtonColor = false
            Track.Parent = SldFrame

            local TrackCorner = Instance.new("UICorner")
            TrackCorner.CornerRadius = UDim.new(1, 0)
            TrackCorner.Parent = Track

            -- Active Filled Gauge
            local Fill = Instance.new("Frame")
            Fill.Name = "Fill"
            Fill.Size = UDim2.new(0, 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Fill.BorderSizePixel = 0
            Fill.Parent = Track

            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = Fill

            local FillGradient = Instance.new("UIGradient")
            FillGradient.Color = ColorSequence.new(Library.AccentGradient[1], Library.AccentGradient[2])
            FillGradient.Parent = Fill

            -- Precision Value Update Mechanics
            local function updateValue(input)
                local totalWidth = Track.AbsoluteSize.X
                local percent = math.clamp((input.Position.X - Track.AbsolutePosition.X) / totalWidth, 0, 1)
                local exactVal = min + (max - min) * percent
                local displayVal = math.round(exactVal)

                TweenService:Create(Fill, TweenInfo.new(0.08, Enum.EasingStyle.OutQuad), {Size = UDim2.new(percent, 0, 1, 0)}):Play()
                ValLabel.Text = tostring(displayVal)
                task.spawn(callback, displayVal)
            end

            -- Snap to initial default
            local startPercent = math.clamp((default - min) / (max - min), 0, 1)
            Fill.Size = UDim2.new(startPercent, 0, 1, 0)

            -- Listeners
            Track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    updateValue(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateValue(input)
                end
            end)

            SldFrame.MouseEnter:Connect(function()
                TweenService:Create(SldStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(50, 50, 65)}):Play()
            end)
            SldFrame.MouseLeave:Connect(function()
                TweenService:Create(SldStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(35, 35, 45)}):Play()
            end)

            return SldFrame
        end

        -- 4. INPUT (TEXTBOX)
        function Tab:CreateInput(text, placeholder, callback)
            local callback = callback or function() end

            local InpFrame = Instance.new("Frame")
            InpFrame.Name = text .. "_Input"
            InpFrame.Size = UDim2.new(1, 0, 0, 36)
            InpFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
            InpFrame.Parent = TabPage

            local InpCorner = Instance.new("UICorner")
            InpCorner.CornerRadius = UDim.new(0, 6)
            InpCorner.Parent = InpFrame

            local InpStroke = Instance.new("UIStroke")
            InpStroke.Color = Color3.fromRGB(35, 35, 45)
            InpStroke.Thickness = 1
            InpStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            InpStroke.Parent = InpFrame

            local InpLabel = Instance.new("TextLabel")
            InpLabel.Position = UDim2.new(0, 12, 0, 0)
            InpLabel.Size = UDim2.new(0.5, -20, 1, 0)
            InpLabel.BackgroundTransparency = 1
            InpLabel.Text = text
            InpLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
            InpLabel.Font = Enum.Font.GothamSemibold
            InpLabel.TextSize = 11
            InpLabel.TextXAlignment = Enum.TextXAlignment.Left
            InpLabel.Parent = InpFrame

            -- TextBox element
            local TextBox = Instance.new("TextBox")
            TextBox.Position = UDim2.new(0.5, 0, 0.5, -10)
            TextBox.Size = UDim2.new(0.5, -12, 0, 20)
            TextBox.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
            TextBox.Text = ""
            TextBox.PlaceholderText = placeholder or "Type here..."
            TextBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 115)
            TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextBox.Font = Enum.Font.Gotham
            TextBox.TextSize = 10
            TextBox.ClearTextOnFocus = false
            TextBox.ClipsDescendants = true
            TextBox.Parent = InpFrame

            local BoxCorner = Instance.new("UICorner")
            BoxCorner.CornerRadius = UDim.new(0, 4)
            BoxCorner.Parent = TextBox

            local BoxStroke = Instance.new("UIStroke")
            BoxStroke.Color = Color3.fromRGB(40, 40, 50)
            BoxStroke.Thickness = 1
            BoxStroke.Parent = TextBox

            -- Focus Highlight Actions
            TextBox.Focused:Connect(function()
                TweenService:Create(BoxStroke, TweenInfo.new(0.2), {Color = Library.AccentGradient[1]}):Play()
                TweenService:Create(InpStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(50, 50, 65)}):Play()
            end)

            TextBox.FocusLost:Connect(function(enterPressed)
                TweenService:Create(BoxStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(40, 40, 50)}):Play()
                TweenService:Create(InpStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(35, 35, 45)}):Play()
                task.spawn(callback, TextBox.Text)
            end)

            InpFrame.MouseEnter:Connect(function()
                TweenService:Create(InpStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(50, 50, 65)}):Play()
            end)
            InpFrame.MouseLeave:Connect(function()
                if not TextBox:IsFocused() then
                    TweenService:Create(InpStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(35, 35, 45)}):Play()
                end
            end)

            return InpFrame
        end

        -- 5. DROPDOWN
        function Tab:CreateDropdown(text, listOptions, defaultOption, callback)
            local callback = callback or function() end
            local expanded = false
            local selected = defaultOption or "None"

            local DrpFrame = Instance.new("TextButton")
            DrpFrame.Name = text .. "_Dropdown"
            DrpFrame.Size = UDim2.new(1, 0, 0, 36)
            DrpFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
            DrpFrame.AutoButtonColor = false
            DrpFrame.Text = ""
            DrpFrame.ClipsDescendants = true
            DrpFrame.Parent = TabPage

            local DrpCorner = Instance.new("UICorner")
            DrpCorner.CornerRadius = UDim.new(0, 6)
            DrpCorner.Parent = DrpFrame

            local DrpStroke = Instance.new("UIStroke")
            DrpStroke.Color = Color3.fromRGB(35, 35, 45)
            DrpStroke.Thickness = 1
            DrpStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            DrpStroke.Parent = DrpFrame

            local DrpLabel = Instance.new("TextLabel")
            DrpLabel.Position = UDim2.new(0, 12, 0, 0)
            DrpLabel.Size = UDim2.new(0.5, 0, 0, 36)
            DrpLabel.BackgroundTransparency = 1
            DrpLabel.Text = text
            DrpLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
            DrpLabel.Font = Enum.Font.GothamSemibold
            DrpLabel.TextSize = 11
            DrpLabel.TextXAlignment = Enum.TextXAlignment.Left
            DrpLabel.Parent = DrpFrame

            -- Current Selected Option readout
            local SelectedLabel = Instance.new("TextLabel")
            SelectedLabel.Position = UDim2.new(1, -55, 0, 0)
            SelectedLabel.Size = UDim2.new(0, 30, 0, 36)
            SelectedLabel.BackgroundTransparency = 1
            SelectedLabel.Text = selected
            SelectedLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
            SelectedLabel.Font = Enum.Font.Gotham
            SelectedLabel.TextSize = 10
            SelectedLabel.TextXAlignment = Enum.TextXAlignment.Right
            SelectedLabel.Parent = DrpFrame

            -- Indicator Icon
            local ArrowIcon = Instance.new("TextLabel")
            ArrowIcon.Name = "Arrow"
            ArrowIcon.Position = UDim2.new(1, -22, 0, 0)
            ArrowIcon.Size = UDim2.new(0, 12, 0, 36)
            ArrowIcon.BackgroundTransparency = 1
            ArrowIcon.Text = "▼"
            ArrowIcon.TextColor3 = Color3.fromRGB(120, 120, 130)
            ArrowIcon.Font = Enum.Font.Gotham
            ArrowIcon.TextSize = 10
            ArrowIcon.Parent = DrpFrame

            -- Dropdown Options list holder frame
            local OptionsHolder = Instance.new("Frame")
            OptionsHolder.Name = "Options"
            OptionsHolder.Position = UDim2.new(0, 0, 0, 36)
            OptionsHolder.Size = UDim2.new(1, 0, 1, -36)
            OptionsHolder.BackgroundTransparency = 1
            OptionsHolder.Parent = DrpFrame

            local OptionLayout = Instance.new("UIListLayout")
            OptionLayout.Padding = UDim.new(0, 4)
            OptionLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            OptionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            OptionLayout.Parent = OptionsHolder

            local OptionPadding = Instance.new("UIPadding")
            OptionPadding.PaddingTop = UDim.new(0, 4)
            OptionPadding.PaddingBottom = UDim.new(0, 4)
            OptionPadding.PaddingLeft = UDim.new(0, 10)
            OptionPadding.PaddingRight = UDim.new(0, 10)
            OptionPadding.Parent = OptionsHolder

            -- Dynamic Dropdown expansion calculation
            local calculatedHeight = 36
            local function rebuildOptions()
                -- Clean active ones
                for _, child in ipairs(OptionsHolder:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end

                for idx, option in ipairs(listOptions) do
                    local OptBtn = Instance.new("TextButton")
                    OptBtn.Name = option .. "_Opt"
                    OptBtn.Size = UDim2.new(1, 0, 0, 26)
                    OptBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
                    OptBtn.AutoButtonColor = false
                    OptBtn.Text = ""
                    OptBtn.Parent = OptionsHolder

                    local OptCorner = Instance.new("UICorner")
                    OptCorner.CornerRadius = UDim.new(0, 4)
                    OptCorner.Parent = OptBtn

                    local OptStroke = Instance.new("UIStroke")
                    OptStroke.Color = Color3.fromRGB(40, 40, 50)
                    OptStroke.Thickness = 1
                    OptStroke.Parent = OptBtn

                    local OptLabel = Instance.new("TextLabel")
                    OptLabel.Size = UDim2.new(1, 0, 1, 0)
                    OptLabel.BackgroundTransparency = 1
                    OptLabel.Text = option
                    OptLabel.TextColor3 = (option == selected) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 160)
                    OptLabel.Font = Enum.Font.Gotham
                    OptLabel.TextSize = 10
                    OptLabel.Parent = OptBtn

                    -- Hover / Click behavior
                    OptBtn.MouseEnter:Connect(function()
                        TweenService:Create(OptBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(32, 32, 42)}):Play()
                        TweenService:Create(OptStroke, TweenInfo.new(0.15), {Color = Library.AccentGradient[1]}):Play()
                    end)
                    OptBtn.MouseLeave:Connect(function()
                        TweenService:Create(OptBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(26, 26, 34)}):Play()
                        TweenService:Create(OptStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(40, 40, 50)}):Play()
                    end)

                    OptBtn.MouseButton1Click:Connect(function()
                        selected = option
                        SelectedLabel.Text = selected
                        
                        -- Collapse dropdown
                        expanded = false
                        TweenService:Create(DrpFrame, TweenInfo.new(0.25, Enum.EasingStyle.QuartOut), {Size = UDim2.new(1, 0, 0, 36)}):Play()
                        TweenService:Create(ArrowIcon, TweenInfo.new(0.25), {Rotation = 0}):Play()
                        
                        rebuildOptions() -- Refresh selected text highlight
                        task.spawn(callback, selected)
                    end)
                end
                
                calculatedHeight = 36 + OptionLayout.AbsoluteContentSize.Y + 8
            end

            rebuildOptions()

            -- Toggle expand collapse
            DrpFrame.MouseButton1Click:Connect(function()
                expanded = not expanded
                local targetHeight = expanded and calculatedHeight or 36
                local targetRotation = expanded and 180 or 0
                
                TweenService:Create(DrpFrame, TweenInfo.new(0.25, Enum.EasingStyle.QuartOut), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
                TweenService:Create(ArrowIcon, TweenInfo.new(0.25), {Rotation = targetRotation}):Play()
            end)

            DrpFrame.MouseEnter:Connect(function()
                TweenService:Create(DrpStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(50, 50, 65)}):Play()
            end)
            DrpFrame.MouseLeave:Connect(function()
                TweenService:Create(DrpStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(35, 35, 45)}):Play()
            end)

            return DrpFrame
        end

        return Tab
    end

    return Window
end

[[-- ============================================================================
-- [SHOWCASE DEMONSTRATION & RUNNABLE TEST CASE]
-- ============================================================================

-- 1. Create Window
local Window = Library:CreateWindow("EXOTIC V4", "Project Sandbox • Build v1.02")

-- 2. Create Tabs
local MainTab = Window:CreateTab("Main Settings")
local VisualTab = Window:CreateTab("Visual Configs")
local SettingsTab = Window:CreateTab("Misc Configs")

-- 3. Add Elements to 'Main Settings' Tab
MainTab:CreateButton("Perform Soft Execution", function()
    print("Execution Callback fired successfully!")
end)

MainTab:CreateToggle("Enable Silent Aim", true, function(state)
    print("Silent Aim Toggle State: ", state)
end)

MainTab:CreateSlider("Aimbot Field-Of-View", 10, 360, 90, function(value)
    print("FOV Slider Updated: ", value)
end)

MainTab:CreateInput("Config Name", "Type custom name...", function(text)
    print("Config Custom Input Saved: ", text)
end)

MainTab:CreateDropdown("Target Hitbox", {"Head", "HumanoidRootPart", "Torso", "Random"}, "Head", function(option)
    print("Selected Hitbox Target: ", option)
end)

-- 4. Add Elements to 'Visual Configs' Tab
VisualTab:CreateToggle("Draw Box ESP", false, function(state)
    print("Box ESP State: ", state)
end)

VisualTab:CreateToggle("Draw Nametags", true, function(state)
    print("Nametag ESP State: ", state)
end)

VisualTab:CreateSlider("ESP Render Distance", 100, 5000, 1500, function(value)
    print("Render Distance set to: ", value, " studs")
end)

-- 5. Add Elements to 'Misc Configs' Tab
SettingsTab:CreateButton("Unload Cheat Library", function()
    local container = ParentGui:FindFirstChild("SKBuilderUI_Library")
    if container then
        container:Destroy()
        print("Cheat interface safely closed and resources freed.")
    end
end)]]
