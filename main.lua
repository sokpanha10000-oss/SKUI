-- [[ SKBUILDER AI: GLASSMORPHIC UI LIBRARY ]]
-- Modern, High-Performance, Object-Oriented Luau UI Library with Glass Theme

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Debris = game:GetService("Debris")

local SKUI = {}
SKUI.__index = SKUI

-- Helper: Make Draggable
local function makeDraggable(frame, handle)
	local dragging = false
	local dragInput, dragStart, startPos

	local function update(input)
		local delta = input.Position - dragStart
		TweenService:Create(frame, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		}):Play()
	end

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	handle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

-- Helper: Standard Accent Hover Effect
local function addHoverEffect(instance, normalColor, hoverColor, targetProp)
	targetProp = targetProp or "BackgroundColor3"
	instance.MouseEnter:Connect(function()
		TweenService:Create(instance, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {[targetProp] = hoverColor}):Play()
	end)
	instance.MouseLeave:Connect(function()
		TweenService:Create(instance, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {[targetProp] = normalColor}):Play()
	end)
end

-- Create Window
function SKUI:CreateWindow(config)
	config = config or {}
	local titleText = config.Title or "My Super Hub"
	local authorText = config.Author or "by Unknown"
	local imageId = config.Image or ""

	local targetFolder = CoreGui:FindFirstChild("SKUI_Container") or Instance.new("Folder", CoreGui)
	targetFolder.Name = "SKUI_Container"

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = targetFolder

	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, 580, 0, 380)
	MainFrame.Position = UDim2.new(0.5, -290, 0.5, -190)
	MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MainFrame.BackgroundTransparency = 0.88 -- Pure clear glass vibe
	MainFrame.BorderSizePixel = 0
	MainFrame.Parent = ScreenGui

	-- UI Stroke (Glass Outline Glow)
	local WindowStroke = Instance.new("UIStroke")
	WindowStroke.Color = Color3.fromRGB(255, 255, 255)
	WindowStroke.Thickness = 1.5
	WindowStroke.Transparency = 0.4
	WindowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	WindowStroke.Parent = MainFrame

	-- Soft Corner Radius
	local WindowCorner = Instance.new("UICorner")
	WindowCorner.CornerRadius = UDim.new(0, 14)
	WindowCorner.Parent = MainFrame

	-- Top Header Bar
	local Header = Instance.new("Frame")
	Header.Name = "Header"
	Header.Size = UDim2.new(1, 0, 0, 45)
	Header.BackgroundTransparency = 1
	Header.Parent = MainFrame

	local TitleIcon = Instance.new("ImageLabel")
	TitleIcon.Name = "TitleIcon"
	TitleIcon.Size = UDim2.new(0, 24, 0, 24)
	TitleIcon.Position = UDim2.new(0, 15, 0.5, -12)
	TitleIcon.BackgroundTransparency = 1
	if imageId ~= "" then
		TitleIcon.Image = imageId:find("rbxassetid://") and imageId or "rbxassetid://" .. imageId
	else
		TitleIcon.Image = "rbxassetid://10747372701" -- Default fallback logo
	end
	TitleIcon.Parent = Header

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Name = "Title"
	TitleLabel.Size = UDim2.new(0, 200, 1, 0)
	TitleLabel.Position = UDim2.new(0, 48, 0, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = titleText
	TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.TextSize = 16
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Parent = Header

	local AuthorLabel = Instance.new("TextLabel")
	AuthorLabel.Name = "Author"
	AuthorLabel.Size = UDim2.new(0, 150, 1, 0)
	AuthorLabel.Position = UDim2.new(1, -210, 0, 0)
	AuthorLabel.BackgroundTransparency = 1
	AuthorLabel.Text = authorText
	AuthorLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	AuthorLabel.Font = Enum.Font.GothamMedium
	AuthorLabel.TextSize = 11
	AuthorLabel.TextXAlignment = Enum.TextXAlignment.Right
	AuthorLabel.Parent = Header

	-- Close Button
	local CloseBtn = Instance.new("ImageButton")
	CloseBtn.Name = "CloseBtn"
	CloseBtn.Size = UDim2.new(0, 24, 0, 24)
	CloseBtn.Position = UDim2.new(1, -38, 0.5, -12)
	CloseBtn.BackgroundTransparency = 1
	CloseBtn.Image = "rbxassetid://10747383863" -- Close Icon
	CloseBtn.ImageColor3 = Color3.fromRGB(255, 100, 100)
	CloseBtn.Parent = Header

	CloseBtn.MouseButton1Click:Connect(function()
		ScreenGui:Destroy()
	end)

	-- Body Content Separator Left / Right
	local ContentContainer = Instance.new("Frame")
	ContentContainer.Name = "ContentContainer"
	ContentContainer.Size = UDim2.new(1, -20, 1, -65)
	ContentContainer.Position = UDim2.new(0, 10, 0, 55)
	ContentContainer.BackgroundTransparency = 1
	ContentContainer.Parent = MainFrame

	-- Left Sidebar Box
	local Sidebar = Instance.new("Frame")
	Sidebar.Name = "Sidebar"
	Sidebar.Size = UDim2.new(0, 170, 1, 0)
	Sidebar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Sidebar.BackgroundTransparency = 0.95
	Sidebar.BorderSizePixel = 0
	Sidebar.Parent = ContentContainer

	local SidebarCorner = Instance.new("UICorner")
	SidebarCorner.CornerRadius = UDim.new(0, 10)
	SidebarCorner.Parent = Sidebar

	local SidebarStroke = Instance.new("UIStroke")
	SidebarStroke.Color = Color3.fromRGB(255, 255, 255)
	SidebarStroke.Thickness = 1
	SidebarStroke.Transparency = 0.7
	SidebarStroke.Parent = Sidebar

	-- Search Bar Frame (Inside Left Sidebar top)
	local SearchFrame = Instance.new("Frame")
	SearchFrame.Name = "SearchFrame"
	SearchFrame.Size = UDim2.new(1, -16, 0, 32)
	SearchFrame.Position = UDim2.new(0, 8, 0, 8)
	SearchFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SearchFrame.BackgroundTransparency = 0.92
	SearchFrame.Parent = Sidebar

	local SearchCorner = Instance.new("UICorner")
	SearchCorner.CornerRadius = UDim.new(0, 6)
	SearchCorner.Parent = SearchFrame

	local SearchStroke = Instance.new("UIStroke")
	SearchStroke.Color = Color3.fromRGB(255, 255, 255)
	SearchStroke.Thickness = 1
	SearchStroke.Transparency = 0.7
	SearchStroke.Parent = SearchFrame

	local SearchIcon = Instance.new("ImageLabel")
	SearchIcon.Name = "SearchIcon"
	SearchIcon.Size = UDim2.new(0, 16, 0, 16)
	SearchIcon.Position = UDim2.new(0, 8, 0.5, -8)
	SearchIcon.BackgroundTransparency = 1
	SearchIcon.Image = "rbxassetid://10723346959" -- Search Icon
	SearchIcon.ImageColor3 = Color3.fromRGB(220, 220, 220)
	SearchIcon.Parent = SearchFrame

	local SearchBox = Instance.new("TextBox")
	SearchBox.Name = "SearchBox"
	SearchBox.Size = UDim2.new(1, -34, 1, 0)
	SearchBox.Position = UDim2.new(0, 30, 0, 0)
	SearchBox.BackgroundTransparency = 1
	SearchBox.Text = ""
	SearchBox.PlaceholderText = "Search elements..."
	SearchBox.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
	SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	SearchBox.Font = Enum.Font.Gotham
	SearchBox.TextSize = 12
	SearchBox.TextXAlignment = Enum.TextXAlignment.Left
	SearchBox.Parent = SearchFrame

	-- Tabs Scrolling Container
	local TabListScroll = Instance.new("ScrollingFrame")
	TabListScroll.Name = "TabListScroll"
	TabListScroll.Size = UDim2.new(1, -10, 1, -54)
	TabListScroll.Position = UDim2.new(0, 5, 0, 48)
	TabListScroll.BackgroundTransparency = 1
	TabListScroll.BorderSizePixel = 0
	TabListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	TabListScroll.ScrollBarThickness = 2
	TabListScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
	TabListScroll.Parent = Sidebar

	local TabListLayout = Instance.new("UIListLayout")
	TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabListLayout.Padding = UDim.new(0, 5)
	TabListLayout.Parent = TabListScroll

	-- Right Side Container (Clean Open Canvas)
	local DisplayContainer = Instance.new("Frame")
	DisplayContainer.Name = "DisplayContainer"
	DisplayContainer.Size = UDim2.new(1, -185, 1, 0)
	DisplayContainer.Position = UDim2.new(0, 185, 0, 0)
	DisplayContainer.BackgroundTransparency = 1
	DisplayContainer.Parent = ContentContainer

	-- Center Dropdown Overlay (A single global popout overlay container)
	local DropdownOverlay = Instance.new("Frame")
	DropdownOverlay.Name = "DropdownOverlay"
	DropdownOverlay.Size = UDim2.new(1, 0, 1, 0)
	DropdownOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	DropdownOverlay.BackgroundTransparency = 1
	DropdownOverlay.Visible = false
	DropdownOverlay.ZIndex = 100
	DropdownOverlay.Parent = MainFrame

	local OverlayCorner = Instance.new("UICorner")
	OverlayCorner.CornerRadius = UDim.new(0, 14)
	OverlayCorner.Parent = DropdownOverlay

	local DropdownModal = Instance.new("Frame")
	DropdownModal.Name = "DropdownModal"
	DropdownModal.Size = UDim2.new(0, 240, 0, 220)
	DropdownModal.Position = UDim2.new(0.5, -120, 0.5, -110)
	DropdownModal.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	DropdownModal.BackgroundTransparency = 0.1
	DropdownModal.Parent = DropdownOverlay

	local ModalCorner = Instance.new("UICorner")
	ModalCorner.CornerRadius = UDim.new(0, 10)
	ModalCorner.Parent = DropdownModal

	local ModalStroke = Instance.new("UIStroke")
	ModalStroke.Color = Color3.fromRGB(255, 255, 255)
	ModalStroke.Thickness = 1
	ModalStroke.Parent = DropdownModal

	local ModalTitle = Instance.new("TextLabel")
	ModalTitle.Name = "ModalTitle"
	ModalTitle.Size = UDim2.new(1, 0, 0, 35)
	ModalTitle.BackgroundTransparency = 1
	ModalTitle.Text = "Select Option"
	ModalTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	ModalTitle.Font = Enum.Font.GothamBold
	ModalTitle.TextSize = 13
	ModalTitle.Parent = DropdownModal

	local ModalScroll = Instance.new("ScrollingFrame")
	ModalScroll.Name = "ModalScroll"
	ModalScroll.Size = UDim2.new(1, -16, 1, -75)
	ModalScroll.Position = UDim2.new(0, 8, 0, 35)
	ModalScroll.BackgroundTransparency = 1
	ModalScroll.BorderSizePixel = 0
	ModalScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	ModalScroll.ScrollBarThickness = 4
	ModalScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
	ModalScroll.Parent = DropdownModal

	local ModalScrollLayout = Instance.new("UIListLayout")
	ModalScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ModalScrollLayout.Padding = UDim.new(0, 4)
	ModalScrollLayout.Parent = ModalScroll

	local CloseModalBtn = Instance.new("TextButton")
	CloseModalBtn.Name = "CloseModalBtn"
	CloseModalBtn.Size = UDim2.new(1, -16, 0, 28)
	CloseModalBtn.Position = UDim2.new(0, 8, 1, -34)
	CloseModalBtn.BackgroundColor3 = Color3.fromRGB(230, 80, 80)
	CloseModalBtn.Text = "Cancel"
	CloseModalBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	CloseModalBtn.Font = Enum.Font.GothamBold
	CloseModalBtn.TextSize = 12
	CloseModalBtn.Parent = DropdownModal

	local CloseModalCorner = Instance.new("UICorner")
	CloseModalCorner.CornerRadius = UDim.new(0, 6)
	CloseModalCorner.Parent = CloseModalBtn

	CloseModalBtn.MouseButton1Click:Connect(function()
		TweenService:Create(DropdownOverlay, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
		DropdownModal:TweenSize(UDim2.new(0, 240, 0, 0), "Out", "Quad", 0.2, true, function()
			DropdownOverlay.Visible = false
		end)
	end)

	-- Setup Base Dragging
	makeDraggable(MainFrame, Header)

	-- Library Instance State
	local windowObject = {
		ScreenGui = ScreenGui,
		MainFrame = MainFrame,
		Tabs = {},
		ActiveTab = nil,
		ActiveGroupboxes = {},
		SearchQuery = ""
	}

	-- Create Minimize (Floating) Button
	function windowObject:CreateMinimizeBtn(minConfig)
		minConfig = minConfig or {}
		local minTitle = minConfig.Title or "Open UI"
		local minImage = minConfig.Image or ""

		local FloatingBtn = Instance.new("Frame")
		FloatingBtn.Name = "FloatingMinimize"
		FloatingBtn.Size = UDim2.new(0, 50, 0, 50)
		FloatingBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
		FloatingBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		FloatingBtn.BackgroundTransparency = 0.88
		FloatingBtn.Active = true
		FloatingBtn.Parent = ScreenGui

		local FloatCorner = Instance.new("UICorner")
		FloatCorner.CornerRadius = UDim.new(0.5, 0)
		FloatCorner.Parent = FloatingBtn

		local FloatStroke = Instance.new("UIStroke")
		FloatStroke.Color = Color3.fromRGB(255, 255, 255)
		FloatStroke.Thickness = 1.5
		FloatStroke.Parent = FloatingBtn

		local FloatIcon = Instance.new("ImageLabel")
		FloatIcon.Name = "Icon"
		FloatIcon.Size = UDim2.new(0, 24, 0, 24)
		FloatIcon.Position = UDim2.new(0.5, -12, 0.5, -12)
		FloatIcon.BackgroundTransparency = 1
		if minImage ~= "" then
			FloatIcon.Image = minImage:find("rbxassetid://") and minImage or "rbxassetid://" .. minImage
		else
			FloatIcon.Image = "rbxassetid://10723415122" -- System Toggle Icon
		end
		FloatIcon.Parent = FloatingBtn

		local FloatLabel = Instance.new("TextLabel")
		FloatLabel.Name = "Label"
		FloatLabel.Size = UDim2.new(0, 80, 0, 20)
		FloatLabel.Position = UDim2.new(0.5, -40, 1, 4)
		FloatLabel.BackgroundTransparency = 0.2
		FloatLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		FloatLabel.Text = minTitle
		FloatLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		FloatLabel.Font = Enum.Font.GothamMedium
		FloatLabel.TextSize = 10
		FloatLabel.Visible = false
		FloatLabel.Parent = FloatingBtn

		local LabelCorner = Instance.new("UICorner")
		LabelCorner.CornerRadius = UDim.new(0, 4)
		LabelCorner.Parent = FloatLabel

		FloatingBtn.MouseEnter:Connect(function()
			FloatLabel.Visible = true
		end)
		FloatingBtn.MouseLeave:Connect(function()
			FloatLabel.Visible = false
		end)

		-- Action to Minimize / Restore
		local ClickDetect = Instance.new("TextButton")
		ClickDetect.Name = "ClickDetect"
		ClickDetect.Size = UDim2.new(1, 0, 1, 0)
		ClickDetect.BackgroundTransparency = 1
		ClickDetect.Text = ""
		ClickDetect.Parent = FloatingBtn

		ClickDetect.MouseButton1Click:Connect(function()
			MainFrame.Visible = not MainFrame.Visible
		end)

		makeDraggable(FloatingBtn, ClickDetect)

		return FloatingBtn
	end

	-- Search System Engine Logic
	local function updateSearch(query)
		windowObject.SearchQuery = query:lower()
		for _, groupbox in ipairs(windowObject.ActiveGroupboxes) do
			local visibleElements = 0
			for _, element in ipairs(groupbox.Elements) do
				if windowObject.SearchQuery == "" or element.Title:lower():find(windowObject.SearchQuery) then
					element.Frame.Visible = true
					visibleElements = visibleElements + 1
				else
					element.Frame.Visible = false
				end
			end
			-- Hide the whole Groupbox if all contained elements are filtered out
			groupbox.Frame.Visible = (visibleElements > 0)
		end
	end

	SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
		updateSearch(SearchBox.Text)
	end)

	-- Tabs Creation Engine
	function windowObject:CreateTab(tabName)
		local TabBtn = Instance.new("TextButton")
		TabBtn.Name = tabName .. "_Tab"
		TabBtn.Size = UDim2.new(1, -10, 0, 32)
		TabBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabBtn.BackgroundTransparency = 1
		TabBtn.Text = tabName
		TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
		TabBtn.Font = Enum.Font.GothamMedium
		TabBtn.TextSize = 12
		TabBtn.Parent = TabListScroll

		local TabBtnCorner = Instance.new("UICorner")
		TabBtnCorner.CornerRadius = UDim.new(0, 6)
		TabBtnCorner.Parent = TabBtn

		local Canvas = Instance.new("ScrollingFrame")
		Canvas.Name = tabName .. "_Canvas"
		Canvas.Size = UDim2.new(1, 0, 1, 0)
		Canvas.BackgroundTransparency = 1
		Canvas.BorderSizePixel = 0
		Canvas.ScrollBarThickness = 3
		Canvas.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
		Canvas.CanvasSize = UDim2.new(0, 0, 0, 0)
		Canvas.Visible = false
		Canvas.Parent = DisplayContainer

		local CanvasLayout = Instance.new("UIListLayout")
		CanvasLayout.SortOrder = Enum.SortOrder.LayoutOrder
		CanvasLayout.Padding = UDim.new(0, 12)
		CanvasLayout.Parent = Canvas

		CanvasLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			Canvas.CanvasSize = UDim2.new(0, 0, 0, CanvasLayout.AbsoluteContentSize.Y + 20)
		end)

		local tabObject = {
			Name = tabName,
			Button = TabBtn,
			Canvas = Canvas,
			Groupboxes = {}
		}

		local function selectTab()
			for _, t in ipairs(windowObject.Tabs) do
				t.Button.BackgroundTransparency = 1
				t.Button.TextColor3 = Color3.fromRGB(180, 180, 180)
				t.Canvas.Visible = false
			end
			TabBtn.BackgroundTransparency = 0.92
			TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			Canvas.Visible = true
			windowObject.ActiveTab = tabObject
			windowObject.ActiveGroupboxes = tabObject.Groupboxes
			updateSearch(SearchBox.Text)
		end

		TabBtn.MouseButton1Click:Connect(selectTab)

		-- Select first tab automatically
		if #windowObject.Tabs == 0 then
			selectTab()
		end

		table.insert(windowObject.Tabs, tabObject)

		-- Groupbox Creator inside Tab
		function tabObject:CreateGroupbox(groupName)
			local GroupFrame = Instance.new("Frame")
			GroupFrame.Name = groupName .. "_Group"
			GroupFrame.Size = UDim2.new(1, -10, 0, 45) -- Auto-scales lower
			GroupFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			GroupFrame.BackgroundTransparency = 0.96
			GroupFrame.Parent = Canvas

			local GroupCorner = Instance.new("UICorner")
			GroupCorner.CornerRadius = UDim.new(0, 8)
			GroupCorner.Parent = GroupFrame

			local GroupStroke = Instance.new("UIStroke")
			GroupStroke.Color = Color3.fromRGB(255, 255, 255)
			GroupStroke.Thickness = 1
			GroupStroke.Transparency = 0.8
			GroupStroke.Parent = GroupFrame

			local GroupTitle = Instance.new("TextLabel")
			GroupTitle.Name = "Header"
			GroupTitle.Size = UDim2.new(1, -12, 0, 25)
			GroupTitle.Position = UDim2.new(0, 12, 0, 4)
			GroupTitle.BackgroundTransparency = 1
			GroupTitle.Text = groupName:upper()
			GroupTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			GroupTitle.Font = Enum.Font.GothamBold
			GroupTitle.TextSize = 10
			GroupTitle.TextXAlignment = Enum.TextXAlignment.Left
			GroupTitle.Parent = GroupFrame

			local GroupList = Instance.new("Frame")
			GroupList.Name = "GroupList"
			GroupList.Size = UDim2.new(1, -24, 1, -30)
			GroupList.Position = UDim2.new(0, 12, 0, 26)
			GroupList.BackgroundTransparency = 1
			GroupList.Parent = GroupFrame

			local GroupLayout = Instance.new("UIListLayout")
			GroupLayout.SortOrder = Enum.SortOrder.LayoutOrder
			GroupLayout.Padding = UDim.new(0, 8)
			GroupLayout.Parent = GroupList

			local function resizeGroup()
				local contentHeight = GroupLayout.AbsoluteContentSize.Y
				GroupFrame.Size = UDim2.new(1, -10, 0, contentHeight + 36)
				GroupList.Size = UDim2.new(1, -24, 0, contentHeight)
			end

			GroupLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(resizeGroup)

			local groupboxObject = {
				Frame = GroupFrame,
				Elements = {}
			}
			table.insert(tabObject.Groupboxes, groupboxObject)

			-- Component 1: BUTTON
			function groupboxObject:CreateButton(btnConfig)
				btnConfig = btnConfig or {}
				local bTitle = btnConfig.Title or "Button"
				local bCallback = btnConfig.Callback or function() end

				local ButtonFrame = Instance.new("Frame")
				ButtonFrame.Name = "ButtonFrame"
				ButtonFrame.Size = UDim2.new(1, 0, 0, 32)
				ButtonFrame.BackgroundTransparency = 1
				ButtonFrame.Parent = GroupList

				local ActionBtn = Instance.new("TextButton")
				ActionBtn.Name = "ActionBtn"
				ActionBtn.Size = UDim2.new(1, 0, 1, 0)
				ActionBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ActionBtn.BackgroundTransparency = 0.92
				ActionBtn.Text = "  " .. bTitle
				ActionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
				ActionBtn.Font = Enum.Font.GothamMedium
				ActionBtn.TextSize = 12
				ActionBtn.TextXAlignment = Enum.TextXAlignment.Left
				ActionBtn.Parent = ButtonFrame

				local BtnCorner = Instance.new("UICorner")
				BtnCorner.CornerRadius = UDim.new(0, 6)
				BtnCorner.Parent = ActionBtn

				local BtnStroke = Instance.new("UIStroke")
				BtnStroke.Color = Color3.fromRGB(255, 255, 255)
				BtnStroke.Thickness = 0.8
				BtnStroke.Transparency = 0.7
				BtnStroke.Parent = ActionBtn

				addHoverEffect(ActionBtn, Color3.fromRGB(255, 255, 255), Color3.fromRGB(220, 240, 255), "TextColor3")

				ActionBtn.MouseButton1Click:Connect(function()
					-- Button click shrink effect
					ActionBtn:TweenSize(UDim2.new(0.98, 0, 0.9, 0), "Out", "Quad", 0.08, true, function()
						ActionBtn:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quad", 0.08)
					end)
					task.spawn(bCallback)
				end)

				table.insert(groupboxObject.Elements, {Title = bTitle, Frame = ButtonFrame})
				resizeGroup()
			end

			-- Component 2: DROPDOWN (Modal Popout Style)
			function groupboxObject:CreateDropdown(dropConfig)
				dropConfig = dropConfig or {}
				local dTitle = dropConfig.Title or "Dropdown"
				local dValues = dropConfig.Values or {}
				local currentVal = dropConfig.Value or dValues[1] or "None"
				local dCallback = dropConfig.Callback or function() end

				local DropdownFrame = Instance.new("Frame")
				DropdownFrame.Name = "DropdownFrame"
				DropdownFrame.Size = UDim2.new(1, 0, 0, 32)
				DropdownFrame.BackgroundTransparency = 1
				DropdownFrame.Parent = GroupList

				local SelectBtn = Instance.new("TextButton")
				SelectBtn.Name = "SelectBtn"
				SelectBtn.Size = UDim2.new(1, 0, 1, 0)
				SelectBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SelectBtn.BackgroundTransparency = 0.92
				SelectBtn.Text = "  " .. dTitle .. " : " .. currentVal
				SelectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
				SelectBtn.Font = Enum.Font.GothamMedium
				SelectBtn.TextSize = 12
				SelectBtn.TextXAlignment = Enum.TextXAlignment.Left
				SelectBtn.Parent = DropdownFrame

				local SelectCorner = Instance.new("UICorner")
				SelectCorner.CornerRadius = UDim.new(0, 6)
				SelectCorner.Parent = SelectBtn

				local SelectStroke = Instance.new("UIStroke")
				SelectStroke.Color = Color3.fromRGB(255, 255, 255)
				SelectStroke.Thickness = 0.8
				SelectStroke.Transparency = 0.7
				SelectStroke.Parent = SelectBtn

				local DropIcon = Instance.new("ImageLabel")
				DropIcon.Size = UDim2.new(0, 14, 0, 14)
				DropIcon.Position = UDim2.new(1, -22, 0.5, -7)
				DropIcon.BackgroundTransparency = 1
				DropIcon.Image = "rbxassetid://10752184940" -- Dropdown Arrow
				DropIcon.Parent = SelectBtn

				local dropdownInstance = {}

				local function openModal()
					-- Reset the Modal container list
					for _, item in ipairs(ModalScroll:GetChildren()) do
						if item:IsA("TextButton") then
							item:Destroy()
						end
					end

					ModalTitle.Text = "Select " .. dTitle

					for _, val in ipairs(dValues) do
						local OptBtn = Instance.new("TextButton")
						OptBtn.Name = val .. "_Option"
						OptBtn.Size = UDim2.new(1, -10, 0, 30)
						OptBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						OptBtn.BackgroundTransparency = 0.95
						OptBtn.Text = val
						OptBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
						OptBtn.Font = Enum.Font.Gotham
						OptBtn.TextSize = 12
						OptBtn.Parent = ModalScroll

						local OptCorner = Instance.new("UICorner")
						OptCorner.CornerRadius = UDim.new(0, 5)
						OptCorner.Parent = OptBtn

						OptBtn.MouseButton1Click:Connect(function()
							currentVal = val
							SelectBtn.Text = "  " .. dTitle .. " : " .. currentVal
							task.spawn(dCallback, val)
							-- Smooth Close Modal
							TweenService:Create(DropdownOverlay, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
							DropdownModal:TweenSize(UDim2.new(0, 240, 0, 0), "Out", "Quad", 0.2, true, function()
								DropdownOverlay.Visible = false
							end)
						end)
					end

					ModalScroll.CanvasSize = UDim2.new(0, 0, 0, ModalScrollLayout.AbsoluteContentSize.Y + 10)

					-- Display Modal Smoothly
					DropdownOverlay.Visible = true
					DropdownOverlay.BackgroundTransparency = 1
					DropdownModal.Size = UDim2.new(0, 240, 0, 0)

					TweenService:Create(DropdownOverlay, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.4}):Play()
					DropdownModal:TweenSize(UDim2.new(0, 240, 0, 220), "Out", "Back", 0.25, true)
				end

				SelectBtn.MouseButton1Click:Connect(openModal)

				function dropdownInstance:Refresh(newValues)
					dValues = newValues
					if not table.find(dValues, currentVal) then
						currentVal = dValues[1] or "None"
						SelectBtn.Text = "  " .. dTitle .. " : " .. currentVal
					end
				end

				table.insert(groupboxObject.Elements, {Title = dTitle, Frame = DropdownFrame})
				resizeGroup()

				return dropdownInstance
			end

			-- Component 3: TOGGLE (Slide Pill Style)
			function groupboxObject:CreateToggle(toggleConfig)
				toggleConfig = toggleConfig or {}
				local tTitle = toggleConfig.Title or "Toggle"
				local tDesc = toggleConfig.Desc or ""
				local tState = toggleConfig.Value or false
				local tCallback = toggleConfig.Callback or function() end

				local ToggleFrame = Instance.new("Frame")
				ToggleFrame.Name = "ToggleFrame"
				ToggleFrame.Size = UDim2.new(1, 0, 0, 36)
				ToggleFrame.BackgroundTransparency = 1
				ToggleFrame.Parent = GroupList

				local TitleLabel = Instance.new("TextLabel")
				TitleLabel.Name = "TitleLabel"
				TitleLabel.Size = UDim2.new(0.6, 0, 0.5, 0)
				TitleLabel.Position = UDim2.new(0, 8, 0, 2)
				TitleLabel.BackgroundTransparency = 1
				TitleLabel.Text = tTitle
				TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				TitleLabel.Font = Enum.Font.GothamMedium
				TitleLabel.TextSize = 12
				TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
				TitleLabel.Parent = ToggleFrame

				local DescLabel = Instance.new("TextLabel")
				DescLabel.Name = "DescLabel"
				DescLabel.Size = UDim2.new(0.6, 0, 0.5, 0)
				DescLabel.Position = UDim2.new(0, 8, 0.5, 0)
				DescLabel.BackgroundTransparency = 1
				DescLabel.Text = tDesc
				DescLabel.TextColor3 = Color3.fromRGB(170, 170, 170)
				DescLabel.Font = Enum.Font.Gotham
				DescLabel.TextSize = 9
				DescLabel.TextXAlignment = Enum.TextXAlignment.Left
				DescLabel.Parent = ToggleFrame

				local Switch = Instance.new("TextButton")
				Switch.Name = "Switch"
				Switch.Size = UDim2.new(0, 38, 0, 18)
				Switch.Position = UDim2.new(1, -48, 0.5, -9)
				Switch.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				Switch.Text = ""
				Switch.Parent = ToggleFrame

				local SwitchCorner = Instance.new("UICorner")
				SwitchCorner.CornerRadius = UDim.new(1, 0)
				SwitchCorner.Parent = Switch

				local SwitchStroke = Instance.new("UIStroke")
				SwitchStroke.Color = Color3.fromRGB(255, 255, 255)
				SwitchStroke.Thickness = 1
				SwitchStroke.Transparency = 0.5
				SwitchStroke.Parent = Switch

				local SliderKnob = Instance.new("Frame")
				SliderKnob.Name = "SliderKnob"
				SliderKnob.Size = UDim2.new(0, 14, 0, 14)
				SliderKnob.Position = UDim2.new(0, 2, 0.5, -7)
				SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderKnob.Parent = Switch

				local KnobCorner = Instance.new("UICorner")
				KnobCorner.CornerRadius = UDim.new(1, 0)
				KnobCorner.Parent = SliderKnob

				local function updateVisuals()
					local targetPos = tState and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
					local targetColor = tState and Color3.fromRGB(220, 255, 220) or Color3.fromRGB(255, 255, 255)
					local switchColor = tState and Color3.fromRGB(50, 180, 100) or Color3.fromRGB(40, 40, 40)

					TweenService:Create(SliderKnob, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {Position = targetPos, BackgroundColor3 = targetColor}):Play()
					TweenService:Create(Switch, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {BackgroundColor3 = switchColor}):Play()
				end

				Switch.MouseButton1Click:Connect(function()
					tState = not tState
					updateVisuals()
					task.spawn(tCallback, tState)
				end)

				updateVisuals()

				table.insert(groupboxObject.Elements, {Title = tTitle, Frame = ToggleFrame})
				resizeGroup()
			end

			-- Component 4: SLIDER (Drag interactive bounds constraint)
			function groupboxObject:CreateSlider(slideConfig)
				slideConfig = slideConfig or {}
				local sTitle = slideConfig.Title or "Slider"
				local step = slideConfig.Step or 1
				local bounds = slideConfig.Value or {Min = 0, Max = 100, Default = 50}
				local currentVal = bounds.Default or bounds.Min
				local sCallback = slideConfig.Callback or function() end

				local SliderFrame = Instance.new("Frame")
				SliderFrame.Name = "SliderFrame"
				SliderFrame.Size = UDim2.new(1, 0, 0, 42)
				SliderFrame.BackgroundTransparency = 1
				SliderFrame.Parent = GroupList

				local TitleLabel = Instance.new("TextLabel")
				TitleLabel.Name = "TitleLabel"
				TitleLabel.Size = UDim2.new(0.5, 0, 0, 20)
				TitleLabel.Position = UDim2.new(0, 8, 0, 2)
				TitleLabel.BackgroundTransparency = 1
				TitleLabel.Text = sTitle
				TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				TitleLabel.Font = Enum.Font.GothamMedium
				TitleLabel.TextSize = 12
				TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
				TitleLabel.Parent = SliderFrame

				local ValueLabel = Instance.new("TextLabel")
				ValueLabel.Name = "ValueLabel"
				ValueLabel.Size = UDim2.new(0.4, 0, 0, 20)
				ValueLabel.Position = UDim2.new(1, -88, 0, 2)
				ValueLabel.BackgroundTransparency = 1
				ValueLabel.Text = tostring(currentVal)
				ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				ValueLabel.Font = Enum.Font.GothamBold
				ValueLabel.TextSize = 12
				ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
				ValueLabel.Parent = SliderFrame

				local SlideTrack = Instance.new("TextButton")
				SlideTrack.Name = "SlideTrack"
				SlideTrack.Size = UDim2.new(1, -16, 0, 6)
				SlideTrack.Position = UDim2.new(0, 8, 1, -12)
				SlideTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
				SlideTrack.BackgroundTransparency = 0.5
				SlideTrack.Text = ""
				SlideTrack.Parent = SliderFrame

				local TrackCorner = Instance.new("UICorner")
				TrackCorner.CornerRadius = UDim.new(1, 0)
				TrackCorner.Parent = SlideTrack

				local FillBar = Instance.new("Frame")
				FillBar.Name = "FillBar"
				FillBar.Size = UDim2.new(0, 0, 1, 0)
				FillBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				FillBar.Parent = SlideTrack

				local FillCorner = Instance.new("UICorner")
				FillCorner.CornerRadius = UDim.new(1, 0)
				FillCorner.Parent = FillBar

				local function updateSlider(input)
					local relativeMouseX = input.Position.X - SlideTrack.AbsolutePosition.X
					local percentage = math.clamp(relativeMouseX / SlideTrack.AbsoluteSize.X, 0, 1)
					local rawValue = bounds.Min + (bounds.Max - bounds.Min) * percentage
					local roundedValue = math.floor(rawValue / step + 0.5) * step

					currentVal = math.clamp(roundedValue, bounds.Min, bounds.Max)
					ValueLabel.Text = tostring(currentVal)

					local finalPct = (currentVal - bounds.Min) / (bounds.Max - bounds.Min)
					TweenService:Create(FillBar, TweenInfo.new(0.08, Enum.EasingStyle.Quad), {Size = UDim2.new(finalPct, 0, 1, 0)}):Play()

					task.spawn(sCallback, currentVal)
				end

				-- Initialize Slider Fill Position
				local initPct = (currentVal - bounds.Min) / (bounds.Max - bounds.Min)
				FillBar.Size = UDim2.new(initPct, 0, 1, 0)

				local isSliding = false
				SlideTrack.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						isSliding = true
						updateSlider(input)
					end
				end)

				SlideTrack.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						isSliding = false
					end
				end)

				UserInputService.InputChanged:Connect(function(input)
					if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						updateSlider(input)
					end
				end)

				table.insert(groupboxObject.Elements, {Title = sTitle, Frame = SliderFrame})
				resizeGroup()
			end

			-- Component 5: INPUT BOX
			function groupboxObject:CreateInput(inputConfig)
				inputConfig = inputConfig or {}
				local iTitle = inputConfig.Title or "Input"
				local defaultVal = inputConfig.Value or ""
				local placeholder = inputConfig.Placeholder or "Enter text..."
				local iCallback = inputConfig.Callback or function() end

				local InputFrame = Instance.new("Frame")
				InputFrame.Name = "InputFrame"
				InputFrame.Size = UDim2.new(1, 0, 0, 32)
				InputFrame.BackgroundTransparency = 1
				InputFrame.Parent = GroupList

				local TitleLabel = Instance.new("TextLabel")
				TitleLabel.Name = "TitleLabel"
				TitleLabel.Size = UDim2.new(0.4, 0, 1, 0)
				TitleLabel.Position = UDim2.new(0, 8, 0, 0)
				TitleLabel.BackgroundTransparency = 1
				TitleLabel.Text = iTitle
				TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				TitleLabel.Font = Enum.Font.GothamMedium
				TitleLabel.TextSize = 12
				TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
				TitleLabel.Parent = InputFrame

				local TextBoxFrame = Instance.new("Frame")
				TextBoxFrame.Name = "TextBoxFrame"
				TextBoxFrame.Size = UDim2.new(0.55, 0, 1, -4)
				TextBoxFrame.Position = UDim2.new(1, -210, 0.5, -14)
				TextBoxFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				TextBoxFrame.BackgroundTransparency = 0.95
				TextBoxFrame.Parent = InputFrame

				local BoxCorner = Instance.new("UICorner")
				BoxCorner.CornerRadius = UDim.new(0, 6)
				BoxCorner.Parent = TextBoxFrame

				local BoxStroke = Instance.new("UIStroke")
				BoxStroke.Color = Color3.fromRGB(255, 255, 255)
				BoxStroke.Thickness = 0.8
				BoxStroke.Transparency = 0.7
				BoxStroke.Parent = TextBoxFrame

				local ActualBox = Instance.new("TextBox")
				ActualBox.Name = "TextBox"
				ActualBox.Size = UDim2.new(1, -12, 1, 0)
				ActualBox.Position = UDim2.new(0, 6, 0, 0)
				ActualBox.BackgroundTransparency = 1
				ActualBox.Text = defaultVal
				ActualBox.PlaceholderText = placeholder
				ActualBox.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
				ActualBox.TextColor3 = Color3.fromRGB(255, 255, 255)
				ActualBox.Font = Enum.Font.Gotham
				ActualBox.TextSize = 11
				ActualBox.TextXAlignment = Enum.TextXAlignment.Left
				ActualBox.Parent = TextBoxFrame

				ActualBox.FocusLost:Connect(function(enterPressed)
					task.spawn(iCallback, ActualBox.Text)
				end)

				table.insert(groupboxObject.Elements, {Title = iTitle, Frame = InputFrame})
				resizeGroup()
			end

			return groupboxObject
		end

		return tabObject
	end

	return windowObject
end

return SKUI
