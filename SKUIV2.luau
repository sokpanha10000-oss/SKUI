if getgenv().Nousigi then 
	if game.CoreGui:FindFirstChild("Nousigi Hub GUI") then
		for i, v in ipairs(game.CoreGui:GetChildren()) do
			if string.find(v.Name,  "Nousigi Hub") then
				v:Destroy()
			end
		end
	end
end
getgenv().Nousigi = true

-- =====================================================
-- New() helper: creates an Instance with all properties set at once.
-- Parent is always applied last for safety.
-- =====================================================
local function New(class, props)
	local obj = Instance.new(class)
	local parent = props.Parent
	props.Parent = nil
	for k, v in pairs(props) do
		obj[k] = v
	end
	if parent ~= nil then
		obj.Parent = parent
	end
	return obj
end


local DisableAnimation = game.Players.LocalPlayer.PlayerGui:FindFirstChild('TouchGui')
local T1UIColor = {
	["Border Color"] = Color3.fromRGB(255, 206, 27),
	["Click Effect Color"] = Color3.fromRGB(230, 230, 230),
	["Setting Icon Color"] = Color3.fromRGB(230, 230, 230),
	["Logo Image"] = "rbxassetid://128185233852701",
	["Search Icon Color"] = Color3.fromRGB(240, 240, 230),
	["Search Icon Highlight Color"] = Color3.fromRGB(255, 206, 27),
	["GUI Text Color"] = Color3.fromRGB(235, 235, 230),
	["Text Color"] = Color3.fromRGB(235, 235, 230),
	["Placeholder Text Color"] = Color3.fromRGB(170, 170, 160),
	["Title Text Color"] = Color3.fromRGB(255, 206, 27),
	["Background Main Color"] = Color3.fromRGB(18, 18, 22),
	["Background 1 Color"] = Color3.fromRGB(28, 28, 34),
	["Background 1 Transparency"] = 0.1,
	["Background 2 Color"] = Color3.fromRGB(38, 38, 46),
	["Background 3 Color"] = Color3.fromRGB(48, 48, 56),
	["Background Image"] = "",
	["Page Selected Color"] = Color3.fromRGB(255, 206, 27),
	["Section Text Color"] = Color3.fromRGB(220, 220, 210),
	["Section Underline Color"] = Color3.fromRGB(255, 206, 27),
	["Toggle Border Color"] = Color3.fromRGB(255, 206, 27),
	["Toggle Checked Color"] = Color3.fromRGB(230, 230, 230),
	["Toggle Desc Color"] = Color3.fromRGB(185, 185, 185),
	["Button Color"] = Color3.fromRGB(255, 206, 27),
	["Label Color"] = Color3.fromRGB(38, 38, 42),
	["Dropdown Icon Color"] = Color3.fromRGB(230, 230, 230),
	["Dropdown Selected Color"] = Color3.fromRGB(255, 206, 27),
	["Dropdown Selected Check Color"] = Color3.fromRGB(219, 177, 23),
	["Textbox Highlight Color"] = Color3.fromRGB(255, 206, 27),
	["Box Highlight Color"] = Color3.fromRGB(255, 206, 27),
	["Slider Line Color"] = Color3.fromRGB(255, 206, 27),
	["Slider Highlight Color"] = Color3.fromRGB(194, 156, 20),
	["Tween Animation 1 Speed"] = DisableAnimation and 0 or 0.25,
	["Tween Animation 2 Speed"] = DisableAnimation and 0 or 0.5,
	["Tween Animation 3 Speed"] = DisableAnimation and 0 or 0.1,
	["Text Stroke Transparency"] = 0.5
}

getgenv().UIColor = T1UIColor
getgenv().AllControls = {}
getgenv().UIToggled = false


local currcolor = {}
local Library = {};
local Library_Function = {}
local TweenService = game:GetService('TweenService')
local uis = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local function makeDraggable(topBarObject, object)
	local dragging = nil
	local dragInput = nil
	local dragStart = nil
	local startPosition = nil
	topBarObject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPosition = object.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	topBarObject.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	uis.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			if not djtmemay and cac then
				TweenService:Create(object, TweenInfo.new(DisableAnimation and 0 or 0.35, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
					Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
				}):Play()
			elseif not djtmemay and not cac then
				object.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
			end
		end
	end)
end

Library_Function.Gui = New('ScreenGui', {
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	Name = 'Nousigi Hub GUI',
	Enabled = false,
})

getgenv().ReadyForGuiLoaded = false
spawn(function()
	repeat
		task.wait()
	until getgenv().ReadyForGuiLoaded
	if getgenv().UIToggled then
		Library_Function.Gui.Enabled = true
	end
end)


Library_Function.NotiGui = New('ScreenGui', {
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	Name = 'Nousigi Hub Notification',
})

Library_Function.HideGui = New('ScreenGui', {
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	Name = 'Nousigi Hub Btn',
})


local btnHide = New("TextButton", {
	BackgroundTransparency = 1,
	Text = "",
	AnchorPoint = Vector2.new(0, 1),
	Size = UDim2.new(0, 50, 0, 50),
	Position = UDim2.new(0, 15, 1, -15),
	Parent = Library_Function.HideGui,
})

local btnHideFrame = New("Frame", {
	AnchorPoint = Vector2.new(0, 1),
	Size = UDim2.new(0, 50, 0, 50),
	Position = UDim2.new(0, 0, 1, 0),
	Name = "dut dit",
	BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	BackgroundTransparency = getgenv().UIToggled and 0 or .25,
	Parent = btnHide,
})

local imgHide = New("ImageLabel", {
	AnchorPoint = Vector2.new(.5, .5),
	Image = getgenv().UIColor["Logo Image"],
	BackgroundTransparency = 1,
	Size = UDim2.new(0, getgenv().UIToggled and (getgenv().T1 and 30 or 40) or (getgenv().T1 and 25 or 30), 0, getgenv().UIToggled and (getgenv().T1 and 30 or 40) or (getgenv().T1 and 25 or 30)),
	Position = UDim2.new(.5, 0, .5, 0),
	Parent = btnHide,
})

local UICornerBtnHide = New("UICorner", {
	CornerRadius = UDim.new(1, 0),
	Parent = btnHideFrame,
})

Library.ToggleUI = function()
	getgenv().UIToggled = not getgenv().UIToggled
	local sizeXY = getgenv().UIToggled and (getgenv().T1 and 30 or 40) or (getgenv().T1 and 25 or 30)
	TweenService:Create(imgHide, TweenInfo.new(DisableAnimation and 0 or .25), {
		Size = UDim2.new(0, sizeXY, 0, sizeXY)
	}):Play()
	TweenService:Create(btnHideFrame, TweenInfo.new(DisableAnimation and 0 or .25), {
		BackgroundTransparency = getgenv().UIToggled and 0 or .25
	}):Play()
	if game.CoreGui:FindFirstChild("Nousigi Hub GUI") then
		for a, b in ipairs(game.CoreGui:GetChildren()) do
			if b.Name == "Nousigi Hub GUI" then
				b.Enabled = getgenv().UIToggled
			end
		end
	end
end

Library.DestroyUI = function()
	if game.CoreGui:FindFirstChild("Nousigi Hub GUI") then
		for i, v in ipairs(game.CoreGui:GetChildren()) do
			if string.find(v.Name,  "Nousigi Hub") then
				v:Destroy()
			end
		end
	end
end

if true then
	local button = btnHide -- Assuming this is a TextButton or ImageButton
	local UIS = game:GetService("UserInputService")
	
	local dragging = false
	local dragInput, dragStart, startPos
	local holdTime = 0.1 -- Time to hold before dragging is enabled
	local holdStarted = 0
	
	-- Function to update the button's position
	local function update(input)
		local delta = input.Position - dragStart
		button.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
	
	-- Function to detect the start of dragging (for both mouse and touch)
	local function onInputBegan(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			holdStarted = tick() -- Record the time when holding starts
			dragStart = input.Position
			startPos = button.Position
	
			-- Listen for release to stop dragging
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					holdStarted = 0 -- Reset the hold timer
				end
			end)
		end
	end
	
	-- Function to detect when dragging stops
	local function onInputEnded(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
			holdStarted = 0 -- Reset the hold timer
		end
	end
	
	-- Detect input movement (for both mouse and touch)
	local function onInputChanged(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end
	
	-- Connect the events
	button.InputBegan:Connect(onInputBegan)
	button.InputEnded:Connect(onInputEnded)
	button.InputChanged:Connect(onInputChanged)
	
	-- RenderStepped updates the position while dragging
	RunService.RenderStepped:Connect(function()
		if holdStarted > 0 and (tick() - holdStarted >= holdTime) and not dragging then
			dragging = true
		end
	
		if dragging and dragInput then
			update(dragInput)
		end
	end)
		
end

btnHide.MouseButton1Click:Connect(function() 
	Library.ToggleUI()
end)

local NotiContainer = New("Frame", {
	Name = "NotiContainer",
	AnchorPoint = Vector2.new(1, 1),
	BackgroundColor3 = Color3.fromRGB(230, 230, 230),
	BackgroundTransparency = 1.000,
	Position = UDim2.new(1, -5, 1, -5),
	Size = UDim2.new(0, 350, 1, -10),
	Parent = Library_Function.NotiGui,
})
local NotiList = New("UIListLayout", {
	Name = "NotiList",
	SortOrder = Enum.SortOrder.LayoutOrder,
	VerticalAlignment = Enum.VerticalAlignment.Bottom,
	Padding = UDim.new(0, 5),
	Parent = NotiContainer,
})


Library_Function.Gui.Parent = game:GetService('CoreGui')
Library_Function.NotiGui.Parent = game:GetService('CoreGui')
Library_Function.HideGui.Parent = game:GetService('CoreGui')

function Library_Function.Getcolor(color)
	return {
		math.floor(color.r * 255),
		math.floor(color.g * 255),
		math.floor(color.b * 255)
	}
end

local libCreateNoti = function(Setting)
	getgenv().TitleNameNoti = Setting.Title or ""; 
	local Description = Setting.Description or Setting.Desc or Setting.Content or ""; 
	local Duration = Setting.Duration or Setting.Timeshow or Setting.Delay or 10;

	local NotiFrame = New("Frame", {
		Name = "NotiFrame",
		BackgroundColor3 = Color3.fromRGB(230, 230, 230),
		BackgroundTransparency = 1.000,
		ClipsDescendants = true,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = NotiContainer,
	})
	local Noticontainer = New("Frame", {
		Name = "Noticontainer",
		Position = UDim2.new(1, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 6),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = getgenv().UIColor["Background 3 Color"],
		Parent = NotiFrame,
	})
	local UICorner = New("UICorner", {
		CornerRadius = UDim.new(0, 4),
		Parent = Noticontainer,
	})
	local Topnoti = New("Frame", {
		Name = "Topnoti",
		BackgroundColor3 = Color3.fromRGB(230, 230, 230),
		BackgroundTransparency = 1.000,
		Position = UDim2.new(0, 0, 0, 5),
		Size = UDim2.new(1, 0, 0, 25),
		Parent = Noticontainer,
	})
	local Ruafimg = New("ImageLabel", {
		Name = "Ruafimg",
		BackgroundColor3 = Color3.fromRGB(230, 230, 230),
		BackgroundTransparency = 1.000,
		Position = UDim2.new(0, 5, 0, getgenv().T1 and 5 or 0),
		Size = UDim2.new(0, getgenv().T1 and 30 or 25, 0, getgenv().T1 and 15 or 25),
		Image = getgenv().UIColor["Logo Image"],
		Parent = Topnoti,
	})
	local RuafimgCorner = New("UICorner", {
		CornerRadius = UDim.new(1, 0),
		Name = "RuafimgCorner",
		Parent = Ruafimg,
	})
	local TextLabelNoti = New("TextLabel", {
	})
	local CloseContainer = New("Frame", {
	})
	local CloseImage = New("ImageLabel", {
	})
	local TextButton = New("TextButton", {
	})
	local TextLabelNoti2 = New("TextLabel", {
	})
	
	local colorR = tostring(Library_Function.Getcolor(getgenv().UIColor['Title Text Color'])[1])
	local colorG = tostring(Library_Function.Getcolor(getgenv().UIColor['Title Text Color'])[2])
	local colorB = tostring(Library_Function.Getcolor(getgenv().UIColor['Title Text Color'])[3])
	local color = colorR .. ',' .. colorG .. ',' .. colorB
    TextLabelNoti.Text = "<font color=\"rgb(" .. tostring(color or "255,206,27") .. ")\">" .. tostring("Night Slayer Hub") .. "</font> " .. tostring(getgenv().TitleNameNoti or "")
    
	TextLabelNoti.Name = "TextLabelNoti"
	TextLabelNoti.Parent = Topnoti
	TextLabelNoti.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
	TextLabelNoti.BackgroundTransparency = 1.000
	TextLabelNoti.Position = UDim2.new(0, getgenv().T1 and 40 or 35, 0, 0)
	TextLabelNoti.Size = UDim2.new(1, getgenv().T1 and -40 or -35, 1, 0)
	TextLabelNoti.Font = Enum.Font.GothamBold
	TextLabelNoti.TextSize = 14.000
	TextLabelNoti.TextWrapped = true
	TextLabelNoti.TextXAlignment = Enum.TextXAlignment.Left
	TextLabelNoti.RichText = true
	TextLabelNoti.TextColor3 = getgenv().UIColor["GUI Text Color"]

	CloseContainer.Name = "CloseContainer"
	CloseContainer.Parent = Topnoti
	CloseContainer.AnchorPoint = Vector2.new(1, 0.5)
	CloseContainer.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
	CloseContainer.BackgroundTransparency = 1.000
	CloseContainer.Position = UDim2.new(1, -4, 0.5, 0)
	CloseContainer.Size = UDim2.new(0, 22, 0, 22)

	CloseImage.Name = "CloseImage"
	CloseImage.Parent = CloseContainer
	CloseImage.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
	CloseImage.BackgroundTransparency = 1.000
	CloseImage.Size = UDim2.new(1, 0, 1, 0)
	CloseImage.Image = "rbxassetid://3926305904"
	CloseImage.ImageRectOffset = Vector2.new(284, 4)
	CloseImage.ImageRectSize = Vector2.new(24, 24)
	CloseImage.ImageColor3 = getgenv().UIColor["Search Icon Color"]

	TextButton.Parent = CloseContainer
	TextButton.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
	TextButton.BackgroundTransparency = 1.000
	TextButton.Size = UDim2.new(1, 0, 1, 0)
	TextButton.Font = Enum.Font.SourceSans
	TextButton.Text = ""
	TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
	TextButton.TextSize = 14.000

	if Description then
		TextLabelNoti2.Name = 'TextColor'
		TextLabelNoti2.Parent = Noticontainer
		TextLabelNoti2.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
		TextLabelNoti2.BackgroundTransparency = 1.000
		TextLabelNoti2.Position = UDim2.new(0, 10, 0, 35)
		TextLabelNoti2.Size = UDim2.new(1, -15, 0, 0)
		TextLabelNoti2.Font = Enum.Font.GothamBold
		TextLabelNoti2.Text = Description
		TextLabelNoti2.TextSize = 14.000
		TextLabelNoti2.TextXAlignment = Enum.TextXAlignment.Left
		TextLabelNoti2.RichText = true
		TextLabelNoti2.TextColor3 = getgenv().UIColor["Text Color"]
		TextLabelNoti2.AutomaticSize = Enum.AutomaticSize.Y
		TextLabelNoti2.TextWrapped = true
	end

	local function remove()
		TweenService:Create(Noticontainer, TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
			Position = UDim2.new(1, 0, 0, 0)
		}):Play()
		wait(.25)
		NotiFrame:Destroy()
	end

	TweenService:Create(Noticontainer, TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
		Position = UDim2.new(0, 0, 0, 0)
	}):Play()

	TextButton.MouseEnter:Connect(function()
		TweenService:Create(CloseImage, TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
			ImageColor3 = getgenv().UIColor["Search Icon Highlight Color"]
		}):Play()
	end)

	TextButton.MouseLeave:Connect(function()
		TweenService:Create(CloseImage, TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
			ImageColor3 = getgenv().UIColor["Search Icon Color"]
		}):Play()
	end)

	TextButton.MouseButton1Click:Connect(function()
		wait(.25)
		remove()
	end)

	spawn(function()
		wait(Duration)
		remove()
	end)

end

function Library:Notify(Setting, bypass)
	if not getgenv().Config or bypass then
		local s, e = pcall(function()
			libCreateNoti(Setting)
		end)
		if e then
			print(e)
		end
	end
end

function Library:CreateWindow(Setting)
    local TitleNameMain = Setting.Title or "Night Slayer Hub"
    local AuthorText = Setting.Author and (" | " .. tostring(Setting.Author)) or ""
    getgenv().MainDesc = (Setting.Desc or Setting.Subtitle or "") .. AuthorText
    
    if Setting.Image then
        getgenv().UIColor["Logo Image"] = Setting.Image
    end
    
	local djtmemay = false
	cac = false

	local Main = New("Frame", {
	})
	local maingui = New("ImageLabel", {
	})
	local MainCorner = New("UICorner", {
	})
	local TopMain = New("Frame", {
	})
	local Ruafimg = New("ImageLabel", {
	})
	local TextLabelMain = New("TextLabel", {
	})
	local PageControl = New("Frame", {
	})
	local UICorner = New("UICorner", {
	})
	local ControlList = New("ScrollingFrame", {
	})
	local UIListLayout = New("UIListLayout", {
	})
	local ControlTitle = New("TextLabel", {
	})
	local MainPage = New("Frame", {
	})
	local UIPage = New("UIPageLayout", {
	})
	local Concacontainer = New("Frame", {
	})
	local Concacmain = New("Frame", {
	})
	local MainContainer

	Main.Name = "Main"
	Main.Parent = Library_Function.Gui
	Main.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
	Main.BackgroundTransparency = 1.000
	Main.Position = UDim2.new(0.5, 0, 0.5, 0)
	Main.AnchorPoint = Vector2.new(0.5, 0.5)
	Main.Size = UDim2.new(0, 629, 0, 359)

	makeDraggable(Main, Main)

	maingui.Name = "maingui"
	maingui.Parent = Main
	maingui.AnchorPoint = Vector2.new(0.5, 0.5)
	maingui.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
	maingui.BackgroundTransparency = 1.000
	maingui.Position = UDim2.new(0.5, 0, 0.5, 0)
	maingui.Selectable = true
	maingui.Size = UDim2.new(1, 30, 1, 30)
	maingui.Image = "rbxassetid://8068653048"
	maingui.ScaleType = Enum.ScaleType.Slice
	maingui.SliceCenter = Rect.new(15, 15, 175, 175)
	maingui.SliceScale = 1.300
	maingui.ImageColor3 = getgenv().UIColor["Border Color"]
	maingui.ImageTransparency = 1

	maingui.ImageColor3 = getgenv().UIColor['Title Text Color']

	MainContainer = New("ImageLabel", {
		Name = "MainContainer",
		BackgroundColor3 = Color3.fromRGB(18, 18, 22),
		Size = UDim2.new(1, 0, 1, 0),
		Parent = Main,
	})

	local uistr = New("UIStroke", {
		Thickness = 1,
		Color = Color3.fromRGB(90, 90, 70),
		Parent = MainContainer,
	})

	local uigradient = New("UIGradient", {
		Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
			},
		Rotation = 90,
		Transparency = NumberSequence.new{
			NumberSequenceKeypoint.new(0, 0.92),
			NumberSequenceKeypoint.new(1, 0.92)
			},
		Parent = MainContainer,
	})

	getgenv().ReadyForGuiLoaded = true
	
	MainCorner.CornerRadius = UDim.new(0, 5)
	MainCorner.Name = "MainCorner"
	MainCorner.Parent = MainContainer

	Concacontainer.Name = "Concacontainer"
	Concacontainer.Parent = MainContainer
	Concacontainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Concacontainer.BackgroundTransparency = 1.000
	Concacontainer.ClipsDescendants = true
	Concacontainer.Position = UDim2.new(0, 0, 0, 30)
	Concacontainer.Size = UDim2.new(1, 0, 1, -30)
	
	Concacmain.Name = "Concacmain"
	Concacmain.Parent = Concacontainer
	Concacmain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Concacmain.BackgroundTransparency = 1.000
	Concacmain.Selectable = true
	Concacmain.Size = UDim2.new(1, 0, 1, 0)
	
	TopMain.Name = "TopMain"
	TopMain.Parent = MainContainer
	TopMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TopMain.BackgroundTransparency = 1.000
	TopMain.Size = UDim2.new(1, 0, 0, 25)
	
	local TopStroke = New("Frame", {
		Name = "TopStroke",
		BackgroundColor3 = Color3.fromRGB(90, 90, 70),
		BackgroundTransparency = 0.6,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 1, -1),
		Size = UDim2.new(1, 0, 0, 1),
		Parent = TopMain,
	})
	
	Ruafimg.Name = "Ruafimg"
	Ruafimg.Parent = TopMain
	Ruafimg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Ruafimg.BackgroundTransparency = 1.000
	Ruafimg.Position = UDim2.new(0, 5, 0, 0)
	Ruafimg.Size = UDim2.new(0, 25, 0, 25)
	Ruafimg.Image = getgenv().UIColor["Logo Image"]

	TextLabelMain.Name = "TextLabelMain"
	TextLabelMain.Parent = TopMain
	TextLabelMain.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
	TextLabelMain.BackgroundTransparency = 1.000
	TextLabelMain.Position = UDim2.new(0, 220, 0, 0)
	TextLabelMain.Size = UDim2.new(1, -35, 1, 0)
	TextLabelMain.Font = Enum.Font.GothamBold
	TextLabelMain.RichText = true
	TextLabelMain.TextSize = 16.000
	TextLabelMain.TextWrapped = true
	TextLabelMain.TextXAlignment = Enum.TextXAlignment.Left
	TextLabelMain.TextColor3 = getgenv().UIColor["GUI Text Color"]

	local colorR = tostring(Library_Function.Getcolor(getgenv().UIColor['Title Text Color'])[1])
	local colorG = tostring(Library_Function.Getcolor(getgenv().UIColor['Title Text Color'])[2])
	local colorB = tostring(Library_Function.Getcolor(getgenv().UIColor['Title Text Color'])[3])
	local color = colorR .. ',' .. colorG .. ',' .. colorB
    TextLabelMain.Text = "<font color=\"rgb(" .. tostring(color or "255,206,27") .. ")\">" .. tostring(TitleNameMain or "Night Slayer Hub") .. "</font> " .. tostring(getgenv().MainDesc or "")

	PageControl.Name = "Background1"
	PageControl.Parent = Concacmain
	PageControl.Position = UDim2.new(0, 5, 0, 0)
	PageControl.Size = UDim2.new(0, 180, 0, 325)
	PageControl.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
	PageControl.BackgroundTransparency = 0.1

	local pageControlStroke = New("UIStroke", {
		Color = Color3.fromRGB(90, 90, 70),
		Thickness = 1,
		Parent = PageControl,
	})

	local pageControlGradient = New("UIGradient", {
		Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 28, 34)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(38, 38, 46))
			},
		Rotation = 90,
		Transparency = NumberSequence.new{
			NumberSequenceKeypoint.new(0, 0.06),
			NumberSequenceKeypoint.new(1, 0.12)
			},
		Parent = PageControl,
	})

	UICorner.CornerRadius = UDim.new(0, 4)
	UICorner.Parent = PageControl

	ControlList.Name = "ControlList"
	ControlList.Parent = PageControl
	ControlList.Active = true
	ControlList.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
	ControlList.BackgroundTransparency = 1.000
	ControlList.BorderColor3 = Color3.fromRGB(27, 42, 53)
	ControlList.BorderSizePixel = 0
	ControlList.Position = UDim2.new(0, 0, 0, 30)
	ControlList.Size = UDim2.new(1, -5, 1, -30)
	ControlList.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
	ControlList.CanvasSize = UDim2.new(0, 0, 0, 0)
	ControlList.ScrollBarThickness = 5
	ControlList.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"

	UIListLayout.Parent = ControlList
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)

	ControlTitle.Name = "GUITextColor"
	ControlTitle.Parent = PageControl
	ControlTitle.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
	ControlTitle.BackgroundTransparency = 1.000
	ControlTitle.Position = UDim2.new(0, 5, 0, 0)
	ControlTitle.Size = UDim2.new(1, 0, 0, 25)
	ControlTitle.Font = Enum.Font.GothamBold
	ControlTitle.Text = TitleNameMain
	ControlTitle.TextSize = 14.000
	ControlTitle.TextXAlignment = Enum.TextXAlignment.Left
	ControlTitle.TextColor3 = getgenv().UIColor["GUI Text Color"]

	local PageSearch = New("Frame", {
		Name = "PageSearch",
		AnchorPoint = Vector2.new(1, 0),
		BackgroundColor3 = Color3.fromRGB(38, 38, 46),
		Position = UDim2.new(1, -5, 0, 5),
		Size = UDim2.new(0, 170, 0, 25),
		ClipsDescendants = true,
		Parent = PageControl,
	})
	local PageSearchCorner = New("UICorner", {
		CornerRadius = UDim.new(0, 4),
		Parent = PageSearch,
	})
	local SearchFrame = New("Frame", {
		Name = "SearchFrame",
		BackgroundColor3 = Color3.fromRGB(163, 162, 165),
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 25, 1, 0),
		Parent = PageSearch,
	})
	local SearchIcon = New("ImageLabel", {
		Name = "SearchIcon",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(163, 162, 165),
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 16, 0, 16),
		Image = "rbxassetid://8154282545",
		ImageColor3 = Color3.fromRGB(240, 240, 230),
		Parent = SearchFrame,
	})
	local SearchBox = New("TextBox", {
		Name = "SearchBox",
		Active = true,
		BackgroundColor3 = Color3.fromRGB(163, 162, 165),
		BackgroundTransparency = 1,
		CursorPosition = -1,
		Position = UDim2.new(0, 30, 0, 0),
		Size = UDim2.new(1, -30, 1, 0),
		Font = Enum.Font.GothamBold,
		PlaceholderColor3 = Color3.fromRGB(170, 170, 160),
		PlaceholderText = "Search section or Function...",
		Text = "",
		TextColor3 = Color3.fromRGB(235, 235, 230),
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = PageSearch,
	})

	MainPage.Name = "MainPage"
	MainPage.Parent = Concacmain
	MainPage.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
	MainPage.BackgroundTransparency = 1.000
	MainPage.ClipsDescendants = true
	MainPage.Position = UDim2.new(0, 190, 0, 0)
	MainPage.Size = UDim2.new(0, 435, 0, 325)

	UIPage.Name = "UIPage"
	UIPage.Parent = MainPage
	UIPage.FillDirection = Enum.FillDirection.Vertical
	UIPage.SortOrder = Enum.SortOrder.LayoutOrder
	UIPage.EasingDirection = Enum.EasingDirection.InOut
	UIPage.EasingStyle = Enum.EasingStyle.Quart
	UIPage.Padding = UDim.new(0, 10)
	UIPage.TweenTime = getgenv().UIColor["Tween Animation 1 Speed"]

	UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		ControlList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 5)
	end)

	local Shadow = New("ImageLabel", {
		Name = "Shadow",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(163, 162, 165),
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(1, 40, 1, 40),
		ZIndex = 0,
		Image = "rbxassetid://5028857084",
		ImageTransparency = 0.35,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(24, 24, 276, 276),
		Parent = Main,
	})

    -- Thêm biến để lưu thông tin section
    local sectionInfo = {}
    
    -- Tạo hàm GlobalSearch nếu chưa tồn tại
    if not GlobalSearch then
        GlobalSearch = function(searchText)
            searchText = string.lower(searchText)
            
            if searchText == "" then
                -- Hiển thị tất cả như cũ
                for _, control in pairs(getgenv().AllControls) do
                    control.TabButton.Visible = true
                    control.Section.Visible = true
                    control.Element.Visible = true
                end
                -- Hiển thị tất cả tab
                for _, tab in pairs(ControlList:GetChildren()) do
                    if not tab:IsA('UIListLayout') then
                        tab.Visible = true
                    end
                end
                return
            end
            
            -- Ẩn tất cả trước
            for _, control in pairs(getgenv().AllControls) do
                control.Section.Visible = false
                control.Element.Visible = false
            end
            
            -- Ẩn tất cả tab
            for _, tab in pairs(ControlList:GetChildren()) do
                if not tab:IsA('UIListLayout') then
                    tab.Visible = false
                end
            end
            
            -- Tạo bản đồ section
            local sectionsWithElements = {}
            local elementsInSection = {}
            
            -- Phân tích từng control
            for _, control in pairs(getgenv().AllControls) do
                local elementName = string.lower(control.Name or "")
                local sectionName = string.lower(control.SectionName or "")
                
                -- Kiểm tra phần tử (sử dụng string.find thay vì string.match)
                local elementFound = string.find(elementName, searchText, 1, true) ~= nil
                -- Kiểm tra section
                local sectionFound = string.find(sectionName, searchText, 1, true) ~= nil
                
                -- Tạo bản đồ section
                if not elementsInSection[control.Section] then
                    elementsInSection[control.Section] = {}
                end
                table.insert(elementsInSection[control.Section], {
                    control = control,
                    elementFound = elementFound,
                    sectionFound = sectionFound
                })
                
                -- Đánh dấu section có phần tử khớp
                if elementFound then
                    sectionsWithElements[control.Section] = true
                end
            end
            
            -- Xử lý hiển thị
            local foundTabs = {}
            
            for section, elements in pairs(elementsInSection) do
                local shouldShowSection = false
                local hasElementMatch = false
                
                -- Kiểm tra section có khớp không
                for _, elementInfo in ipairs(elements) do
                    if elementInfo.sectionFound then
                        shouldShowSection = true
                    end
                    if elementInfo.elementFound then
                        hasElementMatch = true
                    end
                end
                
                -- Logic hiển thị
                for _, elementInfo in ipairs(elements) do
                    local control = elementInfo.control
                    
                    if elementInfo.elementFound then
                        -- Phần tử khớp: hiển thị phần tử
                        control.Element.Visible = true
                        
                        -- Nếu section cũng khớp hoặc có phần tử khớp: hiện section
                        if elementInfo.sectionFound or hasElementMatch then
                            control.Section.Visible = true
                        end
                        
                        foundTabs[control.TabName] = true
                        control.TabButton.Visible = true
                    elseif elementInfo.sectionFound and not hasElementMatch then
                        -- Section khớp nhưng không có phần tử khớp: chỉ hiện section
                        control.Section.Visible = true
                        control.Element.Visible = false
                        
                        foundTabs[control.TabName] = true
                        control.TabButton.Visible = true
                    end
                end
            end
            
            -- Hiển thị các tab có kết quả
            for tabName, _ in pairs(foundTabs) do
                for _, tab in pairs(ControlList:GetChildren()) do
                    if not tab:IsA('UIListLayout') and string.find(tab.Name, tabName, 1, true) then
                        tab.Visible = true
                    end
                end
            end
            
            -- Nếu không tìm thấy gì cả, hiển thị thông báo
            if not next(foundTabs) then
                -- Có thể thêm thông báo "Không tìm thấy kết quả" ở đây nếu muốn
            end
        end
    end
    
    -- Kết nối sự kiện search (giữ nguyên)
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        GlobalSearch(SearchBox.Text)
    end)

	local Main_Function = {}

	local LayoutOrderBut = -1
	local LayoutOrder = -1
	local PageCounter = 1

	function Main_Function:AddTab(PageName)

		local Page_Name = tostring(PageName)
		local Page_Title = Page_Name

		LayoutOrder = LayoutOrder + 1
		LayoutOrderBut = LayoutOrderBut + 1

		--Control 
		local PageName = New("Frame", {
			Name = Page_Name .. "_Control",
			BackgroundColor3 = Color3.fromRGB(230, 230, 230),
			BackgroundTransparency = 1.000,
			Size = UDim2.new(1, -10, 0, 25),
			LayoutOrder = LayoutOrderBut,
			Parent = ControlList,
		})
		local Frame = New("Frame", {
			BackgroundColor3 = Color3.fromRGB(230, 230, 230),
			BackgroundTransparency = 1.000,
			Position = UDim2.new(0, 5, 0, 0),
			Size = UDim2.new(1, -5, 1, 0),
			Parent = PageName,
		})
		local TabNameCorner = New("UICorner", {
			CornerRadius = UDim.new(0, 4),
			Name = "TabNameCorner",
			Parent = Frame,
		})
		local Line = New("Frame", {
			Name = "Line",
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundColor3 = Color3.fromRGB(230, 230, 230),
			BackgroundTransparency = 1.000,
			Position = UDim2.new(0, 0, 0.5, 0),
			Size = UDim2.new(0, 14, 1, 0),
			Parent = Frame,
		})
		local InLine = New("Frame", {
			Name = "PageInLine",
			AnchorPoint = Vector2.new(0.5, 0.5),
			BorderSizePixel = 0,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(1, -10, 1, -10),
			BackgroundColor3 = getgenv().UIColor["Page Selected Color"],
			BackgroundTransparency = 1.000,
			Parent = Line,
		})
		local LineCorner = New("UICorner", {
			Name = "LineCorner",
			Parent = InLine,
		})
		local TabTitleContainer = New("Frame", {
			Name = "TabTitleContainer",
			BackgroundColor3 = Color3.fromRGB(230, 230, 230),
			BackgroundTransparency = 1.000,
			Position = UDim2.new(0, 15, 0, 0),
			Size = UDim2.new(1, -15, 1, 0),
			Parent = Frame,
		})
		local TabTitle = New("TextLabel", {
			Name = "GUITextColor",
			BackgroundColor3 = Color3.fromRGB(230, 230, 230),
			BackgroundTransparency = 1.000,
			Size = UDim2.new(1, 0, 1, 0),
			Font = Enum.Font.GothamBold,
			Text = Page_Name,
			TextColor3 = getgenv().UIColor["GUI Text Color"],
			TextSize = 14.000,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = TabTitleContainer,
		})
		local PageButton = New("TextButton", {
			Name = "PageButton",
			BackgroundColor3 = Color3.fromRGB(230, 230, 230),
			BackgroundTransparency = 1.000,
			Size = UDim2.new(1, 0, 1, 0),
			Font = Enum.Font.SourceSans,
			Text = "",
			TextColor3 = Color3.fromRGB(0, 0, 0),
			TextSize = 14.000,
			Parent = PageName,
		})

		-- Container

		local PageContainer = New("Frame", {
		})
		local UICorner = New("UICorner", {
		})
		local PageTitle = New("TextLabel", {
		})
		local PageList = New("ScrollingFrame", {
		})
		local Pagelistlayout = New("UIListLayout", {
		})

		local CurrentPage = PageCounter
		PageCounter = PageCounter + 1
		PageContainer.Name = "Page" .. CurrentPage
		PageContainer.Parent = MainPage
		PageContainer.BackgroundColor3 = getgenv().UIColor["Background 1 Color"]
		PageContainer.Position = UDim2.new(0, 190, 0, 30)
		PageContainer.Size = UDim2.new(0, 435, 0, 325)
		PageContainer.LayoutOrder = LayoutOrder
		PageContainer.BackgroundTransparency = getgenv().UIColor["Background 1 Transparency"]

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = PageContainer

		PageTitle.Name = "GUITextColor"
		PageTitle.Parent = PageContainer
		PageTitle.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
		PageTitle.BackgroundTransparency = 1.000
		PageTitle.Position = UDim2.new(0, 5, 0, 0)
		PageTitle.Size = UDim2.new(1, 0, 0, 25)
		PageTitle.Font = Enum.Font.GothamBold
		PageTitle.Text = Page_Title
		PageTitle.TextSize = 16.000
		PageTitle.TextXAlignment = Enum.TextXAlignment.Left
		PageTitle.TextColor3 = getgenv().UIColor["GUI Text Color"]

		PageList.Name = "PageList"
		PageList.Parent = PageContainer
		PageList.Active = true
		PageList.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
		PageList.BackgroundTransparency = 1.000
		PageList.BorderColor3 = Color3.fromRGB(27, 42, 53)
		PageList.BorderSizePixel = 0
		PageList.Position = UDim2.new(0, 5, 0, 30)
		PageList.Size = UDim2.new(1, -10, 1, -30)
		PageList.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
		PageList.ScrollBarThickness = 5
		PageList.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
		PageList.ScrollingEnabled = true
		PageList.VerticalScrollBarInset = Enum.ScrollBarInset.Always

		Pagelistlayout.Name = "Pagelistlayout"
		Pagelistlayout.Parent = PageList
		Pagelistlayout.SortOrder = Enum.SortOrder.LayoutOrder
		Pagelistlayout.Padding = UDim.new(0, 5)
		Pagelistlayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			PageList.CanvasSize = UDim2.new(0, 0, 0, Pagelistlayout.AbsoluteContentSize.Y)
		end)

		local PageSearch = New("Frame", {
			Name = "Page Search",
			AnchorPoint = Vector2.new(1, 0),
			BackgroundColor3 = getgenv().UIColor["Background 2 Color"],
			Position = UDim2.new(1, -5, 0, 5),
			Size = UDim2.new(0, 20, 0, 20),
			ClipsDescendants = true,
			Parent = PageContainer,
		})
		local PageSearchCorner = New("UICorner", {
			CornerRadius = UDim.new(0, 2),
			Name = "PageSearchCorner",
			Parent = PageSearch,
		})
		local SearchFrame = New("Frame", {
			Name = "SearchFrame",
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			Size = UDim2.new(0, 20, 0, 20),
			Parent = PageSearch,
		})
		local SearchIcon = New("ImageLabel", {
			Name = "SearchIcon",
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, 16, 0, 16),
			Image = "rbxassetid://8154282545",
			ImageColor3 = getgenv().UIColor["Search Icon Color"],
			Parent = SearchFrame,
		})
		local SearchButton = New("TextButton", {
			Name = "Search Button",
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			Size = UDim2.new(1, 0, 1, 0),
			Font = Enum.Font.SourceSans,
			Text = "",
			TextColor3 = Color3.fromRGB(0, 0, 0),
			TextSize = 14.000,
			Parent = SearchFrame,
		})
		local SearchBox = New("TextBox", {
			Name = "Search Box",
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			Position = UDim2.new(0, 30, 0, 0),
			Size = UDim2.new(1, -30, 1, 0),
			Font = Enum.Font.GothamBold,
			Text = "",
			TextSize = 14.000,
			TextXAlignment = Enum.TextXAlignment.Left,
			PlaceholderText = "Search Section name",
			PlaceholderColor3 = getgenv().UIColor["Placeholder Text Color"],
			TextColor3 = getgenv().UIColor["Text Color"],
			Parent = PageSearch,
		})
		
		local Openned = false 

		SearchButton.MouseEnter:Connect(function()
			TweenService:Create(SearchIcon, TweenInfo.new(getgenv().UIColor["Tween Animation 3 Speed"]), {
				ImageColor3 = getgenv().UIColor["Search Icon Highlight Color"]
			}):Play()
		end)

		SearchButton.MouseLeave:Connect(function()
			TweenService:Create(SearchIcon, TweenInfo.new(getgenv().UIColor["Tween Animation 3 Speed"]), {
				ImageColor3 = getgenv().UIColor["Search Icon Color"]
			}):Play()
		end)

		SearchButton.MouseButton1Click:Connect(function()
			Openned = not Openned
			local size = Openned and UDim2.new(0, 175, 0, 20) or  UDim2.new(0, 20, 0, 20)
			game.TweenService:Create(PageSearch, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
				Size = size
			}):Play()
		end)

		local function hideOtherFrame()
			for i, v in next, PageList:GetChildren() do 
				if not v:IsA('UIListLayout') then 
					v.Visible = false
				end
			end
		end
		
		local function showFrameName()
			for i, v in pairs(PageList:GetChildren()) do
				if not v:IsA('UIListLayout') then 
					if string.find(string.lower(v.Name), string.lower(SearchBox.Text)) then 
						v.Visible = true
					end
				end
			end
		end
		
		SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
			hideOtherFrame()
			showFrameName()
		end)

		for i, v in pairs(ControlList:GetChildren()) do
			if not (v:IsA('UIListLayout')) then
				if i == 2 then 
					v.Frame.Line.PageInLine.BackgroundTransparency = 0
				end
			end
		end

		PageButton.MouseButton1Click:Connect(function()
			if tostring(UIPage.CurrentPage) == PageContainer.Name then 
				return
			end

			for i, v in pairs(MainPage:GetChildren()) do
				if not (v:IsA('UIPageLayout')) and not (v:IsA('UICorner')) then
					v.Visible = false
				end
			end

			PageContainer.Visible = true 
			UIPage:JumpTo(PageContainer)

			for i, v in next, ControlList:GetChildren() do
				if not (v:IsA('UIListLayout')) then
					if v.Name == Page_Name .. "_Control" then 
						TweenService:Create(v.Frame.Line.PageInLine, TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
							BackgroundTransparency = 0
						}):Play()
					else
						TweenService:Create(v.Frame.Line.PageInLine, TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
							BackgroundTransparency = 1
						}):Play()
					end
				end
			end
		end)

		local pageFunction = {}

		function pageFunction:AddSection(Section_Name, Toggleable, SectionGap, SectionColor)
			local Toggleable = Toggleable or false
			local Section = New("Frame", {
				Name = Section_Name .. "_Dot",
				Size = UDim2.new(1, -5, 0, 30),
				BackgroundColor3 = Color3.fromRGB(48, 48, 56),
				BackgroundTransparency = 0.25,
				ClipsDescendants = true,
				Parent = PageList,
			})
			local UICorner = New("UICorner", {
			})
			local Topsec = New("Frame", {
			})
			local Sectiontitle = New("TextLabel", {
			})
			local Linesec = New("Frame", {
			})
			local UIGradient = New("UIGradient", {
			})
			local SectionList = New("UIListLayout", {
			})

			local sectionStroke = New("UIStroke", {
				Color = Color3.fromRGB(90, 90, 70),
				Thickness = 1,
				Parent = Section,
			})

			local sectionGradient = New("UIGradient", {
				Color = ColorSequence.new{
					ColorSequenceKeypoint.new(0, Color3.fromRGB(38, 38, 46)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(48, 48, 56))
					},
				Rotation = 90,
				Transparency = NumberSequence.new{
					NumberSequenceKeypoint.new(0, 0.05),
					NumberSequenceKeypoint.new(1, 0.15)
					},
				Parent = Section,
			})

			UICorner.CornerRadius = UDim.new(0, 4)
			UICorner.Parent = Section

			Topsec.Name = "Topsec"
			Topsec.Parent = Section
			Topsec.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
			Topsec.BackgroundTransparency = 1.000
			Topsec.Size = UDim2.new(0, 415, 0, 30)

			Sectiontitle.Name = "Sectiontitle"
			Sectiontitle.Parent = Topsec
			Sectiontitle.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
			Sectiontitle.BackgroundTransparency = 1.000
			Sectiontitle.Size = UDim2.new(1, 0, 1, 0)
			Sectiontitle.Font = Enum.Font.GothamBold
			Sectiontitle.Text = Section_Name
			Sectiontitle.TextSize = 14.000
			Sectiontitle.TextColor3 = getgenv().UIColor["Section Text Color"]

			Linesec.Name = "Linesec"
			Linesec.Parent = Topsec
			Linesec.AnchorPoint = Vector2.new(0.5, 1)
			Linesec.BorderSizePixel = 0
			Linesec.Position = UDim2.new(0.5, 0, 1, -2)
			Linesec.Size = UDim2.new(1, -10, 0, 2)
			Linesec.BackgroundColor3 = getgenv().UIColor["Section Underline Color"]

			local LineShadow = New("ImageLabel", {
				Name = "LineShadow",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(163,162,165),
				BackgroundTransparency = 1,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(1, 8, 1, 8),
				ZIndex = 0,
				Image = "rbxassetid://5028857084",
				ImageTransparency = 0.6,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(24, 24, 276, 276),
				Parent = Linesec,
			})

			UIGradient.Transparency = NumberSequence.new{
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.5, 0),
				NumberSequenceKeypoint.new(0.51, 0.02),
				NumberSequenceKeypoint.new(1, 1)
			}
			UIGradient.Parent = Linesec

			SectionList.Name = "SectionList"
			SectionList.Parent = Section
			SectionList.SortOrder = Enum.SortOrder.LayoutOrder
			SectionList.Padding = UDim.new(0, 5)

			local SizeSectionY
			local sectionIsVisible = false
			if Toggleable then
				local VisibilitySectionFrame = New("Frame", {
					Name = "VisibilitySectionFrame",
					AnchorPoint = Vector2.new(1, 0.5),
					BackgroundColor3 = Color3.fromRGB(30, 30, 30),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.new(1, -5, 0.5, 0),
					Size = UDim2.new(0, 20, 0, 20),
					Parent = Topsec,
				})
				local VisibilitySectionFrameCorner = New("UICorner", {
					CornerRadius = UDim.new(0, 4),
					Name = "VisibilitySectionFrameCorner",
					Parent = VisibilitySectionFrame,
				})
				local visibility = New("ImageButton", {
					Name = "visibility",
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1.000,
					LayoutOrder = 4,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(1, -4, 1, -4),
					ZIndex = 2,
					Image = "rbxassetid://3926307971",
					ImageRectOffset = Vector2.new(84, 44),
					ImageRectSize = Vector2.new(36, 36),
					ImageTransparency = 1,
					Parent = VisibilitySectionFrame,
				})
				local visibility_off = New("ImageButton", {
					Name = "visibility_off",
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1.000,
					LayoutOrder = 4,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(1, -4, 1, -4),
					ZIndex = 2,
					Image = "rbxassetid://3926307971",
					ImageRectOffset = Vector2.new(564, 44),
					ImageRectSize = Vector2.new(36, 36),
					ImageTransparency = 0,
					Parent = VisibilitySectionFrame,
				})
				local VisibilityButton = New("TextButton", {
					Name = "VisibilityButton",
					AnchorPoint = Vector2.new(1, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1.000,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Font = Enum.Font.SourceSans,
					Text = "",
					TextColor3 = Color3.fromRGB(0, 0, 0),
					TextSize = 14.000,
					ZIndex = 2,
					Position = UDim2.new(1, -5, 0.5, 0),
					Size = UDim2.new(0, 20, 0, 20),
					Parent = Topsec,
				})
				VisibilityButton.MouseButton1Down:Connect(function()
					sectionIsVisible = not sectionIsVisible
					TweenService:Create(visibility, TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"] / 2), {
						ImageTransparency = sectionIsVisible and 0 or 1
					}):Play()
					wait(getgenv().UIColor["Tween Animation 1 Speed"] / 4)
					TweenService:Create(visibility_off, TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"] / 2), {
						ImageTransparency = sectionIsVisible and 1 or 0
					}):Play()
					TweenService:Create(Section, TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
						Size =  UDim2.new(1, -5, 0, (sectionIsVisible and SizeSectionY or 30))
					}):Play()
				end)
			end
			if SectionGap then
				local SectionGap = New("Frame", {
					Name = "SectionGap",
					Size = UDim2.new(1, -5, 0, 30),
					ClipsDescendants = true,
					Transparency = 1,
					Parent = PageList,
				})
			end

			SectionList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				if (not Toggleable) then
					Section.Size = UDim2.new(1, -5, 0, SectionList.AbsoluteContentSize.Y + 5)
				end
				SizeSectionY = SectionList.AbsoluteContentSize.Y + 5
				if sectionIsVisible then
					TweenService:Create(Section, TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
						Size =  UDim2.new(1, -5, 0, SizeSectionY)
					}):Play()
				end
			end)
			local sectionFunction = {}
			function sectionFunction:AddToggle(idk,Setting)
				local Title = tostring(Setting.Text or Setting.Title) or ""
				local Desc = Setting.Desc or Setting.Description
				local Default = Setting.Default
				if Default == nil then
					Default = false
				end
				local Callback = Setting.Callback
				local ToggleFrame = New("Frame", {
					Name = "ToggleFrame",
					BackgroundColor3 = Color3.fromRGB(230, 230, 230),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(0, 0, 0.300000012, 0),
					Size = UDim2.new(1, 0 , 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					Parent = Section,
				})
				local TogFrame1 = New("Frame", {
					Name = "TogFrame1",
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(230, 230, 230),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(1, -10, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					Parent = ToggleFrame,
				})
				local checkbox = New("ImageLabel", {
					Name = "checkbox",
					AnchorPoint = Vector2.new(1, 0.5),
					BackgroundColor3 = Color3.fromRGB(230, 230, 230),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(1, -5, 0.5, 3),
					Size = UDim2.new(0, 25, 0, 25),
					Image = "rbxassetid://4552505888",
					ImageColor3 = getgenv().UIColor["Toggle Border Color"],
					Parent = TogFrame1,
				})
				local check = New("Frame", {
					Name = "check",
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 206, 27),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Parent = checkbox,
				})
				local ToggleDesc = New("TextLabel", {
				})
				local ToggleTitle = New("TextLabel", {
				})
				local ToggleBg = New("Frame", {
				})
				local ToggleCorner = New("UICorner", {
				})
				local ToggleButton = New("TextButton", {
				})
				local ToggleList = New("UIListLayout", {
				})
				local cac = 5
				if Desc then
					cac = 0
					ToggleDesc.Name = "ToggleDesc"
					ToggleDesc.Parent = TogFrame1
					ToggleDesc.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
					ToggleDesc.BackgroundTransparency = 1.000
					ToggleDesc.Position = UDim2.new(0, 15, 0, 20)
					ToggleDesc.Size = UDim2.new(1, -50, 0, 0)
					ToggleDesc.Font = Enum.Font.GothamBlack
					ToggleDesc.Text = Desc
					ToggleDesc.TextSize = 13.000
					ToggleDesc.TextWrapped = true
					ToggleDesc.TextXAlignment = Enum.TextXAlignment.Left
					ToggleDesc.RichText = true
					ToggleDesc.AutomaticSize = Enum.AutomaticSize.Y
					ToggleDesc.TextColor3 = getgenv().UIColor["Toggle Desc Color"]
				else
					ToggleDesc.Text = ''
				end
				ToggleTitle.Name = "TextColor"
				ToggleTitle.Parent = TogFrame1
				ToggleTitle.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
				ToggleTitle.BackgroundTransparency = 1.000
				ToggleTitle.Position = UDim2.new(0, 10, 0, cac)
				ToggleTitle.Size = UDim2.new(1, -10, 0, 20)
				ToggleTitle.Font = Enum.Font.GothamBlack
				ToggleTitle.Text = Title
				ToggleTitle.TextSize = 14.000
				ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
				ToggleTitle.TextYAlignment = Enum.TextYAlignment.Center
				ToggleTitle.RichText = true
				ToggleTitle.AutomaticSize = Enum.AutomaticSize.Y
				ToggleTitle.TextColor3 = getgenv().UIColor["Text Color"]
				ToggleBg.Name = "Background1"
				ToggleBg.Parent = TogFrame1
				ToggleBg.Size = UDim2.new(1, 0, 1, 6)
				ToggleBg.ZIndex = 0
				ToggleBg.BackgroundColor3 = getgenv().UIColor["Background 1 Color"]
				ToggleBg.BackgroundTransparency = getgenv().UIColor["Background 1 Transparency"]
				ToggleCorner.CornerRadius = UDim.new(0, 4)
				ToggleCorner.Name = "ToggleCorner"
				ToggleCorner.Parent = ToggleBg
				ToggleButton.Name = "ToggleButton"
				ToggleButton.Parent = TogFrame1
				ToggleButton.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
				ToggleButton.BackgroundTransparency = 1.000
				ToggleButton.AnchorPoint = Vector2.new(1, 0.5)
				ToggleButton.Size = UDim2.new(0, 25, 0, 25)
				ToggleButton.Position = UDim2.new(1, -5, 0.5, 3)
				ToggleButton.Font = Enum.Font.SourceSans
				ToggleButton.Text = ""
				ToggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
				ToggleButton.TextSize = 14.000
				ToggleList.Name = "ToggleList"
				ToggleList.Parent = ToggleFrame
				ToggleList.HorizontalAlignment = Enum.HorizontalAlignment.Center
				ToggleList.SortOrder = Enum.SortOrder.LayoutOrder
				ToggleList.VerticalAlignment = Enum.VerticalAlignment.Center
				ToggleList.Padding = UDim.new(0, 5)
				local function ChangeStage(val)
					local csize = val and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0, 0, 0, 0)
					local pos = val and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0.5, 0, 0.5, 0)
					local apos = val and Vector2.new(0.5, 0.5) or Vector2.new(0.5, 0.5)
					game.TweenService:Create(check, TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
						Size = csize,
						Position = pos,
						AnchorPoint = apos
					}):Play()
				end
				ChangeStage(Default)
				local function ButtonClick()
					Default = not Default
				    ChangeStage(Default)
				    if Callback then
				        pcall(Callback, Default)
				    end
				end
				ToggleButton.MouseButton1Down:Connect(function()
					ButtonClick()
				end)
				local toggleFunction = {}
				function toggleFunction.SetStage(value)
					if value ~= Default then
						ButtonClick()
					end
				end
				local controlData = {
                    Name = Title,
                    Section = Section,
                    Element = ToggleFrame,
                    SectionName = Section_Name,
                    TabName = Page_Name,
                    TabButton = PageName
                }
                table.insert(getgenv().AllControls, controlData)
                
				return toggleFunction
			end
        function sectionFunction:AddButton(Setting, Callback)
        	local Title = Setting.Title or Setting.Text or ""
        	local Callback = Setting.Callback or Setting.Func or function() end
            local Button = New("Frame", {
            	Name = "Button",
            	BackgroundColor3 = Color3.fromRGB(163,162,165),
            	BackgroundTransparency = 1,
            	Size = UDim2.new(1, 0,0, 40),
            	Parent = Section,
            })
            local RowBG_1 = New("Frame", {
            	Name = "RowBG",
            	AnchorPoint = Vector2.new(0.5, 0.5),
            	BackgroundColor3 = getgenv().UIColor["Background 1 Color"],
            	BackgroundTransparency = getgenv().UIColor["Background 1 Transparency"],
            	Position = UDim2.new(0.5, 0,0.5, 0),
            	Size = UDim2.new(1, -10,1, 0),
            	Parent = Button,
            })
            local UICorner_1 = New("UICorner", {
            	CornerRadius = UDim.new(0,10),
            	Parent = RowBG_1,
            })
            local RowHover_1 = New("Frame", {
            	Name = "RowHover",
            	BackgroundColor3 = getgenv().UIColor["Background 2 Color"],
            	BackgroundTransparency = 1,
            	Size = UDim2.new(1, 0,1, 0),
            	ZIndex = 2,
            	Parent = RowBG_1,
            })
            local UICorner_2 = New("UICorner", {
            	CornerRadius = UDim.new(0,10),
            	Parent = RowHover_1,
            })
            local TextColor_1 = New("TextLabel", {
            	Name = "TextColor",
            	BackgroundColor3 = Color3.fromRGB(163,162,165),
            	BackgroundTransparency = 1,
            	Position = UDim2.new(0, 12,0, 0),
            	Size = UDim2.new(1, -110,1, 0),
            	Font = Enum.Font.GothamBold,
            	Text = Title,
            	TextColor3 = getgenv().UIColor["GUI Text Color"],
            	TextSize = 14,
            	TextStrokeTransparency = 0.8500000238418579,
            	TextXAlignment = Enum.TextXAlignment.Left,
            	Parent = RowBG_1,
            })
            local ClickArea_1 = New("Frame", {
            	Name = "ClickArea",
            	AnchorPoint = Vector2.new(1, 0.5),
            	BackgroundColor3 = Color3.fromRGB(255, 206, 27),
            	Position = UDim2.new(1, -8,0.5, 0),
            	Size = UDim2.new(0, 94,0, 30),
            	ClipsDescendants = true  -- THÊM DÒNG NÀY: Ngăn ripple tràn ra,
            	Parent = RowBG_1,
            })
            local UICorner_3 = New("UICorner", {
            	CornerRadius = UDim.new(0,12),
            	Parent = ClickArea_1,
            })
            local UIGradient_1 = New("UIGradient", {
            	Color = ColorSequence.new{
            		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 216, 77)),
            		ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 206, 27)),
            		ColorSequenceKeypoint.new(0.6, Color3.fromRGB(235, 186, 17)),
            		ColorSequenceKeypoint.new(1, Color3.fromRGB(215, 166, 7))
            		},
            	Rotation = 90,
            	Parent = ClickArea_1,
            })
            local ImageLabel_1 = New("ImageLabel", {
            	AnchorPoint = Vector2.new(0.5, 0.5),
            	BackgroundColor3 = Color3.fromRGB(163,162,165),
            	BackgroundTransparency = 1,
            	Position = UDim2.new(0.5, 0,0.5, 0),
            	Size = UDim2.new(1, 14,1, 14),
            	ZIndex = 0,
            	Image = "rbxassetid://5028857084",
            	ImageTransparency = 0.7,
            	ScaleType = Enum.ScaleType.Slice,
            	SliceCenter = Rect.new(24, 24, 276, 276),
            	Parent = ClickArea_1,
            })
            local Frame_1 = New("Frame", {
            	AnchorPoint = Vector2.new(0.5, 0),
            	BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            	BackgroundTransparency = 0.8,
            	Position = UDim2.new(0.5, 0,0, 2),
            	Size = UDim2.new(1, -6,0, 10),
            	ZIndex = 2,
            	Parent = ClickArea_1,
            })
            local UICorner_4 = New("UICorner", {
            	CornerRadius = UDim.new(0,10),
            	Parent = Frame_1,
            })
            local UIScale_1 = New("UIScale", {
            	Parent = ClickArea_1,
            })
            local Button_1 = New("TextButton", {
            	Name = "Button",
            	Active = true,
            	AutoButtonColor = false,
            	BackgroundColor3 = Color3.fromRGB(163,162,165),
            	BackgroundTransparency = 1,
            	Size = UDim2.new(1, 0,1, 0),
            	Font = Enum.Font.GothamBold,
            	Text = "Click",
            	TextColor3 = Color3.fromRGB(240, 240, 240),
            	TextSize = 13,
            	Parent = ClickArea_1,
            })

             -- UIScale mặc định
             UIScale_1.Scale = 1
             
             -- HOVER (chỉ phóng to)
             local scaleHover = TweenService:Create(UIScale_1, TweenInfo.new(0.12, Enum.EasingStyle.Sine), { Scale = 1.05 })
             local scaleNormal = TweenService:Create(UIScale_1, TweenInfo.new(0.12, Enum.EasingStyle.Sine), { Scale = 1 })
             
             Button_1.MouseEnter:Connect(function()
             	scaleHover:Play()
             end)
             
             Button_1.MouseLeave:Connect(function()
             	scaleNormal:Play()
             end)
             
                Button_1.MouseButton1Down:Connect(function()
                    
                    -- Lấy kích thước thực tế của ClickArea
                    local w = ClickArea_1.AbsoluteSize.X
                    local h = ClickArea_1.AbsoluteSize.Y
                    
                    -- Tạo ripple với hình dạng bo góc giống button (chữ nhật bo góc)
                    local ripple = New("Frame", {
                    	AnchorPoint = Vector2.new(0.5, 0.5),
                    	Position = UDim2.new(0.5, 0, 0.5, 0),
                    	Size = UDim2.new(0, 0, 0, 0),
                    	BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    	BackgroundTransparency = 0.6,
                    	ZIndex = 20,
                    	Parent = ClickArea_1,
                    })
                    
                    -- Tạo UICorner cho ripple với bo góc y hệt button
                    local rippleCorner = New("UICorner", {
                    	CornerRadius = UICorner_3.CornerRadius -- Lấy góc bo từ button,
                    	Parent = ripple,
                    })
                    
                    -- Animation ripple mở rộng từ tâm ra đầy đủ button
                    local rippleTween = TweenService:Create(
                        ripple,
                        TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {
                            Size = UDim2.new(1, 0, 1, 0),
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0.5, 0, 0.5, 0)
                        }
                    )
                    
                    rippleTween:Play()
                    rippleTween.Completed:Connect(function()
                        ripple:Destroy()
                    end)
                    
                    Callback()
                end)
                local f = {}
                function f:SetTitle(vl)
                    TextColor_1.Text = vl
                end
                local controlData = {
                    Name = Title,
                    Section = Section,
                    Element = Button,
                    SectionName = Section_Name,
                    TabName = Page_Name,
                    TabButton = PageName
                }
                table.insert(getgenv().AllControls, controlData)
                
                return f
            end
        
			function sectionFunction:AddLabel(text)
				local Title = text
                local LabelFrame = New("Frame", {
                	Name = "LabelFrame",
                	AutomaticSize = Enum.AutomaticSize.Y,
                	BackgroundColor3 = Color3.fromRGB(163,162,165),
                	BackgroundTransparency = 1,
                	Size = UDim2.new(1, 0,0, 0),
                	Parent = Section,
                })
                local LabelBG = New("Frame", {
                	Name = "LabelBG",
                	AnchorPoint = Vector2.new(0.5, 0),
                	AutomaticSize = Enum.AutomaticSize.Y,
                	BackgroundColor3 = Color3.fromRGB(38,38,46),
                	BackgroundTransparency = 0.25,
                	Position = UDim2.new(0.5, 0,0, 0),
                	Size = UDim2.new(1, -10,0, -10),
                	Parent = LabelFrame,
                })
                local UICorner = New("UICorner", {
                	CornerRadius = UDim.new(0,6),
                	Parent = LabelBG,
                })
                local TextColor = New("TextLabel", {
                	Name = "TextColor",
                	AutomaticSize = Enum.AutomaticSize.Y,
                	BackgroundColor3 = Color3.fromRGB(163,162,165),
                	BackgroundTransparency = 1,
                	Position = UDim2.new(0, 12,0, 6),
                	Size = UDim2.new(1, -24,1, -12),
                	Font = Enum.Font.GothamMedium,
                	Text = Title,
                	TextColor3 = Color3.fromRGB(240,240,230),
                	TextSize = 14,
                	TextStrokeTransparency = 0.8500000238418579,
                	TextWrapped = true,
                	TextXAlignment = Enum.TextXAlignment.Left,
                	Parent = LabelBG,
                })
				local labelFunction = {}
				function labelFunction:SetText(text)
					TextColor.Text = text
				end
				function labelFunction.SetColor(color)
					TextColor.TextColor3 = color
				end
				local controlData = {
                    Name = Title,
                    Section = Section,
                    Element = LabelFrame,
                    SectionName = Section_Name,
                    TabName = Page_Name,
                    TabButton = PageName
                }
                table.insert(getgenv().AllControls, controlData)
                
				return labelFunction
			end
            function sectionFunction:AddDropdownSection(Setting)
                local Title = tostring(Setting.Text or Setting.Title or "")
                local Search = Setting.Search or false
              
                local DropdownFrame = New("Frame", {
                	Name = Title .. "DropdownSectionFrame",
                	BackgroundColor3 = Color3.fromRGB(230, 230, 230),
                	BackgroundTransparency = 1.000,
                	Position = UDim2.new(0, 0, 0.473684222, 0),
                	Size = UDim2.new(1, 0, 0, 25),
                	Parent = Section,
                })
                local Dropdownbg = New("Frame", {
                	Name = "Background1",
                	AnchorPoint = Vector2.new(0.5, 0.5),
                	Position = UDim2.new(0.5, 0, 0.5, 0),
                	Size = UDim2.new(1, -10, 1, 0),
                	ClipsDescendants = true,
                	BackgroundColor3 = getgenv().UIColor["Background 1 Color"],
                	BackgroundTransparency = 0.25,
                	Parent = DropdownFrame,
                })
                local Dropdowncorner = New("UICorner", {
                	CornerRadius = UDim.new(0, 4),
                	Name = "Dropdowncorner",
                	Parent = Dropdownbg,
                })
                local Topdrop = New("Frame", {
                	Name = "Background2",
                	Size = UDim2.new(1, 0, 0, 25),
                	BackgroundColor3 = getgenv().UIColor["Background 2 Color"],
                	BackgroundTransparency = getgenv().UIColor["Background 1 Transparency"],
                	Parent = Dropdownbg,
                })
                local UICorner = New("UICorner", {
                	CornerRadius = UDim.new(0, 4),
                	Parent = Topdrop,
                })
                local ImgDrop = New("ImageLabel", {
                })
                local DropdownButton = New("TextButton", {
                })
                local Dropdownlisttt = New("Frame", {
                })
                local DropdownScroll = New("ScrollingFrame", {
                })
                local ScrollContainer = New("Frame", {
                })
                local ScrollContainerList = New("UIListLayout", {
                })
                
                local Dropdowntitle
                if Search then
                    Dropdowntitle = New("TextBox", {
                    	PlaceholderText = Title,
                    	PlaceholderColor3 = getgenv().UIColor["Placeholder Text Color"],
                    })
                else
                    Dropdowntitle = New("TextLabel", {
                    	Text = Title,
                    })
                end
                
                Dropdowntitle.Name = "TextColorPlaceholder"
                Dropdowntitle.Parent = Topdrop
                Dropdowntitle.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
                Dropdowntitle.BackgroundTransparency = 1.000
                Dropdowntitle.Position = UDim2.new(0, 10, 0, 0)
                Dropdowntitle.Size = UDim2.new(1, -40, 1, 0)
                Dropdowntitle.Font = Enum.Font.GothamBlack
                Dropdowntitle.TextSize = 14.000
                Dropdowntitle.TextXAlignment = Enum.TextXAlignment.Left
                Dropdowntitle.ClipsDescendants = true
                Dropdowntitle.TextColor3 = getgenv().UIColor["Text Color"]
                
                ImgDrop.Name = "ImgDrop"
                ImgDrop.Parent = Topdrop
                ImgDrop.AnchorPoint = Vector2.new(1, 0.5)
                ImgDrop.BackgroundTransparency = 1.000
                ImgDrop.BorderColor3 = Color3.fromRGB(27, 42, 53)
                ImgDrop.Position = UDim2.new(1, -6, 0.5, 0)
                ImgDrop.Size = UDim2.new(0, 15, 0, 15)
                ImgDrop.Image = "rbxassetid://6954383209"
                ImgDrop.ImageColor3 = getgenv().UIColor["Dropdown Icon Color"]
                
                DropdownButton.Name = "DropdownButton"
                DropdownButton.Parent = Topdrop
                DropdownButton.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
                DropdownButton.BackgroundTransparency = 1.000
                DropdownButton.Size = Search and UDim2.new(0, 30, 0, 30) or UDim2.new(1, 0, 1 , 0)
                DropdownButton.Position = Search and UDim2.new(1, -35, 0, 0) or UDim2.new(0 , 0 , 0 , 0)
                DropdownButton.Font = Enum.Font.GothamBold
                DropdownButton.Text = ""
                DropdownButton.TextColor3 = Color3.fromRGB(230, 230, 230)
                DropdownButton.TextSize = 14.000
                
                Dropdownlisttt.Name = "Dropdownlisttt"
                Dropdownlisttt.Parent = Dropdownbg
                Dropdownlisttt.BackgroundTransparency = 1.000
                Dropdownlisttt.BorderSizePixel = 0
                Dropdownlisttt.Position = UDim2.new(0, 0, 0, 25)
                Dropdownlisttt.Size = UDim2.new(1, 0, 0, 0)
                Dropdownlisttt.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
                
                DropdownScroll.Name = "DropdownScroll"
                DropdownScroll.Parent = Dropdownlisttt
                DropdownScroll.Active = true
                DropdownScroll.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
                DropdownScroll.BackgroundTransparency = 1.000
                DropdownScroll.BorderSizePixel = 0
                DropdownScroll.Size = UDim2.new(1, 0, 1, 0)
                DropdownScroll.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
                DropdownScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
                DropdownScroll.ScrollBarThickness = 5
                DropdownScroll.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
                DropdownScroll.ScrollingEnabled = true
                DropdownScroll.VerticalScrollBarInset = Enum.ScrollBarInset.Always
                
                ScrollContainer.Name = "ScrollContainer"
                ScrollContainer.Parent = DropdownScroll
                ScrollContainer.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
                ScrollContainer.BackgroundTransparency = 1.000
                ScrollContainer.Position = UDim2.new(0, 5, 0, 5)
                ScrollContainer.Size = UDim2.new(1, -15, 1, -5)
                
                ScrollContainerList.Name = "ScrollContainerList"
                ScrollContainerList.Parent = ScrollContainer
                ScrollContainerList.SortOrder = Enum.SortOrder.LayoutOrder
                ScrollContainerList.Padding = UDim.new(0, 5)
                
                -- Tạo internal section để chứa các control
                local InternalSection = New("Frame", {
                	Name = "InternalSection",
                	BackgroundColor3 = Color3.fromRGB(230, 230, 230),
                	BackgroundTransparency = 1.000,
                	Size = UDim2.new(1, 0, 0, 0),
                	AutomaticSize = Enum.AutomaticSize.Y,
                	Parent = ScrollContainer,
                })
                
                local InternalList = New("UIListLayout", {
                	Name = "InternalList",
                	SortOrder = Enum.SortOrder.LayoutOrder,
                	Padding = UDim.new(0, 5),
                	Parent = InternalSection,
                })
                
                local isOpen = false
                
                DropdownButton.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    
                    local listsize = isOpen and UDim2.new(1, 0, 0, 200) or UDim2.new(1, 0, 0, 0)
                    local mainsize = isOpen and UDim2.new(1, 0, 0, 230) or UDim2.new(1, 0, 0, 25)
                    local DropCRotation = isOpen and 90 or 0
                    
                    TweenService:Create(Dropdownlisttt, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
                        Size = listsize
                    }):Play()
                    TweenService:Create(DropdownFrame, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
                        Size = mainsize
                    }):Play()
                    TweenService:Create(ImgDrop, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
                        Rotation = DropCRotation
                    }):Play()
                end)
                
                ScrollContainerList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    DropdownScroll.CanvasSize = UDim2.new(0, 0, 0, 10 + ScrollContainerList.AbsoluteContentSize.Y + 5)
                end)
                
                InternalList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    local contentHeight = math.min(InternalList.AbsoluteContentSize.Y + 10, 300)
                    local listsize = isOpen and UDim2.new(1, 0, 0, contentHeight) or UDim2.new(1, 0, 0, 0)
                    local mainsize = isOpen and UDim2.new(1, 0, 0, contentHeight + 25) or UDim2.new(1, 0, 0, 25)
                    
                    if isOpen then
                        TweenService:Create(Dropdownlisttt, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
                            Size = listsize
                        }):Play()
                        TweenService:Create(DropdownFrame, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
                            Size = mainsize
                        }):Play()
                    end
                end)
                
                -- Tạo dropdown section functions (CHỈ CÓ SLIDER)
                local dropdownSectionFunction = {}
                
                -- HÀM TẠO SLIDER (RỘNG HƠN, SÁT VIỀN)
                function dropdownSectionFunction:AddSlider(Setting)
                    local TitleText = tostring(Setting.Text or Setting.Title) or ""
                    local minValue = tonumber(Setting.Min) or 0
                    local maxValue = tonumber(Setting.Max) or 100
                    local Precise = Setting.Precise or false
                    local DefaultValue = tonumber(Setting.Default) or 0
                    local Callback = Setting.Callback
                    local Rounding = Setting.Rouding or Setting.Rounding
                    
                    local SliderFrame = New("Frame", {
                    	Name = TitleText,
                    	BackgroundColor3 = Color3.fromRGB(60, 60, 60),
                    	BackgroundTransparency = 1.000,
                    	Size = UDim2.new(1, 0, 0, 50)  -- Chiếm toàn bộ chiều rộng,
                    	Parent = InternalSection,
                    })
                    local SliderCorner = New("UICorner", {
                    	CornerRadius = UDim.new(0, 4),
                    	Name = "SliderCorner",
                    	Parent = SliderFrame,
                    })
                    local SliderBG = New("Frame", {
                    	Name = "Background1",
                    	AnchorPoint = Vector2.new(0.5, 0.5),
                    	Position = UDim2.new(0.5, 0, 0.5, 0),
                    	Size = UDim2.new(1, -5, 1, 0)  -- Chiếm gần toàn bộ (trừ 5 pixel),
                    	BackgroundColor3 = Color3.fromRGB(28, 28, 34),
                    	BackgroundTransparency = 0.25,
                    	Parent = SliderFrame,
                    })
                    local SliderBGCorner = New("UICorner", {
                    	CornerRadius = UDim.new(0, 4),
                    	Name = "SliderBGCorner",
                    	Parent = SliderBG,
                    })
                    local SliderTitle = New("TextLabel", {
                    	Name = "TextColor",
                    	BackgroundColor3 = Color3.fromRGB(230, 230, 230),
                    	BackgroundTransparency = 1.000,
                    	Position = UDim2.new(0, 10, 0, 0),
                    	Size = UDim2.new(0.65, -10, 0, 25)  -- Title chiếm 65%,
                    	Font = Enum.Font.GothamBlack,
                    	Text = TitleText,
                    	TextSize = 14.000,
                    	RichText = true,
                    	TextXAlignment = Enum.TextXAlignment.Left,
                    	TextColor3 = getgenv().UIColor["Text Color"],
                    	Parent = SliderBG,
                    })
                    local SliderBar = New("Frame", {
                    	Name = "SliderBar",
                    	AnchorPoint = Vector2.new(0.5, 0.5),
                    	Position = UDim2.new(0.5, 0, 0.5, 14),
                    	Size = UDim2.new(0.9, 0, 0, 6)  -- Thanh slider rộng 90%,
                    	BackgroundColor3 = getgenv().UIColor["Background 2 Color"],
                    	Parent = SliderFrame,
                    })
                    local SliderButton = New("TextButton", {
                    	Name = "SliderButton",
                    	BackgroundColor3 = Color3.fromRGB(230, 230, 230),
                    	BackgroundTransparency = 1.000,
                    	Size = UDim2.new(1, 0, 1, 0),
                    	Font = Enum.Font.GothamBold,
                    	Text = "",
                    	TextColor3 = Color3.fromRGB(230, 230, 230),
                    	TextSize = 14.000,
                    	Parent = SliderBar,
                    })
                    local SliderBarCorner = New("UICorner", {
                    	CornerRadius = UDim.new(1, 0),
                    	Name = "SliderBarCorner",
                    	Parent = SliderBar,
                    })
                    local Bar = New("Frame", {
                    	Name = "Bar",
                    	BorderSizePixel = 0,
                    	Size = UDim2.new(0, 0, 1, 0),
                    	BackgroundColor3 = getgenv().UIColor["Slider Line Color"],
                    	Parent = SliderBar,
                    })
                    local BarCorner = New("UICorner", {
                    	CornerRadius = UDim.new(1, 0),
                    	Name = "BarCorner",
                    	Parent = Bar,
                    })
                    local Sliderboxframe = New("Frame", {
                    	Name = "Background2",
                    	AnchorPoint = Vector2.new(1, 0),
                    	Position = UDim2.new(1, -10, 0, 5),
                    	Size = UDim2.new(0.25, 0, 0, 25)  -- Textbox chiếm 25%,
                    	BackgroundColor3 = getgenv().UIColor["Background 2 Color"],
                    	Parent = SliderFrame,
                    })
                    local Sliderbox = New("UICorner", {
                    	CornerRadius = UDim.new(0, 4),
                    	Name = "Sliderbox",
                    	Parent = Sliderboxframe,
                    })
                    local Sliderbox_2 = New("TextBox", {
                    	Name = "TextColor",
                    	BackgroundColor3 = Color3.fromRGB(230, 230, 230),
                    	BackgroundTransparency = 1.000,
                    	Size = UDim2.new(1, 0, 1, 0),
                    	Font = Enum.Font.GothamBold,
                    	Text = "",
                    	TextSize = 14.000,
                    	TextColor3 = getgenv().UIColor["Text Color"],
                    	Parent = Sliderboxframe,
                    })
                    
                    SliderButton.MouseEnter:Connect(function()
                        TweenService:Create(Bar, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
                            BackgroundColor3 = getgenv().UIColor["Slider Highlight Color"]
                        }):Play()
                    end)
                    
                    SliderButton.MouseLeave:Connect(function()
                        TweenService:Create(Bar, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
                            BackgroundColor3 = getgenv().UIColor["Slider Line Color"]
                        }):Play()
                    end)
                    
                    local callBackAndSetText = function(val)
                        Sliderbox_2.Text = tostring(val)
                        Callback(tonumber(val))
                    end
                    if DefaultValue then
                        if DefaultValue <= minValue then
                            DefaultValue = minValue
                        elseif DefaultValue >= maxValue then
                            DefaultValue = maxValue
                        end
                        Bar.Size = UDim2.new(1 - ((maxValue - DefaultValue) / (maxValue - minValue)), 0, 0, 6)
                        Sliderbox_2.Text = tostring(DefaultValue)
                    end
                    
                    
                    local dragging = false
                    local dragInput
                    local holdTime = 0
                    local holdStarted = 0
                    
                    local function onInputBegan(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            holdStarted = tick()
                            
                            input.Changed:Connect(function()
                                if input.UserInputState == Enum.UserInputState.End then
                                    dragging = false
                                    holdStarted = 0
                                end
                            end)
                        end
                    end
                    
                    local function onInputEnded(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            dragging = false
                            holdStarted = 0
                        end
                    end
                    
                    local function onInputChanged(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                            dragInput = input
                        end
                    end
                    
                    SliderButton.InputBegan:Connect(onInputBegan)
                    SliderButton.InputEnded:Connect(onInputEnded)
                    SliderButton.InputChanged:Connect(onInputChanged)
                    
                    RunService.RenderStepped:Connect(function()
                        if holdStarted > 0 and (tick() - holdStarted >= holdTime) and not dragging then
                            dragging = true
                        end
                        
                        if dragging and dragInput then
                            local barWidth = math.clamp(dragInput.Position.X - Bar.AbsolutePosition.X, 0, SliderBar.AbsoluteSize.X)
                            local percentage = barWidth / SliderBar.AbsoluteSize.X
                            local value = minValue + (maxValue - minValue) * percentage
                            
                            if Rounding then
                                value = tonumber(string.format("%.".. Rounding .."f", value))
                            elseif not Precise then
                                value = math.floor(value)
                            end
                            
                            value = math.clamp(value, minValue, maxValue)
                            
                            pcall(function()
                                callBackAndSetText(value)
                            end)
                            Bar.Size = UDim2.new(percentage, 0, 1, 0)
                        end
                    end)
                    
                    local function GetSliderValue(Value)
                        Value = tonumber(Value) or minValue
                        Value = math.clamp(Value, minValue, maxValue)
                        
                        if Rounding then
                            Value = tonumber(string.format("%.".. Rounding .."f", Value))
                        elseif not Precise then
                            Value = math.floor(Value)
                        end
                        
                        local percentage = (Value - minValue) / (maxValue - minValue)
                        Bar.Size = UDim2.new(percentage, 0, 1, 0)
                        callBackAndSetText(Value)
                    end
                    
                    Sliderbox_2.FocusLost:Connect(function()
                        GetSliderValue(Sliderbox_2.Text)
                    end)
                    
                    local slider_function = {}
                    function slider_function.SetValue(Value)
                        GetSliderValue(Value)
                    end
                    
                    function slider_function.GetValue()
                        return tonumber(Sliderbox_2.Text) or minValue
                    end
                    
                    return slider_function
                end
                
                function dropdownSectionFunction:SetOpen(state)
                    if state ~= isOpen then
                        DropdownButton.MouseButton1Click:Fire()
                    end
                end
                
                function dropdownSectionFunction:GetOpen()
                    return isOpen
                end
                
                function dropdownSectionFunction:SetTitle(newTitle)
                    if Search then
                        Dropdowntitle.PlaceholderText = newTitle
                    else
                        Dropdowntitle.Text = newTitle
                    end
                end
                
                local controlData = {
                    Name = Title,
                    Section = Section,
                    Element = DropdownFrame,
                    SectionName = Section_Name,
                    TabName = Page_Name,
                    TabButton = PageName
                }
                table.insert(getgenv().AllControls, controlData)
                
                return dropdownSectionFunction
            end
            
			function sectionFunction:AddDropdown(idk, Setting)
				local Title = tostring(Setting.Text or Setting.Title) or ""
				local List = Setting.Values
				local Search = Setting.Search or false
				local Selected = Setting.Selected or Setting.Multi or false
				local Slider = Setting.Slider or false
				local SliderRelease = Setting.SliderRelease or false
				local Default = (function ()
                    if Setting.Default then
                        if type(Setting.Default) == "number" then
                            return List[Setting.Default]
                        elseif type(Setting.Default) == "string" then
                            return Setting.Default
                        end
                    end
                    return nil
                end)()
				local Callback = Setting.Callback
				local pairs = Setting.SortPairs or pairs
				local DropdownFrame = New("Frame", {
				})
				local Dropdownbg = New("Frame", {
				})
				local Dropdowncorner = New("UICorner", {
				})
				local Topdrop = New("Frame", {
				})
				local UICorner = New("UICorner", {
				})
				local ImgDrop = New("ImageLabel", {
				})
				local DropdownButton = New("TextButton", {
				})
				local Dropdownlisttt = New("Frame", {
				})
				local DropdownScroll = New("ScrollingFrame", {
				})
				local ScrollContainer = New("Frame", {
				})
				local ScrollContainerList = New("UIListLayout", {
				})
				local dropdownLeave = false
				local Dropdowntitle;
				if Search then
					Dropdowntitle = New("TextBox", {
					})
				else
					Dropdowntitle = New("TextLabel", {
					})
				end
				DropdownFrame.Name = Title .. "DropdownFrame"
				DropdownFrame.Parent = Section
				DropdownFrame.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
				DropdownFrame.BackgroundTransparency = 1.000
				DropdownFrame.Position = UDim2.new(0, 0, 0.473684222, 0)
				DropdownFrame.Size = UDim2.new(1, 0, 0, 25)
				Dropdownbg.Name = "Background1"
				Dropdownbg.Parent = DropdownFrame
				Dropdownbg.AnchorPoint = Vector2.new(0.5, 0.5)
				Dropdownbg.Position = UDim2.new(0.5, 0, 0.5, 0)
				Dropdownbg.Size = UDim2.new(1, -10, 1, 0)
				Dropdownbg.ClipsDescendants = true
				Dropdownbg.BackgroundColor3 = getgenv().UIColor["Background 1 Color"]
				Dropdownbg.BackgroundTransparency = getgenv().UIColor["Background 1 Transparency"]
				Dropdowncorner.CornerRadius = UDim.new(0, 4)
				Dropdowncorner.Name = "Dropdowncorner"
				Dropdowncorner.Parent = Dropdownbg
				Topdrop.Name = "Background2"
				Topdrop.Parent = Dropdownbg
				Topdrop.Size = UDim2.new(1, 0, 0, 25)
				Topdrop.BackgroundColor3 = getgenv().UIColor["Background 2 Color"]
				Topdrop.BackgroundTransparency = getgenv().UIColor["Background 1 Transparency"]
				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = Topdrop
				Dropdowntitle.Name = "TextColorPlaceholder"
				Dropdowntitle.Parent = Topdrop
				Dropdowntitle.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
				Dropdowntitle.BackgroundTransparency = 1.000
				Dropdowntitle.Position = UDim2.new(0, 10, 0, 0)
				Dropdowntitle.Size = UDim2.new(1, -40, 1, 0)
				Dropdowntitle.Font = Enum.Font.GothamBlack
				Dropdowntitle.Text = ''
				Dropdowntitle.TextSize = 14.000
				Dropdowntitle.TextXAlignment = Enum.TextXAlignment.Left
				Dropdowntitle.ClipsDescendants = true
				local Sel = New("StringValue", {
					Value = "",
					Parent = Dropdowntitle,
				})
				if Default and table.find(List, Default) then
					Sel.Value = Default
				end
				if not Selected then
					if Search then
						Dropdowntitle.PlaceholderColor3 = getgenv().UIColor["Placeholder Text Color"]
						Dropdowntitle.PlaceholderText = Title .. ': ' .. tostring(Default or "");
					else
						Dropdowntitle.Text = Title .. ': ' .. tostring(Default or "");
					end
				else
					if Search then
						Dropdowntitle.PlaceholderColor3 = getgenv().UIColor["Placeholder Text Color"]
						Dropdowntitle.PlaceholderText = Title .. ': ' .. tostring(Default or "");
					else
						Dropdowntitle.Text = Title .. ': ' .. tostring(Default or "");
					end
				end
				Dropdowntitle.TextColor3 = getgenv().UIColor["Text Color"]
				ImgDrop.Name = "ImgDrop"
				ImgDrop.Parent = Topdrop
				ImgDrop.AnchorPoint = Vector2.new(1, 0.5)
				ImgDrop.BackgroundTransparency = 1.000
				ImgDrop.BorderColor3 = Color3.fromRGB(27, 42, 53)
				ImgDrop.Position = UDim2.new(1, -6, 0.5, 0)
				ImgDrop.Size = UDim2.new(0, 15, 0, 15)
				ImgDrop.Image = "rbxassetid://6954383209"
				ImgDrop.ImageColor3 = getgenv().UIColor["Dropdown Icon Color"]
				DropdownButton.Name = "DropdownButton"
				DropdownButton.Parent = Topdrop
				DropdownButton.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
				DropdownButton.BackgroundTransparency = 1.000
				DropdownButton.Size = Search and UDim2.new(0, 30, 0, 30) or UDim2.new(1, 0, 1 , 0)
				DropdownButton.Position = Search and UDim2.new(1, -35, 0, 0) or UDim2.new(0 , 0 , 0 , 0)
				DropdownButton.Font = Enum.Font.GothamBold
				DropdownButton.Text = ""
				DropdownButton.TextColor3 = Color3.fromRGB(230, 230, 230)
				DropdownButton.TextSize = 14.000
				Dropdownlisttt.Name = "Dropdownlisttt"
				Dropdownlisttt.Parent = Dropdownbg
				Dropdownlisttt.BackgroundTransparency = 1.000
				Dropdownlisttt.BorderSizePixel = 0
				Dropdownlisttt.Position = UDim2.new(0, 0, 0, 25)
				Dropdownlisttt.Size = UDim2.new(1, 0, 0, 25)
				Dropdownlisttt.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
				DropdownScroll.Name = "DropdownScroll"
				DropdownScroll.Parent = Dropdownlisttt
				DropdownScroll.Active = true
				DropdownScroll.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
				DropdownScroll.BackgroundTransparency = 1.000
				DropdownScroll.BorderSizePixel = 0
				DropdownScroll.Size = UDim2.new(1, 0, 1, 0)
				DropdownScroll.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
				DropdownScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
				DropdownScroll.ScrollBarThickness = 5
				DropdownScroll.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
				DropdownScroll.ScrollingEnabled = true
				DropdownScroll.VerticalScrollBarInset = Enum.ScrollBarInset.Always
				ScrollContainer.Name = "ScrollContainer"
				ScrollContainer.Parent = DropdownScroll
				ScrollContainer.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
				ScrollContainer.BackgroundTransparency = 1.000
				ScrollContainer.Position = UDim2.new(0, 5, 0, 5)
				ScrollContainer.Size = UDim2.new(1, -15, 1, -5)
				ScrollContainerList.Name = "ScrollContainerList"
				ScrollContainerList.Parent = ScrollContainer
				ScrollContainerList.SortOrder = Enum.SortOrder.LayoutOrder
				ScrollContainerList.Padding = UDim.new(0, 5)
				ScrollContainerList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
					DropdownScroll.CanvasSize = UDim2.new(0, 0, 0, 10 + ScrollContainerList.AbsoluteContentSize.Y + 5)
				end)
				local isbusy = false
				local found = {}
				local searchtable = {}
				local function edit()
					for i in pairs(found) do
						found[i] = nil
					end
					for h, l in pairs(ScrollContainer:GetChildren()) do
						if not l:IsA("UIListLayout") and not l:IsA("UIPadding") and not l:IsA('UIGridLayout') then
							l.Visible = false
						end
					end
					Dropdowntitle.Text = string.lower(Dropdowntitle.Text)
				end
				local function SearchDropdown()
					local Results = {}
					for i, v in pairs(searchtable) do
						if string.find(v, Dropdowntitle.Text) then
							table.insert(found, v)
						end
					end
					for a, b in pairs(ScrollContainer:GetChildren()) do
						for c, d in pairs(found) do
							if d == b.Name then
								b.Visible = true
							end
						end
					end
				end
				local function clear_object_in_list()
					for i, v in next, ScrollContainer:GetChildren() do
						if v:IsA('Frame') then
							v:Destroy()
						end
					end
				end
				local ListNew
                local OrderedList = {} -- Thêm biến lưu thứ tự
                if Selected then
                    ListNew = {}
                    for _, value in ipairs(List) do
                        -- Kiểm tra nếu value trùng với Default thì set true
                        ListNew[value] = (value == Default)
                        table.insert(OrderedList, value) -- Lưu thứ tự
                    end
                else
                    ListNew = List
                end
				local function refreshlist(SortPairs)
					pairs = SortPairs or pairs
					clear_object_in_list()
					searchtable = {}
					for i, v in pairs(ListNew) do
						if Selected then
							table.insert(searchtable, string.lower(i))
						elseif Slider then
							table.insert(searchtable, string.lower(v['Title']))
						else
							table.insert(searchtable, string.lower(v))
						end
					end
					if Selected then
                        for _, i in ipairs(OrderedList) do
                            local v = ListNew[i]
							local SampleItem = New("Frame", {
								Name = string.lower(i),
								BackgroundColor3 = Color3.fromRGB(60, 60, 60),
								BackgroundTransparency = 1.000,
								BorderColor3 = Color3.fromRGB(27, 42, 53),
								LayoutOrder = 1,
								Position = UDim2.new(0, 0, 0.208333328, 0),
								Size = UDim2.new(1, 0, 0, 25),
								Parent = ScrollContainer,
							})
							local SampleItemCorner = New("UICorner", {
								CornerRadius = UDim.new(0, 4),
								Name = "SampleItemCorner",
								Parent = SampleItem,
							})
							local SampleItemBG = New("Frame", {
								Name = "SampleItemBG",
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundColor3 = v and UIColor["Dropdown Selected Check Color"] or Color3.fromRGB(255, 255, 255),
								BackgroundTransparency = v and .5 or 1,
								BorderColor3 = Color3.fromRGB(27, 42, 53),
								Position = UDim2.new(0.5, 0, 0.5, 0),
								Size = UDim2.new(1, 0, 1, 0),
								Parent = SampleItem,
							})
							local SampleItemBGCorner = New("UICorner", {
								CornerRadius = UDim.new(0, 4),
								Name = "SampleItemBGCorner",
								Parent = SampleItemBG,
							})
							local SampleItemTitle = New("TextLabel", {
								Name = "SampleItemTitle",
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BackgroundTransparency = 1.000,
								BorderColor3 = Color3.fromRGB(27, 42, 53),
								Position = UDim2.new(0, 10, 0, 0),
								Size = UDim2.new(1, -40, 0, 25),
								Font = Enum.Font.GothamBlack,
								Text = tostring(i),
								TextColor3 = Color3.fromRGB(255, 255, 255),
								TextSize = 14.000,
								TextStrokeTransparency = 0.500,
								TextXAlignment = Enum.TextXAlignment.Left,
								Parent = SampleItemBG,
							})
							local SampleItemCheck = New("ImageButton", {
								Name = "SampleItemCheck",
								AnchorPoint = Vector2.new(1, 0.5),
								BackgroundTransparency = 1.000,
								Position = UDim2.new(1, 0, 0.5, 0),
								Size = UDim2.new(0, 25, 0, 25),
								ZIndex = 2,
								Image = "rbxassetid://3926305904",
								ImageColor3 = UIColor["Dropdown Selected Check Color"],
								ImageRectOffset = Vector2.new(312, 4),
								ImageRectSize = Vector2.new(24, 24),
								ImageTransparency = v and 0 or 1,
								Parent = SampleItemBG,
							})
							local SampleItemButton = New("TextButton", {
								Name = "SampleItemButton",
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BackgroundTransparency = 1.000,
								BorderColor3 = Color3.fromRGB(0, 0, 0),
								BorderSizePixel = 0,
								Size = UDim2.new(1, 0, 1, 0),
								Font = Enum.Font.SourceSans,
								TextColor3 = getgenv().UIColor["Text Color"],
								TextSize = 14.000,
								TextTransparency = 1.000,
								Parent = SampleItem,
							})
							SampleItemButton.MouseEnter:Connect(function()
								if v then
									return
								end
								TweenService:Create(
											SampleItemBG,
											TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
									BackgroundColor3 = Color3.fromRGB(255, 255, 255)
								}
										):Play()
								TweenService:Create(
											SampleItemBG,
											TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
									BackgroundTransparency = .7
								}
										):Play()
							end)
							SampleItemButton.MouseLeave:Connect(function()
								if v then
									return
								end
								TweenService:Create(
											SampleItemBG,
											TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
									BackgroundColor3 = Color3.fromRGB(255, 255, 255)
								}
										):Play()
								TweenService:Create(
											SampleItemBG,
											TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
									BackgroundTransparency = 1
								}
										):Play()
							end)
							SampleItemButton.MouseButton1Click:Connect(function()
								v = not v
								TweenService:Create(
											SampleItemCheck,
											TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
									ImageTransparency = v and 0 or 1
								}
										):Play()
								TweenService:Create(
											SampleItemBG,
											TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
									BackgroundColor3 = v and UIColor["Dropdown Selected Check Color"] or Color3.fromRGB(255, 255, 255)
								}
										):Play()
								TweenService:Create(
											SampleItemBG,
											TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
									BackgroundTransparency = v and .5 or 1
								}
										):Play()
								if Callback then
									Callback(i, v)
									ListNew[i] = v
								end
								if Search then
									Dropdowntitle.PlaceholderText = Title .. ': '
								else
									Dropdowntitle.Text = Title .. ': '
								end
							end)
						end
					elseif Slider then
						for i, v in pairs(ListNew) do
							local TitleText = tostring(v.Title) or ""
							local minValue = tonumber(v.Min) or 0
							local maxValue = tonumber(v.Max) or 100
							local Precise = v.Precise or false
							local DefaultValue = tonumber(v.Default) or minValue
							local SizeChia = 365;
							local SliderFrame = New("Frame", {
								Name = string.lower(v['Title']),
								BackgroundColor3 = Color3.fromRGB(60, 60, 60),
								BackgroundTransparency = 1.000,
								Position = UDim2.new(0, 0, 0.208333328, 0),
								Size = UDim2.new(1, 0, 0, 50),
								Parent = ScrollContainer,
							})
							local SliderCorner = New("UICorner", {
								CornerRadius = UDim.new(0, 4),
								Name = "SliderCorner",
								Parent = SliderFrame,
							})
							local SliderBG = New("Frame", {
								Name = "Background1",
								AnchorPoint = Vector2.new(0.5, 0.5),
								Position = UDim2.new(0.5, 0, 0.5, 0),
								Size = UDim2.new(1, -10, 1, 0),
								BackgroundColor3 = getgenv().UIColor["Background 1 Color"],
								BackgroundTransparency = getgenv().UIColor["Background 1 Transparency"],
								Parent = SliderFrame,
							})
							local SliderBGCorner = New("UICorner", {
								CornerRadius = UDim.new(0, 4),
								Name = "SliderBGCorner",
								Parent = SliderBG,
							})
							local SliderTitle = New("TextLabel", {
								Name = "TextColor",
								BackgroundColor3 = Color3.fromRGB(230, 230, 230),
								BackgroundTransparency = 1.000,
								Position = UDim2.new(0, 10, 0, 0),
								Size = UDim2.new(1, -10, 0, 25),
								Font = Enum.Font.GothamBlack,
								Text = TitleText,
								TextSize = 14.000,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextColor3 = getgenv().UIColor["Text Color"],
								Parent = SliderBG,
							})
							local SliderBar = New("Frame", {
								Name = "SliderBar",
								AnchorPoint = Vector2.new(.5, 0.5),
								Position = UDim2.new(.5, 0, 0.5, 14),
								Size = UDim2.new(1, -20, 0, 6),
								BackgroundColor3 = getgenv().UIColor["Background 2 Color"],
								Parent = SliderFrame,
							})
							local SliderButton = New("TextButton", {
								Name = "SliderButton ",
								BackgroundColor3 = Color3.fromRGB(230, 230, 230),
								BackgroundTransparency = 1.000,
								Size = UDim2.new(1, 0, 1, 0),
								Font = Enum.Font.GothamBold,
								Text = "",
								TextColor3 = Color3.fromRGB(230, 230, 230),
								TextSize = 14.000,
								Parent = SliderBar,
							})
							local SliderBarCorner = New("UICorner", {
								CornerRadius = UDim.new(1, 0),
								Name = "SliderBarCorner",
								Parent = SliderBar,
							})
							local Bar = New("Frame", {
								Name = "Bar",
								BorderSizePixel = 0,
								Size = UDim2.new(0, 0, 1, 0),
								BackgroundColor3 = getgenv().UIColor["Slider Line Color"],
								Parent = SliderBar,
							})
							local BarCorner = New("UICorner", {
								CornerRadius = UDim.new(1, 0),
								Name = "BarCorner",
								Parent = Bar,
							})
							local Sliderboxframe = New("Frame", {
								Name = "Background2",
								AnchorPoint = Vector2.new(1, 0),
								Position = UDim2.new(1, -10, 0, 5),
								Size = UDim2.new(0, 150, 0, 25),
								BackgroundColor3 = getgenv().UIColor["Background 2 Color"],
								Parent = SliderFrame,
							})
							local Sliderbox = New("UICorner", {
								CornerRadius = UDim.new(0, 4),
								Name = "Sliderbox",
								Parent = Sliderboxframe,
							})
							local Sliderbox_2 = New("TextBox", {
								Name = "TextColor",
								BackgroundColor3 = Color3.fromRGB(230, 230, 230),
								BackgroundTransparency = 1.000,
								Size = UDim2.new(1, 0, 1, 0),
								Font = Enum.Font.GothamBold,
								Text = "",
								TextSize = 14.000,
								TextColor3 = getgenv().UIColor["Text Color"],
								Parent = Sliderboxframe,
							})
							SliderButton.MouseEnter:Connect(function()
								TweenService:Create(Bar, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
									BackgroundColor3 = getgenv().UIColor["Slider Highlight Color"]
								}):Play()
							end)
							SliderButton.MouseLeave:Connect(function()
								TweenService:Create(Bar, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
									BackgroundColor3 = getgenv().UIColor["Slider Line Color"]
								}):Play()
							end)
							local callBackAndSetText = function(val)
								Sliderbox_2.Text = val
								ListNew[i].Default = val
								Callback(i, v)
							end
							if DefaultValue then
								if DefaultValue <= minValue then
									DefaultValue = minValue
								elseif DefaultValue >= maxValue then
									DefaultValue = maxValue
								end
								Bar.Size = UDim2.new(1 - ((maxValue - DefaultValue) / (maxValue - minValue)), 0, 0, 6)
								callBackAndSetText(DefaultValue)
							end
							if SliderRelease then
								local dragging = false
								local dragInput
								local holdTime = 0
								local holdStarted = 0

										-- Function to detect the start of dragging (for both mouse and touch)
								local function onInputBegan(input)
									if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
										holdStarted = tick() -- Record the time when holding starts
										
												-- Listen for release to stop dragging
										input.Changed:Connect(function()
											if input.UserInputState == Enum.UserInputState.End then
												dragging = false
												holdStarted = 0 -- Reset the hold timer
											end
										end)
									end
								end
										
										-- Function to detect when dragging stops
								local function onInputEnded(input)
									if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
										dragging = false
										holdStarted = 0 -- Reset the hold timer
									end
								end

										-- Detect input movement (for both mouse and touch)
								local function onInputChanged(input)
									if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
										dragInput = input
									end
								end
										
										-- Connect the events
								SliderButton.InputBegan:Connect(onInputBegan)
								SliderButton.InputEnded:Connect(onInputEnded)
								SliderButton.InputChanged:Connect(onInputChanged)
										
										-- RenderStepped updates the position while dragging
								RunService.RenderStepped:Connect(function()
									if holdStarted > 0 and (tick() - holdStarted >= holdTime) and not dragging then
										dragging = true
									end
									if dragging and dragInput then
										local value = Precise and  tonumber(string.format("%.1f", (((tonumber(maxValue) - tonumber(minValue)) / SizeChia) * Bar.AbsoluteSize.X) + tonumber(minValue))) or math.floor((((tonumber(maxValue) - tonumber(minValue)) / SizeChia) * Bar.AbsoluteSize.X) + tonumber(minValue))
										pcall(function()
											callBackAndSetText(value)
										end)
										Bar.Size = UDim2.new(0, math.clamp(dragInput.Position.X - Bar.AbsolutePosition.X, 0, SizeChia), 0, 6)
									end
								end)
							else
								local dragging = false
								local dragInput
								local holdTime = 0 -- Time to hold before dragging is enabled
								local holdStarted = 0

										-- Function to detect the start of dragging (for both mouse and touch)
								local function onInputBegan(input)
									if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
										holdStarted = tick() -- Record the time when holding starts
										
												-- Listen for release to stop dragging
										input.Changed:Connect(function()
											if input.UserInputState == Enum.UserInputState.End then
												dragging = false
												holdStarted = 0 -- Reset the hold timer
											end
										end)
									end
								end
										
										-- Function to detect when dragging stops
								local function onInputEnded(input)
									if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
										dragging = false
										holdStarted = 0 -- Reset the hold timer
									end
								end

										-- Detect input movement (for both mouse and touch)
								local function onInputChanged(input)
									if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
										dragInput = input
									end
								end
										
										-- Connect the events
								SliderButton.InputBegan:Connect(onInputBegan)
								SliderButton.InputEnded:Connect(onInputEnded)
								SliderButton.InputChanged:Connect(onInputChanged)
										
										-- RenderStepped updates the position while dragging
								RunService.RenderStepped:Connect(function()
									if holdStarted > 0 and (tick() - holdStarted >= holdTime) and not dragging then
										dragging = true
									end
									if dragging and dragInput then
										local value = Precise and  tonumber(string.format("%.1f", (((tonumber(maxValue) - tonumber(minValue)) / SizeChia) * Bar.AbsoluteSize.X) + tonumber(minValue))) or math.floor((((tonumber(maxValue) - tonumber(minValue)) / SizeChia) * Bar.AbsoluteSize.X) + tonumber(minValue))
										pcall(function()
											callBackAndSetText(value)
										end)
										Bar.Size = UDim2.new(0, math.clamp(dragInput.Position.X - Bar.AbsolutePosition.X, 0, SizeChia), 0, 6)
									end
								end)
							end
							local function GetSliderValue(Value)
								if tonumber(Value) <= minValue then
									Bar.Size = UDim2.new(0, (0 * SizeChia), 0, 6)
									callBackAndSetText(minValue)
								elseif tonumber(Value) >= maxValue then
									Bar.Size = UDim2.new(0, (maxValue  /  maxValue * SizeChia), 0, 6)
									callBackAndSetText(maxValue)
								else
									Bar.Size = UDim2.new(1 - ((maxValue - Value) / (maxValue - minValue)), 0, 0, 6)
									callBackAndSetText(Value)
								end
							end
							Sliderbox_2.FocusLost:Connect(function()
								GetSliderValue(Sliderbox_2.Text)
							end)
						end
					else
						for i, v in pairs (ListNew) do
							if typeof(v) == "string" then
								local SampleItem = New("Frame", {
									Name = string.lower(v),
									BackgroundColor3 = Color3.fromRGB(60, 60, 60),
									BackgroundTransparency = 1.000,
									BorderColor3 = Color3.fromRGB(27, 42, 53),
									LayoutOrder = 1,
									Position = UDim2.new(0, 0, 0.208333328, 0),
									Size = UDim2.new(1, 0, 0, 25),
									Parent = ScrollContainer,
								})
								local SampleItemCorner = New("UICorner", {
									CornerRadius = UDim.new(0, 4),
									Name = "SampleItemCorner",
									Parent = SampleItem,
								})
								local SampleItemBG = New("Frame", {
									Name = "SampleItemBG",
									AnchorPoint = Vector2.new(0.5, 0.5),
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									BackgroundTransparency = 1,
									BorderColor3 = Color3.fromRGB(27, 42, 53),
									Position = UDim2.new(0.5, 0, 0.5, 0),
									Size = UDim2.new(1, 0, 1, 0),
									Parent = SampleItem,
								})
								local SampleItemBGCorner = New("UICorner", {
									CornerRadius = UDim.new(0, 4),
									Name = "SampleItemBGCorner",
									Parent = SampleItemBG,
								})
								local SampleItemTitle = New("TextLabel", {
									Name = "SampleItemTitle",
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									BackgroundTransparency = 1.000,
									BorderColor3 = Color3.fromRGB(27, 42, 53),
									Position = UDim2.new(0, 10, 0, 0),
									Size = UDim2.new(1, -40, 0, 25),
									Font = Enum.Font.GothamBlack,
									Text = v,
									TextColor3 = Color3.fromRGB(255, 255, 255),
									TextSize = 14.000,
									TextStrokeTransparency = 0.500,
									TextXAlignment = Enum.TextXAlignment.Left,
									Parent = SampleItemBG,
								})
								local SampleItemCheck = New("ImageButton", {
									Name = "SampleItemCheck",
									AnchorPoint = Vector2.new(1, 0.5),
									BackgroundTransparency = 1.000,
									Position = UDim2.new(1, 0, 0.5, 0),
									Size = UDim2.new(0, 25, 0, 25),
									ZIndex = 2,
									Image = "rbxassetid://3926305904",
									ImageColor3 = UIColor["Dropdown Selected Check Color"],
									ImageRectOffset = Vector2.new(312, 4),
									ImageRectSize = Vector2.new(24, 24),
									ImageTransparency = 1,
									Parent = SampleItemBG,
								})
								local SampleItemButton = New("TextButton", {
									Name = "SampleItemButton",
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									BackgroundTransparency = 1.000,
									BorderColor3 = Color3.fromRGB(0, 0, 0),
									BorderSizePixel = 0,
									Size = UDim2.new(1, 0, 1, 0),
									Font = Enum.Font.SourceSans,
									TextColor3 = getgenv().UIColor["Text Color"],
									TextSize = 14.000,
									TextTransparency = 1.000,
									Parent = SampleItem,
								})
								SampleItemButton.MouseEnter:Connect(function()
									if Sel.Value == v then
										return
									end
									TweenService:Create(
												SampleItemBG,
												TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
										BackgroundColor3 = Color3.fromRGB(255, 255, 255)
									}
											):Play()
									TweenService:Create(
												SampleItemBG,
												TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
										BackgroundTransparency = .7
									}
											):Play()
								end)
								SampleItemButton.MouseLeave:Connect(function()
									if Sel.Value == v then
										return
									end
									TweenService:Create(
												SampleItemBG,
												TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
										BackgroundColor3 = Color3.fromRGB(255, 255, 255)
									}
											):Play()
									TweenService:Create(
												SampleItemBG,
												TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
										BackgroundTransparency = 1
									}
											):Play()
								end)
								SampleItemButton.MouseButton1Click:Connect(function()
									if Search then
										Dropdowntitle.PlaceholderText = Title .. ': ' .. v or ""
										Sel.Value = v
									else
										Dropdowntitle.Text = Title .. ': ' .. v or ""
										Sel.Value = v
									end
									TweenService:Create(
												SampleItemBG,
												TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
										BackgroundColor3 = UIColor["Dropdown Selected Check Color"]
									}
											):Play()
									TweenService:Create(
												SampleItemBG,
												TweenInfo.new(getgenv().UIColor["Tween Animation 1 Speed"]), {
										BackgroundTransparency = .5
									}
											):Play()
									if Callback then
										Callback(v)
									end
									if Search then
										Dropdowntitle.Text = ""
									end
									refreshlist()
								end)
								if Sel.Value == v then
									SampleItemBG.BackgroundTransparency = .5;
									SampleItemBG.BackgroundColor3 = UIColor["Dropdown Selected Check Color"]
									SampleItem.LayoutOrder = 0
								end
							end
						end
					end
				end
				if Search then
					Dropdowntitle.Changed:Connect(function()
						edit()
						SearchDropdown()
					end)
				end
				if typeof(Default) ~= 'table' then
					if Search then
						Dropdowntitle.PlaceholderText = Title .. ': ' .. tostring(Default or "")
					else
						Dropdowntitle.Text = Title .. ': ' .. tostring(Default or "")
					end
				elseif Slider then
					Dropdowntitle.Text = ''
					Dropdowntitle.PlaceholderText = Title .. ': '
				elseif Selected then
					if Search then
						Dropdowntitle.PlaceholderText = Title .. ': '
					else
						Dropdowntitle.Text = Title .. ': '
					end
				end
				DropdownButton.MouseButton1Click:Connect(function()
					refreshlist()
					isbusy = not isbusy
					local listsize = isbusy and UDim2.new(1, 0, 0, 170) or UDim2.new(1, 0, 0, 0)
					local mainsize = isbusy and UDim2.new(1, 0, 0, 200) or UDim2.new(1, 0, 0, 25)
					local DropCRotation = isbusy and 90 or 0
					TweenService:Create(Dropdownlisttt, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
						Size = listsize
					}):Play()
					TweenService:Create(DropdownFrame, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
						Size = mainsize
					}):Play()
					TweenService:Create(ImgDrop, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
						Rotation = DropCRotation
					}):Play()
				end)
				local dropdownFunction = {
					rf = refreshlist
				}
				function dropdownFunction:ClearText(v)
					if not Selected then
						if Search then
							Dropdowntitle.PlaceholderText = Title .. ': ' .. (v or "")
						else
							Dropdowntitle.Text = Title .. ': ' .. (v or "")
						end
					else
						Dropdowntitle.Text = Title .. ': ' .. (v or "")
					end
				end
				function dropdownFunction:GetNewList(List)
					Sel.Value = ""
							--refreshlist()
					isbusy = false
					local listsize = isbusy and UDim2.new(1, 0, 0, 170) or UDim2.new(1, 0, 0, 0)
					local mainsize = isbusy and UDim2.new(1, 0, 0, 200) or UDim2.new(1, 0, 0, 25)
					local DropCRotation = isbusy and 90 or 0
					TweenService:Create(Dropdownlisttt, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
						Size = listsize
					}):Play()
					TweenService:Create(DropdownFrame, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
						Size = mainsize
					}):Play()
					TweenService:Create(ImgDrop, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
						Rotation = DropCRotation
					}):Play()
					ListNew = {}
					ListNew = List
					refreshlist()
					if Search then
						Dropdowntitle.PlaceholderText = Title .. ': '
					else
						Dropdowntitle.Text = Title .. ': '
					end
				end
				-- THÊM ĐOẠN NÀY
                function dropdownFunction:SetValue(value)
                    if not Selected then
                        -- Dropdown đơn lẻ (single)
                        if table.find(ListNew, value) then
                            Sel.Value = value
                            if Search then
                                Dropdowntitle.PlaceholderText = Title .. ': ' .. value
                            else
                                Dropdowntitle.Text = Title .. ': ' .. value
                            end
                            if Callback then
                                Callback(value)
                            end
                            refreshlist()
                        end
                    else
                        -- Dropdown multi-select
                        if ListNew[value] ~= nil then
                            ListNew[value] = true
                            if Search then
                                Dropdowntitle.PlaceholderText = Title .. ': '
                            else
                                Dropdowntitle.Text = Title .. ': '
                            end
                            if Callback then
                                Callback(value, true)
                            end
                            refreshlist()
                        end
                    end
                end
                
                function dropdownFunction:GetValue()
                    if not Selected then
                        return Sel.Value
                    else
                        local result = {}
                        for key, val in pairs(ListNew) do
                            if val == true then
                                table.insert(result, key)
                            end
                        end
                        return result
                    end
                end
				local controlData = {
                    Name = Title,
                    Section = Section,
                    Element = DropdownFrame,
                    SectionName = Section_Name,
                    TabName = Page_Name,
                    TabButton = PageName,
                    SetValue = dropdownFunction.SetValue,  -- THÊM DÒNG NÀY
                    GetValue = dropdownFunction.GetValue   -- THÊM DÒNG NÀY
                }
                table.insert(getgenv().AllControls, controlData)
                
                return dropdownFunction
			end

function sectionFunction:AddKeyBind(Setting, Callback)
    local TitleText = tostring(Setting.Title or Setting.Text) or ""
    local Default = Setting.Default or Setting.Key or "F"
    local Mode = Setting.Mode or "Toggle" -- Hold hoặc Toggle
    local Callback = Setting.Callback or Callback or function() end
    
    local function GetKeyString(key)
        local keyStr = tostring(key)
        keyStr = keyStr:gsub("Enum.UserInputType.", "")
        keyStr = keyStr:gsub("Enum.KeyCode.", "")
        return keyStr
    end
    
    local CurrentKey = GetKeyString(Default)
    local CurrentMode = Mode
    local Picking = false
    local ToggleState = false
    local HoldActive = false
    
    -- UI Elements (BỎ ModeButton)
    local BindFrame = New("Frame", {
    	Name = TitleText .. "bguvl",
    	BackgroundColor3 = Color3.fromRGB(60, 60, 60),
    	BackgroundTransparency = 1.000,
    	Position = UDim2.new(0, 0, 0.208333328, 0),
    	Size = UDim2.new(1, 0, 0, 35),
    	Parent = Section,
    })
    local BindCorner = New("UICorner", {
    	CornerRadius = UDim.new(0, 4),
    	Name = "BindCorner",
    	Parent = BindFrame,
    })
    local BindBG = New("Frame", {
    	Name = "Background1",
    	AnchorPoint = Vector2.new(0.5, 0.5),
    	Position = UDim2.new(0.5, 0, 0.5, 0),
    	Size = UDim2.new(1, -10, 1, 0),
    	BackgroundColor3 = getgenv().UIColor["Background 1 Color"],
    	BackgroundTransparency = getgenv().UIColor["Background 1 Transparency"],
    	Parent = BindFrame,
    })
    local ButtonCorner = New("UICorner", {
    	CornerRadius = UDim.new(0, 4),
    	Name = "ButtonCorner",
    	Parent = BindBG,
    })
    local BindButtonTitle = New("TextLabel", {
    	Name = "TextColor",
    	BackgroundColor3 = Color3.fromRGB(230, 230, 230),
    	BackgroundTransparency = 1.000,
    	Position = UDim2.new(0, 10, 0, 0),
    	Size = UDim2.new(1, -10, 1, 0),
    	Font = Enum.Font.GothamBlack,
    	Text = TitleText,
    	TextSize = 14.000,
    	TextXAlignment = Enum.TextXAlignment.Left,
    	TextColor3 = getgenv().UIColor["Text Color"],
    	Parent = BindBG,
    })
    local BindCor = New("Frame", {
    	Name = "Background2",
    	AnchorPoint = Vector2.new(1, 0.5),
    	Position = UDim2.new(1, -5, 0.5, 0),
    	Size = UDim2.new(0, 150, 0, 25),
    	BackgroundColor3 = getgenv().UIColor["Background 2 Color"],
    	Parent = BindBG,
    })
    local ButtonCorner_2 = New("UICorner", {
    	CornerRadius = UDim.new(0, 4),
    	Name = "ButtonCorner",
    	Parent = BindCor,
    })
    local Bindkey = New("TextButton", {
    	Name = "Bindkey",
    	BackgroundColor3 = Color3.fromRGB(230, 230, 230),
    	BackgroundTransparency = 1.000,
    	Size = UDim2.new(1, 0, 1, 0),
    	Font = Enum.Font.GothamBold,
    	Text = CurrentKey,
    	TextSize = 14.000,
    	TextColor3 = getgenv().UIColor["Text Color"],
    	Parent = BindCor,
    })
    
    -- Change Key
    Bindkey.MouseButton1Click:Connect(function()
        if Picking then return end
        
        Picking = true
        Bindkey.Text = "..."
        
        task.wait(0.2)
        
        local Connection
        Connection = uis.InputBegan:Connect(function(input)
            if Picking then
                local Key
                
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    Key = input.KeyCode.Name
                elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Key = "MouseLeft"
                elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                    Key = "MouseRight"
                end
                
                if Key then
                    Picking = false
                    CurrentKey = Key
                    Bindkey.Text = Key
                    Connection:Disconnect()
                end
            end
        end)
    end)
    
    -- Input Began (Press)
    uis.InputBegan:Connect(function(input, gpe)
        if gpe or Picking then return end
        if uis:GetFocusedTextBox() then return end
        
        local pressedKey
        if input.UserInputType == Enum.UserInputType.Keyboard then
            pressedKey = input.KeyCode.Name
        elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
            pressedKey = "MouseLeft"
        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
            pressedKey = "MouseRight"
        end
        
        if pressedKey == CurrentKey then
            if CurrentMode == "Toggle" then
                ToggleState = not ToggleState
                pcall(Callback, ToggleState)
            elseif CurrentMode == "Hold" then
                HoldActive = true
                pcall(Callback, true)
            end
        end
    end)
    
    -- Input Ended (Release) - Only for Hold mode
    uis.InputEnded:Connect(function(input)
        if Picking then return end
        if uis:GetFocusedTextBox() then return end
        
        local releasedKey
        if input.UserInputType == Enum.UserInputType.Keyboard then
            releasedKey = input.KeyCode.Name
        elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
            releasedKey = "MouseLeft"
        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
            releasedKey = "MouseRight"
        end
        
        if releasedKey == CurrentKey and CurrentMode == "Hold" and HoldActive then
            HoldActive = false
            pcall(Callback, false)
        end
    end)
    
    local controlData = {
        Name = TitleText,
        Section = Section,
        Element = BindFrame,
        SectionName = Section_Name,
        TabName = Page_Name,
        TabButton = PageName
    }
    table.insert(getgenv().AllControls, controlData)
    
    local keybindFunction = {}
    
    function keybindFunction:Set(newKey)
        CurrentKey = GetKeyString(newKey)
        Bindkey.Text = CurrentKey
    end
    
    function keybindFunction:Get()
        return CurrentKey
    end
    
    function keybindFunction:SetMode(mode)
        if mode == "Hold" or mode == "Toggle" then
            CurrentMode = mode
            ToggleState = false
            HoldActive = false
        end
    end
    
    function keybindFunction:GetMode()
        return CurrentMode
    end
    
    function keybindFunction:GetState()
        if CurrentMode == "Toggle" then
            return ToggleState
        elseif CurrentMode == "Hold" then
            return HoldActive
        end
        return false
    end
    
    return keybindFunction
end
			function sectionFunction:AddInput(idk, Setting)
				local TitleText = tostring(Setting.Text or Setting.Title) or ""
				local Placeholder = tostring(Setting.Placeholder) or ""
				local Default = Setting.Default or false
				local Number_Only = Setting.Numeric or false
				local Callback = Setting.Callback
				local BoxFrame = New("Frame", {
					Name = "BoxFrame",
					BackgroundColor3 = Color3.fromRGB(60, 60, 60),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(0, 0, 0.208333328, 0),
					Size = UDim2.new(1, 0, 0, 60),
					Parent = Section,
				})
				local BoxCorner = New("UICorner", {
					CornerRadius = UDim.new(0, 4),
					Name = "BoxCorner",
					Parent = BoxFrame,
				})
				local BoxBG = New("Frame", {
					Name = "Background1",
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(1, -10, 1, 0),
					BackgroundColor3 = getgenv().UIColor["Background 1 Color"],
					BackgroundTransparency = getgenv().UIColor["Background 1 Transparency"],
					Parent = BoxFrame,
				})
				local ButtonCorner = New("UICorner", {
					CornerRadius = UDim.new(0, 4),
					Name = "ButtonCorner",
					Parent = BoxBG,
				})
				local Boxtitle = New("TextLabel", {
					Name = "TextColor",
					BackgroundColor3 = Color3.fromRGB(230, 230, 230),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(0, 10, 0, 0),
					Size = UDim2.new(1, -10, 0.5, 0),
					Font = Enum.Font.GothamBlack,
					Text = TitleText,
					TextSize = 14.000,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextColor3 = getgenv().UIColor["Text Color"],
					Parent = BoxBG,
				})
				local BoxCor = New("Frame", {
					Name = "Background2",
					AnchorPoint = Vector2.new(1, 0.5),
					ClipsDescendants = true,
					Position = UDim2.new(1, -5, 0, 40),
					Size = UDim2.new(1, -10, 0, 25),
					BackgroundColor3 = getgenv().UIColor["Background 2 Color"],
					Parent = BoxBG,
				})
				local ButtonCorner_2 = New("UICorner", {
					CornerRadius = UDim.new(0, 4),
					Name = "ButtonCorner",
					Parent = BoxCor,
				})
				local Boxxx = New("TextBox", {
					Name = "TextColorPlaceholder",
					BackgroundColor3 = Color3.fromRGB(230, 230, 230),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(0, 5, 0, 0),
					Size = UDim2.new(1, -5, 1, 0),
					Font = Enum.Font.GothamBold,
					PlaceholderText = Placeholder,
					Text = "",
					TextSize = 14.000,
					TextXAlignment = Enum.TextXAlignment.Left,
					PlaceholderColor3 = getgenv().UIColor["Placeholder Text Color"],
					TextColor3 = getgenv().UIColor["Text Color"],
					Parent = BoxCor,
				})
				local Lineeeee = New("Frame", {
					Name = "TextNSBoxLineeeee",
					BackgroundTransparency = 1.000,
					Position = UDim2.new(0, 0, 1, -2),
					Size = UDim2.new(1, 0, 0, 6),
					BackgroundColor3 = getgenv().UIColor["Box Highlight Color"],
					Parent = BoxCor,
				})
				local UICorner = New("UICorner", {
					CornerRadius = UDim.new(1, 0),
					Parent = Lineeeee,
				})
				Boxxx.Focused:Connect(function()
					TweenService:Create(Lineeeee, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
						BackgroundTransparency = 0
					}):Play()
				end)
				if Number_Only then
					Boxxx:GetPropertyChangedSignal("Text"):Connect(function()
						if tonumber(Boxxx.Text) then
						else
							Boxxx.PlaceholderText = Placeholder
							Boxxx.Text = ''
						end
					end)
				end
				Boxxx.FocusLost:Connect(function()
					TweenService:Create(Lineeeee, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
						BackgroundTransparency = 1
					}):Play()
					if Boxxx.Text ~= '' then
						Callback(Boxxx.Text)
					end
				end)
				local textbox_function = {}
				if Default then
					Boxxx.Text = Default
				end
				function textbox_function.SetValue(Value)
					Boxxx.Text = Value
					Callback(Value)
				end
				local controlData = {
                    Name = TitleText,
                    Section = Section,
                    Element = BoxFrame,
                    SectionName = Section_Name,
                    TabName = Page_Name,
                    TabButton = PageName
                }
                table.insert(getgenv().AllControls, controlData)
                
				return textbox_function;
			end
			function sectionFunction:AddSlider(Setting)
				local TitleText = tostring(Setting.Text or Setting.Title) or ""
				local minValue = tonumber(Setting.Min) or 0
				local maxValue = tonumber(Setting.Max) or 100
				local Precise = Setting.Precise or false
				local DefaultValue = tonumber(Setting.Default) or 0
				local Callback = Setting.Callback
				local SizeChia = 400;
				local SliderFrame = New("Frame", {
					Name = TitleText .. 'buda',
					BackgroundColor3 = Color3.fromRGB(60, 60, 60),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(0, 0, 0.208333328, 0),
					Size = UDim2.new(1, 0, 0, 50),
					Parent = Section,
				})
				local SliderCorner = New("UICorner", {
					CornerRadius = UDim.new(0, 4),
					Name = "SliderCorner",
					Parent = SliderFrame,
				})
				local SliderBG = New("Frame", {
					Name = "Background1",
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(1, -10, 1, 0),
					BackgroundColor3 = getgenv().UIColor["Background 1 Color"],
					BackgroundTransparency = getgenv().UIColor["Background 1 Transparency"],
					Parent = SliderFrame,
				})
				local SliderBGCorner = New("UICorner", {
					CornerRadius = UDim.new(0, 4),
					Name = "SliderBGCorner",
					Parent = SliderBG,
				})
				local SliderTitle = New("TextLabel", {
					Name = "TextColor",
					BackgroundColor3 = Color3.fromRGB(230, 230, 230),
					BackgroundTransparency = 1.000,
					Position = UDim2.new(0, 10, 0, 0),
					Size = UDim2.new(1, -10, 0, 25),
					Font = Enum.Font.GothamBlack,
					Text = TitleText,
					TextSize = 14.000,
					RichText = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextColor3 = getgenv().UIColor["Text Color"],
					Parent = SliderBG,
				})
				local SliderBar = New("Frame", {
					Name = "SliderBar",
					AnchorPoint = Vector2.new(.5, 0.5),
					Position = UDim2.new(.5, 0, 0.5, 14),
					Size = UDim2.new(0, 400, 0, 6),
					BackgroundColor3 = getgenv().UIColor["Background 2 Color"],
					Parent = SliderFrame,
				})
				local SliderButton = New("TextButton", {
					Name = "SliderButton ",
					BackgroundColor3 = Color3.fromRGB(230, 230, 230),
					BackgroundTransparency = 1.000,
					Size = UDim2.new(1, 0, 1, 0),
					Font = Enum.Font.GothamBold,
					Text = "",
					TextColor3 = Color3.fromRGB(230, 230, 230),
					TextSize = 14.000,
					Parent = SliderBar,
				})
				local SliderBarCorner = New("UICorner", {
					CornerRadius = UDim.new(1, 0),
					Name = "SliderBarCorner",
					Parent = SliderBar,
				})
				local Bar = New("Frame", {
					Name = "Bar",
					BorderSizePixel = 0,
					Size = UDim2.new(0, 0, 1, 0),
					BackgroundColor3 = getgenv().UIColor["Slider Line Color"],
					Parent = SliderBar,
				})
				local BarCorner = New("UICorner", {
					CornerRadius = UDim.new(1, 0),
					Name = "BarCorner",
					Parent = Bar,
				})
				local Sliderboxframe = New("Frame", {
					Name = "Background2",
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.new(1, -10, 0, 5),
					Size = UDim2.new(0, 150, 0, 25),
					BackgroundColor3 = getgenv().UIColor["Background 2 Color"],
					Parent = SliderFrame,
				})
				local Sliderbox = New("UICorner", {
					CornerRadius = UDim.new(0, 4),
					Name = "Sliderbox",
					Parent = Sliderboxframe,
				})
				local Sliderbox_2 = New("TextBox", {
					Name = "TextColor",
					BackgroundColor3 = Color3.fromRGB(230, 230, 230),
					BackgroundTransparency = 1.000,
					Size = UDim2.new(1, 0, 1, 0),
					Font = Enum.Font.GothamBold,
					Text = "",
					TextSize = 14.000,
					TextColor3 = getgenv().UIColor["Text Color"],
					Parent = Sliderboxframe,
				})
				SliderButton.MouseEnter:Connect(function()
					TweenService:Create(Bar, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
						BackgroundColor3 = getgenv().UIColor["Slider Highlight Color"]
					}):Play()
				end)
				SliderButton.MouseLeave:Connect(function()
					TweenService:Create(Bar, TweenInfo.new(getgenv().UIColor["Tween Animation 2 Speed"]), {
						BackgroundColor3 = getgenv().UIColor["Slider Line Color"]
					}):Play()
				end)
				local callBackAndSetText = function(val)
					Sliderbox_2.Text = val
					Callback(tonumber(val))
				end
				if DefaultValue then
					if DefaultValue <= minValue then
						DefaultValue = minValue
					elseif DefaultValue >= maxValue then
						DefaultValue = maxValue
					end
					Sliderbox_2.Text = tostring(DefaultValue)
					Bar.Size = UDim2.new(1 - ((maxValue - DefaultValue) / (maxValue - minValue)), 0, 0, 6)
				end
				local dragging = false
				local dragInput
				local holdTime = 0 -- Time to hold before dragging is enabled
				local holdStarted = 0

						-- Function to detect the start of dragging (for both mouse and touch)
				local function onInputBegan(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						holdStarted = tick() -- Record the time when holding starts
						
								-- Listen for release to stop dragging
						input.Changed:Connect(function()
							if input.UserInputState == Enum.UserInputState.End then
								dragging = false
								holdStarted = 0 -- Reset the hold timer
							end
						end)
					end
				end
						
						-- Function to detect when dragging stops
				local function onInputEnded(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = false
						holdStarted = 0 -- Reset the hold timer
					end
				end

						-- Detect input movement (for both mouse and touch)
				local function onInputChanged(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
						dragInput = input
					end
				end
						
						-- Connect the events
				SliderButton.InputBegan:Connect(onInputBegan)
				SliderButton.InputEnded:Connect(onInputEnded)
				SliderButton.InputChanged:Connect(onInputChanged)
						
						-- RenderStepped updates the position while dragging
				RunService.RenderStepped:Connect(function()
					if holdStarted > 0 and (tick() - holdStarted >= holdTime) and not dragging then
						dragging = true
					end
					if dragging and dragInput then
						local value = Setting.Rouding and  tonumber(string.format("%.".. Setting.Rouding or 1 .."f", (((tonumber(maxValue) - tonumber(minValue)) / SizeChia) * Bar.AbsoluteSize.X) + tonumber(minValue))) or math.floor((((tonumber(maxValue) - tonumber(minValue)) / SizeChia) * Bar.AbsoluteSize.X) + tonumber(minValue))
						pcall(function()
							callBackAndSetText(value)
						end)
						Bar.Size = UDim2.new(0, math.clamp(dragInput.Position.X - Bar.AbsolutePosition.X, 0, SizeChia), 0, 6)
					end
				end)
				local function GetSliderValue(Value)
					if tonumber(Value) <= minValue then
						Bar.Size = UDim2.new(0, (0 * SizeChia), 0, 6)
						callBackAndSetText(minValue)
					elseif tonumber(Value) >= maxValue then
						Bar.Size = UDim2.new(0, (maxValue  /  maxValue * SizeChia), 0, 6)
						callBackAndSetText(maxValue)
					else
						Bar.Size = UDim2.new(1 - ((maxValue - Value) / (maxValue - minValue)), 0, 0, 6)
						callBackAndSetText(Value)
					end
				end
				Sliderbox_2.FocusLost:Connect(function()
					GetSliderValue(Sliderbox_2.Text)
				end)
				local slider_function = {}
				function slider_function.SetValue(Value)
					GetSliderValue(Value)
				end
				local controlData = {
                    Name = TitleText,
                    Section = Section,
                    Element = SliderFrame,
                    SectionName = Section_Name,
                    TabName = Page_Name,
                    TabButton = PageName
                }
                table.insert(getgenv().AllControls, controlData)
                
				return slider_function
			end
			return sectionFunction
		end
        local pagefunc = {}
        function pagefunc:AddLeftGroupbox(name)
            return pageFunction:AddSection(name)
        end
        function pagefunc:AddRightGroupbox(name)
            return pageFunction:AddSection(name)
        end
		return pagefunc
        end

	-- =====================================================
	-- NEW SIMPLIFIED TAB API
	-- Usage: local Tab = Window:Tab({ Title = "...", Locked = false })
	--        Tab:Toggle({ Title, Desc, Value, Callback })
	--        Tab:Button({ Title, Desc, Callback })
	--        Tab:Slider({ Title, Desc, Step, Value={Min,Max,Default}, Callback })
	--        Tab:Dropdown({ Title, Desc, Values, Value, Callback })
	--        Tab:Input({ Title, Desc, Value, Placeholder, Callback })
	-- =====================================================
	function Main_Function:Tab(Setting)
		local tabTitle = Setting.Title or Setting.Text or "Tab"
		-- Internally reuse the existing AddTab method to build the page
		local pagefunc = self:AddTab(tabTitle)
		-- Create one default section to hold all elements
		local section = pagefunc:AddLeftGroupbox(tabTitle)

		local tabObj = {}

		-- Toggle: Tab:Toggle({ Title, Desc, Type, Value, Callback })
		function tabObj:Toggle(s)
			return section:AddToggle("_", {
				Title    = s.Title or s.Text or "",
				Desc     = s.Desc or s.Description,
				Default  = s.Value or false,
				Callback = s.Callback or function() end,
			})
		end

		-- Button: Tab:Button({ Title, Desc, Locked, Callback })
		function tabObj:Button(s)
			return section:AddButton({
				Title    = s.Title or s.Text or "",
				Callback = s.Callback or function() end,
			})
		end

		-- Slider: Tab:Slider({ Title, Desc, Step, Value={Min,Max,Default}, Callback })
		function tabObj:Slider(s)
			local v = s.Value or {}
			return section:AddSlider({
				Title    = s.Title or s.Text or "",
				Min      = v.Min or 0,
				Max      = v.Max or 100,
				Default  = v.Default or v.Min or 0,
				Precise  = s.Step and (s.Step < 1) or false,
				Callback = s.Callback or function() end,
			})
		end

		-- Dropdown: Tab:Dropdown({ Title, Desc, Values, Value, Callback })
		function tabObj:Dropdown(s)
			return section:AddDropdown("_", {
				Title    = s.Title or s.Text or "",
				Values   = s.Values or {},
				Default  = s.Value,
				Callback = s.Callback or function() end,
			})
		end

		-- Input: Tab:Input({ Title, Desc, Value, InputIcon, Type, Placeholder, Callback })
		function tabObj:Input(s)
			return section:AddInput("_", {
				Title       = s.Title or s.Text or "",
				Placeholder = s.Placeholder or "",
				Default     = s.Value or false,
				Callback    = s.Callback or function() end,
			})
		end

		return tabObj
	end
	-- =====================================================

	return Main_Function
end

return Library
