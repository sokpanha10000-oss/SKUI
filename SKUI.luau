--// SKUI PREMIUM GLASS LIBRARY
--// FULL CLEAN MERGED VERSION
--// Single File

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Library = {}
Library.__index = Library

local Theme = {
	Accent = Color3.fromRGB(180, 10, 20),
	Accent2 = Color3.fromRGB(255, 60, 80),

	Background = Color3.fromRGB(12, 12, 14),
	Topbar = Color3.fromRGB(14, 14, 18),

	Panel = Color3.fromRGB(18, 18, 22),
	Element = Color3.fromRGB(26, 26, 30),

	Text = Color3.fromRGB(255,255,255),
	SubText = Color3.fromRGB(180,180,180),

	Border = Color3.fromRGB(255,255,255)
}

--// Helpers

local function Create(Class, Properties)
	local Obj = Instance.new(Class)

	for i,v in pairs(Properties or {}) do
		Obj[i] = v
	end

	return Obj
end

local function Corner(Obj, Radius)
	return Create("UICorner", {
		CornerRadius = UDim.new(0, Radius or 12),
		Parent = Obj
	})
end

local function Stroke(Obj, Color, Thickness, Transparency)
	return Create("UIStroke", {
		Parent = Obj,
		Color = Color or Theme.Border,
		Thickness = Thickness or 1,
		Transparency = Transparency or 0.8
	})
end

local function Padding(Obj, Top, Bottom, Left, Right)
	return Create("UIPadding", {
		Parent = Obj,
		PaddingTop = UDim.new(0, Top or 0),
		PaddingBottom = UDim.new(0, Bottom or 0),
		PaddingLeft = UDim.new(0, Left or 0),
		PaddingRight = UDim.new(0, Right or 0)
	})
end

local function List(Obj, Pad)
	return Create("UIListLayout", {
		Parent = Obj,
		Padding = UDim.new(0, Pad or 8),
		SortOrder = Enum.SortOrder.LayoutOrder
	})
end

local function Draggable(Frame, DragFrame)
	local Dragging = false
	local DragInput
	local MousePos
	local FramePos

	DragFrame.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 then
			Dragging = true
			MousePos = Input.Position
			FramePos = Frame.Position

			Input.Changed:Connect(function()
				if Input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)

	DragFrame.InputChanged:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseMovement then
			DragInput = Input
		end
	end)

	UserInputService.InputChanged:Connect(function(Input)
		if Input == DragInput and Dragging then
			local Delta = Input.Position - MousePos

			Frame.Position = UDim2.new(
				FramePos.X.Scale,
				FramePos.X.Offset + Delta.X,
				FramePos.Y.Scale,
				FramePos.Y.Offset + Delta.Y
			)
		end
	end)
end

local function Tween(Obj, Time, Properties)
	TweenService:Create(
		Obj,
		TweenInfo.new(Time or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		Properties
	):Play()
end

local function IconText(Icon, Text)
	if Icon then
		return tostring(Icon).."  "..tostring(Text)
	end
	return tostring(Text)
end

--// Window

function Library:CreateWindow(Config)
	Config = Config or {}

	local Window = {}

	local Blur = Create("BlurEffect", {
		Parent = Lighting,
		Size = Config.Acrylic and 12 or 0
	})

	local Gui = Create("ScreenGui", {
		Name = "SKUI",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = PlayerGui
	})

	local Main = Create("Frame", {
		Parent = Gui,
		BackgroundColor3 = Theme.Background,
		BackgroundTransparency = 0.15,
		BorderSizePixel = 0,
		Size = Config.Size or UDim2.fromOffset(520, 460),
		Position = UDim2.new(0.5,-260,0.5,-230),
		ClipsDescendants = true
	})

	Corner(Main,18)
	Stroke(Main, Theme.Border,1,0.85)

	local Topbar = Create("Frame", {
		Parent = Main,
		BackgroundColor3 = Theme.Topbar,
		BackgroundTransparency = 0.2,
		BorderSizePixel = 0,
		Size = UDim2.new(1,0,0,60)
	})

	Corner(Topbar,18)

	Create("Frame",{
		Parent = Topbar,
		BackgroundColor3 = Theme.Topbar,
		BorderSizePixel = 0,
		Position = UDim2.new(0,0,1,-18),
		Size = UDim2.new(1,0,0,18)
	})

	Create("TextLabel",{
		Parent = Topbar,
		BackgroundTransparency = 1,
		Position = UDim2.new(0,16,0,8),
		Size = UDim2.new(1,-100,0,22),
		Font = Enum.Font.GothamBold,
		Text = Config.Title or "Window",
		TextSize = 18,
		TextColor3 = Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	Create("TextLabel",{
		Parent = Topbar,
		BackgroundTransparency = 1,
		Position = UDim2.new(0,16,0,30),
		Size = UDim2.new(1,-100,0,18),
		Font = Enum.Font.Gotham,
		Text = Config.SubTitle or "",
		TextSize = 12,
		TextColor3 = Theme.SubText,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	local Close = Create("TextButton",{
		Parent = Topbar,
		BackgroundColor3 = Theme.Element,
		BackgroundTransparency = 0.1,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(32,32),
		Position = UDim2.new(1,-42,0,14),
		Text = "✕",
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		TextColor3 = Theme.Text
	})

	Corner(Close,10)
	Stroke(Close,Theme.Border,1,0.8)

	local Left = Create("Frame",{
		Parent = Main,
		BackgroundColor3 = Theme.Panel,
		BackgroundTransparency = 0.15,
		BorderSizePixel = 0,
		Position = UDim2.new(0,12,0,72),
		Size = UDim2.new(0,160,1,-84)
	})

	Corner(Left,16)
	Stroke(Left,Theme.Border,1,0.88)

	local Right = Create("ScrollingFrame",{
		Parent = Main,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0,184,0,72),
		Size = UDim2.new(1,-196,1,-84),

		CanvasSize = UDim2.fromOffset(0,0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,

		ScrollBarThickness = 3,
		ScrollBarImageColor3 = Theme.Accent
	})

	Padding(Right,4,4,4,4)
	List(Right,10)

	local UserProfile = Create("Frame",{
		Parent = Left,
		BackgroundColor3 = Theme.Element,
		BackgroundTransparency = 0.1,
		BorderSizePixel = 0,
		Position = UDim2.new(0,8,0,8),
		Size = UDim2.new(1,-16,0,58)
	})

	Corner(UserProfile,14)
	Stroke(UserProfile,Theme.Border,1,0.9)

	local Avatar = Create("ImageLabel",{
		Parent = UserProfile,
		BackgroundTransparency = 1,
		Position = UDim2.new(0,10,0,10),
		Size = UDim2.fromOffset(38,38)
	})

	Corner(Avatar,99)

	task.spawn(function()
		local ok, img = pcall(function()
			return Players:GetUserThumbnailAsync(
				LocalPlayer.UserId,
				Enum.ThumbnailType.HeadShot,
				Enum.ThumbnailSize.Size100x100
			)
		end)

		if ok then
			Avatar.Image = img
		end
	end)

	Create("TextLabel",{
		Parent = UserProfile,
		BackgroundTransparency = 1,
		Position = UDim2.new(0,56,0,10),
		Size = UDim2.new(1,-60,0,18),
		Font = Enum.Font.GothamBold,
		Text = Config.UserInfoTitle or LocalPlayer.DisplayName,
		TextSize = 14,
		TextColor3 = Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	Create("TextLabel",{
		Parent = UserProfile,
		BackgroundTransparency = 1,
		Position = UDim2.new(0,56,0,28),
		Size = UDim2.new(1,-60,0,16),
		Font = Enum.Font.Gotham,
		Text = Config.UserInfoSubtitle or "Advanced User",
		TextSize = 11,
		TextColor3 = Theme.SubText,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	local SearchFrame = Create("Frame",{
		Parent = Left,
		BackgroundColor3 = Theme.Element,
		BackgroundTransparency = 0.1,
		BorderSizePixel = 0,
		Position = UDim2.new(0,8,0,74),
		Size = UDim2.new(1,-16,0,32)
	})

	Corner(SearchFrame,10)
	Stroke(SearchFrame,Theme.Border,1,0.9)

	Create("TextLabel",{
		Parent = SearchFrame,
		BackgroundTransparency = 1,
		Position = UDim2.new(0,8,0,0),
		Size = UDim2.fromOffset(16,32),
		Font = Enum.Font.GothamBold,
		Text = "⌕",
		TextColor3 = Theme.SubText,
		TextSize = 14
	})

	local SearchBox = Create("TextBox",{
		Parent = SearchFrame,
		BackgroundTransparency = 1,
		Position = UDim2.new(0,28,0,0),
		Size = UDim2.new(1,-32,1,0),
		ClearTextOnFocus = false,
		PlaceholderText = "Search tabs...",
		Text = "",
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextColor3 = Theme.Text,
		PlaceholderColor3 = Theme.SubText,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	local TabsHolder = Create("ScrollingFrame",{
		Parent = Left,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0,0,0,114),
		Size = UDim2.new(1,0,1,-120),

		CanvasSize = UDim2.fromOffset(0,0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,

		ScrollBarThickness = 3,
		ScrollBarImageColor3 = Theme.Accent
	})

	Padding(TabsHolder,6,6,6,6)
	List(TabsHolder,8)

	local Tabs = {}
	local CurrentTab

	function Window:CreateMinimizeBtn(Data)
		Data = Data or {}

		local Btn = Create("TextButton",{
			Parent = Gui,
			BackgroundColor3 = Theme.Panel,
			BackgroundTransparency = 0.1,
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(120,38),
			Position = UDim2.new(0,20,0.5,-19),
			Text = ""
		})

		Corner(Btn,12)
		Stroke(Btn,Theme.Border,1,0.8)

		Create("TextLabel",{
			Parent = Btn,
			BackgroundTransparency = 1,
			Position = UDim2.new(0,12,0,0),
			Size = UDim2.new(1,-20,1,0),
			Font = Enum.Font.GothamSemibold,
			Text = Data.Title or "Open UI",
			TextSize = 13,
			TextColor3 = Theme.Text,
			TextXAlignment = Enum.TextXAlignment.Left
		})

		Draggable(Btn,Btn)

		Btn.MouseButton1Click:Connect(function()
			Main.Visible = not Main.Visible
			Blur.Size = Main.Visible and 12 or 0
		end)

		return Btn
	end

	Close.MouseButton1Click:Connect(function()
		Blur:Destroy()
		Gui:Destroy()
	end)

	makeconnection = makeconnection or function() end

	UserInputService.InputBegan:Connect(function(Input,Typing)
		if Typing then return end

		if Input.KeyCode == (Config.MinimizeKey or Enum.KeyCode.LeftControl) then
			Main.Visible = not Main.Visible
			Blur.Size = Main.Visible and 12 or 0
		end
	end)

	Draggable(Main,Topbar)

	function Window:AddTab(TabData)
		TabData = TabData or {}

		local Tab = {}

		local Button = Create("TextButton",{
			Parent = TabsHolder,
			BackgroundColor3 = Theme.Element,
			BackgroundTransparency = 0.1,
			BorderSizePixel = 0,
			Size = UDim2.new(1,0,0,40),
			Text = ""
		})

		Corner(Button,12)
		Stroke(Button,Theme.Border,1,0.92)

		Create("TextLabel",{
			Parent = Button,
			BackgroundTransparency = 1,
			Position = UDim2.new(0,12,0,0),
			Size = UDim2.new(1,-20,1,0),
			Font = Enum.Font.GothamSemibold,
			Text = IconText(TabData.Icon,TabData.Title or "Tab"),
			TextSize = 13,
			TextColor3 = Theme.Text,
			TextXAlignment = Enum.TextXAlignment.Left
		})

		local Page = Create("Frame",{
			Parent = Right,
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0,0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Visible = false
		})

		List(Page,10)

		Button.MouseButton1Click:Connect(function()
			for _,v in pairs(Tabs) do
				v.Page.Visible = false
			end

			Page.Visible = true
			CurrentTab = Tab
		end)

		table.insert(Tabs,{
			Page = Page
		})

		if not CurrentTab then
			Page.Visible = true
			CurrentTab = Tab
		end

		function Tab:AddSection(Title)
			local Section = {}

			local Holder = Create("Frame",{
				Parent = Page,
				BackgroundColor3 = Theme.Element,
				BackgroundTransparency = 0.08,
				BorderSizePixel = 0,
				Size = UDim2.new(1,0,0,40),
				AutomaticSize = Enum.AutomaticSize.Y
			})

			Corner(Holder,14)
			Stroke(Holder,Theme.Border,1,0.94)

			Padding(Holder,12,12,12,12)

			Create("TextLabel",{
				Parent = Holder,
				BackgroundTransparency = 1,
				Size = UDim2.new(1,0,0,18),
				Font = Enum.Font.GothamBold,
				Text = Title or "Section",
				TextSize = 14,
				TextColor3 = Theme.Text,
				TextXAlignment = Enum.TextXAlignment.Left
			})

			local Content = Create("Frame",{
				Parent = Holder,
				BackgroundTransparency = 1,
				Position = UDim2.new(0,0,0,26),
				Size = UDim2.new(1,0,0,0),
				AutomaticSize = Enum.AutomaticSize.Y
			})

			List(Content,8)

			local function Element(SizeY)
				local Frame = Create("Frame",{
					Parent = Content,
					BackgroundColor3 = Theme.Panel,
					BackgroundTransparency = 0.08,
					BorderSizePixel = 0,
					Size = UDim2.new(1,0,0,SizeY or 40)
				})

				Corner(Frame,12)
				Stroke(Frame,Theme.Border,1,0.95)

				return Frame
			end

			function Section:AddButton(Data)
				Data = Data or {}

				local Frame = Element(40)

				local Btn = Create("TextButton",{
					Parent = Frame,
					Name = Data.Name or "click",
					BackgroundTransparency = 1,
					Size = UDim2.new(1,0,1,0),
					Text = ""
				})

				Create("TextLabel",{
					Parent = Btn,
					BackgroundTransparency = 1,
					Position = UDim2.new(0,12,0,0),
					Size = UDim2.new(1,-20,1,0),
					Font = Enum.Font.GothamSemibold,
					Text = IconText(Data.Icon,Data.Title or "Button"),
					TextSize = 13,
					TextColor3 = Theme.Text,
					TextXAlignment = Enum.TextXAlignment.Left
				})

				Btn.MouseButton1Click:Connect(function()
					if Data.Callback then
						Data.Callback()
					end
				end)

				return Btn
			end

			function Section:AddDropdown(Data)
				Data = Data or {}

				local Values = Data.Values or {}

				local Frame = Element(42)

				local Btn = Create("TextButton",{
					Parent = Frame,
					BackgroundTransparency = 1,
					Size = UDim2.new(1,0,1,0),
					Text = ""
				})

				local Label = Create("TextLabel",{
					Parent = Btn,
					BackgroundTransparency = 1,
					Position = UDim2.new(0,12,0,0),
					Size = UDim2.new(1,-24,1,0),
					Font = Enum.Font.GothamSemibold,
					Text = IconText(Data.Icon,Data.Title or "Dropdown"),
					TextSize = 13,
					TextColor3 = Theme.Text,
					TextXAlignment = Enum.TextXAlignment.Left
				})

				Create("TextLabel",{
					Parent = Btn,
					BackgroundTransparency = 1,
					Position = UDim2.new(1,-24,0,0),
					Size = UDim2.fromOffset(18,42),
					Font = Enum.Font.GothamBold,
					Text = "⌄",
					TextSize = 18,
					TextColor3 = Theme.SubText
				})

				local Dropdown = {}
				Dropdown.Values = Values

				local function OpenDropdown()
					local Overlay = Create("Frame",{
						Parent = Gui,
						BackgroundColor3 = Color3.new(0,0,0),
						BackgroundTransparency = 0.5,
						Size = UDim2.fromScale(1,1),
						ZIndex = 50
					})

					local Popup = Create("Frame",{
						Parent = Overlay,
						BackgroundColor3 = Theme.Panel,
						BackgroundTransparency = 0.05,
						BorderSizePixel = 0,
						AnchorPoint = Vector2.new(0.5,0.5),
						Position = UDim2.fromScale(0.5,0.5),
						Size = UDim2.fromOffset(320,340),
						ZIndex = 51
					})

					Corner(Popup,16)
					Stroke(Popup,Theme.Border,1,0.86)

					local CloseBtn = Create("TextButton",{
						Parent = Popup,
						BackgroundColor3 = Theme.Element,
						BackgroundTransparency = 0.1,
						BorderSizePixel = 0,
						Position = UDim2.new(1,-38,0,10),
						Size = UDim2.fromOffset(28,28),
						Text = "✕",
						Font = Enum.Font.GothamBold,
						TextSize = 14,
						TextColor3 = Theme.Text,
						ZIndex = 52
					})

					Corner(CloseBtn,10)

					CloseBtn.MouseButton1Click:Connect(function()
						Overlay:Destroy()
					end)

					local SearchFrame2 = Create("Frame",{
						Parent = Popup,
						BackgroundColor3 = Theme.Element,
						BackgroundTransparency = 0.08,
						BorderSizePixel = 0,
						Position = UDim2.new(0,12,0,46),
						Size = UDim2.new(1,-24,0,30),
						ZIndex = 52
					})

					Corner(SearchFrame2,10)

					local SearchBox2 = Create("TextBox",{
						Parent = SearchFrame2,
						BackgroundTransparency = 1,
						Position = UDim2.new(0,10,0,0),
						Size = UDim2.new(1,-20,1,0),
						ClearTextOnFocus = false,
						PlaceholderText = "Search...",
						Text = "",
						Font = Enum.Font.Gotham,
						TextSize = 13,
						TextColor3 = Theme.Text,
						PlaceholderColor3 = Theme.SubText,
						ZIndex = 53
					})

					local Scroll = Create("ScrollingFrame",{
						Parent = Popup,
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Position = UDim2.new(0,12,0,84),
						Size = UDim2.new(1,-24,1,-96),

						CanvasSize = UDim2.fromOffset(0,0),
						AutomaticCanvasSize = Enum.AutomaticSize.Y,

						ScrollBarThickness = 3,
						ScrollBarImageColor3 = Theme.Accent,
						ZIndex = 52
					})

					Padding(Scroll,2,2,2,2)
					List(Scroll,8)

					local Buttons = {}

					local function Build()
						for _,v in pairs(Buttons) do
							v:Destroy()
						end

						Buttons = {}

						local Search = string.lower(SearchBox2.Text)

						for _,Value in ipairs(Dropdown.Values) do
							local Txt = tostring(Value)

							if Search == "" or string.find(string.lower(Txt),Search,1,true) then
								local Item = Create("TextButton",{
									Parent = Scroll,
									BackgroundColor3 = Theme.Element,
									BackgroundTransparency = 0.08,
									BorderSizePixel = 0,
									Size = UDim2.new(1,0,0,34),
									Text = "",
									ZIndex = 53
								})

								Corner(Item,10)
								Stroke(Item,Theme.Border,1,0.94)

								Create("TextLabel",{
									Parent = Item,
									BackgroundTransparency = 1,
									Position = UDim2.new(0,10,0,0),
									Size = UDim2.new(1,-20,1,0),
									Font = Enum.Font.Gotham,
									Text = Txt,
									TextSize = 13,
									TextColor3 = Theme.Text,
									TextXAlignment = Enum.TextXAlignment.Left,
									ZIndex = 54
								})

								Item.MouseButton1Click:Connect(function()
									Label.Text = IconText(Data.Icon,(Data.Title or "Dropdown").." : "..Txt)

									if Data.Callback then
										Data.Callback(Value)
									end

									Overlay:Destroy()
								end)

								table.insert(Buttons,Item)
							end
						end
					end

					Build()

					SearchBox2:GetPropertyChangedSignal("Text"):Connect(Build)
				end

				Btn.MouseButton1Click:Connect(OpenDropdown)

				function Dropdown:Refresh(New)
					Dropdown.Values = New or {}
				end

				return Dropdown
			end

			return Section
		end

		return Tab
	end

	function Library:Notify(Data)
		Data = Data or {}

		local Notify = Create("Frame",{
			Parent = Gui,
			BackgroundColor3 = Theme.Panel,
			BackgroundTransparency = 0.05,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(1,0),
			Position = UDim2.new(1,280,0,20),
			Size = UDim2.fromOffset(260,68)
		})

		Corner(Notify,14)
		Stroke(Notify,Theme.Accent,1,0.4)

		Create("TextLabel",{
			Parent = Notify,
			BackgroundTransparency = 1,
			Position = UDim2.new(0,12,0,8),
			Size = UDim2.new(1,-24,0,18),
			Font = Enum.Font.GothamBold,
			Text = Data.Title or "Notify",
			TextSize = 15,
			TextColor3 = Theme.Text,
			TextXAlignment = Enum.TextXAlignment.Left
		})

		Create("TextLabel",{
			Parent = Notify,
			BackgroundTransparency = 1,
			Position = UDim2.new(0,12,0,28),
			Size = UDim2.new(1,-24,0,26),
			Font = Enum.Font.Gotham,
			Text = Data.Content or "",
			TextWrapped = true,
			TextSize = 12,
			TextColor3 = Theme.SubText,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top
		})

		Tween(Notify,0.25,{
			Position = UDim2.new(1,-18,0,20)
		})

		task.delay(Data.Duration or 4,function()
			Tween(Notify,0.2,{
				Position = UDim2.new(1,280,0,20)
			})

			task.wait(0.22)

			if Notify then
				Notify:Destroy()
			end
		end)
	end

	return Window
end

return Library
