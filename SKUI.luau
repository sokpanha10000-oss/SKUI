--// SKUI PREMIUM GLASS LIBRARY (MERGED CLEAN VERSION)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Library = {}
Library.__index = Library
Library._lastWindow = nil

local Theme = {
	Accent = Color3.fromRGB(180, 10, 20),
	Background = Color3.fromRGB(12,12,14),
	Topbar = Color3.fromRGB(18,18,22),
	Panel = Color3.fromRGB(20,20,25),
	Element = Color3.fromRGB(28,28,34),
	Text = Color3.fromRGB(255,255,255),
	SubText = Color3.fromRGB(180,180,180),
	Border = Color3.fromRGB(255,255,255)
}

--// Helpers
local function Create(class, props)
	local obj = Instance.new(class)
	for i,v in pairs(props or {}) do
		obj[i] = v
	end
	return obj
end

local function Corner(obj, r)
	Create("UICorner", {
		Parent = obj,
		CornerRadius = UDim.new(0, r or 12)
	})
end

local function Stroke(obj, transparency)
	Create("UIStroke", {
		Parent = obj,
		Color = Theme.Border,
		Thickness = 1,
		Transparency = transparency or 0.85
	})
end

local function Padding(obj,t,b,l,r)
	Create("UIPadding",{
		Parent=obj,
		PaddingTop=UDim.new(0,t or 0),
		PaddingBottom=UDim.new(0,b or 0),
		PaddingLeft=UDim.new(0,l or 0),
		PaddingRight=UDim.new(0,r or 0)
	})
end

local function List(obj,pad)
	Create("UIListLayout",{
		Parent=obj,
		Padding=UDim.new(0,pad or 8),
		SortOrder=Enum.SortOrder.LayoutOrder
	})
end

local function Draggable(frame, drag)
	local dragging=false
	local dragInput,start,startPos

	drag.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging=true
			start=input.Position
			startPos=frame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging=false
				end
			end)
		end
	end)

	drag.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput=input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input==dragInput then
			local delta=input.Position-start
			frame.Position=UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset+delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset+delta.Y
			)
		end
	end)
end

local function IconText(icon,text)
	if icon and tostring(icon) ~= "" then
		return tostring(icon).."  "..tostring(text)
	end
	return tostring(text)
end

--// Create Window
function Library:CreateWindow(opts)
	opts=opts or {}

	local Window={}
	Window.Tabs={}
	Window.CurrentTab=nil

	local Blur=Create("BlurEffect",{
		Parent=Lighting,
		Size=12
	})

	local GUI=Create("ScreenGui",{
		Name="SKUI",
		ResetOnSpawn=false,
		IgnoreGuiInset=true,
		Parent=PlayerGui
	})

	local Main=Create("Frame",{
		Parent=GUI,
		Size=opts.Size or UDim2.fromOffset(520,480),
		Position=UDim2.new(0.5,-260,0.5,-240),
		BackgroundColor3=Theme.Background,
		BackgroundTransparency=0.25,
		BorderSizePixel=0
	})
	Corner(Main,18)
	Stroke(Main,0.75)

	local Topbar=Create("Frame",{
		Parent=Main,
		Size=UDim2.new(1,0,0,60),
		BackgroundColor3=Theme.Topbar,
		BackgroundTransparency=0.15,
		BorderSizePixel=0
	})
	Corner(Topbar,18)

	Create("Frame",{
		Parent=Topbar,
		Size=UDim2.new(1,0,0,18),
		Position=UDim2.new(0,0,1,-18),
		BackgroundColor3=Theme.Topbar,
		BorderSizePixel=0
	})

	Create("TextLabel",{
		Parent=Topbar,
		BackgroundTransparency=1,
		Position=UDim2.new(0,16,0,8),
		Size=UDim2.new(1,-120,0,20),
		Font=Enum.Font.GothamBold,
		Text=opts.Title or "SKUI",
		TextSize=18,
		TextColor3=Theme.Text,
		TextXAlignment=Enum.TextXAlignment.Left
	})

	Create("TextLabel",{
		Parent=Topbar,
		BackgroundTransparency=1,
		Position=UDim2.new(0,16,0,30),
		Size=UDim2.new(1,-120,0,16),
		Font=Enum.Font.Gotham,
		Text=opts.SubTitle or "",
		TextSize=12,
		TextColor3=Theme.SubText,
		TextXAlignment=Enum.TextXAlignment.Left
	})

	-- Close
	local Close=Create("TextButton",{
		Parent=Topbar,
		Size=UDim2.fromOffset(30,30),
		Position=UDim2.new(1,-40,0,15),
		Text="✕",
		Font=Enum.Font.GothamBold,
		TextSize=16,
		TextColor3=Theme.Text,
		BackgroundColor3=Theme.Element,
		BackgroundTransparency=0.1,
		BorderSizePixel=0
	})
	Corner(Close,10)
	Stroke(Close,0.8)

	-- Content
	local Content=Create("Frame",{
		Parent=Main,
		BackgroundTransparency=1,
		Position=UDim2.new(0,0,0,60),
		Size=UDim2.new(1,0,1,-60)
	})

	-- Left
	local Left=Create("Frame",{
		Parent=Content,
		Size=UDim2.new(0,160,1,-20),
		Position=UDim2.new(0,10,0,10),
		BackgroundColor3=Theme.Panel,
		BackgroundTransparency=0.15,
		BorderSizePixel=0
	})
	Corner(Left,16)
	Stroke(Left,0.85)

	-- Profile
	local Profile=Create("Frame",{
		Parent=Left,
		Size=UDim2.new(1,-12,0,58),
		Position=UDim2.new(0,6,0,6),
		BackgroundColor3=Theme.Element,
		BackgroundTransparency=0.08,
		BorderSizePixel=0
	})
	Corner(Profile,12)
	Stroke(Profile,0.9)

	local Avatar=Create("ImageLabel",{
		Parent=Profile,
		Size=UDim2.fromOffset(38,38),
		Position=UDim2.new(0,10,0,10),
		BackgroundTransparency=1
	})
	Corner(Avatar,99)

	task.spawn(function()
		local ok,img=pcall(function()
			return Players:GetUserThumbnailAsync(
				LocalPlayer.UserId,
				Enum.ThumbnailType.HeadShot,
				Enum.ThumbnailSize.Size100x100
			)
		end)
		if ok then
			Avatar.Image=img
		end
	end)

	Create("TextLabel",{
		Parent=Profile,
		BackgroundTransparency=1,
		Position=UDim2.new(0,56,0,10),
		Size=UDim2.new(1,-60,0,18),
		Font=Enum.Font.GothamBold,
		Text=opts.UserInfoTitle or LocalPlayer.DisplayName,
		TextSize=13,
		TextColor3=Theme.Text,
		TextXAlignment=Enum.TextXAlignment.Left
	})

	Create("TextLabel",{
		Parent=Profile,
		BackgroundTransparency=1,
		Position=UDim2.new(0,56,0,28),
		Size=UDim2.new(1,-60,0,16),
		Font=Enum.Font.Gotham,
		Text=opts.UserInfoSubtitle or "Advanced User",
		TextSize=11,
		TextColor3=Theme.SubText,
		TextXAlignment=Enum.TextXAlignment.Left
	})

	-- Search
	local SearchFrame=Create("Frame",{
		Parent=Left,
		Size=UDim2.new(1,-12,0,32),
		Position=UDim2.new(0,6,0,72),
		BackgroundColor3=Theme.Element,
		BackgroundTransparency=0.08,
		BorderSizePixel=0
	})
	Corner(SearchFrame,10)
	Stroke(SearchFrame,0.9)

	Create("TextLabel",{
		Parent=SearchFrame,
		BackgroundTransparency=1,
		Position=UDim2.new(0,8,0,0),
		Size=UDim2.fromOffset(20,32),
		Text="⌕",
		Font=Enum.Font.GothamBold,
		TextSize=14,
		TextColor3=Theme.SubText
	})

	local Search=Create("TextBox",{
		Parent=SearchFrame,
		BackgroundTransparency=1,
		Position=UDim2.new(0,28,0,0),
		Size=UDim2.new(1,-32,1,0),
		PlaceholderText="Search...",
		Text="",
		ClearTextOnFocus=false,
		Font=Enum.Font.Gotham,
		TextSize=13,
		TextColor3=Theme.Text,
		TextXAlignment=Enum.TextXAlignment.Left
	})

	-- Tabs Scroll
	local TabsScroll=Create("ScrollingFrame",{
		Parent=Left,
		Position=UDim2.new(0,0,0,112),
		Size=UDim2.new(1,0,1,-118),
		BackgroundTransparency=1,
		BorderSizePixel=0,
		ScrollBarThickness=3,
		CanvasSize=UDim2.fromOffset(0,0),
		AutomaticCanvasSize=Enum.AutomaticSize.Y
	})
	Padding(TabsScroll,6,6,6,6)
	List(TabsScroll,8)

	-- Right
	local Right=Create("Frame",{
		Parent=Content,
		Position=UDim2.new(0,180,0,10),
		Size=UDim2.new(1,-190,1,-20),
		BackgroundTransparency=1
	})

	Draggable(Main,Topbar)

	-- Minimize Key
	UserInputService.InputBegan:Connect(function(input,gp)
		if gp then return end

		if input.KeyCode == (opts.MinimizeKey or Enum.KeyCode.LeftControl) then
			Main.Visible=not Main.Visible

			if Main.Visible then
				Blur.Size=12
			else
				Blur.Size=0
			end
		end
	end)

	-- Close
	Close.MouseButton1Click:Connect(function()
		Blur:Destroy()
		GUI:Destroy()
	end)

	-- Create Minimize Btn
	function Window:CreateMinimizeBtn(data)
		local Btn=Create("TextButton",{
			Parent=GUI,
			Size=UDim2.fromOffset(120,38),
			Position=UDim2.new(0,20,0.5,-19),
			BackgroundColor3=Theme.Panel,
			BackgroundTransparency=0.1,
			BorderSizePixel=0,
			Text=""
		})
		Corner(Btn,12)
		Stroke(Btn,0.8)

		Create("TextLabel",{
			Parent=Btn,
			BackgroundTransparency=1,
			Position=UDim2.new(0,12,0,0),
			Size=UDim2.new(1,-24,1,0),
			Font=Enum.Font.GothamSemibold,
			Text=data.Title or "Open UI",
			TextSize=13,
			TextColor3=Theme.Text,
			TextXAlignment=Enum.TextXAlignment.Left
		})

		Draggable(Btn,Btn)

		Btn.MouseButton1Click:Connect(function()
			Main.Visible=not Main.Visible

			if Main.Visible then
				Blur.Size=12
			else
				Blur.Size=0
			end
		end)

		return Btn
	end

	-- Add Tab
	function Window:AddTab(tabData)
		local Tab={}
		local TabBtn=Create("TextButton",{
			Parent=TabsScroll,
			Size=UDim2.new(1,0,0,40),
			BackgroundColor3=Theme.Element,
			BackgroundTransparency=0.08,
			BorderSizePixel=0,
			Text=""
		})
		Corner(TabBtn,12)
		Stroke(TabBtn,0.92)

		Create("TextLabel",{
			Parent=TabBtn,
			BackgroundTransparency=1,
			Position=UDim2.new(0,12,0,0),
			Size=UDim2.new(1,-20,1,0),
			Font=Enum.Font.GothamSemibold,
			Text=IconText(tabData.Icon,tabData.Title),
			TextSize=13,
			TextColor3=Theme.Text,
			TextXAlignment=Enum.TextXAlignment.Left
		})

		local Page=Create("ScrollingFrame",{
			Parent=Right,
			Size=UDim2.new(1,0,1,0),
			BackgroundTransparency=1,
			BorderSizePixel=0,
			ScrollBarThickness=3,
			Visible=false,
			CanvasSize=UDim2.fromOffset(0,0),
			AutomaticCanvasSize=Enum.AutomaticSize.Y
		})
		Padding(Page,2,2,2,2)
		List(Page,10)

		TabBtn.MouseButton1Click:Connect(function()
			for _,v in pairs(Window.Tabs) do
				v.Page.Visible=false
			end
			Page.Visible=true
			Window.CurrentTab=Tab
		end)

		Tab.Page=Page
		table.insert(Window.Tabs,Tab)

		if not Window.CurrentTab then
			Page.Visible=true
			Window.CurrentTab=Tab
		end

		-- Add Section
		function Tab:AddSection(name)
			local Section={}

			local Holder=Create("Frame",{
				Parent=Page,
				Size=UDim2.new(1,0,0,40),
				AutomaticSize=Enum.AutomaticSize.Y,
				BackgroundColor3=Theme.Element,
				BackgroundTransparency=0.08,
				BorderSizePixel=0
			})
			Corner(Holder,14)
			Stroke(Holder,0.94)
			Padding(Holder,12,12,12,12)

			Create("TextLabel",{
				Parent=Holder,
				BackgroundTransparency=1,
				Size=UDim2.new(1,0,0,18),
				Text=name,
				Font=Enum.Font.GothamBold,
				TextSize=14,
				TextColor3=Theme.Text,
				TextXAlignment=Enum.TextXAlignment.Left
			})

			local Content=Create("ScrollingFrame",{
				Parent=Holder,
				Position=UDim2.new(0,0,0,26),
				Size=UDim2.new(1,0,0,0),
				AutomaticSize=Enum.AutomaticSize.Y,
				BackgroundTransparency=1,
				BorderSizePixel=0,
				CanvasSize=UDim2.fromOffset(0,0),
				AutomaticCanvasSize=Enum.AutomaticSize.Y,
				ScrollBarThickness=3
			})
			List(Content,8)

			local function Base(h)
				local F=Create("Frame",{
					Parent=Content,
					Size=UDim2.new(1,0,0,h),
					BackgroundColor3=Theme.Panel,
					BackgroundTransparency=0.08,
					BorderSizePixel=0
				})
				Corner(F,12)
				Stroke(F,0.95)
				return F
			end

			-- Button
			function Section:AddButton(data)
				local Frame=Base(40)

				local Btn=Create("TextButton",{
					Parent=Frame,
					Name=data.Name or "click",
					Size=UDim2.new(1,0,1,0),
					BackgroundTransparency=1,
					Text=""
				})

				Create("TextLabel",{
					Parent=Btn,
					BackgroundTransparency=1,
					Position=UDim2.new(0,12,0,0),
					Size=UDim2.new(1,-24,1,0),
					Text=IconText(data.Icon,data.Title),
					Font=Enum.Font.GothamSemibold,
					TextSize=13,
					TextColor3=Theme.Text,
					TextXAlignment=Enum.TextXAlignment.Left
				})

				Btn.MouseButton1Click:Connect(function()
					if data.Callback then
						data.Callback()
					end
				end)
			end

			-- Toggle
			function Section:AddToggle(data)
				local Frame=Base(42)

				local Value=data.Default or false

				Create("TextLabel",{
					Parent=Frame,
					BackgroundTransparency=1,
					Position=UDim2.new(0,12,0,0),
					Size=UDim2.new(1,-60,1,0),
					Text=IconText(data.Icon,data.Title),
					Font=Enum.Font.GothamSemibold,
					TextSize=13,
					TextColor3=Theme.Text,
					TextXAlignment=Enum.TextXAlignment.Left
				})

				local Box=Create("TextButton",{
					Parent=Frame,
					Size=UDim2.fromOffset(22,22),
					Position=UDim2.new(1,-34,0.5,-11),
					BackgroundColor3=Theme.Element,
					BackgroundTransparency=0.08,
					Text=""
				})
				Corner(Box,6)
				Stroke(Box,0.9)

				local Fill=Create("Frame",{
					Parent=Box,
					Size=UDim2.new(1,-6,1,-6),
					Position=UDim2.new(0,3,0,3),
					BackgroundColor3=Theme.Accent,
					Visible=Value
				})
				Corner(Fill,5)

				Box.MouseButton1Click:Connect(function()
					Value=not Value
					Fill.Visible=Value

					if data.Callback then
						data.Callback(Value)
					end
				end)
			end

			-- Slider
			function Section:AddSlider(data)
				local Min=data.Min or 0
				local Max=data.Max or 100
				local Value=data.Default or Min

				local Frame=Base(58)

				local Label=Create("TextLabel",{
					Parent=Frame,
					BackgroundTransparency=1,
					Position=UDim2.new(0,12,0,0),
					Size=UDim2.new(1,-24,0,16),
					Text=IconText(data.Icon,data.Title),
					Font=Enum.Font.GothamSemibold,
					TextSize=13,
					TextColor3=Theme.Text,
					TextXAlignment=Enum.TextXAlignment.Left
				})

				local Number=Create("TextLabel",{
					Parent=Frame,
					BackgroundTransparency=1,
					Position=UDim2.new(1,-60,0,0),
					Size=UDim2.fromOffset(50,16),
					Text=tostring(Value),
					Font=Enum.Font.Gotham,
					TextSize=12,
					TextColor3=Theme.SubText,
					TextXAlignment=Enum.TextXAlignment.Right
				})

				local Bar=Create("Frame",{
					Parent=Frame,
					Position=UDim2.new(0,12,0,30),
					Size=UDim2.new(1,-24,0,12),
					BackgroundColor3=Theme.Element,
					BackgroundTransparency=0.08
				})
				Corner(Bar,8)

				local Fill=Create("Frame",{
					Parent=Bar,
					Size=UDim2.new((Value-Min)/(Max-Min),0,1,0),
					BackgroundColor3=Theme.Accent
				})
				Corner(Fill,8)

				local dragging=false

				local function Set(v)
					v=math.clamp(v,Min,Max)
					Value=v

					local Percent=(v-Min)/(Max-Min)

					Fill.Size=UDim2.new(Percent,0,1,0)
					Number.Text=tostring(math.floor(v))

					if data.Callback then
						data.Callback(v)
					end
				end

				Bar.InputBegan:Connect(function(input)
					if input.UserInputType==Enum.UserInputType.MouseButton1 then
						dragging=true
					end
				end)

				Bar.InputEnded:Connect(function(input)
					if input.UserInputType==Enum.UserInputType.MouseButton1 then
						dragging=false
					end
				end)

				UserInputService.InputChanged:Connect(function(input)
					if dragging and input.UserInputType==Enum.UserInputType.MouseMovement then
						local Percent=math.clamp(
							(input.Position.X-Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X,
							0,1
						)

						Set(Min+((Max-Min)*Percent))
					end
				end)
			end

			-- Input
			function Section:AddInput(data)
				local Frame=Base(52)

				Create("TextLabel",{
					Parent=Frame,
					BackgroundTransparency=1,
					Position=UDim2.new(0,12,0,2),
					Size=UDim2.new(1,-24,0,16),
					Text=IconText(data.Icon,data.Title),
					Font=Enum.Font.GothamSemibold,
					TextSize=13,
					TextColor3=Theme.Text,
					TextXAlignment=Enum.TextXAlignment.Left
				})

				local Box=Create("TextBox",{
					Parent=Frame,
					Position=UDim2.new(0,12,0,24),
					Size=UDim2.new(1,-24,0,24),
					BackgroundColor3=Theme.Element,
					BackgroundTransparency=0.08,
					Text="",
					PlaceholderText=data.Placeholder or "",
					ClearTextOnFocus=false,
					Font=Enum.Font.Gotham,
					TextSize=13,
					TextColor3=Theme.Text,
					TextXAlignment=Enum.TextXAlignment.Left
				})
				Corner(Box,8)
				Stroke(Box,0.94)

				Box.FocusLost:Connect(function()
					if data.Callback then
						data.Callback(Box.Text)
					end
				end)
			end

			-- Dropdown
			function Section:AddDropdown(data)
				local Frame=Base(44)

				local Values=data.Values or {}
				local Current=data.Default or Values[1]

				local Btn=Create("TextButton",{
					Parent=Frame,
					Size=UDim2.new(1,0,1,0),
					BackgroundTransparency=1,
					Text=""
				})

				local Label=Create("TextLabel",{
					Parent=Btn,
					BackgroundTransparency=1,
					Position=UDim2.new(0,12,0,0),
					Size=UDim2.new(1,-30,1,0),
					Text=IconText(data.Icon,data.Title).." : "..tostring(Current),
					Font=Enum.Font.GothamSemibold,
					TextSize=13,
					TextColor3=Theme.Text,
					TextXAlignment=Enum.TextXAlignment.Left
				})

				Create("TextLabel",{
					Parent=Btn,
					BackgroundTransparency=1,
					Position=UDim2.new(1,-24,0,0),
					Size=UDim2.fromOffset(20,44),
					Text="⌄",
					Font=Enum.Font.GothamBold,
					TextSize=18,
					TextColor3=Theme.SubText
				})

				local Dropdown={}
				Dropdown.Values=Values

				function Dropdown:Refresh(newValues)
					self.Values=newValues
				end

				Btn.MouseButton1Click:Connect(function()

					local Overlay=Create("Frame",{
						Parent=GUI,
						Size=UDim2.fromScale(1,1),
						BackgroundColor3=Color3.new(0,0,0),
						BackgroundTransparency=0.55,
						ZIndex=50
					})

					local Popup=Create("Frame",{
						Parent=Overlay,
						Size=UDim2.fromOffset(320,340),
						Position=UDim2.new(0.5,-160,0.5,-170),
						BackgroundColor3=Theme.Panel,
						BackgroundTransparency=0.08,
						ZIndex=51
					})
					Corner(Popup,16)
					Stroke(Popup,0.86)

					local ClosePopup=Create("TextButton",{
						Parent=Popup,
						Size=UDim2.fromOffset(28,28),
						Position=UDim2.new(1,-38,0,10),
						Text="✕",
						Font=Enum.Font.GothamBold,
						TextSize=14,
						TextColor3=Theme.Text,
						BackgroundColor3=Theme.Element,
						BackgroundTransparency=0.1,
						ZIndex=52
					})
					Corner(ClosePopup,10)

					ClosePopup.MouseButton1Click:Connect(function()
						Overlay:Destroy()
					end)

					local SearchBox

					if not data.NoSearch then
						local SearchFrame=Create("Frame",{
							Parent=Popup,
							Position=UDim2.new(0,12,0,44),
							Size=UDim2.new(1,-24,0,30),
							BackgroundColor3=Theme.Element,
							BackgroundTransparency=0.08,
							ZIndex=52
						})
						Corner(SearchFrame,10)

						SearchBox=Create("TextBox",{
							Parent=SearchFrame,
							BackgroundTransparency=1,
							Position=UDim2.new(0,10,0,0),
							Size=UDim2.new(1,-20,1,0),
							PlaceholderText="Search...",
							Text="",
							ClearTextOnFocus=false,
							Font=Enum.Font.Gotham,
							TextSize=13,
							TextColor3=Theme.Text,
							TextXAlignment=Enum.TextXAlignment.Left,
							ZIndex=53
						})
					end

					local Scroll=Create("ScrollingFrame",{
						Parent=Popup,
						Position=UDim2.new(0,12,0,data.NoSearch and 44 or 82),
						Size=UDim2.new(1,-24,1,-(data.NoSearch and 56 or 94)),
						BackgroundTransparency=1,
						BorderSizePixel=0,
						CanvasSize=UDim2.fromOffset(0,0),
						AutomaticCanvasSize=Enum.AutomaticSize.Y,
						ScrollBarThickness=3,
						ZIndex=52
					})
					List(Scroll,8)

					local Buttons={}

					local function RefreshSearch()
						local Query=SearchBox and string.lower(SearchBox.Text) or ""

						for _,Btn in pairs(Buttons) do
							Btn.Visible=Query=="" or string.find(
								string.lower(Btn.Name),
								Query,
								1,
								true
							)
						end
					end

					for _,v in ipairs(Dropdown.Values) do
						local Item=Create("TextButton",{
							Parent=Scroll,
							Name=tostring(v),
							Size=UDim2.new(1,0,0,34),
							BackgroundColor3=Theme.Element,
							BackgroundTransparency=0.08,
							Text="",
							ZIndex=53
						})
						Corner(Item,10)
						Stroke(Item,0.94)

						Create("TextLabel",{
							Parent=Item,
							BackgroundTransparency=1,
							Position=UDim2.new(0,10,0,0),
							Size=UDim2.new(1,-20,1,0),
							Text=tostring(v),
							Font=Enum.Font.Gotham,
							TextSize=13,
							TextColor3=Theme.Text,
							TextXAlignment=Enum.TextXAlignment.Left,
							ZIndex=54
						})

						Item.MouseButton1Click:Connect(function()
							Current=v
							Label.Text=IconText(data.Icon,data.Title).." : "..tostring(v)

							if data.Callback then
								data.Callback(v)
							end

							Overlay:Destroy()
						end)

						table.insert(Buttons,Item)
					end

					if SearchBox then
						SearchBox:GetPropertyChangedSignal("Text"):Connect(RefreshSearch)
					end
				end)

				return Dropdown
			end

			return Section
		end

		return Tab
	end

	function Library:Notify(data)
		local Notify=Create("Frame",{
			Parent=GUI,
			Size=UDim2.fromOffset(260,68),
			Position=UDim2.new(1,280,0,20),
			BackgroundColor3=Theme.Element,
			BackgroundTransparency=0.05,
			BorderSizePixel=0
		})
		Corner(Notify,14)
		Stroke(Notify,0.55)

		Create("TextLabel",{
			Parent=Notify,
			BackgroundTransparency=1,
			Position=UDim2.new(0,12,0,8),
			Size=UDim2.new(1,-24,0,18),
			Text=data.Title or "Notification",
			Font=Enum.Font.GothamBold,
			TextSize=14,
			TextColor3=Theme.Text,
			TextXAlignment=Enum.TextXAlignment.Left
		})

		Create("TextLabel",{
			Parent=Notify,
			BackgroundTransparency=1,
			Position=UDim2.new(0,12,0,30),
			Size=UDim2.new(1,-24,0,26),
			Text=data.Content or "",
			Font=Enum.Font.Gotham,
			TextSize=12,
			TextWrapped=true,
			TextColor3=Theme.SubText,
			TextXAlignment=Enum.TextXAlignment.Left,
			TextYAlignment=Enum.TextYAlignment.Top
		})

		TweenService:Create(
			Notify,
			TweenInfo.new(0.25),
			{Position=UDim2.new(1,-20,0,20)}
		):Play()

		task.delay(data.Duration or 4,function()
			if Notify then
				Notify:Destroy()
			end
		end)
	end

	Library._lastWindow=Window
	return Window
end

function Library:CreateUI(data)
	return self:CreateWindow(data)
end

return Library
