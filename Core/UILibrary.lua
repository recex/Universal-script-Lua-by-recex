-- [[ RECEX HUB — CORE/UILIBRARY.LUA ]] --
-- [[ Biblioteca de Interface Studio (Made by recex) ]] --

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Palette = {
    Obsidian   = Color3.fromRGB(10, 11, 15),
    Surface    = Color3.fromRGB(15, 17, 23),
    Card       = Color3.fromRGB(20, 22, 30),
    CardHover  = Color3.fromRGB(26, 29, 39),
    Border     = Color3.fromRGB(36, 39, 52),
    Gold       = Color3.fromRGB(255, 200, 115),
    GoldDark   = Color3.fromRGB(185, 135, 65),
    PureWhite  = Color3.fromRGB(245, 247, 255),
    MutedText  = Color3.fromRGB(140, 145, 165)
}

local function PlayUISound(id, vol, pitch)
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://" .. tostring(id)
    s.Volume = vol or 0.4
    s.PlaybackSpeed = pitch or 1
    s.Parent = SoundService
    s:Play()
    task.delay(3, function() if s then s:Destroy() end end)
end

local function MakeDraggable(dragHandle, targetFrame)
    local dragging, dragInput, dragStart, startPos
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = targetFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            targetFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function CreateRecexHub()
    if PlayerGui:FindFirstChild("RecexStudioHub") then
        PlayerGui.RecexStudioHub:Destroy()
    end

    local HubGui = Instance.new("ScreenGui", PlayerGui)
    HubGui.Name = "RecexStudioHub"; HubGui.IgnoreGuiInset = true; HubGui.ResetOnSpawn = false

    -- Notificações
    local NotifyHolder = Instance.new("Frame", HubGui)
    NotifyHolder.Size = UDim2.new(0, 300, 1, -40); NotifyHolder.Position = UDim2.new(1, -320, 0, 20); NotifyHolder.BackgroundTransparency = 1
    local NotifyLayout = Instance.new("UIListLayout", NotifyHolder)
    NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom; NotifyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right; NotifyLayout.Padding = UDim.new(0, 10)

    local function Notify(title, text, duration)
        duration = duration or 3.5
        PlayUISound(6895079853, 0.45, 1.15)
        local Card = Instance.new("Frame", NotifyHolder)
        Card.Size = UDim2.new(1, 0, 0, 66); Card.BackgroundColor3 = Palette.Obsidian; Card.BackgroundTransparency = 0.05; Card.ClipsDescendants = true
        Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 8)
        local Stroke = Instance.new("UIStroke", Card); Stroke.Color = Palette.GoldDark; Stroke.Thickness = 1

        local T = Instance.new("TextLabel", Card)
        T.Size = UDim2.new(1, -24, 0, 20); T.Position = UDim2.new(0, 12, 0, 10); T.BackgroundTransparency = 1; T.Text = string.upper(title); T.TextColor3 = Palette.Gold; T.Font = Enum.Font.GothamBold; T.TextSize = 12; T.TextXAlignment = Enum.TextXAlignment.Left

        local D = Instance.new("TextLabel", Card)
        D.Size = UDim2.new(1, -24, 0, 22); D.Position = UDim2.new(0, 12, 0, 30); D.BackgroundTransparency = 1; D.Text = text; D.TextColor3 = Palette.PureWhite; D.Font = Enum.Font.GothamMedium; D.TextSize = 12; D.TextXAlignment = Enum.TextXAlignment.Left

        local ProgBar = Instance.new("Frame", Card)
        ProgBar.Size = UDim2.new(1, 0, 0, 2); ProgBar.Position = UDim2.new(0, 0, 1, -2); ProgBar.BackgroundColor3 = Palette.Gold; ProgBar.BorderSizePixel = 0

        TweenService:Create(ProgBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 2)}):Play()
        task.delay(duration, function()
            local out = TweenService:Create(Card, TweenInfo.new(0.3), {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0)})
            out:Play(); out.Completed:Wait(); Card:Destroy()
        end)
    end

    -- Botão Flutuante
    local FloatToggle = Instance.new("TextButton", HubGui)
    FloatToggle.Size = UDim2.new(0, 46, 0, 46); FloatToggle.Position = UDim2.new(0, 25, 0.5, -23); FloatToggle.BackgroundColor3 = Palette.Obsidian; FloatToggle.Text = "R"; FloatToggle.TextColor3 = Palette.Gold; FloatToggle.Font = Enum.Font.GothamBlack; FloatToggle.TextSize = 20
    Instance.new("UICorner", FloatToggle).CornerRadius = UDim.new(0, 12)
    local FloatStroke = Instance.new("UIStroke", FloatToggle); FloatStroke.Color = Palette.Gold; FloatStroke.Thickness = 1.5
    MakeDraggable(FloatToggle, FloatToggle)

    -- Janela Principal
    local MainWindow = Instance.new("Frame", HubGui)
    MainWindow.Size = UDim2.new(0, 0, 0, 0); MainWindow.Position = UDim2.new(0.5, 0, 0.5, 0); MainWindow.AnchorPoint = Vector2.new(0.5, 0.5); MainWindow.BackgroundColor3 = Palette.Obsidian; MainWindow.ClipsDescendants = true
    Instance.new("UICorner", MainWindow).CornerRadius = UDim.new(0, 12)
    local MainStroke = Instance.new("UIStroke", MainWindow); MainStroke.Color = Palette.Border; MainStroke.Thickness = 1.2

    local Header = Instance.new("Frame", MainWindow)
    Header.Size = UDim2.new(1, 0, 0, 48); Header.BackgroundColor3 = Palette.Surface; Header.BorderSizePixel = 0
    MakeDraggable(Header, MainWindow)

    local HeaderLine = Instance.new("Frame", Header)
    HeaderLine.Size = UDim2.new(1, 0, 0, 1); HeaderLine.Position = UDim2.new(0, 0, 1, -1); HeaderLine.BackgroundColor3 = Palette.Border; HeaderLine.BorderSizePixel = 0

    local BrandTitle = Instance.new("TextLabel", Header)
    BrandTitle.Size = UDim2.new(0, 200, 1, 0); BrandTitle.Position = UDim2.new(0, 20, 0, 0); BrandTitle.BackgroundTransparency = 1; BrandTitle.Text = "RECEX HUB"; BrandTitle.TextColor3 = Palette.PureWhite; BrandTitle.Font = Enum.Font.GothamBlack; BrandTitle.TextSize = 16; BrandTitle.TextXAlignment = Enum.TextXAlignment.Left

    local BrandBadge = Instance.new("TextLabel", Header)
    BrandBadge.Size = UDim2.new(0, 130, 0, 22); BrandBadge.Position = UDim2.new(0, 125, 0.5, -11); BrandBadge.BackgroundColor3 = Color3.fromRGB(28, 25, 20); BrandBadge.Text = "MADE BY RECEX"; BrandBadge.TextColor3 = Palette.Gold; BrandBadge.Font = Enum.Font.GothamBold; BrandBadge.TextSize = 10
    Instance.new("UICorner", BrandBadge).CornerRadius = UDim.new(0, 4)
    local BadgeStroke = Instance.new("UIStroke", BrandBadge); BadgeStroke.Color = Palette.GoldDark; BadgeStroke.Thickness = 1

    local MinimizeBtn = Instance.new("TextButton", Header)
    MinimizeBtn.Size = UDim2.new(0, 32, 0, 32); MinimizeBtn.Position = UDim2.new(1, -44, 0.5, -16); MinimizeBtn.BackgroundColor3 = Palette.Card; MinimizeBtn.Text = "—"; MinimizeBtn.TextColor3 = Palette.MutedText; MinimizeBtn.Font = Enum.Font.GothamBold; MinimizeBtn.TextSize = 14
    Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 6)

    local Sidebar = Instance.new("Frame", MainWindow)
    Sidebar.Size = UDim2.new(0, 185, 1, -48); Sidebar.Position = UDim2.new(0, 0, 0, 48); Sidebar.BackgroundColor3 = Palette.Surface; Sidebar.BorderSizePixel = 0

    local SideDivider = Instance.new("Frame", Sidebar)
    SideDivider.Size = UDim2.new(0, 1, 1, 0); SideDivider.Position = UDim2.new(1, -1, 0, 0); SideDivider.BackgroundColor3 = Palette.Border; SideDivider.BorderSizePixel = 0

    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, -20, 1, -85); TabContainer.Position = UDim2.new(0, 10, 0, 12); TabContainer.BackgroundTransparency = 1; TabContainer.ScrollBarThickness = 0
    local TabListLayout = Instance.new("UIListLayout", TabContainer)
    TabListLayout.Padding = UDim.new(0, 6); TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local ProfileCard = Instance.new("Frame", Sidebar)
    ProfileCard.Size = UDim2.new(1, -20, 0, 54); ProfileCard.Position = UDim2.new(0, 10, 1, -64); ProfileCard.BackgroundColor3 = Palette.Card
    Instance.new("UICorner", ProfileCard).CornerRadius = UDim.new(0, 8)
    local ProfStroke = Instance.new("UIStroke", ProfileCard); ProfStroke.Color = Palette.Border; ProfStroke.Thickness = 1

    local AvatarImg = Instance.new("ImageLabel", ProfileCard)
    AvatarImg.Size = UDim2.new(0, 36, 0, 36); AvatarImg.Position = UDim2.new(0, 9, 0.5, -18); AvatarImg.BackgroundColor3 = Palette.Obsidian
    Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)
    task.spawn(function()
        local ok, img = pcall(function()
            return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        end)
        if ok and img then AvatarImg.Image = img end
    end)

    local PlayerNameLbl = Instance.new("TextLabel", ProfileCard)
    PlayerNameLbl.Size = UDim2.new(1, -55, 0, 18); PlayerNameLbl.Position = UDim2.new(0, 52, 0, 10); PlayerNameLbl.BackgroundTransparency = 1; PlayerNameLbl.Text = LocalPlayer.DisplayName; PlayerNameLbl.TextColor3 = Palette.PureWhite; PlayerNameLbl.Font = Enum.Font.GothamBold; PlayerNameLbl.TextSize = 12; PlayerNameLbl.TextXAlignment = Enum.TextXAlignment.Left; PlayerNameLbl.TextTruncate = Enum.TextTruncate.AtEnd

    local PlayerRankLbl = Instance.new("TextLabel", ProfileCard)
    PlayerRankLbl.Size = UDim2.new(1, -55, 0, 14); PlayerRankLbl.Position = UDim2.new(0, 52, 0, 28); PlayerRankLbl.BackgroundTransparency = 1; PlayerRankLbl.Text = "GitHub Modular v1.0"; PlayerRankLbl.TextColor3 = Palette.Gold; PlayerRankLbl.Font = Enum.Font.GothamMedium; PlayerRankLbl.TextSize = 10; PlayerRankLbl.TextXAlignment = Enum.TextXAlignment.Left

    local PagesArea = Instance.new("Frame", MainWindow)
    PagesArea.Size = UDim2.new(1, -185, 1, -48); PagesArea.Position = UDim2.new(0, 185, 0, 48); PagesArea.BackgroundTransparency = 1

    local isOpen = true
    local function ToggleHub()
        isOpen = not isOpen
        PlayUISound(6895079853, 0.4, isOpen and 1.1 or 0.9)
        if isOpen then
            MainWindow.Visible = true
            TweenService:Create(MainWindow, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 640, 0, 410)}):Play()
        else
            local tw = TweenService:Create(MainWindow, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
            tw:Play()
            tw.Completed:Connect(function() if not isOpen then MainWindow.Visible = false end end)
        end
    end

    MinimizeBtn.MouseButton1Click:Connect(ToggleHub)
    FloatToggle.MouseButton1Click:Connect(ToggleHub)
    UserInputService.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == Enum.KeyCode.RightControl then ToggleHub() end
    end)

    TweenService:Create(MainWindow, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 640, 0, 410)}):Play()

    local Tabs = {}
    local FirstTab = true
    local HubAPI = { Notify = Notify }

    function HubAPI:CreateTab(tabName)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, 0, 0, 36); TabBtn.BackgroundColor3 = Palette.Card; TabBtn.BackgroundTransparency = FirstTab and 0 or 1; TabBtn.Text = "    " .. tabName; TabBtn.TextColor3 = FirstTab and Palette.Gold or Palette.MutedText; TabBtn.Font = Enum.Font.GothamSemibold; TabBtn.TextSize = 13; TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        local Indicator = Instance.new("Frame", TabBtn)
        Indicator.Size = UDim2.new(0, 3, 0, FirstTab and 18 or 0); Indicator.Position = UDim2.new(0, 0, 0.5, 0); Indicator.AnchorPoint = Vector2.new(0, 0.5); Indicator.BackgroundColor3 = Palette.Gold; Indicator.BorderSizePixel = 0
        Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

        local Page = Instance.new("ScrollingFrame", PagesArea)
        Page.Size = UDim2.new(1, -28, 1, -24); Page.Position = UDim2.new(0, 14, 0, 12); Page.BackgroundTransparency = 1; Page.ScrollBarThickness = 3; Page.ScrollBarImageColor3 = Palette.GoldDark; Page.Visible = FirstTab

        local PageLayout = Instance.new("UIListLayout", Page)
        PageLayout.Padding = UDim.new(0, 8); PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 14)
        end)

        table.insert(Tabs, {Btn = TabBtn, Ind = Indicator, Page = Page})
        FirstTab = false

        TabBtn.MouseButton1Click:Connect(function()
            PlayUISound(6895079853, 0.35, 1.2)
            for _, t in ipairs(Tabs) do
                t.Page.Visible = false
                TweenService:Create(t.Btn, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = Palette.MutedText}):Play()
                TweenService:Create(t.Ind, TweenInfo.new(0.2), {Size = UDim2.new(0, 3, 0, 0)}):Play()
            end
            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.25), {BackgroundTransparency = 0, TextColor3 = Palette.Gold}):Play()
            TweenService:Create(Indicator, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Size = UDim2.new(0, 3, 0, 18)}):Play()
        end)

        local TabElements = {}

        function TabElements:AddSection(sectionTitle)
            local Sec = Instance.new("TextLabel", Page)
            Sec.Size = UDim2.new(1, 0, 0, 24); Sec.BackgroundTransparency = 1; Sec.Text = string.upper(sectionTitle); Sec.TextColor3 = Palette.Gold; Sec.Font = Enum.Font.GothamBold; Sec.TextSize = 11; Sec.TextXAlignment = Enum.TextXAlignment.Left
        end

        function TabElements:AddButton(title, desc, callback)
            local BtnCard = Instance.new("TextButton", Page)
            BtnCard.Size = UDim2.new(1, -6, 0, 52); BtnCard.BackgroundColor3 = Palette.Card; BtnCard.Text = ""; BtnCard.AutoButtonColor = false
            Instance.new("UICorner", BtnCard).CornerRadius = UDim.new(0, 8)
            local CardStroke = Instance.new("UIStroke", BtnCard); CardStroke.Color = Palette.Border; CardStroke.Thickness = 1

            local T = Instance.new("TextLabel", BtnCard)
            T.Size = UDim2.new(1, -80, 0, 20); T.Position = UDim2.new(0, 14, 0, 8); T.BackgroundTransparency = 1; T.Text = title; T.TextColor3 = Palette.PureWhite; T.Font = Enum.Font.GothamBold; T.TextSize = 13; T.TextXAlignment = Enum.TextXAlignment.Left

            local D = Instance.new("TextLabel", BtnCard)
            D.Size = UDim2.new(1, -80, 0, 16); D.Position = UDim2.new(0, 14, 0, 28); D.BackgroundTransparency = 1; D.Text = desc or ""; D.TextColor3 = Palette.MutedText; D.Font = Enum.Font.Gotham; D.TextSize = 11; D.TextXAlignment = Enum.TextXAlignment.Left

            local ExecBadge = Instance.new("TextLabel", BtnCard)
            ExecBadge.Size = UDim2.new(0, 62, 0, 24); ExecBadge.Position = UDim2.new(1, -74, 0.5, -12); ExecBadge.BackgroundColor3 = Palette.Surface; ExecBadge.Text = "EXECUTAR"; ExecBadge.TextColor3 = Palette.Gold; ExecBadge.Font = Enum.Font.GothamBold; ExecBadge.TextSize = 9
            Instance.new("UICorner", ExecBadge).CornerRadius = UDim.new(0, 4)

            BtnCard.MouseEnter:Connect(function()
                TweenService:Create(BtnCard, TweenInfo.new(0.15), {BackgroundColor3 = Palette.CardHover}):Play()
                TweenService:Create(CardStroke, TweenInfo.new(0.15), {Color = Palette.GoldDark}):Play()
            end)
            BtnCard.MouseLeave:Connect(function()
                TweenService:Create(BtnCard, TweenInfo.new(0.15), {BackgroundColor3 = Palette.Card}):Play()
                TweenService:Create(CardStroke, TweenInfo.new(0.15), {Color = Palette.Border}):Play()
            end)
            BtnCard.MouseButton1Click:Connect(function()
                PlayUISound(6895079853, 0.45, 1.05)
                if callback then task.spawn(callback) end
            end)
        end

        function TabElements:AddToggle(title, desc, defaultState, callback)
            local state = defaultState or false
            local TogCard = Instance.new("TextButton", Page)
            TogCard.Size = UDim2.new(1, -6, 0, 52); TogCard.BackgroundColor3 = Palette.Card; TogCard.Text = ""; TogCard.AutoButtonColor = false
            Instance.new("UICorner", TogCard).CornerRadius = UDim.new(0, 8)
            local CardStroke = Instance.new("UIStroke", TogCard); CardStroke.Color = state and Palette.GoldDark or Palette.Border; CardStroke.Thickness = 1

            local T = Instance.new("TextLabel", TogCard)
            T.Size = UDim2.new(1, -80, 0, 20); T.Position = UDim2.new(0, 14, 0, 8); T.BackgroundTransparency = 1; T.Text = title; T.TextColor3 = Palette.PureWhite; T.Font = Enum.Font.GothamBold; T.TextSize = 13; T.TextXAlignment = Enum.TextXAlignment.Left

            local D = Instance.new("TextLabel", TogCard)
            D.Size = UDim2.new(1, -80, 0, 16); D.Position = UDim2.new(0, 14, 0, 28); D.BackgroundTransparency = 1; D.Text = desc or ""; D.TextColor3 = Palette.MutedText; D.Font = Enum.Font.Gotham; D.TextSize = 11; D.TextXAlignment = Enum.TextXAlignment.Left

            local SwitchBg = Instance.new("Frame", TogCard)
            SwitchBg.Size = UDim2.new(0, 44, 0, 22); SwitchBg.Position = UDim2.new(1, -58, 0.5, -11); SwitchBg.BackgroundColor3 = state and Palette.Gold or Palette.Surface
            Instance.new("UICorner", SwitchBg).CornerRadius = UDim.new(1, 0)

            local Knob = Instance.new("Frame", SwitchBg)
            Knob.Size = UDim2.new(0, 16, 0, 16); Knob.Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8); Knob.BackgroundColor3 = state and Palette.Obsidian or Palette.MutedText
            Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

            TogCard.MouseButton1Click:Connect(function()
                state = not state
                PlayUISound(6895079853, 0.45, state and 1.25 or 0.95)
                TweenService:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = state and Palette.Gold or Palette.Surface}):Play()
                TweenService:Create(Knob, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
                    Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
                    BackgroundColor3 = state and Palette.Obsidian or Palette.MutedText
                }):Play()
                TweenService:Create(CardStroke, TweenInfo.new(0.2), {Color = state and Palette.GoldDark or Palette.Border}):Play()
                if callback then task.spawn(callback, state) end
            end)
        end

        function TabElements:AddSlider(title, minVal, maxVal, defaultVal, callback)
            local currentVal = defaultVal or minVal
            local SliderCard = Instance.new("Frame", Page)
            SliderCard.Size = UDim2.new(1, -6, 0, 58); SliderCard.BackgroundColor3 = Palette.Card
            Instance.new("UICorner", SliderCard).CornerRadius = UDim.new(0, 8)
            local CardStroke = Instance.new("UIStroke", SliderCard); CardStroke.Color = Palette.Border; CardStroke.Thickness = 1

            local T = Instance.new("TextLabel", SliderCard)
            T.Size = UDim2.new(0.7, 0, 0, 20); T.Position = UDim2.new(0, 14, 0, 8); T.BackgroundTransparency = 1; T.Text = title; T.TextColor3 = Palette.PureWhite; T.Font = Enum.Font.GothamBold; T.TextSize = 13; T.TextXAlignment = Enum.TextXAlignment.Left

            local ValLbl = Instance.new("TextLabel", SliderCard)
            ValLbl.Size = UDim2.new(0.3, -14, 0, 20); ValLbl.Position = UDim2.new(0.7, 0, 0, 8); ValLbl.BackgroundTransparency = 1; ValLbl.Text = tostring(currentVal); ValLbl.TextColor3 = Palette.Gold; ValLbl.Font = Enum.Font.GothamBold; ValLbl.TextSize = 13; ValLbl.TextXAlignment = Enum.TextXAlignment.Right

            local BarTrack = Instance.new("TextButton", SliderCard)
            BarTrack.Size = UDim2.new(1, -28, 0, 6); BarTrack.Position = UDim2.new(0, 14, 0, 38); BarTrack.BackgroundColor3 = Palette.Surface; BarTrack.Text = ""; BarTrack.AutoButtonColor = false
            Instance.new("UICorner", BarTrack).CornerRadius = UDim.new(1, 0)

            local initPct = math.clamp((currentVal - minVal) / (maxVal - minVal), 0, 1)
            local BarFill = Instance.new("Frame", BarTrack)
            BarFill.Size = UDim2.new(initPct, 0, 1, 0); BarFill.BackgroundColor3 = Palette.Gold
            Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)

            local draggingSlider = false
            local function UpdateSlider(input)
                local pct = math.clamp((input.Position.X - BarTrack.AbsolutePosition.X) / BarTrack.AbsoluteSize.X, 0, 1)
                local val = math.floor(minVal + (maxVal - minVal) * pct)
                ValLbl.Text = tostring(val)
                BarFill.Size = UDim2.new(pct, 0, 1, 0)
                if callback then task.spawn(callback, val) end
            end

            BarTrack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = true; UpdateSlider(input)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlider(input)
                end
            end)
        end

        return TabElements
    end

    return HubAPI
end

return CreateRecexHub
