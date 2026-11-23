--[[
    RECEX HUB - MODULE: UNIVERSAL AUTO-FARM, MACRO RECORDER & TYCOON HELPER
    made by recex
]]

return function(Hub, Tabs)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer

    local AutoTab = Hub:CreateTab("🤖 Auto-Farm")

    local function GetRoot()
        return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    end

    local function GetHum()
        return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    end

    -- Detecta se um Model é um NPC/Mob/Boss vivo (e NÃO um jogador real)
    local function FindClosestNPC()
        local myRoot = GetRoot()
        if not myRoot then return nil end

        local closestNPC, minDist = nil, math.huge
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Humanoid") and obj.Health > 0 and obj.Parent and obj.Parent ~= LocalPlayer.Character then
                local model = obj.Parent
                local npcRoot = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso") or model:FindFirstChild("UpperTorso")
                if npcRoot and not Players:GetPlayerFromCharacter(model) then
                    local d = (npcRoot.Position - myRoot.Position).Magnitude
                    if d < minDist then
                        minDist = d
                        closestNPC = npcRoot
                    end
                end
            end
        end
        return closestNPC
    end

    -- =========================================================================
    -- 1. GRAVADOR DE MACRO / ROTA (MACRO RECORDER)
    -- =========================================================================
    AutoTab:AddSection("Gravador de Macro (Rotas & Obbies)")

    local IsRecordingMacro = false
    local IsPlayingMacro = false
    local RecordedMacro = {}
    local MacroStep = 1

    AutoTab:AddToggle("1. Gravar Meus Passos (Macro Recorder)", "Grava todo o caminho que você fizer pelo mapa", false, function(state)
        IsRecordingMacro = state
        if state then
            RecordedMacro = {}
            IsPlayingMacro = false
            Hub.Notify("Gravando Macro 🔴", "Ande pelo mapa! Seus movimentos estão sendo salvos.", 3)
        else
            Hub.Notify("Macro Salva ✅", #RecordedMacro .. " quadros de movimento gravados!", 3)
        end
    end)

    AutoTab:AddToggle("2. Reproduzir Macro em Loop Infinito", "Repete sozinho o caminho que você gravou sem parar", false, function(state)
        if state and #RecordedMacro == 0 then
            Hub.Notify("Aviso", "Grave uma rota primeiro usando a opção 1!", 3)
            return
        end
        IsPlayingMacro = state
        IsRecordingMacro = false
        MacroStep = 1
        if state then
            Hub.Notify("Macro Ativada ▶️", "Reproduzindo sua rota em loop automático!", 3)
        end
    end)

    AutoTab:AddButton("🗑️ Limpar Macro Gravada", "Apaga a rota atual da memória", function()
        RecordedMacro = {}
        MacroStep = 1
        Hub.Notify("Macro Limpa", "Memória de rota zerada.", 2)
    end)

    -- =========================================================================
    -- 2. AUTO-FARM UNIVERSAL DE NPCS / MOBS / BOSSES (RPG & ANIME GAMES)
    -- =========================================================================
    AutoTab:AddSection("Auto-Farm de NPCs, Mobs & Bosses")

    local FarmNPCEnabled = false
    local FarmHeightOffset = 7
    local AutoEquipTool = false

    AutoTab:AddToggle("3. Auto-Farm Mobs / NPCs Vivos", "Flutua automaticamente em cima do monstro/NPC mais próximo", false, function(state)
        FarmNPCEnabled = state
        if state then
            Hub.Notify("Auto-Farm NPC", "Procurando monstros/NPCs vivos no mapa...", 3)
        end
    end)

    AutoTab:AddSlider("Altura Acima do Mob/Boss (Distância)", 3, 22, 7, function(val)
        FarmHeightOffset = val
    end)

    AutoTab:AddToggle("4. Auto-Equipar & Atacar com Arma/Espada", "Equipa o 1º item da mochila e bate sem parar", false, function(state)
        AutoEquipTool = state
    end)

    -- =========================================================================
    -- 3. AUTO-COLETOR DE MOEDAS, BAÚS, CLIQUES & TYCOONS
    -- =========================================================================
    AutoTab:AddSection("Coletores Automáticos & Tycoons")

    local AutoCoinEnabled = false
    AutoTab:AddToggle("5. Auto-Coletar Moedas / Orbs / Gems / Baús", "Puxa ou vai até itens de farm (Coin, Gem, Orb, Cash, Drop)", false, function(state)
        AutoCoinEnabled = state
    end)

    local AutoClickDetector = false
    AutoTab:AddToggle("6. Auto-Clicar Botões Próximos (ClickDetector)", "Aciona automaticamente qualquer botão clicável perto de você", false, function(state)
        AutoClickDetector = state
    end)

    local AutoPromptEnabled = false
    AutoTab:AddToggle("7. Auto-Coletar Interações (ProximityPrompt)", "Pressiona automaticamente botões de interação [E] próximos", false, function(state)
        AutoPromptEnabled = state
    end)

    AutoTab:AddButton("8. 💰 Auto-Pisar nos Botões de Tycoon", "Passa rapidamente pelos botões de compra/coleta de Tycoon", function()
        local root = GetRoot()
        if not root then return end
        local oldCF = root.CFrame
        local count = 0

        task.spawn(function()
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and (v.Name:lower():find("button") or v.Name:lower():find("giver") or v.Name:lower():find("collect") or v.Name:lower():find("buy")) then
                    if (v.Position - oldCF.Position).Magnitude < 350 then
                        root.CFrame = v.CFrame + Vector3.new(0, 3, 0)
                        count += 1
                        task.wait(0.06)
                        if count >= 35 then break end
                    end
                end
            end
            root.CFrame = oldCF
            Hub.Notify("Tycoon Helper", count .. " botões acionados com sucesso!", 3)
        end)
    end)

    -- =========================================================================
    -- LOOP CENTRAL DE AUTOMAÇÃO
    -- =========================================================================
    local LastCollectTick = 0

    RunService.RenderStepped:Connect(function()
        local root = GetRoot()
        local hum = GetHum()
        if not root or not hum then return end

        -- 1. Gravar Macro
        if IsRecordingMacro and #RecordedMacro < 1800 then
            table.insert(RecordedMacro, root.CFrame)
        end

        -- 2. Reproduzir Macro
        if IsPlayingMacro and #RecordedMacro > 0 then
            root.CFrame = RecordedMacro[MacroStep]
            MacroStep += 1
            if MacroStep > #RecordedMacro then
                MacroStep = 1
            end
        end

        -- 3. Auto-Farm NPCs / Bosses
        if FarmNPCEnabled then
            local npcRoot = FindClosestNPC()
            if npcRoot then
                root.AssemblyLinearVelocity = Vector3.zero
                root.CFrame = CFrame.new(npcRoot.Position + Vector3.new(0, FarmHeightOffset, 0), npcRoot.Position)
            end
        end

        -- 4. Auto-Equipar & Atacar
        if AutoEquipTool and LocalPlayer.Character then
            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if not tool then
                local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
                local bpTool = bp and bp:FindFirstChildOfClass("Tool")
                if bpTool then
                    hum:EquipTool(bpTool)
                end
            else
                tool:Activate()
            end
        end

        -- 5, 6, 7. Coletores (Rodam a cada 0.25s para manter FPS alto)
        if tick() - LastCollectTick > 0.25 then
            LastCollectTick = tick()

            if AutoCoinEnabled then
                for _, v in ipairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") and (v.Position - root.Position).Magnitude < 120 then
                        local n = v.Name:lower()
                        if n:find("coin") or n:find("gem") or n:find("orb") or n:find("cash") or n:find("drop") or n:find("chest") or n:find("diamond") then
                            if firetouchinterest then
                                firetouchinterest(root, v, 0)
                                firetouchinterest(root, v, 1)
                            else
                                v.CFrame = root.CFrame
                            end
                        end
                    end
                end
            end

            if AutoClickDetector and fireclickdetector then
                for _, cd in ipairs(workspace:GetDescendants()) do
                    if cd:IsA("ClickDetector") and cd.Parent and cd.Parent:IsA("BasePart") then
                        if (cd.Parent.Position - root.Position).Magnitude < 25 then
                            pcall(fireclickdetector, cd)
                        end
                    end
                end
            end

            if AutoPromptEnabled and fireproximityprompt then
                for _, pp in ipairs(workspace:GetDescendants()) do
                    if pp:IsA("ProximityPrompt") and pp.Parent and pp.Parent:IsA("BasePart") then
                        if (pp.Parent.Position - root.Position).Magnitude < 22 then
                            pcall(fireproximityprompt, pp)
                        end
                    end
                end
            end
        end
    end)
end