--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║                   SKUI — Premium UI Library                  ║
    ║              Glassmorphism · Draggable · Minimal             ║
    ║                 by .ftgs — Roblox Hub Framework              ║
    ╚══════════════════════════════════════════════════════════════╝
--]]

local SKUI = {}
SKUI.__index = SKUI

-- ─────────────────────────────────────────────
--  SERVICES
-- ─────────────────────────────────────────────
local Players         = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService    = game:GetService("TweenService")
local RunService      = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Mouse       = LocalPlayer:GetMouse()

-- ─────────────────────────────────────────────
--  THEME — Glassmorphism Palette
-- ─────────────────────────────────────────────
local T = {
    -- Base glass
    BG            = Color3.fromRGB(10,  12,  20),
    Glass         = Color3.fromRGB(20,  24,  38),
    GlassLight    = Color3.fromRGB(28,  33,  52),
    GlassBorder   = Color3.fromRGB(55,  65,  100),

    -- Sidebar
    Sidebar       = Color3.fromRGB(14,  17,  28),
    SidebarBorder = Color3.fromRGB(40,  48,  75),
    TabHover      = Color3.fromRGB(30,  36,  58),
    TabActive     = Color3.fromRGB(38,  46,  78),

    -- Accent gradient stops
    AccentA       = Color3.fromRGB(120, 100, 255),  -- violet
    AccentB       = Color3.fromRGB(80,  170, 255),  -- sky
    Accent        = Color3.fromRGB(100, 135, 255),  -- mid

    -- Text
    TextPrimary   = Color3.fromRGB(235, 238, 255),
    TextSecondary = Color3.fromRGB(140, 150, 185),
    TextMuted     = Color3.fromRGB(80,  90,  130),
    TextAccent    = Color3.fromRGB(145, 165, 255),

    -- Controls
    ControlBG     = Color3.fromRGB(18,  22,  36),
    ControlBorder = Color3.fromRGB(50,  60,  95),
    ControlHover  = Color3.fromRGB(25,  30,  50),

    -- Toggle
    ToggleOff     = Color3.fromRGB(35,  40,  65),
    ToggleOn      = Color3.fromRGB(100, 135, 255),
    ToggleKnob    = Color3.fromRGB(255, 255, 255),

    -- Slider
    SliderTrack   = Color3.fromRGB(25,  30,  50),
    SliderFill    = Color3.fromRGB(100, 135, 255),
    SliderKnob    = Color3.fromRGB(220, 225, 255),

    -- Dropdown modal
    ModalBG       = Color3.fromRGB(16,  20,  34),
    ModalBorder   = Color3.fromRGB(60,  72,  115),
    ModalItem     = Color3.fromRGB(22,  27,  44),
    ModalHover    = Color3.fromRGB(32,  40,  68),
    ModalSelected = Color3.fromRGB(38,  50,  95),

    -- Search
    SearchBG      = Color3.fromRGB(16,  20,  33),

    -- Misc
    Shadow        = Color3.fromRGB(0,   0,   0),
    Success       = Color3.fromRGB(80,  220, 140),
    Danger        = Color3.fromRGB(255, 80,  100),
    White         = Color3.fromRGB(255, 255, 255),
}

-- ─────────────────────────────────────────────
--  UTILITY HELPERS
-- ─────────────────────────────────────────────
local function tween(obj, props, t, style, dir)
    local info = TweenInfo.new(t or 0.18, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out)
    TweenService:Create(obj, info, props):Play()
end

local function makeCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = parent
    return c
end

local function makeBorder(parent, color, thick)
    local s = Instance.new("UIStroke")
    s.Color = color or T.GlassBorder
    s.Thickness = thick or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function makePadding(parent, t, b, l, r)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, t or 6)
    p.PaddingBottom = UDim.new(0, b or 6)
    p.PaddingLeft   = UDim.new(0, l or 8)
    p.PaddingRight  = UDim.new(0, r or 8)
    p.Parent = parent
    return p
end

local function makeListLayout(parent, dir, spacing, halign)
    local l = Instance.new("UIListLayout")
    l.FillDirection         = dir or Enum.FillDirection.Vertical
    l.Padding               = UDim.new(0, spacing or 6)
    l.HorizontalAlignment   = halign or Enum.HorizontalAlignment.Left
    l.SortOrder             = Enum.SortOrder.LayoutOrder
    l.Parent                = parent
    return l
end

local function makeSizeConstraint(parent, minX, minY, maxX, maxY)
    local c = Instance.new("UISizeConstraint")
    c.MinSize = Vector2.new(minX or 0, minY or 0)
    c.MaxSize = Vector2.new(maxX or math.huge, maxY or math.huge)
    c.Parent  = parent
    return c
end

-- Label shorthand
local function label(parent, text, size, color, bold, halign)
    local l = Instance.new("TextLabel")
    l.Text              = text or ""
    l.TextSize          = size or 13
    l.TextColor3        = color or T.TextPrimary
    l.Font              = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    l.BackgroundTransparency = 1
    l.TextXAlignment    = halign or Enum.TextXAlignment.Left
    l.Size              = UDim2.new(1, 0, 0, size and size + 4 or 18)
    l.Parent            = parent
    return l
end

-- Frame shorthand
local function frame(parent, size, pos, color, trans)
    local f = Instance.new("Frame")
    f.Size                  = size or UDim2.new(1, 0, 0, 30)
    f.Position              = pos  or UDim2.new(0, 0, 0, 0)
    f.BackgroundColor3      = color or T.Glass
    f.BackgroundTransparency = trans or 0
    f.BorderSizePixel       = 0
    f.Parent                = parent
    return f
end

-- ImageLabel icon shorthand
local function icon(parent, imageId, size, pos)
    local img = Instance.new("ImageLabel")
    img.Image               = imageId or ""
    img.Size                = size or UDim2.new(0, 16, 0, 16)
    img.Position            = pos  or UDim2.new(0, 0, 0.5, -8)
    img.BackgroundTransparency = 1
    img.ScaleType           = Enum.ScaleType.Fit
    img.Parent              = parent
    return img
end

-- Draggable helper
local function makeDraggable(handle, target)
    local dragging, dragStart, startPos = false, nil, nil
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = input.Position
            startPos  = target.Position
        end
    end)
    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Gradient helper
local function makeGradient(parent, colorSeq, rotation)
    local g = Instance.new("UIGradient")
    g.Color    = colorSeq
    g.Rotation = rotation or 90
    g.Parent   = parent
    return g
end

-- Accent gradient sequence
local function accentGradient()
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0,   T.AccentA),
        ColorSequenceKeypoint.new(0.5, T.Accent),
        ColorSequenceKeypoint.new(1,   T.AccentB),
    })
end

-- ─────────────────────────────────────────────
--  SCREEN GUI ROOT
-- ─────────────────────────────────────────────
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name            = "SKUI_Hub"
ScreenGui.ResetOnSpawn    = false
ScreenGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder    = 999
ScreenGui.IgnoreGuiInset  = true

-- Try to parent to CoreGui (exploits), else PlayerGui
local ok = pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not ok then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- ─────────────────────────────────────────────
--  WINDOW CONSTRUCTOR
-- ─────────────────────────────────────────────
function SKUI:CreateWindow(cfg)
    cfg = cfg or {}
    local windowTitle  = cfg.Title    or "SKUI Hub"
    local windowImage  = cfg.Image    or ""
    local windowAuthor = cfg.Author   or ""
    local isDraggable  = cfg.Draggable ~= false

    local Win = {}
    Win._tabs       = {}
    Win._activeTab  = nil
    Win._allElements = {}  -- for search

    -- ── SHADOW LAYER ──────────────────────────
    local Shadow = frame(ScreenGui, UDim2.new(0, 684, 0, 420), UDim2.new(0.5, -342, 0.5, -210), T.Shadow, 0.5)
    Shadow.Name = "SKUI_Shadow"
    Shadow.ZIndex = 1
    makeCorner(Shadow, 18)

    -- ── MAIN WINDOW ───────────────────────────
    local Main = frame(ScreenGui, UDim2.new(0, 680, 0, 416), UDim2.new(0.5, -340, 0.5, -208), T.BG, 0)
    Main.Name    = "SKUI_Main"
    Main.ZIndex  = 5
    makeCorner(Main, 16)
    makeBorder(Main, T.GlassBorder, 1)

    -- subtle inner glow gradient
    local bgGrad = Instance.new("UIGradient")
    bgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(18, 22, 36)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(10, 12, 20)),
    })
    bgGrad.Rotation = 135
    bgGrad.Parent   = Main

    -- ── TITLE BAR ─────────────────────────────
    local TitleBar = frame(Main, UDim2.new(1, 0, 0, 46), UDim2.new(0,0,0,0), T.Glass, 0)
    TitleBar.Name   = "TitleBar"
    TitleBar.ZIndex = 6
    makeCorner(TitleBar, 16)

    -- bottom of titlebar flush
    local TitleBarBottom = frame(TitleBar, UDim2.new(1,0,0,10), UDim2.new(0,0,1,-10), T.Glass, 0)
    TitleBarBottom.ZIndex = 6

    -- accent line under title bar
    local TitleLine = frame(Main, UDim2.new(1,0,0,1), UDim2.new(0,0,0,46), T.AccentA, 0)
    TitleLine.Name  = "TitleLine"
    TitleLine.ZIndex = 6
    makeGradient(TitleLine, accentGradient(), 90)

    -- window icon
    local WinIcon
    if windowImage ~= "" and windowImage ~= "ID" then
        WinIcon = Instance.new("ImageLabel")
        WinIcon.Image               = "rbxassetid://" .. windowImage
        WinIcon.Size                = UDim2.new(0, 22, 0, 22)
        WinIcon.Position            = UDim2.new(0, 12, 0.5, -11)
        WinIcon.BackgroundTransparency = 1
        WinIcon.ZIndex              = 7
        WinIcon.Parent              = TitleBar
        makeCorner(WinIcon, 6)
    end

    -- title text
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text          = windowTitle
    TitleLabel.TextSize      = 15
    TitleLabel.Font          = Enum.Font.GothamBold
    TitleLabel.TextColor3    = T.TextPrimary
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position      = UDim2.new(0, WinIcon and 40 or 14, 0, 0)
    TitleLabel.Size          = UDim2.new(0, 200, 1, 0)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex        = 7
    TitleLabel.Parent        = TitleBar

    -- author text
    local AuthorLabel = Instance.new("TextLabel")
    AuthorLabel.Text          = windowAuthor
    AuthorLabel.TextSize      = 11
    AuthorLabel.Font          = Enum.Font.Gotham
    AuthorLabel.TextColor3    = T.TextMuted
    AuthorLabel.BackgroundTransparency = 1
    AuthorLabel.Position      = UDim2.new(0, WinIcon and 40 or 14, 0.5, 2)
    AuthorLabel.Size          = UDim2.new(0, 300, 0, 14)
    AuthorLabel.TextXAlignment = Enum.TextXAlignment.Left
    AuthorLabel.ZIndex        = 7
    AuthorLabel.Parent        = TitleBar

    -- close button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size                = UDim2.new(0, 28, 0, 28)
    CloseBtn.Position            = UDim2.new(1, -38, 0.5, -14)
    CloseBtn.BackgroundColor3    = T.Danger
    CloseBtn.BackgroundTransparency = 0.3
    CloseBtn.Text                = ""
    CloseBtn.ZIndex              = 8
    CloseBtn.Parent              = TitleBar
    makeCorner(CloseBtn, 8)
    makeBorder(CloseBtn, Color3.fromRGB(255,60,80), 1)

    -- X icon on close button
    local CloseIcon = Instance.new("TextLabel")
    CloseIcon.Text          = "✕"
    CloseIcon.TextSize      = 13
    CloseIcon.Font          = Enum.Font.GothamBold
    CloseIcon.TextColor3    = T.White
    CloseIcon.BackgroundTransparency = 1
    CloseIcon.Size          = UDim2.new(1,0,1,0)
    CloseIcon.TextXAlignment = Enum.TextXAlignment.Center
    CloseIcon.ZIndex        = 9
    CloseIcon.Parent        = CloseBtn

    -- minimize button (title bar)
    local MinBtn = Instance.new("TextButton")
    MinBtn.Size                = UDim2.new(0, 28, 0, 28)
    MinBtn.Position            = UDim2.new(1, -72, 0.5, -14)
    MinBtn.BackgroundColor3    = T.GlassLight
    MinBtn.BackgroundTransparency = 0.2
    MinBtn.Text                = ""
    MinBtn.ZIndex              = 8
    MinBtn.Parent              = TitleBar
    makeCorner(MinBtn, 8)
    makeBorder(MinBtn, T.GlassBorder, 1)

    local MinIcon = Instance.new("TextLabel")
    MinIcon.Text          = "—"
    MinIcon.TextSize      = 13
    MinIcon.Font          = Enum.Font.GothamBold
    MinIcon.TextColor3    = T.TextSecondary
    MinIcon.BackgroundTransparency = 1
    MinIcon.Size          = UDim2.new(1,0,1,0)
    MinIcon.TextXAlignment = Enum.TextXAlignment.Center
    MinIcon.ZIndex        = 9
    MinIcon.Parent        = MinBtn

    -- ── BODY (below title bar) ─────────────────
    local Body = frame(Main, UDim2.new(1,0,1,-47), UDim2.new(0,0,0,47), T.BG, 1)
    Body.Name   = "Body"
    Body.ZIndex = 6

    -- LEFT SIDEBAR ──────────────────────────────
    local Sidebar = frame(Body, UDim2.new(0, 160, 1, 0), UDim2.new(0,0,0,0), T.Sidebar, 0)
    Sidebar.Name   = "Sidebar"
    Sidebar.ZIndex = 7
    makeCorner(Sidebar, 12)

    local SidebarRight = frame(Sidebar, UDim2.new(0, 10, 1, 0), UDim2.new(1,-10,0,0), T.Sidebar, 0)
    SidebarRight.ZIndex = 7 -- flush right edge

    local SidebarBorderRight = frame(Sidebar, UDim2.new(0, 1, 1, -16), UDim2.new(1,-1,0,8), T.SidebarBorder, 0)
    SidebarBorderRight.ZIndex = 7

    -- Search bar in sidebar header
    local SearchOuter = frame(Sidebar, UDim2.new(1,-16,0,30), UDim2.new(0,8,0,8), T.SearchBG, 0)
    SearchOuter.Name  = "SearchOuter"
    SearchOuter.ZIndex = 8
    makeCorner(SearchOuter, 8)
    makeBorder(SearchOuter, T.ControlBorder, 1)

    -- search magnifier icon
    local SearchIconLabel = Instance.new("TextLabel")
    SearchIconLabel.Text          = "⌕"
    SearchIconLabel.TextSize      = 14
    SearchIconLabel.Font          = Enum.Font.Gotham
    SearchIconLabel.TextColor3    = T.TextMuted
    SearchIconLabel.BackgroundTransparency = 1
    SearchIconLabel.Size          = UDim2.new(0, 22, 1, 0)
    SearchIconLabel.Position      = UDim2.new(0, 4, 0, 0)
    SearchIconLabel.TextXAlignment = Enum.TextXAlignment.Center
    SearchIconLabel.ZIndex        = 9
    SearchIconLabel.Parent        = SearchOuter

    local SearchBox = Instance.new("TextBox")
    SearchBox.Text               = ""
    SearchBox.PlaceholderText    = "Search..."
    SearchBox.TextSize           = 11
    SearchBox.Font               = Enum.Font.Gotham
    SearchBox.TextColor3         = T.TextPrimary
    SearchBox.PlaceholderColor3  = T.TextMuted
    SearchBox.BackgroundTransparency = 1
    SearchBox.Size               = UDim2.new(1,-28,1,0)
    SearchBox.Position           = UDim2.new(0,26,0,0)
    SearchBox.TextXAlignment     = Enum.TextXAlignment.Left
    SearchBox.ClearTextOnFocus   = false
    SearchBox.ZIndex             = 9
    SearchBox.Parent             = SearchOuter

    -- divider below search
    local SearchDiv = frame(Sidebar, UDim2.new(1,-16,0,1), UDim2.new(0,8,0,44), T.SidebarBorder, 0)
    SearchDiv.ZIndex = 8

    -- "TABS" label
    local TabsHeader = Instance.new("TextLabel")
    TabsHeader.Text          = "NAVIGATION"
    TabsHeader.TextSize      = 9
    TabsHeader.Font          = Enum.Font.GothamBold
    TabsHeader.TextColor3    = T.TextMuted
    TabsHeader.BackgroundTransparency = 1
    TabsHeader.Size          = UDim2.new(1,-16,0,16)
    TabsHeader.Position      = UDim2.new(0,8,0,52)
    TabsHeader.TextXAlignment = Enum.TextXAlignment.Left
    TabsHeader.ZIndex        = 8
    TabsHeader.Parent        = Sidebar

    -- Tab scroll container
    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Size                = UDim2.new(1,-4,1,-74)
    TabScroll.Position            = UDim2.new(0,4,0,72)
    TabScroll.BackgroundTransparency = 1
    TabScroll.BorderSizePixel     = 0
    TabScroll.ScrollBarThickness  = 2
    TabScroll.ScrollBarImageColor3 = T.Accent
    TabScroll.CanvasSize          = UDim2.new(0,0,0,0)
    TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabScroll.ZIndex              = 8
    TabScroll.Parent              = Sidebar

    local TabList = Instance.new("Frame")
    TabList.Size              = UDim2.new(1,0,0,0)
    TabList.AutomaticSize     = Enum.AutomaticSize.Y
    TabList.BackgroundTransparency = 1
    TabList.ZIndex            = 8
    TabList.Parent            = TabScroll
    makeListLayout(TabList, Enum.FillDirection.Vertical, 3)
    makePadding(TabList, 2, 2, 4, 4)

    -- RIGHT PANEL ───────────────────────────────
    local RightPanel = frame(Body, UDim2.new(1,-168,1,-8), UDim2.new(0,164,0,4), T.BG, 1)
    RightPanel.Name   = "RightPanel"
    RightPanel.ZIndex = 7

    local ElementScroll = Instance.new("ScrollingFrame")
    ElementScroll.Size                = UDim2.new(1,0,1,0)
    ElementScroll.BackgroundTransparency = 1
    ElementScroll.BorderSizePixel     = 0
    ElementScroll.ScrollBarThickness  = 3
    ElementScroll.ScrollBarImageColor3 = T.Accent
    ElementScroll.CanvasSize          = UDim2.new(0,0,0,0)
    ElementScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ElementScroll.ZIndex              = 8
    ElementScroll.Parent              = RightPanel

    -- Content pages container
    local PagesFrame = frame(ElementScroll, UDim2.new(1,0,0,0), UDim2.new(0,0,0,0), T.BG, 1)
    PagesFrame.Name          = "PagesFrame"
    PagesFrame.AutomaticSize = Enum.AutomaticSize.Y
    PagesFrame.ZIndex        = 8

    -- ── DRAGGABLE ─────────────────────────────
    if isDraggable then
        makeDraggable(TitleBar, Main)
        -- sync shadow
        RunService.RenderStepped:Connect(function()
            Shadow.Position = UDim2.new(
                Main.Position.X.Scale,
                Main.Position.X.Offset + 4,
                Main.Position.Y.Scale,
                Main.Position.Y.Offset + 6
            )
        end)
    end

    -- ── MINIMIZE / CLOSE ──────────────────────
    local isMinimized = false

    MinBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        tween(Body, { Size = isMinimized and UDim2.new(1,0,0,0) or UDim2.new(1,0,1,-47) }, 0.25)
        tween(Main, { Size = isMinimized and UDim2.new(0,680,0,47) or UDim2.new(0,680,0,416) }, 0.25)
        tween(Shadow, { Size = isMinimized and UDim2.new(0,684,0,51) or UDim2.new(0,684,0,420) }, 0.25)
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        tween(Main, { Size = UDim2.new(0,680,0,0), BackgroundTransparency = 1 }, 0.2)
        tween(Shadow, { BackgroundTransparency = 1 }, 0.2)
        task.delay(0.25, function()
            ScreenGui:Destroy()
        end)
    end)

    -- close button hover
    CloseBtn.MouseEnter:Connect(function()
        tween(CloseBtn, { BackgroundTransparency = 0 }, 0.12)
    end)
    CloseBtn.MouseLeave:Connect(function()
        tween(CloseBtn, { BackgroundTransparency = 0.3 }, 0.12)
    end)
    MinBtn.MouseEnter:Connect(function()
        tween(MinBtn, { BackgroundColor3 = T.TabHover, BackgroundTransparency = 0 }, 0.12)
    end)
    MinBtn.MouseLeave:Connect(function()
        tween(MinBtn, { BackgroundColor3 = T.GlassLight, BackgroundTransparency = 0.2 }, 0.12)
    end)

    -- ── SEARCH LOGIC ──────────────────────────
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local query = SearchBox.Text:lower()
        for _, entry in ipairs(Win._allElements) do
            if entry.frame then
                local title = (entry.title or ""):lower()
                local visible = query == "" or title:find(query, 1, true)
                entry.frame.Visible = visible ~= nil and visible ~= false
            end
        end
        -- also filter tabs
        for _, tabEntry in ipairs(Win._tabs) do
            local title = (tabEntry.title or ""):lower()
            local vis = query == "" or title:find(query, 1, true)
            if tabEntry.btn then
                tabEntry.btn.Visible = vis ~= nil and vis ~= false
            end
        end
    end)

    -- ── INTERNAL: activate tab ────────────────
    local function activateTab(tabEntry)
        -- deactivate all
        for _, t in ipairs(Win._tabs) do
            if t.page then t.page.Visible = false end
            if t.btn then
                tween(t.btn, { BackgroundColor3 = T.Sidebar, BackgroundTransparency = 1 }, 0.15)
                if t.label then tween(t.label, { TextColor3 = T.TextSecondary }, 0.15) end
                if t.indicator then tween(t.indicator, { BackgroundTransparency = 1 }, 0.15) end
            end
        end
        -- activate chosen
        if tabEntry.page then tabEntry.page.Visible = true end
        if tabEntry.btn then
            tween(tabEntry.btn, { BackgroundColor3 = T.TabActive, BackgroundTransparency = 0 }, 0.15)
            if tabEntry.label then tween(tabEntry.label, { TextColor3 = T.TextAccent }, 0.15) end
            if tabEntry.indicator then tween(tabEntry.indicator, { BackgroundTransparency = 0 }, 0.15) end
        end
        Win._activeTab = tabEntry
        ElementScroll.CanvasPosition = Vector2.new(0, 0)
    end

    -- ── CREATE TAB ────────────────────────────
    function Win:CreateTab(title, tabIcon)
        local tabEntry = { title = title, elements = {} }

        -- sidebar button
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size                = UDim2.new(1,0,0,32)
        TabBtn.BackgroundColor3    = T.Sidebar
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text                = ""
        TabBtn.ZIndex              = 9
        TabBtn.Parent              = TabList
        makeCorner(TabBtn, 8)

        -- active indicator bar
        local Indicator = frame(TabBtn, UDim2.new(0,3,0,18), UDim2.new(0,0,0.5,-9), T.AccentA, 0)
        Indicator.ZIndex = 10
        makeCorner(Indicator, 2)
        makeGradient(Indicator, accentGradient(), 180)
        tween(Indicator, { BackgroundTransparency = 1 }, 0)

        -- tab icon
        if tabIcon and tabIcon ~= "" and tabIcon ~= "ID" then
            local tabImg = Instance.new("ImageLabel")
            tabImg.Image               = "rbxassetid://" .. tabIcon
            tabImg.Size                = UDim2.new(0,16,0,16)
            tabImg.Position            = UDim2.new(0,10,0.5,-8)
            tabImg.BackgroundTransparency = 1
            tabImg.ZIndex              = 10
            tabImg.Parent              = TabBtn
        end

        -- tab label
        local TabLabel = Instance.new("TextLabel")
        TabLabel.Text          = title
        TabLabel.TextSize      = 12
        TabLabel.Font          = Enum.Font.GothamSemibold
        TabLabel.TextColor3    = T.TextSecondary
        TabLabel.BackgroundTransparency = 1
        TabLabel.Size          = UDim2.new(1,-14,1,0)
        TabLabel.Position      = UDim2.new(0,10,0,0)
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.ZIndex        = 10
        TabLabel.Parent        = TabBtn

        -- page in right panel
        local Page = frame(PagesFrame, UDim2.new(1,0,0,0), UDim2.new(0,0,0,0), T.BG, 1)
        Page.AutomaticSize = Enum.AutomaticSize.Y
        Page.Visible       = false
        Page.ZIndex        = 8

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.FillDirection       = Enum.FillDirection.Vertical
        PageLayout.Padding             = UDim.new(0, 8)
        PageLayout.SortOrder           = Enum.SortOrder.LayoutOrder
        PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        PageLayout.Parent              = Page
        makePadding(Page, 8, 8, 6, 8)

        tabEntry.btn       = TabBtn
        tabEntry.label     = TabLabel
        tabEntry.indicator = Indicator
        tabEntry.page      = Page
        table.insert(Win._tabs, tabEntry)

        -- hover
        TabBtn.MouseEnter:Connect(function()
            if Win._activeTab ~= tabEntry then
                tween(TabBtn, { BackgroundColor3 = T.TabHover, BackgroundTransparency = 0 }, 0.12)
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if Win._activeTab ~= tabEntry then
                tween(TabBtn, { BackgroundColor3 = T.Sidebar, BackgroundTransparency = 1 }, 0.12)
            end
        end)

        TabBtn.MouseButton1Click:Connect(function()
            activateTab(tabEntry)
        end)

        -- auto-activate first tab
        if #Win._tabs == 1 then
            activateTab(tabEntry)
        end

        -- ── GROUPBOX ──────────────────────────
        local Tab = {}

        function Tab:CreateGroupbox(gbTitle)
            local Gb = {}
            Gb._elements = {}

            -- Groupbox container
            local GbFrame = frame(Page, UDim2.new(1,-4,0,0), UDim2.new(0,0,0,0), T.Glass, 0)
            GbFrame.AutomaticSize = Enum.AutomaticSize.Y
            GbFrame.ZIndex        = 9
            makeCorner(GbFrame, 12)
            makeBorder(GbFrame, T.GlassBorder, 1)

            -- subtle gradient on groupbox
            local gbGrad = Instance.new("UIGradient")
            gbGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(24,28,46)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(18,22,38)),
            })
            gbGrad.Rotation = 160
            gbGrad.Parent   = GbFrame

            -- groupbox header
            local GbHeader = frame(GbFrame, UDim2.new(1,0,0,34), UDim2.new(0,0,0,0), T.GlassLight, 0)
            GbHeader.ZIndex = 10
            makeCorner(GbHeader, 12)
            local GbHeaderBottom = frame(GbHeader, UDim2.new(1,0,0,12), UDim2.new(0,0,1,-12), T.GlassLight, 0)
            GbHeaderBottom.ZIndex = 10

            -- accent dot
            local GbDot = frame(GbHeader, UDim2.new(0,4,0,4), UDim2.new(0,12,0.5,-2), T.AccentA, 0)
            GbDot.ZIndex = 11
            makeCorner(GbDot, 2)
            makeGradient(GbDot, accentGradient(), 90)

            local GbTitleLabel = Instance.new("TextLabel")
            GbTitleLabel.Text          = gbTitle or "Groupbox"
            GbTitleLabel.TextSize      = 12
            GbTitleLabel.Font          = Enum.Font.GothamBold
            GbTitleLabel.TextColor3    = T.TextPrimary
            GbTitleLabel.BackgroundTransparency = 1
            GbTitleLabel.Size          = UDim2.new(1,-24,1,0)
            GbTitleLabel.Position      = UDim2.new(0,22,0,0)
            GbTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            GbTitleLabel.ZIndex        = 11
            GbTitleLabel.Parent        = GbHeader

            -- elements container
            local GbContent = frame(GbFrame, UDim2.new(1,0,0,0), UDim2.new(0,0,0,34), T.Glass, 1)
            GbContent.AutomaticSize = Enum.AutomaticSize.Y
            GbContent.ZIndex        = 9
            makeListLayout(GbContent, Enum.FillDirection.Vertical, 6)
            makePadding(GbContent, 8, 8, 10, 10)

            -- ── BUTTON ────────────────────────
            function Gb:CreateButton(opts)
                opts = opts or {}
                local btnFrame = frame(GbContent, UDim2.new(1,0,0,32), UDim2.new(0,0,0,0), T.ControlBG, 0)
                btnFrame.ZIndex = 10
                makeCorner(btnFrame, 8)
                makeBorder(btnFrame, T.ControlBorder, 1)

                local btnGrad = Instance.new("UIGradient")
                btnGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(30,36,58)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(18,22,38)),
                })
                btnGrad.Rotation = 90
                btnGrad.Parent   = btnFrame

                local Btn = Instance.new("TextButton")
                Btn.Size                = UDim2.new(1,0,1,0)
                Btn.BackgroundTransparency = 1
                Btn.Text                = ""
                Btn.ZIndex              = 11
                Btn.Parent              = btnFrame

                local BtnLabel = Instance.new("TextLabel")
                BtnLabel.Text          = opts.Title or "Button"
                BtnLabel.TextSize      = 12
                BtnLabel.Font          = Enum.Font.GothamSemibold
                BtnLabel.TextColor3    = T.TextPrimary
                BtnLabel.BackgroundTransparency = 1
                BtnLabel.Size          = UDim2.new(1,-16,1,0)
                BtnLabel.Position      = UDim2.new(0,12,0,0)
                BtnLabel.TextXAlignment = Enum.TextXAlignment.Left
                BtnLabel.ZIndex        = 11
                BtnLabel.Parent        = Btn

                -- chevron icon
                local BtnChevron = Instance.new("TextLabel")
                BtnChevron.Text          = "›"
                BtnChevron.TextSize      = 16
                BtnChevron.Font          = Enum.Font.GothamBold
                BtnChevron.TextColor3    = T.TextMuted
                BtnChevron.BackgroundTransparency = 1
                BtnChevron.Size          = UDim2.new(0,16,1,0)
                BtnChevron.Position      = UDim2.new(1,-20,0,0)
                BtnChevron.TextXAlignment = Enum.TextXAlignment.Center
                BtnChevron.ZIndex        = 11
                BtnChevron.Parent        = Btn

                -- hover / click
                Btn.MouseEnter:Connect(function()
                    tween(btnFrame, { BackgroundColor3 = T.ControlHover, BackgroundTransparency = 0 }, 0.12)
                    tween(BtnChevron, { TextColor3 = T.Accent }, 0.12)
                end)
                Btn.MouseLeave:Connect(function()
                    tween(btnFrame, { BackgroundColor3 = T.ControlBG, BackgroundTransparency = 0 }, 0.12)
                    tween(BtnChevron, { TextColor3 = T.TextMuted }, 0.12)
                end)
                Btn.MouseButton1Down:Connect(function()
                    tween(btnFrame, { BackgroundColor3 = T.TabActive }, 0.08)
                    tween(BtnLabel, { TextColor3 = T.TextAccent }, 0.08)
                end)
                Btn.MouseButton1Up:Connect(function()
                    tween(btnFrame, { BackgroundColor3 = T.ControlHover }, 0.1)
                    tween(BtnLabel, { TextColor3 = T.TextPrimary }, 0.1)
                end)

                if not opts.Locked then
                    Btn.MouseButton1Click:Connect(function()
                        if opts.Callback then
                            pcall(opts.Callback)
                        end
                    end)
                end

                table.insert(Win._allElements, { title = opts.Title or "Button", frame = btnFrame })
                return {}
            end

            -- ── TOGGLE ────────────────────────
            function Gb:CreateToggle(opts)
                opts = opts or {}
                local togState = opts.Value == true

                local togRow = frame(GbContent, UDim2.new(1,0,0,0), UDim2.new(0,0,0,0), T.Glass, 1)
                togRow.AutomaticSize = Enum.AutomaticSize.Y
                togRow.ZIndex        = 10

                local togLeft = frame(togRow, UDim2.new(1,-54,0,0), UDim2.new(0,0,0,0), T.Glass, 1)
                togLeft.AutomaticSize = Enum.AutomaticSize.Y
                togLeft.ZIndex        = 10

                local TogTitle = Instance.new("TextLabel")
                TogTitle.Text          = opts.Title or "Toggle"
                TogTitle.TextSize      = 12
                TogTitle.Font          = Enum.Font.GothamSemibold
                TogTitle.TextColor3    = T.TextPrimary
                TogTitle.BackgroundTransparency = 1
                TogTitle.Size          = UDim2.new(1,0,0,20)
                TogTitle.ZIndex        = 11
                TogTitle.Parent        = togLeft

                if opts.Desc and opts.Desc ~= "" then
                    local TogDesc = Instance.new("TextLabel")
                    TogDesc.Text          = opts.Desc
                    TogDesc.TextSize      = 10
                    TogDesc.Font          = Enum.Font.Gotham
                    TogDesc.TextColor3    = T.TextMuted
                    TogDesc.BackgroundTransparency = 1
                    TogDesc.Size          = UDim2.new(1,0,0,14)
                    TogDesc.Position      = UDim2.new(0,0,0,20)
                    TogDesc.TextWrapped   = true
                    TogDesc.ZIndex        = 11
                    TogDesc.Parent        = togLeft

                    togRow.Size = UDim2.new(1,0,0,36)
                    togLeft.Size = UDim2.new(1,-54,0,36)
                else
                    togRow.Size = UDim2.new(1,0,0,22)
                    togLeft.Size = UDim2.new(1,-54,0,22)
                end

                -- track
                local TogTrack = frame(togRow, UDim2.new(0,40,0,22), UDim2.new(1,-44,0.5,-11), togState and T.ToggleOn or T.ToggleOff, 0)
                TogTrack.ZIndex = 11
                makeCorner(TogTrack, 11)
                makeBorder(TogTrack, togState and T.Accent or T.ControlBorder, 1)

                if togState then
                    makeGradient(TogTrack, accentGradient(), 90)
                end
                local togGrad = TogTrack:FindFirstChildOfClass("UIGradient")

                -- knob
                local TogKnob = frame(TogTrack, UDim2.new(0,16,0,16), togState and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8), T.ToggleKnob, 0)
                TogKnob.ZIndex = 12
                makeCorner(TogKnob, 8)

                local function setToggle(state)
                    togState = state
                    if state then
                        tween(TogTrack, { BackgroundColor3 = T.ToggleOn }, 0.18)
                        local s = Instance.new("UIStroke")
                        s.Color = T.Accent
                        s.Thickness = 1
                        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                        s.Parent = TogTrack
                        if not togGrad then
                            makeGradient(TogTrack, accentGradient(), 90)
                        end
                        tween(TogKnob, { Position = UDim2.new(1,-19,0.5,-8) }, 0.18)
                    else
                        tween(TogTrack, { BackgroundColor3 = T.ToggleOff }, 0.18)
                        local s = TogTrack:FindFirstChildOfClass("UIStroke")
                        if s then s:Destroy() end
                        makeBorder(TogTrack, T.ControlBorder, 1)
                        local g = TogTrack:FindFirstChildOfClass("UIGradient")
                        if g then g:Destroy() end
                        tween(TogKnob, { Position = UDim2.new(0,3,0.5,-8) }, 0.18)
                    end
                    if opts.Callback then pcall(opts.Callback, state) end
                end

                local TogBtn = Instance.new("TextButton")
                TogBtn.Size               = UDim2.new(1,0,1,0)
                TogBtn.BackgroundTransparency = 1
                TogBtn.Text               = ""
                TogBtn.ZIndex             = 13
                TogBtn.Parent             = togRow
                TogBtn.MouseButton1Click:Connect(function()
                    setToggle(not togState)
                end)

                table.insert(Win._allElements, { title = opts.Title or "Toggle", frame = togRow })
                return { SetValue = setToggle }
            end

            -- ── SLIDER ────────────────────────
            function Gb:CreateSlider(opts)
                opts = opts or {}
                local vOpts   = opts.Value or {}
                local minV    = vOpts.Min     or 0
                local maxV    = vOpts.Max     or 100
                local defV    = vOpts.Default or minV
                local stepV   = opts.Step     or 1
                local curVal  = defV

                local sliderRow = frame(GbContent, UDim2.new(1,0,0,46), UDim2.new(0,0,0,0), T.Glass, 1)
                sliderRow.ZIndex = 10

                local SlTitle = Instance.new("TextLabel")
                SlTitle.Text          = opts.Title or "Slider"
                SlTitle.TextSize      = 12
                SlTitle.Font          = Enum.Font.GothamSemibold
                SlTitle.TextColor3    = T.TextPrimary
                SlTitle.BackgroundTransparency = 1
                SlTitle.Size          = UDim2.new(1,-50,0,18)
                SlTitle.Position      = UDim2.new(0,0,0,0)
                SlTitle.ZIndex        = 11
                SlTitle.Parent        = sliderRow

                local SlVal = Instance.new("TextLabel")
                SlVal.Text          = tostring(curVal)
                SlVal.TextSize      = 11
                SlVal.Font          = Enum.Font.GothamBold
                SlVal.TextColor3    = T.TextAccent
                SlVal.BackgroundTransparency = 1
                SlVal.Size          = UDim2.new(0,48,0,18)
                SlVal.Position      = UDim2.new(1,-48,0,0)
                SlVal.TextXAlignment = Enum.TextXAlignment.Right
                SlVal.ZIndex        = 11
                SlVal.Parent        = sliderRow

                -- track background
                local SlTrack = frame(sliderRow, UDim2.new(1,0,0,6), UDim2.new(0,0,0,26), T.SliderTrack, 0)
                SlTrack.ZIndex = 11
                makeCorner(SlTrack, 3)
                makeBorder(SlTrack, T.ControlBorder, 1)

                -- fill
                local pct = (curVal - minV) / (maxV - minV)
                local SlFill = frame(SlTrack, UDim2.new(pct, 0, 1, 0), UDim2.new(0,0,0,0), T.SliderFill, 0)
                SlFill.ZIndex = 12
                makeCorner(SlFill, 3)
                makeGradient(SlFill, accentGradient(), 90)

                -- knob
                local SlKnob = frame(SlTrack, UDim2.new(0,14,0,14), UDim2.new(pct,-7,0.5,-7), T.SliderKnob, 0)
                SlKnob.ZIndex = 13
                makeCorner(SlKnob, 7)
                makeBorder(SlKnob, T.Accent, 2)

                -- interaction
                local slDragging = false

                local function updateSlider(inputX)
                    local abs = SlTrack.AbsolutePosition.X
                    local w   = SlTrack.AbsoluteSize.X
                    local t   = math.clamp((inputX - abs) / w, 0, 1)
                    local raw = minV + t * (maxV - minV)
                    local stepped = math.round(raw / stepV) * stepV
                    curVal = math.clamp(stepped, minV, maxV)
                    local p = (curVal - minV) / (maxV - minV)
                    SlFill.Size     = UDim2.new(p, 0, 1, 0)
                    SlKnob.Position = UDim2.new(p, -7, 0.5, -7)
                    SlVal.Text      = tostring(curVal)
                    if opts.Callback then pcall(opts.Callback, curVal) end
                end

                local SlBtn = Instance.new("TextButton")
                SlBtn.Size               = UDim2.new(1,0,0,28)
                SlBtn.Position           = UDim2.new(0,0,0,20)
                SlBtn.BackgroundTransparency = 1
                SlBtn.Text               = ""
                SlBtn.ZIndex             = 14
                SlBtn.Parent             = sliderRow

                SlBtn.MouseButton1Down:Connect(function(x)
                    slDragging = true
                    updateSlider(x)
                end)
                SlBtn.MouseButton1Up:Connect(function()
                    slDragging = false
                end)
                SlBtn.MouseMoved:Connect(function(x)
                    if slDragging then updateSlider(x) end
                end)
                UserInputService.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        slDragging = false
                    end
                end)
                UserInputService.InputChanged:Connect(function(inp)
                    if slDragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
                        updateSlider(inp.Position.X)
                    end
                end)

                table.insert(Win._allElements, { title = opts.Title or "Slider", frame = sliderRow })
                return {
                    SetValue = function(v)
                        curVal = math.clamp(v, minV, maxV)
                        local p = (curVal - minV)/(maxV - minV)
                        SlFill.Size     = UDim2.new(p,0,1,0)
                        SlKnob.Position = UDim2.new(p,-7,0.5,-7)
                        SlVal.Text      = tostring(curVal)
                    end
                }
            end

            -- ── INPUT ─────────────────────────
            function Gb:CreateInput(opts)
                opts = opts or {}

                local inputRow = frame(GbContent, UDim2.new(1,0,0,52), UDim2.new(0,0,0,0), T.Glass, 1)
                inputRow.ZIndex = 10

                local InTitle = Instance.new("TextLabel")
                InTitle.Text          = opts.Title or "Input"
                InTitle.TextSize      = 12
                InTitle.Font          = Enum.Font.GothamSemibold
                InTitle.TextColor3    = T.TextPrimary
                InTitle.BackgroundTransparency = 1
                InTitle.Size          = UDim2.new(1,0,0,18)
                InTitle.Position      = UDim2.new(0,0,0,0)
                InTitle.ZIndex        = 11
                InTitle.Parent        = inputRow

                local InBoxBg = frame(inputRow, UDim2.new(1,0,0,28), UDim2.new(0,0,0,22), T.ControlBG, 0)
                InBoxBg.ZIndex = 11
                makeCorner(InBoxBg, 7)
                makeBorder(InBoxBg, T.ControlBorder, 1)

                local InBox = Instance.new("TextBox")
                InBox.Text               = opts.Value or ""
                InBox.PlaceholderText    = opts.Placeholder or "Enter text..."
                InBox.TextSize           = 11
                InBox.Font               = Enum.Font.Gotham
                InBox.TextColor3         = T.TextPrimary
                InBox.PlaceholderColor3  = T.TextMuted
                InBox.BackgroundTransparency = 1
                InBox.Size               = UDim2.new(1,-12,1,0)
                InBox.Position           = UDim2.new(0,10,0,0)
                InBox.TextXAlignment     = Enum.TextXAlignment.Left
                InBox.ClearTextOnFocus   = false
                InBox.ZIndex             = 12
                InBox.Parent             = InBoxBg

                InBox.Focused:Connect(function()
                    tween(InBoxBg, { BackgroundColor3 = T.ControlHover }, 0.12)
                    local s = InBoxBg:FindFirstChildOfClass("UIStroke")
                    if s then tween(s, { Color = T.Accent }, 0.12) end
                end)
                InBox.FocusLost:Connect(function(enter)
                    tween(InBoxBg, { BackgroundColor3 = T.ControlBG }, 0.12)
                    local s = InBoxBg:FindFirstChildOfClass("UIStroke")
                    if s then tween(s, { Color = T.ControlBorder }, 0.12) end
                    if opts.Callback then pcall(opts.Callback, InBox.Text) end
                end)

                table.insert(Win._allElements, { title = opts.Title or "Input", frame = inputRow })
                return { GetValue = function() return InBox.Text end }
            end

            -- ── DROPDOWN ──────────────────────
            function Gb:CreateDropdown(opts)
                opts = opts or {}
                local values  = opts.Values or {}
                local curVal  = opts.Value or (values[1] or "")
                local isOpen  = false
                local DdObj   = {}

                local ddRow = frame(GbContent, UDim2.new(1,0,0,52), UDim2.new(0,0,0,0), T.Glass, 1)
                ddRow.ZIndex = 10

                local DdTitle = Instance.new("TextLabel")
                DdTitle.Text          = opts.Title or "Dropdown"
                DdTitle.TextSize      = 12
                DdTitle.Font          = Enum.Font.GothamSemibold
                DdTitle.TextColor3    = T.TextPrimary
                DdTitle.BackgroundTransparency = 1
                DdTitle.Size          = UDim2.new(1,0,0,18)
                DdTitle.ZIndex        = 11
                DdTitle.Parent        = ddRow

                local DdBtn = frame(ddRow, UDim2.new(1,0,0,28), UDim2.new(0,0,0,22), T.ControlBG, 0)
                DdBtn.ZIndex = 11
                makeCorner(DdBtn, 7)
                makeBorder(DdBtn, T.ControlBorder, 1)

                local DdValLabel = Instance.new("TextLabel")
                DdValLabel.Text          = curVal
                DdValLabel.TextSize      = 11
                DdValLabel.Font          = Enum.Font.Gotham
                DdValLabel.TextColor3    = T.TextPrimary
                DdValLabel.BackgroundTransparency = 1
                DdValLabel.Size          = UDim2.new(1,-28,1,0)
                DdValLabel.Position      = UDim2.new(0,10,0,0)
                DdValLabel.TextXAlignment = Enum.TextXAlignment.Left
                DdValLabel.ZIndex        = 12
                DdValLabel.Parent        = DdBtn

                local DdArrow = Instance.new("TextLabel")
                DdArrow.Text          = "⌄"
                DdArrow.TextSize      = 14
                DdArrow.Font          = Enum.Font.GothamBold
                DdArrow.TextColor3    = T.TextMuted
                DdArrow.BackgroundTransparency = 1
                DdArrow.Size          = UDim2.new(0,20,1,0)
                DdArrow.Position      = UDim2.new(1,-24,0,0)
                DdArrow.TextXAlignment = Enum.TextXAlignment.Center
                DdArrow.ZIndex        = 12
                DdArrow.Parent        = DdBtn

                local DdBtnClick = Instance.new("TextButton")
                DdBtnClick.Size               = UDim2.new(1,0,1,0)
                DdBtnClick.BackgroundTransparency = 1
                DdBtnClick.Text               = ""
                DdBtnClick.ZIndex             = 13
                DdBtnClick.Parent             = DdBtn

                -- ── MODAL ─────────────────────
                local function openModal()
                    if isOpen then return end
                    isOpen = true

                    tween(DdArrow, { Rotation = 180 }, 0.15)

                    -- Backdrop
                    local Backdrop = Instance.new("TextButton")
                    Backdrop.Size               = UDim2.new(1,0,1,0)
                    Backdrop.BackgroundColor3   = T.Shadow
                    Backdrop.BackgroundTransparency = 0.6
                    Backdrop.Text               = ""
                    Backdrop.ZIndex             = 50
                    Backdrop.Parent             = ScreenGui

                    -- Modal frame — centered square medium
                    local Modal = frame(ScreenGui, UDim2.new(0,240,0,0), UDim2.new(0.5,-120,0.5,-10), T.ModalBG, 0)
                    Modal.AutomaticSize = Enum.AutomaticSize.Y
                    Modal.ZIndex        = 51
                    makeCorner(Modal, 14)
                    makeBorder(Modal, T.ModalBorder, 1)

                    -- modal gradient
                    local mGrad = Instance.new("UIGradient")
                    mGrad.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(22,27,46)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(14,18,32)),
                    })
                    mGrad.Rotation = 160
                    mGrad.Parent   = Modal

                    -- scale in
                    Modal.Size = UDim2.new(0, 0, 0, 0)
                    Modal.Position = UDim2.new(0.5, 0, 0.5, 0)
                    tween(Modal, { Size = UDim2.new(0,240,0,0), Position = UDim2.new(0.5,-120,0.5,-10) }, 0.2, Enum.EasingStyle.Back)

                    -- header
                    local MHeader = frame(Modal, UDim2.new(1,0,0,38), UDim2.new(0,0,0,0), T.GlassLight, 0)
                    MHeader.ZIndex = 52
                    makeCorner(MHeader, 14)
                    local MHeaderBottom = frame(MHeader, UDim2.new(1,0,0,14), UDim2.new(0,0,1,-14), T.GlassLight, 0)
                    MHeaderBottom.ZIndex = 52
                    local MHeaderAccent = frame(MHeader, UDim2.new(1,0,0,2), UDim2.new(0,0,1,0), T.AccentA, 0)
                    MHeaderAccent.ZIndex = 53
                    makeGradient(MHeaderAccent, accentGradient(), 90)

                    local MTitle = Instance.new("TextLabel")
                    MTitle.Text          = opts.Title or "Select Option"
                    MTitle.TextSize      = 13
                    MTitle.Font          = Enum.Font.GothamBold
                    MTitle.TextColor3    = T.TextPrimary
                    MTitle.BackgroundTransparency = 1
                    MTitle.Size          = UDim2.new(1,-40,1,0)
                    MTitle.Position      = UDim2.new(0,14,0,0)
                    MTitle.TextXAlignment = Enum.TextXAlignment.Left
                    MTitle.ZIndex        = 53
                    MTitle.Parent        = MHeader

                    local MClose = Instance.new("TextButton")
                    MClose.Size               = UDim2.new(0,24,0,24)
                    MClose.Position           = UDim2.new(1,-30,0.5,-12)
                    MClose.BackgroundColor3   = T.GlassLight
                    MClose.BackgroundTransparency = 0
                    MClose.Text               = "✕"
                    MClose.TextSize           = 11
                    MClose.Font               = Enum.Font.GothamBold
                    MClose.TextColor3         = T.TextMuted
                    MClose.ZIndex             = 54
                    MClose.Parent             = MHeader
                    makeCorner(MClose, 6)

                    -- scroll content
                    local MScrollMax = math.min(#values * 36 + 8, 200)
                    local MScroll = Instance.new("ScrollingFrame")
                    MScroll.Size                = UDim2.new(1,0,0,MScrollMax)
                    MScroll.Position            = UDim2.new(0,0,0,40)
                    MScroll.BackgroundTransparency = 1
                    MScroll.BorderSizePixel     = 0
                    MScroll.ScrollBarThickness  = 3
                    MScroll.ScrollBarImageColor3 = T.Accent
                    MScroll.CanvasSize          = UDim2.new(0,0,0,#values*36+8)
                    MScroll.ZIndex              = 52
                    MScroll.Parent              = Modal

                    local MList = frame(MScroll, UDim2.new(1,0,0,#values*36+8), UDim2.new(0,0,0,0), T.ModalBG, 1)
                    MList.ZIndex = 52
                    makeListLayout(MList, Enum.FillDirection.Vertical, 3)
                    makePadding(MList, 4, 4, 8, 8)

                    -- ensure modal accounts for scroll height
                    local function closeModal()
                        isOpen = false
                        tween(DdArrow, { Rotation = 0 }, 0.15)
                        tween(Modal, { Size = UDim2.new(0,240,0,0), Position = UDim2.new(0.5,-120,0.5, 0) }, 0.15)
                        task.delay(0.16, function()
                            Backdrop:Destroy()
                            Modal:Destroy()
                        end)
                    end

                    for _, v in ipairs(values) do
                        local ItemBtn = frame(MList, UDim2.new(1,0,0,32), UDim2.new(0,0,0,0), v == curVal and T.ModalSelected or T.ModalItem, 0)
                        ItemBtn.ZIndex = 53
                        makeCorner(ItemBtn, 8)

                        if v == curVal then
                            local selDot = frame(ItemBtn, UDim2.new(0,4,0,4), UDim2.new(0,8,0.5,-2), T.AccentA, 0)
                            selDot.ZIndex = 54
                            makeCorner(selDot, 2)
                            makeGradient(selDot, accentGradient(), 90)
                        end

                        local ItemLabel = Instance.new("TextLabel")
                        ItemLabel.Text          = v
                        ItemLabel.TextSize      = 12
                        ItemLabel.Font          = v == curVal and Enum.Font.GothamSemibold or Enum.Font.Gotham
                        ItemLabel.TextColor3    = v == curVal and T.TextAccent or T.TextSecondary
                        ItemLabel.BackgroundTransparency = 1
                        ItemLabel.Size          = UDim2.new(1,-16,1,0)
                        ItemLabel.Position      = UDim2.new(0,16,0,0)
                        ItemLabel.TextXAlignment = Enum.TextXAlignment.Left
                        ItemLabel.ZIndex        = 54
                        ItemLabel.Parent        = ItemBtn

                        local ItemClick = Instance.new("TextButton")
                        ItemClick.Size               = UDim2.new(1,0,1,0)
                        ItemClick.BackgroundTransparency = 1
                        ItemClick.Text               = ""
                        ItemClick.ZIndex             = 55
                        ItemClick.Parent             = ItemBtn

                        ItemClick.MouseEnter:Connect(function()
                            if v ~= curVal then
                                tween(ItemBtn, { BackgroundColor3 = T.ModalHover }, 0.1)
                            end
                        end)
                        ItemClick.MouseLeave:Connect(function()
                            if v ~= curVal then
                                tween(ItemBtn, { BackgroundColor3 = T.ModalItem }, 0.1)
                            end
                        end)
                        ItemClick.MouseButton1Click:Connect(function()
                            curVal = v
                            DdValLabel.Text = v
                            if opts.Callback then pcall(opts.Callback, v) end
                            closeModal()
                        end)
                    end

                    MClose.MouseButton1Click:Connect(closeModal)
                    Backdrop.MouseButton1Click:Connect(closeModal)
                end

                DdBtnClick.MouseEnter:Connect(function()
                    tween(DdBtn, { BackgroundColor3 = T.ControlHover }, 0.12)
                end)
                DdBtnClick.MouseLeave:Connect(function()
                    tween(DdBtn, { BackgroundColor3 = T.ControlBG }, 0.12)
                end)
                DdBtnClick.MouseButton1Click:Connect(openModal)

                table.insert(Win._allElements, { title = opts.Title or "Dropdown", frame = ddRow })

                function DdObj:Refresh(newValues)
                    values = newValues
                    if not table.find(values, curVal) then
                        curVal = values[1] or ""
                        DdValLabel.Text = curVal
                    end
                end
                function DdObj:SetValue(v)
                    curVal = v
                    DdValLabel.Text = v
                end

                return DdObj
            end

            table.insert(Win._allElements, { title = gbTitle or "Groupbox", frame = GbFrame })
            return Gb
        end

        return Tab
    end

    -- ── FLOATING MINIMIZE BUTTON ──────────────
    function Win:CreateMinimizeBtn(cfg2)
        cfg2 = cfg2 or {}
        local floatTitle = cfg2.Title or "Open UI"
        local floatImage = cfg2.Image or ""

        local FloatBtn = frame(ScreenGui, UDim2.new(0,120,0,36), UDim2.new(0.5,-60,0,8), T.Glass, 0)
        FloatBtn.Name    = "SKUI_FloatBtn"
        FloatBtn.ZIndex  = 20
        FloatBtn.Visible = false
        makeCorner(FloatBtn, 18)
        makeBorder(FloatBtn, T.GlassBorder, 1)
        makeGradient(FloatBtn, ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(22,28,48)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(14,18,32)),
        }), 90)

        -- accent top border
        local FABTop = frame(FloatBtn, UDim2.new(1,0,0,2), UDim2.new(0,0,0,0), T.AccentA, 0)
        FABTop.ZIndex = 21
        makeCorner(FABTop, 18)
        makeGradient(FABTop, accentGradient(), 90)
        local FABTopBottom = frame(FABTop, UDim2.new(1,0,0,8), UDim2.new(0,0,1,-8), T.AccentA, 0)

        if floatImage ~= "" and floatImage ~= "ID" then
            local fImg = Instance.new("ImageLabel")
            fImg.Image               = "rbxassetid://" .. floatImage
            fImg.Size                = UDim2.new(0,18,0,18)
            fImg.Position            = UDim2.new(0,8,0.5,-9)
            fImg.BackgroundTransparency = 1
            fImg.ZIndex              = 22
            fImg.Parent              = FloatBtn
            makeCorner(fImg, 4)
        end

        local FBtnLabel = Instance.new("TextLabel")
        FBtnLabel.Text          = floatTitle
        FBtnLabel.TextSize      = 11
        FBtnLabel.Font          = Enum.Font.GothamBold
        FBtnLabel.TextColor3    = T.TextAccent
        FBtnLabel.BackgroundTransparency = 1
        FBtnLabel.Size          = UDim2.new(1,-10,1,0)
        FBtnLabel.Position      = UDim2.new(0, floatImage ~= "" and floatImage ~= "ID" and 30 or 10, 0, 0)
        FBtnLabel.TextXAlignment = Enum.TextXAlignment.Left
        FBtnLabel.ZIndex        = 22
        FBtnLabel.Parent        = FloatBtn

        makeDraggable(FloatBtn, FloatBtn)

        local FClick = Instance.new("TextButton")
        FClick.Size               = UDim2.new(1,0,1,0)
        FClick.BackgroundTransparency = 1
        FClick.Text               = ""
        FClick.ZIndex             = 23
        FClick.Parent             = FloatBtn

        FClick.MouseEnter:Connect(function()
            tween(FloatBtn, { BackgroundTransparency = 0 }, 0.12)
        end)
        FClick.MouseLeave:Connect(function()
            tween(FloatBtn, { BackgroundTransparency = 0 }, 0.12)
        end)

        -- hook minimize to show/hide float btn
        local _origMinClick = MinBtn.MouseButton1Click
        MinBtn.MouseButton1Click:Connect(function()
            -- isMinimized is toggled by existing handler above
            task.defer(function()
                local hidden = Main.Size.Y.Offset <= 60
                FloatBtn.Visible = hidden
                Main.Visible     = not hidden
            end)
        end)

        FClick.MouseButton1Click:Connect(function()
            FloatBtn.Visible = false
            Main.Visible     = true
            tween(Main, { Size = UDim2.new(0,680,0,416) }, 0.25)
            tween(Body, { Size = UDim2.new(1,0,1,-47) }, 0.25)
            isMinimized = false
        end)

        return {}
    end

    return Win
end

-- ─────────────────────────────────────────────
--  USAGE EXAMPLE (Comment out if using as lib)
-- ─────────────────────────────────────────────
--[[

local Window = SKUI:CreateWindow({
    Title     = "My Super Hub",
    Image     = "ID",
    Author    = "by .ftgs and .ftgs",
    Draggable = true
})

local MinimizeBtn = Window:CreateMinimizeBtn({
    Title = "Open UI",
    Image = "ID"
})

local MainTab = Window:CreateTab("Main Menu")
local Groupbox = MainTab:CreateGroupbox("All Features")

Groupbox:CreateButton({
    Title  = "Button",
    Locked = false,
    Callback = function()
        print("Button clicked")
    end
})

local Dropdown = Groupbox:CreateDropdown({
    Title    = "Dropdown",
    Values   = { "A", "B", "C" },
    Value    = "A",
    Callback = function(option)
        print("Category selected: " .. option)
    end
})

Dropdown:Refresh({ "A", "B", "C", "D" })

Groupbox:CreateToggle({
    Title    = "Toggle",
    Desc     = "Toggle Description",
    Value    = false,
    Callback = function(state)
        print("Toggle Activated: " .. tostring(state))
    end
})

Groupbox:CreateSlider({
    Title = "Slider",
    Step  = 1,
    Value = { Min = 20, Max = 120, Default = 70 },
    Callback = function(value)
        print("Slider value: " .. tostring(value))
    end
})

Groupbox:CreateInput({
    Title       = "Input",
    Value       = "Default value",
    Placeholder = "Enter text...",
    Callback    = function(input)
        print("Text entered: " .. input)
    end
})

--]]

return SKUI
