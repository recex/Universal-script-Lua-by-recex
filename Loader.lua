--[[
    RECEX HUB - MASTER LAUNCHER V3 (SELETOR GRÁTIS VS. SOVEREIGN VIP PAGO)
    made by recex
]]

local GITHUB_USER = "recex"
local GITHUB_REPO = "Universal-script-Lua-by-recex"
local BRANCH      = "main"

local BaseURL = string.format("https://raw.githubusercontent.com/%s/%s/%s/", GITHUB_USER, GITHUB_REPO, BRANCH)

local function Import(path)
    local url = BaseURL .. path .. "?t=" .. tostring(os.time())
    local ok, code = pcall(function()
        return game:HttpGet(url, true)
    end)

    if not ok or type(code) ~= "string" or #code == 0 or code:sub(1, 3) == "404" then
        warn("[Recex Hub] Arquivo não encontrado no GitHub (404): " .. path)
        return nil
    end

    code = code:gsub("^\239\187\191", "")

    local fn, syntaxErr = loadstring(code)
    if not fn then
        warn("[Recex Hub] Erro de sintaxe em " .. path .. ": " .. tostring(syntaxErr))
        return nil
    end

    local runOk, result = pcall(fn)
    if not runOk then
        warn("[Recex Hub] Erro ao executar " .. path .. ": " .. tostring(result))
        return nil
    end

    return result
end

local StandardModules = {
    "Modules/Universal.lua",
    "Modules/Visuals.lua",
    "Modules/RecexScripts.lua",
    "Modules/Hubs.lua",
    "Modules/Spotify.lua",
    "Modules/Shaders.lua",
    "Modules/Parkour.lua",
    "Modules/Waypoints.lua",
    "Modules/Vehicles.lua",
    "Modules/Automation.lua"
}

-- Função que constrói o Hub (Modo Grátis ou Modo Sovereign VIP)
local function BuildRecexHub(isVIP, vipData)
    local CreateHub = Import("Core/UILibrary.lua")
    if type(CreateHub) ~= "function" then return end

    local Hub = CreateHub()

    local Tabs = {
        Inicio    = Hub:CreateTab(isVIP and "👑 Início VIP" or "Início"),
        Universal = Hub:CreateTab("Universal"),
        Visuals   = Hub:CreateTab("Visuais"),
        Recex     = Hub:CreateTab("Recex Scripts")
    }

    if isVIP and vipData then
        Tabs.Inicio:AddSection("Passaporte Sovereign VIP Verificado")
        Tabs.Inicio:AddButton("Cargo: " .. tostring(vipData.Role), "Plano Ativo: " .. tostring(vipData.Plan), function()
            Hub.Notify("👑 Sovereign VIP", "Sua assinatura VIP está ativa e validada na nuvem!", 4)
        end)
    else
        Tabs.Inicio:AddSection("Edição Gratuita • Recex Hub")
        Tabs.Inicio:AddButton("Status: Edição Grátis Ativa", "Adquira o Sovereign VIP no Discord para recursos exclusivos!", function()
            Hub.Notify("Recex Hub", "Você está usando a Edição Gratuita.", 3)
        end)
    end

    Tabs.Inicio:AddSection("Sincronização & Links")

    Tabs.Inicio:AddButton("Verificar Sincronização GitHub", "Testa a conexão com o repositório recex", function()
        Hub.Notify("GitHub Sync", "Todos os módulos sincronizados em tempo real!", 4)
    end)

    Tabs.Inicio:AddButton("Copiar Loadstring Oficial", "Copia o código de execução do Recex Hub", function()
        if setclipboard then
            setclipboard('loadstring(game:HttpGet("https://raw.githubusercontent.com/' .. GITHUB_USER .. '/' .. GITHUB_REPO .. '/' .. BRANCH .. '/Loader.lua", true))()')
            Hub.Notify("Copiado!", "Loadstring copiada para a área de transferência.", 3)
        end
    end)

    -- Se entrou pelo modo PAGO, carrega primeiro o Módulo Exclusivo VIP!
    if isVIP then
        task.spawn(function()
            local InitVIP = Import("Modules/VIP_Sovereign.lua")
            if type(InitVIP) == "function" then
                pcall(InitVIP, Hub, Tabs, vipData)
            end
        end)
    end

    -- Carrega todos os demais módulos
    for _, modulePath in ipairs(StandardModules) do
        task.spawn(function()
            local InitModule = Import(modulePath)
            if type(InitModule) == "function" then
                pcall(InitModule, Hub, Tabs)
            end
        end)
    end
end

-- ============================================================================
-- PASSO 1: ABRE O MINI-HUB SELETOR (GRÁTIS VS. VIP PAGO)
-- ============================================================================
local OpenSelector = Import("Core/SelectorHub.lua")

if type(OpenSelector) == "function" then
    OpenSelector({
        -- Se a pessoa escolheu o GRÁTIS:
        OnSelectFree = function()
            local RunFreeIntro = Import("Core/Intro3D.lua")
            if type(RunFreeIntro) == "function" then
                RunFreeIntro(function()
                    BuildRecexHub(false, nil)
                end)
            else
                BuildRecexHub(false, nil)
            end
        end,

        -- Se a pessoa foi ACEITA no VIP PAGO:
        OnSelectVIP = function(vipData)
            local RunVIPIntro = Import("Core/IntroVIP3D.lua")
            if type(RunVIPIntro) == "function" then
                RunVIPIntro(vipData, function()
                    BuildRecexHub(true, vipData)
                end)
            else
                BuildRecexHub(true, vipData)
            end
        end
    })
else
    warn("[Recex Hub] Core/SelectorHub.lua não encontrado no GitHub!")
end