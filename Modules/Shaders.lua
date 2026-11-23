--[[
    RECEX HUB - MODULE: RTX SHADERS STUDIO & FPS/PING MONITOR
    made by recex
]]

return function(Hub, Tabs)
    local Lighting = game:GetService("Lighting")
    local RunService = game:GetService("RunService")
    local Stats = game:GetService("Stats")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local ShadersTab = Hub:CreateTab("✨ RTX & FPS")

    -- Salva o estado original da iluminação do jogo para poder restaurar
    local OriginalLighting = {
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        ColorShift_Top = Lighting.ColorShift_Top,
        ExposureCompensation = Lighting.ExposureCompensation,
        ShadowSoftness = Lighting.ShadowSoftness,
        GlobalShadows = Lighting.GlobalShadows
    }

    local ShaderFolder = Lighting:FindFirstChild("RecexRTXEffects") or Instance.new("Folder")
    ShaderFolder.Name = "RecexRTXEffects"
    ShaderFolder.Parent = Lighting

    local function ClearShaders()
        ShaderFolder:ClearAllChildren()
    end

    local function GetOrCreate(className, name)
        local fx = ShaderFolder:FindFirstChild(name)
        if not fx then
            fx = Instance.new(className)
            fx.Name = name
            fx.Parent = ShaderFolder
        end
        return fx
    end

    -- =========================================================================
    -- WIDGET FLUTUANTE DE FPS & PING (ESTILO STUDIO)
    -- =========================================================================
    local HubGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("RecexStudioHub")
    local StatsFrame, StatsLabel

    if HubGui then
        local oldStats = HubGui:FindFirstChild("RecexStatsWidget")
        if oldStats then oldStats:Destroy() end

        StatsFrame = Instance.new("Frame")
        StatsFrame.Name = "RecexStatsWidget"
        StatsFrame.Size = UDim2.new(0, 175, 0, 30)
        StatsFrame.Position = UDim2.new(1, -190, 0, 14)
        StatsFrame.BackgroundColor3 = Color3.fromRGB(14, 15, 20)
        StatsFrame.BorderSizePixel = 0
        StatsFrame.Parent = HubGui

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 8)
        Corner.Parent = StatsFrame

        local Stroke = Instance.new("UIStroke")
        Stroke.Color = Color3.fromRGB(245, 195, 70)
        Stroke.Thickness = 1.2
        Stroke.Transparency = 0.35
        Stroke.Parent = StatsFrame

        StatsLabel = Instance.new("TextLabel")
        StatsLabel.Size = UDim2.new(1, -16, 1, 0)
        StatsLabel.Position = UDim2.new(0, 8, 0, 0)
        StatsLabel.BackgroundTransparency = 1
        StatsLabel.Text = "⚡ FPS: 60  |  📶 Ping: 50ms"
        StatsLabel.TextColor3 = Color3.fromRGB(245, 240, 225)
        StatsLabel.Font = Enum.Font.GothamBold
        StatsLabel.TextSize = 11
        StatsLabel.Parent = StatsFrame
    end

    local FpsCount = 0
    local LastUpdate = tick()

    RunService.RenderStepped:Connect(function()
        FpsCount += 1
        if tick() - LastUpdate >= 0.6 then
            local fps = math.floor(FpsCount / (tick() - LastUpdate))
            FpsCount = 0
            LastUpdate = tick()

            local ping = 0
            pcall(function()
                ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            end)

            if StatsLabel then
                StatsLabel.Text = string.format("⚡ FPS: %d  |  📶 %dms", fps, ping)
            end
        end
    end)

    -- =========================================================================
    -- SEÇÃO 1: MONITOR DE PERFORMANCE
    -- =========================================================================
    ShadersTab:AddSection("Monitor de Performance em Tempo Real")

    ShadersTab:AddToggle("Mostrar Barra Flutuante (FPS & Ping)", "Exibe ou oculta o medidor dourado no canto superior", true, function(state)
        if StatsFrame then StatsFrame.Visible = state end
    end)

    ShadersTab:AddSlider("Limite de FPS (FPS Unlocker)", 30, 360, 144, function(val)
        if setfpscap then
            setfpscap(val)
        end
    end)

    -- =========================================================================
    -- SEÇÃO 2: PRESETS RTX CINEMATOGRÁFICOS (1 CLIQUE)
    -- =========================================================================
    ShadersTab:AddSection("Presets Gráficos RTX (1-Clique)")

    ShadersTab:AddButton("1. RTX Golden Hour (Pôr do Sol Realista)", "Iluminação dourada cinematográfica com sombras suaves", function()
        ClearShaders()
        Lighting.ClockTime = 17.6
        Lighting.Brightness = 3.2
        Lighting.ExposureCompensation = 0.25
        Lighting.GlobalShadows = true
        Lighting.ShadowSoftness = 0.4

        local cc = GetOrCreate("ColorCorrectionEffect", "RTXColor")
        cc.TintColor = Color3.fromRGB(255, 235, 210)
        cc.Saturation = 0.25
        cc.Contrast = 0.18

        local bloom = GetOrCreate("BloomEffect", "RTXBloom")
        bloom.Intensity = 0.65
        bloom.Size = 28
        bloom.Threshold = 0.85

        local rays = GetOrCreate("SunRaysEffect", "RTXRays")
        rays.Intensity = 0.22
        rays.Spread = 0.85

        local atmo = GetOrCreate("Atmosphere", "RTXAtmo")
        atmo.Density = 0.32
        atmo.Color = Color3.fromRGB(255, 190, 130)
        atmo.Decay = Color3.fromRGB(120, 70, 50)
        atmo.Glare = 0.35

        Hub.Notify("RTX Golden Hour", "Shader de Pôr do Sol ativado com sucesso!", 3)
    end)

    ShadersTab:AddButton("2. RTX Cyberpunk 2077 (Noite Neon)", "Noite intensa com reflexos neon violeta e azul", function()
        ClearShaders()
        Lighting.ClockTime = 0.5
        Lighting.Brightness = 2.5
        Lighting.Ambient = Color3.fromRGB(35, 20, 55)
        Lighting.OutdoorAmbient = Color3.fromRGB(45, 25, 75)

        local cc = GetOrCreate("ColorCorrectionEffect", "RTXColor")
        cc.TintColor = Color3.fromRGB(215, 195, 255)
        cc.Saturation = 0.45
        cc.Contrast = 0.32

        local bloom = GetOrCreate("BloomEffect", "RTXBloom")
        bloom.Intensity = 1.2
        bloom.Size = 36
        bloom.Threshold = 0.7

        Hub.Notify("RTX Cyberpunk", "Modo Noite Neon ativado!", 3)
    end)

    ShadersTab:AddButton("3. RTX Anime Vibrant (Cores Vivas)", "Visual limpo, saturado e brilhante estilo anime moderno", function()
        ClearShaders()
        Lighting.ClockTime = 13.5
        Lighting.Brightness = 3.5
        Lighting.ExposureCompensation = 0.35

        local cc = GetOrCreate("ColorCorrectionEffect", "RTXColor")
        cc.TintColor = Color3.fromRGB(245, 250, 255)
        cc.Saturation = 0.55
        cc.Contrast = 0.15

        local bloom = GetOrCreate("BloomEffect", "RTXBloom")
        bloom.Intensity = 0.8
        bloom.Size = 24
        bloom.Threshold = 0.9

        Hub.Notify("RTX Anime", "Cores vibrantes aplicadas!", 3)
    end)

    ShadersTab:AddButton("4. RTX Dreamcore / Lo-Fi Aesthetic", "Atmosfera nostálgica rosada/violeta suave para ouvir música", function()
        ClearShaders()
        Lighting.ClockTime = 18.4
        Lighting.Brightness = 2.4

        local cc = GetOrCreate("ColorCorrectionEffect", "RTXColor")
        cc.TintColor = Color3.fromRGB(255, 210, 245)
        cc.Saturation = 0.15
        cc.Contrast = 0.1

        local dof = GetOrCreate("DepthOfFieldEffect", "RTXDoF")
        dof.FarIntensity = 0.45
        dof.InFocusRadius = 35
        dof.NearIntensity = 0.2

        Hub.Notify("RTX Dreamcore", "Visual Lo-Fi Aesthetic aplicado!", 3)
    end)

    ShadersTab:AddButton("5. RTX Sinister Fog (Modo Terror)", "Escuridão densa e contraste cinematográfico sombrio", function()
        ClearShaders()
        Lighting.ClockTime = 0
        Lighting.Brightness = 0.6

        local cc = GetOrCreate("ColorCorrectionEffect", "RTXColor")
        cc.Saturation = -0.65
        cc.Contrast = 0.45

        local atmo = GetOrCreate("Atmosphere", "RTXAtmo")
        atmo.Density = 0.68
        atmo.Color = Color3.fromRGB(15, 15, 20)

        Hub.Notify("RTX Horror", "Modo Terror Cinematográfico ativado!", 3)
    end)

    ShadersTab:AddButton("🔄 Restaurar Gráficos Originais", "Remove todos os Shaders e volta ao padrão do jogo", function()
        ClearShaders()
        for prop, val in pairs(OriginalLighting) do
            pcall(function() Lighting[prop] = val end)
        end
        Hub.Notify("Gráficos Restaurados", "Iluminação original do mapa restaurada.", 3)
    end)

    -- =========================================================================
    -- SEÇÃO 3: EFEITOS DE LENTE & ÁGUA REALISTA
    -- =========================================================================
    ShadersTab:AddSection("Lente Cinematográfica & Água")

    ShadersTab:AddToggle("Desfoque de Lente (Depth of Field)", "Desfoca o fundo distante igual câmera profissional", false, function(state)
        local dof = GetOrCreate("DepthOfFieldEffect", "CustomDoF")
        dof.Enabled = state
        dof.FarIntensity = 0.6
        dof.InFocusRadius = 40
    end)

    ShadersTab:AddToggle("Brilho Neon Intenso (Ultra Bloom)", "Aumenta o brilho de todas as peças Neon do jogo", false, function(state)
        local bloom = GetOrCreate("BloomEffect", "CustomBloom")
        bloom.Enabled = state
        bloom.Intensity = 1.4
        bloom.Size = 40
        bloom.Threshold = 0.75
    end)

    ShadersTab:AddButton("🌊 Água Ultra Realista (Terrain Water)", "Deixa a água do mapa cristalina com ondas e reflexo máximo", function()
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            terrain.WaterReflectance = 1
            terrain.WaterTransparency = 0.85
            terrain.WaterWaveSize = 0.25
            terrain.WaterWaveSpeed = 16
            terrain.WaterColor = Color3.fromRGB(18, 95, 135)
            Hub.Notify("Água RTX", "Física e reflexos da água atualizados!", 3)
        end
    end)

    ShadersTab:AddSlider("Saturação de Cores", -10, 20, 0, function(val)
        local cc = GetOrCreate("ColorCorrectionEffect", "CustomCC")
        cc.Saturation = val / 10
    end)

    ShadersTab:AddSlider("Exposição de Luz (Brilho Geral)", -20, 20, 0, function(val)
        Lighting.ExposureCompensation = val / 10
    end)
end