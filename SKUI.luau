--[[
    ╔══════════════════════════════════════════════╗
    ║         SKUI  —  Script Hub UI Library       ║
    ║         Glass Theme · Draggable · Tabbed     ║
    ╚══════════════════════════════════════════════╝

    USAGE:
        local SKUI = loadstring(game:HttpGet("YOUR_RAW_URL"))()
        local Window = SKUI:CreateWindow({ ... })
--]]

local SKUI = {}
SKUI.__index = SKUI

-- ──────────────────────────────────────────────
--  Services
-- ──────────────────────────────────────────────
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- ──────────────────────────────────────────────
--  Internal Helpers
-- ──────────────────────────────────────────────
local function Tween(obj, props, t, style, dir)
    style = style or Enum.EasingStyle.Quart
    dir   = dir   or Enum.EasingDirection.Out
    local tw = TweenService:Create(obj, TweenInfo.new(t or 0.18, style, dir), props)
    tw:Play()
    return tw
end

local function Corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

local function Stroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color        = color        or Color3.fromRGB(90, 90, 150)
    s.Thickness    = thickness    or 1.2
    s.Transparency = transparency or 0.45
    s.Parent       = parent
    return s
end

local function Padding(parent, top, bottom, left, right)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, top    or 0)
    p.PaddingBottom = UDim.new(0, bottom or 0)
    p.PaddingLeft   = UDim.new(0, left   or 0)
    p.PaddingRight  = UDim.new(0, right  or 0)
    p.Parent        = parent
    return p
end

local function ListLayout(parent, padding, dir, sort)
    local l = Instance.new("UIListLayout")
    l.Padding       = UDim.new(0, padding or 6)
    l.FillDirection = dir  or Enum.FillDirection.Vertical
    l.SortOrder     = sort or Enum.SortOrder.LayoutOrder
    l.Parent        = parent
    return l
end

-- Make any frame draggable; dragHandle defaults to frame itself
local function MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging, start, origin = false, nil, nil

    handle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            start    = inp.Position
            origin   = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local d = inp.Position - start
            frame.Position = UDim2.new(
                origin.X.Scale, origin.X.Offset + d.X,
                origin.Y.Scale, origin.Y.Offset + d.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- Glass-style Frame factory
local function GlassFrame(parent, size, pos, bgColor, bgTrans, zIndex)
    local f = Instance.new("Frame")
    f.Size                    = size    or UDim2.new(1,0,1,0)
    f.Position                = pos     or UDim2.new(0,0,0,0)
    f.BackgroundColor3        = bgColor or Color3.fromRGB(14, 14, 22)
    f.BackgroundTransparency  = bgTrans or 0.18
    f.BorderSizePixel         = 0
    f.ZIndex                  = zIndex  or 1
    f.Parent                  = parent
    return f
end

-- Icon Image helper (rbxassetid or empty)
local function Icon(parent, assetId, size, pos, zIndex)
    local img = Instance.new("ImageLabel")
    img.Size                = size  or UDim2.new(0,18,0,18)
    img.Position            = pos   or UDim2.new(0,0,0,0)
    img.BackgroundTransparency = 1
    img.Image               = (assetId and assetId ~= "") and ("rbxassetid://"..assetId) or ""
    img.ImageColor3         = Color3.fromRGB(200,200,255)
    img.ZIndex              = zIndex or 3
    img.Parent              = parent
    return img
end

-- ╔══════════════════════════════════════════════╗
-- ║               SKUI:CreateWindow             ║
-- ╚══════════════════════════════════════════════╝
function SKUI:CreateWindow(cfg)
    cfg = cfg or {}
    local Title  = cfg.Title  or "SKUI Hub"
    local Image  = cfg.Image  or ""
    local Author = cfg.Author or ""

    -- ── ScreenGui ──────────────────────────────
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name           = "SKUI_"..Title
    ScreenGui.ResetOnSpawn   = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent         = LocalPlayer:WaitForChild("PlayerGui")

    -- ── Main Window ────────────────────────────
    local Main = GlassFrame(ScreenGui,
        UDim2.new(0,550,0,340),
        UDim2.new(0.5,-330,0.5,-220),
        Color3.fromRGB(10,10,18), 0.12, 1)
    Corner(Main, 14)
    Stroke(Main, Color3.fromRGB(80,80,160), 1.5, 0.38)

    -- subtle inner glow overlay
    local Glow = Instance.new("Frame")
    Glow.Size                   = UDim2.new(1,0,1,0)
    Glow.BackgroundColor3       = Color3.fromRGB(180,180,255)
    Glow.BackgroundTransparency = 0.94
    Glow.BorderSizePixel        = 0
    Glow.ZIndex                 = 1
    Glow.Parent                 = Main
    Corner(Glow, 14)

    -- ── Top Bar ───────────────────────────────
    local TopBar = GlassFrame(Main,
        UDim2.new(1,0,0,46),
        UDim2.new(0,0,0,0),
        Color3.fromRGB(18,18,30), 0.22, 3)
    Corner(TopBar, 14)
    -- fix bottom-round of topbar
    local TBFix = Instance.new("Frame")
    TBFix.Size                   = UDim2.new(1,0,0.5,0)
    TBFix.Position               = UDim2.new(0,0,0.5,0)
    TBFix.BackgroundColor3       = Color3.fromRGB(18,18,30)
    TBFix.BackgroundTransparency = 0.22
    TBFix.BorderSizePixel        = 0
    TBFix.ZIndex                 = 3
    TBFix.Parent                 = TopBar

    -- logo
    if Image ~= "" then
        local Logo = Icon(TopBar, Image, UDim2.new(0,28,0,28),
            UDim2.new(0,12,0.5,-14), 4)
        Corner(Logo, 6)
    end

    -- title
    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Size                = UDim2.new(0,220,0,22)
    TitleLbl.Position            = UDim2.new(0, Image~="" and 48 or 14, 0, 7)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text                = Title
    TitleLbl.TextColor3          = Color3.fromRGB(240,240,255)
    TitleLbl.TextSize            = 15
    TitleLbl.Font                = Enum.Font.GothamBold
    TitleLbl.TextXAlignment      = Enum.TextXAlignment.Left
    TitleLbl.ZIndex              = 5
    TitleLbl.Parent              = TopBar

    -- author
    if Author ~= "" then
        local AuthLbl = Instance.new("TextLabel")
        AuthLbl.Size                = UDim2.new(0,260,0,14)
        AuthLbl.Position            = UDim2.new(0, Image~="" and 48 or 14, 0, 27)
        AuthLbl.BackgroundTransparency = 1
        AuthLbl.Text                = Author
        AuthLbl.TextColor3          = Color3.fromRGB(130,130,180)
        AuthLbl.TextSize            = 11
        AuthLbl.Font                = Enum.Font.Gotham
        AuthLbl.TextXAlignment      = Enum.TextXAlignment.Left
        AuthLbl.ZIndex              = 5
        AuthLbl.Parent              = TopBar
    end

    -- ── Close Button (X icon) ─────────────────
    local CloseBtn = Instance.new("ImageButton")
    CloseBtn.Size                    = UDim2.new(0,26,0,26)
    CloseBtn.Position                = UDim2.new(1,-34,0.5,-13)
    CloseBtn.BackgroundColor3        = Color3.fromRGB(210,55,55)
    CloseBtn.BackgroundTransparency  = 0.25
    CloseBtn.BorderSizePixel         = 0
    CloseBtn.Image                   = "rbxassetid://7072725341"  -- X icon
    CloseBtn.ImageColor3             = Color3.fromRGB(255,255,255)
    CloseBtn.ScaleType               = Enum.ScaleType.Fit
    CloseBtn.ZIndex                  = 6
    CloseBtn.Parent                  = TopBar
    Corner(CloseBtn, 7)

    CloseBtn.MouseEnter:Connect(function()
        Tween(CloseBtn,{BackgroundColor3=Color3.fromRGB(255,70,70)},0.12)
    end)
    CloseBtn.MouseLeave:Connect(function()
        Tween(CloseBtn,{BackgroundColor3=Color3.fromRGB(210,55,55)},0.12)
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        Tween(Main,{BackgroundTransparency=1,Size=UDim2.new(0,500,0,320)},0.22)
        task.wait(0.25)
        ScreenGui:Destroy()
    end)

    -- drag the whole window from topbar
    MakeDraggable(Main, TopBar)

    -- ══════════════════════════════════════════
    --  SEARCH BAR  (sits between topbar & panels)
    -- ══════════════════════════════════════════
    local SearchOuter = GlassFrame(Main,
        UDim2.new(0,178,0,30),
        UDim2.new(0,8,0,52),
        Color3.fromRGB(22,22,36), 0.20, 4)
    Corner(SearchOuter, 9)
    Stroke(SearchOuter, Color3.fromRGB(80,80,160), 1, 0.55)

    -- magnify icon
    local SearchIcon = Instance.new("ImageLabel")
    SearchIcon.Size               = UDim2.new(0,14,0,14)
    SearchIcon.Position           = UDim2.new(0,8,0.5,-7)
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.Image              = "rbxassetid://6031094667"
    SearchIcon.ImageColor3        = Color3.fromRGB(140,140,200)
    SearchIcon.ZIndex             = 5
    SearchIcon.Parent             = SearchOuter

    local SearchBox = Instance.new("TextBox")
    SearchBox.Size               = UDim2.new(1,-28,1,0)
    SearchBox.Position           = UDim2.new(0,26,0,0)
    SearchBox.BackgroundTransparency = 1
    SearchBox.Text               = ""
    SearchBox.PlaceholderText    = "Search elements / tabs…"
    SearchBox.TextColor3         = Color3.fromRGB(220,220,255)
    SearchBox.PlaceholderColor3  = Color3.fromRGB(90,90,130)
    SearchBox.TextSize           = 12
    SearchBox.Font               = Enum.Font.Gotham
    SearchBox.TextXAlignment     = Enum.TextXAlignment.Left
    SearchBox.ClearTextOnFocus   = false
    SearchBox.ZIndex             = 5
    SearchBox.Parent             = SearchOuter

    -- ══════════════════════════════════════════
    --  CONTENT AREA  (left tabs + right elements)
    -- ══════════════════════════════════════════
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size               = UDim2.new(1,-16,1,-96)
    ContentFrame.Position           = UDim2.new(0,8,0,88)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.BorderSizePixel    = 0
    ContentFrame.ZIndex             = 2
    ContentFrame.Parent             = Main

    -- ── Left Tab Panel ────────────────────────
    local LeftPanel = GlassFrame(ContentFrame,
        UDim2.new(0,178,1,0),
        UDim2.new(0,0,0,0),
        Color3.fromRGB(12,12,20), 0.28, 2)
    Corner(LeftPanel, 10)
    Stroke(LeftPanel, Color3.fromRGB(60,60,120), 1.2, 0.50)

    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Size               = UDim2.new(1,-6,1,-6)
    TabScroll.Position           = UDim2.new(0,3,0,3)
    TabScroll.BackgroundTransparency = 1
    TabScroll.BorderSizePixel    = 0
    TabScroll.ScrollBarThickness = 2
    TabScroll.ScrollBarImageColor3 = Color3.fromRGB(100,100,200)
    TabScroll.CanvasSize         = UDim2.new(0,0,0,0)
    TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabScroll.ZIndex             = 3
    TabScroll.Parent             = LeftPanel
    ListLayout(TabScroll, 5)
    Padding(TabScroll, 5, 5, 5, 5)

    -- ── Right Elements Panel ──────────────────
    local RightPanel = GlassFrame(ContentFrame,
        UDim2.new(1,-186,1,0),
        UDim2.new(0,186,0,0),
        Color3.fromRGB(12,12,20), 0.28, 2)
    Corner(RightPanel, 10)
    Stroke(RightPanel, Color3.fromRGB(60,60,120), 1.2, 0.50)

    local ElemScroll = Instance.new("ScrollingFrame")
    ElemScroll.Size               = UDim2.new(1,-8,1,-8)
    ElemScroll.Position           = UDim2.new(0,4,0,4)
    ElemScroll.BackgroundTransparency = 1
    ElemScroll.BorderSizePixel    = 0
    ElemScroll.ScrollBarThickness = 3
    ElemScroll.ScrollBarImageColor3 = Color3.fromRGB(100,100,200)
    ElemScroll.CanvasSize         = UDim2.new(0,0,0,0)
    ElemScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ElemScroll.ZIndex             = 3
    ElemScroll.Parent             = RightPanel
    ListLayout(ElemScroll, 8)
    Padding(ElemScroll, 6, 8, 6, 6)

    -- ══════════════════════════════════════════
    --  DROPDOWN POPUP  (centred over main frame)
    -- ══════════════════════════════════════════
    local DdPopup = GlassFrame(Main,
        UDim2.new(0,230,0,210),
        UDim2.new(0.5,-115,0.5,-105),
        Color3.fromRGB(16,16,28), 0.08, 25)
    DdPopup.Visible = false
    Corner(DdPopup, 12)
    Stroke(DdPopup, Color3.fromRGB(100,100,220), 1.5, 0.28)

    local DdPopupTitle = Instance.new("TextLabel")
    DdPopupTitle.Size               = UDim2.new(1,-36,0,36)
    DdPopupTitle.Position           = UDim2.new(0,12,0,0)
    DdPopupTitle.BackgroundTransparency = 1
    DdPopupTitle.Text               = "Select Option"
    DdPopupTitle.TextColor3         = Color3.fromRGB(200,200,255)
    DdPopupTitle.TextSize           = 13
    DdPopupTitle.Font               = Enum.Font.GothamBold
    DdPopupTitle.TextXAlignment     = Enum.TextXAlignment.Left
    DdPopupTitle.ZIndex             = 26
    DdPopupTitle.Parent             = DdPopup

    local DdPopupClose = Instance.new("ImageButton")
    DdPopupClose.Size               = UDim2.new(0,22,0,22)
    DdPopupClose.Position           = UDim2.new(1,-30,0,7)
    DdPopupClose.BackgroundColor3   = Color3.fromRGB(200,55,55)
    DdPopupClose.BackgroundTransparency = 0.25
    DdPopupClose.BorderSizePixel    = 0
    DdPopupClose.Image              = "rbxassetid://7072725341"
    DdPopupClose.ImageColor3        = Color3.fromRGB(255,255,255)
    DdPopupClose.ScaleType          = Enum.ScaleType.Fit
    DdPopupClose.ZIndex             = 27
    DdPopupClose.Parent             = DdPopup
    Corner(DdPopupClose, 6)
    DdPopupClose.MouseButton1Click:Connect(function() DdPopup.Visible = false end)

    local DdDiv = Instance.new("Frame")
    DdDiv.Size               = UDim2.new(1,-20,0,1)
    DdDiv.Position           = UDim2.new(0,10,0,40)
    DdDiv.BackgroundColor3   = Color3.fromRGB(80,80,150)
    DdDiv.BackgroundTransparency = 0.4
    DdDiv.BorderSizePixel    = 0
    DdDiv.ZIndex             = 26
    DdDiv.Parent             = DdPopup

    local DdScroll = Instance.new("ScrollingFrame")
    DdScroll.Size               = UDim2.new(1,-14,1,-50)
    DdScroll.Position           = UDim2.new(0,7,0,46)
    DdScroll.BackgroundTransparency = 1
    DdScroll.BorderSizePixel    = 0
    DdScroll.ScrollBarThickness = 3
    DdScroll.ScrollBarImageColor3 = Color3.fromRGB(100,100,220)
    DdScroll.CanvasSize         = UDim2.new(0,0,0,0)
    DdScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    DdScroll.ZIndex             = 26
    DdScroll.Parent             = DdPopup
    ListLayout(DdScroll, 4)
    Padding(DdScroll, 4, 4, 4, 4)

    -- ══════════════════════════════════════════
    --  Window Object
    -- ══════════════════════════════════════════
    local Win = {}
    Win._gui        = ScreenGui
    Win._main       = Main
    Win._tabScroll  = TabScroll
    Win._elemScroll = ElemScroll
    Win._ddPopup    = DdPopup
    Win._ddTitle    = DdPopupTitle
    Win._ddScroll   = DdScroll
    Win._tabs       = {}
    Win._allElems   = {}   -- { frame, name } for search
    Win._visible    = true

    -- Search filter
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local q = SearchBox.Text:lower():gsub("^%s+",""):gsub("%s+$","")
        for _, e in ipairs(Win._allElems) do
            if q == "" then
                e.frame.Visible = true
            else
                e.frame.Visible = e.name:lower():find(q, 1, true) ~= nil
            end
        end
        -- also show/hide tab buttons
        for _, t in ipairs(Win._tabs) do
            if q == "" then
                t.btn.Visible = true
            else
                t.btn.Visible = t.name:lower():find(q, 1, true) ~= nil
            end
        end
    end)

    -- ──────────────────────────────────────────
    --  Window:CreateMinimizeBtn
    -- ──────────────────────────────────────────
    function Win:CreateMinimizeBtn(cfg2)
        cfg2 = cfg2 or {}
        local BTitle = cfg2.Title or "Open UI"
        local BImage = cfg2.Image or ""

        local MinFrame = GlassFrame(ScreenGui,
            UDim2.new(0,138,0,42),
            UDim2.new(0,24,1,-70),
            Color3.fromRGB(18,18,32), 0.10, 50)
        Corner(MinFrame, 12)
        Stroke(MinFrame, Color3.fromRGB(100,100,220), 1.5, 0.28)

        if BImage ~= "" then
            Icon(MinFrame, BImage, UDim2.new(0,24,0,24), UDim2.new(0,9,0.5,-12), 51)
        end

        local BLbl = Instance.new("TextLabel")
        BLbl.Size               = UDim2.new(1, BImage~="" and -38 or -16, 1, 0)
        BLbl.Position           = UDim2.new(0, BImage~="" and 38 or 10, 0, 0)
        BLbl.BackgroundTransparency = 1
        BLbl.Text               = BTitle
        BLbl.TextColor3         = Color3.fromRGB(220,220,255)
        BLbl.TextSize           = 13
        BLbl.Font               = Enum.Font.GothamSemibold
        BLbl.TextXAlignment     = Enum.TextXAlignment.Left
        BLbl.ZIndex             = 51
        BLbl.Parent             = MinFrame

        MakeDraggable(MinFrame)

        -- click overlay
        local MinClickBtn = Instance.new("TextButton")
        MinClickBtn.Size               = UDim2.new(1,0,1,0)
        MinClickBtn.BackgroundTransparency = 1
        MinClickBtn.Text               = ""
        MinClickBtn.ZIndex             = 52
        MinClickBtn.Parent             = MinFrame

        MinClickBtn.MouseButton1Click:Connect(function()
            Win._visible = not Win._visible
            if Win._visible then
                Main.Visible = true
                Tween(Main, {BackgroundTransparency=0.12,Size=UDim2.new(0,660,0,440)}, 0.22)
                BLbl.Text = BTitle
            else
                Tween(Main, {BackgroundTransparency=1}, 0.18)
                task.wait(0.20)
                Main.Visible = false
                BLbl.Text = BTitle
            end
        end)

        return MinFrame
    end

    -- ──────────────────────────────────────────
    --  Window:CreateTab
    -- ──────────────────────────────────────────
    function Win:CreateTab(tabName)
        -- Tab button (left panel)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name                  = "Tab_"..tabName
        TabBtn.Size                  = UDim2.new(1,0,0,34)
        TabBtn.BackgroundColor3      = Color3.fromRGB(28,28,50)
        TabBtn.BackgroundTransparency = 0.4
        TabBtn.BorderSizePixel       = 0
        TabBtn.Text                  = tabName
        TabBtn.TextColor3            = Color3.fromRGB(150,150,195)
        TabBtn.TextSize              = 13
        TabBtn.Font                  = Enum.Font.GothamSemibold
        TabBtn.ZIndex                = 4
        TabBtn.Parent                = TabScroll
        Corner(TabBtn, 8)

        -- Tab groupbox container (right panel)
        local TabContainer = Instance.new("Frame")
        TabContainer.Name               = "TabCont_"..tabName
        TabContainer.Size               = UDim2.new(1,0,0,0)
        TabContainer.AutomaticSize      = Enum.AutomaticSize.Y
        TabContainer.BackgroundTransparency = 1
        TabContainer.BorderSizePixel    = 0
        TabContainer.Visible            = false
        TabContainer.ZIndex             = 3
        TabContainer.Parent             = ElemScroll
        ListLayout(TabContainer, 10)

        local tabEntry = { btn=TabBtn, container=TabContainer, name=tabName }
        table.insert(Win._tabs, tabEntry)

        local function Select()
            for _, t in ipairs(Win._tabs) do
                Tween(t.btn, {BackgroundColor3=Color3.fromRGB(28,28,50),
                    TextColor3=Color3.fromRGB(150,150,195)}, 0.15)
                t.btn.BackgroundTransparency = 0.4
                t.container.Visible = false
            end
            Tween(TabBtn, {BackgroundColor3=Color3.fromRGB(70,70,160),
                TextColor3=Color3.fromRGB(255,255,255)}, 0.15)
            TabBtn.BackgroundTransparency = 0.10
            TabContainer.Visible = true
        end

        TabBtn.MouseButton1Click:Connect(Select)

        -- Auto-select first tab
        if #Win._tabs == 1 then Select() end

        -- ────────────────────────────────────────
        --  Tab Object
        -- ────────────────────────────────────────
        local TabObj = {}
        TabObj._container = TabContainer
        TabObj._win       = Win

        -- ── Tab:CreateGroupbox ─────────────────
        function TabObj:CreateGroupbox(boxTitle)
            local GBox = Instance.new("Frame")
            GBox.Name               = "GBox_"..boxTitle
            GBox.Size               = UDim2.new(1,0,0,0)
            GBox.AutomaticSize      = Enum.AutomaticSize.Y
            GBox.BackgroundColor3   = Color3.fromRGB(18,18,30)
            GBox.BackgroundTransparency = 0.22
            GBox.BorderSizePixel    = 0
            GBox.ZIndex             = 4
            GBox.Parent             = TabContainer
            Corner(GBox, 10)
            Stroke(GBox, Color3.fromRGB(70,70,140), 1.2, 0.42)

            -- Group header bar
            local GHead = GlassFrame(GBox,
                UDim2.new(1,0,0,30),
                UDim2.new(0,0,0,0),
                Color3.fromRGB(30,30,54), 0.22, 5)
            Corner(GHead, 10)
            local GHFix = Instance.new("Frame")
            GHFix.Size = UDim2.new(1,0,0.5,0)
            GHFix.Position = UDim2.new(0,0,0.5,0)
            GHFix.BackgroundColor3 = Color3.fromRGB(30,30,54)
            GHFix.BackgroundTransparency = 0.22
            GHFix.BorderSizePixel = 0
            GHFix.ZIndex = 5
            GHFix.Parent = GHead

            local GHeadLbl = Instance.new("TextLabel")
            GHeadLbl.Size               = UDim2.new(1,-12,1,0)
            GHeadLbl.Position           = UDim2.new(0,10,0,0)
            GHeadLbl.BackgroundTransparency = 1
            GHeadLbl.Text               = boxTitle
            GHeadLbl.TextColor3         = Color3.fromRGB(195,195,255)
            GHeadLbl.TextSize           = 12
            GHeadLbl.Font               = Enum.Font.GothamBold
            GHeadLbl.TextXAlignment     = Enum.TextXAlignment.Left
            GHeadLbl.ZIndex             = 6
            GHeadLbl.Parent             = GHead

            -- Group content
            local GContent = Instance.new("Frame")
            GContent.Name               = "GContent"
            GContent.Size               = UDim2.new(1,0,0,0)
            GContent.Position           = UDim2.new(0,0,0,32)
            GContent.AutomaticSize      = Enum.AutomaticSize.Y
            GContent.BackgroundTransparency = 1
            GContent.BorderSizePixel    = 0
            GContent.ZIndex             = 5
            GContent.Parent             = GBox
            ListLayout(GContent, 6)
            Padding(GContent, 4, 8, 8, 8)

            local GBoxObj = {}
            GBoxObj._content = GContent
            GBoxObj._win     = Win

            local function RegElem(frame, name)
                table.insert(Win._allElems, {frame=frame, name=name})
            end

            -- ════════════════════════════════════
            --  Groupbox:CreateButton
            -- ════════════════════════════════════
            function GBoxObj:CreateButton(cfg3)
                cfg3 = cfg3 or {}
                local locked = cfg3.Locked or false
                local cb     = cfg3.Callback or function() end

                local Wrap = Instance.new("Frame")
                Wrap.Size               = UDim2.new(1,0,0,34)
                Wrap.BackgroundTransparency = 1
                Wrap.ZIndex             = 6
                Wrap.Parent             = GContent

                local Btn = Instance.new("TextButton")
                Btn.Size                = UDim2.new(1,0,1,0)
                Btn.BackgroundColor3    = locked
                    and Color3.fromRGB(30,30,48)
                    or  Color3.fromRGB(55,55,110)
                Btn.BackgroundTransparency = locked and 0.5 or 0.18
                Btn.BorderSizePixel     = 0
                Btn.Text                = cfg3.Title or "Button"
                Btn.TextColor3          = locked
                    and Color3.fromRGB(100,100,130)
                    or  Color3.fromRGB(220,220,255)
                Btn.TextSize            = 13
                Btn.Font                = Enum.Font.GothamSemibold
                Btn.ZIndex              = 7
                Btn.Parent              = Wrap
                Corner(Btn, 8)
                if not locked then
                    Stroke(Btn, Color3.fromRGB(80,80,160), 1, 0.55)
                end

                if not locked then
                    Btn.MouseEnter:Connect(function()
                        Tween(Btn,{BackgroundColor3=Color3.fromRGB(75,75,150)},0.12)
                    end)
                    Btn.MouseLeave:Connect(function()
                        Tween(Btn,{BackgroundColor3=Color3.fromRGB(55,55,110)},0.12)
                    end)
                    Btn.MouseButton1Click:Connect(function()
                        Tween(Btn,{BackgroundColor3=Color3.fromRGB(100,100,200)},0.08)
                        task.wait(0.1)
                        Tween(Btn,{BackgroundColor3=Color3.fromRGB(55,55,110)},0.12)
                        cb()
                    end)
                end

                RegElem(Wrap, cfg3.Title or "Button")
                return Btn
            end

            -- ════════════════════════════════════
            --  Groupbox:CreateToggle
            -- ════════════════════════════════════
            function GBoxObj:CreateToggle(cfg3)
                cfg3 = cfg3 or {}
                local val = cfg3.Value or false
                local cb  = cfg3.Callback or function() end
                local hasDesc = cfg3.Desc and cfg3.Desc ~= ""

                local Wrap = Instance.new("Frame")
                Wrap.Size               = UDim2.new(1,0,0, hasDesc and 46 or 34)
                Wrap.BackgroundTransparency = 1
                Wrap.ZIndex             = 6
                Wrap.Parent             = GContent

                local TLbl = Instance.new("TextLabel")
                TLbl.Size               = UDim2.new(1,-52,0,20)
                TLbl.Position           = UDim2.new(0,0,0, hasDesc and 2 or 7)
                TLbl.BackgroundTransparency = 1
                TLbl.Text               = cfg3.Title or "Toggle"
                TLbl.TextColor3         = Color3.fromRGB(210,210,240)
                TLbl.TextSize           = 13
                TLbl.Font               = Enum.Font.Gotham
                TLbl.TextXAlignment     = Enum.TextXAlignment.Left
                TLbl.ZIndex             = 7
                TLbl.Parent             = Wrap

                if hasDesc then
                    local DLbl = Instance.new("TextLabel")
                    DLbl.Size               = UDim2.new(1,-52,0,14)
                    DLbl.Position           = UDim2.new(0,0,0,22)
                    DLbl.BackgroundTransparency = 1
                    DLbl.Text               = cfg3.Desc
                    DLbl.TextColor3         = Color3.fromRGB(110,110,155)
                    DLbl.TextSize           = 10
                    DLbl.Font               = Enum.Font.Gotham
                    DLbl.TextXAlignment     = Enum.TextXAlignment.Left
                    DLbl.ZIndex             = 7
                    DLbl.Parent             = Wrap
                end

                local Track = Instance.new("Frame")
                Track.Size              = UDim2.new(0,40,0,20)
                Track.Position          = UDim2.new(1,-42,0.5,-10)
                Track.BackgroundColor3  = val
                    and Color3.fromRGB(75,120,225)
                    or  Color3.fromRGB(42,42,65)
                Track.BorderSizePixel   = 0
                Track.ZIndex            = 7
                Track.Parent            = Wrap
                Corner(Track, 20)

                local Knob = Instance.new("Frame")
                Knob.Size              = UDim2.new(0,14,0,14)
                Knob.Position          = val
                    and UDim2.new(1,-17,0.5,-7)
                    or  UDim2.new(0,3,0.5,-7)
                Knob.BackgroundColor3  = Color3.fromRGB(255,255,255)
                Knob.BorderSizePixel   = 0
                Knob.ZIndex            = 8
                Knob.Parent            = Track
                Corner(Knob, 14)

                local TBtn = Instance.new("TextButton")
                TBtn.Size              = UDim2.new(1,0,1,0)
                TBtn.BackgroundTransparency = 1
                TBtn.Text              = ""
                TBtn.ZIndex            = 9
                TBtn.Parent            = Wrap

                TBtn.MouseButton1Click:Connect(function()
                    val = not val
                    Tween(Track, {BackgroundColor3 = val
                        and Color3.fromRGB(75,120,225)
                        or  Color3.fromRGB(42,42,65)}, 0.15)
                    Tween(Knob, {Position = val
                        and UDim2.new(1,-17,0.5,-7)
                        or  UDim2.new(0,3,0.5,-7)}, 0.15)
                    cb(val)
                end)

                RegElem(Wrap, cfg3.Title or "Toggle")
                local obj = {}
                function obj:SetValue(v)
                    val = v
                    Track.BackgroundColor3 = v
                        and Color3.fromRGB(75,120,225)
                        or  Color3.fromRGB(42,42,65)
                    Knob.Position = v
                        and UDim2.new(1,-17,0.5,-7)
                        or  UDim2.new(0,3,0.5,-7)
                end
                function obj:GetValue() return val end
                return obj
            end

            -- ════════════════════════════════════
            --  Groupbox:CreateSlider
            -- ════════════════════════════════════
            function GBoxObj:CreateSlider(cfg3)
                cfg3 = cfg3 or {}
                local vc  = cfg3.Value or {}
                local Min = vc.Min  or 0
                local Max = vc.Max  or 100
                local Def = vc.Default or Min
                local Step = cfg3.Step or 1
                local cb   = cfg3.Callback or function() end
                local cur  = math.clamp(Def, Min, Max)

                local Wrap = Instance.new("Frame")
                Wrap.Size               = UDim2.new(1,0,0,52)
                Wrap.BackgroundTransparency = 1
                Wrap.ZIndex             = 6
                Wrap.Parent             = GContent

                local SLbl = Instance.new("TextLabel")
                SLbl.Size               = UDim2.new(1,-55,0,18)
                SLbl.BackgroundTransparency = 1
                SLbl.Text               = cfg3.Title or "Slider"
                SLbl.TextColor3         = Color3.fromRGB(210,210,240)
                SLbl.TextSize           = 13
                SLbl.Font               = Enum.Font.Gotham
                SLbl.TextXAlignment     = Enum.TextXAlignment.Left
                SLbl.ZIndex             = 7
                SLbl.Parent             = Wrap

                local SVLbl = Instance.new("TextLabel")
                SVLbl.Size              = UDim2.new(0,50,0,18)
                SVLbl.Position          = UDim2.new(1,-50,0,0)
                SVLbl.BackgroundTransparency = 1
                SVLbl.Text              = tostring(cur)
                SVLbl.TextColor3        = Color3.fromRGB(140,140,220)
                SVLbl.TextSize          = 12
                SVLbl.Font              = Enum.Font.GothamSemibold
                SVLbl.TextXAlignment    = Enum.TextXAlignment.Right
                SVLbl.ZIndex            = 7
                SVLbl.Parent            = Wrap

                local Track = Instance.new("Frame")
                Track.Size              = UDim2.new(1,0,0,7)
                Track.Position          = UDim2.new(0,0,0,26)
                Track.BackgroundColor3  = Color3.fromRGB(36,36,58)
                Track.BorderSizePixel   = 0
                Track.ZIndex            = 7
                Track.Parent            = Wrap
                Corner(Track, 6)

                local pct0 = (cur-Min)/(Max-Min)
                local Fill = Instance.new("Frame")
                Fill.Size              = UDim2.new(pct0,0,1,0)
                Fill.BackgroundColor3  = Color3.fromRGB(75,120,225)
                Fill.BorderSizePixel   = 0
                Fill.ZIndex            = 8
                Fill.Parent            = Track
                Corner(Fill, 6)

                local Knob = Instance.new("Frame")
                Knob.Size              = UDim2.new(0,14,0,14)
                Knob.Position          = UDim2.new(pct0,-7,0.5,-7)
                Knob.BackgroundColor3  = Color3.fromRGB(200,210,255)
                Knob.BorderSizePixel   = 0
                Knob.ZIndex            = 9
                Knob.Parent            = Track
                Corner(Knob, 14)

                local dragging = false
                local function Upd(x)
                    local ap = Track.AbsolutePosition.X
                    local as = Track.AbsoluteSize.X
                    local p  = math.clamp((x-ap)/as, 0, 1)
                    local raw = Min + p*(Max-Min)
                    local stepped = math.round(raw/Step)*Step
                    stepped = math.clamp(stepped, Min, Max)
                    cur = stepped
                    local fp = (stepped-Min)/(Max-Min)
                    Fill.Size     = UDim2.new(fp,0,1,0)
                    Knob.Position = UDim2.new(fp,-7,0.5,-7)
                    SVLbl.Text    = tostring(stepped)
                    cb(stepped)
                end

                Track.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true; Upd(i.Position.X)
                    end
                end)
                UserInputService.InputChanged:Connect(function(i)
                    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                        Upd(i.Position.X)
                    end
                end)
                UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)

                RegElem(Wrap, cfg3.Title or "Slider")
                local obj = {}
                function obj:SetValue(v)
                    cur = math.clamp(v, Min, Max)
                    local fp = (cur-Min)/(Max-Min)
                    Fill.Size = UDim2.new(fp,0,1,0)
                    Knob.Position = UDim2.new(fp,-7,0.5,-7)
                    SVLbl.Text = tostring(cur)
                end
                function obj:GetValue() return cur end
                return obj
            end

            -- ════════════════════════════════════
            --  Groupbox:CreateInput
            -- ════════════════════════════════════
            function GBoxObj:CreateInput(cfg3)
                cfg3 = cfg3 or {}
                local cb = cfg3.Callback or function() end

                local Wrap = Instance.new("Frame")
                Wrap.Size               = UDim2.new(1,0,0,52)
                Wrap.BackgroundTransparency = 1
                Wrap.ZIndex             = 6
                Wrap.Parent             = GContent

                local ILbl = Instance.new("TextLabel")
                ILbl.Size               = UDim2.new(1,0,0,18)
                ILbl.BackgroundTransparency = 1
                ILbl.Text               = cfg3.Title or "Input"
                ILbl.TextColor3         = Color3.fromRGB(210,210,240)
                ILbl.TextSize           = 13
                ILbl.Font               = Enum.Font.Gotham
                ILbl.TextXAlignment     = Enum.TextXAlignment.Left
                ILbl.ZIndex             = 7
                ILbl.Parent             = Wrap

                local IBox = Instance.new("TextBox")
                IBox.Size               = UDim2.new(1,0,0,28)
                IBox.Position           = UDim2.new(0,0,0,22)
                IBox.BackgroundColor3   = Color3.fromRGB(24,24,40)
                IBox.BackgroundTransparency = 0.18
                IBox.BorderSizePixel    = 0
                IBox.Text               = cfg3.Value or ""
                IBox.PlaceholderText    = cfg3.Placeholder or "Enter text…"
                IBox.TextColor3         = Color3.fromRGB(215,215,255)
                IBox.PlaceholderColor3  = Color3.fromRGB(90,90,130)
                IBox.TextSize           = 13
                IBox.Font               = Enum.Font.Gotham
                IBox.TextXAlignment     = Enum.TextXAlignment.Left
                IBox.ClearTextOnFocus   = false
                IBox.ZIndex             = 7
                IBox.Parent             = Wrap
                Corner(IBox, 7)
                Stroke(IBox, Color3.fromRGB(70,70,130), 1, 0.50)
                Padding(IBox, 0, 0, 8, 0)

                IBox.FocusLost:Connect(function(enter)
                    if enter then cb(IBox.Text) end
                end)

                RegElem(Wrap, cfg3.Title or "Input")
                return IBox
            end

            -- ════════════════════════════════════
            --  Groupbox:CreateDropdown
            -- ════════════════════════════════════
            function GBoxObj:CreateDropdown(cfg3)
                cfg3 = cfg3 or {}
                local vals   = cfg3.Values or {}
                local curVal = cfg3.Value  or (vals[1] or "")
                local cb     = cfg3.Callback or function() end

                local Wrap = Instance.new("Frame")
                Wrap.Size               = UDim2.new(1,0,0,52)
                Wrap.BackgroundTransparency = 1
                Wrap.ZIndex             = 6
                Wrap.Parent             = GContent

                local DLbl = Instance.new("TextLabel")
                DLbl.Size               = UDim2.new(1,0,0,18)
                DLbl.BackgroundTransparency = 1
                DLbl.Text               = cfg3.Title or "Dropdown"
                DLbl.TextColor3         = Color3.fromRGB(210,210,240)
                DLbl.TextSize           = 13
                DLbl.Font               = Enum.Font.Gotham
                DLbl.TextXAlignment     = Enum.TextXAlignment.Left
                DLbl.ZIndex             = 7
                DLbl.Parent             = Wrap

                local DBtnFrame = GlassFrame(Wrap,
                    UDim2.new(1,0,0,28),
                    UDim2.new(0,0,0,22),
                    Color3.fromRGB(24,24,40), 0.18, 7)
                Corner(DBtnFrame, 7)
                Stroke(DBtnFrame, Color3.fromRGB(70,70,130), 1, 0.50)

                local DCurLbl = Instance.new("TextLabel")
                DCurLbl.Size            = UDim2.new(1,-26,1,0)
                DCurLbl.Position        = UDim2.new(0,8,0,0)
                DCurLbl.BackgroundTransparency = 1
                DCurLbl.Text            = curVal
                DCurLbl.TextColor3      = Color3.fromRGB(210,210,240)
                DCurLbl.TextSize        = 13
                DCurLbl.Font            = Enum.Font.Gotham
                DCurLbl.TextXAlignment  = Enum.TextXAlignment.Left
                DCurLbl.ZIndex          = 8
                DCurLbl.Parent          = DBtnFrame

                local DArrow = Instance.new("TextLabel")
                DArrow.Size             = UDim2.new(0,20,1,0)
                DArrow.Position         = UDim2.new(1,-22,0,0)
                DArrow.BackgroundTransparency = 1
                DArrow.Text             = "▾"
                DArrow.TextColor3       = Color3.fromRGB(140,140,210)
                DArrow.TextSize         = 14
                DArrow.Font             = Enum.Font.Gotham
                DArrow.ZIndex           = 8
                DArrow.Parent           = DBtnFrame

                local DClickBtn = Instance.new("TextButton")
                DClickBtn.Size          = UDim2.new(1,0,1,0)
                DClickBtn.BackgroundTransparency = 1
                DClickBtn.Text          = ""
                DClickBtn.ZIndex        = 9
                DClickBtn.Parent        = DBtnFrame

                -- Dropdown obj
                local DObj = {}
                DObj._vals    = vals
                DObj._cur     = curVal
                DObj._cb      = cb
                DObj._curLbl  = DCurLbl

                local function OpenPopup()
                    -- clear old options
                    for _, ch in ipairs(Win._ddScroll:GetChildren()) do
                        if ch:IsA("TextButton") or ch:IsA("Frame") then ch:Destroy() end
                    end
                    Win._ddTitle.Text = cfg3.Title or "Select Option"

                    for _, v in ipairs(DObj._vals) do
                        local OptBtn = Instance.new("TextButton")
                        OptBtn.Size             = UDim2.new(1,0,0,30)
                        OptBtn.BackgroundColor3 = v == DObj._cur
                            and Color3.fromRGB(60,80,170)
                            or  Color3.fromRGB(26,26,44)
                        OptBtn.BackgroundTransparency = 0.18
                        OptBtn.BorderSizePixel  = 0
                        OptBtn.Text             = v
                        OptBtn.TextColor3       = Color3.fromRGB(210,210,240)
                        OptBtn.TextSize         = 13
                        OptBtn.Font             = Enum.Font.Gotham
                        OptBtn.ZIndex           = 27
                        OptBtn.Parent           = Win._ddScroll
                        Corner(OptBtn, 6)

                        OptBtn.MouseEnter:Connect(function()
                            Tween(OptBtn,{BackgroundColor3=Color3.fromRGB(65,85,175)},0.10)
                        end)
                        OptBtn.MouseLeave:Connect(function()
                            Tween(OptBtn,{BackgroundColor3 = v==DObj._cur
                                and Color3.fromRGB(60,80,170)
                                or  Color3.fromRGB(26,26,44)},0.10)
                        end)
                        OptBtn.MouseButton1Click:Connect(function()
                            DObj._cur     = v
                            DCurLbl.Text  = v
                            Win._ddPopup.Visible = false
                            DObj._cb(v)
                        end)
                    end

                    Win._ddPopup.Visible = true
                end

                DClickBtn.MouseButton1Click:Connect(OpenPopup)

                function DObj:Refresh(newVals)
                    DObj._vals = newVals
                    if not table.find(newVals, DObj._cur) then
                        DObj._cur = newVals[1] or ""
                        DCurLbl.Text = DObj._cur
                    end
                end
                function DObj:GetValue() return DObj._cur end
                function DObj:SetValue(v)
                    DObj._cur = v
                    DCurLbl.Text = v
                end

                RegElem(Wrap, cfg3.Title or "Dropdown")
                return DObj
            end

            return GBoxObj
        end -- CreateGroupbox

        return TabObj
    end -- CreateTab

    return Win
end -- CreateWindow

return SKUI
