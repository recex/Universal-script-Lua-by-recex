-- ==============================================================================
-- 👑 MODULE: Modules/VIP_Sovereign.lua (YARHM 1.20 ENGINE EDITION)
-- Baseado na arquitetura real do YARHM (Joystickplays):
-- Floating Quick-Buttons, WalkFling Físico, Anti-Fling Stepped, Weapon/Role ESP,
-- Safe Gun/Item TP, Velocity Speed (Anti-Cheat Safe), AirWalk e Spectate/Target.
-- ==============================================================================

return function(Window, Tabs, Recex, VIPData)
    local VIPTab = Window:CreateTab("👑 YARHM VIP")

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Workspace = game:GetService("Workspace")
    local TweenService = game:GetService("TweenService")
    local CoreGui = game:GetService("CoreGui")
    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera

    -- Helpers seguros de Personagem (Funciona mesmo após morrer/resetar)
    local function GetChar()
        return LocalPlayer.Character
    end
    local function GetHRP(char)
        char = char or GetChar()
        return char and char:FindFirstChild("HumanoidRootPart")
    end
    local function GetHum(char)
        char = char or GetChar()
        return char and char:FindFirstChildOfClass("Humanoid")
    end

    -- Estado Global do Módulo YARHM
    local YState = {
        QuickBarVisible = true,
        WalkFling = false,
        AntiFling = false,
        VelocitySpeed = false,
        SpeedValue = 38,
        AirWalk = false,
        AirWalkY = 0,
        Noclip = false,
        WeaponESP = false,
        ThreatHUD = false,
        AutoGrabDropped = false,
        AimLock = false,
        AimLockPart = "HumanoidRootPart",
        Spectating = false,
        TargetFollow = false,
        SelectedTarget = nil
    }

    -- ==========================================================================
    -- 📌 1. YARHM FLOATING QUICK-BUTTONS (BOTÕES RÁPIDOS NA TELA)
    -- ==========================================================================
    local SafeParent = (gethui and gethui()) or CoreGui
    if SafeParent:FindFirstChild("RecexYARHM_QuickUI") then
        SafeParent.RecexYARHM_QuickUI:Destroy()
    end

    local QuickGui = Instance.new("ScreenGui")
    QuickGui.Name = "RecexYARHM_QuickUI"
    QuickGui.ResetOnSpawn = false
    QuickGui.Parent = SafeParent

    -- Barra Flutuante Arrastável estilo YARHM
    local QuickBar = Instance.new("Frame")
    QuickBar.Size = UDim2.new(0, 340, 0, 44)
    QuickBar.Position = UDim2.new(0.5, -170, 0.03, 0)
    QuickBar.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
    QuickBar.BackgroundTransparency = 0.12
    QuickBar.BorderSizePixel = 0
    QuickBar.Active = true
    QuickBar.Draggable = true
    QuickBar.Parent = QuickGui
    Instance.new("UICorner", QuickBar).CornerRadius = UDim.new(0, 12)

    local BarStroke = Instance.new("UIStroke", QuickBar)
    BarStroke.Color = Color3.fromRGB(255, 200, 60)
    BarStroke.Thickness = 1.5
    BarStroke.Transparency = 0.25

    local BarLayout = Instance.new("UIListLayout", QuickBar)
    BarLayout.FillDirection = Enum.FillDirection.Horizontal
    BarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    BarLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    BarLayout.Padding = UDim.new(0, 6)

    local QuickButtons = {}
    local function CreateQuickButton(id, labelText, callback)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(0, 60, 0, 30)
        Btn.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
        Btn.Text = labelText
        Btn.Font = Enum.Font.GothamBold
        Btn.TextSize = 10
        Btn.TextColor3 = Color3.fromRGB(210, 210, 225)
        Btn.AutoButtonColor = false
        Btn.Parent = QuickBar
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

        local Stroke = Instance.new("UIStroke", Btn)
        Stroke.Color = Color3.fromRGB(65, 65, 85)
        Stroke.Thickness = 1

        local function UpdateVisual(active)
            TweenService:Create(Btn, TweenInfo.new(0.2), {
                BackgroundColor3 = active and Color3.fromRGB(255, 195, 50) or Color3.fromRGB(26, 26, 36),
                TextColor3 = active and Color3.fromRGB(15, 15, 20) or Color3.fromRGB(210, 210, 225)
            }):Play()
            Stroke.Color = active and Color3.fromRGB(255, 235, 120) or Color3.fromRGB(65, 65, 85)
        end

        Btn.MouseButton1Click:Connect(function()
            local newState = callback()
            UpdateVisual(newState)
        end)

        QuickButtons[id] = UpdateVisual
    end

    -- HUD Flutuante de Ameaças / Armas (YARHM Role Tracker)
    local ThreatFrame = Instance.new("Frame")
    ThreatFrame.Size = UDim2.new(0, 210, 0, 110)
    ThreatFrame.Position = UDim2.new(1, -225, 0.35, 0)
    ThreatFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    ThreatFrame.BackgroundTransparency = 0.15
    ThreatFrame.Visible = false
    ThreatFrame.Active = true
    ThreatFrame.Draggable = true
    ThreatFrame.Parent = QuickGui
    Instance.new("UICorner", ThreatFrame).CornerRadius = UDim.new(0, 10)

    local ThreatStroke = Instance.new("UIStroke", ThreatFrame)
    ThreatStroke.Color = Color3.fromRGB(255, 70, 90)
    ThreatStroke.Thickness = 1.2

    local ThreatTitle = Instance.new("TextLabel", ThreatFrame)
    ThreatTitle.Size = UDim2.new(1, -12, 0, 22)
    ThreatTitle.Position = UDim2.new(0, 6, 0, 4)
    ThreatTitle.BackgroundTransparency = 1
    ThreatTitle.Text = "🔫 YARHM WEAPON SCANNER"
    ThreatTitle.Font = Enum.Font.GothamBlack
    ThreatTitle.TextSize = 11
    ThreatTitle.TextColor3 = Color3.fromRGB(255, 200, 70)
    ThreatTitle.TextXAlignment = Enum.TextXAlignment.Left

    local ThreatList = Instance.new("TextLabel", ThreatFrame)
    ThreatList.Size = UDim2.new(1, -12, 1, -30)
    ThreatList.Position = UDim2.new(0, 6, 0, 26)
    ThreatList.BackgroundTransparency = 1
    ThreatList.Text = "Escaneando inventários..."
    ThreatList.Font = Enum.Font.GothamMedium
    ThreatList.TextSize = 11
    ThreatList.TextColor3 = Color3.fromRGB(230, 230, 240)
    ThreatList.TextXAlignment = Enum.TextXAlignment.Left
    ThreatList.TextYAlignment = Enum.TextYAlignment.Top
    ThreatList.TextWrapped = true

    -- ==========================================================================
    -- 🛡️ 2. FUNÇÕES INTERNAS REAIS (MOTOR YARHM)
    -- ==========================================================================

    -- Plataforma AirWalk (Invisível e acompanha X/Z perfeitamente)
    local AirPart = Instance.new("Part")
    AirPart.Name = "YARHM_AirWalkPad"
    AirPart.Size = Vector3.new(10, 1, 10)
    AirPart.Transparency = 1
    AirPart.Anchored = true
    AirPart.CanCollide = false

    local function SetAirWalk(state)
        YState.AirWalk = state
        local hrp = GetHRP()
        if state and hrp then
            YState.AirWalkY = hrp.Position.Y - 3.4
            AirPart.CanCollide = true
            AirPart.Parent = Workspace
        else
            AirPart.CanCollide = false
            AirPart.Parent = nil
        end
        if QuickButtons["AirWalk"] then QuickButtons["AirWalk"](state) end
    end

    local function SetWalkFling(state)
        YState.WalkFling = state
        if QuickButtons["Fling"] then QuickButtons["Fling"](state) end
        Window:Notify("YARHM WalkFling", state and "Encoste em alguém para arremessar!" or "WalkFling Desativado.")
    end

    local function SetNoclip(state)
        YState.Noclip = state
        if QuickButtons["Noclip"] then QuickButtons["Noclip"](state) end
    end

    local function SetAimLock(state)
        YState.AimLock = state
        if QuickButtons["LockOn"] then QuickButtons["LockOn"](state) end
    end

    -- Função YARHM: Pegar Arma/Item Caído no Mapa (Safe Micro-Teleport)
    local function GrabDroppedWeapon()
        local hrp = GetHRP()
        if not hrp then return end

        local targetObj = nil
        -- Procura GunDrop (MM2) ou Tools caídas no Workspace
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj.Name == "GunDrop" and obj:IsA("BasePart") then
                targetObj = obj
                break
            elseif obj:IsA("Tool") and obj.Parent == Workspace and obj:FindFirstChild("Handle") then
                targetObj = obj.Handle
                break
            end
        end

        if targetObj then
            local savedCF = hrp.CFrame
            hrp.CFrame = targetObj.CFrame + Vector3.new(0, 1.5, 0)
            task.wait(0.14)
            if hrp and hrp.Parent then
                hrp.CFrame = savedCF
            end
            Window:Notify("YARHM GunTP", "Item coletado e posição restaurada!")
        else
            Window:Notify("YARHM GunTP", "Nenhuma arma/item caído no chão agora.")
        end
    end

    -- Popula os 5 Botões Rápidos Flutuantes do Topo da Tela
    CreateQuickButton("Fling", "FLING", function()
        SetWalkFling(not YState.WalkFling)
        return YState.WalkFling
    end)
    CreateQuickButton("AirWalk", "AIRWALK", function()
        SetAirWalk(not YState.AirWalk)
        return YState.AirWalk
    end)
    CreateQuickButton("Noclip", "NOCLIP", function()
        SetNoclip(not YState.Noclip)
        return YState.Noclip
    end)
    CreateQuickButton("LockOn", "AIMLOCK", function()
        SetAimLock(not YState.AimLock)
        return YState.AimLock
    end)
    CreateQuickButton("GunTP", "GUN TP", function()
        GrabDroppedWeapon()
        return false
    end)

    -- ==========================================================================
    -- ⚙️ 3. LOOPS DE FÍSICA REAIS (STEPPED / HEARTBEAT / RENDERSTEPPED)
    -- ==========================================================================

    -- A) RunService.Stepped (Roda ANTES da física do Roblox: Noclip e Anti-Fling)
    RunService.Stepped:Connect(function()
        local myChar = GetChar()

        -- Noclip Real (sem travar ao pular)
        if YState.Noclip and myChar then
            for _, part in ipairs(myChar:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end

        -- Anti-Fling YARHM (Desativa colisão e zera energia cinética dos outros jogadores)
        if YState.AntiFling then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    for _, part in ipairs(plr.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                            part.AssemblyLinearVelocity = Vector3.zero
                            part.AssemblyAngularVelocity = Vector3.zero
                        end
                    end
                end
            end
        end
    end)

    -- B) RunService.Heartbeat (Física Pós-Step: WalkFling Real, Velocity Speed, AirWalk, Target)
    RunService.Heartbeat:Connect(function()
        local myChar = GetChar()
        local hrp = GetHRP(myChar)
        local hum = GetHum(myChar)
        if not hrp or not hum then return end

        -- 1. YARHM Velocity Speed (Usa MoveDirection na Física Horizontal -> Não toma Kick/Rubberband!)
        if YState.VelocitySpeed and hum.MoveDirection.Magnitude > 0 then
            local currentVel = hrp.AssemblyLinearVelocity
            hrp.AssemblyLinearVelocity = Vector3.new(
                hum.MoveDirection.X * YState.SpeedValue,
                currentVel.Y,
                hum.MoveDirection.Z * YState.SpeedValue
            )
        end

        -- 2. YARHM AirWalk (Subir com Espaço / Descer com Shift)
        if YState.AirWalk then
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                YState.AirWalkY = YState.AirWalkY + 0.45
            elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                YState.AirWalkY = YState.AirWalkY - 0.45
            end
            AirPart.Position = Vector3.new(hrp.Position.X, YState.AirWalkY, hrp.Position.Z)
        end

        -- 3. Target Follow / Sit / Orbit Fling no Alvo Selecionado
        if YState.TargetFollow and YState.SelectedTarget and YState.SelectedTarget.Character then
            local tHRP = GetHRP(YState.SelectedTarget.Character)
            if tHRP then
                hrp.CFrame = tHRP.CFrame * CFrame.new(0, 0, 2.5)
            end
        end

        -- 4. YARHM WalkFling (Pulso Físico + Restauração Instantânea no RenderStepped)
        if YState.WalkFling then
            local origVel = hrp.AssemblyLinearVelocity
            hrp.AssemblyLinearVelocity = origVel * 10000 + Vector3.new(0, 10000, 0)
            RunService.RenderStepped:Wait()
            if hrp and hrp.Parent then
                hrp.AssemblyLinearVelocity = origVel
            end
        end
    end)

    -- C) AimLock Suave na Câmera (RenderStepped)
    RunService.RenderStepped:Connect(function()
        if YState.AimLock then
            local closestTarget = nil
            local shortestDist = 300
            local myHRP = GetHRP()
            if not myHRP then return end

            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local tHum = GetHum(plr.Character)
                    local tPart = plr.Character:FindFirstChild(YState.AimLockPart) or GetHRP(plr.Character)
                    if tHum and tHum.Health > 0 and tPart then
                        local dist = (tPart.Position - myHRP.Position).Magnitude
                        if dist < shortestDist then
                            shortestDist = dist
                            closestTarget = tPart
                        end
                    end
                end
            end

            if closestTarget then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestTarget.Position)
            end
        end
    end)

    -- ==========================================================================
    -- 🔫 4. SCANNER DE ARMAS / ROLES & AUTO-GRAB (LOOP 0.6s)
    -- ==========================================================================
    local function ClassifyPlayerRole(plr)
        -- Detecta armas tanto na mão (Character) quanto escondidas na Mochila (Backpack)
        local hasKnifeOrMelee = false
        local hasGunOrRanged = false
        local weaponName = nil

        local function scanContainer(container)
            if not container then return end
            for _, item in ipairs(container:GetChildren()) do
                if item:IsA("Tool") then
                    local n = item.Name:lower()
                    weaponName = item.Name
                    if n:find("knife") or n:find("sword") or n:find("blade") or n:find("scythe") or n:find("katana") or n:find("faca") then
                        hasKnifeOrMelee = true
                    elseif n:find("gun") or n:find("revolver") or n:find("pistol") or n:find("sheriff") or n:find("rifle") or n:find("shotgun") then
                        hasGunOrRanged = true
                    else
                        -- Qualquer outra Tool equipada/guardada conta como item ativo
                        hasKnifeOrMelee = true
                    end
                end
            end
        end

        scanContainer(plr.Character)
        scanContainer(plr:FindFirstChild("Backpack"))

        if hasKnifeOrMelee then
            return "THREAT", Color3.fromRGB(255, 50, 60), weaponName
        elseif hasGunOrRanged then
            return "SHERIFF/GUN", Color3.fromRGB(50, 150, 255), weaponName
        else
            return "INNOCENT", Color3.fromRGB(60, 235, 120), nil
        end
    end

    task.spawn(function()
        while task.wait(0.6) do
            -- Auto-Grab Arma Caída
            if YState.AutoGrabDropped then
                for _, obj in ipairs(Workspace:GetChildren()) do
                    if obj.Name == "GunDrop" or (obj:IsA("Tool") and obj:FindFirstChild("Handle")) then
                        GrabDroppedWeapon()
                        break
                    end
                end
            end

            -- Weapon ESP & Threat HUD
            if YState.WeaponESP or YState.ThreatHUD then
                local reportLines = {}

                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character then
                        local role, color, wName = ClassifyPlayerRole(plr)

                        if wName then
                            table.insert(reportLines, "• " .. plr.DisplayName .. " [" .. wName .. "]")
                        end

                        local hl = plr.Character:FindFirstChild("YARHM_RoleESP")
                        if YState.WeaponESP then
                            if not hl then
                                hl = Instance.new("Highlight")
                                hl.Name = "YARHM_RoleESP"
                                hl.FillTransparency = 0.45
                                hl.OutlineTransparency = 0
                                hl.Parent = plr.Character
                            end
                            hl.FillColor = color
                            hl.OutlineColor = color
                        elseif hl then
                            hl:Destroy()
                        end
                    end
                end

                if YState.ThreatHUD then
                    if #reportLines > 0 then
                        ThreatList.Text = table.concat(reportLines, "\n")
                    else
                        ThreatList.Text = "Nenhum jogador armado detectado."
                    end
                end
            else
                -- Limpa Highlights se desligado
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr.Character and plr.Character:FindFirstChild("YARHM_RoleESP") then
                        plr.Character.YARHM_RoleESP:Destroy()
                    end
                end
            end
        end
    end)

    -- ==========================================================================
    -- 🖥️ 5. INTERFACE DO MENU YARHM VIP (ORGANIZADA E FUNCIONAL)
    -- ==========================================================================

    -- SEÇÃO 1: YARHM QUICK-BAR & COMBATE FÍSICO
    VIPTab:CreateSection("📌 YARHM Quick-Bar & Física Real (Sem Lag)")

    VIPTab:CreateToggle("Mostrar Barra Flutuante YARHM (Topo da Tela)", true, function(state)
        YState.QuickBarVisible = state
        QuickBar.Visible = state
    end)

    VIPTab:CreateToggle("YARHM WalkFling Real (Arremessar ao Encostar)", false, function(state)
        SetWalkFling(state)
    end)

    VIPTab:CreateToggle("YARHM Anti-Fling 100% (Imune a Colisões/Fling)", false, function(state)
        YState.AntiFling = state
        Window:Notify("YARHM Anti-Fling", state and "Colisões de terceiros bloqueadas!" or "Desativado.")
    end)

    VIPTab:CreateToggle("AimLock Suave no Inimigo Mais Próximo", false, function(state)
        SetAimLock(state)
    end)

    -- SEÇÃO 2: DETECTOR DE ARMAS / ROLES (MM2 & UNIVERSAL)
    VIPTab:CreateSection("🔫 YARHM Weapon & Role Scanner (MM2 / Combat)")

    VIPTab:CreateToggle("ESP por Cor de Ameaça (Vermelho=Arma / Azul=Gun / Verde=Limpo)", false, function(state)
        YState.WeaponESP = state
    end)

    VIPTab:CreateToggle("Mostrar Painel Flutuante de Quem Está Armado", false, function(state)
        YState.ThreatHUD = state
        ThreatFrame.Visible = state
    end)

    VIPTab:CreateButton("⚡ Pegar Arma/Item Caído no Mapa (Safe GunTP)", function()
        GrabDroppedWeapon()
    end)

    VIPTab:CreateToggle("Auto-Pegar Arma Caída Automaticamente", false, function(state)
        YState.AutoGrabDropped = state
    end)

    -- SEÇÃO 3: MOVIMENTO YARHM (ANTI-RUBBERBAND)
    VIPTab:CreateSection("🏃 Movimento Físico YARHM (Funciona em Qualquer Jogo)")

    VIPTab:CreateToggle("Velocity Speed Boost (Não reseta WalkSpeed)", false, function(state)
        YState.VelocitySpeed = state
    end)

    VIPTab:CreateSlider("Velocidade do Velocity Boost", 18, 120, 38, function(val)
        YState.SpeedValue = val
    end)

    VIPTab:CreateToggle("YARHM AirWalk (Andar no Ar | Espaço Sobe / Shift Desce)", false, function(state)
        SetAirWalk(state)
    end)

    VIPTab:CreateToggle("Noclip Físico Contínuo (Atravessar Paredes)", false, function(state)
        SetNoclip(state)
    end)

    VIPTab:CreateButton("🚪 Phase Forward (Atravessar Parede/Porta Trancada à Frente)", function()
        local hrp = GetHRP()
        if hrp then
            hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -6.5)
        end
    end)

    -- SEÇÃO 4: SISTEMA DE ALVO & SPECTATE (YARHM TARGET CONTROLLER)
    VIPTab:CreateSection("🎯 YARHM Target Controller (Spectate / TP / Fling Alvo)")

    local TargetIndex = 1
    local function CycleTarget()
        local list = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(list, p) end
        end
        if #list == 0 then
            YState.SelectedTarget = nil
            Window:Notify("YARHM Target", "Nenhum outro jogador na sala.")
            return
        end
        TargetIndex = (TargetIndex % #list) + 1
        YState.SelectedTarget = list[TargetIndex]
        Window:Notify("🎯 Alvo Selecionado", YState.SelectedTarget.DisplayName .. " (@" .. YState.SelectedTarget.Name .. ")")
    end

    VIPTab:CreateButton("🔄 Trocar Jogador Alvo (Selecionar Próximo da Sala)", function()
        CycleTarget()
    end)

    VIPTab:CreateToggle("👁️ Spectate Alvo (Ver Tela do Jogador Selecionado)", false, function(state)
        YState.Spectating = state
        if state then
            if not YState.SelectedTarget then CycleTarget() end
            if YState.SelectedTarget and YState.SelectedTarget.Character then
                local tHum = GetHum(YState.SelectedTarget.Character)
                if tHum then Camera.CameraSubject = tHum end
            end
        else
            local myHum = GetHum()
            if myHum then Camera.CameraSubject = myHum end
        end
    end)

    VIPTab:CreateButton("⚡ Teleportar Atrás do Jogador Alvo", function()
        if not YState.SelectedTarget then CycleTarget() end
        if YState.SelectedTarget and YState.SelectedTarget.Character then
            local myHRP = GetHRP()
            local tHRP = GetHRP(YState.SelectedTarget.Character)
            if myHRP and tHRP then
                myHRP.CFrame = tHRP.CFrame * CFrame.new(0, 0, 3)
            end
        end
    end)

    VIPTab:CreateToggle("🔗 Grudar Atrás do Alvo (Target Attach / Follow)", false, function(state)
        if state and not YState.SelectedTarget then CycleTarget() end
        YState.TargetFollow = state
    end)

    VIPTab:CreateButton("🌪️ Dar Fling Focado no Alvo (Arremessar e Voltar)", function()
        if not YState.SelectedTarget then CycleTarget() end
        local target = YState.SelectedTarget
        local myHRP = GetHRP()
        if target and target.Character and myHRP then
            local tHRP = GetHRP(target.Character)
            if tHRP then
                local savedPos = myHRP.CFrame
                Window:Notify("YARHM Target Fling", "Atacando " .. target.DisplayName .. "...")
                SetWalkFling(true)

                local start = tick()
                while tick() - start < 1.3 and target.Character and GetHRP(target.Character) do
                    myHRP.CFrame = GetHRP(target.Character).CFrame
                    task.wait()
                end

                SetWalkFling(false)
                myHRP.AssemblyLinearVelocity = Vector3.zero
                myHRP.CFrame = savedPos
                Window:Notify("YARHM Target Fling", "Concluído! Posição restaurada.")
            end
        end
    end)
end