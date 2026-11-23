--[[
    RECEX SOVEREIGN VIP - EXCLUSIVE 3D CINEMATIC INTRO (GARGANTUA SINGULARITY)
    made by recex (PAID VIP EDITION)
]]

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local function RunSovereignVIPIntro(vipData, onComplete)
    -- Suporte flexível caso seja chamado apenas com (onComplete)
    if type(vipData) == "function" then
        onComplete = vipData
        vipData = { Role = "👑 SOVEREIGN VIP", Plan = "Acesso Premium Verificado" }
    end
    vipData = vipData or { Role = "👑 SOVEREIGN VIP", Plan = "Acesso Premium Verificado" }

    -- 1. Backup completo da iluminação e câmera originais
    local SavedLighting = {
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        FogEnd = Lighting.FogEnd,
        GlobalShadows = Lighting.GlobalShadows,
        ExposureCompensation = Lighting.ExposureCompensation
    }
    local SavedCamType = Camera.CameraType
    local SavedCamCF = Camera.CFrame
    local SavedCamFOV = Camera.FieldOfView

    local DisabledPostFX = {}
    for _, fx in ipairs(Lighting:GetChildren()) do
        if fx:IsA("PostEffect") or fx:IsA("Atmosphere") or fx:IsA("Sky") then
            if fx:IsA("PostEffect") and fx.Enabled then
                fx.Enabled = false
                table.insert(DisabledPostFX, fx)
            end
        end
    end

    -- 2. Atmosfera Espacial Carmesim & Ouro Imperial
    Lighting.Ambient = Color3.fromRGB(14, 8, 18)
    Lighting.OutdoorAmbient = Color3.fromRGB(22, 10, 26)
    Lighting.Brightness = 3.5
    Lighting.ClockTime = 0
    Lighting.ExposureCompensation = 0.25

    local VIPFolder = Instance.new("Folder")
    VIPFolder.Name = "RecexGargantuaVIP3D"
    VIPFolder.Parent = Camera

    local VIPBloom = Instance.new("BloomEffect")
    VIPBloom.Intensity = 1.35
    VIPBloom.Size = 38
    VIPBloom.Threshold = 0.72
    VIPBloom.Parent = Lighting

    local VIPColor = Instance.new("ColorCorrectionEffect")
    VIPColor.Contrast = 0.28
    VIPColor.Saturation = 0.25
    VIPColor.TintColor = Color3.fromRGB(255, 235, 240)
    VIPColor.Parent = Lighting

    local VIPDoF = Instance.new("DepthOfFieldEffect")
    VIPDoF.FarIntensity = 0.45
    VIPDoF.InFocusRadius = 55
    VIPDoF.NearIntensity = 0.25
    VIPDoF.FocusDistance = 42
    VIPDoF.Parent = Lighting

    -- Áudio de Cinema IMAX (Sub-Bass + Ambiência Cósmica)
    local CinemaSound = Instance.new("Sound")
    CinemaSound.SoundId = "rbxassetid://1837849285"
    CinemaSound.Volume = 0
    CinemaSound.PlaybackSpeed = 0.85
    CinemaSound.Looped = true
    CinemaSound.Parent = SoundService
    CinemaSound:Play()
    TweenService:Create(CinemaSound, TweenInfo.new(1.5), {Volume = 0.6}):Play()

    local DropWhoosh = Instance.new("Sound")
    DropWhoosh.SoundId = "rbxassetid://9114221580"
    DropWhoosh.Volume = 0.75
    DropWhoosh.PlaybackSpeed = 0.8
    DropWhoosh.Parent = SoundService

    -- Paleta de Luxo: Obsidiana, Ouro Imperial, Carmesim Real e Diamante
    local COL_OBSIDIAN = Color3.fromRGB(8, 8, 12)
    local COL_GOLD     = Color3.fromRGB(255, 200, 65)
    local COL_CRIMSON  = Color3.fromRGB(235, 35, 75)
    local COL_DIAMOND  = Color3.fromRGB(255, 245, 250)

    local Origin = Vector3.new(35000, 12000, 35000)
    local CorePos = Origin + Vector3.new(0, 24, 0)

    local function MakePart(name, size, cf, color, mat, trans, shape)
        local p = Instance.new("Part")
        p.Name = name
        p.Size = size
        p.CFrame = cf
        p.Color = color
        p.Material = mat or Enum.Material.SmoothPlastic
        p.Transparency = trans or 0
        if shape then p.Shape = shape end
        p.Anchored = true
        p.CanCollide = false
        p.CastShadow = false
        p.TopSurface = Enum.SurfaceType.Smooth
        p.BottomSurface = Enum.SurfaceType.Smooth
        p.Parent = VIPFolder
        return p
    end

    -- =========================================================================
    -- 3. CONSTRUÇÃO DA CATEDRAL ESPACIAL & PISTA IMPERIAL
    -- =========================================================================
    -- Domo Estelar Negro Profundo
    MakePart("VoidDome", Vector3.new(1800, 1800, 1800), CFrame.new(Origin), Color3.fromRGB(4, 4, 7), Enum.Material.SmoothPlastic, 0, Enum.PartType.Ball)

    -- Espelho de Obsidiana Infinito no Chão
    MakePart("MirrorFloor", Vector3.new(900, 2, 900), CFrame.new(Origin - Vector3.new(0, 1, 0)), COL_OBSIDIAN, Enum.Material.Glass, 0.12)

    -- Passarela Imperial com Circuitos de Ouro e Carmesim que guiam a câmera
    for i = 1, 18 do
        local zPos = 18 + (i * 7)
        MakePart("RunwayGoldL", Vector3.new(0.45, 0.2, 5), CFrame.new(Origin + Vector3.new(-6, 0.1, zPos)), COL_GOLD, Enum.Material.Neon)
        MakePart("RunwayGoldR", Vector3.new(0.45, 0.2, 5), CFrame.new(Origin + Vector3.new(6, 0.1, zPos)), COL_GOLD, Enum.Material.Neon)
        MakePart("RunwayCrimsonCenter", Vector3.new(2.2, 0.15, 3), CFrame.new(Origin + Vector3.new(0, 0.08, zPos)), COL_CRIMSON, Enum.Material.Neon, 0.2)
    end

    -- Altar Octogonal Sob o Buraco Negro
    for s = 1, 4 do
        local radius = 38 - (s * 7)
        local h = s * 1.1
        MakePart("AltarStep", Vector3.new(h, radius, radius), CFrame.new(Origin + Vector3.new(0, h / 2, 0)) * CFrame.Angles(0, 0, math.rad(90)), COL_OBSIDIAN, Enum.Material.Metal, 0, Enum.PartType.Cylinder)
        MakePart("AltarTrim", Vector3.new(0.18, radius + 0.5, radius + 0.5), CFrame.new(Origin + Vector3.new(0, h, 0)) * CFrame.Angles(0, 0, math.rad(90)), (s % 2 == 0) and COL_GOLD or COL_CRIMSON, Enum.Material.Neon, 0, Enum.PartType.Cylinder)
    end

    -- =========================================================================
    -- 4. MODELAGEM 3D DO BURACO NEGRO "GARGANTUA" & ANÉIS SOBERANOS
    -- =========================================================================
    -- Horizonte de Eventos (Esfera Negra Absoluta no Centro)
    local EventHorizon = MakePart("EventHorizon", Vector3.new(11, 11, 11), CFrame.new(CorePos), Color3.fromRGB(0, 0, 0), Enum.Material.SmoothPlastic, 0, Enum.PartType.Ball)

    -- Halo Fotônico Interno (Brilho Diamante/Carmesim colado ao Horizonte de Eventos)
    local PhotonSphere = MakePart("PhotonSphere", Vector3.new(12.2, 12.2, 12.2), CFrame.new(CorePos), COL_CRIMSON, Enum.Material.ForceField, 0.15, Enum.PartType.Ball)

    local CoreLight = Instance.new("PointLight")
    CoreLight.Color = COL_CRIMSON
    CoreLight.Range = 95
    CoreLight.Brightness = 5.5
    CoreLight.Parent = EventHorizon

    local CenterAttachment = Instance.new("Attachment", EventHorizon)

    -- Construtor de Anéis 3D Esculpidos (Com Lâminas de Energia)
    local function BuildSovereignRing(radius, thickness, segments, color, mat, addFins)
        local group = {}
        local arcLen = (2 * math.pi * radius) / segments
        for i = 1, segments do
            local angle = (i / segments) * math.pi * 2
            local seg = MakePart("RingSeg", Vector3.new(thickness, thickness * 1.3, arcLen * 1.06), CFrame.new(CorePos), color, mat)
            table.insert(group, {Part = seg, Angle = angle, Radius = radius, IsFin = false})

            if addFins and i % 3 == 0 then
                local fin = MakePart("BladeFin", Vector3.new(thickness * 3.8, thickness * 0.35, arcLen * 0.45), CFrame.new(CorePos), COL_GOLD, Enum.Material.Neon)
                table.insert(group, {Part = fin, Angle = angle, Radius = radius + 0.9, IsFin = true})
            end
        end
        return group
    end

    -- Disco de Acreção Principal (Gargantua Disk) + 3 Anéis Giroscópicos Imperiais
    local AccretionDisk = BuildSovereignRing(16.5, 0.55, 36, COL_GOLD, Enum.Material.Neon, true)
    local CrimsonRing   = BuildSovereignRing(12.5, 0.42, 28, COL_CRIMSON, Enum.Material.Neon, false)
    local OuterTitanium = BuildSovereignRing(21.5, 0.75, 36, Color3.fromRGB(28, 22, 32), Enum.Material.Metal, true)
    local DiamondHalo   = BuildSovereignRing(8.8, 0.28, 24, COL_DIAMOND, Enum.Material.Neon, false)

    -- 4 Quasares Orbitais com Rastros de Luz (Trails)
    local Quasars = {}
    for i = 1, 4 do
        local qColor = (i % 2 == 0) and COL_GOLD or COL_CRIMSON
        local sat = MakePart("Quasar_" .. i, Vector3.new(1.1, 1.1, 1.1), CFrame.new(CorePos), qColor, Enum.Material.Neon, 0, Enum.PartType.Ball)
        local a0 = Instance.new("Attachment", sat)
        a0.Position = Vector3.new(0, 0.55, 0)
        local a1 = Instance.new("Attachment", sat)
        a1.Position = Vector3.new(0, -0.55, 0)

        local trail = Instance.new("Trail")
        trail.Attachment0 = a0
        trail.Attachment1 = a1
        trail.Color = ColorSequence.new(qColor, COL_DIAMOND)
        trail.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
        trail.Lifetime = 0.65
        trail.LightEmission = 1
        trail.FaceCamera = true
        trail.Parent = sat
        table.insert(Quasars, sat)
    end

    -- 16 Torres Imperiais Conectadas por Feixes de Energia ao Buraco Negro
    for i = 1, 16 do
        local a = (i / 16) * math.pi * 2
        local dist = 78
        local height = 45 + (i % 3) * 14
        local pos = Origin + Vector3.new(math.cos(a) * dist, height / 2, math.sin(a) * dist)
        local lookAtCenter = CFrame.lookAt(pos, Vector3.new(Origin.X, pos.Y, Origin.Z))

        MakePart("ImperialTower_" .. i, Vector3.new(5.5, height, 5.5), lookAtCenter, COL_OBSIDIAN, Enum.Material.Metal)
        local stripColor = (i % 2 == 0) and COL_CRIMSON or COL_GOLD
        local strip = MakePart("TowerNeon_" .. i, Vector3.new(0.8, height * 0.88, 5.7), lookAtCenter, stripColor, Enum.Material.Neon)

        if i % 2 == 0 then
            local towerAtt = Instance.new("Attachment", strip)
            towerAtt.Position = Vector3.new(0, height * 0.42, 0)

            local beam = Instance.new("Beam")
            beam.Attachment0 = towerAtt
            beam.Attachment1 = CenterAttachment
            beam.Width0 = 0.8
            beam.Width1 = 3.2
            beam.LightEmission = 1
            beam.Color = ColorSequence.new( COL_CRIMSON, COL_GOLD)
            beam.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.35),
                NumberSequenceKeypoint.new(0.6, 0.7),
                NumberSequenceKeypoint.new(1, 0.15)
            })
            beam.FaceCamera = true
            beam.Parent = strip
        end
    end

    -- Brasas Astrais Flutuantes (Subindo do chão em direção ao cosmos)
    local FloatingEmbers = {}
    for i = 1, 35 do
        local eColor = (i % 2 == 0) and COL_GOLD or COL_CRIMSON
        local ember = MakePart("Ember_" .. i, Vector3.new(0.55, 0.55, 0.55), CFrame.new(Origin), eColor, Enum.Material.Neon, 0.1, Enum.PartType.Ball)
        table.insert(FloatingEmbers, {
            Part = ember,
            Angle = math.random() * math.pi * 2,
            Dist = math.random(12, 65),
            Y = math.random(2, 48),
            Speed = math.random(4, 10)
        })
    end

    -- =========================================================================
    -- 5. INTERFACE CINEMA IMAX + CREDENCIAL VIP DO USUÁRIO
    -- =========================================================================
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local IntroGui = Instance.new("ScreenGui")
    IntroGui.Name = "RecexVIPCinemaGUI"
    IntroGui.IgnoreGuiInset = true
    IntroGui.ResetOnSpawn = false
    IntroGui.Parent = PlayerGui

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 82)
    TopBar.BackgroundColor3 = Color3.fromRGB(4, 4, 6)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = IntroGui

    local BottomBar = Instance.new("Frame")
    BottomBar.Size = UDim2.new(1, 0, 0, 128)
    BottomBar.Position = UDim2.new(0, 0, 1, -128)
    BottomBar.BackgroundColor3 = Color3.fromRGB(4, 4, 6)
    BottomBar.BorderSizePixel = 0
    BottomBar.Parent = IntroGui

    local BottomStroke = Instance.new("UIStroke")
    BottomStroke.Color = COL_CRIMSON
    BottomStroke.Thickness = 1.4
    BottomStroke.Transparency = 0.35
    BottomStroke.Parent = BottomBar

    local TextBoxFrame = Instance.new("Frame")
    TextBoxFrame.Size = UDim2.new(0, 650, 0, 95)
    TextBoxFrame.Position = UDim2.new(0.5, 0, 0.5, -4)
    TextBoxFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    TextBoxFrame.BackgroundTransparency = 1
    TextBoxFrame.Parent = BottomBar

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ListLayout.Padding = UDim.new(0, 5)
    ListLayout.Parent = TextBoxFrame

    local RoleBadge = Instance.new("TextLabel")
    RoleBadge.LayoutOrder = 1
    RoleBadge.Size = UDim2.new(1, 0, 0, 16)
    RoleBadge.BackgroundTransparency = 1
    RoleBadge.Text = string.upper(vipData.Role .. "  •  " .. LocalPlayer.DisplayName)
    RoleBadge.TextColor3 = COL_GOLD
    RoleBadge.Font = Enum.Font.GothamBlack
    RoleBadge.TextSize = 11
    RoleBadge.TextTransparency = 1
    RoleBadge.Parent = TextBoxFrame

    local MainTitle = Instance.new("TextLabel")
    MainTitle.LayoutOrder = 2
    MainTitle.Size = UDim2.new(1, 0, 0, 34)
    MainTitle.BackgroundTransparency = 1
    MainTitle.Text = "RECEX SOVEREIGN VIP"
    MainTitle.TextColor3 = Color3.fromRGB(255, 248, 250)
    MainTitle.Font = Enum.Font.GothamBlack
    MainTitle.TextSize = 30
    MainTitle.TextTransparency = 1
    MainTitle.Parent = TextBoxFrame

    local SubCaption = Instance.new("TextLabel")
    SubCaption.LayoutOrder = 3
    SubCaption.Size = UDim2.new(1, 0, 0, 16)
    SubCaption.BackgroundTransparency = 1
    SubCaption.Text = "S I N G U L A R I T Y   E N G I N E   •   M A D E   B Y   R E C E X"
    SubCaption.TextColor3 = COL_CRIMSON
    SubCaption.Font = Enum.Font.GothamBold
    SubCaption.TextSize = 10
    SubCaption.TextTransparency = 1
    SubCaption.Parent = TextBoxFrame

    local ProgBG = Instance.new("Frame")
    ProgBG.LayoutOrder = 4
    ProgBG.Size = UDim2.new(0, 340, 0, 3)
    ProgBG.BackgroundColor3 = Color3.fromRGB(26, 18, 28)
    ProgBG.BorderSizePixel = 0
    ProgBG.Parent = TextBoxFrame
    Instance.new("UICorner", ProgBG).CornerRadius = UDim.new(1, 0)

    local ProgFill = Instance.new("Frame")
    ProgFill.Size = UDim2.new(0, 0, 1, 0)
    ProgFill.BackgroundColor3 = COL_CRIMSON
    ProgFill.BorderSizePixel = 0
    ProgFill.Parent = ProgBG
    Instance.new("UICorner", ProgFill).CornerRadius = UDim.new(1, 0)

    -- Botão Pular Intro VIP
    local SkipVIPBtn = Instance.new("TextButton")
    SkipVIPBtn.Size = UDim2.new(0, 118, 0, 28)
    SkipVIPBtn.Position = UDim2.new(1, -138, 0, 26)
    SkipVIPBtn.BackgroundColor3 = Color3.fromRGB(22, 14, 24)
    SkipVIPBtn.Text = "PULAR VIP  >>"
    SkipVIPBtn.TextColor3 = COL_GOLD
    SkipVIPBtn.Font = Enum.Font.GothamBold
    SkipVIPBtn.TextSize = 10
    SkipVIPBtn.Parent = TopBar
    Instance.new("UICorner", SkipVIPBtn).CornerRadius = UDim.new(0, 6)
    local SkipStroke = Instance.new("UIStroke", SkipVIPBtn)
    SkipStroke.Color = COL_CRIMSON
    SkipStroke.Thickness = 1

    local WhiteFlash = Instance.new("Frame")
    WhiteFlash.Size = UDim2.new(1, 0, 1, 0)
    WhiteFlash.BackgroundColor3 = COL_CRIMSON
    WhiteFlash.BackgroundTransparency = 0
    WhiteFlash.BorderSizePixel = 0
    WhiteFlash.ZIndex = 20
    WhiteFlash.Parent = IntroGui

    -- =========================================================================
    -- 6. DIREÇÃO DE CÂMERA EM 4 ATOS + FÍSICA DO BURACO NEGRO
    -- =========================================================================
    Camera.CameraType = Enum.CameraType.Scriptable
    local StartTick = tick()
    local TotalDuration = 7.6
    local Finished = false
    local ShockwaveFired = false
    local RenderConn

    local function UpdateRingTransform(ringTable, rotCF)
        for _, item in ipairs(ringTable) do
            local posOffset = CFrame.Angles(0, item.Angle, 0) * CFrame.new(item.Radius, 0, 0)
            item.Part.CFrame = CFrame.new(CorePos) * rotCF * posOffset
        end
    end

    local function FinishVIPIntro()
        if Finished then return end
        Finished = true
        if RenderConn then RenderConn:Disconnect() end

        DropWhoosh:Play()
        WhiteFlash.BackgroundColor3 = COL_GOLD
        TweenService:Create(WhiteFlash, TweenInfo.new(0.28, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
        TweenService:Create(CinemaSound, TweenInfo.new(0.45), {Volume = 0}):Play()
        task.wait(0.3)

        VIPFolder:Destroy()
        VIPBloom:Destroy()
        VIPColor:Destroy()
        VIPDoF:Destroy()

        for prop, val in pairs(SavedLighting) do
            pcall(function() Lighting[prop] = val end)
        end
        for _, fx in ipairs(DisabledPostFX) do
            if fx and fx.Parent then fx.Enabled = true end
        end

        Camera.CameraType = SavedCamType
        Camera.CFrame = SavedCamCF
        Camera.FieldOfView = SavedCamFOV

        TopBar.Visible = false
        BottomBar.Visible = false

        TweenService:Create(WhiteFlash, TweenInfo.new(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
        task.delay(0.7, function()
            CinemaSound:Destroy()
            DropWhoosh:Destroy()
            IntroGui:Destroy()
        end)

        if onComplete then
            task.spawn(onComplete)
        end
    end

    SkipVIPBtn.MouseButton1Click:Connect(FinishVIPIntro)

    TweenService:Create(WhiteFlash, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
    TweenService:Create(RoleBadge, TweenInfo.new(0.8), {TextTransparency = 0}):Play()
    TweenService:Create(MainTitle, TweenInfo.new(1.0), {TextTransparency = 0}):Play()
    TweenService:Create(SubCaption, TweenInfo.new(1.2), {TextTransparency = 0.1}):Play()
    TweenService:Create(ProgFill, TweenInfo.new(TotalDuration, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)}):Play()

    RenderConn = RunService.RenderStepped:Connect(function(dt)
        local t = tick() - StartTick
        if t >= TotalDuration then
            FinishVIPIntro()
            return
        end

        -- Pulso gravitacional da Singularidade
        local pulse = 11 + math.sin(t * 5) * 0.65
        EventHorizon.Size = Vector3.new(pulse, pulse, pulse)
        PhotonSphere.Size = Vector3.new(pulse + 1.4, pulse + 1.4, pulse + 1.4)

        -- Rotação Giroscópica dos 4 Anéis do Buraco Negro
        UpdateRingTransform(AccretionDisk, CFrame.Angles(math.rad(16), t * 1.4, math.rad(8)))
        UpdateRingTransform(CrimsonRing, CFrame.Angles(t * 1.9, math.rad(45), -t * 1.2))
        UpdateRingTransform(OuterTitanium, CFrame.Angles(math.rad(-22), -t * 0.75, math.rad(12)))
        UpdateRingTransform(DiamondHalo, CFrame.Angles(-t * 2.4, t * 2.1, 0))

        -- Órbita dos 4 Quasares com Rastros
        for i, sat in ipairs(Quasars) do
            local a = (t * 3.4) + (i * math.pi / 2)
            local r = 14.5 + (i % 2) * 4.5
            local offset = CFrame.Angles(math.rad(35 * i), a, 0) * Vector3.new(r, 0, 0)
            sat.Position = CorePos + offset
        end

        -- Subida das Brasas Douradas/Carmesim
        for _, e in ipairs(FloatingEmbers) do
            e.Y = (e.Y + dt * e.Speed) % 52
            e.Angle = e.Angle + dt * 0.5
            e.Part.Position = Origin + Vector3.new(math.cos(e.Angle) * e.Dist, e.Y, math.sin(e.Angle) * e.Dist)
        end

        -- 4 Cortes de Câmera Cinematográficos
        if t < 2.3 then
            -- ATO 1: Voo rasante em alta velocidade sobre a Passarela Imperial Dourada
            local a = t / 2.3
            Camera.FieldOfView = 72
            local camPos = Origin + Vector3.new(0, 2.8 + a * 3, 125 - (a * 68))
            Camera.CFrame = CFrame.lookAt(camPos, CorePos) * CFrame.Angles(0, 0, math.rad(math.sin(t * 2) * 2))

        elseif t < 4.6 then
            -- ATO 2: Macro Close-up Dramático dentro do Disco de Acreção do Buraco Negro
            local a = (t - 2.3) / 2.3
            Camera.FieldOfView = 46
            VIPDoF.FocusDistance = 20
            local orbitAngle = -0.8 + (a * 2.2)
            local camPos = CorePos + Vector3.new(math.sin(orbitAngle) * 21, 5 - (a * 8), math.cos(orbitAngle) * 21)
            Camera.CFrame = CFrame.lookAt(camPos, CorePos) * CFrame.Angles(0, 0, math.rad(-14 + a * 28))

        elseif t < 6.6 then
            -- ATO 3: Revelação Imperial — Onda de Choque de Plasma (Shockwave)
            local a = (t - 4.6) / 2.0
            if not ShockwaveFired then
                ShockwaveFired = true
                local wave = MakePart("SupernovaWave", Vector3.new(0.4, 12, 12), CFrame.new(CorePos) * CFrame.Angles(0, 0, math.rad(90)), COL_GOLD, Enum.Material.Neon, 0.1, Enum.PartType.Cylinder)
                TweenService:Create(wave, TweenInfo.new(1.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Size = Vector3.new(0.1, 180, 180),
                    Transparency = 1
                }):Play()
            end
            Camera.FieldOfView = 64 + (a * 12)
            VIPDoF.FocusDistance = 58
            local camPos = Origin + Vector3.new(math.sin(a * 0.5) * 16, 12 + (a * 14), 52 + (a * 16))
            Camera.CFrame = CFrame.lookAt(camPos, CorePos)

        else
            -- ATO 4: Mergulho Hiper-Espacial Atravessando o Centro do Buraco Negro!
            local a = (t - 6.6) / 1.0
            local easeIn = a * a * a
            Camera.FieldOfView = 76 + (easeIn * 42)
            local startPos = Origin + Vector3.new(8, 26, 68)
            local camPos = startPos:Lerp(CorePos, easeIn)
            -- Tremor sutil de câmera (Camera Shake) conforme entra na singularidade
            local shake = Vector3.new(math.random(-10, 10) * 0.04 * a, math.random(-10, 10) * 0.04 * a, 0)
            Camera.CFrame = CFrame.lookAt(camPos + shake, CorePos)
        end
    end)
end

return RunSovereignVIPIntro