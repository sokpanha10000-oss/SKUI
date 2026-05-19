--// Nexus UI Library (Premium Single File)
local Nexus = {}
Nexus.__index = Nexus

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

--// Utils
local function Tween(obj, t, props)
    TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

--// Notification System
function Nexus:Notify(title, text, time)
    time = time or 3
    local gui = Instance.new("ScreenGui", PlayerGui)
    gui.Name = "NexusNotify"

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 250, 0, 60)
    frame.Position = UDim2.new(1, -270, 1, -100)
    frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    frame.BackgroundTransparency = 0.2

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local t1 = Instance.new("TextLabel", frame)
    t1.Size = UDim2.new(1, -10, 0.5, 0)
    t1.Position = UDim2.new(0,5,0,0)
    t1.Text = title
    t1.TextColor3 = Color3.fromRGB(255,255,255)
    t1.BackgroundTransparency = 1
    t1.TextXAlignment = Enum.TextXAlignment.Left

    local t2 = Instance.new("TextLabel", frame)
    t2.Size = UDim2.new(1, -10, 0.5, 0)
    t2.Position = UDim2.new(0,5,0.5,0)
    t2.Text = text
    t2.TextColor3 = Color3.fromRGB(200,200,200)
    t2.BackgroundTransparency = 1
    t2.TextXAlignment = Enum.TextXAlignment.Left

    Tween(frame, 0.3, {Position = UDim2.new(1, -270, 1, -130)})
    task.delay(time, function()
        Tween(frame, 0.3, {Position = UDim2.new(1, 300, 1, -130)})
        task.wait(0.4)
        gui:Destroy()
    end)
end

--// Create Window
function Nexus:CreateWindow(title)
    local UI = {}

    local ScreenGui = Instance.new("ScreenGui", PlayerGui)
    ScreenGui.Name = "NexusUI"

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 550, 0, 340)
    Main.Position = UDim2.new(0.5, -275, 0.5, -170)
    Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
    Main.BackgroundTransparency = 0.25
    Main.Active = true

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

    -- Glass effect
    local blur = Instance.new("BlurEffect", game.Lighting)
    blur.Size = 10

    -- Top bar
    local Top = Instance.new("Frame", Main)
    Top.Size = UDim2.new(1,0,0,35)
    Top.BackgroundTransparency = 1

    local Title = Instance.new("TextLabel", Top)
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Position = UDim2.new(0,10,0,0)
    Title.Text = title
    Title.TextColor3 = Color3.fromRGB(255,255,255)
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Minimize button
    local MinBtn = Instance.new("TextButton", Top)
    MinBtn.Size = UDim2.new(0,30,0,30)
    MinBtn.Position = UDim2.new(1,-40,0,2)
    MinBtn.Text = "-"
    MinBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)

    Instance.new("UICorner", MinBtn)

    local isMin = false
    local FullSize = Main.Size

    MinBtn.MouseButton1Click:Connect(function()
        isMin = not isMin
        if isMin then
            Tween(Main,0.3,{Size = UDim2.new(0,550,0,40)})
        else
            Tween(Main,0.3,{Size = FullSize})
        end
    end)

    -- Floating reopen button
    local FloatBtn = Instance.new("TextButton", ScreenGui)
    FloatBtn.Size = UDim2.new(0,50,0,50)
    FloatBtn.Position = UDim2.new(0,20,0.5,0)
    FloatBtn.Text = "N"
    FloatBtn.Visible = false

    Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(1,0)

    FloatBtn.MouseButton1Click:Connect(function()
        Main.Visible = true
        FloatBtn.Visible = false
    end)

    MinBtn.MouseButton1Click:Connect(function()
        if isMin then
            FloatBtn.Visible = true
        else
            FloatBtn.Visible = false
        end
    end)

    -- Dragging
    local dragging, dragInput, startPos, start

    Top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            start = Main.Position
            startPos = input.Position
        end
    end)

    Top.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - startPos
            Tween(Main,0,{Position = UDim2.new(start.X.Scale, start.X.Offset + delta.X, start.Y.Scale, start.Y.Offset + delta.Y)})
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- Tabs
    local TabHolder = Instance.new("Frame", Main)
    TabHolder.Size = UDim2.new(0,120,1,-40)
    TabHolder.Position = UDim2.new(0,0,0,40)
    TabHolder.BackgroundTransparency = 0.3

    local PageHolder = Instance.new("Frame", Main)
    PageHolder.Size = UDim2.new(1,-120,1,-40)
    PageHolder.Position = UDim2.new(0,120,0,40)
    PageHolder.BackgroundTransparency = 1

    UI.Tabs = {}

    function UI:CreateTab(name)
        local tabBtn = Instance.new("TextButton", TabHolder)
        tabBtn.Size = UDim2.new(1,0,0,35)
        tabBtn.Text = name
        tabBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)

        local page = Instance.new("ScrollingFrame", PageHolder)
        page.Size = UDim2.new(1,0,1,0)
        page.CanvasSize = UDim2.new(0,0,2,0)
        page.Visible = false
        page.BackgroundTransparency = 1

        Instance.new("UIListLayout", page)

        tabBtn.MouseButton1Click:Connect(function()
            for _,v in pairs(PageHolder:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end
            page.Visible = true
        end)

        local tab = {}

        function tab:Button(text, callback)
            local b = Instance.new("TextButton", page)
            b.Size = UDim2.new(1,-10,0,35)
            b.Text = text
            b.BackgroundColor3 = Color3.fromRGB(45,45,45)
            b.MouseButton1Click:Connect(callback)
        end

        function tab:Toggle(text, callback)
            local state = false
            local t = Instance.new("TextButton", page)
            t.Size = UDim2.new(1,-10,0,35)
            t.Text = text.." : OFF"
            t.MouseButton1Click:Connect(function()
                state = not state
                t.Text = text.." : "..(state and "ON" or "OFF")
                callback(state)
            end)
        end

        function tab:Slider(text, min, max, callback)
            local s = Instance.new("TextButton", page)
            s.Size = UDim2.new(1,-10,0,35)
            local val = min
            s.Text = text..": "..val

            s.MouseButton1Click:Connect(function()
                val = math.clamp(val + 5, min, max)
                s.Text = text..": "..val
                callback(val)
            end)
        end

        function tab:Dropdown(text, options, callback)
            local d = Instance.new("TextButton", page)
            d.Size = UDim2.new(1,-10,0,35)
            d.Text = text.." (Click)"

            d.MouseButton1Click:Connect(function()
                local choice = options[math.random(1,#options)]
                d.Text = text..": "..choice
                callback(choice)
            end)
        end

        function tab:Keybind(text, callback)
            local k = Instance.new("TextButton", page)
            k.Size = UDim2.new(1,-10,0,35)
            k.Text = text.." : None"

            local binding = false

            k.MouseButton1Click:Connect(function()
                binding = true
                k.Text = "Press Key..."
            end)

            UserInputService.InputBegan:Connect(function(input)
                if binding then
                    binding = false
                    k.Text = text.." : "..input.KeyCode.Name
                    callback(input.KeyCode)
                end
            end)
        end

        UI.Tabs[name] = tab
        return tab
    end

    return UI
end

return Nexus
