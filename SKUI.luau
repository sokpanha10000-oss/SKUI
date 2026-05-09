--// Premium Glass UI Library
--// Full merged single-file version

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Library = {}
Library.__index = Library
Library._lastWindow = nil

local Themes = {
	["Blood Red"] = {
		Accent = Color3.fromRGB(180, 10, 20),
		Accent2 = Color3.fromRGB(255, 80, 90),
		Background = Color3.fromRGB(12, 12, 14),
		Top = Color3.fromRGB(10, 10, 12),
		Panel = Color3.fromRGB(18, 18, 22),
		Element = Color3.fromRGB(25, 25, 30),
		Element2 = Color3.fromRGB(30, 30, 36),
		Text = Color3.fromRGB(255, 255, 255),
		SubText = Color3.fromRGB(190, 190, 190),
		Border = Color3.fromRGB(255, 255, 255),
	},
	Dark = {
		Accent = Color3.fromRGB(120, 120, 255),
		Accent2 = Color3.fromRGB(160, 160, 255),
		Background = Color3.fromRGB(12, 12, 14),
		Top = Color3.fromRGB(10, 10, 12),
		Panel = Color3.fromRGB(18, 18, 22),
		Element = Color3.fromRGB(25, 25, 30),
		Element2 = Color3.fromRGB(30, 30, 36),
		Text = Color3.fromRGB(255, 255, 255),
		SubText = Color3.fromRGB(190, 190, 190),
		Border = Color3.fromRGB(255, 255, 255),
	},
}

local function themeOf(name)
	return Themes[name] or Themes["Blood Red"]
end

local function create(className, props)
	local obj = Instance.new(className)
	for k, v in pairs(props or {}) do
		obj[k] = v
	end
	return obj
end

local function round(parent, radius)
	return create("UICorner", {
		CornerRadius = UDim.new(0, radius or 12),
		Parent = parent,
	})
end

local function stroke(parent, color, thickness, transparency)
	return create("UIStroke", {
		Color = color or Color3.new(1, 1, 1),
		Thickness = thickness or 1,
		Transparency = transparency or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = parent,
	})
end

local function padding(parent, top, bottom, left, right)
	return create("UIPadding", {
		PaddingTop = UDim.new(0, top or 0),
		PaddingBottom = UDim.new(0, bottom or 0),
		PaddingLeft = UDim.new(0, left or 0),
		PaddingRight = UDim.new(0, right or 0),
		Parent = parent,
	})
end

local function list(parent, pad)
	return create("UIListLayout", {
		Parent = parent,
		Padding = UDim.new(0, pad or 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})
end

local function tween(obj, ti, props)
	TweenService:Create(obj, ti or TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function clamp(n, a, b)
	return math.max(a, math.min(b, n))
end

local function makeDraggable(frame, handle)
	frame.Active = true
	handle.Active = true

	local dragging = false
	local dragStart
	local startPos

	local function update(input)
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
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
		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then
			if dragging then
				update(input)
			end
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			update(input)
		end
	end)
end

local WindowClass = {}
WindowClass.__index = WindowClass

function Library:CreateUI(opts)
	return self:CreateWindow(opts)
end

function Library:CreateWindow(opts)
	opts = opts or {}

	local selfWindow = setmetatable({}, WindowClass)
	selfWindow.Title = opts.Title or "UI"
	selfWindow.SubTitle = opts.SubTitle or ""
	selfWindow.TabWidth = opts.TabWidth or 160
	selfWindow.Size = opts.Size or UDim2.fromOffset(480, 460)
	selfWindow.Acrylic = opts.Acrylic ~= false
	selfWindow.ThemeName = opts.Theme or "Blood Red"
	selfWindow.Theme = themeOf(selfWindow.ThemeName)
	selfWindow.MinimizeKey = opts.MinimizeKey or Enum.KeyCode.LeftControl
	selfWindow.UserInfoTop = opts.UserInfoTop ~= false
	selfWindow.UserInfoTitle = opts.UserInfoTitle or LocalPlayer.DisplayName
	selfWindow.UserInfoSubtitle = opts.UserInfoSubtitle or "User"
	selfWindow.UserInfoColor = opts.UserInfoColor or selfWindow.Theme.Accent
	selfWindow.Search = opts.Search ~= false
	selfWindow._tabs = {}
	selfWindow._currentTab = nil
	selfWindow._destroyed = false
	selfWindow._blur = nil
	selfWindow._minimizeBtn = nil

	local function enableBlur()
		if not selfWindow.Acrylic then
			return
		end
		if selfWindow._blur and selfWindow._blur.Parent then
			selfWindow._blur.Enabled = true
			selfWindow._blur.Size = 12
			return
		end
		local blur = create("BlurEffect", {
			Name = "UILibraryBlur",
			Size = 12,
			Parent = Lighting,
		})
		selfWindow._blur = blur
	end

	local function disableBlur()
		if selfWindow._blur and selfWindow._blur.Parent then
			selfWindow._blur:Destroy()
		end
		selfWindow._blur = nil
	end

	local gui = create("ScreenGui", {
		Name = "CustomUILibrary",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		IgnoreGuiInset = true,
		Parent = PlayerGui,
	})
	selfWindow.Gui = gui

	enableBlur()

	local main = create("Frame", {
		Name = "Main",
		Parent = gui,
		BackgroundColor3 = selfWindow.Theme.Background,
		BackgroundTransparency = 0.28,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Size = selfWindow.Size,
		Position = UDim2.new(0.5, -selfWindow.Size.X.Offset / 2, 0.5, -selfWindow.Size.Y.Offset / 2),
	})
	selfWindow.Main = main
	round(main, 18)
	stroke(main, Color3.fromRGB(255, 255, 255), 1, 0.72)

	create("ImageLabel", {
		Name = "Shadow",
		Parent = main,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 34, 1, 34),
		Position = UDim2.new(0, -17, 0, -17),
		Image = "rbxassetid://1316045217",
		ImageTransparency = 0.58,
		ImageColor3 = Color3.new(0, 0, 0),
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(10, 10, 118, 118),
		ZIndex = 0,
	})

	local top = create("Frame", {
		Name = "TopBar",
		Parent = main,
		BackgroundColor3 = selfWindow.Theme.Top,
		BackgroundTransparency = 0.22,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 66),
	})
	selfWindow.TopBar = top
	round(top, 18)
	stroke(top, Color3.fromRGB(255, 255, 255), 1, 0.82)

	create("Frame", {
		Parent = top,
		BackgroundColor3 = selfWindow.Theme.Top,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 18),
		Position = UDim2.new(0, 0, 1, -18),
		ZIndex = 0,
	})

	create("TextLabel", {
		Parent = top,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 16, 0, 10),
		Size = UDim2.new(1, -180, 0, 24),
		Font = Enum.Font.GothamBold,
		Text = selfWindow.Title,
		TextColor3 = selfWindow.Theme.Text,
		TextSize = 18,
		TextXAlignment = Enum.TextXAlignment.Left,
	})

	create("TextLabel", {
		Parent = top,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 16, 0, 34),
		Size = UDim2.new(1, -180, 0, 18),
		Font = Enum.Font.Gotham,
		Text = selfWindow.SubTitle,
		TextColor3 = selfWindow.Theme.SubText,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
	})

	local closeBtn = create("TextButton", {
		Parent = top,
		BackgroundColor3 = Color3.fromRGB(40, 18, 18),
		BackgroundTransparency = 0.12,
		BorderSizePixel = 0,
		Text = tostring(opts.CloseIcon or "✕"),
		TextColor3 = Color3.fromRGB(255, 245, 245),
		Font = Enum.Font.GothamBold,
		TextSize = 16,
		Size = UDim2.fromOffset(34, 34),
		Position = UDim2.new(1, -42, 0, 16),
		AutoButtonColor = false,
	})
	round(closeBtn, 10)
	stroke(closeBtn, Color3.fromRGB(255, 255, 255), 1, 0.72)

	local content = create("Frame", {
		Name = "Content",
		Parent = main,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, 66),
		Size = UDim2.new(1, 0, 1, -66),
	})
	selfWindow.Content = content

	local left = create("Frame", {
		Name = "TabsPanel",
		Parent = content,
		BackgroundColor3 = selfWindow.Theme.Panel,
		BackgroundTransparency = 0.18,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 12, 0, 12),
		Size = UDim2.new(0, selfWindow.TabWidth, 1, -24),
	})
	selfWindow.LeftPanel = left
	round(left, 16)
	stroke(left, Color3.fromRGB(255, 255, 255), 1, 0.88)

	local right = create("Frame", {
		Name = "PagePanel",
		Parent = content,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, selfWindow.TabWidth + 24, 0, 12),
		Size = UDim2.new(1, -(selfWindow.TabWidth + 36), 1, -24),
	})
	selfWindow.RightPanel = right

	local rightScroll = create("ScrollingFrame", {
		Name = "RightScroll",
		Parent = right,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		CanvasSize = UDim2.fromOffset(0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = selfWindow.Theme.Accent,
		Visible = true,
	})
	selfWindow.RightScroll = rightScroll
	padding(rightScroll, 4, 8, 4, 4)
	list(rightScroll, 10)

	local tabsHeader = create("Frame", {
		Parent = left,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, selfWindow.UserInfoTop and 118 or 70),
	})
	padding(tabsHeader, 10, 8, 10, 10)

	local userInfo = create("Frame", {
		Parent = tabsHeader,
		BackgroundColor3 = selfWindow.UserInfoColor,
		BackgroundTransparency = 0.84,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 60),
		Visible = selfWindow.UserInfoTop,
	})
	round(userInfo, 14)
	stroke(userInfo, Color3.fromRGB(255, 255, 255), 1, 0.9)

	local avatar = create("ImageLabel", {
		Parent = userInfo,
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(38, 38),
		Position = UDim2.new(0, 10, 0, 11),
		Image = "",
		ScaleType = Enum.ScaleType.Crop,
	})
	round(avatar, 19)

	task.spawn(function()
		local ok, contentId = pcall(function()
			return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
		end)
		if ok and avatar and avatar.Parent then
			avatar.Image = contentId
		end
	end)

	create("TextLabel", {
		Parent = userInfo,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 56, 0, 8),
		Size = UDim2.new(1, -66, 0, 20),
		Font = Enum.Font.GothamBold,
		Text = selfWindow.UserInfoTitle,
		TextColor3 = Color3.new(1, 1, 1),
		TextSize = 15,
		TextXAlignment = Enum.TextXAlignment.Left,
	})

	create("TextLabel", {
		Parent = userInfo,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 56, 0, 29),
		Size = UDim2.new(1, -66, 0, 16),
		Font = Enum.Font.Gotham,
		Text = selfWindow.UserInfoSubtitle,
		TextColor3 = Color3.fromRGB(235, 235, 235),
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
	})

	local searchBox
	if selfWindow.Search then
		local searchFrame = create("Frame", {
			Parent = tabsHeader,
			BackgroundColor3 = selfWindow.Theme.Element,
			BackgroundTransparency = 0.18,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 0, 0, selfWindow.UserInfoTop and 72 or 8),
			Size = UDim2.new(1, 0, 0, 32),
		})
		round(searchFrame, 10)
		stroke(searchFrame, Color3.fromRGB(255, 255, 255), 1, 0.9)

		create("TextLabel", {
			Parent = searchFrame,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 10, 0, 0),
			Size = UDim2.fromOffset(16, 32),
			Font = Enum.Font.GothamBold,
			Text = "⌕",
			TextColor3 = selfWindow.Theme.SubText,
			TextSize = 15,
			TextXAlignment = Enum.TextXAlignment.Center,
		})

		searchBox = create("TextBox", {
			Parent = searchFrame,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 28, 0, 0),
			Size = UDim2.new(1, -34, 1, 0),
			ClearTextOnFocus = false,
			Font = Enum.Font.Gotham,
			PlaceholderText = "Search tabs...",
			Text = "",
			TextColor3 = selfWindow.Theme.Text,
			PlaceholderColor3 = selfWindow.Theme.SubText,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
		})
	end
	selfWindow.SearchBox = searchBox

	local tabsList = create("ScrollingFrame", {
		Parent = left,
		Name = "TabsList",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, selfWindow.UserInfoTop and 112 or 52),
		Size = UDim2.new(1, 0, 1, -(selfWindow.UserInfoTop and 122 or 62)),
		CanvasSize = UDim2.fromOffset(0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = selfWindow.Theme.Accent,
	})
	selfWindow.TabsList = tabsList
	padding(tabsList, 6, 8, 6, 6)
	list(tabsList, 8)

	local function applyTabFilter(text)
		local lower = string.lower(text or "")
		for _, tabData in ipairs(selfWindow._tabs) do
			local visible = lower == "" or string.find(string.lower(tabData.Title), lower, 1, true) ~= nil
			tabData.Button.Visible = visible
		end
	end

	if searchBox then
		searchBox:GetPropertyChangedSignal("Text"):Connect(function()
			applyTabFilter(searchBox.Text)
		end)
	end

	local function selectTab(tabData)
		selfWindow._currentTab = tabData
		for _, t in ipairs(selfWindow._tabs) do
			t.Page.Visible = false
			t.Button.BackgroundTransparency = 0.86
			t.Button.TextColor3 = selfWindow.Theme.Text
			if t.ActiveBar then
				t.ActiveBar.BackgroundTransparency = 1
			end
		end
		tabData.Page.Visible = true
		tabData.Button.BackgroundTransparency = 0.72
		tabData.Button.TextColor3 = Color3.new(1, 1, 1)
		if tabData.ActiveBar then
			tabData.ActiveBar.BackgroundTransparency = 0
		end
	end

	function selfWindow:Notify(notify)
		notify = notify or {}
		if not selfWindow.Gui then
			return
		end

		local holder = create("Frame", {
			Parent = selfWindow.Gui,
			BackgroundColor3 = Color3.fromRGB(20, 20, 24),
			BackgroundTransparency = 0.05,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, 280, 0, 18),
			Size = UDim2.fromOffset(270, 66),
		})
		round(holder, 14)
		stroke(holder, selfWindow.Theme.Accent, 1, 0.55)

		create("TextLabel", {
			Parent = holder,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 14, 0, 10),
			Size = UDim2.new(1, -28, 0, 18),
			Font = Enum.Font.GothamBold,
			Text = notify.Title or "Notify",
			TextColor3 = selfWindow.Theme.Text,
			TextSize = 15,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		create("TextLabel", {
			Parent = holder,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 14, 0, 28),
			Size = UDim2.new(1, -28, 0, 24),
			Font = Enum.Font.Gotham,
			Text = notify.Content or "",
			TextColor3 = selfWindow.Theme.SubText,
			TextSize = 13,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
		})

		tween(holder, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.new(1, -18, 0, 18),
		})

		task.delay(tonumber(notify.Duration) or 4, function()
			if holder and holder.Parent then
				tween(holder, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
					Position = UDim2.new(1, 280, 0, 18),
				})
				task.wait(0.22)
				if holder then
					holder:Destroy()
				end
			end
		end)
	end

	local function openDropdown(dropdown, values, multi, defaultValue, noSearch)
		local overlay = create("Frame", {
			Parent = gui,
			Name = "DropdownOverlay",
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.55,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 50,
		})

		local popW = math.clamp(math.floor(selfWindow.Size.X.Offset * 0.46), 290, 360)
		local popH = math.clamp(math.floor(selfWindow.Size.Y.Offset * 0.62), 280, 380)

		local popup = create("Frame", {
			Parent = overlay,
			BackgroundColor3 = selfWindow.Theme.Element,
			BackgroundTransparency = 0.08,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(popW, popH),
			ZIndex = 51,
		})
		round(popup, 16)
		stroke(popup, Color3.fromRGB(255, 255, 255), 1, 0.86)

		local function closePopup()
			if overlay and overlay.Parent then
				overlay:Destroy()
			end
		end

		create("TextLabel", {
			Parent = popup,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 14, 0, 10),
			Size = UDim2.new(1, -28, 0, 20),
			Font = Enum.Font.GothamBold,
			Text = (dropdown.Icon and tostring(dropdown.Icon) .. "  " or "") .. (dropdown.Title or "Dropdown"),
			TextColor3 = selfWindow.Theme.Text,
			TextSize = 16,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 52,
		})

		local close = create("TextButton", {
			Parent = popup,
			BackgroundColor3 = Color3.fromRGB(40, 18, 18),
			BackgroundTransparency = 0.12,
			BorderSizePixel = 0,
			Text = "✕",
			TextColor3 = Color3.fromRGB(255, 245, 245),
			Font = Enum.Font.GothamBold,
			TextSize = 14,
			Size = UDim2.fromOffset(28, 28),
			Position = UDim2.new(1, -38, 0, 10),
			AutoButtonColor = false,
			ZIndex = 52,
		})
		round(close, 10)
		stroke(close, Color3.fromRGB(255, 255, 255), 1, 0.75)
		close.Activated:Connect(closePopup)

		local search
		local listTop = 50

		if not noSearch then
			local searchFrame = create("Frame", {
				Parent = popup,
				BackgroundColor3 = Color3.fromRGB(25, 25, 30),
				BackgroundTransparency = 0.16,
				BorderSizePixel = 0,
				Position = UDim2.new(0, 14, 0, 38),
				Size = UDim2.new(1, -28, 0, 30),
				ZIndex = 52,
			})
			round(searchFrame, 10)
			stroke(searchFrame, Color3.fromRGB(255, 255, 255), 1, 0.92)

			create("TextLabel", {
				Parent = searchFrame,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0, 0),
				Size = UDim2.fromOffset(16, 30),
				Font = Enum.Font.GothamBold,
				Text = "⌕",
				TextColor3 = selfWindow.Theme.SubText,
				TextSize = 15,
				TextXAlignment = Enum.TextXAlignment.Center,
				ZIndex = 53,
			})

			search = create("TextBox", {
				Parent = searchFrame,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.new(0, 28, 0, 0),
				Size = UDim2.new(1, -34, 1, 0),
				ClearTextOnFocus = false,
				Font = Enum.Font.Gotham,
				PlaceholderText = "Search...",
				Text = "",
				TextColor3 = selfWindow.Theme.Text,
				PlaceholderColor3 = selfWindow.Theme.SubText,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 53,
			})
			listTop = 76
		end

		local scroll = create("ScrollingFrame", {
			Parent = popup,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 14, 0, listTop),
			Size = UDim2.new(1, -28, 1, -(listTop + 14)),
			CanvasSize = UDim2.fromOffset(0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = selfWindow.Theme.Accent,
			ZIndex = 52,
		})
		padding(scroll, 2, 2, 2, 2)
		list(scroll, 8)

		local optionButtons = {}
		local selection = {}

		if multi then
			if typeof(defaultValue) == "table" then
				for _, v in ipairs(defaultValue) do
					selection[tostring(v)] = true
				end
			elseif defaultValue ~= nil then
				selection[tostring(defaultValue)] = true
			end
		end

		local function getCurrent()
			if multi then
				local result = {}
				for _, v in ipairs(values) do
					if selection[tostring(v)] then
						table.insert(result, v)
					end
				end
				return result
			end
			return dropdown._selected or defaultValue
		end

		local function syncButton()
			if multi then
				local arr = getCurrent()
				if #arr == 0 then
					dropdown.Button.Text = (dropdown.Title or "Dropdown") .. " : None"
				else
					dropdown.Button.Text = (dropdown.Title or "Dropdown") .. " : " .. table.concat(arr, ", ")
				end
			else
				dropdown.Button.Text = (dropdown.Title or "Dropdown") .. " : " .. tostring(dropdown._selected or defaultValue or "Select")
			end
		end

		local function refreshVisible(filterText)
			local lower = string.lower(filterText or "")
			for _, item in ipairs(optionButtons) do
				item.Visible = lower == "" or string.find(string.lower(item.ValueText), lower, 1, true) ~= nil
			end
		end

		for _, value in ipairs(values) do
			local vText = tostring(value)

			local itemBtn = create("TextButton", {
				Parent = scroll,
				BackgroundColor3 = selfWindow.Theme.Element2,
				BackgroundTransparency = 0.08,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 34),
				Font = Enum.Font.Gotham,
				Text = "",
				AutoButtonColor = false,
				ZIndex = 53,
			})
			round(itemBtn, 10)
			stroke(itemBtn, Color3.fromRGB(255, 255, 255), 1, 0.94)

			local itemText = create("TextLabel", {
				Parent = itemBtn,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0, 0),
				Size = UDim2.new(1, -20, 1, 0),
				Font = Enum.Font.Gotham,
				Text = data and data.Multi and ((selection[vText] and "✓  " or "○  ") .. vText) or vText,
				TextColor3 = selfWindow.Theme.Text,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 54,
			})

			itemBtn.Activated:Connect(function()
				if multi then
					selection[vText] = not selection[vText]
					itemText.Text = (selection[vText] and "✓  " or "○  ") .. vText
					dropdown._selected = selection
					syncButton()
					if dropdown.Callback then
						local result = {}
						for _, vv in ipairs(values) do
							if selection[tostring(vv)] then
								table.insert(result, vv)
							end
						end
						dropdown.Callback(result)
					end
				else
					dropdown._selected = value
					syncButton()
					if dropdown.Callback then
						dropdown.Callback(value)
					end
					closePopup()
				end
			end)

			itemBtn.ValueText = vText
			table.insert(optionButtons, itemBtn)
		end

		if search then
			refreshVisible(search.Text)
			search:GetPropertyChangedSignal("Text"):Connect(function()
				refreshVisible(search.Text)
			end)
		end

		overlay.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				local mouse = UserInputService:GetMouseLocation()
				local p = popup.AbsolutePosition
				local s = popup.AbsoluteSize
				if mouse.X < p.X or mouse.X > p.X + s.X or mouse.Y < p.Y or mouse.Y > p.Y + s.Y then
					closePopup()
				end
			end
		end)
	end

	function selfWindow:AddTab(tabOpts)
		tabOpts = tabOpts or {}
		local tabTitle = tabOpts.Title or "Tab"
		local tabIcon = tabOpts.Icon or "◆"

		local tabBtn = create("TextButton", {
			Parent = tabsList,
			BackgroundColor3 = selfWindow.Theme.Element,
			BackgroundTransparency = 0.14,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 40),
			AutoButtonColor = false,
			Text = "",
		})
		round(tabBtn, 11)
		stroke(tabBtn, Color3.fromRGB(255, 255, 255), 1, 0.93)

		local activeBar = create("Frame", {
			Parent = tabBtn,
			BackgroundColor3 = selfWindow.Theme.Accent,
			BorderSizePixel = 0,
			Size = UDim2.new(0, 4, 1, -12),
			Position = UDim2.new(0, 8, 0, 6),
			BackgroundTransparency = 1,
		})
		round(activeBar, 10)

		create("TextLabel", {
			Parent = tabBtn,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 18, 0, 0),
			Size = UDim2.fromOffset(20, 40),
			Font = Enum.Font.GothamBold,
			Text = tostring(tabIcon),
			TextColor3 = selfWindow.Theme.Text,
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		create("TextLabel", {
			Parent = tabBtn,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 42, 0, 0),
			Size = UDim2.new(1, -48, 1, 0),
			Font = Enum.Font.GothamSemibold,
			Text = tabTitle,
			TextColor3 = selfWindow.Theme.Text,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		local page = create("ScrollingFrame", {
			Parent = rightScroll,
			Name = tabTitle .. "_Page",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, -6, 1, 0),
			CanvasSize = UDim2.fromOffset(0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = selfWindow.Theme.Accent,
			Visible = false,
		})
		padding(page, 2, 4, 2, 2)
		list(page, 10)

		local tab = {}
		tab.Title = tabTitle
		tab.Icon = tabIcon
		tab.Page = page
		tab.Button = tabBtn
		tab.ActiveBar = activeBar
		tab._sections = {}

		function tab:AddSection(sectionTitle, sectionIcon)
			local section = create("Frame", {
				Parent = page,
				BackgroundColor3 = selfWindow.Theme.Element,
				BackgroundTransparency = 0.1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 42),
				AutomaticSize = Enum.AutomaticSize.Y,
			})
			round(section, 14)
			stroke(section, Color3.fromRGB(255, 255, 255), 1, 0.94)
			padding(section, 12, 12, 12, 12)

			create("TextLabel", {
				Parent = section,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 18),
				Font = Enum.Font.GothamBold,
				Text = ((sectionIcon and tostring(sectionIcon) .. "  ") or "") .. (sectionTitle or "Section"),
				TextColor3 = selfWindow.Theme.Text,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
			})

			local content = create("Frame", {
				Parent = section,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.new(0, 0, 0, 24),
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
			})
			list(content, 8)

			local sectionObj = { _container = content, _tab = tab }

			local function elementBase(height)
				local frame = create("Frame", {
					Parent = content,
					BackgroundColor3 = selfWindow.Theme.Element2,
					BackgroundTransparency = 0.08,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, height or 42),
				})
				round(frame, 12)
				stroke(frame, Color3.fromRGB(255, 255, 255), 1, 0.95)
				return frame
			end

			local function iconText(text, icon)
				if icon and tostring(icon) ~= "" then
					return tostring(icon) .. "  " .. tostring(text)
				end
				return tostring(text)
			end

			function sectionObj:AddToggle(data)
				data = data or {}
				local frame = elementBase(42)

				create("TextLabel", {
					Parent = frame,
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 12, 0, 0),
					Size = UDim2.new(1, -60, 1, 0),
					Font = Enum.Font.GothamSemibold,
					Text = iconText(data.Title or "Toggle", data.Icon),
					TextColor3 = selfWindow.Theme.Text,
					TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Left,
				})

				local box = create("TextButton", {
					Parent = frame,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 0.9,
					BorderSizePixel = 0,
					Text = "",
					Size = UDim2.fromOffset(22, 22),
					Position = UDim2.new(1, -34, 0.5, -11),
					AutoButtonColor = false,
				})
				round(box, 7)
				stroke(box, Color3.fromRGB(255, 255, 255), 1, 0.94)

				local check = create("Frame", {
					Parent = box,
					BackgroundColor3 = selfWindow.Theme.Accent,
					BorderSizePixel = 0,
					Size = UDim2.new(1, -6, 1, -6),
					Position = UDim2.new(0, 3, 0, 3),
					Visible = data.Default == true,
				})
				round(check, 5)

				local value = data.Default == true
				local function set(v)
					value = v and true or false
					check.Visible = value
					if data.Callback then
						data.Callback(value)
					end
				end

				box.Activated:Connect(function()
					set(not value)
				end)

				set(value)
				return { Set = set, Get = function() return value end }
			end

			function sectionObj:AddButton(data)
				data = data or {}
				local frame = elementBase(40)

				local btn = create("TextButton", {
					Parent = frame,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 1, 0),
					Text = "",
					AutoButtonColor = false,
				})

				create("TextLabel", {
					Parent = btn,
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 12, 0, 0),
					Size = UDim2.new(1, -24, 1, 0),
					Font = Enum.Font.GothamSemibold,
					Text = iconText(data.Title or "Button", data.Icon),
					TextColor3 = selfWindow.Theme.Text,
					TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Left,
				})

				btn.Activated:Connect(function()
					if data.Callback then
						data.Callback()
					end
				end)

				return btn
			end

			function sectionObj:AddInput(data)
				data = data or {}
				local frame = elementBase(52)

				create("TextLabel", {
					Parent = frame,
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 12, 0, 2),
					Size = UDim2.new(1, -24, 0, 16),
					Font = Enum.Font.GothamSemibold,
					Text = iconText(data.Title or "Input", data.Icon),
					TextColor3 = selfWindow.Theme.Text,
					TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Left,
				})

				local box = create("TextBox", {
					Parent = frame,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 0.9,
					BorderSizePixel = 0,
					Position = UDim2.new(0, 12, 0, 22),
					Size = UDim2.new(1, -24, 0, 24),
					ClearTextOnFocus = false,
					Font = Enum.Font.Gotham,
					PlaceholderText = data.Placeholder or "",
					Text = tostring(data.Default or ""),
					TextColor3 = selfWindow.Theme.Text,
					PlaceholderColor3 = selfWindow.Theme.SubText,
					TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Left,
				})
				round(box, 8)
				stroke(box, Color3.fromRGB(255, 255, 255), 1, 0.94)
				padding(box, 0, 0, 10, 10)

				box.FocusLost:Connect(function(enter)
					local txt = box.Text
					if data.Numeric then
						txt = string.gsub(txt, "[^%d%.%-]", "")
						box.Text = txt
					end
					if data.Callback then
						if data.Finished then
							if enter then
								data.Callback(txt)
							end
						else
							data.Callback(txt)
						end
					end
				end)

				return box
			end

			function sectionObj:AddSlider(data)
				data = data or {}
				local min = tonumber(data.Min) or 0
				local max = tonumber(data.Max) or 100
				local rounding = tonumber(data.Rounding) or 0
				local value = clamp(tonumber(data.Default) or min, min, max)

				local frame = elementBase(58)

				create("TextLabel", {
					Parent = frame,
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 12, 0, 2),
					Size = UDim2.new(1, -24, 0, 16),
					Font = Enum.Font.GothamSemibold,
					Text = iconText(data.Title or "Slider", data.Icon),
					TextColor3 = selfWindow.Theme.Text,
					TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Left,
				})

				local valueLabel = create("TextLabel", {
					Parent = frame,
					BackgroundTransparency = 1,
					Position = UDim2.new(1, -60, 0, 2),
					Size = UDim2.fromOffset(50, 16),
					Font = Enum.Font.Gotham,
					Text = tostring(value),
					TextColor3 = selfWindow.Theme.SubText,
					TextSize = 12,
					TextXAlignment = Enum.TextXAlignment.Right,
				})

				local bar = create("Frame", {
					Parent = frame,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 0.9,
					BorderSizePixel = 0,
					Position = UDim2.new(0, 12, 0, 28),
					Size = UDim2.new(1, -24, 0, 14),
				})
				round(bar, 8)
				stroke(bar, Color3.fromRGB(255, 255, 255), 1, 0.95)

				local fill = create("Frame", {
					Parent = bar,
					BackgroundColor3 = selfWindow.Theme.Accent,
					BorderSizePixel = 0,
					Size = UDim2.new(0, 0, 1, 0),
				})
				round(fill, 8)

				local knob = create("Frame", {
					Parent = bar,
					BackgroundColor3 = Color3.new(1, 1, 1),
					BorderSizePixel = 0,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Size = UDim2.fromOffset(18, 18),
					Position = UDim2.fromScale(0, 0.5),
				})
				round(knob, 9)
				stroke(knob, selfWindow.Theme.Accent, 1, 0.5)

				local dragging = false

				local function set(v)
					v = clamp(v, min, max)
					if rounding > 0 then
						local m = 10 ^ rounding
						v = math.floor(v * m + 0.5) / m
					end
					value = v
					local alpha = (value - min) / math.max((max - min), 0.0001)
					fill.Size = UDim2.new(alpha, 0, 1, 0)
					knob.Position = UDim2.new(alpha, 0, 0.5, 0)
					valueLabel.Text = tostring(value)
					if data.Callback then
						data.Callback(value)
					end
				end

				local function updateFromX(x)
					local alpha = clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
					set(min + (max - min) * alpha)
				end

				bar.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = true
						updateFromX(input.Position.X)
					end
				end)

				UserInputService.InputChanged:Connect(function(input)
					if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						updateFromX(input.Position.X)
					end
				end)

				bar.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = false
					end
				end)

				set(value)
				return { Set = set, Get = function() return value end }
			end

			function sectionObj:AddDropdown(data)
				data = data or {}
				local values = data.Values or {}
				local defaultValue = data.Default

				local frame = elementBase(46)
				local button = create("TextButton", {
					Parent = frame,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 1, 0),
					Text = "",
					AutoButtonColor = false,
				})

				local titleLabel = create("TextLabel", {
					Parent = button,
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 12, 0, 0),
					Size = UDim2.new(1, -42, 1, 0),
					Font = Enum.Font.GothamSemibold,
					Text = iconText(data.Title or "Dropdown", data.Icon),
					TextColor3 = selfWindow.Theme.Text,
					TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Left,
				})

				create("TextLabel", {
					Parent = button,
					BackgroundTransparency = 1,
					Position = UDim2.new(1, -26, 0, 0),
					Size = UDim2.fromOffset(16, 46),
					Font = Enum.Font.GothamBold,
					Text = "⌄",
					TextColor3 = selfWindow.Theme.SubText,
					TextSize = 18,
				})

				local dropdownObj = {
					Title = data.Title or "Dropdown",
					Icon = data.Icon,
					Button = button,
					Callback = data.Callback,
					_selected = nil,
				}

				local function setText()
					if data.Multi then
						local selected = {}
						dropdownObj._selected = dropdownObj._selected or {}
						for _, v in ipairs(values) do
							if dropdownObj._selected[tostring(v)] then
								table.insert(selected, tostring(v))
							end
						end
						titleLabel.Text = iconText(data.Title or "Dropdown", data.Icon) .. " : " .. (#selected > 0 and table.concat(selected, ", ") or "None")
					else
						titleLabel.Text = iconText(data.Title or "Dropdown", data.Icon) .. " : " .. tostring(dropdownObj._selected or defaultValue or "Select")
					end
				end

				local function openDropdown(valuesArg, multiArg, defaultArg, noSearchArg)
					local overlay = create("Frame", {
						Parent = gui,
						Name = "DropdownOverlay",
						BackgroundColor3 = Color3.fromRGB(0, 0, 0),
						BackgroundTransparency = 0.55,
						BorderSizePixel = 0,
						Size = UDim2.fromScale(1, 1),
						ZIndex = 50,
					})

					local popW = math.clamp(math.floor(selfWindow.Size.X.Offset * 0.46), 290, 360)
					local popH = math.clamp(math.floor(selfWindow.Size.Y.Offset * 0.62), 280, 380)

					local popup = create("Frame", {
						Parent = overlay,
						BackgroundColor3 = selfWindow.Theme.Element,
						BackgroundTransparency = 0.08,
						BorderSizePixel = 0,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						Size = UDim2.fromOffset(popW, popH),
						ZIndex = 51,
					})
					round(popup, 16)
					stroke(popup, Color3.fromRGB(255, 255, 255), 1, 0.86)

					local function closePopup()
						if overlay and overlay.Parent then
							overlay:Destroy()
						end
					end

					create("TextLabel", {
						Parent = popup,
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 14, 0, 10),
						Size = UDim2.new(1, -28, 0, 20),
						Font = Enum.Font.GothamBold,
						Text = (data.Icon and tostring(data.Icon) .. "  " or "") .. (data.Title or "Dropdown"),
						TextColor3 = selfWindow.Theme.Text,
						TextSize = 16,
						TextXAlignment = Enum.TextXAlignment.Left,
						ZIndex = 52,
					})

					local close = create("TextButton", {
						Parent = popup,
						BackgroundColor3 = Color3.fromRGB(40, 18, 18),
						BackgroundTransparency = 0.12,
						BorderSizePixel = 0,
						Text = "✕",
						TextColor3 = Color3.fromRGB(255, 245, 245),
						Font = Enum.Font.GothamBold,
						TextSize = 14,
						Size = UDim2.fromOffset(28, 28),
						Position = UDim2.new(1, -38, 0, 10),
						AutoButtonColor = false,
						ZIndex = 52,
					})
					round(close, 10)
					stroke(close, Color3.fromRGB(255, 255, 255), 1, 0.75)
					close.Activated:Connect(closePopup)

					local search
					local listTop = 50

					if not noSearchArg then
						local searchFrame = create("Frame", {
							Parent = popup,
							BackgroundColor3 = Color3.fromRGB(25, 25, 30),
							BackgroundTransparency = 0.16,
							BorderSizePixel = 0,
							Position = UDim2.new(0, 14, 0, 38),
							Size = UDim2.new(1, -28, 0, 30),
							ZIndex = 52,
						})
						round(searchFrame, 10)
						stroke(searchFrame, Color3.fromRGB(255, 255, 255), 1, 0.92)

						create("TextLabel", {
							Parent = searchFrame,
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 10, 0, 0),
							Size = UDim2.fromOffset(16, 30),
							Font = Enum.Font.GothamBold,
							Text = "⌕",
							TextColor3 = selfWindow.Theme.SubText,
							TextSize = 15,
							TextXAlignment = Enum.TextXAlignment.Center,
							ZIndex = 53,
						})

						search = create("TextBox", {
							Parent = searchFrame,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Position = UDim2.new(0, 28, 0, 0),
							Size = UDim2.new(1, -34, 1, 0),
							ClearTextOnFocus = false,
							Font = Enum.Font.Gotham,
							PlaceholderText = "Search...",
							Text = "",
							TextColor3 = selfWindow.Theme.Text,
							PlaceholderColor3 = selfWindow.Theme.SubText,
							TextSize = 13,
							TextXAlignment = Enum.TextXAlignment.Left,
							ZIndex = 53,
						})
						listTop = 76
					end

					local scroll = create("ScrollingFrame", {
						Parent = popup,
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Position = UDim2.new(0, 14, 0, listTop),
						Size = UDim2.new(1, -28, 1, -(listTop + 14)),
						CanvasSize = UDim2.fromOffset(0, 0),
						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						ScrollBarThickness = 3,
						ScrollBarImageColor3 = selfWindow.Theme.Accent,
						ZIndex = 52,
					})
					padding(scroll, 2, 2, 2, 2)
					list(scroll, 8)

					local optionButtons = {}
					local selection = {}

					if multiArg then
						if typeof(defaultArg) == "table" then
							for _, v in ipairs(defaultArg) do
								selection[tostring(v)] = true
							end
						elseif defaultArg ~= nil then
							selection[tostring(defaultArg)] = true
						end
					end

					local function getCurrent()
						if multiArg then
							local result = {}
							for _, v in ipairs(valuesArg) do
								if selection[tostring(v)] then
									table.insert(result, v)
								end
							end
							return result
						end
						return dropdownObj._selected or defaultArg
					end

					local function syncButton()
						if multiArg then
							local arr = getCurrent()
							if #arr == 0 then
								titleLabel.Text = iconText(data.Title or "Dropdown", data.Icon) .. " : None"
							else
								titleLabel.Text = iconText(data.Title or "Dropdown", data.Icon) .. " : " .. table.concat(arr, ", ")
							end
						else
							titleLabel.Text = iconText(data.Title or "Dropdown", data.Icon) .. " : " .. tostring(dropdownObj._selected or defaultArg or "Select")
						end
					end

					local function refreshVisible(filterText)
						local lower = string.lower(filterText or "")
						for _, item in ipairs(optionButtons) do
							item.Visible = lower == "" or string.find(string.lower(item.ValueText), lower, 1, true) ~= nil
						end
					end

					for _, value in ipairs(valuesArg) do
						local vText = tostring(value)

						local itemBtn = create("TextButton", {
							Parent = scroll,
							BackgroundColor3 = selfWindow.Theme.Element2,
							BackgroundTransparency = 0.08,
							BorderSizePixel = 0,
							Size = UDim2.new(1, 0, 0, 34),
							Font = Enum.Font.Gotham,
							Text = "",
							AutoButtonColor = false,
							ZIndex = 53,
						})
						round(itemBtn, 10)
						stroke(itemBtn, Color3.fromRGB(255, 255, 255), 1, 0.94)

						local itemText = create("TextLabel", {
							Parent = itemBtn,
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 10, 0, 0),
							Size = UDim2.new(1, -20, 1, 0),
							Font = Enum.Font.Gotham,
							Text = multiArg and ((selection[vText] and "✓  " or "○  ") .. vText) or vText,
							TextColor3 = selfWindow.Theme.Text,
							TextSize = 13,
							TextXAlignment = Enum.TextXAlignment.Left,
							ZIndex = 54,
						})

						itemBtn.Activated:Connect(function()
							if multiArg then
								selection[vText] = not selection[vText]
								itemText.Text = (selection[vText] and "✓  " or "○  ") .. vText
								dropdownObj._selected = selection
								syncButton()
								if dropdownObj.Callback then
									local result = {}
									for _, vv in ipairs(valuesArg) do
										if selection[tostring(vv)] then
											table.insert(result, vv)
										end
									end
									dropdownObj.Callback(result)
								end
							else
								dropdownObj._selected = value
								syncButton()
								if dropdownObj.Callback then
									dropdownObj.Callback(value)
								end
								closePopup()
							end
						end)

						itemBtn.ValueText = vText
						table.insert(optionButtons, itemBtn)
					end

					if search then
						refreshVisible(search.Text)
						search:GetPropertyChangedSignal("Text"):Connect(function()
							refreshVisible(search.Text)
						end)
					end

					overlay.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							local mouse = UserInputService:GetMouseLocation()
							local p = popup.AbsolutePosition
							local s = popup.AbsoluteSize
							if mouse.X < p.X or mouse.X > p.X + s.X or mouse.Y < p.Y or mouse.Y > p.Y + s.Y then
								closePopup()
							end
						end
					end)
				end

				button.Activated:Connect(function()
					openDropdown(values, data.Multi == true, defaultValue, data.NoSearch == true)
				end)

				if defaultValue ~= nil then
					dropdownObj._selected = defaultValue
				end
				setText()

				function dropdownObj:Refresh(newValues)
					values = newValues or {}
					setText()
				end

				function dropdownObj:Set(v)
					dropdownObj._selected = v
					setText()
				end

				return dropdownObj
			end

			table.insert(tab._sections, sectionObj)
			return sectionObj
		end

		tabBtn.Activated:Connect(function()
			selectTab(tab)
		end)

		table.insert(selfWindow._tabs, tab)

		if not selfWindow._currentTab then
			selectTab(tab)
		end

		return tab
	end

	function selfWindow:CreateMinimizeBtn(btnOpts)
		btnOpts = btnOpts or {}

		if selfWindow._minimizeBtn and selfWindow._minimizeBtn.Parent then
			selfWindow._minimizeBtn:Destroy()
		end

		local btn = create("TextButton", {
			Parent = gui,
			Name = "MinimizeBtn",
			BackgroundColor3 = Color3.fromRGB(22, 22, 24),
			BackgroundTransparency = 0.08,
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(124, 38),
			Position = UDim2.new(0, 20, 0.5, -19),
			Text = "",
			AutoButtonColor = false,
			ZIndex = 40,
		})
		round(btn, 12)
		stroke(btn, Color3.fromRGB(255, 255, 255), 1, 0.78)

		create("TextLabel", {
			Parent = btn,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -30, 1, 0),
			Position = UDim2.new(0, 12, 0, 0),
			Font = Enum.Font.GothamSemibold,
			Text = tostring(btnOpts.Title or "Open UI"),
			TextColor3 = selfWindow.Theme.Text,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		create("TextLabel", {
			Parent = btn,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(22, 22),
			Position = UDim2.new(1, -28, 0.5, -11),
			Font = Enum.Font.GothamBold,
			Text = tostring(btnOpts.Icon or btnOpts.Image or "◉"),
			TextColor3 = selfWindow.Theme.Accent,
			TextSize = 14,
		})

		makeDraggable(btn, btn)

		btn.Activated:Connect(function()
			if not selfWindow.Main or not selfWindow.Main.Parent then
				return
			end

			selfWindow.Main.Visible = not selfWindow.Main.Visible
			if selfWindow.Main.Visible then
				enableBlur()
			else
				disableBlur()
			end
		end)

		selfWindow._minimizeBtn = btn
		return btn
	end

	function selfWindow:Destroy()
		if selfWindow._destroyed then
			return
		end
		selfWindow._destroyed = true
		disableBlur()
		if selfWindow.Gui then
			selfWindow.Gui:Destroy()
		end
	end

	closeBtn.Activated:Connect(function()
		selfWindow:Destroy()
	end)

	makeDraggable(main, top)

	UserInputService.InputBegan:Connect(function(input, gp)
		if gp then
			return
		end
		if input.KeyCode == selfWindow.MinimizeKey then
			if selfWindow.Main and selfWindow.Main.Parent then
				selfWindow.Main.Visible = not selfWindow.Main.Visible
				if selfWindow.Main.Visible then
					enableBlur()
				else
					disableBlur()
				end
			end
		end
	end)

	Library._lastWindow = selfWindow
	return selfWindow
end

function Library:Notify(data)
	if self._lastWindow and self._lastWindow.Notify then
		self._lastWindow:Notify(data)
	end
end

return Library
