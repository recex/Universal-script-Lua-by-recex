--[[
    RECEX SOVEREIGN VIP - TECHNICAL ENGINE MODULE
    CFrame Movement | World & Physics | Anti-Aim, Desync, Fake Lag, Hitbox & State Spoofing
    made by recex (PAID VIP EDITION)
]]

return function(Hub, Tabs, vipData)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    local Mouse = LocalPlayer:GetMouse()

    local VIPTab = Hub:CreateTab("👑 Sovereign VIP")

    local VisualFolder = Camera:FindFirstChild("RecexVIPTechVisuals") or Instance.new("Folder")
    VisualFolder.Name = "RecexVIPTechVisuals"
    VisualFolder.Parent = Camera

    local function GetRoot(plr)
        plr = plr or LocalPlayer
        return plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    end

    local function GetHum(plr)
        plr = plr or LocalPlayer
        return plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
    end

    local function GetClosestEnemy()
        local myRoot = GetRoot()
        if not myRoot then return nil end
        local closest, minDist = nil, math.huge
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local r = GetRoot(plr)
                local h = GetHum(plr)
                if r and h and h.Health > 0 then
                    local d = (r.Position - myRoot.Position).Magnitude
                    if d < minDist then
                        minDist = d
                        closest = plr
                    end
                end
            end
        end
        return closest
    end

    -- =========================================================================
    -- SEÇÃO 1: CFRAME MOVEMENT, TELEPORT & GRAVITY HACK
    -- =========================================================================
    VIPTab:AddSection("⚡ CFrame Movement, Teleport & Gravity")

    local CFrameSpeedEnabled = false
    local CFrameSpeedMultiplier = 45

    VIPTab:AddToggle("1. CFrame Speed Movement (Bypass WalkSpeed)", "Move o personagem direto pela matriz CFrame ignorando travas de WalkSpeed", false, function(state)
        CFrameSpeedEnabled = state
    end)

    VIPTab:AddSlider("Multiplicador CFrame Speed", 10, 180, 45, function(val)
        CFrameSpeedMultiplier = val
    end)

    local CFrameFlyEnabled = false
    local CFrameFlySpeed = 65

    VIPTab:AddToggle("2. CFrame Fly (Voo Puro Sem BodyVelocity)", "Trava o eixo por CFrame puro sem criar objetos detectáveis no personagem", false, function(state)
        CFrameFlyEnabled = state
        local root = GetRoot()
        if not state and root then
            root.Anchored = false
        end
    end)

    VIPTab:AddSlider("Velocidade do CFrame Fly", 20, 220, 65, function(val)
        CFrameFlySpeed = val
    end)

    VIPTab:AddButton("3. Instant CFrame Teleport (Posição do Mouse)", "Teleporta instantaneamente para onde o cursor estiver apontando", function()
        local root = GetRoot()
        if root and Mouse.Hit then
            root.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3.2, 0))
            Hub.Notify("CFrame Teleport", "Posição alterada com sucesso!", 2)
        end
    end)

    VIPTab:AddButton("4. CFrame Backstab Teleport (Atrás do Alvo)", "Coloca você exatamente a 3.5 studs nas costas do inimigo mais próximo", function()
        local enemy = GetClosestEnemy()
        local myRoot = GetRoot()
        if enemy and GetRoot(enemy) and myRoot then
            myRoot.CFrame = GetRoot(enemy).CFrame * CFrame.new(0, 0, 3.5)
            Hub.Notify("Backstab TP", "Alvo: " .. enemy.DisplayName, 2)
        end
    end)

    local GravityHackEnabled = false
    local CustomGravityVal = 35
    local DefaultGravity = workspace.Gravity

    VIPTab:AddToggle("5. Gravity Hack (Alterar Gravidade Global)", "Substitui a gravidade padrão (196.2) pelo valor configurado abaixo", false, function(state)
        GravityHackEnabled = state
        workspace.Gravity = state and CustomGravityVal or DefaultGravity
    end)

    VIPTab:AddSlider("Valor da Gravidade (0 = Gravidade Zero)", 0, 196, 35, function(val)
        CustomGravityVal = val
        if GravityHackEnabled then
            workspace.Gravity = val
        end
    end)

    -- =========================================================================
    -- SEÇÃO 2: 🧨 WORLD EXPLOITS (REMOTES, NETWORK OWNERSHIP, PHYSICS, CLIENT)
    -- =========================================================================
    VIPTab:AddSection("🧨 World, Remotes, Network & Physics")

    -- Remote Spy / Inspector
    local RemoteSpyActive = false
    local HookInstalled = false

    VIPTab:AddToggle("6. Remote Spy / Logger (Monitorar no Console F9)", "Registra chamadas de RemoteEvent/RemoteFunction em tempo real no F9", false, function(state)
        RemoteSpyActive = state
        if state then
            Hub.Notify("Remote Spy Ativo", "Abra o console (F9) para ver os Remotes disparados!", 4)

            -- Se o executor suportar hookmetamethod, intercepta FireServer/InvokeServer
            if not HookInstalled and hookmetamethod and getnamecallmethod then
                HookInstalled = true
                pcall(function()
                    local oldNamecall
                    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                        local method = getnamecallmethod()
                        if RemoteSpyActive and (method == "FireServer" or method == "InvokeServer") then
                            local args = {...}
                            warn(string.format("[👑 RECEX REMOTE SPY] %s:%s() | Caminho: %s | Args: %d",
                                tostring(self.Name), method, tostring(self:GetFullName()), #args))
                        end
                        return oldNamecall(self, ...)
                    end)
                end)
            end
        end
    end)

    VIPTab:AddButton("7. Escanear & Copiar Todos os Remotes do Jogo", "Lista todos os RemoteEvents/Functions no F9 e copia para o Clipboard", function()
        local list = {}
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                local entry = string.format("[%s] %s", v.ClassName, v:GetFullName())
                table.insert(list, entry)
                print(entry)
            end
        end
        if setclipboard and #list > 0 then
            setclipboard(table.concat(list, "\n"))
        end
        Hub.Notify("Scanner de Remotes", #list .. " Remotes encontrados e copiados!", 4)
    end)

    -- Auto-Trigger Remotes / Interações Próximas
    local AutoTriggerWorld = false
    VIPTab:AddToggle("8. Auto-Trigger Interações (Click/Touch/Prompt)", "Aciona automaticamente ClickDetectors, TouchInterests e Prompts próximos", false, function(state)
        AutoTriggerWorld = state
    end)

    -- Network Ownership Abuse (SimulationRadius Maximizer)
    local NetOwnershipActive = false
    VIPTab:AddToggle("9. Network Ownership (Maximizar SimulationRadius)", "Assume o controle físico das peças soltas do servidor ao seu redor", false, function(state)
        NetOwnershipActive = state
        if state then
            Hub.Notify("Network Ownership", "SimulationRadius expandido ao máximo!", 3)
        end
    end)

    -- Physics Exploits (Repulsão / Vórtice / Super Ice)
    local PhysicsVortexActive = false
    VIPTab:AddToggle("10. Physics Manipulation (Levitar & Lançar Peças)", "Usa sua Network Ownership para acelerar peças soltas em órbita", false, function(state)
        PhysicsVortexActive = state
    end)

    local ZeroFrictionActive = false
    VIPTab:AddToggle("11. Physics Friction Hack (Zero Atrito / Super Slide)", "Remove o atrito físico do seu personagem permitindo deslizar sem perder embalo", false, function(state)
        ZeroFrictionActive = state
        if LocalPlayer.Character then
            for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CustomPhysicalProperties = state and PhysicalProperties.new(0.7, 0, 0, 100, 100) or nil
                end
            end
        end
    end)

    -- Client-Side Manipulation
    local ClickDeleteMode = false
    VIPTab:AddToggle("12. Client-Side Manipulation (Tecla X = Deletar Parede)", "Aponte o mouse para qualquer parede/porta e aperte X para removê-la localmente", false, function(state)
        ClickDeleteMode = state
        if state then
            Hub.Notify("Client Manipulation", "Aponte o mouse para qualquer objeto e aperte a tecla [X]!", 3)
        end
    end)

    VIPTab:AddButton("13. Remover Barreiras Invisíveis do Mapa", "Destrói paredes invisíveis (Transparency 1) que bloqueiam passagem", function()
        local count = 0
        for _, p in ipairs(workspace:GetDescendants()) do
            if p:IsA("BasePart") and p.Transparency >= 0.98 and p.CanCollide and not p:IsDescendantOf(LocalPlayer.Character) then
                p.CanCollide = false
                count += 1
            end
        end
        Hub.Notify("Client Manipulation", count .. " barreiras invisíveis desativadas!", 3)
    end)

    -- =========================================================================
    -- SEÇÃO 3: ☠️ EXPLOITS AVANÇADOS (ANTI-AIM, DESYNC, FAKE LAG, HITBOX, STATE)
    -- =========================================================================
    VIPTab:AddSection("☠️ Exploits Avançados (Desync, Hitbox & State)")

    -- 14. Anti-Aim (Spin / Jitter)
    local AntiAimEnabled = false
    local AntiAimSpeed = 35

    VIPTab:AddToggle("14. Anti-Aim (Rotação Jitter / Spin Inverso)", "Gira seu corpo em ângulos quebrados sem afetar sua câmera de visão", false, function(state)
        AntiAimEnabled = state
        local hum = GetHum()
        if hum then
            hum.AutoRotate = not state
        end
    end)

    -- 15. CFrame Desync (Com Visualizador Holográfico)
    local DesyncEnabled = false
    local DesyncRange = 8
    local DesyncGhost = nil

    VIPTab:AddToggle("15. CFrame Desync (Deslocar Hitbox do Servidor)", "Desloca sua posição física em alta frequência com marcador holográfico", false, function(state)
        DesyncEnabled = state
        if DesyncGhost then DesyncGhost:Destroy() DesyncGhost = nil end
        if state then
            DesyncGhost = Instance.new("Part")
            DesyncGhost.Size = Vector3.new(2, 5, 1)
            DesyncGhost.Material = Enum.Material.ForceField
            DesyncGhost.Color = Color3.fromRGB(235, 35, 75)
            DesyncGhost.Anchored = true
            DesyncGhost.CanCollide = false
            DesyncGhost.Parent = VisualFolder
        end
    end)

    VIPTab:AddSlider("Distância do Desync (Studs)", 3, 25, 8, function(val)
        DesyncRange = val
    end)

    -- 16. Fake Lag (Network Choke Simulator)
    local FakeLagEnabled = false
    local FakeLagInterval = 0.35
    local LastLagSwitch = 0

    VIPTab:AddToggle("16. Fake Lag (Simulador de Ping Alto / Teleporte)", "Trava e solta a replicação física para você parecer lagado aos inimigos", false, function(state)
        FakeLagEnabled = state
        local root = GetRoot()
        if not state and root then
            root.Anchored = false
        end
    end)

    VIPTab:AddSlider("Intervalo do Fake Lag (Décimos de Seg.)", 1, 10, 4, function(val)
        FakeLagInterval = val / 10
    end)

    -- 17. Hitbox Manipulation (Expander + Visualizer)
    local HitboxEnabled = false
    local HitboxSize = 14

    local function ResetHitboxes()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and GetRoot(plr) then
                local r = GetRoot(plr)
                r.Size = Vector3.new(2, 2, 1)
                r.Transparency = 1
                r.Material = Enum.Material.Plastic
            end
        end
    end

    VIPTab:AddToggle("17. Hitbox Manipulation (Expandir Hitbox Inimiga)", "Aumenta a caixa de colisão dos inimigos para acertar ataques de longe", false, function(state)
        HitboxEnabled = state
        if not state then ResetHitboxes() end
    end)

    VIPTab:AddSlider("Tamanho da Hitbox (Studs)", 4, 45, 14, function(val)
        HitboxSize = val
    end)

    -- 18. Animation Spoofing (Cancelar / Substituir Animações)
    local NoAnimsSpoof = false
    local AnimSpeedMult = 1

    VIPTab:AddToggle("18. Animation Spoofing (Ocultar Animações / T-Pose)", "Interrompe a replicação das suas animações para esconder seus ataques", false, function(state)
        NoAnimsSpoof = state
        local hum = GetHum()
        if hum then
            for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
                if state then track:Stop() end
            end
        end
    end)

    VIPTab:AddSlider("Velocidade das Animações (Spoof Speed)", 0, 10, 1, function(val)
        AnimSpeedMult = val
        local hum = GetHum()
        if hum then
            for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
                track:AdjustSpeed(val)
            end
        end
    end)

    -- 19. State Manipulation (Forçar Estados do Humanoid)
    local SwimAirState = false
    local AntiStunState = false

    VIPTab:AddToggle("19. State Manipulation: Nadar no Ar (Swimming State)", "Força o HumanoidState para Swimming permitindo nadar livremente pelo céu", false, function(state)
        SwimAirState = state
        local hum = GetHum()
        if not state and hum then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)

    VIPTab:AddToggle("20. State Manipulation: Anti-Ragdoll / Anti-Stun", "Bloqueia estados de queda (Ragdoll, FallingDown, PlatformStand)", false, function(state)
        AntiStunState = state
    end)

    -- =========================================================================
    -- EVENTOS DE TECLADO & LOOP TÉCNICO DE ALTA FREQUÊNCIA
    -- =========================================================================
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        -- Tecla X: Deletar objeto Client-Side (#12)
        if input.KeyCode == Enum.KeyCode.X and ClickDeleteMode then
            local target = Mouse.Target
            if target and not target:IsDescendantOf(LocalPlayer.Character) then
                local name = target.Name
                target:Destroy()
                Hub.Notify("Client Delete [X]", "Objeto '" .. name .. "' removido localmente!", 2)
            end
        end
    end)

    local LastWorldTrigger = 0

    RunService.RenderStepped:Connect(function(dt)
        local root = GetRoot()
        local hum = GetHum()
        if not root or not hum then return end

        -- [1] CFrame Speed Movement
        if CFrameSpeedEnabled and hum.MoveDirection.Magnitude > 0 then
            root.CFrame = root.CFrame + (hum.MoveDirection * (CFrameSpeedMultiplier * dt))
        end

        -- [2] CFrame Fly Puro
        if CFrameFlyEnabled then
            root.AssemblyLinearVelocity = Vector3.zero
            local camCF = Camera.CFrame
            local moveVec = Vector3.zero

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVec += camCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVec -= camCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVec += camCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVec -= camCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVec += Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveVec -= Vector3.new(0, 1, 0) end

            if moveVec.Magnitude == 0 and hum.MoveDirection.Magnitude > 0 then
                moveVec = (camCF.LookVector * -hum.MoveDirection.Z) + (camCF.RightVector * hum.MoveDirection.X)
            end

            root.CFrame = CFrame.new(root.Position + (moveVec * CFrameFlySpeed * dt), root.Position + (moveVec * CFrameFlySpeed * dt) + camCF.LookVector)
        end

        -- [9] Network Ownership (SimulationRadius)
        if NetOwnershipActive then
            pcall(function()
                if sethiddenproperty then
                    sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
                    sethiddenproperty(LocalPlayer, "MaxSimulationRadius", math.huge)
                end
            end)
        end

        -- [10] Physics Manipulation (Vórtice de Peças Soltas)
        if PhysicsVortexActive then
            for _, p in ipairs(workspace:GetChildren()) do
                if p:IsA("BasePart") and not p.Anchored and (p.Position - root.Position).Magnitude < 65 then
                    local angle = tick() * 4
                    local targetPos = root.Position + Vector3.new(math.cos(angle) * 14, 6, math.sin(angle) * 14)
                    p.AssemblyLinearVelocity = (targetPos - p.Position) * 8
                end
            end
        end

        -- [14] Anti-Aim (Spin + Jitter)
        if AntiAimEnabled then
            hum.AutoRotate = false
            local jitterYaw = math.rad((tick() * 720) % 360)
            root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, jitterYaw, 0)
        end

        -- [15] CFrame Desync
        if DesyncEnabled then
            local realCF = root.CFrame
            local offset = Vector3.new(
                math.sin(tick() * 40) * DesyncRange,
                0,
                math.cos(tick() * 40) * DesyncRange
            )
            local fakeCF = realCF + offset
            if DesyncGhost then
                DesyncGhost.CFrame = fakeCF
            end
            root.CFrame = fakeCF
            RunService.RenderStepped:Wait()
            if root and root.Parent then
                root.CFrame = realCF
            end
        end

        -- [16] Fake Lag
        if FakeLagEnabled then
            if tick() - LastLagSwitch >= FakeLagInterval then
                LastLagSwitch = tick()
                root.Anchored = not root.Anchored
            end
        end

        -- [17] Hitbox Manipulation
        if HitboxEnabled then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and GetRoot(plr) and GetHum(plr) and GetHum(plr).Health > 0 then
                    local eRoot = GetRoot(plr)
                    eRoot.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                    eRoot.Transparency = 0.68
                    eRoot.Material = Enum.Material.Neon
                    eRoot.Color = Color3.fromRGB(235, 35, 75)
                    eRoot.CanCollide = false
                end
            end
        end

        -- [18] Animation Spoofing
        if NoAnimsSpoof then
            for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
                track:Stop()
            end
        elseif AnimSpeedMult ~= 1 then
            for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
                track:AdjustSpeed(AnimSpeedMult)
            end
        end

        -- [19] State Manipulation: Nadar no Ar
        if SwimAirState then
            hum:ChangeState(Enum.HumanoidStateType.Swimming)
        end

        -- [20] State Manipulation: Anti-Ragdoll / Anti-Stun
        if AntiStunState then
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStand, false)
            hum.PlatformStand = false
            if hum.Sit then hum.Sit = false end
        end

        -- [8] Auto-Trigger Interações do Mundo
        if AutoTriggerWorld and tick() - LastWorldTrigger > 0.3 then
            LastWorldTrigger = tick()
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("ClickDetector") and v.Parent and v.Parent:IsA("BasePart") then
                    if (v.Parent.Position - root.Position).Magnitude < 22 and fireclickdetector then
                        pcall(fireclickdetector, v)
                    end
                elseif v:IsA("ProximityPrompt") and v.Parent and v.Parent:IsA("BasePart") then
                    if (v.Parent.Position - root.Position).Magnitude < 20 and fireproximityprompt then
                        pcall(fireproximityprompt, v)
                    end
                end
            end
        end
    end)
end