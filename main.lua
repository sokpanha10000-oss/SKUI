-- ============================================================
--  SKUI  |  Script-Hub UI Library  |  by .ftgs
--  Glass UI · Draggable · Tabs · Groupboxes · Scrollframes
-- ============================================================

local SKUI = {}
SKUI.__index = SKUI

-- ──────────────────────────────────────────────────────────────
--  Services
-- ──────────────────────────────────────────────────────────────
local Players           = game:GetService("Players")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local RunService        = game:GetService("RunService")

local LocalPlayer       = Players.LocalPlayer
local PlayerGui         = LocalPlayer:WaitForChild("PlayerGui")

-- ──────────────────────────────────────────────────────────────
--  Constants / Palette
-- ──────────────────────────────────────────────────────────────
local C = {
    -- Glass surfaces (outer window stays glass/white-air)
    GlassBG         = Color3.fromRGB(255, 255, 255),
    GlassAlpha      = 0.09,      -- main window transparency
    FrameBG         = Color3.fromRGB(255, 255, 255),
    FrameAlpha      = 0.09,

    -- Accents
    Accent          = Color3.fromRGB(74,  143, 255),
    AccentHover     = Color3.fromRGB(125, 180, 255),
    TabActive       = Color3.fromRGB(74,  143, 255),
    TabInactive     = Color3.fromRGB(160, 190, 235),

    -- Text
    TextPrimary     = Color3.fromRGB(210, 225, 255),
    TextSecondary   = Color3.fromRGB(130, 155, 210),
    TextDark        = Color3.fromRGB(20,  28,  55),

    -- Elements — deep dark panels
    ElementBG       = Color3.fromRGB(8,   12,  28),   -- dark element rows
    ElementAlpha    = 0.25,                            -- semi-opaque dark
    TabBG           = Color3.fromRGB(8,   12,  30),   -- dark tab frame
    TabAlpha        = 0.18,
    SliderFill      = Color3.fromRGB(58,  122, 239),
    ToggleOn        = Color3.fromRGB(40,  220, 120),
    ToggleOff       = Color3.fromRGB(30,  35,  60),
    InputBG         = Color3.fromRGB(4,   7,   20),
    DropdownBG      = Color3.fromRGB(6,   9,   22),   -- very dark dropdown

    -- Borders / Shadows
    Border          = Color3.fromRGB(255, 255, 255),
    BorderAlpha     = 0.30,
    Shadow          = Color3.fromRGB(0,   5,   20),
}

local FONT        = Enum.Font.GothamBold
local FONT_SEMI   = Enum.Font.GothamSemibold
local FONT_REG    = Enum.Font.Gotham

-- ──────────────────────────────────────────────────────────────
--  Utility helpers
-- ──────────────────────────────────────────────────────────────
local function makeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement or
           input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
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

local function tween(obj, props, t, style, dir)
    local info = TweenInfo.new(t or 0.2,
        style or Enum.EasingStyle.Quad,
        dir   or Enum.EasingDirection.Out)
    TweenService:Create(obj, info, props):Play()
end

local function newInst(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do obj[k] = v end
    return obj
end

local function glassFrame(parent, size, pos, alpha, cornerR)
    local f = newInst("Frame", {
        Parent              = parent,
        Size                = size,
        Position            = pos or UDim2.new(0,0,0,0),
        BackgroundColor3    = C.GlassBG,
        BackgroundTransparency = alpha or C.GlassAlpha,
        BorderSizePixel     = 0,
        ClipsDescendants    = true,
    })
    newInst("UICorner",  { Parent = f, CornerRadius = UDim.new(0, cornerR or 12) })
    newInst("UIStroke",  {
        Parent      = f,
        Color       = C.Border,
        Transparency= C.BorderAlpha,
        Thickness   = 1,
    })
    return f
end

local function labelText(parent, text, size, pos, textSize, font, color, xAlign)
    return newInst("TextLabel", {
        Parent               = parent,
        Text                 = text,
        Size                 = size,
        Position             = pos or UDim2.new(0,0,0,0),
        BackgroundTransparency = 1,
        TextColor3           = color or C.TextPrimary,
        TextSize             = textSize or 14,
        Font                 = font  or FONT_REG,
        TextXAlignment       = xAlign or Enum.TextXAlignment.Left,
        TextTruncate         = Enum.TextTruncate.AtEnd,
    })
end

local function iconLabel(parent, icon, size, pos, iconSize)
    return newInst("ImageLabel", {
        Parent               = parent,
        Image                = icon,
        Size                 = size or UDim2.new(0,18,0,18),
        Position             = pos  or UDim2.new(0,0,0,0),
        BackgroundTransparency = 1,
        ScaleType            = Enum.ScaleType.Fit,
        ImageColor3          = C.TextPrimary,
    })
end

-- ──────────────────────────────────────────────────────────────
--  Dropdown Overlay (modal popup)
-- ──────────────────────────────────────────────────────────────
local function createDropdownOverlay(screenGui, title, values, callback, dropRef)
    -- Dim background
    local dim = newInst("Frame", {
        Parent               = screenGui,
        Size                 = UDim2.new(1,0,1,0),
        BackgroundColor3     = Color3.fromRGB(0,0,0),
        BackgroundTransparency = 0.55,
        BorderSizePixel      = 0,
        ZIndex               = 50,
    })

    -- Popup box  ─  medium, centered
    local ITEM_H   = 36
    local maxShow  = math.min(#values, 6)
    local popH     = 44 + maxShow * ITEM_H + 12

    local popup = glassFrame(dim,
        UDim2.new(0, 260, 0, popH),
        UDim2.new(0.5, -130, 0.5, -popH//2),
        0.08, 14)
    popup.ZIndex = 51
    -- glow border
    newInst("UIStroke", { Parent = popup, Color = C.Accent, Transparency = 0.3, Thickness = 1.5 })

    -- Header
    local hdr = newInst("Frame", {
        Parent               = popup,
        Size                 = UDim2.new(1,0,0,40),
        BackgroundColor3     = C.Accent,
        BackgroundTransparency = 0.6,
        BorderSizePixel      = 0,
        ZIndex               = 52,
    })
    newInst("UICorner", { Parent = hdr, CornerRadius = UDim.new(0,12) })
    labelText(hdr, title, UDim2.new(1,-16,1,0), UDim2.new(0,12,0,0), 13, FONT_SEMI,
        C.TextPrimary, Enum.TextXAlignment.Left).ZIndex = 53

    -- Scroll list
    local scroll = newInst("ScrollingFrame", {
        Parent               = popup,
        Size                 = UDim2.new(1,-12, 0, maxShow * ITEM_H),
        Position             = UDim2.new(0, 6, 0, 44),
        BackgroundTransparency = 1,
        BorderSizePixel      = 0,
        ScrollBarThickness   = 4,
        ScrollBarImageColor3 = C.Accent,
        CanvasSize           = UDim2.new(0,0,0, #values * ITEM_H),
        ZIndex               = 52,
    })
    newInst("UIListLayout", { Parent = scroll, SortOrder = Enum.SortOrder.LayoutOrder })

    for i, val in ipairs(values) do
        local btn = newInst("TextButton", {
            Parent               = scroll,
            Size                 = UDim2.new(1,0,0, ITEM_H),
            BackgroundColor3     = Color3.fromRGB(255,255,255),
            BackgroundTransparency = 0.92,
            BorderSizePixel      = 0,
            Text                 = val,
            TextColor3           = C.TextPrimary,
            TextSize             = 13,
            Font                 = FONT_REG,
            ZIndex               = 53,
        })
        newInst("UICorner", { Parent = btn, CornerRadius = UDim.new(0,6) })
        btn.MouseEnter:Connect(function()
            tween(btn, { BackgroundTransparency = 0.75 }, 0.1)
        end)
        btn.MouseLeave:Connect(function()
            tween(btn, { BackgroundTransparency = 0.92 }, 0.1)
        end)
        btn.MouseButton1Click:Connect(function()
            if dropRef then
                dropRef._value = val
                dropRef._label.Text = val
            end
            callback(val)
            dim:Destroy()
        end)
    end

    -- Close on dim click
    dim.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dim:Destroy()
        end
    end)
end

-- ──────────────────────────────────────────────────────────────
--  SKUI:CreateWindow
-- ──────────────────────────────────────────────────────────────
function SKUI:CreateWindow(cfg)
    cfg = cfg or {}
    local title  = cfg.Title  or "SKUI Hub"
    local image  = cfg.Image  or ""
    local author = cfg.Author or ""

    -- ScreenGui
    local screenGui = newInst("ScreenGui", {
        Parent              = PlayerGui,
        Name                = "SKUI_" .. title,
        ResetOnSpawn        = false,
        ZIndexBehavior      = Enum.ZIndexBehavior.Sibling,
    })

    -- ── Shadow backdrop ──
    local shadow = newInst("Frame", {
        Parent               = screenGui,
        Size                 = UDim2.new(0, 680, 0, 470),
        Position             = UDim2.new(0.5,-340, 0.5,-235),
        BackgroundColor3     = C.Shadow,
        BackgroundTransparency = 0.5,
        BorderSizePixel      = 0,
    })
    newInst("UICorner", { Parent = shadow, CornerRadius = UDim.new(0,16) })

    -- ── Main glass window ──
    local win = glassFrame(screenGui,
        UDim2.new(0,668,0,460),
        UDim2.new(0.5,-334, 0.5,-230),
        C.GlassAlpha, 14)
    win.Name = "MainWindow"

    -- Align shadow behind window
    shadow.Parent = win.Parent

    makeDraggable(win)
    makeDraggable(shadow, win) -- shadow follows via code below

    -- keep shadow synced
    RunService.RenderStepped:Connect(function()
        shadow.Position = UDim2.new(
            win.Position.X.Scale,
            win.Position.X.Offset + 6,
            win.Position.Y.Scale,
            win.Position.Y.Offset + 8
        )
    end)

    -- ── Gradient overlay (glass shimmer) ──
    local shimmer = newInst("Frame", {
        Parent               = win,
        Size                 = UDim2.new(1,0,0.5,0),
        BackgroundColor3     = Color3.fromRGB(255,255,255),
        BackgroundTransparency = 0.92,
        BorderSizePixel      = 0,
    })
    newInst("UICorner", { Parent = shimmer, CornerRadius = UDim.new(0,12) })

    -- ── Titlebar ──
    local titlebar = newInst("Frame", {
        Parent               = win,
        Size                 = UDim2.new(1,0,0,46),
        BackgroundColor3     = Color3.fromRGB(255,255,255),
        BackgroundTransparency = 0.88,
        BorderSizePixel      = 0,
    })
    newInst("UICorner", { Parent = titlebar, CornerRadius = UDim.new(0,12) })

    -- Icon
    if image ~= "" then
        iconLabel(titlebar, image,
            UDim2.new(0,24,0,24), UDim2.new(0,12,0,11))
    end

    -- Title text
    labelText(titlebar, title,
        UDim2.new(1,-140,1,0), UDim2.new(0,44,0,0),
        15, FONT, C.TextPrimary)

    -- Author
    if author ~= "" then
        labelText(titlebar, author,
            UDim2.new(0,200,1,0),
            UDim2.new(1,-210,0,0),
            12, FONT_REG, C.TextSecondary,
            Enum.TextXAlignment.Right)
    end

    -- ── Close button ──
    local closeBtn = newInst("ImageButton", {
        Parent               = titlebar,
        Size                 = UDim2.new(0,26,0,26),
        Position             = UDim2.new(1,-36,0,10),
        BackgroundColor3     = Color3.fromRGB(255,80,80),
        BackgroundTransparency = 0.3,
        BorderSizePixel      = 0,
        Image                = "rbxassetid://7072725342",  -- X icon
        ImageColor3          = Color3.fromRGB(255,255,255),
        ScaleType            = Enum.ScaleType.Fit,
    })
    newInst("UICorner", { Parent = closeBtn, CornerRadius = UDim.new(0,6) })
    closeBtn.MouseButton1Click:Connect(function()
        tween(win,    { BackgroundTransparency = 1 }, 0.3)
        tween(shadow, { BackgroundTransparency = 1 }, 0.3)
        wait(0.31)
        screenGui:Destroy()
    end)
    closeBtn.MouseEnter:Connect(function()
        tween(closeBtn, { BackgroundTransparency = 0 }, 0.1)
    end)
    closeBtn.MouseLeave:Connect(function()
        tween(closeBtn, { BackgroundTransparency = 0.3 }, 0.1)
    end)

    -- ── Search bar (below titlebar, above tab/content split) ──
    local searchBar = newInst("Frame", {
        Parent               = win,
        Size                 = UDim2.new(1,-24,0,32),
        Position             = UDim2.new(0,12,0,52),
        BackgroundColor3     = Color3.fromRGB(255,255,255),
        BackgroundTransparency = 0.88,
        BorderSizePixel      = 0,
    })
    newInst("UICorner", { Parent = searchBar, CornerRadius = UDim.new(0,8) })
    newInst("UIStroke", {
        Parent = searchBar, Color = C.Border,
        Transparency = 0.6, Thickness = 1,
    })

    -- Search icon
    newInst("ImageLabel", {
        Parent               = searchBar,
        Size                 = UDim2.new(0,16,0,16),
        Position             = UDim2.new(0,8,0,8),
        BackgroundTransparency = 1,
        Image                = "rbxassetid://6031094670",  -- magnifier
        ImageColor3          = C.TextSecondary,
        ScaleType            = Enum.ScaleType.Fit,
    })

    local searchInput = newInst("TextBox", {
        Parent               = searchBar,
        Size                 = UDim2.new(1,-36,1,0),
        Position             = UDim2.new(0,30,0,0),
        BackgroundTransparency = 1,
        TextColor3           = C.TextPrimary,
        PlaceholderColor3    = C.TextSecondary,
        PlaceholderText      = "Search tabs, elements...",
        TextSize             = 12,
        Font                 = FONT_REG,
        TextXAlignment       = Enum.TextXAlignment.Left,
        ClearTextOnFocus     = false,
    })

    -- ── Body area ──
    local body = newInst("Frame", {
        Parent               = win,
        Size                 = UDim2.new(1,-24,1,-100),
        Position             = UDim2.new(0,12,0,90),
        BackgroundTransparency = 1,
        BorderSizePixel      = 0,
    })

    -- ── LEFT TAB FRAME (glass box) ──
    local tabFrame = glassFrame(body,
        UDim2.new(0,160,1,0),
        UDim2.new(0,0,0,0),
        0.88, 10)
    tabFrame.Name = "TabFrame"

    local tabList = newInst("ScrollingFrame", {
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
    newInst("UIListLayout", {
        Parent      = tabList,
        Padding     = UDim.new(0,4),
        SortOrder   = Enum.SortOrder.LayoutOrder,
    })

    -- ── RIGHT CONTENT AREA (no box, open) ──
    local contentArea = newInst("Frame", {
        Parent               = body,
        Size                 = UDim2.new(1,-172,1,0),
        Position             = UDim2.new(0,172,0,0),
        BackgroundTransparency = 1,
        BorderSizePixel      = 0,
        ClipsDescendants     = true,
    })

    -- ──────────────────────────────────────
    --  Window object
    -- ──────────────────────────────────────
    local Window = {}
    Window._screenGui   = screenGui
    Window._win         = win
    Window._tabList     = tabList
    Window._contentArea = contentArea
    Window._tabs        = {}
    Window._activeTab   = nil
    Window._searchInput = searchInput
    Window._allElements = {}   -- {label=str, show=fn, hide=fn}

    -- Search filter logic
    searchInput:GetPropertyChangedSignal("Text"):Connect(function()
        local query = searchInput.Text:lower()
        if query == "" then
            -- restore active tab visibility
            if Window._activeTab then
                Window._activeTab._scroll.Visible = true
            end
        else
            -- hide all tab content, show filtered
            for _, tab in ipairs(Window._tabs) do
                tab._scroll.Visible = false
            end
            -- search through registered elements
            for _, el in ipairs(Window._allElements) do
                if el.label:lower():find(query, 1, true) then
                    el.show()
                end
            end
        end
    end)

    -- ── CreateTab ──
    function Window:CreateTab(name, iconId)
        local tabBtn = newInst("TextButton", {
            Parent               = tabList,
            Size                 = UDim2.new(1,0,0,34),
            BackgroundColor3     = C.TabInactive,
            BackgroundTransparency = 0.7,
            BorderSizePixel      = 0,
            Text                 = "",
            AutoButtonColor      = false,
        })
        newInst("UICorner", { Parent = tabBtn, CornerRadius = UDim.new(0,7) })

        if iconId and iconId ~= "" then
            iconLabel(tabBtn, iconId,
                UDim2.new(0,18,0,18), UDim2.new(0,8,0.5,-9))
        end

        labelText(tabBtn, name,
            UDim2.new(1,-36,1,0),
            UDim2.new(0, (iconId and iconId ~= "") and 30 or 10, 0,0),
            13, FONT_SEMI, C.TextPrimary)

        -- Scroll frame for this tab's content
        local scroll = newInst("ScrollingFrame", {
            Parent               = contentArea,
            Size                 = UDim2.new(1,0,1,0),
            BackgroundTransparency = 1,
            BorderSizePixel      = 0,
            ScrollBarThickness   = 4,
            ScrollBarImageColor3 = C.Accent,
            CanvasSize           = UDim2.new(0,0,0,0),
            AutomaticCanvasSize  = Enum.AutomaticSize.Y,
            Visible              = false,
        })
        newInst("UIPadding", {
            Parent           = scroll,
            PaddingLeft      = UDim.new(0,4),
            PaddingRight     = UDim.new(0,4),
            PaddingTop       = UDim.new(0,4),
        })
        newInst("UIListLayout", {
            Parent    = scroll,
            Padding   = UDim.new(0,8),
            SortOrder = Enum.SortOrder.LayoutOrder,
        })

        local Tab = {}
        Tab._btn    = tabBtn
        Tab._scroll = scroll
        Tab._name   = name
        Tab._window = self

        function Tab:Activate()
            -- deactivate previous
            if Window._activeTab and Window._activeTab ~= self then
                local prev = Window._activeTab
                tween(prev._btn, { BackgroundTransparency = 0.7 }, 0.15)
                prev._btn.TextColor3 = C.TabInactive
                prev._scroll.Visible = false
            end
            Window._activeTab = self
            tween(tabBtn, { BackgroundTransparency = 0.25 }, 0.15)
            scroll.Visible = true
        end

        tabBtn.MouseButton1Click:Connect(function()
            Tab:Activate()
        end)
        tabBtn.MouseEnter:Connect(function()
            if Window._activeTab ~= Tab then
                tween(tabBtn, { BackgroundTransparency = 0.5 }, 0.1)
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if Window._activeTab ~= Tab then
                tween(tabBtn, { BackgroundTransparency = 0.7 }, 0.1)
            end
        end)

        table.insert(self._tabs, Tab)
        if #self._tabs == 1 then Tab:Activate() end

        -- ── CreateGroupbox ──
        function Tab:CreateGroupbox(boxTitle)
            local group = newInst("Frame", {
                Parent               = scroll,
                Size                 = UDim2.new(1,0,0,0),
                AutomaticSize        = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                BorderSizePixel      = 0,
            })

            -- Title label
            labelText(group, boxTitle,
                UDim2.new(1,0,0,18), UDim2.new(0,4,0,0),
                12, FONT_SEMI, C.Accent)

            -- Inner container (no glass box — open style)
            local inner = newInst("Frame", {
                Parent               = group,
                Size                 = UDim2.new(1,0,0,0),
                Position             = UDim2.new(0,0,0,20),
                AutomaticSize        = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                BorderSizePixel      = 0,
            })
            newInst("UIListLayout", {
                Parent    = inner,
                Padding   = UDim.new(0,6),
                SortOrder = Enum.SortOrder.LayoutOrder,
            })
            newInst("UIPadding", {
                Parent      = inner,
                PaddingLeft = UDim.new(0,2),
            })

            -- Separator line
            local sep = newInst("Frame", {
                Parent               = group,
                Size                 = UDim2.new(1,0,0,1),
                Position             = UDim2.new(0,0,0,18),
                BackgroundColor3     = C.Accent,
                BackgroundTransparency = 0.6,
                BorderSizePixel      = 0,
            })

            local Groupbox = {}
            Groupbox._inner  = inner
            Groupbox._window = Window

            local function registerElement(label, frame)
                table.insert(Window._allElements, {
                    label = label,
                    show  = function()
                        Tab:Activate()
                        frame.Visible = true
                    end,
                    hide = function()
                        frame.Visible = false
                    end,
                })
            end

            -- ── elementRow helper ──
            local function elementRow(titleStr)
                local row = newInst("Frame", {
                    Parent               = inner,
                    Size                 = UDim2.new(1,0,0,34),
                    BackgroundColor3     = C.ElementBG,
                    BackgroundTransparency = 0.88,
                    BorderSizePixel      = 0,
                })
                newInst("UICorner", { Parent = row, CornerRadius = UDim.new(0,7) })
                newInst("UIStroke", {
                    Parent       = row,
                    Color        = C.Border,
                    Transparency = 0.75,
                    Thickness    = 1,
                })
                labelText(row, titleStr,
                    UDim2.new(0.55,0,1,0), UDim2.new(0,10,0,0),
                    13, FONT_REG, C.TextPrimary)
                return row
            end

            -- ────────────────── Button ──────────────────
            function Groupbox:CreateButton(cfg)
                cfg = cfg or {}
                local row = elementRow(cfg.Title or "Button")
                local locked = cfg.Locked or false

                local btn = newInst("TextButton", {
                    Parent               = row,
                    Size                 = UDim2.new(0,70,0,22),
                    Position             = UDim2.new(1,-78,0.5,-11),
                    BackgroundColor3     = C.Accent,
                    BackgroundTransparency = locked and 0.6 or 0.15,
                    BorderSizePixel      = 0,
                    Text                 = locked and "Locked" or "Run",
                    TextColor3           = locked and C.TextSecondary or C.TextPrimary,
                    TextSize             = 12,
                    Font                 = FONT_SEMI,
                    AutoButtonColor      = false,
                })
                newInst("UICorner", { Parent = btn, CornerRadius = UDim.new(0,5) })

                if not locked then
                    btn.MouseButton1Click:Connect(function()
                        tween(btn, { BackgroundTransparency = 0.55 }, 0.08)
                        task.delay(0.12, function()
                            tween(btn, { BackgroundTransparency = 0.15 }, 0.12)
                        end)
                        if cfg.Callback then cfg.Callback() end
                    end)
                    btn.MouseEnter:Connect(function()
                        tween(btn, { BackgroundTransparency = 0 }, 0.1)
                    end)
                    btn.MouseLeave:Connect(function()
                        tween(btn, { BackgroundTransparency = 0.15 }, 0.1)
                    end)
                end
                registerElement(cfg.Title or "Button", row)
                return row
            end

            -- ────────────────── Toggle ──────────────────
            function Groupbox:CreateToggle(cfg)
                cfg = cfg or {}
                local row = elementRow(cfg.Title or "Toggle")
                if cfg.Desc and cfg.Desc ~= "" then
                    row.Size = UDim2.new(1,0,0,46)
                    labelText(row, cfg.Desc,
                        UDim2.new(0.7,0,0,14),
                        UDim2.new(0,10,0,20),
                        11, FONT_REG, C.TextSecondary)
                end
                local value = cfg.Value or false

                local track = newInst("Frame", {
                    Parent               = row,
                    Size                 = UDim2.new(0,40,0,20),
                    Position             = UDim2.new(1,-50,0.5,-10),
                    BackgroundColor3     = value and C.ToggleOn or C.ToggleOff,
                    BackgroundTransparency = 0.1,
                    BorderSizePixel      = 0,
                })
                newInst("UICorner", { Parent = track, CornerRadius = UDim.new(1,0) })

                local knob = newInst("Frame", {
                    Parent               = track,
                    Size                 = UDim2.new(0,16,0,16),
                    Position             = value
                        and UDim2.new(1,-18,0.5,-8)
                        or  UDim2.new(0,2,0.5,-8),
                    BackgroundColor3     = Color3.fromRGB(255,255,255),
                    BackgroundTransparency = 0,
                    BorderSizePixel      = 0,
                })
                newInst("UICorner", { Parent = knob, CornerRadius = UDim.new(1,0) })

                local Toggle = { _value = value }

                local trackBtn = newInst("TextButton", {
                    Parent               = track,
                    Size                 = UDim2.new(1,0,1,0),
                    BackgroundTransparency = 1,
                    Text                 = "",
                })

                local function updateToggle(v)
                    Toggle._value = v
                    tween(track, { BackgroundColor3 = v and C.ToggleOn or C.ToggleOff }, 0.15)
                    tween(knob,  { Position = v
                        and UDim2.new(1,-18,0.5,-8)
                        or  UDim2.new(0,2,0.5,-8) }, 0.15)
                    if cfg.Callback then cfg.Callback(v) end
                end

                trackBtn.MouseButton1Click:Connect(function()
                    updateToggle(not Toggle._value)
                end)

                function Toggle:Set(v) updateToggle(v) end
                registerElement(cfg.Title or "Toggle", row)
                return Toggle
            end

            -- ────────────────── Slider ──────────────────
            function Groupbox:CreateSlider(cfg)
                cfg = cfg or {}
                local row = newInst("Frame", {
                    Parent               = inner,
                    Size                 = UDim2.new(1,0,0,50),
                    BackgroundColor3     = C.ElementBG,
                    BackgroundTransparency = 0.88,
                    BorderSizePixel      = 0,
                })
                newInst("UICorner", { Parent = row, CornerRadius = UDim.new(0,7) })
                newInst("UIStroke", {
                    Parent = row, Color = C.Border,
                    Transparency = 0.75, Thickness = 1,
                })

                local V    = cfg.Value or {}
                local minV = V.Min     or 0
                local maxV = V.Max     or 100
                local step = cfg.Step  or 1
                local cur  = V.Default or minV

                local titleLbl = labelText(row, cfg.Title or "Slider",
                    UDim2.new(0.6,0,0,18), UDim2.new(0,10,0,4),
                    13, FONT_REG, C.TextPrimary)

                local valLbl = newInst("TextLabel", {
                    Parent               = row,
                    Size                 = UDim2.new(0.3,0,0,18),
                    Position             = UDim2.new(0.7,0,0,4),
                    BackgroundTransparency = 1,
                    TextColor3           = C.Accent,
                    TextSize             = 13,
                    Font                 = FONT_SEMI,
                    Text                 = tostring(cur),
                    TextXAlignment       = Enum.TextXAlignment.Right,
                })

                -- Track
                local track = newInst("Frame", {
                    Parent               = row,
                    Size                 = UDim2.new(1,-20,0,6),
                    Position             = UDim2.new(0,10,0,34),
                    BackgroundColor3     = Color3.fromRGB(200,210,230),
                    BackgroundTransparency = 0.4,
                    BorderSizePixel      = 0,
                })
                newInst("UICorner", { Parent = track, CornerRadius = UDim.new(1,0) })

                local fill = newInst("Frame", {
                    Parent               = track,
                    Size                 = UDim2.new((cur-minV)/(maxV-minV),0,1,0),
                    BackgroundColor3     = C.SliderFill,
                    BackgroundTransparency = 0,
                    BorderSizePixel      = 0,
                })
                newInst("UICorner", { Parent = fill, CornerRadius = UDim.new(1,0) })

                local knob = newInst("Frame", {
                    Parent               = track,
                    Size                 = UDim2.new(0,14,0,14),
                    Position             = UDim2.new((cur-minV)/(maxV-minV),0-7, 0.5,-7),
                    BackgroundColor3     = C.SliderFill,
                    BackgroundTransparency = 0,
                    BorderSizePixel      = 0,
                })
                newInst("UICorner", { Parent = knob, CornerRadius = UDim.new(1,0) })

                local Slider = { _value = cur }
                local dragging = false

                local function setSlider(absX)
                    local trackAbsPos  = track.AbsolutePosition
                    local trackAbsSize = track.AbsoluteSize
                    local pct = math.clamp((absX - trackAbsPos.X) / trackAbsSize.X, 0, 1)
                    local raw = minV + (maxV - minV) * pct
                    local snapped = math.round(raw / step) * step
                    snapped = math.clamp(snapped, minV, maxV)
                    Slider._value = snapped
                    local displayPct = (snapped - minV) / (maxV - minV)
                    fill.Size = UDim2.new(displayPct, 0, 1, 0)
                    knob.Position = UDim2.new(displayPct, -7, 0.5, -7)
                    valLbl.Text = tostring(snapped)
                    if cfg.Callback then cfg.Callback(snapped) end
                end

                track.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        setSlider(input.Position.X)
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        setSlider(input.Position.X)
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)

                function Slider:Set(v)
                    v = math.clamp(v, minV, maxV)
                    Slider._value = v
                    local pct = (v - minV) / (maxV - minV)
                    fill.Size = UDim2.new(pct,0,1,0)
                    knob.Position = UDim2.new(pct,-7,0.5,-7)
                    valLbl.Text = tostring(v)
                end

                registerElement(cfg.Title or "Slider", row)
                return Slider
            end

            -- ────────────────── Input ──────────────────
            function Groupbox:CreateInput(cfg)
                cfg = cfg or {}
                local row = newInst("Frame", {
                    Parent               = inner,
                    Size                 = UDim2.new(1,0,0,52),
                    BackgroundColor3     = C.ElementBG,
                    BackgroundTransparency = 0.88,
                    BorderSizePixel      = 0,
                })
                newInst("UICorner", { Parent = row, CornerRadius = UDim.new(0,7) })
                newInst("UIStroke", {
                    Parent = row, Color = C.Border,
                    Transparency = 0.75, Thickness = 1,
                })
                labelText(row, cfg.Title or "Input",
                    UDim2.new(1,0,0,18), UDim2.new(0,10,0,4),
                    13, FONT_REG, C.TextPrimary)

                local inputBox = newInst("TextBox", {
                    Parent               = row,
                    Size                 = UDim2.new(1,-20,0,22),
                    Position             = UDim2.new(0,10,0,24),
                    BackgroundColor3     = C.InputBG,
                    BackgroundTransparency = 0.3,
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
                newInst("UICorner", { Parent = inputBox, CornerRadius = UDim.new(0,5) })
                newInst("UIPadding", {
                    Parent     = inputBox,
                    PaddingLeft = UDim.new(0,6),
                })

                local Input = { _value = inputBox.Text }
                inputBox.FocusLost:Connect(function(enterPressed)
                    Input._value = inputBox.Text
                    if cfg.Callback then cfg.Callback(inputBox.Text) end
                end)

                function Input:Set(v)
                    inputBox.Text = v
                    Input._value  = v
                end

                registerElement(cfg.Title or "Input", row)
                return Input
            end

            -- ────────────────── Dropdown ──────────────────
            function Groupbox:CreateDropdown(cfg)
                cfg = cfg or {}
                local row = elementRow(cfg.Title or "Dropdown")

                local Dropdown = { _value = cfg.Value or (cfg.Values and cfg.Values[1]) or "" }

                local dropBtn = newInst("TextButton", {
                    Parent               = row,
                    Size                 = UDim2.new(0,110,0,22),
                    Position             = UDim2.new(1,-118,0.5,-11),
                    BackgroundColor3     = C.DropdownBG,
                    BackgroundTransparency = 0.3,
                    BorderSizePixel      = 0,
                    Text                 = "",
                    AutoButtonColor      = false,
                })
                newInst("UICorner", { Parent = dropBtn, CornerRadius = UDim.new(0,5) })
                newInst("UIStroke", {
                    Parent = dropBtn, Color = C.Accent,
                    Transparency = 0.5, Thickness = 1,
                })

                Dropdown._label = labelText(dropBtn, Dropdown._value,
                    UDim2.new(1,-24,1,0), UDim2.new(0,6,0,0),
                    12, FONT_REG, C.TextPrimary)

                -- chevron icon
                newInst("ImageLabel", {
                    Parent               = dropBtn,
                    Size                 = UDim2.new(0,12,0,12),
                    Position             = UDim2.new(1,-16,0.5,-6),
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
                        Dropdown
                    )
                end)
                dropBtn.MouseEnter:Connect(function()
                    tween(dropBtn, { BackgroundTransparency = 0.1 }, 0.1)
                end)
                dropBtn.MouseLeave:Connect(function()
                    tween(dropBtn, { BackgroundTransparency = 0.3 }, 0.1)
                end)

                function Dropdown:Refresh(newValues)
                    cfg.Values = newValues
                    if not table.find(newValues, self._value) then
                        self._value = newValues[1] or ""
                        self._label.Text = self._value
                    end
                end

                function Dropdown:Set(v)
                    if table.find(cfg.Values, v) then
                        self._value = v
                        self._label.Text = v
                    end
                end

                registerElement(cfg.Title or "Dropdown", row)
                return Dropdown
            end

            return Groupbox
        end -- CreateGroupbox

        return Tab
    end -- CreateTab

    -- ── CreateMinimizeBtn (floating, draggable) ──
    function Window:CreateMinimizeBtn(cfg)
        cfg = cfg or {}
        local btnTitle = cfg.Title or "Open UI"
        local btnImage = cfg.Image or ""

        local floatBtn = newInst("ImageButton", {
            Parent               = screenGui,
            Size                 = UDim2.new(0,48,0,48),
            Position             = UDim2.new(0,20,1,-70),
            BackgroundColor3     = C.Accent,
            BackgroundTransparency = 0.15,
            BorderSizePixel      = 0,
            Image                = btnImage,
            ScaleType            = Enum.ScaleType.Fit,
            ZIndex               = 10,
        })
        newInst("UICorner", { Parent = floatBtn, CornerRadius = UDim.new(0,12) })
        newInst("UIStroke", {
            Parent = floatBtn, Color = C.Border,
            Transparency = 0.4, Thickness = 1.5,
        })

        if btnImage == "" then
            -- fallback text/icon
            newInst("TextLabel", {
                Parent               = floatBtn,
                Size                 = UDim2.new(1,0,1,0),
                BackgroundTransparency = 1,
                Text                 = "☰",
                TextColor3           = C.TextPrimary,
                TextSize             = 22,
                Font                 = FONT,
            })
        end

        -- tooltip
        local tip = newInst("TextLabel", {
            Parent               = floatBtn,
            Size                 = UDim2.new(0,90,0,24),
            Position             = UDim2.new(1,6,0.5,-12),
            BackgroundColor3     = Color3.fromRGB(20,30,55),
            BackgroundTransparency = 0.2,
            BorderSizePixel      = 0,
            Text                 = btnTitle,
            TextColor3           = C.TextPrimary,
            TextSize             = 11,
            Font                 = FONT_SEMI,
            Visible              = false,
            ZIndex               = 11,
        })
        newInst("UICorner", { Parent = tip, CornerRadius = UDim.new(0,6) })

        floatBtn.MouseEnter:Connect(function() tip.Visible = true  end)
        floatBtn.MouseLeave:Connect(function() tip.Visible = false end)

        makeDraggable(floatBtn)

        local uiVisible = true
        floatBtn.MouseButton1Click:Connect(function()
            uiVisible = not uiVisible
            tween(win, { BackgroundTransparency = uiVisible and C.GlassAlpha or 1 }, 0.25)
            for _, child in ipairs(win:GetDescendants()) do
                if child:IsA("GuiObject") and child ~= win then
                    tween(child, { BackgroundTransparency = uiVisible
                        and (child.BackgroundTransparency < 0.9 and child.BackgroundTransparency or child.BackgroundTransparency)
                        or 1 }, 0.2)
                end
            end
            win.Visible = uiVisible
            shadow.Visible = uiVisible
        end)

        return floatBtn
    end

    return Window
end

return SKUI
