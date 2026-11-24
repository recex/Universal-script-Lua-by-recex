-- ==============================================================================
-- 🚀 RECEX HUB | MASTER LOADER V3 (ANTI-CACHE + DUAL KEY & YARHM VIP)
-- Repositório: https://github.com/recex/Universal-script-Lua-by-recex
-- ==============================================================================

local RepoBase = "https://raw.githubusercontent.com/recex/Universal-script-Lua-by-recex/main/"

-- Função de importação com Anti-Cache e diagnóstico de erros no F9
local function RecexImport(path)
    local url = RepoBase .. path .. "?t=" .. tostring(os.time())
    local ok, content = pcall(function()
        return game:HttpGet(url, true)
    end)

    if not ok or not content then
        warn("[Recex Loader] ❌ Falha ao baixar: " .. tostring(path))
        return nil
    end

    local fn, syntaxErr = loadstring(content)
    if not fn then
        warn("[Recex Loader] ❌ Erro de sintaxe em " .. tostring(path) .. ": " .. tostring(syntaxErr))
        return nil
    end

    local runOk, result = pcall(fn)
    if not runOk then
        warn("[Recex Loader] ❌ Erro ao executar " .. tostring(path) .. ": " .. tostring(result))
        return nil
    end

    return result
end

-- Ambiente Compartilhado do Recex Hub
local RecexEnv = {
    Version = "3.5 Sovereign",
    Author = "recex",
    Import = RecexImport
}

-- Lista dos 10 Módulos Padrão (Carregados no Free e no VIP)
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

-- Construtor Principal da Interface e Módulos
local function BuildRecexHub(isVIP, vipData)
    local UILibrary = RecexImport("Core/UILibrary.lua")
    if not UILibrary then
        warn("[Recex Loader] ❌ Core/UILibrary.lua não pôde ser carregada!")
        return
    end

    local hubTitle = isVIP and "👑 Recex Sovereign VIP | by recex" or "⚡ Recex Hub | made by recex"
    local Window = UILibrary:CreateWindow(hubTitle)

    -- Abas Base esperadas pelos módulos clássicos
    local Tabs = {
        Universal = Window:CreateTab("🌍 Universal"),
        Visuals   = Window:CreateTab("👁️ Visuais & ESP"),
        Recex     = Window:CreateTab("⚡ Recex (40)"),
        Hubs      = Window:CreateTab("🔥 Hubs (58)")
    }

    -- Se for VIP, carrega primeiro as Abas Exclusivas do YARHM VIP
    if isVIP then
        local VIPModule = RecexImport("Modules/VIP_Sovereign.lua")
        if type(VIPModule) == "function" then
            local ok, err = pcall(VIPModule, Window, Tabs, RecexEnv, vipData)
            if not ok then
                warn("[Recex Loader] ⚠️ Erro no módulo VIP_Sovereign.lua: " .. tostring(err))
            end
        end
    end

    -- Carrega todos os 10 Módulos Padrão
    for _, modPath in ipairs(StandardModules) do
        local ModFn = RecexImport(modPath)
        if type(ModFn) == "function" then
            local ok, err = pcall(ModFn, Window, Tabs, RecexEnv)
            if not ok then
                warn("[Recex Loader] ⚠️ Erro no módulo " .. modPath .. ": " .. tostring(err))
            end
        end
    end
end

-- ==============================================================================
-- 🔐 FLUXO DE INICIALIZAÇÃO: ABRE PRIMEIRO O SELECTOR HUB (FREE KEY / VIP KEY)
-- ==============================================================================
local RunSelectorHub = RecexImport("Core/SelectorHub.lua")

if type(RunSelectorHub) == "function" then
    RunSelectorHub(
        -- 1. Quando validar a Key Free 24h:
        function()
            local RunFreeIntro = RecexImport("Core/Intro3D.lua")
            if type(RunFreeIntro) == "function" then
                pcall(RunFreeIntro)
            end
            BuildRecexHub(false, nil)
        end,

        -- 2. Quando validar a Key VIP / Bot do Discord:
        function(vipData)
            local RunVIPIntro = RecexImport("Core/IntroVIP3D.lua")
            if type(RunVIPIntro) == "function" then
                RunVIPIntro(vipData, function()
                    BuildRecexHub(true, vipData)
                end)
            else
                BuildRecexHub(true, vipData)
            end
        end
    )
else
    warn("[Recex Loader] ⚠️ Core/SelectorHub.lua não encontrado! Iniciando modo de segurança...")
    BuildRecexHub(false, nil)
end