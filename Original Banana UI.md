# Boost UI
```
local Library = loadstring(game:HttpGet("https://pastefy.app/21Kp3vvz/raw"))()
```

## Window
```
local Window = Library:CreateWindow({
    Title = "Banana Ui Example",
    Subtitle = "All Elements",
    Image = "rbxassetid://128185233852701"
})
```

### Tab
```
local MainTab = Window:AddTab("Main Menu")
```
### GroupBox
```
local MainGroup = MainTab:AddLeftGroupbox("All Features")
```
#### Toggle
```
MainGroup:AddToggle("ExampleToggle", {
    Text = "Enable Feature",
    Default = false,
    Callback = function(Value)
        print("Toggle is:", Value)
    end
})
```

#### Slider
```
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

#### Dropdown
```
MainGroup:AddDropdown("ExampleDropdown", {
    Text = "Select Category",
    Default = 1,
    Values = {"Option A", "Option B", "Option C"},
    Callback = function(Value)
        print("Dropdown selected:", Value)
    end
})
```

#### Input
```
MainGroup:AddInput("ExampleInput", {
    Text = "Custom Text",
    Default = "",
    Placeholder = "Type here...",
    Callback = function(Value)
        print("Input text:", Value)
    end
})
```

#### Button
```
MainGroup:AddButton({
    Text = "Run Script",
    Func = function()
        print("Button executed!")
    end,
    DoubleClick = false
})
```

### Notify
```
Library:Notify({
    Title = "Loaded",
    Description = "Everything is in one tab.",
    Duration = 3
})
```
