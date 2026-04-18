--[[
    ╔══════════════════════════════════════════════════╗
    ║           SCRIPT HUB UI LIBRARY                  ║
    ║           Version 1.0.0                          ║
    ║           Made for Roblox                        ║
    ╚══════════════════════════════════════════════════╝

    USAGE:
    ────────────────────────────────────────────────────

    local UI = loadstring(game:HttpGet("YOUR_RAW_URL"))()

    local Window = UI:CreateWindow({
        Title = "My Super Hub",
        Author = "by .ftgs and .ftgs",
    })

    local MinimizeBtn = Window:CreateMinimizeBtn({
        Name = "Open UI",
        Color = "Red",
    })

    local Tab = Window:Tab({
        Title = "Tab Title",
        Locked = false,
    })

    local Button = Tab:Button({
        Title = "Button",
        Desc = "Test Button",
        Locked = false,
        Callback = function() end
    })

    local Dropdown = Tab:Dropdown({
        Title = "Dropdown",
        Desc = "Dropdown Description",
        Values = { "Category A", "Category B", "Category C" },
        Value = "Category A",
        Callback = function(option) print(option) end
    })

    local Toggle = Tab:Toggle({
        Title = "Toggle",
        Desc = "Toggle Description",
        Value = false,
        Callback = function(state) print(tostring(state)) end
    })

    local Slider = Tab:Slider({
        Title = "Slider",
        Desc = "Slider Description",
        Step = 1,
        Value = { Min = 20, Max = 120, Default = 70 },
        Callback = function(value) print(value) end
    })

    local Input = Tab:Input({
        Title = "Input",
        Desc = "Input Description",
        Value = "Default value",
        Type = "Input",
        Placeholder = "Enter text...",
        Callback = function(input) print(input) end
    })

    ────────────────────────────────────────────────────
--]]

-- ─────────────────────────────────────────────────────────────────────────────
--  SERVICES
-- ─────────────────────────────────────────────────────────────────────────────
local Players            = game:GetService("Players")
local UserInputService   = game:GetService("UserInputService")
local TweenService       = game:GetService("TweenService")
local RunService         = game:GetService("RunService")

local LocalPlayer        = Players.LocalPlayer
local Mouse              = LocalPlayer:GetMouse()

-- ─────────────────────────────────────────────────────────────────────────────
--  THEME
-- ─────────────────────────────────────────────────────────────────────────────
local Theme = {
    Background      = Color3.fromRGB(15,  15,  20),
    Surface         = Color3.fromRGB(22,  22,  30),
    SurfaceHover    = Color3.fromRGB(30,  30,  42),
    Border          = Color3.fromRGB(45,  45,  60),
    Accent          = Color3.fromRGB(100, 80,  255),
    AccentHover     = Color3.fromRGB(120, 100, 255),
    AccentDim       = Color3.fromRGB(50,  40,  120),
    TextPrimary     = Color3.fromRGB(240, 240, 255),
    TextSecondary   = Color3.fromRGB(140, 140, 165),
    TextDisabled    = Color3.fromRGB(80,  80,  100),
    Success         = Color3.fromRGB(60,  200, 120),
    Danger          = Color3.fromRGB(220, 60,  80),
    Warning         = Color3.fromRGB(255, 180, 50),
    Slider          = Color3.fromRGB(100, 80,  255),
    SliderBg        = Color3.fromRGB(35,  35,  50),
    TabActive       = Color3.fromRGB(100, 80,  255),
    TabInactive     = Color3.fromRGB(28,  28,  38),
    ScrollBar       = Color3.fromRGB(60,  60,  85),
    ToggleOn        = Color3.fromRGB(100, 80,  255),
    ToggleOff       = Color3.fromRGB(50,  50,  70),
    Shadow          = Color3.fromRGB(0,   0,   0),
}

local MinColors = {
    Red    = Color3.fromRGB(220, 60,  80),
    Blue   = Color3.fromRGB(60,  120, 220),
    Green  = Color3.fromRGB(60,  200, 120),
    Purple = Color3.fromRGB(100, 80,  255),
    Orange = Color3.fromRGB(255, 140, 60),
    White  = Color3.fromRGB(240, 240, 255),
    Cyan   = Color3.fromRGB(60,  200, 220),
}

-- ─────────────────────────────────────────────────────────────────────────────
--  UTILITY HELPERS
-- ─────────────────────────────────────────────────────────────────────────────
local function Create(class, props, children)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then obj[k] = v end
    end
    for _, child in ipairs(children or {}) do
        child.Parent = obj
    end
    if props and props.Parent then obj.Parent = props.Parent end
    return obj
end

local function Tween(obj, info, goals)
    TweenService:Create(obj, info, goals):Play()
end

local function MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = input.Position
            startPos  = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

local function RoundedFrame(props)
    local frame = Create("Frame", props)
    Create("UICorner", { CornerRadius = UDim.new(0, props._Radius or 8), Parent = frame })
    return frame
end

-- ─────────────────────────────────────────────────────────────────────────────
--  LIBRARY TABLE
-- ─────────────────────────────────────────────────────────────────────────────
local Library = {}
Library.__index = Library

-- ─────────────────────────────────────────────────────────────────────────────
--  CreateWindow
-- ─────────────────────────────────────────────────────────────────────────────
function Library:CreateWindow(config)
    config = config or {}
    local title  = config.Title  or "Script Hub"
    local author = config.Author or ""

    -- ── ScreenGui ────────────────────────────────────────────────────────────
    local ScreenGui = Create("ScreenGui", {
        Name             = "ScriptHubUI",
        ResetOnSpawn     = false,
        ZIndexBehavior   = Enum.ZIndexBehavior.Sibling,
        DisplayOrder     = 100,
    })

    -- Try to parent to CoreGui (exploit), else PlayerGui
    pcall(function()
        ScreenGui.Parent = game:GetService("CoreGui")
    end)
    if not ScreenGui.Parent then
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    -- ── Overlay blur backdrop ─────────────────────────────────────────────────
    local DropdownOverlay = Create("Frame", {
        Name            = "DropdownOverlay",
        Size            = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        ZIndex          = 50,
        Visible         = false,
        Parent          = ScreenGui,
    })

    -- ── Main Window ───────────────────────────────────────────────────────────
    local MainWindow = Create("Frame", {
        Name            = "MainWindow",
        Size            = UDim2.new(0, 560, 0, 350),
        Position        = UDim2.new(0.5, -290, 0.5, -210),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex          = 10,
        Parent          = ScreenGui,
    })
    Create("UICorner",  { CornerRadius = UDim.new(0, 12), Parent = MainWindow })
    -- outer glow
    Create("UIStroke",  { Color = Theme.Border, Thickness = 1, Parent = MainWindow })

    -- ── Title Bar ─────────────────────────────────────────────────────────────
    local TitleBar = Create("Frame", {
        Name            = "TitleBar",
        Size            = UDim2.new(1, 0, 0, 48),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        ZIndex          = 11,
        Parent          = MainWindow,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = TitleBar })
    -- bottom square corners on the bar
    Create("Frame", {
        Size  = UDim2.new(1, 0, 0.5, 0),
        Position = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        ZIndex = 10,
        Parent = TitleBar,
    })

    -- Accent left strip
    Create("Frame", {
        Size  = UDim2.new(0, 3, 0, 28),
        Position = UDim2.new(0, 14, 0.5, -14),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        ZIndex = 12,
        Parent = TitleBar,
    })

    -- Title
    Create("TextLabel", {
        Text      = title,
        Font      = Enum.Font.GothamBold,
        TextSize  = 16,
        TextColor3 = Theme.TextPrimary,
        BackgroundTransparency = 1,
        Position  = UDim2.new(0, 26, 0, 0),
        Size      = UDim2.new(0, 300, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex    = 12,
        Parent    = TitleBar,
    })

    -- ── Draggable (TitleBar is the drag handle) ───────────────────────────────
    MakeDraggable(MainWindow, TitleBar)

    -- Author
    if author ~= "" then
        Create("TextLabel", {
            Text      = author,
            Font      = Enum.Font.Gotham,
            TextSize  = 11,
            TextColor3 = Theme.Accent,
            BackgroundTransparency = 1,
            Position  = UDim2.new(0, 26, 0, 28),
            Size      = UDim2.new(0, 300, 0, 14),
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex    = 12,
            Parent    = TitleBar,
        })
    end

    -- Close button (X)
    local CloseBtn = Create("TextButton", {
        Text      = "Close",
        Font      = Enum.Font.GothamBold,
        TextSize  = 14,
        TextColor3 = Theme.TextSecondary,
        BackgroundColor3 = Color3.fromRGB(200, 50, 60),
        BackgroundTransparency = 0.7,
        Size      = UDim2.new(0, 28, 0, 28),
        Position  = UDim2.new(1, -40, 0.5, -14),
        ZIndex    = 13,
        Parent    = TitleBar,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = CloseBtn })

    CloseBtn.MouseEnter:Connect(function()
        Tween(CloseBtn, TweenInfo.new(0.15), { BackgroundTransparency = 0, TextColor3 = Theme.TextPrimary })
    end)
    CloseBtn.MouseLeave:Connect(function()
        Tween(CloseBtn, TweenInfo.new(0.15), { BackgroundTransparency = 0.7, TextColor3 = Theme.TextSecondary })
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        -- Animate window shrink
        Tween(MainWindow, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 580, 0, 0),
        })
        -- Animate MinimizeBtn shrink/fade if it exists
        if Window._floatFrame and Window._floatFrame.Parent then
            Tween(Window._floatFrame, TweenInfo.new(0.2), {
                Size = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1,
            })
        end
        -- After animation: destroy ScreenGui (kills Window + all modals) and float btn
        task.delay(0.3, function()
            if ScreenGui and ScreenGui.Parent then
                ScreenGui:Destroy()
            end
            if Window._floatFrame and Window._floatFrame.Parent then
                Window._floatFrame:Destroy()
            end
        end)
    end)

    -- ── Tab Bar ───────────────────────────────────────────────────────────────
    local TabBar = Create("Frame", {
        Name            = "TabBar",
        Size            = UDim2.new(0, 140, 1, -48),
        Position        = UDim2.new(0, 0, 0, 48),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        ZIndex          = 11,
        Parent          = MainWindow,
    })

    -- scrollable tab list
    local TabScroll = Create("ScrollingFrame", {
        Size            = UDim2.new(1, 0, 1, -10),
        Position        = UDim2.new(0, 0, 0, 8),
        BackgroundTransparency = 1,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.ScrollBar,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        CanvasSize      = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        BorderSizePixel = 0,
        ZIndex          = 12,
        Parent          = TabBar,
    })
    Create("UIListLayout", {
        FillDirection  = Enum.FillDirection.Vertical,
        SortOrder      = Enum.SortOrder.LayoutOrder,
        Padding        = UDim.new(0, 4),
        Parent         = TabScroll,
    })
    Create("UIPadding", { PaddingLeft = UDim.new(0,8), PaddingRight = UDim.new(0,8), Parent = TabScroll })

    -- ── Content Area ──────────────────────────────────────────────────────────
    local ContentArea = Create("Frame", {
        Name            = "ContentArea",
        Size            = UDim2.new(1, -148, 1, -56),
        Position        = UDim2.new(0, 148, 0, 56),
        BackgroundTransparency = 1,
        ZIndex          = 11,
        Parent          = MainWindow,
    })

    -- ── Separator line ────────────────────────────────────────────────────────
    Create("Frame", {
        Size  = UDim2.new(0, 1, 1, -48),
        Position = UDim2.new(0, 140, 0, 48),
        BackgroundColor3 = Theme.Border,
        BorderSizePixel = 0,
        ZIndex = 12,
        Parent = MainWindow,
    })

    -- ─────────────────────────────────────────────────────────────────────────
    --  WINDOW OBJECT
    -- ─────────────────────────────────────────────────────────────────────────
    local Window = {}
    Window._gui          = ScreenGui
    Window._main         = MainWindow
    Window._tabBar       = TabScroll
    Window._contentArea  = ContentArea
    Window._overlay      = DropdownOverlay
    Window._tabs         = {}
    Window._activeTab    = nil
    Window._floatFrame   = nil  -- set by CreateMinimizeBtn

    -- ── CreateMinimizeBtn ─────────────────────────────────────────────────────
    function Window:CreateMinimizeBtn(cfg)
        cfg = cfg or {}
        local btnName  = cfg.Name  or "Open UI"
        local btnColor = MinColors[cfg.Color] or Theme.Accent

        local FloatFrame = Create("Frame", {
            Name = "FloatFrame",
            Size = UDim2.new(0, 110, 0, 34),
            Position = UDim2.new(0, 20, 1, -54),
            BackgroundColor3 = btnColor,
            BorderSizePixel = 0,
            ZIndex = 20,
            Parent = ScreenGui,
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 17), Parent = FloatFrame })
        Create("UIStroke", { Color = Color3.fromRGB(255,255,255), Thickness = 1, Transparency = 0.7, Parent = FloatFrame })

        -- Register so CloseBtn can destroy it
        self._floatFrame = FloatFrame

        -- Draggable: drag the frame itself, but only when NOT clicking the button
        MakeDraggable(FloatFrame, FloatFrame)

        local BtnLabel = Create("TextLabel", {
            Text      = "◉  " .. btnName,
            Font      = Enum.Font.GothamBold,
            TextSize  = 12,
            TextColor3 = Color3.fromRGB(255,255,255),
            BackgroundTransparency = 1,
            Size      = UDim2.fromScale(1,1),
            TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex    = 21,
            Parent    = FloatFrame,
        })

        local isOpen = true

        local function toggleUI()
            isOpen = not isOpen
            MainWindow.Visible = isOpen
            if isOpen then
                BtnLabel.Text = "◉  " .. btnName
                Tween(FloatFrame, TweenInfo.new(0.2), { BackgroundColor3 = btnColor })
                MainWindow.Size = UDim2.new(0, 580, 0, 0)
                Tween(MainWindow, TweenInfo.new(0.3, Enum.EasingStyle.Back), { Size = UDim2.new(0, 580, 0, 420) })
            else
                BtnLabel.Text = "⊙  " .. btnName
                Tween(FloatFrame, TweenInfo.new(0.2), { BackgroundColor3 = Theme.Surface })
                Tween(MainWindow, TweenInfo.new(0.25), { Size = UDim2.new(0, 580, 0, 0) })
                task.delay(0.25, function() if not isOpen then MainWindow.Visible = false end end)
            end
        end

        -- click button
        local ClickRegion = Create("TextButton", {
            Text = "",
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1,1),
            ZIndex = 22,
            Parent = FloatFrame,
        })
        ClickRegion.MouseButton1Click:Connect(toggleUI)

        ClickRegion.MouseEnter:Connect(function()
            Tween(FloatFrame, TweenInfo.new(0.15), { Size = UDim2.new(0, 116, 0, 36) })
        end)
        ClickRegion.MouseLeave:Connect(function()
            Tween(FloatFrame, TweenInfo.new(0.15), { Size = UDim2.new(0, 110, 0, 34) })
        end)

        return FloatFrame
    end

    -- ── Tab ───────────────────────────────────────────────────────────────────
    function Window:Tab(cfg)
        cfg = cfg or {}
        local tabTitle  = cfg.Title  or "Tab"
        local tabLocked = cfg.Locked or false

        -- Tab button
        local TabBtn = Create("TextButton", {
            Text            = tabTitle,
            Font            = Enum.Font.GothamSemibold,
            TextSize        = 13,
            TextColor3      = Theme.TextSecondary,
            BackgroundColor3 = Theme.TabInactive,
            Size            = UDim2.new(1, 0, 0, 36),
            BorderSizePixel = 0,
            ZIndex          = 13,
            Parent          = self._tabBar,
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = TabBtn })

        -- Tab content panel (scrollable)
        local TabPanel = Create("ScrollingFrame", {
            Name            = "TabPanel_" .. tabTitle,
            Size            = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Theme.ScrollBar,
            ScrollingDirection = Enum.ScrollingDirection.Y,
            CanvasSize      = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            BorderSizePixel = 0,
            Visible         = false,
            ZIndex          = 12,
            Parent          = self._contentArea,
        })
        Create("UIListLayout", {
            FillDirection  = Enum.FillDirection.Vertical,
            SortOrder      = Enum.SortOrder.LayoutOrder,
            Padding        = UDim.new(0, 6),
            Parent         = TabPanel,
        })
        Create("UIPadding", {
            PaddingTop    = UDim.new(0,8),
            PaddingLeft   = UDim.new(0,8),
            PaddingRight  = UDim.new(0,12),
            PaddingBottom = UDim.new(0,8),
            Parent        = TabPanel,
        })

        local tabObj = {
            _btn   = TabBtn,
            _panel = TabPanel,
            _order = 0,
            _win   = self,
        }

        -- activate / deactivate
        local function activate()
            if tabLocked then return end
            -- hide all
            for _, t in ipairs(self._tabs) do
                t._panel.Visible = false
                Tween(t._btn, TweenInfo.new(0.15), {
                    BackgroundColor3 = Theme.TabInactive,
                    TextColor3       = Theme.TextSecondary,
                })
            end
            TabPanel.Visible = true
            Tween(TabBtn, TweenInfo.new(0.15), {
                BackgroundColor3 = Theme.TabActive,
                TextColor3       = Theme.TextPrimary,
            })
            self._activeTab = tabObj
        end

        TabBtn.MouseButton1Click:Connect(activate)
        TabBtn.MouseEnter:Connect(function()
            if self._activeTab ~= tabObj then
                Tween(TabBtn, TweenInfo.new(0.1), { BackgroundColor3 = Theme.SurfaceHover })
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if self._activeTab ~= tabObj then
                Tween(TabBtn, TweenInfo.new(0.1), { BackgroundColor3 = Theme.TabInactive })
            end
        end)

        table.insert(self._tabs, tabObj)
        if #self._tabs == 1 then activate() end

        -- ── ELEMENT FACTORY ───────────────────────────────────────────────────
        local function nextOrder()
            tabObj._order = tabObj._order + 1
            return tabObj._order
        end

        local function BaseCard(height)
            local card = Create("Frame", {
                Size            = UDim2.new(1, 0, 0, height or 58),
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                LayoutOrder     = nextOrder(),
                ZIndex          = 13,
                Parent          = TabPanel,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = card })
            return card
        end

        local function LabelPair(parent, titleTxt, descTxt)
            Create("TextLabel", {
                Text      = titleTxt,
                Font      = Enum.Font.GothamSemibold,
                TextSize  = 13,
                TextColor3 = Theme.TextPrimary,
                BackgroundTransparency = 1,
                Position  = UDim2.new(0, 12, 0, 8),
                Size      = UDim2.new(0.6, 0, 0, 18),
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex    = 14,
                Parent    = parent,
            })
            if descTxt and descTxt ~= "" then
                Create("TextLabel", {
                    Text      = descTxt,
                    Font      = Enum.Font.Gotham,
                    TextSize  = 10,
                    TextColor3 = Theme.TextSecondary,
                    BackgroundTransparency = 1,
                    Position  = UDim2.new(0, 12, 0, 28),
                    Size      = UDim2.new(0.7, 0, 0, 14),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex    = 14,
                    Parent    = parent,
                })
            end
        end

        -- ── Button ────────────────────────────────────────────────────────────
        function tabObj:Button(opts)
            opts = opts or {}
            if opts.Locked then return end

            local card = BaseCard(52)
            LabelPair(card, opts.Title or "Button", opts.Desc)

            local Btn = Create("TextButton", {
                Text      = "Run",
                Font      = Enum.Font.GothamBold,
                TextSize  = 12,
                TextColor3 = Color3.fromRGB(255,255,255),
                BackgroundColor3 = Theme.Accent,
                Size      = UDim2.new(0, 64, 0, 28),
                Position  = UDim2.new(1, -76, 0.5, -14),
                ZIndex    = 15,
                Parent    = card,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Btn })

            Btn.MouseEnter:Connect(function()
                Tween(Btn, TweenInfo.new(0.1), { BackgroundColor3 = Theme.AccentHover })
            end)
            Btn.MouseLeave:Connect(function()
                Tween(Btn, TweenInfo.new(0.1), { BackgroundColor3 = Theme.Accent })
            end)
            Btn.MouseButton1Click:Connect(function()
                Tween(Btn, TweenInfo.new(0.05), { BackgroundColor3 = Theme.AccentDim })
                task.delay(0.1, function()
                    Tween(Btn, TweenInfo.new(0.1), { BackgroundColor3 = Theme.AccentHover })
                end)
                if opts.Callback then
                    task.spawn(opts.Callback)
                end
            end)
            return Btn
        end

        -- ── Toggle ────────────────────────────────────────────────────────────
        function tabObj:Toggle(opts)
            opts = opts or {}
            local state = opts.Value or false

            local card = BaseCard(52)
            LabelPair(card, opts.Title or "Toggle", opts.Desc)

            local Track = Create("Frame", {
                Size      = UDim2.new(0, 48, 0, 26),
                Position  = UDim2.new(1, -64, 0.5, -13),
                BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff,
                ZIndex    = 15,
                Parent    = card,
            })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Track })

            local Knob = Create("Frame", {
                Size      = UDim2.new(0, 20, 0, 20),
                Position  = state and UDim2.new(0, 25, 0.5, -10) or UDim2.new(0, 3, 0.5, -10),
                BackgroundColor3 = Color3.fromRGB(255,255,255),
                ZIndex    = 16,
                Parent    = Track,
            })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Knob })

            local ClickArea = Create("TextButton", {
                Text      = "",
                BackgroundTransparency = 1,
                Size      = UDim2.fromScale(1,1),
                ZIndex    = 17,
                Parent    = Track,
            })

            local function setToggle(val)
                state = val
                Tween(Track, TweenInfo.new(0.2), { BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff })
                Tween(Knob,  TweenInfo.new(0.2, Enum.EasingStyle.Back), {
                    Position = state and UDim2.new(0, 25, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
                })
                if opts.Callback then task.spawn(opts.Callback, state) end
            end

            ClickArea.MouseButton1Click:Connect(function() setToggle(not state) end)

            return { SetValue = setToggle, GetValue = function() return state end }
        end

        -- ── Slider ────────────────────────────────────────────────────────────
        function tabObj:Slider(opts)
            opts = opts or {}
            local vOpts  = opts.Value or { Min = 0, Max = 100, Default = 50 }
            local min    = vOpts.Min     or 0
            local max    = vOpts.Max     or 100
            local default = vOpts.Default or min
            local step   = opts.Step    or 1
            local cur    = default

            local card = BaseCard(64)
            LabelPair(card, opts.Title or "Slider", opts.Desc)

            local ValLabel = Create("TextLabel", {
                Text      = tostring(cur),
                Font      = Enum.Font.GothamBold,
                TextSize  = 12,
                TextColor3 = Theme.Accent,
                BackgroundTransparency = 1,
                Position  = UDim2.new(1, -52, 0, 6),
                Size      = UDim2.new(0, 44, 0, 18),
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex    = 15,
                Parent    = card,
            })

            local Track = Create("Frame", {
                Size      = UDim2.new(1, -24, 0, 6),
                Position  = UDim2.new(0, 12, 0, 44),
                BackgroundColor3 = Theme.SliderBg,
                ZIndex    = 15,
                Parent    = card,
            })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Track })

            local Fill = Create("Frame", {
                Size      = UDim2.new((cur - min) / (max - min), 0, 1, 0),
                BackgroundColor3 = Theme.Slider,
                ZIndex    = 16,
                Parent    = Track,
            })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Fill })

            local Handle = Create("Frame", {
                Size      = UDim2.new(0, 14, 0, 14),
                Position  = UDim2.new((cur - min) / (max - min), -7, 0.5, -7),
                BackgroundColor3 = Color3.fromRGB(255,255,255),
                ZIndex    = 17,
                Parent    = Track,
            })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Handle })

            local ClickArea = Create("TextButton", {
                Text = "", BackgroundTransparency = 1,
                Size = UDim2.fromScale(1,1), ZIndex = 18, Parent = Track,
            })

            local function setValue(v)
                v = math.clamp(v, min, max)
                if step ~= 0 then
                    v = math.round(v / step) * step
                end
                cur = v
                local pct = (cur - min) / (max - min)
                Tween(Fill,   TweenInfo.new(0.05), { Size     = UDim2.new(pct, 0, 1, 0) })
                Tween(Handle, TweenInfo.new(0.05), { Position = UDim2.new(pct, -7, 0.5, -7) })
                ValLabel.Text = tostring(math.round(cur * 100) / 100)
                if opts.Callback then task.spawn(opts.Callback, cur) end
            end

            local sliding = false
            ClickArea.MouseButton1Down:Connect(function()
                sliding = true
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = false
                end
            end)
            RunService.Heartbeat:Connect(function()
                if sliding then
                    local abs = Track.AbsolutePosition
                    local sz  = Track.AbsoluteSize
                    local rel = math.clamp((Mouse.X - abs.X) / sz.X, 0, 1)
                    setValue(min + rel * (max - min))
                end
            end)

            return { SetValue = setValue, GetValue = function() return cur end }
        end

        -- ── Dropdown ──────────────────────────────────────────────────────────
        -- Opens a MODAL square popup in the centre of the screen with scroll.
        function tabObj:Dropdown(opts)
            opts = opts or {}
            local values   = opts.Values or {}
            local current  = opts.Value  or (values[1] or "Select")
            local win      = self._win

            local card = BaseCard(52)
            LabelPair(card, opts.Title or "Dropdown", opts.Desc)

            -- current-value chip
            local ChipBg = Create("Frame", {
                Size      = UDim2.new(0, 130, 0, 30),
                Position  = UDim2.new(1, -142, 0.5, -15),
                BackgroundColor3 = Theme.AccentDim,
                ZIndex    = 15,
                Parent    = card,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = ChipBg })
            Create("UIStroke", { Color = Theme.Accent, Thickness = 1, Parent = ChipBg })

            local ChipLabel = Create("TextLabel", {
                Text      = current,
                Font      = Enum.Font.GothamSemibold,
                TextSize  = 12,
                TextColor3 = Theme.TextPrimary,
                BackgroundTransparency = 1,
                Size      = UDim2.new(1, -28, 1, 0),
                Position  = UDim2.new(0, 8, 0, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex    = 16,
                Parent    = ChipBg,
            })
            Create("TextLabel", {
                Text      = "▾",
                Font      = Enum.Font.GothamBold,
                TextSize  = 14,
                TextColor3 = Theme.Accent,
                BackgroundTransparency = 1,
                Size      = UDim2.new(0, 20, 1, 0),
                Position  = UDim2.new(1, -22, 0, 0),
                ZIndex    = 16,
                Parent    = ChipBg,
            })

            -- ── Popup Modal ──────────────────────────────────────────────────
            local ModalBg = Create("Frame", {
                Name      = "DropModal",
                Size      = UDim2.new(0, 260, 0, 300),
                Position  = UDim2.new(0.5, -130, 0.5, -150),
                BackgroundColor3 = Theme.Background,
                BorderSizePixel = 0,
                ZIndex    = 55,
                Visible   = false,
                Parent    = win._gui,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = ModalBg })
            Create("UIStroke", { Color = Theme.Accent, Thickness = 1.5, Parent = ModalBg })

            -- header
            local ModalHeader = Create("Frame", {
                Size      = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                ZIndex    = 56,
                Parent    = ModalBg,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = ModalHeader })
            Create("Frame", {
                Size = UDim2.new(1,0,0.5,0), Position = UDim2.new(0,0,0.5,0),
                BackgroundColor3 = Theme.Surface, BorderSizePixel=0, ZIndex=55, Parent=ModalHeader
            })
            Create("TextLabel", {
                Text      = opts.Title or "Select",
                Font      = Enum.Font.GothamBold,
                TextSize  = 13,
                TextColor3 = Theme.TextPrimary,
                BackgroundTransparency = 1,
                Size      = UDim2.new(1, -40, 1, 0),
                Position  = UDim2.new(0, 14, 0, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex    = 57,
                Parent    = ModalHeader,
            })

            local ModalClose = Create("TextButton", {
                Text      = "✕",
                Font      = Enum.Font.GothamBold,
                TextSize  = 12,
                TextColor3 = Theme.TextSecondary,
                BackgroundColor3 = Theme.Surface,
                Size      = UDim2.new(0, 26, 0, 26),
                Position  = UDim2.new(1, -34, 0.5, -13),
                ZIndex    = 57,
                Parent    = ModalHeader,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = ModalClose })

            -- scrollable list
            local ModalScroll = Create("ScrollingFrame", {
                Size      = UDim2.new(1, -16, 1, -52),
                Position  = UDim2.new(0, 8, 0, 46),
                BackgroundTransparency = 1,
                ScrollBarThickness = 4,
                ScrollBarImageColor3 = Theme.ScrollBar,
                ScrollingDirection = Enum.ScrollingDirection.Y,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                BorderSizePixel = 0,
                ZIndex    = 56,
                Parent    = ModalBg,
            })
            Create("UIListLayout", {
                FillDirection = Enum.FillDirection.Vertical,
                SortOrder     = Enum.SortOrder.LayoutOrder,
                Padding       = UDim.new(0, 4),
                Parent        = ModalScroll,
            })
            Create("UIPadding", { PaddingTop = UDim.new(0,4), PaddingBottom = UDim.new(0,4), Parent = ModalScroll })

            local function closeModal()
                Tween(ModalBg, TweenInfo.new(0.15), { Size = UDim2.new(0, 260, 0, 0), Position = UDim2.new(0.5,-130,0.5,0) })
                task.delay(0.15, function()
                    ModalBg.Visible = false
                    win._overlay.Visible = false
                    ModalBg.Size     = UDim2.new(0, 260, 0, 300)
                    ModalBg.Position = UDim2.new(0.5, -130, 0.5, -150)
                end)
            end

            -- populate items
            for i, val in ipairs(values) do
                local Item = Create("TextButton", {
                    Text            = val,
                    Font            = Enum.Font.GothamSemibold,
                    TextSize        = 13,
                    TextColor3      = (val == current) and Theme.TextPrimary or Theme.TextSecondary,
                    BackgroundColor3 = (val == current) and Theme.AccentDim or Theme.Surface,
                    Size            = UDim2.new(1, 0, 0, 38),
                    BorderSizePixel = 0,
                    LayoutOrder     = i,
                    ZIndex          = 57,
                    Parent          = ModalScroll,
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 7), Parent = Item })

                Item.MouseEnter:Connect(function()
                    if val ~= current then
                        Tween(Item, TweenInfo.new(0.1), { BackgroundColor3 = Theme.SurfaceHover })
                    end
                end)
                Item.MouseLeave:Connect(function()
                    if val ~= current then
                        Tween(Item, TweenInfo.new(0.1), { BackgroundColor3 = Theme.Surface })
                    end
                end)
                Item.MouseButton1Click:Connect(function()
                    current      = val
                    ChipLabel.Text = val
                    -- reset all
                    for _, child in ipairs(ModalScroll:GetChildren()) do
                        if child:IsA("TextButton") then
                            child.TextColor3      = Theme.TextSecondary
                            child.BackgroundColor3 = Theme.Surface
                        end
                    end
                    Item.TextColor3       = Theme.TextPrimary
                    Item.BackgroundColor3 = Theme.AccentDim
                    closeModal()
                    if opts.Callback then task.spawn(opts.Callback, val) end
                end)
            end

            ModalClose.MouseButton1Click:Connect(closeModal)
            win._overlay.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    closeModal()
                end
            end)

            -- open button
            local OpenBtn = Create("TextButton", {
                Text = "", BackgroundTransparency = 1,
                Size = UDim2.fromScale(1,1), ZIndex = 17, Parent = ChipBg,
            })
            OpenBtn.MouseButton1Click:Connect(function()
                win._overlay.Visible = true
                ModalBg.Visible = true
                ModalBg.Size     = UDim2.new(0, 260, 0, 0)
                ModalBg.Position = UDim2.new(0.5,-130,0.5,0)
                Tween(ModalBg, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
                    Size     = UDim2.new(0, 260, 0, 300),
                    Position = UDim2.new(0.5, -130, 0.5, -150),
                })
            end)

            return { GetValue = function() return current end }
        end

        -- ── Input ─────────────────────────────────────────────────────────────
        function tabObj:Input(opts)
            opts = opts or {}
            local isTextarea = (opts.Type == "Textarea")
            local h = isTextarea and 88 or 60

            local card = BaseCard(h)
            LabelPair(card, opts.Title or "Input", opts.Desc)

            local InputBox = Create("TextBox", {
                Text                    = opts.Value or "",
                PlaceholderText         = opts.Placeholder or "Enter text...",
                Font                    = Enum.Font.Gotham,
                TextSize                = 12,
                TextColor3              = Theme.TextPrimary,
                PlaceholderColor3       = Theme.TextDisabled,
                BackgroundColor3        = Theme.SliderBg,
                BorderSizePixel         = 0,
                ClearTextOnFocus        = false,
                MultiLine               = isTextarea,
                TextWrapped             = isTextarea,
                TextXAlignment          = Enum.TextXAlignment.Left,
                Size                    = isTextarea and UDim2.new(1, -24, 0, 52) or UDim2.new(1, -24, 0, 28),
                Position                = isTextarea and UDim2.new(0, 12, 0, 30) or UDim2.new(0, 12, 1, -36),
                ZIndex                  = 15,
                Parent                  = card,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = InputBox })
            Create("UIPadding", { PaddingLeft = UDim.new(0,8), PaddingRight = UDim.new(0,8), Parent = InputBox })
            Create("UIStroke", { Color = Theme.Border, Thickness = 1, Parent = InputBox })

            InputBox.Focused:Connect(function()
                Tween(InputBox, TweenInfo.new(0.15), { })
                TweenService:Create(InputBox, TweenInfo.new(0.15), {}):Play()
                -- highlight border via stroke
                for _, c in ipairs(InputBox:GetChildren()) do
                    if c:IsA("UIStroke") then
                        Tween(c, TweenInfo.new(0.15), { Color = Theme.Accent })
                    end
                end
            end)
            InputBox.FocusLost:Connect(function(enter)
                for _, c in ipairs(InputBox:GetChildren()) do
                    if c:IsA("UIStroke") then
                        Tween(c, TweenInfo.new(0.15), { Color = Theme.Border })
                    end
                end
                if opts.Callback then task.spawn(opts.Callback, InputBox.Text) end
            end)

            return { GetValue = function() return InputBox.Text end, SetValue = function(v) InputBox.Text = v end }
        end

        return tabObj
    end

    return Window
end

-- ─────────────────────────────────────────────────────────────────────────────
return Library
