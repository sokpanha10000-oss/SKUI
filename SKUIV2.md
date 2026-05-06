# ✨SKUIV2✨
- This is V2 of my UI Library.
- If you don't use Section also working.
- New and fix mistakes
- Good Bye

# Get 🔘Start
```lua
local Library = loadstring(game:HttpGet("https://pastefy.app/xiYJ6xht/raw"))()
```

## 📂Window
```lua
local Window = Library:CreateWindow({
    Title = "Banana Ui Example",
    Subtitle = "All Elements",
    Image = "rbxassetid://128185233852701"
})
```

### 📑Tab
```lua
local MainTab = Window:AddTab("Main Menu")
```

### 📦GroupBox
```lua
local MainGroup = MainTab:AddLeftGroupbox("All Features")
```

#### ⚡Toggle
```lua
MainGroup:AddToggle("ExampleToggle", {
    Text = "Enable Feature",
    Default = false,
    Callback = function(Value)
        print("Toggle is:", Value)
    end
})
```

#### ⚡Button
```lua
MainGroup:AddButton({
    Text = "Run Script",
    Func = function()
        print("Button executed!")
    end,
    DoubleClick = false
})
```

 #### ⚡Slider
 ```lua
MainGroup:AddSlider("ExampleSlider", {
    Text = "Speed Multiplier",
    Min = 0,
    Max = 100,
    Default = 50,
    Rounding = 0,
    Callback = function(Value)
        print("Slider value:", Value)
    end
})
```

#### ⚡Dropdown
```lua
MainGroup:AddDropdown("ExampleDropdown", {
    Text = "Select Category",
    Default = 1,
    Values = {"Option A", "Option B", "Option C"},
    Callback = function(Value)
        print("Dropdown selected:", Value)
    end
})
```
```
Dropdown:Refresh({ "A", "B" })
```

#### ⚡Input
```lua
MainGroup:AddInput("ExampleInput", {
    Text = "Custom Text",
    Default = "",
    Placeholder = "Type here...",
    Callback = function(Value)
        print("Input text:", Value)
    end
})
```

#### ⚡Notify
```lua
Library:Notify({
    Title = "Loaded",
    Description = "Everything is in one tab.",
    Duration = 3
})
```
