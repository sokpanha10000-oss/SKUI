# Get 🔘Start
```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/sokpanha10000-oss/SKUI/refs/heads/main/SKUIV2.luau"))()
```

## 📂Window
```lua
local Window = Library:CreateWindow({
    Title = "My Banana Cat Style Hub",
    Desc = "Custom Hub - No Section Version",
    Author = " By STEVEKHMER",
})
```

### 📑Tab
```lua
local Tab = Window:Tab({
    Title = "Main",
    Locked = false,
})
```

#### Toggle
```lua
local Toggle  = Tab:Toggle({ 
      Title="Toggle", 
      Desc="...", 
      Value=false, 
     Callback=function(s) 

end 
})
```

#### Button
```lua
local Button = Tab:Button({ 
      Title="Button", 
      Desc="...", 
     Callback=function() 

end 
})
```

 #### Slider
 ```lua
local Slider  = Tab:Slider({ 
    Title="Slider", 
    Step=1, 
    Value={
      Min=20,
      Max=120,
      Default=70
      }, 
     Callback=function(v) 

end 
})
```

#### Dropdown
```lua
local Dropdown= Tab:Dropdown({ 
    Title="Dropdown", 
    Values={"A","B","C"}, 
    Value="A", 
   Callback=function(o) 

end 
})
```

#### Input
```lua
local Input   = Tab:Input({ 
    Title="Input", 
    Placeholder="Enter text...", 
    Value="Default", 
   Callback=function(t) 

end 
})
```
