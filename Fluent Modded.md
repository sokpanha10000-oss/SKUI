# Fluent Modded
- if hard to get fluent modded join this link

## Getting Library 
```
local Fluent = loadstring(game:HttpGet("https://github.com/StyearX/Fluent-Modded/releases/download/1.6.0/Example.lua"))()
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
BasicSection:AddDropdown("DropdownWithSearch", {
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
BasicSection:AddDropdown("DropdownNoSearch", {
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
BasicSection:AddDropdown("MultiDropdown", {
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
BasicSection:AddColorpicker("MyColorpicker", {
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
BasicSection:AddKeybind("KeybindToggle", {
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
BasicSection:AddKeybind("KeybindHold", {
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
BasicSection:AddButton({
    Title    = "Show Notification",
    Callback = function()
        
    end,
})
```

### Paragraph
```
-- Paragraph
BasicSection:AddParagraph({
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
Minimizer = x:CreateMinimizer({
    Icon = "rbxassetid://109639117875913",
    Size = UDim2.fromOffset(64, 64),
    Position = UDim2.new(0.101969875, 0, 0.110441767, 0),
    Corner = 12,
    BackgroundTransparency = 1,
    IconCorner = 6,
    Transparency = 0,
    Lockable = true,
    LockHoldTime = 1.0,
    Draggable = true,
    OnClickSound = {
        "7127123605", "137566474343039", "438666542",
        "257001341", "257000833", "7127123554",
        "131607746976396", "97325669841459", "109312518223078",
    },
})

Minimizer.Visible = true
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
