# Example
'''lua
local SKUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/sokpanha10000-oss/SKUI/refs/heads/main/SKUI.luau"))()

local Window = SKUI:CreateWindow({
    Title = "SK Hub",
    Author = "by STEVEKHMER", -- optional
})

local MinimizeBtn = Window:CreateMinimizeBtn({
  Name = "Open UI",
  Color = "Red",
})

local Tab = Window:Tab({
    Title = "General",
    Locked = false,
})

local Tab2 = Window:Tab({
    Title = "Main",
    Locked = false,
})

local Toggle = Tab:Toggle({
    Title = "Speed Boost (16 → 500)",
    Desc = "Dynamic speed changer",
    Type = "Toggle",
    Value = false,

    Callback = function(state)
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local humanoid = char:WaitForChild("Humanoid")

        -- Speed settings
        local MIN_SPEED = 16
        local MAX_SPEED = 500

        if state then
            _G.SpeedLoop = true

            task.spawn(function()
                while _G.SpeedLoop do
                    if humanoid then
                        -- You can change this logic if you want dynamic scaling
                        humanoid.WalkSpeed = MAX_SPEED
                    end
                    task.wait() -- ultra fast loop
                end
            end)

        else
            _G.SpeedLoop = false

            if humanoid then
                humanoid.WalkSpeed = MIN_SPEED
            end
        end
    end
})

--// SERVICES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

--// VARIABLES
local SelectedPlayer = nil
local TPEnabled = false

--// FUNCTION: GET PLAYER LIST
local function GetPlayerNames()
    local list = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(list, plr.Name)
        end
    end
    return list
end

--// DROPDOWN (AUTO REFRESH LOOP)
local Dropdown = Tab2:Dropdown({
    Title = "Select Player",
    Desc = "Auto-refresh player list",
    Values = GetPlayerNames(),
    Value = nil,

    Callback = function(option)
        SelectedPlayer = Players:FindFirstChild(option)
    end
})

--// AUTO REFRESH SYSTEM (ULTRA SMOOTH)
task.spawn(function()
    while true do
        task.wait(2) -- refresh every 2s (fast but safe)
        if Dropdown and Dropdown.Refresh then
            Dropdown:Refresh(GetPlayerNames(), true)
        end
    end
end)

local Toggle = Tab2:Toggle({
    Title = "TP To Player (Ultra Fast)",
    Desc = "Loop teleport to selected player",
    Type = "Toggle",
    Value = false,

    Callback = function(state)
        TPEnabled = state

        if state then
            task.spawn(function()
                while TPEnabled do
                    task.wait() -- fastest safe loop

                    if SelectedPlayer
                        and SelectedPlayer.Character
                        and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart")
                        and LocalPlayer.Character
                        and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then

                        LocalPlayer.Character.HumanoidRootPart.CFrame =
                            SelectedPlayer.Character.HumanoidRootPart.CFrame
                    end
                end
            end)
        end
    end
})

local Toggle = Tab:Toggle({
    Title = "Fly (Tween)",
    Desc = "Float + auto forward fly",
    Type = "Toggle",
    Value = false,

    Callback = function(state)
        local Players = game:GetService("Players")
        local TweenService = game:GetService("TweenService")
        local RunService = game:GetService("RunService")

        local player = Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local root = char:WaitForChild("HumanoidRootPart")
        local humanoid = char:WaitForChild("Humanoid")

        if state then
            _G.AutoFly = true

            -- make player float
            humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            root.Velocity = Vector3.zero

            task.spawn(function()
                while _G.AutoFly do
                    task.wait()

                    if not root then break end

                    local cam = workspace.CurrentCamera

                    -- direction always forward (camera)
                    local moveDir = cam.CFrame.LookVector * 100

                    -- target position
                    local goal = {
                        CFrame = root.CFrame + moveDir
                    }

                    -- smooth tween move
                    local tween = TweenService:Create(
                        root,
                        TweenInfo.new(0.15, Enum.EasingStyle.Linear),
                        goal
                    )

                    tween:Play()
                end
            end)

        else
            _G.AutoFly = false

            -- reset to normal
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
    end
})
```
