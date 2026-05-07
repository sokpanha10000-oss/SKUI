--// SKUI - Glass Hub UI Library
--// Return this table from a ModuleScript / hosted script

local SKUI = {}
SKUI.__index = SKUI

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

local function new(className, props)
	local obj = Instance.new(className)
	for k, v in pairs(props or {}) do
		obj[k] = v
	end
	return obj
end

local function corner(parent, radius)
	return new("UICorner", {
		CornerRadius = UDim.new(0, radius or 10),
		Parent = parent
	})
end

local function stroke(parent, thickness, transparency)
	return new("UIStroke", {
		Thickness = thickness or 1,
		Transparency = transparency or 0.5,
		Color = Color3.fromRGB(255, 255, 255),
		Parent = parent
	})
end

local function padding(parent, px)
	return new("UIPadding", {
		PaddingTop = UDim.new(0, px or 8),
		PaddingBottom = UDim.new(0, px or 8),
		PaddingLeft = UDim.new(0, px or 8),
		PaddingRight = UDim.new(0, px or 8),
		Parent = parent
	})
end

local function makeDraggable(frame, handle)
	handle = handle or frame
	local dragging = false
	local dragStart, startPos

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

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
end

local function fitCanvas(scroller, layout, extra)
	extra = extra or 12
	local function update()
		scroller.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + extra)
	end
	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(update)
	update()
end

local function iconButton(parent, text, imageId, size)
	local btn = new(imageId and "ImageButton" or "TextButton", {
		Parent = parent,
		BackgroundTransparency = 1,
		Size = size or UDim2.fromOffset(28, 28),
		AutoButtonColor = false,
		Font = Enum.Font.GothamBold,
		Text = imageId and "" or text or "",
		TextSize = 16,
		TextColor3 = Color3.fromRGB(255, 255, 255),
	})
	if imageId then
		new("ImageLabel", {
			Parent = btn,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Image = imageId,
			ImageTransparency = 0,
			ScaleType = Enum.ScaleType.Fit,
		})
	end
	return btn
end

function SKUI:CreateWindow(config)
	config = config or {}

	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	local self = setmetatable({}, SKUI)
	self.Name = config.Name or config.Title or "SKUI"
	self.Title = config.Title or config.Name or "SKUI"
	self.Author = config.Author or "by SKUI"
	self.Image = config.Image
	self.Visible = true
	self._searchTargets = {}
	self._tabs = {}
	self._activeTab = nil
	self._blur = nil
	self._minBtn = nil
	self._dropdownPopup = nil

	pcall(function()
		local old = Lighting:FindFirstChild("SKUI_Blur")
		if old then old:Destroy() end
		local blur = Instance.new("BlurEffect")
		blur.Name = "SKUI_Blur"
		blur.Size = 12
		blur.Parent = Lighting
		self._blur = blur
	end)

	local gui = new("ScreenGui", {
		Name = "SKUI_" .. self.Name,
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = playerGui
	})
	self.Gui = gui

	local main = new("Frame", {
		Parent = gui,
		Size = UDim2.fromOffset(760, 470),
		Position = UDim2.new(0.5, -380, 0.5, -235),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.78,
		BorderSizePixel = 0,
	})
	self.Main = main
	corner(main, 18)
	stroke(main, 1, 0.7)

	local glass = new("UIGradient", {
		Parent = main,
		Rotation = 90,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(225, 235, 255)),
		}),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.2),
			NumberSequenceKeypoint.new(1, 0.35),
		})
	})
	self._glass = glass

	local topbar = new("Frame", {
		Parent = main,
		Size = UDim2.new(1, 0, 0, 52),
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	})

	local titleIcon = iconButton(topbar, "", self.Image, UDim2.fromOffset(28, 28))
	titleIcon.Position = UDim2.fromOffset(14, 12)

	local titleLbl = new("TextLabel", {
		Parent = topbar,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(50, 5),
		Size = UDim2.new(0, 340, 0, 24),
		Font = Enum.Font.GothamBold,
		Text = self.Title,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextSize = 18
	})

	local authorLbl = new("TextLabel", {
		Parent = topbar,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(50, 25),
		Size = UDim2.new(0, 340, 0, 18),
		Font = Enum.Font.Gotham,
		Text = self.Author,
		TextColor3 = Color3.fromRGB(230, 230, 230),
		TextTransparency = 0.1,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextSize = 13
	})

	local searchBox = new("TextBox", {
		Parent = topbar,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 280, 0.5, 0),
		Size = UDim2.fromOffset(240, 32),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.72,
		BorderSizePixel = 0,
		ClearTextOnFocus = false,
		PlaceholderText = "Search tabs / elements...",
		Text = "",
		PlaceholderColor3 = Color3.fromRGB(235, 235, 235),
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.Gotham,
		TextSize = 14,
		Parent = topbar
	})
	corner(searchBox, 10)
	stroke(searchBox, 1, 0.75)

	iconButton(searchBox, "⌕", nil, UDim2.fromOffset(24, 24)).Position = UDim2.fromOffset(8, 4)
	local searchPad = new("TextLabel", {
		Parent = searchBox,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(32, 0),
		Size = UDim2.new(1, -36, 1, 0),
		Text = "",
	})

	local closeBtn = iconButton(topbar, "✕", config.CloseIcon, UDim2.fromOffset(34, 34))
	closeBtn.AnchorPoint = Vector2.new(1, 0.5)
	closeBtn.Position = UDim2.new(1, -12, 0.5, 0)
	corner(closeBtn, 10)
	closeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	closeBtn.BackgroundTransparency = 0.82

	local content = new("Frame", {
		Parent = main,
		Position = UDim2.fromOffset(14, 60),
		Size = UDim2.new(1, -28, 1, -74),
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	})

	local left = new("Frame", {
		Parent = content,
		Size = UDim2.new(0, 185, 1, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.9,
		BorderSizePixel = 0
	})
	corner(left, 14)
	stroke(left, 1, 0.8)

	local leftLabel = new("TextLabel", {
		Parent = left,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(12, 8),
		Size = UDim2.new(1, -24, 0, 18),
		Font = Enum.Font.GothamBold,
		Text = "Tabs",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	local tabScroll = new("ScrollingFrame", {
		Parent = left,
		Position = UDim2.fromOffset(10, 34),
		Size = UDim2.new(1, -20, 1, -44),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 4,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.None
	})

	local tabLayout = new("UIListLayout", {
		Parent = tabScroll,
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder
	})
	padding(tabScroll, 2)
	fitCanvas(tabScroll, tabLayout, 10)

	local right = new("Frame", {
		Parent = content,
		Position = UDim2.fromOffset(198, 0),
		Size = UDim2.new(1, -198, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	})

	local pageHolder = new("Folder", {
		Parent = right
	})

	local dropdownOverlay = new("Frame", {
		Parent = gui,
		Visible = false,
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.4,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 50
	})

	local popup = new("Frame", {
		Parent = dropdownOverlay,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(320, 360),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.2,
		BorderSizePixel = 0,
		ZIndex = 51
	})
	corner(popup, 16)
	stroke(popup, 1, 0.7)

	local popupTitle = new("TextLabel", {
		Parent = popup,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(14, 10),
		Size = UDim2.new(1, -60, 0, 22),
		Font = Enum.Font.GothamBold,
		Text = "Dropdown",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextSize = 16,
		ZIndex = 52
	})

	local popupClose = iconButton(popup, "✕", config.CloseIcon, UDim2.fromOffset(28, 28))
	popupClose.Position = UDim2.new(1, -38, 0, 10)
	popupClose.ZIndex = 52
	corner(popupClose, 8)
	popupClose.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	popupClose.BackgroundTransparency = 0.8

	local popupScroll = new("ScrollingFrame", {
		Parent = popup,
		Position = UDim2.fromOffset(12, 46),
		Size = UDim2.new(1, -24, 1, -58),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 4,
		ZIndex = 52
	})

	local popupLayout = new("UIListLayout", {
		Parent = popupScroll,
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder
	})
	padding(popupScroll, 2)
	fitCanvas(popupScroll, popupLayout, 8)

	local function closePopup()
		dropdownOverlay.Visible = false
	end

	popupClose.MouseButton1Click:Connect(closePopup)
	dropdownOverlay.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			closePopup()
		end
	end)

	local function setVisible(state)
		self.Visible = state
		main.Visible = state
		if self._minBtn then
			self._minBtn.Visible = not state
		end
	end

	local function clearSearch()
		for _, item in ipairs(self._searchTargets) do
			if item.Object and item.DefaultVisible ~= nil then
				item.Object.Visible = item.DefaultVisible
			end
		end
	end

	local function applySearch(query)
		query = string.lower((query or ""):gsub("^%s+", ""):gsub("%s+$", ""))
		if query == "" then
			clearSearch()
			return
		end

		for _, item in ipairs(self._searchTargets) do
			local text = string.lower(item.Text or "")
			local matched = text:find(query, 1, true) ~= nil
			if item.Object then
				item.Object.Visible = matched
			end
		end
	end

	searchBox:GetPropertyChangedSignal("Text"):Connect(function()
		applySearch(searchBox.Text)
	end)

	closeBtn.MouseButton1Click:Connect(function()
		if self._blur then
			self._blur:Destroy()
		end
		gui:Destroy()
	end)

	makeDraggable(main, topbar)

	function self:CreateMinimizeBtn(minConfig)
		minConfig = minConfig or {}
		if self._minBtn then
			self._minBtn:Destroy()
		end

		local btn = new(minConfig.Image and "ImageButton" or "TextButton", {
			Parent = gui,
			Size = UDim2.fromOffset(56, 56),
			Position = UDim2.new(0, 24, 0.5, -28),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 0.72,
			BorderSizePixel = 0,
			AutoButtonColor = true,
			Text = minConfig.Image and "" or "≡",
			Font = Enum.Font.GothamBold,
			TextSize = 22,
			TextColor3 = Color3.fromRGB(255, 255, 255)
		})
		corner(btn, 18)
		stroke(btn, 1, 0.74)

		if minConfig.Image then
			new("ImageLabel", {
				Parent = btn,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				Image = minConfig.Image,
				ScaleType = Enum.ScaleType.Fit
			})
		end

		local label = new("TextLabel", {
			Parent = btn,
			BackgroundTransparency = 1,
			Position = UDim2.new(1, 10, 0, 0),
			Size = UDim2.new(0, 120, 1, 0),
			Font = Enum.Font.GothamBold,
			Text = minConfig.Title or "Open UI",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextSize = 14
		})

		makeDraggable(btn, btn)

		btn.MouseButton1Click:Connect(function()
			setVisible(not self.Visible)
		end)

		self._minBtn = btn
		self.MinimizeBtn = btn
		return btn
	end

	local function newTabButton(tabName, pageFrame)
		local btn = new("TextButton", {
			Parent = tabScroll,
			Size = UDim2.new(1, 0, 0, 40),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 0.8,
			BorderSizePixel = 0,
			Text = tabName,
			Font = Enum.Font.GothamSemibold,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 14,
			AutoButtonColor = true
		})
		corner(btn, 10)
		stroke(btn, 1, 0.85)

		table.insert(self._searchTargets, {
			Object = btn,
			Text = tabName,
			DefaultVisible = true
		})

		btn.MouseButton1Click:Connect(function()
			for _, tab in ipairs(self._tabs) do
				tab.Page.Visible = false
				tab.Button.BackgroundTransparency = 0.8
			end
			pageFrame.Visible = true
			btn.BackgroundTransparency = 0.62
			self._activeTab = pageFrame
		end)

		return btn
	end

	function self:CreateTab(tabName)
		local tab = {}
		tab.Name = tabName

		local page = new("ScrollingFrame", {
			Parent = pageHolder,
			Visible = false,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 4,
			CanvasSize = UDim2.new()
		})

		local list = new("UIListLayout", {
			Parent = page,
			Padding = UDim.new(0, 12),
			SortOrder = Enum.SortOrder.LayoutOrder
		})
		padding(page, 2)
		fitCanvas(page, list, 10)

		local btn = newTabButton(tabName, page)

		tab.Page = page
		tab.Button = btn
		tab._items = {}

		function tab:CreateGroupbox(title)
			local box = {}
			box.Title = title

			local frame = new("Frame", {
				Parent = page,
				Size = UDim2.new(1, -6, 0, 180),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 0.88,
				BorderSizePixel = 0
			})
			corner(frame, 14)
			stroke(frame, 1, 0.86)

			local boxTitle = new("TextLabel", {
				Parent = frame,
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(12, 8),
				Size = UDim2.new(1, -24, 0, 20),
				Text = title,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = Enum.Font.GothamBold,
				TextSize = 15
			})

			local contentFrame = new("ScrollingFrame", {
				Parent = frame,
				Position = UDim2.fromOffset(10, 32),
				Size = UDim2.new(1, -20, 1, -42),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ScrollBarThickness = 4,
				CanvasSize = UDim2.new()
			})

			local inner = new("UIListLayout", {
				Parent = contentFrame,
				Padding = UDim.new(0, 8),
				SortOrder = Enum.SortOrder.LayoutOrder
			})
			padding(contentFrame, 2)
			fitCanvas(contentFrame, inner, 8)

			table.insert(self._searchTargets, {
				Object = frame,
				Text = title,
				DefaultVisible = true
			})

			local function rowBase(height)
				local row = new("Frame", {
					Parent = contentFrame,
					Size = UDim2.new(1, 0, 0, height),
					BackgroundTransparency = 1,
					BorderSizePixel = 0
				})
				return row
			end

			function box:CreateButton(info)
				info = info or {}
				local row = rowBase(38)
				local btn = new("TextButton", {
					Parent = row,
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 0.82,
					BorderSizePixel = 0,
					Text = info.Title or "Button",
					Font = Enum.Font.GothamSemibold,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 14,
					AutoButtonColor = true
				})
				corner(btn, 10)
				stroke(btn, 1, 0.88)

				if info.Locked then
					btn.AutoButtonColor = false
					btn.TextTransparency = 0.35
				end

				btn.MouseButton1Click:Connect(function()
					if not info.Locked and info.Callback then
						task.spawn(info.Callback)
					end
				end)

				table.insert(self._searchTargets, {
					Object = row,
					Text = info.Title or "Button",
					DefaultVisible = true
				})

				return btn
			end

			function box:CreateToggle(info)
				info = info or {}
				local row = rowBase(42)
				local holder = new("Frame", {
					Parent = row,
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 0.86,
					BorderSizePixel = 0
				})
				corner(holder, 10)
				stroke(holder, 1, 0.9)

				local txt = new("TextLabel", {
					Parent = holder,
					BackgroundTransparency = 1,
					Position = UDim2.fromOffset(12, 4),
					Size = UDim2.new(1, -70, 1, 0),
					Text = info.Title or "Toggle",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					Font = Enum.Font.GothamSemibold,
					TextSize = 14,
					TextXAlignment = Enum.TextXAlignment.Left
				})

				if info.Desc then
					txt.Size = UDim2.new(1, -70, 0, 20)
					local desc = new("TextLabel", {
						Parent = holder,
						BackgroundTransparency = 1,
						Position = UDim2.fromOffset(12, 20),
						Size = UDim2.new(1, -70, 0, 16),
						Text = info.Desc,
						TextColor3 = Color3.fromRGB(235, 235, 235),
						TextTransparency = 0.12,
						Font = Enum.Font.Gotham,
						TextSize = 12,
						TextXAlignment = Enum.TextXAlignment.Left
					})
				end

				local knob = new("TextButton", {
					Parent = holder,
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -12, 0.5, 0),
					Size = UDim2.fromOffset(48, 24),
					Text = "",
					BackgroundColor3 = info.Value and Color3.fromRGB(120, 255, 170) or Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 0.72,
					BorderSizePixel = 0
				})
				corner(knob, 999)
				stroke(knob, 1, 0.9)

				local dot = new("Frame", {
					Parent = knob,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = info.Value and UDim2.new(1, -12, 0.5, 0) or UDim2.new(0, 12, 0.5, 0),
					Size = UDim2.fromOffset(16, 16),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderSizePixel = 0
				})
				corner(dot, 999)

				local state = info.Value and true or false
				local function setState(v)
					state = v
					TweenService:Create(knob, TweenInfo.new(0.18), {
						BackgroundColor3 = v and Color3.fromRGB(120, 255, 170) or Color3.fromRGB(255, 255, 255)
					}):Play()
					TweenService:Create(dot, TweenInfo.new(0.18), {
						Position = v and UDim2.new(1, -12, 0.5, 0) or UDim2.new(0, 12, 0.5, 0)
					}):Play()
					if info.Callback then
						task.spawn(info.Callback, state)
					end
				end

				holder.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						setState(not state)
					end
				end)

				knob.MouseButton1Click:Connect(function()
					setState(not state)
				end)

				table.insert(self._searchTargets, {
					Object = row,
					Text = info.Title or "Toggle",
					DefaultVisible = true
				})

				return {
					Set = setState,
					Get = function() return state end
				}
			end

			function box:CreateSlider(info)
				info = info or {}
				local row = rowBase(56)

				local holder = new("Frame", {
					Parent = row,
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 0.86,
					BorderSizePixel = 0
				})
				corner(holder, 10)
				stroke(holder, 1, 0.9)

				local title = new("TextLabel", {
					Parent = holder,
					BackgroundTransparency = 1,
					Position = UDim2.fromOffset(12, 4),
					Size = UDim2.new(1, -24, 0, 18),
					Text = info.Title or "Slider",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					Font = Enum.Font.GothamSemibold,
					TextSize = 14,
					TextXAlignment = Enum.TextXAlignment.Left
				})

				local valueLabel = new("TextLabel", {
					Parent = holder,
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.new(1, -12, 0, 4),
					Size = UDim2.new(0, 60, 0, 18),
					Text = "",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					Font = Enum.Font.Gotham,
					TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Right
				})

				local bar = new("Frame", {
					Parent = holder,
					Position = UDim2.fromOffset(12, 31),
					Size = UDim2.new(1, -24, 0, 10),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 0.9,
					BorderSizePixel = 0
				})
				corner(bar, 999)
				stroke(bar, 1, 0.92)

				local fill = new("Frame", {
					Parent = bar,
					Size = UDim2.new(0, 0, 1, 0),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 0.42,
					BorderSizePixel = 0
				})
				corner(fill, 999)

				local minV = info.Value and info.Value.Min or 0
				local maxV = info.Value and info.Value.Max or 100
				local defaultV = info.Value and info.Value.Default or minV
				local step = info.Step or 1
				local value = defaultV

				local function setValue(v)
					v = math.clamp(v, minV, maxV)
					v = math.floor((v / step) + 0.5) * step
					value = v
					local alpha = (value - minV) / math.max((maxV - minV), 1)
					fill.Size = UDim2.new(alpha, 0, 1, 0)
					valueLabel.Text = tostring(value)
					if info.Callback then
						task.spawn(info.Callback, value)
					end
				end

				local dragging = false
				local function updateFromX(x)
					local alpha = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
					local v = minV + (maxV - minV) * alpha
					setValue(v)
				end

				bar.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = true
						updateFromX(input.Position.X)
					end
				end)

				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = false
					end
				end)

				UserInputService.InputChanged:Connect(function(input)
					if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
						updateFromX(input.Position.X)
					end
				end)

				setValue(defaultV)

				table.insert(self._searchTargets, {
					Object = row,
					Text = info.Title or "Slider",
					DefaultVisible = true
				})

				return {
					Set = setValue,
					Get = function() return value end
				}
			end

			function box:CreateInput(info)
				info = info or {}
				local row = rowBase(50)

				local holder = new("Frame", {
					Parent = row,
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 0.86,
					BorderSizePixel = 0
				})
				corner(holder, 10)
				stroke(holder, 1, 0.9)

				local title = new("TextLabel", {
					Parent = holder,
					BackgroundTransparency = 1,
					Position = UDim2.fromOffset(12, 3),
					Size = UDim2.new(1, -24, 0, 18),
					Text = info.Title or "Input",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					Font = Enum.Font.GothamSemibold,
					TextSize = 14,
					TextXAlignment = Enum.TextXAlignment.Left
				})

				local boxInput = new("TextBox", {
					Parent = holder,
					Position = UDim2.fromOffset(10, 24),
					Size = UDim2.new(1, -20, 0, 20),
					BackgroundTransparency = 1,
					Text = info.Value or "",
					PlaceholderText = info.Placeholder or "Enter text...",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					PlaceholderColor3 = Color3.fromRGB(235, 235, 235),
					Font = Enum.Font.Gotham,
					TextSize = 13,
					ClearTextOnFocus = false
				})

				boxInput.FocusLost:Connect(function()
					if info.Callback then
						task.spawn(info.Callback, boxInput.Text)
					end
				end)

				table.insert(self._searchTargets, {
					Object = row,
					Text = info.Title or "Input",
					DefaultVisible = true
				})

				return boxInput
			end

			function box:CreateDropdown(info)
				info = info or {}
				local row = rowBase(42)

				local holder = new("TextButton", {
					Parent = row,
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 0.86,
					BorderSizePixel = 0,
					Text = "",
					AutoButtonColor = true
				})
				corner(holder, 10)
				stroke(holder, 1, 0.9)

				local title = new("TextLabel", {
					Parent = holder,
					BackgroundTransparency = 1,
					Position = UDim2.fromOffset(12, 0),
					Size = UDim2.new(1, -44, 1, 0),
					Text = info.Title or "Dropdown",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					Font = Enum.Font.GothamSemibold,
					TextSize = 14,
					TextXAlignment = Enum.TextXAlignment.Left
				})

				local selectedText = new("TextLabel", {
					Parent = holder,
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -30, 0.5, 0),
					Size = UDim2.new(0, 140, 0, 18),
					Text = tostring(info.Value or ""),
					TextColor3 = Color3.fromRGB(235, 235, 235),
					Font = Enum.Font.Gotham,
					TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Right
				})

				iconButton(holder, "⌄", nil, UDim2.fromOffset(18, 18)).Position = UDim2.new(1, -14, 0.5, -9)

				local dd = {}
				dd._values = info.Values or {}
				dd._value = info.Value or dd._values[1]

				local function refresh(values)
					dd._values = values or {}
					if not table.find(dd._values, dd._value) then
						dd._value = dd._values[1]
					end
					selectedText.Text = tostring(dd._value or "")
				end

				local function openPopup()
					dropdownOverlay.Visible = true
					popupTitle.Text = info.Title or "Dropdown"
					for _, child in ipairs(popupScroll:GetChildren()) do
						if child:IsA("GuiObject") then
							child:Destroy()
						end
					end

					for _, option in ipairs(dd._values) do
						local opt = new("TextButton", {
							Parent = popupScroll,
							Size = UDim2.new(1, 0, 0, 34),
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BackgroundTransparency = 0.82,
							BorderSizePixel = 0,
							Text = tostring(option),
							Font = Enum.Font.GothamSemibold,
							TextColor3 = Color3.fromRGB(255, 255, 255),
							TextSize = 14,
							ZIndex = 52
						})
						corner(opt, 10)
						stroke(opt, 1, 0.9)

						opt.MouseButton1Click:Connect(function()
							dd._value = option
							selectedText.Text = tostring(option)
							closePopup()
							if info.Callback then
								task.spawn(info.Callback, option)
							end
						end)
					end
				end

				holder.MouseButton1Click:Connect(openPopup)

				table.insert(self._searchTargets, {
					Object = row,
					Text = info.Title or "Dropdown",
					DefaultVisible = true
				})

				function dd:Refresh(values)
					refresh(values)
				end

				dd.Set = function(_, v)
					dd._value = v
					selectedText.Text = tostring(v)
				end

				dd.Get = function()
					return dd._value
				end

				return dd
			end

			table.insert(self._tabs, tab)

			if #self._tabs == 1 then
				page.Visible = true
				btn.BackgroundTransparency = 0.62
				self._activeTab = page
			end

			return tab
		end

		return tab
	end

	function self:CreateUI(...)
		return self:CreateWindow(...)
	end

	return self
end

SKUI.CreateUI = SKUI.CreateWindow

return SKUI
