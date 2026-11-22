-- [[ RECEX HUB — MODULES/RECEXSCRIPTS.LUA ]] --
-- [[ Scripts Autorais Exclusivos — 100% Made by recex ]] --

return function(Hub, Tabs)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")

    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    local Mouse = LocalPlayer:GetMouse()
    local Tab = Tabs.Recex

    local GoldColor   = Color3.fromRGB(255, 200, 115)
    local VioletColor = Color3.fromRGB(145, 95, 255)
    local PureWhite   = Color3.fromRGB(255, 255, 255)

    local function GetRoot()
        return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    end

    -- =========================================================================
    -- SCRIPT AUTORAL #1: RECEX BLINK TOOL (TELEPORTE VISUAL)
    -- =========================================================================
    Tab:AddSection("1. Recex Blink (Teleporte Relâmpago)")

    local function SpawnBlinkEffect(position)
        local ring = Instance.new("Part")
        ring.Size = Vector3.new(1, 0.2, 1)
        ring.Position = position + Vector3.new(0, 0.5, 0)
        ring.Color = GoldColor
        ring.Material = Enum.Material.Neon
        ring.Anchored = true
        ring.CanCollide = false
        ring.CastShadow = false
        ring.Shape = Enum.PartType.Cylinder
        ring.CFrame = CFrame.new(ring.Position) * CFrame.Angles(0, 0, math.rad(90))
        ring.Parent = Camera

        local tw = TweenService:Create(ring, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = Vector3.new(0.2, 14, 14),
            Transparency = 1
        })
        tw:Play()
        tw.Completed:Connect(function() ring:Destroy() end)
    end

    Tab:AddButton("Pegar Item: [ Recex Blink ]", "Adiciona a ferramenta exclusiva de Teleporte Instantâneo na sua mochila", function()
        local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
        if not backpack then return end

        -- Evita duplicar se já tiver
        if backpack:FindFirstChild("Recex Blink") or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Recex Blink")) then
            Hub.Notify("Recex Blink", "Você já possui a ferramenta no inventário!", 2.5)
            return
        end

        local tool = Instance.new("Tool")
        tool.Name = "Recex Blink"
        tool.RequiresHandle = false
        tool.ToolTip = "Made by recex — Clique para teleportar"

        tool.Activated:Connect(function()
            local root = GetRoot()
            if root and Mouse.Hit then
                local targetPos = Mouse.Hit.Position
                SpawnBlinkEffect(root.Position)
                root.CFrame = CFrame.new(targetPos + Vector3.new(0, 3.2, 0))
                SpawnBlinkEffect(targetPos)
            end
        end)

        tool.Parent = backpack
        Hub.Notify("Recex Blink", "Item adicionado à sua mochila! Equipe e clique onde quiser ir.", 3.5)
    end)

    -- =========================================================================
    -- SCRIPT AUTORAL #2: RECEX TIME REWIND (VOLTAR NO TEMPO)
    -- =========================================================================
    Tab:AddSection("2. Recex Time Rewind (Manipulação Temporal)")

    local TimeRecording = false
    local IsRewinding = false
    local FrameHistory = {}
    local MaxHistoryFrames = 240 -- ~4 segundos a 60 FPS

    local function TriggerRewind()
        if not TimeRecording then
            Hub.Notify("Time Rewind", "Ative o Gravador Temporal primeiro!", 2.5)
            return
        end
        if IsRewinding or #FrameHistory < 10 then
            Hub.Notify("Time Rewind", "Ainda não há histórico suficiente para voltar!", 2)
            return
        end

        local root = GetRoot()
        if not root then return end

        IsRewinding = true
        Hub.Notify("Time Rewind", "⏪ Rebobinando no tempo...", 2)

        -- Efeito visual de distorção de câmera durante o Rewind
        local origFOV = Camera.FieldOfView
        TweenService:Create(Camera, TweenInfo.new(0.25), {FieldOfView = 92}):Play()

        task.spawn(function()
            root.Anchored = true
            -- Rebobina 2 quadros por vez para ser rápido e super fluido
            for i = #FrameHistory, 1, -2 do
                if not root or not root.Parent then break end
                root.CFrame = FrameHistory[i]
                RunService.RenderStepped:Wait()
            end
            table.clear(FrameHistory)
            if root then root.Anchored = false end
            TweenService:Create(Camera, TweenInfo.new(0.35, Enum.EasingStyle.Back), {FieldOfView = origFOV}):Play()
            IsRewinding = false
        end)
    end

    Tab:AddToggle("Ativar Gravador Temporal (Tecla C)", "Grava seus últimos 4 segundos continuamente. Pressione [C] para rebobinar!", false, function(enabled)
        TimeRecording = enabled
        table.clear(FrameHistory)
        Hub.Notify("Time Rewind", enabled and "Gravador Temporal ativo! Pressione [C] ou use o botão abaixo para voltar." or "Gravador Temporal desligado.", 3)
    end)

    Tab:AddButton("⏪ Voltar 4 Segundos no Tempo Agora", "Rebobina seu personagem imediatamente (Ideal para Mobile)", function()
        TriggerRewind()
    end)

    UserInputService.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == Enum.KeyCode.C and TimeRecording then
            TriggerRewind()
        end
    end)

    -- =========================================================================
    -- SCRIPT AUTORAL #3: RECEX ASTRAL AURA 3D (COSMÉTICO EXCLUSIVO)
    -- =========================================================================
    Tab:AddSection("3. Recex Astral Aura (Cosmético 3D)")

    local AuraEnabled = false
    local AuraFolder = nil
    local AuraOrbs = {}
    local AuraAngle = 0

    local function DestroyAura()
        if AuraFolder then AuraFolder:Destroy(); AuraFolder = nil end
        table.clear(AuraOrbs)
    end

    local function CreateAura()
        DestroyAura()
        AuraFolder = Instance.new("Folder", Camera)
        AuraFolder.Name = "RecexAstralAura"

        for i = 1, 3 do
            local orb = Instance.new("Part")
            orb.Size = Vector3.new(0.55, 0.55, 0.55)
            orb.Shape = Enum.PartType.Ball
            orb.Color = (i % 2 == 1) and GoldColor or VioletColor
            orb.Material = Enum.Material.Neon
            orb.Anchored = true
            orb.CanCollide = false
            orb.CastShadow = false
            orb.Parent = AuraFolder

            local a0 = Instance.new("Attachment", orb); a0.Position = Vector3.new(0, 0.25, 0)
            local a1 = Instance.new("Attachment", orb); a1.Position = Vector3.new(0, -0.25, 0)

            local trail = Instance.new("Trail", orb)
            trail.Attachment0 = a0
            trail.Attachment1 = a1
            trail.Lifetime = 0.55
            trail.LightEmission = 1
            trail.Color = ColorSequence.new(orb.Color, PureWhite)
            trail.Transparency = NumberSequence.new(0.05, 1)
            trail.WidthScale = NumberSequence.new(1, 0)

            table.insert(AuraOrbs, {
                part = orb,
                phase = i * ((math.pi * 2) / 3),
                tilt = math.rad((i - 2) * 32)
            })
        end
    end

    Tab:AddToggle("Ativar Aura Astral 3D (Orbes Recex)", "Cria 3 satélites dourados e violetas orbitando seu personagem em 3D", false, function(enabled)
        AuraEnabled = enabled
        if enabled then
            CreateAura()
            Hub.Notify("Astral Aura", "Aura 3D Recex ativada no seu personagem!", 2.5)
        else
            DestroyAura()
            Hub.Notify("Astral Aura", "Aura 3D desativada.", 2.5)
        end
    end)

    -- =========================================================================
    -- SCRIPT AUTORAL #4: RECEX SPECTATE & TARGET (ESPIÃO DE JOGADORES)
    -- =========================================================================
    Tab:AddSection("4. Recex Spectate (Espionar & Teleportar)")

    local Spectating = false
    local TargetIndex = 1
    local CurrentTarget = nil

    local function GetOtherPlayers()
        local list = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
                table.insert(list, p)
            end
        end
        return list
    end

    local function UpdateSpectateTarget()
        local list = GetOtherPlayers()
        if #list == 0 then
            Hub.Notify("Spectate", "Não há outros jogadores vivos no servidor.", 2.5)
            return
        end
        if TargetIndex > #list then TargetIndex = 1 end
        CurrentTarget = list[TargetIndex]

        if Spectating and CurrentTarget and CurrentTarget.Character then
            local hum = CurrentTarget.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                Camera.CameraSubject = hum
                Hub.Notify("Espionando Jogador", "Alvo atual: " .. CurrentTarget.DisplayName .. " (@" .. CurrentTarget.Name .. ")", 2.5)
            end
        else
            Hub.Notify("Alvo Selecionado", CurrentTarget.DisplayName .. " (@" .. CurrentTarget.Name .. ")", 2)
        end
    end

    Tab:AddToggle("Ativar Modo Espião (Spectate)", "Transfere sua câmera para assistir o jogador selecionado em tempo real", false, function(enabled)
        Spectating = enabled
        if enabled then
            UpdateSpectateTarget()
        else
            local myHum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if myHum then Camera.CameraSubject = myHum end
            Hub.Notify("Spectate", "Câmera devolvida ao seu personagem.", 2.5)
        end
    end)

    Tab:AddButton("⏭️ Trocar para o Próximo Jogador", "Muda o jogador alvo para espionar ou teleportar", function()
        TargetIndex = TargetIndex + 1
        UpdateSpectateTarget()
    end)

    Tab:AddButton("⚡ Teleportar para o Jogador Selecionado", "Leva você instantaneamente até o jogador que você escolheu", function()
        if not CurrentTarget then UpdateSpectateTarget() end
        local myRoot = GetRoot()
        local targetRoot = CurrentTarget and CurrentTarget.Character and CurrentTarget.Character:FindFirstChild("HumanoidRootPart")

        if myRoot and targetRoot then
            SpawnBlinkEffect(myRoot.Position)
            myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3.5)
            SpawnBlinkEffect(myRoot.Position)
            Hub.Notify("Teleporte Recex", "Teleportado para " .. CurrentTarget.DisplayName .. "!", 2.5)
        else
            Hub.Notify("Erro", "Jogador alvo não encontrado no mapa.", 2.5)
        end
    end)

    -- =========================================================================
    -- MOTOR EM TEMPO REAL DOS SCRIPTS RECEX (60 FPS)
    -- =========================================================================
    RunService.RenderStepped:Connect(function(dt)
        local root = GetRoot()

        -- 1. Gravação Contínua do Time Rewind
        if TimeRecording and not IsRewinding and root then
            table.insert(FrameHistory, root.CFrame)
            if #FrameHistory > MaxHistoryFrames then
                table.remove(FrameHistory, 1)
            end
        end

        -- 2. Rotação 3D dos Orbes da Aura Recex ao redor do personagem
        if AuraEnabled and root and #AuraOrbs > 0 then
            AuraAngle = AuraAngle + (dt * 3.2)
            local centerCF = CFrame.new(root.Position)
            for _, orbData in ipairs(AuraOrbs) do
                local a = AuraAngle + orbData.phase
                local yWave = math.sin(a * 1.5) * 1.2
                orbData.part.CFrame = centerCF
                    * CFrame.Angles(orbData.tilt, a, 0)
                    * CFrame.new(0, yWave, -3.8)
            end
        end
    end)
end
