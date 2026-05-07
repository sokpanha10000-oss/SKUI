# Fluent Modded
- if hard to get fluent modded join this link

## Getting Library 
```
local Fluent = loadstring(game:HttpGet("https://github.com/StyearX/Fluent-Modded/releases/download/FluentPro/Fluent.lua"))()
```

# Save Mangers
```
-- Grab managers (must be done before creating the window)
local SaveManager = Fluent.SaveManager
local InterfaceManager = Fluent.InterfaceManager
local FloatingButtonManager = Fluent.FloatingButtonManager
```

## Create Window
```
local Window = Fluent:CreateWindow({
    Title              = "FluentModded",
    SubTitle           = "dev : StyearX, EvilFish",
    TabWidth           = 160,
    Size               = UDim2.fromOffset(480, 460),
    Acrylic            = true,
    Theme              = "Blood Red",
    MinimizeKey        = Enum.KeyCode.LeftControl,
    UserInfoTop        = true,                     -- Show user info at the TOP
    UserInfoTitle      = game:GetService("Players").LocalPlayer.DisplayName,
    UserInfoSubtitle   = "Advanced User",
    UserInfoColor      = Color3.fromRGB(180, 10, 20),
    Search             = true,                     -- Enable tab search
})
```

## Create tab
```
-- CREATE TABS

local MainTab     = Window:AddTab({ Title = "Main",    Icon = "home"     })
```
```
local SettingsTab = Window:AddTab({ Title = "Settings", Icon = "settings" })
local DialogTab   = Window:AddTab({ Title = "Dialog",   Icon = "message-circle" })
local InfoTab     = Window:AddTab({ Title = "UserInfo", Icon = "user"     })
```

### Section
```
-- SECTION: BASIC CONTROLS (MainTab)

local BasicSection = MainTab:AddSection("Basic Controls")
```

### elements 

### Toggle
```
-- Toggle
BasicSection:AddToggle("MyToggle", {
    Title    = "Enable Feature",
    Default  = false,
    Callback = function(value)
        print("[Toggle]", value)
    end,
})
```

### Slider
```
-- Slider
BasicSection:AddSlider("MySlider", {
    Title    = "Volume",
    Default  = 50,
    Min      = 0,
    Max      = 100,
    Rounding = 1,
    Callback = function(value)
        print("[Slider]", value)
    end,
})
```

### Input
```
-- Input
BasicSection:AddInput("MyInput", {
    Title       = "Username",
    Placeholder = "Type here...",
    Numeric     = false,
    Finished    = false,
    Callback    = function(value)
        print("[Input]", value)
    end,
})
```

### Dropdown With Search
```
-- Dropdown WITH search (default, NoSearch = false or omitted)
AdvancedSection:AddDropdown("DropdownWithSearch", {
    Title    = "Dropdown (with search)",
    Values   = { "Apple", "Banana", "Cherry", "Date", "Elderberry" },
    Default  = "Apple",
    Multi    = false,
    -- NoSearch = false (default) → search bar appears
    Callback = function(value)
        print("[Dropdown w/ search]", value)
    end,
})
```

### Dropdown Normal
```
-- Dropdown WITHOUT search (NoSearch = true)
AdvancedSection:AddDropdown("DropdownNoSearch", {
    Title    = "Dropdown (NO search)",
    Values   = { "Red", "Green", "Blue", "Yellow" },
    Default  = "Red",
    Multi    = false,
    NoSearch = true,   -- 👈 disables the search box inside the dropdown
    Callback = function(value)
        print("[Dropdown no search]", value)
    end,
})
```

### Dropdown Multi Select
```
-- Multi‑select Dropdown (with search, because NoSearch not set)
AdvancedSection:AddDropdown("MultiDropdown", {
    Title    = "Multi‑Select (with search)",
    Values   = { "Option 1", "Option 2", "Option 3", "Option 4" },
    Default  = { "Option 1", "Option 3" },  -- multiple defaults
    Multi    = true,
    Callback = function(value)
        print("[Multi Dropdown] Selected:", value)
    end,
})
```

### Colorpicker
```
-- Colorpicker
AdvancedSection:AddColorpicker("MyColorpicker", {
    Title        = "Pick a Color",
    Default      = Color3.fromRGB(255, 0, 0),
    Transparency = 0,
    Callback     = function(color)
        print("[Color]", color)
    end,
})
```

### keybind
```
-- Keybind – Toggle mode (default)
AdvancedSection:AddKeybind("KeybindToggle", {
    Title    = "Keybind (Toggle)",
    Default  = "LeftAlt",
    Mode     = "Toggle",   -- press to toggle on/off
    Callback = function(toggled)
        print("[Toggle Keybind] state:", toggled)
    end,
})
```

### keybind hold mode
```
-- Keybind – Hold mode
AdvancedSection:AddKeybind("KeybindHold", {
    Title    = "Keybind (Hold)",
    Default  = "F",
    Mode     = "Hold",     -- stays true while held
    Callback = function(held)
        print("[Hold Keybind] holding:", held)
    end,
})
```

### Button
```
-- Button
AdvancedSection:AddButton({
    Title    = "Show Notification",
    Callback = function()
        
    end,
})
```

### Paragraph
```
-- Paragraph
AdvancedSection:AddParagraph({
    Title   = "Information",
    Content = "This is a read‑only paragraph. It can contain long descriptions or help text."
})
```

```
-- Manager Setup

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
FloatingButtonManager:SetLibrary(Fluent)

InterfaceManager:SetFolder("MyHub")
SaveManager:SetFolder("MyHub/Config")
FloatingButtonManager:SetFolder("MyHub/Floating")

InterfaceManager:BuildInterfaceSection(SettingsTab)
SaveManager:BuildConfigSection(SettingsTab)
FloatingButtonManager:BuildConfigSection(SettingsTab)

SaveManager:IgnoreThemeSettings()
SaveManager:LoadAutoloadConfig()
FloatingButtonManager:LoadAutoloadConfig()
```

```
-- FLOATING BUTTON (open/minimize UI) -- optional 

local OpenGui = Instance.new("ScreenGui")
OpenGui.Name         = "OpenUI"
OpenGui.ResetOnSpawn = false
OpenGui.Parent       = game:GetService("CoreGui")

local OpenBtn = Instance.new("ImageButton")
OpenBtn.Size                   = UDim2.fromOffset(55, 55)
OpenBtn.Position               = UDim2.new(0.02, 0, 0.85, 0)
OpenBtn.BackgroundColor3       = Color3.fromRGB(105, 105, 105)
OpenBtn.BackgroundTransparency = 0
OpenBtn.Image                  = "rbxassetid://"   -- replace with your icon ID if desired
OpenBtn.Parent                 = OpenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0.2, 0)

FloatingButtonManager:AddButton("OpenBtn", OpenBtn, false, false)

-- Dragging logic 
local _dragActive, _dragStart, _startPos
OpenBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        _dragActive = true
        _dragStart  = input.Position
        _startPos   = OpenBtn.Position
    end
end)
OpenBtn.InputChanged:Connect(function(input)
    if _dragActive and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - _dragStart
        OpenBtn.Position = UDim2.new(
            _startPos.X.Scale, _startPos.X.Offset + delta.X,
            _startPos.Y.Scale, _startPos.Y.Offset + delta.Y
        )
    end
end)
game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        _dragActive = false
    end
end)
OpenBtn.MouseButton1Click:Connect(function()
    if Window and Window.Minimize then Window:Minimize() end
end)
```

```
-- Notification 
Fluent:Notify({
    Title    = "FluentModded",
    Content  = "example loaded!",
    Duration = 4,
})
```

```
-- Select the first tab
Window:SelectTab(1)
```
