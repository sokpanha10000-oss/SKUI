# ✨ SKUI (SK Library V1)

## 📌 About
- **SKUI** is a rebuilt and optimized version of **SK Library V1**.
- It uses the same UI style as the original, with some improvements and refinements.
- The reason the UI is named **SK** is that it should be the name of the next generation of **redz Hub** UIs

- 🔹 Made by **STEVEKHMER**  
- 🔹 Designed mainly for use in **SK Hub** scripts  
- 🔹 Open-Source, Lightweight, and Optimized  

---

## 🚀 Getting Start
To load **SKUI**, simply run:
```lua
local SKUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/sokpanha10000-oss/SKUI/refs/heads/main/SKUI.luau"))()
```

### Creating a Window
```lua
local Window = SKUI:CreateWindow({
    Title = "My Super Hub",
    Author = "by .ftgs and .ftgs", -- optional
})
```

### Minimizer
```lua
local MinimizeBtn = Window:CreateMinimizeBtn({
  Name = "Open UI",
  Color = "Red",
})
```

### Creating a Tab
Normal
```lua
local Tab = Window:Tab({
    Title = "Tab Title",
    Locked = false,
})
```

#### Toggle
```lua
local Toggle = Tab:Toggle({
    Title = "Toggle",
    Desc = "Toggle Description",
    Type = "Toggle",
    Value = false, -- default value
    Callback = function(state) 
        print("Toggle Activated" .. tostring(state))
    end
})
```

#### Button
```lua
local Button = Tab:Button({
    Title = "Button",
    Desc = "Test Button",
    Locked = false,
    Callback = function()
        -- ...
    end
})
```

#### Slider
```lua
local Slider = Tab:Slider({
    Title = "Slider",
    Desc = "Slider Description",
    
    -- To make float number supported, 
    -- make the Step a float number.
    -- example: Step = 0.1
    Step = 1,
    Value = {
        Min = 20,
        Max = 120,
        Default = 70,
    },
    Callback = function(value)
        print(value)
    end
})
```

#### Dropdown
```lua
local Dropdown = Tab:Dropdown({
    Title = "Dropdown",
    Desc = "Dropdown Description",
    Values = { "Category A", "Category B", "Category C" },
    Value = "Category A",
    Callback = function(option) 
        print("Category selected: " .. option) 
    end
})
```

#### Input
```lua
local Input = Tab:Input({
    Title = "Input",
    Desc = "Input Description",
    Value = "Default value",
    InputIcon = "",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter text...",
    Callback = function(input) 
        print("text entered: " .. input)
    end
})
```
