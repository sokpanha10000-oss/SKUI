--// SKUI Library
--// Glass UI / Draggable / Floating Minimize / Search / Dropdown Window
--// Size: 540x340

local SKUI = {}
SKUI.__index = SKUI

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

function SKUI:CreateWindow(cfg)
    cfg = cfg or {}

    local gui = Instance.new("ScreenGui")
    gui.Name = "SKUI"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function()
        gui.Parent = game:GetService("CoreGui")
    end)

    -- MAIN
    local Main = Instance.new("Frame")
    Main.Parent = gui
    Main.Size = UDim2.new(0,540,0,340)
    Main.Position = UDim2.new(0.5,-270,0.5,-170)
    Main.BackgroundColor3 = Color3.fromRGB(255,255,255)
    Main.BackgroundTransparency = 0.35
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0,18)

    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Color3.fromRGB(255,255,255)
    Stroke.Transparency = 0.7
    Stroke.Thickness = 1

    local Blur = Instance.new("UIGradient", Main)
    Blur.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(220,220,220))
    }

    -- TOPBAR
    local Top = Instance.new("Frame")
    Top.Parent = Main
    Top.Size = UDim2.new(1,0,0,45)
    Top.BackgroundTransparency = 1

    -- TITLE
    local Title = Instance.new("TextLabel")
    Title.Parent = Top
    Title.Position = UDim2.new(0,15,0,4)
    Title.Size = UDim2.new(0,260,1,0)
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 19
    Title.TextColor3 = Color3.new(1,1,1)
    Title.Text = cfg.Title or "SKUI HUB"

    -- AUTHOR
    local Author = Instance.new("TextLabel")
    Author.Parent = Top
    Author.Position = UDim2.new(0,15,0,22)
    Author.Size = UDim2.new(0,260,0,20)
    Author.BackgroundTransparency = 1
    Author.TextXAlignment = Enum.TextXAlignment.Left
    Author.Font = Enum.Font.Gotham
    Author.TextSize = 12
    Author.TextColor3 = Color3.fromRGB(220,220,220)
    Author.Text = cfg.Author or ""

    -- CLOSE BUTTON
    local Close = Instance.new("TextButton")
    Close.Parent = Top
    Close.Size = UDim2.new(0,28,0,28)
    Close.Position = UDim2.new(1,-38,0,8)
    Close.BackgroundColor3 = Color3.fromRGB(255,255,255)
    Close.BackgroundTransparency = 0.75
    Close.Text = "✕"
    Close.Font = Enum.Font.GothamBold
    Close.TextSize = 16
    Close.TextColor3 = Color3.new(1,1,1)
    Close.BorderSizePixel = 0
    Instance.new("UICorner", Close).CornerRadius = UDim.new(1,0)

    Close.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    -- SEARCH BAR
    local Search = Instance.new("TextBox")
    Search.Parent = Main
    Search.Size = UDim2.new(0,160,0,30)
    Search.Position = UDim2.new(0,15,0,50)
    Search.PlaceholderText = "🔍 Search..."
    Search.Text = ""
    Search.Font = Enum.Font.Gotham
    Search.TextSize = 14
    Search.TextColor3 = Color3.new(1,1,1)
    Search.PlaceholderColor3 = Color3.fromRGB(220,220,220)
    Search.BackgroundColor3 = Color3.fromRGB(255,255,255)
    Search.BackgroundTransparency = 0.75
    Search.BorderSizePixel = 0
    Instance.new("UICorner", Search).CornerRadius = UDim.new(0,10)

    -- LEFT TAB FRAME
    local Left = Instance.new("Frame")
    Left.Parent = Main
    Left.Size = UDim2.new(0,170,0,240)
    Left.Position = UDim2.new(0,15,0,90)
    Left.BackgroundColor3 = Color3.fromRGB(255,255,255)
    Left.BackgroundTransparency = 0.78
    Left.BorderSizePixel = 0
    Instance.new("UICorner", Left).CornerRadius = UDim.new(0,14)

    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Parent = Left
    TabScroll.Size = UDim2.new(1,-8,1,-8)
    TabScroll.Position = UDim2.new(0,4,0,4)
    TabScroll.CanvasSize = UDim2.new(0,0,0,0)
    TabScroll.ScrollBarThickness = 0
    TabScroll.BackgroundTransparency = 1

    local TabLayout = Instance.new("UIListLayout", TabScroll)
    TabLayout.Padding = UDim.new(0,5)

    -- RIGHT ELEMENT FRAME
    local Right = Instance.new("Frame")
    Right.Parent = Main
    Right.Size = UDim2.new(0,325,0,240)
    Right.Position = UDim2.new(0,200,0,90)
    Right.BackgroundColor3 = Color3.fromRGB(255,255,255)
    Right.BackgroundTransparency = 0.78
    Right.BorderSizePixel = 0
    Instance.new("UICorner", Right).CornerRadius = UDim.new(0,14)

    -- DRAGGABLE
    local dragging = false
    local dragInput
    local dragStart
    local startPos

    Top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Top.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart

            Main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    local Window = {}

    -- CREATE TAB
    function Window:CreateTab(name)
        local Tab = {}

        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = TabScroll
        TabBtn.Size = UDim2.new(1,-5,0,34)
        TabBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
        TabBtn.BackgroundTransparency = 0.8
        TabBtn.Text = name
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.TextSize = 14
        TabBtn.TextColor3 = Color3.new(1,1,1)
        TabBtn.BorderSizePixel = 0
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0,10)

        local Elements = Instance.new("ScrollingFrame")
        Elements.Parent = Right
        Elements.Size = UDim2.new(1,-10,1,-10)
        Elements.Position = UDim2.new(0,5,0,5)
        Elements.Visible = false
        Elements.BackgroundTransparency = 1
        Elements.ScrollBarThickness = 3
        Elements.CanvasSize = UDim2.new(0,0,0,0)

        local Layout = Instance.new("UIListLayout", Elements)
        Layout.Padding = UDim.new(0,6)

        TabBtn.MouseButton1Click:Connect(function()
            for _,v in pairs(Right:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end
            Elements.Visible = true
        end)

        -- BUTTON
        function Tab:addButton(opt)
            local Btn = Instance.new("TextButton")
            Btn.Parent = Elements
            Btn.Size = UDim2.new(1,-5,0,38)
            Btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
            Btn.BackgroundTransparency = 0.8
            Btn.Text = opt.Title or "Button"
            Btn.Font = Enum.Font.GothamBold
            Btn.TextSize = 14
            Btn.TextColor3 = Color3.new(1,1,1)
            Btn.BorderSizePixel = 0
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,10)

            Btn.MouseButton1Click:Connect(function()
                if opt.Callback then
                    opt.Callback()
                end
            end)
        end

        -- TOGGLE
        function Tab:AddToggle(opt)
            local Toggle = Instance.new("TextButton")
            Toggle.Parent = Elements
            Toggle.Size = UDim2.new(1,-5,0,38)
            Toggle.BackgroundColor3 = Color3.fromRGB(255,255,255)
            Toggle.BackgroundTransparency = 0.8
            Toggle.Text = opt.Title
            Toggle.Font = Enum.Font.GothamBold
            Toggle.TextSize = 14
            Toggle.TextColor3 = Color3.new(1,1,1)
            Toggle.BorderSizePixel = 0
            Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0,10)

            local state = opt.Value or false

            Toggle.MouseButton1Click:Connect(function()
                state = not state
                if opt.Callback then
                    opt.Callback(state)
                end
            end)
        end

        -- INPUT
        function Tab:AddInput(opt)
            local Box = Instance.new("TextBox")
            Box.Parent = Elements
            Box.Size = UDim2.new(1,-5,0,38)
            Box.BackgroundColor3 = Color3.fromRGB(255,255,255)
            Box.BackgroundTransparency = 0.8
            Box.PlaceholderText = opt.Placeholder or "Input..."
            Box.Text = opt.Value or ""
            Box.Font = Enum.Font.Gotham
            Box.TextSize = 14
            Box.TextColor3 = Color3.new(1,1,1)
            Box.BorderSizePixel = 0
            Instance.new("UICorner", Box).CornerRadius = UDim.new(0,10)

            Box.FocusLost:Connect(function()
                if opt.Callback then
                    opt.Callback(Box.Text)
                end
            end)
        end

        -- DROPDOWN
        function Tab:AddDropdown(opt)
            local Dropdown = {}
            local values = opt.Values or {}

            local Btn = Instance.new("TextButton")
            Btn.Parent = Elements
            Btn.Size = UDim2.new(1,-5,0,38)
            Btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
            Btn.BackgroundTransparency = 0.8
            Btn.Text = opt.Title.." ▼"
            Btn.Font = Enum.Font.GothamBold
            Btn.TextSize = 14
            Btn.TextColor3 = Color3.new(1,1,1)
            Btn.BorderSizePixel = 0
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,10)

            local DropFrame = Instance.new("Frame")
            DropFrame.Parent = Main
            DropFrame.Visible = false
            DropFrame.Size = UDim2.new(0,220,0,180)
            DropFrame.Position = UDim2.new(0.5,-110,0.5,-90)
            DropFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
            DropFrame.BackgroundTransparency = 0.2
            DropFrame.BorderSizePixel = 0
            Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0,14)

            local DropScroll = Instance.new("ScrollingFrame")
            DropScroll.Parent = DropFrame
            DropScroll.Size = UDim2.new(1,-10,1,-10)
            DropScroll.Position = UDim2.new(0,5,0,5)
            DropScroll.CanvasSize = UDim2.new(0,0,0,0)
            DropScroll.ScrollBarThickness = 3
            DropScroll.BackgroundTransparency = 1

            local DLayout = Instance.new("UIListLayout", DropScroll)
            DLayout.Padding = UDim.new(0,5)

            local function refresh()
                for _,v in pairs(DropScroll:GetChildren()) do
                    if v:IsA("TextButton") then
                        v:Destroy()
                    end
                end

                for _,name in pairs(values) do
                    local Item = Instance.new("TextButton")
                    Item.Parent = DropScroll
                    Item.Size = UDim2.new(1,-5,0,35)
                    Item.BackgroundColor3 = Color3.fromRGB(255,255,255)
                    Item.BackgroundTransparency = 0.7
                    Item.Text = name
                    Item.Font = Enum.Font.Gotham
                    Item.TextSize = 14
                    Item.TextColor3 = Color3.new(1,1,1)
                    Item.BorderSizePixel = 0
                    Instance.new("UICorner", Item).CornerRadius = UDim.new(0,10)

                    Item.MouseButton1Click:Connect(function()
                        DropFrame.Visible = false
                        Btn.Text = opt.Title.." : "..name
                        if opt.Callback then
                            opt.Callback(name)
                        end
                    end)
                end
            end

            refresh()

            Btn.MouseButton1Click:Connect(function()
                DropFrame.Visible = not DropFrame.Visible
            end)

            function Dropdown:Refresh(new)
                values = new
                refresh()
            end

            return Dropdown
        end

        -- SLIDER
        function Tab:AddSlider(opt)
            local Slider = Instance.new("TextButton")
            Slider.Parent = Elements
            Slider.Size = UDim2.new(1,-5,0,38)
            Slider.BackgroundColor3 = Color3.fromRGB(255,255,255)
            Slider.BackgroundTransparency = 0.8
            Slider.Text = opt.Title.." : "..opt.Value.Default
            Slider.Font = Enum.Font.GothamBold
            Slider.TextSize = 14
            Slider.TextColor3 = Color3.new(1,1,1)
            Slider.BorderSizePixel = 0
            Instance.new("UICorner", Slider).CornerRadius = UDim.new(0,10)

            local value = opt.Value.Default

            Slider.MouseButton1Click:Connect(function()
                value += opt.Step or 1

                if value > opt.Value.Max then
                    value = opt.Value.Min
                end

                Slider.Text = opt.Title.." : "..value

                if opt.Callback then
                    opt.Callback(value)
                end
            end)
        end

        return Tab
    end

    -- MINIMIZE BUTTON
    function Window:CreateMinimizeBtn(opt)
        local Mini = Instance.new("TextButton")
        Mini.Parent = gui
        Mini.Size = UDim2.new(0,55,0,55)
        Mini.Position = UDim2.new(0,30,0.5,0)
        Mini.BackgroundColor3 = Color3.fromRGB(255,255,255)
        Mini.BackgroundTransparency = 0.3
        Mini.Text = "☰"
        Mini.Font = Enum.Font.GothamBold
        Mini.TextSize = 22
        Mini.TextColor3 = Color3.new(1,1,1)
        Mini.BorderSizePixel = 0
        Instance.new("UICorner", Mini).CornerRadius = UDim.new(1,0)

        local draggingMini = false
        local dragStartMini
        local startPosMini

        Mini.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggingMini = true
                dragStartMini = input.Position
                startPosMini = Mini.Position
            end
        end)

        UIS.InputChanged:Connect(function(input)
            if draggingMini and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStartMini

                Mini.Position = UDim2.new(
                    startPosMini.X.Scale,
                    startPosMini.X.Offset + delta.X,
                    startPosMini.Y.Scale,
                    startPosMini.Y.Offset + delta.Y
                )
            end
        end)

        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggingMini = false
            end
        end)

        Mini.MouseButton1Click:Connect(function()
            Main.Visible = not Main.Visible
        end)
    end

    return Window
end

return SKUI
