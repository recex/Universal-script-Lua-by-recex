--[[
    RECEX HUB - MODULE: DRONE FREECAM & 3D WAYPOINTS MANAGER
    made by recex
]]

return function(Hub, Tabs)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera

    local WaypointsTab = Hub:CreateTab("📍 Drone & TP")

    local BeaconFolder = Camera:FindFirstChild("RecexWaypoints3D") or Instance.new("Folder")
    BeaconFolder.Name = "RecexWaypoints3D"
    BeaconFolder.Parent = Camera

    local function GetRoot(plr)
        plr = plr or LocalPlayer
        return plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    end

    local function GetHum(plr)
        plr = plr or LocalPlayer
        return plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
    end

    local function SpawnTPFlash(pos)
        local sphere = Instance.new("Part")
        sphere.Shape = Enum.PartType.Ball
        sphere.Material = Enum.Material.Neon
        sphere.Color = Color3.fromRGB(245, 195, 70)
        sphere.Size = Vector3.new(2, 2, 2)
        sphere.Position = pos
        sphere.Anchored = true
        sphere.CanCollide = false
        sphere.Parent = BeaconFolder
        TweenService:Create(sphere, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = Vector3.new(14, 14, 14),
            Transparency = 1
        }):Play()
        task.delay(0.5, function()
            if sphere and sphere.Parent then sphere:Destroy() end
        end)
    end

    -- =========================================================================
    -- 1. RECEX DRONE FREECAM (CÂMERA LIVRE CINEMATOGRÁFICA)
    -- =========================================================================
    WaypointsTab:AddSection("Câmera Drone 3D (Freecam)")

    local FreecamActive = false
    local FreecamSpeed = 1.8
    local DronePos = Vector3.zero

    WaypointsTab:AddToggle("Ativar Câmera Drone Livre (Freecam)", "Solta a câmera do corpo para espionar o mapa inteiro", false, function(state)
        FreecamActive = state
        local root = GetRoot()
        if state then
            DronePos = Camera.CFrame.Position
            if root then root.Anchored = true end
            Hub.Notify("Drone Freecam", "Use W, A, S, D (ou analógico) para voar com a câmera!", 3)
        else
            Camera.CameraType = Enum.CameraType.Custom
            if LocalPlayer.Character and GetHum() then
                Camera.CameraSubject = GetHum()
            end
            if root then root.Anchored = false end
        end
    end)

    WaypointsTab:AddButton("⚡ Teleportar Personagem até o Drone", "Leva seu boneco exatamente para onde a câmera Drone está", function()
        local root = GetRoot()
        if root and FreecamActive then
            root.Anchored = false
            root.CFrame = CFrame.new(Camera.CFrame.Position)
            SpawnTPFlash(Camera.CFrame.Position)
            Hub.Notify("Teleporte Drone", "Personagem movido para a posição da câmera!", 3)
        else
            Hub.Notify("Aviso", "Ative a Câmera Drone primeiro para usar este teleporte!", 3)
        end
    end)

    WaypointsTab:AddSlider("Velocidade da Câmera Drone", 1, 10, 3, function(val)
        FreecamSpeed = val * 0.7
    end)

    RunService.RenderStepped:Connect(function()
        if FreecamActive then
            local hum = GetHum()
            local rot = Camera.CFrame.Rotation
            local moveVec = Vector3.zero

            -- Funciona no PC (W,A,S,D,E,Q) e no Celular (Analógico)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVec += rot.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVec -= rot.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVec += rot.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVec -= rot.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.E) or UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveVec += Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Q) or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveVec -= Vector3.new(0, 1, 0)
            end

            if moveVec.Magnitude == 0 and hum and hum.MoveDirection.Magnitude > 0 then
                moveVec = (rot.LookVector * -hum.MoveDirection.Z) + (rot.RightVector * hum.MoveDirection.X)
            end

            DronePos = DronePos + (moveVec * FreecamSpeed)
            Camera.CFrame = CFrame.new(DronePos) * rot
        end
    end)

    -- =========================================================================
    -- 2. TELEPORTES INTELIGENTES DO MAPA
    -- =========================================================================
    WaypointsTab:AddSection("Teleportes Inteligentes do Mapa")

    WaypointsTab:AddButton("🏠 Ir para o Spawn Inicial do Mapa", "Teleporta de volta para o SpawnLocation principal", function()
        local root = GetRoot()
        if not root then return end
        local spawnPt = workspace:FindFirstChildOfClass("SpawnLocation", true)
        if spawnPt then
            root.CFrame = spawnPt.CFrame + Vector3.new(0, 4, 0)
            SpawnTPFlash(root.Position)
            Hub.Notify("Spawn TP", "Teleportado para o início do mapa!", 3)
        else
            root.CFrame = CFrame.new(0, 50, 0)
        end
    end)

    WaypointsTab:AddButton("🏔️ Ir para o Ponto Mais Alto do Mapa", "Encontra a estrutura mais alta do jogo e leva você ao topo", function()
        local root = GetRoot()
        if not root then return end
        local highestPart = nil
        local maxY = -math.huge

        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide and v.Position.Y < 2000 and v.Position.Y > maxY and not v:IsDescendantOf(LocalPlayer.Character) then
                maxY = v.Position.Y
                highestPart = v
            end
        end

        if highestPart then
            root.CFrame = CFrame.new(highestPart.Position + Vector3.new(0, highestPart.Size.Y / 2 + 4, 0))
            SpawnTPFlash(root.Position)
            Hub.Notify("Topo do Mapa", string.format("Teleportado a %dm de altura!", math.floor(maxY)), 3)
        end
    end)

    WaypointsTab:AddButton("🎲 Teleportar para um Jogador Aleatório", "Escolhe um player vivo no servidor e vai até ele", function()
        local root = GetRoot()
        if not root then return end
        local candidates = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and GetRoot(plr) then
                table.insert(candidates, plr)
            end
        end
        if #candidates > 0 then
            local chosen = candidates[math.random(1, #candidates)]
            root.CFrame = GetRoot(chosen).CFrame * CFrame.new(0, 0, 3.5)
            SpawnTPFlash(root.Position)
            Hub.Notify("Teleporte Player", "Você foi até " .. chosen.DisplayName, 3)
        end
    end)

    -- =========================================================================
    -- 3. GERADOR DE WAYPOINTS 3D (SALVAR POSIÇÕES COM HOLOGRAMA)
    -- =========================================================================
    WaypointsTab:AddSection("Meus Waypoints Salvos (3D)")

    local WaypointCount = 0
    local ShowBeacons = true

    WaypointsTab:AddToggle("Mostrar Hologramas 3D dos Waypoints", "Exibe marcadores dourados visíveis através das paredes", true, function(state)
        ShowBeacons = state
        for _, b in ipairs(BeaconFolder:GetChildren()) do
            if b:IsA("BasePart") then
                b.Transparency = state and 0.25 or 1
                local gui = b:FindFirstChildOfClass("BillboardGui")
                if gui then gui.Enabled = state end
            end
        end
    end)

    WaypointsTab:AddButton("➕ Salvar Posição Atual como Novo Waypoint", "Cria um marcador 3D aqui e adiciona um botão de TP abaixo!", function()
        local root = GetRoot()
        if not root then return end

        WaypointCount += 1
        local savedCF = root.CFrame
        local wpName = string.format("Waypoint #%d (%dm, %dm)", WaypointCount, math.floor(savedCF.X), math.floor(savedCF.Z))

        -- Cria o Holograma 3D no mundo
        local beacon = Instance.new("Part")
        beacon.Name = "WaypointBeacon_" .. WaypointCount
        beacon.Shape = Enum.PartType.Ball
        beacon.Size = Vector3.new(1.6, 1.6, 1.6)
        beacon.Position = savedCF.Position
        beacon.Anchored = true
        beacon.CanCollide = false
        beacon.Material = Enum.Material.Neon
        beacon.Color = Color3.fromRGB(245, 195, 70)
        beacon.Transparency = ShowBeacons and 0.25 or 1
        beacon.Parent = BeaconFolder

        local bGui = Instance.new("BillboardGui")
        bGui.Size = UDim2.new(0, 140, 0, 32)
        bGui.StudsOffset = Vector3.new(0, 2.5, 0)
        bGui.AlwaysOnTop = true
        bGui.Enabled = ShowBeacons
        bGui.Parent = beacon

        local bLabel = Instance.new("TextLabel")
        bLabel.Size = UDim2.new(1, 0, 1, 0)
        bLabel.BackgroundTransparency = 1
        bLabel.Text = "📍 " .. wpName
        bLabel.TextColor3 = Color3.fromRGB(245, 195, 70)
        bLabel.TextStrokeTransparency = 0.2
        bLabel.Font = Enum.Font.GothamBold
        bLabel.TextSize = 11
        bLabel.Parent = bGui

        -- Adiciona automaticamente o botão na lista do Hub
        WaypointsTab:AddButton("📍 Ir para " .. wpName, "Clique para teleportar instantaneamente para este ponto", function()
            local myRoot = GetRoot()
            if myRoot then
                myRoot.CFrame = savedCF
                SpawnTPFlash(savedCF.Position)
                Hub.Notify("Waypoint TP", "Teleportado para " .. wpName, 2)
            end
        end)

        SpawnTPFlash(savedCF.Position)
        Hub.Notify("Waypoint Criado!", wpName .. " salvo na lista abaixo!", 3)
    end)

    WaypointsTab:AddButton("🗑️ Limpar Hologramas 3D do Mapa", "Remove todas as esferas de marcação visual do mapa", function()
        BeaconFolder:ClearAllChildren()
        Hub.Notify("Limpo", "Hologramas 3D removidos da tela.", 2)
    end)
end