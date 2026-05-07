--[[
    ╔══════════════════════════════════════════╗
    ║           SKUI  —  Glass UI Library      ║
    ║         by .ftgs  |  v1.0.0              ║
    ╚══════════════════════════════════════════╝
    
    Usage:
        local SKUI = loadstring(game:HttpGet("YOUR_URL"))()
        local Window = SKUI:CreateWindow({ Title = "My Hub", Author = "by .ftgs" })
        local Tab    = Window:CreateTab("Main Menu")
        local Box    = Tab:CreateLeftGroupbox("Features")
        Box:CreateButton({ Title = "Click Me", Callback = function() end })
]]

-- ─────────────────────────────────────────────────────────────────────────────
--  Services
-- ─────────────────────────────────────────────────────────────────────────────
local Players            = game:GetService("Players")
local TweenService       = game:GetService("TweenService")
local UserInputService   = game:GetService("UserInputService")

local LocalPlayer  = Players.LocalPlayer
local PlayerGui    = LocalPlayer:WaitForChild("PlayerGui")

-- ─────────────────────────────────────────────────────────────────────────────
--  Theme
-- ─────────────────────────────────────────────────────────────────────────────
local T = {
    -- Window glass
    WinBG           = Color3.fromRGB(255, 255, 255),
    WinAlpha        = 0.12,          -- very see-through → glass look
    -- Title bar
    TitleBG         = Color3.fromRGB(245, 248, 255),
    TitleAlpha      = 0.25,
    -- Left panel
    PanelBG         = Color3.fromRGB(228, 238, 255),
    PanelAlpha      = 0.45,
    -- Tab button
    TabDef          = Color3.fromRGB(210, 225, 255),
    TabDefAlpha     = 0.65,
    TabHov          = Color3.fromRGB(190, 215, 255),
    TabHovAlpha     = 0.45,
    TabSel          = Color3.fromRGB(110, 160, 255),
    TabSelAlpha     = 0.10,
    -- Groupbox
    GroupBG         = Color3.fromRGB(245, 250, 255),
    GroupAlpha      = 0.50,
    GroupBorder     = Color3.fromRGB(180, 205, 255),
    -- Elements
    ElemBG          = Color3.fromRGB(242, 247, 255),
    ElemAlpha       = 0.55,
    -- Text
    TextMain        = Color3.fromRGB(25, 30, 45),
    TextSub         = Color3.fromRGB(90, 100, 125),
    TextWhite       = Color3.fromRGB(255, 255, 255),
    -- Accent / Brand
    Accent          = Color3.fromRGB(100, 155, 255),
    AccentHov       = Color3.fromRGB(75, 130, 240),
    AccentDark      = Color3.fromRGB(60, 105, 210),
    -- Toggle
    TogOff          = Color3.fromRGB(185, 190, 200),
    TogOn           = Color3.fromRGB(90, 205, 120),
    -- Slider
    SliderBG        = Color3.fromRGB(210, 218, 235),
    SliderFill      = Color3.fromRGB(100, 155, 255),
    -- Input
    InputBG         = Color3.fromRGB(252, 254, 255),
    InputAlpha      = 0.20,
    -- Stroke
    StrokeWin       = Color3.fromRGB(215, 228, 255),
    StrokeAccent    = Color3.fromRGB(130, 175, 255),
    -- Close btn
    CloseRed        = Color3.fromRGB(255, 85, 85),
    -- Minimize btn (floating)
    MiniBG          = Color3.fromRGB(255, 255, 255),
    MiniAlpha       = 0.08,
    -- Dropdown popup
    PopupBG         = Color3.fromRGB(250, 253, 255),
    PopupAlpha      = 0.04,
}

-- ─────────────────────────────────────────────────────────────────────────────
--  Helpers
-- ─────────────────────────────────────────────────────────────────────────────
local function tween(obj, t, props)
    TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = parent
    return c
end

local function stroke(parent, color, alpha, thick)
    local s = Instance.new("UIStroke")
    s.Color = color or T.StrokeWin
    s.Transparency = alpha or 0.35
    s.Thickness = thick or 1.2
    s.Parent = parent
    return s
end

local function shadow(parent)
    local s = Instance.new("ImageLabel")
    s.Name = "_Shadow"
    s.AnchorPoint = Vector2.new(0.5, 0.5)
    s.BackgroundTransparency = 1
    s.Position = UDim2.new(0.5, 0, 0.5, 6)
    s.Size = UDim2.new(1, 26, 1, 26)
    s.ZIndex = (parent.ZIndex or 1) - 1
    s.Image = "rbxassetid://6014261993"   -- soft rounded shadow asset
    s.ImageColor3 = Color3.fromRGB(100, 120, 180)
    s.ImageTransparency = 0.72
    s.ScaleType = Enum.ScaleType.Slice
    s.SliceCenter = Rect.new(49, 49, 450, 450)
    s.Parent = parent
    return s
end

-- Glass gradient overlay applied to any frame for the frosted look
local function glassGradient(parent)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(240, 246, 255)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(225, 237, 255)),
    })
    g.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0,   0.00),
        NumberSequenceKeypoint.new(0.5, 0.06),
        NumberSequenceKeypoint.new(1,   0.15),
    })
    g.Rotation = 135
    g.Parent = parent
    return g
end

-- Draggable helper
local function makeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = i.Position
            startPos  = frame.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then
                    dragging = false
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
        if i == dragInput and dragging then
            local d = i.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
        end
    end)
end

-- ─────────────────────────────────────────────────────────────────────────────
--  Library root
-- ─────────────────────────────────────────────────────────────────────────────
local SKUI = {}
SKUI.__index = SKUI

-- ─────────────────────────────────────────────────────────────────────────────
--  SKUI:CreateWindow
-- ─────────────────────────────────────────────────────────────────────────────
function SKUI:CreateWindow(cfg)
    cfg = cfg or {}
    local wTitle  = cfg.Title  or "SKUI Hub"
    local wImage  = tostring(cfg.Image or "")
    local wAuthor = cfg.Author or ""

    -- ── ScreenGui ──────────────────────────────────────────────────────────
    local gui = Instance.new("ScreenGui")
    gui.Name            = "SKUI_" .. wTitle
    gui.ResetOnSpawn    = false
    gui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder    = 999
    gui.IgnoreGuiInset  = true
    gui.Parent          = PlayerGui

    -- Dropdown overlay (always on top, captures outside clicks)
    local dropOverlay = Instance.new("Frame")
    dropOverlay.Name                = "DropOverlay"
    dropOverlay.Size                = UDim2.new(1,0,1,0)
    dropOverlay.BackgroundTransparency = 1
    dropOverlay.ZIndex              = 200
    dropOverlay.Visible             = false
    dropOverlay.Parent              = gui

    -- ── Main Window Frame ──────────────────────────────────────────────────
    local win = Instance.new("Frame")
    win.Name                    = "Window"
    win.Size                    = UDim2.new(0, 550, 0, 340)
    win.Position                = UDim2.new(0.5, -320, 0.5, -210)
    win.BackgroundColor3        = T.WinBG
    win.BackgroundTransparency  = T.WinAlpha
    win.BorderSizePixel         = 0
    win.ZIndex                  = 10
    win.Parent                  = gui

    corner(win, 14)
    stroke(win, T.StrokeWin, 0.30, 1.5)
    glassGradient(win)
    shadow(win)

    -- ── Title Bar ──────────────────────────────────────────────────────────
    local titleBar = Instance.new("Frame")
    titleBar.Name                   = "TitleBar"
    titleBar.Size                   = UDim2.new(1, 0, 0, 46)
    titleBar.BackgroundColor3       = T.TitleBG
    titleBar.BackgroundTransparency = T.TitleAlpha
    titleBar.BorderSizePixel        = 0
    titleBar.ZIndex                 = 11
    titleBar.Parent                 = win

    corner(titleBar, 14)

    -- Patch square bottom corners of titleBar
    local titlePatch = Instance.new("Frame")
    titlePatch.Size                     = UDim2.new(1, 0, 0, 14)
    titlePatch.Position                 = UDim2.new(0, 0, 1, -14)
    titlePatch.BackgroundColor3         = T.TitleBG
    titlePatch.BackgroundTransparency   = T.TitleAlpha
    titlePatch.BorderSizePixel          = 0
    titlePatch.ZIndex                   = 11
    titlePatch.Parent                   = titleBar

    -- Window icon
    local iconOffset = 0
    if wImage ~= "" and wImage ~= "0" then
        local ico = Instance.new("ImageLabel")
        ico.Size                    = UDim2.new(0, 26, 0, 26)
        ico.Position                = UDim2.new(0, 12, 0.5, -13)
        ico.BackgroundTransparency  = 1
        ico.Image                   = "rbxassetid://" .. wImage
        ico.ZIndex                  = 12
        ico.Parent                  = titleBar
        iconOffset = 40
    end

    -- Window title
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size               = UDim2.new(0, 240, 1, 0)
    titleLbl.Position           = UDim2.new(0, 12 + iconOffset, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text               = wTitle
    titleLbl.TextColor3         = T.TextMain
    titleLbl.Font               = Enum.Font.GothamBold
    titleLbl.TextSize           = 15
    titleLbl.TextXAlignment     = Enum.TextXAlignment.Left
    titleLbl.ZIndex             = 12
    titleLbl.Parent             = titleBar

    -- Author label (centered)
    if wAuthor ~= "" then
        local authLbl = Instance.new("TextLabel")
        authLbl.Size                = UDim2.new(0, 260, 1, 0)
        authLbl.Position            = UDim2.new(0.5, -130, 0, 0)
        authLbl.BackgroundTransparency = 1
        authLbl.Text                = wAuthor
        authLbl.TextColor3          = T.TextSub
        authLbl.Font                = Enum.Font.Gotham
        authLbl.TextSize            = 11
        authLbl.TextXAlignment      = Enum.TextXAlignment.Center
        authLbl.ZIndex              = 12
        authLbl.Parent              = titleBar
    end

    -- Close button (top-right)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name                   = "CloseBtn"
    closeBtn.Size                   = UDim2.new(0, 28, 0, 28)
    closeBtn.Position               = UDim2.new(1, -40, 0.5, -14)
    closeBtn.BackgroundColor3       = T.CloseRed
    closeBtn.BackgroundTransparency = 0.20
    closeBtn.BorderSizePixel        = 0
    closeBtn.Text                   = "✕"
    closeBtn.TextColor3             = T.TextWhite
    closeBtn.Font                   = Enum.Font.GothamBold
    closeBtn.TextSize               = 12
    closeBtn.ZIndex                 = 13
    closeBtn.Parent                 = titleBar
    corner(closeBtn, 7)

    closeBtn.MouseEnter:Connect(function()
        tween(closeBtn, 0.12, { BackgroundTransparency = 0 })
    end)
    closeBtn.MouseLeave:Connect(function()
        tween(closeBtn, 0.12, { BackgroundTransparency = 0.20 })
    end)

    -- ── Content Area ───────────────────────────────────────────────────────
    local content = Instance.new("Frame")
    content.Name                    = "Content"
    content.Size                    = UDim2.new(1, 0, 1, -46)
    content.Position                = UDim2.new(0, 0, 0, 46)
    content.BackgroundTransparency  = 1
    content.BorderSizePixel         = 0
    content.ZIndex                  = 10
    content.Parent                  = win

    -- ── Left Panel (Tab list) ──────────────────────────────────────────────
    local leftPanel = Instance.new("ScrollingFrame")
    leftPanel.Name                      = "LeftPanel"
    leftPanel.Size                      = UDim2.new(0, 148, 1, -10)
    leftPanel.Position                  = UDim2.new(0, 6, 0, 5)
    leftPanel.BackgroundColor3          = T.PanelBG
    leftPanel.BackgroundTransparency    = T.PanelAlpha
    leftPanel.BorderSizePixel           = 0
    leftPanel.ScrollBarThickness        = 3
    leftPanel.ScrollBarImageColor3      = T.Accent
    leftPanel.ScrollingDirection        = Enum.ScrollingDirection.Y
    leftPanel.CanvasSize                = UDim2.new(0, 0, 0, 0)
    leftPanel.AutomaticCanvasSize       = Enum.AutomaticSize.Y
    leftPanel.ZIndex                    = 11
    leftPanel.Parent                    = content

    corner(leftPanel, 10)
    stroke(leftPanel, T.StrokeAccent, 0.50, 1.0)

    local leftLayout = Instance.new("UIListLayout")
    leftLayout.SortOrder    = Enum.SortOrder.LayoutOrder
    leftLayout.Padding      = UDim.new(0, 4)
    leftLayout.Parent       = leftPanel

    local leftPad = Instance.new("UIPadding")
    leftPad.PaddingTop      = UDim.new(0, 8)
    leftPad.PaddingBottom   = UDim.new(0, 8)
    leftPad.PaddingLeft     = UDim.new(0, 6)
    leftPad.PaddingRight    = UDim.new(0, 6)
    leftPad.Parent          = leftPanel

    -- ── Right Panel (Element area) ─────────────────────────────────────────
    local rightPanel = Instance.new("Frame")
    rightPanel.Name                     = "RightPanel"
    rightPanel.Size                     = UDim2.new(1, -162, 1, -10)
    rightPanel.Position                 = UDim2.new(0, 158, 0, 5)
    rightPanel.BackgroundTransparency   = 1
    rightPanel.BorderSizePixel          = 0
    rightPanel.ZIndex                   = 10
    rightPanel.Parent                   = content

    -- Make window draggable via title bar
    makeDraggable(win, titleBar)

    -- ─────────────────────────────────────────────────────────────────────
    --  Window object
    -- ─────────────────────────────────────────────────────────────────────
    local W = {
        _gui          = gui,
        _win          = win,
        _titleBar     = titleBar,
        _leftPanel    = leftPanel,
        _rightPanel   = rightPanel,
        _dropOverlay  = dropOverlay,
        _closeBtn     = closeBtn,
        _tabs         = {},
        _activeTab    = nil,
        _miniFrame    = nil,
    }

    -- Close logic (wired after mini-btn is optionally created)
    closeBtn.MouseButton1Click:Connect(function()
        win.Visible = false
        if W._miniFrame then
            W._miniFrame.Visible = true
        end
    end)

    -- ── _selectTab ─────────────────────────────────────────────────────────
    function W:_selectTab(tab)
        for _, t in ipairs(self._tabs) do
            t._content.Visible          = false
            t._btn.BackgroundColor3     = T.TabDef
            t._btn.BackgroundTransparency = T.TabDefAlpha
            t._btnLabel.Font            = Enum.Font.Gotham
            t._btnLabel.TextColor3      = T.TextSub
        end
        tab._content.Visible            = true
        tab._btn.BackgroundColor3       = T.TabSel
        tab._btn.BackgroundTransparency = T.TabSelAlpha
        tab._btnLabel.Font              = Enum.Font.GothamBold
        tab._btnLabel.TextColor3        = T.TextWhite
        self._activeTab = tab
    end

    -- ── CreateTab ──────────────────────────────────────────────────────────
    function W:CreateTab(name, iconId)
        -- Tab button (left panel)
        local btn = Instance.new("TextButton")
        btn.Name                    = "Tab_" .. name
        btn.Size                    = UDim2.new(1, 0, 0, 36)
        btn.BackgroundColor3        = T.TabDef
        btn.BackgroundTransparency  = T.TabDefAlpha
        btn.BorderSizePixel         = 0
        btn.Text                    = ""
        btn.ZIndex                  = 12
        btn.Parent                  = self._leftPanel
        corner(btn, 8)

        -- Optional tab icon
        local lblOffX = 10
        if iconId and tostring(iconId) ~= "" then
            local tabIco = Instance.new("ImageLabel")
            tabIco.Size                 = UDim2.new(0, 18, 0, 18)
            tabIco.Position             = UDim2.new(0, 8, 0.5, -9)
            tabIco.BackgroundTransparency = 1
            tabIco.Image               = "rbxassetid://" .. tostring(iconId)
            tabIco.ZIndex              = 13
            tabIco.Parent              = btn
            lblOffX = 30
        end

        local btnLabel = Instance.new("TextLabel")
        btnLabel.Size               = UDim2.new(1, -(lblOffX + 4), 1, 0)
        btnLabel.Position           = UDim2.new(0, lblOffX, 0, 0)
        btnLabel.BackgroundTransparency = 1
        btnLabel.Text               = name
        btnLabel.TextColor3         = T.TextSub
        btnLabel.Font               = Enum.Font.Gotham
        btnLabel.TextSize           = 13
        btnLabel.TextXAlignment     = Enum.TextXAlignment.Left
        btnLabel.ZIndex             = 13
        btnLabel.Parent             = btn

        -- Tab content scrolling frame (right panel)
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name                     = "TabContent_" .. name
        tabContent.Size                     = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency   = 1
        tabContent.BorderSizePixel          = 0
        tabContent.ScrollBarThickness       = 3
        tabContent.ScrollBarImageColor3     = T.Accent
        tabContent.CanvasSize               = UDim2.new(0, 0, 0, 0)
        tabContent.AutomaticCanvasSize      = Enum.AutomaticSize.Y
        tabContent.Visible                  = false
        tabContent.ZIndex                   = 11
        tabContent.Parent                   = self._rightPanel

        local tcLayout = Instance.new("UIListLayout")
        tcLayout.SortOrder  = Enum.SortOrder.LayoutOrder
        tcLayout.Padding    = UDim.new(0, 8)
        tcLayout.Parent     = tabContent

        local tcPad = Instance.new("UIPadding")
        tcPad.PaddingTop    = UDim.new(0, 5)
        tcPad.PaddingLeft   = UDim.new(0, 2)
        tcPad.PaddingRight  = UDim.new(0, 6)
        tcPad.PaddingBottom = UDim.new(0, 8)
        tcPad.Parent        = tabContent

        local tab = {
            _name    = name,
            _window  = self,
            _btn     = btn,
            _btnLabel = btnLabel,
            _content = tabContent,
        }

        -- Hover effects
        btn.MouseEnter:Connect(function()
            if self._activeTab ~= tab then
                tween(btn, 0.13, { BackgroundColor3 = T.TabHov, BackgroundTransparency = T.TabHovAlpha })
                tween(btnLabel, 0.13, { TextColor3 = T.TextMain })
            end
        end)
        btn.MouseLeave:Connect(function()
            if self._activeTab ~= tab then
                tween(btn, 0.13, { BackgroundColor3 = T.TabDef, BackgroundTransparency = T.TabDefAlpha })
                tween(btnLabel, 0.13, { TextColor3 = T.TextSub })
            end
        end)
        btn.MouseButton1Click:Connect(function()
            self:_selectTab(tab)
        end)

        table.insert(self._tabs, tab)
        if #self._tabs == 1 then
            self:_selectTab(tab)
        end

        -- ── CreateLeftGroupbox / CreateRightGroupbox (alias) ───────────────
        local function makeGroupbox(gName)
            -- Groupbox outer frame
            local gFrame = Instance.new("Frame")
            gFrame.Name                     = "Groupbox_" .. gName
            gFrame.Size                     = UDim2.new(1, 0, 0, 0)
            gFrame.AutomaticSize            = Enum.AutomaticSize.Y
            gFrame.BackgroundColor3         = T.GroupBG
            gFrame.BackgroundTransparency   = T.GroupAlpha
            gFrame.BorderSizePixel          = 0
            gFrame.ZIndex                   = 12
            gFrame.Parent                   = tabContent
            corner(gFrame, 10)
            stroke(gFrame, T.GroupBorder, 0.38, 1.0)

            -- Groupbox title
            local gTitle = Instance.new("TextLabel")
            gTitle.Size                 = UDim2.new(1, -20, 0, 28)
            gTitle.Position             = UDim2.new(0, 12, 0, 0)
            gTitle.BackgroundTransparency = 1
            gTitle.Text                 = gName
            gTitle.TextColor3           = T.Accent
            gTitle.Font                 = Enum.Font.GothamBold
            gTitle.TextSize             = 13
            gTitle.TextXAlignment       = Enum.TextXAlignment.Left
            gTitle.ZIndex               = 13
            gTitle.Parent               = gFrame

            -- Separator
            local sep = Instance.new("Frame")
            sep.Size                    = UDim2.new(1, -24, 0, 1)
            sep.Position                = UDim2.new(0, 12, 0, 28)
            sep.BackgroundColor3        = T.GroupBorder
            sep.BackgroundTransparency  = 0.30
            sep.BorderSizePixel         = 0
            sep.ZIndex                  = 13
            sep.Parent                  = gFrame

            -- Elements container
            local elems = Instance.new("Frame")
            elems.Name                  = "Elements"
            elems.Size                  = UDim2.new(1, 0, 0, 0)
            elems.Position              = UDim2.new(0, 0, 0, 32)
            elems.AutomaticSize         = Enum.AutomaticSize.Y
            elems.BackgroundTransparency = 1
            elems.BorderSizePixel       = 0
            elems.ZIndex                = 12
            elems.Parent                = gFrame

            local eLayout = Instance.new("UIListLayout")
            eLayout.SortOrder   = Enum.SortOrder.LayoutOrder
            eLayout.Padding     = UDim.new(0, 5)
            eLayout.Parent      = elems

            local ePad = Instance.new("UIPadding")
            ePad.PaddingLeft    = UDim.new(0, 10)
            ePad.PaddingRight   = UDim.new(0, 10)
            ePad.PaddingBottom  = UDim.new(0, 10)
            ePad.Parent         = elems

            -- ── Groupbox object ────────────────────────────────────────────
            local GB = {
                _frame = gFrame,
                _elems = elems,
                _window = self._window,
            }

            -- ── Helper: element wrapper ────────────────────────────────────
            local function elemWrap(h, bg, bgA)
                local f = Instance.new("Frame")
                f.Size                      = UDim2.new(1, 0, 0, h)
                f.BackgroundColor3          = bg  or T.ElemBG
                f.BackgroundTransparency    = bgA or T.ElemAlpha
                f.BorderSizePixel           = 0
                f.ZIndex                    = 13
                f.Parent                    = elems
                corner(f, 7)
                return f
            end

            -- ─────────────────────────────────────────────────────────────
            --  CreateButton
            -- ─────────────────────────────────────────────────────────────
            function GB:CreateButton(cfg2)
                cfg2 = cfg2 or {}
                local locked = cfg2.Locked or false

                local f = elemWrap(34)
                f.BackgroundColor3          = locked and T.TextSub or T.Accent
                f.BackgroundTransparency    = locked and 0.55 or 0.08

                local btn2 = Instance.new("TextButton")
                btn2.Size                   = UDim2.new(1, 0, 1, 0)
                btn2.BackgroundTransparency = 1
                btn2.Text                   = cfg2.Title or "Button"
                btn2.TextColor3             = locked and T.TextSub or T.TextWhite
                btn2.Font                   = Enum.Font.GothamSemibold
                btn2.TextSize               = 13
                btn2.ZIndex                 = 14
                btn2.Parent                 = f

                if not locked then
                    btn2.MouseEnter:Connect(function()
                        tween(f, 0.13, { BackgroundColor3 = T.AccentHov, BackgroundTransparency = 0.0 })
                    end)
                    btn2.MouseLeave:Connect(function()
                        tween(f, 0.13, { BackgroundColor3 = T.Accent, BackgroundTransparency = 0.08 })
                    end)
                    btn2.MouseButton1Down:Connect(function()
                        tween(f, 0.08, { BackgroundColor3 = T.AccentDark })
                    end)
                    btn2.MouseButton1Up:Connect(function()
                        tween(f, 0.08, { BackgroundColor3 = T.AccentHov })
                    end)
                    btn2.MouseButton1Click:Connect(function()
                        if cfg2.Callback then cfg2.Callback() end
                    end)
                end
            end

            -- ─────────────────────────────────────────────────────────────
            --  CreateToggle
            -- ─────────────────────────────────────────────────────────────
            function GB:CreateToggle(cfg2)
                cfg2 = cfg2 or {}
                local val = cfg2.Value or false

                local f = elemWrap(cfg2.Desc and 48 or 36)

                local lbl = Instance.new("TextLabel")
                lbl.Size                = UDim2.new(1, -58, 0, 20)
                lbl.Position            = UDim2.new(0, 10, 0, cfg2.Desc and 4 or 8)
                lbl.BackgroundTransparency = 1
                lbl.Text                = cfg2.Title or "Toggle"
                lbl.TextColor3          = T.TextMain
                lbl.Font                = Enum.Font.Gotham
                lbl.TextSize            = 13
                lbl.TextXAlignment      = Enum.TextXAlignment.Left
                lbl.ZIndex              = 14
                lbl.Parent              = f

                if cfg2.Desc then
                    local desc = Instance.new("TextLabel")
                    desc.Size               = UDim2.new(1, -58, 0, 16)
                    desc.Position           = UDim2.new(0, 10, 0, 26)
                    desc.BackgroundTransparency = 1
                    desc.Text               = cfg2.Desc
                    desc.TextColor3         = T.TextSub
                    desc.Font               = Enum.Font.Gotham
                    desc.TextSize           = 11
                    desc.TextXAlignment     = Enum.TextXAlignment.Left
                    desc.ZIndex             = 14
                    desc.Parent             = f
                end

                -- Track
                local track = Instance.new("Frame")
                track.Size              = UDim2.new(0, 42, 0, 22)
                track.Position          = UDim2.new(1, -52, 0.5, -11)
                track.BackgroundColor3  = val and T.TogOn or T.TogOff
                track.BorderSizePixel   = 0
                track.ZIndex            = 14
                track.Parent            = f
                corner(track, 11)

                -- Knob
                local knob = Instance.new("Frame")
                knob.Size               = UDim2.new(0, 16, 0, 16)
                knob.Position           = val
                    and UDim2.new(0, 23, 0.5, -8)
                    or  UDim2.new(0,  3, 0.5, -8)
                knob.BackgroundColor3   = Color3.fromRGB(255, 255, 255)
                knob.BorderSizePixel    = 0
                knob.ZIndex             = 15
                knob.Parent             = track
                corner(knob, 8)

                local hitbox = Instance.new("TextButton")
                hitbox.Size                 = UDim2.new(1, 0, 1, 0)
                hitbox.BackgroundTransparency = 1
                hitbox.Text                 = ""
                hitbox.ZIndex               = 15
                hitbox.Parent               = f

                hitbox.MouseButton1Click:Connect(function()
                    val = not val
                    tween(track, 0.18, { BackgroundColor3 = val and T.TogOn or T.TogOff })
                    tween(knob,  0.18, { Position = val
                        and UDim2.new(0, 23, 0.5, -8)
                        or  UDim2.new(0,  3, 0.5, -8) })
                    if cfg2.Callback then cfg2.Callback(val) end
                end)
            end

            -- ─────────────────────────────────────────────────────────────
            --  CreateSlider
            -- ─────────────────────────────────────────────────────────────
            function GB:CreateSlider(cfg2)
                cfg2 = cfg2 or {}
                local vCfg  = cfg2.Value or {}
                local minV  = vCfg.Min     or 0
                local maxV  = vCfg.Max     or 100
                local defV  = vCfg.Default or minV
                local step  = cfg2.Step    or 1
                local cur   = defV
                local dragging = false

                local f = elemWrap(56)

                local titleLbl2 = Instance.new("TextLabel")
                titleLbl2.Size              = UDim2.new(1, -64, 0, 20)
                titleLbl2.Position          = UDim2.new(0, 10, 0, 5)
                titleLbl2.BackgroundTransparency = 1
                titleLbl2.Text              = cfg2.Title or "Slider"
                titleLbl2.TextColor3        = T.TextMain
                titleLbl2.Font              = Enum.Font.Gotham
                titleLbl2.TextSize          = 13
                titleLbl2.TextXAlignment    = Enum.TextXAlignment.Left
                titleLbl2.ZIndex            = 14
                titleLbl2.Parent            = f

                local valLbl = Instance.new("TextLabel")
                valLbl.Size             = UDim2.new(0, 52, 0, 20)
                valLbl.Position         = UDim2.new(1, -62, 0, 5)
                valLbl.BackgroundTransparency = 1
                valLbl.Text             = tostring(cur)
                valLbl.TextColor3       = T.Accent
                valLbl.Font             = Enum.Font.GothamBold
                valLbl.TextSize         = 13
                valLbl.TextXAlignment   = Enum.TextXAlignment.Right
                valLbl.ZIndex           = 14
                valLbl.Parent           = f

                -- Bar background
                local barBG = Instance.new("Frame")
                barBG.Size              = UDim2.new(1, -20, 0, 8)
                barBG.Position          = UDim2.new(0, 10, 0, 36)
                barBG.BackgroundColor3  = T.SliderBG
                barBG.BorderSizePixel   = 0
                barBG.ZIndex            = 14
                barBG.Parent            = f
                corner(barBG, 4)

                local pct0 = (cur - minV) / (maxV - minV)

                -- Fill
                local fill = Instance.new("Frame")
                fill.Size               = UDim2.new(pct0, 0, 1, 0)
                fill.BackgroundColor3   = T.SliderFill
                fill.BorderSizePixel    = 0
                fill.ZIndex             = 15
                fill.Parent             = barBG
                corner(fill, 4)

                -- Knob
                local knob = Instance.new("Frame")
                knob.Size               = UDim2.new(0, 16, 0, 16)
                knob.Position           = UDim2.new(pct0, -8, 0.5, -8)
                knob.BackgroundColor3   = Color3.fromRGB(255, 255, 255)
                knob.BorderSizePixel    = 0
                knob.ZIndex             = 16
                knob.Parent             = barBG
                corner(knob, 8)

                local kStroke = Instance.new("UIStroke")
                kStroke.Color       = T.SliderFill
                kStroke.Thickness   = 2
                kStroke.Parent      = knob

                -- Invisible full-bar hitbox
                local hitbox = Instance.new("TextButton")
                hitbox.Size                 = UDim2.new(1, 0, 0, 24)
                hitbox.Position             = UDim2.new(0, 0, 0.5, -12)
                hitbox.BackgroundTransparency = 1
                hitbox.Text                 = ""
                hitbox.ZIndex               = 17
                hitbox.Parent               = barBG

                local function applyPos(inputPos)
                    local abs  = barBG.AbsolutePosition
                    local size = barBG.AbsoluteSize
                    local rel  = math.clamp((inputPos.X - abs.X) / size.X, 0, 1)
                    local raw  = minV + rel * (maxV - minV)
                    -- Apply step
                    local stepped = math.round(raw / step) * step
                    stepped = math.clamp(stepped, minV, maxV)
                    -- Float precision
                    if step < 1 then
                        local dec = math.ceil(-math.log10(step))
                        stepped = math.floor(stepped * (10^dec) + 0.5) / (10^dec)
                    end
                    cur = stepped
                    local p = (stepped - minV) / (maxV - minV)
                    fill.Size     = UDim2.new(p, 0, 1, 0)
                    knob.Position = UDim2.new(p, -8, 0.5, -8)
                    valLbl.Text   = tostring(stepped)
                    if cfg2.Callback then cfg2.Callback(stepped) end
                end

                hitbox.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1
                    or i.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        applyPos(i.Position)
                    end
                end)
                UserInputService.InputChanged:Connect(function(i)
                    if dragging and (
                        i.UserInputType == Enum.UserInputType.MouseMovement or
                        i.UserInputType == Enum.UserInputType.Touch) then
                        applyPos(i.Position)
                    end
                end)
                UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1
                    or i.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)
            end

            -- ─────────────────────────────────────────────────────────────
            --  CreateInput
            -- ─────────────────────────────────────────────────────────────
            function GB:CreateInput(cfg2)
                cfg2 = cfg2 or {}

                local f = elemWrap(56)

                local lbl = Instance.new("TextLabel")
                lbl.Size                = UDim2.new(1, -20, 0, 20)
                lbl.Position            = UDim2.new(0, 10, 0, 4)
                lbl.BackgroundTransparency = 1
                lbl.Text                = cfg2.Title or "Input"
                lbl.TextColor3          = T.TextMain
                lbl.Font                = Enum.Font.Gotham
                lbl.TextSize            = 13
                lbl.TextXAlignment      = Enum.TextXAlignment.Left
                lbl.ZIndex              = 14
                lbl.Parent              = f

                local box = Instance.new("TextBox")
                box.Size                = UDim2.new(1, -20, 0, 24)
                box.Position            = UDim2.new(0, 10, 0, 26)
                box.BackgroundColor3    = T.InputBG
                box.BackgroundTransparency = T.InputAlpha
                box.BorderSizePixel     = 0
                box.Text                = cfg2.Value or ""
                box.PlaceholderText     = cfg2.Placeholder or "Enter text…"
                box.PlaceholderColor3   = Color3.fromRGB(155, 165, 185)
                box.TextColor3          = T.TextMain
                box.Font                = Enum.Font.Gotham
                box.TextSize            = 12
                box.TextXAlignment      = Enum.TextXAlignment.Left
                box.ClearTextOnFocus    = false
                box.ZIndex              = 14
                box.Parent              = f
                corner(box, 5)

                local boxStroke = stroke(box, T.Accent, 0.65, 1.2)

                local bPad = Instance.new("UIPadding")
                bPad.PaddingLeft = UDim.new(0, 7)
                bPad.Parent = box

                box.Focused:Connect(function()
                    tween(boxStroke, 0.15, { Transparency = 0.10 })
                end)
                box.FocusLost:Connect(function()
                    tween(boxStroke, 0.15, { Transparency = 0.65 })
                    if cfg2.Callback then cfg2.Callback(box.Text) end
                end)
            end

            -- ─────────────────────────────────────────────────────────────
            --  CreateDropdown
            -- ─────────────────────────────────────────────────────────────
            function GB:CreateDropdown(cfg2)
                cfg2 = cfg2 or {}
                local values  = cfg2.Values or {}
                local curVal  = cfg2.Value or (values[1] or "")

                local f = elemWrap(54)

                local lbl = Instance.new("TextLabel")
                lbl.Size                = UDim2.new(1, -20, 0, 20)
                lbl.Position            = UDim2.new(0, 10, 0, 4)
                lbl.BackgroundTransparency = 1
                lbl.Text                = cfg2.Title or "Dropdown"
                lbl.TextColor3          = T.TextMain
                lbl.Font                = Enum.Font.Gotham
                lbl.TextSize            = 13
                lbl.TextXAlignment      = Enum.TextXAlignment.Left
                lbl.ZIndex              = 14
                lbl.Parent              = f

                -- Selector pill
                local pill = Instance.new("TextButton")
                pill.Size               = UDim2.new(1, -20, 0, 24)
                pill.Position           = UDim2.new(0, 10, 0, 26)
                pill.BackgroundColor3   = T.InputBG
                pill.BackgroundTransparency = T.InputAlpha
                pill.BorderSizePixel    = 0
                pill.Text               = ""
                pill.ZIndex             = 14
                pill.Parent             = f
                corner(pill, 5)
                stroke(pill, T.Accent, 0.55, 1.1)

                local selLbl = Instance.new("TextLabel")
                selLbl.Size             = UDim2.new(1, -28, 1, 0)
                selLbl.Position         = UDim2.new(0, 8, 0, 0)
                selLbl.BackgroundTransparency = 1
                selLbl.Text             = curVal
                selLbl.TextColor3       = T.TextMain
                selLbl.Font             = Enum.Font.Gotham
                selLbl.TextSize         = 12
                selLbl.TextXAlignment   = Enum.TextXAlignment.Left
                selLbl.ZIndex           = 15
                selLbl.Parent           = pill

                local arrow = Instance.new("TextLabel")
                arrow.Size              = UDim2.new(0, 20, 1, 0)
                arrow.Position          = UDim2.new(1, -22, 0, 0)
                arrow.BackgroundTransparency = 1
                arrow.Text              = "▾"
                arrow.TextColor3        = T.Accent
                arrow.Font              = Enum.Font.GothamBold
                arrow.TextSize          = 14
                arrow.ZIndex            = 15
                arrow.Parent            = pill

                -- ── Dropdown object (returned) ─────────────────────────────
                local DO = {
                    _values  = values,
                    _current = curVal,
                    _selLbl  = selLbl,
                    _cfg     = cfg2,
                    _window  = self._window,
                }

                local overlay = self._window._dropOverlay

                local function closePopup()
                    overlay.Visible = false
                    for _, c in ipairs(overlay:GetChildren()) do c:Destroy() end
                    tween(arrow, 0.15, { Rotation = 0 })
                end

                local function openPopup()
                    -- Close any existing
                    closePopup()
                    overlay.Visible = true
                    tween(arrow, 0.15, { Rotation = 180 })

                    -- Backdrop (click-away)
                    local backdrop = Instance.new("TextButton")
                    backdrop.Size                   = UDim2.new(1, 0, 1, 0)
                    backdrop.BackgroundTransparency = 1
                    backdrop.Text                   = ""
                    backdrop.ZIndex                 = 200
                    backdrop.Parent                 = overlay
                    backdrop.MouseButton1Click:Connect(closePopup)

                    -- How many options? Cap popup height
                    local optCount = #DO._values
                    local popH = math.clamp(optCount * 36 + 56, 80, 300)

                    -- Popup frame — centered in the full screen
                    local popup = Instance.new("Frame")
                    popup.Name                      = "DropPopup"
                    popup.AnchorPoint               = Vector2.new(0.5, 0.5)
                    popup.Size                      = UDim2.new(0, 260, 0, 0)
                    popup.Position                  = UDim2.new(0.5, 0, 0.5, 0)
                    popup.BackgroundColor3          = T.PopupBG
                    popup.BackgroundTransparency    = T.PopupAlpha
                    popup.BorderSizePixel           = 0
                    popup.ClipsDescendants          = true
                    popup.ZIndex                    = 201
                    popup.Parent                    = overlay
                    corner(popup, 14)
                    stroke(popup, T.Accent, 0.28, 1.5)
                    glassGradient(popup)
                    shadow(popup)

                    -- Popup header
                    local popHeader = Instance.new("TextLabel")
                    popHeader.Size              = UDim2.new(1, -16, 0, 36)
                    popHeader.Position          = UDim2.new(0, 12, 0, 0)
                    popHeader.BackgroundTransparency = 1
                    popHeader.Text              = cfg2.Title or "Select"
                    popHeader.TextColor3        = T.Accent
                    popHeader.Font              = Enum.Font.GothamBold
                    popHeader.TextSize          = 13
                    popHeader.TextXAlignment    = Enum.TextXAlignment.Left
                    popHeader.ZIndex            = 202
                    popHeader.Parent            = popup

                    local popSep = Instance.new("Frame")
                    popSep.Size                 = UDim2.new(1, -24, 0, 1)
                    popSep.Position             = UDim2.new(0, 12, 0, 36)
                    popSep.BackgroundColor3     = T.Accent
                    popSep.BackgroundTransparency = 0.55
                    popSep.BorderSizePixel      = 0
                    popSep.ZIndex               = 202
                    popSep.Parent               = popup

                    -- Scroll area for options
                    local scroll = Instance.new("ScrollingFrame")
                    scroll.Size                     = UDim2.new(1, 0, 1, -44)
                    scroll.Position                 = UDim2.new(0, 0, 0, 42)
                    scroll.BackgroundTransparency   = 1
                    scroll.BorderSizePixel          = 0
                    scroll.ScrollBarThickness       = 3
                    scroll.ScrollBarImageColor3     = T.Accent
                    scroll.CanvasSize               = UDim2.new(0, 0, 0, 0)
                    scroll.AutomaticCanvasSize      = Enum.AutomaticSize.Y
                    scroll.ZIndex                   = 202
                    scroll.Parent                   = popup

                    local scrollLayout = Instance.new("UIListLayout")
                    scrollLayout.SortOrder  = Enum.SortOrder.LayoutOrder
                    scrollLayout.Padding    = UDim.new(0, 3)
                    scrollLayout.Parent     = scroll

                    local scrollPad = Instance.new("UIPadding")
                    scrollPad.PaddingLeft   = UDim.new(0, 8)
                    scrollPad.PaddingRight  = UDim.new(0, 8)
                    scrollPad.PaddingTop    = UDim.new(0, 4)
                    scrollPad.PaddingBottom = UDim.new(0, 6)
                    scrollPad.Parent        = scroll

                    for _, v in ipairs(DO._values) do
                        local isSelected = (v == DO._current)

                        local optBtn = Instance.new("TextButton")
                        optBtn.Size                 = UDim2.new(1, 0, 0, 32)
                        optBtn.BackgroundColor3     = isSelected and T.Accent or T.ElemBG
                        optBtn.BackgroundTransparency = isSelected and 0.05 or 0.40
                        optBtn.BorderSizePixel      = 0
                        optBtn.Text                 = v
                        optBtn.TextColor3           = isSelected and T.TextWhite or T.TextMain
                        optBtn.Font                 = isSelected and Enum.Font.GothamSemibold or Enum.Font.Gotham
                        optBtn.TextSize             = 13
                        optBtn.ZIndex               = 203
                        optBtn.Parent               = scroll
                        corner(optBtn, 7)

                        optBtn.MouseEnter:Connect(function()
                            if v ~= DO._current then
                                tween(optBtn, 0.10, { BackgroundTransparency = 0.20 })
                            end
                        end)
                        optBtn.MouseLeave:Connect(function()
                            if v ~= DO._current then
                                tween(optBtn, 0.10, { BackgroundTransparency = 0.40 })
                            end
                        end)
                        optBtn.MouseButton1Click:Connect(function()
                            DO._current = v
                            DO._selLbl.Text = v
                            if cfg2.Callback then cfg2.Callback(v) end
                            closePopup()
                        end)
                    end

                    -- Animate open
                    tween(popup, 0.22, { Size = UDim2.new(0, 260, 0, popH) })
                end

                pill.MouseButton1Click:Connect(openPopup)

                pill.MouseEnter:Connect(function()
                    tween(pill, 0.12, { BackgroundTransparency = 0.05 })
                end)
                pill.MouseLeave:Connect(function()
                    tween(pill, 0.12, { BackgroundTransparency = T.InputAlpha })
                end)

                -- ── Refresh ────────────────────────────────────────────────
                function DO:Refresh(newValues)
                    self._values = newValues
                    local found = false
                    for _, v in ipairs(newValues) do
                        if v == self._current then found = true break end
                    end
                    if not found then
                        self._current   = newValues[1] or ""
                        self._selLbl.Text = self._current
                    end
                end

                return DO
            end -- CreateDropdown

            return GB
        end -- makeGroupbox

        function tab:CreateLeftGroupbox(name)
            return makeGroupbox(name)
        end
        function tab:CreateRightGroupbox(name)
            return makeGroupbox(name)
        end

        return tab
    end -- CreateTab

    -- ── CreateMinimizeBtn ──────────────────────────────────────────────────
    function W:CreateMinimizeBtn(cfg2)
        cfg2 = cfg2 or {}

        local mf = Instance.new("Frame")
        mf.Name                     = "MinimizeBtn"
        mf.Size                     = UDim2.new(0, 140, 0, 40)
        mf.Position                 = UDim2.new(0.5, -70, 0, 12)
        mf.BackgroundColor3         = T.MiniBG
        mf.BackgroundTransparency   = T.MiniAlpha
        mf.BorderSizePixel          = 0
        mf.Visible                  = false
        mf.ZIndex                   = 50
        mf.Parent                   = gui
        corner(mf, 12)
        stroke(mf, T.Accent, 0.25, 1.5)
        glassGradient(mf)
        shadow(mf)
        makeDraggable(mf)

        self._miniFrame = mf

        -- Mini icon
        local iconOff = 0
        if cfg2.Image and tostring(cfg2.Image) ~= "" and tostring(cfg2.Image) ~= "0" then
            local mIco = Instance.new("ImageLabel")
            mIco.Size                   = UDim2.new(0, 22, 0, 22)
            mIco.Position               = UDim2.new(0, 9, 0.5, -11)
            mIco.BackgroundTransparency = 1
            mIco.Image                  = "rbxassetid://" .. tostring(cfg2.Image)
            mIco.ZIndex                 = 51
            mIco.Parent                 = mf
            iconOff = 28
        end

        local miniBtn = Instance.new("TextButton")
        miniBtn.Size                    = UDim2.new(1, 0, 1, 0)
        miniBtn.BackgroundTransparency  = 1
        miniBtn.Text                    = cfg2.Title or "Open UI"
        miniBtn.TextColor3              = T.TextMain
        miniBtn.Font                    = Enum.Font.GothamSemibold
        miniBtn.TextSize                = 13
        miniBtn.ZIndex                  = 51
        miniBtn.Parent                  = mf

        if iconOff > 0 then
            miniBtn.TextXAlignment = Enum.TextXAlignment.Center
        end

        miniBtn.MouseButton1Click:Connect(function()
            win.Visible = true
            mf.Visible  = false
        end)

        miniBtn.MouseEnter:Connect(function()
            tween(mf, 0.13, { BackgroundTransparency = 0.0 })
        end)
        miniBtn.MouseLeave:Connect(function()
            tween(mf, 0.13, { BackgroundTransparency = T.MiniAlpha })
        end)

        return { _frame = mf }
    end -- CreateMinimizeBtn

    return W
end -- CreateWindow

return SKUI
