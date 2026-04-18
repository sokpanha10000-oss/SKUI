--[[
    ╔══════════════════════════════════════════╗
    ║         ftgs UI Library v1.0             ║
    ║     Script Hub · Draggable · Tabs        ║
    ╚══════════════════════════════════════════╝

    USAGE:
    local UI = loadstring(game:HttpGet("YOUR_RAW_URL"))()

    local Window = UI:CreateWindow({
        Title  = "My Super Hub",
        Author = "by .ftgs and .ftgs",
    })

    local MinimizeBtn = Window:CreateMinimizeBtn({
        Title = "Open UI",
        Color = "Red",   -- Red | Green | Blue | Purple | Yellow | Orange
    })

    local Tab = Window:Tab({
        Title  = "Tab Title",
        Locked = false,
    })

    local Button = Tab:Button({
        Title    = "Button",
        Desc     = "Test Button",
        Locked   = false,
        Callback = function() end,
    })

    local Dropdown = Tab:Dropdown({
        Title    = "Dropdown",
        Desc     = "Dropdown Description",
        Values   = { "Category A", "Category B", "Category C" },
        Value    = "Category A",
        Callback = function(option) print(option) end,
    })

    local Toggle = Tab:Toggle({
        Title    = "Toggle",
        Desc     = "Toggle Description",
        Value    = false,
        Callback = function(state) print(tostring(state)) end,
    })

    local Slider = Tab:Slider({
        Title    = "Slider",
        Desc     = "Slider Description",
        Step     = 1,          -- float supported, e.g. 0.1
        Value    = { Min = 20, Max = 120, Default = 70 },
        Callback = function(value) print(value) end,
    })

    local Input = Tab:Input({
        Title       = "Input",
        Desc        = "Input Description",
        Value       = "Default value",
        Type        = "Input",  -- "Input" | "Textarea"
        Placeholder = "Enter text...",
        Callback    = function(text) print(text) end,
    })
--]]

-- ─────────────────────────────────────────────
--  Services
-- ─────────────────────────────────────────────
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

-- ─────────────────────────────────────────────
--  Helpers
-- ─────────────────────────────────────────────
local function Tween(obj, info, props)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function Corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

local function Stroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Parent = parent
    return s
end

local function MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, mousePos, framePos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            mousePos  = input.Position
            framePos  = frame.Position
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
            local delta = input.Position - mousePos
            frame.Position = UDim2.new(
                framePos.X.Scale, framePos.X.Offset + delta.X,
                framePos.Y.Scale, framePos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ─────────────────────────────────────────────
--  Theme
-- ─────────────────────────────────────────────
local T = {
    Bg         = Color3.fromRGB(15,  15,  22 ),
    Secondary  = Color3.fromRGB(22,  22,  32 ),
    Tertiary   = Color3.fromRGB(30,  30,  44 ),
    Elem       = Color3.fromRGB(26,  26,  38 ),
    Accent     = Color3.fromRGB(108, 84,  230),
    AccentHov  = Color3.fromRGB(130, 108, 252),
    AccentDim  = Color3.fromRGB(70,  54,  160),
    Text       = Color3.fromRGB(238, 238, 252),
    SubText    = Color3.fromRGB(148, 148, 172),
    Border     = Color3.fromRGB(44,  44,  62 ),
    Success    = Color3.fromRGB(72,  196, 120),
    Danger     = Color3.fromRGB(220, 74,  74 ),
    Warning    = Color3.fromRGB(220, 164, 60 ),
    Blue       = Color3.fromRGB(70,  130, 220),
    Orange     = Color3.fromRGB(220, 118, 58 ),
}

-- ─────────────────────────────────────────────
--  ScreenGui
-- ─────────────────────────────────────────────
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name            = "ftgsUILibrary"
ScreenGui.ResetOnSpawn    = false
ScreenGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder    = 999
ScreenGui.IgnoreGuiInset  = true

local ok = pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not ok or not ScreenGui.Parent then
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
end

-- ─────────────────────────────────────────────
--  Dropdown Popup (global, shared)
-- ─────────────────────────────────────────────
local Overlay = Instance.new("Frame")
Overlay.Name                = "DropdownOverlay"
Overlay.Size                = UDim2.fromScale(1, 1)
Overlay.BackgroundColor3    = Color3.fromRGB(0,0,0)
Overlay.BackgroundTransparency = 0.55
Overlay.BorderSizePixel     = 0
Overlay.ZIndex              = 200
Overlay.Visible             = false
Overlay.Parent              = ScreenGui

local Popup = Instance.new("Frame")
Popup.Name              = "DropdownPopup"
Popup.Size              = UDim2.new(0, 270, 0, 0)
Popup.AnchorPoint       = Vector2.new(0.5, 0.5)
Popup.Position          = UDim2.fromScale(0.5, 0.5)
Popup.BackgroundColor3  = T.Secondary
Popup.BorderSizePixel   = 0
Popup.ZIndex            = 201
Popup.ClipsDescendants  = true
Popup.Parent            = Overlay
Corner(Popup, 12)
Stroke(Popup, T.Border, 1)

local PopupTitle = Instance.new("TextLabel")
PopupTitle.Size                = UDim2.new(1, -16, 0, 38)
PopupTitle.Position            = UDim2.new(0, 14, 0, 0)
PopupTitle.BackgroundTransparency = 1
PopupTitle.Text                = "Select"
PopupTitle.TextColor3          = T.Text
PopupTitle.Font                = Enum.Font.GothamBold
PopupTitle.TextSize            = 14
PopupTitle.TextXAlignment      = Enum.TextXAlignment.Left
PopupTitle.ZIndex              = 202
PopupTitle.Parent              = Popup

local PopupDivider = Instance.new("Frame")
PopupDivider.Size            = UDim2.new(1, -20, 0, 1)
PopupDivider.Position        = UDim2.new(0, 10, 0, 38)
PopupDivider.BackgroundColor3= T.Border
PopupDivider.BorderSizePixel = 0
PopupDivider.ZIndex          = 202
PopupDivider.Parent          = Popup

local PopupScroll = Instance.new("ScrollingFrame")
PopupScroll.Size                  = UDim2.new(1, -10, 1, -50)
PopupScroll.Position              = UDim2.new(0, 5, 0, 44)
PopupScroll.BackgroundTransparency = 1
PopupScroll.BorderSizePixel       = 0
PopupScroll.ScrollBarThickness    = 3
PopupScroll.ScrollBarImageColor3  = T.Accent
PopupScroll.CanvasSize            = UDim2.new(0, 0, 0, 0)
PopupScroll.ZIndex                = 202
PopupScroll.Parent                = Popup

local PopupList = Instance.new("UIListLayout")
PopupList.SortOrder = Enum.SortOrder.LayoutOrder
PopupList.Padding   = UDim.new(0, 4)
PopupList.Parent    = PopupScroll

local PopupPad = Instance.new("UIPadding")
PopupPad.PaddingTop    = UDim.new(0, 4)
PopupPad.PaddingBottom = UDim.new(0, 6)
PopupPad.PaddingLeft   = UDim.new(0, 4)
PopupPad.PaddingRight  = UDim.new(0, 4)
PopupPad.Parent        = PopupScroll

-- Close overlay on background click
Overlay.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Tween(Overlay, TweenInfo.new(0.15), {BackgroundTransparency = 1})
        task.delay(0.15, function() Overlay.Visible = false end)
    end
end)

local function OpenDropdown(title, values, currentValue, onSelect)
    PopupTitle.Text = title

    -- Clear previous items
    for _, c in ipairs(PopupScroll:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end

    local active = currentValue
    for _, val in ipairs(values) do
        local item = Instance.new("TextButton")
        item.Size             = UDim2.new(1, 0, 0, 36)
        item.BackgroundColor3 = val == active and T.Accent or T.Tertiary
        item.BorderSizePixel  = 0
        item.Text             = val
        item.TextColor3       = T.Text
        item.Font             = Enum.Font.Gotham
        item.TextSize         = 13
        item.ZIndex           = 203
        item.Parent           = PopupScroll
        Corner(item, 7)

        item.MouseEnter:Connect(function()
            if val ~= active then
                Tween(item, TweenInfo.new(0.1), {BackgroundColor3 = T.Border})
            end
        end)
        item.MouseLeave:Connect(function()
            if val ~= active then
                Tween(item, TweenInfo.new(0.1), {BackgroundColor3 = T.Tertiary})
            end
        end)

        item.MouseButton1Click:Connect(function()
            active = val
            for _, sib in ipairs(PopupScroll:GetChildren()) do
                if sib:IsA("TextButton") then
                    Tween(sib, TweenInfo.new(0.12), {
                        BackgroundColor3 = sib.Text == val and T.Accent or T.Tertiary
                    })
                end
            end
            onSelect(val)
            Tween(Popup, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                {Size = UDim2.new(0, 270, 0, 0)})
            task.delay(0.15, function()
                Overlay.Visible = false
            end)
        end)
    end

    local count = #values
    local targetH = math.min(count * 40 + 56, 300)
    PopupScroll.CanvasSize = UDim2.new(0, 0, 0, count * 40 + 10)

    Popup.Size = UDim2.new(0, 270, 0, 0)
    Overlay.BackgroundTransparency = 1
    Overlay.Visible = true
    Tween(Overlay, TweenInfo.new(0.2), {BackgroundTransparency = 0.55})
    Tween(Popup, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, 270, 0, targetH)})
end

-- ─────────────────────────────────────────────
--  Library
-- ─────────────────────────────────────────────
local Library = {}
Library.__index = Library

function Library:CreateWindow(config)
    config = config or {}
    local winTitle  = config.Title  or "Hub"
    local winAuthor = config.Author or ""

    -- ── Main Frame ──────────────────────────────
    local Main = Instance.new("Frame")
    Main.Name            = "MainWindow"
    Main.Size            = UDim2.new(0, 560, 0, 350)
    Main.Position        = UDim2.new(0.5, -290, 0.5, -210)
    Main.BackgroundColor3= T.Bg
    Main.BorderSizePixel = 0
    Main.ClipsDescendants= true
    Main.Parent          = ScreenGui
    Corner(Main, 14)
    Stroke(Main, T.Border)

    -- Shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Size                  = UDim2.new(1, 40, 1, 40)
    Shadow.Position              = UDim2.new(0, -20, 0, -20)
    Shadow.BackgroundTransparency= 1
    Shadow.Image                 = "rbxassetid://6014261993"
    Shadow.ImageColor3           = Color3.fromRGB(0,0,0)
    Shadow.ImageTransparency     = 0.55
    Shadow.ScaleType             = Enum.ScaleType.Slice
    Shadow.SliceCenter           = Rect.new(49, 49, 450, 450)
    Shadow.ZIndex                = -1
    Shadow.Parent                = Main

    -- ── Title Bar ───────────────────────────────
    local TitleBar = Instance.new("Frame")
    TitleBar.Size            = UDim2.new(1, 0, 0, 46)
    TitleBar.BackgroundColor3= T.Secondary
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent          = Main
    Corner(TitleBar, 14)

    -- fill bottom corners of titlebar
    local TBFix = Instance.new("Frame")
    TBFix.Size            = UDim2.new(1, 0, 0, 14)
    TBFix.Position        = UDim2.new(0, 0, 1, -14)
    TBFix.BackgroundColor3= T.Secondary
    TBFix.BorderSizePixel = 0
    TBFix.Parent          = TitleBar

    -- accent pill
    local Pill = Instance.new("Frame")
    Pill.Size            = UDim2.new(0, 3, 0, 22)
    Pill.Position        = UDim2.new(0, 14, 0.5, -11)
    Pill.BackgroundColor3= T.Accent
    Pill.BorderSizePixel = 0
    Pill.Parent          = TitleBar
    Corner(Pill, 3)

    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Size                = UDim2.new(1, -160, 1, 0)
    TitleLbl.Position            = UDim2.new(0, 26, 0, 0)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text                = winTitle
    TitleLbl.TextColor3          = T.Text
    TitleLbl.Font                = Enum.Font.GothamBold
    TitleLbl.TextSize            = 15
    TitleLbl.TextXAlignment      = Enum.TextXAlignment.Left
    TitleLbl.Parent              = TitleBar

    if winAuthor ~= "" then
        local AuthorLbl = Instance.new("TextLabel")
        AuthorLbl.Size                = UDim2.new(0, 160, 1, 0)
        AuthorLbl.Position            = UDim2.new(1, -230, 0, 0)
        AuthorLbl.BackgroundTransparency = 1
        AuthorLbl.Text                = winAuthor
        AuthorLbl.TextColor3          = T.SubText
        AuthorLbl.Font                = Enum.Font.Gotham
        AuthorLbl.TextSize            = 11
        AuthorLbl.TextXAlignment      = Enum.TextXAlignment.Right
        AuthorLbl.Parent              = TitleBar
    end

    -- Close btn
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size            = UDim2.new(0, 26, 0, 26)
    CloseBtn.Position        = UDim2.new(1, -36, 0.5, -13)
    CloseBtn.BackgroundColor3= T.Danger
    CloseBtn.Text            = "✕"
    CloseBtn.TextColor3      = T.Text
    CloseBtn.Font            = Enum.Font.GothamBold
    CloseBtn.TextSize        = 11
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Parent          = TitleBar
    Corner(CloseBtn, 13)

    -- Mini btn
    local MiniBtn = Instance.new("TextButton")
    MiniBtn.Size            = UDim2.new(0, 26, 0, 26)
    MiniBtn.Position        = UDim2.new(1, -68, 0.5, -13)
    MiniBtn.BackgroundColor3= T.Warning
    MiniBtn.Text            = "–"
    MiniBtn.TextColor3      = T.Text
    MiniBtn.Font            = Enum.Font.GothamBold
    MiniBtn.TextSize        = 15
    MiniBtn.BorderSizePixel = 0
    MiniBtn.Parent          = TitleBar
    Corner(MiniBtn, 13)

    -- ── Sidebar ──────────────────────────────────
    local Sidebar = Instance.new("Frame")
    Sidebar.Name            = "Sidebar"
    Sidebar.Size            = UDim2.new(0, 136, 1, -46)
    Sidebar.Position        = UDim2.new(0, 0, 0, 46)
    Sidebar.BackgroundColor3= T.Secondary
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent          = Main

    local SbScroll = Instance.new("ScrollingFrame")
    SbScroll.Size                  = UDim2.new(1, 0, 1, 0)
    SbScroll.BackgroundTransparency= 1
    SbScroll.BorderSizePixel       = 0
    SbScroll.ScrollBarThickness    = 0
    SbScroll.CanvasSize            = UDim2.new(0, 0, 0, 0)
    SbScroll.Parent                = Sidebar

    local SbList = Instance.new("UIListLayout")
    SbList.SortOrder = Enum.SortOrder.LayoutOrder
    SbList.Padding   = UDim.new(0, 4)
    SbList.Parent    = SbScroll

    local SbPad = Instance.new("UIPadding")
    SbPad.PaddingTop    = UDim.new(0, 8)
    SbPad.PaddingBottom = UDim.new(0, 8)
    SbPad.PaddingLeft   = UDim.new(0, 8)
    SbPad.PaddingRight  = UDim.new(0, 8)
    SbPad.Parent        = SbScroll

    SbList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SbScroll.CanvasSize = UDim2.new(0, 0, 0, SbList.AbsoluteContentSize.Y + 16)
    end)

    -- ── Divider ──────────────────────────────────
    local SbDiv = Instance.new("Frame")
    SbDiv.Size            = UDim2.new(0, 1, 1, -46)
    SbDiv.Position        = UDim2.new(0, 136, 0, 46)
    SbDiv.BackgroundColor3= T.Border
    SbDiv.BorderSizePixel = 0
    SbDiv.Parent          = Main

    -- ── Content Area ─────────────────────────────
    local ContentArea = Instance.new("Frame")
    ContentArea.Name             = "ContentArea"
    ContentArea.Size             = UDim2.new(1, -144, 1, -54)
    ContentArea.Position         = UDim2.new(0, 142, 0, 50)
    ContentArea.BackgroundTransparency = 1
    ContentArea.BorderSizePixel  = 0
    ContentArea.Parent           = Main

    -- ── Draggable ────────────────────────────────
    MakeDraggable(Main, TitleBar)

    -- ── Minimize ─────────────────────────────────
    local minimized = false
    MiniBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(Main, TweenInfo.new(0.22, Enum.EasingStyle.Quad),
                {Size = UDim2.new(0, 580, 0, 46)})
        else
            Tween(Main, TweenInfo.new(0.28, Enum.EasingStyle.Back),
                {Size = UDim2.new(0, 580, 0, 420)})
        end
    end)

    -- ── Close ────────────────────────────────────
    CloseBtn.MouseButton1Click:Connect(function()
        Tween(Main, TweenInfo.new(0.18, Enum.EasingStyle.Quad),
            {Size = UDim2.new(0, 580, 0, 0)})
        task.delay(0.2, function() Main.Visible = false end)
    end)

    -- ── Tab tracking ─────────────────────────────
    local tabs      = {}
    local activeTab = nil

    local function SetActiveTab(tab)
        if activeTab then
            Tween(activeTab.Btn, TweenInfo.new(0.14),
                {BackgroundColor3 = T.Tertiary, BackgroundTransparency = 0})
            activeTab.Btn.TextColor3  = T.SubText
            activeTab.Btn.Font        = Enum.Font.Gotham
            activeTab.Content.Visible = false
        end
        activeTab = tab
        Tween(tab.Btn, TweenInfo.new(0.14),
            {BackgroundColor3 = T.Accent, BackgroundTransparency = 0})
        tab.Btn.TextColor3  = T.Text
        tab.Btn.Font        = Enum.Font.GothamBold
        tab.Content.Visible = true
    end

    -- ─────────────────────────────────────────────
    --  Window Object
    -- ─────────────────────────────────────────────
    local WindowObj = {}

    -- ── CreateMinimizeBtn ────────────────────────
    function WindowObj:CreateMinimizeBtn(cfg)
        cfg = cfg or {}
        local label = cfg.Title or "Open UI"
        local colorMap = {
            Red    = T.Danger,  Green  = T.Success,
            Blue   = T.Blue,    Purple = T.Accent,
            Yellow = T.Warning, Orange = T.Orange,
        }
        local bg = colorMap[cfg.Color] or T.Accent

        local FloatBtn = Instance.new("TextButton")
        FloatBtn.Name            = "FloatMinimize"
        FloatBtn.Size            = UDim2.new(0, 116, 0, 34)
        FloatBtn.Position        = UDim2.new(0, 18, 0.5, 60)
        FloatBtn.BackgroundColor3= bg
        FloatBtn.Text            = label
        FloatBtn.TextColor3      = T.Text
        FloatBtn.Font            = Enum.Font.GothamBold
        FloatBtn.TextSize        = 12
        FloatBtn.BorderSizePixel = 0
        FloatBtn.ZIndex          = 50
        FloatBtn.Parent          = ScreenGui
        Corner(FloatBtn, 9)
        Stroke(FloatBtn, Color3.fromRGB(255,255,255), 0)

        local fs = Instance.new("UIStroke")
        fs.Color        = Color3.fromRGB(255,255,255)
        fs.Transparency = 0.78
        fs.Thickness    = 1
        fs.Parent       = FloatBtn

        MakeDraggable(FloatBtn)

        local showing = true
        FloatBtn.MouseButton1Click:Connect(function()
            showing = not showing
            Main.Visible = showing
            if showing then
                Main.Size = UDim2.new(0, 580, 0, 0)
                Tween(Main, TweenInfo.new(0.28, Enum.EasingStyle.Back),
                    {Size = UDim2.new(0, 580, 0, 420)})
                minimized = false
                FloatBtn.Text = "Hide UI"
            else
                FloatBtn.Text = label
            end
        end)

        FloatBtn.MouseEnter:Connect(function()
            Tween(FloatBtn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.new(
                bg.R * 1.15, bg.G * 1.15, bg.B * 1.15)})
        end)
        FloatBtn.MouseLeave:Connect(function()
            Tween(FloatBtn, TweenInfo.new(0.12), {BackgroundColor3 = bg})
        end)

        return FloatBtn
    end

    -- ── Tab ──────────────────────────────────────
    function WindowObj:Tab(cfg)
        cfg = cfg or {}
        local tabName = cfg.Title  or "Tab"
        local locked  = cfg.Locked or false

        -- Sidebar button
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size            = UDim2.new(1, 0, 0, 34)
        TabBtn.BackgroundColor3= T.Tertiary
        TabBtn.Text            = (locked and "🔒  " or "") .. tabName
        TabBtn.TextColor3      = locked and T.SubText or T.SubText
        TabBtn.Font            = Enum.Font.Gotham
        TabBtn.TextSize        = 12
        TabBtn.BorderSizePixel = 0
        TabBtn.LayoutOrder     = #tabs + 1
        TabBtn.Parent          = SbScroll
        Corner(TabBtn, 8)

        -- Content scroll
        local Content = Instance.new("ScrollingFrame")
        Content.Name                  = "Content_" .. tabName
        Content.Size                  = UDim2.new(1, 0, 1, 0)
        Content.BackgroundTransparency= 1
        Content.BorderSizePixel       = 0
        Content.ScrollBarThickness    = 3
        Content.ScrollBarImageColor3  = T.Accent
        Content.CanvasSize            = UDim2.new(0, 0, 0, 0)
        Content.Visible               = false
        Content.Parent                = ContentArea

        local CList = Instance.new("UIListLayout")
        CList.SortOrder = Enum.SortOrder.LayoutOrder
        CList.Padding   = UDim.new(0, 6)
        CList.Parent    = Content

        local CPad = Instance.new("UIPadding")
        CPad.PaddingTop    = UDim.new(0, 4)
        CPad.PaddingBottom = UDim.new(0, 10)
        CPad.PaddingRight  = UDim.new(0, 4)
        CPad.Parent        = Content

        CList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Content.CanvasSize = UDim2.new(0, 0, 0, CList.AbsoluteContentSize.Y + 14)
        end)

        local tabEntry = {Btn = TabBtn, Content = Content}
        table.insert(tabs, tabEntry)

        if #tabs == 1 then SetActiveTab(tabEntry) end

        TabBtn.MouseButton1Click:Connect(function()
            if not locked then SetActiveTab(tabEntry) end
        end)
        TabBtn.MouseEnter:Connect(function()
            if activeTab ~= tabEntry and not locked then
                Tween(TabBtn, TweenInfo.new(0.12), {BackgroundColor3 = T.Border})
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if activeTab ~= tabEntry then
                Tween(TabBtn, TweenInfo.new(0.12), {BackgroundColor3 = T.Tertiary})
            end
        end)

        -- ─────────────────────────────────────────
        --  Element builders
        -- ─────────────────────────────────────────
        local function NewElem(h)
            local e = Instance.new("Frame")
            e.Size            = UDim2.new(1, 0, 0, h)
            e.BackgroundColor3= T.Elem
            e.BorderSizePixel = 0
            e.Parent          = Content
            Corner(e, 9)
            return e
        end

        local function Labels(parent, title, desc, ox)
            ox = ox or 0
            local hasDesc = desc and desc ~= ""
            local t = Instance.new("TextLabel")
            t.Size             = UDim2.new(1, -110 - ox, 0, 16)
            t.Position         = UDim2.new(0, 12 + ox, 0.5, hasDesc and -11 or -8)
            t.BackgroundTransparency= 1
            t.Text             = title
            t.TextColor3       = T.Text
            t.Font             = Enum.Font.GothamBold
            t.TextSize         = 13
            t.TextXAlignment   = Enum.TextXAlignment.Left
            t.Parent           = parent

            if hasDesc then
                local d = Instance.new("TextLabel")
                d.Size             = UDim2.new(1, -110 - ox, 0, 13)
                d.Position         = UDim2.new(0, 12 + ox, 0.5, 3)
                d.BackgroundTransparency= 1
                d.Text             = desc
                d.TextColor3       = T.SubText
                d.Font             = Enum.Font.Gotham
                d.TextSize         = 11
                d.TextXAlignment   = Enum.TextXAlignment.Left
                d.Parent           = parent
            end
        end

        -- ─────────────────────────────────────────
        local Elem = {}

        -- ── Button ───────────────────────────────
        function Elem:Button(cfg)
            cfg = cfg or {}
            local lk  = cfg.Locked or false
            local e   = NewElem(52)
            Labels(e, cfg.Title or "Button", cfg.Desc or "")

            local btn = Instance.new("TextButton")
            btn.Size            = UDim2.new(0, 68, 0, 28)
            btn.Position        = UDim2.new(1, -78, 0.5, -14)
            btn.BackgroundColor3= lk and T.Border or T.Accent
            btn.Text            = lk and "🔒" or "Run"
            btn.TextColor3      = T.Text
            btn.Font            = Enum.Font.GothamBold
            btn.TextSize        = 12
            btn.BorderSizePixel = 0
            btn.Parent          = e
            Corner(btn, 8)

            if not lk then
                btn.MouseEnter:Connect(function()
                    Tween(btn, TweenInfo.new(0.12), {BackgroundColor3 = T.AccentHov})
                end)
                btn.MouseLeave:Connect(function()
                    Tween(btn, TweenInfo.new(0.12), {BackgroundColor3 = T.Accent})
                end)
                btn.MouseButton1Click:Connect(function()
                    Tween(btn, TweenInfo.new(0.06), {BackgroundColor3 = T.Text})
                    task.delay(0.12, function()
                        Tween(btn, TweenInfo.new(0.14), {BackgroundColor3 = T.Accent})
                    end)
                    if cfg.Callback then pcall(cfg.Callback) end
                end)
            end
            return btn
        end

        -- ── Dropdown ─────────────────────────────
        function Elem:Dropdown(cfg)
            cfg = cfg or {}
            local vals = cfg.Values or {}
            local cur  = cfg.Value  or (vals[1] or "None")
            local e    = NewElem(52)
            Labels(e, cfg.Title or "Dropdown", cfg.Desc or "")

            local dBtn = Instance.new("TextButton")
            dBtn.Size            = UDim2.new(0, 118, 0, 28)
            dBtn.Position        = UDim2.new(1, -128, 0.5, -14)
            dBtn.BackgroundColor3= T.Tertiary
            dBtn.Text            = cur .. "  ▾"
            dBtn.TextColor3      = T.Text
            dBtn.Font            = Enum.Font.Gotham
            dBtn.TextSize        = 12
            dBtn.BorderSizePixel = 0
            dBtn.ClipsDescendants= true
            dBtn.Parent          = e
            Corner(dBtn, 8)
            Stroke(dBtn, T.Border)

            dBtn.MouseEnter:Connect(function()
                Tween(dBtn, TweenInfo.new(0.12), {BackgroundColor3 = T.Border})
            end)
            dBtn.MouseLeave:Connect(function()
                Tween(dBtn, TweenInfo.new(0.12), {BackgroundColor3 = T.Tertiary})
            end)
            dBtn.MouseButton1Click:Connect(function()
                OpenDropdown(cfg.Title or "Select", vals, cur, function(val)
                    cur = val
                    dBtn.Text = val .. "  ▾"
                    if cfg.Callback then pcall(cfg.Callback, val) end
                end)
            end)
            return {
                SetValue = function(v)
                    cur = v; dBtn.Text = v .. "  ▾"
                end,
                GetValue = function() return cur end,
            }
        end

        -- ── Toggle ───────────────────────────────
        function Elem:Toggle(cfg)
            cfg = cfg or {}
            local state = cfg.Value or false
            local e     = NewElem(52)
            Labels(e, cfg.Title or "Toggle", cfg.Desc or "")

            local TrackBg = Instance.new("Frame")
            TrackBg.Size            = UDim2.new(0, 46, 0, 24)
            TrackBg.Position        = UDim2.new(1, -58, 0.5, -12)
            TrackBg.BackgroundColor3= state and T.Accent or T.Border
            TrackBg.BorderSizePixel = 0
            TrackBg.Parent          = e
            Corner(TrackBg, 12)

            local Knob = Instance.new("Frame")
            Knob.Size            = UDim2.new(0, 18, 0, 18)
            Knob.Position        = state
                and UDim2.new(1, -21, 0.5, -9)
                or  UDim2.new(0,   3, 0.5, -9)
            Knob.BackgroundColor3= T.Text
            Knob.BorderSizePixel = 0
            Knob.ZIndex          = 2
            Knob.Parent          = TrackBg
            Corner(Knob, 9)

            local Click = Instance.new("TextButton")
            Click.Size                = UDim2.fromScale(1, 1)
            Click.BackgroundTransparency = 1
            Click.Text                = ""
            Click.ZIndex              = 3
            Click.Parent              = TrackBg

            Click.MouseButton1Click:Connect(function()
                state = not state
                Tween(TrackBg, TweenInfo.new(0.18),
                    {BackgroundColor3 = state and T.Accent or T.Border})
                Tween(Knob, TweenInfo.new(0.2, Enum.EasingStyle.Back),
                    {Position = state
                        and UDim2.new(1, -21, 0.5, -9)
                        or  UDim2.new(0,   3, 0.5, -9)})
                if cfg.Callback then pcall(cfg.Callback, state) end
            end)

            return {
                SetValue = function(v)
                    state = v
                    Tween(TrackBg, TweenInfo.new(0.18),
                        {BackgroundColor3 = v and T.Accent or T.Border})
                    Tween(Knob, TweenInfo.new(0.2),
                        {Position = v
                            and UDim2.new(1, -21, 0.5, -9)
                            or  UDim2.new(0,   3, 0.5, -9)})
                end,
                GetValue = function() return state end,
            }
        end

        -- ── Slider ───────────────────────────────
        function Elem:Slider(cfg)
            cfg = cfg or {}
            local vc  = cfg.Value or {}
            local mn  = vc.Min     or 0
            local mx  = vc.Max     or 100
            local def = vc.Default or mn
            local stp = cfg.Step   or 1
            local cur = math.clamp(def, mn, mx)

            local e = NewElem(68)

            local TitleLbl2 = Instance.new("TextLabel")
            TitleLbl2.Size             = UDim2.new(1, -90, 0, 16)
            TitleLbl2.Position         = UDim2.new(0, 12, 0, 9)
            TitleLbl2.BackgroundTransparency= 1
            TitleLbl2.Text             = cfg.Title or "Slider"
            TitleLbl2.TextColor3       = T.Text
            TitleLbl2.Font             = Enum.Font.GothamBold
            TitleLbl2.TextSize         = 13
            TitleLbl2.TextXAlignment   = Enum.TextXAlignment.Left
            TitleLbl2.Parent           = e

            local ValLbl = Instance.new("TextLabel")
            ValLbl.Size              = UDim2.new(0, 70, 0, 16)
            ValLbl.Position          = UDim2.new(1, -80, 0, 9)
            ValLbl.BackgroundTransparency= 1
            ValLbl.Text              = tostring(cur)
            ValLbl.TextColor3        = T.Accent
            ValLbl.Font              = Enum.Font.GothamBold
            ValLbl.TextSize          = 13
            ValLbl.TextXAlignment    = Enum.TextXAlignment.Right
            ValLbl.Parent            = e

            if cfg.Desc and cfg.Desc ~= "" then
                local dl = Instance.new("TextLabel")
                dl.Size             = UDim2.new(1, -90, 0, 13)
                dl.Position         = UDim2.new(0, 12, 0, 27)
                dl.BackgroundTransparency= 1
                dl.Text             = cfg.Desc
                dl.TextColor3       = T.SubText
                dl.Font             = Enum.Font.Gotham
                dl.TextSize         = 11
                dl.TextXAlignment   = Enum.TextXAlignment.Left
                dl.Parent           = e
            end

            -- Track
            local Track = Instance.new("Frame")
            Track.Size            = UDim2.new(1, -24, 0, 5)
            Track.Position        = UDim2.new(0, 12, 1, -15)
            Track.BackgroundColor3= T.Tertiary
            Track.BorderSizePixel = 0
            Track.Parent          = e
            Corner(Track, 3)

            local Fill = Instance.new("Frame")
            Fill.Size            = UDim2.new((cur - mn) / (mx - mn), 0, 1, 0)
            Fill.BackgroundColor3= T.Accent
            Fill.BorderSizePixel = 0
            Fill.Parent          = Track
            Corner(Fill, 3)

            local Handle = Instance.new("Frame")
            Handle.Size            = UDim2.new(0, 14, 0, 14)
            Handle.AnchorPoint     = Vector2.new(0.5, 0.5)
            Handle.Position        = UDim2.new((cur - mn) / (mx - mn), 0, 0.5, 0)
            Handle.BackgroundColor3= T.Text
            Handle.BorderSizePixel = 0
            Handle.ZIndex          = 2
            Handle.Parent          = Track
            Corner(Handle, 7)

            local function SnapVal(raw)
                if stp >= 1 then
                    return math.clamp(math.round(raw / stp) * stp, mn, mx)
                else
                    local f = 1 / stp
                    return math.clamp(math.round(raw * f) / f, mn, mx)
                end
            end

            local function UpdateSlider(inputPos)
                local tx  = Track.AbsolutePosition.X
                local tw  = Track.AbsoluteSize.X
                local pct = math.clamp((inputPos.X - tx) / tw, 0, 1)
                cur       = SnapVal(mn + (mx - mn) * pct)
                local p   = (cur - mn) / (mx - mn)
                Fill.Size            = UDim2.new(p, 0, 1, 0)
                Handle.Position      = UDim2.new(p, 0, 0.5, 0)
                ValLbl.Text          = tostring(cur)
                if cfg.Callback then pcall(cfg.Callback, cur) end
            end

            local dragging = false
            Track.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true; UpdateSlider(i.Position)
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                    UpdateSlider(i.Position)
                end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)

            return {
                SetValue = function(v)
                    cur = math.clamp(v, mn, mx)
                    local p = (cur - mn) / (mx - mn)
                    Fill.Size       = UDim2.new(p, 0, 1, 0)
                    Handle.Position = UDim2.new(p, 0, 0.5, 0)
                    ValLbl.Text     = tostring(cur)
                end,
                GetValue = function() return cur end,
            }
        end

        -- ── Input ────────────────────────────────
        function Elem:Input(cfg)
            cfg = cfg or {}
            local isTA = (cfg.Type == "Textarea")
            local h    = isTA and 80 or 52
            local e    = NewElem(h)
            Labels(e, cfg.Title or "Input", cfg.Desc or "")

            local IBg = Instance.new("Frame")
            IBg.Size            = UDim2.new(0, 155, 0, isTA and 56 or 28)
            IBg.Position        = UDim2.new(1, -167, 0.5, isTA and -28 or -14)
            IBg.BackgroundColor3= T.Tertiary
            IBg.BorderSizePixel = 0
            IBg.Parent          = e
            Corner(IBg, 8)
            local iStroke = Stroke(IBg, T.Border)

            local TB = Instance.new("TextBox")
            TB.Size                = UDim2.new(1, -12, 1, -6)
            TB.Position            = UDim2.new(0, 6, 0, 3)
            TB.BackgroundTransparency = 1
            TB.Text                = cfg.Value or ""
            TB.PlaceholderText     = cfg.Placeholder or "Enter text..."
            TB.PlaceholderColor3   = T.SubText
            TB.TextColor3          = T.Text
            TB.Font                = Enum.Font.Gotham
            TB.TextSize            = 12
            TB.TextXAlignment      = Enum.TextXAlignment.Left
            TB.TextYAlignment      = isTA and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center
            TB.TextWrapped         = isTA
            TB.MultiLine           = isTA
            TB.ClearTextOnFocus    = false
            TB.BorderSizePixel     = 0
            TB.Parent              = IBg

            TB.Focused:Connect(function()
                Tween(iStroke, TweenInfo.new(0.15), {Color = T.Accent})
            end)
            TB.FocusLost:Connect(function()
                Tween(iStroke, TweenInfo.new(0.15), {Color = T.Border})
                if cfg.Callback then pcall(cfg.Callback, TB.Text) end
            end)

            return {
                SetValue = function(v) TB.Text = v end,
                GetValue = function()  return TB.Text end,
            }
        end

        -- ── Section label (bonus) ─────────────────
        function Elem:Section(text)
            local s = Instance.new("TextLabel")
            s.Size             = UDim2.new(1, 0, 0, 24)
            s.BackgroundTransparency= 1
            s.Text             = "  " .. (text or "Section")
            s.TextColor3       = T.Accent
            s.Font             = Enum.Font.GothamBold
            s.TextSize         = 12
            s.TextXAlignment   = Enum.TextXAlignment.Left
            s.Parent           = Content
            return s
        end

        return Elem
    end

    return WindowObj
end

return Library
