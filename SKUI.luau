--[[
    ╔══════════════════════════════════════════════════════╗
    ║              HUB UI LIBRARY  v2.0                    ║
    ║  Draggable · Tabs · Scroll · Dropdown Popup · Icons  ║
    ╚══════════════════════════════════════════════════════╝

    USAGE:
        local UI = loadstring(game:HttpGet(""))()
        local Window = UI:CreateWindow({ Title = "Hub", Icon = "bird", Author = "by .ftgs" })
        local MinBtn  = Window:CreateMinimizeBtn({ Title = "Open UI", Image = "1234567890" })
        local Tab     = Window:Tab({ Title = "Main", Icon = "star" })
        Tab:Button({ Title = "Click Me", Callback = function() end })
        Tab:Toggle({ Title = "Toggle", Value = false, Callback = function(v) end })
        Tab:Slider({ Title = "Speed", Step = 1, Value = { Min = 0, Max = 100, Default = 50 }, Callback = function(v) end })
        Tab:Dropdown({ Title = "Mode", Values = {"A","B","C"}, Value = "A", Callback = function(v) end })
        Tab:Input({ Title = "Name", Placeholder = "Enter...", Callback = function(v) end })
]]

-- ─────────────────────────────────────────────────────────────────────────────
-- SERVICES
-- ─────────────────────────────────────────────────────────────────────────────
local cloneref    = (cloneref or clonereference or function(i) return i end)
local Players     = cloneref(game:GetService("Players"))
local TweenSvc    = cloneref(game:GetService("TweenService"))
local UIS         = cloneref(game:GetService("UserInputService"))
local HttpSvc     = cloneref(game:GetService("HttpService"))
local RunSvc      = cloneref(game:GetService("RunService"))

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

-- ─────────────────────────────────────────────────────────────────────────────
-- ICON MODULE  (from uploaded IconModule)
-- ─────────────────────────────────────────────────────────────────────────────
local function HttpGet(url)
    if game.HttpGet then return game:HttpGet(url)
    else return HttpSvc:GetAsync(url) end
end

local IconPacks = {}
local function TryLoadPack(name, url)
    local ok, result = pcall(function()
        return loadstring(HttpGet(url))()
    end)
    if ok and type(result) == "table" then
        IconPacks[name] = result
    end
end

-- Lazy load icon packs on first icon usage
local IconsLoaded = false
local function EnsureIcons()
    if IconsLoaded then return end
    IconsLoaded = true
    TryLoadPack("lucide",    "https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/lucide/dist/Icons.lua")
    TryLoadPack("solar",     "https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/solar/dist/Icons.lua")
    TryLoadPack("craft",     "https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/craft/dist/Icons.lua")
    TryLoadPack("geist",     "https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/geist/dist/Icons.lua")
    TryLoadPack("sfsymbols", "https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/sfsymbols/dist/Icons.lua")
    TryLoadPack("gravity",   "https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/gravity/dist/Icons.lua")
end

--[[
    Resolve an icon string → { image, rectSize, rectPos }
    Supports:
        "bird"           → lucide:bird
        "solar:bird"     → solar:bird
        "rbxassetid://X" → direct asset
        "1234567890"     → numeric asset id
]]
local function ResolveIcon(iconStr)
    if not iconStr or iconStr == "" then return nil end
    EnsureIcons()

    -- Direct asset
    if type(iconStr) == "string" then
        if iconStr:match("^rbxassetid://") then
            return iconStr, Vector2.new(0,0), Vector2.new(0,0)
        end
        if iconStr:match("^%d+$") then
            return "rbxassetid://" .. iconStr, Vector2.new(0,0), Vector2.new(0,0)
        end
        -- Pack:name  or  name  (defaults to lucide)
        local packName, iconName
        local split = iconStr:find(":")
        if split then
            packName = iconStr:sub(1, split - 1)
            iconName = iconStr:sub(split + 1)
        else
            packName = "lucide"
            iconName = iconStr
        end
        local pack = IconPacks[packName]
        if pack then
            -- format: pack.Icons[name] or pack[name]
            local icons = pack.Icons or pack
            local sheets = pack.Spritesheets or pack
            if icons and icons[iconName] then
                local d = icons[iconName]
                local img = sheets[tostring(d.Image)] or d.Image
                if type(img) == "number" then img = "rbxassetid://"..tostring(img) end
                return img, d.ImageRectSize or Vector2.new(0,0), d.ImageRectPosition or Vector2.new(0,0)
            end
        end
    end
    return nil
end

local function ApplyIcon(imgLabel, iconStr)
    if not iconStr then return end
    local img, rs, rp = ResolveIcon(iconStr)
    if img then
        imgLabel.Image = img
        if rs and rs ~= Vector2.new(0,0) then
            imgLabel.ImageRectSize   = rs
            imgLabel.ImageRectOffset = rp
        end
    end
end

-- ─────────────────────────────────────────────────────────────────────────────
-- THEME
-- ─────────────────────────────────────────────────────────────────────────────
local T = {
    -- Main panels
    BG          = Color3.fromRGB(12, 12, 18),
    BgTrans     = 0.12,          -- main frame transparency  (≈ "1.5" intent)
    TopBar      = Color3.fromRGB(18, 18, 27),
    TopTrans    = 0.05,
    Left        = Color3.fromRGB(16, 16, 24),
    LeftTrans   = 0.08,
    Right       = Color3.fromRGB(11, 11, 17),
    RightTrans  = 0.05,

    -- Elements
    Elem        = Color3.fromRGB(22, 22, 34),
    ElemTrans   = 0.15,
    ElemHov     = Color3.fromRGB(28, 28, 44),
    ElemHovT    = 0.05,

    -- Accent / Text
    Accent      = Color3.fromRGB(110, 86, 230),
    AccentHov   = Color3.fromRGB(130, 106, 255),
    Text        = Color3.fromRGB(230, 230, 242),
    TextDim     = Color3.fromRGB(140, 140, 165),
    Border      = Color3.fromRGB(45, 45, 68),
    BorderTrans = 0.45,

    -- Controls
    TogOn       = Color3.fromRGB(110, 86, 230),
    TogOff      = Color3.fromRGB(45, 45, 68),
    SliderTrack = Color3.fromRGB(30, 30, 48),
    SliderFill  = Color3.fromRGB(110, 86, 230),
    CloseBtn    = Color3.fromRGB(220, 58, 78),
    MinBtn      = Color3.fromRGB(110, 86, 230),

    -- Dropdown popup
    Popup       = Color3.fromRGB(20, 20, 32),
    PopupItem   = Color3.fromRGB(28, 28, 44),
}

-- ─────────────────────────────────────────────────────────────────────────────
-- UTILITY HELPERS
-- ─────────────────────────────────────────────────────────────────────────────
local function Tween(obj, props, t, style, dir)
    local info = TweenInfo.new(t or 0.18, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out)
    TweenSvc:Create(obj, info, props):Play()
end

local function Corner(parent, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = parent; return c
end

local function Stroke(parent, color, thick, trans)
    local s = Instance.new("UIStroke")
    s.Color = color or T.Border
    s.Thickness = thick or 1
    s.Transparency = trans or T.BorderTrans
    s.Parent = parent; return s
end

local function Pad(parent, t, r, b, l)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, t or 8)
    p.PaddingRight  = UDim.new(0, r or 8)
    p.PaddingBottom = UDim.new(0, b or 8)
    p.PaddingLeft   = UDim.new(0, l or 8)
    p.Parent = parent; return p
end

local function ListLayout(parent, padding, align)
    local l = Instance.new("UIListLayout")
    l.Padding = UDim.new(0, padding or 6)
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.HorizontalAlignment = align or Enum.HorizontalAlignment.Left
    l.Parent = parent; return l
end

local function New(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    if parent then obj.Parent = parent end
    return obj
end

-- Make an instance draggable.  handle = drag zone (defaults to frame itself)
local function MakeDraggable(frame, handle)
    handle = handle or frame
    local drag, dragStart, startPos = false, nil, nil

    handle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            drag = true
            dragStart = inp.Position
            startPos  = frame.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then
                    drag = false
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(inp)
        if drag and (inp.UserInputType == Enum.UserInputType.MouseMovement
                  or inp.UserInputType == Enum.UserInputType.Touch) then
            local d = inp.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
        end
    end)
end

-- Hover helpers
local function HoverStyle(btn, normalBG, normalT, hoverBG, hoverT)
    hoverBG = hoverBG or normalBG; hoverT = hoverT or math.max(0, normalT - 0.18)
    btn.MouseEnter:Connect(function()  Tween(btn, {BackgroundColor3=hoverBG, BackgroundTransparency=hoverT}) end)
    btn.MouseLeave:Connect(function()  Tween(btn, {BackgroundColor3=normalBG, BackgroundTransparency=normalT}) end)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- LIBRARY
-- ─────────────────────────────────────────────────────────────────────────────
local Library = {}
Library.__index = Library

-- ╔══════════════════╗
-- ║   CreateWindow   ║
-- ╚══════════════════╝
function Library:CreateWindow(cfg)
    cfg = cfg or {}
    local title  = cfg.Title  or "Hub"
    local icon   = cfg.Icon
    local author = cfg.Author

    -- ── ScreenGui ──────────────────────────────────────────
    local gui = New("ScreenGui", {
        Name           = "HubUI",
        ResetOnSpawn   = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder   = 999,
    }, PlayerGui)

    -- ── Main Frame ─────────────────────────────────────────
    local main = New("Frame", {
        Name                 = "Main",
        Size                 = UDim2.new(0, 640, 0, 440),
        Position             = UDim2.new(0.5,-320, 0.5,-220),
        BackgroundColor3     = T.BG,
        BackgroundTransparency = T.BgTrans,
        BorderSizePixel      = 0,
        ClipsDescendants     = false,
    }, gui)
    Corner(main, 14)
    Stroke(main, T.Border, 1, 0.30)

    -- Blur-glass feel: subtle inner gradient
    local grad = New("UIGradient", {
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(26,22,46)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(10,10,18)),
        },
        Rotation = 130,
    }, main)

    -- ── Top Bar ────────────────────────────────────────────
    local topBar = New("Frame", {
        Name                 = "TopBar",
        Size                 = UDim2.new(1,0,0,46),
        BackgroundColor3     = T.TopBar,
        BackgroundTransparency = T.TopTrans,
        BorderSizePixel      = 0,
        ZIndex               = 2,
    }, main)
    Corner(topBar, 14)
    -- fill bottom corners so topbar looks flush
    New("Frame", {
        Size=UDim2.new(1,0,0,14), Position=UDim2.new(0,0,1,-14),
        BackgroundColor3=T.TopBar, BackgroundTransparency=T.TopTrans, BorderSizePixel=0, ZIndex=2,
    }, topBar)

    -- Hub icon
    local topIcon = New("ImageLabel", {
        Size=UDim2.new(0,22,0,22), Position=UDim2.new(0,14,0.5,-11),
        BackgroundTransparency=1, ImageColor3=T.Accent, ZIndex=3,
    }, topBar)
    if icon then ApplyIcon(topIcon, icon) end

    local iconOffset = icon and 44 or 14

    -- Title
    local titleLbl = New("TextLabel", {
        Size     = UDim2.new(0,220,0, author and 20 or 46),
        Position = UDim2.new(0, iconOffset, 0, author and 6 or 0),
        BackgroundTransparency = 1,
        Text = title, TextColor3=T.Text,
        Font=Enum.Font.GothamBold, TextSize=15,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
    }, topBar)

    -- Author
    if author then
        New("TextLabel", {
            Size     = UDim2.new(0,280,0,16),
            Position = UDim2.new(0, iconOffset, 0, 26),
            BackgroundTransparency=1,
            Text=author, TextColor3=T.TextDim,
            Font=Enum.Font.Gotham, TextSize=11,
            TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
        }, topBar)
    end

    -- Separator line
    New("Frame", {
        Size=UDim2.new(1,-28,0,1), Position=UDim2.new(0,14,1,-1),
        BackgroundColor3=T.Border, BackgroundTransparency=0.4, BorderSizePixel=0, ZIndex=3,
    }, topBar)

    -- Close button
    local closeBtn = New("TextButton", {
        Size=UDim2.new(0,28,0,28), Position=UDim2.new(1,-40,0.5,-14),
        BackgroundColor3=T.CloseBtn, BackgroundTransparency=0.3, BorderSizePixel=0,
        Text="✕", TextColor3=T.Text, Font=Enum.Font.GothamBold, TextSize=14, ZIndex=3,
    }, topBar)
    Corner(closeBtn, 7)
    HoverStyle(closeBtn, T.CloseBtn, 0.3, T.CloseBtn, 0)

    -- Minimize (−/+) button in topbar
    local minBarBtn = New("TextButton", {
        Size=UDim2.new(0,28,0,28), Position=UDim2.new(1,-74,0.5,-14),
        BackgroundColor3=T.MinBtn, BackgroundTransparency=0.3, BorderSizePixel=0,
        Text="−", TextColor3=T.Text, Font=Enum.Font.GothamBold, TextSize=18, ZIndex=3,
    }, topBar)
    Corner(minBarBtn, 7)
    HoverStyle(minBarBtn, T.MinBtn, 0.3, T.AccentHov, 0)

    -- ── Content Area ───────────────────────────────────────
    local contentArea = New("Frame", {
        Name="ContentArea",
        Size=UDim2.new(1,0,1,-46), Position=UDim2.new(0,0,0,46),
        BackgroundTransparency=1, BorderSizePixel=0,
        ClipsDescendants=true,
    }, main)

    -- ── LEFT Panel (Tabs) ───────────────────────────────────
    local leftPanel = New("Frame", {
        Name="LeftPanel",
        Size=UDim2.new(0,155,1,0), Position=UDim2.new(0,0,0,0),
        BackgroundColor3=T.Left, BackgroundTransparency=T.LeftTrans, BorderSizePixel=0,
    }, contentArea)
    Corner(leftPanel, 14)
    -- flatten top-right + right edge
    New("Frame", {
        Size=UDim2.new(0,14,1,0), Position=UDim2.new(1,-14,0,0),
        BackgroundColor3=T.Left, BackgroundTransparency=T.LeftTrans, BorderSizePixel=0,
    }, leftPanel)
    New("Frame", {
        Size=UDim2.new(1,0,0,14), Position=UDim2.new(0,0,0,0),
        BackgroundColor3=T.Left, BackgroundTransparency=T.LeftTrans, BorderSizePixel=0,
    }, leftPanel)

    -- Scrolling tab list
    local tabScroll = New("ScrollingFrame", {
        Size=UDim2.new(1,-4,1,-10), Position=UDim2.new(0,0,0,8),
        BackgroundTransparency=1, BorderSizePixel=0,
        ScrollBarThickness=3, ScrollBarImageColor3=T.Accent,
        CanvasSize=UDim2.new(0,0,0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
        ScrollingDirection=Enum.ScrollingDirection.Y,
    }, leftPanel)
    ListLayout(tabScroll, 4)
    Pad(tabScroll, 8, 10, 8, 8)

    -- ── RIGHT Panel (Elements) ──────────────────────────────
    local rightPanel = New("Frame", {
        Name="RightPanel",
        Size=UDim2.new(1,-160,1,0), Position=UDim2.new(0,160,0,0),
        BackgroundColor3=T.Right, BackgroundTransparency=T.RightTrans, BorderSizePixel=0,
    }, contentArea)
    Corner(rightPanel, 14)
    -- flatten top-left edge
    New("Frame", {
        Size=UDim2.new(0,14,1,0), Position=UDim2.new(0,0,0,0),
        BackgroundColor3=T.Right, BackgroundTransparency=T.RightTrans, BorderSizePixel=0,
    }, rightPanel)
    New("Frame", {
        Size=UDim2.new(1,0,0,14), Position=UDim2.new(0,0,0,0),
        BackgroundColor3=T.Right, BackgroundTransparency=T.RightTrans, BorderSizePixel=0,
    }, rightPanel)

    -- Tab content will parent ScrollingFrames here
    local rightContainer = New("Frame", {
        Size=UDim2.new(1,-6,1,-6), Position=UDim2.new(0,3,0,3),
        BackgroundTransparency=1, BorderSizePixel=0,
        ClipsDescendants=true,
    }, rightPanel)

    -- ── DROPDOWN OVERLAY (full-UI dimmed popup) ─────────────
    local ddOverlay = New("Frame", {
        Name="DropdownOverlay",
        Size=UDim2.new(1,0,1,0), BackgroundColor3=Color3.fromRGB(0,0,0),
        BackgroundTransparency=0.45, BorderSizePixel=0,
        Visible=false, ZIndex=20,
    }, main)
    Corner(ddOverlay, 14)

    local ddPopup = New("Frame", {
        Size=UDim2.new(0,240,0,190), Position=UDim2.new(0.5,-120,0.5,-95),
        BackgroundColor3=T.Popup, BackgroundTransparency=0.04, BorderSizePixel=0, ZIndex=21,
    }, ddOverlay)
    Corner(ddPopup, 12)
    Stroke(ddPopup, T.Accent, 1, 0.45)

    local ddPopTitle = New("TextLabel", {
        Size=UDim2.new(1,-16,0,30), Position=UDim2.new(0,10,0,4),
        BackgroundTransparency=1,
        TextColor3=T.Text, Font=Enum.Font.GothamBold, TextSize=13,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=22,
    }, ddPopup)

    local ddCloseX = New("TextButton", {
        Size=UDim2.new(0,22,0,22), Position=UDim2.new(1,-28,0,6),
        BackgroundColor3=T.CloseBtn, BackgroundTransparency=0.3, BorderSizePixel=0,
        Text="✕", TextColor3=T.Text, Font=Enum.Font.GothamBold, TextSize=11, ZIndex=22,
    }, ddPopup)
    Corner(ddCloseX, 5)

    local ddItemScroll = New("ScrollingFrame", {
        Size=UDim2.new(1,-12,1,-42), Position=UDim2.new(0,6,0,38),
        BackgroundTransparency=1, BorderSizePixel=0,
        ScrollBarThickness=3, ScrollBarImageColor3=T.Accent,
        CanvasSize=UDim2.new(0,0,0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
        ScrollingDirection=Enum.ScrollingDirection.Y,
        ZIndex=22,
    }, ddPopup)
    ListLayout(ddItemScroll, 4)
    Pad(ddItemScroll, 4,6,4,4)

    local function CloseDropdown()
        Tween(ddOverlay, {BackgroundTransparency=0.9}, 0.15)
        task.wait(0.12)
        ddOverlay.Visible = false
        ddOverlay.BackgroundTransparency = 0.45
    end

    ddOverlay.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then CloseDropdown() end
    end)
    ddCloseX.MouseButton1Click:Connect(CloseDropdown)
    -- Prevent popup clicks from propagating to overlay
    ddPopup.InputBegan:Connect(function(i) end)

    -- ── DRAG & MINIMIZE logic ───────────────────────────────
    MakeDraggable(main, topBar)

    local minimized = false
    closeBtn.MouseButton1Click:Connect(function()
        Tween(main, {Size=UDim2.new(0,640,0,0), BackgroundTransparency=1}, 0.25)
        task.wait(0.26)
        main.Visible = false
        main.BackgroundTransparency = T.BgTrans
    end)

    minBarBtn.MouseButton1Click:Connect(function()
        if minimized then
            minimized = false
            minBarBtn.Text = "−"
            contentArea.Visible = true
            Tween(main, {Size=UDim2.new(0,640,0,440)}, 0.25)
        else
            minimized = true
            minBarBtn.Text = "+"
            Tween(main, {Size=UDim2.new(0,640,0,46)}, 0.22)
            task.wait(0.22)
            contentArea.Visible = false
        end
    end)

    -- ── Window Object ───────────────────────────────────────
    local Win         = {}
    Win._gui          = gui
    Win._main         = main
    Win._tabScroll    = tabScroll
    Win._rightContainer = rightContainer
    Win._ddOverlay    = ddOverlay
    Win._ddPopTitle   = ddPopTitle
    Win._ddItemScroll = ddItemScroll
    Win._tabs         = {}
    Win._activeIdx    = 0
    Win._contentArea  = contentArea
    Win._minimized    = false

    -- ╔════════════════════════╗
    -- ║  CreateMinimizeBtn     ║  (floating draggable button)
    -- ╚════════════════════════╝
    function Win:CreateMinimizeBtn(cfg2)
        cfg2 = cfg2 or {}
        local btnText  = cfg2.Title or "Open UI"
        local btnImage = cfg2.Image

        local floatBtn = New("TextButton", {
            Name="FloatingBtn",
            Size=UDim2.new(0, btnImage and 136 or 110, 0,38),
            Position=UDim2.new(0,24,1,-66),
            BackgroundColor3=T.MinBtn, BackgroundTransparency=0.18,
            BorderSizePixel=0, Text="", ZIndex=10,
        }, gui)
        Corner(floatBtn, 10)
        Stroke(floatBtn, T.Accent, 1, 0.4)
        MakeDraggable(floatBtn)

        local iconOff = 10
        if btnImage then
            local fi = New("ImageLabel", {
                Size=UDim2.new(0,20,0,20), Position=UDim2.new(0,10,0.5,-10),
                BackgroundTransparency=1, ImageColor3=T.Text, ZIndex=11,
            }, floatBtn)
            ApplyIcon(fi, btnImage)
            iconOff = 36
        end

        New("TextLabel", {
            Size=UDim2.new(1,-iconOff-6,1,0), Position=UDim2.new(0,iconOff,0,0),
            BackgroundTransparency=1, Text=btnText,
            TextColor3=T.Text, Font=Enum.Font.GothamBold, TextSize=13,
            TextXAlignment=Enum.TextXAlignment.Left, ZIndex=11,
        }, floatBtn)

        HoverStyle(floatBtn, T.MinBtn, 0.18, T.AccentHov, 0.05)

        floatBtn.MouseButton1Click:Connect(function()
            if main.Visible then
                Tween(main, {Size=UDim2.new(0,640,0,0),BackgroundTransparency=1},0.22)
                task.wait(0.23)
                main.Visible = false
                main.Size = UDim2.new(0,640,0, minimized and 46 or 440)
                main.BackgroundTransparency = T.BgTrans
            else
                main.Visible = true
                main.Size = UDim2.new(0,640,0,0)
                main.BackgroundTransparency = 1
                contentArea.Visible = not minimized
                Tween(main, {Size=UDim2.new(0,640,0, minimized and 46 or 440), BackgroundTransparency=T.BgTrans}, 0.25)
            end
        end)

        return floatBtn
    end

    -- ╔══════════╗
    -- ║   Tab    ║
    -- ╚══════════╝
    function Win:Tab(cfg3)
        cfg3 = cfg3 or {}
        local tabTitle  = cfg3.Title  or "Tab"
        local tabIcon   = cfg3.Icon
        local tabLocked = cfg3.Locked or false

        local tabIdx = #self._tabs + 1

        -- ── Tab button (left panel) ─────────────────────────
        local tabBtn = New("TextButton", {
            Size=UDim2.new(1,0,0,36),
            BackgroundColor3=T.Elem, BackgroundTransparency=0.25,
            BorderSizePixel=0, Text="",
        }, tabScroll)
        Corner(tabBtn, 8)

        local tabIconImg = New("ImageLabel", {
            Size=UDim2.new(0,18,0,18), Position=UDim2.new(0,10,0.5,-9),
            BackgroundTransparency=1, ImageColor3=T.TextDim,
        }, tabBtn)
        if tabIcon then ApplyIcon(tabIconImg, tabIcon) end

        local iconShift = tabIcon and 34 or 10
        local tabLabel = New("TextLabel", {
            Size=UDim2.new(1,-iconShift-8,1,0), Position=UDim2.new(0,iconShift,0,0),
            BackgroundTransparency=1, Text=tabTitle,
            TextColor3=T.TextDim, Font=Enum.Font.Gotham, TextSize=13,
            TextXAlignment=Enum.TextXAlignment.Left,
        }, tabBtn)

        if tabLocked then
            New("TextLabel", {
                Size=UDim2.new(0,18,0,18), Position=UDim2.new(1,-24,0.5,-9),
                BackgroundTransparency=1, Text="🔒",
                TextColor3=T.TextDim, Font=Enum.Font.Gotham, TextSize=12,
            }, tabBtn)
        end

        -- ── Tab content (right panel, scrollable) ───────────
        local tabScroller = New("ScrollingFrame", {
            Size=UDim2.new(1,0,1,0),
            BackgroundTransparency=1, BorderSizePixel=0,
            ScrollBarThickness=3, ScrollBarImageColor3=T.Accent,
            CanvasSize=UDim2.new(0,0,0,0),
            AutomaticCanvasSize=Enum.AutomaticSize.Y,
            ScrollingDirection=Enum.ScrollingDirection.Y,
            Visible=false,
        }, rightContainer)
        ListLayout(tabScroller, 6)
        Pad(tabScroller, 10, 12, 10, 10)

        -- ── Activate logic ──────────────────────────────────
        local function ActivateTab()
            if tabLocked then return end
            -- Deactivate all tabs
            for _, t in ipairs(self._tabs) do
                Tween(t.btn,   {BackgroundTransparency=0.25}, 0.15)
                Tween(t.lbl,   {TextColor3=T.TextDim}, 0.15)
                t.lbl.Font       = Enum.Font.Gotham
                t.ico.ImageColor3 = T.TextDim
                t.scroller.Visible = false
            end
            -- Activate this tab
            Tween(tabBtn,   {BackgroundTransparency=0.05}, 0.15)
            Tween(tabLabel, {TextColor3=T.Text}, 0.15)
            tabLabel.Font            = Enum.Font.GothamBold
            tabIconImg.ImageColor3   = T.Accent
            tabScroller.Visible      = true
            self._activeIdx          = tabIdx
        end

        tabBtn.MouseButton1Click:Connect(ActivateTab)
        tabBtn.MouseEnter:Connect(function()
            if self._activeIdx ~= tabIdx then
                Tween(tabBtn, {BackgroundTransparency=0.12}, 0.12)
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if self._activeIdx ~= tabIdx then
                Tween(tabBtn, {BackgroundTransparency=0.25}, 0.12)
            end
        end)

        table.insert(self._tabs, {btn=tabBtn, lbl=tabLabel, ico=tabIconImg, scroller=tabScroller})
        if tabIdx == 1 then ActivateTab() end

        -- ─────────────────────────────────────────────────────
        --   ELEMENT BUILDERS
        -- ─────────────────────────────────────────────────────
        local win = self

        local function ElemFrame(h)
            local f = New("Frame", {
                Size=UDim2.new(1,0,0,h or 44),
                BackgroundColor3=T.Elem, BackgroundTransparency=T.ElemTrans, BorderSizePixel=0,
            }, tabScroller)
            Corner(f, 9)
            Stroke(f, T.Border, 1, 0.55)
            return f
        end

        local function ElemTitle(parent, text, xOff, yOff, w, h)
            return New("TextLabel", {
                Size=UDim2.new(w or 0.55, 0, h or 1, 0),
                Position=UDim2.new(0, xOff or 12, 0, yOff or 0),
                BackgroundTransparency=1, Text=text,
                TextColor3=T.Text, Font=Enum.Font.Gotham, TextSize=13,
                TextXAlignment=Enum.TextXAlignment.Left,
            }, parent)
        end

        -- ══════════════════════════════════════════════════════
        --  BUTTON
        -- ══════════════════════════════════════════════════════
        local Tab = {}

        function Tab:Button(c)
            c = c or {}
            local f = ElemFrame(44)
            ElemTitle(f, c.Title or "Button")

            local cb = c.Locked and nil or c.Callback or function() end
            local btn = New("TextButton", {
                Size=UDim2.new(0,82,0,28), Position=UDim2.new(1,-92,0.5,-14),
                BackgroundColor3 = c.Locked and T.TextDim or T.Accent,
                BackgroundTransparency=0.2, BorderSizePixel=0,
                Text = c.Locked and "Locked" or "Execute",
                TextColor3=T.Text, Font=Enum.Font.GothamBold, TextSize=12,
            }, f)
            Corner(btn, 7)

            if not c.Locked then
                HoverStyle(btn, T.Accent, 0.2, T.AccentHov, 0)
                btn.MouseButton1Click:Connect(function()
                    Tween(btn,{BackgroundTransparency=0},0.08)
                    task.wait(0.08)
                    Tween(btn,{BackgroundTransparency=0.2},0.15)
                    cb()
                end)
            end
            return f
        end

        -- ══════════════════════════════════════════════════════
        --  DROPDOWN   (middle popup with scroll)
        -- ══════════════════════════════════════════════════════
        function Tab:Dropdown(c)
            c = c or {}
            local values   = c.Values or {}
            local selected = c.Value or values[1] or ""
            local cb       = c.Callback or function() end

            local f = ElemFrame(44)
            ElemTitle(f, c.Title or "Dropdown")

            -- Preview button
            local prev = New("TextButton", {
                Size=UDim2.new(0,130,0,30), Position=UDim2.new(1,-140,0.5,-15),
                BackgroundColor3=T.SliderTrack, BackgroundTransparency=0.1,
                BorderSizePixel=0, Text="",
            }, f)
            Corner(prev, 7)
            Stroke(prev, T.Border, 1, 0.3)

            local prevLbl = New("TextLabel", {
                Size=UDim2.new(1,-26,1,0), Position=UDim2.new(0,8,0,0),
                BackgroundTransparency=1, Text=selected,
                TextColor3=T.Text, Font=Enum.Font.Gotham, TextSize=12,
                TextXAlignment=Enum.TextXAlignment.Left,
            }, prev)

            New("TextLabel", {
                Size=UDim2.new(0,20,1,0), Position=UDim2.new(1,-22,0,0),
                BackgroundTransparency=1, Text="▾",
                TextColor3=T.TextDim, Font=Enum.Font.GothamBold, TextSize=13,
            }, prev)

            HoverStyle(prev, T.SliderTrack, 0.1, T.ElemHov, 0)

            prev.MouseButton1Click:Connect(function()
                -- Populate popup
                win._ddPopTitle.Text = c.Title or "Dropdown"
                for _, ch in ipairs(ddItemScroll:GetChildren()) do
                    if not ch:IsA("UIListLayout") and not ch:IsA("UIPadding") then ch:Destroy() end
                end

                for _, val in ipairs(values) do
                    local isSelected = val == selected
                    local item = New("TextButton", {
                        Size=UDim2.new(1,0,0,32),
                        BackgroundColor3 = isSelected and T.Accent or T.PopupItem,
                        BackgroundTransparency = isSelected and 0.1 or 0.25,
                        BorderSizePixel=0, Text=val,
                        TextColor3 = isSelected and T.Text or T.TextDim,
                        Font = isSelected and Enum.Font.GothamBold or Enum.Font.Gotham,
                        TextSize=13, ZIndex=23,
                    }, ddItemScroll)
                    Corner(item, 7)

                    if isSelected then
                        local dot = New("Frame", {
                            Size=UDim2.new(0,7,0,7), Position=UDim2.new(1,-16,0.5,-3),
                            BackgroundColor3=T.Text, BackgroundTransparency=0, BorderSizePixel=0, ZIndex=24,
                        }, item)
                        Corner(dot, 4)
                    end

                    item.MouseEnter:Connect(function()
                        if val ~= selected then Tween(item,{BackgroundTransparency=0.1},0.1) end
                    end)
                    item.MouseLeave:Connect(function()
                        if val ~= selected then Tween(item,{BackgroundTransparency=0.25},0.1) end
                    end)
                    item.MouseButton1Click:Connect(function()
                        selected = val
                        prevLbl.Text = val
                        CloseDropdown()
                        cb(val)
                    end)
                end

                ddOverlay.Visible = true
                Tween(ddPopup, {Size=UDim2.new(0,240,0,190)}, 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            end)
            return f
        end

        -- ══════════════════════════════════════════════════════
        --  TOGGLE
        -- ══════════════════════════════════════════════════════
        function Tab:Toggle(c)
            c = c or {}
            local hasDesc = c.Desc ~= nil
            local h       = hasDesc and 54 or 44
            local f       = ElemFrame(h)
            local xOff    = 12

            -- optional icon
            if c.Icon then
                local ico = New("ImageLabel", {
                    Size=UDim2.new(0,18,0,18), Position=UDim2.new(0,12,0.5,-9),
                    BackgroundTransparency=1, ImageColor3=T.Accent,
                }, f)
                ApplyIcon(ico, c.Icon)
                xOff = 36
            end

            New("TextLabel", {
                Size=UDim2.new(0.6,0,0, hasDesc and 20 or 44),
                Position=UDim2.new(0,xOff,0, hasDesc and 8 or 0),
                BackgroundTransparency=1, Text=c.Title or "Toggle",
                TextColor3=T.Text, Font=Enum.Font.Gotham, TextSize=13,
                TextXAlignment=Enum.TextXAlignment.Left,
            }, f)

            if hasDesc then
                New("TextLabel", {
                    Size=UDim2.new(0.72,0,0,16), Position=UDim2.new(0,xOff,0,28),
                    BackgroundTransparency=1, Text=c.Desc,
                    TextColor3=T.TextDim, Font=Enum.Font.Gotham, TextSize=11,
                    TextXAlignment=Enum.TextXAlignment.Left,
                }, f)
            end

            local state = c.Value or false

            -- Pill background
            local pillBg = New("Frame", {
                Size=UDim2.new(0,46,0,26), Position=UDim2.new(1,-56,0.5,-13),
                BackgroundColor3 = state and T.TogOn or T.TogOff,
                BackgroundTransparency=0.05, BorderSizePixel=0,
            }, f)
            Corner(pillBg, 13)

            -- Circle
            local circ = New("Frame", {
                Size=UDim2.new(0,20,0,20),
                Position = state and UDim2.new(0,23,0.5,-10) or UDim2.new(0,3,0.5,-10),
                BackgroundColor3=Color3.fromRGB(255,255,255), BackgroundTransparency=0, BorderSizePixel=0,
            }, pillBg)
            Corner(circ, 10)

            -- Invisible click layer
            local clickLayer = New("TextButton", {
                Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="",
            }, f)
            clickLayer.MouseButton1Click:Connect(function()
                state = not state
                Tween(pillBg, {BackgroundColor3 = state and T.TogOn or T.TogOff}, 0.2)
                Tween(circ, {Position = state and UDim2.new(0,23,0.5,-10) or UDim2.new(0,3,0.5,-10)}, 0.2)
                if c.Callback then c.Callback(state) end
            end)
            return f
        end

        -- ══════════════════════════════════════════════════════
        --  SLIDER
        -- ══════════════════════════════════════════════════════
        function Tab:Slider(c)
            c = c or {}
            local vt   = c.Value or {}
            local mn   = vt.Min     or 0
            local mx   = vt.Max     or 100
            local def  = vt.Default or mn
            local step = c.Step     or 1
            local cb   = c.Callback or function() end
            local cur  = def

            local f = ElemFrame(62)
            New("TextLabel", {
                Size=UDim2.new(0.6,0,0,20), Position=UDim2.new(0,12,0,8),
                BackgroundTransparency=1, Text=c.Title or "Slider",
                TextColor3=T.Text, Font=Enum.Font.Gotham, TextSize=13,
                TextXAlignment=Enum.TextXAlignment.Left,
            }, f)

            local valLbl = New("TextLabel", {
                Size=UDim2.new(0,56,0,20), Position=UDim2.new(1,-66,0,8),
                BackgroundTransparency=1, Text=tostring(cur),
                TextColor3=T.Accent, Font=Enum.Font.GothamBold, TextSize=13,
                TextXAlignment=Enum.TextXAlignment.Right,
            }, f)

            local track = New("Frame", {
                Size=UDim2.new(1,-24,0,6), Position=UDim2.new(0,12,0,38),
                BackgroundColor3=T.SliderTrack, BackgroundTransparency=0.1, BorderSizePixel=0,
            }, f)
            Corner(track, 3)

            local pct0 = (cur - mn) / math.max(mx - mn, 0.001)
            local fill = New("Frame", {
                Size=UDim2.new(pct0,0,1,0),
                BackgroundColor3=T.SliderFill, BackgroundTransparency=0.1, BorderSizePixel=0,
            }, track)
            Corner(fill, 3)

            local thumb = New("Frame", {
                Size=UDim2.new(0,14,0,14), Position=UDim2.new(pct0,-7,0.5,-7),
                BackgroundColor3=Color3.fromRGB(255,255,255), BackgroundTransparency=0,
                BorderSizePixel=0, ZIndex=2,
            }, track)
            Corner(thumb, 7)
            Stroke(thumb, T.Accent, 2, 0)

            local sliding = false
            local function setVal(pos)
                local ax = track.AbsolutePosition.X
                local aw = track.AbsoluteSize.X
                local rel = math.clamp((pos.X - ax) / aw, 0, 1)
                local raw = mn + rel * (mx - mn)
                local v   = math.clamp(math.round(raw / step) * step, mn, mx)
                cur = v
                local p = (v - mn) / math.max(mx - mn, 0.001)
                fill.Size      = UDim2.new(p, 0, 1, 0)
                thumb.Position = UDim2.new(p, -7, 0.5, -7)
                valLbl.Text    = tostring(v)
                cb(v)
            end

            track.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = true; setVal(i.Position)
                end
            end)
            thumb.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true end
            end)
            UIS.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
            end)
            UIS.InputChanged:Connect(function(i)
                if sliding and i.UserInputType == Enum.UserInputType.MouseMovement then
                    setVal(i.Position)
                end
            end)
            return f
        end

        -- ══════════════════════════════════════════════════════
        --  INPUT
        -- ══════════════════════════════════════════════════════
        function Tab:Input(c)
            c = c or {}
            local cb = c.Callback or function() end

            local f = ElemFrame(44)
            ElemTitle(f, c.Title or "Input", 12, 0, 0.38)

            local iBox = New("Frame", {
                Size=UDim2.new(0,172,0,30), Position=UDim2.new(1,-182,0.5,-15),
                BackgroundColor3=T.SliderTrack, BackgroundTransparency=0.1, BorderSizePixel=0,
            }, f)
            Corner(iBox, 7)
            local iStroke = Stroke(iBox, T.Border, 1, 0.35)

            local xOff = 8
            if c.InputIcon then
                local ico = New("ImageLabel", {
                    Size=UDim2.new(0,16,0,16), Position=UDim2.new(0,6,0.5,-8),
                    BackgroundTransparency=1, ImageColor3=T.TextDim,
                }, iBox)
                ApplyIcon(ico, c.InputIcon)
                xOff = 28
            end

            local tb = New("TextBox", {
                Size=UDim2.new(1,-xOff-6,1,0), Position=UDim2.new(0,xOff,0,0),
                BackgroundTransparency=1, Text=c.Value or "",
                PlaceholderText=c.Placeholder or "Enter text...",
                TextColor3=T.Text, PlaceholderColor3=T.TextDim,
                Font=Enum.Font.Gotham, TextSize=12,
                TextXAlignment=Enum.TextXAlignment.Left,
                ClearTextOnFocus=false,
            }, iBox)

            tb.Focused:Connect(function()
                iStroke.Color = T.Accent; iStroke.Transparency = 0.2
            end)
            tb.FocusLost:Connect(function(enter)
                iStroke.Color = T.Border; iStroke.Transparency = 0.35
                if enter then cb(tb.Text) end
            end)
            return f
        end

        -- ══════════════════════════════════════════════════════
        --  LABEL  (bonus: static text / section header)
        -- ══════════════════════════════════════════════════════
        function Tab:Label(c)
            c = c or {}
            local f = New("Frame", {
                Size=UDim2.new(1,0,0,26),
                BackgroundTransparency=1, BorderSizePixel=0,
            }, tabScroller)
            New("TextLabel", {
                Size=UDim2.new(1,0,1,0),
                BackgroundTransparency=1, Text=c.Title or "",
                TextColor3=T.TextDim, Font=Enum.Font.GothamBold, TextSize=12,
                TextXAlignment=Enum.TextXAlignment.Left,
            }, f)
            New("Frame", {
                Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,1,-1),
                BackgroundColor3=T.Border, BackgroundTransparency=0.5, BorderSizePixel=0,
            }, f)
            return f
        end

        return Tab
    end -- Win:Tab

    return Win
end -- Library:CreateWindow

-- ─────────────────────────────────────────────────────────────────────────────
return Library
