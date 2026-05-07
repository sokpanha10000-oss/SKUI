-- ╔══════════════════════════════════════════════════════════════╗
-- ║              SKUI — Glass Hub UI Library                     ║
-- ║   Draggable • Glass • Tabs • Search • Minimize • Dropdown    ║
-- ╚══════════════════════════════════════════════════════════════╝

local SKUI = {}
SKUI.__index = SKUI

-- ─── Services ────────────────────────────────────────────────────────────────
local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

-- ─── Theme ───────────────────────────────────────────────────────────────────
local T = {
    -- Window glass
    WinBG            = Color3.fromRGB(255, 255, 255),
    WinTrans         = 0.80,
    WinStroke        = Color3.fromRGB(200, 205, 240),
    WinStrokeTrans   = 0.40,

    -- Title bar
    TitleBG          = Color3.fromRGB(250, 250, 255),
    TitleBGTrans     = 0.72,
    TitleText        = Color3.fromRGB(35, 35, 75),
    AuthorText       = Color3.fromRGB(120, 120, 165),

    -- Left panel (tabs)
    LeftBG           = Color3.fromRGB(242, 244, 255),
    LeftBGTrans      = 0.62,
    LeftStroke       = Color3.fromRGB(210, 215, 245),
    LeftStrokeTrans  = 0.45,

    -- Tab button
    TabBtn           = Color3.fromRGB(255, 255, 255),
    TabBtnTrans      = 0.78,
    TabBtnActive     = Color3.fromRGB(105, 125, 255),
    TabBtnActiveTrans = 0.08,
    TabText          = Color3.fromRGB(65, 65, 110),
    TabTextActive    = Color3.fromRGB(255, 255, 255),
    TabHover         = 0.55,

    -- Right panel
    RightBGTrans     = 1,

    -- Groupbox
    GroupBG          = Color3.fromRGB(255, 255, 255),
    GroupBGTrans     = 0.65,
    GroupStroke      = Color3.fromRGB(210, 215, 245),
    GroupStrokeTrans = 0.38,
    GroupTitle       = Color3.fromRGB(80, 95, 170),

    -- Text
    Text             = Color3.fromRGB(28, 28, 62),
    SubText          = Color3.fromRGB(105, 105, 155),
    Accent           = Color3.fromRGB(105, 125, 255),

    -- Button
    BtnBG            = Color3.fromRGB(105, 125, 255),
    BtnBGTrans       = 0.12,
    BtnText          = Color3.fromRGB(255, 255, 255),
    BtnLocked        = Color3.fromRGB(175, 175, 200),
    BtnLockedTrans   = 0.35,

    -- Toggle
    ToggleOn         = Color3.fromRGB(95, 210, 130),
    ToggleOff        = Color3.fromRGB(185, 185, 210),
    ToggleKnob       = Color3.fromRGB(255, 255, 255),

    -- Slider
    SliderTrack      = Color3.fromRGB(210, 215, 245),
    SliderFill       = Color3.fromRGB(105, 125, 255),
    SliderKnob       = Color3.fromRGB(255, 255, 255),

    -- Input
    InputBG          = Color3.fromRGB(245, 245, 255),
    InputBGTrans     = 0.42,
    InputStroke      = Color3.fromRGB(200, 205, 238),

    -- Dropdown
    DropBG           = Color3.fromRGB(248, 248, 255),
    DropItem         = Color3.fromRGB(255, 255, 255),
    DropItemHover    = Color3.fromRGB(218, 222, 255),
    DropSelected     = Color3.fromRGB(105, 125, 255),

    -- Search
    SearchBG         = Color3.fromRGB(245, 245, 255),
    SearchBGTrans    = 0.50,

    -- Close / Min
    CloseRed         = Color3.fromRGB(255, 72, 72),
    CloseTrans       = 0.12,
    MinBG            = Color3.fromRGB(105, 125, 255),
    MinBGTrans       = 0.08,
    MinText          = Color3.fromRGB(255, 255, 255),

    -- Misc
    Divider          = Color3.fromRGB(208, 212, 245),
    DividerTrans     = 0.45,
    Shadow           = Color3.fromRGB(130, 145, 210),
    ShadowTrans      = 0.82,
}

-- ─── Utilities ───────────────────────────────────────────────────────────────
local function New(class, props)
    local ok, inst = pcall(Instance.new, class)
    if not ok then return nil end
    for k, v in pairs(props) do
        if k ~= "Parent" and k ~= "Children" then
            pcall(function() inst[k] = v end)
        end
    end
    if props.Children then
        for _, c in ipairs(props.Children) do
            if c then c.Parent = inst end
        end
    end
    if props.Parent then inst.Parent = props.Parent end
    return inst
end

local function Tween(inst, props, t, style, dir)
    local ti = TweenInfo.new(
        t     or 0.18,
        style or Enum.EasingStyle.Quad,
        dir   or Enum.EasingDirection.Out
    )
    TweenService:Create(inst, ti, props):Play()
end

local function MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging   = false
    local wasDragged = false
    local dragInput, dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging   = true
            wasDragged = false
            dragStart  = input.Position
            startPos   = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            if delta.Magnitude > 3 then wasDragged = true end
            frame.Position = UDim2.new(
                startPos.X.Scale,  startPos.X.Offset  + delta.X,
                startPos.Y.Scale,  startPos.Y.Offset  + delta.Y
            )
        end
    end)

    return function() return wasDragged end
end

local function AddCorner(parent, radius)
    return New("UICorner", { CornerRadius = UDim.new(0, radius or 10), Parent = parent })
end

local function AddStroke(parent, color, transparency, thickness)
    return New("UIStroke", {
        Color        = color        or T.WinStroke,
        Transparency = transparency or 0.3,
        Thickness    = thickness    or 1.2,
        Parent       = parent,
    })
end

-- ─── CreateWindow ────────────────────────────────────────────────────────────
function SKUI:CreateWindow(config)
    config = config or {}
    local title  = config.Title  or "SKUI Hub"
    local author = config.Author or ""
    local image  = config.Image  or ""

    local win = setmetatable({}, SKUI)
    win._tabs        = {}
    win._allElements = {}   -- { name, frame, tabName }
    win._visible     = true
    win._activeTab   = nil

    -- ── ScreenGui ─────────────────────────────────────────────────────────────
    local gui = New("ScreenGui", {
        Name             = "SKUI_" .. title,
        ResetOnSpawn     = false,
        ZIndexBehavior   = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset   = true,
        Parent           = PlayerGui,
    })
    win._gui = gui

    -- ── Shadow ────────────────────────────────────────────────────────────────
    local shadow = New("ImageLabel", {
        Name               = "Shadow",
        Size               = UDim2.new(0, 550, 0, 340),
        Position           = UDim2.new(0.5, -330, 0.5, -222),
        BackgroundTransparency = 1,
        Image              = "rbxassetid://5554236805",
        ImageColor3        = T.Shadow,
        ImageTransparency  = T.ShadowTrans,
        ScaleType          = Enum.ScaleType.Slice,
        SliceCenter        = Rect.new(23, 23, 277, 277),
        ZIndex             = 0,
        Parent             = gui,
    })

    -- ── Main Frame ────────────────────────────────────────────────────────────
    local main = New("Frame", {
        Name                 = "MainFrame",
        Size                 = UDim2.new(0, 628, 0, 430),
        Position             = UDim2.new(0.5, -314, 0.5, -215),
        BackgroundColor3     = T.WinBG,
        BackgroundTransparency = T.WinTrans,
        BorderSizePixel      = 0,
        ClipsDescendants     = true,
        ZIndex               = 1,
        Parent               = gui,
    })
    win._main = main
    AddCorner(main, 14)
    AddStroke(main, T.WinStroke, T.WinStrokeTrans, 1.4)

    -- Sync shadow position when main moves
    RunService.RenderStepped:Connect(function()
        if main and main.Parent then
            shadow.Position = UDim2.new(
                main.Position.X.Scale, main.Position.X.Offset - 16,
                main.Position.Y.Scale, main.Position.Y.Offset - 17
            )
        end
    end)

    -- ── Title Bar ─────────────────────────────────────────────────────────────
    local titleBar = New("Frame", {
        Name                 = "TitleBar",
        Size                 = UDim2.new(1, 0, 0, 50),
        Position             = UDim2.new(0, 0, 0, 0),
        BackgroundColor3     = T.TitleBG,
        BackgroundTransparency = T.TitleBGTrans,
        BorderSizePixel      = 0,
        ZIndex               = 2,
        Parent               = main,
    })
    -- Rounded top only (fill bottom half to remove bottom rounding)
    AddCorner(titleBar, 14)
    New("Frame", {
        Size                 = UDim2.new(1, 0, 0.5, 0),
        Position             = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3     = T.TitleBG,
        BackgroundTransparency = T.TitleBGTrans,
        BorderSizePixel      = 0,
        ZIndex               = 2,
        Parent               = titleBar,
    })
    -- Bottom divider
    New("Frame", {
        Name                 = "Divider",
        Size                 = UDim2.new(1, 0, 0, 1),
        Position             = UDim2.new(0, 0, 1, -1),
        BackgroundColor3     = T.Divider,
        BackgroundTransparency = T.DividerTrans,
        BorderSizePixel      = 0,
        ZIndex               = 3,
        Parent               = titleBar,
    })

    -- Logo image
    local logoW = 0
    if image and image ~= "" then
        New("ImageLabel", {
            Size               = UDim2.new(0, 28, 0, 28),
            Position           = UDim2.new(0, 12, 0.5, -14),
            BackgroundTransparency = 1,
            Image              = "rbxassetid://" .. tostring(image):gsub("rbxassetid://", ""),
            ZIndex             = 4,
            Parent             = titleBar,
        })
        logoW = 46
    end

    -- Title
    New("TextLabel", {
        Name        = "Title",
        Size        = UDim2.new(0, 220, 0, 22),
        Position    = UDim2.new(0, 12 + logoW, 0, 7),
        BackgroundTransparency = 1,
        Text        = title,
        TextColor3  = T.TitleText,
        TextSize    = 16,
        Font        = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex      = 4,
        Parent      = titleBar,
    })
    -- Author
    if author ~= "" then
        New("TextLabel", {
            Name        = "Author",
            Size        = UDim2.new(0, 220, 0, 14),
            Position    = UDim2.new(0, 12 + logoW, 0, 30),
            BackgroundTransparency = 1,
            Text        = author,
            TextColor3  = T.AuthorText,
            TextSize    = 11,
            Font        = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex      = 4,
            Parent      = titleBar,
        })
    end

    -- ── Search Bar (title bar, right area) ────────────────────────────────────
    local searchFrame = New("Frame", {
        Name                 = "SearchFrame",
        Size                 = UDim2.new(0, 168, 0, 28),
        Position             = UDim2.new(1, -244, 0.5, -14),
        BackgroundColor3     = T.SearchBG,
        BackgroundTransparency = T.SearchBGTrans,
        BorderSizePixel      = 0,
        ZIndex               = 4,
        Parent               = titleBar,
    })
    AddCorner(searchFrame, 8)
    AddStroke(searchFrame, T.InputStroke, 0.25, 1)

    -- Search icon (magnifier)
    New("ImageLabel", {
        Size               = UDim2.new(0, 14, 0, 14),
        Position           = UDim2.new(0, 8, 0.5, -7),
        BackgroundTransparency = 1,
        Image              = "rbxassetid://6031154871",
        ImageColor3        = T.SubText,
        ZIndex             = 5,
        Parent             = searchFrame,
    })

    local searchBox = New("TextBox", {
        Name               = "SearchBox",
        Size               = UDim2.new(1, -28, 1, 0),
        Position           = UDim2.new(0, 26, 0, 0),
        BackgroundTransparency = 1,
        Text               = "",
        PlaceholderText    = "Search...",
        PlaceholderColor3  = T.SubText,
        TextColor3         = T.Text,
        TextSize           = 12,
        Font               = Enum.Font.Gotham,
        TextXAlignment     = Enum.TextXAlignment.Left,
        ClearTextOnFocus   = false,
        ZIndex             = 5,
        Parent             = searchFrame,
    })
    win._searchBox = searchBox

    -- ── Close Button ──────────────────────────────────────────────────────────
    local closeBtn = New("ImageButton", {
        Name               = "CloseBtn",
        Size               = UDim2.new(0, 28, 0, 28),
        Position           = UDim2.new(1, -38, 0.5, -14),
        BackgroundColor3   = T.CloseRed,
        BackgroundTransparency = T.CloseTrans,
        BorderSizePixel    = 0,
        Image              = "rbxassetid://7743878857",
        ImageColor3        = Color3.fromRGB(255, 255, 255),
        ImageTransparency  = 0,
        ScaleType          = Enum.ScaleType.Fit,
        ZIndex             = 5,
        Parent             = titleBar,
    })
    AddCorner(closeBtn, 7)

    closeBtn.MouseEnter:Connect(function()
        Tween(closeBtn, { BackgroundTransparency = 0 }, 0.12)
    end)
    closeBtn.MouseLeave:Connect(function()
        Tween(closeBtn, { BackgroundTransparency = T.CloseTrans }, 0.12)
    end)
    closeBtn.MouseButton1Click:Connect(function()
        Tween(main,   { BackgroundTransparency = 1 }, 0.2)
        Tween(shadow, { ImageTransparency = 1 },      0.2)
        task.delay(0.22, function() gui:Destroy() end)
    end)

    -- Draggable via title bar
    MakeDraggable(main, titleBar)

    -- ── Left Panel ────────────────────────────────────────────────────────────
    local leftPanel = New("Frame", {
        Name                 = "LeftPanel",
        Size                 = UDim2.new(0, 148, 1, -62),
        Position             = UDim2.new(0, 8, 0, 54),
        BackgroundColor3     = T.LeftBG,
        BackgroundTransparency = T.LeftBGTrans,
        BorderSizePixel      = 0,
        ClipsDescendants     = true,
        ZIndex               = 2,
        Parent               = main,
    })
    AddCorner(leftPanel, 10)
    AddStroke(leftPanel, T.LeftStroke, T.LeftStrokeTrans, 1.1)

    local tabScroll = New("ScrollingFrame", {
        Name                   = "TabScroll",
        Size                   = UDim2.new(1, -4, 1, -8),
        Position               = UDim2.new(0, 2, 0, 4),
        BackgroundTransparency = 1,
        BorderSizePixel        = 0,
        ScrollBarThickness     = 3,
        ScrollBarImageColor3   = T.Accent,
        ScrollBarImageTransparency = 0.45,
        CanvasSize             = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize    = Enum.AutomaticSize.Y,
        ZIndex                 = 3,
        Parent                 = leftPanel,
    })
    New("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding   = UDim.new(0, 4),
        Parent    = tabScroll,
    })
    New("UIPadding", {
        PaddingLeft   = UDim.new(0, 5),
        PaddingRight  = UDim.new(0, 5),
        PaddingTop    = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5),
        Parent        = tabScroll,
    })
    win._tabScroll = tabScroll

    -- ── Right Panel ───────────────────────────────────────────────────────────
    local rightPanel = New("Frame", {
        Name                 = "RightPanel",
        Size                 = UDim2.new(1, -170, 1, -62),
        Position             = UDim2.new(0, 162, 0, 54),
        BackgroundTransparency = 1,
        BorderSizePixel      = 0,
        ClipsDescendants     = true,
        ZIndex               = 2,
        Parent               = main,
    })
    win._rightPanel = rightPanel

    -- ── Search Logic ──────────────────────────────────────────────────────────
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local q = searchBox.Text:lower():gsub("^%s+", ""):gsub("%s+$", "")
        for _, entry in ipairs(win._allElements) do
            if entry.frame and entry.frame.Parent then
                if q == "" then
                    entry.frame.Visible = true
                else
                    entry.frame.Visible = (entry.name:lower():find(q, 1, true) ~= nil)
                end
            end
        end
    end)

    return win
end

-- ─── CreateTab ───────────────────────────────────────────────────────────────
function SKUI:CreateTab(name)
    local win = self

    -- Tab button
    local tabBtn = New("TextButton", {
        Name                 = "Tab_" .. name,
        Size                 = UDim2.new(1, 0, 0, 34),
        BackgroundColor3     = T.TabBtn,
        BackgroundTransparency = T.TabBtnTrans,
        BorderSizePixel      = 0,
        Text                 = name,
        TextColor3           = T.TabText,
        TextSize             = 13,
        Font                 = Enum.Font.GothamSemibold,
        AutoButtonColor      = false,
        LayoutOrder          = #win._tabs + 1,
        ZIndex               = 4,
        Parent               = win._tabScroll,
    })
    AddCorner(tabBtn, 8)

    -- Tab content scroll
    local contentScroll = New("ScrollingFrame", {
        Name                   = "Content_" .. name,
        Size                   = UDim2.new(1, -4, 1, -8),
        Position               = UDim2.new(0, 2, 0, 4),
        BackgroundTransparency = 1,
        BorderSizePixel        = 0,
        ScrollBarThickness     = 3,
        ScrollBarImageColor3   = T.Accent,
        ScrollBarImageTransparency = 0.40,
        CanvasSize             = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize    = Enum.AutomaticSize.Y,
        Visible                = false,
        ZIndex                 = 3,
        Parent                 = win._rightPanel,
    })
    New("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding   = UDim.new(0, 8),
        Parent    = contentScroll,
    })
    New("UIPadding", {
        PaddingLeft   = UDim.new(0, 4),
        PaddingRight  = UDim.new(0, 8),
        PaddingTop    = UDim.new(0, 4),
        PaddingBottom = UDim.new(0, 8),
        Parent        = contentScroll,
    })

    local tabData = {
        _name    = name,
        _btn     = tabBtn,
        _content = contentScroll,
        _win     = win,
    }

    -- Select on click
    tabBtn.MouseButton1Click:Connect(function()
        win:_SelectTab(tabData)
    end)
    tabBtn.MouseEnter:Connect(function()
        if win._activeTab ~= tabData then
            Tween(tabBtn, { BackgroundTransparency = T.TabHover }, 0.12)
        end
    end)
    tabBtn.MouseLeave:Connect(function()
        if win._activeTab ~= tabData then
            Tween(tabBtn, { BackgroundTransparency = T.TabBtnTrans }, 0.12)
        end
    end)

    table.insert(win._tabs, tabData)

    -- Auto-select first
    if #win._tabs == 1 then
        win:_SelectTab(tabData)
    end

    -- Tab methods via metatable
    setmetatable(tabData, {
        __index = {
            CreateGroupbox = function(td, gbName)
                return win:_CreateGroupbox(td, gbName)
            end,
        },
    })

    return tabData
end

function SKUI:_SelectTab(tabData)
    for _, td in ipairs(self._tabs) do
        td._content.Visible = false
        Tween(td._btn, {
            BackgroundColor3     = T.TabBtn,
            BackgroundTransparency = T.TabBtnTrans,
            TextColor3           = T.TabText,
        }, 0.18)
    end
    tabData._content.Visible = true
    Tween(tabData._btn, {
        BackgroundColor3     = T.TabBtnActive,
        BackgroundTransparency = T.TabBtnActiveTrans,
        TextColor3           = T.TabTextActive,
    }, 0.18)
    self._activeTab = tabData
end

-- ─── CreateGroupbox ──────────────────────────────────────────────────────────
function SKUI:_CreateGroupbox(tabData, name)
    local win = self

    local groupFrame = New("Frame", {
        Name                 = "Group_" .. name,
        Size                 = UDim2.new(1, 0, 0, 40),
        AutomaticSize        = Enum.AutomaticSize.Y,
        BackgroundColor3     = T.GroupBG,
        BackgroundTransparency = T.GroupBGTrans,
        BorderSizePixel      = 0,
        ZIndex               = 4,
        Parent               = tabData._content,
    })
    AddCorner(groupFrame, 10)
    AddStroke(groupFrame, T.GroupStroke, T.GroupStrokeTrans, 1.1)

    -- Group title
    New("TextLabel", {
        Name        = "GBTitle",
        Size        = UDim2.new(1, -16, 0, 30),
        Position    = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text        = name,
        TextColor3  = T.GroupTitle,
        TextSize    = 13,
        Font        = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex      = 5,
        Parent      = groupFrame,
    })
    -- Divider
    New("Frame", {
        Size                 = UDim2.new(1, -16, 0, 1),
        Position             = UDim2.new(0, 8, 0, 30),
        BackgroundColor3     = T.Divider,
        BackgroundTransparency = T.DividerTrans,
        BorderSizePixel      = 0,
        ZIndex               = 5,
        Parent               = groupFrame,
    })

    -- Elements container
    local elemBox = New("Frame", {
        Name                 = "Elements",
        Size                 = UDim2.new(1, 0, 0, 0),
        Position             = UDim2.new(0, 0, 0, 33),
        AutomaticSize        = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        ZIndex               = 5,
        Parent               = groupFrame,
    })
    New("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding   = UDim.new(0, 2),
        Parent    = elemBox,
    })
    New("UIPadding", {
        PaddingLeft   = UDim.new(0, 8),
        PaddingRight  = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 8),
        Parent        = elemBox,
    })

    local groupData = {
        _name      = name,
        _frame     = groupFrame,
        _container = elemBox,
        _tab       = tabData,
        _win       = win,
    }

    setmetatable(groupData, {
        __index = {
            CreateButton   = function(gd, cfg) return win:_CreateButton(gd, cfg)   end,
            CreateToggle   = function(gd, cfg) return win:_CreateToggle(gd, cfg)   end,
            CreateSlider   = function(gd, cfg) return win:_CreateSlider(gd, cfg)   end,
            CreateInput    = function(gd, cfg) return win:_CreateInput(gd, cfg)    end,
            CreateDropdown = function(gd, cfg) return win:_CreateDropdown(gd, cfg) end,
        },
    })

    return groupData
end

-- ─── Element Row Helper ───────────────────────────────────────────────────────
local function ElemRow(parent, name, height)
    return New("Frame", {
        Name                 = name,
        Size                 = UDim2.new(1, 0, 0, height or 36),
        BackgroundTransparency = 1,
        ZIndex               = 6,
        Parent               = parent,
    })
end

-- ─── Button ──────────────────────────────────────────────────────────────────
function SKUI:_CreateButton(gd, config)
    config = config or {}
    local locked = config.Locked == true
    local row = ElemRow(gd._container, "Btn_" .. (config.Title or "Button"), 38)

    local btn = New("TextButton", {
        Name                 = "Btn",
        Size                 = UDim2.new(1, 0, 0, 30),
        Position             = UDim2.new(0, 0, 0, 4),
        BackgroundColor3     = locked and T.BtnLocked or T.BtnBG,
        BackgroundTransparency = locked and T.BtnLockedTrans or T.BtnBGTrans,
        BorderSizePixel      = 0,
        Text                 = config.Title or "Button",
        TextColor3           = locked and T.SubText or T.BtnText,
        TextSize             = 13,
        Font                 = Enum.Font.GothamSemibold,
        AutoButtonColor      = false,
        ZIndex               = 7,
        Parent               = row,
    })
    AddCorner(btn, 7)

    if not locked then
        btn.MouseEnter:Connect(function()
            Tween(btn, { BackgroundTransparency = 0 }, 0.12)
        end)
        btn.MouseLeave:Connect(function()
            Tween(btn, { BackgroundTransparency = T.BtnBGTrans }, 0.12)
        end)
        btn.MouseButton1Click:Connect(function()
            Tween(btn, { BackgroundTransparency = 0.35 }, 0.05)
            task.delay(0.12, function()
                Tween(btn, { BackgroundTransparency = T.BtnBGTrans }, 0.12)
            end)
            if config.Callback then pcall(config.Callback) end
        end)
    end

    table.insert(self._allElements, {
        name    = config.Title or "Button",
        frame   = row,
        tabName = gd._tab._name,
    })
    return { _frame = row, _btn = btn }
end

-- ─── Toggle ──────────────────────────────────────────────────────────────────
function SKUI:_CreateToggle(gd, config)
    config = config or {}
    local value = config.Value == true
    local height = (config.Desc and config.Desc ~= "") and 46 or 36
    local row = ElemRow(gd._container, "Toggle_" .. (config.Title or "Toggle"), height)

    New("TextLabel", {
        Size        = UDim2.new(1, -60, 0, 20),
        Position    = UDim2.new(0, 4, 0, height == 46 and 4 or 8),
        BackgroundTransparency = 1,
        Text        = config.Title or "Toggle",
        TextColor3  = T.Text,
        TextSize    = 13,
        Font        = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex      = 7,
        Parent      = row,
    })
    if config.Desc and config.Desc ~= "" then
        New("TextLabel", {
            Size        = UDim2.new(1, -60, 0, 14),
            Position    = UDim2.new(0, 4, 0, 24),
            BackgroundTransparency = 1,
            Text        = config.Desc,
            TextColor3  = T.SubText,
            TextSize    = 10,
            Font        = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex      = 7,
            Parent      = row,
        })
    end

    local toggleBG = New("Frame", {
        Name                 = "ToggleBG",
        Size                 = UDim2.new(0, 44, 0, 24),
        Position             = UDim2.new(1, -47, 0.5, -12),
        BackgroundColor3     = value and T.ToggleOn or T.ToggleOff,
        BorderSizePixel      = 0,
        ZIndex               = 7,
        Parent               = row,
    })
    AddCorner(toggleBG, 50)

    local knob = New("Frame", {
        Name                 = "Knob",
        Size                 = UDim2.new(0, 18, 0, 18),
        Position             = value and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
        BackgroundColor3     = T.ToggleKnob,
        BorderSizePixel      = 0,
        ZIndex               = 8,
        Parent               = toggleBG,
    })
    AddCorner(knob, 50)

    local hitbox = New("TextButton", {
        Size                 = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text                 = "",
        ZIndex               = 9,
        Parent               = toggleBG,
    })

    local togData = { Value = value }

    local function setToggle(state, silent)
        togData.Value = state
        Tween(toggleBG, { BackgroundColor3 = state and T.ToggleOn or T.ToggleOff }, 0.18)
        Tween(knob, {
            Position = state
                and UDim2.new(1, -21, 0.5, -9)
                or  UDim2.new(0,  3, 0.5, -9),
        }, 0.18)
        if not silent and config.Callback then
            pcall(config.Callback, state)
        end
    end

    hitbox.MouseButton1Click:Connect(function()
        setToggle(not togData.Value)
    end)

    togData.Set = setToggle
    table.insert(self._allElements, {
        name = config.Title or "Toggle", frame = row, tabName = gd._tab._name,
    })
    return togData
end

-- ─── Slider ───────────────────────────────────────────────────────────────────
function SKUI:_CreateSlider(gd, config)
    config = config or {}
    local vCfg   = config.Value or {}
    local minV   = vCfg.Min     or 0
    local maxV   = vCfg.Max     or 100
    local defV   = vCfg.Default or minV
    local step   = config.Step  or 1
    local cur    = math.clamp(defV, minV, maxV)

    local row = ElemRow(gd._container, "Slider_" .. (config.Title or "Slider"), 52)

    New("TextLabel", {
        Size        = UDim2.new(1, -65, 0, 18),
        Position    = UDim2.new(0, 4, 0, 4),
        BackgroundTransparency = 1,
        Text        = config.Title or "Slider",
        TextColor3  = T.Text,
        TextSize    = 13,
        Font        = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex      = 7,
        Parent      = row,
    })

    local valLabel = New("TextLabel", {
        Name        = "ValLabel",
        Size        = UDim2.new(0, 58, 0, 18),
        Position    = UDim2.new(1, -62, 0, 4),
        BackgroundTransparency = 1,
        Text        = tostring(cur),
        TextColor3  = T.Accent,
        TextSize    = 13,
        Font        = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Right,
        ZIndex      = 7,
        Parent      = row,
    })

    local track = New("Frame", {
        Name                 = "Track",
        Size                 = UDim2.new(1, -8, 0, 8),
        Position             = UDim2.new(0, 4, 0, 30),
        BackgroundColor3     = T.SliderTrack,
        BorderSizePixel      = 0,
        ZIndex               = 7,
        Parent               = row,
    })
    AddCorner(track, 50)

    local pct0 = (cur - minV) / (maxV - minV)
    local fill = New("Frame", {
        Name                 = "Fill",
        Size                 = UDim2.new(pct0, 0, 1, 0),
        BackgroundColor3     = T.SliderFill,
        BorderSizePixel      = 0,
        ZIndex               = 8,
        Parent               = track,
    })
    AddCorner(fill, 50)

    local knob = New("Frame", {
        Name                 = "Knob",
        Size                 = UDim2.new(0, 16, 0, 16),
        AnchorPoint          = Vector2.new(0.5, 0.5),
        Position             = UDim2.new(pct0, 0, 0.5, 0),
        BackgroundColor3     = T.SliderKnob,
        BorderSizePixel      = 0,
        ZIndex               = 9,
        Parent               = track,
    })
    AddCorner(knob, 50)
    AddStroke(knob, T.SliderFill, 0.18, 2)

    local sliding  = false
    local slData   = { Value = cur }

    local function snap(raw)
        local s = math.round(raw / step) * step
        s = math.clamp(s, minV, maxV)
        if step < 1 then
            local dec = #tostring(step):match("%.(%d+)")
            s = tonumber(string.format("%." .. (dec or 1) .. "f", s))
        end
        return s
    end

    local function updateSlider(inputX)
        local ap  = track.AbsolutePosition.X
        local as  = track.AbsoluteSize.X
        local rel = math.clamp((inputX - ap) / as, 0, 1)
        local val = snap(minV + rel * (maxV - minV))
        slData.Value = val
        valLabel.Text = tostring(val)
        local p = (val - minV) / (maxV - minV)
        fill.Size     = UDim2.new(p, 0, 1, 0)
        knob.Position = UDim2.new(p, 0, 0.5, 0)
        if config.Callback then pcall(config.Callback, val) end
    end

    track.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            sliding = true
            updateSlider(i.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if sliding and (
            i.UserInputType == Enum.UserInputType.MouseMovement
         or i.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(i.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)

    table.insert(self._allElements, {
        name = config.Title or "Slider", frame = row, tabName = gd._tab._name,
    })
    return slData
end

-- ─── Input ────────────────────────────────────────────────────────────────────
function SKUI:_CreateInput(gd, config)
    config = config or {}
    local row = ElemRow(gd._container, "Input_" .. (config.Title or "Input"), 56)

    New("TextLabel", {
        Size        = UDim2.new(1, -8, 0, 18),
        Position    = UDim2.new(0, 4, 0, 4),
        BackgroundTransparency = 1,
        Text        = config.Title or "Input",
        TextColor3  = T.Text,
        TextSize    = 13,
        Font        = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex      = 7,
        Parent      = row,
    })

    local bg = New("Frame", {
        Size                 = UDim2.new(1, -8, 0, 28),
        Position             = UDim2.new(0, 4, 0, 24),
        BackgroundColor3     = T.InputBG,
        BackgroundTransparency = T.InputBGTrans,
        BorderSizePixel      = 0,
        ZIndex               = 7,
        Parent               = row,
    })
    AddCorner(bg, 7)
    AddStroke(bg, T.InputStroke, 0.25, 1)

    local box = New("TextBox", {
        Size               = UDim2.new(1, -12, 1, 0),
        Position           = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text               = config.Value or "",
        PlaceholderText    = config.Placeholder or "Enter text...",
        PlaceholderColor3  = T.SubText,
        TextColor3         = T.Text,
        TextSize           = 12,
        Font               = Enum.Font.Gotham,
        TextXAlignment     = Enum.TextXAlignment.Left,
        ClearTextOnFocus   = false,
        ZIndex             = 8,
        Parent             = bg,
    })

    box.Focused:Connect(function()
        Tween(bg, { BackgroundTransparency = 0.15 }, 0.14)
    end)
    box.FocusLost:Connect(function(enter)
        Tween(bg, { BackgroundTransparency = T.InputBGTrans }, 0.14)
        if enter and config.Callback then
            pcall(config.Callback, box.Text)
        end
    end)

    local inData = {
        Value = box.Text,
        _box  = box,
        Set   = function(v) box.Text = v end,
    }
    table.insert(self._allElements, {
        name = config.Title or "Input", frame = row, tabName = gd._tab._name,
    })
    return inData
end

-- ─── Dropdown ────────────────────────────────────────────────────────────────
function SKUI:_CreateDropdown(gd, config)
    config = config or {}
    local values   = config.Values or {}
    local selValue = config.Value  or (values[1] or "Select...")

    local row = ElemRow(gd._container, "DD_" .. (config.Title or "Dropdown"), 56)

    New("TextLabel", {
        Size        = UDim2.new(1, -8, 0, 18),
        Position    = UDim2.new(0, 4, 0, 4),
        BackgroundTransparency = 1,
        Text        = config.Title or "Dropdown",
        TextColor3  = T.Text,
        TextSize    = 13,
        Font        = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex      = 7,
        Parent      = row,
    })

    local dropBtn = New("TextButton", {
        Size                 = UDim2.new(1, -8, 0, 28),
        Position             = UDim2.new(0, 4, 0, 24),
        BackgroundColor3     = T.DropBG,
        BackgroundTransparency = 0.28,
        BorderSizePixel      = 0,
        Text                 = "",
        AutoButtonColor      = false,
        ZIndex               = 7,
        Parent               = row,
    })
    AddCorner(dropBtn, 7)
    AddStroke(dropBtn, T.InputStroke, 0.20, 1)

    local selLabel = New("TextLabel", {
        Size        = UDim2.new(1, -30, 1, 0),
        Position    = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text        = selValue,
        TextColor3  = T.Text,
        TextSize    = 12,
        Font        = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex      = 8,
        Parent      = dropBtn,
    })

    -- Arrow
    New("TextLabel", {
        Size        = UDim2.new(0, 22, 1, 0),
        Position    = UDim2.new(1, -22, 0, 0),
        BackgroundTransparency = 1,
        Text        = "▾",
        TextColor3  = T.Accent,
        TextSize    = 14,
        Font        = Enum.Font.GothamBold,
        ZIndex      = 8,
        Parent      = dropBtn,
    })

    local ddData = { Value = selValue, _values = values }

    -- Open popup
    local function openDropdown()
        local itemH    = 34
        local padding  = 50   -- title + divider + bottom pad
        local maxH     = 260
        local totalH   = math.min(#ddData._values * itemH + padding, maxH)

        -- Backdrop
        local backdrop = New("Frame", {
            Name                 = "DDBackdrop",
            Size                 = UDim2.new(1, 0, 1, 0),
            BackgroundColor3     = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 0.55,
            ZIndex               = 98,
            Parent               = self._gui,
        })

        -- Popup frame
        local popup = New("Frame", {
            Name                 = "DDPopup",
            Size                 = UDim2.new(0, 240, 0, totalH),
            Position             = UDim2.new(0.5, -120, 0.5, -(totalH / 2)),
            BackgroundColor3     = T.DropBG,
            BackgroundTransparency = 0.04,
            BorderSizePixel      = 0,
            ZIndex               = 99,
            Parent               = self._gui,
        })
        AddCorner(popup, 12)
        AddStroke(popup, T.InputStroke, 0.10, 1.4)

        -- Popup title
        New("TextLabel", {
            Size        = UDim2.new(1, -16, 0, 32),
            Position    = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text        = config.Title or "Select Option",
            TextColor3  = T.GroupTitle,
            TextSize    = 13,
            Font        = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex      = 100,
            Parent      = popup,
        })
        New("Frame", {
            Size                 = UDim2.new(1, -16, 0, 1),
            Position             = UDim2.new(0, 8, 0, 32),
            BackgroundColor3     = T.Divider,
            BackgroundTransparency = T.DividerTrans,
            BorderSizePixel      = 0,
            ZIndex               = 100,
            Parent               = popup,
        })

        -- Items scroll
        local iScroll = New("ScrollingFrame", {
            Size                   = UDim2.new(1, -8, 1, -40),
            Position               = UDim2.new(0, 4, 0, 36),
            BackgroundTransparency = 1,
            BorderSizePixel        = 0,
            ScrollBarThickness     = 3,
            ScrollBarImageColor3   = T.Accent,
            ScrollBarImageTransparency = 0.4,
            CanvasSize             = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize    = Enum.AutomaticSize.Y,
            ZIndex                 = 100,
            Parent                 = popup,
        })
        New("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding   = UDim.new(0, 3),
            Parent    = iScroll,
        })
        New("UIPadding", {
            PaddingTop    = UDim.new(0, 2),
            PaddingBottom = UDim.new(0, 4),
            PaddingLeft   = UDim.new(0, 2),
            PaddingRight  = UDim.new(0, 2),
            Parent        = iScroll,
        })

        local function closePopup()
            Tween(popup, {
                Size     = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0),
            }, 0.14)
            task.delay(0.15, function()
                popup:Destroy()
                backdrop:Destroy()
            end)
        end

        backdrop.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                closePopup()
            end
        end)

        -- Build items
        for _, v in ipairs(ddData._values) do
            local isSel = (v == ddData.Value)
            local item  = New("TextButton", {
                Size                 = UDim2.new(1, 0, 0, itemH - 2),
                BackgroundColor3     = isSel and T.DropSelected or T.DropItem,
                BackgroundTransparency = isSel and 0.10 or 0.30,
                BorderSizePixel      = 0,
                Text                 = v,
                TextColor3           = isSel and Color3.fromRGB(255,255,255) or T.Text,
                TextSize             = 12,
                Font                 = isSel and Enum.Font.GothamBold or Enum.Font.Gotham,
                AutoButtonColor      = false,
                ZIndex               = 101,
                Parent               = iScroll,
            })
            AddCorner(item, 6)

            item.MouseEnter:Connect(function()
                if not (v == ddData.Value) then
                    Tween(item, {
                        BackgroundColor3     = T.DropItemHover,
                        BackgroundTransparency = 0.10,
                    }, 0.10)
                end
            end)
            item.MouseLeave:Connect(function()
                if not (v == ddData.Value) then
                    Tween(item, {
                        BackgroundColor3     = T.DropItem,
                        BackgroundTransparency = 0.30,
                    }, 0.10)
                end
            end)

            item.MouseButton1Click:Connect(function()
                ddData.Value = v
                selLabel.Text = v
                if config.Callback then pcall(config.Callback, v) end
                closePopup()
            end)
        end

        -- Animate in
        popup.Size     = UDim2.new(0, 0, 0, 0)
        popup.Position = UDim2.new(0.5, 0, 0.5, 0)
        Tween(popup, {
            Size     = UDim2.new(0, 240, 0, totalH),
            Position = UDim2.new(0.5, -120, 0.5, -(totalH / 2)),
        }, 0.20, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end

    dropBtn.MouseButton1Click:Connect(openDropdown)

    -- Hover
    dropBtn.MouseEnter:Connect(function()
        Tween(dropBtn, { BackgroundTransparency = 0.10 }, 0.12)
    end)
    dropBtn.MouseLeave:Connect(function()
        Tween(dropBtn, { BackgroundTransparency = 0.28 }, 0.12)
    end)

    -- Refresh method
    ddData.Refresh = function(newValues)
        ddData._values = newValues
        if not table.find(newValues, ddData.Value) then
            ddData.Value  = newValues[1] or "Select..."
            selLabel.Text = ddData.Value
        end
    end

    table.insert(self._allElements, {
        name = config.Title or "Dropdown", frame = row, tabName = gd._tab._name,
    })
    return ddData
end

-- ─── MinimizeBtn (Floating + Draggable) ──────────────────────────────────────
function SKUI:CreateMinimizeBtn(config)
    config = config or {}
    local label = config.Title or "Open UI"
    local img   = config.Image or ""

    local minFrame = New("Frame", {
        Name                 = "MinimizeBtn",
        Size                 = UDim2.new(0, 140, 0, 44),
        Position             = UDim2.new(0.5, -70, 0.88, -22),
        BackgroundColor3     = T.MinBG,
        BackgroundTransparency = T.MinBGTrans,
        BorderSizePixel      = 0,
        ZIndex               = 60,
        Parent               = self._gui,
    })
    AddCorner(minFrame, 12)
    AddStroke(minFrame, T.Accent, 0.28, 1.4)

    -- Shadow
    New("ImageLabel", {
        Size               = UDim2.new(1, 22, 1, 22),
        Position           = UDim2.new(0, -11, 0, 6),
        BackgroundTransparency = 1,
        Image              = "rbxassetid://5554236805",
        ImageColor3        = T.Shadow,
        ImageTransparency  = 0.62,
        ScaleType          = Enum.ScaleType.Slice,
        SliceCenter        = Rect.new(23, 23, 277, 277),
        ZIndex             = 59,
        Parent             = minFrame,
    })

    local textLeft = 12
    if img ~= "" then
        New("ImageLabel", {
            Size               = UDim2.new(0, 24, 0, 24),
            Position           = UDim2.new(0, 10, 0.5, -12),
            BackgroundTransparency = 1,
            Image              = "rbxassetid://" .. tostring(img):gsub("rbxassetid://", ""),
            ZIndex             = 61,
            Parent             = minFrame,
        })
        textLeft = 40
    end

    New("TextLabel", {
        Size        = UDim2.new(1, -(textLeft + 10), 1, 0),
        Position    = UDim2.new(0, textLeft, 0, 0),
        BackgroundTransparency = 1,
        Text        = label,
        TextColor3  = T.MinText,
        TextSize    = 13,
        Font        = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex      = 61,
        Parent      = minFrame,
    })

    -- Drag (with click discrimination)
    local wasDragged = MakeDraggable(minFrame)

    -- Click button on top
    local hitbox = New("TextButton", {
        Size                 = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text                 = "",
        ZIndex               = 62,
        Parent               = minFrame,
    })

    hitbox.MouseEnter:Connect(function()
        Tween(minFrame, { BackgroundTransparency = 0 }, 0.12)
    end)
    hitbox.MouseLeave:Connect(function()
        Tween(minFrame, { BackgroundTransparency = T.MinBGTrans }, 0.12)
    end)

    local main = self._main

    hitbox.MouseButton1Click:Connect(function()
        if wasDragged() then return end   -- ignore click if dragged
        self._visible = not self._visible
        if self._visible then
            main.Visible = true
            Tween(main, { BackgroundTransparency = T.WinTrans }, 0.22)
        else
            Tween(main, { BackgroundTransparency = 1 }, 0.18)
            task.delay(0.20, function() main.Visible = false end)
        end
    end)

    return { _frame = minFrame }
end

-- ─── Return ───────────────────────────────────────────────────────────────────
return SKUI
