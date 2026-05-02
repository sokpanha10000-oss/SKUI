--[[
    ╔═══════════════════════════════════════════════════════╗
    ║                  SKUI  –  v1.0.0                      ║
    ║       Roblox UI Library  •  by .ftgs                  ║
    ╚═══════════════════════════════════════════════════════╝
    
    USAGE:
        local SKUI = loadstring(game:HttpGet("YOUR_RAW_URL"))()
        local Window = SKUI:CreateWindow({ ... })
        local Tab    = Window:Tab({ ... })
        Tab:Button({ ... })  /  Tab:Toggle({ ... })  /  etc.
--]]

-- ─────────────────────────────────────────────────────────
--  SERVICES
-- ─────────────────────────────────────────────────────────
local cloneref = (cloneref or clonereference or function(i) return i end)

local Players        = cloneref(game:GetService("Players"))
local TweenService   = cloneref(game:GetService("TweenService"))
local UIS            = cloneref(game:GetService("UserInputService"))
local RunService     = cloneref(game:GetService("RunService"))
local HttpService    = cloneref(game:GetService("HttpService"))
local CoreGui        = cloneref(game:GetService("CoreGui"))

local LocalPlayer    = Players.LocalPlayer
local Mouse          = LocalPlayer:GetMouse()

-- ─────────────────────────────────────────────────────────
--  ICON MODULE  (from uploaded Icons.lua)
-- ─────────────────────────────────────────────────────────
local function HttpGet(url)
    if game.HttpGet then
        return game:HttpGet(url)
    else
        return HttpService:GetAsync(url)
    end
end

local IconModule = (function()
    local M = {
        IconsType  = "lucide",
        New        = nil,
        IconThemeTag = nil,
        Icons      = {},
    }

    -- Lazy-load icon packs only when first used
    local _packs = {
        lucide   = "https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/lucide/dist/Icons.lua",
        solar    = "https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/solar/dist/Icons.lua",
        craft    = "https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/craft/dist/Icons.lua",
        geist    = "https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/geist/dist/Icons.lua",
        sfsymbols = "https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/sfsymbols/dist/Icons.lua",
        gravity  = "https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/gravity/dist/Icons.lua",
    }

    local function ensurePack(name)
        if not M.Icons[name] and _packs[name] then
            local ok, result = pcall(function()
                return loadstring(HttpGet(_packs[name]))()
            end)
            if ok then M.Icons[name] = result end
        end
    end

    local function parseIconString(s)
        if type(s) == "string" then
            local idx = s:find(":")
            if idx then
                return s:sub(1, idx-1), s:sub(idx+1)
            end
        end
        return nil, s
    end

    function M.Icon(icon, iconType, defaultFmt)
        defaultFmt = defaultFmt ~= false
        local iType, iName = parseIconString(icon)
        local targetType = iType or iconType or M.IconsType
        ensurePack(targetType)
        local iconSet = M.Icons[targetType]
        if not iconSet then return nil end
        -- Spritesheet-based pack
        if iconSet.Icons and iconSet.Icons[iName] then
            local entry = iconSet.Icons[iName]
            return { iconSet.Spritesheets[tostring(entry.Image)], entry }
        end
        -- Plain assetid pack
        if iconSet[iName] and type(iconSet[iName]) == "string" and iconSet[iName]:find("rbxassetid://") then
            if defaultFmt then
                return { iconSet[iName], { ImageRectSize = Vector2.new(0,0), ImageRectPosition = Vector2.new(0,0) } }
            end
            return iconSet[iName]
        end
        return nil
    end

    function M.GetIcon(icon, iconType)
        return M.Icon(icon, iconType, false)
    end

    -- Apply icon data to an existing ImageLabel
    function M.Apply(imageLabel, icon, iconType)
        local data = M.Icon(icon, iconType, true)
        if not data then return end
        if type(data) == "string" then
            imageLabel.Image = data
            imageLabel.ImageRectSize     = Vector2.new(0,0)
            imageLabel.ImageRectOffset   = Vector2.new(0,0)
        else
            imageLabel.Image             = data[1]
            imageLabel.ImageRectSize     = data[2].ImageRectSize
            imageLabel.ImageRectOffset   = data[2].ImageRectPosition
        end
    end

    return M
end)()

-- ─────────────────────────────────────────────────────────
--  UTILITY HELPERS
-- ─────────────────────────────────────────────────────────
local function Tween(obj, props, t, style, dir)
    TweenService:Create(
        obj,
        TweenInfo.new(t or 0.25, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out),
        props
    ):Play()
end

local function New(class, props, children)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then obj[k] = v end
    end
    for _, c in ipairs(children or {}) do c.Parent = obj end
    if props and props.Parent then obj.Parent = props.Parent end
    return obj
end

local function Corner(r, parent)
    return New("UICorner", { CornerRadius = UDim.new(0, r), Parent = parent })
end

local function Stroke(color, thickness, transparency, parent)
    return New("UIStroke", {
        Color = color, Thickness = thickness or 1.5,
        Transparency = transparency or 0, Parent = parent
    })
end

-- Create an ImageLabel pre-loaded with a Lucide icon
local function IconImage(name, size, parent, color)
    local img = New("ImageLabel", {
        Size          = size or UDim2.new(0, 18, 0, 18),
        BackgroundTransparency = 1,
        ImageColor3   = color or Color3.new(1,1,1),
        Parent        = parent,
    })
    -- Apply icon asynchronously so it doesn't block UI build
    task.spawn(function()
        if name then IconModule.Apply(img, name) end
    end)
    return img
end

-- Draggable helper
local function MakeDraggable(frame, handle)
    handle = handle or frame
    local drag, start, origin = false, nil, nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag   = true
            start  = i.Position
            origin = frame.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - start
            frame.Position = UDim2.new(
                origin.X.Scale, origin.X.Offset + d.X,
                origin.Y.Scale, origin.Y.Offset + d.Y
            )
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
    end)
end

-- ─────────────────────────────────────────────────────────
--  THEMES
-- ─────────────────────────────────────────────────────────
local Themes = {
    Dark = {
        -- Background layers
        Window      = Color3.fromRGB(16,  16,  22),   -- main window (glass)
        LeftBG      = Color3.fromRGB(12,  12,  17),   -- left tab strip
        RightBG     = Color3.fromRGB(20,  20,  28),   -- right element area
        HeaderBG    = Color3.fromRGB(12,  12,  17),   -- top header
        DropBG      = Color3.fromRGB(17,  17,  24),   -- dropdown popup
        ElementBG   = Color3.fromRGB(26,  26,  36),   -- element cards
        SearchBG    = Color3.fromRGB(22,  22,  32),   -- input / search bg
        OverlayBG   = Color3.fromRGB(0,    0,   0),   -- modal overlay

        -- Accents
        Accent      = Color3.fromRGB(99, 102, 241),
        AccentHover = Color3.fromRGB(129,132, 255),
        AccentDim   = Color3.fromRGB(60,  63, 160),

        -- Text
        Text        = Color3.fromRGB(236, 236, 255),
        TextDim     = Color3.fromRGB(130, 130, 165),
        TextSection = Color3.fromRGB(99,  102, 241),

        -- Borders
        Border      = Color3.fromRGB(44,  44,  64),

        -- Controls
        ToggleOff   = Color3.fromRGB(48,  48,  68),
        ToggleOn    = Color3.fromRGB(99,  102, 241),
        SliderFill  = Color3.fromRGB(99,  102, 241),
        CloseRed    = Color3.fromRGB(240,  70,  70),
        FloatBG     = Color3.fromRGB(99,  102, 241),

        -- Tab states
        TabActiveAlpha = 0.82,   -- bg transparency when active
        TabHoverAlpha  = 0.92,
        TabIdleAlpha   = 1.0,

        -- Window transparency  (0.15 ≈ 85% opaque = "1.5 opacity feel")
        WindowAlpha    = 0.15,
        LeftBGAlpha    = 0.10,
        RightBGAlpha   = 0.12,
        HeaderAlpha    = 0.08,
        ElementAlpha   = 0.20,
    },
}

-- ─────────────────────────────────────────────────────────
--  LIBRARY  ENTRY POINT
-- ─────────────────────────────────────────────────────────
local SKUI = {}
SKUI.__index = SKUI

-- ─────────────────────────────────────────────────────────
--  CreateWindow
-- ─────────────────────────────────────────────────────────
function SKUI:CreateWindow(cfg)
    cfg = cfg or {}

    local title      = cfg.Title     or "SKUI"
    local icon       = cfg.Icon
    local author     = cfg.Author    or ""
    local winSize    = cfg.Size      or UDim2.fromOffset(560, 350)
    local T          = Themes[cfg.Theme or "Dark"]
    local hasSearch  = cfg.SearchBar ~= false
    local userCfg    = cfg.User       or {}
    local keyCfg     = cfg.KeySystem

    -- ── ScreenGui ──────────────────────────────────────────
    local SG = New("ScreenGui", {
        Name            = "SKUI_" .. title,
        ResetOnSpawn    = false,
        ZIndexBehavior  = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset  = true,
    })
    local ok = pcall(function() SG.Parent = CoreGui end)
    if not ok then SG.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    -- ── Drop-shadow ────────────────────────────────────────
    local Shadow = New("ImageLabel", {
        Name                 = "Shadow",
        AnchorPoint          = Vector2.new(0.5, 0.5),
        Position             = UDim2.fromScale(0.5, 0.5),
        Size                 = UDim2.new(1, 60, 1, 60),
        BackgroundTransparency = 1,
        Image                = "rbxassetid://6015897843",
        ImageColor3          = Color3.new(0,0,0),
        ImageTransparency    = 0.55,
        ScaleType            = Enum.ScaleType.Slice,
        SliceCenter          = Rect.new(49, 49, 450, 450),
        ZIndex               = 0,
        Parent               = SG,
    })

    -- ── Main Window ────────────────────────────────────────
    local Win = New("Frame", {
        Name                 = "Window",
        AnchorPoint          = Vector2.new(0.5, 0.5),
        Position             = UDim2.fromScale(0.5, 0.5),
        Size                 = UDim2.fromOffset(winSize.X.Offset, 0),  -- starts collapsed for intro
        BackgroundColor3     = T.Window,
        BackgroundTransparency = T.WindowAlpha,
        BorderSizePixel      = 0,
        ClipsDescendants     = true,
        Parent               = SG,
    })
    Corner(12, Win)
    Stroke(T.Border, 1.5, 0.35, Win)

    Shadow.Parent = Win  -- re-parent so shadow moves with window

    -- ── HEADER ────────────────────────────────────────────
    local Header = New("Frame", {
        Name                 = "Header",
        Size                 = UDim2.new(1, 0, 0, 46),
        BackgroundColor3     = T.HeaderBG,
        BackgroundTransparency = T.HeaderAlpha,
        BorderSizePixel      = 0,
        ZIndex               = 3,
        Parent               = Win,
    })
    Corner(12, Header)
    -- fill bottom-corners of header (square edge flush with body)
    New("Frame", {
        Size                 = UDim2.new(1, 0, 0, 12),
        Position             = UDim2.new(0, 0, 1, -12),
        BackgroundColor3     = T.HeaderBG,
        BackgroundTransparency = T.HeaderAlpha,
        BorderSizePixel      = 0,
        Parent               = Header,
    })

    -- Header left: icon + title + author
    local hIcon = New("Frame", {
        Size                 = UDim2.new(0, 46, 1, 0),
        BackgroundTransparency = 1,
        Parent               = Header,
    })
    if icon then
        local iconImg = New("ImageLabel", {
            Size                 = UDim2.new(0, 20, 0, 20),
            Position             = UDim2.new(0, 13, 0.5, -10),
            BackgroundTransparency = 1,
            ImageColor3          = T.Accent,
            Parent               = hIcon,
        })
        task.spawn(function() IconModule.Apply(iconImg, icon) end)
    end

    local TitleLbl = New("TextLabel", {
        Size                 = UDim2.new(0, 200, 0, 18),
        Position             = UDim2.new(0, icon and 46 or 12, author ~= "" and 0 or 0.5, author ~= "" and 5 or -9),
        BackgroundTransparency = 1,
        Text                 = title,
        TextColor3           = T.Text,
        TextSize             = 14,
        Font                 = Enum.Font.GothamBold,
        TextXAlignment       = Enum.TextXAlignment.Left,
        Parent               = Header,
    })
    if author ~= "" then
        New("TextLabel", {
            Size                 = UDim2.new(0, 220, 0, 13),
            Position             = UDim2.new(0, icon and 46 or 12, 0, 25),
            BackgroundTransparency = 1,
            Text                 = author,
            TextColor3           = T.TextDim,
            TextSize             = 10,
            Font                 = Enum.Font.Gotham,
            TextXAlignment       = Enum.TextXAlignment.Left,
            Parent               = Header,
        })
    end

    -- ── SEARCH BAR (header right) ──────────────────────────
    local SearchBox
    if hasSearch then
        local SF = New("Frame", {
            Size                 = UDim2.new(0, 155, 0, 26),
            Position             = UDim2.new(1, -200, 0.5, -13),
            BackgroundColor3     = T.SearchBG,
            BackgroundTransparency = 0.05,
            BorderSizePixel      = 0,
            Parent               = Header,
        })
        Corner(7, SF)
        Stroke(T.Border, 1, 0.3, SF)

        local sIconImg = New("ImageLabel", {
            Size                 = UDim2.new(0, 14, 0, 14),
            Position             = UDim2.new(0, 7, 0.5, -7),
            BackgroundTransparency = 1,
            ImageColor3          = T.TextDim,
            Parent               = SF,
        })
        task.spawn(function() IconModule.Apply(sIconImg, "search") end)

        SearchBox = New("TextBox", {
            Name                 = "SearchBox",
            Size                 = UDim2.new(1, -28, 1, 0),
            Position             = UDim2.new(0, 26, 0, 0),
            BackgroundTransparency = 1,
            Text                 = "",
            PlaceholderText      = "Search elements...",
            PlaceholderColor3    = T.TextDim,
            TextColor3           = T.Text,
            TextSize             = 11,
            Font                 = Enum.Font.Gotham,
            ClearTextOnFocus     = false,
            TextXAlignment       = Enum.TextXAlignment.Left,
            Parent               = SF,
        })
    end

    -- ── CLOSE BUTTON ──────────────────────────────────────
    local CloseBtn = New("TextButton", {
        Size                 = UDim2.new(0, 26, 0, 26),
        Position             = UDim2.new(1, -34, 0.5, -13),
        BackgroundColor3     = T.CloseRed,
        BackgroundTransparency = 0.25,
        BorderSizePixel      = 0,
        Text                 = "✕",
        TextColor3           = Color3.new(1,1,1),
        TextSize             = 12,
        Font                 = Enum.Font.GothamBold,
        ZIndex               = 4,
        Parent               = Header,
    })
    Corner(6, CloseBtn)

    CloseBtn.MouseEnter:Connect(function()  Tween(CloseBtn, { BackgroundTransparency = 0 }, 0.15) end)
    CloseBtn.MouseLeave:Connect(function()  Tween(CloseBtn, { BackgroundTransparency = 0.25 }, 0.15) end)

    -- ── BODY (left + right panels) ────────────────────────
    local Body = New("Frame", {
        Name                 = "Body",
        Size                 = UDim2.new(1, 0, 1, -46),
        Position             = UDim2.new(0, 0, 0, 46),
        BackgroundTransparency = 1,
        BorderSizePixel      = 0,
        Parent               = Win,
    })

    -- ── LEFT PANEL ────────────────────────────────────────
    local LeftPanel = New("ScrollingFrame", {
        Name                 = "LeftPanel",
        Size                 = UDim2.new(0, 138, 1, -6),
        Position             = UDim2.new(0, 3, 0, 3),
        BackgroundColor3     = T.LeftBG,
        BackgroundTransparency = T.LeftBGAlpha,
        BorderSizePixel      = 0,
        ScrollBarThickness   = 2,
        ScrollBarImageColor3 = T.Accent,
        ScrollBarImageTransparency = 0.4,
        CanvasSize           = UDim2.fromScale(0, 0),
        AutomaticCanvasSize  = Enum.AutomaticSize.Y,
        ClipsDescendants     = true,
        Parent               = Body,
    })
    Corner(9, LeftPanel)
    -- mask right side corners (flush against right edge)
    New("Frame", {
        Size                 = UDim2.new(0, 10, 1, 0),
        Position             = UDim2.new(1, -10, 0, 0),
        BackgroundColor3     = T.LeftBG,
        BackgroundTransparency = T.LeftBGAlpha,
        BorderSizePixel      = 0,
        Parent               = LeftPanel,
    })

    local TabListLayout = New("UIListLayout", {
        Padding              = UDim.new(0, 3),
        SortOrder            = Enum.SortOrder.LayoutOrder,
        Parent               = LeftPanel,
    })
    New("UIPadding", {
        PaddingTop           = UDim.new(0, 8),
        PaddingLeft          = UDim.new(0, 7),
        PaddingRight         = UDim.new(0, 7),
        Parent               = LeftPanel,
    })

    -- ── USER PROFILE  (left panel top) ───────────────────
    if userCfg.Enabled then
        local ProF = New("Frame", {
            Name                 = "Profile",
            Size                 = UDim2.new(1, 0, 0, 56),
            BackgroundColor3     = T.ElementBG,
            BackgroundTransparency = T.ElementAlpha,
            BorderSizePixel      = 0,
            LayoutOrder          = 0,
            Parent               = LeftPanel,
        })
        Corner(9, ProF)
        Stroke(T.Border, 1, 0.5, ProF)

        if userCfg.Profile then
            local avatar = New("ImageLabel", {
                Size                 = UDim2.new(0, 34, 0, 34),
                Position             = UDim2.new(0, 7, 0.5, -17),
                BackgroundColor3     = T.AccentDim,
                BackgroundTransparency = 0.4,
                Image                = "https://www.roblox.com/headshot-thumbnail/image?userId=" ..
                                       LocalPlayer.UserId .. "&width=150&height=150&format=png",
                Parent               = ProF,
            })
            Corner(17, avatar)

            New("TextLabel", {
                Size                 = UDim2.new(1, -48, 0, 15),
                Position             = UDim2.new(0, 46, 0, 11),
                BackgroundTransparency = 1,
                Text                 = LocalPlayer.DisplayName,
                TextColor3           = T.Text,
                TextSize             = 11,
                Font                 = Enum.Font.GothamBold,
                TextXAlignment       = Enum.TextXAlignment.Left,
                TextTruncate         = Enum.TextTruncate.AtEnd,
                Parent               = ProF,
            })
            New("TextLabel", {
                Size                 = UDim2.new(1, -48, 0, 13),
                Position             = UDim2.new(0, 46, 0, 28),
                BackgroundTransparency = 1,
                Text                 = "@" .. LocalPlayer.Name,
                TextColor3           = T.TextDim,
                TextSize             = 9,
                Font                 = Enum.Font.Gotham,
                TextXAlignment       = Enum.TextXAlignment.Left,
                TextTruncate         = Enum.TextTruncate.AtEnd,
                Parent               = ProF,
            })
        else
            New("TextLabel", {
                Size                 = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text                 = LocalPlayer.DisplayName,
                TextColor3           = T.Text,
                TextSize             = 11,
                Font                 = Enum.Font.GothamBold,
                Parent               = ProF,
            })
        end

        -- Divider below profile
        New("Frame", {
            Size                 = UDim2.new(1, 0, 0, 1),
            BackgroundColor3     = T.Border,
            BackgroundTransparency = 0.5,
            BorderSizePixel      = 0,
            LayoutOrder          = 1,
            Parent               = LeftPanel,
        })
    end

    -- ── RIGHT PANEL ───────────────────────────────────────
    -- Single container; each tab gets its own child ScrollingFrame
    local RightContainer = New("Frame", {
        Name                 = "RightContainer",
        Size                 = UDim2.new(1, -146, 1, -6),
        Position             = UDim2.new(0, 143, 0, 3),
        BackgroundColor3     = T.RightBG,
        BackgroundTransparency = T.RightBGAlpha,
        BorderSizePixel      = 0,
        ClipsDescendants     = true,
        Parent               = Body,
    })
    Corner(9, RightContainer)

    -- ── DROPDOWN POPUP (lives in Win, shown above everything) ──
    local DDOverlay = New("TextButton", {
        Name                 = "DDOverlay",
        Size                 = UDim2.fromScale(1, 1),
        BackgroundColor3     = T.OverlayBG,
        BackgroundTransparency = 0.48,
        BorderSizePixel      = 0,
        Text                 = "",
        Visible              = false,
        ZIndex               = 60,
        Parent               = Win,
    })

    local DDPopup = New("Frame", {
        Name                 = "DDPopup",
        Size                 = UDim2.fromOffset(270, 0),  -- height animates in
        Position             = UDim2.fromScale(0.5, 0.5),
        AnchorPoint          = Vector2.new(0.5, 0.5),
        BackgroundColor3     = T.DropBG,
        BackgroundTransparency = 0,
        BorderSizePixel      = 0,
        ClipsDescendants     = true,
        ZIndex               = 61,
        Parent               = DDOverlay,
    })
    Corner(12, DDPopup)
    Stroke(T.Border, 1.5, 0.2, DDPopup)

    -- Popup header
    local DDHead = New("Frame", {
        Size                 = UDim2.new(1, 0, 0, 38),
        BackgroundColor3     = T.HeaderBG,
        BackgroundTransparency = 0.05,
        BorderSizePixel      = 0,
        ZIndex               = 62,
        Parent               = DDPopup,
    })
    Corner(12, DDHead)
    New("Frame", { -- flatten bottom corners
        Size                 = UDim2.new(1, 0, 0, 12),
        Position             = UDim2.new(0, 0, 1, -12),
        BackgroundColor3     = T.HeaderBG,
        BackgroundTransparency = 0.05,
        BorderSizePixel      = 0,
        Parent               = DDHead,
    })

    local DDTitleLbl = New("TextLabel", {
        Size                 = UDim2.new(1, -44, 1, 0),
        Position             = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text                 = "Select Option",
        TextColor3           = T.Text,
        TextSize             = 13,
        Font                 = Enum.Font.GothamBold,
        TextXAlignment       = Enum.TextXAlignment.Left,
        ZIndex               = 63,
        Parent               = DDHead,
    })

    local DDCloseBtn = New("TextButton", {
        Size                 = UDim2.new(0, 24, 0, 24),
        Position             = UDim2.new(1, -30, 0.5, -12),
        BackgroundColor3     = T.CloseRed,
        BackgroundTransparency = 0.25,
        BorderSizePixel      = 0,
        Text                 = "✕",
        TextColor3           = Color3.new(1,1,1),
        TextSize             = 11,
        Font                 = Enum.Font.GothamBold,
        ZIndex               = 63,
        Parent               = DDHead,
    })
    Corner(5, DDCloseBtn)

    -- Popup search
    local DDSFrame = New("Frame", {
        Size                 = UDim2.new(1, -16, 0, 26),
        Position             = UDim2.new(0, 8, 0, 44),
        BackgroundColor3     = T.SearchBG,
        BackgroundTransparency = 0.05,
        BorderSizePixel      = 0,
        ZIndex               = 62,
        Parent               = DDPopup,
    })
    Corner(7, DDSFrame)
    Stroke(T.Border, 1, 0.3, DDSFrame)

    local ddSIcon = New("ImageLabel", {
        Size                 = UDim2.new(0, 13, 0, 13),
        Position             = UDim2.new(0, 7, 0.5, -6.5),
        BackgroundTransparency = 1,
        ImageColor3          = T.TextDim,
        ZIndex               = 63,
        Parent               = DDSFrame,
    })
    task.spawn(function() IconModule.Apply(ddSIcon, "search") end)

    local DDSearchBox = New("TextBox", {
        Size                 = UDim2.new(1, -28, 1, 0),
        Position             = UDim2.new(0, 24, 0, 0),
        BackgroundTransparency = 1,
        Text                 = "",
        PlaceholderText      = "Search...",
        PlaceholderColor3    = T.TextDim,
        TextColor3           = T.Text,
        TextSize             = 11,
        Font                 = Enum.Font.Gotham,
        ClearTextOnFocus     = false,
        TextXAlignment       = Enum.TextXAlignment.Left,
        ZIndex               = 63,
        Parent               = DDSFrame,
    })

    -- Popup scroll list
    local DDScroll = New("ScrollingFrame", {
        Size                 = UDim2.new(1, -16, 1, -78),
        Position             = UDim2.new(0, 8, 0, 74),
        BackgroundTransparency = 1,
        BorderSizePixel      = 0,
        ScrollBarThickness   = 3,
        ScrollBarImageColor3 = T.Accent,
        CanvasSize           = UDim2.fromScale(0, 0),
        AutomaticCanvasSize  = Enum.AutomaticSize.Y,
        ZIndex               = 62,
        Parent               = DDPopup,
    })
    New("UIListLayout", {
        Padding              = UDim.new(0, 3),
        SortOrder            = Enum.SortOrder.LayoutOrder,
        Parent               = DDScroll,
    })

    -- ── Dropdown open / close logic ────────────────────────
    local function CloseDD()
        Tween(DDPopup, { Size = UDim2.fromOffset(270, 0) }, 0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        task.wait(0.18)
        DDOverlay.Visible = false
    end

    DDCloseBtn.MouseButton1Click:Connect(CloseDD)
    DDOverlay.MouseButton1Click:Connect(CloseDD)
    DDPopup.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            i:GetPropertyChangedSignal("UserInputState"):Connect(function()
                -- consume clicks on popup without closing overlay
            end)
        end
    end)

    local _ddValues, _ddCallback, _ddCurrent = {}, nil, ""

    local function PopulateDDList(filter)
        for _, c in pairs(DDScroll:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        filter = (filter or ""):lower()
        for _, v in ipairs(_ddValues) do
            if filter == "" or v:lower():find(filter, 1, true) then
                local isSelected = (v == _ddCurrent)
                local item = New("TextButton", {
                    Size                 = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3     = isSelected and T.Accent or T.ElementBG,
                    BackgroundTransparency = isSelected and 0.3 or 0.4,
                    BorderSizePixel      = 0,
                    Text                 = "",
                    ZIndex               = 63,
                    Parent               = DDScroll,
                })
                Corner(7, item)

                New("TextLabel", {
                    Size                 = UDim2.new(1, -32, 1, 0),
                    Position             = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Text                 = v,
                    TextColor3           = isSelected and T.Text or T.TextDim,
                    TextSize             = 12,
                    Font                 = isSelected and Enum.Font.GothamBold or Enum.Font.Gotham,
                    TextXAlignment       = Enum.TextXAlignment.Left,
                    ZIndex               = 64,
                    Parent               = item,
                })

                if isSelected then
                    local chk = New("ImageLabel", {
                        Size                 = UDim2.new(0, 14, 0, 14),
                        Position             = UDim2.new(1, -22, 0.5, -7),
                        BackgroundTransparency = 1,
                        ImageColor3          = T.Accent,
                        ZIndex               = 64,
                        Parent               = item,
                    })
                    task.spawn(function() IconModule.Apply(chk, "check") end)
                end

                item.MouseEnter:Connect(function()
                    if not isSelected then Tween(item, { BackgroundTransparency = 0.2 }, 0.1) end
                end)
                item.MouseLeave:Connect(function()
                    if not isSelected then Tween(item, { BackgroundTransparency = 0.4 }, 0.1) end
                end)
                item.MouseButton1Click:Connect(function()
                    _ddCurrent = v
                    if _ddCallback then _ddCallback(v) end
                    CloseDD()
                end)
            end
        end
    end

    local function OpenDD(title, values, current, callback)
        _ddValues   = values
        _ddCurrent  = current
        _ddCallback = callback
        DDTitleLbl.Text = title
        DDSearchBox.Text = ""
        PopulateDDList("")
        DDPopup.Size = UDim2.fromOffset(270, 0)
        DDOverlay.Visible = true
        Tween(DDPopup, { Size = UDim2.fromOffset(270, 230) }, 0.22)
    end

    DDSearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        PopulateDDList(DDSearchBox.Text)
    end)

    -- ── FLOATING TOGGLE BUTTON ────────────────────────────
    local FloatBtn = New("ImageButton", {
        Name                 = "FloatBtn",
        Size                 = UDim2.fromOffset(42, 42),
        Position             = UDim2.new(0, 18, 0.5, -21),
        BackgroundColor3     = T.FloatBG,
        BackgroundTransparency = 0,
        BorderSizePixel      = 0,
        ZIndex               = 20,
        Image                = "",
        Parent               = SG,
    })
    Corner(10, FloatBtn)
    Stroke(T.AccentHover, 1.5, 0.3, FloatBtn)

    local floatIcon = New("ImageLabel", {
        Size                 = UDim2.new(0, 20, 0, 20),
        Position             = UDim2.new(0.5, -10, 0.5, -10),
        BackgroundTransparency = 1,
        ImageColor3          = Color3.new(1,1,1),
        Parent               = FloatBtn,
    })
    task.spawn(function() IconModule.Apply(floatIcon, "menu") end)

    MakeDraggable(FloatBtn)

    local uiVisible = true
    local function SetUI(visible)
        uiVisible = visible
        if visible then
            Win.Visible = true
            Tween(Win, { Size = winSize }, 0.28)
            task.spawn(function()
                IconModule.Apply(floatIcon, "x")
            end)
        else
            Tween(Win, { Size = UDim2.fromOffset(winSize.X.Offset, 0) }, 0.2)
            task.delay(0.22, function()
                Win.Visible = false
            end)
            task.spawn(function()
                IconModule.Apply(floatIcon, "menu")
            end)
        end
    end

    FloatBtn.MouseEnter:Connect(function()
        Tween(FloatBtn, { BackgroundColor3 = T.AccentHover, Size = UDim2.fromOffset(46, 46) }, 0.12)
    end)
    FloatBtn.MouseLeave:Connect(function()
        Tween(FloatBtn, { BackgroundColor3 = T.FloatBG, Size = UDim2.fromOffset(42, 42) }, 0.12)
    end)
    FloatBtn.MouseButton1Click:Connect(function() SetUI(not uiVisible) end)

    -- Close button hides (same as float button close)
    CloseBtn.MouseButton1Click:Connect(function() SetUI(false) end)

    -- Make header draggable
    MakeDraggable(Win, Header)

    -- ── KEY SYSTEM ────────────────────────────────────────
    if keyCfg then
        Win.Visible = false
        local KG = New("Frame", {
            Name                 = "KeyGate",
            Size                 = UDim2.fromScale(1, 1),
            BackgroundColor3     = Color3.new(0,0,0),
            BackgroundTransparency = 0.45,
            BorderSizePixel      = 0,
            ZIndex               = 100,
            Parent               = SG,
        })
        local KF = New("Frame", {
            AnchorPoint          = Vector2.new(0.5, 0.5),
            Position             = UDim2.fromScale(0.5, 0.5),
            Size                 = UDim2.fromOffset(310, 230),
            BackgroundColor3     = T.Window,
            BackgroundTransparency = T.WindowAlpha,
            BorderSizePixel      = 0,
            ZIndex               = 101,
            Parent               = KG,
        })
        Corner(14, KF)
        Stroke(T.Accent, 1.5, 0.2, KF)

        -- Key icon
        local keyIco = New("ImageLabel", {
            Size                 = UDim2.new(0, 28, 0, 28),
            Position             = UDim2.new(0.5, -14, 0, 16),
            BackgroundTransparency = 1,
            ImageColor3          = T.Accent,
            ZIndex               = 102,
            Parent               = KF,
        })
        task.spawn(function() IconModule.Apply(keyIco, "key-round") end)

        New("TextLabel", {
            Size                 = UDim2.new(1, -24, 0, 16),
            Position             = UDim2.new(0, 12, 0, 52),
            BackgroundTransparency = 1,
            Text                 = keyCfg.Note or "Enter your key to continue.",
            TextColor3           = T.TextDim,
            TextSize             = 11,
            Font                 = Enum.Font.Gotham,
            ZIndex               = 102,
            Parent               = KF,
        })

        if keyCfg.Thumbnail and keyCfg.Thumbnail.Image and keyCfg.Thumbnail.Image ~= "" then
            local thumb = New("ImageLabel", {
                Size                 = UDim2.new(0, 50, 0, 50),
                Position             = UDim2.new(0, 12, 0, 12),
                BackgroundTransparency = 1,
                Image                = keyCfg.Thumbnail.Image,
                ZIndex               = 102,
                Parent               = KF,
            })
            Corner(8, thumb)
        end

        local KInput = New("TextBox", {
            Size                 = UDim2.new(1, -24, 0, 34),
            Position             = UDim2.new(0, 12, 0, 76),
            BackgroundColor3     = T.SearchBG,
            BackgroundTransparency = 0.05,
            BorderSizePixel      = 0,
            Text                 = "",
            PlaceholderText      = "Enter key here...",
            PlaceholderColor3    = T.TextDim,
            TextColor3           = T.Text,
            TextSize             = 13,
            Font                 = Enum.Font.Gotham,
            ClearTextOnFocus     = false,
            ZIndex               = 102,
            Parent               = KF,
        })
        Corner(8, KInput)
        Stroke(T.Border, 1, 0.3, KInput)
        New("UIPadding", { PaddingLeft = UDim.new(0, 10), Parent = KInput })

        local KStatus = New("TextLabel", {
            Size                 = UDim2.new(1, -24, 0, 14),
            Position             = UDim2.new(0, 12, 0, 114),
            BackgroundTransparency = 1,
            Text                 = "",
            TextColor3           = Color3.fromRGB(255, 80, 80),
            TextSize             = 10,
            Font                 = Enum.Font.Gotham,
            ZIndex               = 102,
            Parent               = KF,
        })

        local KSubmit = New("TextButton", {
            Size                 = UDim2.new(1, -24, 0, 34),
            Position             = UDim2.new(0, 12, 0, 132),
            BackgroundColor3     = T.Accent,
            BackgroundTransparency = 0,
            BorderSizePixel      = 0,
            Text                 = "Confirm Key",
            TextColor3           = Color3.new(1,1,1),
            TextSize             = 13,
            Font                 = Enum.Font.GothamBold,
            ZIndex               = 102,
            Parent               = KF,
        })
        Corner(8, KSubmit)

        if keyCfg.URL then
            local gk = New("TextButton", {
                Size                 = UDim2.new(1, -24, 0, 22),
                Position             = UDim2.new(0, 12, 0, 172),
                BackgroundTransparency = 1,
                BorderSizePixel      = 0,
                Text                 = "Get a key  →",
                TextColor3           = T.Accent,
                TextSize             = 11,
                Font                 = Enum.Font.GothamBold,
                ZIndex               = 102,
                Parent               = KF,
            })
        end

        -- Load saved key
        if keyCfg.SaveKey then
            local savedKey = ""
            pcall(function() savedKey = readfile("skui_key.txt") end)
            local valid = false
            for _, k in ipairs(keyCfg.Key or {}) do
                if savedKey == k then valid = true break end
            end
            if valid then
                KG:Destroy()
                Win.Visible = true
                Tween(Win, { Size = winSize }, 0.28)
            end
        end

        local function TryKey()
            local entered = KInput.Text
            local valid = false
            for _, k in ipairs(keyCfg.Key or {}) do
                if entered == k then valid = true break end
            end
            if valid then
                if keyCfg.SaveKey then pcall(function() writefile("skui_key.txt", entered) end) end
                Tween(KF, { BackgroundColor3 = Color3.fromRGB(20, 60, 20) }, 0.15)
                task.wait(0.3)
                KG:Destroy()
                Win.Visible = true
                Tween(Win, { Size = winSize }, 0.28)
            else
                KStatus.Text = "✕  Invalid key. Please try again."
                Tween(KInput, { BackgroundColor3 = Color3.fromRGB(70, 15, 15) }, 0.1)
                task.wait(0.9)
                Tween(KInput, { BackgroundColor3 = T.SearchBG }, 0.25)
            end
        end

        KSubmit.MouseButton1Click:Connect(TryKey)
        KInput.FocusLost:Connect(function(enter)
            if enter then TryKey() end
        end)

        KSubmit.MouseEnter:Connect(function() Tween(KSubmit, { BackgroundColor3 = T.AccentHover }, 0.12) end)
        KSubmit.MouseLeave:Connect(function() Tween(KSubmit, { BackgroundColor3 = T.Accent }, 0.12) end)
    else
        -- Animate window open
        Tween(Win, { Size = winSize }, 0.28)
        task.spawn(function() IconModule.Apply(floatIcon, "x") end)
    end

    -- ─────────────────────────────────────────────────────
    --  WINDOW OBJECT
    -- ─────────────────────────────────────────────────────
    local WinObj      = { _tabs = {}, _activeTabKey = nil }
    WinObj._T         = T
    WinObj._left      = LeftPanel
    WinObj._right     = RightContainer
    WinObj._openDD    = OpenDD
    WinObj._layoutOrd = userCfg.Enabled and 2 or 0
    WinObj._searchBox = SearchBox

    -- ─────────────────────────────────────────────────────
    --  Tab()
    -- ─────────────────────────────────────────────────────
    function WinObj:Tab(cfg2)
        cfg2 = cfg2 or {}
        local tabName   = cfg2.Title  or "Tab"
        local tabIcon   = cfg2.Icon
        local isLocked  = cfg2.Locked

        self._layoutOrd = self._layoutOrd + 1
        local lo = self._layoutOrd

        -- ── Tab button (left panel) ───────────────────────
        local TBtn = New("TextButton", {
            Size                 = UDim2.new(1, 0, 0, 34),
            BackgroundColor3     = T.LeftBG,
            BackgroundTransparency = T.TabIdleAlpha,
            BorderSizePixel      = 0,
            Text                 = "",
            LayoutOrder          = lo,
            Parent               = self._left,
        })
        Corner(8, TBtn)

        -- Active indicator bar
        local AccBar = New("Frame", {
            Size                 = UDim2.new(0, 3, 0.55, 0),
            Position             = UDim2.new(0, 0, 0.225, 0),
            BackgroundColor3     = T.Accent,
            BackgroundTransparency = 1,
            BorderSizePixel      = 0,
            Parent               = TBtn,
        })
        Corner(3, AccBar)

        local xPad = 10
        if tabIcon then
            local tIcoImg = New("ImageLabel", {
                Size                 = UDim2.new(0, 16, 0, 16),
                Position             = UDim2.new(0, 10, 0.5, -8),
                BackgroundTransparency = 1,
                ImageColor3          = T.TextDim,
                Parent               = TBtn,
            })
            task.spawn(function() IconModule.Apply(tIcoImg, tabIcon) end)
            xPad = 32

            -- Store for color updates
            TBtn:SetAttribute("_iconRef", tabIcon)
            TBtn._iconImg = tIcoImg
        end

        local TLbl = New("TextLabel", {
            Size                 = UDim2.new(1, isLocked and -36 or -xPad - 4, 1, 0),
            Position             = UDim2.new(0, xPad, 0, 0),
            BackgroundTransparency = 1,
            Text                 = tabName,
            TextColor3           = T.TextDim,
            TextSize             = 12,
            Font                 = Enum.Font.Gotham,
            TextXAlignment       = Enum.TextXAlignment.Left,
            Parent               = TBtn,
        })

        if isLocked then
            local lkIco = New("ImageLabel", {
                Size                 = UDim2.new(0, 13, 0, 13),
                Position             = UDim2.new(1, -20, 0.5, -6.5),
                BackgroundTransparency = 1,
                ImageColor3          = T.TextDim,
                Parent               = TBtn,
            })
            task.spawn(function() IconModule.Apply(lkIco, "lock") end)
        end

        -- ── Content ScrollingFrame (right panel) ──────────
        local Content = New("ScrollingFrame", {
            Name                 = "Content_" .. tabName,
            Size                 = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel      = 0,
            ScrollBarThickness   = 3,
            ScrollBarImageColor3 = T.Accent,
            ScrollBarImageTransparency = 0.35,
            CanvasSize           = UDim2.fromScale(0, 0),
            AutomaticCanvasSize  = Enum.AutomaticSize.Y,
            Visible              = false,
            Parent               = self._right,
        })
        New("UIListLayout", {
            Padding              = UDim.new(0, 6),
            SortOrder            = Enum.SortOrder.LayoutOrder,
            Parent               = Content,
        })
        New("UIPadding", {
            PaddingTop           = UDim.new(0, 8),
            PaddingLeft          = UDim.new(0, 8),
            PaddingRight         = UDim.new(0, 8),
            PaddingBottom        = UDim.new(0, 8),
            Parent               = Content,
        })

        -- ── Activation logic ──────────────────────────────
        local tabEntry = {
            btn     = TBtn,
            lbl     = TLbl,
            bar     = AccBar,
            content = Content,
            iconImg = TBtn._iconImg,
        }
        table.insert(self._tabs, tabEntry)

        local function Activate()
            if isLocked then return end
            -- Deactivate all
            for _, te in ipairs(self._tabs) do
                te.content.Visible = false
                Tween(te.btn, { BackgroundTransparency = T.TabIdleAlpha }, 0.15)
                te.lbl.TextColor3 = T.TextDim
                te.lbl.Font       = Enum.Font.Gotham
                Tween(te.bar, { BackgroundTransparency = 1 }, 0.15)
                if te.iconImg then te.iconImg.ImageColor3 = T.TextDim end
            end
            -- Activate this
            Content.Visible = true
            Tween(TBtn, { BackgroundTransparency = T.TabActiveAlpha }, 0.15)
            TLbl.TextColor3 = T.Text
            TLbl.Font       = Enum.Font.GothamBold
            Tween(AccBar, { BackgroundTransparency = 0 }, 0.15)
            if tabEntry.iconImg then tabEntry.iconImg.ImageColor3 = T.Accent end
            self._activeTabKey = tabName
        end

        TBtn.MouseButton1Click:Connect(Activate)
        TBtn.MouseEnter:Connect(function()
            if self._activeTabKey ~= tabName then
                Tween(TBtn, { BackgroundTransparency = T.TabHoverAlpha }, 0.1)
            end
        end)
        TBtn.MouseLeave:Connect(function()
            if self._activeTabKey ~= tabName then
                Tween(TBtn, { BackgroundTransparency = T.TabIdleAlpha }, 0.1)
            end
        end)

        -- Auto-activate first tab
        if #self._tabs == 1 then Activate() end

        -- Search filtering
        if hasSearch and SearchBox then
            SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                local q = SearchBox.Text:lower()
                for _, child in ipairs(Content:GetChildren()) do
                    if child:IsA("Frame") and child.Name ~= "Section" then
                        local tl = child:FindFirstChild("Title")
                        if tl then
                            child.Visible = q == "" or tl.Text:lower():find(q, 1, true) ~= nil
                        end
                    end
                end
            end)
        end

        -- ─────────────────────────────────────────────────
        --  TAB OBJECT
        -- ─────────────────────────────────────────────────
        local TabObj   = {}
        TabObj._T      = T
        TabObj._c      = Content
        TabObj._ord    = 0
        TabObj._openDD = self._openDD

        local function nOrd(self2)
            self2._ord = self2._ord + 1
            return self2._ord
        end

        -- Helper: card frame for elements
        local function Card(self2, h, name)
            return New("Frame", {
                Name                 = name or "Card",
                Size                 = UDim2.new(1, 0, 0, h),
                BackgroundColor3     = T.ElementBG,
                BackgroundTransparency = T.ElementAlpha,
                BorderSizePixel      = 0,
                LayoutOrder          = nOrd(self2),
                Parent               = self2._c,
            })
        end

        -- ── Section ───────────────────────────────────────
        function TabObj:Section(cfg3)
            cfg3 = cfg3 or {}
            local st = cfg3.Title or "Section"
            local f = New("Frame", {
                Name                 = "Section",
                Size                 = UDim2.new(1, 0, 0, 22),
                BackgroundTransparency = 1,
                BorderSizePixel      = 0,
                LayoutOrder          = nOrd(self),
                Parent               = self._c,
            })
            New("TextLabel", {
                Size                 = UDim2.new(1, -8, 1, 0),
                Position             = UDim2.new(0, 4, 0, 0),
                BackgroundTransparency = 1,
                Text                 = "— " .. st,
                TextColor3           = T.TextSection,
                TextSize             = 10,
                Font                 = Enum.Font.GothamBold,
                TextXAlignment       = Enum.TextXAlignment.Left,
                Parent               = f,
            })
            New("Frame", {
                Size                 = UDim2.new(1, 0, 0, 1),
                Position             = UDim2.new(0, 0, 1, -1),
                BackgroundColor3     = T.TextSection,
                BackgroundTransparency = 0.65,
                BorderSizePixel      = 0,
                Parent               = f,
            })
        end

        -- ── Button ────────────────────────────────────────
        function TabObj:Button(cfg3)
            cfg3 = cfg3 or {}
            local bt       = cfg3.Title    or "Button"
            local locked3  = cfg3.Locked
            local cb       = cfg3.Callback or function() end

            local card = Card(self, 38, "Btn_" .. bt)
            Corner(8, card)
            Stroke(T.Border, 1, 0.5, card)

            New("TextLabel", {
                Name                 = "Title",
                Size                 = UDim2.new(1, -90, 1, 0),
                Position             = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Text                 = bt,
                TextColor3           = locked3 and T.TextDim or T.Text,
                TextSize             = 12,
                Font                 = Enum.Font.GothamSemibold,
                TextXAlignment       = Enum.TextXAlignment.Left,
                Parent               = card,
            })

            local execBtn = New("TextButton", {
                Size                 = UDim2.new(0, 64, 0, 26),
                Position             = UDim2.new(1, -72, 0.5, -13),
                BackgroundColor3     = locked3 and T.Border or T.Accent,
                BackgroundTransparency = 0.2,
                BorderSizePixel      = 0,
                Text                 = locked3 and "" or "Execute",
                TextColor3           = Color3.new(1,1,1),
                TextSize             = 11,
                Font                 = Enum.Font.GothamBold,
                Parent               = card,
            })
            Corner(6, execBtn)

            if locked3 then
                local lkI = New("ImageLabel", {
                    Size                 = UDim2.new(0, 13, 0, 13),
                    Position             = UDim2.new(0.5, -6.5, 0.5, -6.5),
                    BackgroundTransparency = 1,
                    ImageColor3          = T.TextDim,
                    Parent               = execBtn,
                })
                task.spawn(function() IconModule.Apply(lkI, "lock") end)
            else
                execBtn.MouseButton1Click:Connect(function()
                    Tween(execBtn, { BackgroundTransparency = 0 }, 0.08)
                    task.wait(0.12)
                    Tween(execBtn, { BackgroundTransparency = 0.2 }, 0.18)
                    task.spawn(cb)
                end)
                execBtn.MouseEnter:Connect(function() Tween(execBtn, { BackgroundColor3 = T.AccentHover }, 0.12) end)
                execBtn.MouseLeave:Connect(function() Tween(execBtn, { BackgroundColor3 = T.Accent }, 0.12) end)
            end
        end

        -- ── Toggle ────────────────────────────────────────
        function TabObj:Toggle(cfg3)
            cfg3 = cfg3 or {}
            local tt    = cfg3.Title   or "Toggle"
            local td    = cfg3.Desc
            local ti    = cfg3.Icon
            local defV  = cfg3.Value   or false
            local cb    = cfg3.Callback or function() end
            local h     = td and 50 or 38

            local card  = Card(self, h, "Tog_" .. tt)
            Corner(8, card)
            Stroke(T.Border, 1, 0.5, card)

            local xOff  = 12
            if ti then
                local tiI = New("ImageLabel", {
                    Size                 = UDim2.new(0, 16, 0, 16),
                    Position             = UDim2.new(0, 10, 0.5, -8),
                    BackgroundTransparency = 1,
                    ImageColor3          = T.Accent,
                    Parent               = card,
                })
                task.spawn(function() IconModule.Apply(tiI, ti) end)
                xOff = 32
            end

            New("TextLabel", {
                Name                 = "Title",
                Size                 = UDim2.new(1, -90, 0, td and 18 or 22),
                Position             = UDim2.new(0, xOff, 0, td and 7 or 0.5 - 11/card.Size.Y.Offset),
                BackgroundTransparency = 1,
                Text                 = tt,
                TextColor3           = T.Text,
                TextSize             = 12,
                Font                 = Enum.Font.GothamSemibold,
                TextXAlignment       = Enum.TextXAlignment.Left,
                Parent               = card,
            })
            if td then
                New("TextLabel", {
                    Name                 = "Desc",
                    Size                 = UDim2.new(1, -90, 0, 14),
                    Position             = UDim2.new(0, xOff, 0, 27),
                    BackgroundTransparency = 1,
                    Text                 = td,
                    TextColor3           = T.TextDim,
                    TextSize             = 10,
                    Font                 = Enum.Font.Gotham,
                    TextXAlignment       = Enum.TextXAlignment.Left,
                    Parent               = card,
                })
            end

            local SwitchBG = New("Frame", {
                Size                 = UDim2.new(0, 38, 0, 20),
                Position             = UDim2.new(1, -48, 0.5, -10),
                BackgroundColor3     = defV and T.ToggleOn or T.ToggleOff,
                BorderSizePixel      = 0,
                Parent               = card,
            })
            Corner(10, SwitchBG)

            local Knob = New("Frame", {
                Size                 = UDim2.new(0, 14, 0, 14),
                Position             = defV and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
                BackgroundColor3     = Color3.new(1,1,1),
                BorderSizePixel      = 0,
                Parent               = SwitchBG,
            })
            Corner(7, Knob)

            local state = defV

            local function SetToggle(v, fire)
                state = v
                Tween(SwitchBG, { BackgroundColor3 = v and T.ToggleOn or T.ToggleOff }, 0.2)
                Tween(Knob, { Position = v and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7) }, 0.2)
                if fire then task.spawn(cb, v) end
            end

            card.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    SetToggle(not state, true)
                end
            end)

            local TogObj = {}
            function TogObj:Set(v)  SetToggle(v, true) end
            function TogObj:Get()   return state end
            return TogObj
        end

        -- ── Slider ────────────────────────────────────────
        function TabObj:Slider(cfg3)
            cfg3 = cfg3 or {}
            local st2   = cfg3.Title   or "Slider"
            local step  = cfg3.Step    or 1
            local vCfg  = cfg3.Value   or {}
            local minV  = vCfg.Min     or 0
            local maxV  = vCfg.Max     or 100
            local defV  = vCfg.Default or minV
            local cb    = cfg3.Callback or function() end

            local card  = Card(self, 54, "Sld_" .. st2)
            Corner(8, card)
            Stroke(T.Border, 1, 0.5, card)

            local ValLbl = New("TextLabel", {
                Name                 = "Value",
                Size                 = UDim2.new(0, 44, 0, 16),
                Position             = UDim2.new(1, -50, 0, 7),
                BackgroundTransparency = 1,
                Text                 = tostring(defV),
                TextColor3           = T.Accent,
                TextSize             = 11,
                Font                 = Enum.Font.GothamBold,
                TextXAlignment       = Enum.TextXAlignment.Right,
                Parent               = card,
            })

            New("TextLabel", {
                Name                 = "Title",
                Size                 = UDim2.new(1, -104, 0, 16),
                Position             = UDim2.new(0, 12, 0, 7),
                BackgroundTransparency = 1,
                Text                 = st2,
                TextColor3           = T.Text,
                TextSize             = 12,
                Font                 = Enum.Font.GothamSemibold,
                TextXAlignment       = Enum.TextXAlignment.Left,
                Parent               = card,
            })

            local TrackBG = New("Frame", {
                Size                 = UDim2.new(1, -24, 0, 6),
                Position             = UDim2.new(0, 12, 0, 36),
                BackgroundColor3     = T.ToggleOff,
                BorderSizePixel      = 0,
                Parent               = card,
            })
            Corner(3, TrackBG)

            local fillPct = (defV - minV) / math.max(maxV - minV, 0.001)

            local TrackFill = New("Frame", {
                Size                 = UDim2.new(fillPct, 0, 1, 0),
                BackgroundColor3     = T.SliderFill,
                BorderSizePixel      = 0,
                Parent               = TrackBG,
            })
            Corner(3, TrackFill)

            local SKnob = New("Frame", {
                Size                 = UDim2.new(0, 14, 0, 14),
                Position             = UDim2.new(fillPct, -7, 0.5, -7),
                BackgroundColor3     = Color3.new(1,1,1),
                BorderSizePixel      = 0,
                Parent               = TrackBG,
            })
            Corner(7, SKnob)
            Stroke(T.Accent, 1.5, 0, SKnob)

            local curV = defV
            local sldDrag = false

            local function UpdateSlider(ax)
                local tp = TrackBG.AbsolutePosition.X
                local tw = TrackBG.AbsoluteSize.X
                local rel = math.clamp((ax - tp) / math.max(tw, 1), 0, 1)
                local raw = minV + rel * (maxV - minV)
                local snapped = math.clamp(math.round(raw / step) * step, minV, maxV)
                curV = snapped
                local s = (snapped - minV) / math.max(maxV - minV, 0.001)
                TrackFill.Size    = UDim2.new(s, 0, 1, 0)
                SKnob.Position    = UDim2.new(s, -7, 0.5, -7)
                ValLbl.Text       = tostring(snapped)
                task.spawn(cb, snapped)
            end

            TrackBG.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    sldDrag = true
                    UpdateSlider(i.Position.X)
                end
            end)
            SKnob.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then sldDrag = true end
            end)
            UIS.InputChanged:Connect(function(i)
                if sldDrag and i.UserInputType == Enum.UserInputType.MouseMovement then
                    UpdateSlider(i.Position.X)
                end
            end)
            UIS.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then sldDrag = false end
            end)

            local SldObj = {}
            function SldObj:Set(v)
                curV = math.clamp(v, minV, maxV)
                local s = (curV - minV) / math.max(maxV - minV, 0.001)
                TrackFill.Size  = UDim2.new(s, 0, 1, 0)
                SKnob.Position  = UDim2.new(s, -7, 0.5, -7)
                ValLbl.Text     = tostring(curV)
            end
            function SldObj:Get() return curV end
            return SldObj
        end

        -- ── Input ─────────────────────────────────────────
        function TabObj:Input(cfg3)
            cfg3 = cfg3 or {}
            local it    = cfg3.Title       or "Input"
            local iDef  = cfg3.Value       or ""
            local iIco  = cfg3.InputIcon
            local iPH   = cfg3.Placeholder or "Type here..."
            local cb    = cfg3.Callback    or function() end

            local card  = Card(self, 54, "Inp_" .. it)
            Corner(8, card)
            Stroke(T.Border, 1, 0.5, card)

            New("TextLabel", {
                Name                 = "Title",
                Size                 = UDim2.new(1, -16, 0, 16),
                Position             = UDim2.new(0, 12, 0, 7),
                BackgroundTransparency = 1,
                Text                 = it,
                TextColor3           = T.Text,
                TextSize             = 12,
                Font                 = Enum.Font.GothamSemibold,
                TextXAlignment       = Enum.TextXAlignment.Left,
                Parent               = card,
            })

            local IBox = New("TextBox", {
                Name                 = "InputBox",
                Size                 = UDim2.new(1, -24, 0, 22),
                Position             = UDim2.new(0, 12, 0, 27),
                BackgroundColor3     = T.SearchBG,
                BackgroundTransparency = 0.05,
                BorderSizePixel      = 0,
                Text                 = iDef,
                PlaceholderText      = iPH,
                PlaceholderColor3    = T.TextDim,
                TextColor3           = T.Text,
                TextSize             = 11,
                Font                 = Enum.Font.Gotham,
                ClearTextOnFocus     = false,
                TextXAlignment       = Enum.TextXAlignment.Left,
                Parent               = card,
            })
            Corner(6, IBox)
            Stroke(T.Border, 1, 0.35, IBox)

            local padL = iIco and 28 or 8
            New("UIPadding", { PaddingLeft = UDim.new(0, padL), Parent = IBox })

            if iIco then
                local iiImg = New("ImageLabel", {
                    Size                 = UDim2.new(0, 13, 0, 13),
                    Position             = UDim2.new(0, 7, 0.5, -6.5),
                    BackgroundTransparency = 1,
                    ImageColor3          = T.Accent,
                    Parent               = IBox,
                })
                task.spawn(function() IconModule.Apply(iiImg, iIco) end)
            end

            -- Focus glow
            IBox.Focused:Connect(function()  Stroke(T.Accent, 1, 0.1, IBox) end)
            IBox.FocusLost:Connect(function(enter)
                Stroke(T.Border, 1, 0.35, IBox)
                task.spawn(cb, IBox.Text)
            end)

            local InpObj = {}
            function InpObj:Set(v) IBox.Text = v end
            function InpObj:Get() return IBox.Text end
            return InpObj
        end

        -- ── Dropdown ──────────────────────────────────────
        function TabObj:Dropdown(cfg3)
            cfg3 = cfg3 or {}
            local dt    = cfg3.Title    or "Dropdown"
            local dVals = cfg3.Values   or {}
            local dDef  = cfg3.Value    or (dVals[1] or "")
            local cb    = cfg3.Callback or function() end

            local curV  = dDef

            local card  = Card(self, 38, "DD_" .. dt)
            Corner(8, card)
            Stroke(T.Border, 1, 0.5, card)

            New("TextLabel", {
                Name                 = "Title",
                Size                 = UDim2.new(0.5, -4, 1, 0),
                Position             = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Text                 = dt,
                TextColor3           = T.Text,
                TextSize             = 12,
                Font                 = Enum.Font.GothamSemibold,
                TextXAlignment       = Enum.TextXAlignment.Left,
                Parent               = card,
            })

            local DispBtn = New("TextButton", {
                Name                 = "Disp",
                Size                 = UDim2.new(0.46, 0, 0, 26),
                Position             = UDim2.new(0.54, -2, 0.5, -13),
                BackgroundColor3     = T.SearchBG,
                BackgroundTransparency = 0.05,
                BorderSizePixel      = 0,
                Text                 = "",
                Parent               = card,
            })
            Corner(6, DispBtn)
            Stroke(T.Border, 1, 0.35, DispBtn)

            local DispTxt = New("TextLabel", {
                Size                 = UDim2.new(1, -24, 1, 0),
                Position             = UDim2.new(0, 8, 0, 0),
                BackgroundTransparency = 1,
                Text                 = curV,
                TextColor3           = T.TextDim,
                TextSize             = 11,
                Font                 = Enum.Font.Gotham,
                TextXAlignment       = Enum.TextXAlignment.Left,
                TextTruncate         = Enum.TextTruncate.AtEnd,
                Parent               = DispBtn,
            })

            local chevImg = New("ImageLabel", {
                Size                 = UDim2.new(0, 12, 0, 12),
                Position             = UDim2.new(1, -18, 0.5, -6),
                BackgroundTransparency = 1,
                ImageColor3          = T.TextDim,
                Parent               = DispBtn,
            })
            task.spawn(function() IconModule.Apply(chevImg, "chevron-down") end)

            DispBtn.MouseEnter:Connect(function() Tween(DispBtn, { BackgroundColor3 = T.ElementBG }, 0.1) end)
            DispBtn.MouseLeave:Connect(function() Tween(DispBtn, { BackgroundColor3 = T.SearchBG  }, 0.1) end)

            DispBtn.MouseButton1Click:Connect(function()
                self._openDD(dt, dVals, curV, function(v)
                    curV = v
                    DispTxt.Text = v
                    task.spawn(cb, v)
                end)
            end)

            local DDObj = {}
            function DDObj:Refresh(newVals)
                dVals = newVals
                curV  = newVals[1] or ""
                DispTxt.Text = curV
            end
            function DDObj:Set(v)
                curV = v
                DispTxt.Text = v
            end
            function DDObj:Get() return curV end
            return DDObj
        end

        return TabObj
    end -- :Tab()

    return WinObj
end -- :CreateWindow()

-- ─────────────────────────────────────────────────────────
return SKUI
