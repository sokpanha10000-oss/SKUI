### get boostUI 
local SKUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/sokpanha10000-oss/SKUI/refs/heads/main/SKUI.luau"))()

local Window = UI:CreateWindow({
    Title = "My Super Hub",
    Author = "by .ftgs and .ftgs", -- optional
})

local MinimizeBtn = Window:CreateMinimizeBtn({
  Name = "Open UI",
  Color = "Red",
})

local Tab = Window:Tab({
    Title = "Tab Title",
    Locked = false,
})

local Button = Tab:Button({
    Title = "Button",
    Desc = "Test Button",
    Locked = false,
    Callback = function()
        -- ...
    end
})

local Dropdown = Tab:Dropdown({
    Title = "Dropdown",
    Desc = "Dropdown Description",
    Values = { "Category A", "Category B", "Category C" },
    Value = "Category A",
    Callback = function(option) 
        print("Category selected: " .. option) 
    end
})

local Toggle = Tab:Toggle({
    Title = "Toggle",
    Desc = "Toggle Description",
    Type = "Toggle",
    Value = false, -- default value
    Callback = function(state) 
        print("Toggle Activated" .. tostring(state))
    end
})

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
