-- [[ RECEX HUB — MODULES/HUBS.LUA ]] --
-- [[ Combate Universal, FE Fling, Hitbox, Admins e Hubs Famosos ]] --

return function(Hub, Tabs)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Lighting = game:GetService("Lighting")

    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera

    -- Cria 2 novas abas automaticamente na nossa UI Compacta!
    local TabCombat = Hub:CreateTab("Combate & FE")
    local TabHubs   = Hub:CreateTab("Hubs & Admins")

    local GoldColor = Color3.fromRGB(255, 202, 122)

    -- Função segura para executar Loadstrings externos com aviso na tela
    local function ExecuteExternal(name, url)
        Hub.Notify("Carregando Script", "Baixando " .. name .. "...", 2.5)
        task.spawn(function()
            local ok, err = pcall(function()
                local code = game:HttpGet(url, true)
                local fn = loadstring(code)
                if fn then fn() end
            end)
            if ok then
                Hub.Notify("Sucesso", name .. " executado!", 3)
            else
                Hub.Notify("Erro no Script", "Não foi possível carregar " .. name, 3)
                warn("[Recex Hub] Erro ao carregar " .. name .. ": " .. tostring(err))
            end
        end)
    end

    -- =========================================================================
    -- ABA 1: COMBATE UNIVERSAL & FE (HITBOX, CAMLOCK, FLING, ANTI-FLING)
    -- =========================================================================
    local CombatState = {
        CamLock      = false,
        CamSmooth    = 0.25,
        HitboxOn     = false,
        HitboxSize   = 12,
        TouchFling   = false,
        AntiFling    = false
    }

    TabCombat:AddSection("Mira & Hitbox Universal")

    -- Pega o jogador vivo mais próximo do centro da tela (Mira)
    local function GetClosestPlayerToCenter()
        local closestPlr = nil
        local shortestDist = 450 -- Raio máximo em pixels na tela
        local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                local head = plr.Character:FindFirstChild("Head") or plr.Character:FindFirstChild("HumanoidRootPart")
                if hum and head and hum.Health > 0 then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        if dist < shortestDist then
                            shortestDist = dist
                            closestPlr = head
                        end
                    end
                end
            end
        end
        return closestPlr
    end

    TabCombat:AddToggle("AimLock / CamLock Suave", "Puxa a câmera suavemente para o inimigo mais próximo do centro da tela", false, function(enabled)
        CombatState.CamLock = enabled
        Hub.Notify("Combate", enabled and "AimLock Universal ativado!" or "AimLock desativado.", 2.5)
    end)

    TabCombat:AddToggle("Hitbox Expander (Aumentar Inimigos)", "Aumenta a caixa de colisão dos jogadores para acertar ataques facilmente", false, function(enabled)
        CombatState.HitboxOn = enabled
        if not enabled then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local root = plr.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.Size = Vector3.new(2, 2, 1)
                        root.Transparency = 1
                    end
                end
            end
        end
        Hub.Notify("Hitbox Expander", enabled and ("Hitbox expandida para " .. CombatState.HitboxSize .. "!") or "Hitbox restaurada ao normal.", 2.5)
    end)

    TabCombat:AddSlider("Tamanho da Hitbox", 4, 35, 12, function(val)
        CombatState.HitboxSize = val
    end)

    TabCombat:AddSection("Scripts FE (Física & Fling)")

    TabCombat:AddToggle("Touch Fling FE (Arremessar ao Encostar)", "Quem tocar no seu personagem é lançado para fora do mapa!", false, function(enabled)
        CombatState.TouchFling = enabled
        Hub.Notify("Touch Fling FE", enabled and "Ativado! Encoste em alguém para arremessar." or "Touch Fling desativado.", 3)
    end)

    -- Loop de Física do Touch Fling FE
    task.spawn(function()
        while task.wait() do
            if CombatState.TouchFling then
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    local oldVel = root.Velocity
                    root.Velocity = oldVel * 10000 + Vector3.new(0, 10000, 0)
                    RunService.RenderStepped:Wait()
                    if root and root.Parent then
                        root.Velocity = oldVel
                    end
                    RunService.Stepped:Wait()
                    if root and root.Parent then
                        root.Velocity = oldVel + Vector3.new(0, 0.1, 0)
                    end
                end
            end
        end
    end)

    TabCombat:AddToggle("Anti-Fling FE (Imunidade a Fling)", "Remove a colisão física dos outros jogadores para ninguém te jogar longe", false, function(enabled)
        CombatState.AntiFling = enabled
        Hub.Notify("Proteção FE", enabled and "Anti-Fling ativado! Você está imune." or "Anti-Fling desativado.", 2.5)
    end)

    TabCombat:AddSection("Desempenho & FPS")

    TabCombat:AddButton("Ativar FPS Booster Ultra (+FPS)", "Remove texturas pesadas, reflexos e partículas para deixar o jogo liso", function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v.Parent:FindFirstChildOfClass("Humanoid") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
                v.CastShadow = false
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Lifetime = NumberRange.new(0)
            end
        end
        Hub.Notify("FPS Booster", "Mapa otimizado com sucesso! (+FPS)", 3)
    end)

    -- Loop em Tempo Real para CamLock, Hitbox e Anti-Fling
    RunService.RenderStepped:Connect(function()
        -- 1. CamLock Universal
        if CombatState.CamLock then
            local targetPart = GetClosestPlayerToCenter()
            if targetPart then
                local goalCF = CFrame.new(Camera.CFrame.Position, targetPart.Position)
                Camera.CFrame = Camera.CFrame:Lerp(goalCF, CombatState.CamSmooth)
            end
        end

        -- 2. Hitbox Expander & Anti-Fling
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local root = plr.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    if CombatState.HitboxOn then
                        root.Size = Vector3.new(CombatState.HitboxSize, CombatState.HitboxSize, CombatState.HitboxSize)
                        root.Transparency = 0.65
                        root.Color = GoldColor
                        root.Material = Enum.Material.Neon
                        root.CanCollide = false
                    end
                end

                if CombatState.AntiFling then
                    for _, part in ipairs(plr.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end
    end)

    -- =========================================================================
    -- ABA 2: HUBS FAMOSOS, ADMINS & FERRAMENTAS DEV
    -- =========================================================================
    TabHubs:AddSection("Scripts de Admin FE (Comandos)")

    TabHubs:AddButton("Infinite Yield FE", "O script de Admin mais famoso do Roblox (+300 comandos)", function()
        ExecuteExternal("Infinite Yield", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
    end)

    TabHubs:AddButton("Nameless Admin FE", "Painel de comandos FE moderno e completo", function()
        ExecuteExternal("Nameless Admin", "https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source")
    end)

    TabHubs:AddButton("CMD-X Admin", " Mais de 600 comandos avançados de servidor e cliente", function()
        ExecuteExternal("CMD-X", "https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source")
    end)

    TabHubs:AddSection("Hubs Universais & Animações")

    TabHubs:AddButton("Orca Universal Hub", "Interface universal moderna com funções extras e controles", function()
        ExecuteExternal("Orca Hub", "https://raw.githubusercontent.com/richie0866/orca/master/public/latest.lua")
    end)

    TabHubs:AddButton("GhostHub Universal (+100 Scripts)", "Hub com dezenas de scripts FE, Trolling e Jogos", function()
        ExecuteExternal("GhostHub", "https://raw.githubusercontent.com/GhostPlayer352/Test4/main/GhostHub")
    end)

    TabHubs:AddButton("FE Emotes & Danças Grátis", "Use todas as danças e animações do catálogo gratuitamente", function()
        ExecuteExternal("FE Emotes", "https://raw.githubusercontent.com/XNEOFF/FEmotesGui/main/FEmotesGui.lua")
    end)

    TabHubs:AddButton("Teclado Virtual na Tela (Mobile)", "Adiciona um teclado de PC na tela para quem joga no celular", function()
        ExecuteExternal("Mobile Keyboard", "https://raw.githubusercontent.com/advxzivhsjjdhxhsidifvsh/mobkeyboard/main/main.txt")
    end)

    TabHubs:AddSection("Ferramentas para Criadores (Dev Tools)")

    TabHubs:AddButton("Dex Explorer (Ver Mapa e Scripts)", "Inspecione todas as pastas do Workspace, ReplicatedStorage e Player", function()
        ExecuteExternal("Dex Explorer", "https://raw.githubusercontent.com/infyiff/backup/main/dex.lua")
    end)

    TabHubs:AddButton("SimpleSpy V3 (Remote Spy)", "Monitora todos os RemoteEvents do jogo para você criar seus scripts", function()
        ExecuteExternal("SimpleSpy V3", "https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua")
    end)
end
