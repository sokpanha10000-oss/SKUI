--// Nexus UI Library (Dark Green)
--// Self-contained UI library for Roblox executors / Studio testing

local SKUI = {}
SKUI.__index = SKUI

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local function new(className, props)
    local inst = Instance.new(className)
    if props then
        for k, v in pairs(props) do
            inst[k] = v
        end
    end
    return inst
end

local function corner(parent, radius)
    local c = new("UICorner", {CornerRadius = UDim.new(0, radius or 8)})
    c.Parent = parent
    return c
end

local function stroke(parent, thickness, transparency, color)
    local s = new("UIStroke", {
        Thickness = thickness or 1,
        Transparency = transparency or 0.5,
        Color = color or Color3.fromRGB(48, 120, 70)
    })
    s.Parent = parent
    return s
end

local function pad(parent, l, r, t, b)
    local p = new("UIPadding", {
        PaddingLeft = UDim.new(0, l or 0),
        PaddingRight = UDim.new(0, r or 0),
        PaddingTop = UDim.new(0, t or 0),
        PaddingBottom = UDim.new(0, b or 0),
    })
    p.Parent = parent
    return p
end

local function tween(obj, info, goal)
    local ti = TweenInfo.new(
        info.Time or 0.2,
        info.Style or Enum.EasingStyle.Quad,
        info.Dir or Enum.EasingDirection.Out
    )
    local tw = TweenService:Create(obj, ti, goal)
    tw:Play()
    return tw
end

local function roundNumber(value, step)
    step = step or 1
    return math.floor((value / step) + 0.5) * step
end

local function makeIcon(parent, image, fallbackText, size, textSize)
    if image and image ~= "" and image ~= "ID" then
        local img = new("ImageLabel", {
            BackgroundTransparency = 1,
            Image = image,
            Size = size or UDim2.fromOffset(16, 16),
            ImageColor3 = Color3.fromRGB(220, 255, 230),
            ScaleType = Enum.ScaleType.Fit
        })
        img.Parent = parent
        return img
    else
        local lbl = new("TextLabel", {
            BackgroundTransparency = 1,
            Text = fallbackText or "",
            TextColor3 = Color3.fromRGB(220, 255, 230),
            Font = Enum.Font.GothamBold,
            TextSize = textSize or 16,
            Size = size or UDim2.fromOffset(16, 16),
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center
        })
        lbl.Parent = parent
        return lbl
    end
end

local function dragify(frame, handle)
    handle = handle or frame
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    handle.InputBegan:Connect(function(input)
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

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            update(input)
        end
    end)
end

function SKUI:CreateWindow(config)
    config = config or {}

    local theme = {
        bg = Color3.fromRGB(8, 12, 9),
        panel = Color3.fromRGB(12, 20, 14),
        panel2 = Color3.fromRGB(16, 28, 18),
        panel3 = Color3.fromRGB(22, 38, 24),
        accent = Color3.fromRGB(32, 180, 88),
        accent2 = Color3.fromRGB(20, 120, 60),
        text = Color3.fromRGB(235, 255, 240),
        muted = Color3.fromRGB(170, 190, 176),
        danger = Color3.fromRGB(220, 70, 70)
    }

    local gui = new("ScreenGui", {
        Name = "NexusUI",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    gui.Parent = CoreGui

    local root = new("Frame", {
        Name = "Root",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.fromOffset(700, 430),
        BackgroundColor3 = theme.bg,
        BorderSizePixel = 0
    })
    root.Parent = gui
    corner(root, 14)
    stroke(root, 1, 0.5, theme.accent2)

    local glow = new("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 0
    })
    glow.Parent = root

    local top = new("Frame", {
        Name = "TopBar",
        BackgroundColor3 = theme.panel,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 48),
        ZIndex = 2
    })
    top.Parent = root
    corner(top, 14)

    local topMask = new("Frame", {
        Name = "Mask",
        BackgroundColor3 = theme.panel,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -14),
        Size = UDim2.new(1, 0, 0, 14),
        ZIndex = 2
    })
    topMask.Parent = top

    local topStroke = stroke(top, 1, 0.55, theme.accent2)

    local titleWrap = new("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(14, 7),
        Size = UDim2.new(0, 280, 0, 34),
        ZIndex = 3
    })
    titleWrap.Parent = top

    local titleIcon = makeIcon(titleWrap, config.Image, "⬢", UDim2.fromOffset(22, 22), 18)
    titleIcon.Position = UDim2.fromOffset(0, 6)

    local title = new("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(28, 0),
        Size = UDim2.new(1, -28, 0, 20),
        Text = config.Title or "Nexus UI",
        TextColor3 = theme.text,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3
    })
    title.Parent = titleWrap

    local author = new("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(28, 18),
        Size = UDim2.new(1, -28, 0, 14),
        Text = config.Author or "by Nexus",
        TextColor3 = theme.muted,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3
    })
    author.Parent = titleWrap

    local searchBox
    if config.SearchBar then
        searchBox = new("Frame", {
            BackgroundColor3 = theme.panel2,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -128, 0.5, 0),
            Size = UDim2.fromOffset(220, 30),
            ZIndex = 3
        })
        searchBox.Parent = top
        corner(searchBox, 10)
        stroke(searchBox, 1, 0.72, theme.accent2)
        pad(searchBox, 10, 10, 0, 0)

        local searchIcon = makeIcon(searchBox, "rbxassetid://0", "⌕", UDim2.fromOffset(14, 14), 16)
        searchIcon.Position = UDim2.fromOffset(0, 8)

        local search = new("TextBox", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(22, 0),
            Size = UDim2.new(1, -22, 1, 0),
            ClearTextOnFocus = false,
            PlaceholderText = "Search tabs...",
            Text = "",
            TextColor3 = theme.text,
            PlaceholderColor3 = Color3.fromRGB(135, 155, 140),
            Font = Enum.Font.Gotham,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 3
        })
        search.Parent = searchBox
        self._searchBox = search
    end

    local closeBtn = new("TextButton", {
        Name = "Close",
        BackgroundColor3 = theme.panel2,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -14, 0.5, 0),
        Size = UDim2.fromOffset(30, 30),
        Text = "",
        AutoButtonColor = false,
        ZIndex = 3
    })
    closeBtn.Parent = top
    corner(closeBtn, 10)
    stroke(closeBtn, 1, 0.7, theme.danger)
    makeIcon(closeBtn, "rbxassetid://0", "×", UDim2.fromOffset(18, 18), 20)

    local minimizeBtn = new("TextButton", {
        Name = "Minimize",
        BackgroundColor3 = theme.panel2,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -50, 0.5, 0),
        Size = UDim2.fromOffset(30, 30),
        Text = "",
        AutoButtonColor = false,
        ZIndex = 3
    })
    minimizeBtn.Parent = top
    corner(minimizeBtn, 10)
    stroke(minimizeBtn, 1, 0.75, theme.accent2)
    makeIcon(minimizeBtn, "rbxassetid://0", "—", UDim2.fromOffset(18, 18), 18)

    local body = new("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 48),
        Size = UDim2.new(1, 0, 1, -48),
        ZIndex = 1
    })
    body.Parent = root

    local left = new("Frame", {
        BackgroundColor3 = theme.panel,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 165, 1, 0),
        ZIndex = 1
    })
    left.Parent = body
    corner(left, 12)
    stroke(left, 1, 0.7, theme.accent2)

    local tabScroll = new("ScrollingFrame", {
        Name = "Tabs",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(10, 10),
        Size = UDim2.new(1, -20, 1, -20),
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = theme.accent,
        ZIndex = 2
    })
    tabScroll.Parent = left

    local tabLayout = new("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    tabLayout.Parent = tabScroll

    local right = new("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 175, 0, 10),
        Size = UDim2.new(1, -185, 1, -20),
        ZIndex = 1
    })
    right.Parent = body

    local pages = new("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 1
    })
    pages.Parent = right

    local modal = new("Frame", {
        Name = "ModalOverlay",
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.35,
        Visible = false,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 50
    })
    modal.Parent = gui

    local popup = new("Frame", {
        Name = "DropdownPopup",
        BackgroundColor3 = theme.panel,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(360, 290),
        Visible = false,
        ZIndex = 51
    })
    popup.Parent = gui
    corner(popup, 14)
    stroke(popup, 1, 0.5, theme.accent2)

    local popupTop = new("Frame", {
        BackgroundColor3 = theme.panel2,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 42),
        ZIndex = 52
    })
    popupTop.Parent = popup
    corner(popupTop, 14)

    local popupMask = new("Frame", {
        BackgroundColor3 = theme.panel2,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -14),
        Size = UDim2.new(1, 0, 0, 14),
        ZIndex = 52
    })
    popupMask.Parent = popupTop

    local popupTitle = new("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(14, 0),
        Size = UDim2.new(1, -50, 1, 0),
        Text = "Dropdown",
        TextColor3 = theme.text,
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 53
    })
    popupTitle.Parent = popupTop

    local popupClose = new("TextButton", {
        BackgroundColor3 = theme.panel3,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.fromOffset(26, 26),
        Text = "",
        AutoButtonColor = false,
        ZIndex = 53
    })
    popupClose.Parent = popupTop
    corner(popupClose, 8)
    makeIcon(popupClose, "rbxassetid://0", "×", UDim2.fromOffset(16, 16), 18)

    local popupScroll = new("ScrollingFrame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(12, 52),
        Size = UDim2.new(1, -24, 1, -64),
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = theme.accent,
        ZIndex = 52
    })
    popupScroll.Parent = popup

    local popupList = new("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    popupList.Parent = popupScroll

    local popupPadding = pad(popupScroll, 2, 2, 2, 2)

    local floatingBtn
    local minimized = false

    local Window = {}
    Window.__index = Window
    Window._tabs = {}
    Window._activeTab = nil
    Window._gui = gui
    Window._root = root
    Window._modal = modal
    Window._popup = popup
    Window._popupScroll = popupScroll
    Window._popupTitle = popupTitle
    Window._floatingBtn = nil
    Window._theme = theme
    Window._destroyed = false

    local function hidePopup()
        modal.Visible = false
        popup.Visible = false
    end

    local function openPopup(title, values, current, onSelect)
        hidePopup()
        popupTitle.Text = title or "Dropdown"

        for _, child in ipairs(popupScroll:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end

        for _, v in ipairs(values or {}) do
            local item = new("TextButton", {
                BackgroundColor3 = theme.panel2,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 34),
                Text = "",
                AutoButtonColor = false,
                ZIndex = 52
            })
            item.Parent = popupScroll
            corner(item, 10)
            stroke(item, 1, 0.8, theme.accent2)

            local label = new("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(12, 0),
                Size = UDim2.new(1, -24, 1, 0),
                Text = tostring(v),
                TextColor3 = (tostring(v) == tostring(current)) and theme.accent or theme.text,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 53
            })
            label.Parent = item

            item.MouseButton1Click:Connect(function()
                if onSelect then
                    onSelect(v)
                end
                hidePopup()
            end)
        end

        modal.Visible = true
        popup.Visible = true
    end

    function Window:Destroy()
        if self._destroyed then return end
        self._destroyed = true
        if floatingBtn then
            floatingBtn:Destroy()
        end
        gui:Destroy()
    end

    function Window:Toggle()
        if self._destroyed then return end
        minimized = not minimized
        root.Visible = not minimized
        if floatingBtn then
            floatingBtn.Visible = minimized
        end
        if minimized then
            hidePopup()
        end
    end

    function Window:CreateMinimizeBtn(cfg)
        cfg = cfg or {}
        floatingBtn = new("TextButton", {
            Name = "FloatingOpen",
            BackgroundColor3 = theme.panel,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.new(1, -24, 1, -24),
            Size = UDim2.fromOffset(110, 38),
            Text = "",
            AutoButtonColor = false,
            Visible = false,
            ZIndex = 100
        })
        floatingBtn.Parent = gui
        corner(floatingBtn, 12)
        stroke(floatingBtn, 1, 0.5, theme.accent2)

        local ico = makeIcon(floatingBtn, cfg.Image, "◎", UDim2.fromOffset(18, 18), 16)
        ico.Position = UDim2.fromOffset(12, 10)

        local lbl = new("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(38, 0),
            Size = UDim2.new(1, -48, 1, 0),
            Text = cfg.Title or "Open UI",
            TextColor3 = theme.text,
            Font = Enum.Font.GothamSemibold,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 101
        })
        lbl.Parent = floatingBtn

        floatingBtn.MouseButton1Click:Connect(function()
            Window:Toggle()
        end)

        dragify(floatingBtn, floatingBtn)

        Window._floatingBtn = floatingBtn
        return floatingBtn
    end

    closeBtn.MouseButton1Click:Connect(function()
        Window:Destroy()
    end)

    minimizeBtn.MouseButton1Click:Connect(function()
        Window:Toggle()
    end)

    popupClose.MouseButton1Click:Connect(hidePopup)
    modal.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            hidePopup()
        end
    end)

    dragify(root, top)

    local function filterTabs(text)
        text = string.lower(text or "")
        for _, tabData in ipairs(Window._tabs) do
            local visible = (text == "") or string.find(string.lower(tabData.Name), text, 1, true) ~= nil
            tabData.Button.Visible = visible
        end
    end

    if Window._searchBox then
        Window._searchBox:GetPropertyChangedSignal("Text"):Connect(function()
            filterTabs(Window._searchBox.Text)
        end)
    end

    local function setActive(tabData)
        for _, t in ipairs(Window._tabs) do
            t.Page.Visible = false
            t.Button.BackgroundColor3 = theme.panel2
            t.ButtonStroke.Transparency = 0.82
            t.ButtonTitle.TextColor3 = theme.text
        end
        tabData.Page.Visible = true
        tabData.Button.BackgroundColor3 = theme.panel3
        tabData.ButtonStroke.Transparency = 0.35
        tabData.ButtonTitle.TextColor3 = theme.accent
        Window._activeTab = tabData
    end

    function Window:CreateTab(tabName)
        local tabData = {}
        tabData.Name = tabName or "Tab"

        local button = new("TextButton", {
            BackgroundColor3 = theme.panel2,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 38),
            Text = "",
            AutoButtonColor = false,
            ZIndex = 2
        })
        button.Parent = tabScroll
        corner(button, 10)
        local buttonStroke = stroke(button, 1, 0.82, theme.accent2)

        local buttonTitle = new("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(12, 0),
            Size = UDim2.new(1, -24, 1, 0),
            Text = tabName or "Tab",
            TextColor3 = theme.text,
            Font = Enum.Font.GothamSemibold,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        buttonTitle.Parent = button

        local page = new("ScrollingFrame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = theme.accent,
            CanvasSize = UDim2.new(),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ZIndex = 1
        })
        page.Parent = pages

        local pageLayout = new("UIListLayout", {
            Padding = UDim.new(0, 12),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        pageLayout.Parent = page

        pad(page, 2, 2, 2, 2)

        button.MouseButton1Click:Connect(function()
            setActive(tabData)
        end)

        tabData.Button = button
        tabData.ButtonTitle = buttonTitle
        tabData.ButtonStroke = buttonStroke
        tabData.Page = page

        function tabData:CreateGroupbox(groupTitle)
            local group = {}
            group.Name = groupTitle or "Groupbox"

            local box = new("Frame", {
                BackgroundColor3 = theme.panel,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                ZIndex = 2
            })
            box.Parent = page
            corner(box, 12)
            stroke(box, 1, 0.75, theme.accent2)

            local head = new("TextLabel", {
                BackgroundColor3 = theme.panel2,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 34),
                Text = groupTitle or "Groupbox",
                TextColor3 = theme.text,
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 3
            })
            head.Parent = box
            corner(head, 12)

            local headMask = new("Frame", {
                BackgroundColor3 = theme.panel2,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 1, -12),
                Size = UDim2.new(1, 0, 0, 12),
                ZIndex = 3
            })
            headMask.Parent = head

            pad(head, 12, 12, 0, 0)

            local content = new("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(10, 44),
                Size = UDim2.new(1, -20, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                ZIndex = 3
            })
            content.Parent = box

            local contentLayout = new("UIListLayout", {
                Padding = UDim.new(0, 10),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
            contentLayout.Parent = content

            local contentPad = pad(content, 0, 0, 0, 0)

            local function makeElementContainer(height)
                local e = new("Frame", {
                    BackgroundColor3 = theme.panel2,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, height or 36),
                    ZIndex = 3
                })
                e.Parent = content
                corner(e, 10)
                stroke(e, 1, 0.82, theme.accent2)
                return e
            end

            function group:CreateButton(opts)
                opts = opts or {}
                local btn = makeElementContainer(36)
                btn.BackgroundColor3 = theme.panel2

                local title = new("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(12, 0),
                    Size = UDim2.new(1, -24, 1, 0),
                    Text = tostring(opts.Title or "Button"),
                    TextColor3 = theme.text,
                    Font = Enum.Font.GothamSemibold,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 4
                })
                title.Parent = btn

                local click = new("TextButton", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = "",
                    ZIndex = 5
                })
                click.Parent = btn

                if opts.Locked then
                    btn.BackgroundTransparency = 0.2
                    title.TextColor3 = theme.muted
                end

                click.MouseButton1Click:Connect(function()
                    if not opts.Locked and opts.Callback then
                        opts.Callback()
                    end
                end)

                return btn
            end

            function group:CreateToggle(opts)
                opts = opts or {}
                local state = opts.Value and true or false

                local boxT = makeElementContainer(42)

                local title = new("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(12, 4),
                    Size = UDim2.new(1, -60, 0, 18),
                    Text = tostring(opts.Title or "Toggle"),
                    TextColor3 = theme.text,
                    Font = Enum.Font.GothamSemibold,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 4
                })
                title.Parent = boxT

                local desc = new("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(12, 20),
                    Size = UDim2.new(1, -60, 0, 14),
                    Text = tostring(opts.Desc or ""),
                    TextColor3 = theme.muted,
                    Font = Enum.Font.Gotham,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 4
                })
                desc.Parent = boxT

                local toggle = new("TextButton", {
                    BackgroundColor3 = state and theme.accent or theme.panel3,
                    BorderSizePixel = 0,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -12, 0.5, 0),
                    Size = UDim2.fromOffset(42, 22),
                    Text = "",
                    AutoButtonColor = false,
                    ZIndex = 4
                })
                toggle.Parent = boxT
                corner(toggle, 999)
                stroke(toggle, 1, 0.75, state and theme.accent or theme.accent2)

                local knob = new("Frame", {
                    BackgroundColor3 = Color3.fromRGB(245, 255, 245),
                    BorderSizePixel = 0,
                    Position = state and UDim2.new(1, -19, 0, 3) or UDim2.new(0, 3, 0, 3),
                    Size = UDim2.fromOffset(16, 16),
                    ZIndex = 5
                })
                knob.Parent = toggle
                corner(knob, 999)

                local function setState(v)
                    state = v and true or false
                    tween(toggle, {Time = 0.15}, {BackgroundColor3 = state and theme.accent or theme.panel3})
                    tween(knob, {Time = 0.15}, {Position = state and UDim2.new(1, -19, 0, 3) or UDim2.new(0, 3, 0, 3)})
                    if opts.Callback then
                        opts.Callback(state)
                    end
                end

                toggle.MouseButton1Click:Connect(function()
                    setState(not state)
                end)

                return {
                    Set = setState,
                    Get = function()
                        return state
                    end
                }
            end

            function group:CreateSlider(opts)
                opts = opts or {}
                local min = tonumber(opts.Value and opts.Value.Min) or 0
                local max = tonumber(opts.Value and opts.Value.Max) or 100
                local value = tonumber(opts.Value and opts.Value.Default) or min
                local step = tonumber(opts.Step) or 1

                local wrap = makeElementContainer(56)

                local title = new("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(12, 4),
                    Size = UDim2.new(1, -24, 0, 18),
                    Text = tostring(opts.Title or "Slider"),
                    TextColor3 = theme.text,
                    Font = Enum.Font.GothamSemibold,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 4
                })
                title.Parent = wrap

                local valLabel = new("TextLabel", {
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, -12, 0, 4),
                    Size = UDim2.fromOffset(80, 18),
                    Text = tostring(value),
                    TextColor3 = theme.muted,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    ZIndex = 4
                })
                valLabel.Parent = wrap

                local bar = new("Frame", {
                    BackgroundColor3 = theme.panel3,
                    BorderSizePixel = 0,
                    Position = UDim2.fromOffset(12, 32),
                    Size = UDim2.new(1, -24, 0, 12),
                    ZIndex = 4
                })
                bar.Parent = wrap
                corner(bar, 999)

                local fill = new("Frame", {
                    BackgroundColor3 = theme.accent,
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, 0, 1, 0),
                    ZIndex = 5
                })
                fill.Parent = bar
                corner(fill, 999)

                local drag = new("TextButton", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = "",
                    ZIndex = 6
                })
                drag.Parent = bar

                local dragging = false

                local function setValue(v)
                    v = math.clamp(roundNumber(v, step), min, max)
                    value = v
                    local alpha = (value - min) / math.max((max - min), 1)
                    fill.Size = UDim2.new(alpha, 0, 1, 0)
                    valLabel.Text = tostring(value)
                    if opts.Callback then
                        opts.Callback(value)
                    end
                end

                task.defer(function()
                    setValue(value)
                end)

                local function updateFromX(x)
                    local absX = bar.AbsolutePosition.X
                    local width = bar.AbsoluteSize.X
                    local alpha = math.clamp((x - absX) / width, 0, 1)
                    local v = min + ((max - min) * alpha)
                    setValue(v)
                end

                drag.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        updateFromX(input.Position.X)
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        updateFromX(input.Position.X)
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)

                return {
                    Set = setValue,
                    Get = function()
                        return value
                    end
                }
            end

            function group:CreateInput(opts)
                opts = opts or {}
                local wrap = makeElementContainer(48)

                local title = new("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(12, 4),
                    Size = UDim2.new(1, -24, 0, 18),
                    Text = tostring(opts.Title or "Input"),
                    TextColor3 = theme.text,
                    Font = Enum.Font.GothamSemibold,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 4
                })
                title.Parent = wrap

                local box = new("TextBox", {
                    BackgroundColor3 = theme.panel3,
                    BorderSizePixel = 0,
                    Position = UDim2.fromOffset(12, 24),
                    Size = UDim2.new(1, -24, 0, 18),
                    Text = tostring(opts.Value or ""),
                    PlaceholderText = tostring(opts.Placeholder or "Type here..."),
                    ClearTextOnFocus = false,
                    TextColor3 = theme.text,
                    PlaceholderColor3 = theme.muted,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 4
                })
                box.Parent = wrap
                corner(box, 8)
                pad(box, 8, 8, 0, 0)

                box.FocusLost:Connect(function(enterPressed)
                    if opts.Callback then
                        opts.Callback(box.Text, enterPressed)
                    end
                end)

                return box
            end

            function group:CreateDropdown(opts)
                opts = opts or {}
                local values = opts.Values or {}
                local selected = opts.Value or values[1] or "None"

                local wrap = makeElementContainer(46)

                local title = new("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(12, 4),
                    Size = UDim2.new(1, -24, 0, 18),
                    Text = tostring(opts.Title or "Dropdown"),
                    TextColor3 = theme.text,
                    Font = Enum.Font.GothamSemibold,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 4
                })
                title.Parent = wrap

                local button = new("TextButton", {
                    BackgroundColor3 = theme.panel3,
                    BorderSizePixel = 0,
                    Position = UDim2.fromOffset(12, 24),
                    Size = UDim2.new(1, -24, 0, 16),
                    Text = "",
                    AutoButtonColor = false,
                    ZIndex = 4
                })
                button.Parent = wrap
                corner(button, 8)
                stroke(button, 1, 0.8, theme.accent2)

                local selectedLabel = new("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(8, 0),
                    Size = UDim2.new(1, -34, 1, 0),
                    Text = tostring(selected),
                    TextColor3 = theme.text,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 5
                })
                selectedLabel.Parent = button

                local arrow = new("TextLabel", {
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, -8, 0, 0),
                    Size = UDim2.fromOffset(14, 16),
                    Text = "▾",
                    TextColor3 = theme.muted,
                    Font = Enum.Font.GothamBold,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    ZIndex = 5
                })
                arrow.Parent = button

                local function setSelected(v)
                    selected = v
                    selectedLabel.Text = tostring(v)
                    if opts.Callback then
                        opts.Callback(v)
                    end
                end

                button.MouseButton1Click:Connect(function()
                    openPopup(tostring(opts.Title or "Dropdown"), values, selected, setSelected)
                end)

                local api = {}
                function api:Refresh(newValues)
                    values = newValues or {}
                    if #values > 0 then
                        if not table.find(values, selected) then
                            setSelected(values[1])
                        end
                    end
                end
                function api:Set(v)
                    if v ~= nil then
                        setSelected(v)
                    end
                end
                function api:Get()
                    return selected
                end

                return api
            end

            return group
        end

        table.insert(Window._tabs, tabData)

        if #Window._tabs == 1 then
            setActive(tabData)
        end

        return tabData
    end

    function Window:SetVisible(state)
        root.Visible = state and true or false
        if floatingBtn then
            floatingBtn.Visible = not state
        end
    end

    function Window:GetRoot()
        return root
    end

    setmetatable(Window, self)
    return Window
end

return SKUI
