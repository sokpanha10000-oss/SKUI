# ✨SKUIV2✨
**BANANA STYLE**This is V2 of my UI Library.
If you don't use Section also working.
Good Bye.

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
```lua
local Section = Tab:Section({ 
    Title = "Movement" 
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
```lua
local Toggle  = Section:Toggle({ 
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
```lua
local Button = Section:Button({ 
      Title="Button", 
      Desc="...", 
     Callback=function() 

end 
})
```

 #### Slider
 ```lua
local Slider = Tab:Slider({ 
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
```lua
local Slider = Section:Slider({ 
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
local Dropdown = Tab:Dropdown({ 
    Title="Dropdown", 
    Values={"A","B","C"}, 
    Value="A", 
   Callback=function(o) 

end 
})
```
```lua
local Dropdown = Section:Dropdown({ 
    Title="Dropdown", 
    Values={"A","B","C"}, 
    Value="A", 
   Callback=function(o) 

end 
})
```

#### Input
```lua
local Input = Tab:Input({ 
    Title="Input", 
    Placeholder="Enter text...", 
    Value="Default", 
   Callback=function(t) 

end 
})
```
```lua
local Input = Section:Input({ 
    Title="Input", 
    Placeholder="Enter text...", 
    Value="Default", 
   Callback=function(t) 

end 
})
```

#### Notify
```lua
Window:Notify({
    Title    = "SK Hub",
    Desc     = "Thank you for using it",
    ImageL   = "rbxassetid://128185233852701",  -- custom logo (optional)
    Duration = 5                                 -- seconds (optional, default 10)
})
```
