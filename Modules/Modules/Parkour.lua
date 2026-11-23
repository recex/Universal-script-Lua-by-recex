--[[
    RECEX HUB - MODULE: PARKOUR, GRAPPLING HOOK 3D & HOVERBOARD
    made by recex
]]

return function(Hub, Tabs)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    local Mouse = LocalPlayer:GetMouse()

    local ParkourTab = Hub:CreateTab("🛹 Parkour 3D")

    local GadgetFolder = Camera:FindFirstChild("RecexGadgets3D") or Instance.new("Folder")
    GadgetFolder.Name = "RecexGadgets3D"
    GadgetFolder.Parent = Camera

    local function GetRoot()
        return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    end

    local function GetHum()
        return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    end

    local function SpawnRing(pos, color, size)
        local ring = Instance.new("Part")
        ring.Shape = Enum.PartType.Cylinder
        ring.Material = Enum.Material.Neon
        ring.Color = color or Color3.fromRGB(245, 195, 70)
        ring.Anchored = true
        ring.CanCollide = false
        ring.Size = Vector3.new(0.2, 2, 2)
        ring.CFrame = CFrame.new(pos) * CFrame.Angles(0, 0, math.rad(90))
        ring.Parent = GadgetFolder
        TweenService:Create(ring, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = Vector3.new(0.05, size or 12, size or 12),
            Transparency = 1
        }):Play()
        task.delay(0.45, function()
            if ring and ring.Parent then ring:Destroy() end
        end)
    end

    -- =========================================================================
    -- 1. RECEX GRAPPLING HOOK 3D (ARPÉU ESTILO SPIDER-MAN / AOT)
    -- =========================================================================
    ParkourTab:AddSection("Gadgets Exclusivos 3D")

    ParkourTab:AddButton("1. Recex Arpéu 3D (Grappling Hook Tool)", "Equipa um gancho laser que puxa você até onde mirar", function()
        local Backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
        if not Backpack then return end

        local Tool = Instance.new("Tool")
        Tool.Name = "Recex Grapple 3D"
        Tool.RequiresHandle = false
        Tool.Parent = Backpack

        local GrappleActive = false
        local TargetPos = nil
        local RopePart = nil

        Tool.Activated:Connect(function()
            local root = GetRoot()
            if not root or not Mouse.Hit then return end

            TargetPos = Mouse.Hit.Position
            GrappleActive = true
            SpawnRing(TargetPos, Color3.fromRGB(245, 195, 70), 10)

            if RopePart then RopePart:Destroy() end
            RopePart = Instance.new("Part")
            RopePart.Anchored = true
            RopePart.CanCollide = false
            RopePart.Material = Enum.Material.Neon
            RopePart.Color = Color3.fromRGB(245, 195, 70)
            RopePart.Parent = GadgetFolder
        end)

        Tool.Deactivated:Connect(function()
            GrappleActive = false
            if RopePart then RopePart:Destroy() RopePart = nil end
        end)

        Tool.Unequipped:Connect(function()
            GrappleActive = false
            if RopePart then RopePart:Destroy() RopePart = nil end
        end)

        RunService.RenderStepped:Connect(function()
            local root = GetRoot()
            if GrappleActive and root and TargetPos and Tool.Parent == LocalPlayer.Character then
                local diff = (TargetPos - root.Position)
                local dist = diff.Magnitude

                if dist > 6 then
                    root.AssemblyLinearVelocity = diff.Unit * 135 + Vector3.new(0, 18, 0)
                    if RopePart then
                        RopePart.Size = Vector3.new(0.22, 0.22, dist)
                        RopePart.CFrame = CFrame.lookAt(root.Position, TargetPos) * CFrame.new(0, 0, -dist / 2)
                    end
                else
                    GrappleActive = false
                    if RopePart then RopePart:Destroy() RopePart = nil end
                end
            end
        end)

        Hub.Notify("Arpéu 3D Criado!", "Segure o clique com o 'Recex Grapple 3D' na mão para voar no cabo!", 4)
    end)

    -- =========================================================================
    -- 2. RECEX HOVERBOARD NEON 3D (PRANCHA FLUTUANTE PILOTÁVEL)
    -- =========================================================================
    local HoverboardActive = false
    local HoverboardSpeed = 85
    local BoardPart = nil

    ParkourTab:AddToggle("2. Recex Hoverboard Neon 3D", "Invoca uma prancha futurista 3D que desliza em alta velocidade", false, function(state)
        HoverboardActive = state
        if BoardPart then BoardPart:Destroy() BoardPart = nil end

        if state then
            BoardPart = Instance.new("Part")
            BoardPart.Name = "RecexHoverboard"
            BoardPart.Size = Vector3.new(2.8, 0.35, 6.2)
            BoardPart.Material = Enum.Material.Neon
            BoardPart.Color = Color3.fromRGB(165, 95, 255)
            BoardPart.Anchored = true
            BoardPart.CanCollide = false
            BoardPart.Parent = GadgetFolder

            local InnerDeck = Instance.new("Part")
            InnerDeck.Size = Vector3.new(2.3, 0.42, 5.6)
            InnerDeck.Material = Enum.Material.SmoothPlastic
            InnerDeck.Color = Color3.fromRGB(16, 18, 26)
            InnerDeck.Anchored = true
            InnerDeck.CanCollide = false
            InnerDeck.Parent = BoardPart

            Hub.Notify("Hoverboard 3D", "Use W, A, S, D para pilotar sua prancha!", 3)
        end
    end)

    ParkourTab:AddSlider("Velocidade do Hoverboard", 40, 220, 85, function(val)
        HoverboardSpeed = val
    end)

    -- =========================================================================
    -- 3. RECEX JETPACK ASTRAL (PROPULSOR NO ESPAÇO)
    -- =========================================================================
    local JetpackActive = false
    local JetpackPower = 55
    local LastJetRing = 0

    ParkourTab:AddToggle("3. Recex Jetpack Astral (Segurar Espaço)", "Segure Espaço para subir voando com anéis de propulsão", false, function(state)
        JetpackActive = state
    end)

    ParkourTab:AddSlider("Potência do Jetpack", 30, 140, 55, function(val)
        JetpackPower = val
    end)

    -- =========================================================================
    -- 4. ACROBACIAS & MOVIMENTAÇÃO PARKOUR
    -- =========================================================================
    ParkourTab:AddSection("Acrobacias & Movimentação")

    local FlipJumpEnabled = false
    ParkourTab:AddToggle("4. Pulo Duplo Acrobático (Mortal 360°)", "Aperte Espaço no ar para dar um mortal 360° com impulso", false, function(state)
        FlipJumpEnabled = state
    end)

    local SlideEnabled = false
    ParkourTab:AddToggle("5. Parkour Slide Deslizante (Tecla V)", "Aperte V correndo para dar um carrinho veloz pelo chão", false, function(state)
        SlideEnabled = state
    end)

    local BouncePadEnabled = false
    local BouncePadPart = nil
    ParkourTab:AddToggle("6. Criar Trampolim Astral no Chão", "Coloca um trampolim dourado onde você está que lança a 200m", false, function(state)
        BouncePadEnabled = state
        if BouncePadPart then BouncePadPart:Destroy() BouncePadPart = nil end
        local root = GetRoot()
        if state and root then
            BouncePadPart = Instance.new("Part")
            BouncePadPart.Shape = Enum.PartType.Cylinder
            BouncePadPart.Size = Vector3.new(0.6, 9, 9)
            BouncePadPart.Material = Enum.Material.Neon
            BouncePadPart.Color = Color3.fromRGB(245, 195, 70)
            BouncePadPart.Anchored = true
            BouncePadPart.CanCollide = false
            BouncePadPart.CFrame = CFrame.new(root.Position - Vector3.new(0, 2.8, 0)) * CFrame.Angles(0, 0, math.rad(90))
            BouncePadPart.Parent = GadgetFolder
            Hub.Notify("Trampolim Criado!", "Pise no círculo dourado para ser lançado ao céu!", 3)
        end
    end)

    local WaterWalkEnabled = false
    local WaterPlatform = nil
    ParkourTab:AddToggle("7. Jesus Walk (Correr Sobre a Água/Ar)", "Mantém um piso invisível nivelado na altura inicial dos seus pés", false, function(state)
        WaterWalkEnabled = state
        if WaterPlatform then WaterPlatform:Destroy() WaterPlatform = nil end
        local root = GetRoot()
        if state and root then
            WaterPlatform = Instance.new("Part")
            WaterPlatform.Size = Vector3.new(14, 1, 14)
            WaterPlatform.Transparency = 0.75
            WaterPlatform.Material = Enum.Material.Glass
            WaterPlatform.Color = Color3.fromRGB(90, 200, 255)
            WaterPlatform.Anchored = true
            WaterPlatform.Parent = GadgetFolder
            WaterPlatform.Position = Vector3.new(root.Position.X, root.Position.Y - 3.5, root.Position.Z)
        end
    end)

    -- =========================================================================
    -- EVENTOS DE TECLADO & FÍSICA DO PARKOUR
    -- =========================================================================
    local IsFlipping = false

    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        local root = GetRoot()
        local hum = GetHum()
        if not root or not hum then return end

        -- Pulo Duplo Acrobático (Mortal 360°)
        if input.KeyCode == Enum.KeyCode.Space and FlipJumpEnabled and hum.FloorMaterial == Enum.Material.Air and not IsFlipping then
            IsFlipping = true
            SpawnRing(root.Position - Vector3.new(0, 2.5, 0), Color3.fromRGB(165, 95, 255), 11)
            root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 68, root.AssemblyLinearVelocity.Z)
            task.spawn(function()
                for i = 1, 12 do
                    if root then
                        root.CFrame = root.CFrame * CFrame.Angles(math.rad(-30), 0, 0)
                    end
                    RunService.RenderStepped:Wait()
                end
                IsFlipping = false
            end)
        end

        -- Parkour Slide (Tecla V)
        if input.KeyCode == Enum.KeyCode.V and SlideEnabled then
            local dir = hum.MoveDirection.Magnitude > 0 and hum.MoveDirection or root.CFrame.LookVector
            SpawnRing(root.Position - Vector3.new(0, 2.5, 0), Color3.fromRGB(245, 195, 70), 9)
            root.AssemblyLinearVelocity = dir * 130 + Vector3.new(0, 8, 0)
        end
    end)

    RunService.RenderStepped:Connect(function()
        local root = GetRoot()
        local hum = GetHum()
        if not root or not hum then return end

        -- Física do Hoverboard 3D
        if HoverboardActive and BoardPart then
            local moveDir = hum.MoveDirection
            local targetCF = CFrame.new(root.Position - Vector3.new(0, 3.1, 0), root.Position - Vector3.new(0, 3.1, 0) + root.CFrame.LookVector)
            BoardPart.CFrame = targetCF
            local inner = BoardPart:FindFirstChildOfClass("Part")
            if inner then
                inner.CFrame = targetCF * CFrame.new(0, 0.05, 0)
            end
            if moveDir.Magnitude > 0 then
                root.AssemblyLinearVelocity = Vector3.new(moveDir.X * HoverboardSpeed, root.AssemblyLinearVelocity.Y, moveDir.Z * HoverboardSpeed)
            end
        end

        -- Física do Jetpack Astral
        if JetpackActive and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, JetpackPower, root.AssemblyLinearVelocity.Z)
            if tick() - LastJetRing > 0.16 then
                LastJetRing = tick()
                SpawnRing(root.Position - Vector3.new(0, 3, 0), Color3.fromRGB(245, 195, 70), 7)
            end
        end

        -- Física do Trampolim Astral
        if BouncePadEnabled and BouncePadPart then
            if (root.Position - BouncePadPart.Position).Magnitude < 5.5 then
                root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 165, root.AssemblyLinearVelocity.Z)
                SpawnRing(BouncePadPart.Position, Color3.fromRGB(165, 95, 255), 18)
            end
        end

        -- Física do Jesus Walk
        if WaterWalkEnabled and WaterPlatform then
            WaterPlatform.Position = Vector3.new(root.Position.X, WaterPlatform.Position.Y, root.Position.Z)
        end
    end)
end