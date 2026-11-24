-- ==============================================================================
-- 🚀 RECEX HUB | MASTER LOADER V4 (SAFE UI ADAPTER & INTRO SYNC)
-- Corrige:
-- 1. Erro "attempt to call a nil value" (Linha 499 - CreateSection / Notify)
-- 2. Sincronização de Callback entre SelectorHub -> Intro3D/IntroVIP3D -> UILibrary
-- 3. Ponte de compatibilidade automática para VIP_Sovereign e os 10 Módulos Padrão
-- ==============================================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local RepoBase = "https://raw.githubusercontent.com/recex/Universal-script-Lua-by-recex/main/"

-- ==============================================================================
-- 📥 1. IMPORTADOR SEGURO COM ANTI-CACHE E LOG DE DIAGNÓSTICO
-- ==============================================================================
local function RecexImport(path)
    local url = RepoBase .. path .. "?t=" .. tostring(os.time())
    local ok, content = pcall(function()
        return game:HttpGet(url, true)
    end)

    if not ok or type(content) ~= "string" or #content == 0 then
        warn("[Recex Loader] ❌ Falha de rede ao baixar: " .. tostring(path))
        return nil
    end

    local fn, syntaxErr = loadstring(content, "@" .. path)
    if not fn then
        warn("[Recex Loader] ❌ Erro de sintaxe em " .. tostring(path) .. ": " .. tostring(syntaxErr))
        return nil
    end

    local runOk, result = pcall(fn)
    if not runOk then
        warn("[Recex Loader] ❌ Erro ao inicializar " .. tostring(path) .. ": " .. tostring(result))
        return nil
    end

    return result
end

-- ==============================================================================
-- 🔔 2. SISTEMA DE NOTIFICAÇÃO NATIVO DO LOADER (FALLBACK UNIVERSAL)
-- ==============================================================================
local function SafeNotify(title, message)
    task.spawn(function()
        local parent = (gethui and gethui()) or CoreGui
        local gui = parent:FindFirstChild("RecexUniversalNotify")
        if not gui then
            gui = Instance.new("ScreenGui")
            gui.Name = "RecexUniversalNotify"
            gui.ResetOnSpawn = false
            gui.Parent = parent

            local holder = Instance.new("Frame")
            holder.Name = "Holder"
            holder.Size = UDim2.new(0, 260, 0, 320)
            holder.Position = UDim2.new(1, -275, 1, -335)
            holder.BackgroundTransparency = 1
            holder.Parent = gui

            local layout = Instance.new("UIListLayout", holder)
            layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
            layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
            layout.Padding = UDim.new(0, 6)
        end

        local holder = gui:FindFirstChild("Holder")
        if not holder then return end

        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, 50)
        card.BackgroundColor3 = Color3.fromRGB(14, 15, 22)
        card.BackgroundTransparency = 0.08
        card.BorderSizePixel = 0
        card.Parent = holder
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 9)

        local stroke = Instance.new("UIStroke", card)
        stroke.Color = Color3.fromRGB(255, 200, 60)
        stroke.Thickness = 1.2

        local tLbl = Instance.new("TextLabel", card)
        tLbl.Size = UDim2.new(1, -16, 0, 18)
        tLbl.Position = UDim2.new(0, 8, 0, 5)
        tLbl.BackgroundTransparency = 1
        tLbl.Text = tostring(title or "Recex Hub")
        tLbl.Font = Enum.Font.GothamBlack
        tLbl.TextSize = 11
        tLbl.TextColor3 = Color3.fromRGB(255, 205, 65)
        tLbl.TextXAlignment = Enum.TextXAlignment.Left

        local mLbl = Instance.new("TextLabel", card)
        mLbl.Size = UDim2.new(1, -16, 0, 22)
        mLbl.Position = UDim2.new(0, 8, 0, 23)
        mLbl.BackgroundTransparency = 1
        mLbl.Text = tostring(message or "")
        mLbl.Font = Enum.Font.GothamMedium
        mLbl.TextSize = 10
        mLbl.TextColor3 = Color3.fromRGB(225, 228, 240)
        mLbl.TextXAlignment = Enum.TextXAlignment.Left
        mLbl.TextWrapped = true

        task.wait(3)
        if card and card.Parent then
            TweenService:Create(card, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
            task.wait(0.28)
            if card and card.Parent then card:Destroy() end
        end
    end)
end

-- ==============================================================================
-- 🧩 3. ADAPTADOR UNIVERSAL DE UI (IMPEDE ERROS DE NIL NA UILIBRARY)
-- ==============================================================================
local function WrapTab(rawTab)
    if type(rawTab) ~= "table" then
        rawTab = {}
    end

    local Wrapped = {}

    -- Procura um container ScrollingFrame/Frame interno caso a UILibrary exponha
    local function FindInternalContainer()
        for _, v in pairs(rawTab) do
            if typeof(v) == "Instance" and (v:IsA("ScrollingFrame") or v:IsA("Frame")) then
                return v
            end
        end
        return nil
    end

    -- 1. CreateSection / AddSection (Resolve o erro da Linha 499!)
    function Wrapped:CreateSection(sectionTitle)
        local fn = rawTab.CreateSection or rawTab.AddSection or rawTab.Section
        if type(fn) == "function" then
            return fn(rawTab, sectionTitle)
        end

        -- Se a UILibrary não tiver CreateSection nativo, cria um cabeçalho visual limpo
        local container = FindInternalContainer()
        if container then
            local secFrame = Instance.new("Frame")
            secFrame.Size = UDim2.new(1, -10, 0, 24)
            secFrame.BackgroundTransparency = 1
            secFrame.Parent = container

            local lbl = Instance.new("TextLabel", secFrame)
            lbl.Size = UDim2.new(1, -8, 1, 0)
            lbl.Position = UDim2.new(0, 4, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = tostring(sectionTitle or "")
            lbl.Font = Enum.Font.GothamBlack
            lbl.TextSize = 11
            lbl.TextColor3 = Color3.fromRGB(255, 205, 70)
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            return secFrame
        end
    end
    Wrapped.AddSection = Wrapped.CreateSection

    -- 2. CreateButton / AddButton
    function Wrapped:CreateButton(text, callback)
        local fn = rawTab.CreateButton or rawTab.AddButton or rawTab.Button
        if type(fn) == "function" then
            return fn(rawTab, text, callback or function() end)
        end
    end
    Wrapped.AddButton = Wrapped.CreateButton

    -- 3. CreateToggle / AddToggle (Suporta tanto (text, default, cb) quanto (text, cb))
    function Wrapped:CreateToggle(text, default, callback)
        if type(default) == "function" and callback == nil then
            callback = default
            default = false
        end
        local fn = rawTab.CreateToggle or rawTab.AddToggle or rawTab.Toggle
        if type(fn) == "function" then
            return fn(rawTab, text, default or false, callback or function() end)
        end
    end
    Wrapped.AddToggle = Wrapped.CreateToggle

    -- 4. CreateSlider / AddSlider
    function Wrapped:CreateSlider(text, min, max, default, callback)
        local fn = rawTab.CreateSlider or rawTab.AddSlider or rawTab.Slider
        if type(fn) == "function" then
            return fn(rawTab, text, min or 0, max or 100, default or min or 0, callback or function() end)
        end
    end
    Wrapped.AddSlider = Wrapped.CreateSlider

    -- Mantém acesso a qualquer outra propriedade original da aba
    return setmetatable(Wrapped, {
        __index = function(_, k)
            return rawTab[k]
        end
    })
end

local function WrapWindow(rawWindow)
    local WrappedWin = {}

    function WrappedWin:CreateTab(tabName)
        local fn = rawWindow.CreateTab or rawWindow.AddTab or rawWindow.NewTab or rawWindow.Tab
        if type(fn) == "function" then
            local ok, rawTab = pcall(fn, rawWindow, tabName)
            if ok and rawTab then
                return WrapTab(rawTab)
            end
        end
        return WrapTab({})
    end
    WrappedWin.AddTab = WrappedWin.CreateTab

    function WrappedWin:Notify(title, msg)
        local fn = rawWindow.Notify or rawWindow.SendNotification
        if type(fn) == "function" then
            pcall(fn, rawWindow, title, msg)
        else
            SafeNotify(title, msg)
        end
    end

    return setmetatable(WrappedWin, {
        __index = function(_, k)
            return rawWindow[k]
        end
    })
end

-- ==============================================================================
-- 🏗️ 4. CONSTRUTOR PRINCIPAL DO HUB (UILIBRARY + VIP + 10 MÓDULOS PADRÃO)
-- ==============================================================================
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

local HubAlreadyBuilt = false

local function BuildRecexHub(isVIP, vipData)
    if HubAlreadyBuilt then return end
    HubAlreadyBuilt = true

    local UILibrary = RecexImport("Core/UILibrary.lua")
    if not UILibrary then
        warn("[Recex Loader] ❌ Core/UILibrary.lua não pôde ser carregada!")
        return
    end

    local hubTitle = isVIP and "👑 Recex Sovereign VIP | by recex" or "⚡ Recex Hub | made by recex"
    local rawWindow = nil

    if type(UILibrary) == "table" then
        local createFn = UILibrary.CreateWindow or UILibrary.new or UILibrary.Init
        if type(createFn) == "function" then
            local ok, win = pcall(createFn, UILibrary, hubTitle)
            if ok and win then rawWindow = win end
        else
            rawWindow = UILibrary
        end
    elseif type(UILibrary) == "function" then
        local ok, win = pcall(UILibrary, hubTitle)
        if ok and win then rawWindow = win end
    end

    if not rawWindow then
        warn("[Recex Loader] ❌ Falha ao instanciar a janela da UILibrary!")
        return
    end

    local Window = WrapWindow(rawWindow)

    -- Ambiente Global Recex passado para todos os módulos
    local RecexEnv = {
        Version = "4.0 Sovereign",
        Author = "recex",
        IsVIP = isVIP,
        VIPData = vipData,
        Import = RecexImport,
        Notify = function(_, t, m) Window:Notify(t, m) end
    }

    -- Abas Base + Metatable Inteligente (Se um módulo pedir uma aba não listada, cria na hora!)
    local BaseTabs = {
        Universal = Window:CreateTab("🌍 Universal"),
        Visuals   = Window:CreateTab("👁️ Visuais & ESP"),
        Recex     = Window:CreateTab("⚡ Recex (40)"),
        Hubs      = Window:CreateTab("🔥 Hubs (58)")
    }

    local Tabs = setmetatable(BaseTabs, {
        __index = function(tbl, key)
            local autoTab = Window:CreateTab("✨ " .. tostring(key))
            rawset(tbl, key, autoTab)
            return autoTab
        end
    })

    -- 1. Carrega o Módulo VIP (se entrou pelo modo Sovereign VIP)
    if isVIP then
        local VIPModule = RecexImport("Modules/VIP_Sovereign.lua")
        if type(VIPModule) == "function" then
            local ok, err = pcall(VIPModule, Window, Tabs, RecexEnv, vipData)
            if not ok then
                warn("[Recex Loader] ⚠️ Erro em Modules/VIP_Sovereign.lua: " .. tostring(err))
            end
        end
    end

    -- 2. Carrega os 10 Módulos Padrão com isolamento de erro individual
    for _, modPath in ipairs(StandardModules) do
        local ModFn = RecexImport(modPath)
        if type(ModFn) == "function" then
            local ok, err = pcall(ModFn, Window, Tabs, RecexEnv)
            if not ok then
                warn("[Recex Loader] ⚠️ Erro em " .. modPath .. ": " .. tostring(err))
            end
        end
    end

    Window:Notify("⚡ Recex Hub Pronto", isVIP and "Sovereign VIP & YARHM carregados!" or "Edição Free carregada com sucesso!")
end

-- ==============================================================================
-- 🎬 5. TRANSIÇÃO SEGURA: SELECTOR HUB -> INTRO 3D -> BUILD HUB
-- ==============================================================================
local function SafePlayFreeIntroAndBuild()
    local started = false
    local function Finish()
        if started then return end
        started = true
        BuildRecexHub(false, nil)
    end

    local Intro3D = RecexImport("Core/Intro3D.lua")
    if type(Intro3D) == "function" then
        -- Passa Finish como callback caso o Intro3D espere onComplete,
        -- e também chama Finish após o término caso o Intro3D seja síncrono!
        task.spawn(function()
            pcall(Intro3D, Finish)
            task.wait(0.2)
            Finish()
        end)
    else
        Finish()
    end
end

local function SafePlayVIPIntroAndBuild(vipData)
    local started = false
    local function Finish()
        if started then return end
        started = true
        BuildRecexHub(true, vipData)
    end

    local IntroVIP3D = RecexImport("Core/IntroVIP3D.lua")
    if type(IntroVIP3D) == "function" then
        task.spawn(function()
            pcall(IntroVIP3D, vipData, Finish)
            task.wait(0.2)
            Finish()
        end)
    else
        Finish()
    end
end

-- Inicializa o SelectorHub
local RunSelectorHub = RecexImport("Core/SelectorHub.lua")

if type(RunSelectorHub) == "function" then
    local ok, err = pcall(RunSelectorHub, SafePlayFreeIntroAndBuild, SafePlayVIPIntroAndBuild)
    if not ok then
        warn("[Recex Loader] ⚠️ Erro no SelectorHub: " .. tostring(err))
        BuildRecexHub(false, nil)
    end
else
    warn("[Recex Loader] ⚠️ Core/SelectorHub.lua indisponível. Abrindo Hub direto...")
    BuildRecexHub(false, nil)
end