--// SKUI PREMIUM GLASS LIBRARY //-- --// Rebuilt clean version with scrolling, dropdown search, draggable window, --// profile card, minimize button, blur toggle, icons, notifications, and stable layout.

local Players = game:GetService("Players") local TweenService = game:GetService("TweenService") local UserInputService = game:GetService("UserInputService") local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Library = {} Library.__index = Library Library._lastWindow = nil

local Theme = { Accent = Color3.fromRGB(180, 10, 20), Background = Color3.fromRGB(12, 12, 14), Topbar = Color3.fromRGB(16, 16, 20), Panel = Color3.fromRGB(18, 18, 22), Element = Color3.fromRGB(25, 25, 30), Element2 = Color3.fromRGB(30, 30, 36), Text = Color3.fromRGB(255, 255, 255), SubText = Color3.fromRGB(185, 185, 185), Border = Color3.fromRGB(255, 255, 255), }

local function Create(className, props) local obj = Instance.new(className) for k, v in pairs(props or {}) do obj[k] = v end return obj end

local function Corner(obj, radius) return Create("UICorner", { CornerRadius = UDim.new(0, radius or 12), Parent = obj, }) end

local function Stroke(obj, transparency) return Create("UIStroke", { Parent = obj, Color = Theme.Border, Thickness = 1, Transparency = transparency or 0.85, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, }) end

local function Padding(obj, top, bottom, left, right) return Create("UIPadding", { Parent = obj, PaddingTop = UDim.new(0, top or 0), PaddingBottom = UDim.new(0, bottom or 0), PaddingLeft = UDim.new(0, left or 0), PaddingRight = UDim.new(0, right or 0), }) end

local function List(obj, pad) return Create("UIListLayout", { Parent = obj, Padding = UDim.new(0, pad or 8), SortOrder = Enum.SortOrder.LayoutOrder, }) end

local function Tween(obj, timeSec, props) TweenService:Create( obj, TweenInfo.new(timeSec or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props ):Play() end

local function Draggable(frame, handle) local dragging = false local dragStart local startPos local dragInput

handle.Active = true
frame.Active = true

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
	if dragging and input == dragInput then
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

local function WithIcon(icon, text) if icon and tostring(icon) ~= "" then return tostring(icon) .. "  " .. tostring(text) end return tostring(text) end

local function Clamp(n, a, b) return math.max(a, math.min(b, n)) end

local function CopyArray(src) local out = {} for i, v in ipairs(src or {}) do out[i] = v end return out end

local function MakeBaseFrame(parent, theme, height) local frame = Create("Frame", { Parent = parent, BackgroundColor3 = theme.Element2, BackgroundTransparency = 0.08, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, height or 40), }) Corner(frame, 12) Stroke(frame, 0.95) return frame end

local function MakeNotification(gui, theme, title, content, duration) local notif = Create("Frame", { Parent = gui, BackgroundColor3 = theme.Element, BackgroundTransparency = 0.05, BorderSizePixel = 0, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 280, 0, 20), Size = UDim2.fromOffset(260, 68), }) Corner(notif, 14) Stroke(notif, 0.55)

Create("TextLabel", {
	Parent = notif,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 12, 0, 8),
	Size = UDim2.new(1, -24, 0, 18),
	Font = Enum.Font.GothamBold,
	Text = title or "Notification",
	TextSize = 14,
	TextColor3 = theme.Text,
	TextXAlignment = Enum.TextXAlignment.Left,
})

Create("TextLabel", {
	Parent = notif,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 12, 0, 30),
	Size = UDim2.new(1, -24, 0, 26),
	Font = Enum.Font.Gotham,
	Text = content or "",
	TextWrapped = true,
	TextSize = 12,
	TextColor3 = theme.SubText,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Top,
})

Tween(notif, 0.25, { Position = UDim2.new(1, -20, 0, 20) })
	task.delay(duration or 4, function()
		if notif and notif.Parent then
			Tween(notif, 0.2, { Position = UDim2.new(1, 280, 0, 20) })
			task.wait(0.22)
			if notif then
				notif:Destroy()
			end
		end
	end)

end

function Library:CreateUI(opts) return self:CreateWindow(opts) end

function Library:CreateWindow(opts) opts = opts or {}

local selfWindow = setmetatable({}, Library)
selfWindow.Title = opts.Title or "SKUI"
selfWindow.SubTitle = opts.SubTitle or ""
selfWindow.Size = opts.Size or UDim2.fromOffset(520, 480)
selfWindow.TabWidth = opts.TabWidth or 160
selfWindow.Acrylic = opts.Acrylic ~= false
selfWindow.MinimizeKey = opts.MinimizeKey or Enum.KeyCode.LeftControl
selfWindow.UserInfoTop = opts.UserInfoTop ~= false
selfWindow.UserInfoTitle = opts.UserInfoTitle or LocalPlayer.DisplayName
selfWindow.UserInfoSubtitle = opts.UserInfoSubtitle or "Advanced User"
selfWindow.UserInfoColor = opts.UserInfoColor or Theme.Accent
selfWindow.Search = opts.Search ~= false
selfWindow._tabs = {}
selfWindow._currentTab = nil
selfWindow._destroyed = false
selfWindow._blur = nil
selfWindow._minimizeBtn = nil

local function EnableBlur()
	if not selfWindow.Acrylic then
		return
	end
	if selfWindow._blur and selfWindow._blur.Parent then
		selfWindow._blur.Size = 12
		return
	end
	selfWindow._blur = Create("BlurEffect", {
		Name = "UILibraryBlur",
		Size = 12,
		Parent = Lighting,
	})
end

local function DisableBlur()
	if selfWindow._blur and selfWindow._blur.Parent then
		selfWindow._blur:Destroy()
	end
	selfWindow._blur = nil
end

local gui = Create("ScreenGui", {
	Name = "SKUIPremiumGUI",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	Parent = PlayerGui,
})
selfWindow.Gui = gui

EnableBlur()

local main = Create("Frame", {
	Parent = gui,
	Name = "Main",
	BackgroundColor3 = Theme.Background,
	BackgroundTransparency = 0.28,
	BorderSizePixel = 0,
	ClipsDescendants = true,
	Size = selfWindow.Size,
	Position = UDim2.new(0.5, -selfWindow.Size.X.Offset / 2, 0.5, -selfWindow.Size.Y.Offset / 2),
})
Corner(main, 18)
Stroke(main, 0.75)
selfWindow.Main = main

Create("ImageLabel", {
	Parent = main,
	BackgroundTransparency = 1,
	Size = UDim2.new(1, 30, 1, 30),
	Position = UDim2.new(0, -15, 0, -15),
	Image = "rbxassetid://1316045217",
	ImageTransparency = 0.6,
	ImageColor3 = Color3.new(0, 0, 0),
	ScaleType = Enum.ScaleType.Slice,
	SliceCenter = Rect.new(10, 10, 118, 118),
})

local topbar = Create("Frame", {
	Parent = main,
	Name = "Topbar",
	Size = UDim2.new(1, 0, 0, 60),
	BackgroundColor3 = Theme.Topbar,
	BackgroundTransparency = 0.2,
	BorderSizePixel = 0,
})
Corner(topbar, 18)
Stroke(topbar, 0.84)
selfWindow.Topbar = topbar

Create("Frame", {
	Parent = topbar,
	BackgroundColor3 = Theme.Topbar,
	BorderSizePixel = 0,
	Size = UDim2.new(1, 0, 0, 18),
	Position = UDim2.new(0, 0, 1, -18),
})

Create("TextLabel", {
	Parent = topbar,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 16, 0, 8),
	Size = UDim2.new(1, -120, 0, 20),
	Font = Enum.Font.GothamBold,
	Text = selfWindow.Title,
	TextColor3 = Theme.Text,
	TextSize = 18,
	TextXAlignment = Enum.TextXAlignment.Left,
})

Create("TextLabel", {
	Parent = topbar,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 16, 0, 30),
	Size = UDim2.new(1, -120, 0, 16),
	Font = Enum.Font.Gotham,
	Text = selfWindow.SubTitle,
	TextColor3 = Theme.SubText,
	TextSize = 13,
	TextXAlignment = Enum.TextXAlignment.Left,
})

local closeBtn = Create("TextButton", {
	Parent = topbar,
	BackgroundColor3 = Theme.Element,
	BackgroundTransparency = 0.1,
	BorderSizePixel = 0,
	Text = opts.CloseIcon or "✕",
	TextColor3 = Theme.Text,
	Font = Enum.Font.GothamBold,
	TextSize = 16,
	Size = UDim2.fromOffset(30, 30),
	Position = UDim2.new(1, -40, 0, 15),
	AutoButtonColor = false,
})
Corner(closeBtn, 10)
Stroke(closeBtn, 0.8)

local content = Create("Frame", {
	Parent = main,
	Name = "Content",
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2.new(0, 0, 0, 60),
	Size = UDim2.new(1, 0, 1, -60),
})
selfWindow.Content = content

local left = Create("Frame", {
	Parent = content,
	Name = "TabsPanel",
	BackgroundColor3 = Theme.Panel,
	BackgroundTransparency = 0.15,
	BorderSizePixel = 0,
	Position = UDim2.new(0, 10, 0, 10),
	Size = UDim2.new(0, selfWindow.TabWidth, 1, -20),
})
Corner(left, 16)
Stroke(left, 0.88)
selfWindow.LeftPanel = left

local right = Create("Frame", {
	Parent = content,
	Name = "PagesPanel",
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2.new(0, selfWindow.TabWidth + 20, 0, 10),
	Size = UDim2.new(1, -(selfWindow.TabWidth + 30), 1, -20),
})
selfWindow.RightPanel = right

local rightScroll = Create("ScrollingFrame", {
	Parent = right,
	Name = "RightScroll",
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Size = UDim2.new(1, 0, 1, 0),
	CanvasSize = UDim2.fromOffset(0, 0),
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
	ScrollBarThickness = 3,
	ScrollBarImageColor3 = Theme.Accent,
})
Padding(rightScroll, 4, 4, 4, 4)
List(rightScroll, 10)
selfWindow.RightScroll = rightScroll

local profile = Create("Frame", {
	Parent = left,
	BackgroundColor3 = Theme.Element,
	BackgroundTransparency = 0.1,
	BorderSizePixel = 0,
	Position = UDim2.new(0, 6, 0, 6),
	Size = UDim2.new(1, -12, 0, 58),
})
Corner(profile, 12)
Stroke(profile, 0.9)

local avatar = Create("ImageLabel", {
	Parent = profile,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 10, 0, 10),
	Size = UDim2.fromOffset(38, 38),
	Image = "",
})
Corner(avatar, 99)

task.spawn(function()
	local ok, image = pcall(function()
		return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
	end)
	if ok and avatar and avatar.Parent then
		avatar.Image = image
	end
end)

Create("TextLabel", {
	Parent = profile,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 56, 0, 10),
	Size = UDim2.new(1, -60, 0, 18),
	Font = Enum.Font.GothamBold,
	Text = selfWindow.UserInfoTitle,
	TextColor3 = Theme.Text,
	TextSize = 13,
	TextXAlignment = Enum.TextXAlignment.Left,
})

Create("TextLabel", {
	Parent = profile,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 56, 0, 28),
	Size = UDim2.new(1, -60, 0, 16),
	Font = Enum.Font.Gotham,
	Text = selfWindow.UserInfoSubtitle,
	TextColor3 = Theme.SubText,
	TextSize = 11,
	TextXAlignment = Enum.TextXAlignment.Left,
})

local searchFrame
local searchBox
if selfWindow.Search then
	searchFrame = Create("Frame", {
		Parent = left,
		BackgroundColor3 = Theme.Element,
		BackgroundTransparency = 0.1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 6, 0, 72),
		Size = UDim2.new(1, -12, 0, 32),
	})
	Corner(searchFrame, 10)
	Stroke(searchFrame, 0.9)

	Create("TextLabel", {
		Parent = searchFrame,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 8, 0, 0),
		Size = UDim2.fromOffset(20, 32),
		Font = Enum.Font.GothamBold,
		Text = "⌕",
		TextColor3 = Theme.SubText,
		TextSize = 14,
	})

	searchBox = Create("TextBox", {
		Parent = searchFrame,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 28, 0, 0),
		Size = UDim2.new(1, -32, 1, 0),
		PlaceholderText = "Search tabs...",
		Text = "",
		ClearTextOnFocus = false,
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextColor3 = Theme.Text,
		PlaceholderColor3 = Theme.SubText,
		TextXAlignment = Enum.TextXAlignment.Left,
	})
end
selfWindow.SearchBox = searchBox

local tabsScroll = Create("ScrollingFrame", {
	Parent = left,
	Name = "TabsScroll",
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2.new(0, 0, 0, selfWindow.UserInfoTop and 112 or 52),
	Size = UDim2.new(1, 0, 1, -(selfWindow.UserInfoTop and 118 or 58)),
	CanvasSize = UDim2.fromOffset(0, 0),
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
	ScrollBarThickness = 3,
	ScrollBarImageColor3 = Theme.Accent,
})
Padding(tabsScroll, 6, 6, 6, 6)
List(tabsScroll, 8)
selfWindow.TabsScroll = tabsScroll

local function SelectTab(tabData)
	selfWindow._currentTab = tabData
	for _, t in ipairs(selfWindow._tabs) do
		t.Page.Visible = false
		t.Button.BackgroundColor3 = Theme.Element
		t.Button.BackgroundTransparency = 0.1
		if t.ActiveBar then
			t.ActiveBar.BackgroundTransparency = 1
		end
	end
	tabData.Page.Visible = true
	tabData.Button.BackgroundColor3 = Theme.Element2
	tabData.Button.BackgroundTransparency = 0.02
	if tabData.ActiveBar then
		tabData.ActiveBar.BackgroundTransparency = 0
	end
end

if searchBox then
	searchBox:GetPropertyChangedSignal("Text"):Connect(function()
		local q = string.lower(searchBox.Text or "")
		for _, tabData in ipairs(selfWindow._tabs) do
			tabData.Button.Visible = q == "" or string.find(string.lower(tabData.Title), q, 1, true) ~= nil
		end
	end)
end

local function OpenDropdown(dropdown, valuesRef, multiMode, defaultValue, noSearch)
	local overlay = Create("Frame", {
		Parent = gui,
		Name = "DropdownOverlay",
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.55,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 50,
	})

	local popup = Create("Frame", {
		Parent = overlay,
		BackgroundColor3 = Theme.Element,
		BackgroundTransparency = 0.08,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(320, 340),
		ZIndex = 51,
	})
	Corner(popup, 16)
	Stroke(popup, 0.86)

	local function ClosePopup()
		if overlay and overlay.Parent then
			overlay:Destroy()
		end
	end

	Create("TextLabel", {
		Parent = popup,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 14, 0, 10),
		Size = UDim2.new(1, -28, 0, 20),
		Font = Enum.Font.GothamBold,
		Text = WithIcon(dropdown.Icon, dropdown.Title),
		TextColor3 = Theme.Text,
		TextSize = 16,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 52,
	})

	local popupClose = Create("TextButton", {
		Parent = popup,
		BackgroundColor3 = Theme.Element,
		BackgroundTransparency = 0.12,
		BorderSizePixel = 0,
		Text = "✕",
		TextColor3 = Theme.Text,
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		Size = UDim2.fromOffset(28, 28),
		Position = UDim2.new(1, -38, 0, 10),
		AutoButtonColor = false,
		ZIndex = 52,
	})
	Corner(popupClose, 10)
	Stroke(popupClose, 0.75)
	popupClose.Activated:Connect(ClosePopup)

	local topOffset = 50
	local searchBox2
	if not noSearch then
		local searchArea = Create("Frame", {
			Parent = popup,
			BackgroundColor3 = Theme.Element2,
			BackgroundTransparency = 0.12,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 12, 0, 38),
			Size = UDim2.new(1, -24, 0, 30),
			ZIndex = 52,
		})
		Corner(searchArea, 10)
		Stroke(searchArea, 0.92)

		Create("TextLabel", {
			Parent = searchArea,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 10, 0, 0),
			Size = UDim2.fromOffset(16, 30),
			Font = Enum.Font.GothamBold,
			Text = "⌕",
			TextColor3 = Theme.SubText,
			TextSize = 15,
			ZIndex = 53,
		})

		searchBox2 = Create("TextBox", {
			Parent = searchArea,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 28, 0, 0),
			Size = UDim2.new(1, -34, 1, 0),
			ClearTextOnFocus = false,
			Font = Enum.Font.Gotham,
			PlaceholderText = "Search...",
			Text = "",
			TextColor3 = Theme.Text,
			PlaceholderColor3 = Theme.SubText,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 53,
		})
		topOffset = 76
	end

	local scroll = Create("ScrollingFrame", {
		Parent = popup,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 12, 0, topOffset),
		Size = UDim2.new(1, -24, 1, -(topOffset + 12)),
		CanvasSize = UDim2.fromOffset(0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = Theme.Accent,
		ZIndex = 52,
	})
	Padding(scroll, 2, 2, 2, 2)
	List(scroll, 8)

	local selection = {}
	if multiMode then
		if typeof(defaultValue) == "table" then
			for _, v in ipairs(defaultValue) do
				selection[tostring(v)] = true
			end
		elseif defaultValue ~= nil then
			selection[tostring(defaultValue)] = true
		end
	end

	local optionButtons = {}

	local function Current()
		if multiMode then
			local out = {}
			for _, v in ipairs(valuesRef) do
				if selection[tostring(v)] then
					table.insert(out, v)
				end
			end
			return out
		end
		return dropdown._selected or defaultValue
	end

	local function SyncLabel()
		if multiMode then
			local arr = Current()
			if #arr == 0 then
				dropdown.Label.Text = WithIcon(dropdown.Icon, dropdown.Title) .. " : None"
			else
				dropdown.Label.Text = WithIcon(dropdown.Icon, dropdown.Title) .. " : " .. table.concat(arr, ", ")
			end
		else
			dropdown.Label.Text = WithIcon(dropdown.Icon, dropdown.Title) .. " : " .. tostring(dropdown._selected or defaultValue or "Select")
		end
	end

	local function RefreshSearch(query)
		local lower = string.lower(query or "")
		for _, item in ipairs(optionButtons) do
			item.Visible = lower == "" or string.find(string.lower(item.ValueText), lower, 1, true) ~= nil
		end
	end

	for _, value in ipairs(valuesRef) do
		local text = tostring(value)
		local item = Create("TextButton", {
			Parent = scroll,
			BackgroundColor3 = Theme.Element2,
			BackgroundTransparency = 0.08,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 34),
			Text = "",
			AutoButtonColor = false,
			ZIndex = 53,
		})
		Corner(item, 10)
		Stroke(item, 0.94)

		local itemLabel = Create("TextLabel", {
			Parent = item,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 10, 0, 0),
			Size = UDim2.new(1, -20, 1, 0),
			Font = Enum.Font.Gotham,
			Text = multiMode and ((selection[text] and "✓  " or "○  ") .. text) or text,
			TextColor3 = Theme.Text,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 54,
		})

		item.Activated:Connect(function()
			if multiMode then
				selection[text] = not selection[text]
				itemLabel.Text = (selection[text] and "✓  " or "○  ") .. text
				dropdown._selected = selection

				local result = {}
				for _, v in ipairs(valuesRef) do
					if selection[tostring(v)] then
						table.insert(result, v)
					end
				end

				SyncLabel()
				if dropdown.Callback then
					dropdown.Callback(result)
				end
			else
				dropdown._selected = value
				SyncLabel()
				if dropdown.Callback then
					dropdown.Callback(value)
				end
				ClosePopup()
			end
		end)

		item.ValueText = text
		table.insert(optionButtons, item)
	end

	if searchBox2 then
		RefreshSearch(searchBox2.Text)
		searchBox2:GetPropertyChangedSignal("Text"):Connect(function()
			RefreshSearch(searchBox2.Text)
		end)
	end

	overlay.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local mouse = UserInputService:GetMouseLocation()
			local p = popup.AbsolutePosition
			local s = popup.AbsoluteSize
			if mouse.X < p.X or mouse.X > p.X + s.X or mouse.Y < p.Y or mouse.Y > p.Y + s.Y then
				ClosePopup()
			end
		end
	end)

	return ClosePopup
end

function selfWindow:CreateMinimizeBtn(data)
	data = data or {}

	if selfWindow._minimizeBtn and selfWindow._minimizeBtn.Parent then
		selfWindow._minimizeBtn:Destroy()
	end

	local btn = Create("TextButton", {
		Parent = gui,
		Name = "MinimizeBtn",
		BackgroundColor3 = Theme.Element,
		BackgroundTransparency = 0.1,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(124, 38),
		Position = UDim2.new(0, 20, 0.5, -19),
		Text = "",
		AutoButtonColor = false,
		ZIndex = 40,
	})
	Corner(btn, 12)
	Stroke(btn, 0.8)

	Create("TextLabel", {
		Parent = btn,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 12, 0, 0),
		Size = UDim2.new(1, -30, 1, 0),
		Font = Enum.Font.GothamSemibold,
		Text = data.Title or "Open UI",
		TextColor3 = Theme.Text,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
	})

	Create("TextLabel", {
		Parent = btn,
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(22, 22),
		Position = UDim2.new(1, -28, 0.5, -11),
		Font = Enum.Font.GothamBold,
		Text = tostring(data.Icon or data.Image or "◉"),
		TextColor3 = Theme.Accent,
		TextSize = 14,
	})

	Draggable(btn, btn)

	btn.Activated:Connect(function()
		if not selfWindow.Main or not selfWindow.Main.Parent then
			return
		end

		selfWindow.Main.Visible = not selfWindow.Main.Visible
		if selfWindow.Main.Visible then
			EnableBlur()
		else
			DisableBlur()
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
	DisableBlur()
	SafeDestroy(selfWindow.Gui)
end

closeBtn.Activated:Connect(function()
	selfWindow:Destroy()
end)

UserInputService.InputBegan:Connect(function(input, gp)
	if gp then
		return
	end
	if input.KeyCode == selfWindow.MinimizeKey then
		if selfWindow.Main and selfWindow.Main.Parent then
			selfWindow.Main.Visible = not selfWindow.Main.Visible
			if selfWindow.Main.Visible then
				EnableBlur()
			else
				DisableBlur()
			end
		end
	end
end)

Draggable(main, topbar)

function selfWindow:AddTab(tabData)
	tabData = tabData or {}

	local tab = {}
	tab.Title = tabData.Title or "Tab"
	tab.Icon = tabData.Icon or "◆"
	tab._sections = {}

	local tabButton = Create("TextButton", {
		Parent = tabsScroll,
		BackgroundColor3 = Theme.Element,
		BackgroundTransparency = 0.1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 40),
		Text = "",
		AutoButtonColor = false,
	})
	Corner(tabButton, 12)
	Stroke(tabButton, 0.92)

	local activeBar = Create("Frame", {
		Parent = tabButton,
		BackgroundColor3 = Theme.Accent,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 4, 1, -12),
		Position = UDim2.new(0, 8, 0, 6),
		BackgroundTransparency = 1,
	})
	Corner(activeBar, 8)

	Create("TextLabel", {
		Parent = tabButton,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 18, 0, 0),
		Size = UDim2.fromOffset(20, 40),
		Font = Enum.Font.GothamBold,
		Text = tostring(tab.Icon),
		TextColor3 = Theme.Text,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
	})

	Create("TextLabel", {
		Parent = tabButton,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 42, 0, 0),
		Size = UDim2.new(1, -48, 1, 0),
		Font = Enum.Font.GothamSemibold,
		Text = tab.Title,
		TextColor3 = Theme.Text,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
	})

	local page = Create("ScrollingFrame", {
		Parent = rightScroll,
		Name = tab.Title .. "_Page",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -6, 1, 0),
		CanvasSize = UDim2.fromOffset(0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = Theme.Accent,
		Visible = false,
	})
	Padding(page, 2, 4, 2, 2)
	List(page, 10)

	tab.Page = page
	tab.Button = tabButton
	tab.ActiveBar = activeBar

	tabButton.Activated:Connect(function()
		SelectTab(tab)
	end)

	function tab:AddSection(sectionTitle, sectionIcon)
		local section = {}

		local holder = Create("Frame", {
			Parent = page,
			BackgroundColor3 = Theme.Element,
			BackgroundTransparency = 0.08,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 40),
			AutomaticSize = Enum.AutomaticSize.Y,
		})
		Corner(holder, 14)
		Stroke(holder, 0.94)
		Padding(holder, 12, 12, 12, 12)

		Create("TextLabel", {
			Parent = holder,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 18),
			Font = Enum.Font.GothamBold,
			Text = WithIcon(sectionIcon, sectionTitle or "Section"),
			TextColor3 = Theme.Text,
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		local content = Create("ScrollingFrame", {
			Parent = holder,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 0, 0, 26),
			Size = UDim2.new(1, 0, 0, 0),
			CanvasSize = UDim2.fromOffset(0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = Theme.Accent,
		})
		List(content, 8)

		local function Base(height)
			return MakeBaseFrame(content, selfWindow.Theme, height)
		end

		function section:AddButton(data)
			data = data or {}
			local frame = Base(40)

			local btn = Create("TextButton", {
				Parent = frame,
				Name = data.Name or "click",
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, 0),
				Text = "",
				AutoButtonColor = false,
			})

			Create("TextLabel", {
				Parent = btn,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 12, 0, 0),
				Size = UDim2.new(1, -24, 1, 0),
				Font = Enum.Font.GothamSemibold,
				Text = WithIcon(data.Icon, data.Title or "Button"),
				TextColor3 = Theme.Text,
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

		function section:AddToggle(data)
			data = data or {}
			local frame = Base(42)
			local value = data.Default or false

			Create("TextLabel", {
				Parent = frame,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 12, 0, 0),
				Size = UDim2.new(1, -60, 1, 0),
				Font = Enum.Font.GothamSemibold,
				Text = WithIcon(data.Icon, data.Title or "Toggle"),
				TextColor3 = Theme.Text,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left,
			})

			local box = Create("TextButton", {
				Parent = frame,
				BackgroundColor3 = Theme.Element,
				BackgroundTransparency = 0.08,
				BorderSizePixel = 0,
				Text = "",
				Size = UDim2.fromOffset(22, 22),
				Position = UDim2.new(1, -34, 0.5, -11),
				AutoButtonColor = false,
			})
			Corner(box, 7)
			Stroke(box, 0.94)

			local fill = Create("Frame", {
				Parent = box,
				BackgroundColor3 = Theme.Accent,
				BorderSizePixel = 0,
				Size = UDim2.new(1, -6, 1, -6),
				Position = UDim2.new(0, 3, 0, 3),
				Visible = value,
			})
			Corner(fill, 5)

			box.Activated:Connect(function()
				value = not value
				fill.Visible = value
				if data.Callback then
					data.Callback(value)
				end
			end)

			return { Set = function(v) value = v and true or false fill.Visible = value end, Get = function() return value end }
		end

		function section:AddSlider(data)
			data = data or {}
			local min = tonumber(data.Min) or 0
			local max = tonumber(data.Max) or 100
			local value = tonumber(data.Default) or min
			value = Clamp(value, min, max)

			local frame = Base(58)

			Create("TextLabel", {
				Parent = frame,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 12, 0, 0),
				Size = UDim2.new(1, -24, 0, 16),
				Font = Enum.Font.GothamSemibold,
				Text = WithIcon(data.Icon, data.Title or "Slider"),
				TextColor3 = Theme.Text,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left,
			})

			local number = Create("TextLabel", {
				Parent = frame,
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -60, 0, 0),
				Size = UDim2.fromOffset(50, 16),
				Font = Enum.Font.Gotham,
				Text = tostring(value),
				TextColor3 = Theme.SubText,
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Right,
			})

			local bar = Create("Frame", {
				Parent = frame,
				BackgroundColor3 = Theme.Element,
				BackgroundTransparency = 0.08,
				BorderSizePixel = 0,
				Position = UDim2.new(0, 12, 0, 30),
				Size = UDim2.new(1, -24, 0, 12),
			})
			Corner(bar, 8)
			Stroke(bar, 0.95)

			local fill = Create("Frame", {
				Parent = bar,
				BackgroundColor3 = Theme.Accent,
				BorderSizePixel = 0,
				Size = UDim2.new((value - min) / math.max((max - min), 0.0001), 0, 1, 0),
			})
			Corner(fill, 8)

			local dragging = false

			local function Set(v)
				value = Clamp(v, min, max)
				local percent = (value - min) / math.max((max - min), 0.0001)
				fill.Size = UDim2.new(percent, 0, 1, 0)
				number.Text = tostring(math.floor(value))
				if data.Callback then
					data.Callback(value)
				end
			end

			bar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
				end
			end)

			bar.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					local percent = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
					Set(min + ((max - min) * percent))
				end
			end)

			Set(value)
			return { Set = Set, Get = function() return value end }
		end

		function section:AddInput(data)
			data = data or {}
			local frame = Base(52)

			Create("TextLabel", {
				Parent = frame,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 12, 0, 2),
				Size = UDim2.new(1, -24, 0, 16),
				Font = Enum.Font.GothamSemibold,
				Text = WithIcon(data.Icon, data.Title or "Input"),
				TextColor3 = Theme.Text,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left,
			})

			local box = Create("TextBox", {
				Parent = frame,
				BackgroundColor3 = Theme.Element,
				BackgroundTransparency = 0.1,
				BorderSizePixel = 0,
				Position = UDim2.new(0, 12, 0, 24),
				Size = UDim2.new(1, -24, 0, 24),
				ClearTextOnFocus = false,
				Font = Enum.Font.Gotham,
				PlaceholderText = data.Placeholder or "",
				Text = tostring(data.Default or ""),
				TextColor3 = Theme.Text,
				PlaceholderColor3 = Theme.SubText,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left,
			})
			Corner(box, 8)
			Stroke(box, 0.94)
			Padding(box, 0, 0, 10, 10)

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

		function section:AddDropdown(data)
			data = data or {}
			local values = CopyArray(data.Values or {})
			local frame = Base(44)

			local button = Create("TextButton", {
				Parent = frame,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, 0),
				Text = "",
				AutoButtonColor = false,
			})

			local label = Create("TextLabel", {
				Parent = button,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 12, 0, 0),
				Size = UDim2.new(1, -30, 1, 0),
				Font = Enum.Font.GothamSemibold,
				Text = WithIcon(data.Icon, data.Title or "Dropdown"),
				TextColor3 = Theme.Text,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left,
			})

			Create("TextLabel", {
				Parent = button,
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -24, 0, 0),
				Size = UDim2.fromOffset(18, 44),
				Font = Enum.Font.GothamBold,
				Text = "⌄",
				TextColor3 = Theme.SubText,
				TextSize = 18,
			})

			local dropdown = {
				Title = data.Title or "Dropdown",
				Icon = data.Icon,
				Button = button,
				Label = label,
				Callback = data.Callback,
				_selected = nil,
				_values = values,
			}

			local function Sync()
				if data.Multi then
					local sel = dropdown._selected or {}
					local picked = {}
					for _, v in ipairs(dropdown._values) do
						if sel[tostring(v)] then
							table.insert(picked, tostring(v))
						end
					end
					if #picked == 0 then
						label.Text = WithIcon(dropdown.Icon, dropdown.Title) .. " : None"
					else
						label.Text = WithIcon(dropdown.Icon, dropdown.Title) .. " : " .. table.concat(picked, ", ")
					end
				else
					label.Text = WithIcon(dropdown.Icon, dropdown.Title) .. " : " .. tostring(dropdown._selected or data.Default or "Select")
				end
			end

			button.Activated:Connect(function()
				OpenDropdown(dropdown, dropdown._values, data.Multi == true, data.Default, data.NoSearch == true)
			end)

			if data.Default ~= nil then
				dropdown._selected = data.Default
			end
			Sync()

			function dropdown:Refresh(newValues)
				dropdown._values = CopyArray(newValues or {})
				Sync()
			end

			function dropdown:Set(value)
				dropdown._selected = value
				Sync()
			end

			return dropdown
		end

		function section:AddLabel(data)
			data = data or {}
			local frame = Base(36)
			Create("TextLabel", {
				Parent = frame,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 12, 0, 0),
				Size = UDim2.new(1, -24, 1, 0),
				Font = Enum.Font.Gotham,
				Text = WithIcon(data.Icon, data.Text or "Label"),
				TextColor3 = Theme.Text,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left,
			})
		end

		function section:AddParagraph(data)
			data = data or {}
			local frame = Base(60)
			Create("TextLabel", {
				Parent = frame,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 12, 0, 0),
				Size = UDim2.new(1, -24, 1, 0),
				Font = Enum.Font.Gotham,
				Text = (data.Title and (data.Title .. "

") or "") .. tostring(data.Content or ""), TextColor3 = Theme.SubText, TextSize = 12, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, }) end

function section:AddKeybind(data)
			data = data or {}
			local frame = Base(42)
			local key = data.Default or Enum.KeyCode.Unknown

			Create("TextLabel", {
				Parent = frame,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 12, 0, 0),
				Size = UDim2.new(1, -70, 1, 0),
				Font = Enum.Font.GothamSemibold,
				Text = WithIcon(data.Icon, data.Title or "Keybind"),
				TextColor3 = Theme.Text,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left,
			})

			local keyLabel = Create("TextButton", {
				Parent = frame,
				BackgroundColor3 = Theme.Element,
				BackgroundTransparency = 0.1,
				BorderSizePixel = 0,
				Text = tostring(key.Name),
				TextColor3 = Theme.Text,
				Font = Enum.Font.GothamBold,
				TextSize = 12,
				Size = UDim2.fromOffset(56, 22),
				Position = UDim2.new(1, -68, 0.5, -11),
				AutoButtonColor = false,
			})
			Corner(keyLabel, 8)
			Stroke(keyLabel, 0.94)

			local listening = false
			keyLabel.Activated:Connect(function()
				listening = true
				keyLabel.Text = "..."
			end)

			UserInputService.InputBegan:Connect(function(input, gp)
				if gp then return end
				if listening then
					if input.UserInputType == Enum.UserInputType.Keyboard then
						key = input.KeyCode
						keyLabel.Text = tostring(key.Name)
						listening = false
						if data.Callback then data.Callback(key) end
					end
				elseif input.KeyCode == key then
					if data.Callback then data.Callback(key) end
				end
			end)
		end

		function section:AddColorPicker(data)
			data = data or {}
			local frame = Base(44)
			local value = data.Default or Color3.fromRGB(255, 255, 255)

			Create("TextLabel", {
				Parent = frame,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 12, 0, 0),
				Size = UDim2.new(1, -60, 1, 0),
				Font = Enum.Font.GothamSemibold,
				Text = WithIcon(data.Icon, data.Title or "Color"),
				TextColor3 = Theme.Text,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left,
			})

			local swatch = Create("Frame", {
				Parent = frame,
				Size = UDim2.fromOffset(28, 20),
				Position = UDim2.new(1, -40, 0.5, -10),
				BackgroundColor3 = value,
				BorderSizePixel = 0,
			})
			Corner(swatch, 6)
			Stroke(swatch, 0.6)

			swatch.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					local h = (math.random(0, 360) / 360)
					local s = 0.8
					local v = 1
					value = Color3.fromHSV(h, s, v)
					swatch.BackgroundColor3 = value
					if data.Callback then
						data.Callback(value)
					end
				end
			end)
		end

		return section
	end

	table.insert(selfWindow._tabs, tab)
	if not selfWindow._currentTab then
		SelectTab(tab)
	end
	return tab
end

function selfWindow:AddTab(tabData)
	return selfWindow:AddTab(tabData)
end

selfWindow._lastWindow = selfWindow
Library._lastWindow = selfWindow
return selfWindow

end

function Library:Notify(data) if self._lastWindow and self._lastWindow.Notify then self._lastWindow:Notify(data) end end

return Library
