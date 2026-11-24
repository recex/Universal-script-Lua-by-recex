-- ==============================================================================
-- 👑 MODULE: Modules/VIP_Sovereign.lua (YARHM 1.20 FULL SUITE - FIXED EDITION)
-- Correção Aplicada: Sistema próprio de Notificações Flutuantes YARHM (YNotify)
-- eliminando o erro "attempt to call a nil value" no Window:Notify!
-- ==============================================================================

return function(Window, Tabs, Recex, VIPData)
    local TabUniv = Window:CreateTab("👑 YARHM Univ")
    local TabMM2  = Window:CreateTab("🔪 YARHM MM2")
    local TabFTF  = Window:CreateTab("🔨 YARHM FTF")

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Workspace = game:GetService("Workspace")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local TweenService = game:GetService("TweenService")
    local StarterGui = game:GetService("StarterGui")
    local CoreGui = game:GetService("CoreGui")
    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera

    -- Helpers Dinâmicos (Não quebram ao morrer/resetar)
    local function GetChar() return LocalPlayer.Character end
    local function GetHRP(c) c = c or GetChar(); return c and c:FindFirstChild("HumanoidRootPart") end
    local function GetHum(c) c = c or GetChar(); return c and c:FindFirstChildOfClass("Humanoid") end

    -- Estado Geral do YARHM 1.20
    local Y = {
        -- Universal
        WalkFling = false,
        AntiFling = false,
        AirWalk = false,
        AirWalkY = 0,
        Noclip = false,
        VelSpeed = false,
        VelSpeedVal = 40,
        LoopWS = false,
        WSVal = 32,
        InstantPrompts = false,
        HitboxExp = false,
        HitboxSize = 10,
        SelectedTarget = nil,
        TargetFollow = false,
        Spectating = false,

        -- MM2
        MM2_RoleESP = false,
        MM2_GunESP = false,
        MM2_HUD = false,
        MM2_AutoGrabGun = false,
        MM2_Prediction = 0.16,
        MM2_TeleportShoot = false,
        MM2_KillAura = false,
        MM2_AuraRange = 18,
        MM2_CoinFarm = false,
        MM2_AntiMurderer = false,
        MM2_AntiTraps = false,

        -- FTF & Horror
        FTF_PCESP = false,
        FTF_BeastESP = false,
        FTF_PodExitESP = false,
        FTF_NeverFailPC = false,
        FTF_NoSlow = false,
        Horror_GenESP = false,
        Horror_InfStamina = false
    }

    -- ==========================================================================
    -- 📌 1. YARHM FLOATING UI & SISTEMA DE NOTIFICAÇÕES (SEM ERRO DE NIL)
    -- ==========================================================================
    local SafeParent = (gethui and gethui()) or CoreGui
    if SafeParent:FindFirstChild("RecexYARHM_FullGUI") then
        SafeParent.RecexYARHM_FullGUI:Destroy()
    end

    local YGui = Instance.new("ScreenGui")
    YGui.Name = "RecexYARHM_FullGUI"
    YGui.ResetOnSpawn = false
    YGui.Parent = SafeParent

    -- Container de Notificações YARHM (Canto Inferior Direito)
    local NotifyHolder = Instance.new("Frame")
    NotifyHolder.Size = UDim2.new(0, 250, 0, 300)
    NotifyHolder.Position = UDim2.new(1, -265, 1, -315)
    NotifyHolder.BackgroundTransparency = 1
    NotifyHolder.Parent = YGui

    local NotifyLayout = Instance.new("UIListLayout", NotifyHolder)
    NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    NotifyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    NotifyLayout.Padding = UDim.new(0, 8)

    -- Função Segura de Notificação (Resolve o erro da Linha 499!)
    local function YNotify(title, message)
        task.spawn(function()
            local Card = Instance.new("Frame")
            Card.Size = UDim2.new(1, 0, 0, 52)
            Card.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
            Card.BackgroundTransparency = 0.08
            Card.BorderSizePixel = 0
            Card.Parent = NotifyHolder
            Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 10)

            local Stroke = Instance.new("UIStroke", Card)
            Stroke.Color = Color3.fromRGB(255, 200, 60)
            Stroke.Thickness = 1.3

            local T = Instance.new("TextLabel", Card)
            T.Size = UDim2.new(1, -16, 0, 20)
            T.Position = UDim2.new(0, 8, 0, 5)
            T.BackgroundTransparency = 1
            T.Text = tostring(title or "YARHM VIP")
            T.Font = Enum.Font.GothamBlack
            T.TextSize = 11
            T.TextColor3 = Color3.fromRGB(255, 205, 65)
            T.TextXAlignment = Enum.TextXAlignment.Left

            local M = Instance.new("TextLabel", Card)
            M.Size = UDim2.new(1, -16, 0, 22)
            M.Position = UDim2.new(0, 8, 0, 24)
            M.BackgroundTransparency = 1
            M.Text = tostring(message or "")
            M.Font = Enum.Font.GothamMedium
            M.TextSize = 10
            M.TextColor3 = Color3.fromRGB(230, 230, 240)
            M.TextXAlignment = Enum.TextXAlignment.Left
            M.TextWrapped = true

            task.wait(3.2)
            if Card and Card.Parent then
                TweenService:Create(Card, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                TweenService:Create(T, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
                TweenService:Create(M, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
                task.wait(0.32)
                if Card and Card.Parent then Card:Destroy() end
            end
        end)
    end

    -- Registra também no Window para nunca dar nil em nenhum módulo
    if type(Window) == "table" and not Window.Notify then
        Window.Notify = function(_, title, msg)
            YNotify(title, msg)
        end
    end

    -- Barra Flutuante de Ações Rápidas YARHM
    local QuickBar = Instance.new("Frame")
    QuickBar.Size = UDim2.new(0, 410, 0, 44)
    QuickBar.Position = UDim2.new(0.5, -205, 0.025, 0)
    QuickBar.BackgroundColor3 = Color3.fromRGB(13, 13, 19)
    QuickBar.BackgroundTransparency = 0.1
    QuickBar.BorderSizePixel = 0
    QuickBar.Active = true
    QuickBar.Draggable = true
    QuickBar.Parent = YGui
    Instance.new("UICorner", QuickBar).CornerRadius = UDim.new(0, 12)

    local BarStroke = Instance.new("UIStroke", QuickBar)
    BarStroke.Color = Color3.fromRGB(255, 195, 55)
    BarStroke.Thickness = 1.5
    BarStroke.Transparency = 0.2

    local BarLayout = Instance.new("UIListLayout", QuickBar)
    BarLayout.FillDirection = Enum.FillDirection.Horizontal
    BarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    BarLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    BarLayout.Padding = UDim.new(0, 5)

    local QuickUpdaters = {}
    local function AddQuickBtn(id, text, accentColor, onClick)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(0, 62, 0, 30)
        Btn.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
        Btn.Text = text
        Btn.Font = Enum.Font.GothamBold
        Btn.TextSize = 9
        Btn.TextColor3 = Color3.fromRGB(225, 225, 240)
        Btn.AutoButtonColor = false
        Btn.Parent = QuickBar
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

        local Stk = Instance.new("UIStroke", Btn)
        Stk.Color = accentColor or Color3.fromRGB(70, 70, 95)
        Stk.Thickness = 1

        local function SetVisual(active)
            TweenService:Create(Btn, TweenInfo.new(0.18), {
                BackgroundColor3 = active and (accentColor or Color3.fromRGB(255, 195, 55)) or Color3.fromRGB(24, 24, 34),
                TextColor3 = active and Color3.fromRGB(12, 12, 16) or Color3.fromRGB(225, 225, 240)
            }):Play()
        end

        Btn.MouseButton1Click:Connect(function()
            local state = onClick()
            if type(state) == "boolean" then
                SetVisual(state)
            else
                SetVisual(true)
                task.delay(0.2, function() SetVisual(false) end)
            end
        end)

        QuickUpdaters[id] = SetVisual
    end

    -- Painel Flutuante de Roles MM2
    local RoleHUD = Instance.new("Frame")
    RoleHUD.Size = UDim2.new(0, 220, 0, 92)
    RoleHUD.Position = UDim2.new(1, -235, 0.32, 0)
    RoleHUD.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
    RoleHUD.BackgroundTransparency = 0.12
    RoleHUD.Visible = false
    RoleHUD.Active = true
    RoleHUD.Draggable = true
    RoleHUD.Parent = YGui
    Instance.new("UICorner", RoleHUD).CornerRadius = UDim.new(0, 10)

    local RoleStroke = Instance.new("UIStroke", RoleHUD)
    RoleStroke.Color = Color3.fromRGB(255, 65, 85)
    RoleStroke.Thickness = 1.3

    local RoleTitle = Instance.new("TextLabel", RoleHUD)
    RoleTitle.Size = UDim2.new(1, -12, 0, 20)
    RoleTitle.Position = UDim2.new(0, 6, 0, 4)
    RoleTitle.BackgroundTransparency = 1
    RoleTitle.Text = "🔪 YARHM MM2 LIVE TRACKER"
    RoleTitle.Font = Enum.Font.GothamBlack
    RoleTitle.TextSize = 11
    RoleTitle.TextColor3 = Color3.fromRGB(255, 205, 65)
    RoleTitle.TextXAlignment = Enum.TextXAlignment.Left

    local RoleBody = Instance.new("TextLabel", RoleHUD)
    RoleBody.Size = UDim2.new(1, -12, 1, -26)
    RoleBody.Position = UDim2.new(0, 6, 0, 24)
    RoleBody.BackgroundTransparency = 1
    RoleBody.Text = "🔪 Murderer: ---\n🔫 Sheriff: ---\n✨ GunDrop: Não"
    RoleBody.Font = Enum.Font.GothamBold
    RoleBody.TextSize = 11
    RoleBody.TextColor3 = Color3.fromRGB(235, 235, 245)
    RoleBody.TextXAlignment = Enum.TextXAlignment.Left
    RoleBody.TextYAlignment = Enum.TextYAlignment.Top

    -- ==========================================================================
    -- 🔪 2. FUNÇÕES NÚCLEO DO MM2 (ROLES, SHOOT MURDERER, GRAB GUN)
    -- ==========================================================================
    local function HasToolKeyword(plr, keywords)
        if not plr then return false, nil end
        local function check(container)
            if not container then return false, nil end
            for _, item in ipairs(container:GetChildren()) do
                if item:IsA("Tool") then
                    local lower = item.Name:lower()
                    for _, kw in ipairs(keywords) do
                        if lower:find(kw) then
                            return true, item
                        end
                    end
                end
            end
            return false, nil
        end
        local ok, tool = check(plr.Character)
        if ok then return true, tool end
        return check(plr:FindFirstChild("Backpack"))
    end

    local function GetMurderer()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local isM, tool = HasToolKeyword(p, {"knife", "faca", "scythe", "blade", "sword", "murder"})
                if isM then return p, tool end
            end
        end
        return nil, nil
    end

    local function GetSheriff()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local isS, tool = HasToolKeyword(p, {"gun", "revolver", "pistol", "sheriff", "laser"})
                if isS then return p, tool end
            end
        end
        return nil, nil
    end

    local function FindGunDrop()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj.Name == "GunDrop" and obj:IsA("BasePart") then
                return obj
            end
        end
        return nil
    end

    local function SafeGrabGun()
        local gunDrop = FindGunDrop()
        local hrp = GetHRP()
        if not gunDrop or not hrp then
            YNotify("YARHM GunTP", "Nenhuma GunDrop caída no mapa agora!")
            return
        end

        if typeof(firetouchinterest) == "function" then
            pcall(function()
                firetouchinterest(hrp, gunDrop, 0)
                task.wait(0.05)
                firetouchinterest(hrp, gunDrop, 1)
            end)
        end

        local oldCF = hrp.CFrame
        hrp.CFrame = gunDrop.CFrame + Vector3.new(0, 1.2, 0)
        task.wait(0.14)
        if hrp and hrp.Parent then
            hrp.CFrame = oldCF
        end
        YNotify("YARHM GunTP", "Arma coletada com segurança!")
    end

    local function ShootMurdererAction()
        local murderer = GetMurderer()
        if not murderer or not murderer.Character then
            YNotify("YARHM Shoot", "Murderer não encontrado na partida!")
            return
        end

        local mHRP = GetHRP(murderer.Character)
        local myChar = GetChar()
        local myHRP = GetHRP(myChar)
        local myHum = GetHum(myChar)
        if not mHRP or not myHRP or not myHum then return end

        local hasGun, gunTool = HasToolKeyword(LocalPlayer, {"gun", "revolver", "pistol", "sheriff", "laser"})
        if not hasGun or not gunTool then
            YNotify("YARHM Shoot", "Você não está com a arma do Sheriff!")
            return
        end

        if gunTool.Parent ~= myChar then
            myHum:EquipTool(gunTool)
            task.wait(0.08)
        end

        local savedCF = myHRP.CFrame
        if Y.MM2_TeleportShoot then
            myHRP.CFrame = mHRP.CFrame * CFrame.new(0, 2, 14)
            task.wait(0.06)
        end

        local predictedPos = mHRP.Position + (mHRP.AssemblyLinearVelocity * Y.MM2_Prediction)
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, predictedPos)
        myHRP.CFrame = CFrame.new(myHRP.Position, Vector3.new(predictedPos.X, myHRP.Position.Y, predictedPos.Z))

        pcall(function()
            local knifeLocal = gunTool:FindFirstChild("KnifeLocal")
            if knifeLocal and knifeLocal:FindFirstChild("CreateBeam") then
                knifeLocal.CreateBeam.RemoteFunction:InvokeServer(1, predictedPos, "AH2")
            end
        end)
        pcall(function()
            gunTool:Activate()
        end)

        if Y.MM2_TeleportShoot then
            task.wait(0.12)
            if myHRP and myHRP.Parent then
                myHRP.CFrame = savedCF
            end
        end
        YNotify("🔫 YARHM Shoot", "Disparo efetuado em " .. murderer.DisplayName .. "!")
    end

    -- ==========================================================================
    -- ⚙️ 3. CONTROLES UNIVERSAIS E BOTÕES DA BARRA RÁPIDA
    -- ==========================================================================
    local AirPart = Instance.new("Part")
    AirPart.Name = "YARHM_AirPad"
    AirPart.Size = Vector3.new(12, 1, 12)
    AirPart.Transparency = 1
    AirPart.Anchored = true
    AirPart.CanCollide = false

    local function ToggleAirWalk(state)
        Y.AirWalk = state
        local hrp = GetHRP()
        if state and hrp then
            Y.AirWalkY = hrp.Position.Y - 3.4
            AirPart.CanCollide = true
            AirPart.Parent = Workspace
        else
            AirPart.CanCollide = false
            AirPart.Parent = nil
        end
        if QuickUpdaters["AirWalk"] then QuickUpdaters["AirWalk"](state) end
    end

    local function ToggleWalkFling(state)
        Y.WalkFling = state
        if QuickUpdaters["Fling"] then QuickUpdaters["Fling"](state) end
        YNotify("🌪️ YARHM WalkFling", state and "Ativado! Encoste para arremessar." or "WalkFling Desativado.")
    end

    local function ToggleNoclip(state)
        Y.Noclip = state
        if QuickUpdaters["Noclip"] then QuickUpdaters["Noclip"](state) end
    end

    AddQuickBtn("Shoot", "🔫 SHOOT", Color3.fromRGB(70, 165, 255), function()
        ShootMurdererAction()
    end)
    AddQuickBtn("GunTP", "⚡ GUN TP", Color3.fromRGB(255, 205, 60), function()
        SafeGrabGun()
    end)
    AddQuickBtn("Fling", "🌪️ FLING", Color3.fromRGB(255, 80, 95), function()
        ToggleWalkFling(not Y.WalkFling)
        return Y.WalkFling
    end)
    AddQuickBtn("AirWalk", "☁️ AIRWALK", Color3.fromRGB(120, 220, 255), function()
        ToggleAirWalk(not Y.AirWalk)
        return Y.AirWalk
    end)
    AddQuickBtn("Noclip", "👻 NOCLIP", Color3.fromRGB(180, 130, 255), function()
        ToggleNoclip(not Y.Noclip)
        return Y.Noclip
    end)
    AddQuickBtn("Escape", "🛡️ ESCAPE", Color3.fromRGB(80, 240, 140), function()
        local hrp = GetHRP()
        if hrp then
            hrp.CFrame = hrp.CFrame + Vector3.new(0, 85, 0)
            YNotify("🛡️ YARHM Escape", "Teleportado para zona segura acima!")
        end
    end)

    -- ==========================================================================
    -- 🔄 4. LOOPS DE MOTOR (STEPPED & HEARTBEAT & SCANNER)
    -- ==========================================================================
    RunService.Stepped:Connect(function()
        local myChar = GetChar()
        if Y.Noclip and myChar then
            for _, p in ipairs(myChar:GetDescendants()) do
                if p:IsA("BasePart") and p.CanCollide then
                    p.CanCollide = false
                end
            end
        end

        if Y.AntiFling then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    for _, p in ipairs(plr.Character:GetChildren()) do
                        if p:IsA("BasePart") then
                            p.CanCollide = false
                            p.AssemblyLinearVelocity = Vector3.zero
                            p.AssemblyAngularVelocity = Vector3.zero
                        end
                    end
                end
            end
        end
    end)

    RunService.Heartbeat:Connect(function()
        local myChar = GetChar()
        local hrp = GetHRP(myChar)
        local hum = GetHum(myChar)
        if not hrp or not hum then return end

        if Y.LoopWS then
            hum.WalkSpeed = Y.WSVal
        elseif Y.FTF_NoSlow and hum.WalkSpeed < 16 then
            hum.WalkSpeed = 16
        end

        if Y.Horror_InfStamina then
            if myChar:GetAttribute("Stamina") then myChar:SetAttribute("Stamina", 100) end
            if LocalPlayer:GetAttribute("Stamina") then LocalPlayer:SetAttribute("Stamina", 100) end
        end

        if Y.VelSpeed and hum.MoveDirection.Magnitude > 0 then
            local v = hrp.AssemblyLinearVelocity
            hrp.AssemblyLinearVelocity = Vector3.new(
                hum.MoveDirection.X * Y.VelSpeedVal,
                v.Y,
                hum.MoveDirection.Z * Y.VelSpeedVal
            )
        end

        if Y.AirWalk then
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                Y.AirWalkY = Y.AirWalkY + 0.45
            elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                Y.AirWalkY = Y.AirWalkY - 0.45
            end
            AirPart.Position = Vector3.new(hrp.Position.X, Y.AirWalkY, hrp.Position.Z)
        end

        if Y.TargetFollow and Y.SelectedTarget and Y.SelectedTarget.Character then
            local tHRP = GetHRP(Y.SelectedTarget.Character)
            if tHRP then
                hrp.CFrame = tHRP.CFrame * CFrame.new(0, 0, 2.5)
            end
        end

        if Y.MM2_KillAura then
            local hasKnife, knife = HasToolKeyword(LocalPlayer, {"knife", "faca", "scythe", "blade"})
            if hasKnife and knife then
                if knife.Parent ~= myChar then hum:EquipTool(knife) end
                local handle = knife:FindFirstChild("Handle")
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character then
                        local tHRP = GetHRP(plr.Character)
                        local tHum = GetHum(plr.Character)
                        if tHRP and tHum and tHum.Health > 0 then
                            if (tHRP.Position - hrp.Position).Magnitude <= Y.MM2_AuraRange then
                                knife:Activate()
                                if handle and typeof(firetouchinterest) == "function" then
                                    pcall(function()
                                        firetouchinterest(tHRP, handle, 0)
                                        firetouchinterest(tHRP, handle, 1)
                                    end)
                                else
                                    tHRP.CFrame = hrp.CFrame * CFrame.new(0, 0, -2)
                                end
                            end
                        end
                    end
                end
            end
        end

        if Y.WalkFling then
            local origV = hrp.AssemblyLinearVelocity
            hrp.AssemblyLinearVelocity = origV * 10000 + Vector3.new(0, 10000, 0)
            RunService.RenderStepped:Wait()
            if hrp and hrp.Parent then
                hrp.AssemblyLinearVelocity = origV
            end
        end
    end)

    task.spawn(function()
        while task.wait(0.5) do
            local myHRP = GetHRP()

            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local tHRP = GetHRP(plr.Character)
                    if tHRP then
                        if Y.HitboxExp then
                            tHRP.Size = Vector3.new(Y.HitboxSize, Y.HitboxSize, Y.HitboxSize)
                            tHRP.Transparency = 0.65
                            tHRP.CanCollide = false
                        elseif tHRP.Size.X > 3 then
                            tHRP.Size = Vector3.new(2, 2, 1)
                            tHRP.Transparency = 1
                        end
                    end
                end
            end

            if Y.InstantPrompts then
                for _, prompt in ipairs(Workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") then
                        prompt.HoldDuration = 0
                    end
                end
            end

            local murderer = GetMurderer()
            local sheriff = GetSheriff()
            local gunDrop = FindGunDrop()

            if Y.MM2_HUD then
                local mName = murderer and murderer.DisplayName or "Nenhum"
                local sName = sheriff and sheriff.DisplayName or "Nenhum"
                local gText = gunDrop and "CAÍDA NO MAPA! ⚡" or "Não"
                RoleBody.Text = string.format("🔪 Murderer: %s\n🔫 Sheriff: %s\n✨ GunDrop: %s", mName, sName, gText)
            end

            if Y.MM2_AutoGrabGun and gunDrop then
                SafeGrabGun()
            end

            if Y.MM2_AntiMurderer and murderer and murderer.Character and myHRP then
                local mHRP = GetHRP(murderer.Character)
                if mHRP and (mHRP.Position - myHRP.Position).Magnitude < 18 then
                    myHRP.CFrame = myHRP.CFrame + Vector3.new(0, 45, 0)
                    YNotify("🛡️ Anti-Murderer", "Murderer chegou perto! Você foi salvo.")
                end
            end

            if Y.MM2_AntiTraps then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj.Name == "Trap" and obj:IsA("BasePart") then
                        obj.CanTouch = false
                        obj.Transparency = 0.8
                    end
                end
            end

            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local hl = plr.Character:FindFirstChild("YARHM_MM2_HL")
                    if Y.MM2_RoleESP then
                        if not hl then
                            hl = Instance.new("Highlight")
                            hl.Name = "YARHM_MM2_HL"
                            hl.FillTransparency = 0.45
                            hl.Parent = plr.Character
                        end
                        if plr == murderer then
                            hl.FillColor = Color3.fromRGB(255, 45, 60)
                        elseif plr == sheriff then
                            hl.FillColor = Color3.fromRGB(45, 145, 255)
                        else
                            hl.FillColor = Color3.fromRGB(60, 235, 115)
                        end
                    elseif hl then
                        hl:Destroy()
                    end
                end
            end

            if gunDrop then
                local ghl = gunDrop:FindFirstChild("YARHM_GunHL")
                if Y.MM2_GunESP then
                    if not ghl then
                        ghl = Instance.new("Highlight")
                        ghl.Name = "YARHM_GunHL"
                        ghl.FillColor = Color3.fromRGB(255, 215, 0)
                        ghl.OutlineColor = Color3.fromRGB(255, 255, 150)
                        ghl.Parent = gunDrop
                    end
                elseif ghl then
                    ghl:Destroy()
                end
            end

            if Y.FTF_NeverFailPC then
                pcall(function()
                    local rem = ReplicatedStorage:FindFirstChild("RemoteEvent")
                    if rem then
                        rem:FireServer("SetPlayerMinigameResult", true)
                    end
                end)
            end

            if Y.FTF_PCESP or Y.FTF_PodExitESP or Y.Horror_GenESP then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if Y.FTF_PCESP and obj.Name == "ComputerTable" and obj:IsA("Model") then
                        local hl = obj:FindFirstChild("YARHM_PC_HL")
                        if not hl then
                            hl = Instance.new("Highlight", obj)
                            hl.Name = "YARHM_PC_HL"
                            hl.FillTransparency = 0.4
                        end
                        local scr = obj:FindFirstChild("Screen")
                        hl.FillColor = (scr and scr:IsA("BasePart") and scr.Color) or Color3.fromRGB(0, 200, 255)
                    end

                    if Y.FTF_PodExitESP and (obj.Name == "FreezePod" or obj.Name == "ExitDoor") and obj:IsA("Model") then
                        if not obj:FindFirstChild("YARHM_Pod_HL") then
                            local hl = Instance.new("Highlight", obj)
                            hl.Name = "YARHM_Pod_HL"
                            hl.FillColor = (obj.Name == "FreezePod") and Color3.fromRGB(80, 180, 255) or Color3.fromRGB(255, 220, 60)
                        end
                    end

                    if Y.Horror_GenESP and obj:IsA("Model") and obj.Name:lower():find("generator") then
                        if not obj:FindFirstChild("YARHM_Gen_HL") then
                            local hl = Instance.new("Highlight", obj)
                            hl.Name = "YARHM_Gen_HL"
                            hl.FillColor = Color3.fromRGB(180, 90, 255)
                        end
                    end
                end
            end

            if Y.FTF_BeastESP then
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character then
                        local isBeast = plr.Character:FindFirstChild("Hammer") or plr.Character:FindFirstChild("BeastPowers")
                        local bhl = plr.Character:FindFirstChild("YARHM_Beast_HL")
                        if isBeast then
                            if not bhl then
                                bhl = Instance.new("Highlight", plr.Character)
                                bhl.Name = "YARHM_Beast_HL"
                                bhl.FillColor = Color3.fromRGB(255, 0, 40)
                            end
                        elseif bhl then
                            bhl:Destroy()
                        end
                    end
                end
            end
        end
    end)

    task.spawn(function()
        while task.wait(0.35) do
            if Y.MM2_CoinFarm then
                local hrp = GetHRP()
                if hrp then
                    local closestCoin = nil
                    local minDist = 250
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if (obj.Name == "Coin_Server" or obj.Name == "Coin") and obj:IsA("BasePart") then
                            local d = (obj.Position - hrp.Position).Magnitude
                            if d < minDist then
                                minDist = d
                                closestCoin = obj
                            end
                        end
                    end

                    if closestCoin then
                        local duration = math.clamp(minDist / 24, 0.15, 2.2)
                        local tw = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
                            CFrame = CFrame.new(closestCoin.Position)
                        })
                        tw:Play()
                        tw.Completed:Wait()
                    end
                end
            end
        end
    end)

    -- ==========================================================================
    -- 🖥️ ABA 1: 👑 YARHM UNIVERSAL
    -- ==========================================================================
    TabUniv:CreateSection("📌 YARHM Floating Quick-Bar (Botões na Tela)")

    TabUniv:CreateToggle("Mostrar Barra de Botões Flutuantes YARHM", true, function(s)
        QuickBar.Visible = s
    end)

    TabUniv:CreateSection("🌪️ Fling & Anti-Fling Físico (YARHM Core)")

    TabUniv:CreateToggle("YARHM WalkFling (Arremessar ao Encostar)", false, function(s)
        ToggleWalkFling(s)
    end)

    TabUniv:CreateToggle("YARHM Anti-Fling 100% (Imune a Fling/Colisão)", false, function(s)
        Y.AntiFling = s
        YNotify("🛡️ YARHM Anti-Fling", s and "Colisões de terceiros neutralizadas!" or "Anti-Fling Desativado.")
    end)

    TabUniv:CreateSection("🏃 Movimento Universal & Utilidades")

    TabUniv:CreateToggle("YARHM AirWalk (Espaço Sobe / Shift Desce)", false, function(s)
        ToggleAirWalk(s)
    end)

    TabUniv:CreateToggle("Noclip Físico Contínuo", false, function(s)
        ToggleNoclip(s)
    end)

    TabUniv:CreateToggle("Velocity Speed Boost (Anti-Rubberband)", false, function(s)
        Y.VelSpeed = s
    end)

    TabUniv:CreateSlider("Potência do Velocity Speed", 20, 120, 40, function(v)
        Y.VelSpeedVal = v
    end)

    TabUniv:CreateToggle("Travar WalkSpeed (Loop WalkSpeed)", false, function(s)
        Y.LoopWS = s
    end)

    TabUniv:CreateSlider("Valor do WalkSpeed Travado", 16, 150, 32, function(v)
        Y.WSVal = v
    end)

    TabUniv:CreateToggle("Instant ProximityPrompts (Interagir em 0s)", false, function(s)
        Y.InstantPrompts = s
    end)

    TabUniv:CreateToggle("Hitbox Expander Universal", false, function(s)
        Y.HitboxExp = s
    end)

    TabUniv:CreateSlider("Tamanho da Hitbox", 4, 30, 10, function(v)
        Y.HitboxSize = v
    end)

    TabUniv:CreateSection("🎯 Target Controller (Selecionar / Spectate / Fling)")

    local tIdx = 1
    local function NextTarget()
        local list = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(list, p) end
        end
        if #list == 0 then
            YNotify("🎯 Alvo YARHM", "Nenhum outro jogador na sala!")
            return
        end
        tIdx = (tIdx % #list) + 1
        Y.SelectedTarget = list[tIdx]
        YNotify("🎯 Alvo Selecionado", Y.SelectedTarget.DisplayName .. " (@" .. Y.SelectedTarget.Name .. ")")
    end

    TabUniv:CreateButton("🔄 Selecionar Próximo Jogador da Sala", function()
        NextTarget()
    end)

    TabUniv:CreateToggle("👁️ Spectate Jogador Selecionado", false, function(s)
        Y.Spectating = s
        if s then
            if not Y.SelectedTarget then NextTarget() end
            if Y.SelectedTarget and Y.SelectedTarget.Character then
                Camera.CameraSubject = GetHum(Y.SelectedTarget.Character)
            end
        else
            if GetHum() then Camera.CameraSubject = GetHum() end
        end
    end)

    TabUniv:CreateButton("⚡ Teleportar no Alvo Selecionado", function()
        if not Y.SelectedTarget then NextTarget() end
        if Y.SelectedTarget and Y.SelectedTarget.Character and GetHRP() and GetHRP(Y.SelectedTarget.Character) then
            GetHRP().CFrame = GetHRP(Y.SelectedTarget.Character).CFrame * CFrame.new(0, 0, 3)
        end
    end)

    TabUniv:CreateToggle("🔗 Loop Teleport / Grudar no Alvo", false, function(s)
        if s and not Y.SelectedTarget then NextTarget() end
        Y.TargetFollow = s
    end)

    TabUniv:CreateButton("🌪️ Fling Focado no Alvo (Arremessar e Voltar)", function()
        if not Y.SelectedTarget then NextTarget() end
        local t = Y.SelectedTarget
        local myHRP = GetHRP()
        if t and t.Character and GetHRP(t.Character) and myHRP then
            local saved = myHRP.CFrame
            YNotify("🌪️ Target Fling", "Atacando " .. t.DisplayName .. "...")
            ToggleWalkFling(true)
            local st = tick()
            while tick() - st < 1.3 and t.Character and GetHRP(t.Character) do
                myHRP.CFrame = GetHRP(t.Character).CFrame
                task.wait()
            end
            ToggleWalkFling(false)
            myHRP.AssemblyLinearVelocity = Vector3.zero
            myHRP.CFrame = saved
            YNotify("🌪️ Target Fling", "Alvo arremessado e posição restaurada!")
        end
    end)

    -- ==========================================================================
    -- 🖥️ ABA 2: 🔪 YARHM MM2 (MURDER MYSTERY 2 COMPLETO)
    -- ==========================================================================
    TabMM2:CreateSection("👁️ YARHM MM2 ESP & Live Role Tracker")

    TabMM2:CreateToggle("Role ESP (Murderer=Vermelho | Sheriff=Azul | Inocente=Verde)", false, function(s)
        Y.MM2_RoleESP = s
    end)

    TabMM2:CreateToggle("GunDrop ESP (Destacar Arma Caída em Dourado)", false, function(s)
        Y.MM2_GunESP = s
    end)

    TabMM2:CreateToggle("Mostrar Painel Flutuante Live Tracker (Murderer/Sheriff)", false, function(s)
        Y.MM2_HUD = s
        RoleHUD.Visible = s
    end)

    TabMM2:CreateSection("🔫 Sheriff Functions (Shoot Murderer & Grab Gun)")

    TabMM2:CreateButton("🔫 Shoot Murderer Agora (Atirar no Murderer com Predição)", function()
        ShootMurdererAction()
    end)

    TabMM2:CreateToggle("TP Shoot (Teleportar p/ Linha de Tiro Limpa ao Atirar)", false, function(s)
        Y.MM2_TeleportShoot = s
    end)

    TabMM2:CreateSlider("Predição do Tiro (Ping Offset %)", 0, 40, 16, function(v)
        Y.MM2_Prediction = v / 100
    end)

    TabMM2:CreateButton("⚡ Safe Grab Gun (Pegar Arma Caída e Voltar)", function()
        SafeGrabGun()
    end)

    TabMM2:CreateToggle("Auto-Grab Gun (Pegar Automaticamente Quando Cair)", false, function(s)
        Y.MM2_AutoGrabGun = s
    end)

    TabMM2:CreateSection("🔪 Murderer Functions (Kill All & Knife Aura)")

    TabMM2:CreateToggle("Knife Kill Aura / Reach (Matar Automaticamente Perto)", false, function(s)
        Y.MM2_KillAura = s
    end)

    TabMM2:CreateSlider("Alcance da Knife Aura (Studs)", 8, 35, 18, function(v)
        Y.MM2_AuraRange = v
    end)

    TabMM2:CreateButton("💀 Murderer Kill All (Eliminar Todos da Partida)", function()
        local hasKnife, knife = HasToolKeyword(LocalPlayer, {"knife", "faca", "scythe", "blade"})
        local myChar = GetChar()
        local myHRP = GetHRP(myChar)
        local myHum = GetHum(myChar)
        if not hasKnife or not knife or not myHRP or not myHum then
            YNotify("YARHM MM2", "Você precisa ser o Murderer para usar Kill All!")
            return
        end
        if knife.Parent ~= myChar then myHum:EquipTool(knife) end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and GetHRP(plr.Character) then
                local tHum = GetHum(plr.Character)
                if tHum and tHum.Health > 0 then
                    myHRP.CFrame = GetHRP(plr.Character).CFrame * CFrame.new(0, 0, 1.5)
                    knife:Activate()
                    task.wait(0.18)
                end
            end
        end
    end)

    TabMM2:CreateSection("🪙 Auto-Farm de Moedas & Sobrevivência")

    TabMM2:CreateToggle("Auto-Farm Coins (Tween Suave Anti-Kick)", false, function(s)
        Y.MM2_CoinFarm = s
        if s then ToggleNoclip(true) end
    end)

    TabMM2:CreateToggle("Auto-Dodge Anti-Murderer (Fugir se o Murderer Encostar)", false, function(s)
        Y.MM2_AntiMurderer = s
    end)

    TabMM2:CreateToggle("Anti-Trap (Desativar Armadilhas do Murderer)", false, function(s)
        Y.MM2_AntiTraps = s
    end)

    TabMM2:CreateButton("🏛️ Teleportar para o Lobby Seguro", function()
        local hrp = GetHRP()
        if hrp then hrp.CFrame = CFrame.new(-108, 138, 37) end
    end)

    -- ==========================================================================
    -- 🖥️ ABA 3: 🔨 YARHM FTF & HORROR (FLEE THE FACILITY + FORSAKEN)
    -- ==========================================================================
    TabFTF:CreateSection("💻 Flee the Facility (ESP & Hacks)")

    TabFTF:CreateToggle("ESP Computadores (Mostra Cor se Já Foi Hackeado)", false, function(s)
        Y.FTF_PCESP = s
    end)

    TabFTF:CreateToggle("ESP da Fera (Beast ESP Vermelho)", false, function(s)
        Y.FTF_BeastESP = s
    end)

    TabFTF:CreateToggle("ESP Cápsulas de Gelo (FreezePods) & Portas de Saída", false, function(s)
        Y.FTF_PodExitESP = s
    end)

    TabFTF:CreateToggle("⚡ Never Fail PC Hack (Nunca Errar Skillcheck do PC)", false, function(s)
        Y.FTF_NeverFailPC = s
    end)

    TabFTF:CreateToggle("🏃 No Beast Slowdown (Sem Lentidão ao Bater/Pular)", false, function(s)
        Y.FTF_NoSlow = s
    end)

    TabFTF:CreateSection("👻 Forsaken & Survival Horror Universal")

    TabFTF:CreateToggle("ESP de Geradores / Objetivos no Mapa", false, function(s)
        Y.Horror_GenESP = s
    end)

    TabFTF:CreateToggle("Infinite Stamina (Travar Estamina no Máximo)", false, function(s)
        Y.Horror_InfStamina = s
    end)
end