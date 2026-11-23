--[[
    RECEX SOVEREIGN VIP - EXCLUSIVE PAID MODULE
    made by recex (SOVEREIGN VIP EDITION)
]]

return function(Hub, Tabs, vipData)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local TeleportService = game:GetService("TeleportService")
    local HttpService = game:GetService("HttpService")
    local Lighting = game:GetService("Lighting")

    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local HubGui = PlayerGui:FindFirstChild("RecexStudioHub")

    local VIPTab = Hub:CreateTab("👑 Sovereign VIP")

    local VIPFolder = Camera:FindFirstChild("RecexVIPAssets3D") or Instance.new("Folder")
    VIPFolder.Name = "RecexVIPAssets3D"
    VIPFolder.Parent = Camera

    local function GetRoot(plr)
        plr = plr or LocalPlayer
        return plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    end

    local function GetHum(plr)
        plr = plr or LocalPlayer
        return plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
    end

    -- =========================================================================
    -- 1. PERSONALIZAÇÃO DE TEMAS VIP & BARRA DE COMANDOS (TECLA ;)
    -- =========================================================================
    VIPTab:AddSection("Personalização & Comandos VIP")

    local function ApplyHubTheme(c1, c2)
        if not HubGui then return end
        for _, obj in ipairs(HubGui:GetDescendants()) do
            if obj:IsA("UIGradient") then
                obj.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, c1),
                    ColorSequenceKeypoint.new(0.5, c2),
                    ColorSequenceKeypoint.new(1, c1)
                })
            end
        end
    end

    -- Já aplica o Tema Carmesim & Ouro por padrão ao entrar no VIP
    ApplyHubTheme(Color3.fromRGB(235, 35, 75), Color3.fromRGB(255, 200, 65))

    VIPTab:AddButton("🎨 Tema VIP: Carmesim & Ouro Imperial", "Aplica a paleta oficial da edição paga Sovereign", function()
        ApplyHubTheme(Color3.fromRGB(235, 35, 75), Color3.fromRGB(255, 200, 65))
        Hub.Notify("Tema VIP", "Paleta Carmesim & Ouro ativada!", 2)
    end)

    VIPTab:AddButton("🎨 Tema VIP: Diamante & Azul Real", "Aplica um gradiente brilhante azul safira e diamante", function()
        ApplyHubTheme(Color3.fromRGB(50, 160, 255), Color3.fromRGB(220, 245, 255))
        Hub.Notify("Tema VIP", "Paleta Diamante Real ativada!", 2)
    end)

    VIPTab:AddButton("🎨 Tema VIP: Esmeralda Matrix", "Aplica um gradiente verde neon executivo", function()
        ApplyHubTheme(Color3.fromRGB(25, 225, 110), Color3.fromRGB(180, 255, 210))
        Hub.Notify("Tema VIP", "Paleta Esmeralda ativada!", 2)
    end)

    -- Barra de Comandos Flutuante VIP (Tecla ;)
    local CmdBarFrame, CmdInput
    if HubGui then
        local oldCmd = HubGui:FindFirstChild("RecexVIPCmdBar")
        if oldCmd then oldCmd:Destroy() end

        CmdBarFrame = Instance.new("Frame")
        CmdBarFrame.Name = "RecexVIPCmdBar"
        CmdBarFrame.Size = UDim2.new(0, 320, 0, 38)
        CmdBarFrame.Position = UDim2.new(0.5, 0, 1, 50)
        CmdBarFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        CmdBarFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
        CmdBarFrame.BorderSizePixel = 0
        CmdBarFrame.Visible = false
        CmdBarFrame.Parent = HubGui

        Instance.new("UICorner", CmdBarFrame).CornerRadius = UDim.new(0, 10)
        local cmdStroke = Instance.new("UIStroke", CmdBarFrame)
        cmdStroke.Color = Color3.fromRGB(235, 35, 75)
        cmdStroke.Thickness = 1.5

        CmdInput = Instance.new("TextBox")
        CmdInput.Size = UDim2.new(1, -24, 1, 0)
        CmdInput.Position = UDim2.new(0, 12, 0, 0)
        CmdInput.BackgroundTransparency = 1
        CmdInput.Text = ""
        CmdInput.PlaceholderText = "👑 Comando VIP (;speed 100, ;jump 120, ;fov 100, ;day, ;night, ;rejoin)"
        CmdInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
        CmdInput.TextColor3 = Color3.fromRGB(255, 200, 65)
        CmdInput.Font = Enum.Font.GothamBold
        CmdInput.TextSize = 11
        CmdInput.TextXAlignment = Enum.TextXAlignment.Left
        CmdInput.Parent = CmdBarFrame

        CmdInput.FocusLost:Connect(function(enterPressed)
            if enterPressed and #CmdInput.Text > 0 then
                local raw = CmdInput.Text:lower():gsub("^;", "")
                local args = string.split(raw, " ")
                local cmd = args[1]
                local val = tonumber(args[2])

                if cmd == "speed" and val and GetHum() then
                    GetHum().WalkSpeed = val
                    Hub.Notify("Comando VIP", "WalkSpeed alterado para " .. val, 2)
                elseif cmd == "jump" and val and GetHum() then
                    GetHum().UseJumpPower = true
                    GetHum().JumpPower = val
                    Hub.Notify("Comando VIP", "JumpPower alterado para " .. val, 2)
                elseif cmd == "fov" and val then
                    Camera.FieldOfView = math.clamp(val, 40, 120)
                    Hub.Notify("Comando VIP", "FOV alterado para " .. val, 2)
                elseif cmd == "day" then
                    Lighting.ClockTime = 14
                elseif cmd == "night" then
                    Lighting.ClockTime = 0
                elseif cmd == "rejoin" then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
                end
            end
            CmdInput.Text = ""
            TweenService:Create(CmdBarFrame, TweenInfo.new(0.25), {Position = UDim2.new(0.5, 0, 1, 50)}):Play()
            task.delay(0.25, function() CmdBarFrame.Visible = false end)
        end)
    end

    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode.Semicolon and CmdBarFrame then
            CmdBarFrame.Visible = true
            TweenService:Create(CmdBarFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 0, 1, -45)
            }):Play()
            task.wait(0.05)
            CmdInput:CaptureFocus()
        end
    end)

    -- =========================================================================
    -- 2. MIRA ASSISTIDA VIP + CÍRCULO FOV + TARGET HUD (FOTO & VIDA DO ALVO)
    -- =========================================================================
    VIPTab:AddSection("Aim Assist VIP, Círculo FOV & Target HUD")

    local FOVCircleEnabled = false
    local AimAssistVIP = false
    local TargetHUDEnabled = false
    local FOVRadius = 110
    local AimSmoothness = 0.25

    local FOVCircleFrame, TargetCard, TargetAvatar, TargetNameLbl, TargetHPBar, TargetDistLbl

    if HubGui then
        -- Círculo FOV na tela
        FOVCircleFrame = Instance.new("Frame")
        FOVCircleFrame.Name = "RecexFOVCircle"
        FOVCircleFrame.Size = UDim2.new(0, FOVRadius * 2, 0, FOVRadius * 2)
        FOVCircleFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        FOVCircleFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        FOVCircleFrame.BackgroundTransparency = 1
        FOVCircleFrame.Visible = false
        FOVCircleFrame.Parent = HubGui

        Instance.new("UICorner", FOVCircleFrame).CornerRadius = UDim.new(1, 0)
        local fovStroke = Instance.new("UIStroke", FOVCircleFrame)
        fovStroke.Color = Color3.fromRGB(235, 35, 75)
        fovStroke.Thickness = 1.5
        fovStroke.Transparency = 0.2

        -- Card Flutuante do Alvo (Target HUD)
        TargetCard = Instance.new("Frame")
        TargetCard.Name = "RecexTargetHUD"
        TargetCard.Size = UDim2.new(0, 210, 0, 58)
        TargetCard.Position = UDim2.new(0.5, 0, 0.78, 0)
        TargetCard.AnchorPoint = Vector2.new(0.5, 0.5)
        TargetCard.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
        TargetCard.BorderSizePixel = 0
        TargetCard.Visible = false
        TargetCard.Parent = HubGui

        Instance.new("UICorner", TargetCard).CornerRadius = UDim.new(0, 10)
        local thStroke = Instance.new("UIStroke", TargetCard)
        thStroke.Color = Color3.fromRGB(255, 200, 65)
        thStroke.Thickness = 1.2

        TargetAvatar = Instance.new("ImageLabel")
        TargetAvatar.Size = UDim2.new(0, 42, 0, 42)
        TargetAvatar.Position = UDim2.new(0, 8, 0.5, -21)
        TargetAvatar.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
        TargetAvatar.Parent = TargetCard
        Instance.new("UICorner", TargetAvatar).CornerRadius = UDim.new(1, 0)

        TargetNameLbl = Instance.new("TextLabel")
        TargetNameLbl.Size = UDim2.new(1, -64, 0, 16)
        TargetNameLbl.Position = UDim2.new(0, 58, 0, 8)
        TargetNameLbl.BackgroundTransparency = 1
        TargetNameLbl.Text = "Nenhum Alvo"
        TargetNameLbl.TextColor3 = Color3.fromRGB(245, 245, 250)
        TargetNameLbl.Font = Enum.Font.GothamBlack
        TargetNameLbl.TextSize = 11
        TargetNameLbl.TextXAlignment = Enum.TextXAlignment.Left
        TargetNameLbl.TextTruncate = Enum.TextTruncate.AtEnd
        TargetNameLbl.Parent = TargetCard

        TargetDistLbl = Instance.new("TextLabel")
        TargetDistLbl.Size = UDim2.new(1, -64, 0, 14)
        TargetDistLbl.Position = UDim2.new(0, 58, 0, 23)
        TargetDistLbl.BackgroundTransparency = 1
        TargetDistLbl.Text = "HP: 100% • 0m"
        TargetDistLbl.TextColor3 = Color3.fromRGB(255, 200, 65)
        TargetDistLbl.Font = Enum.Font.GothamMedium
        TargetDistLbl.TextSize = 9
        TargetDistLbl.TextXAlignment = Enum.TextXAlignment.Left
        TargetDistLbl.Parent = TargetCard

        local hpBg = Instance.new("Frame")
        hpBg.Size = UDim2.new(1, -68, 0, 6)
        hpBg.Position = UDim2.new(0, 58, 0, 42)
        hpBg.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
        hpBg.BorderSizePixel = 0
        hpBg.Parent = TargetCard
        Instance.new("UICorner", hpBg).CornerRadius = UDim.new(1, 0)

        TargetHPBar = Instance.new("Frame")
        TargetHPBar.Size = UDim2.new(1, 0, 1, 0)
        TargetHPBar.BackgroundColor3 = Color3.fromRGB(235, 35, 75)
        TargetHPBar.BorderSizePixel = 0
        TargetHPBar.Parent = hpBg
        Instance.new("UICorner", TargetHPBar).CornerRadius = UDim.new(1, 0)
    end

    VIPTab:AddToggle("Mostrar Círculo FOV na Tela", "Desenha o raio de captura de alvo no centro da tela", false, function(state)
        FOVCircleEnabled = state
        if FOVCircleFrame then FOVCircleFrame.Visible = state end
    end)

    VIPTab:AddSlider("Tamanho do Círculo FOV", 40, 300, 110, function(val)
        FOVRadius = val
        if FOVCircleFrame then
            FOVCircleFrame.Size = UDim2.new(0, val * 2, 0, val * 2)
        end
    end)

    VIPTab:AddToggle("Ativar Aim Assist Suave (Dentro do FOV)", "Puxa suavemente a mira para o inimigo dentro do círculo FOV", false, function(state)
        AimAssistVIP = state
    end)

    VIPTab:AddSlider("Suavidade da Mira (Smoothness %)", 10, 100, 35, function(val)
        AimSmoothness = val / 100
    end)

    VIPTab:AddToggle("Mostrar Painel do Alvo (Target HUD VIP)", "Mostra foto, vida e distância do jogador na sua mira", false, function(state)
        TargetHUDEnabled = state
        if not state and TargetCard then TargetCard.Visible = false end
    end)

    -- =========================================================================
    -- 3. CLONADOR DE SKIN / AVATAR MORPH & COSMÉTICOS IMPERIAIS
    -- =========================================================================
    VIPTab:AddSection("Clonador de Avatar (Morph) & Itens Raros")

    local function CopyPlayerAppearance(targetPlr)
        local myChar = LocalPlayer.Character
        local tChar = targetPlr and targetPlr.Character
        if not myChar or not tChar then return end

        -- Remove roupas e acessórios atuais
        for _, v in ipairs(myChar:GetChildren()) do
            if v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") or v:IsA("Accessory") or v:IsA("BodyColors") then
                v:Destroy()
            end
        end

        -- Clona roupas, cores e acessórios do alvo
        for _, v in ipairs(tChar:GetChildren()) do
            if v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") or v:IsA("Accessory") or v:IsA("BodyColors") then
                v:Clone().Parent = myChar
            end
        end

        Hub.Notify("👑 Avatar Clonado!", "Você copiou a skin de " .. targetPlr.DisplayName, 3)
    end

    VIPTab:AddButton("🎭 Clonar Skin do Jogador Mais Próximo", "Copia instantaneamente a roupa e acessórios de quem estiver perto", function()
        local myRoot = GetRoot()
        if not myRoot then return end
        local closest, minDist = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and GetRoot(p) then
                local d = (GetRoot(p).Position - myRoot.Position).Magnitude
                if d < minDist then
                    minDist = d
                    closest = p
                end
            end
        end
        if closest then
            CopyPlayerAppearance(closest)
        end
    end)

    VIPTab:AddButton("🎲 Clonar Skin de um Jogador Aleatório", "Transforma seu avatar na skin de alguém do servidor", function()
        local list = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then table.insert(list, p) end
        end
        if #list > 0 then
            CopyPlayerAppearance(list[math.random(1, #list)])
        end
    end)

    VIPTab:AddToggle("✨ Kit Headless + Korblox + Halo Imperial 3D", "Deixa a cabeça invisível e adiciona auréola Carmesim & Ouro", false, function(state)
        local char = LocalPlayer.Character
        if not char then return end
        local head = char:FindFirstChild("Head")
        local rLeg = char:FindFirstChild("RightLowerLeg") or char:FindFirstChild("Right Leg")

        if head then
            head.Transparency = state and 1 or 0
            local face = head:FindFirstChildOfClass("Decal")
            if face then face.Transparency = state and 1 or 0 end
        end
        if rLeg then
            rLeg.Transparency = state and 1 or 0
        end

        local oldHalo = VIPFolder:FindFirstChild("SovereignHalo")
        if oldHalo then oldHalo:Destroy() end

        if state then
            local halo = Instance.new("Part")
            halo.Name = "SovereignHalo"
            halo.Shape = Enum.PartType.Cylinder
            halo.Size = Vector3.new(0.25, 3.2, 3.2)
            halo.Material = Enum.Material.Neon
            halo.Color = Color3.fromRGB(235, 35, 75)
            halo.Anchored = true
            halo.CanCollide = false
            halo.Parent = VIPFolder
        end
    end)

    -- =========================================================================
    -- 4. MECHA IMPERIAL 3D (TITÃ DE COMBATE CONTROLÁVEL)
    -- =========================================================================
    VIPTab:AddSection("Mecha Imperial 3D (Exclusivo VIP)")

    local MechaActive = false
    local MechaModel = nil

    VIPTab:AddToggle("🤖 Invocar Armadura Mecha Sovereign 3D", "Constrói um robô titã negro, carmesim e dourado ao redor de você", false, function(state)
        MechaActive = state
        if MechaModel then MechaModel:Destroy() MechaModel = nil end

        if state then
            MechaModel = Instance.new("Model")
            MechaModel.Name = "SovereignMecha3D"
            MechaModel.Parent = VIPFolder

            local function AddMechaPart(name, size, col, mat)
                local p = Instance.new("Part")
                p.Name = name
                p.Size = size
                p.Color = col
                p.Material = mat or Enum.Material.Metal
                p.Anchored = true
                p.CanCollide = false
                p.Parent = MechaModel
                return p
            end

            AddMechaPart("Chest", Vector3.new(8, 10, 5), Color3.fromRGB(15, 15, 22), Enum.Material.Metal)
            AddMechaPart("ReactorCore", Vector3.new(3.2, 3.2, 5.4), Color3.fromRGB(235, 35, 75), Enum.Material.Neon)
            AddMechaPart("LeftShoulder", Vector3.new(3.5, 4, 4), Color3.fromRGB(255, 200, 65), Enum.Material.Neon)
            AddMechaPart("RightShoulder", Vector3.new(3.5, 4, 4), Color3.fromRGB(255, 200, 65), Enum.Material.Neon)
            AddMechaPart("VisorHead", Vector3.new(4, 3.5, 4), Color3.fromRGB(235, 35, 75), Enum.Material.Neon)

            Hub.Notify("👑 Mecha Sovereign 3D", "Titã Imperial ativado!", 3)
        end
    end)

    -- =========================================================================
    -- 5. SEGURANÇA VIP: ANTI-MOD/STAFF & SERVER SNIPER (SERVIDOR VAZIO)
    -- =========================================================================
    VIPTab:AddSection("Segurança VIP & Server Sniper")

    local AntiStaffEnabled = false
    VIPTab:AddToggle("🛡️ Detector Anti-Admin / Criador do Jogo", "Avisa imediatamente se um admin ou dono do jogo entrar na sala", true, function(state)
        AntiStaffEnabled = state
    end)

    Players.PlayerAdded:Connect(function(newPlr)
        if not AntiStaffEnabled then return end
        if newPlr.UserId == game.CreatorId then
            Hub.Notify("⚠️ ALERTA DE SEGURANÇA VIP", "O Criador do jogo (" .. newPlr.Name .. ") acabou de entrar no servidor!", 8)
        end
    end)

    VIPTab:AddButton("🕵️ Entrar no Servidor Mais Vazio (Low Player Hop)", "Procura um servidor quase vazio para você farmar sozinho", function()
        Hub.Notify("Server Sniper VIP", "Buscando o servidor mais vazio disponível...", 3)
        pcall(function()
            local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            local res = HttpService:JSONDecode(game:HttpGet(url))
            for _, srv in ipairs(res.data) do
                if srv.playing < srv.maxPlayers and srv.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, srv.id, LocalPlayer)
                    break
                end
            end
        end)
    end)

    -- =========================================================================
    -- LOOP EM TEMPO REAL DO MÓDULO VIP
    -- =========================================================================
    local LastAvatarId = nil

    RunService.RenderStepped:Connect(function(dt)
        local myRoot = GetRoot()

        -- 1. Busca o alvo dentro do Círculo FOV
        local bestTarget, bestScreenDist = nil, FOVRadius
        local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local head = plr.Character:FindFirstChild("Head")
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if head and hum and hum.Health > 0 then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local dist2D = (Vector2.new(screenPos.X, screenPos.Y) - centerScreen).Magnitude
                        if dist2D < bestScreenDist then
                            bestScreenDist = dist2D
                            bestTarget = plr
                        end
                    end
                end
            end
        end

        -- 2. Aim Assist Suave VIP
        if AimAssistVIP and bestTarget and bestTarget.Character and bestTarget.Character:FindFirstChild("Head") then
            local targetPos = bestTarget.Character.Head.Position
            local goalCF = CFrame.new(Camera.CFrame.Position, targetPos)
            Camera.CFrame = Camera.CFrame:Lerp(goalCF, AimSmoothness)
        end

        -- 3. Atualiza Target HUD VIP
        if TargetHUDEnabled and TargetCard then
            if bestTarget and bestTarget.Character then
                TargetCard.Visible = true
                local tHum = GetHum(bestTarget)
                local tRoot = GetRoot(bestTarget)
                local hpRatio = (tHum and tHum.MaxHealth > 0) and math.clamp(tHum.Health / tHum.MaxHealth, 0, 1) or 1
                local studs = (myRoot and tRoot) and math.floor((tRoot.Position - myRoot.Position).Magnitude) or 0

                TargetNameLbl.Text = "👑 " .. bestTarget.DisplayName
                TargetDistLbl.Text = string.format("HP: %d%%  •  Distância: %dm", math.floor(hpRatio * 100), studs)
                TargetHPBar.Size = TargetHPBar.Size:Lerp(UDim2.new(hpRatio, 0, 1, 0), dt * 12)

                if LastAvatarId ~= bestTarget.UserId then
                    LastAvatarId = bestTarget.UserId
                    TargetAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(bestTarget.UserId) .. "&w=150&h=150"
                end
            else
                TargetCard.Visible = false
            end
        end

        -- 4. Atualiza Halo Imperial & Mecha 3D
        if myRoot then
            local halo = VIPFolder:FindFirstChild("SovereignHalo")
            if halo then
                halo.CFrame = CFrame.new(myRoot.Position + Vector3.new(0, 3.8, 0)) * CFrame.Angles(math.rad(15), tick() * 2, math.rad(90))
            end

            if MechaActive and MechaModel then
                local baseCF = myRoot.CFrame
                local chest = MechaModel:FindFirstChild("Chest")
                local core = MechaModel:FindFirstChild("ReactorCore")
                local lSh = MechaModel:FindFirstChild("LeftShoulder")
                local rSh = MechaModel:FindFirstChild("RightShoulder")
                local head = MechaModel:FindFirstChild("VisorHead")

                if chest and core and lSh and rSh and head then
                    chest.CFrame = baseCF * CFrame.new(0, 3, 2.5)
                    core.CFrame = baseCF * CFrame.new(0, 3.5, 2.5)
                    lSh.CFrame = baseCF * CFrame.new(-6, 6.5, 2.5)
                    rSh.CFrame = baseCF * CFrame.new(6, 6.5, 2.5)
                    head.CFrame = baseCF * CFrame.new(0, 10, 2.5)
                end
            end
        end
    end)
end