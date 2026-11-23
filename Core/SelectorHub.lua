-- ==============================================================================
-- 🔐 CORE: Core/SelectorHub.lua (DUAL KEY SYSTEM: FREE 24H SITE + DISCORD VIP BOT)
-- Exige Key tanto na Edição Free (Site 24h) quanto na Edição VIP (Bot Discord/Cloud)
-- ==============================================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- 🌐 CONFIGURAÇÃO DOS LINKS (Site Oficial + API do Bot no GitHub)
local KEY_SITE_URL      = "https://recex.github.io/Universal-script-Lua-by-recex/"
local DISCORD_INVITE    = "https://discord.gg/recexhub" -- Troque pelo convite do seu Discord
local CLOUD_VIP_API_URL = "https://raw.githubusercontent.com/recex/Universal-script-Lua-by-recex/main/VIP_API.json"

local SAVED_FREE_FILE = "RecexHub_FreeKey.txt"
local SAVED_VIP_FILE  = "RecexHub_VIPKey.txt"

-- ==============================================================================
-- 🔑 1. MOTOR CRIPTOGRÁFICO (SINCRONIZADO COM O SITE E COM O BOT DO DISCORD)
-- ==============================================================================

-- Algoritmo interno usado pelo Site e pelo Hub para validar Keys Free de 24h por UserId
local function GenerateDailyFreeKey(userId, dayOffset)
    local utcDay = math.floor(os.time() / 86400) + (dayOffset or 0)
    local seedStr = "RECEX_FREE_SECRET_2025_" .. tostring(userId) .. "_" .. tostring(utcDay)
    local h1 = 5381
    local h2 = 52711
    for i = 1, #seedStr do
        local b = string.byte(seedStr, i)
        h1 = ((h1 * 33) + b) % 99999999
        h2 = ((h2 * 131) + b) % 99999999
    end
    return string.format("RXFREE-%06X-%06X", h1, h2)
end

-- Hash de Assinatura de Sessão VIP
local function RecexSign(str)
    str = tostring(str or "")
    local h = 2166136261
    for i = 1, #str do
        h = ((h + string.byte(str, i)) * 16777619) % 4294967295
    end
    return string.format("RXSIG-%08X", h)
end

-- Anti-Spoof de Identidade na Roblox
local function VerifyIdentity()
    local uid = LocalPlayer.UserId
    local uname = LocalPlayer.Name
    if uid <= 0 then return false, "Conta inválida" end
    if LocalPlayer.CharacterAppearanceId > 0 and LocalPlayer.CharacterAppearanceId ~= uid then
        return false, "Spoof de UserId detectado!"
    end
    local ok, realId = pcall(function()
        return Players:GetUserIdFromNameAsync(uname)
    end)
    if ok and realId and realId ~= uid then
        return false, "Spoof de Nome/ID detectado!"
    end
    return true, uid, uname:lower()
end

-- Dono / Founder (Acesso direto ou bypass de teste)
local FounderBypass = {
    ["recex"] = "👑 FOUNDER / DONO"
}

local function RunSelectorHub(OnSelectFree, OnSelectVIP)
    local SafeParent = (gethui and gethui()) or CoreGui
    if SafeParent:FindFirstChild("RecexDualKeyGUI") then
        SafeParent.RecexDualKeyGUI:Destroy()
    end

    local Blur = Instance.new("BlurEffect")
    Blur.Name = "RecexKeyBlur"
    Blur.Size = 0
    Blur.Parent = Lighting
    TweenService:Create(Blur, TweenInfo.new(0.5), {Size = 18}):Play()

    local Gui = Instance.new("ScreenGui")
    Gui.Name = "RecexDualKeyGUI"
    Gui.ResetOnSpawn = false
    Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Gui.Parent = SafeParent

    -- Frame Principal
    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 540, 0, 350)
    Main.Position = UDim2.new(0.5, -270, 0.5, -175)
    Main.BackgroundColor3 = Color3.fromRGB(11, 11, 16)
    Main.BorderSizePixel = 0
    Main.Parent = Gui
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Color = Color3.fromRGB(255, 200, 60)
    MainStroke.Thickness = 1.5
    MainStroke.Transparency = 0.2

    -- Topo / Cabeçalho
    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, -190, 0, 26)
    Title.Position = UDim2.new(0, 18, 0, 12)
    Title.BackgroundTransparency = 1
    Title.Text = "🔐 RECEX AUTHENTICATION SYSTEM"
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 15
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local SubTitle = Instance.new("TextLabel", Main)
    SubTitle.Size = UDim2.new(1, -190, 0, 18)
    SubTitle.Position = UDim2.new(0, 18, 0, 35)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = "Seu Roblox UserId: " .. tostring(LocalPlayer.UserId) .. "  •  Conectado ao Site & Bot Discord"
    SubTitle.Font = Enum.Font.GothamMedium
    SubTitle.TextSize = 11
    SubTitle.TextColor3 = Color3.fromRGB(160, 165, 185)
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left

    -- Botão Copiar UserId (Para colar no Site ou no Bot do Discord)
    local CopyIDBtn = Instance.new("TextButton", Main)
    CopyIDBtn.Size = UDim2.new(0, 160, 0, 28)
    CopyIDBtn.Position = UDim2.new(1, -176, 0, 16)
    CopyIDBtn.BackgroundColor3 = Color3.fromRGB(24, 26, 38)
    CopyIDBtn.Text = "📋 Copiar Meu UserId"
    CopyIDBtn.Font = Enum.Font.GothamBold
    CopyIDBtn.TextSize = 10
    CopyIDBtn.TextColor3 = Color3.fromRGB(255, 215, 75)
    Instance.new("UICorner", CopyIDBtn).CornerRadius = UDim.new(0, 8)

    CopyIDBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(tostring(LocalPlayer.UserId))
            CopyIDBtn.Text = "✅ ID Copiado: " .. tostring(LocalPlayer.UserId)
            task.delay(1.5, function()
                if CopyIDBtn and CopyIDBtn.Parent then
                    CopyIDBtn.Text = "📋 Copiar Meu UserId"
                end
            end)
        end
    end)

    -- ==========================================================================
    -- 🌐 COLUNA ESQUERDA: FREE EDITION (KEY 24H PELO SITE / DISCORD)
    -- ==========================================================================
    local FreeCard = Instance.new("Frame", Main)
    FreeCard.Size = UDim2.new(0, 244, 0, 265)
    FreeCard.Position = UDim2.new(0, 18, 0, 66)
    FreeCard.BackgroundColor3 = Color3.fromRGB(16, 18, 26)
    Instance.new("UICorner", FreeCard).CornerRadius = UDim.new(0, 12)

    local FreeStroke = Instance.new("UIStroke", FreeCard)
    FreeStroke.Color = Color3.fromRGB(65, 135, 255)
    FreeStroke.Thickness = 1.3
    FreeStroke.Transparency = 0.3

    local FreeTitle = Instance.new("TextLabel", FreeCard)
    FreeTitle.Size = UDim2.new(1, -20, 0, 22)
    FreeTitle.Position = UDim2.new(0, 12, 0, 12)
    FreeTitle.BackgroundTransparency = 1
    FreeTitle.Text = "🌐 FREE EDITION (KEY 24H)"
    FreeTitle.Font = Enum.Font.GothamBlack
    FreeTitle.TextSize = 13
    FreeTitle.TextColor3 = Color3.fromRGB(100, 170, 255)
    FreeTitle.TextXAlignment = Enum.TextXAlignment.Left

    local FreeInfo = Instance.new("TextLabel", FreeCard)
    FreeInfo.Size = UDim2.new(1, -24, 0, 52)
    FreeInfo.Position = UDim2.new(0, 12, 0, 36)
    FreeInfo.BackgroundTransparency = 1
    FreeInfo.Text = "• 10 Módulos + 40 Scripts Recex\n• Spotify 200 Músicas & Shaders RTX\n• Pegue sua Key gratuita no nosso Site!"
    FreeInfo.Font = Enum.Font.GothamMedium
    FreeInfo.TextSize = 10
    FreeInfo.TextColor3 = Color3.fromRGB(185, 195, 215)
    FreeInfo.TextXAlignment = Enum.TextXAlignment.Left
    FreeInfo.TextYAlignment = Enum.TextYAlignment.Top
    FreeInfo.TextWrapped = true

    -- Input da Key Free
    local FreeKeyBox = Instance.new("TextBox", FreeCard)
    FreeKeyBox.Size = UDim2.new(1, -24, 0, 32)
    FreeKeyBox.Position = UDim2.new(0, 12, 0, 94)
    FreeKeyBox.BackgroundColor3 = Color3.fromRGB(10, 11, 16)
    FreeKeyBox.PlaceholderText = "Cole sua Key Free (Ex: RXFREE-...)"
    FreeKeyBox.Text = ""
    FreeKeyBox.Font = Enum.Font.GothamBold
    FreeKeyBox.TextSize = 10
    FreeKeyBox.TextColor3 = Color3.fromRGB(130, 195, 255)
    FreeKeyBox.PlaceholderColor3 = Color3.fromRGB(105, 110, 130)
    FreeKeyBox.ClearTextOnFocus = false
    Instance.new("UICorner", FreeKeyBox).CornerRadius = UDim.new(0, 7)

    if isfile and readfile and isfile(SAVED_FREE_FILE) then
        pcall(function() FreeKeyBox.Text = readfile(SAVED_FREE_FILE) end)
    end

    local FreeStatus = Instance.new("TextLabel", FreeCard)
    FreeStatus.Size = UDim2.new(1, -24, 0, 24)
    FreeStatus.Position = UDim2.new(0, 12, 0, 130)
    FreeStatus.BackgroundTransparency = 1
    FreeStatus.Text = "🔒 Digite sua Key Free para liberar."
    FreeStatus.Font = Enum.Font.GothamBold
    FreeStatus.TextSize = 10
    FreeStatus.TextColor3 = Color3.fromRGB(160, 170, 190)
    FreeStatus.TextXAlignment = Enum.TextXAlignment.Left
    FreeStatus.TextWrapped = true

    -- Botão Copiar Link do Site Gerador de Key
    local GetSiteKeyBtn = Instance.new("TextButton", FreeCard)
    GetSiteKeyBtn.Size = UDim2.new(1, -24, 0, 32)
    GetSiteKeyBtn.Position = UDim2.new(0, 12, 0, 162)
    GetSiteKeyBtn.BackgroundColor3 = Color3.fromRGB(28, 36, 58)
    GetSiteKeyBtn.Text = "🌐 Pegar Key Free (Copiar Site)"
    GetSiteKeyBtn.Font = Enum.Font.GothamBold
    GetSiteKeyBtn.TextSize = 10
    GetSiteKeyBtn.TextColor3 = Color3.fromRGB(135, 195, 255)
    Instance.new("UICorner", GetSiteKeyBtn).CornerRadius = UDim.new(0, 8)

    GetSiteKeyBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(KEY_SITE_URL .. "?uid=" .. tostring(LocalPlayer.UserId))
            FreeStatus.Text = "✅ Link do Site copiado! Abra no navegador."
            FreeStatus.TextColor3 = Color3.fromRGB(100, 220, 255)
        end
    end)

    -- Botão Verificar & Abrir Free Hub
    local OpenFreeBtn = Instance.new("TextButton", FreeCard)
    OpenFreeBtn.Size = UDim2.new(1, -24, 0, 38)
    OpenFreeBtn.Position = UDim2.new(0, 12, 1, -50)
    OpenFreeBtn.BackgroundColor3 = Color3.fromRGB(55, 120, 245)
    OpenFreeBtn.Text = "VERIFICAR KEY & ABRIR FREE"
    OpenFreeBtn.Font = Enum.Font.GothamBlack
    OpenFreeBtn.TextSize = 10
    OpenFreeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", OpenFreeBtn).CornerRadius = UDim.new(0, 8)

    -- ==========================================================================
    -- 👑 COLUNA DIREITA: SOVEREIGN VIP (BOT DO DISCORD + CLOUD API)
    -- ==========================================================================
    local VIPCard = Instance.new("Frame", Main)
    VIPCard.Size = UDim2.new(0, 244, 0, 265)
    VIPCard.Position = UDim2.new(1, -262, 0, 66)
    VIPCard.BackgroundColor3 = Color3.fromRGB(20, 17, 12)
    Instance.new("UICorner", VIPCard).CornerRadius = UDim.new(0, 12)

    local VIPStroke = Instance.new("UIStroke", VIPCard)
    VIPStroke.Color = Color3.fromRGB(255, 195, 50)
    VIPStroke.Thickness = 1.5
    VIPStroke.Transparency = 0.15

    local VIPTitle = Instance.new("TextLabel", VIPCard)
    VIPTitle.Size = UDim2.new(1, -20, 0, 22)
    VIPTitle.Position = UDim2.new(0, 12, 0, 12)
    VIPTitle.BackgroundTransparency = 1
    VIPTitle.Text = "👑 SOVEREIGN YARHM VIP"
    VIPTitle.Font = Enum.Font.GothamBlack
    VIPTitle.TextSize = 13
    VIPTitle.TextColor3 = Color3.fromRGB(255, 210, 65)
    VIPTitle.TextXAlignment = Enum.TextXAlignment.Left

    local VIPInfo = Instance.new("TextLabel", VIPCard)
    VIPInfo.Size = UDim2.new(1, -24, 0, 52)
    VIPInfo.Position = UDim2.new(0, 12, 0, 36)
    VIPInfo.BackgroundTransparency = 1
    VIPInfo.Text = "• Todas as Funções YARHM 1.20 (MM2/FTF)\n• Barra Rápida Flutuante & Anti-Fling\n• Ativação via Key VIP ou Bot do Discord!"
    VIPInfo.Font = Enum.Font.GothamMedium
    VIPInfo.TextSize = 10
    VIPInfo.TextColor3 = Color3.fromRGB(225, 215, 190)
    VIPInfo.TextXAlignment = Enum.TextXAlignment.Left
    VIPInfo.TextYAlignment = Enum.TextYAlignment.Top
    VIPInfo.TextWrapped = true

    -- Input da Key VIP
    local VIPKeyBox = Instance.new("TextBox", VIPCard)
    VIPKeyBox.Size = UDim2.new(1, -24, 0, 32)
    VIPKeyBox.Position = UDim2.new(0, 12, 0, 94)
    VIPKeyBox.BackgroundColor3 = Color3.fromRGB(12, 10, 14)
    VIPKeyBox.PlaceholderText = "Cole sua Key VIP (Ex: RXVIP-...)"
    VIPKeyBox.Text = ""
    VIPKeyBox.Font = Enum.Font.GothamBold
    VIPKeyBox.TextSize = 10
    VIPKeyBox.TextColor3 = Color3.fromRGB(255, 220, 100)
    VIPKeyBox.PlaceholderColor3 = Color3.fromRGB(115, 110, 125)
    VIPKeyBox.ClearTextOnFocus = false
    Instance.new("UICorner", VIPKeyBox).CornerRadius = UDim.new(0, 7)

    if isfile and readfile and isfile(SAVED_VIP_FILE) then
        pcall(function() VIPKeyBox.Text = readfile(SAVED_VIP_FILE) end)
    end

    local VIPStatus = Instance.new("TextLabel", VIPCard)
    VIPStatus.Size = UDim2.new(1, -24, 0, 24)
    VIPStatus.Position = UDim2.new(0, 12, 0, 130)
    VIPStatus.BackgroundTransparency = 1
    VIPStatus.Text = "🔒 Digite sua Key VIP ou valide pelo ID."
    VIPStatus.Font = Enum.Font.GothamBold
    VIPStatus.TextSize = 10
    VIPStatus.TextColor3 = Color3.fromRGB(190, 180, 160)
    VIPStatus.TextXAlignment = Enum.TextXAlignment.Left
    VIPStatus.TextWrapped = true

    -- Botão Copiar Discord para Comprar / Resgatar no Bot
    local GetDiscordBtn = Instance.new("TextButton", VIPCard)
    GetDiscordBtn.Size = UDim2.new(1, -24, 0, 32)
    GetDiscordBtn.Position = UDim2.new(0, 12, 0, 162)
    GetDiscordBtn.BackgroundColor3 = Color3.fromRGB(42, 34, 20)
    GetDiscordBtn.Text = "💬 Discord VIP & Bot (Copiar Link)"
    GetDiscordBtn.Font = Enum.Font.GothamBold
    GetDiscordBtn.TextSize = 10
    GetDiscordBtn.TextColor3 = Color3.fromRGB(255, 215, 85)
    Instance.new("UICorner", GetDiscordBtn).CornerRadius = UDim.new(0, 8)

    GetDiscordBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(DISCORD_INVITE)
            VIPStatus.Text = "✅ Convite do Discord copiado!"
            VIPStatus.TextColor3 = Color3.fromRGB(255, 220, 90)
        end
    end)

    -- Botão Verificar & Abrir VIP Hub
    local OpenVIPBtn = Instance.new("TextButton", VIPCard)
    OpenVIPBtn.Size = UDim2.new(1, -24, 0, 38)
    OpenVIPBtn.Position = UDim2.new(0, 12, 1, -50)
    OpenVIPBtn.BackgroundColor3 = Color3.fromRGB(255, 195, 45)
    OpenVIPBtn.Text = "VERIFICAR KEY & ABRIR VIP"
    OpenVIPBtn.Font = Enum.Font.GothamBlack
    OpenVIPBtn.TextSize = 10
    OpenVIPBtn.TextColor3 = Color3.fromRGB(15, 15, 20)
    Instance.new("UICorner", OpenVIPBtn).CornerRadius = UDim.new(0, 8)

    -- Função para fechar o Launcher com transição suave
    local function CloseLauncher()
        TweenService:Create(Blur, TweenInfo.new(0.4), {Size = 0}):Play()
        task.delay(0.45, function()
            if Blur and Blur.Parent then Blur:Destroy() end
        end)
        Gui:Destroy()
    end

    -- Helper para consultar o banco de dados do Bot no GitHub (VIP_API.json)
    local function FetchCloudDatabase()
        local ok, resp = pcall(function()
            return game:HttpGet(CLOUD_VIP_API_URL .. "?nocache=" .. tostring(os.time()), true)
        end)
        if ok and resp then
            local decOk, data = pcall(function()
                return HttpService:JSONDecode(resp)
            end)
            if decOk and type(data) == "table" then
                return data
            end
        end
        return nil
    end

    -- ==========================================================================
    -- ✅ 2. VALIDAÇÃO DA KEY FREE (ACEITA KEY 24H DO SITE OU KEY DO BOT DISCORD)
    -- ==========================================================================
    OpenFreeBtn.MouseButton1Click:Connect(function()
        FreeStatus.Text = "⏳ Verificando Key Free..."
        FreeStatus.TextColor3 = Color3.fromRGB(120, 195, 255)

        local idOk, realUid, realLowerName = VerifyIdentity()
        if not idOk then
            FreeStatus.Text = "⛔ Erro: " .. tostring(realUid)
            FreeStatus.TextColor3 = Color3.fromRGB(255, 75, 75)
            return
        end

        local typedFree = (FreeKeyBox.Text or ""):gsub("^%s*(.-)%s*$", "%1"):upper()

        -- 1. Checa se é o Dono (Founder Bypass)
        local isFreeValid = (FounderBypass[realLowerName] ~= nil)

        -- 2. Checa se a Key bate com a Key Criptográfica de 24h gerada pelo Site para este UserId
        -- (Aceita o dia UTC atual ou o dia anterior para evitar erro de fuso horário à meia-noite)
        local validSiteKeyToday = GenerateDailyFreeKey(realUid, 0)
        local validSiteKeyYest  = GenerateDailyFreeKey(realUid, -1)

        if typedFree ~= "" and (typedFree == validSiteKeyToday or typedFree == validSiteKeyYest) then
            isFreeValid = true
        end

        -- 3. Checa também no VIP_API.json caso a Key Free tenha sido gerada pelo Bot do Discord
        if not isFreeValid and typedFree ~= "" then
            local db = FetchCloudDatabase()
            if db then
                if type(db.FreeKeys) == "table" and db.FreeKeys[typedFree] then
                    local fk = db.FreeKeys[typedFree]
                    if type(fk) == "string" or (type(fk) == "table" and (tostring(fk.UserId) == tostring(realUid) or fk.UserId == "ANY")) then
                        isFreeValid = true
                    end
                elseif type(db.Keys) == "table" and db.Keys[typedFree] then
                    -- Quem tem Key VIP também pode abrir o Free se quiser
                    isFreeValid = true
                end
            end
        end

        if isFreeValid then
            if writefile and typedFree ~= "" then
                pcall(function() writefile(SAVED_FREE_FILE, typedFree) end)
            end
            FreeStatus.Text = "✅ Key Free 24h Válida! Abrindo..."
            FreeStatus.TextColor3 = Color3.fromRGB(75, 255, 140)
            task.wait(0.4)
            CloseLauncher()
            OnSelectFree()
        else
            FreeStatus.Text = "❌ Key Inválida/Expirada! Pegue no Site."
            FreeStatus.TextColor3 = Color3.fromRGB(255, 75, 75)
        end
    end)

    -- ==========================================================================
    -- 👑 3. VALIDAÇÃO DA KEY VIP (BOT DO DISCORD + TRAVA DE USERID)
    -- ==========================================================================
    OpenVIPBtn.MouseButton1Click:Connect(function()
        VIPStatus.Text = "⏳ Consultando Bot & Cloud API..."
        VIPStatus.TextColor3 = Color3.fromRGB(255, 215, 80)

        local idOk, realUid, realLowerName = VerifyIdentity()
        if not idOk then
            VIPStatus.Text = "⛔ Erro: " .. tostring(realUid)
            VIPStatus.TextColor3 = Color3.fromRGB(255, 75, 75)
            return
        end

        local strUid = tostring(realUid)
        local typedVIP = (VIPKeyBox.Text or ""):gsub("^%s*(.-)%s*$", "%1")
        local authorizedRole = FounderBypass[realLowerName]

        if not authorizedRole then
            local db = FetchCloudDatabase()
            if not db then
                VIPStatus.Text = "⚠️ Erro ao ler API do GitHub."
                VIPStatus.TextColor3 = Color3.fromRGB(255, 90, 90)
                return
            end

            -- A) Verifica se o Bot do Discord autorizou direto pelo UserId ou Username
            if type(db.Users) == "table" then
                if db.Users[strUid] then
                    authorizedRole = tostring(db.Users[strUid])
                elseif db.Users[realLowerName] then
                    authorizedRole = tostring(db.Users[realLowerName])
                end
            end

            -- B) Verifica se digitou uma Key VIP gerada pelo Bot do Discord
            if not authorizedRole and typedVIP ~= "" and type(db.Keys) == "table" then
                local kData = db.Keys[typedVIP]
                if type(kData) == "string" then
                    authorizedRole = kData
                elseif type(kData) == "table" then
                    local lockedUid = tostring(kData.UserId or "ANY")
                    local expTime = tonumber(kData.ExpiresAt or 0)

                    if expTime > 0 and os.time() > expTime then
                        VIPStatus.Text = "⛔ Esta Key VIP expirou!"
                        VIPStatus.TextColor3 = Color3.fromRGB(255, 75, 75)
                        return
                    elseif lockedUid ~= "ANY" and lockedUid ~= "" and lockedUid ~= strUid then
                        VIPStatus.Text = "⛔ Key vinculada a outro UserId!"
                        VIPStatus.TextColor3 = Color3.fromRGB(255, 75, 75)
                        return
                    else
                        authorizedRole = tostring(kData.Plan or "💎 Sovereign VIP")
                    end
                end
            end
        end

        if authorizedRole then
            if writefile and typedVIP ~= "" then
                pcall(function() writefile(SAVED_VIP_FILE, typedVIP) end)
            end

            local stamp = os.time()
            local vipPayload = {
                User = LocalPlayer.Name,
                UserId = realUid,
                Role = authorizedRole,
                Timestamp = stamp,
                Signature = RecexSign("VIP_" .. strUid .. "_" .. tostring(stamp))
            }
            _G.__RECEX_VIP_SESSION = vipPayload

            VIPStatus.Text = "✅ VIP Autorizado: " .. authorizedRole
            VIPStatus.TextColor3 = Color3.fromRGB(80, 255, 135)
            task.wait(0.45)
            CloseLauncher()
            OnSelectVIP(vipPayload)
        else
            VIPStatus.Text = "❌ Key VIP Inválida! Abra ticket no Discord."
            VIPStatus.TextColor3 = Color3.fromRGB(255, 75, 75)
        end
    end)
end

return RunSelectorHub