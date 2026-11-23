--[[
    RECEX SOVEREIGN VIP - MODULE: ULTIMATE POWERS & CATACLYSM ENGINE
    made by recex (PAID VIP EDITION)
]]

return function(Hub, Tabs, vipData)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    local Lighting = game:GetService("Lighting")
    local SoundService = game:GetService("SoundService")

    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    local Mouse = LocalPlayer:GetMouse()

    local VIPTab = Hub:CreateTab("👑 Sovereign VIP")

    local FXFolder = Camera:FindFirstChild("RecexVIPCataclysm3D") or Instance.new("Folder")
    FXFolder.Name = "RecexVIPCataclysm3D"
    FXFolder.Parent = Camera

    local COL_CRIMSON = Color3.fromRGB(235, 35, 75)
    local COL_GOLD    = Color3.fromRGB(255, 200, 65)
    local COL_VOID    = Color3.fromRGB(145, 55, 255)

    -- =========================================================================
    -- FUNÇÕES UTILITÁRIAS DE FÍSICA, SOM E EFEITOS 3D
    -- =========================================================================
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

    local function PlaySFX(id, vol, speed)
        local s = Instance.new("Sound")
        s.SoundId = id
        s.Volume = vol or 0.6
        s.PlaybackSpeed = speed or 1
        s.Parent = SoundService
        s:Play()
        task.delay(4, function()
            if s and s.Parent then s:Destroy() end
        end)
    end

    local function ShakeCamera(intensity, duration)
        task.spawn(function()
            local start = tick()
            while tick() - start < duration do
                local offset = Vector3.new(
                    (math.random() - 0.5) * intensity,
                    (math.random() - 0.5) * intensity,
                    (math.random() - 0.5) * intensity
                )
                Camera.CFrame = Camera.CFrame * CFrame.new(offset)
                RunService.RenderStepped:Wait()
            end
        end)
    end

    local function Create3DWave(pos, color, maxRadius, duration, height)
        local ring = Instance.new("Part")
        ring.Shape = Enum.PartType.Cylinder
        ring.Material = Enum.Material.Neon
        ring.Color = color or COL_CRIMSON
        ring.Anchored = true
        ring.CanCollide = false
        ring.CastShadow = false
        ring.Size = Vector3.new(height or 0.4, 2, 2)
        ring.CFrame = CFrame.new(pos) * CFrame.Angles(0, 0, math.rad(90))
        ring.Parent = FXFolder

        TweenService:Create(ring, TweenInfo.new(duration or 0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = Vector3.new(0.1, maxRadius, maxRadius),
            Transparency = 1
        }):Play()

        task.delay(duration or 0.6, function()
            if ring and ring.Parent then ring:Destroy() end
        end)
    end

    local function CreateEnergySphere(pos, color, startSize, endSize, duration)
        local ball = Instance.new("Part")
        ball.Shape = Enum.PartType.Ball
        ball.Material = Enum.Material.Neon
        ball.Color = color
        ball.Anchored = true
        ball.CanCollide = false
        ball.CastShadow = false
        ball.Size = Vector3.new(startSize, startSize, startSize)
        ball.Position = pos
        ball.Parent = FXFolder

        TweenService:Create(ball, TweenInfo.new(duration, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
            Size = Vector3.new(endSize, endSize, endSize),
            Transparency = 1
        }):Play()

        task.delay(duration, function()
            if ball and ball.Parent then ball:Destroy() end
        end)
    end

    -- =========================================================================
    -- SEÇÃO 1: ATRIBUTOS SUPREMOS (ZERO COOLDOWN, OVERDRIVE & TITAN MODE)
    -- =========================================================================
    VIPTab:AddSection("Atributos Supremos & Transformações")

    -- 1. Zero Cooldown
    local ZeroCDActive = false
    VIPTab:AddToggle("1. Zero Cooldown (Sem Intervalo de Skills)", "Remove travas de tempo das Tools e ativa habilidades sem pausa", false, function(state)
        ZeroCDActive = state
        if state then
            Hub.Notify("👑 Zero Cooldown", "Intervalos de habilidades e Tools removidos!", 3)
        end
    end)

    -- 2. Overdrive Mode
    local OverdriveActive = false
    local OverdriveHighlight = nil
    VIPTab:AddToggle("2. Overdrive (Modo Sobrecarga de Combate)", "Aumenta velocidade, pulo, ataque, FOV e ativa aura Carmesim", false, function(state)
        OverdriveActive = state
        local hum = GetHum()
        if state then
            PlaySFX("rbxassetid://9114221580", 0.7, 1.1)
            Camera.FieldOfView = 92
            if hum then
                hum.WalkSpeed = 65
                hum.UseJumpPower = true
                hum.JumpPower = 115
            end
            if LocalPlayer.Character then
                OverdriveHighlight = Instance.new("Highlight")
                OverdriveHighlight.FillColor = COL_CRIMSON
                OverdriveHighlight.OutlineColor = COL_GOLD
                OverdriveHighlight.FillTransparency = 0.35
                OverdriveHighlight.Parent = LocalPlayer.Character
            end
            if GetRoot() then
                Create3DWave(GetRoot().Position, COL_CRIMSON, 45, 0.7, 1.5)
            end
            Hub.Notify("👑 OVERDRIVE", "Atributos de combate elevados ao máximo!", 3)
        else
            Camera.FieldOfView = 70
            if hum then
                hum.WalkSpeed = 16
                hum.JumpPower = 50
            end
            if OverdriveHighlight then OverdriveHighlight:Destroy() OverdriveHighlight = nil end
        end
    end)

    -- 3. Titan Mode
    local TitanActive = false
    local TitanParts = {}
    VIPTab:AddToggle("3. Titan Mode (Escala Colossal & Passo Pesado)", "Aumenta a escala do personagem, cria armadura de energia e treme o chão", false, function(state)
        TitanActive = state
        local hum = GetHum()
        local char = LocalPlayer.Character

        for _, p in ipairs(TitanParts) do if p and p.Parent then p:Destroy() end end
        TitanParts = {}

        if hum then
            -- Escala R15 caso o servidor possua NumberValues de escala
            for _, scaleName in ipairs({"BodyDepthScale", "BodyHeightScale", "BodyWidthScale", "HeadScale"}) do
                local valObj = hum:FindFirstChild(scaleName)
                if valObj and valObj:IsA("NumberValue") then
                    valObj.Value = state and 2.6 or 1
                end
            end
            hum.HipHeight = state and 4.5 or 0
        end

        if state and char then
            PlaySFX("rbxassetid://9114221580", 0.8, 0.65)
            for _, limb in ipairs(char:GetChildren()) do
                if limb:IsA("BasePart") and limb.Name ~= "HumanoidRootPart" then
                    local armor = Instance.new("Part")
                    armor.Size = limb.Size * 2.2
                    armor.Material = Enum.Material.ForceField
                    armor.Color = COL_GOLD
                    armor.Anchored = true
                    armor.CanCollide = false
                    armor.Parent = FXFolder
                    table.insert(TitanParts, {Armor = armor, Limb = limb})
                end
            end
            Hub.Notify("👑 TITAN MODE", "Modo Colossal ativado! Cada passo gera abalos sísmicos.", 3)
        end
    end)

    -- 4. Dimension Shift
    local DimensionActive = false
    VIPTab:AddToggle("4. Dimension Shift (Salto Dimensional)", "Entra no plano astral invisível e teleporta instantaneamente ao mirar", false, function(state)
        DimensionActive = state
        local root = GetRoot()
        if state then
            PlaySFX("rbxassetid://9114221580", 0.65, 1.3)
            local cc = Lighting:FindFirstChild("RecexDimShift") or Instance.new("ColorCorrectionEffect", Lighting)
            cc.Name = "RecexDimShift"
            cc.TintColor = Color3.fromRGB(185, 130, 255)
            cc.Contrast = 0.45
            cc.Saturation = -0.5

            if root then
                CreateEnergySphere(root.Position, COL_VOID, 2, 28, 0.5)
                if Mouse.Hit then
                    root.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 4, 0))
                    CreateEnergySphere(root.Position, COL_GOLD, 2, 28, 0.5)
                end
            end
            if LocalPlayer.Character then
                for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                        p.Transparency = 0.75
                    end
                end
            end
            Hub.Notify("👑 Dimension Shift", "Você atravessou para a dimensão astral!", 3)
        else
            local cc = Lighting:FindFirstChild("RecexDimShift")
            if cc then cc:Destroy() end
            if LocalPlayer.Character then
                for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                        p.Transparency = 0
                    end
                end
            end
        end
    end)

    -- =========================================================================
    -- SEÇÃO 2: TÉCNICAS DE COMBATE & FÍSICA VIP (GOLPES ESPECIAIS)
    -- =========================================================================
    VIPTab:AddSection("Técnicas Especiais de Combate VIP")

    -- 5. Ultimate Combo
    VIPTab:AddButton("5. Ultimate Combo (Sequência Cinematográfica)", "Executa um combo aéreo de 6 golpes velozes + impacto final no alvo", function()
        local enemy = GetClosestEnemy()
        local myRoot = GetRoot()
        if not enemy or not GetRoot(enemy) or not myRoot then
            Hub.Notify("Aviso", "Nenhum alvo próximo encontrado para o Ultimate Combo!", 2)
            return
        end

        task.spawn(function()
            local eRoot = GetRoot(enemy)
            Hub.Notify("👑 ULTIMATE COMBO", "Executando sequência em " .. enemy.DisplayName .. "!", 3)
            PlaySFX("rbxassetid://9114221580", 0.75, 1.15)

            -- Fase 1: 6 Cortes em ângulos diferentes ao redor do alvo
            for i = 1, 6 do
                if not eRoot or not eRoot.Parent then break end
                local angle = math.rad(i * 60)
                local offset = Vector3.new(math.cos(angle) * 5, (i % 2 == 0) and 4 or 0, math.sin(angle) * 5)
                myRoot.CFrame = CFrame.lookAt(eRoot.Position + offset, eRoot.Position)
                Create3DWave(eRoot.Position, (i % 2 == 0) and COL_CRIMSON or COL_GOLD, 18, 0.35, 0.5)
                local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
                ShakeCamera(0.6, 0.08)
                task.wait(0.11)
            end

            -- Fase 2: Teleporte Aéreo + Slam Final
            if eRoot and eRoot.Parent then
                myRoot.CFrame = CFrame.lookAt(eRoot.Position + Vector3.new(0, 18, 0), eRoot.Position)
                task.wait(0.15)
                myRoot.CFrame = eRoot.CFrame * CFrame.new(0, 0, 3)
                CreateEnergySphere(eRoot.Position, COL_CRIMSON, 4, 42, 0.65)
                Create3DWave(eRoot.Position, COL_GOLD, 55, 0.75, 1.2)
                ShakeCamera(1.4, 0.35)
            end
        end)
    end)

    -- 6. Phantom Strike
    VIPTab:AddButton("6. Phantom Strike (Corte Fantasma Instantâneo)", "Atravessa o inimigo em velocidade da luz deixando 5 espectros", function()
        local enemy = GetClosestEnemy()
        local myRoot = GetRoot()
        if not enemy or not GetRoot(enemy) or not myRoot then return end

        local ePos = GetRoot(enemy).Position
        local startPos = myRoot.Position
        PlaySFX("rbxassetid://9114221580", 0.7, 1.4)

        for i = 1, 5 do
            local lerpPos = startPos:Lerp(ePos, i / 5)
            local phantom = Instance.new("Part")
            phantom.Size = Vector3.new(2, 5, 1)
            phantom.Material = Enum.Material.Neon
            phantom.Color = COL_VOID
            phantom.Transparency = 0.35
            phantom.Anchored = true
            phantom.CanCollide = false
            phantom.CFrame = CFrame.lookAt(lerpPos, ePos)
            phantom.Parent = FXFolder
            TweenService:Create(phantom, TweenInfo.new(0.5), {Transparency = 1}):Play()
            task.delay(0.5, function() if phantom.Parent then phantom:Destroy() end end)
        end

        myRoot.CFrame = GetRoot(enemy).CFrame * CFrame.new(0, 0, -4.5) * CFrame.Angles(0, math.rad(180), 0)
        Create3DWave(ePos, COL_VOID, 26, 0.45, 0.6)
        ShakeCamera(0.8, 0.2)
    end)

    -- 7. Clone Assault
    VIPTab:AddButton("7. Clone Assault (Esquadrão de Clones Explosivos)", "Invoca 6 clones visuais que avançam contra o alvo e explodem", function()
        local enemy = GetClosestEnemy()
        local myRoot = GetRoot()
        if not enemy or not GetRoot(enemy) or not myRoot or not LocalPlayer.Character then return end

        local eRoot = GetRoot(enemy)
        LocalPlayer.Character.Archivable = true
        Hub.Notify("👑 Clone Assault", "6 Clones enviados contra " .. enemy.DisplayName .. "!", 3)

        for i = 1, 6 do
            task.spawn(function()
                local angle = math.rad(i * 60)
                local spawnPos = myRoot.Position + Vector3.new(math.cos(angle) * 10, 2, math.sin(angle) * 10)

                local cloneOrb = Instance.new("Part")
                cloneOrb.Size = Vector3.new(2.5, 5.2, 1.5)
                cloneOrb.Material = Enum.Material.Neon
                cloneOrb.Color = (i % 2 == 0) and COL_CRIMSON or COL_GOLD
                cloneOrb.Anchored = true
                cloneOrb.CanCollide = false
                cloneOrb.CFrame = CFrame.lookAt(spawnPos, eRoot.Position)
                cloneOrb.Parent = FXFolder

                local tw = TweenService:Create(cloneOrb, TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                    CFrame = eRoot.CFrame
                })
                tw:Play()
                tw.Completed:Wait()
                CreateEnergySphere(eRoot.Position, cloneOrb.Color, 2, 18, 0.4)
                cloneOrb:Destroy()
            end)
        end
    end)

    -- 8. Target Cyclone
    local TargetCycloneActive = false
    VIPTab:AddToggle("8. Target Cyclone (Redemoinho no Alvo)", "Prende você num furacão letal girando ao redor do alvo", false, function(state)
        TargetCycloneActive = state
    end)

    -- 9. Cyclone Attack (Ao redor de você)
    local SelfCycloneActive = false
    VIPTab:AddToggle("9. Cyclone Attack (Furacão Pessoal 3D)", "Cria um tornado 3D ao seu redor que arremessa peças soltas", false, function(state)
        SelfCycloneActive = state
    end)

    -- 10. Gravity Crush
    VIPTab:AddButton("10. Gravity Crush (Esmagamento Gravitacional)", "Cria uma cúpula roxa pesada que esmaga objetos e alvos para o chão", function()
        local myRoot = GetRoot()
        if not myRoot then return end
        local center = myRoot.Position

        PlaySFX("rbxassetid://9114221580", 0.85, 0.55)
        CreateEnergySphere(center, COL_VOID, 65, 6, 0.65)
        Create3DWave(center - Vector3.new(0, 2.5, 0), COL_VOID, 70, 0.8, 2.5)
        ShakeCamera(1.5, 0.45)

        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v.Anchored and not v:IsDescendantOf(LocalPlayer.Character) then
                if (v.Position - center).Magnitude < 75 then
                    v.AssemblyLinearVelocity = Vector3.new(0, -350, 0)
                end
            end
        end
        Hub.Notify("👑 Gravity Crush", "Pressão gravitacional máxima aplicada na área!", 3)
    end)

    -- 11. Shockwave
    VIPTab:AddButton("11. Shockwave (Onda Expansiva Tripla)", "Dispara 3 ondas de choque concêntricas que repelem objetos", function()
        local myRoot = GetRoot()
        if not myRoot then return end
        local pos = myRoot.Position - Vector3.new(0, 2.5, 0)
        PlaySFX("rbxassetid://9114221580", 0.8, 0.9)
        ShakeCamera(1.2, 0.35)

        task.spawn(function()
            for i = 1, 3 do
                Create3DWave(pos, (i % 2 == 0) and COL_GOLD or COL_CRIMSON, 45 * i, 0.65, 1.2)
                task.wait(0.12)
            end
        end)

        for _, v in ipairs(workspace:GetChildren()) do
            if v:IsA("BasePart") and not v.Anchored and (v.Position - myRoot.Position).Magnitude < 65 then
                v.AssemblyLinearVelocity = (v.Position - myRoot.Position).Unit * 220 + Vector3.new(0, 60, 0)
            end
        end
    end)

    -- 12. Impact Burst
    VIPTab:AddButton("12. Impact Burst (Explosão de Curto Alcance)", "Detona energia concentrada no seu peito com impulso radial", function()
        local myRoot = GetRoot()
        if not myRoot then return end
        PlaySFX("rbxassetid://9114221580", 0.9, 1.05)
        CreateEnergySphere(myRoot.Position, COL_GOLD, 2, 38, 0.45)
        CreateEnergySphere(myRoot.Position, COL_CRIMSON, 4, 26, 0.35)
        ShakeCamera(1.6, 0.28)
    end)

    -- 13. Area Strike
    VIPTab:AddButton("13. Area Strike (Bombardeio de Pilares de Luz)", "Invoca 12 pilares de energia orbital do céu ao redor da área", function()
        local myRoot = GetRoot()
        if not myRoot then return end
        local center = myRoot.Position
        Hub.Notify("👑 Area Strike", "Bombardeio orbital iniciado!", 3)

        task.spawn(function()
            for i = 1, 12 do
                local strikePos = center + Vector3.new(math.random(-45, 45), 0, math.random(-45, 45))
                local pillar = Instance.new("Part")
                pillar.Shape = Enum.PartType.Cylinder
                pillar.Size = Vector3.new(160, 7, 7)
                pillar.Material = Enum.Material.Neon
                pillar.Color = (i % 2 == 0) and COL_CRIMSON or COL_GOLD
                pillar.Anchored = true
                pillar.CanCollide = false
                pillar.CFrame = CFrame.new(strikePos + Vector3.new(0, 80, 0)) * CFrame.Angles(0, 0, math.rad(90))
                pillar.Parent = FXFolder

                Create3DWave(strikePos, pillar.Color, 28, 0.5, 0.8)
                ShakeCamera(0.5, 0.1)
                TweenService:Create(pillar, TweenInfo.new(0.45), {Size = Vector3.new(160, 0.1, 0.1), Transparency = 1}):Play()
                task.delay(0.45, function() if pillar.Parent then pillar:Destroy() end end)
                task.wait(0.1)
            end
        end)
    end)

    -- =========================================================================
    -- SEÇÃO 3: FLINGS AVANÇADOS (PHANTOM FLING & CHAIN FLING)
    -- =========================================================================
    VIPTab:AddSection("Física de Lançamento VIP (Flings)")

    -- 14. Phantom Fling
    VIPTab:AddButton("14. Phantom Fling (Lançamento Fantasma no Alvo)", "Lança o alvo mais próximo com pico de física e volta pro seu lugar", function()
        local enemy = GetClosestEnemy()
        local myRoot = GetRoot()
        if not enemy or not GetRoot(enemy) or not myRoot then return end

        local savedCF = myRoot.CFrame
        local eRoot = GetRoot(enemy)
        Hub.Notify("👑 Phantom Fling", "Aplicando impulso físico em " .. enemy.DisplayName, 3)

        task.spawn(function()
            local start = tick()
            while tick() - start < 0.65 and eRoot and eRoot.Parent and myRoot do
                myRoot.CFrame = eRoot.CFrame
                myRoot.AssemblyLinearVelocity = Vector3.new(9000, 9000, 9000)
                myRoot.AssemblyAngularVelocity = Vector3.new(9000, 9000, 9000)
                RunService.Heartbeat:Wait()
            end
            if myRoot then
                myRoot.AssemblyLinearVelocity = Vector3.zero
                myRoot.AssemblyAngularVelocity = Vector3.zero
                myRoot.CFrame = savedCF
            end
        end)
    end)

    -- 15. Chain Fling
    VIPTab:AddButton("15. Chain Fling (Fling em Cadeia no Servidor)", "Teleporta de jogador em jogador aplicando lançamento em sequência!", function()
        local myRoot = GetRoot()
        if not myRoot then return end
        local savedCF = myRoot.CFrame
        Hub.Notify("👑 CHAIN FLING", "Iniciando lançamento em cadeia nos alvos!", 4)

        task.spawn(function()
            local count = 0
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and GetRoot(plr) and GetHum(plr) and GetHum(plr).Health > 0 then
                    count += 1
                    if count > 6 then break end
                    local tRoot = GetRoot(plr)
                    local tStart = tick()
                    Create3DWave(tRoot.Position, COL_CRIMSON, 18, 0.4, 0.5)
                    while tick() - tStart < 0.35 and tRoot and tRoot.Parent and myRoot do
                        myRoot.CFrame = tRoot.CFrame
                        myRoot.AssemblyLinearVelocity = Vector3.new(8500, 8500, 8500)
                        RunService.Heartbeat:Wait()
                    end
                end
            end
            if myRoot then
                myRoot.AssemblyLinearVelocity = Vector3.zero
                myRoot.AssemblyAngularVelocity = Vector3.zero
                myRoot.CFrame = savedCF
            end
            Hub.Notify("👑 Chain Fling", "Sequência finalizada! Posição restaurada.", 3)
        end)
    end)

    -- =========================================================================
    -- SEÇÃO 4: CATACLISMOS & EVENTOS SUPREMOS (NUCLEAR, APOCALYPSE, CHAOS)
    -- =========================================================================
    VIPTab:AddSection("Cataclismos & Modos Supremos VIP")

    -- 16. Meteor Attack
    VIPTab:AddButton("16. Meteor Attack (Meteoro Colossal de Madara)", "Invoca um meteoro gigante flamejante que cai onde você estiver olhando", function()
        local myRoot = GetRoot()
        if not myRoot then return end
        local targetPos = (Mouse and Mouse.Hit) and Mouse.Hit.Position or (myRoot.Position + Vector3.new(0, 0, -25))

        Hub.Notify("👑 METEOR ATTACK", "Um meteoro colossal entrou na atmosfera!", 3)
        PlaySFX("rbxassetid://9114221580", 0.9, 0.6)

        local meteor = Instance.new("Part")
        meteor.Shape = Enum.PartType.Ball
        meteor.Size = Vector3.new(36, 36, 36)
        meteor.Material = Enum.Material.Neon
        meteor.Color = COL_CRIMSON
        meteor.Anchored = true
        meteor.CanCollide = false
        meteor.Position = targetPos + Vector3.new(60, 220, 60)
        meteor.Parent = FXFolder

        local core = Instance.new("Part")
        core.Shape = Enum.PartType.Ball
        core.Size = Vector3.new(40, 40, 40)
        core.Material = Enum.Material.ForceField
        core.Color = COL_GOLD
        core.Anchored = true
        core.CanCollide = false
        core.Position = meteor.Position
        core.Parent = meteor

        local fallTween = TweenService:Create(meteor, TweenInfo.new(1.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = targetPos
        })
        TweenService:Create(core, TweenInfo.new(1.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = targetPos
        }):Play()
        fallTween:Play()

        fallTween.Completed:Connect(function()
            PlaySFX("rbxassetid://9114221580", 1, 0.5)
            ShakeCamera(2.5, 0.8)
            CreateEnergySphere(targetPos, COL_GOLD, 15, 130, 1.1)
            Create3DWave(targetPos, COL_CRIMSON, 160, 1.2, 4)
            Create3DWave(targetPos, COL_GOLD, 110, 0.9, 2)
            meteor:Destroy()
        end)
    end)

    -- 17. Time Freeze
    local TimeFreezeDome = nil
    VIPTab:AddToggle("17. Time Freeze (Congelamento Temporal)", "Congela visualmente a cena, inverte cores e trava inimigos na área", false, function(state)
        if TimeFreezeDome then TimeFreezeDome:Destroy() TimeFreezeDome = nil end
        if state then
            PlaySFX("rbxassetid://9114221580", 0.85, 0.5)
            local cc = Lighting:FindFirstChild("RecexVIPTimeFreeze") or Instance.new("ColorCorrectionEffect", Lighting)
            cc.Name = "RecexVIPTimeFreeze"
            cc.Contrast = -1.6
            cc.Saturation = -1

            if GetRoot() then
                TimeFreezeDome = Instance.new("Part")
                TimeFreezeDome.Shape = Enum.PartType.Ball
                TimeFreezeDome.Material = Enum.Material.ForceField
                TimeFreezeDome.Color = COL_GOLD
                TimeFreezeDome.Anchored = true
                TimeFreezeDome.CanCollide = false
                TimeFreezeDome.Size = Vector3.new(4, 4, 4)
                TimeFreezeDome.Position = GetRoot().Position
                TimeFreezeDome.Parent = FXFolder
                TweenService:Create(TimeFreezeDome, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Size = Vector3.new(180, 180, 180)
                }):Play()
            end

            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and GetRoot(plr) then
                    GetRoot(plr).Anchored = true
                end
            end
            Hub.Notify("👑 TIME FREEZE", "O tempo foi congelado na sua dimensão!", 3)
        else
            local cc = Lighting:FindFirstChild("RecexVIPTimeFreeze")
            if cc then cc:Destroy() end
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and GetRoot(plr) then
                    GetRoot(plr).Anchored = false
                end
            end
        end
    end)

    -- 18. Nuclear Effect
    VIPTab:AddButton("18. Nuclear Effect (Detonação Atômica 3D)", "Gera clarão cegante, cogumelo atômico gigante e ondas de choque", function()
        local myRoot = GetRoot()
        if not myRoot then return end
        local pos = myRoot.Position

        Hub.Notify("☢️ NUCLEAR EFFECT", "Detonação termonuclear ativada!", 4)
        PlaySFX("rbxassetid://9114221580", 1, 0.45)
        ShakeCamera(3.2, 1.4)

        -- Clarão Nuclear na Iluminação
        local oldExp = Lighting.ExposureCompensation
        Lighting.ExposureCompensation = 3.5
        TweenService:Create(Lighting, TweenInfo.new(2.2), {ExposureCompensation = oldExp}):Play()

        -- Coluna e Cogumelo Nuclear 3D
        local stem = Instance.new("Part")
        stem.Shape = Enum.PartType.Cylinder
        stem.Material = Enum.Material.Neon
        stem.Color = Color3.fromRGB(255, 140, 40)
        stem.Anchored = true
        stem.CanCollide = false
        stem.Size = Vector3.new(10, 8, 8)
        stem.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0)) * CFrame.Angles(0, 0, math.rad(90))
        stem.Parent = FXFolder

        local cap = Instance.new("Part")
        cap.Shape = Enum.PartType.Ball
        cap.Material = Enum.Material.Neon
        cap.Color = COL_CRIMSON
        cap.Anchored = true
        cap.CanCollide = false
        cap.Size = Vector3.new(12, 8, 12)
        cap.Position = pos + Vector3.new(0, 12, 0)
        cap.Parent = FXFolder

        TweenService:Create(stem, TweenInfo.new(2.0, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = Vector3.new(110, 26, 26),
            Position = pos + Vector3.new(0, 55, 0),
            Transparency = 1
        }):Play()

        TweenService:Create(cap, TweenInfo.new(2.0, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = Vector3.new(130, 65, 130),
            Position = pos + Vector3.new(0, 105, 0),
            Transparency = 1
        }):Play()

        Create3DWave(pos, COL_GOLD, 240, 1.6, 5)
        Create3DWave(pos, COL_CRIMSON, 180, 1.2, 3)

        task.delay(2.1, function()
            if stem.Parent then stem:Destroy() end
            if cap.Parent then cap:Destroy() end
        end)
    end)

    -- 19. Chaos Mode
    local ChaosModeActive = false
    VIPTab:AddToggle("19. Chaos Mode (Combate & Física Caótica)", "Combina pulsos gravitacionais, ondas de choque e ataques automáticos", false, function(state)
        ChaosModeActive = state
        if state then
            Hub.Notify("👑 CHAOS MODE", "Modo Caos de Combate e Física ativado!", 3)
        end
    end)

    -- 20. Apocalypse Mode
    local ApocalypseActive = false
    VIPTab:AddToggle("20. Apocalypse Mode (Céu Carmesim & Chuva de Fogo)", "Transforma o mapa no Apocalipse com meteoros e raios contínuos", false, function(state)
        ApocalypseActive = state
        if state then
            local cc = Lighting:FindFirstChild("RecexApocalypse") or Instance.new("ColorCorrectionEffect", Lighting)
            cc.Name = "RecexApocalypse"
            cc.TintColor = Color3.fromRGB(255, 120, 120)
            cc.Contrast = 0.35
            Hub.Notify("🔥 APOCALYPSE MODE", "O Apocalipse começou no servidor!", 4)
        else
            local cc = Lighting:FindFirstChild("RecexApocalypse")
            if cc then cc:Destroy() end
        end
    end)

    -- 21. ULTIMATE CHAOS (O Botão Supremo que combina TUDO)
    local UltimateChaosActive = false
    VIPTab:AddToggle("21. ⚡ ULTIMATE CHAOS (PODER TOTAL SUPREMO)", "Ativa Overdrive + Furacão + Pilares + Clones + Explosões simultaneamente!", false, function(state)
        UltimateChaosActive = state
        if state then
            PlaySFX("rbxassetid://9114221580", 1, 0.75)
            ShakeCamera(2.0, 0.6)
            Hub.Notify("👑 ULTIMATE CHAOS", "PODER MÁXIMO DO SOVEREIGN VIP LIBERADO!", 5)
        end
    end)

    -- =========================================================================
    -- LOOP CENTRAL DE EXECUÇÃO EM TEMPO REAL (60 FPS)
    -- =========================================================================
    local SpinAngle = 0
    local LastChaosTick = 0
    local LastTitanStep = Vector3.zero

    RunService.RenderStepped:Connect(function(dt)
        SpinAngle += dt * 8
        local myRoot = GetRoot()
        local myHum = GetHum()
        if not myRoot or not myHum then return end

        -- [1] Zero Cooldown
        if ZeroCDActive and LocalPlayer.Character then
            for _, item in ipairs(LocalPlayer.Character:GetDescendants()) do
                if item:IsA("Tool") then
                    item.Enabled = true
                elseif item:IsA("NumberValue") or item:IsA("IntValue") then
                    local n = item.Name:lower()
                    if n:find("cooldown") or n:find("cd") or n:find("reload") or n:find("delay") then
                        item.Value = 0
                    end
                elseif item:IsA("BoolValue") then
                    local n = item.Name:lower()
                    if n:find("debounce") or n:find("cooldown") or n:find("busy") or n:find("stun") then
                        item.Value = false
                    end
                end
            end
        end

        -- [2] Overdrive Lock
        if OverdriveActive then
            if myHum.WalkSpeed < 65 then myHum.WalkSpeed = 65 end
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end

        -- [3] Titan Mode Armor & Heavy Steps
        if TitanActive then
            for _, pair in ipairs(TitanParts) do
                if pair.Armor and pair.Limb and pair.Limb.Parent then
                    pair.Armor.CFrame = pair.Limb.CFrame
                end
            end
            if (myRoot.Position - LastTitanStep).Magnitude > 8 then
                LastTitanStep = myRoot.Position
                Create3DWave(myRoot.Position - Vector3.new(0, 4, 0), COL_GOLD, 18, 0.4, 0.5)
                ShakeCamera(0.35, 0.08)
            end
        end

        -- [8] Target Cyclone
        if TargetCycloneActive then
            local enemy = GetClosestEnemy()
            if enemy and GetRoot(enemy) then
                local ePos = GetRoot(enemy).Position
                local offset = Vector3.new(math.cos(SpinAngle * 2) * 8, math.sin(SpinAngle) * 3 + 2, math.sin(SpinAngle * 2) * 8)
                myRoot.CFrame = CFrame.lookAt(ePos + offset, ePos)
                if math.random(1, 4) == 1 then
                    Create3DWave(ePos, COL_CRIMSON, 16, 0.3, 0.4)
                end
            end
        end

        -- [9] Cyclone Attack (Furacão Pessoal 3D)
        if SelfCycloneActive or UltimateChaosActive then
            if math.random(1, 3) == 1 then
                local h = math.random(-2, 8)
                Create3DWave(myRoot.Position + Vector3.new(0, h, 0), (h % 2 == 0) and COL_GOLD or COL_CRIMSON, 18 + h * 1.5, 0.28, 0.35)
            end
            for _, p in ipairs(workspace:GetChildren()) do
                if p:IsA("BasePart") and not p.Anchored and (p.Position - myRoot.Position).Magnitude < 45 then
                    local tang = Vector3.new(-math.sin(SpinAngle), 0.5, math.cos(SpinAngle))
                    p.AssemblyLinearVelocity = tang * 140
                end
            end
        end

        -- [19, 20, 21] Chaos Mode, Apocalypse Mode & Ultimate Chaos (Pulsos Automáticos)
        if (ChaosModeActive or ApocalypseActive or UltimateChaosActive) and (tick() - LastChaosTick > 0.45) then
            LastChaosTick = tick()

            if ChaosModeActive or UltimateChaosActive then
                Create3DWave(myRoot.Position - Vector3.new(0, 2.5, 0), COL_CRIMSON, 42, 0.5, 0.8)
                local enemy = GetClosestEnemy()
                if enemy and GetRoot(enemy) then
                    CreateEnergySphere(GetRoot(enemy).Position, COL_GOLD, 2, 16, 0.35)
                end
            end

            if ApocalypseActive or UltimateChaosActive then
                local randPos = myRoot.Position + Vector3.new(math.random(-55, 55), 0, math.random(-55, 55))
                local beam = Instance.new("Part")
                beam.Shape = Enum.PartType.Cylinder
                beam.Size = Vector3.new(140, 4, 4)
                beam.Material = Enum.Material.Neon
                beam.Color = (math.random(1, 2) == 1) and COL_CRIMSON or COL_GOLD
                beam.Anchored = true
                beam.CanCollide = false
                beam.CFrame = CFrame.new(randPos + Vector3.new(0, 70, 0)) * CFrame.Angles(0, 0, math.rad(90))
                beam.Parent = FXFolder

                Create3DWave(randPos, beam.Color, 24, 0.45, 0.6)
                TweenService:Create(beam, TweenInfo.new(0.4), {Transparency = 1, Size = Vector3.new(140, 0.1, 0.1)}):Play()
                task.delay(0.4, function() if beam.Parent then beam:Destroy() end end)
            end
        end
    end)
end