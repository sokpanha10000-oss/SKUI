--[[
╔══════════════════════════════════════════════════════════╗
║              ftgs UI Library  v2.1 (FIXED)               ║
║   Infinite Tabs · Infinite Elements · Fixed Slider       ║
║   ScrollFrame V2 · Draggable · Dropdown Popup            ║
╚══════════════════════════════════════════════════════════╝
--]]

-- ═══════════════════════════════════════════════
--  SERVICES
-- ═══════════════════════════════════════════════
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")

local Player = Players.LocalPlayer

-- ═══════════════════════════════════════════════
--  SMALL HELPERS
-- ═══════════════════════════════════════════════
local function Tween(obj, info, props)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function Corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = p
    return c
end

local function NewStroke(p, color, thick)
    local s = Instance.new("UIStroke")
    s.Color     = color
    s.Thickness = thick or 1
    s.Parent    = p
    return s
end

-- ─── draggable frames ───────────────────────────
local function MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, startMouse, startPos

    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            dragging   = true
            startMouse = i.Position
            startPos   = frame.Position
            
            -- Fix: Disconnect event to prevent memory leak
            local con
            con = i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    if con then con:Disconnect() end
                end
            end)
        end
    end)
    handle.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement
        or i.UserInputType == Enum.UserInputType.Touch then
            dragInput = i
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i == dragInput then
            local d = i.Position - startMouse
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
        end
    end)
end

-- ═══════════════════════════════════════════════
--  THEME
-- ═══════════════════════════════════════════════
local T = {
    Bg        = Color3.fromRGB(13,  13,  20 ),
    Secondary = Color3.fromRGB(20,  20,  30 ),
    Tertiary  = Color3.fromRGB(28,  28,  42 ),
    Elem      = Color3.fromRGB(22,  22,  34 ),
    ElemHov   = Color3.fromRGB(27,  27,  41 ),
    Accent    = Color3.fromRGB(110, 86,  235),
    AccentHov = Color3.fromRGB(132, 108, 255),
    AccentDim = Color3.fromRGB(68,  52,  155),
    Text      = Color3.fromRGB(236, 236, 252),
    SubText   = Color3.fromRGB(140, 140, 168),
    Border    = Color3.fromRGB(40,  40,  60 ),
    BorderHi  = Color3.fromRGB(60,  60,  92 ),
    Success   = Color3.fromRGB(68,  194, 118),
    Danger    = Color3.fromRGB(218, 70,  70 ),
    Warning   = Color3.fromRGB(218, 162, 58 ),
    Blue      = Color3.fromRGB(68,  128, 218),
    Orange    = Color3.fromRGB(218, 116, 56 ),
}

-- ═══════════════════════════════════════════════
--  SCREENGUI
-- ═══════════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "ftgsUIv2"
ScreenGui.ResetOnSpawn   = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder   = 999
ScreenGui.IgnoreGuiInset = true

local ok = pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not ok or not ScreenGui.Parent then
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
end

-- ═══════════════════════════════════════════════
--  SCROLL-V2 FACTORY (FIXED FOR INFINITE TABS)
-- ═══════════════════════════════════════════════
local function ScrollV2(parent, size, position, pad)
    pad = pad or { top=6, bottom=12, left=4, right=6 }

    local Wrapper = Instance.new("Frame")
    Wrapper.Size                  = size
    Wrapper.Position              = position
    Wrapper.BackgroundTransparency= 1
    Wrapper.BorderSizePixel       = 0
    Wrapper.ClipsDescendants      = true
    Wrapper.Parent                = parent

    local SF = Instance.new("ScrollingFrame")
    SF.Size                  = UDim2.fromScale(1, 1)
    SF.BackgroundTransparency= 1
    SF.BorderSizePixel       = 0
    SF.ScrollBarThickness    = 4
    SF.ScrollBarImageColor3  = T.Accent
    SF.ScrollingDirection    = Enum.ScrollingDirection.Y
    SF.CanvasSize            = UDim2.new(0, 0, 0, 0)
    -- Fix: Replaced manual math with native auto size for infinite scrolling
    SF.AutomaticCanvasSize   = Enum.AutomaticSize.Y 
    SF.ScrollingEnabled      = true
    SF.ElasticBehavior       = Enum.ElasticBehavior.WhenScrollable
    SF.BottomImage           = "rbxasset://textures/ui/Scroll/scroll-middle.png"
    SF.MidImage              = "rbxasset://textures/ui/Scroll/scroll-middle.png"
    SF.TopImage              = "rbxasset://textures/ui/Scroll/scroll-middle.png"
    SF.Parent                = Wrapper

    local Layout = Instance.new("UIListLayout")
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding   = UDim.new(0, 6)
    Layout.Parent    = SF

    local Pad = Instance.new("UIPadding")
    Pad.PaddingTop    = UDim.new(0, pad.top)
    Pad.PaddingBottom = UDim.new(0, pad.bottom)
    Pad.PaddingLeft   = UDim.new(0, pad.left)
    Pad.PaddingRight  = UDim.new(0, pad.right)
    Pad.Parent        = SF

    return { Wrapper = Wrapper, Scroll = SF, Layout = Layout }
end

-- ═══════════════════════════════════════════════
--  DROPDOWN POPUP
-- ═══════════════════════════════════════════════
local DDOverlay = Instance.new("Frame")
DDOverlay.Name                   = "DDOverlay"
DDOverlay.Size                   = UDim2.fromScale(1, 1)
DDOverlay.BackgroundColor3       = Color3.fromRGB(0,0,0)
DDOverlay.BackgroundTransparency = 1
DDOverlay.BorderSizePixel        = 0
DDOverlay.ZIndex                 = 300
DDOverlay.Visible                = false
DDOverlay.Parent                 = ScreenGui

local DDPopup = Instance.new("Frame")
DDPopup.Name             = "DDPopup"
DDPopup.Size             = UDim2.new(0, 284, 0, 0)
DDPopup.AnchorPoint      = Vector2.new(0.5, 0.5)
DDPopup.Position         = UDim2.fromScale(0.5, 0.5)
DDPopup.BackgroundColor3 = T.Secondary
DDPopup.BorderSizePixel  = 0
DDPopup.ZIndex           = 301
DDPopup.ClipsDescendants = true
DDPopup.Parent           = DDOverlay
Corner(DDPopup, 14)
NewStroke(DDPopup, T.BorderHi, 1)

local DDHeader = Instance.new("Frame")
DDHeader.Size            = UDim2.new(1, 0, 0, 44)
DDHeader.BackgroundColor3= T.Tertiary
DDHeader.BorderSizePixel = 0
DDHeader.ZIndex          = 302
DDHeader.Parent          = DDPopup
Corner(DDHeader, 14)

local DDHeaderFix = Instance.new("Frame")
DDHeaderFix.Size            = UDim2.new(1, 0, 0, 14)
DDHeaderFix.Position        = UDim2.new(0, 0, 1, -14)
DDHeaderFix.BackgroundColor3= T.Tertiary
DDHeaderFix.BorderSizePixel = 0
DDHeaderFix.ZIndex          = 302
DDHeaderFix.Parent          = DDHeader

local DDPill = Instance.new("Frame")
DDPill.Size            = UDim2.new(0, 3, 0, 20)
DDPill.Position        = UDim2.new(0, 14, 0.5, -10)
DDPill.BackgroundColor3= T.Accent
DDPill.BorderSizePixel = 0
DDPill.ZIndex          = 303
DDPill.Parent          = DDHeader
Corner(DDPill, 2)

local DDTitle = Instance.new("TextLabel")
DDTitle.Size                  = UDim2.new(1, -72, 1, 0)
DDTitle.Position              = UDim2.new(0, 26, 0, 0)
DDTitle.BackgroundTransparency= 1
DDTitle.Text                  = "Select Option"
DDTitle.TextColor3            = T.Text
DDTitle.Font                  = Enum.Font.GothamBold
DDTitle.TextSize              = 14
DDTitle.TextXAlignment        = Enum.TextXAlignment.Left
DDTitle.ZIndex                = 303
DDTitle.Parent                = DDHeader

local DDCloseBtn = Instance.new("TextButton")
DDCloseBtn.Size            = UDim2.new(0, 24, 0, 24)
DDCloseBtn.Position        = UDim2.new(1, -34, 0.5, -12)
DDCloseBtn.BackgroundColor3= T.Border
DDCloseBtn.Text            = "✕"
DDCloseBtn.TextColor3      = T.SubText
DDCloseBtn.Font            = Enum.Font.GothamBold
DDCloseBtn.TextSize        = 11
DDCloseBtn.BorderSizePixel = 0
DDCloseBtn.ZIndex          = 303
DDCloseBtn.Parent          = DDHeader
Corner(DDCloseBtn, 12)

local DDScrollV2 = ScrollV2(
    DDPopup,
    UDim2.new(1, -8, 1, -52),
    UDim2.new(0, 4, 0, 48),
    { top = 4, bottom = 6, left = 4, right = 4 }
)
DDScrollV2.Scroll.ZIndex       = 302
DDScrollV2.Scroll.ScrollBarThickness = 4

local function HideDD()
    Tween(DDPopup,
        TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        { Size = UDim2.new(0, 284, 0, 0) }
    )
    Tween(DDOverlay, TweenInfo.new(0.18), { BackgroundTransparency = 1 })
    task.delay(0.22, function()
        DDOverlay.Visible = false
        for _, c in ipairs(DDScrollV2.Scroll:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
    end)
end

DDCloseBtn.MouseButton1Click:Connect(HideDD)
DDOverlay.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then HideDD() end
end)

local function OpenDropdown(title, values, currentVal, onSelect)
    for _, c in ipairs(DDScrollV2.Scroll:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end

    DDTitle.Text = title
    local active = currentVal

    for idx, val in ipairs(values) do
        local isActive = val == active
        local item = Instance.new("TextButton")
        item.Size            = UDim2.new(1, 0, 0, 36)
        item.BackgroundColor3= isActive and T.Accent or T.Tertiary
        item.BorderSizePixel = 0
        item.Text            = val
        item.TextColor3      = isActive and T.Text or T.SubText
        item.Font            = isActive and Enum.Font.GothamBold or Enum.Font.Gotham
        item.TextSize        = 13
        item.LayoutOrder     = idx
        item.ZIndex          = 303
        item.Parent          = DDScrollV2.Scroll
        Corner(item, 8)

        if isActive then
            local dot = Instance.new("Frame")
            dot.Name            = "SelDot"
            dot.Size            = UDim2.new(0, 6, 0, 6)
            dot.Position        = UDim2.new(1, -16, 0.5, -3)
            dot.BackgroundColor3= T.Text
            dot.BorderSizePixel = 0
            dot.ZIndex          = 304
            dot.Parent          = item
            Corner(dot, 3)
        end

        item.MouseEnter:Connect(function()
            if val ~= active then
                Tween(item, TweenInfo.new(0.1), { BackgroundColor3 = T.BorderHi, TextColor3 = T.Text })
            end
        end)
        item.MouseLeave:Connect(function()
            if val ~= active then
                Tween(item, TweenInfo.new(0.1), { BackgroundColor3 = T.Tertiary, TextColor3 = T.SubText })
            end
        end)
        item.MouseButton1Click:Connect(function()
            active = val
            for _, sib in ipairs(DDScrollV2.Scroll:GetChildren()) do
                if sib:IsA("TextButton") then
                    local a = sib.Text == val
                    Tween(sib, TweenInfo.new(0.12), {
                        BackgroundColor3 = a and T.Accent or T.Tertiary,
                        TextColor3       = a and T.Text   or T.SubText,
                    })
                    sib.Font = a and Enum.Font.GothamBold or Enum.Font.Gotham
                    local d = sib:FindFirstChild("SelDot")
                    if d then d:Destroy() end
                    if a then
                        local nd = Instance.new("Frame")
                        nd.Name            = "SelDot"
                        nd.Size            = UDim2.new(0, 6, 0, 6)
                        nd.Position        = UDim2.new(1, -16, 0.5, -3)
                        nd.BackgroundColor3= T.Text
                        nd.BorderSizePixel = 0
                        nd.ZIndex          = 304
                        nd.Parent          = sib
                        Corner(nd, 3)
                    end
                end
            end
            onSelect(val)
            HideDD()
        end)
    end

    local count   = #values
    local targetH = math.min(count * 42 + 56, 320)

    DDPopup.Size = UDim2.new(0, 284, 0, 0)
    DDOverlay.Visible = true
    Tween(DDOverlay, TweenInfo.new(0.2), { BackgroundTransparency = 0.5 })
    Tween(DDPopup,
        TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Size = UDim2.new(0, 284, 0, targetH) }
    )
end

-- ═══════════════════════════════════════════════
--  LIBRARY ENTRY
-- ═══════════════════════════════════════════════
local Library = {}
Library.__index = Library

function Library:CreateWindow(config)
    config = config or {}
    local winTitle  = config.Title  or "Hub"
    local winAuthor = config.Author or ""

    local Main = Instance.new("Frame")
    Main.Name             = "MainWindow"
    Main.Size             = UDim2.new(0, 560, 0, 350)
    Main.Position         = UDim2.new(0.5, -297, 0.5, -117)
    Main.BackgroundColor3 = T.Bg
    Main.BorderSizePixel  = 0
    Main.ClipsDescendants = true
    Main.Parent           = ScreenGui
    Corner(Main, 14)
    NewStroke(Main, T.Border, 1)

    local Shad = Instance.new("ImageLabel")
    Shad.Size                  = UDim2.new(1, 70, 1, 70)
    Shad.Position              = UDim2.new(0, -35, 0, -35)
    Shad.BackgroundTransparency= 1
    Shad.Image                 = "rbxassetid://6014261993"
    Shad.ImageColor3           = Color3.fromRGB(0,0,0)
    Shad.ImageTransparency     = 0.48
    Shad.ScaleType             = Enum.ScaleType.Slice
    Shad.SliceCenter           = Rect.new(49,49,450,450)
    Shad.ZIndex                = -1
    Shad.Parent                = Main

    local TBar = Instance.new("Frame")
    TBar.Size            = UDim2.new(1, 0, 0, 46)
    TBar.BackgroundColor3= T.Secondary
    TBar.BorderSizePixel = 0
    TBar.Parent          = Main
    Corner(TBar, 14)

    local TBarFix = Instance.new("Frame")
    TBarFix.Size            = UDim2.new(1, 0, 0, 14)
    TBarFix.Position        = UDim2.new(0, 0, 1, -14)
    TBarFix.BackgroundColor3= T.Secondary
    TBarFix.BorderSizePixel = 0
    TBarFix.Parent          = TBar

    local TPill = Instance.new("Frame")
    TPill.Size            = UDim2.new(0, 3, 0, 22)
    TPill.Position        = UDim2.new(0, 14, 0.5, -11)
    TPill.BackgroundColor3= T.Accent
    TPill.BorderSizePixel = 0
    TPill.Parent          = TBar
    Corner(TPill, 2)

    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Size                  = UDim2.new(1, -165, 1, 0)
    TitleLbl.Position              = UDim2.new(0, 26, 0, 0)
    TitleLbl.BackgroundTransparency= 1
    TitleLbl.Text                  = winTitle
    TitleLbl.TextColor3            = T.Text
    TitleLbl.Font                  = Enum.Font.GothamBold
    TitleLbl.TextSize              = 15
    TitleLbl.TextXAlignment        = Enum.TextXAlignment.Left
    TitleLbl.Parent                = TBar

    if winAuthor ~= "" then
        local AuthLbl = Instance.new("TextLabel")
        AuthLbl.Size                  = UDim2.new(0, 155, 1, 0)
        AuthLbl.Position              = UDim2.new(1, -237, 0, 0)
        AuthLbl.BackgroundTransparency= 1
        AuthLbl.Text                  = winAuthor
        AuthLbl.TextColor3            = T.SubText
        AuthLbl.Font                  = Enum.Font.Gotham
        AuthLbl.TextSize              = 11
        AuthLbl.TextXAlignment        = Enum.TextXAlignment.Right
        AuthLbl.Parent                = TBar
    end

    local TBarMini = Instance.new("TextButton")
    TBarMini.Size            = UDim2.new(0, 26, 0, 26)
    TBarMini.Position        = UDim2.new(1, -68, 0.5, -13)
    TBarMini.BackgroundColor3= T.Warning
    TBarMini.Text            = "–"
    TBarMini.TextColor3      = T.Text
    TBarMini.Font            = Enum.Font.GothamBold
    TBarMini.TextSize        = 16
    TBarMini.BorderSizePixel = 0
    TBarMini.Parent          = TBar
    Corner(TBarMini, 13)

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size            = UDim2.new(0, 26, 0, 26)
    CloseBtn.Position        = UDim2.new(1, -36, 0.5, -13)
    CloseBtn.BackgroundColor3= T.Danger
    CloseBtn.Text            = "✕"
    CloseBtn.TextColor3      = T.Text
    CloseBtn.Font            = Enum.Font.GothamBold
    CloseBtn.TextSize        = 11
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Parent          = TBar
    Corner(CloseBtn, 13)

    MakeDraggable(Main, TBar)

    local SideFrame = Instance.new("Frame")
    SideFrame.Name            = "Sidebar"
    SideFrame.Size            = UDim2.new(0, 140, 1, -46)
    SideFrame.Position        = UDim2.new(0, 0, 0, 46)
    SideFrame.BackgroundColor3= T.Secondary
    SideFrame.BorderSizePixel = 0
    SideFrame.Parent          = Main

    local SideV2 = ScrollV2(
        SideFrame,
        UDim2.fromScale(1, 1),
        UDim2.fromScale(0, 0),
        { top = 8, bottom = 10, left = 8, right = 8 }
    )
    SideV2.Scroll.ScrollBarThickness = 0
    SideV2.Layout.Padding            = UDim.new(0, 4)

    local SideDiv = Instance.new("Frame")
    SideDiv.Size            = UDim2.new(0, 1, 1, -46)
    SideDiv.Position        = UDim2.new(0, 140, 0, 46)
    SideDiv.BackgroundColor3= T.Border
    SideDiv.BorderSizePixel = 0
    SideDiv.Parent          = Main

    local ContentArea = Instance.new("Frame")
    ContentArea.Name                  = "ContentArea"
    ContentArea.Size                  = UDim2.new(1, -150, 1, -54)
    ContentArea.Position              = UDim2.new(0, 146, 0, 50)
    ContentArea.BackgroundTransparency= 1
    ContentArea.BorderSizePixel       = 0
    ContentArea.Parent                = Main

local FULL_H    = 434
local minimized = false

TBarMini.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        Tween(Main, TweenInfo.new(0.22, Enum.EasingStyle.Quad),
            { Size = UDim2.new(0, 594, 0, 46) })
    else
        Tween(Main, TweenInfo.new(0.28, Enum.EasingStyle.Back),
            { Size = UDim2.new(0, 594, 0, FULL_H) })
    end
end)

-- UPDATED CLOSE BUTTON LOGIC:
CloseBtn.MouseButton1Click:Connect(function()
    -- Animate closing
    Tween(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad),
        { Size = UDim2.new(0, 594, 0, 0), BackgroundTransparency = 1 })
    
    -- Wait for animation then delete everything
    task.delay(0.22, function() 
        ScreenGui:Destroy() 
    end)
end)

    local tabs      = {}
    local activeTab = nil

    local function SetActiveTab(entry)
        if activeTab then
            Tween(activeTab.Btn, TweenInfo.new(0.15), { BackgroundColor3 = T.Tertiary })
            activeTab.Btn.TextColor3  = T.SubText
            activeTab.Btn.Font        = Enum.Font.Gotham
            activeTab.Wrapper.Visible = false
        end
        activeTab = entry
        Tween(entry.Btn, TweenInfo.new(0.15), { BackgroundColor3 = T.Accent })
        entry.Btn.TextColor3  = T.Text
        entry.Btn.Font        = Enum.Font.GothamBold
        entry.Wrapper.Visible = true
    end

    local WindowObj = {}

    function WindowObj:CreateMinimizeBtn(cfg)
        cfg = cfg or {}
        local label    = cfg.Title or "Open UI"
        local colorMap = {
            Red    = T.Danger,  Green  = T.Success,
            Blue   = T.Blue,    Purple = T.Accent,
            Yellow = T.Warning, Orange = T.Orange,
        }
        local bg = colorMap[cfg.Color] or T.Accent

        local FB = Instance.new("TextButton")
        FB.Name            = "FloatBtn"
        FB.Size            = UDim2.new(0, 118, 0, 34)
        FB.Position        = UDim2.new(0, 16, 0.5, 64)
        FB.BackgroundColor3= bg
        FB.Text            = label
        FB.TextColor3      = T.Text
        FB.Font            = Enum.Font.GothamBold
        FB.TextSize        = 12
        FB.BorderSizePixel = 0
        FB.ZIndex          = 50
        FB.Parent          = ScreenGui
        Corner(FB, 9)

        local FBStroke = Instance.new("UIStroke")
        FBStroke.Color        = Color3.fromRGB(255,255,255)
        FBStroke.Transparency = 0.78
        FBStroke.Thickness    = 1
        FBStroke.Parent       = FB

        MakeDraggable(FB)

        -- Fix: Replaced MouseButton1Click with Input Ended checking distance dragged.
        local showing = true
        local dragStartPos = nil

        FB.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragStartPos = i.Position
            end
        end)

        FB.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                -- if the user dragged it instead of clicking, do nothing
                if dragStartPos and (i.Position - dragStartPos).Magnitude > 5 then return end
                
                showing = not showing
                if showing then
                    Main.Size    = UDim2.new(0, 594, 0, 0)
                    Main.Visible = true
                    minimized    = false
                    Tween(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back), { Size = UDim2.new(0, 594, 0, FULL_H) })
                    FB.Text = "Hide UI"
                else
                    Tween(Main, TweenInfo.new(0.18, Enum.EasingStyle.Quad), { Size = UDim2.new(0, 594, 0, 0) })
                    task.delay(0.2, function()
                        Main.Visible = false
                        FB.Text      = label
                    end)
                end
            end
        end)

        FB.MouseEnter:Connect(function()
            Tween(FB, TweenInfo.new(0.12), {
                BackgroundColor3 = Color3.new( math.min(bg.R * 1.18, 1), math.min(bg.G * 1.18, 1), math.min(bg.B * 1.18, 1) )
            })
        end)
        FB.MouseLeave:Connect(function()
            Tween(FB, TweenInfo.new(0.12), { BackgroundColor3 = bg })
        end)

        return FB
    end

    function WindowObj:Tab(cfg)
        cfg = cfg or {}
        local tabName = cfg.Title  or "Tab"
        local locked  = cfg.Locked or false

        local TabBtn = Instance.new("TextButton")
        TabBtn.Size            = UDim2.new(1, 0, 0, 34)
        TabBtn.BackgroundColor3= T.Tertiary
        TabBtn.Text            = (locked and "🔒  " or "") .. tabName
        TabBtn.TextColor3      = T.SubText
        TabBtn.Font            = Enum.Font.Gotham
        TabBtn.TextSize        = 12
        TabBtn.BorderSizePixel = 0
        TabBtn.LayoutOrder     = #tabs + 1
        TabBtn.Parent          = SideV2.Scroll
        Corner(TabBtn, 8)

        local TabV2 = ScrollV2(
            ContentArea,
            UDim2.fromScale(1, 1),
            UDim2.fromScale(0, 0),
            { top = 4, bottom = 14, left = 4, right = 6 }
        )
        TabV2.Wrapper.Visible = false

        local entry = { Btn = TabBtn, Wrapper = TabV2.Wrapper, Scroll = TabV2.Scroll, Layout = TabV2.Layout }
        table.insert(tabs, entry)

        if #tabs == 1 then SetActiveTab(entry) end

        TabBtn.MouseButton1Click:Connect(function()
            if not locked then SetActiveTab(entry) end
        end)
        TabBtn.MouseEnter:Connect(function()
            if activeTab ~= entry and not locked then
                Tween(TabBtn, TweenInfo.new(0.12), { BackgroundColor3 = T.Border })
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if activeTab ~= entry then
                Tween(TabBtn, TweenInfo.new(0.12), { BackgroundColor3 = T.Tertiary })
            end
        end)

        local elemCount = 0 -- Fix: Explicit LayoutOrdering prevents scrambling
        local function NewElem(h)
            elemCount = elemCount + 1
            local f = Instance.new("Frame")
            f.Size            = UDim2.new(1, 0, 0, h)
            f.BackgroundColor3= T.Elem
            f.BorderSizePixel = 0
            f.LayoutOrder     = elemCount
            f.Parent          = TabV2.Scroll
            Corner(f, 10)
            return f
        end

        local function AddLabels(parent, title, desc, ox)
            ox = ox or 0
            local hasD = desc and desc ~= ""
            local tl = Instance.new("TextLabel")
            tl.Size                  = UDim2.new(1, -118 - ox, 0, 16)
            tl.Position              = UDim2.new(0, 12 + ox, 0.5, hasD and -11 or -8)
            tl.BackgroundTransparency= 1
            tl.Text                  = title
            tl.TextColor3            = T.Text
            tl.Font                  = Enum.Font.GothamBold
            tl.TextSize              = 13
            tl.TextXAlignment        = Enum.TextXAlignment.Left
            tl.Parent                = parent
            if hasD then
                local dl = Instance.new("TextLabel")
                dl.Size                  = UDim2.new(1, -118 - ox, 0, 13)
                dl.Position              = UDim2.new(0, 12 + ox, 0.5, 3)
                dl.BackgroundTransparency= 1
                dl.Text                  = desc
                dl.TextColor3            = T.SubText
                dl.Font                  = Enum.Font.Gotham
                dl.TextSize              = 11
                dl.TextXAlignment        = Enum.TextXAlignment.Left
                dl.Parent                = parent
            end
        end

        local Elem = {}

        function Elem:Button(cfg)
            cfg = cfg or {}
            local lk = cfg.Locked or false
            local e  = NewElem(52)
            AddLabels(e, cfg.Title or "Button", cfg.Desc or "")

            local Btn = Instance.new("TextButton")
            Btn.Size            = UDim2.new(0, 68, 0, 28)
            Btn.Position        = UDim2.new(1, -78, 0.5, -14)
            Btn.BackgroundColor3= lk and T.Border or T.Accent
            Btn.Text            = lk and "🔒" or "Run"
            Btn.TextColor3      = T.Text
            Btn.Font            = Enum.Font.GothamBold
            Btn.TextSize        = 12
            Btn.BorderSizePixel = 0
            Btn.Parent          = e
            Corner(Btn, 8)

            if not lk then
                Btn.MouseEnter:Connect(function() Tween(Btn, TweenInfo.new(0.12), { BackgroundColor3 = T.AccentHov }) end)
                Btn.MouseLeave:Connect(function() Tween(Btn, TweenInfo.new(0.12), { BackgroundColor3 = T.Accent }) end)
                Btn.MouseButton1Click:Connect(function()
                    Tween(Btn, TweenInfo.new(0.07), { BackgroundColor3 = T.Text })
                    task.delay(0.14, function() Tween(Btn, TweenInfo.new(0.15), { BackgroundColor3 = T.Accent }) end)
                    if cfg.Callback then task.spawn(cfg.Callback) end
                end)
            end

            return {
                SetLocked = function(v)
                    lk = v
                    Btn.BackgroundColor3 = v and T.Border or T.Accent
                    Btn.Text             = v and "🔒" or "Run"
                end,
            }
        end

        function Elem:Dropdown(cfg)
            cfg = cfg or {}
            local vals = cfg.Values or {}
            local cur  = cfg.Value  or (vals[1] or "None")
            local e    = NewElem(52)
            AddLabels(e, cfg.Title or "Dropdown", cfg.Desc or "")

            local DBtn = Instance.new("TextButton")
            DBtn.Size            = UDim2.new(0, 124, 0, 28)
            DBtn.Position        = UDim2.new(1, -134, 0.5, -14)
            DBtn.BackgroundColor3= T.Tertiary
            DBtn.Text            = cur .. "  ▾"
            DBtn.TextColor3      = T.Text
            DBtn.Font            = Enum.Font.Gotham
            DBtn.TextSize        = 12
            DBtn.BorderSizePixel = 0
            DBtn.ClipsDescendants= true
            DBtn.Parent          = e
            Corner(DBtn, 8)
            local dStroke = NewStroke(DBtn, T.Border)

            DBtn.MouseEnter:Connect(function()
                Tween(DBtn,   TweenInfo.new(0.12), { BackgroundColor3 = T.BorderHi })
                Tween(dStroke,TweenInfo.new(0.12), { Color = T.Accent })
            end)
            DBtn.MouseLeave:Connect(function()
                Tween(DBtn,   TweenInfo.new(0.12), { BackgroundColor3 = T.Tertiary })
                Tween(dStroke,TweenInfo.new(0.12), { Color = T.Border })
            end)
            DBtn.MouseButton1Click:Connect(function()
                OpenDropdown(cfg.Title or "Select", vals, cur, function(val)
                    cur      = val
                    DBtn.Text= val .. "  ▾"
                    if cfg.Callback then task.spawn(cfg.Callback, val) end
                end)
            end)

            return {
                SetValue  = function(v) cur = v; DBtn.Text = v .. "  ▾" end,
                GetValue  = function() return cur end,
                SetValues = function(newVals)
                    vals = newVals
                    if not table.find(vals, cur) then
                        cur = vals[1] or "None"; DBtn.Text = cur .. "  ▾"
                    end
                end,
            }
        end

        function Elem:Toggle(cfg)
            cfg = cfg or {}
            local state = cfg.Value or false
            local e     = NewElem(52)
            AddLabels(e, cfg.Title or "Toggle", cfg.Desc or "")

            local Track = Instance.new("Frame")
            Track.Size            = UDim2.new(0, 46, 0, 24)
            Track.Position        = UDim2.new(1, -58, 0.5, -12)
            Track.BackgroundColor3= state and T.Accent or T.Border
            Track.BorderSizePixel = 0
            Track.Parent          = e
            Corner(Track, 12)

            local Knob = Instance.new("Frame")
            Knob.Size            = UDim2.new(0, 18, 0, 18)
            Knob.AnchorPoint     = Vector2.new(0, 0.5)
            Knob.Position        = state and UDim2.new(0, 25, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
            Knob.BackgroundColor3= T.Text
            Knob.BorderSizePixel = 0
            Knob.ZIndex          = 2
            Knob.Parent          = Track
            Corner(Knob, 9)

            local Click = Instance.new("TextButton")
            Click.Size                = UDim2.fromScale(1, 1)
            Click.BackgroundTransparency = 1
            Click.Text                = ""
            Click.ZIndex              = 3
            Click.Parent              = Track

            local function ApplyState(v)
                state = v
                Tween(Track, TweenInfo.new(0.2), { BackgroundColor3 = v and T.Accent or T.Border })
                Tween(Knob,  TweenInfo.new(0.22, Enum.EasingStyle.Back), { Position = v and UDim2.new(0, 25, 0.5, 0) or UDim2.new(0,  3, 0.5, 0) })
            end

            Click.MouseButton1Click:Connect(function()
                ApplyState(not state)
                if cfg.Callback then task.spawn(cfg.Callback, state) end
            end)

            return { SetValue = ApplyState, GetValue = function() return state end }
        end

        function Elem:Slider(cfg)
            cfg = cfg or {}
            local vc  = cfg.Value  or {}
            local mn  = vc.Min     or 0
            local mx  = vc.Max     or 100
            local def = vc.Default or mn
            local stp = cfg.Step   or 1
            local cur = math.clamp(def, mn, mx)

            local e = NewElem(72)

            local TL = Instance.new("TextLabel")
            TL.Size                  = UDim2.new(1, -92, 0, 16)
            TL.Position              = UDim2.new(0, 12, 0, 9)
            TL.BackgroundTransparency= 1
            TL.Text                  = cfg.Title or "Slider"
            TL.TextColor3            = T.Text
            TL.Font                  = Enum.Font.GothamBold
            TL.TextSize              = 13
            TL.TextXAlignment        = Enum.TextXAlignment.Left
            TL.Parent                = e

            local VL = Instance.new("TextLabel")
            VL.Size                  = UDim2.new(0, 74, 0, 16)
            VL.Position              = UDim2.new(1, -84, 0, 9)
            VL.BackgroundTransparency= 1
            VL.Text                  = tostring(cur)
            VL.TextColor3            = T.Accent
            VL.Font                  = Enum.Font.GothamBold
            VL.TextSize              = 13
            VL.TextXAlignment        = Enum.TextXAlignment.Right
            VL.Parent                = e

            if cfg.Desc and cfg.Desc ~= "" then
                local DL = Instance.new("TextLabel")
                DL.Size                  = UDim2.new(1, -92, 0, 13)
                DL.Position              = UDim2.new(0, 12, 0, 28)
                DL.BackgroundTransparency= 1
                DL.Text                  = cfg.Desc
                DL.TextColor3            = T.SubText
                DL.Font                  = Enum.Font.Gotham
                DL.TextSize              = 11
                DL.TextXAlignment        = Enum.TextXAlignment.Left
                DL.Parent                = e
            end

            local TrackBg = Instance.new("Frame")
            TrackBg.Size            = UDim2.new(1, -24, 0, 6)
            TrackBg.Position        = UDim2.new(0, 12, 1, -17)
            TrackBg.BackgroundColor3= T.Tertiary
            TrackBg.BorderSizePixel = 0
            TrackBg.Parent          = e
            Corner(TrackBg, 3)

            local Fill = Instance.new("Frame")
            Fill.Size            = UDim2.new((cur - mn) / (mx - mn), 0, 1, 0)
            Fill.BackgroundColor3= T.Accent
            Fill.BorderSizePixel = 0
            Fill.Parent          = TrackBg
            Corner(Fill, 3)

            local FillGrad = Instance.new("UIGradient")
            FillGrad.Color  = ColorSequence.new(T.AccentDim, T.AccentHov)
            FillGrad.Parent = Fill

            local Knob = Instance.new("Frame")
            Knob.Size            = UDim2.new(0, 16, 0, 16)
            Knob.AnchorPoint     = Vector2.new(0.5, 0.5)
            Knob.Position        = UDim2.new((cur - mn) / (mx - mn), 0, 0.5, 0)
            Knob.BackgroundColor3= T.Text
            Knob.BorderSizePixel = 0
            Knob.ZIndex          = 3
            Knob.Parent          = TrackBg
            Corner(Knob, 8)

            local HitBtn = Instance.new("TextButton")
            HitBtn.Size                  = UDim2.new(1, 10, 0, 32)
            HitBtn.Position              = UDim2.new(0, -5, 0.5, -16)
            HitBtn.BackgroundTransparency= 1
            HitBtn.Text                  = ""
            HitBtn.ZIndex                = 4
            HitBtn.Parent                = TrackBg

            local function Snap(raw)
                local v
                if stp >= 1 then v = math.round(raw / stp) * stp
                else local f = 1 / stp; v = math.round(raw * f) / f end
                return math.clamp(v, mn, mx)
            end

            local function ApplySlider(v)
                cur = v
                local pct     = (cur - mn) / (mx - mn)
                Fill.Size     = UDim2.new(pct, 0, 1, 0)
                Knob.Position = UDim2.new(pct, 0, 0.5, 0)
                VL.Text       = tostring(cur)
            end

            local function MouseToVal(mouseX)
                local tx  = TrackBg.AbsolutePosition.X
                local tw  = TrackBg.AbsoluteSize.X
                if tw <= 0 then return cur end
                local pct = math.clamp((mouseX - tx) / tw, 0, 1)
                return Snap(mn + (mx - mn) * pct)
            end

            local isDragging = false
            local hbConn     = nil

            local function StartDrag()
                isDragging = true
                Tween(Knob, TweenInfo.new(0.08), { Size = UDim2.new(0, 20, 0, 20) })

                if hbConn then hbConn:Disconnect() end
                hbConn = RunService.Heartbeat:Connect(function()
                    if not isDragging then
                        hbConn:Disconnect()
                        hbConn = nil
                        return
                    end
                    local mp  = UserInputService:GetMouseLocation()
                    local newV = MouseToVal(mp.X)
                    if newV ~= cur then
                        ApplySlider(newV)
                        if cfg.Callback then task.spawn(cfg.Callback, cur) end
                    end
                end)
            end

            local function StopDrag()
                if not isDragging then return end
                isDragging = false
                Tween(Knob, TweenInfo.new(0.1), { Size = UDim2.new(0, 16, 0, 16) })
                if hbConn then hbConn:Disconnect(); hbConn = nil end
            end

            HitBtn.MouseButton1Down:Connect(function()
                local mp = UserInputService:GetMouseLocation()
                ApplySlider(MouseToVal(mp.X))
                if cfg.Callback then task.spawn(cfg.Callback, cur) end
                StartDrag()
            end)

            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then StopDrag() end
            end)

            TrackBg.MouseEnter:Connect(function()
                if not isDragging then Tween(Knob, TweenInfo.new(0.12), { BackgroundColor3 = T.AccentHov }) end
            end)
            TrackBg.MouseLeave:Connect(function()
                if not isDragging then Tween(Knob, TweenInfo.new(0.12), { BackgroundColor3 = T.Text }) end
            end)

            return { SetValue = function(v) ApplySlider(math.clamp(v, mn, mx)) end, GetValue = function() return cur end }
        end

        function Elem:Input(cfg)
            cfg = cfg or {}
            local isTA = cfg.Type == "Textarea"
            local h    = isTA and 84 or 52
            local e    = NewElem(h)
            AddLabels(e, cfg.Title or "Input", cfg.Desc or "")

            local IBg = Instance.new("Frame")
            IBg.Size            = UDim2.new(0, 158, 0, isTA and 60 or 28)
            IBg.Position        = UDim2.new(1, -168, 0.5, isTA and -30 or -14)
            IBg.BackgroundColor3= T.Tertiary
            IBg.BorderSizePixel = 0
            IBg.Parent          = e
            Corner(IBg, 8)
            local iStroke = NewStroke(IBg, T.Border)

            local TB = Instance.new("TextBox")
            TB.Size                  = UDim2.new(1, -12, 1, -6)
            TB.Position              = UDim2.new(0, 6, 0, 3)
            TB.BackgroundTransparency= 1
            TB.Text                  = cfg.Value or ""
            TB.PlaceholderText       = cfg.Placeholder or "Enter text..."
            TB.PlaceholderColor3     = T.SubText
            TB.TextColor3            = T.Text
            TB.Font                  = Enum.Font.Gotham
            TB.TextSize              = 12
            TB.TextXAlignment        = Enum.TextXAlignment.Left
            TB.TextYAlignment        = isTA and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center
            TB.TextWrapped           = isTA
            TB.MultiLine             = isTA
            TB.ClearTextOnFocus      = false
            TB.BorderSizePixel       = 0
            TB.Parent                = IBg

            TB.Focused:Connect(function()
                Tween(iStroke, TweenInfo.new(0.15), { Color = T.Accent })
                Tween(IBg,     TweenInfo.new(0.15), { BackgroundColor3 = T.BorderHi })
            end)
            TB.FocusLost:Connect(function()
                Tween(iStroke, TweenInfo.new(0.15), { Color = T.Border })
                Tween(IBg,     TweenInfo.new(0.15), { BackgroundColor3 = T.Tertiary })
                if cfg.Callback then task.spawn(cfg.Callback, TB.Text) end
            end)

            return { SetValue = function(v) TB.Text = v end, GetValue = function() return TB.Text end }
        end

        function Elem:Section(text)
            elemCount = elemCount + 1
            local wrap = Instance.new("Frame")
            wrap.Size                  = UDim2.new(1, 0, 0, 26)
            wrap.BackgroundTransparency= 1
            wrap.BorderSizePixel       = 0
            wrap.LayoutOrder           = elemCount
            wrap.Parent                = TabV2.Scroll

            local line = Instance.new("Frame")
            line.Size            = UDim2.new(1, -16, 0, 1)
            line.Position        = UDim2.new(0, 8, 0.5, 0)
            line.BackgroundColor3= T.Border
            line.BorderSizePixel = 0
            line.Parent          = wrap

            local bg = Instance.new("Frame")
            bg.Position        = UDim2.new(0, 12, 0, 4)
            bg.Size            = UDim2.new(0, 0, 0, 18)
            bg.AutomaticSize   = Enum.AutomaticSize.X
            bg.BackgroundColor3= T.Bg
            bg.BorderSizePixel = 0
            bg.Parent          = wrap

            local lbl = Instance.new("TextLabel")
            lbl.Size                  = UDim2.new(0, 0, 1, 0)
            lbl.AutomaticSize         = Enum.AutomaticSize.X
            lbl.BackgroundTransparency= 1
            lbl.BorderSizePixel       = 0
            lbl.Text                  = "  " .. (text or "Section") .. "  "
            lbl.TextColor3            = T.Accent
            lbl.Font                  = Enum.Font.GothamBold
            lbl.TextSize              = 11
            lbl.Parent                = bg

            return lbl
        end

        return Elem
    end

    return WindowObj
end

return Library
