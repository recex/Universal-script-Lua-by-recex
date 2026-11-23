-- [[ RECEX HUB — CORE/UILIBRARY.LUA (V2: COMPACT ANIMATED & LO-FI EDITION) ]] --
-- [[ Made by recex ]] --

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Paleta Lo-Fi Cozy & Luxury (Mais escura, suave e moderna)
local Palette = {
    BgDark     = Color3.fromRGB(11, 11, 16),
    SidebarBg  = Color3.fromRGB(15, 15, 22),
    Card       = Color3.fromRGB(20, 21, 30),
    CardHover  = Color3.fromRGB(26, 27, 38),
    Border     = Color3.fromRGB(36, 38, 52),
    Gold       = Color3.fromRGB(255, 202, 122),
    Violet     = Color3.fromRGB(158, 115, 255),
    PureWhite  = Color3.fromRGB(245, 246, 252),
    MutedText  = Color3.fromRGB(138, 142, 162)
}

-- ==========================================
-- 1. SISTEMA DE SOM LO-FI & EFEITOS SUAVES
-- ==========================================
local LofiTracks = {
    { Name = "Relaxed Scene", Id = 1848354536 },
    { Name = "Cozy Night",    Id = 9043887091 },
    { Name = "Chill Jazz",    Id = 1837879082 }
}

local function PlaySoftSFX(id, vol, pitch)
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://" .. tostring(id)
    s.Volume = vol or 0.25
    s.PlaybackSpeed = pitch or 1
    s.Parent = SoundService
    s:Play()
    task.delay(2, function() if s then s:Destroy() end end)
end

-- Efeito de Onda no Clique (Ripple Animation)
local function SpawnRipple(parentButton, inputPos)
    local ripple = Instance.new("Frame")
    ripple.BackgroundColor3 = Palette.Gold
    ripple.BackgroundTransparency = 0.72
    ripple.BorderSizePixel = 0
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)

    local relX = inputPos and (inputPos.X - parentButton.AbsolutePosition.X) or (parentButton.AbsoluteSize.X / 2)
    local relY = inputPos and (inputPos.Y - parentButton.AbsolutePosition.Y) or (parentButton.AbsoluteSize.Y / 2)
    ripple.Position = UDim2.new(0, relX, 0, relY)
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.ZIndex = parentButton.ZIndex + 2
    ripple.Parent = parentButton

    Instance.new("UICorner", ripple).CornerRadius = UDim.new(1, 0)

    local maxSize = math.max(parentButton.AbsoluteSize.X, parentButton.AbsoluteSize.Y) * 2.2
    local tw = TweenService:Create(ripple, TweenInfo.new(0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        BackgroundTransparency = 1
    })
    tw:Play()
    tw.Completed:Connect(function() ripple:Destroy() end)
end

-- Sistema de Arrastar Suave (Smooth Dragging com Inércia)
local function MakeSmoothDraggable(dragHandle, targetFrame)
    local dragging, dragInput, dragStart, startPos
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = targetFrame.Position
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
            local goalPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            TweenService:Create(targetFrame, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = goalPos
            }):Play()
        end
    end)
end

-- ==========================================
-- 2. CONSTRUÇÃO DO HUB COMPACTO E ANIMADO
-- ==========================================
local function CreateRecexHub()
    if PlayerGui:FindFirstChild("RecexStudioHub") then
        PlayerGui.RecexStudioHub:Destroy()
    end
    if SoundService:FindFirstChild("RecexLofiPlayer") then
        SoundService.RecexLofiPlayer:Destroy()
    end

    local HubGui = Instance.new("ScreenGui", PlayerGui)
    HubGui.Name = "RecexStudioHub"
    HubGui.IgnoreGuiInset = true
    HubGui.ResetOnSpawn = false

    -- Inicia o Player de Música Lo-Fi no Fundo
    local currentTrackIdx = 1
    local lofiPlaying = true
    local LofiSound = Instance.new("Sound", SoundService)
    LofiSound.Name = "RecexLofiPlayer"
    LofiSound.SoundId = "rbxassetid://" .. tostring(LofiTracks[currentTrackIdx].Id)
    LofiSound.Volume = 0
    LofiSound.Looped = true
    LofiSound:Play()
    TweenService:Create(LofiSound, TweenInfo.new(2), {Volume = 0.22}):Play()

    -- Container de Notificações Compactas
    local NotifyHolder = Instance.new("Frame", HubGui)
    NotifyHolder.Size = UDim2.new(0, 250, 1, -30)
    NotifyHolder.Position = UDim2.new(1, -265, 0, 15)
    NotifyHolder.BackgroundTransparency = 1
    local NotifyLayout = Instance.new("UIListLayout", NotifyHolder)
    NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    NotifyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    NotifyLayout.Padding = UDim.new(0, 8)

    local function Notify(title, text, duration)
        duration = duration or 3
        PlaySoftSFX(6895079853, 0.25, 0.92)

        local Card = Instance.new("Frame", NotifyHolder)
        Card.Size = UDim2.new(1, 0, 0, 54)
        Card.BackgroundColor3 = Palette.BgDark
        Card.BackgroundTransparency = 0.08
        Card.ClipsDescendants = true
        Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 8)

        local CardScale = Instance.new("UIScale", Card)
        CardScale.Scale = 0.85
        TweenService:Create(CardScale, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()

        local Stroke = Instance.new("UIStroke", Card)
        Stroke.Color = Palette.Gold
        Stroke.Transparency = 0.4
        Stroke.Thickness = 1

        local T = Instance.new("TextLabel", Card)
        T.Size = UDim2.new(1, -20, 0, 16)
        T.Position = UDim2.new(0, 10, 0, 7)
        T.BackgroundTransparency = 1
        T.Text = "✦ " .. string.upper(title)
        T.TextColor3 = Palette.Gold
        T.Font = Enum.Font.GothamBold
        T.TextSize = 11
        T.TextXAlignment = Enum.TextXAlignment.Left

        local D = Instance.new("TextLabel", Card)
        D.Size = UDim2.new(1, -20, 0, 22)
        D.Position = UDim2.new(0, 10, 0, 23)
        D.BackgroundTransparency = 1
        D.Text = text
        D.TextColor3 = Palette.PureWhite
        D.Font = Enum.Font.GothamMedium
        D.TextSize = 11
        D.TextWrapped = true
        D.TextXAlignment = Enum.TextXAlignment.Left

        local ProgBar = Instance.new("Frame", Card)
        ProgBar.Size = UDim2.new(1, 0, 0, 2)
        ProgBar.Position = UDim2.new(0, 0, 1, -2)
        ProgBar.BackgroundColor3 = Palette.Gold
        ProgBar.BorderSizePixel = 0

        TweenService:Create(ProgBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 2)}):Play()
        task.delay(duration, function()
            local out = TweenService:Create(CardScale, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Scale = 0})
            out:Play()
            out.Completed:Wait()
            Card:Destroy()
        end)
    end

    -- Botão Flutuante Compacto (Com Pulso Animado)
    local FloatToggle = Instance.new("TextButton", HubGui)
    FloatToggle.Size = UDim2.new(0, 38, 0, 38)
    FloatToggle.Position = UDim2.new(0, 20, 0.5, -19)
    FloatToggle.BackgroundColor3 = Palette.BgDark
    FloatToggle.Text = "R"
    FloatToggle.TextColor3 = Palette.Gold
    FloatToggle.Font = Enum.Font.GothamBlack
    FloatToggle.TextSize = 17
    FloatToggle.AutoButtonColor = false
    Instance.new("UICorner", FloatToggle).CornerRadius = UDim.new(1, 0)
    local FloatStroke = Instance.new("UIStroke", FloatToggle)
    FloatStroke.Color = Palette.Gold
    FloatStroke.Thickness = 1.5
    MakeSmoothDraggable(FloatToggle, FloatToggle)

    -- ==========================================
    -- 3. JANELA PRINCIPAL COMPACTA (470 x 300)
    -- ==========================================
    local MainWindow = Instance.new("Frame", HubGui)
    MainWindow.Size = UDim2.new(0, 470, 0, 300)
    MainWindow.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainWindow.AnchorPoint = Vector2.new(0.5, 0.5)
    MainWindow.BackgroundColor3 = Palette.BgDark
    MainWindow.BackgroundTransparency = 0.04
    MainWindow.ClipsDescendants = true
    Instance.new("UICorner", MainWindow).CornerRadius = UDim.new(0, 12)

    -- Escala para Animação Elástica de Abrir/Fechar
    local WindowScale = Instance.new("UIScale", MainWindow)
    WindowScale.Scale = 0

    -- Borda com Brilho Rotativo Contínuo (Gold <-> Violet)
    local AnimatedStroke = Instance.new("UIStroke", MainWindow)
    AnimatedStroke.Thickness = 1.5
    AnimatedStroke.Color = Palette.PureWhite

    local StrokeGradient = Instance.new("UIGradient", AnimatedStroke)
    StrokeGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Palette.Gold),
        ColorSequenceKeypoint.new(0.5, Palette.Border),
        ColorSequenceKeypoint.new(1, Palette.Violet)
    })

    -- Gira o brilho da borda suavemente a 60 FPS
    local strokeConn = RunService.RenderStepped:Connect(function(dt)
        if not HubGui.Parent then return end
        StrokeGradient.Rotation = (StrokeGradient.Rotation + dt * 45) % 360
    end)
    HubGui.Destroying:Connect(function()
        if strokeConn then strokeConn:Disconnect() end
        if LofiSound then LofiSound:Destroy() end
    end)

    -- Barra de Topo (Header Compacto - 38px)
    local Header = Instance.new("Frame", MainWindow)
    Header.Size = UDim2.new(1, 0, 0, 38)
    Header.BackgroundColor3 = Palette.SidebarBg
    Header.BorderSizePixel = 0
    MakeSmoothDraggable(Header, MainWindow)

    local HeaderLine = Instance.new("Frame", Header)
    HeaderLine.Size = UDim2.new(1, 0, 0, 1)
    HeaderLine.Position = UDim2.new(0, 0, 1, -1)
    HeaderLine.BackgroundColor3 = Palette.Border
    HeaderLine.BorderSizePixel = 0

    local BrandDot = Instance.new("Frame", Header)
    BrandDot.Size = UDim2.new(0, 8, 0, 8)
    BrandDot.Position = UDim2.new(0, 14, 0.5, -4)
    BrandDot.BackgroundColor3 = Palette.Gold
    Instance.new("UICorner", BrandDot).CornerRadius = UDim.new(1, 0)

    local BrandTitle = Instance.new("TextLabel", Header)
    BrandTitle.Size = UDim2.new(0, 100, 1, 0)
    BrandTitle.Position = UDim2.new(0, 28, 0, 0)
    BrandTitle.BackgroundTransparency = 1
    BrandTitle.Text = "RECEX HUB"
    BrandTitle.TextColor3 = Palette.PureWhite
    BrandTitle.Font = Enum.Font.GothamBlack
    BrandTitle.TextSize = 13
    BrandTitle.TextXAlignment = Enum.TextXAlignment.Left

    local SubBadge = Instance.new("TextLabel", Header)
    SubBadge.Size = UDim2.new(0, 88, 0, 18)
    SubBadge.Position = UDim2.new(0, 112, 0.5, -9)
    SubBadge.BackgroundColor3 = Palette.Card
    SubBadge.Text = "by recex"
    SubBadge.TextColor3 = Palette.Gold
    SubBadge.Font = Enum.Font.GothamBold
    SubBadge.TextSize = 10
    Instance.new("UICorner", SubBadge).CornerRadius = UDim.new(1, 0)

    -- Botão do Player Lo-Fi no Topo!
    local LofiBtn = Instance.new("TextButton", Header)
    LofiBtn.Size = UDim2.new(0, 125, 0, 22)
    LofiBtn.Position = UDim2.new(1, -168, 0.5, -11)
    LofiBtn.BackgroundColor3 = Palette.Card
    LofiBtn.Text = "♪ Lo-Fi: " .. LofiTracks[currentTrackIdx].Name
    LofiBtn.TextColor3 = Palette.Gold
    LofiBtn.Font = Enum.Font.GothamSemibold
    LofiBtn.TextSize = 10
    LofiBtn.AutoButtonColor = false
    LofiBtn.ClipsDescendants = true
    Instance.new("UICorner", LofiBtn).CornerRadius = UDim.new(1, 0)
    local LofiStroke = Instance.new("UIStroke", LofiBtn)
    LofiStroke.Color = Palette.Border
    LofiStroke.Thickness = 1

    -- Clique esquerdo: Ligar/Desligar Lo-Fi | Clique direito: Trocar música Lo-Fi
    LofiBtn.MouseButton1Click:Connect(function()
        lofiPlaying = not lofiPlaying
        PlaySoftSFX(6895079853, 0.25, lofiPlaying and 1.05 or 0.8)
        SpawnRipple(LofiBtn)
        if lofiPlaying then
            LofiSound:Resume()
            TweenService:Create(LofiSound, TweenInfo.new(0.5), {Volume = 0.22}):Play()
            LofiBtn.Text = "♪ Lo-Fi: " .. LofiTracks[currentTrackIdx].Name
            LofiBtn.TextColor3 = Palette.Gold
        else
            TweenService:Create(LofiSound, TweenInfo.new(0.3), {Volume = 0}):Play()
            LofiBtn.Text = "♪ Lo-Fi: Mutado"
            LofiBtn.TextColor3 = Palette.MutedText
        end
    end)

    LofiBtn.MouseButton2Click:Connect(function()
        currentTrackIdx = (currentTrackIdx % #LofiTracks) + 1
        LofiSound.SoundId = "rbxassetid://" .. tostring(LofiTracks[currentTrackIdx].Id)
        LofiSound:Play()
        lofiPlaying = true
        LofiSound.Volume = 0.22
        LofiBtn.Text = "♪ Lo-Fi: " .. LofiTracks[currentTrackIdx].Name
        LofiBtn.TextColor3 = Palette.Gold
        Notify("Lo-Fi Radio", "Tocando agora: " .. LofiTracks[currentTrackIdx].Name, 2)
    end)

    local MinimizeBtn = Instance.new("TextButton", Header)
    MinimizeBtn.Size = UDim2.new(0, 24, 0, 24)
    MinimizeBtn.Position = UDim2.new(1, -34, 0.5, -12)
    MinimizeBtn.BackgroundColor3 = Palette.Card
    MinimizeBtn.Text = "—"
    MinimizeBtn.TextColor3 = Palette.MutedText
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.TextSize = 12
    MinimizeBtn.AutoButtonColor = false
    Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 6)

    -- Barra Lateral Compacta (135px)
    local Sidebar = Instance.new("Frame", MainWindow)
    Sidebar.Size = UDim2.new(0, 135, 1, -38)
    Sidebar.Position = UDim2.new(0, 0, 0, 38)
    Sidebar.BackgroundColor3 = Palette.SidebarBg
    Sidebar.BorderSizePixel = 0

    local SideDivider = Instance.new("Frame", Sidebar)
    SideDivider.Size = UDim2.new(0, 1, 1, 0)
    SideDivider.Position = UDim2.new(1, -1, 0, 0)
    SideDivider.BackgroundColor3 = Palette.Border
    SideDivider.BorderSizePixel = 0

    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, -14, 1, -58)
    TabContainer.Position = UDim2.new(0, 7, 0, 8)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    local TabListLayout = Instance.new("UIListLayout", TabContainer)
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Mini Perfil Compacto no Rodapé da Sidebar
    local ProfileCard = Instance.new("Frame", Sidebar)
    ProfileCard.Size = UDim2.new(1, -14, 0, 40)
    ProfileCard.Position = UDim2.new(0, 7, 1, -46)
    ProfileCard.BackgroundColor3 = Palette.Card
    Instance.new("UICorner", ProfileCard).CornerRadius = UDim.new(0, 8)

    local AvatarImg = Instance.new("ImageLabel", ProfileCard)
    AvatarImg.Size = UDim2.new(0, 26, 0, 26)
    AvatarImg.Position = UDim2.new(0, 7, 0.5, -13)
    AvatarImg.BackgroundColor3 = Palette.BgDark
    Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)
    task.spawn(function()
        local ok, img = pcall(function()
            return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        end)
        if ok and img then AvatarImg.Image = img end
    end)

    local PlayerNameLbl = Instance.new("TextLabel", ProfileCard)
    PlayerNameLbl.Size = UDim2.new(1, -40, 0, 14)
    PlayerNameLbl.Position = UDim2.new(0, 38, 0, 7)
    PlayerNameLbl.BackgroundTransparency = 1
    PlayerNameLbl.Text = LocalPlayer.DisplayName
    PlayerNameLbl.TextColor3 = Palette.PureWhite
    PlayerNameLbl.Font = Enum.Font.GothamBold
    PlayerNameLbl.TextSize = 10
    PlayerNameLbl.TextXAlignment = Enum.TextXAlignment.Left
    PlayerNameLbl.TextTruncate = Enum.TextTruncate.AtEnd

    local PlayerSubLbl = Instance.new("TextLabel", ProfileCard)
    PlayerSubLbl.Size = UDim2.new(1, -40, 0, 12)
    PlayerSubLbl.Position = UDim2.new(0, 38, 0, 20)
    PlayerSubLbl.BackgroundTransparency = 1
    PlayerSubLbl.Text = "Lo-Fi Edition"
    PlayerSubLbl.TextColor3 = Palette.Violet
    PlayerSubLbl.Font = Enum.Font.GothamMedium
    PlayerSubLbl.TextSize = 9
    PlayerSubLbl.TextXAlignment = Enum.TextXAlignment.Left

    -- Área de Conteúdo das Abas
    local PagesArea = Instance.new("Frame", MainWindow)
    PagesArea.Size = UDim2.new(1, -135, 1, -38)
    PagesArea.Position = UDim2.new(0, 135, 0, 38)
    PagesArea.BackgroundTransparency = 1
    PagesArea.ClipsDescendants = true

    -- Animação de Abrir e Minimizar com UIScale (Efeito Mola)
    local isOpen = true
    local function ToggleHub()
        isOpen = not isOpen
        PlaySoftSFX(6895079853, 0.3, isOpen and 0.95 or 0.75)
        if isOpen then
            MainWindow.Visible = true
            TweenService:Create(WindowScale, TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Scale = 1
            }):Play()
        else
            local tw = TweenService:Create(WindowScale, TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Scale = 0
            })
            tw:Play()
            tw.Completed:Connect(function()
                if not isOpen then MainWindow.Visible = false end
            end)
        end
    end

    MinimizeBtn.MouseButton1Click:Connect(ToggleHub)
    FloatToggle.MouseButton1Click:Connect(ToggleHub)
    UserInputService.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == Enum.KeyCode.RightControl then ToggleHub() end
    end)

    -- Abre a janela com efeito Pop-up suave ao carregar
    TweenService:Create(WindowScale, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play()

    -- ==========================================
    -- 4. ELEMENTOS INTERATIVOS COM MICRO-ANIMAÇÕES
    -- ==========================================
    local Tabs = {}
    local FirstTab = true
    local HubAPI = { Notify = Notify }

    function HubAPI:CreateTab(tabName)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, 0, 0, 30)
        TabBtn.BackgroundColor3 = Palette.Card
        TabBtn.BackgroundTransparency = FirstTab and 0 or 1
        TabBtn.Text = ""
        TabBtn.AutoButtonColor = false
        TabBtn.ClipsDescendants = true
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        local TabTitle = Instance.new("TextLabel", TabBtn)
        TabTitle.Size = UDim2.new(1, -18, 1, 0)
        TabTitle.Position = UDim2.new(0, FirstTab and 14 or 10, 0, 0)
        TabTitle.BackgroundTransparency = 1
        TabTitle.Text = tabName
        TabTitle.TextColor3 = FirstTab and Palette.Gold or Palette.MutedText
        TabTitle.Font = Enum.Font.GothamSemibold
        TabTitle.TextSize = 11
        TabTitle.TextXAlignment = Enum.TextXAlignment.Left

        local Indicator = Instance.new("Frame", TabBtn)
        Indicator.Size = UDim2.new(0, 3, 0, FirstTab and 14 or 0)
        Indicator.Position = UDim2.new(0, 0, 0.5, 0)
        Indicator.AnchorPoint = Vector2.new(0, 0.5)
        Indicator.BackgroundColor3 = Palette.Gold
        Indicator.BorderSizePixel = 0
        Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

        local Page = Instance.new("ScrollingFrame", PagesArea)
        Page.Size = UDim2.new(1, -20, 1, -16)
        Page.Position = UDim2.new(0, 10, 0, 8)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Palette.Gold
        Page.Visible = FirstTab

        local PageScale = Instance.new("UIScale", Page)
        PageScale.Scale = 1

        local PageLayout = Instance.new("UIListLayout", Page)
        PageLayout.Padding = UDim.new(0, 6)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 12)
        end)

        table.insert(Tabs, {Btn = TabBtn, Title = TabTitle, Ind = Indicator, Page = Page, Scale = PageScale})
        FirstTab = false

        TabBtn.MouseEnter:Connect(function()
            if not Page.Visible then
                PlaySoftSFX(6895079853, 0.12, 0.85)
                TweenService:Create(TabTitle, TweenInfo.new(0.2), {Position = UDim2.new(0, 14, 0, 0), TextColor3 = Palette.PureWhite}):Play()
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if not Page.Visible then
                TweenService:Create(TabTitle, TweenInfo.new(0.2), {Position = UDim2.new(0, 10, 0, 0), TextColor3 = Palette.MutedText}):Play()
            end
        end)

        TabBtn.MouseButton1Click:Connect(function()
            PlaySoftSFX(6895079853, 0.25, 1.0)
            SpawnRipple(TabBtn)
            for _, t in ipairs(Tabs) do
                t.Page.Visible = false
                TweenService:Create(t.Btn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                TweenService:Create(t.Title, TweenInfo.new(0.2), {Position = UDim2.new(0, 10, 0, 0), TextColor3 = Palette.MutedText}):Play()
                TweenService:Create(t.Ind, TweenInfo.new(0.2), {Size = UDim2.new(0, 3, 0, 0)}):Play()
            end
            Page.Visible = true
            PageScale.Scale = 0.94
            TweenService:Create(PageScale, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
            TweenService:Create(TabBtn, TweenInfo.new(0.25), {BackgroundTransparency = 0}):Play()
            TweenService:Create(TabTitle, TweenInfo.new(0.25), {Position = UDim2.new(0, 14, 0, 0), TextColor3 = Palette.Gold}):Play()
            TweenService:Create(Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, 3, 0, 14)}):Play()
        end)

        local TabElements = {}

        function TabElements:AddSection(sectionTitle)
            local Sec = Instance.new("TextLabel", Page)
            Sec.Size = UDim2.new(1, 0, 0, 18)
            Sec.BackgroundTransparency = 1
            Sec.Text = "— " .. string.upper(sectionTitle)
            Sec.TextColor3 = Palette.Gold
            Sec.Font = Enum.Font.GothamBold
            Sec.TextSize = 10
            Sec.TextXAlignment = Enum.TextXAlignment.Left
        end

        function TabElements:AddButton(title, desc, callback)
            local BtnCard = Instance.new("TextButton", Page)
            BtnCard.Size = UDim2.new(1, -4, 0, 42)
            BtnCard.BackgroundColor3 = Palette.Card
            BtnCard.Text = ""
            BtnCard.AutoButtonColor = false
            BtnCard.ClipsDescendants = true
            Instance.new("UICorner", BtnCard).CornerRadius = UDim.new(0, 7)

            local CardScale = Instance.new("UIScale", BtnCard)
            local CardStroke = Instance.new("UIStroke", BtnCard)
            CardStroke.Color = Palette.Border
            CardStroke.Thickness = 1

            local T = Instance.new("TextLabel", BtnCard)
            T.Size = UDim2.new(1, -65, 0, 16)
            T.Position = UDim2.new(0, 12, 0, 6)
            T.BackgroundTransparency = 1
            T.Text = title
            T.TextColor3 = Palette.PureWhite
            T.Font = Enum.Font.GothamBold
            T.TextSize = 11
            T.TextXAlignment = Enum.TextXAlignment.Left

            local D = Instance.new("TextLabel", BtnCard)
            D.Size = UDim2.new(1, -65, 0, 14)
            D.Position = UDim2.new(0, 12, 0, 22)
            D.BackgroundTransparency = 1
            D.Text = desc or ""
            D.TextColor3 = Palette.MutedText
            D.Font = Enum.Font.Gotham
            D.TextSize = 9
            D.TextTruncate = Enum.TextTruncate.AtEnd
            D.TextXAlignment = Enum.TextXAlignment.Left

            local ArrowIcon = Instance.new("TextLabel", BtnCard)
            ArrowIcon.Size = UDim2.new(0, 24, 0, 24)
            ArrowIcon.Position = UDim2.new(1, -32, 0.5, -12)
            ArrowIcon.BackgroundColor3 = Palette.SidebarBg
            ArrowIcon.Text = "›"
            ArrowIcon.TextColor3 = Palette.Gold
            ArrowIcon.Font = Enum.Font.GothamBold
            ArrowIcon.TextSize = 15
            Instance.new("UICorner", ArrowIcon).CornerRadius = UDim.new(1, 0)

            BtnCard.MouseEnter:Connect(function()
                PlaySoftSFX(6895079853, 0.10, 0.85)
                TweenService:Create(BtnCard, TweenInfo.new(0.2), {BackgroundColor3 = Palette.CardHover}):Play()
                TweenService:Create(CardStroke, TweenInfo.new(0.2), {Color = Palette.Gold}):Play()
                TweenService:Create(T, TweenInfo.new(0.2), {Position = UDim2.new(0, 16, 0, 6)}):Play()
                TweenService:Create(ArrowIcon, TweenInfo.new(0.2), {BackgroundColor3 = Palette.Gold, TextColor3 = Palette.BgDark}):Play()
            end)
            BtnCard.MouseLeave:Connect(function()
                TweenService:Create(BtnCard, TweenInfo.new(0.2), {BackgroundColor3 = Palette.Card}):Play()
                TweenService:Create(CardStroke, TweenInfo.new(0.2), {Color = Palette.Border}):Play()
                TweenService:Create(T, TweenInfo.new(0.2), {Position = UDim2.new(0, 12, 0, 6)}):Play()
                TweenService:Create(ArrowIcon, TweenInfo.new(0.2), {BackgroundColor3 = Palette.SidebarBg, TextColor3 = Palette.Gold}):Play()
            end)

            BtnCard.MouseButton1Click:Connect(function()
                PlaySoftSFX(6895079853, 0.28, 0.98)
                SpawnRipple(BtnCard, UserInputService:GetMouseLocation())
                TweenService:Create(CardScale, TweenInfo.new(0.1), {Scale = 0.97}):Play()
                task.delay(0.1, function()
                    TweenService:Create(CardScale, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Scale = 1}):Play()
                end)
                if callback then task.spawn(callback) end
            end)
        end

        function TabElements:AddToggle(title, desc, defaultState, callback)
            local state = defaultState or false
            local TogCard = Instance.new("TextButton", Page)
            TogCard.Size = UDim2.new(1, -4, 0, 42)
            TogCard.BackgroundColor3 = Palette.Card
            TogCard.Text = ""
            TogCard.AutoButtonColor = false
            TogCard.ClipsDescendants = true
            Instance.new("UICorner", TogCard).CornerRadius = UDim.new(0, 7)

            local CardStroke = Instance.new("UIStroke", TogCard)
            CardStroke.Color = state and Palette.Gold or Palette.Border
            CardStroke.Transparency = state and 0.3 or 0
            CardStroke.Thickness = 1

            local T = Instance.new("TextLabel", TogCard)
            T.Size = UDim2.new(1, -65, 0, 16)
            T.Position = UDim2.new(0, 12, 0, 6)
            T.BackgroundTransparency = 1
            T.Text = title
            T.TextColor3 = Palette.PureWhite
            T.Font = Enum.Font.GothamBold
            T.TextSize = 11
            T.TextXAlignment = Enum.TextXAlignment.Left

            local D = Instance.new("TextLabel", TogCard)
            D.Size = UDim2.new(1, -65, 0, 14)
            D.Position = UDim2.new(0, 12, 0, 22)
            D.BackgroundTransparency = 1
            D.Text = desc or ""
            D.TextColor3 = Palette.MutedText
            D.Font = Enum.Font.Gotham
            D.TextSize = 9
            D.TextTruncate = Enum.TextTruncate.AtEnd
            D.TextXAlignment = Enum.TextXAlignment.Left

            local SwitchBg = Instance.new("Frame", TogCard)
            SwitchBg.Size = UDim2.new(0, 36, 0, 18)
            SwitchBg.Position = UDim2.new(1, -46, 0.5, -9)
            SwitchBg.BackgroundColor3 = state and Palette.Gold or Palette.SidebarBg
            Instance.new("UICorner", SwitchBg).CornerRadius = UDim.new(1, 0)

            local Knob = Instance.new("Frame", SwitchBg)
            Knob.Size = UDim2.new(0, 12, 0, 12)
            Knob.Position = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
            Knob.BackgroundColor3 = state and Palette.BgDark or Palette.MutedText
            Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

            TogCard.MouseEnter:Connect(function()
                PlaySoftSFX(6895079853, 0.10, 0.85)
                TweenService:Create(TogCard, TweenInfo.new(0.2), {BackgroundColor3 = Palette.CardHover}):Play()
                TweenService:Create(T, TweenInfo.new(0.2), {Position = UDim2.new(0, 16, 0, 6)}):Play()
            end)
            TogCard.MouseLeave:Connect(function()
                TweenService:Create(TogCard, TweenInfo.new(0.2), {BackgroundColor3 = Palette.Card}):Play()
                TweenService:Create(T, TweenInfo.new(0.2), {Position = UDim2.new(0, 12, 0, 6)}):Play()
            end)

            TogCard.MouseButton1Click:Connect(function()
                state = not state
                PlaySoftSFX(6895079853, 0.28, state and 1.12 or 0.85)
                SpawnRipple(TogCard, UserInputService:GetMouseLocation())
                TweenService:Create(SwitchBg, TweenInfo.new(0.25), {BackgroundColor3 = state and Palette.Gold or Palette.SidebarBg}):Play()
                TweenService:Create(Knob, TweenInfo.new(0.28, Enum.EasingStyle.Back), {
                    Position = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6),
                    BackgroundColor3 = state and Palette.BgDark or Palette.MutedText
                }):Play()
                TweenService:Create(CardStroke, TweenInfo.new(0.25), {
                    Color = state and Palette.Gold or Palette.Border,
                    Transparency = state and 0.3 or 0
                }):Play()
                if callback then task.spawn(callback, state) end
            end)
        end

        function TabElements:AddSlider(title, minVal, maxVal, defaultVal, callback)
            local currentVal = defaultVal or minVal
            local SliderCard = Instance.new("Frame", Page)
            SliderCard.Size = UDim2.new(1, -4, 0, 44)
            SliderCard.BackgroundColor3 = Palette.Card
            Instance.new("UICorner", SliderCard).CornerRadius = UDim.new(0, 7)
            local CardStroke = Instance.new("UIStroke", SliderCard)
            CardStroke.Color = Palette.Border
            CardStroke.Thickness = 1

            local T = Instance.new("TextLabel", SliderCard)
            T.Size = UDim2.new(0.7, 0, 0, 16)
            T.Position = UDim2.new(0, 12, 0, 6)
            T.BackgroundTransparency = 1
            T.Text = title
            T.TextColor3 = Palette.PureWhite
            T.Font = Enum.Font.GothamBold
            T.TextSize = 11
            T.TextXAlignment = Enum.TextXAlignment.Left

            local ValLbl = Instance.new("TextLabel", SliderCard)
            ValLbl.Size = UDim2.new(0.3, -12, 0, 16)
            ValLbl.Position = UDim2.new(0.7, 0, 0, 6)
            ValLbl.BackgroundTransparency = 1
            ValLbl.Text = tostring(currentVal)
            ValLbl.TextColor3 = Palette.Gold
            ValLbl.Font = Enum.Font.GothamBold
            ValLbl.TextSize = 11
            ValLbl.TextXAlignment = Enum.TextXAlignment.Right

            local BarTrack = Instance.new("TextButton", SliderCard)
            BarTrack.Size = UDim2.new(1, -24, 0, 5)
            BarTrack.Position = UDim2.new(0, 12, 0, 29)
            BarTrack.BackgroundColor3 = Palette.SidebarBg
            BarTrack.Text = ""
            BarTrack.AutoButtonColor = false
            Instance.new("UICorner", BarTrack).CornerRadius = UDim.new(1, 0)

            local initPct = math.clamp((currentVal - minVal) / (maxVal - minVal), 0, 1)
            local BarFill = Instance.new("Frame", BarTrack)
            BarFill.Size = UDim2.new(initPct, 0, 1, 0)
            BarFill.BackgroundColor3 = Palette.Gold
            Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)

            local draggingSlider = false
            local function UpdateSlider(input)
                local pct = math.clamp((input.Position.X - BarTrack.AbsolutePosition.X) / BarTrack.AbsoluteSize.X, 0, 1)
                local val = math.floor(minVal + (maxVal - minVal) * pct)
                ValLbl.Text = tostring(val)
                TweenService:Create(BarFill, TweenInfo.new(0.08, Enum.EasingStyle.Quad), {Size = UDim2.new(pct, 0, 1, 0)}):Play()
                if callback then task.spawn(callback, val) end
            end

            BarTrack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = true
                    TweenService:Create(CardStroke, TweenInfo.new(0.2), {Color = Palette.Gold}):Play()
                    UpdateSlider(input)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = false
                    TweenService:Create(CardStroke, TweenInfo.new(0.2), {Color = Palette.Border}):Play()
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