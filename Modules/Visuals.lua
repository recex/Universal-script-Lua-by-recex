-- [[ RECEX HUB — MODULES/VISUALS.LUA ]] --
-- [[ Módulo de ESP Studio, Câmera e Iluminação (Made by recex) ]] --

return function(Hub, Tabs)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Lighting = game:GetService("Lighting")

    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    local Tab = Tabs.Visuals

    -- Paleta Recex para o ESP
    local GoldColor   = Color3.fromRGB(255, 200, 115)
    local DarkCard    = Color3.fromRGB(12, 13, 18)
    local PureWhite   = Color3.fromRGB(245, 247, 255)
    local HealthGreen = Color3.fromRGB(85, 225, 135)

    -- Estado Interno do Módulo Visual
    local State = {
        EspHighlight = false,
        EspTags      = false,
        UseTeamColor = false,
        MaxEspDist   = 1500,
        CustomFOV    = false,
        FOVValue     = 70,
        Fullbright   = false,
        NoFog        = false,
        CustomTime   = false,
        ClockTime    = 14
    }

    -- Backup da Iluminação Original do Jogo
    local OriginalLighting = {
        Brightness     = Lighting.Brightness,
        ClockTime      = Lighting.ClockTime,
        FogEnd         = Lighting.FogEnd,
        GlobalShadows  = Lighting.GlobalShadows,
        Ambient        = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient
    }

    -- Pasta dedicada para armazenar os elementos visuais com limpeza fácil
    local VisualsFolder = Camera:FindFirstChild("RecexVisualsContainer")
    if VisualsFolder then VisualsFolder:Destroy() end
    VisualsFolder = Instance.new("Folder", Camera)
    VisualsFolder.Name = "RecexVisualsContainer"

    local PlayerESPData = {}

    -- Função para pegar a cor ideal do jogador (Ouro Recex ou Cor do Time)
    local function GetPlayerColor(plr)
        if State.UseTeamColor and plr.Team and plr.TeamColor then
            return plr.TeamColor.Color
        end
        return GoldColor
    end

    -- Remove o ESP de um jogador
    local function RemoveESP(plr)
        if PlayerESPData[plr] then
            if PlayerESPData[plr].Highlight then PlayerESPData[plr].Highlight:Destroy() end
            if PlayerESPData[plr].Billboard then PlayerESPData[plr].Billboard:Destroy() end
            PlayerESPData[plr] = nil
        end
    end

    -- Cria a estrutura de Highlight e Tag para um jogador
    local function CreateOrUpdateESP(plr)
        if plr == LocalPlayer then return end

        local data = PlayerESPData[plr]
        if not data then
            data = {}
            PlayerESPData[plr] = data
        end

        -- 1. Highlight (Silhueta 3D)
        if not data.Highlight then
            local hl = Instance.new("Highlight")
            hl.Name = "RecexHL_" .. plr.Name
            hl.FillTransparency = 0.72
            hl.OutlineTransparency = 0.05
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent = VisualsFolder
            data.Highlight = hl
        end

        -- 2. BillboardGui (Card de Nome + Vida + Distância)
        if not data.Billboard then
            local bb = Instance.new("BillboardGui")
            bb.Name = "RecexTag_" .. plr.Name
            bb.Size = UDim2.new(0, 180, 0, 38)
            bb.StudsOffset = Vector3.new(0, 3.2, 0)
            bb.AlwaysOnTop = true
            bb.Parent = VisualsFolder

            local badge = Instance.new("Frame", bb)
            badge.Size = UDim2.new(1, 0, 1, 0)
            badge.BackgroundColor3 = DarkCard
            badge.BackgroundTransparency = 0.2
            Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 6)

            local stroke = Instance.new("UIStroke", badge)
            stroke.Color = GoldColor
            stroke.Thickness = 1

            local nameLbl = Instance.new("TextLabel", badge)
            nameLbl.Size = UDim2.new(1, -10, 0, 18)
            nameLbl.Position = UDim2.new(0, 5, 0, 2)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Text = plr.DisplayName
            nameLbl.TextColor3 = PureWhite
            nameLbl.Font = Enum.Font.GothamBold
            nameLbl.TextSize = 11

            local infoLbl = Instance.new("TextLabel", badge)
            infoLbl.Size = UDim2.new(1, -10, 0, 14)
            infoLbl.Position = UDim2.new(0, 5, 0, 19)
            infoLbl.BackgroundTransparency = 1
            infoLbl.Text = "100 HP • 0m"
            infoLbl.TextColor3 = GoldColor
            infoLbl.Font = Enum.Font.GothamMedium
            infoLbl.TextSize = 10

            data.Billboard = bb
            data.Stroke = stroke
            data.NameLabel = nameLbl
            data.InfoLabel = infoLbl
        end
    end

    -- Configura jogadores atuais e futuros
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then CreateOrUpdateESP(plr) end
    end
    Players.PlayerAdded:Connect(CreateOrUpdateESP)
    Players.PlayerRemoving:Connect(RemoveESP)

    -- =========================================================================
    -- SEÇÃO 1: ESP STUDIO (JOGADORES)
    -- =========================================================================
    Tab:AddSection("ESP Studio (Jogadores)")

    Tab:AddToggle("ESP Silhueta (Highlight)", "Destaca o corpo dos jogadores através das paredes", false, function(enabled)
        State.EspHighlight = enabled
        Hub.Notify("Visuais", enabled and "ESP Silhueta ativado!" or "ESP Silhueta desativado.", 2.5)
    end)

    Tab:AddToggle("ESP Tags (Nome, Vida e Distância)", "Mostra um card acima da cabeça com HP e distância em metros", false, function(enabled)
        State.EspTags = enabled
        Hub.Notify("Visuais", enabled and "ESP Tags ativado!" or "ESP Tags desativado.", 2.5)
    end)

    Tab:AddToggle("Usar Cor do Time (Team Color)", "Muda a cor do ESP automaticamente conforme a equipe do jogador", false, function(enabled)
        State.UseTeamColor = enabled
    end)

    Tab:AddSlider("Distância Máxima do ESP (Studs)", 100, 3000, 1500, function(val)
        State.MaxEspDist = val
    end)

    -- =========================================================================
    -- SEÇÃO 2: CÂMERA & CAMPO DE VISÃO (FOV)
    -- =========================================================================
    Tab:AddSection("Câmera & Visão")

    Tab:AddToggle("Ativar FOV Customizado", "Mantém o Campo de Visão (Field of View) fixo no valor escolhido", false, function(enabled)
        State.CustomFOV = enabled
        if not enabled then
            Camera.FieldOfView = 70
        end
        Hub.Notify("Câmera", enabled and ("FOV fixado em " .. State.FOVValue) or "FOV restaurado (70).", 2.5)
    end)

    Tab:AddSlider("Valor do FOV (Campo de Visão)", 50, 120, 70, function(val)
        State.FOVValue = val
        if State.CustomFOV then
            Camera.FieldOfView = val
        end
    end)

    Tab:AddButton("Desbloquear Zoom Máximo da Câmera", "Permite afastar a câmera em 3ª pessoa quase infinitamente", function()
        LocalPlayer.CameraMaxZoomDistance = 1500
        LocalPlayer.CameraMinZoomDistance = 0.5
        Hub.Notify("Câmera", "Zoom máximo desbloqueado (1500 studs)!", 3)
    end)

    -- =========================================================================
    -- SEÇÃO 3: ILUMINAÇÃO & MUNDO
    -- =========================================================================
    Tab:AddSection("Iluminação & Mundo")

    Tab:AddToggle("Visão Noturna (Fullbright)", "Remove a escuridão e sombras pesadas de qualquer mapa", false, function(enabled)
        State.Fullbright = enabled
        if not enabled then
            Lighting.Brightness = OriginalLighting.Brightness
            Lighting.GlobalShadows = OriginalLighting.GlobalShadows
            Lighting.Ambient = OriginalLighting.Ambient
            Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
        end
        Hub.Notify("Iluminação", enabled and "Fullbright ativado!" or "Iluminação original restaurada.", 2.5)
    end)

    Tab:AddToggle("Remover Neblina (No Fog)", "Limpa o horizonte removendo a neblina do mapa", false, function(enabled)
        State.NoFog = enabled
        if enabled then
            Lighting.FogEnd = 100000
            for _, v in ipairs(Lighting:GetDescendants()) do
                if v:IsA("Atmosphere") then
                    v.Density = 0
                end
            end
        else
            Lighting.FogEnd = OriginalLighting.FogEnd
        end
        Hub.Notify("Mundo", enabled and "Neblina removida!" or "Neblina restaurada.", 2.5)
    end)

    Tab:AddToggle("Travar Hora do Dia", "Permite escolher se o mapa fica de dia ou de noite", false, function(enabled)
        State.CustomTime = enabled
        if not enabled then
            Lighting.ClockTime = OriginalLighting.ClockTime
        end
    end)

    Tab:AddSlider("Horário do Mapa (0h - 24h)", 0, 24, 14, function(val)
        State.ClockTime = val
        if State.CustomTime then
            Lighting.ClockTime = val
        end
    end)

    -- =========================================================================
    -- LOOP DE RENDERIZAÇÃO EM TEMPO REAL
    -- =========================================================================
    RunService.RenderStepped:Connect(function()
        -- 1. Atualiza Câmera e Iluminação
        if State.CustomFOV and Camera.FieldOfView ~= State.FOVValue then
            Camera.FieldOfView = State.FOVValue
        end

        if State.Fullbright then
            Lighting.Brightness = 2.2
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.fromRGB(175, 175, 175)
            Lighting.OutdoorAmbient = Color3.fromRGB(175, 175, 175)
        end

        if State.CustomTime then
            Lighting.ClockTime = State.ClockTime
        end

        -- 2. Atualiza ESP de todos os jogadores
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local myPos = myRoot and myRoot.Position or Camera.CFrame.Position

        for plr, data in pairs(PlayerESPData) do
            local char = plr.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local head = char and char:FindFirstChild("Head")

            if char and hum and root and hum.Health > 0 then
                local dist = math.floor((root.Position - myPos).Magnitude)
                local withinRange = (dist <= State.MaxEspDist)
                local espColor = GetPlayerColor(plr)

                -- Atualiza Silhueta (Highlight)
                if data.Highlight then
                    data.Highlight.Enabled = State.EspHighlight and withinRange
                    if data.Highlight.Enabled then
                        data.Highlight.Adornee = char
                        data.Highlight.FillColor = espColor
                        data.Highlight.OutlineColor = espColor
                    end
                end

                -- Atualiza Card Flutuante (BillboardGui)
                if data.Billboard then
                    data.Billboard.Enabled = State.EspTags and withinRange
                    if data.Billboard.Enabled then
                        data.Billboard.Adornee = head or root
                        data.Stroke.Color = espColor
                        local hp = math.floor(hum.Health)
                        data.NameLabel.Text = plr.DisplayName
                        data.InfoLabel.Text = string.format("%d HP  •  %dm", hp, dist)
                        data.InfoLabel.TextColor3 = (hp > 50) and espColor or Color3.fromRGB(255, 95, 95)
                    end
                end
            else
                if data.Highlight then data.Highlight.Enabled = false end
                if data.Billboard then data.Billboard.Enabled = false end
            end
        end
    end)
end
