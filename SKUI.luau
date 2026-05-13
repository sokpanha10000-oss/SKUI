--// AirGlass UI Library
--// Self-contained Roblox Lua UI library
--// Methods:
--// Library:CreateWindow({})
--// Library:CreateUI({}) -- alias
--// Window:CreateMinimizeBtn({})
--// Window:AddTab({})
--// Tab:AddSection("")
--// Section:AddToggle({})
--// Section:AddSlider({})
--// Section:AddInput({})
--// Section:AddButton({})
--// Section:AddDropdown({})
--// Dropdown:Refresh({})

local Library = {}
Library.Name = "AirGlass UI"

--// Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

--// Helpers
local function getParent()
    if gethui then
        return gethui()
    end
    return CoreGui
end

local function create(className, props)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    return obj
end

local function corner(parent, radius)
    return create("UICorner", {
        CornerRadius = radius or UDim.new(0, 10),
        Parent = parent
    })
end

local function stroke(parent, thickness, transparency, color)
    return create("UIStroke", {
        Thickness = thickness or 1,
        Transparency = transparency or 0.55,
        Color = color or Color3.fromRGB(255, 255, 255),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent
    })
end

local function padding(parent, left, right, top, bottom)
    return create("UIPadding", {
        PaddingLeft = UDim.new(0, left or 0),
        PaddingRight = UDim.new(0, right or 0),
        PaddingTop = UDim.new(0, top or 0),
        PaddingBottom = UDim.new(0, bottom or 0),
        Parent = parent
    })
end

local function tween(obj, info, goal)
    local t = TweenService:Create(obj, info, goal)
    t:Play()
    return t
end

local function round(n, p)
    p = p or 0
    local m = 10 ^ p
    return math.floor(n * m + 0.5) / m
end

local function safeCall(fn, ...)
    if typeof(fn) == "function" then
        local ok, err = pcall(fn, ...)
        if not ok then
            warn("[AirGlassUI Callback Error]:", err)
        end
    end
end

local function makeDraggable(dragHandle, dragTarget)
    local dragging = false
    local dragStart, startPos
    local dragInput

    local function update(input)
        local delta = input.Position - dragStart
        dragTarget.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = dragTarget.Position
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
            update(input)
        end
    end)
end

local function iconToLabel(parent, iconText)
    if not iconText or iconText == "" then
        return nil
    end

    local label = create("TextLabel", {
        Name = "Icon",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 20, 0, 20),
        Font = Enum.Font.GothamSemibold,
        Text = tostring(iconText),
        TextSize = 16,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextTransparency = 0.05,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        Parent = parent
    })
    return label
end

--// Notifications
function Library:Notify(opts)
    opts = opts or {}

    local title = opts.Title or "Notification"
    local content = opts.Content or ""
    local duration = opts.Duration or 3

    local gui = create("ScreenGui", {
        Name = "AirGlassNotify",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = getParent()
    })

    local holder = create("Frame", {
        Name = "Holder",
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -20, 1, -20),
        Size = UDim2.fromOffset(300, 0),
        BackgroundTransparency = 1,
        Parent = gui
    })

    local box = create("Frame", {
        Name = "Box",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.82,
        Parent = holder
    })
    corner(box, UDim.new(0, 16))
    stroke(box, 1, 0.6, Color3.fromRGB(255, 255, 255))
    padding(box, 14, 14, 12, 12)

    local titleLabel = create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextSize = 16,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = box
    })

    local contentLabel = create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 22),
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Font = Enum.Font.Gotham,
        Text = content,
        TextWrapped = true,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(230, 230, 230),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        Parent = box
    })

    box.Size = UDim2.fromOffset(300, 0)

    local count = create("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 1, 8),
        Size = UDim2.new(1, 0, 0, 3),
        Parent = box
    })

    local bar = create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.25,
        Parent = count
    })
    corner(bar, UDim.new(1, 0))

    task.delay(duration, function()
        if gui and gui.Parent then
            tween(box, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
            tween(titleLabel, TweenInfo.new(0.18), {TextTransparency = 1})
            tween(contentLabel, TweenInfo.new(0.18), {TextTransparency = 1})
            tween(bar, TweenInfo.new(0.18), {BackgroundTransparency = 1})
            task.wait(0.2)
            gui:Destroy()
        end
    end)
end

--// Theme helper
local function getTheme(name)
    local themes = {
        ["Blood Red"] = {
            Accent = Color3.fromRGB(180, 10, 20),
            Accent2 = Color3.fromRGB(120, 0, 10),
            Background = Color3.fromRGB(18, 18, 22),
            Panel = Color3.fromRGB(28, 28, 34),
            Tab = Color3.fromRGB(255, 255, 255),
            Text = Color3.fromRGB(255, 255, 255),
            SubText = Color3.fromRGB(210, 210, 210)
        },
        ["Dark"] = {
            Accent = Color3.fromRGB(75, 150, 255),
            Accent2 = Color3.fromRGB(50, 100, 180),
            Background = Color3.fromRGB(18, 18, 22),
            Panel = Color3.fromRGB(26, 26, 30),
            Tab = Color3.fromRGB(255, 255, 255),
            Text = Color3.fromRGB(255, 255, 255),
            SubText = Color3.fromRGB(210, 210, 210)
        }
    }
    return themes[name] or themes["Dark"]
end

function Library:CreateWindow(opts)
    opts = opts or {}

    local Theme = getTheme(opts.Theme)
    local Window = {
        Title = opts.Title or "Hub",
        SubTitle = opts.SubTitle or "",
        Tabs = {},
        Sections = {},
        Pages = {},
        ActiveTab = nil,
        Closed = false,
        Minimized = false,
        Acrylic = opts.Acrylic ~= false,
        SearchEnabled = opts.Search ~= false,
        MinimizeKey = opts.MinimizeKey or Enum.KeyCode.LeftControl,
        UserInfoTop = opts.UserInfoTop == true,
        UserInfoTitle = opts.UserInfoTitle or (LocalPlayer and LocalPlayer.DisplayName) or "Player",
        UserInfoSubtitle = opts.UserInfoSubtitle or "User",
        UserInfoColor = opts.UserInfoColor or Theme.Accent,
        TabWidth = opts.TabWidth or 160,
        Size = opts.Size or UDim2.fromOffset(480, 460),
        Theme = Theme,
        UI = nil
    }

    local gui = create("ScreenGui", {
        Name = "AirGlassUI",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = getParent()
    })
    Window.UI = gui

    if Window.Acrylic then
        local blur = Lighting:FindFirstChild("AirGlassBlur")
        if not blur then
            blur = create("BlurEffect", {
                Name = "AirGlassBlur",
                Size = 14,
                Parent = Lighting
            })
        end
    end

    local root = create("Frame", {
        Name = "Root",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = Window.Size,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.83,
        Parent = gui
    })
    corner(root, UDim.new(0, 18))
    stroke(root, 1, 0.68, Color3.fromRGB(255, 255, 255))
    makeDraggable(root, root)

    local shadow = create("ImageLabel", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 60, 1, 60),
        Position = UDim2.new(0, -30, 0, -18),
        Image = "rbxassetid://1316045217",
        ImageTransparency = 0.65,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118),
        Parent = root
    })
    shadow.ZIndex = root.ZIndex - 1

    local topBar = create("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 62),
        BackgroundTransparency = 1,
        Parent = root
    })

    local titleBlock = create("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 18, 0, 10),
        Size = UDim2.new(1, -120, 0, 42),
        Parent = topBar
    })

    local titleLabel = create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 22),
        Font = Enum.Font.GothamBold,
        Text = Window.Title,
        TextSize = 19,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBlock
    })

    local subLabel = create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 20),
        Size = UDim2.new(1, 0, 0, 18),
        Font = Enum.Font.Gotham,
        Text = Window.SubTitle,
        TextSize = 13,
        TextColor3 = Theme.SubText,
        TextTransparency = 0.06,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBlock
    })

    local userInfo = create("Frame", {
        Name = "UserInfo",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -64, 0, 11),
        Size = UDim2.new(0, 170, 0, 40),
        Visible = Window.UserInfoTop,
        Parent = topBar
    })

    local avatar = create("Frame", {
        Name = "Avatar",
        BackgroundColor3 = Window.UserInfoColor,
        BackgroundTransparency = 0.18,
        Size = UDim2.fromOffset(36, 36),
        Parent = userInfo
    })
    corner(avatar, UDim.new(1, 0))
    stroke(avatar, 1, 0.7, Color3.fromRGB(255, 255, 255))

    local avatarLetter = create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = string.sub(Window.UserInfoTitle or "U", 1, 1),
        TextSize = 16,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Parent = avatar
    })

    local userText = create("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 44, 0, 0),
        Size = UDim2.new(1, -44, 1, 0),
        Parent = userInfo
    })

    create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 18),
        Font = Enum.Font.GothamSemibold,
        Text = Window.UserInfoTitle,
        TextSize = 14,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = userText
    })

    create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 18),
        Size = UDim2.new(1, 0, 0, 16),
        Font = Enum.Font.Gotham,
        Text = Window.UserInfoSubtitle,
        TextSize = 12,
        TextColor3 = Theme.SubText,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = userText
    })

    local closeBtn = create("TextButton", {
        Name = "CloseBtn",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -14, 0, 14),
        Size = UDim2.fromOffset(34, 34),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.84,
        AutoButtonColor = false,
        Text = "×",
        Font = Enum.Font.GothamBold,
        TextSize = 22,
        TextColor3 = Theme.Text,
        Parent = topBar
    })
    corner(closeBtn, UDim.new(0, 12))
    stroke(closeBtn, 1, 0.72, Color3.fromRGB(255, 255, 255))

    local body = create("Frame", {
        Name = "Body",
        Position = UDim2.new(0, 12, 0, 58),
        Size = UDim2.new(1, -24, 1, -70),
        BackgroundTransparency = 1,
        Parent = root
    })

    local leftPanel = create("Frame", {
        Name = "TabsPanel",
        Size = UDim2.new(0, Window.TabWidth, 1, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.9,
        Parent = body
    })
    corner(leftPanel, UDim.new(0, 16))
    stroke(leftPanel, 1, 0.78, Color3.fromRGB(255, 255, 255))
    padding(leftPanel, 10, 10, 10, 10)

    local rightPanel = create("Frame", {
        Name = "ElementsPanel",
        Position = UDim2.new(0, Window.TabWidth + 12, 0, 0),
        Size = UDim2.new(1, -Window.TabWidth - 12, 1, 0),
        BackgroundTransparency = 1,
        Parent = body
    })

    local tabSearchBox = nil
    local tabButtonsHolder = leftPanel

    if Window.SearchEnabled then
        tabSearchBox = create("TextBox", {
            Name = "TabSearch",
            Size = UDim2.new(1, 0, 0, 34),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.88,
            PlaceholderText = "Search tabs...",
            Text = "",
            ClearTextOnFocus = false,
            Font = Enum.Font.Gotham,
            TextSize = 13,
            TextColor3 = Theme.Text,
            PlaceholderColor3 = Color3.fromRGB(190, 190, 190),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = leftPanel
        })
        corner(tabSearchBox, UDim.new(0, 12))
        stroke(tabSearchBox, 1, 0.82, Color3.fromRGB(255, 255, 255))
        padding(tabSearchBox, 12, 12, 0, 0)

        tabButtonsHolder = create("ScrollingFrame", {
            Name = "TabScroll",
            Position = UDim2.new(0, 0, 0, 42),
            Size = UDim2.new(1, 0, 1, -42),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageTransparency = 0.2,
            CanvasSize = UDim2.new(),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Parent = leftPanel
        })
    else
        tabButtonsHolder = create("ScrollingFrame", {
            Name = "TabScroll",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageTransparency = 0.2,
            CanvasSize = UDim2.new(),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Parent = leftPanel
        })
    end

    local tabLayout = create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = tabButtonsHolder
    })
    padding(tabButtonsHolder, 0, 6, 0, 0)

    local pageContainer = create("Frame", {
        Name = "PageContainer",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = rightPanel
    })

    local function createPage()
        local scroll = create("ScrollingFrame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 3,
            ScrollBarImageTransparency = 0.15,
            CanvasSize = UDim2.new(),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = pageContainer
        })
        padding(scroll, 2, 8, 0, 6)

        local list = create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 12),
            Parent = scroll
        })

        return scroll, list
    end

    local function setActiveTab(tabData)
        for _, t in pairs(Window.Tabs) do
            if t.Page then
                t.Page.Visible = false
            end
            if t.Button then
                tween(t.Button, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.88,
                    TextColor3 = Theme.Text
                })
            end
        end

        if tabData and tabData.Page then
            tabData.Page.Visible = true
            Window.ActiveTab = tabData
            if tabData.Button then
                tween(tabData.Button, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.72,
                    TextColor3 = Color3.fromRGB(255, 255, 255)
                })
            end
        end
    end

    function Window:AddTab(tabOpts)
        tabOpts = tabOpts or {}
        local title = tabOpts.Title or "Tab"
        local icon = tabOpts.Icon or ""

        local tabButton = create("TextButton", {
            Name = "TabButton",
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.88,
            AutoButtonColor = false,
            Text = "",
            Parent = tabButtonsHolder
        })
        corner(tabButton, UDim.new(0, 12))
        stroke(tabButton, 1, 0.82, Color3.fromRGB(255, 255, 255))

        local iconLbl = nil
        if icon ~= "" then
            iconLbl = create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 11, 0, 0),
                Size = UDim2.new(0, 18, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = tostring(icon),
                TextSize = 15,
                TextColor3 = Theme.Text,
                Parent = tabButton
            })
        end

        local txt = create("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, icon ~= "" and 34 or 12, 0, 0),
            Size = UDim2.new(1, -(icon ~= "" and 40 or 24), 1, 0),
            Font = Enum.Font.GothamSemibold,
            Text = title,
            TextSize = 14,
            TextColor3 = Theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = tabButton
        })

        local page, layout = createPage()

        local tabData = {
            Title = title,
            Icon = icon,
            Button = tabButton,
            Page = page,
            Layout = layout,
            Sections = {}
        }

        table.insert(Window.Tabs, tabData)

        tabButton.MouseButton1Click:Connect(function()
            setActiveTab(tabData)
        end)

        if Window.SearchEnabled and tabSearchBox then
            tabSearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                local q = string.lower(tabSearchBox.Text or "")
                for _, t in pairs(Window.Tabs) do
                    local match = q == "" or string.find(string.lower(t.Title), q, 1, true)
                    if t.Button then
                        t.Button.Visible = match
                    end
                end
            end)
        end

        function tabData:AddSection(sectionTitle)
            local section = {}
            section.Title = sectionTitle or "Section"
            section.Frame = create("Frame", {
                Name = "Section",
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 0.88,
                Parent = page
            })
            corner(section.Frame, UDim.new(0, 16))
            stroke(section.Frame, 1, 0.84, Color3.fromRGB(255, 255, 255))
            padding(section.Frame, 14, 14, 12, 14)

            create("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20),
                Font = Enum.Font.GothamBold,
                Text = section.Title,
                TextSize = 15,
                TextColor3 = Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = section.Frame
            })

            local holder = create("Frame", {
                Name = "Holder",
                Position = UDim2.new(0, 0, 0, 26),
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Parent = section.Frame
            })

            local holderLayout = create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 10),
                Parent = holder
            })

            local function elementWrap(height)
                local element = create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, height),
                    Parent = holder
                })
                return element
            end

            function section:AddButton(btn)
                btn = btn or {}
                local row = elementWrap(34)

                local button = create("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 0.86,
                    AutoButtonColor = false,
                    Text = "",
                    Parent = row
                })
                corner(button, UDim.new(0, 12))
                stroke(button, 1, 0.84, Color3.fromRGB(255, 255, 255))

                if btn.Icon then
                    create("TextLabel", {
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 12, 0, 0),
                        Size = UDim2.new(0, 20, 1, 0),
                        Font = Enum.Font.GothamSemibold,
                        Text = tostring(btn.Icon),
                        TextSize = 15,
                        TextColor3 = Theme.Text,
                        Parent = button
                    })
                end

                create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, btn.Icon and 34 or 12, 0, 0),
                    Size = UDim2.new(1, -(btn.Icon and 40 or 24), 1, 0),
                    Font = Enum.Font.GothamSemibold,
                    Text = btn.Title or "Button",
                    TextSize = 14,
                    TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = button
                })

                button.MouseEnter:Connect(function()
                    tween(button, TweenInfo.new(0.12), {BackgroundTransparency = 0.78})
                end)
                button.MouseLeave:Connect(function()
                    tween(button, TweenInfo.new(0.12), {BackgroundTransparency = 0.86})
                end)

                button.MouseButton1Click:Connect(function()
                    safeCall(btn.Callback)
                end)
            end

            function section:AddToggle(tog)
                tog = tog or {}
                local default = tog.Default == true
                local state = default

                local row = elementWrap(38)

                local toggleBtn = create("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 0.88,
                    AutoButtonColor = false,
                    Text = "",
                    Parent = row
                })
                corner(toggleBtn, UDim.new(0, 12))
                stroke(toggleBtn, 1, 0.84, Color3.fromRGB(255, 255, 255))

                local titleLbl = create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0, 0),
                    Size = UDim2.new(1, -80, 1, 0),
                    Font = Enum.Font.GothamSemibold,
                    Text = tog.Title or "Toggle",
                    TextSize = 14,
                    TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = toggleBtn
                })

                local box = create("Frame", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -12, 0.5, 0),
                    Size = UDim2.fromOffset(42, 22),
                    BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(110, 110, 110),
                    BackgroundTransparency = 0.18,
                    Parent = toggleBtn
                })
                corner(box, UDim.new(1, 0))

                local knob = create("Frame", {
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = state and UDim2.new(1, -11, 0.5, 0) or UDim2.new(0, 11, 0.5, 0),
                    Size = UDim2.fromOffset(16, 16),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = box
                })
                corner(knob, UDim.new(1, 0))

                local function setValue(v)
                    state = v and true or false
                    tween(box, TweenInfo.new(0.15), {BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(110, 110, 110)})
                    tween(knob, TweenInfo.new(0.15), {
                        Position = state and UDim2.new(1, -11, 0.5, 0) or UDim2.new(0, 11, 0.5, 0)
                    })
                    safeCall(tog.Callback, state)
                end

                toggleBtn.MouseButton1Click:Connect(function()
                    setValue(not state)
                end)

                setValue(default)
            end

            function section:AddInput(inp)
                inp = inp or {}
                local row = elementWrap(40)

                local box = create("TextBox", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 0.88,
                    PlaceholderText = inp.Placeholder or "Type here...",
                    Text = "",
                    ClearTextOnFocus = false,
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    TextColor3 = Theme.Text,
                    PlaceholderColor3 = Color3.fromRGB(185, 185, 185),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = row
                })
                corner(box, UDim.new(0, 12))
                stroke(box, 1, 0.84, Color3.fromRGB(255, 255, 255))
                padding(box, 12, 12, 0, 0)

                box.FocusLost:Connect(function(enter)
                    if inp.Finished or enter then
                        local v = box.Text
                        if inp.Numeric then
                            v = tonumber(v) or 0
                        end
                        safeCall(inp.Callback, v)
                    end
                end)
            end

            function section:AddSlider(sli)
                sli = sli or {}
                local min = sli.Min or 0
                local max = sli.Max or 100
                local default = sli.Default or min
                local rounding = sli.Rounding or 1
                local value = default

                local row = elementWrap(54)

                local base = create("Frame", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 0.88,
                    Parent = row
                })
                corner(base, UDim.new(0, 12))
                stroke(base, 1, 0.84, Color3.fromRGB(255, 255, 255))
                padding(base, 12, 12, 8, 8)

                create("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -60, 0, 16),
                    Font = Enum.Font.GothamSemibold,
                    Text = sli.Title or "Slider",
                    TextSize = 14,
                    TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = base
                })

                local valText = create("TextLabel", {
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.fromOffset(60, 16),
                    Font = Enum.Font.Gotham,
                    Text = tostring(default),
                    TextSize = 13,
                    TextColor3 = Theme.SubText,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = base
                })

                local bar = create("Frame", {
                    Position = UDim2.new(0, 0, 0, 24),
                    Size = UDim2.new(1, 0, 0, 8),
                    BackgroundColor3 = Color3.fromRGB(90, 90, 90),
                    BackgroundTransparency = 0.35,
                    Parent = base
                })
                corner(bar, UDim.new(1, 0))

                local fill = create("Frame", {
                    Size = UDim2.new(0, 0, 1, 0),
                    BackgroundColor3 = Theme.Accent,
                    BackgroundTransparency = 0.02,
                    Parent = bar
                })
                corner(fill, UDim.new(1, 0))

                local dragging = false

                local function setSlider(v)
                    v = math.clamp(v, min, max)
                    v = round(v, rounding)
                    value = v

                    local alpha = (v - min) / (max - min)
                    fill.Size = UDim2.new(alpha, 0, 1, 0)
                    valText.Text = tostring(v)
                    safeCall(sli.Callback, v)
                end

                local function updateFromX(x)
                    local alpha = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                    local v = min + (max - min) * alpha
                    setSlider(v)
                end

                bar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        updateFromX(input.Position.X)
                    end
                end)

                bar.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        updateFromX(input.Position.X)
                    end
                end)

                setSlider(default)
            end

            function section:AddDropdown(drp)
                drp = drp or {}

                local dropdownObj = {}
                local values = drp.Values or {}
                local selected = drp.Default
                local multi = drp.Multi == true
                local noSearch = drp.NoSearch == true

                local row = elementWrap(40)

                local main = create("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 0.88,
                    AutoButtonColor = false,
                    Text = "",
                    Parent = row
                })
                corner(main, UDim.new(0, 12))
                stroke(main, 1, 0.84, Color3.fromRGB(255, 255, 255))
                padding(main, 12, 12, 0, 0)

                local titleLbl = create("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -34, 1, 0),
                    Font = Enum.Font.GothamSemibold,
                    Text = drp.Title or "Dropdown",
                    TextSize = 14,
                    TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = main
                })

                local arrow = create("TextLabel", {
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, 0, 0.5, 0),
                    Size = UDim2.fromOffset(18, 18),
                    Font = Enum.Font.GothamBold,
                    Text = "⌄",
                    TextSize = 18,
                    TextColor3 = Theme.SubText,
                    Parent = main
                })

                local function currentText()
                    if multi then
                        if typeof(selected) == "table" then
                            local t = {}
                            for k, v in pairs(selected) do
                                if v then table.insert(t, k) end
                            end
                            return (#t > 0 and table.concat(t, ", ")) or "Select..."
                        end
                        return "Select..."
                    else
                        return selected or "Select..."
                    end
                end

                local function refreshMainText()
                    titleLbl.Text = (drp.Title or "Dropdown") .. "  •  " .. currentText()
                end

                local overlayGui, modal, listScroll, searchBox, closeModal, modalHolder
                local opened = false

                local function closeDropdown()
                    if overlayGui and overlayGui.Parent then
                        overlayGui:Destroy()
                    end
                    opened = false
                end

                local function openDropdown()
                    if opened then
                        closeDropdown()
                        return
                    end
                    opened = true

                    overlayGui = create("ScreenGui", {
                        Name = "AirGlassDropdown",
                        ResetOnSpawn = false,
                        IgnoreGuiInset = true,
                        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
                        Parent = getParent()
                    })

                    local dim = create("TextButton", {
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                        BackgroundTransparency = 0.55,
                        AutoButtonColor = false,
                        Text = "",
                        Parent = overlayGui
                    })

                    dim.MouseButton1Click:Connect(closeDropdown)

                    modalHolder = create("Frame", {
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        Size = UDim2.fromOffset(300, 360),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 0.86,
                        Parent = overlayGui
                    })
                    corner(modalHolder, UDim.new(0, 18))
                    stroke(modalHolder, 1, 0.78, Color3.fromRGB(255, 255, 255))
                    makeDraggable(modalHolder, modalHolder)

                    create("TextLabel", {
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 14, 0, 12),
                        Size = UDim2.new(1, -56, 0, 22),
                        Font = Enum.Font.GothamBold,
                        Text = drp.Title or "Dropdown",
                        TextSize = 16,
                        TextColor3 = Theme.Text,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = modalHolder
                    })

                    closeModal = create("TextButton", {
                        AnchorPoint = Vector2.new(1, 0),
                        Position = UDim2.new(1, -12, 0, 12),
                        Size = UDim2.fromOffset(28, 28),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 0.84,
                        AutoButtonColor = false,
                        Text = "×",
                        Font = Enum.Font.GothamBold,
                        TextSize = 20,
                        TextColor3 = Theme.Text,
                        Parent = modalHolder
                    })
                    corner(closeModal, UDim.new(0, 10))
                    stroke(closeModal, 1, 0.8, Color3.fromRGB(255, 255, 255))
                    closeModal.MouseButton1Click:Connect(closeDropdown)

                    local y = 44
                    if not noSearch then
                        searchBox = create("TextBox", {
                            Position = UDim2.new(0, 12, 0, y),
                            Size = UDim2.new(1, -24, 0, 34),
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            BackgroundTransparency = 0.88,
                            PlaceholderText = "Search...",
                            Text = "",
                            ClearTextOnFocus = false,
                            Font = Enum.Font.Gotham,
                            TextSize = 13,
                            TextColor3 = Theme.Text,
                            PlaceholderColor3 = Color3.fromRGB(185, 185, 185),
                            TextXAlignment = Enum.TextXAlignment.Left,
                            Parent = modalHolder
                        })
                        corner(searchBox, UDim.new(0, 12))
                        stroke(searchBox, 1, 0.84, Color3.fromRGB(255, 255, 255))
                        padding(searchBox, 12, 12, 0, 0)
                        y = y + 42
                    end

                    listScroll = create("ScrollingFrame", {
                        Position = UDim2.new(0, 12, 0, y),
                        Size = UDim2.new(1, -24, 1, -(y + 12)),
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        ScrollBarThickness = 3,
                        ScrollBarImageTransparency = 0.2,
                        CanvasSize = UDim2.new(),
                        AutomaticCanvasSize = Enum.AutomaticSize.Y,
                        Parent = modalHolder
                    })

                    local listLayout = create("UIListLayout", {
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Padding = UDim.new(0, 8),
                        Parent = listScroll
                    })

                    local function rebuild()
                        for _, child in ipairs(listScroll:GetChildren()) do
                            if child:IsA("Frame") or child:IsA("TextButton") then
                                child:Destroy()
                            end
                        end

                        local search = ""
                        if searchBox then
                            search = string.lower(searchBox.Text or "")
                        end

                        for _, v in ipairs(values) do
                            local textValue = tostring(v)
                            if search == "" or string.find(string.lower(textValue), search, 1, true) then
                                local item = create("TextButton", {
                                    Size = UDim2.new(1, 0, 0, 34),
                                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                    BackgroundTransparency = 0.88,
                                    AutoButtonColor = false,
                                    Text = "",
                                    Parent = listScroll
                                })
                                corner(item, UDim.new(0, 12))
                                stroke(item, 1, 0.84, Color3.fromRGB(255, 255, 255))

                                create("TextLabel", {
                                    BackgroundTransparency = 1,
                                    Position = UDim2.new(0, 12, 0, 0),
                                    Size = UDim2.new(1, -24, 1, 0),
                                    Font = Enum.Font.GothamSemibold,
                                    Text = textValue,
                                    TextSize = 14,
                                    TextColor3 = Theme.Text,
                                    TextXAlignment = Enum.TextXAlignment.Left,
                                    Parent = item
                                })

                                item.MouseEnter:Connect(function()
                                    tween(item, TweenInfo.new(0.12), {BackgroundTransparency = 0.76})
                                end)
                                item.MouseLeave:Connect(function()
                                    tween(item, TweenInfo.new(0.12), {BackgroundTransparency = 0.88})
                                end)

                                item.MouseButton1Click:Connect(function()
                                    if multi then
                                        selected = selected or {}
                                        selected[textValue] = not selected[textValue]
                                        safeCall(drp.Callback, selected)
                                        refreshMainText()
                                        rebuild()
                                    else
                                        selected = textValue
                                        safeCall(drp.Callback, selected)
                                        refreshMainText()
                                        closeDropdown()
                                    end
                                end)
                            end
                        end
                    end

                    if searchBox then
                        searchBox:GetPropertyChangedSignal("Text"):Connect(rebuild)
                    end

                    rebuild()
                end

                main.MouseButton1Click:Connect(openDropdown)

                function dropdownObj:Refresh(newValues)
                    values = newValues or {}
                    if not multi then
                        if selected ~= nil then
                            local found = false
                            for _, v in ipairs(values) do
                                if tostring(v) == tostring(selected) then
                                    found = true
                                    break
                                end
                            end
                            if not found then
                                selected = values[1]
                            end
                        else
                            selected = values[1]
                        end
                    end
                    refreshMainText()
                end

                refreshMainText()
                if not multi and selected == nil then
                    selected = values[1]
                    refreshMainText()
                end

                return dropdownObj
            end

            table.insert(Window.Sections, section)
            return section
        end

        if #Window.Tabs == 1 then
            setActiveTab(tabData)
        end

        return tabData
    end

    function Window:CreateMinimizeBtn(btnOpts)
        btnOpts = btnOpts or {}

        local floating = create("Frame", {
            Name = "MinimizeBtn",
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 18, 0.5, 0),
            Size = UDim2.fromOffset(124, 40),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.84,
            Parent = gui
        })
        corner(floating, UDim.new(0, 14))
        stroke(floating, 1, 0.8, Color3.fromRGB(255, 255, 255))
        makeDraggable(floating, floating)

        local icon = create("Frame", {
            BackgroundColor3 = Theme.Accent,
            BackgroundTransparency = 0.08,
            Position = UDim2.new(0, 8, 0, 7),
            Size = UDim2.fromOffset(26, 26),
            Parent = floating
        })
        corner(icon, UDim.new(1, 0))

        local iconText = create("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Font = Enum.Font.GothamBold,
            Text = btnOpts.Image and "⌂" or "≡",
            TextSize = 16,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Parent = icon
        })

        local label = create("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 42, 0, 0),
            Size = UDim2.new(1, -50, 1, 0),
            Font = Enum.Font.GothamSemibold,
            Text = btnOpts.Title or "Open UI",
            TextSize = 14,
            TextColor3 = Theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = floating
        })

        local function refreshText()
            label.Text = Window.Minimized and (btnOpts.OpenText or "Open UI") or (btnOpts.Title or "Open UI")
            icon.BackgroundColor3 = Window.Minimized and Theme.Accent or Theme.Accent
        end

        local function toggleWindow()
            Window.Minimized = not Window.Minimized
            Window.UI.Root.Visible = not Window.Minimized
            refreshText()
        end

        floating.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                toggleWindow()
            end
        end)

        Window.MinimizeBtn = floating
        refreshText()

        return {
            SetText = function(_, text)
                btnOpts.Title = text
                refreshText()
            end,
            Toggle = toggleWindow,
            Instance = floating
        }
    end

    closeBtn.MouseButton1Click:Connect(function()
        Window.Closed = true
        if gui then
            gui:Destroy()
        end
        local blur = Lighting:FindFirstChild("AirGlassBlur")
        if blur then
            blur:Destroy()
        end
    end)

    if Window.MinimizeKey then
        UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.KeyCode == Window.MinimizeKey and not Window.Closed then
                Window.Minimized = not Window.Minimized
                root.Visible = not Window.Minimized
                if Window.MinimizeBtn then
                    local txt = Window.Minimized and "Open UI" or "Hide UI"
                    local lbl = Window.MinimizeBtn:FindFirstChildWhichIsA("TextLabel")
                    if lbl then
                        lbl.Text = txt
                    end
                end
            end
        end)
    end

    function Window:SetVisible(state)
        if self.Closed then return end
        root.Visible = state and true or false
    end

    function Window:Destroy()
        if gui then gui:Destroy() end
        local blur = Lighting:FindFirstChild("AirGlassBlur")
        if blur then blur:Destroy() end
    end

    function Window:Close()
        self:Destroy()
    end

    function Window:CreateUI(opts)
        return self
    end

    if opts.DefaultOpen == false then
        root.Visible = false
        Window.Minimized = true
    end

    return Window
end

Library.CreateUI = Library.CreateWindow

return Library
