-- [[ RECEX HUB — GITHUB MODULAR LOADER ]] --
-- [[ Made by recex ]] --

-- ⚠️ TROQUE PELO SEU USUÁRIO E NOME DO REPOSITÓRIO DO GITHUB:
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

-- 1. Carrega a Intro 3D e a Biblioteca de UI da pasta Core/
local PlayIntro3D   = Import("Core/Intro3D.lua")
local CreateRecexUI = Import("Core/UILibrary.lua")

if PlayIntro3D and CreateRecexUI then
    -- Roda a Cinemática 3D e, quando terminar, abre o Hub e carrega a pasta Modules/
    PlayIntro3D(function()
        local Hub = CreateRecexUI()

        -- Cria as Abas Oficiais
        local Tabs = {
            Inicio    = Hub:CreateTab("Início"),
            Universal = Hub:CreateTab("Universal"),
            Visuals   = Hub:CreateTab("Visuais"),
            Recex     = Hub:CreateTab("Scripts Recex")
        }

        -- Aba Início padrão
        Tabs.Inicio:AddSection("Informações do Repositório")
        Tabs.Inicio:AddButton("Testar Conexão GitHub", "Verifica se os módulos estão sincronizados", function()
            Hub.Notify("GitHub Sync", "Todos os módulos do Recex Hub estão atualizados!", 4)
        end)

        -- 2. Carrega os nossos Scripts da pasta Modules/ (Um por um!)
        local ModulesToLoad = {
            "Modules/Universal.lua",
            "Modules/Visuals.lua",
            "Modules/RecexScripts.lua"
        }

        for _, modPath in ipairs(ModulesToLoad) do
            task.spawn(function()
                local initModule = Import(modPath)
                if type(initModule) == "function" then
                    initModule(Hub, Tabs) -- Passa o Hub e as Abas para o módulo adicionar seus botões!
                end
            end)
        end

        Hub.Notify("Recex Hub", "Carregado via GitHub! Made by recex", 5)
    end)
end
