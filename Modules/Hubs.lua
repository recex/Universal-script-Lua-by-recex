-- [[ RECEX HUB — MODULES/HUBS.LUA (MEGA EDITION: 55+ ESSENTIAL SCRIPTS) ]] --
-- [[ Combate, 50+ Scripts Universais/FE, Animações, Admins e Jogos Famosos ]] --

return function(Hub, Tabs)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Lighting = game:GetService("Lighting")
    local StarterGui = game:GetService("StarterGui")
    local VirtualUser = game:GetService("VirtualUser")

    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    local Mouse = LocalPlayer:GetMouse()

    -- Cria as 3 Abas de Scripts Externos e Essenciais
    local TabCombat = Hub:CreateTab("Combate & FE")
    local TabMega   = Hub:CreateTab("50+ Essenciais")
    local TabGames  = Hub:CreateTab("Jogos Famosos")

    local GoldColor = Color3.fromRGB(255, 202, 122)

    local function GetChar() return LocalPlayer.Character end
    local function GetHum() return GetChar() and GetChar():FindFirstChildOfClass("Humanoid") end
    local function GetRoot() return GetChar() and GetChar():FindFirstChild("HumanoidRootPart") end

    local function ExecuteExternal(name, url)
        Hub.Notify("Carregando Script", "Executando " .. name .. "...", 2.5)
        task.spawn(function()
            local ok, err = pcall(function()
                local code = game:HttpGet(url, true)
                local fn = loadstring(code)
                if fn then fn() end
            end)
            if ok then
                Hub.Notify("Sucesso", name .. " carregado!", 3)
            else
                Hub.Notify("Aviso", "Servidor do script " .. name .. " indisponível.", 3)
                warn("[Recex Hub] Erro em " .. name .. ": " .. tostring(err))
            end
        end)
    end

    -- =========================================================================
    -- ABA 1: COMBATE & FÍSICA FE (AIMLOCK, HITBOX, TOUCH FLING, AUTO-CLICKER)
    -- =========================================================================
    local CombatState = {
        CamLock      = false,
        CamSmooth    = 0.25,
        HitboxOn     = false,
        HitboxSize   = 12,
        TouchFling   = false,
        AntiFling    = false,
        AutoClicker  = false,
        Spinbot      = false,
        SpinSpeed    = 45
    }

    TabCombat:AddSection("Mira, Hitbox & Auto-Clicker")

    local function GetClosestPlayerToCenter()
        local closestPlr = nil
        local shortestDist = 450
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

    TabCombat:AddToggle("1. AimLock / CamLock Universal", "Gruda a mira suavemente no inimigo mais próximo do centro da tela", false, function(v)
        CombatState.CamLock = v
    end)

    TabCombat:AddToggle("2. Hitbox Expander Dourada", "Aumenta o tamanho da Hitbox dos inimigos para acertar de longe", false, function(v)
        CombatState.HitboxOn = v
        if not v then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    plr.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                    plr.Character.HumanoidRootPart.Transparency = 1
                end
            end
        end
    end)

    TabCombat:AddSlider("Tamanho da Hitbox", 4, 35, 12, function(val)
        CombatState.HitboxSize = val
    end)

    TabCombat:AddToggle("3. Auto-Clicker Ultra Rápido", "Clica automaticamente em alta velocidade para PvP e Farm", false, function(v)
        CombatState.AutoClicker = v
        Hub.Notify("Auto-Clicker", v and "Ativado!" or "Desativado.", 2)
    end)

    task.spawn(function()
        while task.wait(0.05) do
            if CombatState.AutoClicker then
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton1(Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2))
                end)
            end
        end
    end)

    TabCombat:AddSection("Física FE (Fling, Anti-Fling & Spinbot)")

    TabCombat:AddToggle("4. Touch Fling FE (Arremessar Jogadores)", "Quem encostar em você voa para fora do mapa!", false, function(v)
        CombatState.TouchFling = v
    end)

    task.spawn(function()
        while task.wait() do
            if CombatState.TouchFling then
                local root = GetRoot()
                if root then
                    local oldVel = root.Velocity
                    root.Velocity = oldVel * 10000 + Vector3.new(0, 10000, 0)
                    RunService.RenderStepped:Wait()
                    if root and root.Parent then root.Velocity = oldVel end
                    RunService.Stepped:Wait()
                    if root and root.Parent then root.Velocity = oldVel + Vector3.new(0, 0.1, 0) end
                end
            end
        end
    end)

    TabCombat:AddToggle("5. Anti-Fling FE (Imunidade Total)", "Desativa colisão de outros jogadores para ninguém te arremessar", false, function(v)
        CombatState.AntiFling = v
    end)

    TabCombat:AddToggle("6. Spinbot 360° FE", "Gira seu personagem em alta velocidade continuamente", false, function(v)
        CombatState.Spinbot = v
    end)

    -- =========================================================================
    -- ABA 2: 50+ SCRIPTS ESSENCIAIS (UNIVERSAIS, FE, TROLLING & ANIMAÇÕES)
    -- =========================================================================
    local EssState = {
        FloatPlatform = false,
        ClickTP       = false,
        LowGravity    = false,
        XRay          = false,
        RainbowChar   = false,
        OrbitPlayer   = false,
        GluePlayer    = false,
        NoclipCam     = false,
        FakeLag       = false
    }

    TabMega:AddSection(" Poderes & Movimentação Essencial")

    -- 7. Air Walk / Float Platform
    local FloatPart = nil
    TabMega:AddToggle("7. Andar no Ar (Plataforma Invisível)", "Cria um chão de energia sob seus pés para caminhar no céu", false, function(v)
        EssState.FloatPlatform = v
        if not v and FloatPart then FloatPart:Destroy(); FloatPart = nil end
    end)

    -- 8. Ctrl + Click Teleport
    TabMega:AddToggle("8. Click Teleport (Segure Ctrl + Clique)", "Teleporta instantaneamente para onde você clicar segurando Ctrl", false, function(v)
        EssState.ClickTP = v
    end)

    Mouse.Button1Down:Connect(function()
        if EssState.ClickTP and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            local root = GetRoot()
            if root and Mouse.Hit then
                root.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
            end
        end
    end)

    -- 9. Gravidade Lunar
    TabMega:AddToggle("9. Gravidade da Lua (Low Gravity)", "Diminui a gravidade do mundo permitindo saltos gigantes", false, function(v)
        workspace.Gravity = v and 45 or 196.2
    end)

    -- 10. Visão Raio-X (X-Ray Walls)
    TabMega:AddToggle("10. Visão Raio-X (Paredes Transparentes)", "Deixa as paredes do mapa semitransparentes para ver tudo", false, function(v)
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and not part.Parent:FindFirstChildOfClass("Humanoid") and part.Name ~= "Terrain" then
                if v then
                    if part.Transparency < 0.5 then
                        part:SetAttribute("OrigTrans", part.Transparency)
                        part.Transparency = 0.65
                    end
                else
                    local orig = part:GetAttribute("OrigTrans")
                    if orig then part.Transparency = orig end
                end
            end
        end
    end)

    -- 11. Fake Lag FE
    TabMega:AddToggle("11. Fake Lag FE (Andar Travando)", "Faz parecer para os outros jogadores que sua internet está em 999ms", false, function(v)
        EssState.FakeLag = v
        local root = GetRoot()
        if not v and root then root.Anchored = false end
    end)

    task.spawn(function()
        while task.wait(0.18) do
            if EssState.FakeLag then
                local root = GetRoot()
                if root then
                    root.Anchored = not root.Anchored
                end
            end
        end
    end)

    -- 12. Orbitar Jogador Mais Próximo
    TabMega:AddToggle("12. Orbitar Jogador (Girar ao Redor)", "Gira em órbita 360° em volta do jogador mais próximo", false, function(v)
        EssState.OrbitPlayer = v
    end)

    -- 13. Grudar nas Costas de Jogador
    TabMega:AddToggle("13. Grudar nas Costas do Inimigo (Glue)", "Cola seu personagem atrás do jogador mais próximo (Impossível te acertar)", false, function(v)
        EssState.GluePlayer = v
    end)

    -- 14. Câmera atravessando paredes (Noclip Camera)
    TabMega:AddButton("14. Câmera Sem Colisão (Ver Através de Paredes)", "Impede que a câmera bata em paredes quando você gira a visão", function()
        LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
        Hub.Notify("Câmera", "Invisicam ativado! Sua câmera agora atravessa obstáculos.", 3)
    end)

    -- 15. BTools Client
    TabMega:AddButton("15. Receber BTools (Construir / Deletar Paredes)", "Adiciona as 3 ferramentas clássicas de deletar e mover blocos na mochila", function()
        local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
        if bp then
            for _, toolType in ipairs({Enum.BinType.Hammer, Enum.BinType.Clone, Enum.BinType.Grab}) do
                local b = Instance.new("HopperBin")
                b.BinType = toolType
                b.Parent = bp
            end
            Hub.Notify("BTools", "Ferramentas de construção adicionadas ao inventário!", 3)
        end
    end)

    TabMega:AddSection("Cosméticos, Poses & Animações R15/R6")

    -- 16. Sentar em Qualquer Lugar
    TabMega:AddButton("16. Sentar no Chão (Sit Anywhere)", "Faz seu personagem sentar imediatamente onde estiver", function()
        local hum = GetHum()
        if hum then hum.Sit = true end
    end)

    -- 17. Deitar / Ragdoll Pose
    TabMega:AddButton("17. Deitar / Fingir de Morto (Lay Pose)", "Coloca o personagem deitado no chão (Pule para levantar)", function()
        local hum = GetHum()
        local root = GetRoot()
        if hum and root then
            hum.Sit = true
            task.wait(0.05)
            root.CFrame = root.CFrame * CFrame.Angles(math.rad(88), 0, 0)
        end
    end)

    -- 18. Personagem RGB
    TabMega:AddToggle("18. Personagem RGB (Rainbow Character)", "Muda a cor do seu corpo continuamente em efeito Chroma", false, function(v)
        EssState.RainbowChar = v
    end)

    -- 19. Corpo Holográfico (ForceField)
    TabMega:AddButton("19. Corpo Holográfico (ForceField Visual)", "Transforma o material do seu avatar em campo de força brilhante", function()
        local char = GetChar()
        if char then
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                    p.Material = Enum.Material.ForceField
                end
            end
        end
    end)

    -- 20. Headless Visual (Sem Cabeça)
    TabMega:AddButton("20. Headless Horseman (Ficar Sem Cabeça)", "Aplica o visual da Headless de 31.000 Robux no seu personagem", function()
        local head = GetChar() and GetChar():FindFirstChild("Head")
        if head then
            head.Transparency = 1
            for _, d in ipairs(head:GetChildren()) do
                if d:IsA("Decal") then d.Transparency = 1 end
            end
            Hub.Notify("Cosmético", "Headless aplicada!", 2.5)
        end
    end)

    -- 21 a 24: Pacotes de Animação R15
    local function ApplyR15Anim(idle1, walk, run, jump)
        local animate = GetChar() and GetChar():FindFirstChild("Animate")
        if animate then
            pcall(function()
                animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=" .. idle1
                animate.walk.WalkAnim.AnimationId   = "http://www.roblox.com/asset/?id=" .. walk
                animate.run.RunAnim.AnimationId     = "http://www.roblox.com/asset/?id=" .. run
                animate.jump.JumpAnim.AnimationId   = "http://www.roblox.com/asset/?id=" .. jump
                GetHum():ChangeState(Enum.HumanoidStateType.Jumping)
            end)
            Hub.Notify("Animação R15", "Pacote de animação aplicado com sucesso!", 2.5)
        else
            Hub.Notify("Aviso", "Seu personagem precisa estar no modo R15.", 2.5)
        end
    end

    TabMega:AddButton("21. Pacote de Animação: Ninja (R15)", "Muda seu jeito de correr e pular para o pacote Ninja", function()
        ApplyR15Anim("656117400", "656121766", "656118852", "656117878")
    end)

    TabMega:AddButton("22. Pacote de Animação: Vampiro (R15)", "Muda sua animação para o pacote Vampire", function()
        ApplyR15Anim("1083445855", "1083473930", "1083462077", "1083455352")
    end)

    TabMega:AddButton("23. Pacote de Animação: Levitação (R15)", "Faz você andar flutuando no ar com o pacote Levitation", function()
        ApplyR15Anim("616006778", "616013216", "616010382", "616008936")
    end)

    TabMega:AddButton("24. Pacote de Animação: Zumbi (R15)", "Aplica a corrida e postura do pacote Zombie", function()
        ApplyR15Anim("616158929", "616168032", "616163682", "616161997")
    end)

    TabMega:AddSection("Utilidades do Jogo & Interface")

    -- 25. Desbloquear Chat e Inventário
    TabMega:AddButton("25. Forçar Ativação do Chat e Mochila", "Reativa o Chat e o Inventário em jogos que escondem a interface", function()
        pcall(function()
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
        end)
        Hub.Notify("Interface", "Toda a interface padrão do Roblox foi desbloqueada!", 3)
    end)

    -- 26. Instant ProximityPrompt (Interagir sem esperar)
    TabMega:AddButton("26. Interação Instantânea (Sem Segurar E)", "Remove o tempo de espera de portas, baús e botões (ProximityPrompt)", function()
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                v.HoldDuration = 0
            end
        end
        workspace.DescendantAdded:Connect(function(v)
            if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end
        end)
        Hub.Notify("Instant Interact", "Todos os botões do mapa agora ativam na hora!", 3)
    end)

    -- 27. Reset Instantâneo
    TabMega:AddButton("27. Forçar Respawn (Resetar Mesmo Travado)", "Mata o personagem imediatamente mesmo se o botão Reset estiver bloqueado", function()
        local hum = GetHum()
        if hum then hum.Health = 0 end
    end)

    -- 28. FPS Booster
    TabMega:AddButton("28. FPS Booster Ultra (+FPS)", "Otimiza texturas e sombras pesadas do mapa para rodar liso", function()
        Lighting.GlobalShadows = false
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v.Parent:FindFirstChildOfClass("Humanoid") then
                v.Material = Enum.Material.SmoothPlastic
                v.CastShadow = false
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            end
        end
        Hub.Notify("FPS Booster", "Texturas e sombras otimizadas!", 2.5)
    end)

    -- 29 a 40: Melhores Hubs Universais, Admins e Dev Tools
    TabMega:AddSection("Admins FE, Hubs Universais & Dev Tools")

    TabMega:AddButton("29. Infinite Yield FE Admin", "O painel de comandos Admin mais completo do Roblox (+350 comandos)", function()
        ExecuteExternal("Infinite Yield", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
    end)

    TabMega:AddButton("30. Nameless Admin FE", "Mais de 400 comandos FE visuais, voo, animações e proteção", function()
        ExecuteExternal("Nameless Admin", "https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source")
    end)

    TabMega:AddButton("31. CMD-X Admin FE", "Mais de 600 comandos avançados de servidor e cliente", function()
        ExecuteExternal("CMD-X", "https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source")
    end)

    TabMega:AddButton("32. Fates Admin FE", "Barra de comandos rápida com recursos de combate e FE", function()
        ExecuteExternal("Fates Admin", "https://raw.githubusercontent.com/fatesc/fates-admin/main/main.lua")
    end)

    TabMega:AddButton("33. Orca Universal Hub", "Interface universal moderna com controles de câmera e jogador", function()
        ExecuteExternal("Orca Hub", "https://raw.githubusercontent.com/richie0866/orca/master/public/latest.lua")
    end)

    TabMega:AddButton("34. GhostHub (+100 Scripts FE & Trolling)", "Coleção gigante de scripts FE, telecinese, carros e animações", function()
        ExecuteExternal("GhostHub", "https://raw.githubusercontent.com/GhostPlayer352/Test4/main/GhostHub")
    end)

    TabMega:AddButton("35. AirHub V2 (Universal Aimbot & Wallhack)", "Aimbot profissional com círculo FOV e ESP completo para jogos de tiro", function()
        ExecuteExternal("AirHub V2", "https://raw.githubusercontent.com/Exunys/AirHub-V2/main/src/Main.lua")
    end)

    TabMega:AddButton("36. OwlHub Universal (FPS & Sniper)", "Clássico Hub de mira e ESP para Arsenal, Counter Blox e FPS", function()
        ExecuteExternal("OwlHub", "https://raw.githubusercontent.com/CriShoux/OwlHub/master/OwlHub.txt")
    end)

    TabMega:AddButton("37. FE Emotes & Todas as Danças Grátis", "Menu com todas as danças pagas da loja do Roblox liberadas", function()
        ExecuteExternal("FE Emotes", "https://raw.githubusercontent.com/XNEOFF/FEmotesGui/main/FEmotesGui.lua")
    end)

    TabMega:AddButton("38. Teclado Virtual na Tela (Mobile Keyboard)", "Adiciona as teclas de PC na tela para jogadores de celular", function()
        ExecuteExternal("Mobile Keyboard", "https://raw.githubusercontent.com/advxzivhsjjdhxhsidifvsh/mobkeyboard/main/main.txt")
    end)

    TabMega:AddButton("39. Dex Explorer V4 (Inspecionar Jogo)", "Veja todas as pastas, objetos e scripts dentro do mapa", function()
        ExecuteExternal("Dex Explorer", "https://raw.githubusercontent.com/infyiff/backup/main/dex.lua")
    end)

    TabMega:AddButton("40. SimpleSpy V3 (Monitor de RemoteEvents)", "Descubra os eventos ocultos do jogo para criar seus próprios scripts", function()
        ExecuteExternal("SimpleSpy V3", "https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua")
    end)

    -- =========================================================================
    -- ABA 3: OS MELHORES SCRIPTS PARA OS JOGOS MAIS FAMOSOS (41 AO 58)
    -- =========================================================================
    TabGames:AddSection("Blox Fruits")

    TabGames:AddButton("41. Blox Fruits — Redz Hub (Auto Farm / Sea Event)", "O script mais famoso e completo para Blox Fruits", function()
        ExecuteExternal("Redz Hub", "https://raw.githubusercontent.com/realredz/BloxFruits/refs/heads/main/Source.lua")
    end)

    TabGames:AddButton("42. Blox Fruits — Speed Hub X", "Auto Farm rápido, Raid, Mirage Island e Kitsune Event", function()
        ExecuteExternal("Speed Hub X", "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua")
    end)

    TabGames:AddButton("43. Blox Fruits — Hoho Hub V4", "Completo para PvP, Bounty Hunt, Auto Trial V4 e Farm", function()
        ExecuteExternal("Hoho Hub", "https://raw.githubusercontent.com/acsu123/HOHO_H/main/Loading_UI")
    end)

    TabGames:AddSection("Brookhaven RP")

    TabGames:AddButton("44. Brookhaven RP — Sander X Hub", "Trolling, Avatar Custom, Carros Voadores, RGB e Admin RP", function()
        ExecuteExternal("Sander X", "https://raw.githubusercontent.com/kigredns/SanderXV4.2.2/refs/heads/main/NormalSS.lua")
    end)

    TabGames:AddButton("45. Brookhaven RP — Ice Hub", "Funções exclusivas de casas, itens secretos e trolling em Brookhaven", function()
        ExecuteExternal("Ice Hub Brookhaven", "https://raw.githubusercontent.com/IceMael7/NewIceHub/main/Brookhaven")
    end)

    TabGames:AddSection("Murder Mystery 2 (MM2) & Blade Ball")

    TabGames:AddButton("46. Murder Mystery 2 — Yarhm Hub", "ESP Murder/Sheriff, Pegar Arma Automático, Auto Farm Moedas e Fling", function()
        ExecuteExternal("Yarhm MM2", "https://raw.githubusercontent.com/Joystickplays/psychic-octo-invention/main/yarhm.lua")
    end)

    TabGames:AddButton("47. Murder Mystery 2 — XHub MM2", "Ver quem é o Assassino/Xerife, Kill All (Murder) e Teleportes", function()
        ExecuteExternal("XHub MM2", "https://raw.githubusercontent.com/Au0yX/Community/main/XhubMM2")
    end)

    TabGames:AddButton("48. Blade Ball — Bedol Auto Parry Hub", "Auto Parry inteligente de alta precisão, Auto Spam e Curva", function()
        ExecuteExternal("Bedol Blade Ball", "https://raw.githubusercontent.com/3345-c-a-t-s-u-s/-beta-/main/AutoParry.lua")
    end)

    TabGames:AddButton("49. Blade Ball — FFJ Hub", "Auto Parry configurável, ESP de Bola e Auto Farm Coins", function()
        ExecuteExternal("FFJ Blade Ball", "https://raw.githubusercontent.com/FFJ1/Roblox-Exploits/main/scripts/BladeBallV3.lua")
    end)

    TabGames:AddSection("The Strongest Battlegrounds, Doors & Fisch")

    TabGames:AddButton("50. The Strongest Battlegrounds — Phantasm Hub", "Auto Combo, Auto Block, Sem Stun e Animacoes Custom", function()
        ExecuteExternal("Phantasm TSB", "https://raw.githubusercontent.com/ATrainz/Phantasm/refs/heads/main/Games/TSB.lua")
    end)

    TabGames:AddButton("51. DOORS — KING Hub / Auto Rooms", "ESP de Chaves/Monstros (Rush/Ambush), Speed Bypass e Auto A-1000", function()
        ExecuteExternal("KING Hub Doors", "https://raw.githubusercontent.com/KINGHUB01/BlackKing-obf/main/Doors%20Blackking%20And%20BobHub")
    end)

    TabGames:AddButton("52. Fisch — Speed Hub X Fisch", "Auto Cast, Auto Reel Perfeito, Teleporte para Ilhas e Auto Sell", function()
        ExecuteExternal("Speed Hub Fisch", "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua")
    end)

    TabGames:AddSection("Da Hood, Arsenal, Evade & Outros Clássicos")

    TabGames:AddButton("53. Da Hood — SwagMode Official", "Silent Aim, CamLock, Fly, Auto Stomp, Godblock e Cash Drop", function()
        ExecuteExternal("SwagMode Da Hood", "https://raw.githubusercontent.com/lerkermer/lua-projects/master/SwagModeV002")
    end)

    TabGames:AddButton("54. Arsenal — Thunder Client / Tbao Hub", "Silent Aim, Wallbang, Tiro Rápido, Munição Infinita e Rainbow Gun", function()
        ExecuteExternal("Tbao Arsenal", "https://raw.githubusercontent.com/tbao143/thaibao/main/TbaoHubArsenal")
    end)

    TabGames:AddButton("55. Evade — Tbao Hub Evade", "Auto Respawn, ESP Nextbots, Speed Strafe e Auto Farm Tickets", function()
        ExecuteExternal("Tbao Evade", "https://raw.githubusercontent.com/tbao143/thaibao/main/TbaoHubEvade")
    end)

    TabGames:AddButton("56. Prison Life — Tiger Admin / PrizzLife", "Pegar Todas as Armas, Virar Policial/Criminoso, Kill Aura e Carros", function()
        ExecuteExternal("PrizzLife", "https://raw.githubusercontent.com/devguy100/PrizzLife/main/pladmin.lua")
    end)

    TabGames:AddButton("57. Build A Boat For Treasure — Auto Farm Gold", "Voa automaticamente pelos portais ganhando barras de ouro AFK", function()
        ExecuteExternal("BABFT AutoGold", "https://raw.githubusercontent.com/max2007killer/auto-build-not-limit/main/autobuild.txt")
    end)

    TabGames:AddButton("58. Natural Disaster Survival — NullFire Hub", "Sem Dano de Queda, Prever Próximo Desastre, Walk on Water e Balão Grátis", function()
        ExecuteExternal("NDS Hub", "https://raw.githubusercontent.com/ySixxNz/Natural-Disaster-Survival/main/SixxHubNDS")
    end)

    -- =========================================================================
    -- MOTOR EM TEMPO REAL DOS SCRIPTS EMBUTIDOS (60 FPS)
    -- =========================================================================
    local orbitAngle = 0
    RunService.RenderStepped:Connect(function(dt)
        local root = GetRoot()
        local char = GetChar()

        -- CamLock
        if CombatState.CamLock then
            local targetPart = GetClosestPlayerToCenter()
            if targetPart then
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPart.Position), CombatState.CamSmooth)
            end
        end

        -- Spinbot 360
        if CombatState.Spinbot and root then
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(CombatState.SpinSpeed), 0)
        end

        -- Plataforma Flutuante (Andar no Ar)
        if EssState.FloatPlatform and root then
            if not FloatPart then
                FloatPart = Instance.new("Part")
                FloatPart.Size = Vector3.new(8, 0.6, 8)
                FloatPart.Color = GoldColor
                FloatPart.Material = Enum.Material.Neon
                FloatPart.Transparency = 0.45
                FloatPart.Anchored = true
                FloatPart.Parent = workspace
            end
            FloatPart.CFrame = CFrame.new(root.Position - Vector3.new(0, 3.3, 0))
        end

        -- Personagem RGB
        if EssState.RainbowChar and char then
            local rgb = Color3.fromHSV((tick() * 0.35) % 1, 0.85, 1)
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.Color = rgb end
            end
        end

        -- Orbitar ou Grudar no Jogador Mais Próximo
        if (EssState.OrbitPlayer or EssState.GluePlayer) and root then
            local targetHead = GetClosestPlayerToCenter()
            local targetRoot = targetHead and targetHead.Parent and targetHead.Parent:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                if EssState.OrbitPlayer then
                    orbitAngle = orbitAngle + dt * 5
                    root.CFrame = CFrame.new(targetRoot.Position + Vector3.new(math.cos(orbitAngle) * 6, 1, math.sin(orbitAngle) * 6), targetRoot.Position)
                elseif EssState.GluePlayer then
                    root.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3.2)
                end
            end
        end

        -- Hitbox & Anti-Fling
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local pRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                if pRoot and CombatState.HitboxOn then
                    pRoot.Size = Vector3.new(CombatState.HitboxSize, CombatState.HitboxSize, CombatState.HitboxSize)
                    pRoot.Transparency = 0.65
                    pRoot.Color = GoldColor
                    pRoot.Material = Enum.Material.Neon
                    pRoot.CanCollide = false
                end
                if CombatState.AntiFling then
                    for _, part in ipairs(plr.Character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end
        end
    end)
end
