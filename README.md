# ✨ SKUI (SK Library V3.2)

## 📌 About
- **SKUI** is a rebuilt and optimized version of **SK Library V3.2**.
- It uses the same UI style as the original, with some improvements and refinements.
- The reason the UI is named **SK** is that it should be the name of the next generation of **SK Hub** UIs

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
    Icon = "bird",
    Author = "by .ftgs and .ftgs", -- optional
})
```
```lua
local Window = SKUI:CreateWindow({
    Title = "My Super Hub",
    Icon = "bird",
    Author = "by .ftgs and .ftgs",
    Folder = "MySuperHub",
    
    -- ↓ This all is Optional. You can remove it.
    Size = UDim2.fromOffset(550, 340),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    ToggleKey = Enum.KeyCode.LeftShift,
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    
    -- ↓ Optional. You can remove it.
    --[[ You can set 'rbxassetid://' or video to Background.
        'rbxassetid://':
            Background = "rbxassetid://", -- rbxassetid
        Video:
            Background = "video:YOUR-RAW-LINK-TO-VIDEO.webm", -- video 
    --]]
    
    -- ↓ Optional. You can remove it.
    User = {
        Enabled = true,
        Anonymous = true,
        Callback = function()
            print("clicked")
        end,
    },
    
    --       remove this all, 
    -- !  ↓  if you DON'T need the key system
    KeySystem = { 
        -- ↓ Optional. You can remove it.
        Key = { "1234", "5678" },
        
        Note = "Example Key System.",
        
        -- ↓ Optional. You can remove it.
        Thumbnail = {
            Image = "rbxassetid://",
            Title = "Thumbnail",
        },
        
        -- ↓ Optional. You can remove it.
        URL = "YOUR LINK TO GET KEY (Discord, Linkvertise, Pastebin, etc.)",
        
        -- ↓ Optional. You can remove it.
        SaveKey = false, -- automatically save and load the key.
        
        -- ↓ Optional. You can remove it.
        -- API = {} ← Services. Read about it below ↓
    },
})
```
### Color Window
```lua
Dark
```
```lua
Light
```

### Minimizer
```lua
local MinimizeBtn = Window:CreateMinimizeBtn({
  Title = "Open UI",
  Color = "Red",
})
```

### Color Minimizer
```lua
Red
```
```lua
Blue
```
```lua
Purple
```

#### Creating a Tab
Normal
```lua
local Tab = Window:Tab({
    Title = "Tab Title",
    Icon = "bird",
    Locked = false,
})
```

#### Elements
*Create Elements*

#### Toggle
```lua
local Toggle = Tab:Toggle({
    Title = "Toggle",
    Desc = "Toggle Description",
    Icon = "bird",
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
    InputIcon = "bird",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter text...",
    Callback = function(input) 
        print("text entered: " .. input)
    end
})
```
