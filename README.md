# **LibraryGlass UI**


## Library
```
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/sokpanha10000-oss/SKUI/refs/heads/main/main.lua", true))()
```

### Window
```
local Window = Library:CreateWindow({
    Title = "My Super Hub",
    Image = "rbxassetid://YOUR_IMAGE_ID",   -- optional logo
    Author = "by .ftgs and .ftgs",            -- optional author line
})
```

### MinimizeBtn
```
local MinimizeBtn = Window:CreateMinimizeBtn({
    Title = "Open UI",                        -- tooltip on hover
    Image = "rbxassetid://YOUR_ICON_ID",      -- optional icon
})
```

#### Tab
```
local Tab = Window:CreateTab("Misc")
```

#### Gropbox
```
local Group = MainTab:CreateGroupbox("All Features")
```

```
MainGroup:CreateButton({
    Title = "Print Hello",
    Locked = false,          -- true = greyed out, unclickable
    Callback = function()
        print("Hello from SKUI!")
    end,
})
```

```
MainGroup:CreateButton({
    Title = "Locked Button",
    Locked = true,
    Callback = function()
        -- never fires when Locked = true
    end,
})
```

```
local MyToggle = MainGroup:CreateToggle({
    Title = "Enable Feature",
    Desc = "Activates the main feature",   -- optional sub-text
    Value = false,                           -- default state
    Callback = function(state)
        print("Toggle is now: " .. tostring(state))
    end,
})

-- Programmatic control:
-- MyToggle:Set(true)
```

```
local SpeedSlider = MainGroup:CreateSlider({
    Title = "Walk Speed",
    Step = 1,            -- use 0.1 for float steps
    Value = {
        Min = 16,
        Max = 200,
        Default = 16,
    },
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end,
})
```

```
-- Float step example:
local SensSlider = MainGroup:CreateSlider({
    Title = "Sensitivity",
    Step  = 0.1,
    Value = { Min = 0.1, Max = 5.0, Default = 1.0 },
    Callback = function(value)
        print("Sensitivity: " .. value)
    end,
})

-- Programmatic control:
-- SpeedSlider:Set(50)
```

```
local NameInput = MainGroup:CreateInput({
    Title = "Player Name",
    Value = "",                    -- default text
    Placeholder = "Enter player name...",
    Callback = function(text)
        print("Input received: " .. text)
    end,
})

-- Programmatic control:
-- NameInput:Set("Roblox")
```

```
local TeamDropdown = MainGroup:CreateDropdown({
    Title = "Select Team",
    Values = { "Red", "Blue", "Green", "Yellow", "Purple" },
    Value = "Red",     -- default selected
    Callback = function(option)
        print("Team selected: " .. option)
    end,
})
```


```
-- Refresh dropdown options at any time:
-- TeamDropdown:Refresh({ "Red", "Blue" })
```

```
-- Set a specific value:
-- TeamDropdown:Set("Blue")
```
