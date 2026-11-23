--[[
    RECEX HUB - MODULE: VEHICLE MODS, CAR FLY & CYBER-MOTO 3D
    made by recex
]]

return function(Hub, Tabs)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera

    local VehicleTab = Hub:CreateTab("🏎️ Veículos 3D")

    local VehicleFolder = Camera:FindFirstChild("RecexVehicles3D") or Instance.new("Folder")
    VehicleFolder.Name = "RecexVehicles3D"
    VehicleFolder.Parent = Camera

    local function GetRoot()
        return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    end

    local function GetHum()
        return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    end

    local function GetCurrentSeat()
        local hum = GetHum()
        if hum and hum.SeatPart then
            return hum.SeatPart
        end
        return nil
    end

    -- =========================================================================
    -- 1. MODIFICAÇÕES UNIVERSAIS DE VEÍCULOS (CARROS, BARCOS E MOTOS)
    -- =========================================================================
    VehicleTab:AddSection("Modificações de Veículos (Qualquer Jogo)")

    local VehicleFlyEnabled = false
    local VehicleFlySpeed = 110

    VehicleTab:AddToggle("1. Vehicle Fly (Voar com Qualquer Carro/Barco)", "Sente no veículo e use W,A,S,D para voar com ele pelo céu", false, function(state)
        VehicleFlyEnabled = state
        if state then
            Hub.Notify("Vehicle Fly", "Sente em qualquer banco de motorista para voar!", 3)
        end
    end)

    VehicleTab:AddSlider("Velocidade do Voo de Veículo", 40, 350, 110, function(val)
        VehicleFlySpeed = val
    end)

    local NitroEnabled = false
    local NitroPower = 160

    VehicleTab:AddToggle("2. Nitro Boost (Segure Shift ou W)", "Multiplica a velocidade e arrancada de qualquer carro/barco", false, function(state)
        NitroEnabled = state
    end)

    VehicleTab:AddSlider("Potência do Nitro", 60, 400, 160, function(val)
        NitroPower = val
    end)

    local CarJumpEnabled = false
    VehicleTab:AddToggle("3. Suspensão Hidráulica / Pulo (Tecla Espaço)", "Permite pular com o carro por cima de muros e obstáculos", false, function(state)
        CarJumpEnabled = state
    end)

    local UnderglowEnabled = false
    local UnderglowPart = nil
    VehicleTab:AddToggle("4. Neon Underglow 3D (Luz Embaixo do Carro)", "Instala um kit de iluminação Neon RGB embaixo do seu veículo", false, function(state)
        UnderglowEnabled = state
        if UnderglowPart then UnderglowPart:Destroy() UnderglowPart = nil end
        if state then
            UnderglowPart = Instance.new("Part")
            UnderglowPart.Name = "RecexUnderglow"
            UnderglowPart.Size = Vector3.new(6, 0.25, 11)
            UnderglowPart.Material = Enum.Material.Neon
            UnderglowPart.Color = Color3.fromRGB(245, 195, 70)
            UnderglowPart.Transparency = 0.2
            UnderglowPart.Anchored = true
            UnderglowPart.CanCollide = false
            UnderglowPart.Parent = VehicleFolder

            local light = Instance.new("PointLight")
            light.Range = 28
            light.Brightness = 3.5
            light.Color = Color3.fromRGB(245, 195, 70)
            light.Parent = UnderglowPart
        end
    end)

    local CarNoclipEnabled = false
    VehicleTab:AddToggle("5. Car Noclip (Atravessar Paredes de Carro)", "Desativa a colisão do veículo para varar prédios e pedágios", false, function(state)
        CarNoclipEnabled = state
    end)

    -- =========================================================================
    -- 2. GERADOR EXCLUSIVO: CYBER-MOTO 3D DA RECEX
    -- =========================================================================
    VehicleTab:AddSection("Garagem Exclusiva 3D (made by recex)")

    local CyberBikeActive = false
    local CyberBikeSpeed = 125
    local BikeModel = nil

    VehicleTab:AddToggle("6. Invocar Recex Cyber-Moto 3D (Tron Bike)", "Constrói uma moto futurista 3D dourada/violeta no seu personagem", false, function(state)
        CyberBikeActive = state
        if BikeModel then BikeModel:Destroy() BikeModel = nil end
        local hum = GetHum()
        if not state and hum then hum.Sit = false return end

        if state then
            BikeModel = Instance.new("Model")
            BikeModel.Name = "RecexCyberBike3D"
            BikeModel.Parent = VehicleFolder

            -- Chassi Central
            local Chassis = Instance.new("Part")
            Chassis.Name = "Chassis"
            Chassis.Size = Vector3.new(1.6, 1.8, 5.5)
            Chassis.Material = Enum.Material.SmoothPlastic
            Chassis.Color = Color3.fromRGB(16, 18, 25)
            Chassis.Anchored = true
            Chassis.CanCollide = false
            Chassis.Parent = BikeModel

            -- Faixa Neon Dourada
            local NeonTrim = Instance.new("Part")
            NeonTrim.Name = "NeonTrim"
            NeonTrim.Size = Vector3.new(1.75, 0.4, 5.7)
            NeonTrim.Material = Enum.Material.Neon
            NeonTrim.Color = Color3.fromRGB(245, 195, 70)
            NeonTrim.Anchored = true
            NeonTrim.CanCollide = false
            NeonTrim.Parent = BikeModel

            -- Roda Dianteira Neon
            local FrontWheel = Instance.new("Part")
            FrontWheel.Name = "FrontWheel"
            FrontWheel.Shape = Enum.PartType.Cylinder
            FrontWheel.Size = Vector3.new(1.2, 3.2, 3.2)
            FrontWheel.Material = Enum.Material.Neon
            FrontWheel.Color = Color3.fromRGB(165, 95, 255)
            FrontWheel.Anchored = true
            FrontWheel.CanCollide = false
            FrontWheel.Parent = BikeModel

            -- Roda Traseira Neon
            local BackWheel = FrontWheel:Clone()
            BackWheel.Name = "BackWheel"
            BackWheel.Color = Color3.fromRGB(245, 195, 70)
            BackWheel.Parent = BikeModel

            Hub.Notify("Cyber-Moto 3D", "Sua moto futurista foi invocada! Use W, A, S, D para acelerar.", 3)
        end
    end)

    VehicleTab:AddSlider("Velocidade da Cyber-Moto 3D", 50, 260, 125, function(val)
        CyberBikeSpeed = val
    end)

    VehicleTab:AddButton("🔓 Destrancar / Sentar no Carro Mais Próximo", "Encontra o banco de motorista mais perto no mapa e senta nele", function()
        local root = GetRoot()
        local hum = GetHum()
        if not root or not hum then return end

        local closestSeat, minDist = nil, math.huge
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("VehicleSeat") and not v.Occupant then
                local d = (v.Position - root.Position).Magnitude
                if d < minDist then
                    minDist = d
                    closestSeat = v
                end
            end
        end

        if closestSeat then
            closestSeat.Disabled = false
            root.CFrame = closestSeat.CFrame + Vector3.new(0, 2, 0)
            task.wait(0.1)
            closestSeat:Sit(hum)
            Hub.Notify("Carro Encontrado!", "Você assumiu o volante do veículo mais próximo!", 3)
        else
            Hub.Notify("Aviso", "Nenhum banco de motorista livre encontrado por perto.", 3)
        end
    end)

    -- =========================================================================
    -- LOOP DE FÍSICA DOS VEÍCULOS & CYBER-MOTO 3D
    -- =========================================================================
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.Space and CarJumpEnabled then
            local seat = GetCurrentSeat()
            if seat then
                seat.AssemblyLinearVelocity = seat.AssemblyLinearVelocity + Vector3.new(0, 75, 0)
            end
        end
    end)

    RunService.RenderStepped:Connect(function()
        local root = GetRoot()
        local hum = GetHum()
        if not root or not hum then return end

        local seat = GetCurrentSeat()

        -- 1. Voo de Veículo (Vehicle Fly)
        if VehicleFlyEnabled and seat then
            local camCF = Camera.CFrame
            local moveDir = hum.MoveDirection
            if moveDir.Magnitude > 0 then
                seat.AssemblyLinearVelocity = (camCF.LookVector * -moveDir.Z + camCF.RightVector * moveDir.X).Unit * VehicleFlySpeed
            else
                seat.AssemblyLinearVelocity = Vector3.new(0, 2, 0)
            end
            seat.AssemblyAngularVelocity = Vector3.zero
            seat.CFrame = CFrame.new(seat.Position, seat.Position + camCF.LookVector)
        end

        -- 2. Nitro Boost
        if NitroEnabled and seat and hum.MoveDirection.Magnitude > 0 then
            seat.AssemblyLinearVelocity = seat.CFrame.LookVector * NitroPower + Vector3.new(0, seat.AssemblyLinearVelocity.Y, 0)
        end

        -- 3. Neon Underglow 3D
        if UnderglowEnabled and UnderglowPart then
            local targetPart = seat or root
            local hue = (tick() * 0.25) % 1
            local col = Color3.fromHSV(hue, 0.85, 1)
            UnderglowPart.Color = col
            local pl = UnderglowPart:FindFirstChildOfClass("PointLight")
            if pl then pl.Color = col end
            UnderglowPart.CFrame = targetPart.CFrame * CFrame.new(0, -2.8, 0)
        end

        -- 4. Car Noclip
        if CarNoclipEnabled and seat and seat.Parent then
            for _, p in ipairs(seat.Parent:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanCollide = false
                end
            end
        end

        -- 5. Recex Cyber-Moto 3D
        if CyberBikeActive and BikeModel then
            local chassis = BikeModel:FindFirstChild("Chassis")
            local trim = BikeModel:FindFirstChild("NeonTrim")
            local fWheel = BikeModel:FindFirstChild("FrontWheel")
            local bWheel = BikeModel:FindFirstChild("BackWheel")

            if chassis and trim and fWheel and bWheel then
                local baseCF = root.CFrame * CFrame.new(0, -1.8, 0)
                chassis.CFrame = baseCF
                trim.CFrame = baseCF * CFrame.new(0, 0.3, 0)
                fWheel.CFrame = baseCF * CFrame.new(0, -0.6, -2.6) * CFrame.Angles(0, math.rad(90), 0)
                bWheel.CFrame = baseCF * CFrame.new(0, -0.6, 2.6) * CFrame.Angles(0, math.rad(90), 0)

                if hum.MoveDirection.Magnitude > 0 then
                    root.AssemblyLinearVelocity = Vector3.new(
                        hum.MoveDirection.X * CyberBikeSpeed,
                        root.AssemblyLinearVelocity.Y,
                        hum.MoveDirection.Z * CyberBikeSpeed
                    )
                end
            end
        end
    end)
end