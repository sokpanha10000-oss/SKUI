--// Nexus UI - Premium Single File UI Library
--// Mobile + PC Support
--// Glassmorphism + Smooth Animations
--// By Nexus UI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local NexusUI = {}
NexusUI.__index = NexusUI

--// Notification System
function NexusUI:Notify(title, text, timee)
	timee = timee or 3

	local NotifyGui = self.NotificationHolder

	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(0, 0, 0, 70)
	Frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
	Frame.BackgroundTransparency = 0.2
	Frame.BorderSizePixel = 0
	Frame.ClipsDescendants = true
	Frame.Parent = NotifyGui

	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,16)

	local Stroke = Instance.new("UIStroke", Frame)
	Stroke.Color = Color3.fromRGB(255,255,255)
	Stroke.Transparency = 0.8

	local Title = Instance.new("TextLabel")
	Title.Parent = Frame
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0,15,0,8)
	Title.Size = UDim2.new(1,-20,0,20)
	Title.Font = Enum.Font.GothamBold
	Title.Text = title
	Title.TextColor3 = Color3.new(1,1,1)
	Title.TextSize = 16
	Title.TextXAlignment = Enum.TextXAlignment.Left

	local Desc = Instance.new("TextLabel")
	Desc.Parent = Frame
	Desc.BackgroundTransparency = 1
	Desc.Position = UDim2.new(0,15,0,30)
	Desc.Size = UDim2.new(1,-20,0,30)
	Desc.Font = Enum.Font.Gotham
	Desc.Text = text
	Desc.TextWrapped = true
	Desc.TextColor3 = Color3.fromRGB(220,220,220)
	Desc.TextSize = 13
	Desc.TextXAlignment = Enum.TextXAlignment.Left

	TweenService:Create(
		Frame,
		TweenInfo.new(0.4, Enum.EasingStyle.Quint),
		{Size = UDim2.new(0,300,0,70)}
	):Play()

	task.wait(timee)

	local CloseTween = TweenService:Create(
		Frame,
		TweenInfo.new(0.4, Enum.EasingStyle.Quint),
		{Size = UDim2.new(0,0,0,70)}
	)

	CloseTween:Play()
	CloseTween.Completed:Wait()

	Frame:Destroy()
end

--// Dragging
local function MakeDraggable(topbar, object)
	local dragging = false
	local dragStart
	local startPos

	local function Update(input)
		local delta = input.Position - dragStart
		object.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end

	topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = object.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (
			input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch
		) then
			Update(input)
		end
	end)
end

--// Create Window
function NexusUI:CreateWindow(config)
	local TitleText = config.Title or "Nexus UI"

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "NexusUI"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = CoreGui

	local Main = Instance.new("Frame")
	Main.Parent = ScreenGui
	Main.Size = UDim2.new(0, 700, 0, 420)
	Main.Position = UDim2.new(0.5,-350,0.5,-210)
	Main.BackgroundColor3 = Color3.fromRGB(15,15,15)
	Main.BackgroundTransparency = 0.15
	Main.BorderSizePixel = 0

	Instance.new("UICorner", Main).CornerRadius = UDim.new(0,20)

	local Stroke = Instance.new("UIStroke", Main)
	Stroke.Color = Color3.fromRGB(255,255,255)
	Stroke.Transparency = 0.85

	-- Glass Effect
	local Gradient = Instance.new("UIGradient", Main)
	Gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(180,180,180))
	}
	Gradient.Rotation = 90

	local TopBar = Instance.new("Frame")
	TopBar.Parent = Main
	TopBar.Size = UDim2.new(1,0,0,50)
	TopBar.BackgroundTransparency = 1

	local Title = Instance.new("TextLabel")
	Title.Parent = TopBar
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0,20,0,0)
	Title.Size = UDim2.new(1,0,1,0)
	Title.Font = Enum.Font.GothamBold
	Title.Text = TitleText
	Title.TextColor3 = Color3.new(1,1,1)
	Title.TextSize = 22
	Title.TextXAlignment = Enum.TextXAlignment.Left

	-- Minimize Button
	local Minimize = Instance.new("TextButton")
	Minimize.Parent = TopBar
	Minimize.Size = UDim2.new(0,35,0,35)
	Minimize.Position = UDim2.new(1,-45,0.5,-17)
	Minimize.Text = "-"
	Minimize.Font = Enum.Font.GothamBold
	Minimize.TextSize = 24
	Minimize.TextColor3 = Color3.new(1,1,1)
	Minimize.BackgroundColor3 = Color3.fromRGB(30,30,30)
	Minimize.BackgroundTransparency = 0.2
	Minimize.BorderSizePixel = 0
	Instance.new("UICorner", Minimize).CornerRadius = UDim.new(1,0)

	local Tabs = Instance.new("Frame")
	Tabs.Parent = Main
	Tabs.Size = UDim2.new(0,180,1,-60)
	Tabs.Position = UDim2.new(0,10,0,55)
	Tabs.BackgroundTransparency = 1

	local TabLayout = Instance.new("UIListLayout", Tabs)
	TabLayout.Padding = UDim.new(0,8)

	local Container = Instance.new("Frame")
	Container.Parent = Main
	Container.Position = UDim2.new(0,200,0,60)
	Container.Size = UDim2.new(1,-210,1,-70)
	Container.BackgroundTransparency = 1

	local Notifications = Instance.new("Frame")
	Notifications.Parent = ScreenGui
	Notifications.AnchorPoint = Vector2.new(1,1)
	Notifications.Position = UDim2.new(1,-15,1,-15)
	Notifications.Size = UDim2.new(0,320,1,-20)
	Notifications.BackgroundTransparency = 1

	local NotifyLayout = Instance.new("UIListLayout", Notifications)
	NotifyLayout.Padding = UDim.new(0,10)
	NotifyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom

	self.NotificationHolder = Notifications

	MakeDraggable(TopBar, Main)

	local Minimized = false

	Minimize.MouseButton1Click:Connect(function()
		Minimized = not Minimized

		TweenService:Create(
			Main,
			TweenInfo.new(0.35, Enum.EasingStyle.Quint),
			{
				Size = Minimized and UDim2.new(0,700,0,50)
					or UDim2.new(0,700,0,420)
			}
		):Play()

		Tabs.Visible = not Minimized
		Container.Visible = not Minimized
	end)

	local Window = {}

	function Window:CreateTab(name)
		local TabButton = Instance.new("TextButton")
		TabButton.Parent = Tabs
		TabButton.Size = UDim2.new(1,-10,0,45)
		TabButton.BackgroundColor3 = Color3.fromRGB(25,25,25)
		TabButton.BackgroundTransparency = 0.2
		TabButton.BorderSizePixel = 0
		TabButton.Text = name
		TabButton.Font = Enum.Font.GothamBold
		TabButton.TextSize = 15
		TabButton.TextColor3 = Color3.new(1,1,1)

		Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0,14)

		local Page = Instance.new("ScrollingFrame")
		Page.Parent = Container
		Page.Size = UDim2.new(1,0,1,0)
		Page.CanvasSize = UDim2.new(0,0,0,0)
		Page.ScrollBarThickness = 0
		Page.Visible = false
		Page.BackgroundTransparency = 1

		local Layout = Instance.new("UIListLayout", Page)
		Layout.Padding = UDim.new(0,10)

		Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			Page.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 20)
		end)

		TabButton.MouseButton1Click:Connect(function()
			for _,v in pairs(Container:GetChildren()) do
				if v:IsA("ScrollingFrame") then
					v.Visible = false
				end
			end

			Page.Visible = true
		end)

		if #Container:GetChildren() == 1 then
			Page.Visible = true
		end

		local Elements = {}

		local function CreateElement(height)
			local Holder = Instance.new("Frame")
			Holder.Parent = Page
			Holder.Size = UDim2.new(1,-5,0,height)
			Holder.BackgroundColor3 = Color3.fromRGB(25,25,25)
			Holder.BackgroundTransparency = 0.2
			Holder.BorderSizePixel = 0
			Instance.new("UICorner", Holder).CornerRadius = UDim.new(0,16)

			return Holder
		end

		function Elements:Button(text, callback)
			local Holder = CreateElement(50)

			local Btn = Instance.new("TextButton")
			Btn.Parent = Holder
			Btn.Size = UDim2.new(1,0,1,0)
			Btn.BackgroundTransparency = 1
			Btn.Text = text
			Btn.Font = Enum.Font.GothamBold
			Btn.TextColor3 = Color3.new(1,1,1)
			Btn.TextSize = 15

			Btn.MouseButton1Click:Connect(function()
				TweenService:Create(
					Holder,
					TweenInfo.new(0.15),
					{BackgroundTransparency = 0}
				):Play()

				task.wait(0.1)

				TweenService:Create(
					Holder,
					TweenInfo.new(0.15),
					{BackgroundTransparency = 0.2}
				):Play()

				callback()
			end)
		end

		function Elements:Toggle(text, default, callback)
			local Enabled = default or false

			local Holder = CreateElement(50)

			local Label = Instance.new("TextLabel")
			Label.Parent = Holder
			Label.BackgroundTransparency = 1
			Label.Position = UDim2.new(0,15,0,0)
			Label.Size = UDim2.new(1,-80,1,0)
			Label.Font = Enum.Font.Gotham
			Label.Text = text
			Label.TextColor3 = Color3.new(1,1,1)
			Label.TextSize = 15
			Label.TextXAlignment = Enum.TextXAlignment.Left

			local ToggleBtn = Instance.new("TextButton")
			ToggleBtn.Parent = Holder
			ToggleBtn.Size = UDim2.new(0,50,0,26)
			ToggleBtn.Position = UDim2.new(1,-65,0.5,-13)
			ToggleBtn.Text = ""
			ToggleBtn.BackgroundColor3 = Enabled and Color3.fromRGB(0,170,255)
				or Color3.fromRGB(40,40,40)

			Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1,0)

			ToggleBtn.MouseButton1Click:Connect(function()
				Enabled = not Enabled

				TweenService:Create(
					ToggleBtn,
					TweenInfo.new(0.25),
					{
						BackgroundColor3 = Enabled
							and Color3.fromRGB(0,170,255)
							or Color3.fromRGB(40,40,40)
					}
				):Play()

				callback(Enabled)
			end)
		end

		function Elements:Slider(text, min, max, default, callback)
			local Value = default or min

			local Holder = CreateElement(70)

			local Label = Instance.new("TextLabel")
			Label.Parent = Holder
			Label.BackgroundTransparency = 1
			Label.Position = UDim2.new(0,15,0,5)
			Label.Size = UDim2.new(1,-20,0,20)
			Label.Font = Enum.Font.Gotham
			Label.Text = text .. ": " .. Value
			Label.TextColor3 = Color3.new(1,1,1)
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left

			local Bar = Instance.new("Frame")
			Bar.Parent = Holder
			Bar.Size = UDim2.new(1,-30,0,8)
			Bar.Position = UDim2.new(0,15,1,-20)
			Bar.BackgroundColor3 = Color3.fromRGB(40,40,40)

			Instance.new("UICorner", Bar).CornerRadius = UDim.new(1,0)

			local Fill = Instance.new("Frame")
			Fill.Parent = Bar
			Fill.Size = UDim2.new((Value-min)/(max-min),0,1,0)
			Fill.BackgroundColor3 = Color3.fromRGB(0,170,255)

			Instance.new("UICorner", Fill).CornerRadius = UDim.new(1,0)

			local Dragging = false

			Bar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch then
					Dragging = true
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch then
					Dragging = false
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if Dragging then
					local SizeX = math.clamp(
						(input.Position.X - Bar.AbsolutePosition.X)
						/ Bar.AbsoluteSize.X,
						0,
						1
					)

					Fill.Size = UDim2.new(SizeX,0,1,0)

					Value = math.floor(min + ((max-min) * SizeX))

					Label.Text = text .. ": " .. Value

					callback(Value)
				end
			end)
		end

		function Elements:Dropdown(text, list, callback)
			local Holder = CreateElement(50)

			local Drop = Instance.new("TextButton")
			Drop.Parent = Holder
			Drop.Size = UDim2.new(1,0,1,0)
			Drop.BackgroundTransparency = 1
			Drop.Text = text
			Drop.Font = Enum.Font.Gotham
			Drop.TextColor3 = Color3.new(1,1,1)
			Drop.TextSize = 14

			Drop.MouseButton1Click:Connect(function()
				callback(list[1])
			end)
		end

		function Elements:Keybind(text, defaultKey, callback)
			local Key = defaultKey or Enum.KeyCode.E

			local Holder = CreateElement(50)

			local Btn = Instance.new("TextButton")
			Btn.Parent = Holder
			Btn.Size = UDim2.new(1,0,1,0)
			Btn.BackgroundTransparency = 1
			Btn.Text = text .. " : " .. Key.Name
			Btn.Font = Enum.Font.Gotham
			Btn.TextColor3 = Color3.new(1,1,1)
			Btn.TextSize = 14

			local Waiting = false

			Btn.MouseButton1Click:Connect(function()
				Btn.Text = "Press any key..."
				Waiting = true
			end)

			UserInputService.InputBegan:Connect(function(input, gp)
				if gp then return end

				if Waiting then
					if input.KeyCode ~= Enum.KeyCode.Unknown then
						Key = input.KeyCode
						Btn.Text = text .. " : " .. Key.Name
						Waiting = false
					end
				else
					if input.KeyCode == Key then
						callback()
					end
				end
			end)
		end

		return Elements
	end

	return Window
end

return NexusUI
