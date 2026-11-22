-- [[ RECEX HUB — MODULES/UNIVERSAL.LUA ]] --
-- [[ Módulo Universal de Movimentação, Física e Utilidades (Made by recex) ]] --

return function(Hub, Tabs)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local TeleportService = game:GetService("TeleportService")
    local HttpService = game:GetService("HttpService")
    local VirtualUser = game:GetService("VirtualUser")

    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    local Tab = Tabs.Universal

    -- Estado Interno do Módulo Universal
    local State = {
        SpeedEnabled = false,
        WalkSpeed = 16,
        JumpEnabled = false,
        JumpPower = 50,
        InfJump = false,
        FlyEnabled = false,
        FlySpeed = 65,
        Noclip = false,
        AntiVoid = false,
        AntiAFK = false
    }

    -- Funções auxiliares seguras de Personagem
    local function GetCharacter()
        return LocalPlayer.Character
    end

    local function GetHumanoid()
        local char = GetCharacter()
        return char and char:FindFirstChildOfClass("Humanoid")
    end

    local function GetRoot()
        local char = GetCharacter()
        return char and char:FindFirstChild("HumanoidRootPart")
    end

    -- =========================================================================
    -- SEÇÃO 1: MOVIMENTAÇÃO AVANÇADA (SPEED & JUMP)
    -- =========================================================================
    Tab:AddSection("Movimentação do Jogador")

    Tab:AddToggle("Ativar Velocidade Customizada", "Mantém sua velocidade fixa mesmo se o jogo tentar resetar", false, function(enabled)
        State.SpeedEnabled = enabled
        local hum = GetHumanoid()
        if not enabled and hum then
            hum.WalkSpeed = 16
        end
        Hub.Notify("Movimentação", enabled and ("Velocidade ativada (" .. State.WalkSpeed .. ")") or "Velocidade restaurada ao padrão", 2.5)
    end)

    Tab:AddSlider("Valor da Velocidade (WalkSpeed)", 16, 250, 16, function(val)
        State.WalkSpeed = val
        if State.SpeedEnabled then
            local hum = GetHumanoid()
            if hum then hum.WalkSpeed = val end
        end
    end)

    Tab:AddToggle("Ativar Super Pulo", "Aumenta a força do seu pulo em qualquer jogo", false, function(enabled)
        State.JumpEnabled = enabled
        local hum = GetHumanoid()
        if not enabled and hum then
            if hum.UseJumpPower then hum.JumpPower = 50 else hum.JumpHeight = 7.2 end
        end
        Hub.Notify("Movimentação", enabled and ("Super Pulo ativado (" .. State.JumpPower .. ")") or "Pulo restaurado ao padrão", 2.5)
    end)

    Tab:AddSlider("Força do Pulo (JumpPower)", 50, 350, 50, function(val)
        State.JumpPower = val
        if State.JumpEnabled then
            local hum = GetHumanoid()
            if hum then
                hum.UseJumpPower = true
                hum.JumpPower = val
            end
        end
    end)

    Tab:AddToggle("Pulo Infinito (Infinite Jump)", "Permite pular no ar infinitas vezes (PC e Mobile)", false, function(enabled)
        State.InfJump = enabled
        Hub.Notify("Pulo Infinito", enabled and "Ativado com sucesso!" or "Desativado", 2.5)
    end)

    UserInputService.JumpRequest:Connect(function()
        if State.InfJump then
            local hum = GetHumanoid()
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)

    -- =========================================================================
    -- SEÇÃO 2: VOO HÍBRIDO (FLY PC/MOBILE) & FÍSICA (NOCLIP)
    -- =========================================================================
    Tab:AddSection("Voo & Física (Recex Physics)")

    local FlyBodyGyro, FlyBodyVel

    local function StopFly()
        if FlyBodyGyro then FlyBodyGyro:Destroy(); FlyBodyGyro = nil end
        if FlyBodyVel then FlyBodyVel:Destroy(); FlyBodyVel = nil end
        local hum = GetHumanoid()
        if hum then hum.PlatformStand = false end
    end

    local function StartFly()
        StopFly()
        local root = GetRoot()
        local hum = GetHumanoid()
        if not root or not hum then return end

        FlyBodyGyro = Instance.new("BodyGyro")
        FlyBodyGyro.P = 9e4
        FlyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        FlyBodyGyro.CFrame = Camera.CFrame
        FlyBodyGyro.Parent = root

        FlyBodyVel = Instance.new("BodyVelocity")
        FlyBodyVel.Velocity = Vector3.new(0, 0, 0)
        FlyBodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        FlyBodyVel.Parent = root
    end

    Tab:AddToggle("Voo Suave (Recex Fly)", "Voe suavemente usando WASD (PC) ou Analógico (Mobile)", false, function(enabled)
        State.FlyEnabled = enabled
        if enabled then
            StartFly()
            Hub.Notify("Recex Fly", "Voo ativado! Use os controles normais de andar para voar.", 3)
        else
            StopFly()
            Hub.Notify("Recex Fly", "Voo desativado.", 2.5)
        end
    end)

    Tab:AddSlider("Velocidade do Voo (Fly Speed)", 20, 300, 65, function(val)
        State.FlySpeed = val
    end)

    Tab:AddToggle("Atravessar Paredes (Noclip)", "Desativa a colisão do seu personagem com paredes e objetos", false, function(enabled)
        State.Noclip = enabled
        if not enabled then
            local char = GetCharacter()
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = true end
                end
            end
        end
        Hub.Notify("Física", enabled and "Noclip ativado! Você pode atravessar paredes." or "Colisão restaurada.", 2.5)
    end)

    -- =========================================================================
    -- SEÇÃO 3: PROTEÇÃO & UTILIDADES DE SERVIDOR
    -- =========================================================================
    Tab:AddSection("Proteção & Servidor")

    Tab:AddToggle("Proteção Anti-Void", "Impede que você morra caindo no vazio do mapa", false, function(enabled)
        State.AntiVoid = enabled
        Hub.Notify("Proteção", enabled and "Anti-Void ativado!" or "Anti-Void desativado.", 2.5)
    end)

    Tab:AddToggle("Anti-AFK (Não cair por inatividade)", "Impede que o Roblox desconecte você após 20 minutos parado", true, function(enabled)
        State.AntiAFK = enabled
        Hub.Notify("Anti-AFK", enabled and "Proteção contra desconexão ativa." or "Anti-AFK desativado.", 2.5)
    end)
    State.AntiAFK = true -- Ativo por padrão

    LocalPlayer.Idled:Connect(function()
        if State.AntiAFK then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end)

    Tab:AddButton("Reentrar no Servidor (Rejoin)", "Reconecta imediatamente neste mesmo servidor", function()
        Hub.Notify("Servidor", "Reconectando ao servidor...", 3)
        task.wait(0.5)
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end)

    Tab:AddButton("Trocar de Servidor (Server Hop)", "Procura outro servidor público com vagas e entra nele", function()
        Hub.Notify("Server Hop", "Buscando um novo servidor...", 3)
        local ok, result = pcall(function()
            local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", game.PlaceId)
            return HttpService:JSONDecode(game:HttpGet(url))
        end)

        if ok and result and result.data then
            for _, srv in ipairs(result.data) do
                if type(srv) == "table" and srv.playing < srv.maxPlayers and srv.id ~= game.JobId then
                    Hub.Notify("Server Hop", "Servidor encontrado! Teleportando...", 3)
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, srv.id, LocalPlayer)
                    return
                end
            end
        end
        Hub.Notify("Server Hop", "Nenhum outro servidor disponível no momento.", 3.5)
    end)

    -- =========================================================================
    -- MOTOR EM TEMPO REAL (HEARTBEAT & STEPPED LOOPS)
    -- =========================================================================
    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(0.6)
        if State.FlyEnabled then
            StartFly()
        end
    end)

    RunService.Stepped:Connect(function()
        if State.Noclip then
            local char = GetCharacter()
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)

    RunService.RenderStepped:Connect(function()
        local hum = GetHumanoid()
        local root = GetRoot()
        if not hum or not root then return end

        -- Mantém Velocidade e Pulo travados se ativos
        if State.SpeedEnabled and hum.WalkSpeed ~= State.WalkSpeed then
            hum.WalkSpeed = State.WalkSpeed
        end
        if State.JumpEnabled then
            hum.UseJumpPower = true
            if hum.JumpPower ~= State.JumpPower then
                hum.JumpPower = State.JumpPower
            end
        end

        -- Proteção Anti-Void
        if State.AntiVoid and root.Position.Y < (workspace.FallenPartsDestroyHeight + 25) then
            root.Velocity = Vector3.new(root.Velocity.X, 110, root.Velocity.Z)
        end

        -- Física do Voo Híbrido (Funciona no PC e no Mobile sem botões extras!)
        if State.FlyEnabled and FlyBodyGyro and FlyBodyVel then
            hum.PlatformStand = true
            FlyBodyGyro.CFrame = Camera.CFrame

            local moveDir = hum.MoveDirection
            if moveDir.Magnitude > 0 then
                -- Converte a direção do analógico/WASD para o ângulo 3D da câmera (permite subir e descer olhando!)
                local camCF = Camera.CFrame
                local right = camCF.RightVector
                local forward = camCF.LookVector

                local flatForward = Vector3.new(forward.X, 0, forward.Z).Unit
                local forwardDot = flatForward:Dot(moveDir)
                local rightDot = right:Dot(moveDir)

                local flyVector = (forward * forwardDot) + (right * rightDot)
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    flyVector = flyVector + Vector3.new(0, 0.8, 0)
                elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    flyVector = flyVector - Vector3.new(0, 0.8, 0)
                end

                FlyBodyVel.Velocity = flyVector.Unit * State.FlySpeed
            else
                -- Subir/Descer parado no PC
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    FlyBodyVel.Velocity = Vector3.new(0, State.FlySpeed * 0.8, 0)
                elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    FlyBodyVel.Velocity = Vector3.new(0, -State.FlySpeed * 0.8, 0)
                else
                    FlyBodyVel.Velocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end)
end
