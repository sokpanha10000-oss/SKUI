-- ============================================================
--  SKUI  |  Script-Hub UI Library  |  by .ftgs
--  Glass outer window · Dark inner panels · Draggable
-- ============================================================

local SKUI = {}
SKUI.__index = SKUI

-- ── Services ──────────────────────────────────────────────────
local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

-- ── Palette ───────────────────────────────────────────────────
--   Outer window  = glass (white/air, see-through)
--   Everything inside = solid dark panels
local C = {
    -- Outer glass window (white-air, unchanged)
    GlassBG    = Color3.fromRGB(255, 255, 255),
    GlassAlpha = 0.10,   -- outer window transparency

    -- Titlebar & search bar  (dark semi-transparent)
    TitleBG    = Color3.fromRGB(10, 14, 35),
    TitleAlpha = 0.35,

    SearchBG   = Color3.fromRGB(6, 9, 22),
    SearchAlpha= 0.0,    -- fully opaque dark

    -- LEFT TAB BOX  →  solid dark
    TabFrameBG    = Color3.fromRGB(10, 14, 32),
    TabFrameAlpha = 0.0,   -- 0 = fully visible/opaque dark

    -- Tab buttons
    TabBtnBG       = Color3.fromRGB(18, 24, 52),   -- inactive dark
    TabBtnAlpha    = 0.0,
    TabActiveBG    = Color3.fromRGB(74, 143, 255),  -- blue when active
    TabActiveAlpha = 0.75,

    -- ELEMENT ROWS  →  solid dark cards
    ElementBG    = Color3.fromRGB(12, 17, 40),
    ElementAlpha = 0.0,    -- 0 = fully opaque dark card
    ElementHover = Color3.fromRGB(18, 25, 55),

    -- DROPDOWN popup  →  very dark
    DropBG    = Color3.fromRGB(8, 11, 26),
    DropAlpha = 0.0,
    DropItemHover = Color3.fromRGB(20, 28, 60),
    DropBtnBG = Color3.fromRGB(6, 9, 22),

    -- INPUT inner box
    InputBG    = Color3.fromRGB(5, 7, 18),
    InputAlpha = 0.0,

    -- SLIDER track
    SliderTrack = Color3.fromRGB(20, 26, 55),
    SliderFill  = Color3.fromRGB(74, 143, 255),

    -- TOGGLE
    ToggleOn  = Color3.fromRGB(40, 210, 120),
    ToggleOff = Color3.fromRGB(28, 32, 60),

    -- Accent / glow
    Accent      = Color3.fromRGB(74, 143, 255),
    AccentHover = Color3.fromRGB(110, 170, 255),

    -- Text
    TextPrimary   = Color3.fromRGB(210, 225, 255),
    TextSecondary = Color3.fromRGB(110, 140, 200),
    TextAccent    = Color3.fromRGB(74,  143, 255),

    -- Borders
    BorderDark  = Color3.fromRGB(30,  40,  80),   -- dark box border
    BorderGlass = Color3.fromRGB(255, 255, 255),  -- glass outer border

    -- Shadow
    Shadow = Color3.fromRGB(0, 4, 15),
}

local FONT      = Enum.Font.GothamBold
local FONT_SEMI = Enum.Font.GothamSemibold
local FONT_REG  = Enum.Font.Gotham

-- ── Helpers ───────────────────────────────────────────────────
local function tween(obj, props, t, style, dir)
    TweenService:Create(obj,
        TweenInfo.new(t or 0.18, style or Enum.EasingStyle.Quad,
            dir or Enum.EasingDirection.Out),
        props):Play()
end

local function new(class, props)
    local o = Instance.new(class)
    for k,v in pairs(props) do o[k] = v end
    return o
end

local function corner(parent, r)
    new("UICorner", { Parent = parent, CornerRadius = UDim.new(0, r or 8) })
end

local function stroke(parent, color, alpha, thick)
    new("UIStroke", {
        Parent       = parent,
        Color        = color,
        Transparency = alpha  or 0,
        Thickness    = thick  or 1,
    })
end

-- Solid dark box (no glass effect — opaque dark panel)
local function darkBox(parent, size, pos, bg, r)
    local f = new("Frame", {
        Parent               = parent,
        Size                 = size,
        Position             = pos or UDim2.new(0,0,0,0),
        BackgroundColor3     = bg or C.ElementBG,
        BackgroundTransparency = 0,
        BorderSizePixel      = 0,
        ClipsDescendants     = true,
    })
    corner(f, r or 10)
    stroke(f, C.BorderDark, 0, 1)
    return f
end

-- Outer glass frame (window shell only)
local function glassBox(parent, size, pos, r)
    local f = new("Frame", {
        Parent               = parent,
        Size                 = size,
        Position             = pos or UDim2.new(0,0,0,0),
        BackgroundColor3     = C.GlassBG,
        BackgroundTransparency = C.GlassAlpha,
        BorderSizePixel      = 0,
        ClipsDescendants     = true,
    })
    corner(f, r or 14)
    stroke(f, C.BorderGlass, 0.78, 1)
    return f
end

local function label(parent, text, size, pos, tsize, font, color, xalign)
    return new("TextLabel", {
        Parent               = parent,
        Text                 = text,
        Size                 = size,
        Position             = pos or UDim2.new(0,0,0,0),
        BackgroundTransparency = 1,
        TextColor3           = color or C.TextPrimary,
        TextSize             = tsize or 13,
        Font                 = font  or FONT_REG,
        TextXAlignment       = xalign or Enum.TextXAlignment.Left,
        TextTruncate         = Enum.TextTruncate.AtEnd,
    })
end

local function makeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
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
                startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

-- ── Dropdown overlay (centered dark modal) ────────────────────
local function createDropdownOverlay(screenGui, title, values, callback, dropRef)
    local dim = new("Frame", {
        Parent               = screenGui,
        Size                 = UDim2.new(1,0,1,0),
        BackgroundColor3     = Color3.fromRGB(0,0,0),
        BackgroundTransparency = 0.50,
        BorderSizePixel      = 0,
        ZIndex               = 50,
    })

    local ITEM_H = 34
    local maxShow = math.min(#values, 7)
    local popH    = 48 + maxShow * ITEM_H + 10

    -- Popup: solid dark box
    local popup = new("Frame", {
        Parent               = dim,
        Size                 = UDim2.new(0, 270, 0, popH),
        Position             = UDim2.new(0.5, -135, 0.5, -(popH//2)),
        BackgroundColor3     = C.DropBG,
        BackgroundTransparency = 0,
        BorderSizePixel      = 0,
        ZIndex               = 51,
    })
    corner(popup, 12)
    stroke(popup, C.Accent, 0.55, 1.5)

    -- Header bar
    local hdr = new("Frame", {
        Parent               = popup,
        Size                 = UDim2.new(1,0,0,44),
        BackgroundColor3     = Color3.fromRGB(15, 20, 48),
        BackgroundTransparency = 0,
        BorderSizePixel      = 0,
        ZIndex               = 52,
    })
    corner(hdr, 12)
    -- Blue left accent line
    new("Frame", {
        Parent               = hdr,
        Size                 = UDim2.new(0,3,0,24),
        Position             = UDim2.new(0,0,0.5,-12),
        BackgroundColor3     = C.Accent,
        BackgroundTransparency = 0,
        BorderSizePixel      = 0,
        ZIndex               = 53,
    })
    label(hdr, title,
        UDim2.new(1,-40,1,0), UDim2.new(0,14,0,0),
        13, FONT_SEMI, C.TextPrimary).ZIndex = 53

    -- Close X button on header
    local hdrClose = new("TextButton", {
        Parent               = hdr,
        Size                 = UDim2.new(0,22,0,22),
        Position             = UDim2.new(1,-30,0.5,-11),
        BackgroundColor3     = Color3.fromRGB(200, 50, 50),
        BackgroundTransparency = 0.4,
        BorderSizePixel      = 0,
        Text                 = "✕",
        TextColor3           = Color3.fromRGB(255,255,255),
        TextSize             = 11,
        Font                 = FONT_SEMI,
        AutoButtonColor      = false,
        ZIndex               = 54,
    })
    corner(hdrClose, 5)
    hdrClose.MouseButton1Click:Connect(function() dim:Destroy() end)

    -- Scroll list
    local scroll = new("ScrollingFrame", {
        Parent               = popup,
        Size                 = UDim2.new(1,-10, 0, maxShow * ITEM_H),
        Position             = UDim2.new(0,5, 0, 48),
        BackgroundTransparency = 1,
        BorderSizePixel      = 0,
        ScrollBarThickness   = 3,
        ScrollBarImageColor3 = C.Accent,
        CanvasSize           = UDim2.new(0,0,0, #values * ITEM_H),
        ZIndex               = 52,
    })
    new("UIListLayout", { Parent = scroll, SortOrder = Enum.SortOrder.LayoutOrder })

    for _, val in ipairs(values) do
        local item = new("TextButton", {
            Parent               = scroll,
            Size                 = UDim2.new(1,0,0, ITEM_H),
            BackgroundColor3     = C.DropBG,
            BackgroundTransparency = 0,
            BorderSizePixel      = 0,
            Text                 = "",
            AutoButtonColor      = false,
            ZIndex               = 53,
        })
        corner(item, 6)
        local dot = new("Frame", {
            Parent               = item,
            Size                 = UDim2.new(0,5,0,5),
            Position             = UDim2.new(0,10,0.5,-2),
            BackgroundColor3     = C.Accent,
            BackgroundTransparency = 0.6,
            BorderSizePixel      = 0,
            ZIndex               = 54,
        })
        corner(dot, 3)
        label(item, val,
            UDim2.new(1,-30,1,0), UDim2.new(0,24,0,0),
            13, FONT_REG, C.TextPrimary).ZIndex = 54

        local isSelected = (dropRef and dropRef._value == val)
        if isSelected then
            item.BackgroundColor3 = Color3.fromRGB(18, 26, 58)
            dot.BackgroundTransparency = 0
        end

        item.MouseEnter:Connect(function()
            tween(item, { BackgroundColor3 = C.DropItemHover }, 0.1)
        end)
        item.MouseLeave:Connect(function()
            tween(item, {
                BackgroundColor3 = isSelected
                    and Color3.fromRGB(18,26,58)
                    or  C.DropBG
            }, 0.1)
        end)
        item.MouseButton1Click:Connect(function()
            if dropRef then
                dropRef._value      = val
                dropRef._label.Text = val
            end
            callback(val)
            dim:Destroy()
        end)
    end

    -- Click dim to close
    dim.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dim:Destroy()
        end
    end)
end

-- ══════════════════════════════════════════════════════════════
--  SKUI:CreateWindow
-- ══════════════════════════════════════════════════════════════
function SKUI:CreateWindow(cfg)
    cfg = cfg or {}
    local title  = cfg.Title  or "SKUI Hub"
    local image  = cfg.Image  or ""
    local author = cfg.Author or ""

    local screenGui = new("ScreenGui", {
        Parent          = PlayerGui,
        Name            = "SKUI_" .. title,
        ResetOnSpawn    = false,
        ZIndexBehavior  = Enum.ZIndexBehavior.Sibling,
    })

    -- Shadow
    local shadow = new("Frame", {
        Parent               = screenGui,
        Size                 = UDim2.new(0,682,0,472),
        Position             = UDim2.new(0.5,-340, 0.5,-232),
        BackgroundColor3     = C.Shadow,
        BackgroundTransparency = 0.45,
        BorderSizePixel      = 0,
    })
    corner(shadow, 16)

    -- Outer glass window (white-air glass — unchanged)
    local win = glassBox(screenGui,
        UDim2.new(0,668,0,460),
        UDim2.new(0.5,-334, 0.5,-230), 14)
    win.Name = "MainWindow"

    -- Glass shimmer top highlight
    new("Frame", {
        Parent               = win,
        Size                 = UDim2.new(1,0,0.42,0),
        BackgroundColor3     = Color3.fromRGB(255,255,255),
        BackgroundTransparency = 0.94,
        BorderSizePixel      = 0,
    })

    -- Keep shadow behind win
    shadow.Parent = win.Parent
    RunService.RenderStepped:Connect(function()
        shadow.Position = UDim2.new(
            win.Position.X.Scale, win.Position.X.Offset + 6,
            win.Position.Y.Scale, win.Position.Y.Offset + 9)
    end)
    makeDraggable(win)

    -- ── Titlebar  (dark solid) ──────────────────────────────
    local titlebar = new("Frame", {
        Parent               = win,
        Size                 = UDim2.new(1,0,0,46),
        BackgroundColor3     = C.TitleBG,
        BackgroundTransparency = C.TitleAlpha,
        BorderSizePixel      = 0,
    })
    new("UICorner", { Parent = titlebar,
        CornerRadius = UDim.new(0,12) })
    stroke(titlebar, C.BorderDark, 0, 1)

    -- Drag by titlebar
    makeDraggable(win, titlebar)

    if image ~= "" then
        new("ImageLabel", {
            Parent               = titlebar,
            Image                = image,
            Size                 = UDim2.new(0,24,0,24),
            Position             = UDim2.new(0,10,0.5,-12),
            BackgroundTransparency = 1,
            ScaleType            = Enum.ScaleType.Fit,
        })
    end

    label(titlebar, title,
        UDim2.new(1,-150,1,0),
        UDim2.new(0, image ~= "" and 40 or 12, 0,0),
        15, FONT, C.TextPrimary)

    if author ~= "" then
        label(titlebar, author,
            UDim2.new(0,220,1,0),
            UDim2.new(1,-228,0,0),
            11, FONT_REG, C.TextSecondary,
            Enum.TextXAlignment.Right)
    end

    -- Close button
    local closeBtn = new("TextButton", {
        Parent               = titlebar,
        Size                 = UDim2.new(0,26,0,26),
        Position             = UDim2.new(1,-34,0.5,-13),
        BackgroundColor3     = Color3.fromRGB(200,45,45),
        BackgroundTransparency = 0,
        BorderSizePixel      = 0,
        Text                 = "✕",
        TextColor3           = Color3.fromRGB(255,255,255),
        TextSize             = 12,
        Font                 = FONT_SEMI,
        AutoButtonColor      = false,
    })
    corner(closeBtn, 6)
    closeBtn.MouseButton1Click:Connect(function()
        tween(win,    { BackgroundTransparency = 1 }, 0.28)
        tween(shadow, { BackgroundTransparency = 1 }, 0.28)
        task.delay(0.3, function() screenGui:Destroy() end)
    end)
    closeBtn.MouseEnter:Connect(function()
        tween(closeBtn, { BackgroundColor3 = Color3.fromRGB(255,60,60) }, 0.1)
    end)
    closeBtn.MouseLeave:Connect(function()
        tween(closeBtn, { BackgroundColor3 = Color3.fromRGB(200,45,45) }, 0.1)
    end)

    -- ── Search bar  (dark solid) ──────────────────────────
    local searchBar = new("Frame", {
        Parent               = win,
        Size                 = UDim2.new(1,-24,0,30),
        Position             = UDim2.new(0,12,0,52),
        BackgroundColor3     = C.SearchBG,
        BackgroundTransparency = C.SearchAlpha,
        BorderSizePixel      = 0,
    })
    corner(searchBar, 7)
    stroke(searchBar, C.BorderDark, 0, 1)

    -- Search icon
    new("ImageLabel", {
        Parent               = searchBar,
        Size                 = UDim2.new(0,15,0,15),
        Position             = UDim2.new(0,8,0.5,-7),
        BackgroundTransparency = 1,
        Image                = "rbxassetid://6031094670",
        ImageColor3          = C.TextSecondary,
        ScaleType            = Enum.ScaleType.Fit,
    })

    local searchInput = new("TextBox", {
        Parent               = searchBar,
        Size                 = UDim2.new(1,-30,1,0),
        Position             = UDim2.new(0,28,0,0),
        BackgroundTransparency = 1,
        TextColor3           = C.TextPrimary,
        PlaceholderColor3    = C.TextSecondary,
        PlaceholderText      = "Search tabs, elements...",
        TextSize             = 12,
        Font                 = FONT_REG,
        TextXAlignment       = Enum.TextXAlignment.Left,
        ClearTextOnFocus     = false,
    })

    -- ── Body ─────────────────────────────────────────────
    local body = new("Frame", {
        Parent               = win,
        Size                 = UDim2.new(1,-24,1,-98),
        Position             = UDim2.new(0,12,0,88),
        BackgroundTransparency = 1,
        BorderSizePixel      = 0,
    })

    -- ── LEFT TAB BOX  →  solid dark panel ──────────────
    local tabFrame = darkBox(body,
        UDim2.new(0,158,1,0),
        UDim2.new(0,0,0,0),
        C.TabFrameBG, 10)
    tabFrame.Name = "TabFrame"
    -- Override stroke to accent-tinted dark border
    for _,s in ipairs(tabFrame:GetChildren()) do
        if s:IsA("UIStroke") then s:Destroy() end
    end
    stroke(tabFrame, C.Accent, 0.72, 1)

    local tabList = new("ScrollingFrame", {
        Parent               = tabFrame,
        Size                 = UDim2.new(1,-8,1,-8),
        Position             = UDim2.new(0,4,0,4),
        BackgroundTransparency = 1,
        BorderSizePixel      = 0,
        ScrollBarThickness   = 3,
        ScrollBarImageColor3 = C.Accent,
        CanvasSize           = UDim2.new(0,0,0,0),
        AutomaticCanvasSize  = Enum.AutomaticSize.Y,
    })
    new("UIListLayout", {
        Parent    = tabList,
        Padding   = UDim.new(0,4),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })

    -- ── RIGHT CONTENT (open, no box) ─────────────────
    local contentArea = new("Frame", {
        Parent               = body,
        Size                 = UDim2.new(1,-170,1,0),
        Position             = UDim2.new(0,170,0,0),
        BackgroundTransparency = 1,
        BorderSizePixel      = 0,
        ClipsDescendants     = true,
    })

    -- ─────────────────────────────────────────────────────
    local Window = {
        _screenGui   = screenGui,
        _win         = win,
        _tabList     = tabList,
        _contentArea = contentArea,
        _tabs        = {},
        _activeTab   = nil,
        _searchInput = searchInput,
        _allElements = {},
    }

    -- Search filter
    searchInput:GetPropertyChangedSignal("Text"):Connect(function()
        local q = searchInput.Text:lower()
        if q == "" then
            if Window._activeTab then
                Window._activeTab._scroll.Visible = true
            end
        else
            for _, t in ipairs(Window._tabs) do
                t._scroll.Visible = false
            end
            for _, el in ipairs(Window._allElements) do
                if el.label:lower():find(q,1,true) then el.show() end
            end
        end
    end)

    -- ── CreateTab ─────────────────────────────────────────
    function Window:CreateTab(name, iconId)

        -- Tab button  →  dark inactive, blue when active
        local tabBtn = new("TextButton", {
            Parent               = tabList,
            Size                 = UDim2.new(1,0,0,34),
            BackgroundColor3     = C.TabBtnBG,
            BackgroundTransparency = 0,
            BorderSizePixel      = 0,
            Text                 = "",
            AutoButtonColor      = false,
        })
        corner(tabBtn, 7)
        stroke(tabBtn, C.BorderDark, 0, 1)

        if iconId and iconId ~= "" then
            new("ImageLabel", {
                Parent               = tabBtn,
                Image                = iconId,
                Size                 = UDim2.new(0,16,0,16),
                Position             = UDim2.new(0,8,0.5,-8),
                BackgroundTransparency = 1,
                ScaleType            = Enum.ScaleType.Fit,
                ImageColor3          = C.TextSecondary,
            })
        end

        local tabLbl = label(tabBtn, name,
            UDim2.new(1,-36,1,0),
            UDim2.new(0, (iconId and iconId ~= "") and 28 or 10, 0,0),
            13, FONT_SEMI, C.TextSecondary)

        -- Active blue accent bar (left side)
        local accentBar = new("Frame", {
            Parent               = tabBtn,
            Size                 = UDim2.new(0,3,0,18),
            Position             = UDim2.new(0,0,0.5,-9),
            BackgroundColor3     = C.Accent,
            BackgroundTransparency = 1,
            BorderSizePixel      = 0,
        })
        corner(accentBar, 2)

        -- Content scroll
        local scroll = new("ScrollingFrame", {
            Parent               = contentArea,
            Size                 = UDim2.new(1,0,1,0),
            BackgroundTransparency = 1,
            BorderSizePixel      = 0,
            ScrollBarThickness   = 3,
            ScrollBarImageColor3 = C.Accent,
            CanvasSize           = UDim2.new(0,0,0,0),
            AutomaticCanvasSize  = Enum.AutomaticSize.Y,
            Visible              = false,
        })
        new("UIPadding", {
            Parent      = scroll,
            PaddingLeft = UDim.new(0,4),
            PaddingRight= UDim.new(0,4),
            PaddingTop  = UDim.new(0,4),
        })
        new("UIListLayout", {
            Parent    = scroll,
            Padding   = UDim.new(0,8),
            SortOrder = Enum.SortOrder.LayoutOrder,
        })

        local Tab = { _btn=tabBtn, _scroll=scroll, _name=name }

        function Tab:Activate()
            if Window._activeTab and Window._activeTab ~= self then
                local p = Window._activeTab
                tween(p._btn, { BackgroundColor3 = C.TabBtnBG }, 0.15)
                p._btn:FindFirstChildOfClass("UIStroke").Color = C.BorderDark
                -- dim accent bar
                local pb = p._btn:FindFirstChild("Frame")
                if pb then tween(pb, { BackgroundTransparency = 1 }, 0.15) end
                p._scroll.Visible = false
            end
            Window._activeTab = self
            tween(tabBtn, { BackgroundColor3 = Color3.fromRGB(16,22,52) }, 0.15)
            tabBtn:FindFirstChildOfClass("UIStroke").Color = C.Accent
            tween(accentBar, { BackgroundTransparency = 0 }, 0.15)
            tabLbl.TextColor3 = C.TextPrimary
            scroll.Visible = true
        end

        tabBtn.MouseButton1Click:Connect(function() Tab:Activate() end)
        tabBtn.MouseEnter:Connect(function()
            if Window._activeTab ~= Tab then
                tween(tabBtn, { BackgroundColor3 = Color3.fromRGB(14,19,44) }, 0.1)
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if Window._activeTab ~= Tab then
                tween(tabBtn, { BackgroundColor3 = C.TabBtnBG }, 0.1)
            end
        end)

        table.insert(self._tabs, Tab)
        if #self._tabs == 1 then Tab:Activate() end

        -- ── CreateGroupbox ─────────────────────────────────
        function Tab:CreateGroupbox(boxTitle)
            local group = new("Frame", {
                Parent               = scroll,
                Size                 = UDim2.new(1,0,0,0),
                AutomaticSize        = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                BorderSizePixel      = 0,
            })

            -- Section title
            label(group, boxTitle,
                UDim2.new(1,0,0,16),
                UDim2.new(0,4,0,0),
                11, FONT_SEMI, C.TextAccent)

            -- Divider line
            new("Frame", {
                Parent               = group,
                Size                 = UDim2.new(1,0,0,1),
                Position             = UDim2.new(0,0,0,16),
                BackgroundColor3     = C.Accent,
                BackgroundTransparency = 0.6,
                BorderSizePixel      = 0,
            })

            -- Inner list
            local inner = new("Frame", {
                Parent               = group,
                Size                 = UDim2.new(1,0,0,0),
                Position             = UDim2.new(0,0,0,20),
                AutomaticSize        = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                BorderSizePixel      = 0,
            })
            new("UIListLayout", {
                Parent    = inner,
                Padding   = UDim.new(0,5),
                SortOrder = Enum.SortOrder.LayoutOrder,
            })

            local Groupbox = { _inner = inner }

            local function reg(lbl, frame)
                table.insert(Window._allElements, {
                    label = lbl,
                    show  = function() Tab:Activate(); frame.Visible = true end,
                    hide  = function() frame.Visible = false end,
                })
            end

            -- ── dark element row ──
            local function elRow(titleStr, h)
                local row = new("Frame", {
                    Parent               = inner,
                    Size                 = UDim2.new(1,0,0,h or 34),
                    BackgroundColor3     = C.ElementBG,   -- solid dark
                    BackgroundTransparency = 0,            -- fully opaque
                    BorderSizePixel      = 0,
                })
                corner(row, 8)
                stroke(row, C.BorderDark, 0, 1)
                label(row, titleStr,
                    UDim2.new(0.55,0,1,0),
                    UDim2.new(0,10,0,0),
                    13, FONT_REG, C.TextPrimary)
                -- hover effect
                row.MouseEnter:Connect(function()
                    tween(row, { BackgroundColor3 = C.ElementHover }, 0.1)
                end)
                row.MouseLeave:Connect(function()
                    tween(row, { BackgroundColor3 = C.ElementBG }, 0.1)
                end)
                return row
            end

            -- ════ Button ════════════════════════════════════
            function Groupbox:CreateButton(cfg)
                cfg = cfg or {}
                local locked = cfg.Locked or false
                local row = elRow(cfg.Title or "Button")

                local btn = new("TextButton", {
                    Parent               = row,
                    Size                 = UDim2.new(0,70,0,22),
                    Position             = UDim2.new(1,-78,0.5,-11),
                    BackgroundColor3     = locked
                        and Color3.fromRGB(28,32,60)
                        or  C.Accent,
                    BackgroundTransparency = 0,
                    BorderSizePixel      = 0,
                    Text                 = locked and "Locked" or "Run",
                    TextColor3           = locked
                        and C.TextSecondary
                        or  Color3.fromRGB(255,255,255),
                    TextSize             = 12,
                    Font                 = FONT_SEMI,
                    AutoButtonColor      = false,
                })
                corner(btn, 5)
                if not locked then
                    stroke(btn, C.Accent, 0.4, 1)
                    btn.MouseButton1Click:Connect(function()
                        tween(btn, { BackgroundColor3 = Color3.fromRGB(40,90,200) }, 0.08)
                        task.delay(0.12, function()
                            tween(btn, { BackgroundColor3 = C.Accent }, 0.12)
                        end)
                        if cfg.Callback then cfg.Callback() end
                    end)
                    btn.MouseEnter:Connect(function()
                        tween(btn, { BackgroundColor3 = C.AccentHover }, 0.1)
                    end)
                    btn.MouseLeave:Connect(function()
                        tween(btn, { BackgroundColor3 = C.Accent }, 0.1)
                    end)
                end
                reg(cfg.Title or "Button", row)
                return row
            end

            -- ════ Toggle ════════════════════════════════════
            function Groupbox:CreateToggle(cfg)
                cfg = cfg or {}
                local h = (cfg.Desc and cfg.Desc ~= "") and 46 or 34
                local row = elRow(cfg.Title or "Toggle", h)
                if cfg.Desc and cfg.Desc ~= "" then
                    label(row, cfg.Desc,
                        UDim2.new(0.7,0,0,13),
                        UDim2.new(0,10,0,20),
                        11, FONT_REG, C.TextSecondary)
                end
                local value = cfg.Value or false

                local track = new("Frame", {
                    Parent               = row,
                    Size                 = UDim2.new(0,40,0,20),
                    Position             = UDim2.new(1,-50,0.5,-10),
                    BackgroundColor3     = value and C.ToggleOn or C.ToggleOff,
                    BackgroundTransparency = 0,
                    BorderSizePixel      = 0,
                })
                corner(track, 20)

                local knob = new("Frame", {
                    Parent               = track,
                    Size                 = UDim2.new(0,16,0,16),
                    Position             = value
                        and UDim2.new(1,-18,0.5,-8)
                        or  UDim2.new(0,2,0.5,-8),
                    BackgroundColor3     = Color3.fromRGB(255,255,255),
                    BackgroundTransparency = 0,
                    BorderSizePixel      = 0,
                })
                corner(knob, 8)

                local Toggle = { _value = value }
                local trackBtn = new("TextButton", {
                    Parent = track, Size = UDim2.new(1,0,1,0),
                    BackgroundTransparency = 1, Text = "",
                    AutoButtonColor = false,
                })
                local function setT(v)
                    Toggle._value = v
                    tween(track, { BackgroundColor3 = v and C.ToggleOn or C.ToggleOff }, 0.18)
                    tween(knob,  { Position = v
                        and UDim2.new(1,-18,0.5,-8)
                        or  UDim2.new(0,2,0.5,-8) }, 0.18)
                    if cfg.Callback then cfg.Callback(v) end
                end
                trackBtn.MouseButton1Click:Connect(function() setT(not Toggle._value) end)
                function Toggle:Set(v) setT(v) end
                reg(cfg.Title or "Toggle", row)
                return Toggle
            end

            -- ════ Slider ════════════════════════════════════
            function Groupbox:CreateSlider(cfg)
                cfg = cfg or {}
                local V    = cfg.Value or {}
                local minV = V.Min or 0
                local maxV = V.Max or 100
                local step = cfg.Step or 1
                local cur  = V.Default or minV

                local row = new("Frame", {
                    Parent               = inner,
                    Size                 = UDim2.new(1,0,0,50),
                    BackgroundColor3     = C.ElementBG,
                    BackgroundTransparency = 0,
                    BorderSizePixel      = 0,
                })
                corner(row, 8)
                stroke(row, C.BorderDark, 0, 1)

                label(row, cfg.Title or "Slider",
                    UDim2.new(0.6,0,0,18),
                    UDim2.new(0,10,0,5),
                    13, FONT_REG, C.TextPrimary)

                -- Value badge
                local valLbl = new("TextLabel", {
                    Parent               = row,
                    Size                 = UDim2.new(0,46,0,18),
                    Position             = UDim2.new(1,-54,0,5),
                    BackgroundColor3     = Color3.fromRGB(14,19,46),
                    BackgroundTransparency = 0,
                    BorderSizePixel      = 0,
                    TextColor3           = C.Accent,
                    TextSize             = 12,
                    Font                 = FONT_SEMI,
                    Text                 = tostring(cur),
                    TextXAlignment       = Enum.TextXAlignment.Center,
                })
                corner(valLbl, 4)
                stroke(valLbl, C.Accent, 0.6, 1)

                -- Slider track
                local track = new("Frame", {
                    Parent               = row,
                    Size                 = UDim2.new(1,-20,0,5),
                    Position             = UDim2.new(0,10,0,36),
                    BackgroundColor3     = C.SliderTrack,
                    BackgroundTransparency = 0,
                    BorderSizePixel      = 0,
                })
                corner(track, 3)

                local initPct = (maxV ~= minV) and (cur-minV)/(maxV-minV) or 0
                local fill = new("Frame", {
                    Parent               = track,
                    Size                 = UDim2.new(initPct,0,1,0),
                    BackgroundColor3     = C.SliderFill,
                    BackgroundTransparency = 0,
                    BorderSizePixel      = 0,
                })
                corner(fill, 3)

                local knob = new("Frame", {
                    Parent               = track,
                    Size                 = UDim2.new(0,13,0,13),
                    Position             = UDim2.new(initPct,-6,0.5,-6),
                    BackgroundColor3     = Color3.fromRGB(255,255,255),
                    BackgroundTransparency = 0,
                    BorderSizePixel      = 0,
                })
                corner(knob, 7)

                local Slider = { _value = cur }
                local dragging = false

                local function setSlider(ax)
                    local ap = track.AbsolutePosition
                    local as = track.AbsoluteSize
                    local pct = math.clamp((ax - ap.X) / as.X, 0, 1)
                    local snapped = math.clamp(
                        math.round((minV + (maxV-minV)*pct) / step) * step,
                        minV, maxV)
                    Slider._value = snapped
                    local dp = (maxV ~= minV) and (snapped-minV)/(maxV-minV) or 0
                    fill.Size = UDim2.new(dp,0,1,0)
                    knob.Position = UDim2.new(dp,-6,0.5,-6)
                    valLbl.Text = tostring(snapped)
                    if cfg.Callback then cfg.Callback(snapped) end
                end

                track.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true; setSlider(i.Position.X)
                    end
                end)
                UserInputService.InputChanged:Connect(function(i)
                    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                        setSlider(i.Position.X)
                    end
                end)
                UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)

                function Slider:Set(v)
                    v = math.clamp(v, minV, maxV)
                    Slider._value = v
                    local p = (maxV ~= minV) and (v-minV)/(maxV-minV) or 0
                    fill.Size = UDim2.new(p,0,1,0)
                    knob.Position = UDim2.new(p,-6,0.5,-6)
                    valLbl.Text = tostring(v)
                end

                reg(cfg.Title or "Slider", row)
                return Slider
            end

            -- ════ Input ═════════════════════════════════════
            function Groupbox:CreateInput(cfg)
                cfg = cfg or {}
                local row = new("Frame", {
                    Parent               = inner,
                    Size                 = UDim2.new(1,0,0,52),
                    BackgroundColor3     = C.ElementBG,
                    BackgroundTransparency = 0,
                    BorderSizePixel      = 0,
                })
                corner(row, 8)
                stroke(row, C.BorderDark, 0, 1)

                label(row, cfg.Title or "Input",
                    UDim2.new(1,0,0,18),
                    UDim2.new(0,10,0,4),
                    13, FONT_REG, C.TextPrimary)

                local inputBox = new("TextBox", {
                    Parent               = row,
                    Size                 = UDim2.new(1,-20,0,22),
                    Position             = UDim2.new(0,10,0,24),
                    BackgroundColor3     = C.InputBG,
                    BackgroundTransparency = 0,
                    BorderSizePixel      = 0,
                    Text                 = cfg.Value or "",
                    PlaceholderText      = cfg.Placeholder or "Enter text...",
                    PlaceholderColor3    = C.TextSecondary,
                    TextColor3           = C.TextPrimary,
                    TextSize             = 12,
                    Font                 = FONT_REG,
                    TextXAlignment       = Enum.TextXAlignment.Left,
                    ClearTextOnFocus     = false,
                })
                corner(inputBox, 5)
                stroke(inputBox, C.BorderDark, 0, 1)
                new("UIPadding", { Parent=inputBox, PaddingLeft=UDim.new(0,6) })

                local Input = { _value = inputBox.Text }
                inputBox.FocusLost:Connect(function()
                    Input._value = inputBox.Text
                    if cfg.Callback then cfg.Callback(inputBox.Text) end
                end)
                function Input:Set(v) inputBox.Text = v; Input._value = v end
                reg(cfg.Title or "Input", row)
                return Input
            end

            -- ════ Dropdown ══════════════════════════════════
            function Groupbox:CreateDropdown(cfg)
                cfg = cfg or {}
                local row = elRow(cfg.Title or "Dropdown")
                local Dropdown = {
                    _value = cfg.Value or (cfg.Values and cfg.Values[1]) or ""
                }

                -- Dropdown trigger button  →  dark solid
                local dropBtn = new("TextButton", {
                    Parent               = row,
                    Size                 = UDim2.new(0,110,0,22),
                    Position             = UDim2.new(1,-118,0.5,-11),
                    BackgroundColor3     = C.DropBtnBG,
                    BackgroundTransparency = 0,
                    BorderSizePixel      = 0,
                    Text                 = "",
                    AutoButtonColor      = false,
                })
                corner(dropBtn, 5)
                stroke(dropBtn, C.Accent, 0.5, 1)

                Dropdown._label = label(dropBtn, Dropdown._value,
                    UDim2.new(1,-24,1,0),
                    UDim2.new(0,7,0,0),
                    12, FONT_REG, C.TextPrimary)

                -- Chevron
                new("ImageLabel", {
                    Parent               = dropBtn,
                    Size                 = UDim2.new(0,10,0,10),
                    Position             = UDim2.new(1,-14,0.5,-5),
                    BackgroundTransparency = 1,
                    Image                = "rbxassetid://6034818372",
                    ImageColor3          = C.Accent,
                    ScaleType            = Enum.ScaleType.Fit,
                })

                dropBtn.MouseButton1Click:Connect(function()
                    createDropdownOverlay(
                        screenGui,
                        cfg.Title or "Select",
                        cfg.Values or {},
                        cfg.Callback or function() end,
                        Dropdown)
                end)
                dropBtn.MouseEnter:Connect(function()
                    tween(dropBtn, { BackgroundColor3 = Color3.fromRGB(14,20,48) }, 0.1)
                end)
                dropBtn.MouseLeave:Connect(function()
                    tween(dropBtn, { BackgroundColor3 = C.DropBtnBG }, 0.1)
                end)

                function Dropdown:Refresh(newVals)
                    cfg.Values = newVals
                    if not table.find(newVals, self._value) then
                        self._value = newVals[1] or ""
                        self._label.Text = self._value
                    end
                end
                function Dropdown:Set(v)
                    if table.find(cfg.Values or {}, v) then
                        self._value = v; self._label.Text = v
                    end
                end

                reg(cfg.Title or "Dropdown", row)
                return Dropdown
            end

            return Groupbox
        end -- CreateGroupbox

        return Tab
    end -- CreateTab

    -- ── CreateMinimizeBtn  (floating, draggable) ─────────────
    function Window:CreateMinimizeBtn(cfg)
        cfg = cfg or {}
        local btnTitle = cfg.Title or "Open UI"
        local btnImage = cfg.Image or ""

        local floatBtn = new("ImageButton", {
            Parent               = screenGui,
            Size                 = UDim2.new(0,48,0,48),
            Position             = UDim2.new(0,20,1,-72),
            BackgroundColor3     = Color3.fromRGB(10,14,35),
            BackgroundTransparency = 0,
            BorderSizePixel      = 0,
            Image                = btnImage,
            ScaleType            = Enum.ScaleType.Fit,
            ZIndex               = 10,
        })
        corner(floatBtn, 12)
        stroke(floatBtn, C.Accent, 0.35, 1.5)

        if btnImage == "" then
            new("TextLabel", {
                Parent               = floatBtn,
                Size                 = UDim2.new(1,0,1,0),
                BackgroundTransparency = 1,
                Text                 = "☰",
                TextColor3           = C.TextPrimary,
                TextSize             = 22,
                Font                 = FONT,
                ZIndex               = 11,
            })
        end

        -- Tooltip
        local tip = new("TextLabel", {
            Parent               = floatBtn,
            Size                 = UDim2.new(0,94,0,26),
            Position             = UDim2.new(1,8,0.5,-13),
            BackgroundColor3     = Color3.fromRGB(8,11,26),
            BackgroundTransparency = 0,
            BorderSizePixel      = 0,
            Text                 = btnTitle,
            TextColor3           = C.TextPrimary,
            TextSize             = 11,
            Font                 = FONT_SEMI,
            Visible              = false,
            ZIndex               = 12,
        })
        corner(tip, 6)
        stroke(tip, C.BorderDark, 0, 1)

        floatBtn.MouseEnter:Connect(function() tip.Visible = true end)
        floatBtn.MouseLeave:Connect(function() tip.Visible = false end)
        makeDraggable(floatBtn)

        local uiVisible = true
        floatBtn.MouseButton1Click:Connect(function()
            uiVisible = not uiVisible
            win.Visible    = uiVisible
            shadow.Visible = uiVisible
        end)

        return floatBtn
    end

    return Window
end

return SKUI
