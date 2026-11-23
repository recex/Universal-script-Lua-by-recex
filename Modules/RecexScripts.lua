--[[
    RECEX HUB - MODULE: 40 EXCLUSIVE OP SCRIPTS (made by recex)
    100% Original & Functional Scripts crafted for Recex Hub
]]

return function(Hub, Tabs)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local Lighting = game:GetService("Lighting")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    local Mouse = LocalPlayer:GetMouse()

    local RecexTab = Tabs.Recex

    local EffectFolder = Camera:FindFirstChild("RecexOPFolder") or Instance.new("Folder")
    EffectFolder.Name = "RecexOPFolder"
    EffectFolder.Parent = Camera

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
                local r = plr.Character:FindFirstChild("HumanoidRootPart")
                local h = plr.Character:FindFirstChildOfClass("Humanoid")
                if r and h and h.Health > 0 then
                    local d = (r.Position - myRoot.Position).Magnitude
                    if d < minDist then
                        minDist = d
                        closest = plr
                    end
                end
            end
        end
        return closest, minDist
    end

    local function SpawnShockwave(pos, color, maxSize)
        local ring = Instance.new("Part")
        ring.Shape = Enum.PartType.Cylinder
        ring.Material = Enum.Material.Neon
        ring.Color = color or Color3.fromRGB(245, 195, 70)
        ring.Anchored = true
        ring.CanCollide = false
        ring.CastShadow = false
        ring.Size = Vector3.new(0.2, 2, 2)
        ring.CFrame = CFrame.new(pos) * CFrame.Angles(0, 0, math.rad(90))
        ring.Parent = EffectFolder
        TweenService:Create(ring, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = Vector3.new(0.05, maxSize or 18, maxSize or 18),
            Transparency = 1
        }):Play()
        task.delay(0.5, function()
            if ring and ring.Parent then ring:Destroy() end
        end)
    end

    -- =========================================================================
    -- CATEGORIA 1: ESPAÇO-TEMPO & MOVIMENTO OP (SCRIPTS #1 AO #10)
    -- =========================================================================
    RecexTab:AddSection("Espaço-Tempo & Movimento OP (1-10)")

    -- [1] Recex Blink Tool
    RecexTab:AddButton("1. Recex Blink (Tool de Teleporte)", "Gera o item exclusivo de teleporte com efeito 3D", function()
        local Backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
        if not Backpack then return end
        local Tool = Instance.new("Tool")
        Tool.Name = "Recex Blink"
        Tool.RequiresHandle = false
        Tool.Parent = Backpack
        Tool.Activated:Connect(function()
            local root = GetRoot()
            if root and Mouse.Hit then
                SpawnShockwave(root.Position - Vector3.new(0, 2.5, 0), Color3.fromRGB(165, 95, 255), 14)
                local targetPos = Mouse.Hit.Position + Vector3.new(0, 3.2, 0)
                root.CFrame = CFrame.new(targetPos, targetPos + Camera.CFrame.LookVector)
                SpawnShockwave(targetPos - Vector3.new(0, 2.5, 0), Color3.fromRGB(245, 195, 70), 16)
            end
        end)
        Hub.Notify("Recex #1", "Tool 'Recex Blink' adicionada ao inventário!", 3)
    end)

    -- [2] Recex Time Rewind
    local RewindEnabled, RewindFrames, IsRewinding = false, {}, false
    RecexTab:AddToggle("2. Recex Time Rewind (Tecla C)", "Volta 4 segundos no tempo refazendo seus passos", false, function(state)
        RewindEnabled = state
        RewindFrames = {}
    end)

    -- [3] Recex Sandevistan / Flash Step (Afterimage Clones)
    local SandevistanEnabled = false
    local LastCloneTick = 0
    RecexTab:AddToggle("3. Recex Sandevistan (Pós-Imagem OP)", "Super velocidade deixando clones holográficos", false, function(state)
        SandevistanEnabled = state
        if state then
            local cc = Lighting:FindFirstChild("RecexSandeCC") or Instance.new("ColorCorrectionEffect")
            cc.Name = "RecexSandeCC"
            cc.TintColor = Color3.fromRGB(190, 255, 220)
            cc.Saturation = 0.3
            cc.Parent = Lighting
            Hub.Notify("Recex #3", "Sandevistan Ativado! Corra para deixar rastros holográficos.", 3)
        else
            local cc = Lighting:FindFirstChild("RecexSandeCC")
            if cc then cc:Destroy() end
        end
    end)

    -- [4] Recex Personal Black Hole (FE Unanchored Vortex)
    local BlackHoleEnabled = false
    RecexTab:AddToggle("4. Recex Buraco Negro Pessoal (FE)", "Faz todas as peças soltas do mapa orbitarem você", false, function(state)
        BlackHoleEnabled = state
    end)

    -- [5] Recex Telekinesis Tool
    RecexTab:AddButton("5. Recex Telecinese (Controlar Objetos)", "Gera uma Tool que levanta e arremessa objetos soltos", function()
        local Backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
        if not Backpack then return end
        local Tool = Instance.new("Tool")
        Tool.Name = "Recex Telekinesis"
        Tool.RequiresHandle = false
        Tool.Parent = Backpack

        local HeldPart = nil
        local Dist = 25
        Tool.Activated:Connect(function()
            if HeldPart then
                HeldPart.AssemblyLinearVelocity = Camera.CFrame.LookVector * 280
                HeldPart = nil
                Hub.Notify("Telecinese", "Objeto arremessado em alta velocidade!", 2)
            else
                local target = Mouse.Target
                if target and not target.Anchored and not target:IsDescendantOf(LocalPlayer.Character) then
                    HeldPart = target
                    SpawnShockwave(target.Position, Color3.fromRGB(165, 95, 255), 10)
                    Hub.Notify("Telecinese", "Objeto capturado! Clique novamente para disparar.", 2)
                end
            end
        end)
        RunService.RenderStepped:Connect(function()
            if HeldPart and HeldPart.Parent and Tool.Parent == LocalPlayer.Character then
                local goalPos = Camera.CFrame.Position + Camera.CFrame.LookVector * Dist
                HeldPart.AssemblyLinearVelocity = (goalPos - HeldPart.Position) * 12
            else
                HeldPart = nil
            end
        end)
        Hub.Notify("Recex #5", "Tool 'Recex Telekinesis' criada no inventário!", 3)
    end)

    -- [6] Recex Portal Gun (Portais A & B)
    local PortalA, PortalB, LastPortalTP = nil, nil, 0
    RecexTab:AddButton("6. Recex Portal A & B (Criar no Chão)", "Clique 1x para Portal Ouro, 2x para Portal Violeta", function()
        local root = GetRoot()
        if not root then return end
        if not PortalA then
            PortalA = Instance.new("Part")
            PortalA.Size = Vector3.new(1, 7, 5)
            PortalA.Shape = Enum.PartType.Cylinder
            PortalA.Material = Enum.Material.Neon
            PortalA.Color = Color3.fromRGB(245, 195, 70)
            PortalA.Anchored = true
            PortalA.CanCollide = false
            PortalA.CFrame = root.CFrame * CFrame.new(0, 0, -6) * CFrame.Angles(0, math.rad(90), 0)
            PortalA.Parent = EffectFolder
            Hub.Notify("Portal A Criado", "Clique novamente em outro lugar para criar o Portal B!", 3)
        elseif not PortalB then
            PortalB = PortalA:Clone()
            PortalB.Color = Color3.fromRGB(165, 95, 255)
            PortalB.CFrame = root.CFrame * CFrame.new(0, 0, -6) * CFrame.Angles(0, math.rad(90), 0)
            PortalB.Parent = EffectFolder
            Hub.Notify("Portal B Criado", "Portais conectados! Entre neles para teleportar.", 3)
        else
            PortalA:Destroy()
            PortalB:Destroy()
            PortalA, PortalB = nil, nil
            Hub.Notify("Portais Removidos", "Clique novamente para posicionar novos portais.", 3)
        end
    end)

    -- [7] Recex Spider-Man Wall Walk
    local WallWalkEnabled = false
    RecexTab:AddToggle("7. Recex Wall Walk (Andar nas Paredes)", "Permite escalar qualquer parede vertical correndo nela", false, function(state)
        WallWalkEnabled = state
    end)

    -- [8] Recex Astral Dash (Tecla Q)
    local DashEnabled = false
    RecexTab:AddToggle("8. Recex Dash Astral (Tecla Q)", "Impulso supersônico na direção em que você anda", false, function(state)
        DashEnabled = state
    end)

    -- [9] Recex Seismic Air Slam
    local SeismicSlamEnabled = false
    RecexTab:AddToggle("9. Recex Pisada Sísmica no Ar", "Pular no ar cria ondas de choque douradas nos pés", false, function(state)
        SeismicSlamEnabled = state
    end)

    -- [10] Recex Auto BunnyHop
    local BhopEnabled = false
    RecexTab:AddToggle("10. Recex BunnyHop Automático", "Pula automaticamente mantendo impulso de velocidade", false, function(state)
        BhopEnabled = state
    end)

    -- =========================================================================
    -- CATEGORIA 2: COMBATE OP & DOMINAÇÃO (SCRIPTS #11 AO #20)
    -- =========================================================================
    RecexTab:AddSection("Combate OP & Dominação (11-20)")

    -- [11] Recex Semi-God Mode / Auto-HealState
    local GodModeEnabled = false
    RecexTab:AddToggle("11. Recex Semi-God Mode & Auto-Recover", "Bloqueia estados de morte/queda e regenera estado", false, function(state)
        GodModeEnabled = state
    end)

    -- [12] Recex Kill Aura 360° (Tool Reach)
    local KillAuraEnabled = false
    RecexTab:AddToggle("12. Recex Kill Aura 360° (Auto-Attack)", "Ativa sua espada/arma e acerta inimigos num raio de 20m", false, function(state)
        KillAuraEnabled = state
    end)

    -- [13] Recex Ultra Instinct (Auto-Dodge Behind Enemy)
    local UltraInstinctEnabled = false
    RecexTab:AddToggle("13. Recex Instinto Superior (Auto-Dodge)", "Se alguém chegar a <11m, teleporta atrás dele na hora", false, function(state)
        UltraInstinctEnabled = state
    end)

    -- [14] Recex Orbit Strike
    local OrbitStrikeEnabled = false
    RecexTab:AddToggle("14. Recex Orbit Strike (Giro Letal)", "Gira em velocidade extrema ao redor do inimigo mais próximo", false, function(state)
        OrbitStrikeEnabled = state
    end)

    -- [15] Recex Head Sit
    local HeadSitEnabled = false
    RecexTab:AddToggle("15. Recex Head Sit (Sentar na Cabeça)", "Trava seu personagem sentado na cabeça do alvo", false, function(state)
        HeadSitEnabled = state
        if not state and GetHum() then GetHum().Sit = false end
    end)

    -- [16] Recex Back Attach FE
    local BackAttachEnabled = false
    RecexTab:AddToggle("16. Recex Back Attach (Colar nas Costas)", "Fica invisivelmente preso atrás do jogador mais próximo", false, function(state)
        BackAttachEnabled = state
    end)

    -- [17] Recex Bring Unanchored Parts to Enemy
    RecexTab:AddButton("17. Recex Chuva de Objetos no Inimigo", "Joga todas as peças soltas do mapa em cima do alvo", function()
        local enemy = GetClosestEnemy()
        if enemy and GetRoot(enemy) then
            local ePos = GetRoot(enemy).Position
            local count = 0
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and not v.Anchored and not v:IsDescendantOf(LocalPlayer.Character) and not v:IsDescendantOf(enemy.Character) then
                    v.CFrame = CFrame.new(ePos + Vector3.new(0, math.random(2, 10), 0))
                    v.AssemblyLinearVelocity = Vector3.new(0, -150, 0)
                    count += 1
                    if count > 60 then break end
                end
            end
            Hub.Notify("Recex #17", count .. " objetos lançados sobre " .. enemy.DisplayName, 3)
        end
    end)

    -- [18] Recex Freeze Aura
    local FreezeAuraEnabled = false
    RecexTab:AddToggle("18. Recex Freeze Aura (Congelar Inimigos)", "Trava os inimigos próximos no lugar para facilitar hits", false, function(state)
        FreezeAuraEnabled = state
        if not state then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and GetRoot(plr) then
                    GetRoot(plr).Anchored = false
                end
            end
        end
    end)

    -- [19] Recex Projectile Deflector
    local DeflectorEnabled = false
    RecexTab:AddToggle("19. Recex Campo Anti-Projétil", "Repele objetos soltos arremessados contra você", false, function(state)
        DeflectorEnabled = state
    end)

    -- [20] Recex Assassin Teleport
    RecexTab:AddButton("20. Recex Assassin Strike (TP Costas)", "Teleporta instantaneamente atrás do inimigo mais próximo", function()
        local enemy = GetClosestEnemy()
        local myRoot = GetRoot()
        if enemy and GetRoot(enemy) and myRoot then
            SpawnShockwave(myRoot.Position, Color3.fromRGB(165, 95, 255), 12)
            myRoot.CFrame = GetRoot(enemy).CFrame * CFrame.new(0, 0, 3.8)
            SpawnShockwave(myRoot.Position, Color3.fromRGB(245, 195, 70), 12)
            Hub.Notify("Assassin Strike", "Alvo: " .. enemy.DisplayName, 2)
        end
    end)

    -- =========================================================================
    -- CATEGORIA 3: DEFESA SUPREMA & ANTI-TROLL (SCRIPTS #21 AO #30)
    -- =========================================================================
    RecexTab:AddSection("Defesa Suprema & Anti-Troll (21-30)")

    -- [21] Recex Ghost Desync (Anti-Hit)
    local DesyncEnabled = false
    RecexTab:AddToggle("21. Recex Ghost Desync (Anti-Mira)", "Oscila sua hitbox em alta frequência para errarem tiros", false, function(state)
        DesyncEnabled = state
    end)

    -- [22] Recex Anti-Ragdoll & Anti-Grab
    local AntiRagdollEnabled = false
    RecexTab:AddToggle("22. Recex Anti-Ragdoll & Anti-Grab", "Impede que você caia no chão ou seja agarrado", false, function(state)
        AntiRagdollEnabled = state
    end)

    -- [23] Recex Sky Sanctuary VIP (Safe Zone)
    local SavedGroundCFrame = nil
    RecexTab:AddToggle("23. Recex Safe Zone VIP no Céu", "Teleporta para uma base blindada a 5000m e volta ao desligar", false, function(state)
        local root = GetRoot()
        if not root then return end
        if state then
            SavedGroundCFrame = root.CFrame
            local pad = EffectFolder:FindFirstChild("RecexSafePad") or Instance.new("Part")
            pad.Name = "RecexSafePad"
            pad.Size = Vector3.new(60, 2, 60)
            pad.Position = Vector3.new(0, 5000, 0)
            pad.Anchored = true
            pad.Material = Enum.Material.Glass
            pad.Color = Color3.fromRGB(20, 22, 30)
            pad.Parent = EffectFolder
            root.CFrame = CFrame.new(0, 5005, 0)
            Hub.Notify("Safe Zone VIP", "Você está seguro no céu! Desligue para voltar.", 3)
        else
            if SavedGroundCFrame then
                root.CFrame = SavedGroundCFrame
            end
        end
    end)

    -- [24] Recex Auto-Escape Low HP
    local AutoEscapeEnabled = false
    RecexTab:AddToggle("24. Recex Auto-Fuga (<25% Vida)", "Salva sua vida teleportando pro alto se o HP baixar de 25%", false, function(state)
        AutoEscapeEnabled = state
    end)

    -- [25] Recex Anti-Seat
    RecexTab:AddButton("25. Recex Anti-Seat (Desativar Cadeiras)", "Impede que você sente acidentalmente em cadeiras no mapa", function()
        local count = 0
        for _, s in ipairs(workspace:GetDescendants()) do
            if s:IsA("Seat") or s:IsA("VehicleSeat") then
                s.Disabled = true
                count += 1
            end
        end
        Hub.Notify("Recex #25", count .. " assentos desativados no mapa!", 3)
    end)

    -- [26] Recex Delete KillBricks
    RecexTab:AddButton("26. Recex Neutralizar Lava / KillBricks", "Desativa o toque de peças de dano/lava pelo mapa", function()
        local count = 0
        for _, p in ipairs(workspace:GetDescendants()) do
            if p:IsA("BasePart") and (p.Name:lower():find("kill") or p.Name:lower():find("lava") or p.Name:lower():find("laser") or p.Name:lower():find("damage")) then
                p.CanTouch = false
                count += 1
            end
        end
        Hub.Notify("Recex #26", count .. " KillBricks neutralizadas com sucesso!", 3)
    end)

    -- [27] Recex Flying Gold Carpet
    local CarpetEnabled = false
    local GoldCarpet = nil
    RecexTab:AddToggle("27. Recex Tapete Voador Astral", "Cria uma prancha neon dourada que flutua sob seus pés", false, function(state)
        CarpetEnabled = state
        if not state and GoldCarpet then
            GoldCarpet:Destroy()
            GoldCarpet = nil
        end
    end)

    -- [28] Recex Fake Death FE
    RecexTab:AddToggle("28. Recex Fingir de Morto (Fake Death)", "Deita seu personagem imóvel como se tivesse morrido", false, function(state)
        local hum = GetHum()
        local root = GetRoot()
        if hum and root then
            if state then
                hum.PlatformStand = true
                root.CFrame = root.CFrame * CFrame.Angles(math.rad(90), 0, 0)
            else
                hum.PlatformStand = false
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
    end)

    -- [29] Recex Ghost Cloak
    RecexTab:AddToggle("29. Recex Manto Fantasma (Semi-Invisível)", "Deixa seu avatar translúcido com brilho etéreo", false, function(state)
        if not LocalPlayer.Character then return end
        for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                p.Transparency = state and 0.65 or 0
            end
        end
    end)

    -- [30] Recex Anti-Lag Particle Cleaner
    RecexTab:AddButton("30. Recex Limpador de Explosões & Lag", "Remove fumaça, fogo e partículas pesadas do servidor", function()
        local count = 0
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                v.Enabled = false
                count += 1
            end
        end
        Hub.Notify("Recex #30", count .. " efeitos pesados desativados!", 3)
    end)

    -- =========================================================================
    -- CATEGORIA 4: VISUAIS 3D EXCLUSIVOS, CLONES & MUNDO (SCRIPTS #31 AO #40)
    -- =========================================================================
    RecexTab:AddSection("Visuais 3D, Clones & Mundo (31-40)")

    -- [31] Recex Astral Aura 3D
    local AuraEnabled, AuraOrbs = false, {}
    RecexTab:AddToggle("31. Recex Astral Aura 3D", "3 esferas de energia com rastros orbitam seu corpo", false, function(state)
        AuraEnabled = state
        for _, o in ipairs(AuraOrbs) do if o and o.Parent then o:Destroy() end end
        AuraOrbs = {}
        if state then
            for i = 1, 3 do
                local orb = Instance.new("Part")
                orb.Shape = Enum.PartType.Ball
                orb.Size = Vector3.new(0.85, 0.85, 0.85)
                orb.Material = Enum.Material.Neon
                orb.Color = (i % 2 == 0) and Color3.fromRGB(165, 95, 255) or Color3.fromRGB(245, 195, 70)
                orb.Anchored = true
                orb.CanCollide = false
                orb.Parent = EffectFolder
                table.insert(AuraOrbs, orb)
            end
        end
    end)

    -- [32] Recex Susanoo / Giant Hologram Guardian
    local SusanooEnabled, SusanooModel = false, nil
    RecexTab:AddToggle("32. Recex Susanoo (Guardião Gigante 3D)", "Invoca um avatar colossal de energia violeta ao seu redor", false, function(state)
        SusanooEnabled = state
        if SusanooModel then SusanooModel:Destroy() SusanooModel = nil end
        if state then
            SusanooModel = Instance.new("Model")
            SusanooModel.Name = "RecexSusanoo"
            SusanooModel.Parent = EffectFolder

            local torso = Instance.new("Part")
            torso.Name = "Torso"
            torso.Size = Vector3.new(10, 14, 6)
            torso.Material = Enum.Material.ForceField
            torso.Color = Color3.fromRGB(150, 75, 255)
            torso.Anchored = true
            torso.CanCollide = false
            torso.Parent = SusanooModel

            local head = Instance.new("Part")
            head.Name = "Head"
            head.Shape = Enum.PartType.Ball
            head.Size = Vector3.new(6, 6, 6)
            head.Material = Enum.Material.Neon
            head.Color = Color3.fromRGB(245, 195, 70)
            head.Transparency = 0.35
            head.Anchored = true
            head.CanCollide = false
            head.Parent = SusanooModel
        end
    end)

    -- [33] Recex Shadow Clones (Kage Bunshin)
    local ClonesEnabled, ActiveClones = false, {}
    RecexTab:AddToggle("33. Recex Kage Bunshin (4 Clones 3D)", "Cria 4 clones seus que escoltam você em formação", false, function(state)
        ClonesEnabled = state
        for _, c in ipairs(ActiveClones) do if c and c.Parent then c:Destroy() end end
        ActiveClones = {}
        if state and LocalPlayer.Character then
            LocalPlayer.Character.Archivable = true
            for i = 1, 4 do
                local clone = LocalPlayer.Character:Clone()
                for _, v in ipairs(clone:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                        v.Anchored = true
                    elseif v:IsA("Script") or v:IsA("LocalScript") then
                        v:Destroy()
                    end
                end
                clone.Parent = EffectFolder
                table.insert(ActiveClones, clone)
            end
        end
    end)

    -- [34] Recex Sovereign Crown 3D
    local CrownEnabled, CrownPart = false, nil
    RecexTab:AddToggle("34. Recex Coroa Real 3D Flutuante", "Modela uma coroa dourada giratória acima da sua cabeça", false, function(state)
        CrownEnabled = state
        if CrownPart then CrownPart:Destroy() CrownPart = nil end
        if state then
            CrownPart = Instance.new("Part")
            CrownPart.Shape = Enum.PartType.Cylinder
            CrownPart.Size = Vector3.new(0.4, 2.6, 2.6)
            CrownPart.Material = Enum.Material.Neon
            CrownPart.Color = Color3.fromRGB(245, 195, 70)
            CrownPart.Anchored = true
            CrownPart.CanCollide = false
            CrownPart.Parent = EffectFolder
        end
    end)

    -- [35] Recex Golden Footsteps
    local FootstepsEnabled, LastStepPos = false, Vector3.zero
    RecexTab:AddToggle("35. Recex Pegadas de Fogo Dourado", "Deixa anéis luminosos no chão por onde você caminha", false, function(state)
        FootstepsEnabled = state
    end)

    -- [36] Recex Domain Expansion 3D
    local DomainDome = nil
    RecexTab:AddToggle("36. Recex Expansão de Domínio 3D", "Fecha a área ao seu redor em uma cúpula astral gigantesca", false, function(state)
        if DomainDome then DomainDome:Destroy() DomainDome = nil end
        if state and GetRoot() then
            DomainDome = Instance.new("Part")
            DomainDome.Shape = Enum.PartType.Ball
            DomainDome.Size = Vector3.new(10, 10, 10)
            DomainDome.Position = GetRoot().Position
            DomainDome.Material = Enum.Material.ForceField
            DomainDome.Color = Color3.fromRGB(130, 60, 240)
            DomainDome.Anchored = true
            DomainDome.CanCollide = false
            DomainDome.Parent = EffectFolder
            TweenService:Create(DomainDome, TweenInfo.new(1.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                Size = Vector3.new(160, 160, 160)
            }):Play()
            Hub.Notify("Expansão de Domínio", "Santuário Astral Recex invocado!", 3)
        end
    end)

    -- [37] Recex 3D Radar Sonar
    local SonarEnabled, LastSonar = false, 0
    RecexTab:AddToggle("37. Recex Radar Sonar 3D", "Dispara um pulso de escaneamento 3D a cada 3 segundos", false, function(state)
        SonarEnabled = state
    end)

    -- [38] Recex Za Warudo (Time Stop Visual + Freeze)
    RecexTab:AddToggle("38. Recex Za Warudo (Parar o Tempo)", "Inverte as cores do mundo e congela os jogadores na tela", false, function(state)
        if state then
            local cc = Lighting:FindFirstChild("RecexTimeStop") or Instance.new("ColorCorrectionEffect")
            cc.Name = "RecexTimeStop"
            cc.Contrast = -1.5
            cc.Saturation = -1
            cc.Parent = Lighting
            if GetRoot() then SpawnShockwave(GetRoot().Position, Color3.fromRGB(245, 195, 70), 120) end
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and GetRoot(plr) then
                    GetRoot(plr).Anchored = true
                end
            end
            Hub.Notify("ZA WARUDO!", "O tempo parou no Recex Hub!", 3)
        else
            local cc = Lighting:FindFirstChild("RecexTimeStop")
            if cc then cc:Destroy() end
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and GetRoot(plr) then
                    GetRoot(plr).Anchored = false
                end
            end
        end
    end)

    -- [39] Recex Magnet Loot (Collect Dropped Tools)
    RecexTab:AddButton("39. Recex Ímã de Itens / Tools do Mapa", "Puxa instantaneamente todos os itens largados no chão", function()
        local root = GetRoot()
        if not root then return end
        local count = 0
        for _, item in ipairs(workspace:GetChildren()) do
            if item:IsA("Tool") and item:FindFirstChild("Handle") then
                item.Handle.CFrame = root.CFrame
                count += 1
            end
        end
        Hub.Notify("Recex #39", count .. " itens puxados para o seu inventário!", 3)
    end)

    -- [40] Recex Astral Meteor Shower 3D
    RecexTab:AddButton("40. Recex Chuva de Meteoros 3D (Nuke)", "Invoca uma barragem cinematográfica de meteoros dourados", function()
        local root = GetRoot()
        if not root then return end
        local center = root.Position
        Hub.Notify("Recex #40", "Chuva de Meteoros Astrais iniciada!", 3)
        task.spawn(function()
            for i = 1, 12 do
                local targetPos = center + Vector3.new(math.random(-45, 45), 0, math.random(-45, 45))
                local meteor = Instance.new("Part")
                meteor.Shape = Enum.PartType.Ball
                meteor.Size = Vector3.new(6, 6, 6)
                meteor.Material = Enum.Material.Neon
                meteor.Color = (i % 2 == 0) and Color3.fromRGB(245, 195, 70) or Color3.fromRGB(165, 95, 255)
                meteor.Anchored = true
                meteor.CanCollide = false
                meteor.Position = targetPos + Vector3.new(25, 90, 25)
                meteor.Parent = EffectFolder

                local tween = TweenService:Create(meteor, TweenInfo.new(0.45, Enum.EasingStyle.Linear), {Position = targetPos})
                tween:Play()
                tween.Completed:Connect(function()
                    SpawnShockwave(targetPos, meteor.Color, 26)
                    meteor:Destroy()
                end)
                task.wait(0.15)
            end
        end)
    end)

    -- =========================================================================
    -- LOOP MESTRE DOS 40 SCRIPTS RECEX (ALTA PERFORMANCE)
    -- =========================================================================
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        -- Tecla C: Time Rewind (#2)
        if input.KeyCode == Enum.KeyCode.C and RewindEnabled and not IsRewinding and #RewindFrames > 5 then
            IsRewinding = true
            local root = GetRoot()
            if root then
                root.Anchored = true
                for i = #RewindFrames, 1, -2 do
                    if not RewindEnabled then break end
                    root.CFrame = RewindFrames[i]
                    RunService.RenderStepped:Wait()
                end
                root.Anchored = false
                RewindFrames = {}
            end
            IsRewinding = false
        end
        -- Tecla Q: Dash Astral (#8)
        if input.KeyCode == Enum.KeyCode.Q and DashEnabled then
            local root = GetRoot()
            local hum = GetHum()
            if root and hum then
                local dir = hum.MoveDirection.Magnitude > 0 and hum.MoveDirection or Camera.CFrame.LookVector
                SpawnShockwave(root.Position, Color3.fromRGB(245, 195, 70), 14)
                root.CFrame = root.CFrame + (dir * 22)
            end
        end
        -- Space: Pisada Sísmica (#9)
        if input.KeyCode == Enum.KeyCode.Space and SeismicSlamEnabled and GetRoot() then
            SpawnShockwave(GetRoot().Position - Vector3.new(0, 2.5, 0), Color3.fromRGB(245, 195, 70), 15)
        end
    end)

    local AngleTick = 0
    RunService.RenderStepped:Connect(function(dt)
        AngleTick += dt * 3.5
        local root = GetRoot()
        local hum = GetHum()
        if not root or not hum then return end

        -- [#2] Gravar Time Rewind
        if RewindEnabled and not IsRewinding then
            table.insert(RewindFrames, root.CFrame)
            if #RewindFrames > 240 then table.remove(RewindFrames, 1) end
        end

        -- [#3] Sandevistan Pós-Imagem
        if SandevistanEnabled and hum.MoveDirection.Magnitude > 0 and tick() - LastCloneTick > 0.14 then
            LastCloneTick = tick()
            local ghost = Instance.new("Part")
            ghost.Size = Vector3.new(2, 5, 1)
            ghost.CFrame = root.CFrame
            ghost.Anchored = true
            ghost.CanCollide = false
            ghost.Material = Enum.Material.Neon
            ghost.Color = Color3.fromRGB(80, 255, 190)
            ghost.Transparency = 0.45
            ghost.Parent = EffectFolder
            TweenService:Create(ghost, TweenInfo.new(0.45), {Transparency = 1}):Play()
            task.delay(0.45, function()
                if ghost and ghost.Parent then ghost:Destroy() end
            end)
        end

        -- [#4] Buraco Negro Pessoal
        if BlackHoleEnabled then
            for _, p in ipairs(workspace:GetChildren()) do
                if p:IsA("BasePart") and not p.Anchored and (p.Position - root.Position).Magnitude < 60 then
                    local orbitPos = root.Position + Vector3.new(math.cos(AngleTick) * 14, 5, math.sin(AngleTick) * 14)
                    p.AssemblyLinearVelocity = (orbitPos - p.Position) * 6
                end
            end
        end

        -- [#6] Portais A & B
        if PortalA and PortalB and tick() - LastPortalTP > 1.2 then
            if (root.Position - PortalA.Position).Magnitude < 4.5 then
                LastPortalTP = tick()
                root.CFrame = PortalB.CFrame * CFrame.new(0, 0, -4)
            elseif (root.Position - PortalB.Position).Magnitude < 4.5 then
                LastPortalTP = tick()
                root.CFrame = PortalA.CFrame * CFrame.new(0, 0, -4)
            end
        end

        -- [#7] Spider-Man Wall Walk
        if WallWalkEnabled and hum.MoveDirection.Magnitude > 0 then
            local ray = workspace:Raycast(root.Position, root.CFrame.LookVector * 3.5)
            if ray then
                root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 34, root.AssemblyLinearVelocity.Z)
            end
        end

        -- [#10] Auto BunnyHop
        if BhopEnabled and hum.MoveDirection.Magnitude > 0 and hum.FloorMaterial ~= Enum.Material.Air then
            hum.Jump = true
        end

        -- [#11] Semi-God Mode
        if GodModeEnabled then
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            if hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
        end

        -- [#12] Kill Aura 360
        if KillAuraEnabled then
            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                tool:Activate()
                local handle = tool:FindFirstChild("Handle")
                local enemy, dist = GetClosestEnemy()
                if handle and enemy and dist < 20 and GetRoot(enemy) and firetouchinterest then
                    firetouchinterest(handle, GetRoot(enemy), 0)
                    firetouchinterest(handle, GetRoot(enemy), 1)
                end
            end
        end

        -- [#13] Ultra Instinct Auto-Dodge
        if UltraInstinctEnabled then
            local enemy, dist = GetClosestEnemy()
            if enemy and dist < 11 and GetRoot(enemy) then
                SpawnShockwave(root.Position, Color3.fromRGB(165, 95, 255), 10)
                root.CFrame = GetRoot(enemy).CFrame * CFrame.new(0, 0, 4.5)
            end
        end

        -- [#14] Orbit Strike
        if OrbitStrikeEnabled then
            local enemy = GetClosestEnemy()
            if enemy and GetRoot(enemy) then
                local ePos = GetRoot(enemy).Position
                local offset = Vector3.new(math.cos(AngleTick * 3.5) * 7, 1, math.sin(AngleTick * 3.5) * 7)
                root.CFrame = CFrame.new(ePos + offset, ePos)
            end
        end

        -- [#15] Head Sit
        if HeadSitEnabled then
            local enemy = GetClosestEnemy()
            if enemy and enemy.Character and enemy.Character:FindFirstChild("Head") then
                hum.Sit = true
                root.CFrame = enemy.Character.Head.CFrame * CFrame.new(0, 2.2, 0)
            end
        end

        -- [#16] Back Attach
        if BackAttachEnabled then
            local enemy = GetClosestEnemy()
            if enemy and GetRoot(enemy) then
                root.CFrame = GetRoot(enemy).CFrame * CFrame.new(0, 0, 3.2)
            end
        end

        -- [#18] Freeze Aura
        if FreezeAuraEnabled then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and GetRoot(plr) then
                    local d = (GetRoot(plr).Position - root.Position).Magnitude
                    GetRoot(plr).Anchored = (d < 22)
                end
            end
        end

        -- [#19] Projectile Deflector
        if DeflectorEnabled then
            for _, p in ipairs(workspace:GetChildren()) do
                if p:IsA("BasePart") and not p.Anchored and (p.Position - root.Position).Magnitude < 15 then
                    p.AssemblyLinearVelocity = (p.Position - root.Position).Unit * 140
                end
            end
        end

        -- [#21] Ghost Desync
        if DesyncEnabled then
            local oldCF = root.CFrame
            root.CFrame = oldCF * CFrame.new(math.sin(tick() * 45) * 3.5, 0, math.cos(tick() * 45) * 3.5)
            RunService.RenderStepped:Wait()
            if root and root.Parent then root.CFrame = oldCF end
        end

        -- [#22] Anti-Ragdoll
        if AntiRagdollEnabled then
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum.PlatformStand = false
        end

        -- [#24] Auto-Escape Low HP
        if AutoEscapeEnabled and hum.Health > 0 and (hum.Health / hum.MaxHealth) < 0.25 then
            root.CFrame = root.CFrame + Vector3.new(0, 120, 0)
            Hub.Notify("Auto-Fuga Recex!", "Vida baixa detectada! Você foi salvo.", 3)
        end

        -- [#27] Tapete Voador Astral
        if CarpetEnabled then
            if not GoldCarpet then
                GoldCarpet = Instance.new("Part")
                GoldCarpet.Size = Vector3.new(6, 0.4, 8)
                GoldCarpet.Material = Enum.Material.Neon
                GoldCarpet.Color = Color3.fromRGB(245, 195, 70)
                GoldCarpet.Anchored = true
                GoldCarpet.Parent = EffectFolder
            end
            GoldCarpet.CFrame = CFrame.new(root.Position - Vector3.new(0, 3.2, 0))
        end

        -- [#31] Astral Aura 3D
        if AuraEnabled and #AuraOrbs > 0 then
            for i, orb in ipairs(AuraOrbs) do
                local a = AngleTick + (i * (math.pi * 2 / #AuraOrbs))
                orb.Position = root.Position + Vector3.new(math.cos(a) * 4.5, math.sin(AngleTick * 2 + i) * 1.6, math.sin(a) * 4.5)
            end
        end

        -- [#32] Susanoo Gigante 3D
        if SusanooEnabled and SusanooModel then
            local t = SusanooModel:FindFirstChild("Torso")
            local h = SusanooModel:FindFirstChild("Head")
            if t and h then
                t.CFrame = root.CFrame * CFrame.new(0, 4, 2)
                h.CFrame = root.CFrame * CFrame.new(0, 14, 2)
            end
        end

        -- [#33] Kage Bunshin (4 Clones)
        if ClonesEnabled and #ActiveClones > 0 then
            local offsets = {
                CFrame.new(-4.5, 0, 2.5),
                CFrame.new(4.5, 0, 2.5),
                CFrame.new(-8, 0, 5),
                CFrame.new(8, 0, 5)
            }
            for i, clone in ipairs(ActiveClones) do
                if clone and clone:FindFirstChild("HumanoidRootPart") then
                    clone:PivotTo(root.CFrame * offsets[i])
                end
            end
        end

        -- [#34] Coroa Real 3D
        if CrownEnabled and CrownPart then
            CrownPart.CFrame = CFrame.new(root.Position + Vector3.new(0, 3.6 + math.sin(AngleTick) * 0.25, 0))
                * CFrame.Angles(0, AngleTick, math.rad(90))
        end

        -- [#35] Pegadas de Fogo Dourado
        if FootstepsEnabled and (root.Position - LastStepPos).Magnitude > 4.5 and hum.FloorMaterial ~= Enum.Material.Air then
            LastStepPos = root.Position
            SpawnShockwave(root.Position - Vector3.new(0, 2.8, 0), Color3.fromRGB(245, 195, 70), 5)
        end

        -- [#37] Radar Sonar 3D
        if SonarEnabled and tick() - LastSonar > 3 then
            LastSonar = tick()
            SpawnShockwave(root.Position - Vector3.new(0, 2, 0), Color3.fromRGB(30, 215, 96), 85)
        end
    end)
end