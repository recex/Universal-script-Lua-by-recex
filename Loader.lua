-- [[ RECEX HUB — GITHUB MODULAR LOADER (V2 LO-FI EDITION) ]] --
-- [[ Made by recex ]] --

local GITHUB_USER = "recex"
local GITHUB_REPO = "Universal-script-Lua-by-recex"
local BRANCH      = "main"

local BaseURL = string.format("https://raw.githubusercontent.com/%s/%s/%s/", GITHUB_USER, GITHUB_REPO, BRANCH)

-- Função para importar qualquer arquivo das pastas do nosso GitHub
local function Import(path)
    local url = BaseURL .. path
    local success, response = pcall(function()
        return game:HttpGet(url, true)
    end)
    if not success or not response then
        warn("[Recex Hub] Erro ao baixar módulo do GitHub: " .. path)
        return nil
    end
    local func, err = loadstring(response)
    if not func then
        warn("[Recex Hub] Erro de sintaxe no módulo " .. path .. ": " .. tostring(err))
        return nil
    end
    return func()
end

-- 1. Carrega a Intro 3D e a Biblioteca de UI (Lo-Fi Edition) da pasta Core/
local PlayIntro3D   = Import("Core/Intro3D.lua")
local CreateRecexUI = Import("Core/UILibrary.lua")

if PlayIntro3D and CreateRecexUI then
    -- Roda a Cinemática 3D e, quando terminar, abre o Hub e carrega a pasta Modules/
    PlayIntro3D(function()
        local Hub = CreateRecexUI()

        -- Cria as Abas Principais
        local Tabs = {
            Inicio    = Hub:CreateTab("Início"),
            Universal = Hub:CreateTab("Universal"),
            Visuals   = Hub:CreateTab("Visuais"),
            Recex     = Hub:CreateTab("Scripts Recex")
        }

        -- Conteúdo da Aba Início
        Tabs.Inicio:AddSection("Bem-vindo ao Recex Hub")

        Tabs.Inicio:AddButton("Verificar Sincronização GitHub", "Testa se todos os módulos estão atualizados", function()
            Hub.Notify("GitHub Sync", "Todos os módulos do Recex Hub estão online e atualizados!", 3.5)
        end)

        Tabs.Inicio:AddButton("Copiar Loadstring Oficial", "Copia o código de execução do Recex Hub para sua área de transferência", function()
            if setclipboard then
                setclipboard('loadstring(game:HttpGet("https://raw.githubusercontent.com/recex/Universal-script-Lua-by-recex/main/Loader.lua", true))()')
                Hub.Notify("Copiado!", "O Loadstring do Recex Hub foi copiado!", 3)
            else
                Hub.Notify("Aviso", "Seu executor não suporta a função setclipboard.", 3)
            end
        end)

        Tabs.Inicio:AddSection("Atalhos Rápidos")

        Tabs.Inicio:AddButton("Como usar a Rádio Lo-Fi", "Clique esquerdo no botão Lo-Fi pausa • Clique direito troca de música", function()
            Hub.Notify("Rádio Lo-Fi", "Use o botão '♪ Lo-Fi' na barra superior do Hub!", 3.5)
        end)

        -- 2. Carrega todos os nossos Scripts da pasta Modules/ na ordem certa
        local ModulesToLoad = {
            "Modules/Universal.lua",
            "Modules/Visuals.lua",
            "Modules/RecexScripts.lua",
            "Modules/Hubs.lua" ,
            "Modules/Spotify.lua" ,
            "Modules/Shaders.lua" ,
            "Modules/Parkour.lua" ,
        }

        for _, modPath in ipairs(ModulesToLoad) do
            task.spawn(function()
                local initModule = Import(modPath)
                if type(initModule) == "function" then
                    initModule(Hub, Tabs)
                end
            end)
        end

        Hub.Notify("Recex Hub", "Todos os módulos foram carregados! Made by recex", 4)
    end)
end
