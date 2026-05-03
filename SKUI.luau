--[[
╔══════════════════════════════════════════════════════════════════╗
║                  ftgs UI Library  v3.4                           ║
║  Built-in Icons · Key System · Themes · Resizable · Refresh     ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  Icons are now BUILT-IN — no separate IconModule load needed!    ║
║                                                                  ║
║  local WindUI = loadstring(game:HttpGet("LIB_RAW_URL"))()        ║
║                                                                  ║
║  -- Optional: override the built-in icon module                  ║
║  -- WindUI:SetIconModule(YourCustomIconModule)                    ║
║                                                                  ║
║  -- Optional: switch icon pack (default = "lucide")              ║
║  -- WindUI:SetIconsType("solar")  -- lucide|solar|craft|         ║
║  --                                  geist|sfsymbols|gravity     ║
║                                                                  ║
║  local Window = WindUI:CreateWindow({                            ║
║      Title   = "My Super Hub",                                   ║
║      Icon    = "layout-dashboard", -- any lucide icon name       ║
║      Author  = "by .ftgs and .ftgs",                             ║
║      Folder  = "MySuperHub",                                     ║
║                                                                  ║
║      -- optional ↓                                               ║
║      Size        = UDim2.fromOffset(580, 460),                   ║
║      MinSize     = Vector2.new(560, 350),                        ║
║      MaxSize     = Vector2.new(850, 560),                        ║
║      ToggleKey   = Enum.KeyCode.LeftShift,                       ║
║      Transparent = true,                                         ║
║      Theme       = "Dark",  -- "Dark" | "Light" | "Midnight"    ║
║      Resizable   = true,                                         ║
║      SideBarWidth= 160,                                          ║
║      BackgroundImageTransparency = 0.42,                         ║
║      HideSearchBar    = false,                                   ║
║      ScrollBarEnabled = true,                                    ║
║      Background  = "rbxassetid://",                              ║
║      -- Background = "video:RAW_URL.webm",                       ║
║                                                                  ║
║      User = {                                                     ║
║          Enabled   = true,                                       ║
║          Anonymous = false,                                      ║
║          Callback  = function() print("clicked") end,            ║
║      },                                                          ║
║                                                                  ║
║      KeySystem = {                                               ║
║          Key       = { "1234", "5678" },                         ║
║          Title     = "Key System",                               ║
║          Note      = "Join discord to get your key.",            ║
║          Thumbnail = { Image="rbxassetid://", Title="My Hub" },  ║
║          URL       = "https://discord.gg/example",               ║
║          SaveKey   = true,                                       ║
║      },                                                          ║
║  })                                                              ║
║                                                                  ║
║  -- MinimizeBtn now supports full styling + EditMinimizeBtn  ✅  ║
║  local MinBtn = Window:CreateMinimizeBtn({                       ║
║      Title          = "Open UI",                                 ║
║      Icon           = "monitor",     -- lucide icon  ✅         ║
║      Color          = ColorSequence.new(   -- gradient  ✅       ║
║                           Color3.fromHex("FF0F7B"),              ║
║                           Color3.fromHex("F89B29")),             ║
║      -- Color = "Purple" | Color3.new() also accepted            ║
║      CornerRadius   = UDim.new(0,16),  -- ✅                    ║
║      StrokeThickness= 2,               -- ✅                    ║
║      OnlyMobile     = false,  -- hide on non-touch devices  ✅   ║
║      Enabled        = true,            -- ✅                    ║
║      Draggable      = true,            -- ✅                    ║
║  })                                                              ║
║                                                                  ║
║  -- Edit any property after creation  ✅                         ║
║  Window:EditMinimizeBtn({                                        ║
║      Title          = "Open Example UI",                         ║
║      Icon           = "layout-dashboard",                        ║
║      Color          = ColorSequence.new(                         ║
║                           Color3.fromHex("FF0F7B"),              ║
║                           Color3.fromHex("F89B29")),             ║
║      CornerRadius   = UDim.new(0,16),                            ║
║      StrokeThickness= 2,                                         ║
║      OnlyMobile     = false,                                     ║
║      Enabled        = true,                                      ║
║      Draggable      = true,                                      ║
║  })                                                              ║
║                                                                  ║
║  -- KeySystem: MinimizeBtn stays hidden until key accepted  ✅   ║
║  -- Clicking MinBtn opens/closes the UI (normal animation).      ║
║  -- Title bar ✕ now DESTROYS everything (ScreenGui:Destroy).     ║
║  -- Title bar – still collapses/restores the window height.      ║
║  -- ToggleKey synced to same open/close state as MinBtn.         ║
║                                                                  ║
║  -- Tab with optional Icon                                       ║
║  local Tab1 = Window:Tab({ Title="Home",    Icon="house"      }) ║
║  local Tab2 = Window:Tab({ Title="Combat",  Icon="sword"      }) ║
║  local Tab3 = Window:Tab({ Title="Settings",Icon="settings"   }) ║
║  local Tab4 = Window:Tab({ Title="Admin",   Icon="shield",       ║
║                            Locked=true })                        ║
║                                                                  ║
║  Tab1:Section("General")                                         ║
║                                                                  ║
║  Tab1:Button({ Title="Click Me", Desc="Runs the script",         ║
║      Locked=false, Callback=function() end })                    ║
║                                                                  ║
║  local DD = Tab1:Dropdown({ Title="Mode", Desc="Pick mode",      ║
║      Values={"A","B","C"}, Value="A",                            ║
║      Callback=function(v) end })                                 ║
║  DD:SetValue("B")  |  DD:GetValue()                              ║
║                                                                  ║
║  -- Toggle now supports a left-side Icon  ✅                     ║
║  local Tog = Tab1:Toggle({ Title="Auto Farm", Desc="Enable",     ║
║      Icon="zap", Value=false,                -- Icon  ✅         ║
║      Callback=function(s) end })                                 ║
║  Tog:SetValue(true)  |  Tog:GetValue()                           ║
║                                                                  ║
║  local Sld = Tab1:Slider({ Title="Speed", Desc="Walk speed",     ║
║      Step=1, Value={Min=0,Max=100,Default=50},                   ║
║      Locked=false,   -- optional: locks value from user input    ║
║      Callback=function(v) end })                                 ║
║  Sld:SetValue(75)    Sld:GetValue()                              ║
║  Sld:SetLocked(true) Sld:SetLocked(false)                        ║
║                                                                  ║
║  -- :Refresh() works on ALL elements  ✅                         ║
║  DD:Refresh({ "New Category A", "New Category B" })              ║
║  Tog:Refresh({ Value=true, Title="New Title" })                  ║
║  Btn:Refresh({ Title="New", Desc="New desc", Locked=false })     ║
║  Sld:Refresh({ Min=0, Max=200, Default=100 })                    ║
║                                                                  ║
║  -- Key System: two-column card (Thumbnail left, form right)     ║
║  -- Copy URL button appears in middle when URL is set            ║
║  -- Standalone usage:                                            ║
║  WindUI:ShowKeySystem({                                          ║
║      KeySystem = { Key={"abc"}, Title="Key", URL="...",          ║
║                   Note="Get key on discord.",                    ║
║                   Thumbnail={Image="rbxassetid://",Title="Hub"}, ║
║                   SaveKey=true },                                ║
║      Folder = "MyHub",                                           ║
║  }, function() print("success") end,                             ║
║     function() print("cancel") end )                             ║
║                                                                  ║
║  -- Resizable=true shows visible drag bars on right + bottom     ║
║  local Inp = Tab1:Input({                                        ║
║      Title       = "Player Name",                                ║
║      Desc        = "Target player",                              ║
║      Icon        = "user",    -- icon left of title  ✅          ║
║      InputIcon   = "search",  -- icon inside the input box  ✅   ║
║      Value       = "Default value",                              ║
║      Type        = "Input",   -- "Input" | "Textarea"            ║
║      Placeholder = "Enter text...",                              ║
║      Callback    = function(t) print(t) end,                     ║
║  })                                                              ║
║  Inp:SetValue("hello")  |  Inp:GetValue()                        ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
--]]

-- ═══════════════════════════════════════════════
--  SERVICES
-- ═══════════════════════════════════════════════
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local Player           = Players.LocalPlayer

-- ═══════════════════════════════════════════════
--  ICON MODULE  (built-in — lucide/solar/craft/geist/sfsymbols/gravity)
-- ═══════════════════════════════════════════════
local _cloneref   = (cloneref or clonereference or function(i) return i end)
local _HttpSvc    = _cloneref(game:GetService("HttpService"))

local function _IconGet(url)
    if writefile and game.HttpGet then
        return game:HttpGet(url)
    else
        return _HttpSvc:GetAsync(url)
    end
end

local function _parseIconString(iconString)
    if type(iconString) == "string" then
        local splitIndex = iconString:find(":")
        if splitIndex then
            local iconType = iconString:sub(1, splitIndex - 1)
            local iconName = iconString:sub(splitIndex + 1)
            return iconType, iconName
        end
    end
    return nil, iconString
end

local IconModule = {
    IconsType    = "lucide",
    New          = nil,
    IconThemeTag = nil,
    Icons        = {
        lucide    = loadstring(_IconGet("https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/lucide/dist/Icons.lua"))(),
        solar     = loadstring(_IconGet("https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/solar/dist/Icons.lua"))(),
        craft     = loadstring(_IconGet("https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/craft/dist/Icons.lua"))(),
        geist     = loadstring(_IconGet("https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/geist/dist/Icons.lua"))(),
        sfsymbols = loadstring(_IconGet("https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/sfsymbols/dist/Icons.lua"))(),
        gravity   = loadstring(_IconGet("https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/gravity/dist/Icons.lua"))(),
    },
}

function IconModule.AddIcons(packName, iconsData)
    if type(packName) ~= "string" or type(iconsData) ~= "table" then
        error("AddIcons: packName must be string, iconsData must be table")
        return
    end
    if not IconModule.Icons[packName] then
        IconModule.Icons[packName] = { Icons = {}, Spritesheets = {} }
    end
    for iconName, iconValue in pairs(iconsData) do
        if type(iconValue) == "number" or (type(iconValue) == "string" and iconValue:match("^rbxassetid://")) then
            local imageId = iconValue
            if type(iconValue) == "number" then
                imageId = "rbxassetid://" .. tostring(iconValue)
            end
            IconModule.Icons[packName].Icons[iconName] = {
                Image             = imageId,
                ImageRectSize     = Vector2.new(0, 0),
                ImageRectPosition = Vector2.new(0, 0),
                Parts             = nil,
            }
            IconModule.Icons[packName].Spritesheets[imageId] = imageId
        elseif type(iconValue) == "table" then
            if iconValue.Image and iconValue.ImageRectSize and iconValue.ImageRectPosition then
                local imageId = iconValue.Image
                if type(imageId) == "number" then
                    imageId = "rbxassetid://" .. tostring(imageId)
                end
                IconModule.Icons[packName].Icons[iconName] = {
                    Image             = imageId,
                    ImageRectSize     = iconValue.ImageRectSize,
                    ImageRectPosition = iconValue.ImageRectPosition,
                    Parts             = iconValue.Parts,
                }
                if not IconModule.Icons[packName].Spritesheets[imageId] then
                    IconModule.Icons[packName].Spritesheets[imageId] = imageId
                end
            else
                warn("AddIcons: Invalid spritesheet data format for icon '" .. iconName .. "'")
            end
        else
            warn("AddIcons: Unsupported data type for icon '" .. iconName .. "': " .. type(iconValue))
        end
    end
end

function IconModule.SetIconsType(iconType)
    IconModule.IconsType = iconType
end

function IconModule.Init(New, IconThemeTag)
    IconModule.New          = New
    IconModule.IconThemeTag = IconThemeTag
    return IconModule
end

function IconModule.Icon(Icon, Type, DefaultFormat)
    DefaultFormat = DefaultFormat ~= false
    local iconType, iconName = _parseIconString(Icon)
    local targetType = iconType or Type or IconModule.IconsType
    local targetName = iconName
    local iconSet    = IconModule.Icons[targetType]

    if iconSet and iconSet.Icons and iconSet.Icons[targetName] then
        return {
            iconSet.Spritesheets[tostring(iconSet.Icons[targetName].Image)],
            iconSet.Icons[targetName],
        }
    elseif iconSet and iconSet[targetName] and string.find(iconSet[targetName], "rbxassetid://") then
        return DefaultFormat
            and {
                iconSet[targetName],
                { ImageRectSize = Vector2.new(0, 0), ImageRectPosition = Vector2.new(0, 0) },
            }
            or iconSet[targetName]
    end
    return nil
end

function IconModule.GetIcon(Icon, Type)
    return IconModule.Icon(Icon, Type, false)
end

function IconModule.Icon2(Icon, Type)
    return IconModule.Icon(Icon, Type, true)
end

function IconModule.Image(IconConfig)
    local Icon = {
        Icon   = IconConfig.Icon or nil,
        Type   = IconConfig.Type,
        Colors = IconConfig.Colors or { (IconModule.IconThemeTag or Color3.new(1,1,1)), Color3.new(1,1,1) },
        Size   = IconConfig.Size  or UDim2.new(0,24,0,24),
        IconFrame = nil,
    }
    local Colors = {}
    for i, color in next, Icon.Colors do
        Colors[i] = {
            ThemeTag = typeof(color) == "string"  and color,
            Color    = typeof(color) == "Color3"  and color,
        }
    end
    local IconLabel    = IconModule.Icon2(Icon.Icon, Icon.Type)
    local isrbxassetid = typeof(IconLabel) == "string" and string.find(IconLabel, "rbxassetid://")

    if IconModule.New then
        local New       = IconModule.New
        local IconFrame = New("ImageLabel", {
            Size                = Icon.Size,
            BackgroundTransparency = 1,
            ImageColor3         = Colors[1].Color or nil,
            ThemeTag            = Colors[1].ThemeTag and { ImageColor3 = Colors[1].ThemeTag },
            Image               = isrbxassetid and IconLabel or IconLabel[1],
            ImageRectSize       = isrbxassetid and nil or IconLabel[2].ImageRectSize,
            ImageRectOffset     = isrbxassetid and nil or IconLabel[2].ImageRectPosition,
        })
        if not isrbxassetid and IconLabel[2].Parts then
            for i, part in next, IconLabel[2].Parts do
                local IconPartLabel = IconModule.Icon(part, Icon.Type)
                New("ImageLabel", {
                    Size                = UDim2.new(1,0,1,0),
                    BackgroundTransparency = 1,
                    ImageColor3         = Colors[1+i].Color or nil,
                    ThemeTag            = Colors[1+i].ThemeTag and { ImageColor3 = Colors[1+i].ThemeTag },
                    Image               = IconPartLabel[1],
                    ImageRectSize       = IconPartLabel[2].ImageRectSize,
                    ImageRectOffset     = IconPartLabel[2].ImageRectPosition,
                    Parent              = IconFrame,
                })
            end
        end
        Icon.IconFrame = IconFrame
    else
        local IconFrame = Instance.new("ImageLabel")
        IconFrame.Size                = Icon.Size
        IconFrame.BackgroundTransparency = 1
        IconFrame.ImageColor3         = Colors[1].Color
        IconFrame.Image               = isrbxassetid and IconLabel or IconLabel[1]
        IconFrame.ImageRectSize       = isrbxassetid and nil or IconLabel[2].ImageRectSize
        IconFrame.ImageRectOffset     = isrbxassetid and nil or IconLabel[2].ImageRectPosition
        if not isrbxassetid and IconLabel[2].Parts then
            for i, part in next, IconLabel[2].Parts do
                local IconPartLabel = IconModule.Icon(part, Icon.Type)
                local IconPart      = Instance.new("ImageLabel")
                IconPart.Size                = UDim2.new(1,0,1,0)
                IconPart.BackgroundTransparency = 1
                IconPart.ImageColor3         = Colors[1+i].Color
                IconPart.Image               = IconPartLabel[1]
                IconPart.ImageRectSize       = IconPartLabel[2].ImageRectSize
                IconPart.ImageRectOffset     = IconPartLabel[2].ImageRectPosition
                IconPart.Parent              = IconFrame
            end
        end
        Icon.IconFrame = IconFrame
    end
    return Icon
end

-- Active icon module — defaults to the built-in IconModule above.
-- Call WindUI:SetIconModule(mod) or WindUI:SetIconsType(type) to customise.
local _activeIconMod = IconModule

-- ═══════════════════════════════════════════════
--  FILE I/O  (executor-safe)
-- ═══════════════════════════════════════════════
local function FSWrite(p,d)   pcall(function() writefile(p,d)   end) end
local function FSRead(p)
    local ok,v = pcall(function() return readfile(p) end); return ok and v or nil
end
local function FSFolder(p)    pcall(function() makefolder(p)    end) end

-- ═══════════════════════════════════════════════
--  SMALL HELPERS
-- ═══════════════════════════════════════════════
local function Tween(obj,info,props)
    local t = TweenService:Create(obj,info,props); t:Play(); return t
end
local function Corner(p,r)
    local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r or 8); c.Parent=p; return c
end
local function NewStroke(p,col,thick)
    local s=Instance.new("UIStroke"); s.Color=col; s.Thickness=thick or 1; s.Parent=p; return s
end
local function Shadow(parent,trans)
    local s=Instance.new("ImageLabel")
    s.Size=UDim2.new(1,60,1,60); s.Position=UDim2.new(0,-30,0,-30)
    s.BackgroundTransparency=1; s.Image="rbxassetid://6014261993"
    s.ImageColor3=Color3.new(0,0,0); s.ImageTransparency=trans or 0.5
    s.ScaleType=Enum.ScaleType.Slice; s.SliceCenter=Rect.new(49,49,450,450)
    s.ZIndex=-1; s.Parent=parent; return s
end
local function MakeDraggable(frame,handle)
    handle=handle or frame
    local dragging,dragInput,startMouse,startPos
    handle.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1
        or i.UserInputType==Enum.UserInputType.Touch then
            dragging=true; startMouse=i.Position; startPos=frame.Position
            i.Changed:Connect(function()
                if i.UserInputState==Enum.UserInputState.End then dragging=false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseMovement
        or i.UserInputType==Enum.UserInputType.Touch then dragInput=i end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i==dragInput then
            local d=i.Position-startMouse
            frame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,
                                     startPos.Y.Scale,startPos.Y.Offset+d.Y)
        end
    end)
end

-- Like MakeDraggable but returns a function to enable/disable dragging at runtime.
local function MakeDraggableToggleable(frame)
    local enabled = true
    local dragging, dragInput, startMouse, startPos
    frame.InputBegan:Connect(function(i)
        if not enabled then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true; startMouse = i.Position; startPos = frame.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(i)
        if not enabled then return end
        if i.UserInputType == Enum.UserInputType.MouseMovement
        or i.UserInputType == Enum.UserInputType.Touch then dragInput = i end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and enabled and i == dragInput then
            local d = i.Position - startMouse
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    -- Returns a setter: call with true/false to enable or disable dragging
    return function(state) enabled = state; if not state then dragging = false end end
end

-- ── Icon resolution (supports spritesheet ImageRect) ────────────
-- Returns { Image, RectSize, RectPos } or nil.
local function _ResolveIcon(name)
    if not name or name == "" then return nil end
    local mod = _activeIconMod
    if not mod then return nil end
    local ok, result = pcall(function() return mod.GetIcon(name) end)
    if not ok or not result then return nil end
    if type(result) == "string" and result:find("rbxassetid://") then
        return { Image=result, RectSize=Vector2.new(0,0), RectPos=Vector2.new(0,0) }
    end
    if type(result) == "table" and result[1] then
        local d = result[2] or {}
        return {
            Image    = result[1],
            RectSize = d.ImageRectSize     or Vector2.new(0,0),
            RectPos  = d.ImageRectPosition or Vector2.new(0,0),
        }
    end
    return nil
end

-- Convenience: returns only the asset id string (backwards-compat).
local function GetIconImg(name)
    local d = _ResolveIcon(name)
    return d and d.Image or nil
end

-- Creates an ImageLabel icon child inside `parent`, with full spritesheet support.
local function PlaceIcon(parent, name, size, color, zi, pos)
    local d = _ResolveIcon(name)
    if not d then return nil end
    local IL = Instance.new("ImageLabel")
    IL.Size               = size  or UDim2.new(0,16,0,16)
    IL.Position           = pos   or UDim2.new(0,0,0.5,-8)
    IL.AnchorPoint        = Vector2.new(0,0.5)
    IL.BackgroundTransparency = 1
    IL.Image              = d.Image
    if d.RectSize ~= Vector2.new(0,0) then
        IL.ImageRectSize   = d.RectSize
        IL.ImageRectOffset = d.RectPos
    end
    IL.ImageColor3        = color or Color3.fromRGB(200,200,220)
    IL.ZIndex             = zi    or 3
    IL.Parent             = parent
    return IL
end

-- ═══════════════════════════════════════════════
--  THEMES
-- ═══════════════════════════════════════════════
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

-- ═══════════════════════════════════════════════
--  SCREENGUI
-- ═══════════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name="ftgsUIv3"; ScreenGui.ResetOnSpawn=false
ScreenGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder=999; ScreenGui.IgnoreGuiInset=true
local _ok=pcall(function() ScreenGui.Parent=game:GetService("CoreGui") end)
if not _ok or not ScreenGui.Parent then ScreenGui.Parent=Player:WaitForChild("PlayerGui") end

-- ═══════════════════════════════════════════════
--  SCROLLFRAME V2  factory
-- ═══════════════════════════════════════════════
local function ScrollV2(parent,size,pos,pad,barThick,accent)
    pad=pad or {top=6,bottom=12,left=4,right=6}
    barThick=barThick or 4
    accent=accent or Color3.fromRGB(108,84,232)
    local W=Instance.new("Frame")
    W.Size=size; W.Position=pos; W.BackgroundTransparency=1
    W.BorderSizePixel=0; W.ClipsDescendants=true; W.Parent=parent
    local SF=Instance.new("ScrollingFrame")
    SF.Size=UDim2.fromScale(1,1); SF.BackgroundTransparency=1; SF.BorderSizePixel=0
    SF.ScrollBarThickness=barThick; SF.ScrollBarImageColor3=accent
    SF.ScrollingDirection=Enum.ScrollingDirection.Y
    SF.CanvasSize=UDim2.new(0,0,0,0); SF.ScrollingEnabled=true
    SF.ElasticBehavior=Enum.ElasticBehavior.WhenScrollable
    SF.BottomImage="rbxasset://textures/ui/Scroll/scroll-middle.png"
    SF.MidImage   ="rbxasset://textures/ui/Scroll/scroll-middle.png"
    SF.TopImage   ="rbxasset://textures/ui/Scroll/scroll-middle.png"
    SF.Parent=W
    local L=Instance.new("UIListLayout")
    L.SortOrder=Enum.SortOrder.LayoutOrder; L.Padding=UDim.new(0,6); L.Parent=SF
    local P=Instance.new("UIPadding")
    P.PaddingTop=UDim.new(0,pad.top); P.PaddingBottom=UDim.new(0,pad.bottom)
    P.PaddingLeft=UDim.new(0,pad.left); P.PaddingRight=UDim.new(0,pad.right); P.Parent=SF
    L:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SF.CanvasSize=UDim2.new(0,0,0,L.AbsoluteContentSize.Y+pad.top+pad.bottom+4)
    end)
    return {Wrapper=W,Scroll=SF,Layout=L}
end

-- ═══════════════════════════════════════════════
--  DROPDOWN  (global singleton, rebuilt per theme)
-- ═══════════════════════════════════════════════
local _DDLayer,_DDCard,_DDTitleLbl,_DDXBtn,_DDScrV2,_DDHide

local function BuildDropdown(T)
    if _DDLayer then _DDLayer:Destroy() end
    _DDLayer=Instance.new("Frame"); _DDLayer.Name="DDLayer"
    _DDLayer.Size=UDim2.fromScale(1,1); _DDLayer.BackgroundColor3=Color3.new(0,0,0)
    _DDLayer.BackgroundTransparency=0.5; _DDLayer.BorderSizePixel=0
    _DDLayer.ZIndex=500; _DDLayer.Visible=false; _DDLayer.Parent=ScreenGui

    _DDCard=Instance.new("Frame"); _DDCard.Size=UDim2.new(0,290,0,0)
    _DDCard.AnchorPoint=Vector2.new(0.5,0.5); _DDCard.Position=UDim2.fromScale(0.5,0.5)
    _DDCard.BackgroundColor3=T.Secondary; _DDCard.BorderSizePixel=0
    _DDCard.ZIndex=501; _DDCard.ClipsDescendants=true; _DDCard.Parent=_DDLayer
    Corner(_DDCard,14); NewStroke(_DDCard,T.BorderHi,1); Shadow(_DDCard,0.44)

    local Head=Instance.new("Frame"); Head.Size=UDim2.new(1,0,0,44)
    Head.BackgroundColor3=T.Tertiary; Head.BorderSizePixel=0; Head.ZIndex=502; Head.Parent=_DDCard
    Corner(Head,14)
    local HFix=Instance.new("Frame"); HFix.Size=UDim2.new(1,0,0,14); HFix.Position=UDim2.new(0,0,1,-14)
    HFix.BackgroundColor3=T.Tertiary; HFix.BorderSizePixel=0; HFix.ZIndex=502; HFix.Parent=Head

    local HPill=Instance.new("Frame"); HPill.Size=UDim2.new(0,3,0,20)
    HPill.Position=UDim2.new(0,14,0.5,-10); HPill.BackgroundColor3=T.Accent
    HPill.BorderSizePixel=0; HPill.ZIndex=503; HPill.Parent=Head; Corner(HPill,2)

    _DDTitleLbl=Instance.new("TextLabel"); _DDTitleLbl.Size=UDim2.new(1,-68,1,0)
    _DDTitleLbl.Position=UDim2.new(0,26,0,0); _DDTitleLbl.BackgroundTransparency=1
    _DDTitleLbl.Text="Select"; _DDTitleLbl.TextColor3=T.Text
    _DDTitleLbl.Font=Enum.Font.GothamBold; _DDTitleLbl.TextSize=14
    _DDTitleLbl.TextXAlignment=Enum.TextXAlignment.Left; _DDTitleLbl.ZIndex=503; _DDTitleLbl.Parent=Head

    _DDXBtn=Instance.new("TextButton"); _DDXBtn.Size=UDim2.new(0,26,0,26)
    _DDXBtn.Position=UDim2.new(1,-34,0.5,0); _DDXBtn.AnchorPoint=Vector2.new(0,0.5)
    _DDXBtn.BackgroundColor3=T.Tertiary; _DDXBtn.Text=""
    _DDXBtn.BorderSizePixel=0; _DDXBtn.ZIndex=503; _DDXBtn.Parent=Head
    Corner(_DDXBtn,13)
    -- Icon inside close button
    do
        local xIcoD = _ResolveIcon("x")
        if xIcoD then
            local XI = Instance.new("ImageLabel")
            XI.Size = UDim2.new(0,11,0,11); XI.Position = UDim2.new(0.5,0,0.5,0)
            XI.AnchorPoint = Vector2.new(0.5,0.5); XI.BackgroundTransparency = 1
            XI.Image = xIcoD.Image
            if xIcoD.RectSize ~= Vector2.new(0,0) then
                XI.ImageRectSize = xIcoD.RectSize; XI.ImageRectOffset = xIcoD.RectPos
            end
            XI.ImageColor3 = T.SubText; XI.ZIndex = 504; XI.Parent = _DDXBtn
        else
            _DDXBtn.Text = "✕"; _DDXBtn.TextColor3 = T.SubText
            _DDXBtn.Font = Enum.Font.GothamBold; _DDXBtn.TextSize = 11
        end
    end
    _DDXBtn.MouseEnter:Connect(function()
        Tween(_DDXBtn,TweenInfo.new(0.1),{BackgroundColor3=T.Danger})
        local xi = _DDXBtn:FindFirstChildWhichIsA("ImageLabel")
        if xi then Tween(xi,TweenInfo.new(0.1),{ImageColor3=T.Text}) end
    end)
    _DDXBtn.MouseLeave:Connect(function()
        Tween(_DDXBtn,TweenInfo.new(0.1),{BackgroundColor3=T.Tertiary})
        local xi = _DDXBtn:FindFirstChildWhichIsA("ImageLabel")
        if xi then Tween(xi,TweenInfo.new(0.1),{ImageColor3=T.SubText}) end
    end)

    _DDScrV2=ScrollV2(_DDCard,UDim2.new(1,-8,1,-52),UDim2.new(0,4,0,48),
        {top=4,bottom=6,left=4,right=4},4,T.Accent)
    _DDScrV2.Scroll.ZIndex=502

    _DDHide=function()
        Tween(_DDCard,TweenInfo.new(0.16,Enum.EasingStyle.Quad,Enum.EasingDirection.In),
            {Size=UDim2.new(0,290,0,0)})
        Tween(_DDLayer,TweenInfo.new(0.16),{BackgroundTransparency=1})
        task.delay(0.2,function()
            _DDLayer.Visible=false
            for _,c in ipairs(_DDScrV2.Scroll:GetChildren()) do
                if c:IsA("TextButton") then c:Destroy() end
            end
        end)
    end
    _DDXBtn.MouseButton1Click:Connect(_DDHide)
    _DDLayer.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then _DDHide() end
    end)
end

local function OpenDropdown(T,title,values,curVal,onSelect)
    for _,c in ipairs(_DDScrV2.Scroll:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    _DDTitleLbl.Text=title; local active=curVal
    for idx,val in ipairs(values) do
        local isA=val==active
        local item=Instance.new("TextButton"); item.Size=UDim2.new(1,0,0,36)
        item.BackgroundColor3=isA and T.Accent or T.Tertiary; item.BorderSizePixel=0
        item.Text=val; item.TextColor3=isA and T.Text or T.SubText
        item.Font=isA and Enum.Font.GothamBold or Enum.Font.Gotham
        item.TextSize=13; item.LayoutOrder=idx; item.ZIndex=503; item.Parent=_DDScrV2.Scroll
        Corner(item,8)
        if isA then
            local dot=Instance.new("Frame"); dot.Name="Dot"
            dot.Size=UDim2.new(0,6,0,6); dot.Position=UDim2.new(1,-16,0.5,-3)
            dot.BackgroundColor3=T.Text; dot.BorderSizePixel=0; dot.ZIndex=504; dot.Parent=item
            Corner(dot,3)
        end
        item.MouseEnter:Connect(function()
            if val~=active then Tween(item,TweenInfo.new(0.1),{BackgroundColor3=T.BorderHi,TextColor3=T.Text}) end
        end)
        item.MouseLeave:Connect(function()
            if val~=active then Tween(item,TweenInfo.new(0.1),{BackgroundColor3=T.Tertiary,TextColor3=T.SubText}) end
        end)
        item.MouseButton1Click:Connect(function()
            active=val
            for _,sib in ipairs(_DDScrV2.Scroll:GetChildren()) do
                if sib:IsA("TextButton") then
                    local a=sib.Text==val
                    Tween(sib,TweenInfo.new(0.12),{BackgroundColor3=a and T.Accent or T.Tertiary,TextColor3=a and T.Text or T.SubText})
                    sib.Font=a and Enum.Font.GothamBold or Enum.Font.Gotham
                    local d=sib:FindFirstChild("Dot"); if d then d:Destroy() end
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
    local count=#values; local targetH=math.min(count*42+56,320)
    _DDScrV2.Scroll.CanvasSize=UDim2.new(0,0,0,count*42+10)
    _DDCard.Size=UDim2.new(0,290,0,0); _DDLayer.BackgroundTransparency=1; _DDLayer.Visible=true
    Tween(_DDLayer,TweenInfo.new(0.2),{BackgroundTransparency=0.5})
    Tween(_DDCard,TweenInfo.new(0.28,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
        {Size=UDim2.new(0,290,0,targetH)})
end

-- ═══════════════════════════════════════════════
--  KEY SYSTEM  v2  (two-column card)
--  Left  : Thumbnail image fills sidebar
--  Right : Title · Note · Key input
--  Bottom: [Cancel] [📋 Copy URL] [Submit Key]
-- ═══════════════════════════════════════════════
local function ShowKeySystem(config, T, onSuccess, onCancel)
    local ks     = config.KeySystem or {}
    local folder = config.Folder or "ftgsUI"

    -- Check saved key first
    if ks.SaveKey then
        FSFolder(folder)
        local saved = FSRead(folder .. "/key.txt")
        if saved then
            for _, k in ipairs(ks.Key or {}) do
                if saved:gsub("%s+", "") == k then task.defer(onSuccess); return end
            end
        end
    end

    -- ── Dim overlay ──────────────────────────────
    local Dim = Instance.new("Frame"); Dim.Name = "KeyDim"
    Dim.Size = UDim2.fromScale(1,1); Dim.BackgroundColor3 = Color3.new(0,0,0)
    Dim.BackgroundTransparency = 1; Dim.BorderSizePixel = 0
    Dim.ZIndex = 700; Dim.Parent = ScreenGui

    -- ── Card ─────────────────────────────────────
    local CARD_W  = 580
    local SIDE_W  = 190   -- left thumbnail column
    local CONT_W  = CARD_W - SIDE_W  -- right form column
    local BTN_H   = 44    -- bottom button bar height
    local FORM_H  = 230   -- right column inner height
    local CARD_H  = FORM_H + BTN_H + 24  -- total visible height

    local Card = Instance.new("Frame"); Card.Name = "KeyCard"
    Card.Size = UDim2.new(0, CARD_W, 0, 0)
    Card.AnchorPoint = Vector2.new(0.5, 0.5)
    Card.Position = UDim2.fromScale(0.5, 0.5)
    Card.BackgroundColor3 = T.Secondary
    Card.BorderSizePixel = 0; Card.ZIndex = 701
    Card.ClipsDescendants = true; Card.Parent = Dim
    Corner(Card, 16); NewStroke(Card, T.BorderHi, 1); Shadow(Card, 0.42)

    -- ── Left sidebar (thumbnail) ──────────────────
    local LeftPanel = Instance.new("Frame"); LeftPanel.Name = "ThumbPanel"
    LeftPanel.Size = UDim2.new(0, SIDE_W, 1, -BTN_H)
    LeftPanel.Position = UDim2.new(0, 0, 0, 0)
    LeftPanel.BackgroundColor3 = T.Tertiary
    LeftPanel.BorderSizePixel = 0; LeftPanel.ZIndex = 702
    LeftPanel.ClipsDescendants = true; LeftPanel.Parent = Card
    -- round only top-left corner
    local LPC = Instance.new("UICorner"); LPC.CornerRadius = UDim.new(0,16); LPC.Parent = LeftPanel
    -- fix: square the right side corners via an overlap frame
    local LPFix = Instance.new("Frame"); LPFix.Size = UDim2.new(0,16,1,0)
    LPFix.Position = UDim2.new(1,-16,0,0); LPFix.BackgroundColor3 = T.Tertiary
    LPFix.BorderSizePixel = 0; LPFix.ZIndex = 702; LPFix.Parent = LeftPanel

    local hasThumb = ks.Thumbnail and ks.Thumbnail.Image
        and ks.Thumbnail.Image ~= "" and ks.Thumbnail.Image ~= "rbxassetid://"
    if hasThumb then
        local TImg = Instance.new("ImageLabel"); TImg.Size = UDim2.fromScale(1,1)
        TImg.BackgroundTransparency = 1; TImg.Image = ks.Thumbnail.Image
        TImg.ScaleType = Enum.ScaleType.Crop; TImg.ImageTransparency = 0.04
        TImg.ZIndex = 703; TImg.Parent = LeftPanel
    end
    -- Gradient overlay bottom-up
    local TGradFrame = Instance.new("Frame"); TGradFrame.Size = UDim2.new(1,0,0.55,0)
    TGradFrame.Position = UDim2.new(0,0,0.45,0)
    TGradFrame.BackgroundColor3 = T.Bg; TGradFrame.BorderSizePixel = 0
    TGradFrame.ZIndex = 703; TGradFrame.Parent = LeftPanel
    local TGrad = Instance.new("UIGradient"); TGrad.Rotation = 90
    TGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.45, 0.6),
        NumberSequenceKeypoint.new(1, 1),
    }); TGrad.Parent = TGradFrame

    -- Thumbnail title at bottom
    if ks.Thumbnail and ks.Thumbnail.Title and ks.Thumbnail.Title ~= "" then
        local TTL = Instance.new("TextLabel")
        TTL.Size = UDim2.new(1,-16,0,36); TTL.Position = UDim2.new(0,10,1,-46)
        TTL.BackgroundTransparency = 1; TTL.Text = ks.Thumbnail.Title
        TTL.TextColor3 = T.Text; TTL.Font = Enum.Font.GothamBold; TTL.TextSize = 13
        TTL.TextXAlignment = Enum.TextXAlignment.Left; TTL.TextWrapped = true
        TTL.ZIndex = 704; TTL.Parent = LeftPanel
    end

    -- Hub icon pill at top-left
    local KPill = Instance.new("Frame"); KPill.Size = UDim2.new(0,4,0,32)
    KPill.Position = UDim2.new(0,14,0,14); KPill.BackgroundColor3 = T.Accent
    KPill.BorderSizePixel = 0; KPill.ZIndex = 704; KPill.Parent = LeftPanel; Corner(KPill,2)

    -- Divider between columns
    local ColDiv = Instance.new("Frame"); ColDiv.Size = UDim2.new(0,1,1,-BTN_H)
    ColDiv.Position = UDim2.new(0,SIDE_W,0,0)
    ColDiv.BackgroundColor3 = T.Border; ColDiv.BorderSizePixel = 0
    ColDiv.ZIndex = 702; ColDiv.Parent = Card

    -- ── Right form panel ─────────────────────────
    local RightPanel = Instance.new("Frame"); RightPanel.Name = "FormPanel"
    RightPanel.Size = UDim2.new(0, CONT_W, 1, -BTN_H)
    RightPanel.Position = UDim2.new(0, SIDE_W+1, 0, 0)
    RightPanel.BackgroundTransparency = 1
    RightPanel.BorderSizePixel = 0; RightPanel.ZIndex = 702; RightPanel.Parent = Card

    local ry = 20  -- running Y inside right panel

    -- Title
    local KTitle = Instance.new("TextLabel")
    KTitle.Size = UDim2.new(1,-28,0,22); KTitle.Position = UDim2.new(0,16,0,ry)
    KTitle.BackgroundTransparency = 1; KTitle.Text = ks.Title or "Key System"
    KTitle.TextColor3 = T.Text; KTitle.Font = Enum.Font.GothamBold; KTitle.TextSize = 17
    KTitle.TextXAlignment = Enum.TextXAlignment.Left; KTitle.ZIndex = 703; KTitle.Parent = RightPanel
    ry = ry + 22 + 10

    -- Divider
    local FDiv = Instance.new("Frame"); FDiv.Size = UDim2.new(1,-32,0,1)
    FDiv.Position = UDim2.new(0,16,0,ry); FDiv.BackgroundColor3 = T.Border
    FDiv.BorderSizePixel = 0; FDiv.ZIndex = 703; FDiv.Parent = RightPanel
    ry = ry + 1 + 14

    -- Note
    if ks.Note and ks.Note ~= "" then
        local KNote = Instance.new("TextLabel")
        KNote.Size = UDim2.new(1,-32,0,52); KNote.Position = UDim2.new(0,16,0,ry)
        KNote.BackgroundTransparency = 1; KNote.Text = ks.Note
        KNote.TextColor3 = T.SubText; KNote.Font = Enum.Font.Gotham; KNote.TextSize = 12
        KNote.TextXAlignment = Enum.TextXAlignment.Left
        KNote.TextWrapped = true; KNote.ZIndex = 703; KNote.Parent = RightPanel
        ry = ry + 52 + 10
    end

    -- Key input box
    local IBg = Instance.new("Frame"); IBg.Size = UDim2.new(1,-32,0,38)
    IBg.Position = UDim2.new(0,16,0,ry)
    IBg.BackgroundColor3 = T.Tertiary; IBg.BorderSizePixel = 0
    IBg.ZIndex = 703; IBg.Parent = RightPanel; Corner(IBg,9)
    local iStr = NewStroke(IBg, T.Border)
    ry = ry + 38 + 8

    local KB = Instance.new("TextBox")
    KB.Size = UDim2.new(1,-44,1,-8); KB.Position = UDim2.new(0,12,0,4)
    KB.BackgroundTransparency = 1; KB.Text = ""
    KB.PlaceholderText = "Enter your key here..."
    KB.PlaceholderColor3 = T.SubText; KB.TextColor3 = T.Text
    KB.Font = Enum.Font.Gotham; KB.TextSize = 13
    KB.TextXAlignment = Enum.TextXAlignment.Left
    KB.ClearTextOnFocus = false; KB.BorderSizePixel = 0
    KB.ZIndex = 704; KB.Parent = IBg

    local EyeBtn = Instance.new("TextButton"); EyeBtn.Size = UDim2.new(0,30,0,30)
    EyeBtn.Position = UDim2.new(1,-34,0.5,-15); EyeBtn.BackgroundTransparency = 1
    EyeBtn.Text = "◉"; EyeBtn.TextColor3 = T.SubText
    EyeBtn.Font = Enum.Font.GothamBold; EyeBtn.TextSize = 16
    EyeBtn.ZIndex = 704; EyeBtn.Parent = IBg

    KB.Focused:Connect(function()
        Tween(iStr,TweenInfo.new(0.14),{Color=T.Accent})
        Tween(IBg, TweenInfo.new(0.14),{BackgroundColor3=T.BorderHi})
    end)
    KB.FocusLost:Connect(function()
        Tween(iStr,TweenInfo.new(0.14),{Color=T.Border})
        Tween(IBg, TweenInfo.new(0.14),{BackgroundColor3=T.Tertiary})
    end)
    EyeBtn.MouseButton1Click:Connect(function()
        if EyeBtn.Text == "◉" then EyeBtn.Text = "⊘"; EyeBtn.TextColor3 = T.Accent
        else EyeBtn.Text = "◉"; EyeBtn.TextColor3 = T.SubText end
    end)

    -- Error label (inside right panel, below input)
    local ErrLbl = Instance.new("TextLabel")
    ErrLbl.Size = UDim2.new(1,-32,0,14); ErrLbl.Position = UDim2.new(0,16,0,ry)
    ErrLbl.BackgroundTransparency = 1; ErrLbl.Text = ""
    ErrLbl.TextColor3 = T.Danger; ErrLbl.Font = Enum.Font.Gotham; ErrLbl.TextSize = 11
    ErrLbl.TextXAlignment = Enum.TextXAlignment.Left
    ErrLbl.ZIndex = 703; ErrLbl.Parent = RightPanel

    -- ── Bottom bar (full width) ───────────────────
    local BotBar = Instance.new("Frame"); BotBar.Name = "BotBar"
    BotBar.Size = UDim2.new(1,0,0,BTN_H)
    BotBar.Position = UDim2.new(0,0,1,-BTN_H)
    BotBar.BackgroundColor3 = T.Tertiary
    BotBar.BorderSizePixel = 0; BotBar.ZIndex = 702; BotBar.Parent = Card
    -- Fix corner rounding (only bottom corners)
    local BBFix = Instance.new("Frame"); BBFix.Size = UDim2.new(1,0,0,16)
    BBFix.BackgroundColor3 = T.Tertiary; BBFix.BorderSizePixel = 0
    BBFix.ZIndex = 702; BBFix.Parent = BotBar
    local BBDiv = Instance.new("Frame"); BBDiv.Size = UDim2.new(1,0,0,1)
    BBDiv.BackgroundColor3 = T.Border; BBDiv.BorderSizePixel = 0
    BBDiv.ZIndex = 703; BBDiv.Parent = BotBar

    local hasURL = ks.URL and ks.URL ~= "" and not ks.URL:find("YOUR LINK")
    -- Three buttons: Cancel | Copy (if URL) | Submit
    -- Widths distribute evenly
    local totalBtns = hasURL and 3 or 2
    local PAD = 14
    local btnW = (CARD_W - PAD*(totalBtns+1)) / totalBtns
    local bx = PAD

    local function MakeBtn(x, w, bgCol, textCol, txt, stroke)
        local b = Instance.new("TextButton"); b.Size = UDim2.new(0,w,0,28)
        b.Position = UDim2.new(0,x,0.5,-14)
        b.BackgroundColor3 = bgCol; b.Text = txt; b.TextColor3 = textCol
        b.Font = Enum.Font.GothamBold; b.TextSize = 13; b.BorderSizePixel = 0
        b.ZIndex = 703; b.Parent = BotBar; Corner(b,8)
        if stroke then NewStroke(b,stroke,1) end
        return b
    end

    local CancelBtn = MakeBtn(bx, btnW, T.Secondary, T.SubText, "Cancel", T.Border)
    bx = bx + btnW + PAD

    local CopyBtn = nil
    if hasURL then
        CopyBtn = MakeBtn(bx, btnW, T.Secondary, T.Accent, "📋  Copy URL", T.Accent)
        bx = bx + btnW + PAD
        local copying = false
        CopyBtn.MouseButton1Click:Connect(function()
            if copying then return end; copying = true
            pcall(function() if setclipboard then setclipboard(ks.URL) end end)
            CopyBtn.Text = "✓  Copied!"
            Tween(CopyBtn,TweenInfo.new(0.15),{BackgroundColor3=T.Success,TextColor3=T.Text})
            task.delay(1.6,function()
                copying = false
                CopyBtn.Text = "📋  Copy URL"
                Tween(CopyBtn,TweenInfo.new(0.2),{BackgroundColor3=T.Secondary,TextColor3=T.Accent})
            end)
        end)
        CopyBtn.MouseEnter:Connect(function() if not copying then Tween(CopyBtn,TweenInfo.new(0.1),{BackgroundColor3=T.BorderHi}) end end)
        CopyBtn.MouseLeave:Connect(function() if not copying then Tween(CopyBtn,TweenInfo.new(0.1),{BackgroundColor3=T.Secondary}) end end)
    end

    local SubmitBtn = MakeBtn(bx, btnW, T.Accent, T.Text, "Submit Key", nil)

    -- Hover effects for Cancel and Submit
    CancelBtn.MouseEnter:Connect(function() Tween(CancelBtn,TweenInfo.new(0.1),{BackgroundColor3=T.BorderHi,TextColor3=T.Text}) end)
    CancelBtn.MouseLeave:Connect(function() Tween(CancelBtn,TweenInfo.new(0.1),{BackgroundColor3=T.Secondary,TextColor3=T.SubText}) end)
    SubmitBtn.MouseEnter:Connect(function() Tween(SubmitBtn,TweenInfo.new(0.1),{BackgroundColor3=T.AccentHov}) end)
    SubmitBtn.MouseLeave:Connect(function() Tween(SubmitBtn,TweenInfo.new(0.1),{BackgroundColor3=T.Accent}) end)

    -- ── Animate in ───────────────────────────────
    local targetH = CARD_H
    Card.Size = UDim2.new(0,CARD_W,0,0)
    Tween(Dim,  TweenInfo.new(0.22), {BackgroundTransparency=0.44})
    Tween(Card, TweenInfo.new(0.32,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
        {Size=UDim2.new(0,CARD_W,0,targetH)})

    -- ── Close helper ─────────────────────────────
    local function CloseCard(cb)
        Tween(Dim,  TweenInfo.new(0.18), {BackgroundTransparency=1})
        Tween(Card, TweenInfo.new(0.18,Enum.EasingStyle.Quad,Enum.EasingDirection.In),
            {Size=UDim2.new(0,CARD_W,0,0)})
        task.delay(0.22, function() Dim:Destroy(); if cb then cb() end end)
    end

    -- ── Validation ───────────────────────────────
    local function Validate(raw)
        local k = raw:gsub("%s+","")
        for _, v in ipairs(ks.Key or {}) do if k == v then return true end end
        return false
    end

    local function OnSubmit()
        local raw = KB.Text
        if raw == "" then ErrLbl.Text = "⚠  Please enter your key."; return end
        if Validate(raw) then
            ErrLbl.Text = ""
            SubmitBtn.Text = "✓  Access Granted"
            Tween(SubmitBtn,TweenInfo.new(0.2),{BackgroundColor3=T.Success})
            if ks.SaveKey then
                FSFolder(folder); FSWrite(folder.."/key.txt", raw:gsub("%s+",""))
            end
            task.delay(0.85, function() CloseCard(onSuccess) end)
        else
            ErrLbl.Text = "✕  Incorrect key — please try again."
            Tween(IBg,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(55,18,18)})
            task.delay(0.65,function() Tween(IBg,TweenInfo.new(0.2),{BackgroundColor3=T.Tertiary}) end)
        end
    end

    CancelBtn.MouseButton1Click:Connect(function() CloseCard(onCancel) end)
    SubmitBtn.MouseButton1Click:Connect(OnSubmit)
    KB.FocusLost:Connect(function(enter) if enter then OnSubmit() end end)
end

-- ═══════════════════════════════════════════════
--  LIBRARY
-- ═══════════════════════════════════════════════
local Library = {}
Library.__index = Library

-- Override the built-in icon module (optional).
-- Call WindUI:SetIconModule(mod) if you have a custom module.
function Library:SetIconModule(mod)
    _activeIconMod = mod
end

-- Switch the active icon pack for the built-in module.
-- Options: "lucide" | "solar" | "craft" | "geist" | "sfsymbols" | "gravity"
function Library:SetIconsType(iconType)
    IconModule.SetIconsType(iconType)
end

-- Expose AddIcons from the built-in module for custom icon packs.
function Library:AddIcons(packName, iconsData)
    IconModule.AddIcons(packName, iconsData)
end

-- Show the Key System card independently (without CreateWindow).
-- WindUI:ShowKeySystem(config, onSuccess, onCancel)
-- config must contain { KeySystem={...}, Folder="..." }
-- Theme defaults to Dark when called standalone.
function Library:ShowKeySystem(config, onSuccess, onCancel)
    local T = Themes[(config and config.Theme) or "Dark"] or Themes.Dark
    ShowKeySystem(config or {}, T, onSuccess or function() end, onCancel or function() end)
end

-- ────────────────────────────────────────────────
function Library:CreateWindow(config)
    config = config or {}

    local T       = Themes[config.Theme] or Themes.Dark
    local W       = (config.Size or UDim2.fromOffset(550,340)).X.Offset
    local H       = (config.Size or UDim2.fromOffset(550,340)).Y.Offset
    local MINW    = config.MinSize and config.MinSize.X or 480
    local MINH    = config.MinSize and config.MinSize.Y or 320
    local MAXW    = config.MaxSize and config.MaxSize.X or 900
    local MAXH    = config.MaxSize and config.MaxSize.Y or 600
    local SIDEW   = config.SideBarWidth or 140
    local SCRBARS = config.ScrollBarEnabled ~= false
    local HIDESRCH= config.HideSearchBar == true

    BuildDropdown(T)

    -- ── Main Frame ───────────────────────────────
    local Main=Instance.new("Frame"); Main.Name="MainWindow_ftgs"
    Main.Size=UDim2.fromOffset(W,H); Main.Position=UDim2.new(0.5,-W/2,0.5,-H/2)
    Main.BackgroundColor3=T.Bg
    Main.BackgroundTransparency=config.Transparent and 0.06 or 0
    Main.BorderSizePixel=0; Main.ClipsDescendants=true; Main.Visible=false; Main.Parent=ScreenGui
    Corner(Main,14); NewStroke(Main,T.Border); Shadow(Main,0.44)

    -- ── Background ───────────────────────────────
    if config.Background and config.Background~="" and config.Background~="rbxassetid://" then
        local bg=config.Background; local trans=config.BackgroundImageTransparency or 0.4
        if bg:sub(1,5)=="video" then
            local url=bg:match("^video:(.+)$") or ""
            local VF=Instance.new("VideoFrame"); VF.Size=UDim2.fromScale(1,1)
            VF.BackgroundTransparency=1; VF.Video=url; VF.Volume=0; VF.Looped=true; VF.ZIndex=0; VF.Parent=Main
            Corner(VF,14); task.defer(function() pcall(function() VF:Play() end) end)
            local VO=Instance.new("Frame"); VO.Size=UDim2.fromScale(1,1)
            VO.BackgroundColor3=T.Bg; VO.BackgroundTransparency=trans; VO.BorderSizePixel=0; VO.ZIndex=1; VO.Parent=Main
            Corner(VO,14)
        else
            local IL=Instance.new("ImageLabel"); IL.Size=UDim2.fromScale(1,1)
            IL.BackgroundTransparency=1; IL.Image=bg; IL.ScaleType=Enum.ScaleType.Crop
            IL.ImageTransparency=trans; IL.ZIndex=0; IL.Parent=Main; Corner(IL,14)
        end
    end

    -- ── Title Bar ────────────────────────────────
    local TBar=Instance.new("Frame"); TBar.Size=UDim2.new(1,0,0,46)
    TBar.BackgroundColor3=T.Secondary; TBar.BorderSizePixel=0; TBar.ZIndex=2; TBar.Parent=Main; Corner(TBar,14)
    local TBFix=Instance.new("Frame"); TBFix.Size=UDim2.new(1,0,0,14); TBFix.Position=UDim2.new(0,0,1,-14)
    TBFix.BackgroundColor3=T.Secondary; TBFix.BorderSizePixel=0; TBFix.ZIndex=2; TBFix.Parent=TBar

    -- Window Icon (left of title bar)
    local titleStartX  = 14
    local winIconData  = _ResolveIcon(config.Icon)

    if winIconData then
        local WIco = Instance.new("ImageLabel")
        WIco.Size        = UDim2.new(0,18,0,18)
        -- AnchorPoint=(0,0.5) means the left-middle of the image lands exactly on Position.
        -- Position Y = 0.5 scale (no offset) → perfect vertical center.
        WIco.Position    = UDim2.new(0,14,0.5,0)
        WIco.AnchorPoint = Vector2.new(0,0.5)
        WIco.BackgroundTransparency = 1
        WIco.Image       = winIconData.Image
        if winIconData.RectSize ~= Vector2.new(0,0) then
            WIco.ImageRectSize   = winIconData.RectSize
            WIco.ImageRectOffset = winIconData.RectPos
        end
        WIco.ImageColor3 = T.Accent; WIco.ZIndex = 3; WIco.Parent = TBar
        titleStartX = 40
    end

    -- Accent pill — vertically centered using AnchorPoint
    local TPill = Instance.new("Frame")
    TPill.Size        = UDim2.new(0,3,0,20)
    TPill.Position    = UDim2.new(0,titleStartX,0.5,0)
    TPill.AnchorPoint = Vector2.new(0,0.5)
    TPill.BackgroundColor3 = T.Accent
    TPill.BorderSizePixel  = 0; TPill.ZIndex = 3
    TPill.Parent = TBar; Corner(TPill,2)

    -- Title text — full height frame, text auto-centers vertically
    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Size     = UDim2.new(1,-200,1,0)
    TitleLbl.Position = UDim2.new(0,titleStartX+10,0,0)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text          = config.Title or "Hub"
    TitleLbl.TextColor3    = T.Text
    TitleLbl.Font          = Enum.Font.GothamBold
    TitleLbl.TextSize      = 15
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.TextYAlignment = Enum.TextYAlignment.Center
    TitleLbl.ZIndex = 3; TitleLbl.Parent = TBar

    if config.Author and config.Author~="" then
        local Auth=Instance.new("TextLabel"); Auth.Size=UDim2.new(0,156,1,0); Auth.Position=UDim2.new(1,-238,0,0)
        Auth.BackgroundTransparency=1; Auth.Text=config.Author; Auth.TextColor3=T.SubText
        Auth.Font=Enum.Font.Gotham; Auth.TextSize=11; Auth.TextXAlignment=Enum.TextXAlignment.Right
        Auth.ZIndex=3; Auth.Parent=TBar
    end

    -- Icon-based control button factory
    local function CtrlBtn(xOff, bg, iconName, fallbackTxt)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0,26,0,26)
        b.Position = UDim2.new(1,xOff,0.5,0)
        b.AnchorPoint = Vector2.new(0,0.5)
        b.BackgroundColor3 = bg
        b.Text = ""; b.BorderSizePixel = 0; b.ZIndex = 3; b.Parent = TBar
        Corner(b,13)
        -- Try to resolve a real icon; fall back to text if the pack isn't loaded yet
        local icoD = _ResolveIcon(iconName)
        if icoD then
            local IL = Instance.new("ImageLabel")
            IL.Size        = UDim2.new(0,12,0,12)
            IL.Position    = UDim2.new(0.5,0,0.5,0)
            IL.AnchorPoint = Vector2.new(0.5,0.5)
            IL.BackgroundTransparency = 1
            IL.Image       = icoD.Image
            if icoD.RectSize ~= Vector2.new(0,0) then
                IL.ImageRectSize   = icoD.RectSize
                IL.ImageRectOffset = icoD.RectPos
            end
            IL.ImageColor3 = T.Text; IL.ZIndex = 4; IL.Parent = b
        else
            b.Text = fallbackTxt; b.TextColor3 = T.Text
            b.Font = Enum.Font.GothamBold; b.TextSize = 12
        end
        return b
    end
    local CloseBtn = CtrlBtn(-36, T.Danger,  "x",     "✕")
    local MiniBtn  = CtrlBtn(-68, T.Warning, "minus", "–")

    MakeDraggable(Main,TBar)

    -- ── Resizable ────────────────────────────────
    if config.Resizable then
        -- Generic invisible edge helper (still used for corner)
        local function ResizeEdge(sz, pos, rW, rH, cursor)
            local e = Instance.new("Frame"); e.Size = sz; e.Position = pos
            e.BackgroundTransparency = 1; e.BorderSizePixel = 0; e.ZIndex = 12; e.Parent = Main
            local drg, sP, sS = false
            e.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    drg = true; sP = i.Position; sS = Main.AbsoluteSize
                    i.Changed:Connect(function()
                        if i.UserInputState == Enum.UserInputState.End then drg = false end
                    end)
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if drg and i.UserInputType == Enum.UserInputType.MouseMovement then
                    local d = i.Position - sP
                    local nw = rW and math.clamp(sS.X + d.X, MINW, MAXW) or sS.X
                    local nh = rH and math.clamp(sS.Y + d.Y, MINH, MAXH) or sS.Y
                    Main.Size = UDim2.fromOffset(nw, nh)
                end
            end)
            return e
        end

        -- ── Visible right resize bar ──────────────
        local RBar = Instance.new("Frame"); RBar.Name = "ResizeBarRight"
        RBar.Size = UDim2.new(0, 5, 1, -60); RBar.Position = UDim2.new(1, -5, 0, 52)
        RBar.BackgroundColor3 = T.Border; RBar.BorderSizePixel = 0; RBar.ZIndex = 11
        RBar.Parent = Main; Corner(RBar, 3)

        local RBarHit = Instance.new("TextButton"); RBarHit.Size = UDim2.new(0, 14, 1, 0)
        RBarHit.Position = UDim2.new(0, -4, 0, 0); RBarHit.BackgroundTransparency = 1
        RBarHit.Text = ""; RBarHit.ZIndex = 12; RBarHit.Parent = RBar
        local rdrag, rsP, rsS = false
        RBarHit.MouseEnter:Connect(function() Tween(RBar,TweenInfo.new(0.12),{BackgroundColor3=T.Accent}) end)
        RBarHit.MouseLeave:Connect(function() if not rdrag then Tween(RBar,TweenInfo.new(0.12),{BackgroundColor3=T.Border}) end end)
        RBarHit.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                rdrag = true; rsP = i.Position; rsS = Main.AbsoluteSize
                Tween(RBar,TweenInfo.new(0.08),{BackgroundColor3=T.AccentHov})
                i.Changed:Connect(function()
                    if i.UserInputState == Enum.UserInputState.End then
                        rdrag = false; Tween(RBar,TweenInfo.new(0.12),{BackgroundColor3=T.Border})
                    end
                end)
            end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if rdrag and i.UserInputType == Enum.UserInputType.MouseMovement then
                local d = i.Position - rsP
                local nw = math.clamp(rsS.X + d.X, MINW, MAXW)
                Main.Size = UDim2.fromOffset(nw, Main.AbsoluteSize.Y)
            end
        end)

        -- ── Visible bottom resize bar ─────────────
        local BBar = Instance.new("Frame"); BBar.Name = "ResizeBarBottom"
        BBar.Size = UDim2.new(1, -16, 0, 5); BBar.Position = UDim2.new(0, 8, 1, -5)
        BBar.BackgroundColor3 = T.Border; BBar.BorderSizePixel = 0; BBar.ZIndex = 11
        BBar.Parent = Main; Corner(BBar, 3)

        local BBarHit = Instance.new("TextButton"); BBarHit.Size = UDim2.new(1, 0, 0, 14)
        BBarHit.Position = UDim2.new(0, 0, 0, -4); BBarHit.BackgroundTransparency = 1
        BBarHit.Text = ""; BBarHit.ZIndex = 12; BBarHit.Parent = BBar
        local bdrag, bsP, bsS = false
        BBarHit.MouseEnter:Connect(function() Tween(BBar,TweenInfo.new(0.12),{BackgroundColor3=T.Accent}) end)
        BBarHit.MouseLeave:Connect(function() if not bdrag then Tween(BBar,TweenInfo.new(0.12),{BackgroundColor3=T.Border}) end end)
        BBarHit.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                bdrag = true; bsP = i.Position; bsS = Main.AbsoluteSize
                Tween(BBar,TweenInfo.new(0.08),{BackgroundColor3=T.AccentHov})
                i.Changed:Connect(function()
                    if i.UserInputState == Enum.UserInputState.End then
                        bdrag = false; Tween(BBar,TweenInfo.new(0.12),{BackgroundColor3=T.Border})
                    end
                end)
            end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if bdrag and i.UserInputType == Enum.UserInputType.MouseMovement then
                local d = i.Position - bsP
                local nh = math.clamp(bsS.Y + d.Y, MINH, MAXH)
                Main.Size = UDim2.fromOffset(Main.AbsoluteSize.X, nh)
            end
        end)

        -- Corner handle (invisible, for diagonal resize)
        ResizeEdge(UDim2.new(0,14,0,14), UDim2.new(1,-14,1,-14), true, true)
    end

    -- ── Sidebar ──────────────────────────────────
    local SideFrame=Instance.new("Frame"); SideFrame.Size=UDim2.new(0,SIDEW,1,-46)
    SideFrame.Position=UDim2.new(0,0,0,46); SideFrame.BackgroundColor3=T.Secondary
    SideFrame.BorderSizePixel=0; SideFrame.ZIndex=2; SideFrame.Parent=Main

    local searchQuery = ""; local sideTopPad = 8
    if not HIDESRCH then
        local SBar = Instance.new("Frame")
        SBar.Size = UDim2.new(1,-16,0,30); SBar.Position = UDim2.new(0,8,0,8)
        SBar.BackgroundColor3 = T.Tertiary; SBar.BorderSizePixel = 0
        SBar.ZIndex = 3; SBar.Parent = SideFrame
        Corner(SBar,8); local SBarStr = NewStroke(SBar,T.Border)

        -- Search icon — ImageLabel with lucide "search", fallback to text
        local searchIcoD = _ResolveIcon("search")
        local SIcoLabel = nil
        if searchIcoD then
            SIcoLabel = Instance.new("ImageLabel")
            SIcoLabel.Size        = UDim2.new(0,14,0,14)
            SIcoLabel.Position    = UDim2.new(0,9,0.5,0)
            SIcoLabel.AnchorPoint = Vector2.new(0,0.5)
            SIcoLabel.BackgroundTransparency = 1
            SIcoLabel.Image       = searchIcoD.Image
            if searchIcoD.RectSize ~= Vector2.new(0,0) then
                SIcoLabel.ImageRectSize   = searchIcoD.RectSize
                SIcoLabel.ImageRectOffset = searchIcoD.RectPos
            end
            SIcoLabel.ImageColor3 = T.SubText; SIcoLabel.ZIndex = 4; SIcoLabel.Parent = SBar
        else
            local SIcoTxt = Instance.new("TextLabel")
            SIcoTxt.Size = UDim2.new(0,26,1,0); SIcoTxt.BackgroundTransparency = 1
            SIcoTxt.Text = "⌕"; SIcoTxt.TextColor3 = T.SubText
            SIcoTxt.Font = Enum.Font.GothamBold; SIcoTxt.TextSize = 14
            SIcoTxt.ZIndex = 4; SIcoTxt.Parent = SBar
        end

        local STB = Instance.new("TextBox")
        STB.Size = UDim2.new(1,-30,1,-6); STB.Position = UDim2.new(0,28,0,3)
        STB.BackgroundTransparency = 1; STB.Text = ""; STB.PlaceholderText = "Search tabs..."
        STB.PlaceholderColor3 = T.SubText; STB.TextColor3 = T.Text
        STB.Font = Enum.Font.Gotham; STB.TextSize = 12
        STB.TextXAlignment = Enum.TextXAlignment.Left
        STB.TextYAlignment = Enum.TextYAlignment.Center
        STB.ClearTextOnFocus = false; STB.BorderSizePixel = 0; STB.ZIndex = 4; STB.Parent = SBar

        STB.Focused:Connect(function()
            Tween(SBarStr,TweenInfo.new(0.14),{Color=T.Accent})
            Tween(SBar,TweenInfo.new(0.14),{BackgroundColor3=T.BorderHi})
            if SIcoLabel then Tween(SIcoLabel,TweenInfo.new(0.14),{ImageColor3=T.Accent}) end
        end)
        STB.FocusLost:Connect(function()
            Tween(SBarStr,TweenInfo.new(0.14),{Color=T.Border})
            Tween(SBar,TweenInfo.new(0.14),{BackgroundColor3=T.Tertiary})
            if SIcoLabel then Tween(SIcoLabel,TweenInfo.new(0.14),{ImageColor3=T.SubText}) end
        end)
        STB:GetPropertyChangedSignal("Text"):Connect(function() searchQuery = STB.Text:lower() end)
        sideTopPad = 46
    end

    local SideV2=ScrollV2(SideFrame,UDim2.new(1,0,1,-sideTopPad),UDim2.new(0,0,0,sideTopPad),
        {top=6,bottom=10,left=8,right=8},0,T.Accent)
    SideV2.Layout.Padding=UDim.new(0,4)

    local SDiv=Instance.new("Frame"); SDiv.Size=UDim2.new(0,1,1,-46); SDiv.Position=UDim2.new(0,SIDEW,0,46)
    SDiv.BackgroundColor3=T.Border; SDiv.BorderSizePixel=0; SDiv.ZIndex=2; SDiv.Parent=Main

    -- ── User Panel ───────────────────────────────
    if config.User and config.User.Enabled then
        local UP=Instance.new("Frame"); UP.Name="UserPanel"
        UP.Size=UDim2.new(0,SIDEW,0,56); UP.Position=UDim2.new(0,0,1,-56)
        UP.BackgroundColor3=T.Secondary; UP.BorderSizePixel=0; UP.ZIndex=3; UP.Parent=Main
        local UPL=Instance.new("Frame"); UPL.Size=UDim2.new(1,0,0,1)
        UPL.BackgroundColor3=T.Border; UPL.BorderSizePixel=0; UPL.ZIndex=3; UPL.Parent=UP
        local AVF=Instance.new("Frame"); AVF.Size=UDim2.new(0,34,0,34); AVF.Position=UDim2.new(0,10,0.5,-17)
        AVF.BackgroundColor3=T.Tertiary; AVF.BorderSizePixel=0; AVF.ZIndex=4; AVF.Parent=UP; Corner(AVF,17)
        task.spawn(function()
            if not config.User.Anonymous then
                local ok,img=pcall(function() return Players:GetUserThumbnailAsync(Player.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size48x48) end)
                if ok and img then
                    local IL=Instance.new("ImageLabel"); IL.Size=UDim2.fromScale(1,1); IL.BackgroundTransparency=1
                    IL.Image=img; IL.ZIndex=5; IL.Parent=AVF; Corner(IL,17)
                end
            else
                local AL=Instance.new("TextLabel"); AL.Size=UDim2.fromScale(1,1); AL.BackgroundTransparency=1
                AL.Text="?"; AL.TextColor3=T.SubText; AL.Font=Enum.Font.GothamBold; AL.TextSize=15; AL.ZIndex=5; AL.Parent=AVF
            end
        end)
        local UN=Instance.new("TextLabel"); UN.Size=UDim2.new(1,-52,0,16); UN.Position=UDim2.new(0,50,0.5,-16)
        UN.BackgroundTransparency=1; UN.Text=config.User.Anonymous and "Anonymous" or Player.DisplayName
        UN.TextColor3=T.Text; UN.Font=Enum.Font.GothamBold; UN.TextSize=12
        UN.TextXAlignment=Enum.TextXAlignment.Left; UN.ZIndex=4; UN.Parent=UP
        local UT=Instance.new("TextLabel"); UT.Size=UDim2.new(1,-52,0,13); UT.Position=UDim2.new(0,50,0.5,2)
        UT.BackgroundTransparency=1; UT.Text=config.User.Anonymous and "Hidden" or "@"..Player.Name
        UT.TextColor3=T.SubText; UT.Font=Enum.Font.Gotham; UT.TextSize=10
        UT.TextXAlignment=Enum.TextXAlignment.Left; UT.ZIndex=4; UT.Parent=UP
        if config.User.Callback then
            local UB=Instance.new("TextButton"); UB.Size=UDim2.fromScale(1,1); UB.BackgroundTransparency=1
            UB.Text=""; UB.ZIndex=5; UB.Parent=UP
            UB.MouseEnter:Connect(function() Tween(UP,TweenInfo.new(0.12),{BackgroundColor3=T.Tertiary}) end)
            UB.MouseLeave:Connect(function() Tween(UP,TweenInfo.new(0.12),{BackgroundColor3=T.Secondary}) end)
            UB.MouseButton1Click:Connect(function() task.spawn(config.User.Callback) end)
        end
        SideV2.Wrapper.Size=UDim2.new(1,0,1,-(sideTopPad+56))
    end

    -- ── Content Area ─────────────────────────────
    local ContentArea=Instance.new("Frame"); ContentArea.Name="ContentArea"
    ContentArea.Size=UDim2.new(1,-(SIDEW+8),1,-54); ContentArea.Position=UDim2.new(0,SIDEW+4,0,50)
    ContentArea.BackgroundTransparency=1; ContentArea.BorderSizePixel=0; ContentArea.Parent=Main

    -- ── Shared visibility state ───────────────────
    local minimized  = false
    local _uiVisible = false

    -- _uiUnlocked: false while KeySystem has not yet been cleared.
    -- Becomes true on the first successful _DoShow call.
    -- Used by CreateMinimizeBtn to hide the float button until the key is accepted.
    local _uiUnlocked = not (config.KeySystem ~= nil)

    local _openCloseCbs = {}
    local function _NotifyCallbacks()
        for _, cb in ipairs(_openCloseCbs) do pcall(cb, _uiVisible) end
    end

    local function _DoShow()
        if _uiVisible then return end
        _uiUnlocked = true          -- key system cleared (or no key system)
        _uiVisible  = true; minimized = false
        Main.Size = UDim2.fromOffset(W,0); Main.Visible = true
        Tween(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Size=UDim2.fromOffset(W,H)})
        _NotifyCallbacks()
    end

    local function _DoHide()
        if not _uiVisible then return end
        _uiVisible = false
        Tween(Main, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {Size=UDim2.fromOffset(W,0)})
        task.delay(0.22, function()
            if not _uiVisible then Main.Visible = false end
        end)
        _NotifyCallbacks()
    end

    -- Close destroys the entire ScreenGui (all windows + FloatBtns).
    local function _DoDestroy()
        _uiVisible = false
        Tween(Main, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {Size=UDim2.fromOffset(W,0)})
        task.delay(0.22, function() ScreenGui:Destroy() end)
    end

    -- ── Title-bar "–"  (collapse / restore height only) ──────────
    MiniBtn.MouseButton1Click:Connect(function()
        if not _uiVisible then return end
        minimized = not minimized
        if minimized then
            Tween(Main, TweenInfo.new(0.22, Enum.EasingStyle.Quad), {Size=UDim2.fromOffset(W,46)})
        else
            local cw = Main.AbsoluteSize.X
            Tween(Main, TweenInfo.new(0.28, Enum.EasingStyle.Back), {Size=UDim2.fromOffset(cw,H)})
        end
    end)

    -- ── Title-bar "✕"  (destroy everything) ──────────────────────
    CloseBtn.MouseButton1Click:Connect(_DoDestroy)

    -- ── ToggleKey  (open / close, synced with FloatBtn) ──────────
    if config.ToggleKey then
        UserInputService.InputBegan:Connect(function(i,gpe)
            if gpe then return end
            if i.KeyCode == config.ToggleKey then
                if _uiVisible then _DoHide() else _DoShow() end
            end
        end)
    end

    -- ── Tab system ───────────────────────────────
    local allTabs={}; local activeTab=nil

    local function SetActiveTab(entry)
        if activeTab then
            Tween(activeTab.Btn,TweenInfo.new(0.15),{BackgroundColor3=T.Tertiary})
            activeTab.Btn.TextColor3=T.SubText; activeTab.Btn.Font=Enum.Font.Gotham
            activeTab.Wrapper.Visible=false
            if activeTab.IconLabel then
                Tween(activeTab.IconLabel,TweenInfo.new(0.15),{ImageColor3=T.SubText})
            end
        end
        activeTab=entry
        Tween(entry.Btn,TweenInfo.new(0.15),{BackgroundColor3=T.Accent})
        entry.Btn.TextColor3=T.Text; entry.Btn.Font=Enum.Font.GothamBold
        entry.Wrapper.Visible=true
        if entry.IconLabel then
            Tween(entry.IconLabel,TweenInfo.new(0.15),{ImageColor3=T.Text})
        end
    end

    -- ════════════════════════════════════════════
    --   WINDOW OBJECT
    -- ════════════════════════════════════════════
    local WindowObj={}

    -- ─────────────────────────────────────────────
    --  CreateMinimizeBtn
    --  cfg keys:
    --    Title, Icon, Color (Color3 | ColorSequence | "Purple"…),
    --    CornerRadius (UDim), StrokeThickness (number),
    --    OnlyMobile (bool), Enabled (bool), Draggable (bool)
    -- ─────────────────────────────────────────────
    function WindowObj:CreateMinimizeBtn(cfg)
        cfg = cfg or {}
        local label = cfg.Title or "Open UI"

        -- ── Resolve color ─────────────────────────
        local solidBg    = T.Accent
        local isGradient = false
        local gradSeq    = nil
        if typeof(cfg.Color) == "ColorSequence" then
            isGradient = true; gradSeq = cfg.Color
            solidBg    = Color3.new(1,1,1)  -- white base so UIGradient shows through
        elseif typeof(cfg.Color) == "Color3" then
            solidBg = cfg.Color
        elseif type(cfg.Color) == "string" then
            local clrs = {Red=T.Danger,Green=T.Success,Blue=T.Blue,
                          Purple=T.Accent,Yellow=T.Warning,Orange=T.Orange}
            solidBg = clrs[cfg.Color] or T.Accent
        end

        -- ── Resolve icon ──────────────────────────
        local iconData = _ResolveIcon(cfg.Icon)
        local btnW     = iconData and 154 or 128

        -- ── Visibility rules ──────────────────────
        -- Hidden until the key system is cleared (or if Enabled=false/OnlyMobile and not touch)
        local enabledCfg   = cfg.Enabled ~= false
        local onlyMobile   = cfg.OnlyMobile == true
        local startVisible = _uiUnlocked
            and enabledCfg
            and not (onlyMobile and not UserInputService.TouchEnabled)

        -- ── Button frame ─────────────────────────
        local FB = Instance.new("TextButton"); FB.Name = "FloatBtn"
        FB.Size            = UDim2.fromOffset(btnW, 36)
        FB.Position        = UDim2.new(0,16,0.5,70)
        FB.BackgroundColor3 = solidBg
        FB.Text            = ""; FB.BorderSizePixel = 0
        FB.ZIndex          = 50; FB.Visible = startVisible
        FB.Parent          = ScreenGui

        -- CornerRadius
        local fbCorner = Instance.new("UICorner")
        fbCorner.CornerRadius = cfg.CornerRadius or UDim.new(0,10)
        fbCorner.Parent = FB

        -- Gradient (if ColorSequence)
        local fbGrad = nil
        if isGradient then
            fbGrad = Instance.new("UIGradient")
            fbGrad.Color    = gradSeq
            fbGrad.Rotation = 90      -- left → right
            fbGrad.Parent   = FB
        end

        -- Stroke
        local fbStroke = Instance.new("UIStroke")
        fbStroke.Color       = Color3.fromRGB(255,255,255)
        fbStroke.Transparency = 0.72
        fbStroke.Thickness   = cfg.StrokeThickness or 1
        fbStroke.Parent      = FB

        -- Icon
        local FBIco = nil
        if iconData then
            FBIco = Instance.new("ImageLabel")
            FBIco.Size        = UDim2.new(0,16,0,16)
            FBIco.Position    = UDim2.new(0,10,0.5,0)
            FBIco.AnchorPoint = Vector2.new(0,0.5)
            FBIco.BackgroundTransparency = 1
            FBIco.Image       = iconData.Image
            if iconData.RectSize ~= Vector2.new(0,0) then
                FBIco.ImageRectSize   = iconData.RectSize
                FBIco.ImageRectOffset = iconData.RectPos
            end
            FBIco.ImageColor3 = T.Text; FBIco.ZIndex = 51; FBIco.Parent = FB
        end

        -- Label
        local textLeft = iconData and 32 or 10
        local FBLbl = Instance.new("TextLabel")
        FBLbl.Size             = UDim2.new(1,-textLeft-8,1,0)
        FBLbl.Position         = UDim2.new(0,textLeft,0,0)
        FBLbl.BackgroundTransparency = 1
        FBLbl.Text             = _uiVisible and "Hide UI" or label
        FBLbl.TextColor3       = T.Text
        FBLbl.Font             = Enum.Font.GothamBold; FBLbl.TextSize = 12
        FBLbl.TextXAlignment   = iconData
            and Enum.TextXAlignment.Left
            or  Enum.TextXAlignment.Center
        FBLbl.TextYAlignment   = Enum.TextYAlignment.Center
        FBLbl.ZIndex           = 51; FBLbl.Parent = FB

        -- ── Hover (gradient-safe) ─────────────────
        local function onEnter()
            if isGradient then
                Tween(FB, TweenInfo.new(0.12), {BackgroundTransparency = 0.14})
            else
                Tween(FB, TweenInfo.new(0.12), {BackgroundColor3 = Color3.new(
                    math.min(solidBg.R*1.18,1),
                    math.min(solidBg.G*1.18,1),
                    math.min(solidBg.B*1.18,1))})
            end
        end
        local function onLeave()
            if isGradient then
                Tween(FB, TweenInfo.new(0.12), {BackgroundTransparency = 0})
            else
                Tween(FB, TweenInfo.new(0.12), {BackgroundColor3 = solidBg})
            end
        end
        FB.MouseEnter:Connect(onEnter)
        FB.MouseLeave:Connect(onLeave)

        -- Click
        FB.MouseButton1Click:Connect(function()
            if _uiVisible then _DoHide() else _DoShow() end
        end)

        -- ── Sync callbacks ────────────────────────
        -- Reveals the button the first time _DoShow fires (key cleared).
        -- Also keeps the label text in sync on every open/close.
        table.insert(_openCloseCbs, function(visible)
            if _uiUnlocked and enabledCfg then
                if not (onlyMobile and not UserInputService.TouchEnabled) then
                    FB.Visible = true
                end
            end
            FBLbl.Text = visible and "Hide UI" or (WindowObj._floatBtnLabel or label)
        end)

        -- ── Draggable ─────────────────────────────
        local setDraggable = MakeDraggableToggleable(FB)
        if cfg.Draggable == false then setDraggable(false) end

        -- ── Store all refs for EditMinimizeBtn ────
        WindowObj._floatBtn        = FB
        WindowObj._floatBtnLbl     = FBLbl
        WindowObj._floatBtnIco     = FBIco
        WindowObj._floatBtnCorner  = fbCorner
        WindowObj._floatBtnStroke  = fbStroke
        WindowObj._floatBtnGrad    = fbGrad
        WindowObj._floatBtnLabel   = label
        WindowObj._floatBtnSolidBg = solidBg
        WindowObj._floatBtnIsGrad  = isGradient
        WindowObj._floatBtnSetDrag = setDraggable
        WindowObj._floatBtnEnabled = enabledCfg
        WindowObj._floatBtnMobile  = onlyMobile
        WindowObj._floatBtnOnEnter = onEnter
        WindowObj._floatBtnOnLeave = onLeave

        return FB
    end

    -- ─────────────────────────────────────────────
    --  EditMinimizeBtn  — edit any property live
    --  Same keys as CreateMinimizeBtn.
    -- ─────────────────────────────────────────────
    function WindowObj:EditMinimizeBtn(ncfg)
        ncfg = ncfg or {}
        local FB = WindowObj._floatBtn
        if not FB or not FB.Parent then
            warn("EditMinimizeBtn: call CreateMinimizeBtn first."); return
        end

        -- Title
        if ncfg.Title ~= nil then
            WindowObj._floatBtnLabel = ncfg.Title
            if WindowObj._floatBtnLbl then
                WindowObj._floatBtnLbl.Text = _uiVisible and "Hide UI" or ncfg.Title
            end
        end

        -- Icon
        if ncfg.Icon ~= nil then
            -- destroy old icon
            if WindowObj._floatBtnIco and WindowObj._floatBtnIco.Parent then
                WindowObj._floatBtnIco:Destroy(); WindowObj._floatBtnIco = nil
            end
            local nd = _ResolveIcon(ncfg.Icon)
            if nd then
                local ni = Instance.new("ImageLabel")
                ni.Size        = UDim2.new(0,16,0,16)
                ni.Position    = UDim2.new(0,10,0.5,0)
                ni.AnchorPoint = Vector2.new(0,0.5)
                ni.BackgroundTransparency = 1
                ni.Image       = nd.Image
                if nd.RectSize ~= Vector2.new(0,0) then
                    ni.ImageRectSize   = nd.RectSize
                    ni.ImageRectOffset = nd.RectPos
                end
                ni.ImageColor3 = T.Text; ni.ZIndex = 51; ni.Parent = FB
                WindowObj._floatBtnIco = ni
                if WindowObj._floatBtnLbl then
                    WindowObj._floatBtnLbl.Size = UDim2.new(1,-40,1,0)
                    WindowObj._floatBtnLbl.Position = UDim2.new(0,32,0,0)
                    WindowObj._floatBtnLbl.TextXAlignment = Enum.TextXAlignment.Left
                end
            else
                WindowObj._floatBtnIco = nil
                if WindowObj._floatBtnLbl then
                    WindowObj._floatBtnLbl.Size = UDim2.new(1,-16,1,0)
                    WindowObj._floatBtnLbl.Position = UDim2.new(0,8,0,0)
                    WindowObj._floatBtnLbl.TextXAlignment = Enum.TextXAlignment.Center
                end
            end
        end

        -- CornerRadius
        if ncfg.CornerRadius ~= nil and WindowObj._floatBtnCorner then
            WindowObj._floatBtnCorner.CornerRadius = ncfg.CornerRadius
        end

        -- StrokeThickness
        if ncfg.StrokeThickness ~= nil and WindowObj._floatBtnStroke then
            WindowObj._floatBtnStroke.Thickness = ncfg.StrokeThickness
        end

        -- Color (ColorSequence | Color3 | string)
        if ncfg.Color ~= nil then
            -- Remove existing gradient
            if WindowObj._floatBtnGrad and WindowObj._floatBtnGrad.Parent then
                WindowObj._floatBtnGrad:Destroy(); WindowObj._floatBtnGrad = nil
            end
            local cSeq = typeof(ncfg.Color) == "ColorSequence"
            local cC3  = typeof(ncfg.Color) == "Color3"
            local cStr = type(ncfg.Color) == "string"
            if cSeq then
                WindowObj._floatBtnIsGrad  = true
                WindowObj._floatBtnSolidBg = Color3.new(1,1,1)
                FB.BackgroundColor3        = Color3.new(1,1,1)
                local g = Instance.new("UIGradient")
                g.Color = ncfg.Color; g.Rotation = 90; g.Parent = FB
                WindowObj._floatBtnGrad = g
            elseif cC3 then
                WindowObj._floatBtnIsGrad  = false
                WindowObj._floatBtnSolidBg = ncfg.Color
                Tween(FB, TweenInfo.new(0.22), {BackgroundColor3 = ncfg.Color})
            elseif cStr then
                WindowObj._floatBtnIsGrad = false
                local clrs = {Red=T.Danger,Green=T.Success,Blue=T.Blue,
                               Purple=T.Accent,Yellow=T.Warning,Orange=T.Orange}
                local c = clrs[ncfg.Color] or T.Accent
                WindowObj._floatBtnSolidBg = c
                Tween(FB, TweenInfo.new(0.22), {BackgroundColor3 = c})
            end
        end

        -- Enabled
        if ncfg.Enabled ~= nil then
            WindowObj._floatBtnEnabled = ncfg.Enabled
            if not ncfg.Enabled then
                FB.Visible = false
            elseif _uiUnlocked then
                local mob = WindowObj._floatBtnMobile
                if not (mob and not UserInputService.TouchEnabled) then
                    FB.Visible = true
                end
            end
        end

        -- OnlyMobile
        if ncfg.OnlyMobile ~= nil then
            WindowObj._floatBtnMobile = ncfg.OnlyMobile
            local hide = ncfg.OnlyMobile and not UserInputService.TouchEnabled
            if hide then
                FB.Visible = false
            elseif _uiUnlocked and WindowObj._floatBtnEnabled then
                FB.Visible = true
            end
        end

        -- Draggable
        if ncfg.Draggable ~= nil and WindowObj._floatBtnSetDrag then
            WindowObj._floatBtnSetDrag(ncfg.Draggable)
        end
    end

    -- ── Tab ──────────────────────────────────────
    function WindowObj:Tab(cfg)
        cfg = cfg or {}; local tabName = cfg.Title or "Tab"; local locked = cfg.Locked or false

        local tabIconData = not locked and _ResolveIcon(cfg.Icon) or nil

        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1,0,0,34)
        TabBtn.BackgroundColor3 = T.Tertiary
        -- Text set to tabName (no spaces). Indent is handled by UIPadding below.
        TabBtn.Text = locked and ("🔒  "..tabName) or tabName
        TabBtn.TextColor3 = T.SubText; TabBtn.Font = Enum.Font.Gotham; TabBtn.TextSize = 12
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.BorderSizePixel = 0; TabBtn.LayoutOrder = #allTabs+1; TabBtn.Parent = SideV2.Scroll
        Corner(TabBtn,8)

        -- UIPadding pushes the text right to make room for the icon (or just adds left margin)
        local TabPad = Instance.new("UIPadding"); TabPad.Parent = TabBtn
        TabPad.PaddingLeft  = UDim.new(0, tabIconData and 34 or 12)
        TabPad.PaddingRight = UDim.new(0, 6)

        -- Icon: AnchorPoint=(0,0.5) + Position Y=0.5 → perfect vertical center, no manual offset
        local tabIconLabel = nil
        if tabIconData then
            tabIconLabel = Instance.new("ImageLabel")
            tabIconLabel.Size        = UDim2.new(0,15,0,15)
            tabIconLabel.Position    = UDim2.new(0,10,0.5,0)   -- ← was 0.5,-7 (bug fixed)
            tabIconLabel.AnchorPoint = Vector2.new(0,0.5)
            tabIconLabel.BackgroundTransparency = 1
            tabIconLabel.Image       = tabIconData.Image
            if tabIconData.RectSize ~= Vector2.new(0,0) then
                tabIconLabel.ImageRectSize   = tabIconData.RectSize
                tabIconLabel.ImageRectOffset = tabIconData.RectPos
            end
            tabIconLabel.ImageColor3 = T.SubText
            tabIconLabel.ZIndex = 4; tabIconLabel.Parent = TabBtn
        end

        local TabV2=ScrollV2(ContentArea,UDim2.fromScale(1,1),UDim2.fromScale(0,0),
            {top=4,bottom=16,left=4,right=6},SCRBARS and 4 or 0,T.Accent)
        TabV2.Wrapper.Visible=false

        local entry={Btn=TabBtn, Wrapper=TabV2.Wrapper, Scroll=TabV2.Scroll, IconLabel=tabIconLabel}
        table.insert(allTabs,entry)
        if #allTabs==1 then SetActiveTab(entry) end

        TabBtn.MouseButton1Click:Connect(function() if not locked then SetActiveTab(entry) end end)
        TabBtn.MouseEnter:Connect(function()
            if activeTab~=entry and not locked then Tween(TabBtn,TweenInfo.new(0.12),{BackgroundColor3=T.Border}) end
        end)
        TabBtn.MouseLeave:Connect(function()
            if activeTab~=entry then Tween(TabBtn,TweenInfo.new(0.12),{BackgroundColor3=T.Tertiary}) end
        end)

        task.spawn(function()
            while TabBtn and TabBtn.Parent do
                TabBtn.Visible=searchQuery=="" or tabName:lower():find(searchQuery,1,true)~=nil
                task.wait(0.15)
            end
        end)

        -- ── element helpers ───────────────────────
        local function NewElem(h)
            local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,h)
            f.BackgroundColor3=T.Elem; f.BorderSizePixel=0; f.Parent=TabV2.Scroll; Corner(f,10); return f
        end
        -- Labels: title + optional description, offset ox pixels right for element icons.
        -- Uses AnchorPoint so text is always pixel-perfect regardless of element height.
        local function Labels(parent, title, desc, ox)
            ox = ox or 0; local hasD = desc and desc ~= ""
            local tl = Instance.new("TextLabel")
            tl.Size        = UDim2.new(1,-120-ox,0,16)
            tl.Position    = UDim2.new(0,12+ox,0.5,0)
            tl.AnchorPoint = Vector2.new(0, hasD and 0.85 or 0.5)
            tl.BackgroundTransparency = 1
            tl.Text = title; tl.TextColor3 = T.Text
            tl.Font = Enum.Font.GothamBold; tl.TextSize = 13
            tl.TextXAlignment = Enum.TextXAlignment.Left
            tl.TextYAlignment = Enum.TextYAlignment.Center
            tl.Parent = parent
            if hasD then
                local dl = Instance.new("TextLabel")
                dl.Size        = UDim2.new(1,-120-ox,0,13)
                dl.Position    = UDim2.new(0,12+ox,0.5,0)
                dl.AnchorPoint = Vector2.new(0,-0.15)
                dl.BackgroundTransparency = 1
                dl.Text = desc; dl.TextColor3 = T.SubText
                dl.Font = Enum.Font.Gotham; dl.TextSize = 11
                dl.TextXAlignment = Enum.TextXAlignment.Left
                dl.TextYAlignment = Enum.TextYAlignment.Center
                dl.Parent = parent
            end
        end

        local Elem={}

        -- BUTTON
        function Elem:Button(cfg)
            cfg=cfg or {}; local lk=cfg.Locked or false
            local e=NewElem(52); Labels(e,cfg.Title or "Button",cfg.Desc or "")
            local Btn=Instance.new("TextButton"); Btn.Size=UDim2.new(0,68,0,28); Btn.Position=UDim2.new(1,-78,0.5,-14)
            Btn.BackgroundColor3=lk and T.Border or T.Accent; Btn.Text=lk and "🔒" or "Run"
            Btn.TextColor3=T.Text; Btn.Font=Enum.Font.GothamBold; Btn.TextSize=12; Btn.BorderSizePixel=0; Btn.Parent=e; Corner(Btn,8)
            if not lk then
                Btn.MouseEnter:Connect(function() Tween(Btn,TweenInfo.new(0.12),{BackgroundColor3=T.AccentHov}) end)
                Btn.MouseLeave:Connect(function() Tween(Btn,TweenInfo.new(0.12),{BackgroundColor3=T.Accent}) end)
                Btn.MouseButton1Click:Connect(function()
                    Tween(Btn,TweenInfo.new(0.07),{BackgroundColor3=T.Text})
                    task.delay(0.14,function() Tween(Btn,TweenInfo.new(0.15),{BackgroundColor3=T.Accent}) end)
                    if cfg.Callback then task.spawn(cfg.Callback) end
                end)
            end
            -- Label refs for Refresh
            local _titleLbl = e:FindFirstChildWhichIsA("TextLabel")
            return {
                SetLocked = function(v) lk=v; Btn.BackgroundColor3=v and T.Border or T.Accent; Btn.Text=v and "🔒" or "Run" end,
                Refresh   = function(ncfg)
                    ncfg = ncfg or {}
                    if ncfg.Title then
                        for _, c in ipairs(e:GetChildren()) do
                            if c:IsA("TextLabel") then c.Text = ncfg.Title; break end
                        end
                    end
                    if ncfg.Locked ~= nil then
                        lk = ncfg.Locked
                        Btn.BackgroundColor3 = lk and T.Border or T.Accent
                        Btn.Text = lk and "🔒" or "Run"
                    end
                    if ncfg.Callback then cfg.Callback = ncfg.Callback end
                end,
            }
        end

        -- DROPDOWN
        function Elem:Dropdown(cfg)
            cfg=cfg or {}; local vals=cfg.Values or {}; local cur=cfg.Value or (vals[1] or "None")
            local e=NewElem(52); Labels(e,cfg.Title or "Dropdown",cfg.Desc or "")
            local DBtn=Instance.new("TextButton"); DBtn.Size=UDim2.new(0,124,0,28); DBtn.Position=UDim2.new(1,-134,0.5,-14)
            DBtn.BackgroundColor3=T.Tertiary; DBtn.Text=cur.."  ▾"; DBtn.TextColor3=T.Text
            DBtn.Font=Enum.Font.Gotham; DBtn.TextSize=12; DBtn.BorderSizePixel=0; DBtn.ClipsDescendants=true; DBtn.Parent=e; Corner(DBtn,8)
            local dStr=NewStroke(DBtn,T.Border)
            DBtn.MouseEnter:Connect(function() Tween(DBtn,TweenInfo.new(0.12),{BackgroundColor3=T.BorderHi}); Tween(dStr,TweenInfo.new(0.12),{Color=T.Accent}) end)
            DBtn.MouseLeave:Connect(function() Tween(DBtn,TweenInfo.new(0.12),{BackgroundColor3=T.Tertiary}); Tween(dStr,TweenInfo.new(0.12),{Color=T.Border}) end)
            DBtn.MouseButton1Click:Connect(function()
                OpenDropdown(T,cfg.Title or "Select",vals,cur,function(val)
                    cur=val; DBtn.Text=val.."  ▾"; if cfg.Callback then task.spawn(cfg.Callback,val) end
                end)
            end)
            return {
                SetValue  = function(v) cur=v; DBtn.Text=v.."  ▾" end,
                GetValue  = function() return cur end,
                SetValues = function(nv) vals=nv; if not table.find(vals,cur) then cur=vals[1] or "None"; DBtn.Text=cur.."  ▾" end end,
                -- Refresh accepts an array of new values directly:
                --   DD:Refresh({ "Cat A", "Cat B" })
                -- or a config table:
                --   DD:Refresh({ Values={"Cat A"}, Value="Cat A", Title="New" })
                Refresh   = function(data)
                    data = data or {}
                    -- Detect raw array vs config table
                    local newVals = (type(data[1]) == "string") and data or data.Values
                    if newVals then
                        vals = newVals
                        if not table.find(vals, cur) then
                            cur = vals[1] or "None"; DBtn.Text = cur.."  ▾"
                        end
                    end
                    if data.Value and table.find(vals, data.Value) then
                        cur = data.Value; DBtn.Text = cur.."  ▾"
                    end
                    if data.Title then
                        cfg.Title = data.Title
                        for _, c in ipairs(e:GetChildren()) do
                            if c:IsA("TextLabel") then c.Text = data.Title; break end
                        end
                    end
                end,
            }
        end

        -- TOGGLE  ✅  (supports Icon = "lucide-icon-name")
        function Elem:Toggle(cfg)
            cfg=cfg or {}; local state=cfg.Value or false
            local e=NewElem(52)

            -- Left-side element icon
            local togIconOffset = 0
            local togIconData   = _ResolveIcon(cfg.Icon)
            if togIconData then
                togIconOffset = 26
                local ico = Instance.new("ImageLabel")
                ico.Size              = UDim2.new(0,16,0,16)
                ico.Position          = UDim2.new(0,10,0.5,0)
                ico.AnchorPoint       = Vector2.new(0,0.5)
                ico.BackgroundTransparency = 1
                ico.Image             = togIconData.Image
                if togIconData.RectSize ~= Vector2.new(0,0) then
                    ico.ImageRectSize   = togIconData.RectSize
                    ico.ImageRectOffset = togIconData.RectPos
                end
                ico.ImageColor3 = T.SubText; ico.ZIndex = 2; ico.Parent = e
            end

            Labels(e,cfg.Title or "Toggle",cfg.Desc or "",togIconOffset)
            local Track=Instance.new("Frame"); Track.Size=UDim2.new(0,46,0,24); Track.Position=UDim2.new(1,-58,0.5,-12)
            Track.BackgroundColor3=state and T.Accent or T.Border; Track.BorderSizePixel=0; Track.Parent=e; Corner(Track,12)
            local Knob=Instance.new("Frame"); Knob.Size=UDim2.new(0,18,0,18); Knob.AnchorPoint=Vector2.new(0,0.5)
            Knob.Position=state and UDim2.new(0,25,0.5,0) or UDim2.new(0,3,0.5,0)
            Knob.BackgroundColor3=T.Text; Knob.BorderSizePixel=0; Knob.ZIndex=2; Knob.Parent=Track; Corner(Knob,9)
            local Click=Instance.new("TextButton"); Click.Size=UDim2.fromScale(1,1)
            Click.BackgroundTransparency=1; Click.Text=""; Click.ZIndex=3; Click.Parent=Track
            local function Apply(v)
                state=v
                Tween(Track,TweenInfo.new(0.2),{BackgroundColor3=v and T.Accent or T.Border})
                Tween(Knob,TweenInfo.new(0.22,Enum.EasingStyle.Back),
                    {Position=v and UDim2.new(0,25,0.5,0) or UDim2.new(0,3,0.5,0)})
            end
            Click.MouseButton1Click:Connect(function() Apply(not state); if cfg.Callback then task.spawn(cfg.Callback,state) end end)
            return {
                SetValue = Apply,
                GetValue = function() return state end,
                Refresh  = function(ncfg)
                    ncfg = ncfg or {}
                    if ncfg.Value ~= nil then Apply(ncfg.Value) end
                    if ncfg.Title then
                        for _, c in ipairs(e:GetChildren()) do
                            if c:IsA("TextLabel") then c.Text = ncfg.Title; break end
                        end
                    end
                    if ncfg.Callback then cfg.Callback = ncfg.Callback end
                end,
            }
        end

        -- SLIDER  ✅  (Locked=true freezes value; isolated drag — no accidental slide)
        function Elem:Slider(cfg)
            cfg = cfg or {}; local vc = cfg.Value or {}
            local mn  = vc.Min or 0; local mx = vc.Max or 100; local def = vc.Default or mn
            local stp = cfg.Step or 1
            local cur = math.clamp(def, mn, mx)
            local isLocked = cfg.Locked == true

            local e = NewElem(72)

            local TL = Instance.new("TextLabel"); TL.Size = UDim2.new(1,-92,0,16); TL.Position = UDim2.new(0,12,0,9)
            TL.BackgroundTransparency = 1; TL.Text = cfg.Title or "Slider"; TL.TextColor3 = T.Text
            TL.Font = Enum.Font.GothamBold; TL.TextSize = 13; TL.TextXAlignment = Enum.TextXAlignment.Left; TL.Parent = e

            local VL = Instance.new("TextLabel"); VL.Size = UDim2.new(0,76,0,16); VL.Position = UDim2.new(1,-86,0,9)
            VL.BackgroundTransparency = 1; VL.Text = tostring(cur); VL.TextColor3 = T.Accent
            VL.Font = Enum.Font.GothamBold; VL.TextSize = 13; VL.TextXAlignment = Enum.TextXAlignment.Right; VL.Parent = e

            -- Lock icon (shown when locked)
            local LockLbl = Instance.new("TextLabel"); LockLbl.Size = UDim2.new(0,20,0,16)
            LockLbl.Position = UDim2.new(1,-108,0,9); LockLbl.BackgroundTransparency = 1
            LockLbl.Text = "🔒"; LockLbl.TextSize = 11; LockLbl.ZIndex = 3
            LockLbl.Visible = isLocked; LockLbl.Parent = e

            if cfg.Desc and cfg.Desc ~= "" then
                local DL = Instance.new("TextLabel"); DL.Size = UDim2.new(1,-92,0,13); DL.Position = UDim2.new(0,12,0,28)
                DL.BackgroundTransparency = 1; DL.Text = cfg.Desc; DL.TextColor3 = T.SubText
                DL.Font = Enum.Font.Gotham; DL.TextSize = 11; DL.TextXAlignment = Enum.TextXAlignment.Left; DL.Parent = e
            end

            local TrBg = Instance.new("Frame"); TrBg.Size = UDim2.new(1,-24,0,6); TrBg.Position = UDim2.new(0,12,1,-17)
            TrBg.BackgroundColor3 = T.Tertiary; TrBg.BorderSizePixel = 0; TrBg.Parent = e; Corner(TrBg,3)

            local Fill = Instance.new("Frame"); Fill.Size = UDim2.new((cur-mn)/(mx-mn),0,1,0)
            Fill.BackgroundColor3 = T.Accent; Fill.BorderSizePixel = 0; Fill.Parent = TrBg; Corner(Fill,3)
            local FG = Instance.new("UIGradient"); FG.Color = ColorSequence.new(T.AccentDim,T.AccentHov); FG.Parent = Fill

            local Knob = Instance.new("Frame"); Knob.Size = UDim2.new(0,16,0,16); Knob.AnchorPoint = Vector2.new(0.5,0.5)
            Knob.Position = UDim2.new((cur-mn)/(mx-mn),0,0.5,0); Knob.BackgroundColor3 = T.Text
            Knob.BorderSizePixel = 0; Knob.ZIndex = 3; Knob.Parent = TrBg; Corner(Knob,8)

            -- Hit area is a SIBLING of TrBg inside `e`, NOT a child of TrBg
            -- This prevents it from bleeding outside its element and captures
            -- only intentional drags on the slider row.
            local Hit = Instance.new("TextButton")
            Hit.Size     = UDim2.new(1,-24,0,28)
            Hit.Position = UDim2.new(0,12,1,-31)   -- covers TrBg + comfortable height
            Hit.BackgroundTransparency = 1; Hit.Text = ""; Hit.ZIndex = 4; Hit.Parent = e

            local function Snap(r)
                local v = stp >= 1 and math.round(r/stp)*stp or math.round(r*(1/stp))/(1/stp)
                return math.clamp(v, mn, mx)
            end
            local function Apply(v)
                cur = v; local p = (cur-mn)/(mx-mn)
                Fill.Size = UDim2.new(p,0,1,0); Knob.Position = UDim2.new(p,0,0.5,0); VL.Text = tostring(cur)
            end
            local function ToVal(screenX)
                local tx = TrBg.AbsolutePosition.X; local tw = TrBg.AbsoluteSize.X
                if tw <= 0 then return cur end
                return Snap(mn + (mx-mn)*math.clamp((screenX-tx)/tw, 0, 1))
            end

            -- Per-slider drag state (not shared with other sliders)
            local isDrag = false; local hb = nil
            local dragToken = {}  -- unique table per slider instance used as ownership check

            local function StopDrag(token)
                if not isDrag or token ~= dragToken then return end
                isDrag = false
                Tween(Knob,TweenInfo.new(0.1),{Size=UDim2.new(0,16,0,16),BackgroundColor3=T.Text})
                if hb then hb:Disconnect(); hb = nil end
            end

            local function StartDrag(token)
                if isLocked then return end
                isDrag = true
                Tween(Knob,TweenInfo.new(0.08),{Size=UDim2.new(0,20,0,20)})
                if hb then hb:Disconnect() end
                hb = RunService.Heartbeat:Connect(function()
                    -- Stop if ownership changed (another slider stole focus) or button released
                    if not isDrag or token ~= dragToken then hb:Disconnect(); hb = nil; return end
                    local mp = UserInputService:GetMouseLocation()
                    local nv = ToVal(mp.X)
                    if nv ~= cur then Apply(nv); if cfg.Callback then task.spawn(cfg.Callback, cur) end end
                end)
            end

            Hit.MouseButton1Down:Connect(function()
                if isLocked then return end
                -- New drag session: new token invalidates any stale Heartbeat
                dragToken = {}; local myToken = dragToken
                local mp = UserInputService:GetMouseLocation()
                Apply(ToVal(mp.X))
                if cfg.Callback then task.spawn(cfg.Callback, cur) end
                StartDrag(myToken)
                -- Stop when THIS button's input ends (most reliable per-slider stop)
                local conn; conn = UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        StopDrag(myToken); conn:Disconnect()
                    end
                end)
            end)

            TrBg.MouseEnter:Connect(function() if not isDrag and not isLocked then Tween(Knob,TweenInfo.new(0.12),{BackgroundColor3=T.AccentHov}) end end)
            TrBg.MouseLeave:Connect(function() if not isDrag then Tween(Knob,TweenInfo.new(0.12),{BackgroundColor3=T.Text}) end end)

            -- Apply locked visual state
            local function ApplyLockVisual()
                local col = isLocked and T.SubText or T.Accent
                Tween(Fill,TweenInfo.new(0.15),{BackgroundColor3=col})
                Tween(Knob,TweenInfo.new(0.15),{BackgroundColor3=isLocked and T.SubText or T.Text})
                LockLbl.Visible = isLocked
                VL.TextColor3 = col
            end

            return {
                SetValue  = function(v) if not isLocked then Apply(math.clamp(v,mn,mx)) end end,
                GetValue  = function() return cur end,
                SetLocked = function(v)
                    isLocked = v
                    -- Stop any active drag immediately
                    if v then dragToken = {}; isDrag = false; if hb then hb:Disconnect(); hb=nil end end
                    ApplyLockVisual()
                end,
                Refresh   = function(ncfg)
                    ncfg = ncfg or {}
                    if ncfg.Min   then mn  = ncfg.Min   end
                    if ncfg.Max   then mx  = ncfg.Max   end
                    if ncfg.Step  then stp = ncfg.Step  end
                    if ncfg.Default then Apply(math.clamp(ncfg.Default,mn,mx)) end
                    if ncfg.Title then TL.Text = ncfg.Title end
                    if ncfg.Locked ~= nil then
                        isLocked = ncfg.Locked
                        if isLocked then dragToken={}; isDrag=false; if hb then hb:Disconnect(); hb=nil end end
                        ApplyLockVisual()
                    end
                end,
            }
        end

        -- INPUT / TEXTAREA  ✅  (Icon = left of title, InputIcon = inside box)
        function Elem:Input(cfg)
            cfg=cfg or {}
            local isTA    = cfg.Type=="Textarea"
            local h       = isTA and 84 or 52
            local e       = NewElem(h)

            -- Left-side element icon (next to title)
            local inpIconOffset = 0
            local inpElemIcon   = _ResolveIcon(cfg.Icon)
            if inpElemIcon then
                inpIconOffset = 26
                local ico = Instance.new("ImageLabel")
                ico.Size              = UDim2.new(0,16,0,16)
                ico.Position          = UDim2.new(0,10,0.5,0)
                ico.AnchorPoint       = Vector2.new(0,0.5)
                ico.BackgroundTransparency = 1
                ico.Image             = inpElemIcon.Image
                if inpElemIcon.RectSize ~= Vector2.new(0,0) then
                    ico.ImageRectSize   = inpElemIcon.RectSize
                    ico.ImageRectOffset = inpElemIcon.RectPos
                end
                ico.ImageColor3 = T.SubText; ico.ZIndex = 2; ico.Parent = e
            end

            Labels(e, cfg.Title or "Input", cfg.Desc or "", inpIconOffset)

            local IBg=Instance.new("Frame")
            IBg.Size=UDim2.new(0,158,0,isTA and 60 or 28)
            IBg.Position=UDim2.new(1,-168,0.5,isTA and -30 or -14)
            IBg.BackgroundColor3=T.Tertiary; IBg.BorderSizePixel=0; IBg.Parent=e; Corner(IBg,8)
            local iStr=NewStroke(IBg,T.Border)

            -- InputIcon: small ImageLabel on the left inside the input box
            local inputIconOffset = 0
            local inputIconData   = _ResolveIcon(cfg.InputIcon)
            local icoLabel        = nil

            if inputIconData then
                inputIconOffset = 26
                icoLabel = Instance.new("ImageLabel")
                icoLabel.Size             = UDim2.new(0,14,0,14)
                icoLabel.Position         = UDim2.new(0,8,0.5,0)
                icoLabel.AnchorPoint      = Vector2.new(0,0.5)
                icoLabel.BackgroundTransparency = 1
                icoLabel.Image            = inputIconData.Image
                if inputIconData.RectSize ~= Vector2.new(0,0) then
                    icoLabel.ImageRectSize   = inputIconData.RectSize
                    icoLabel.ImageRectOffset = inputIconData.RectPos
                end
                icoLabel.ImageColor3      = T.SubText
                icoLabel.ZIndex           = 4
                icoLabel.Parent           = IBg
            end

            local TB=Instance.new("TextBox")
            TB.Size=UDim2.new(1,-(12+inputIconOffset),1,-6)
            TB.Position=UDim2.new(0,6+inputIconOffset,0,3)
            TB.BackgroundTransparency=1; TB.Text=cfg.Value or ""
            TB.PlaceholderText=cfg.Placeholder or "Enter text..."
            TB.PlaceholderColor3=T.SubText; TB.TextColor3=T.Text; TB.Font=Enum.Font.Gotham; TB.TextSize=12
            TB.TextXAlignment=Enum.TextXAlignment.Left
            TB.TextYAlignment=isTA and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center
            TB.TextWrapped=isTA; TB.MultiLine=isTA; TB.ClearTextOnFocus=false
            TB.BorderSizePixel=0; TB.Parent=IBg

            TB.Focused:Connect(function()
                Tween(iStr,TweenInfo.new(0.15),{Color=T.Accent})
                Tween(IBg, TweenInfo.new(0.15),{BackgroundColor3=T.BorderHi})
                if icoLabel then Tween(icoLabel,TweenInfo.new(0.15),{ImageColor3=T.Accent}) end
            end)
            TB.FocusLost:Connect(function()
                Tween(iStr,TweenInfo.new(0.15),{Color=T.Border})
                Tween(IBg, TweenInfo.new(0.15),{BackgroundColor3=T.Tertiary})
                if icoLabel then Tween(icoLabel,TweenInfo.new(0.15),{ImageColor3=T.SubText}) end
                if cfg.Callback then task.spawn(cfg.Callback,TB.Text) end
            end)

            return {SetValue=function(v) TB.Text=v end, GetValue=function() return TB.Text end}
        end

        -- SECTION DIVIDER
        function Elem:Section(text)
            local w=Instance.new("Frame"); w.Size=UDim2.new(1,0,0,26)
            w.BackgroundTransparency=1; w.BorderSizePixel=0; w.Parent=TabV2.Scroll
            local line=Instance.new("Frame"); line.Size=UDim2.new(1,-16,0,1); line.Position=UDim2.new(0,8,0.5,0)
            line.BackgroundColor3=T.Border; line.BorderSizePixel=0; line.Parent=w
            local bg2=Instance.new("Frame"); bg2.Position=UDim2.new(0,12,0,4)
            bg2.Size=UDim2.new(0,0,0,18); bg2.AutomaticSize=Enum.AutomaticSize.X
            bg2.BackgroundColor3=T.Bg; bg2.BorderSizePixel=0; bg2.Parent=w
            local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(0,0,1,0); lbl.AutomaticSize=Enum.AutomaticSize.X
            lbl.BackgroundTransparency=1; lbl.Text="  "..(text or "Section").."  "
            lbl.TextColor3=T.Accent; lbl.Font=Enum.Font.GothamBold; lbl.TextSize=11; lbl.Parent=bg2
            return lbl
        end

        return Elem
    end -- :Tab()

    -- show window (uses shared state so FloatBtn / ToggleKey stay in sync)
    local function ShowMain()
        _DoShow()
    end

    if config.KeySystem then
        ShowKeySystem(config,T,ShowMain,function() Main:Destroy(); ScreenGui:Destroy() end)
    else
        ShowMain()
    end

    return WindowObj
end -- :CreateWindow()

return Library
