-- ============================================================
--  ███╗   ██╗███████╗██╗  ██╗██╗   ██╗███████╗
--  ████╗  ██║██╔════╝╚██╗██╔╝██║   ██║██╔════╝
--  ██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║███████╗
--  ██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║╚════██║
--  ██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝███████║
--  ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝
--  Nexus UI Library v2.0 — Highest Quality Roblox UI Framework
--  Author: NexusUI Team
--  License: MIT
-- ============================================================

local NexusUI = {}
NexusUI.__index = NexusUI

-- ─── Services ──────────────────────────────────────────────
local Players           = game:GetService("Players")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")
local CoreGui           = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse       = LocalPlayer:GetMouse()

-- ─── Theme ─────────────────────────────────────────────────
NexusUI.Theme = {
    -- Core Palette
    Background      = Color3.fromRGB(10,  10,  15),
    Surface         = Color3.fromRGB(18,  18,  28),
    SurfaceAlt      = Color3.fromRGB(24,  24,  38),
    Border          = Color3.fromRGB(45,  45,  70),
    BorderGlow      = Color3.fromRGB(90,  80, 200),

    -- Accent
    Accent          = Color3.fromRGB(120, 80, 255),
    AccentHover     = Color3.fromRGB(140,110, 255),
    AccentActive    = Color3.fromRGB(100, 60, 230),
    AccentGlow      = Color3.fromRGB(80,  40, 200),

    -- Text
    TextPrimary     = Color3.fromRGB(230, 230, 255),
    TextSecondary   = Color3.fromRGB(140, 140, 180),
    TextMuted       = Color3.fromRGB(80,   80, 120),
    TextAccent      = Color3.fromRGB(160, 120, 255),

    -- Status
    Success         = Color3.fromRGB( 80, 220, 140),
    Warning         = Color3.fromRGB(255, 180,  50),
    Danger          = Color3.fromRGB(255,  70,  70),
    Info            = Color3.fromRGB( 80, 180, 255),

    -- UI Sizes
    CornerRadius    = UDim.new(0, 8),
    CornerRadiusLg  = UDim.new(0, 12),
    CornerRadiusSm  = UDim.new(0, 5),

    -- Font
    Font            = Enum.Font.GothamBold,
    FontMedium      = Enum.Font.Gotham,
    FontMono        = Enum.Font.Code,
    FontSize        = 13,
    FontSizeSm      = 11,
    FontSizeLg      = 16,

    -- Animation
    TweenInfo       = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    TweenInfoSlow   = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    TweenInfoFast   = TweenInfo.new(0.10, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
}

-- ─── Internal Helpers ──────────────────────────────────────
local T = NexusUI.Theme

local function tween(obj, props, info)
    TweenService:Create(obj, info or T.TweenInfo, props):Play()
end

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = radius or T.CornerRadius
    c.Parent = parent
    return c
end

local function stroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color     = color or T.Border
    s.Thickness = thickness or 1.2
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function padding(parent, top, bottom, left, right)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, top    or 8)
    p.PaddingBottom = UDim.new(0, bottom or 8)
    p.PaddingLeft   = UDim.new(0, left   or 10)
    p.PaddingRight  = UDim.new(0, right  or 10)
    p.Parent = parent
    return p
end

local function newLabel(text, size, color, font, parent)
    local l = Instance.new("TextLabel")
    l.Text              = text or ""
    l.TextSize          = size  or T.FontSize
    l.TextColor3        = color or T.TextPrimary
    l.Font              = font  or T.FontMedium
    l.BackgroundTransparency = 1
    l.TextXAlignment    = Enum.TextXAlignment.Left
    l.Size              = UDim2.new(1, 0, 0, size and size + 4 or 18)
    l.Parent            = parent
    return l
end

-- Draggable helper
local function makeDraggable(handle, root)
    local dragging, dragStart, startPos = false, nil, nil
    handle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = inp.Position
            startPos  = root.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = inp.Position - dragStart
            root.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- ══════════════════════════════════════════════════════════════
--  NexusUI:CreateWindow(options)
-- ══════════════════════════════════════════════════════════════
--[[
    options = {
        Title   : string  — Window title
        Size    : Vector2 — Width, Height  (default 580 x 420)
        Position: UDim2   — Starting position
    }
    Returns: Window object { AddTab, Destroy, Toggle, SetTitle }
]]
function NexusUI:CreateWindow(options)
    options = options or {}
    local W = options.Size and options.Size.X or 580
    local H = options.Size and options.Size.Y or 420

    -- ── ScreenGui ────────────────────────────────────────────
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name            = "NexusUI_" .. (options.Title or "Window")
    ScreenGui.ResetOnSpawn    = false
    ScreenGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder    = 999
    ScreenGui.Parent          = CoreGui

    -- ── Root Frame ───────────────────────────────────────────
    local Root = Instance.new("Frame")
    Root.Name             = "Root"
    Root.Size             = UDim2.new(0, W, 0, H)
    Root.Position         = options.Position or UDim2.new(0.5, -W/2, 0.5, -H/2)
    Root.BackgroundColor3 = T.Background
    Root.BorderSizePixel  = 0
    Root.Parent           = ScreenGui
    corner(Root, T.CornerRadiusLg)
    stroke(Root, T.Border, 1.5)

    -- Glow shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name    = "Shadow"
    Shadow.Size    = UDim2.new(1, 40, 1, 40)
    Shadow.Position = UDim2.new(0, -20, 0, -20)
    Shadow.BackgroundTransparency = 1
    Shadow.Image   = "rbxassetid://5554236805"
    Shadow.ImageColor3 = T.AccentGlow
    Shadow.ImageTransparency = 0.72
    Shadow.ZIndex  = -1
    Shadow.Parent  = Root

    -- ── Top Bar ──────────────────────────────────────────────
    local TopBar = Instance.new("Frame")
    TopBar.Name             = "TopBar"
    TopBar.Size             = UDim2.new(1, 0, 0, 44)
    TopBar.BackgroundColor3 = T.Surface
    TopBar.BorderSizePixel  = 0
    TopBar.Parent           = Root
    corner(TopBar, T.CornerRadiusLg)

    -- Fix bottom corners of TopBar
    local TopBarFix = Instance.new("Frame")
    TopBarFix.Size             = UDim2.new(1, 0, 0.5, 0)
    TopBarFix.Position         = UDim2.new(0, 0, 0.5, 0)
    TopBarFix.BackgroundColor3 = T.Surface
    TopBarFix.BorderSizePixel  = 0
    TopBarFix.Parent           = TopBar

    -- Logo/Icon
    local LogoDot = Instance.new("Frame")
    LogoDot.Size             = UDim2.new(0, 8, 0, 8)
    LogoDot.Position         = UDim2.new(0, 16, 0.5, -4)
    LogoDot.BackgroundColor3 = T.Accent
    LogoDot.BorderSizePixel  = 0
    LogoDot.ZIndex           = 2
    LogoDot.Parent           = TopBar
    corner(LogoDot, UDim.new(1, 0))

    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name              = "Title"
    TitleLabel.Text              = options.Title or "Nexus UI"
    TitleLabel.TextSize          = 14
    TitleLabel.TextColor3        = T.TextPrimary
    TitleLabel.Font              = T.Font
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position          = UDim2.new(0, 34, 0, 0)
    TitleLabel.Size              = UDim2.new(0, 200, 1, 0)
    TitleLabel.TextXAlignment    = Enum.TextXAlignment.Left
    TitleLabel.ZIndex            = 2
    TitleLabel.Parent            = TopBar

    makeDraggable(TopBar, Root)

    -- ── Search Bar (floats left of main, NOT inside left frame) ─
    local SearchContainer = Instance.new("Frame")
    SearchContainer.Name             = "SearchContainer"
    SearchContainer.Size             = UDim2.new(0, 200, 0, 32)
    SearchContainer.Position         = UDim2.new(0, -216, 0, 6)
    SearchContainer.BackgroundColor3 = T.Surface
    SearchContainer.BorderSizePixel  = 0
    SearchContainer.Parent           = TopBar
    corner(SearchContainer, T.CornerRadius)
    stroke(SearchContainer, T.Border, 1.2)

    -- Search icon (🔍)
    local SearchIcon = Instance.new("TextLabel")
    SearchIcon.Text              = "⌕"
    SearchIcon.TextSize          = 16
    SearchIcon.TextColor3        = T.TextMuted
    SearchIcon.Font              = T.Font
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.Position          = UDim2.new(0, 8, 0, 0)
    SearchIcon.Size              = UDim2.new(0, 24, 1, 0)
    SearchIcon.TextXAlignment    = Enum.TextXAlignment.Center
    SearchIcon.Parent            = SearchContainer

    local SearchBox = Instance.new("TextBox")
    SearchBox.Name               = "SearchBox"
    SearchBox.PlaceholderText    = "Search…"
    SearchBox.PlaceholderColor3  = T.TextMuted
    SearchBox.Text               = ""
    SearchBox.TextSize           = 12
    SearchBox.TextColor3         = T.TextPrimary
    SearchBox.Font               = T.FontMedium
    SearchBox.BackgroundTransparency = 1
    SearchBox.Position           = UDim2.new(0, 34, 0, 0)
    SearchBox.Size               = UDim2.new(1, -40, 1, 0)
    SearchBox.TextXAlignment     = Enum.TextXAlignment.Left
    SearchBox.ClearTextOnFocus   = false
    SearchBox.Parent             = SearchContainer

    -- Search focus effects
    SearchBox.Focused:Connect(function()
        tween(SearchContainer, { BackgroundColor3 = T.SurfaceAlt })
        tween(SearchContainer:FindFirstChildWhichIsA("UIStroke"), { Color = T.Accent })
    end)
    SearchBox.FocusLost:Connect(function()
        tween(SearchContainer, { BackgroundColor3 = T.Surface })
        tween(SearchContainer:FindFirstChildWhichIsA("UIStroke"), { Color = T.Border })
    end)

    -- ── TopBar Buttons ────────────────────────────────────────
    local BtnContainer = Instance.new("Frame")
    BtnContainer.Size             = UDim2.new(0, 60, 0, 28)
    BtnContainer.Position         = UDim2.new(1, -70, 0.5, -14)
    BtnContainer.BackgroundTransparency = 1
    BtnContainer.ZIndex           = 3
    BtnContainer.Parent           = TopBar

    local BtnLayout = Instance.new("UIListLayout")
    BtnLayout.FillDirection       = Enum.FillDirection.Horizontal
    BtnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    BtnLayout.VerticalAlignment   = Enum.VerticalAlignment.Center
    BtnLayout.Padding             = UDim.new(0, 6)
    BtnLayout.Parent              = BtnContainer

    local function makeTopBtn(icon, color)
        local btn = Instance.new("TextButton")
        btn.Size              = UDim2.new(0, 26, 0, 26)
        btn.BackgroundColor3  = T.SurfaceAlt
        btn.Text              = icon
        btn.TextSize          = 13
        btn.TextColor3        = color or T.TextSecondary
        btn.Font              = T.Font
        btn.BorderSizePixel   = 0
        btn.ZIndex            = 4
        btn.Parent            = BtnContainer
        corner(btn, UDim.new(0, 6))
        btn.MouseEnter:Connect(function()
            tween(btn, { BackgroundColor3 = color or T.Border, TextColor3 = T.TextPrimary })
        end)
        btn.MouseLeave:Connect(function()
            tween(btn, { BackgroundColor3 = T.SurfaceAlt, TextColor3 = color or T.TextSecondary })
        end)
        return btn
    end

    local MinimizeBtn = makeTopBtn("─", T.TextSecondary)
    local CloseBtn    = makeTopBtn("✕", T.Danger)

    -- ── Body ─────────────────────────────────────────────────
    local Body = Instance.new("Frame")
    Body.Name             = "Body"
    Body.Size             = UDim2.new(1, 0, 1, -44)
    Body.Position         = UDim2.new(0, 0, 0, 44)
    Body.BackgroundTransparency = 1
    Body.Parent           = Root

    -- Left Nav Panel
    local NavPanel = Instance.new("Frame")
    NavPanel.Name             = "NavPanel"
    NavPanel.Size             = UDim2.new(0, 140, 1, -12)
    NavPanel.Position         = UDim2.new(0, 8, 0, 6)
    NavPanel.BackgroundColor3 = T.Surface
    NavPanel.BorderSizePixel  = 0
    NavPanel.Parent           = Body
    corner(NavPanel, T.CornerRadius)
    padding(NavPanel, 8, 8, 6, 6)

    local NavLayout = Instance.new("UIListLayout")
    NavLayout.FillDirection       = Enum.FillDirection.Vertical
    NavLayout.Padding             = UDim.new(0, 4)
    NavLayout.SortOrder           = Enum.SortOrder.LayoutOrder
    NavLayout.Parent              = NavPanel

    -- Content area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name             = "ContentArea"
    ContentArea.Size             = UDim2.new(1, -158, 1, -12)
    ContentArea.Position         = UDim2.new(0, 154, 0, 6)
    ContentArea.BackgroundColor3 = T.Surface
    ContentArea.BorderSizePixel  = 0
    ContentArea.Parent           = Body
    corner(ContentArea, T.CornerRadius)

    -- ── Minimize / Close logic ────────────────────────────────
    local isMinimized = false
    MinimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            tween(Root, { Size = UDim2.new(0, W, 0, 44) }, T.TweenInfoSlow)
            tween(Body, { BackgroundTransparency = 1 }, T.TweenInfoFast)
            Body.Visible = false
            MinimizeBtn.Text = "□"
        else
            Body.Visible = true
            tween(Root, { Size = UDim2.new(0, W, 0, H) }, T.TweenInfoSlow)
            MinimizeBtn.Text = "─"
        end
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        tween(Root, { BackgroundTransparency = 1, Size = UDim2.new(0, W*0.9, 0, H*0.9) }, T.TweenInfoSlow)
        task.delay(0.35, function() ScreenGui:Destroy() end)
    end)

    -- ── Floating Minimize Button (draggable) ──────────────────
    local FloatingBtn = Instance.new("TextButton")
    FloatingBtn.Name             = "FloatingMinimize"
    FloatingBtn.Size             = UDim2.new(0, 40, 0, 40)
    FloatingBtn.Position         = UDim2.new(0, 20, 0.5, -20)
    FloatingBtn.BackgroundColor3 = T.Accent
    FloatingBtn.Text             = "N"
    FloatingBtn.TextSize         = 16
    FloatingBtn.TextColor3       = Color3.new(1,1,1)
    FloatingBtn.Font             = T.Font
    FloatingBtn.BorderSizePixel  = 0
    FloatingBtn.ZIndex           = 10
    FloatingBtn.Parent           = ScreenGui
    corner(FloatingBtn, UDim.new(1,0))
    stroke(FloatingBtn, T.AccentHover, 2)

    -- Float glow
    local FloatGlow = Instance.new("ImageLabel")
    FloatGlow.Size             = UDim2.new(1, 24, 1, 24)
    FloatGlow.Position         = UDim2.new(0, -12, 0, -12)
    FloatGlow.BackgroundTransparency = 1
    FloatGlow.Image            = "rbxassetid://5554236805"
    FloatGlow.ImageColor3      = T.Accent
    FloatGlow.ImageTransparency = 0.6
    FloatGlow.ZIndex           = 9
    FloatGlow.Parent           = FloatingBtn

    makeDraggable(FloatingBtn, FloatingBtn)

    FloatingBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            Root.Visible = false
            FloatingBtn.Text = "◉"
        else
            Root.Visible = true
            FloatingBtn.Text = "N"
        end
    end)

    -- Hover pulse
    FloatingBtn.MouseEnter:Connect(function()
        tween(FloatingBtn, { BackgroundColor3 = T.AccentHover, Size = UDim2.new(0, 44, 0, 44), Position = UDim2.new(FloatingBtn.Position.X.Scale, FloatingBtn.Position.X.Offset - 2, FloatingBtn.Position.Y.Scale, FloatingBtn.Position.Y.Offset - 2) })
    end)
    FloatingBtn.MouseLeave:Connect(function()
        tween(FloatingBtn, { BackgroundColor3 = T.Accent, Size = UDim2.new(0, 40, 0, 40) })
    end)

    -- ── Tab System ────────────────────────────────────────────
    local tabs = {}
    local activeTab = nil

    local Window = {}

    function Window:AddTab(tabOptions)
        tabOptions = tabOptions or {}
        local tabName = tabOptions.Name or ("Tab " .. (#tabs + 1))
        local tabIcon = tabOptions.Icon or ""

        -- Nav button
        local NavBtn = Instance.new("TextButton")
        NavBtn.Name             = tabName
        NavBtn.Size             = UDim2.new(1, 0, 0, 34)
        NavBtn.BackgroundColor3 = T.SurfaceAlt
        NavBtn.Text             = (tabIcon ~= "" and tabIcon .. "  " or "") .. tabName
        NavBtn.TextSize         = 12
        NavBtn.TextColor3       = T.TextSecondary
        NavBtn.Font             = T.FontMedium
        NavBtn.TextXAlignment   = Enum.TextXAlignment.Left
        NavBtn.BorderSizePixel  = 0
        NavBtn.LayoutOrder      = #tabs + 1
        NavBtn.Parent           = NavPanel
        corner(NavBtn, T.CornerRadiusSm)
        padding(NavBtn, 0, 0, 10, 6)

        local NavAccent = Instance.new("Frame")
        NavAccent.Name             = "Accent"
        NavAccent.Size             = UDim2.new(0, 3, 0, 18)
        NavAccent.Position         = UDim2.new(0, 0, 0.5, -9)
        NavAccent.BackgroundColor3 = T.Accent
        NavAccent.BorderSizePixel  = 0
        NavAccent.BackgroundTransparency = 1
        NavAccent.Parent           = NavBtn
        corner(NavAccent, UDim.new(1,0))

        -- Tab scroll frame
        local TabFrame = Instance.new("ScrollingFrame")
        TabFrame.Name             = tabName .. "_Frame"
        TabFrame.Size             = UDim2.new(1, -16, 1, -16)
        TabFrame.Position         = UDim2.new(0, 8, 0, 8)
        TabFrame.BackgroundTransparency = 1
        TabFrame.BorderSizePixel  = 0
        TabFrame.ScrollBarThickness = 3
        TabFrame.ScrollBarImageColor3 = T.Accent
        TabFrame.CanvasSize       = UDim2.new(0, 0, 0, 0)
        TabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabFrame.Visible          = false
        TabFrame.Parent           = ContentArea

        local TabLayout = Instance.new("UIListLayout")
        TabLayout.FillDirection   = Enum.FillDirection.Vertical
        TabLayout.Padding         = UDim.new(0, 8)
        TabLayout.SortOrder       = Enum.SortOrder.LayoutOrder
        TabLayout.Parent          = TabFrame

        local tab = {
            Name     = tabName,
            NavBtn   = NavBtn,
            Frame    = TabFrame,
            Layout   = TabLayout,
            Elements = {},
            _order   = 0,
        }

        -- Activate
        local function activate()
            if activeTab then
                tween(activeTab.NavBtn, { BackgroundColor3 = T.SurfaceAlt, TextColor3 = T.TextSecondary })
                tween(activeTab.NavBtn.Accent, { BackgroundTransparency = 1 })
                activeTab.Frame.Visible = false
            end
            activeTab = tab
            TabFrame.Visible = true
            tween(NavBtn, { BackgroundColor3 = T.Background, TextColor3 = T.TextAccent })
            tween(NavAccent, { BackgroundTransparency = 0 })
        end

        NavBtn.MouseButton1Click:Connect(activate)
        NavBtn.MouseEnter:Connect(function()
            if activeTab ~= tab then
                tween(NavBtn, { BackgroundColor3 = T.Background })
            end
        end)
        NavBtn.MouseLeave:Connect(function()
            if activeTab ~= tab then
                tween(NavBtn, { BackgroundColor3 = T.SurfaceAlt })
            end
        end)

        if #tabs == 0 then activate() end
        table.insert(tabs, tab)

        -- ── Search filter ─────────────────────────────────────
        SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
            local q = SearchBox.Text:lower()
            for _, el in ipairs(tab.Elements) do
                if el.Container then
                    el.Container.Visible = (q == "" or el.Name:lower():find(q, 1, true) ~= nil)
                end
            end
        end)

        -- ═══════════════════════════════════════════════════════
        --  Element Builders
        -- ═══════════════════════════════════════════════════════

        local Tab = {}

        -- ── Section Label ─────────────────────────────────────
        function Tab:AddSection(name)
            local wrap = Instance.new("Frame")
            wrap.Name             = "Section_" .. name
            wrap.Size             = UDim2.new(1, 0, 0, 24)
            wrap.BackgroundTransparency = 1
            wrap.LayoutOrder      = tab._order
            tab._order += 1
            wrap.Parent           = TabFrame

            local line = Instance.new("Frame")
            line.Size             = UDim2.new(1, 0, 0, 1)
            line.Position         = UDim2.new(0, 0, 0.5, 0)
            line.BackgroundColor3 = T.Border
            line.BorderSizePixel  = 0
            line.Parent           = wrap

            local lbl = newLabel((" " .. name .. " "), 11, T.TextMuted, T.Font, wrap)
            lbl.BackgroundColor3  = T.Surface
            lbl.BackgroundTransparency = 0
            lbl.Size              = UDim2.new(0, 0, 1, 0)
            lbl.AutomaticSize     = Enum.AutomaticSize.X
            lbl.Position          = UDim2.new(0, 12, 0, 0)
            lbl.TextXAlignment    = Enum.TextXAlignment.Left
        end

        -- ══════════════════════════════════════════════════════
        --  1. BUTTON
        -- ══════════════════════════════════════════════════════
        --[[
            Tab:AddButton({
                Name     = "Click Me",
                Callback = function() end,
                Variant  = "primary" | "danger" | "success" | "ghost",  -- optional
            })
        ]]
        function Tab:AddButton(opts)
            opts = opts or {}
            local name     = opts.Name     or "Button"
            local callback = opts.Callback or function() end
            local variant  = opts.Variant  or "primary"

            local accentColor = ({
                primary = T.Accent,
                danger  = T.Danger,
                success = T.Success,
                ghost   = T.SurfaceAlt,
            })[variant] or T.Accent

            local wrap = Instance.new("Frame")
            wrap.Name             = name
            wrap.Size             = UDim2.new(1, 0, 0, 36)
            wrap.BackgroundTransparency = 1
            wrap.LayoutOrder      = tab._order
            tab._order += 1
            wrap.Parent           = TabFrame

            local btn = Instance.new("TextButton")
            btn.Size              = UDim2.new(1, 0, 1, 0)
            btn.BackgroundColor3  = accentColor
            btn.Text              = name
            btn.TextSize          = 13
            btn.TextColor3        = variant == "ghost" and T.TextPrimary or Color3.new(1,1,1)
            btn.Font              = T.Font
            btn.BorderSizePixel   = 0
            btn.Parent            = wrap
            corner(btn)
            if variant == "ghost" then stroke(btn, T.Border) end

            -- Ripple on click
            btn.MouseButton1Down:Connect(function()
                tween(btn, { BackgroundColor3 = Color3.fromRGB(
                    math.clamp(accentColor.R*255 - 20, 0, 255),
                    math.clamp(accentColor.G*255 - 20, 0, 255),
                    math.clamp(accentColor.B*255 - 20, 0, 255)) }, T.TweenInfoFast)
            end)
            btn.MouseButton1Up:Connect(function()
                tween(btn, { BackgroundColor3 = accentColor }, T.TweenInfo)
                callback()
            end)
            btn.MouseEnter:Connect(function()
                tween(btn, { BackgroundColor3 = T.AccentHover })
            end)
            btn.MouseLeave:Connect(function()
                tween(btn, { BackgroundColor3 = accentColor })
            end)

            local el = { Name = name, Container = wrap, Button = btn }
            table.insert(tab.Elements, el)
            return el
        end

        -- ══════════════════════════════════════════════════════
        --  2. TOGGLE
        -- ══════════════════════════════════════════════════════
        --[[
            Tab:AddToggle({
                Name     = "Enable Feature",
                Default  = false,
                Callback = function(value) end,
            })
            -- el.Set(true/false)
            -- el.Get() → boolean
        ]]
        function Tab:AddToggle(opts)
            opts = opts or {}
            local name     = opts.Name     or "Toggle"
            local value    = opts.Default  ~= nil and opts.Default or false
            local callback = opts.Callback or function() end

            local wrap = Instance.new("Frame")
            wrap.Name             = name
            wrap.Size             = UDim2.new(1, 0, 0, 36)
            wrap.BackgroundColor3 = T.SurfaceAlt
            wrap.BorderSizePixel  = 0
            wrap.LayoutOrder      = tab._order
            tab._order += 1
            wrap.Parent           = TabFrame
            corner(wrap)
            padding(wrap, 0, 0, 12, 12)

            newLabel(name, 13, T.TextPrimary, T.FontMedium, wrap)

            local Track = Instance.new("Frame")
            Track.Size             = UDim2.new(0, 44, 0, 24)
            Track.Position         = UDim2.new(1, -44, 0.5, -12)
            Track.BackgroundColor3 = value and T.Accent or T.Border
            Track.BorderSizePixel  = 0
            Track.Parent           = wrap
            corner(Track, UDim.new(1, 0))

            local Thumb = Instance.new("Frame")
            Thumb.Size             = UDim2.new(0, 18, 0, 18)
            Thumb.Position         = value and UDim2.new(0, 23, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
            Thumb.BackgroundColor3 = Color3.new(1,1,1)
            Thumb.BorderSizePixel  = 0
            Thumb.Parent           = Track
            corner(Thumb, UDim.new(1, 0))

            local clickable = Instance.new("TextButton")
            clickable.Size              = UDim2.new(1, 0, 1, 0)
            clickable.BackgroundTransparency = 1
            clickable.Text              = ""
            clickable.Parent            = wrap

            local function updateVisual()
                tween(Track, { BackgroundColor3 = value and T.Accent or T.Border })
                tween(Thumb, { Position = value and UDim2.new(0, 23, 0.5, -9) or UDim2.new(0, 3, 0.5, -9) })
            end

            clickable.MouseButton1Click:Connect(function()
                value = not value
                updateVisual()
                callback(value)
            end)

            local el = {
                Name      = name,
                Container = wrap,
                Set       = function(_, v) value = v; updateVisual(); callback(value) end,
                Get       = function() return value end,
            }
            table.insert(tab.Elements, el)
            return el
        end

        -- ══════════════════════════════════════════════════════
        --  3. INPUT
        -- ══════════════════════════════════════════════════════
        --[[
            Tab:AddInput({
                Name        = "Player Name",
                Placeholder = "Enter text…",
                Default     = "",
                Callback    = function(text) end,
            })
            -- el.Set("text")
            -- el.Get() → string
        ]]
        function Tab:AddInput(opts)
            opts = opts or {}
            local name        = opts.Name        or "Input"
            local placeholder = opts.Placeholder or "Type here…"
            local default     = opts.Default     or ""
            local callback    = opts.Callback    or function() end

            local wrap = Instance.new("Frame")
            wrap.Name             = name
            wrap.Size             = UDim2.new(1, 0, 0, 60)
            wrap.BackgroundTransparency = 1
            wrap.LayoutOrder      = tab._order
            tab._order += 1
            wrap.Parent           = TabFrame

            newLabel(name, 11, T.TextSecondary, T.FontMedium, wrap)

            local box = Instance.new("Frame")
            box.Size              = UDim2.new(1, 0, 0, 36)
            box.Position          = UDim2.new(0, 0, 0, 22)
            box.BackgroundColor3  = T.SurfaceAlt
            box.BorderSizePixel   = 0
            box.Parent            = wrap
            corner(box)
            local boxStroke = stroke(box, T.Border)
            padding(box, 0, 0, 12, 12)

            local input = Instance.new("TextBox")
            input.Text              = default
            input.PlaceholderText   = placeholder
            input.PlaceholderColor3 = T.TextMuted
            input.TextSize          = 13
            input.TextColor3        = T.TextPrimary
            input.Font              = T.FontMedium
            input.BackgroundTransparency = 1
            input.Size              = UDim2.new(1, 0, 1, 0)
            input.TextXAlignment    = Enum.TextXAlignment.Left
            input.ClearTextOnFocus  = false
            input.Parent            = box

            input.Focused:Connect(function()
                tween(box, { BackgroundColor3 = T.Background })
                tween(boxStroke, { Color = T.Accent })
            end)
            input.FocusLost:Connect(function(enter)
                tween(box, { BackgroundColor3 = T.SurfaceAlt })
                tween(boxStroke, { Color = T.Border })
                if enter then callback(input.Text) end
            end)

            local el = {
                Name      = name,
                Container = wrap,
                Set       = function(_, v) input.Text = v end,
                Get       = function() return input.Text end,
            }
            table.insert(tab.Elements, el)
            return el
        end

        -- ══════════════════════════════════════════════════════
        --  4. DROPDOWN  (square popup, centered, scrollable)
        -- ══════════════════════════════════════════════════════
        --[[
            Tab:AddDropdown({
                Name     = "Select Mode",
                Options  = {"Option A", "Option B", "Option C"},
                Default  = "Option A",
                Callback = function(selected) end,
            })
            -- el.Set("Option B")
            -- el.Get() → string
        ]]
        function Tab:AddDropdown(opts)
            opts = opts or {}
            local name     = opts.Name     or "Dropdown"
            local options  = opts.Options  or {}
            local selected = opts.Default  or (options[1] or "")
            local callback = opts.Callback or function() end
            local isOpen   = false

            local wrap = Instance.new("Frame")
            wrap.Name             = name
            wrap.Size             = UDim2.new(1, 0, 0, 60)
            wrap.BackgroundTransparency = 1
            wrap.LayoutOrder      = tab._order
            tab._order += 1
            wrap.Parent           = TabFrame
            wrap.ClipsDescendants = false

            newLabel(name, 11, T.TextSecondary, T.FontMedium, wrap)

            local Trigger = Instance.new("TextButton")
            Trigger.Name             = "Trigger"
            Trigger.Size             = UDim2.new(1, 0, 0, 36)
            Trigger.Position         = UDim2.new(0, 0, 0, 22)
            Trigger.BackgroundColor3 = T.SurfaceAlt
            Trigger.Text             = ""
            Trigger.BorderSizePixel  = 0
            Trigger.Parent           = wrap
            corner(Trigger)
            stroke(Trigger, T.Border)
            padding(Trigger, 0, 0, 12, 12)

            local TriggerLabel = newLabel(selected, 13, T.TextPrimary, T.FontMedium, Trigger)
            TriggerLabel.Size = UDim2.new(1, -24, 1, 0)

            local Arrow = Instance.new("TextLabel")
            Arrow.Text              = "▾"
            Arrow.TextSize          = 14
            Arrow.TextColor3        = T.TextMuted
            Arrow.Font              = T.Font
            Arrow.BackgroundTransparency = 1
            Arrow.Size              = UDim2.new(0, 20, 1, 0)
            Arrow.Position          = UDim2.new(1, -22, 0, 0)
            Arrow.TextXAlignment    = Enum.TextXAlignment.Center
            Arrow.Parent            = Trigger

            -- Popup — placed in ScreenGui so it's truly in front and centered
            local Popup = Instance.new("Frame")
            Popup.Name             = "DropdownPopup_" .. name
            Popup.Size             = UDim2.new(0, 240, 0, 200)
            Popup.AnchorPoint      = Vector2.new(0.5, 0.5)
            Popup.Position         = UDim2.new(0.5, 0, 0.5, 0)
            Popup.BackgroundColor3 = T.SurfaceAlt
            Popup.BorderSizePixel  = 0
            Popup.ZIndex           = 100
            Popup.Visible          = false
            Popup.Parent           = ScreenGui
            corner(Popup, T.CornerRadius)
            stroke(Popup, T.Accent, 1.5)

            -- Popup header
            local PopupTitle = Instance.new("TextLabel")
            PopupTitle.Text              = name
            PopupTitle.TextSize          = 12
            PopupTitle.TextColor3        = T.TextAccent
            PopupTitle.Font              = T.Font
            PopupTitle.BackgroundColor3  = T.Background
            PopupTitle.Size              = UDim2.new(1, 0, 0, 30)
            PopupTitle.TextXAlignment    = Enum.TextXAlignment.Center
            PopupTitle.ZIndex            = 101
            PopupTitle.BorderSizePixel   = 0
            PopupTitle.Parent            = Popup
            corner(PopupTitle, T.CornerRadius)

            local PopupFix = Instance.new("Frame")
            PopupFix.Size             = UDim2.new(1, 0, 0.4, 0)
            PopupFix.Position         = UDim2.new(0, 0, 0.6, 0)
            PopupFix.BackgroundColor3 = T.Background
            PopupFix.BorderSizePixel  = 0
            PopupFix.ZIndex           = 101
            PopupFix.Parent           = PopupTitle

            local Scroll = Instance.new("ScrollingFrame")
            Scroll.Size               = UDim2.new(1, -12, 1, -38)
            Scroll.Position           = UDim2.new(0, 6, 0, 34)
            Scroll.BackgroundTransparency = 1
            Scroll.BorderSizePixel    = 0
            Scroll.ScrollBarThickness = 3
            Scroll.ScrollBarImageColor3 = T.Accent
            Scroll.CanvasSize         = UDim2.new(0, 0, 0, 0)
            Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
            Scroll.ZIndex             = 101
            Scroll.Parent             = Popup

            local ScrollLayout = Instance.new("UIListLayout")
            ScrollLayout.FillDirection = Enum.FillDirection.Vertical
            ScrollLayout.Padding       = UDim.new(0, 3)
            ScrollLayout.Parent        = Scroll

            -- Build option items
            for _, opt in ipairs(options) do
                local item = Instance.new("TextButton")
                item.Size              = UDim2.new(1, 0, 0, 32)
                item.BackgroundColor3  = opt == selected and T.Accent or T.Surface
                item.Text              = opt
                item.TextSize          = 12
                item.TextColor3        = opt == selected and Color3.new(1,1,1) or T.TextPrimary
                item.Font              = T.FontMedium
                item.BorderSizePixel   = 0
                item.ZIndex            = 102
                item.Parent            = Scroll
                corner(item, T.CornerRadiusSm)

                item.MouseEnter:Connect(function()
                    if opt ~= selected then
                        tween(item, { BackgroundColor3 = T.SurfaceAlt })
                    end
                end)
                item.MouseLeave:Connect(function()
                    tween(item, { BackgroundColor3 = opt == selected and T.Accent or T.Surface })
                end)
                item.MouseButton1Click:Connect(function()
                    selected        = opt
                    TriggerLabel.Text = opt
                    -- reset all
                    for _, c in ipairs(Scroll:GetChildren()) do
                        if c:IsA("TextButton") then
                            tween(c, { BackgroundColor3 = T.Surface, TextColor3 = T.TextPrimary })
                        end
                    end
                    tween(item, { BackgroundColor3 = T.Accent, TextColor3 = Color3.new(1,1,1) })
                    isOpen = false
                    tween(Popup, { Size = UDim2.new(0, 240, 0, 0) }, T.TweenInfoFast)
                    task.delay(0.12, function() Popup.Visible = false end)
                    tween(Arrow, { Rotation = 0 })
                    callback(selected)
                end)
            end

            -- Toggle popup
            Trigger.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    Popup.Visible = true
                    Popup.Size    = UDim2.new(0, 240, 0, 0)
                    tween(Popup, { Size = UDim2.new(0, 240, 0, 200) })
                    tween(Arrow, { Rotation = 180 })
                else
                    tween(Popup, { Size = UDim2.new(0, 240, 0, 0) }, T.TweenInfoFast)
                    task.delay(0.12, function() Popup.Visible = false end)
                    tween(Arrow, { Rotation = 0 })
                end
            end)

            -- Close popup when clicking outside
            UserInputService.InputBegan:Connect(function(inp)
                if isOpen and inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    if not Popup.AbsolutePosition then return end
                    local mx, my = Mouse.X, Mouse.Y
                    local px, py = Popup.AbsolutePosition.X, Popup.AbsolutePosition.Y
                    local pw, ph = Popup.AbsoluteSize.X,    Popup.AbsoluteSize.Y
                    if mx < px or mx > px+pw or my < py or my > py+ph then
                        isOpen = false
                        tween(Popup, { Size = UDim2.new(0, 240, 0, 0) }, T.TweenInfoFast)
                        task.delay(0.12, function() Popup.Visible = false end)
                        tween(Arrow, { Rotation = 0 })
                    end
                end
            end)

            local el = {
                Name      = name,
                Container = wrap,
                Set       = function(_, v)
                    selected = v
                    TriggerLabel.Text = v
                    for _, c in ipairs(Scroll:GetChildren()) do
                        if c:IsA("TextButton") then
                            local isActive = c.Text == v
                            c.BackgroundColor3 = isActive and T.Accent or T.Surface
                            c.TextColor3       = isActive and Color3.new(1,1,1) or T.TextPrimary
                        end
                    end
                end,
                Get = function() return selected end,
            }
            table.insert(tab.Elements, el)
            return el
        end

        -- ══════════════════════════════════════════════════════
        --  5. SLIDER
        -- ══════════════════════════════════════════════════════
        --[[
            Tab:AddSlider({
                Name     = "Speed",
                Min      = 0,
                Max      = 100,
                Default  = 50,
                Suffix   = "%",
                Callback = function(value) end,
            })
            -- el.Set(75)
            -- el.Get() → number
        ]]
        function Tab:AddSlider(opts)
            opts = opts or {}
            local name     = opts.Name     or "Slider"
            local min      = opts.Min      or 0
            local max      = opts.Max      or 100
            local value    = opts.Default  or min
            local suffix   = opts.Suffix   or ""
            local callback = opts.Callback or function() end

            local wrap = Instance.new("Frame")
            wrap.Name             = name
            wrap.Size             = UDim2.new(1, 0, 0, 56)
            wrap.BackgroundTransparency = 1
            wrap.LayoutOrder      = tab._order
            tab._order += 1
            wrap.Parent           = TabFrame

            -- Header row
            local header = Instance.new("Frame")
            header.Size             = UDim2.new(1, 0, 0, 18)
            header.BackgroundTransparency = 1
            header.Parent           = wrap

            newLabel(name, 11, T.TextSecondary, T.FontMedium, header)

            local ValLabel = Instance.new("TextLabel")
            ValLabel.Text           = tostring(math.round(value)) .. suffix
            ValLabel.TextSize       = 12
            ValLabel.TextColor3     = T.TextAccent
            ValLabel.Font           = T.Font
            ValLabel.BackgroundTransparency = 1
            ValLabel.Size           = UDim2.new(0, 60, 1, 0)
            ValLabel.Position       = UDim2.new(1, -60, 0, 0)
            ValLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValLabel.Parent         = header

            -- Track
            local Track = Instance.new("Frame")
            Track.Size             = UDim2.new(1, 0, 0, 6)
            Track.Position         = UDim2.new(0, 0, 0, 32)
            Track.BackgroundColor3 = T.Border
            Track.BorderSizePixel  = 0
            Track.Parent           = wrap
            corner(Track, UDim.new(1, 0))

            local Fill = Instance.new("Frame")
            Fill.Size             = UDim2.new((value - min) / (max - min), 0, 1, 0)
            Fill.BackgroundColor3 = T.Accent
            Fill.BorderSizePixel  = 0
            Fill.Parent           = Track
            corner(Fill, UDim.new(1, 0))

            local Knob = Instance.new("Frame")
            Knob.Size             = UDim2.new(0, 16, 0, 16)
            Knob.Position         = UDim2.new((value - min)/(max - min), -8, 0.5, -8)
            Knob.BackgroundColor3 = Color3.new(1,1,1)
            Knob.BorderSizePixel  = 0
            Knob.ZIndex           = 2
            Knob.Parent           = Track
            corner(Knob, UDim.new(1, 0))
            stroke(Knob, T.Accent, 2)

            local dragging = false
            local function update(input)
                local rel   = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                value       = math.round(min + rel * (max - min))
                local pct   = (value - min) / (max - min)
                tween(Fill, { Size = UDim2.new(pct, 0, 1, 0) }, T.TweenInfoFast)
                tween(Knob, { Position = UDim2.new(pct, -8, 0.5, -8) }, T.TweenInfoFast)
                ValLabel.Text = tostring(value) .. suffix
                callback(value)
            end

            Knob.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    tween(Knob, { Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(Knob.Position.X.Scale, -10, 0.5, -10) }, T.TweenInfoFast)
                end
            end)
            Track.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    update(inp)
                end
            end)
            UserInputService.InputChanged:Connect(function(inp)
                if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
                    update(inp)
                end
            end)
            UserInputService.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                    tween(Knob, { Size = UDim2.new(0, 16, 0, 16) }, T.TweenInfoFast)
                    local pct = (value - min) / (max - min)
                    tween(Knob, { Position = UDim2.new(pct, -8, 0.5, -8) }, T.TweenInfoFast)
                end
            end)

            local el = {
                Name      = name,
                Container = wrap,
                Set       = function(_, v)
                    value = math.clamp(v, min, max)
                    local pct = (value - min) / (max - min)
                    Fill.Size  = UDim2.new(pct, 0, 1, 0)
                    Knob.Position = UDim2.new(pct, -8, 0.5, -8)
                    ValLabel.Text = tostring(value) .. suffix
                end,
                Get = function() return value end,
            }
            table.insert(tab.Elements, el)
            return el
        end

        return Tab
    end

    -- Window helpers
    function Window:SetTitle(text)
        TitleLabel.Text = text
    end
    function Window:Toggle()
        Root.Visible = not Root.Visible
    end
    function Window:Destroy()
        ScreenGui:Destroy()
    end

    return Window
end

-- ══════════════════════════════════════════════════════════════
--  USAGE EXAMPLE  (copy to any LocalScript / Script)
-- ══════════════════════════════════════════════════════════════
--[[

local NexusUI = loadstring(game:HttpGet("YOUR_RAW_URL_HERE"))()

-- 1. Create a window
local Window = NexusUI:CreateWindow({
    Title    = "My Nexus Script",
    Size     = Vector2.new(580, 420),
})

-- 2. Create tabs
local MainTab     = Window:AddTab({ Name = "Main",     Icon = "⚡" })
local CombatTab   = Window:AddTab({ Name = "Combat",   Icon = "⚔" })
local SettingsTab = Window:AddTab({ Name = "Settings", Icon = "⚙" })

-- ── Main Tab ─────────────────────────────────────────────────
MainTab:AddSection("Player")

local SpeedSlider = MainTab:AddSlider({
    Name     = "Walk Speed",
    Min      = 16,
    Max      = 250,
    Default  = 16,
    Suffix   = " stud/s",
    Callback = function(v)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
    end,
})

local JumpSlider = MainTab:AddSlider({
    Name     = "Jump Power",
    Min      = 50,
    Max      = 500,
    Default  = 50,
    Suffix   = " jp",
    Callback = function(v)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = v
    end,
})

MainTab:AddSection("Toggles")

local FlyToggle = MainTab:AddToggle({
    Name     = "Fly Mode",
    Default  = false,
    Callback = function(state)
        print("Fly:", state)
    end,
})

local NoclipToggle = MainTab:AddToggle({
    Name     = "Noclip",
    Default  = false,
    Callback = function(state)
        print("Noclip:", state)
    end,
})

-- ── Combat Tab ───────────────────────────────────────────────
CombatTab:AddSection("Targeting")

local TeamDrop = CombatTab:AddDropdown({
    Name     = "Target Team",
    Options  = { "All", "Enemy Only", "Neutral", "Allies" },
    Default  = "Enemy Only",
    Callback = function(sel)
        print("Target:", sel)
    end,
})

CombatTab:AddSection("Actions")

local KillBtn = CombatTab:AddButton({
    Name     = "Kill Aura",
    Variant  = "danger",
    Callback = function()
        print("Kill aura activated")
    end,
})

-- ── Settings Tab ─────────────────────────────────────────────
SettingsTab:AddSection("Preferences")

local NameInput = SettingsTab:AddInput({
    Name        = "Custom Tag",
    Placeholder = "Enter your tag…",
    Default     = "",
    Callback    = function(text)
        print("Tag set:", text)
    end,
})

SettingsTab:AddSection("Theme")

local ThemeDrop = SettingsTab:AddDropdown({
    Name     = "Color Accent",
    Options  = { "Purple", "Cyan", "Rose", "Amber" },
    Default  = "Purple",
    Callback = function(sel)
        print("Theme:", sel)
    end,
})

SettingsTab:AddButton({
    Name     = "Save Settings",
    Variant  = "primary",
    Callback = function()
        print("Saved!")
    end,
})

-- ── API Examples ─────────────────────────────────────────────
-- Get current slider value
print(SpeedSlider:Get())       -- 16

-- Programmatically set elements
SpeedSlider:Set(100)
FlyToggle:Set(true)
TeamDrop:Set("All")
NameInput:Set("NexusUser")

-- Window control
Window:SetTitle("Nexus — Updated")
Window:Toggle()    -- hide/show
-- Window:Destroy()  -- remove entirely

]]

return NexusUI
