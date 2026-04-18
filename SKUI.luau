--[[
╔══════════════════════════════════════════════════════════════════╗
║                  ftgs UI Library  v3.0                           ║
║  Key System · Themes · Resizable · Background · User Panel       ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  local WindUI = loadstring(game:HttpGet("RAW_URL"))()            ║
║                                                                  ║
║  local Window = WindUI:CreateWindow({                            ║
║      Title  = "My Super Hub",                                    ║
║      Author = "by .ftgs and .ftgs",                              ║
║      Folder = "MySuperHub",                                      ║
║                                                                  ║
║      -- all optional ↓                                           ║
║      Size        = UDim2.fromOffset(580, 460),                   ║
║      MinSize     = Vector2.new(560, 350),                        ║
║      MaxSize     = Vector2.new(850, 560),                        ║
║      ToggleKey   = Enum.KeyCode.LeftShift,                       ║
║      Transparent = true,                                         ║
║      Theme       = "Dark",   -- "Dark" | "Light" | "Midnight"   ║
║      Resizable   = true,                                         ║
║      SideBarWidth= 160,                                          ║
║      BackgroundImageTransparency = 0.42,                         ║
║      HideSearchBar  = false,                                     ║
║      ScrollBarEnabled = true,                                    ║
║                                                                  ║
║      -- Background: image or video                               ║
║      Background = "rbxassetid://",                               ║
║      -- Background = "video:RAW_URL.webm",                       ║
║                                                                  ║
║      User = {                                                     ║
║          Enabled   = true,                                       ║
║          Anonymous = false,                                      ║
║          Callback  = function() print("user clicked") end,       ║
║      },                                                          ║
║                                                                  ║
║      KeySystem = {                                               ║
║          Key       = { "1234", "5678" },                         ║
║          Title     = "Key System",                               ║
║          Note      = "Join discord to get a key.",               ║
║          Thumbnail = { Image = "rbxassetid://", Title = "Hub" }, ║
║          URL       = "https://discord.gg/example",               ║
║          SaveKey   = true,                                       ║
║      },                                                          ║
║  })                                                              ║
║                                                                  ║
║  local MinBtn = Window:CreateMinimizeBtn({                       ║
║      Title = "Open UI",                                          ║
║      Color = "Purple", -- Red|Green|Blue|Purple|Yellow|Orange    ║
║  })                                                              ║
║                                                                  ║
║  local Tab1 = Window:Tab({ Title = "Home"     })                 ║
║  local Tab2 = Window:Tab({ Title = "Settings" })                 ║
║  local Tab3 = Window:Tab({ Title = "Admin", Locked = true })     ║
║                                                                  ║
║  Tab1:Section("General")                                         ║
║                                                                  ║
║  Tab1:Button({  Title="Click Me", Desc="Desc", Locked=false,     ║
║      Callback = function() end })                                ║
║                                                                  ║
║  local DD = Tab1:Dropdown({ Title="Mode",                        ║
║      Values={"A","B","C"}, Value="A",                            ║
║      Callback=function(v) end })                                 ║
║  DD:SetValue("B")  DD:GetValue()                                 ║
║                                                                  ║
║  local Tog = Tab1:Toggle({ Title="Auto", Value=false,            ║
║      Callback=function(s) end })                                 ║
║  Tog:SetValue(true)  Tog:GetValue()                              ║
║                                                                  ║
║  local Sld = Tab1:Slider({ Title="Speed",                        ║
║      Step=1, Value={Min=0,Max=100,Default=50},                   ║
║      Callback=function(v) end })                                 ║
║  Sld:SetValue(75)  Sld:GetValue()                                ║
║                                                                  ║
║  local Inp = Tab1:Input({ Title="Name",                          ║
║      Type="Input", Placeholder="Type...",                        ║
║      Callback=function(t) end })                                 ║
║  Inp:SetValue("hi")  Inp:GetValue()                              ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
--]]

-- ═══════════════════════════════════════════
--  SERVICES
-- ═══════════════════════════════════════════
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local Player           = Players.LocalPlayer

-- ═══════════════════════════════════════════
--  FILE I/O  (executor-safe wrappers)
-- ═══════════════════════════════════════════
local function FSWrite(p, d)  pcall(function() writefile(p, d)    end) end
local function FSRead(p)
    local ok, v = pcall(function() return readfile(p) end)
    return ok and v or nil
end
local function FSFolder(p)    pcall(function() makefolder(p)      end) end

-- ═══════════════════════════════════════════
--  HELPERS
-- ═══════════════════════════════════════════
local function Tween(obj, info, props)
    local t = TweenService:Create(obj, info, props); t:Play(); return t
end

local function Corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8); c.Parent = p; return c
end

local function NewStroke(p, col, thick)
    local s = Instance.new("UIStroke")
    s.Color = col; s.Thickness = thick or 1; s.Parent = p; return s
end

local function Shadow(parent, trans)
    local s = Instance.new("ImageLabel")
    s.Size = UDim2.new(1,60,1,60); s.Position = UDim2.new(0,-30,0,-30)
    s.BackgroundTransparency = 1; s.Image = "rbxassetid://6014261993"
    s.ImageColor3 = Color3.new(0,0,0); s.ImageTransparency = trans or 0.5
    s.ScaleType = Enum.ScaleType.Slice; s.SliceCenter = Rect.new(49,49,450,450)
    s.ZIndex = -1; s.Parent = parent; return s
end

local function MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, startMouse, startPos
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true; startMouse = i.Position; startPos = frame.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement
        or i.UserInputType == Enum.UserInputType.Touch then dragInput = i end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i == dragInput then
            local d = i.Position - startMouse
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

-- ═══════════════════════════════════════════
--  THEMES
-- ═══════════════════════════════════════════
local Themes = {
    Dark = {
        Bg        = Color3.fromRGB(13,  13,  20 ),
        Secondary = Color3.fromRGB(19,  19,  29 ),
        Tertiary  = Color3.fromRGB(27,  27,  41 ),
        Elem      = Color3.fromRGB(21,  21,  33 ),
        Accent    = Color3.fromRGB(108, 84,  232),
        AccentHov = Color3.fromRGB(130, 106, 255),
        AccentDim = Color3.fromRGB(66,  50,  152),
        Text      = Color3.fromRGB(234, 234, 250),
        SubText   = Color3.fromRGB(138, 138, 166),
        Border    = Color3.fromRGB(38,  38,  58 ),
        BorderHi  = Color3.fromRGB(58,  58,  88 ),
        Success   = Color3.fromRGB(66,  192, 116),
        Danger    = Color3.fromRGB(216, 68,  68 ),
        Warning   = Color3.fromRGB(216, 160, 56 ),
        Blue      = Color3.fromRGB(66,  126, 216),
        Orange    = Color3.fromRGB(216, 114, 54 ),
    },
    Light = {
        Bg        = Color3.fromRGB(244, 244, 254),
        Secondary = Color3.fromRGB(230, 230, 244),
        Tertiary  = Color3.fromRGB(216, 216, 236),
        Elem      = Color3.fromRGB(234, 234, 250),
        Accent    = Color3.fromRGB(96,  70,  216),
        AccentHov = Color3.fromRGB(116, 90,  238),
        AccentDim = Color3.fromRGB(158, 138, 255),
        Text      = Color3.fromRGB(20,  20,  36 ),
        SubText   = Color3.fromRGB(94,  94,  126),
        Border    = Color3.fromRGB(196, 196, 220),
        BorderHi  = Color3.fromRGB(166, 166, 198),
        Success   = Color3.fromRGB(42,  166, 90 ),
        Danger    = Color3.fromRGB(198, 50,  50 ),
        Warning   = Color3.fromRGB(192, 136, 30 ),
        Blue      = Color3.fromRGB(44,  106, 196),
        Orange    = Color3.fromRGB(194, 96,  34 ),
    },
    Midnight = {
        Bg        = Color3.fromRGB(6,   6,   12 ),
        Secondary = Color3.fromRGB(10,  10,  20 ),
        Tertiary  = Color3.fromRGB(15,  15,  29 ),
        Elem      = Color3.fromRGB(11,  11,  23 ),
        Accent    = Color3.fromRGB(88,  50,  208),
        AccentHov = Color3.fromRGB(108, 70,  238),
        AccentDim = Color3.fromRGB(50,  26,  138),
        Text      = Color3.fromRGB(218, 218, 242),
        SubText   = Color3.fromRGB(108, 108, 146),
        Border    = Color3.fromRGB(24,  24,  46 ),
        BorderHi  = Color3.fromRGB(42,  42,  76 ),
        Success   = Color3.fromRGB(50,  176, 100),
        Danger    = Color3.fromRGB(198, 54,  54 ),
        Warning   = Color3.fromRGB(198, 146, 40 ),
        Blue      = Color3.fromRGB(50,  110, 200),
        Orange    = Color3.fromRGB(198, 98,  38 ),
    },
}

-- ═══════════════════════════════════════════
--  SCREENGUI
-- ═══════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "ftgsUIv3"
ScreenGui.ResetOnSpawn   = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder   = 999
ScreenGui.IgnoreGuiInset = true
local _pcOk = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not _pcOk or not ScreenGui.Parent then
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
end

-- ═══════════════════════════════════════════
--  SCROLLFRAME V2  factory
--  Returns { Wrapper, Scroll, Layout }
--  Canvas auto-expands on content change.
-- ═══════════════════════════════════════════
local function ScrollV2(parent, size, pos, pad, barThick, accent)
    pad      = pad      or {top=6, bottom=12, left=4, right=6}
    barThick = barThick or 4
    accent   = accent   or Color3.fromRGB(108,84,232)

    local W = Instance.new("Frame")
    W.Size = size; W.Position = pos
    W.BackgroundTransparency = 1; W.BorderSizePixel = 0
    W.ClipsDescendants = true; W.Parent = parent

    local SF = Instance.new("ScrollingFrame")
    SF.Size = UDim2.fromScale(1,1); SF.BackgroundTransparency = 1
    SF.BorderSizePixel = 0; SF.ScrollBarThickness = barThick
    SF.ScrollBarImageColor3 = accent; SF.ScrollingDirection = Enum.ScrollingDirection.Y
    SF.CanvasSize = UDim2.new(0,0,0,0); SF.ScrollingEnabled = true
    SF.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
    SF.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
    SF.MidImage    = "rbxasset://textures/ui/Scroll/scroll-middle.png"
    SF.TopImage    = "rbxasset://textures/ui/Scroll/scroll-middle.png"
    SF.Parent = W

    local L = Instance.new("UIListLayout")
    L.SortOrder = Enum.SortOrder.LayoutOrder; L.Padding = UDim.new(0,6); L.Parent = SF

    local P = Instance.new("UIPadding")
    P.PaddingTop    = UDim.new(0, pad.top)
    P.PaddingBottom = UDim.new(0, pad.bottom)
    P.PaddingLeft   = UDim.new(0, pad.left)
    P.PaddingRight  = UDim.new(0, pad.right)
    P.Parent = SF

    L:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SF.CanvasSize = UDim2.new(0,0,0,
            L.AbsoluteContentSize.Y + pad.top + pad.bottom + 4)
    end)

    return {Wrapper=W, Scroll=SF, Layout=L}
end

-- ═══════════════════════════════════════════
--  DROPDOWN POPUP  (global, rebuilt per theme)
-- ═══════════════════════════════════════════
local _DDLayer, _DDCard, _DDTitle, _DDXBtn, _DDScrV2
local _DDHide

local function BuildDropdown(T)
    if _DDLayer then _DDLayer:Destroy() end

    _DDLayer = Instance.new("Frame")
    _DDLayer.Name = "DDLayer"
    _DDLayer.Size = UDim2.fromScale(1,1)
    _DDLayer.BackgroundColor3 = Color3.new(0,0,0)
    _DDLayer.BackgroundTransparency = 0.5
    _DDLayer.BorderSizePixel = 0; _DDLayer.ZIndex = 500
    _DDLayer.Visible = false; _DDLayer.Parent = ScreenGui

    _DDCard = Instance.new("Frame")
    _DDCard.Size = UDim2.new(0,288,0,0)
    _DDCard.AnchorPoint = Vector2.new(0.5,0.5)
    _DDCard.Position = UDim2.fromScale(0.5,0.5)
    _DDCard.BackgroundColor3 = T.Secondary
    _DDCard.BorderSizePixel = 0; _DDCard.ZIndex = 501
    _DDCard.ClipsDescendants = true; _DDCard.Parent = _DDLayer
    Corner(_DDCard, 14); NewStroke(_DDCard, T.BorderHi, 1); Shadow(_DDCard, 0.44)

    -- header
    local Head = Instance.new("Frame")
    Head.Size = UDim2.new(1,0,0,44); Head.BackgroundColor3 = T.Tertiary
    Head.BorderSizePixel = 0; Head.ZIndex = 502; Head.Parent = _DDCard; Corner(Head, 14)
    local HFix = Instance.new("Frame")
    HFix.Size = UDim2.new(1,0,0,14); HFix.Position = UDim2.new(0,0,1,-14)
    HFix.BackgroundColor3 = T.Tertiary; HFix.BorderSizePixel = 0; HFix.ZIndex = 502; HFix.Parent = Head

    local HPill = Instance.new("Frame")
    HPill.Size = UDim2.new(0,3,0,20); HPill.Position = UDim2.new(0,14,0.5,-10)
    HPill.BackgroundColor3 = T.Accent; HPill.BorderSizePixel = 0; HPill.ZIndex = 503; HPill.Parent = Head
    Corner(HPill, 2)

    _DDTitle = Instance.new("TextLabel")
    _DDTitle.Size = UDim2.new(1,-68,1,0); _DDTitle.Position = UDim2.new(0,26,0,0)
    _DDTitle.BackgroundTransparency = 1; _DDTitle.Text = "Select"
    _DDTitle.TextColor3 = T.Text; _DDTitle.Font = Enum.Font.GothamBold
    _DDTitle.TextSize = 14; _DDTitle.TextXAlignment = Enum.TextXAlignment.Left
    _DDTitle.ZIndex = 503; _DDTitle.Parent = Head

    _DDXBtn = Instance.new("TextButton")
    _DDXBtn.Size = UDim2.new(0,24,0,24); _DDXBtn.Position = UDim2.new(1,-34,0.5,-12)
    _DDXBtn.BackgroundColor3 = T.Border; _DDXBtn.Text = "✕"
    _DDXBtn.TextColor3 = T.SubText; _DDXBtn.Font = Enum.Font.GothamBold
    _DDXBtn.TextSize = 11; _DDXBtn.BorderSizePixel = 0; _DDXBtn.ZIndex = 503; _DDXBtn.Parent = Head
    Corner(_DDXBtn, 12)

    _DDScrV2 = ScrollV2(_DDCard,
        UDim2.new(1,-8,1,-52), UDim2.new(0,4,0,48),
        {top=4,bottom=6,left=4,right=4}, 4, T.Accent)
    _DDScrV2.Scroll.ZIndex = 502

    _DDHide = function()
        Tween(_DDCard, TweenInfo.new(0.16,Enum.EasingStyle.Quad,Enum.EasingDirection.In),
            {Size=UDim2.new(0,288,0,0)})
        Tween(_DDLayer, TweenInfo.new(0.16), {BackgroundTransparency=1})
        task.delay(0.2, function()
            _DDLayer.Visible = false
            for _,c in ipairs(_DDScrV2.Scroll:GetChildren()) do
                if c:IsA("TextButton") then c:Destroy() end
            end
        end)
    end

    _DDXBtn.MouseButton1Click:Connect(_DDHide)
    _DDLayer.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then _DDHide() end
    end)
end

local function OpenDropdown(T, title, values, curVal, onSelect)
    if not _DDLayer then BuildDropdown(T) end
    for _,c in ipairs(_DDScrV2.Scroll:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    _DDTitle.Text = title
    local active = curVal

    for idx, val in ipairs(values) do
        local isA = val == active
        local item = Instance.new("TextButton")
        item.Size = UDim2.new(1,0,0,36); item.BackgroundColor3 = isA and T.Accent or T.Tertiary
        item.BorderSizePixel = 0; item.Text = val
        item.TextColor3 = isA and T.Text or T.SubText
        item.Font = isA and Enum.Font.GothamBold or Enum.Font.Gotham
        item.TextSize = 13; item.LayoutOrder = idx; item.ZIndex = 503; item.Parent = _DDScrV2.Scroll
        Corner(item, 8)

        if isA then
            local dot = Instance.new("Frame"); dot.Name = "Dot"
            dot.Size = UDim2.new(0,6,0,6); dot.Position = UDim2.new(1,-16,0.5,-3)
            dot.BackgroundColor3 = T.Text; dot.BorderSizePixel = 0; dot.ZIndex = 504; dot.Parent = item
            Corner(dot, 3)
        end

        item.MouseEnter:Connect(function()
            if val ~= active then Tween(item,TweenInfo.new(0.1),{BackgroundColor3=T.BorderHi,TextColor3=T.Text}) end
        end)
        item.MouseLeave:Connect(function()
            if val ~= active then Tween(item,TweenInfo.new(0.1),{BackgroundColor3=T.Tertiary,TextColor3=T.SubText}) end
        end)
        item.MouseButton1Click:Connect(function()
            active = val
            for _,sib in ipairs(_DDScrV2.Scroll:GetChildren()) do
                if sib:IsA("TextButton") then
                    local a = sib.Text == val
                    Tween(sib, TweenInfo.new(0.12), {BackgroundColor3=a and T.Accent or T.Tertiary, TextColor3=a and T.Text or T.SubText})
                    sib.Font = a and Enum.Font.GothamBold or Enum.Font.Gotham
                    local d = sib:FindFirstChild("Dot"); if d then d:Destroy() end
                    if a then
                        local nd=Instance.new("Frame"); nd.Name="Dot"
                        nd.Size=UDim2.new(0,6,0,6); nd.Position=UDim2.new(1,-16,0.5,-3)
                        nd.BackgroundColor3=T.Text; nd.BorderSizePixel=0; nd.ZIndex=504; nd.Parent=sib
                        Corner(nd,3)
                    end
                end
            end
            onSelect(val); _DDHide()
        end)
    end

    local count = #values; local targetH = math.min(count*42+56, 320)
    _DDScrV2.Scroll.CanvasSize = UDim2.new(0,0,0,count*42+10)
    _DDCard.Size = UDim2.new(0,288,0,0)
    _DDLayer.BackgroundTransparency = 1; _DDLayer.Visible = true
    Tween(_DDLayer, TweenInfo.new(0.2), {BackgroundTransparency=0.5})
    Tween(_DDCard, TweenInfo.new(0.28,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
        {Size=UDim2.new(0,288,0,targetH)})
end

-- ═══════════════════════════════════════════
--  KEY SYSTEM  (square card UI)
-- ═══════════════════════════════════════════
local function ShowKeySystem(config, T, onSuccess, onCancel)
    local ks     = config.KeySystem
    local folder = config.Folder or "ftgsUI"

    -- check saved key
    if ks.SaveKey then
        FSFolder(folder)
        local saved = FSRead(folder.."/key.txt")
        if saved then
            local keys = ks.Key or {}
            for _, k in ipairs(keys) do
                if saved:gsub("%s+","") == k then
                    task.defer(onSuccess); return
                end
            end
        end
    end

    -- ── Dimmer overlay ────────────────────────────
    local Dim = Instance.new("Frame")
    Dim.Name = "KeyDim"; Dim.Size = UDim2.fromScale(1,1)
    Dim.BackgroundColor3 = Color3.new(0,0,0)
    Dim.BackgroundTransparency = 1; Dim.BorderSizePixel = 0
    Dim.ZIndex = 700; Dim.Parent = ScreenGui

    -- ── Square card ───────────────────────────────
    -- We'll build sections top→down, tracking Y cursor
    local CARD_W = 344
    local yPos   = 0

    local Card = Instance.new("Frame")
    Card.Name = "KeyCard"
    Card.Size = UDim2.new(0, CARD_W, 0, 0)  -- height set after building
    Card.AnchorPoint = Vector2.new(0.5, 0.5)
    Card.Position = UDim2.fromScale(0.5, 0.5)
    Card.BackgroundColor3 = T.Bg
    Card.BorderSizePixel = 0; Card.ZIndex = 701
    Card.ClipsDescendants = true; Card.Parent = Dim
    Corner(Card, 16); NewStroke(Card, T.BorderHi, 1); Shadow(Card, 0.42)

    local function Put(instance, height, topGap)
        topGap = topGap or 0
        yPos = yPos + topGap
        instance.Position = UDim2.new(0, 0, 0, yPos)
        instance.Size = UDim2.new(1, 0, 0, height)
        instance.Parent = Card
        yPos = yPos + height
    end
    local function PutPadded(instance, height, topGap, padL, padR)
        topGap = topGap or 0; padL = padL or 20; padR = padR or 20
        yPos = yPos + topGap
        instance.Position = UDim2.new(0, padL, 0, yPos)
        instance.Size = UDim2.new(1, -(padL+padR), 0, height)
        instance.Parent = Card
        yPos = yPos + height
    end

    -- ── 1. Thumbnail ──────────────────────────────
    if ks.Thumbnail then
        local TB = Instance.new("Frame"); TB.BackgroundColor3 = T.Secondary
        TB.BorderSizePixel = 0; TB.ZIndex = 702
        Put(TB, 120)

        if ks.Thumbnail.Image and ks.Thumbnail.Image ~= "" and ks.Thumbnail.Image ~= "rbxassetid://" then
            local IL = Instance.new("ImageLabel")
            IL.Size = UDim2.fromScale(1,1); IL.BackgroundTransparency = 1
            IL.Image = ks.Thumbnail.Image; IL.ScaleType = Enum.ScaleType.Crop
            IL.ImageTransparency = 0.05; IL.ZIndex = 703; IL.Parent = TB
            Corner(IL, 16)
        end

        -- dim overlay on thumbnail
        local TDim = Instance.new("Frame")
        TDim.Size = UDim2.fromScale(1,1); TDim.BackgroundColor3 = Color3.new(0,0,0)
        TDim.BackgroundTransparency = 0.55; TDim.BorderSizePixel = 0; TDim.ZIndex = 703; TDim.Parent = TB

        if ks.Thumbnail.Title and ks.Thumbnail.Title ~= "" then
            local TL = Instance.new("TextLabel")
            TL.Size = UDim2.new(1,-24,0,22); TL.Position = UDim2.new(0,12,1,-32)
            TL.BackgroundTransparency = 1; TL.Text = ks.Thumbnail.Title
            TL.TextColor3 = Color3.fromRGB(255,255,255); TL.Font = Enum.Font.GothamBold
            TL.TextSize = 14; TL.TextXAlignment = Enum.TextXAlignment.Left
            TL.ZIndex = 704; TL.Parent = TB
        end
    end

    -- ── 2. Title + divider ────────────────────────
    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.BackgroundTransparency = 1; TitleLbl.Text = ks.Title or "Key System"
    TitleLbl.TextColor3 = T.Text; TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 17; TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.ZIndex = 702
    PutPadded(TitleLbl, 24, 20)

    local Divider = Instance.new("Frame")
    Divider.BackgroundColor3 = T.Border; Divider.BorderSizePixel = 0; Divider.ZIndex = 702
    PutPadded(Divider, 1, 8)

    -- ── 3. Note ───────────────────────────────────
    if ks.Note and ks.Note ~= "" then
        local NoteLbl = Instance.new("TextLabel")
        NoteLbl.BackgroundTransparency = 1; NoteLbl.Text = ks.Note
        NoteLbl.TextColor3 = T.SubText; NoteLbl.Font = Enum.Font.Gotham
        NoteLbl.TextSize = 12; NoteLbl.TextXAlignment = Enum.TextXAlignment.Left
        NoteLbl.TextWrapped = true; NoteLbl.ZIndex = 702
        PutPadded(NoteLbl, 36, 12)
    end

    -- ── 4. Key input ──────────────────────────────
    local InputBg = Instance.new("Frame")
    InputBg.BackgroundColor3 = T.Tertiary; InputBg.BorderSizePixel = 0; InputBg.ZIndex = 702
    PutPadded(InputBg, 38, 14)
    Corner(InputBg, 8); local iStroke = NewStroke(InputBg, T.Border)

    local KeyBox = Instance.new("TextBox")
    KeyBox.Size = UDim2.new(1,-42,1,-8); KeyBox.Position = UDim2.new(0,10,0,4)
    KeyBox.BackgroundTransparency = 1; KeyBox.Text = ""
    KeyBox.PlaceholderText = "Enter your key here..."
    KeyBox.PlaceholderColor3 = T.SubText; KeyBox.TextColor3 = T.Text
    KeyBox.Font = Enum.Font.Gotham; KeyBox.TextSize = 13
    KeyBox.TextXAlignment = Enum.TextXAlignment.Left
    KeyBox.ClearTextOnFocus = false; KeyBox.BorderSizePixel = 0
    KeyBox.ZIndex = 703; KeyBox.Parent = InputBg

    local EyeBtn = Instance.new("TextButton")
    EyeBtn.Size = UDim2.new(0,30,0,30); EyeBtn.Position = UDim2.new(1,-33,0.5,-15)
    EyeBtn.BackgroundTransparency = 1; EyeBtn.Text = "◉"
    EyeBtn.TextColor3 = T.SubText; EyeBtn.Font = Enum.Font.GothamBold
    EyeBtn.TextSize = 15; EyeBtn.ZIndex = 703; EyeBtn.Parent = InputBg

    KeyBox.Focused:Connect(function()
        Tween(iStroke,TweenInfo.new(0.14),{Color=T.Accent})
        Tween(InputBg,TweenInfo.new(0.14),{BackgroundColor3=T.BorderHi})
    end)
    KeyBox.FocusLost:Connect(function()
        Tween(iStroke,TweenInfo.new(0.14),{Color=T.Border})
        Tween(InputBg,TweenInfo.new(0.14),{BackgroundColor3=T.Tertiary})
    end)
    EyeBtn.MouseButton1Click:Connect(function()
        if EyeBtn.Text == "◉" then EyeBtn.Text = "⊘"; EyeBtn.TextColor3 = T.Accent
        else EyeBtn.Text = "◉"; EyeBtn.TextColor3 = T.SubText end
    end)

    -- ── 5. Error label ────────────────────────────
    local ErrLbl = Instance.new("TextLabel")
    ErrLbl.BackgroundTransparency = 1; ErrLbl.Text = ""
    ErrLbl.TextColor3 = T.Danger; ErrLbl.Font = Enum.Font.Gotham
    ErrLbl.TextSize = 11; ErrLbl.TextXAlignment = Enum.TextXAlignment.Left
    ErrLbl.ZIndex = 702
    PutPadded(ErrLbl, 16, 6)

    -- ── 6. Cancel + Submit row ────────────────────
    local BtnRow = Instance.new("Frame")
    BtnRow.BackgroundTransparency = 1; BtnRow.BorderSizePixel = 0; BtnRow.ZIndex = 702
    PutPadded(BtnRow, 38, 4)

    local CancelBtn = Instance.new("TextButton")
    CancelBtn.Size = UDim2.new(0.44,0,1,0); CancelBtn.Position = UDim2.new(0,0,0,0)
    CancelBtn.BackgroundColor3 = T.Tertiary; CancelBtn.Text = "Cancel"
    CancelBtn.TextColor3 = T.SubText; CancelBtn.Font = Enum.Font.GothamBold
    CancelBtn.TextSize = 13; CancelBtn.BorderSizePixel = 0; CancelBtn.ZIndex = 703; CancelBtn.Parent = BtnRow
    Corner(CancelBtn, 8); NewStroke(CancelBtn, T.Border)

    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.Size = UDim2.new(0.52,0,1,0); SubmitBtn.Position = UDim2.new(0.48,0,0,0)
    SubmitBtn.BackgroundColor3 = T.Accent; SubmitBtn.Text = "Submit Key"
    SubmitBtn.TextColor3 = T.Text; SubmitBtn.Font = Enum.Font.GothamBold
    SubmitBtn.TextSize = 13; SubmitBtn.BorderSizePixel = 0; SubmitBtn.ZIndex = 703; SubmitBtn.Parent = BtnRow
    Corner(SubmitBtn, 8)

    -- ── 7. Get Key button (optional) ──────────────
    if ks.URL and ks.URL ~= "" and ks.URL ~= "YOUR LINK TO GET KEY (Discord, Linkvertise, Pastebin, etc.)" then
        local GetBtn = Instance.new("TextButton")
        GetBtn.BackgroundColor3 = T.Bg; GetBtn.Text = "🔗  Get Key"
        GetBtn.TextColor3 = T.Accent; GetBtn.Font = Enum.Font.GothamBold
        GetBtn.TextSize = 12; GetBtn.BorderSizePixel = 0; GetBtn.ZIndex = 702
        PutPadded(GetBtn, 32, 8)
        Corner(GetBtn, 7); NewStroke(GetBtn, T.Accent)

        GetBtn.MouseEnter:Connect(function()
            Tween(GetBtn,TweenInfo.new(0.12),{BackgroundColor3=T.Accent,TextColor3=T.Text})
        end)
        GetBtn.MouseLeave:Connect(function()
            Tween(GetBtn,TweenInfo.new(0.12),{BackgroundColor3=T.Bg,TextColor3=T.Accent})
        end)
        GetBtn.MouseButton1Click:Connect(function()
            pcall(function()
                if setclipboard then setclipboard(ks.URL) end
            end)
        end)
    end

    yPos = yPos + 20  -- bottom padding

    -- ── finalize card size + animate in ───────────
    Card.Size = UDim2.new(0, CARD_W, 0, 0)
    Tween(Dim,  TweenInfo.new(0.22), {BackgroundTransparency=0.42})
    Tween(Card, TweenInfo.new(0.32,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
        {Size=UDim2.new(0,CARD_W,0,yPos)})

    -- ── button hover ──────────────────────────────
    CancelBtn.MouseEnter:Connect(function()
        Tween(CancelBtn,TweenInfo.new(0.12),{BackgroundColor3=T.BorderHi,TextColor3=T.Text})
    end)
    CancelBtn.MouseLeave:Connect(function()
        Tween(CancelBtn,TweenInfo.new(0.12),{BackgroundColor3=T.Tertiary,TextColor3=T.SubText})
    end)
    SubmitBtn.MouseEnter:Connect(function()
        Tween(SubmitBtn,TweenInfo.new(0.12),{BackgroundColor3=T.AccentHov})
    end)
    SubmitBtn.MouseLeave:Connect(function()
        Tween(SubmitBtn,TweenInfo.new(0.12),{BackgroundColor3=T.Accent})
    end)

    -- ── close helper ──────────────────────────────
    local function CloseCard(cb)
        Tween(Dim,  TweenInfo.new(0.18), {BackgroundTransparency=1})
        Tween(Card, TweenInfo.new(0.18,Enum.EasingStyle.Quad,Enum.EasingDirection.In),
            {Size=UDim2.new(0,CARD_W,0,0)})
        task.delay(0.22, function() Dim:Destroy(); if cb then cb() end end)
    end

    -- ── validation ────────────────────────────────
    local function Validate(raw)
        local k = raw:gsub("%s+","")
        for _,v in ipairs(ks.Key or {}) do
            if k == v then return true end
        end
        return false
    end

    local function OnSubmit()
        local raw = KeyBox.Text
        if raw == "" then ErrLbl.Text = "⚠  Please enter your key."; return end
        if Validate(raw) then
            ErrLbl.Text = ""
            SubmitBtn.Text = "✓  Access Granted"
            Tween(SubmitBtn,TweenInfo.new(0.2),{BackgroundColor3=T.Success})
            if ks.SaveKey then FSFolder(folder); FSWrite(folder.."/key.txt", raw:gsub("%s+","")) end
            task.delay(0.8, function() CloseCard(onSuccess) end)
        else
            ErrLbl.Text = "✕  Incorrect key. Please try again."
            Tween(InputBg,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(55,18,18)})
            task.delay(0.65,function() Tween(InputBg,TweenInfo.new(0.2),{BackgroundColor3=T.Tertiary}) end)
        end
    end

    CancelBtn.MouseButton1Click:Connect(function() CloseCard(onCancel) end)
    SubmitBtn.MouseButton1Click:Connect(OnSubmit)
    KeyBox.FocusLost:Connect(function(enter) if enter then OnSubmit() end end)
end

-- ═══════════════════════════════════════════
--  LIBRARY
-- ═══════════════════════════════════════════
local Library = {}
Library.__index = Library

function Library:CreateWindow(config)
    config = config or {}

    local T       = Themes[config.Theme] or Themes.Dark
    local W       = (config.Size or UDim2.fromOffset(560, 350)).X.Offset
    local H       = (config.Size or UDim2.fromOffset(550, 340)).Y.Offset
    local MINW    = config.MinSize and config.MinSize.X or 480
    local MINH    = config.MinSize and config.MinSize.Y or 320
    local MAXW    = config.MaxSize and config.MaxSize.X or 900
    local MAXH    = config.MaxSize and config.MaxSize.Y or 600
    local SIDEW   = config.SideBarWidth or 140
    local SCRBARS = config.ScrollBarEnabled ~= false
    local HIDESRCH= config.HideSearchBar == true

    BuildDropdown(T)

    -- ── Main Frame ─────────────────────────────────
    local Main = Instance.new("Frame")
    Main.Name = "MainWindow_ftgs"; Main.Size = UDim2.fromOffset(W, H)
    Main.Position = UDim2.new(0.5,-W/2, 0.5,-H/2)
    Main.BackgroundColor3 = T.Bg
    Main.BackgroundTransparency = config.Transparent and 0.06 or 0
    Main.BorderSizePixel = 0; Main.ClipsDescendants = true
    Main.Visible = false; Main.Parent = ScreenGui
    Corner(Main, 14); NewStroke(Main, T.Border); Shadow(Main, 0.44)

    -- ── Background ─────────────────────────────────
    if config.Background and config.Background ~= "" and config.Background ~= "rbxassetid://" then
        local bg    = config.Background
        local trans = config.BackgroundImageTransparency or 0.4
        if bg:sub(1,5) == "video" then
            local url = bg:match("^video:(.+)$") or ""
            local VF  = Instance.new("VideoFrame")
            VF.Size = UDim2.fromScale(1,1); VF.BackgroundTransparency = 1
            VF.Video = url; VF.Volume = 0; VF.Looped = true; VF.ZIndex = 0; VF.Parent = Main
            Corner(VF, 14)
            task.defer(function() pcall(function() VF:Play() end) end)
            local VO = Instance.new("Frame"); VO.Size = UDim2.fromScale(1,1)
            VO.BackgroundColor3 = T.Bg; VO.BackgroundTransparency = trans
            VO.BorderSizePixel = 0; VO.ZIndex = 1; VO.Parent = Main; Corner(VO, 14)
        else
            local IL = Instance.new("ImageLabel"); IL.Size = UDim2.fromScale(1,1)
            IL.BackgroundTransparency = 1; IL.Image = bg
            IL.ScaleType = Enum.ScaleType.Crop; IL.ImageTransparency = trans
            IL.ZIndex = 0; IL.Parent = Main; Corner(IL, 14)
        end
    end

    -- ── Title Bar ──────────────────────────────────
    local TBar = Instance.new("Frame")
    TBar.Size = UDim2.new(1,0,0,46); TBar.BackgroundColor3 = T.Secondary
    TBar.BorderSizePixel = 0; TBar.ZIndex = 2; TBar.Parent = Main; Corner(TBar, 14)
    local TBFix = Instance.new("Frame"); TBFix.Size = UDim2.new(1,0,0,14)
    TBFix.Position = UDim2.new(0,0,1,-14); TBFix.BackgroundColor3 = T.Secondary
    TBFix.BorderSizePixel = 0; TBFix.ZIndex = 2; TBFix.Parent = TBar

    local TPill = Instance.new("Frame"); TPill.Size = UDim2.new(0,3,0,22)
    TPill.Position = UDim2.new(0,14,0.5,-11); TPill.BackgroundColor3 = T.Accent
    TPill.BorderSizePixel = 0; TPill.ZIndex = 3; TPill.Parent = TBar; Corner(TPill, 2)

    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Size = UDim2.new(1,-180,1,0); TitleLbl.Position = UDim2.new(0,26,0,0)
    TitleLbl.BackgroundTransparency = 1; TitleLbl.Text = config.Title or "Hub"
    TitleLbl.TextColor3 = T.Text; TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 15; TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.ZIndex = 3; TitleLbl.Parent = TBar

    if config.Author and config.Author ~= "" then
        local Auth = Instance.new("TextLabel")
        Auth.Size = UDim2.new(0,156,1,0); Auth.Position = UDim2.new(1,-238,0,0)
        Auth.BackgroundTransparency = 1; Auth.Text = config.Author
        Auth.TextColor3 = T.SubText; Auth.Font = Enum.Font.Gotham; Auth.TextSize = 11
        Auth.TextXAlignment = Enum.TextXAlignment.Right; Auth.ZIndex = 3; Auth.Parent = TBar
    end

    local function CtrlBtn(xOff, bg, lbl, tsz)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0,26,0,26); b.Position = UDim2.new(1,xOff,0.5,-13)
        b.BackgroundColor3 = bg; b.Text = lbl; b.TextColor3 = T.Text
        b.Font = Enum.Font.GothamBold; b.TextSize = tsz or 11
        b.BorderSizePixel = 0; b.ZIndex = 3; b.Parent = TBar; Corner(b, 13)
        return b
    end
    local CloseBtn = CtrlBtn(-36, T.Danger,  "✕")
    local MiniBtn  = CtrlBtn(-68, T.Warning, "–", 16)

    MakeDraggable(Main, TBar)

    -- ── Resizable ──────────────────────────────────
    if config.Resizable then
        local function ResizeEdge(size, pos, rW, rH)
            local e = Instance.new("Frame"); e.Size = size; e.Position = pos
            e.BackgroundTransparency = 1; e.BorderSizePixel = 0; e.ZIndex = 10; e.Parent = Main
            local dragging, startP, startS = false, nil, nil
            e.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true; startP = i.Position; startS = Main.AbsoluteSize
                    i.Changed:Connect(function()
                        if i.UserInputState == Enum.UserInputState.End then dragging = false end
                    end)
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                    local d = i.Position - startP
                    local nw = rW and math.clamp(startS.X+d.X,MINW,MAXW) or startS.X
                    local nh = rH and math.clamp(startS.Y+d.Y,MINH,MAXH) or startS.Y
                    Main.Size = UDim2.fromOffset(nw, nh)
                end
            end)
        end
        ResizeEdge(UDim2.new(0,6,1,-46),  UDim2.new(1,-6,0,46),  true,  false)
        ResizeEdge(UDim2.new(1,-6,0,6),   UDim2.new(0,0,1,-6),   false, true )
        ResizeEdge(UDim2.new(0,12,0,12),  UDim2.new(1,-12,1,-12),true,  true )
    end

    -- ── Sidebar ────────────────────────────────────
    local SideFrame = Instance.new("Frame")
    SideFrame.Size = UDim2.new(0,SIDEW,1,-46); SideFrame.Position = UDim2.new(0,0,0,46)
    SideFrame.BackgroundColor3 = T.Secondary; SideFrame.BorderSizePixel = 0
    SideFrame.ZIndex = 2; SideFrame.Parent = Main

    -- optional search bar
    local searchQuery = ""
    local sideTopPad  = 8
    if not HIDESRCH then
        local SBar = Instance.new("Frame")
        SBar.Size = UDim2.new(1,-16,0,28); SBar.Position = UDim2.new(0,8,0,8)
        SBar.BackgroundColor3 = T.Tertiary; SBar.BorderSizePixel = 0; SBar.ZIndex = 3; SBar.Parent = SideFrame
        Corner(SBar, 7); NewStroke(SBar, T.Border)

        local SIco = Instance.new("TextLabel"); SIco.Size = UDim2.new(0,24,1,0)
        SIco.BackgroundTransparency = 1; SIco.Text = "⌕"
        SIco.TextColor3 = T.SubText; SIco.Font = Enum.Font.GothamBold
        SIco.TextSize = 14; SIco.ZIndex = 4; SIco.Parent = SBar

        local STB = Instance.new("TextBox"); STB.Size = UDim2.new(1,-28,1,-4); STB.Position = UDim2.new(0,24,0,2)
        STB.BackgroundTransparency = 1; STB.Text = ""
        STB.PlaceholderText = "Search tabs..."; STB.PlaceholderColor3 = T.SubText
        STB.TextColor3 = T.Text; STB.Font = Enum.Font.Gotham; STB.TextSize = 12
        STB.TextXAlignment = Enum.TextXAlignment.Left; STB.ClearTextOnFocus = false
        STB.BorderSizePixel = 0; STB.ZIndex = 4; STB.Parent = SBar
        STB:GetPropertyChangedSignal("Text"):Connect(function() searchQuery = STB.Text:lower() end)
        sideTopPad = 44
    end

    local SideV2 = ScrollV2(
        SideFrame,
        UDim2.new(1,0,1,-sideTopPad),
        UDim2.new(0,0,0,sideTopPad),
        {top=6,bottom=10,left=8,right=8}, 0, T.Accent)
    SideV2.Layout.Padding = UDim.new(0,4)

    -- sidebar bottom divider line
    local SDiv = Instance.new("Frame"); SDiv.Size = UDim2.new(0,1,1,-46)
    SDiv.Position = UDim2.new(0,SIDEW,0,46); SDiv.BackgroundColor3 = T.Border
    SDiv.BorderSizePixel = 0; SDiv.ZIndex = 2; SDiv.Parent = Main

    -- ── User Panel ─────────────────────────────────
    if config.User and config.User.Enabled then
        local UP = Instance.new("Frame"); UP.Name = "UserPanel"
        UP.Size = UDim2.new(0,SIDEW,0,56); UP.Position = UDim2.new(0,0,1,-56)
        UP.BackgroundColor3 = T.Secondary; UP.BorderSizePixel = 0; UP.ZIndex = 3; UP.Parent = Main

        local UPLine = Instance.new("Frame"); UPLine.Size = UDim2.new(1,0,0,1)
        UPLine.BackgroundColor3 = T.Border; UPLine.BorderSizePixel = 0; UPLine.ZIndex = 3; UPLine.Parent = UP

        local AVFrame = Instance.new("Frame"); AVFrame.Size = UDim2.new(0,34,0,34)
        AVFrame.Position = UDim2.new(0,10,0.5,-17); AVFrame.BackgroundColor3 = T.Tertiary
        AVFrame.BorderSizePixel = 0; AVFrame.ZIndex = 4; AVFrame.Parent = UP; Corner(AVFrame, 17)

        task.spawn(function()
            if not config.User.Anonymous then
                local ok, img = pcall(function()
                    return Players:GetUserThumbnailAsync(Player.UserId,
                        Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
                end)
                if ok and img then
                    local IL = Instance.new("ImageLabel"); IL.Size = UDim2.fromScale(1,1)
                    IL.BackgroundTransparency = 1; IL.Image = img; IL.ZIndex = 5; IL.Parent = AVFrame
                    Corner(IL, 17)
                end
            else
                local AL = Instance.new("TextLabel"); AL.Size = UDim2.fromScale(1,1)
                AL.BackgroundTransparency = 1; AL.Text = "?"
                AL.TextColor3 = T.SubText; AL.Font = Enum.Font.GothamBold
                AL.TextSize = 15; AL.ZIndex = 5; AL.Parent = AVFrame
            end
        end)

        local UName = Instance.new("TextLabel"); UName.Size = UDim2.new(1,-52,0,16)
        UName.Position = UDim2.new(0,50,0.5,-16); UName.BackgroundTransparency = 1
        UName.Text = config.User.Anonymous and "Anonymous" or Player.DisplayName
        UName.TextColor3 = T.Text; UName.Font = Enum.Font.GothamBold; UName.TextSize = 12
        UName.TextXAlignment = Enum.TextXAlignment.Left; UName.ZIndex = 4; UName.Parent = UP

        local UTag = Instance.new("TextLabel"); UTag.Size = UDim2.new(1,-52,0,13)
        UTag.Position = UDim2.new(0,50,0.5,2); UTag.BackgroundTransparency = 1
        UTag.Text = config.User.Anonymous and "Hidden" or "@"..Player.Name
        UTag.TextColor3 = T.SubText; UTag.Font = Enum.Font.Gotham; UTag.TextSize = 10
        UTag.TextXAlignment = Enum.TextXAlignment.Left; UTag.ZIndex = 4; UTag.Parent = UP

        if config.User.Callback then
            local UBtn = Instance.new("TextButton"); UBtn.Size = UDim2.fromScale(1,1)
            UBtn.BackgroundTransparency = 1; UBtn.Text = ""; UBtn.ZIndex = 5; UBtn.Parent = UP
            UBtn.MouseEnter:Connect(function() Tween(UP,TweenInfo.new(0.12),{BackgroundColor3=T.Tertiary}) end)
            UBtn.MouseLeave:Connect(function() Tween(UP,TweenInfo.new(0.12),{BackgroundColor3=T.Secondary}) end)
            UBtn.MouseButton1Click:Connect(function() task.spawn(config.User.Callback) end)
        end

        -- shrink sidebar scroll to fit above user panel
        SideV2.Wrapper.Size = UDim2.new(1,0,1,-(sideTopPad+56))
    end

    -- ── Content Area ───────────────────────────────
    local ContentArea = Instance.new("Frame"); ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1,-(SIDEW+8),1,-54)
    ContentArea.Position = UDim2.new(0,SIDEW+4,0,50)
    ContentArea.BackgroundTransparency = 1; ContentArea.BorderSizePixel = 0; ContentArea.Parent = Main

-- ── Minimize / Close ───────────────────────────
    local minimized = false
    MiniBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(Main,TweenInfo.new(0.22,Enum.EasingStyle.Quad),{Size=UDim2.fromOffset(W,46)})
        else
            local cw = Main.AbsoluteSize.X
            Tween(Main,TweenInfo.new(0.28,Enum.EasingStyle.Back),{Size=UDim2.fromOffset(cw,H)})
        end
    end)
    
    -- UPDATED CLOSE BUTTON LOGIC:
    CloseBtn.MouseButton1Click:Connect(function()
        -- Animate the window shrinking and fading away
        Tween(Main,TweenInfo.new(0.18,Enum.EasingStyle.Quad),{Size=UDim2.fromOffset(W,0), BackgroundTransparency=1})
        
        -- Destroy the entire ScreenGui after the animation finishes
        task.delay(0.2, function() 
            ScreenGui:Destroy() 
        end)
    end)

    -- ── ToggleKey ──────────────────────────────────
    if config.ToggleKey then
        UserInputService.InputBegan:Connect(function(i, gpe)
            if gpe then return end
            if i.KeyCode == config.ToggleKey then
                if Main.Visible then
                    Tween(Main,TweenInfo.new(0.18,Enum.EasingStyle.Quad),{Size=UDim2.fromOffset(W,0)})
                    task.delay(0.2, function() Main.Visible = false end)
                else
                    Main.Size = UDim2.fromOffset(W,0); Main.Visible = true; minimized = false
                    Tween(Main,TweenInfo.new(0.3,Enum.EasingStyle.Back),{Size=UDim2.fromOffset(W,H)})
                end
            end
        end)
    end

    -- ── Tab system ─────────────────────────────────
    local allTabs   = {}
    local activeTab = nil

    local function SetActiveTab(entry)
        if activeTab then
            Tween(activeTab.Btn,TweenInfo.new(0.15),{BackgroundColor3=T.Tertiary})
            activeTab.Btn.TextColor3 = T.SubText; activeTab.Btn.Font = Enum.Font.Gotham
            activeTab.Wrapper.Visible = false
        end
        activeTab = entry
        Tween(entry.Btn,TweenInfo.new(0.15),{BackgroundColor3=T.Accent})
        entry.Btn.TextColor3 = T.Text; entry.Btn.Font = Enum.Font.GothamBold
        entry.Wrapper.Visible = true
    end

    -- ════════════════════════════════════════════
    --   WINDOW OBJECT
    -- ════════════════════════════════════════════
    local WindowObj = {}

    function WindowObj:CreateMinimizeBtn(cfg)
        cfg = cfg or {}
        local label = cfg.Title or "Open UI"
        local clrs  = {Red=T.Danger,Green=T.Success,Blue=T.Blue,Purple=T.Accent,Yellow=T.Warning,Orange=T.Orange}
        local bg    = clrs[cfg.Color] or T.Accent

        local FB = Instance.new("TextButton"); FB.Name = "FloatBtn"
        FB.Size = UDim2.fromOffset(118,34); FB.Position = UDim2.new(0,16,0.5,70)
        FB.BackgroundColor3 = bg; FB.Text = label; FB.TextColor3 = T.Text
        FB.Font = Enum.Font.GothamBold; FB.TextSize = 12
        FB.BorderSizePixel = 0; FB.ZIndex = 50; FB.Parent = ScreenGui; Corner(FB, 9)
        local FBStr = Instance.new("UIStroke"); FBStr.Color = Color3.fromRGB(255,255,255)
        FBStr.Transparency = 0.78; FBStr.Thickness = 1; FBStr.Parent = FB
        MakeDraggable(FB)

        local vis = true
        FB.MouseButton1Click:Connect(function()
            vis = not vis
            if vis then
                Main.Size = UDim2.fromOffset(W,0); Main.Visible = true; minimized = false
                Tween(Main,TweenInfo.new(0.3,Enum.EasingStyle.Back),{Size=UDim2.fromOffset(W,H)})
                FB.Text = "Hide UI"
            else
                Tween(Main,TweenInfo.new(0.18,Enum.EasingStyle.Quad),{Size=UDim2.fromOffset(W,0)})
                task.delay(0.2, function() Main.Visible = false; FB.Text = label end)
            end
        end)
        FB.MouseEnter:Connect(function()
            Tween(FB,TweenInfo.new(0.12),{BackgroundColor3=Color3.new(math.min(bg.R*1.18,1),math.min(bg.G*1.18,1),math.min(bg.B*1.18,1))})
        end)
        FB.MouseLeave:Connect(function() Tween(FB,TweenInfo.new(0.12),{BackgroundColor3=bg}) end)
        return FB
    end

    function WindowObj:Tab(cfg)
        cfg = cfg or {}
        local tabName = cfg.Title  or "Tab"
        local locked  = cfg.Locked or false

        local TabBtn = Instance.new("TextButton"); TabBtn.Size = UDim2.new(1,0,0,34)
        TabBtn.BackgroundColor3 = T.Tertiary
        TabBtn.Text = (locked and "🔒  " or "  ")..tabName
        TabBtn.TextColor3 = T.SubText; TabBtn.Font = Enum.Font.Gotham; TabBtn.TextSize = 12
        TabBtn.BorderSizePixel = 0; TabBtn.LayoutOrder = #allTabs+1; TabBtn.Parent = SideV2.Scroll
        Corner(TabBtn, 8)

        local TabV2 = ScrollV2(ContentArea, UDim2.fromScale(1,1), UDim2.fromScale(0,0),
            {top=4,bottom=16,left=4,right=6}, SCRBARS and 4 or 0, T.Accent)
        TabV2.Wrapper.Visible = false

        local entry = {Btn=TabBtn, Wrapper=TabV2.Wrapper, Scroll=TabV2.Scroll}
        table.insert(allTabs, entry)
        if #allTabs == 1 then SetActiveTab(entry) end

        TabBtn.MouseButton1Click:Connect(function()
            if not locked then SetActiveTab(entry) end
        end)
        TabBtn.MouseEnter:Connect(function()
            if activeTab ~= entry and not locked then Tween(TabBtn,TweenInfo.new(0.12),{BackgroundColor3=T.Border}) end
        end)
        TabBtn.MouseLeave:Connect(function()
            if activeTab ~= entry then Tween(TabBtn,TweenInfo.new(0.12),{BackgroundColor3=T.Tertiary}) end
        end)

        -- live search filter
        task.spawn(function()
            while TabBtn and TabBtn.Parent do
                TabBtn.Visible = searchQuery=="" or tabName:lower():find(searchQuery,1,true)~=nil
                task.wait(0.15)
            end
        end)

        -- ── element helpers ─────────────────────
        local function NewElem(h)
            local f = Instance.new("Frame"); f.Size = UDim2.new(1,0,0,h)
            f.BackgroundColor3 = T.Elem; f.BorderSizePixel = 0; f.Parent = TabV2.Scroll
            Corner(f, 10); return f
        end

        local function Labels(parent, title, desc, ox)
            ox = ox or 0; local hasD = desc and desc ~= ""
            local tl = Instance.new("TextLabel")
            tl.Size = UDim2.new(1,-118-ox,0,16)
            tl.Position = UDim2.new(0,12+ox,0.5,hasD and -11 or -8)
            tl.BackgroundTransparency = 1; tl.Text = title
            tl.TextColor3 = T.Text; tl.Font = Enum.Font.GothamBold; tl.TextSize = 13
            tl.TextXAlignment = Enum.TextXAlignment.Left; tl.Parent = parent
            if hasD then
                local dl = Instance.new("TextLabel")
                dl.Size = UDim2.new(1,-118-ox,0,13)
                dl.Position = UDim2.new(0,12+ox,0.5,3)
                dl.BackgroundTransparency = 1; dl.Text = desc
                dl.TextColor3 = T.SubText; dl.Font = Enum.Font.Gotham; dl.TextSize = 11
                dl.TextXAlignment = Enum.TextXAlignment.Left; dl.Parent = parent
            end
        end

        local Elem = {}

        -- BUTTON
        function Elem:Button(cfg)
            cfg = cfg or {}; local lk = cfg.Locked or false
            local e = NewElem(52); Labels(e, cfg.Title or "Button", cfg.Desc or "")
            local Btn = Instance.new("TextButton"); Btn.Size = UDim2.new(0,68,0,28)
            Btn.Position = UDim2.new(1,-78,0.5,-14)
            Btn.BackgroundColor3 = lk and T.Border or T.Accent
            Btn.Text = lk and "🔒" or "Run"; Btn.TextColor3 = T.Text
            Btn.Font = Enum.Font.GothamBold; Btn.TextSize = 12
            Btn.BorderSizePixel = 0; Btn.Parent = e; Corner(Btn, 8)
            if not lk then
                Btn.MouseEnter:Connect(function() Tween(Btn,TweenInfo.new(0.12),{BackgroundColor3=T.AccentHov}) end)
                Btn.MouseLeave:Connect(function() Tween(Btn,TweenInfo.new(0.12),{BackgroundColor3=T.Accent}) end)
                Btn.MouseButton1Click:Connect(function()
                    Tween(Btn,TweenInfo.new(0.07),{BackgroundColor3=T.Text})
                    task.delay(0.14,function() Tween(Btn,TweenInfo.new(0.15),{BackgroundColor3=T.Accent}) end)
                    if cfg.Callback then task.spawn(cfg.Callback) end
                end)
            end
            return {SetLocked=function(v) lk=v; Btn.BackgroundColor3=v and T.Border or T.Accent; Btn.Text=v and "🔒" or "Run" end}
        end

        -- DROPDOWN
        function Elem:Dropdown(cfg)
            cfg = cfg or {}; local vals = cfg.Values or {}; local cur = cfg.Value or (vals[1] or "None")
            local e = NewElem(52); Labels(e, cfg.Title or "Dropdown", cfg.Desc or "")
            local DBtn = Instance.new("TextButton"); DBtn.Size = UDim2.new(0,124,0,28)
            DBtn.Position = UDim2.new(1,-134,0.5,-14); DBtn.BackgroundColor3 = T.Tertiary
            DBtn.Text = cur.."  ▾"; DBtn.TextColor3 = T.Text; DBtn.Font = Enum.Font.Gotham
            DBtn.TextSize = 12; DBtn.BorderSizePixel = 0; DBtn.ClipsDescendants = true
            DBtn.Parent = e; Corner(DBtn, 8)
            local dStr = NewStroke(DBtn, T.Border)
            DBtn.MouseEnter:Connect(function()
                Tween(DBtn,TweenInfo.new(0.12),{BackgroundColor3=T.BorderHi})
                Tween(dStr,TweenInfo.new(0.12),{Color=T.Accent})
            end)
            DBtn.MouseLeave:Connect(function()
                Tween(DBtn,TweenInfo.new(0.12),{BackgroundColor3=T.Tertiary})
                Tween(dStr,TweenInfo.new(0.12),{Color=T.Border})
            end)
            DBtn.MouseButton1Click:Connect(function()
                OpenDropdown(T, cfg.Title or "Select", vals, cur, function(val)
                    cur=val; DBtn.Text=val.."  ▾"
                    if cfg.Callback then task.spawn(cfg.Callback,val) end
                end)
            end)
            return {
                SetValue  = function(v) cur=v; DBtn.Text=v.."  ▾" end,
                GetValue  = function() return cur end,
                SetValues = function(nv) vals=nv; if not table.find(vals,cur) then cur=vals[1] or "None"; DBtn.Text=cur.."  ▾" end end,
            }
        end

        -- TOGGLE
        function Elem:Toggle(cfg)
            cfg = cfg or {}; local state = cfg.Value or false
            local e = NewElem(52); Labels(e, cfg.Title or "Toggle", cfg.Desc or "")
            local Track = Instance.new("Frame"); Track.Size = UDim2.new(0,46,0,24)
            Track.Position = UDim2.new(1,-58,0.5,-12)
            Track.BackgroundColor3 = state and T.Accent or T.Border
            Track.BorderSizePixel = 0; Track.Parent = e; Corner(Track, 12)
            local Knob = Instance.new("Frame"); Knob.Size = UDim2.new(0,18,0,18)
            Knob.AnchorPoint = Vector2.new(0,0.5)
            Knob.Position = state and UDim2.new(0,25,0.5,0) or UDim2.new(0,3,0.5,0)
            Knob.BackgroundColor3 = T.Text; Knob.BorderSizePixel = 0; Knob.ZIndex = 2; Knob.Parent = Track
            Corner(Knob, 9)
            local Click = Instance.new("TextButton"); Click.Size = UDim2.fromScale(1,1)
            Click.BackgroundTransparency = 1; Click.Text = ""; Click.ZIndex = 3; Click.Parent = Track
            local function Apply(v)
                state = v
                Tween(Track,TweenInfo.new(0.2),{BackgroundColor3=v and T.Accent or T.Border})
                Tween(Knob,TweenInfo.new(0.22,Enum.EasingStyle.Back),
                    {Position=v and UDim2.new(0,25,0.5,0) or UDim2.new(0,3,0.5,0)})
            end
            Click.MouseButton1Click:Connect(function() Apply(not state); if cfg.Callback then task.spawn(cfg.Callback,state) end end)
            return {SetValue=Apply, GetValue=function() return state end}
        end

        -- SLIDER  (RunService.Heartbeat — never locks)
        function Elem:Slider(cfg)
            cfg = cfg or {}; local vc = cfg.Value or {}
            local mn = vc.Min or 0; local mx = vc.Max or 100
            local def = vc.Default or mn; local stp = cfg.Step or 1
            local cur = math.clamp(def,mn,mx)
            local e = NewElem(72)

            local TL = Instance.new("TextLabel"); TL.Size = UDim2.new(1,-92,0,16)
            TL.Position = UDim2.new(0,12,0,9); TL.BackgroundTransparency = 1
            TL.Text = cfg.Title or "Slider"; TL.TextColor3 = T.Text
            TL.Font = Enum.Font.GothamBold; TL.TextSize = 13
            TL.TextXAlignment = Enum.TextXAlignment.Left; TL.Parent = e

            local VL = Instance.new("TextLabel"); VL.Size = UDim2.new(0,76,0,16)
            VL.Position = UDim2.new(1,-86,0,9); VL.BackgroundTransparency = 1
            VL.Text = tostring(cur); VL.TextColor3 = T.Accent
            VL.Font = Enum.Font.GothamBold; VL.TextSize = 13
            VL.TextXAlignment = Enum.TextXAlignment.Right; VL.Parent = e

            if cfg.Desc and cfg.Desc ~= "" then
                local DL = Instance.new("TextLabel"); DL.Size = UDim2.new(1,-92,0,13)
                DL.Position = UDim2.new(0,12,0,28); DL.BackgroundTransparency = 1
                DL.Text = cfg.Desc; DL.TextColor3 = T.SubText; DL.Font = Enum.Font.Gotham
                DL.TextSize = 11; DL.TextXAlignment = Enum.TextXAlignment.Left; DL.Parent = e
            end

            local TrBg = Instance.new("Frame"); TrBg.Size = UDim2.new(1,-24,0,6)
            TrBg.Position = UDim2.new(0,12,1,-17); TrBg.BackgroundColor3 = T.Tertiary
            TrBg.BorderSizePixel = 0; TrBg.Parent = e; Corner(TrBg,3)

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((cur-mn)/(mx-mn),0,1,0)
            Fill.BackgroundColor3 = T.Accent; Fill.BorderSizePixel = 0; Fill.Parent = TrBg; Corner(Fill,3)
            local FG = Instance.new("UIGradient"); FG.Color = ColorSequence.new(T.AccentDim,T.AccentHov); FG.Parent = Fill

            local Knob = Instance.new("Frame"); Knob.Size = UDim2.new(0,16,0,16)
            Knob.AnchorPoint = Vector2.new(0.5,0.5)
            Knob.Position = UDim2.new((cur-mn)/(mx-mn),0,0.5,0)
            Knob.BackgroundColor3 = T.Text; Knob.BorderSizePixel = 0; Knob.ZIndex = 3; Knob.Parent = TrBg
            Corner(Knob,8)

            local Hit = Instance.new("TextButton"); Hit.Size = UDim2.new(1,10,0,32)
            Hit.Position = UDim2.new(0,-5,0.5,-16); Hit.BackgroundTransparency = 1
            Hit.Text = ""; Hit.ZIndex = 4; Hit.Parent = TrBg

            local function Snap(r)
                local v = stp>=1 and math.round(r/stp)*stp or math.round(r*(1/stp))/(1/stp)
                return math.clamp(v,mn,mx)
            end
            local function Apply(v)
                cur=v; local p=(cur-mn)/(mx-mn)
                Fill.Size=UDim2.new(p,0,1,0); Knob.Position=UDim2.new(p,0,0.5,0); VL.Text=tostring(cur)
            end
            local function ToVal(mx2)
                local tx=TrBg.AbsolutePosition.X; local tw=TrBg.AbsoluteSize.X
                if tw<=0 then return cur end
                return Snap(mn+(mx-mn)*math.clamp((mx2-tx)/tw,0,1))
            end

            local isDrag=false; local hb=nil
            local function StartDrag()
                isDrag=true; Tween(Knob,TweenInfo.new(0.08),{Size=UDim2.new(0,20,0,20)})
                if hb then hb:Disconnect() end
                hb = RunService.Heartbeat:Connect(function()
                    if not isDrag then hb:Disconnect(); hb=nil; return end
                    local mp = UserInputService:GetMouseLocation()
                    local nv = ToVal(mp.X)
                    if nv~=cur then Apply(nv); if cfg.Callback then task.spawn(cfg.Callback,cur) end end
                end)
            end
            local function StopDrag()
                if not isDrag then return end; isDrag=false
                Tween(Knob,TweenInfo.new(0.1),{Size=UDim2.new(0,16,0,16)})
                if hb then hb:Disconnect(); hb=nil end
            end

            Hit.MouseButton1Down:Connect(function()
                local mp=UserInputService:GetMouseLocation(); Apply(ToVal(mp.X))
                if cfg.Callback then task.spawn(cfg.Callback,cur) end; StartDrag()
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 then StopDrag() end
            end)
            TrBg.MouseEnter:Connect(function()
                if not isDrag then Tween(Knob,TweenInfo.new(0.12),{BackgroundColor3=T.AccentHov}) end
            end)
            TrBg.MouseLeave:Connect(function()
                if not isDrag then Tween(Knob,TweenInfo.new(0.12),{BackgroundColor3=T.Text}) end
            end)
            return {SetValue=function(v) Apply(math.clamp(v,mn,mx)) end, GetValue=function() return cur end}
        end

        -- INPUT / TEXTAREA
        function Elem:Input(cfg)
            cfg = cfg or {}; local isTA = cfg.Type=="Textarea"; local h = isTA and 84 or 52
            local e = NewElem(h); Labels(e, cfg.Title or "Input", cfg.Desc or "")
            local IBg = Instance.new("Frame")
            IBg.Size = UDim2.new(0,158,0,isTA and 60 or 28)
            IBg.Position = UDim2.new(1,-168,0.5,isTA and -30 or -14)
            IBg.BackgroundColor3 = T.Tertiary; IBg.BorderSizePixel = 0; IBg.Parent = e; Corner(IBg,8)
            local iStr = NewStroke(IBg,T.Border)
            local TB = Instance.new("TextBox"); TB.Size = UDim2.new(1,-12,1,-6); TB.Position = UDim2.new(0,6,0,3)
            TB.BackgroundTransparency = 1; TB.Text = cfg.Value or ""
            TB.PlaceholderText = cfg.Placeholder or "Enter text..."; TB.PlaceholderColor3 = T.SubText
            TB.TextColor3 = T.Text; TB.Font = Enum.Font.Gotham; TB.TextSize = 12
            TB.TextXAlignment = Enum.TextXAlignment.Left
            TB.TextYAlignment = isTA and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center
            TB.TextWrapped = isTA; TB.MultiLine = isTA; TB.ClearTextOnFocus = false
            TB.BorderSizePixel = 0; TB.Parent = IBg
            TB.Focused:Connect(function()
                Tween(iStr,TweenInfo.new(0.15),{Color=T.Accent}); Tween(IBg,TweenInfo.new(0.15),{BackgroundColor3=T.BorderHi})
            end)
            TB.FocusLost:Connect(function()
                Tween(iStr,TweenInfo.new(0.15),{Color=T.Border}); Tween(IBg,TweenInfo.new(0.15),{BackgroundColor3=T.Tertiary})
                if cfg.Callback then task.spawn(cfg.Callback,TB.Text) end
            end)
            return {SetValue=function(v) TB.Text=v end, GetValue=function() return TB.Text end}
        end

        -- SECTION DIVIDER
        function Elem:Section(text)
            local w = Instance.new("Frame"); w.Size = UDim2.new(1,0,0,26)
            w.BackgroundTransparency = 1; w.BorderSizePixel = 0; w.Parent = TabV2.Scroll
            local line = Instance.new("Frame"); line.Size = UDim2.new(1,-16,0,1)
            line.Position = UDim2.new(0,8,0.5,0); line.BackgroundColor3 = T.Border
            line.BorderSizePixel = 0; line.Parent = w
            local bg2 = Instance.new("Frame"); bg2.Position = UDim2.new(0,12,0,4)
            bg2.Size = UDim2.new(0,0,0,18); bg2.AutomaticSize = Enum.AutomaticSize.X
            bg2.BackgroundColor3 = T.Bg; bg2.BorderSizePixel = 0; bg2.Parent = w
            local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(0,0,1,0)
            lbl.AutomaticSize = Enum.AutomaticSize.X; lbl.BackgroundTransparency = 1
            lbl.Text = "  "..(text or "Section").."  "; lbl.TextColor3 = T.Accent
            lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 11; lbl.Parent = bg2
            return lbl
        end

        return Elem
    end -- :Tab()

    -- show main window
    local function ShowMain()
        Main.Size = UDim2.fromOffset(W, 0); Main.Visible = true
        Tween(Main, TweenInfo.new(0.32,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
            {Size=UDim2.fromOffset(W,H)})
    end

    -- ── Key System gate ────────────────────────────
    if config.KeySystem then
        ShowKeySystem(config, T, ShowMain, function()
            -- cancelled — destroy everything
            Main:Destroy()
            ScreenGui:Destroy()
        end)
    else
        ShowMain()
    end

    return WindowObj
end -- :CreateWindow()

return Library
