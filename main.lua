local SKUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") -- Change to CoreGui if using an executor

-- Draggable Logic Helper
local function MakeDraggable(topbar, object)
    local dragging, dragInput, dragStart, startPos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = object.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function SKUI:CreateWindow(config)
    local Window = {}
    Window.Elements = {} -- For search functionality

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SKUI_Hub"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false
    Window.ScreenGui = ScreenGui

    -- Main UI Frame (Glass Effect)
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    MainFrame.BackgroundTransparency = 0.8 -- Glass 'see-through' effect
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
    Window.MainFrame = MainFrame

    -- Topbar (For dragging and Close Button)
    local Topbar = Instance.new("Frame")
    Topbar.Size = UDim2.new(1, 0, 0, 30)
    Topbar.BackgroundTransparency = 1
    Topbar.Parent = MainFrame
    MakeDraggable(Topbar, MainFrame)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0.5, 0, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = config.Title .. " | " .. (config.Author or "")
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Parent = Topbar

    -- Close Button (Icon)
    local CloseBtn = Instance.new("ImageButton")
    CloseBtn.Size = UDim2.new(0, 20, 0, 20)
    CloseBtn.Position = UDim2.new(1, -30, 0, 5)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Image = "rbxassetid://6031094678" -- Close Icon
    CloseBtn.Parent = Topbar
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    -- Left Side (Tabs + Search, Not in a box)
    local LeftSide = Instance.new("Frame")
    LeftSide.Size = UDim2.new(0, 150, 1, -40)
    LeftSide.Position = UDim2.new(0, 10, 0, 35)
    LeftSide.BackgroundTransparency = 1
    LeftSide.Parent = MainFrame

    -- Search Bar
    local SearchBox = Instance.new("TextBox")
    SearchBox.Size = UDim2.new(1, 0, 0, 30)
    SearchBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SearchBox.BackgroundTransparency = 0.8
    SearchBox.PlaceholderText = "Search..."
    SearchBox.Text = ""
    SearchBox.TextColor3 = Color3.fromRGB(0,0,0)
    SearchBox.Parent = LeftSide
    Instance.new("UICorner", SearchBox)

    local SearchIcon = Instance.new("ImageLabel")
    SearchIcon.Size = UDim2.new(0, 15, 0, 15)
    SearchIcon.Position = UDim2.new(1, -20, 0.5, -7)
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.Image = "rbxassetid://6031154871" -- Search Icon
    SearchIcon.Parent = SearchBox

    -- Search Logic
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local query = string.lower(SearchBox.Text)
        for _, el in pairs(Window.Elements) do
            if string.find(string.lower(el.Name), query) then
                el.Visible = true
            else
                el.Visible = false
            end
        end
    end)

    -- Tab Container
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(1, 0, 1, -40)
    TabContainer.Position = UDim2.new(0, 0, 0, 40)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 2
    TabContainer.Parent = LeftSide
    local TabLayout = Instance.new("UIListLayout", TabContainer)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 5)

    -- Right Side (Elements)
    local RightSide = Instance.new("Frame")
    RightSide.Size = UDim2.new(1, -180, 1, -40)
    RightSide.Position = UDim2.new(0, 170, 0, 35)
    RightSide.BackgroundTransparency = 1
    RightSide.Parent = MainFrame

    Window.RightSide = RightSide
    Window.Tabs = {}

    -- Functions
    function Window:CreateMinimizeBtn(minConfig)
        local MinBtn = Instance.new("TextButton")
        MinBtn.Size = UDim2.new(0, 50, 0, 50)
        MinBtn.Position = UDim2.new(0, 20, 0, 20)
        MinBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        MinBtn.BackgroundTransparency = 0.5
        MinBtn.Text = minConfig.Title
        MinBtn.Parent = ScreenGui
        Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(1, 0)
        MakeDraggable(MinBtn, MinBtn)

        MinBtn.MouseButton1Click:Connect(function()
            MainFrame.Visible = not MainFrame.Visible
        end)
    end

    function Window:CreateTab(tabName)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 30)
        TabBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabBtn.BackgroundTransparency = 0.7
        TabBtn.Text = tabName
        TabBtn.Parent = TabContainer
        Instance.new("UICorner", TabBtn)

        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.ScrollBarThickness = 4
        TabContent.Visible = false
        TabContent.Parent = RightSide
        local ContentLayout = Instance.new("UIListLayout", TabContent)
        ContentLayout.Padding = UDim.new(0, 8)

        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(Window.Tabs) do t.Visible = false end
            TabContent.Visible = true
        end)

        table.insert(Window.Tabs, TabContent)
        if #Window.Tabs == 1 then TabContent.Visible = true end

        local TabObj = {}
        function TabObj:CreateGroupbox(groupName)
            local Groupbox = {}
            local GroupLabel = Instance.new("TextLabel")
            GroupLabel.Size = UDim2.new(1, 0, 0, 20)
            GroupLabel.BackgroundTransparency = 1
            GroupLabel.Text = groupName
            GroupLabel.Font = Enum.Font.GothamBold
            GroupLabel.TextXAlignment = Enum.TextXAlignment.Left
            GroupLabel.Parent = TabContent
            
            function Groupbox:CreateButton(btnConfig)
                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(1, 0, 0, 35)
                Btn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                Btn.BackgroundTransparency = 0.5
                Btn.Text = btnConfig.Title
                Btn.Parent = TabContent
                Instance.new("UICorner", Btn)
                Btn.MouseButton1Click:Connect(function() if not btnConfig.Locked then btnConfig.Callback() end end)
                Btn.Name = btnConfig.Title
                table.insert(Window.Elements, Btn)
            end

            function Groupbox:CreateDropdown(dropConfig)
                local DropBtn = Instance.new("TextButton")
                DropBtn.Size = UDim2.new(1, 0, 0, 35)
                DropBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                DropBtn.BackgroundTransparency = 0.5
                DropBtn.Text = dropConfig.Title .. " : " .. dropConfig.Value
                DropBtn.Parent = TabContent
                Instance.new("UICorner", DropBtn)
                DropBtn.Name = dropConfig.Title
                table.insert(Window.Elements, DropBtn)

                local DropLogic = {}
                function DropLogic:Refresh(newValues)
                    dropConfig.Values = newValues
                end

                DropBtn.MouseButton1Click:Connect(function()
                    -- Central Pop-up Dropdown Frame
                    local DropBg = Instance.new("Frame")
                    DropBg.Size = UDim2.new(1, 0, 1, 0)
                    DropBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    DropBg.BackgroundTransparency = 0.5
                    DropBg.ZIndex = 10
                    DropBg.Parent = ScreenGui

                    local DropFrame = Instance.new("ScrollingFrame")
                    DropFrame.Size = UDim2.new(0, 300, 0, 200)
                    DropFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
                    DropFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    DropFrame.ZIndex = 11
                    DropFrame.Parent = DropBg
                    Instance.new("UICorner", DropFrame)
                    local DLayout = Instance.new("UIListLayout", DropFrame)

                    for _, val in pairs(dropConfig.Values) do
                        local Item = Instance.new("TextButton")
                        Item.Size = UDim2.new(1, 0, 0, 30)
                        Item.Text = val
                        Item.ZIndex = 12
                        Item.Parent = DropFrame
                        Item.MouseButton1Click:Connect(function()
                            DropBtn.Text = dropConfig.Title .. " : " .. val
                            dropConfig.Callback(val)
                            DropBg:Destroy()
                        end)
                    end
                end)
                return DropLogic
            end

            function Groupbox:CreateToggle(tglConfig)
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
                ToggleFrame.BackgroundTransparency = 1
                ToggleFrame.Parent = TabContent
                ToggleFrame.Name = tglConfig.Title
                table.insert(Window.Elements, ToggleFrame)

                local TglLabel = Instance.new("TextLabel")
                TglLabel.Size = UDim2.new(0.8, 0, 1, 0)
                TglLabel.BackgroundTransparency = 1
                TglLabel.Text = tglConfig.Title
                TglLabel.TextXAlignment = Enum.TextXAlignment.Left
                TglLabel.Parent = ToggleFrame

                local TglBtn = Instance.new("TextButton")
                TglBtn.Size = UDim2.new(0, 30, 0, 30)
                TglBtn.Position = UDim2.new(1, -30, 0, 2)
                TglBtn.BackgroundColor3 = tglConfig.Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                TglBtn.Text = ""
                TglBtn.Parent = ToggleFrame
                Instance.new("UICorner", TglBtn).CornerRadius = UDim.new(1, 0)

                local state = tglConfig.Value
                TglBtn.MouseButton1Click:Connect(function()
                    state = not state
                    TglBtn.BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                    tglConfig.Callback(state)
                end)
            end

            function Groupbox:CreateSlider(sldConfig)
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Size = UDim2.new(1, 0, 0, 45)
                SliderFrame.BackgroundTransparency = 1
                SliderFrame.Parent = TabContent
                SliderFrame.Name = sldConfig.Title
                table.insert(Window.Elements, SliderFrame)

                local SldLabel = Instance.new("TextLabel")
                SldLabel.Size = UDim2.new(1, 0, 0, 20)
                SldLabel.BackgroundTransparency = 1
                SldLabel.Text = sldConfig.Title .. " : " .. sldConfig.Value.Default
                SldLabel.TextXAlignment = Enum.TextXAlignment.Left
                SldLabel.Parent = SliderFrame

                local Track = Instance.new("Frame")
                Track.Size = UDim2.new(1, 0, 0, 10)
                Track.Position = UDim2.new(0, 0, 0, 25)
                Track.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                Track.Parent = SliderFrame
                Instance.new("UICorner", Track)

                local Fill = Instance.new("Frame")
                Fill.Size = UDim2.new((sldConfig.Value.Default - sldConfig.Value.Min) / (sldConfig.Value.Max - sldConfig.Value.Min), 0, 1, 0)
                Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                Fill.Parent = Track
                Instance.new("UICorner", Fill)

                local Dragging = false
                Track.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = true
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = false
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local percent = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                        local val = sldConfig.Value.Min + ((sldConfig.Value.Max - sldConfig.Value.Min) * percent)
                        val = math.floor(val / sldConfig.Step) * sldConfig.Step
                        Fill.Size = UDim2.new(percent, 0, 1, 0)
                        SldLabel.Text = sldConfig.Title .. " : " .. tostring(val)
                        sldConfig.Callback(val)
                    end
                end)
            end

            function Groupbox:CreateInput(inpConfig)
                local InputBox = Instance.new("TextBox")
                InputBox.Size = UDim2.new(1, 0, 0, 35)
                InputBox.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                InputBox.BackgroundTransparency = 0.5
                InputBox.PlaceholderText = inpConfig.Placeholder
                InputBox.Text = inpConfig.Value
                InputBox.Parent = TabContent
                Instance.new("UICorner", InputBox)
                InputBox.Name = inpConfig.Title
                table.insert(Window.Elements, InputBox)

                InputBox.FocusLost:Connect(function(enterPressed)
                    if enterPressed then inpConfig.Callback(InputBox.Text) end
                end)
            end

            return Groupbox
        end
        return TabObj
    end
    return Window
end

return SKUI
