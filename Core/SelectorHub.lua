--[[
    RECEX HUB - MINI-HUB LAUNCHER (SELETOR GRÁTIS VS. PAGO + API VALIDATOR)
    made by recex
]]

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- URL da sua API de Membros VIP no GitHub (Vamos criar esse arquivo ou usar a lista embutida + nuvem)
local VIP_API_URL = "https://raw.githubusercontent.com/recex/Universal-script-Lua-by-recex/main/VIP_API.json"

-- Lista Mestre de Segurança (Você é reconhecido como DONO automaticamente + Keys VIP)
local MasterVIPDatabase = {
    Owners = {
        ["recex"] = true,
        [tostring(LocalPlayer.UserId)] = false -- Você também pode colocar seu UserId aqui!
    },
    AuthorizedUsers = {
        -- Exemplo: ["123456789"] = "Vitalício (Discord Ticket)"
    },
    AuthorizedKeys = {
        ["RECEX-VIP-2025"]    = "Plano Vitalício (Lifetime)",
        ["RECEX-SOVEREIGN-1"] = "Membro Fundador VIP",
        ["RECEX-PRO-777"]     = "Assinatura VIP Mensal"
    }
}

local KEY_FILE = "RecexVIP_SavedAuth.txt"

local function PlayUIEffect(id, vol, speed)
    local s = Instance.new("Sound")
    s.SoundId = id
    s.Volume = vol or 0.45
    s.PlaybackSpeed = speed or 1
    s.Parent = SoundService
    s:Play()
    task.delay(2.5, function() s:Destroy() end)
end

-- Consulta a API na Nuvem em tempo real para ver se o comprador foi aceito no Discord
local function VerifyUserInCloud(inputKey)
    local userIdStr = tostring(LocalPlayer.UserId)
    local userNameLower = LocalPlayer.Name:lower()

    -- 1. Verifica se é o Dono (recex)
    if MasterVIPDatabase.Owners[userNameLower] or MasterVIPDatabase.Owners[userIdStr] then
        return true, "👑 FOUNDER / DONO", "Acesso Vitalício de Criador"
    end

    -- 2. Consulta o arquivo VIP_API.json na nuvem (para aprovar clientes sem mexer no script)
    local ok, rawJson = pcall(function()
        return game:HttpGet(VIP_API_URL .. "?t=" .. tostring(os.time()), true)
    end)

    if ok and type(rawJson) == "string" and #rawJson > 5 and rawJson:sub(1, 3) ~= "404" then
        local decodeOk, cloudData = pcall(function()
            return HttpService:JSONDecode(rawJson)
        end)
        if decodeOk and type(cloudData) == "table" then
            if cloudData.Users and cloudData.Users[userIdStr] then
                return true, "💎 VIP AUTORIZADO (ID)", cloudData.Users[userIdStr]
            end
            if cloudData.Users and cloudData.Users[userNameLower] then
                return true, "💎 VIP AUTORIZADO (NICK)", cloudData.Users[userNameLower]
            end
            if inputKey and #inputKey > 0 and cloudData.Keys and cloudData.Keys[inputKey] then
                return true, "💎 VIP AUTORIZADO (KEY)", cloudData.Keys[inputKey]
            end
        end
    end

    -- 3. Verifica no banco local do script
    if MasterVIPDatabase.AuthorizedUsers[userIdStr] then
        return true, "💎 VIP AUTORIZADO", MasterVIPDatabase.AuthorizedUsers[userIdStr]
    end
    if inputKey and #inputKey > 0 and MasterVIPDatabase.AuthorizedKeys[inputKey] then
        return true, "💎 VIP AUTORIZADO", MasterVIPDatabase.AuthorizedKeys[inputKey]
    end

    return false, "Não Autorizado", nil
end

local function OpenRecexLauncher(callbacks)
    -- callbacks.OnSelectFree() -> Inicia o Hub Grátis
    -- callbacks.OnSelectVIP(vipData) -> Inicia a Transição VIP + Hub Pago

    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local old = PlayerGui:FindFirstChild("RecexSelectorLauncher")
    if old then old:Destroy() end

    -- Desfoque elegante no fundo enquanto escolhe
    local Blur = Instance.new("BlurEffect")
    Blur.Name = "RecexLauncherBlur"
    Blur.Size = 0
    Blur.Parent = Lighting
    TweenService:Create(Blur, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = 18}):Play()

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RecexSelectorLauncher"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = PlayerGui

    -- Janela do Mini-Hub Seletor
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 460, 0, 290)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(11, 12, 17)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local UIScale = Instance.new("UIScale")
    UIScale.Scale = 0.75
    UIScale.Parent = MainFrame

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 14)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Thickness = 1.8
    MainStroke.Color = Color3.fromRGB(255, 255, 255)
    MainStroke.Parent = MainFrame

    local StrokeGrad = Instance.new("UIGradient")
    StrokeGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(245, 195, 70)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(225, 45, 85)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 80, 255))
    })
    StrokeGrad.Parent = MainStroke

    PlayUIEffect("rbxassetid://6895079853", 0.45, 0.95)
    TweenService:Create(UIScale, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()

    -- Título do Mini-Hub
    local TopBadge = Instance.new("TextLabel")
    TopBadge.Size = UDim2.new(1, -40, 0, 22)
    TopBadge.Position = UDim2.new(0, 20, 0, 14)
    TopBadge.BackgroundTransparency = 1
    TopBadge.Text = "⚡ RECEX STUDIO LAUNCHER • ESCOLHA SUA EDIÇÃO"
    TopBadge.TextColor3 = Color3.fromRGB(245, 195, 70)
    TopBadge.Font = Enum.Font.GothamBlack
    TopBadge.TextSize = 13
    TopBadge.TextXAlignment = Enum.TextXAlignment.Left
    TopBadge.Parent = MainFrame

    local SubDesc = Instance.new("TextLabel")
    SubDesc.Size = UDim2.new(1, -40, 0, 16)
    SubDesc.Position = UDim2.new(0, 20, 0, 34)
    SubDesc.BackgroundTransparency = 1
    SubDesc.Text = "Bem-vindo, " .. LocalPlayer.DisplayName .. " (ID: " .. tostring(LocalPlayer.UserId) .. ")"
    SubDesc.TextColor3 = Color3.fromRGB(150, 155, 175)
    SubDesc.Font = Enum.Font.GothamMedium
    SubDesc.TextSize = 11
    SubDesc.TextXAlignment = Enum.TextXAlignment.Left
    SubDesc.Parent = MainFrame

    -- =========================================================================
    -- CARD ESQUERDO: EDIÇÃO GRÁTIS (NORMAL)
    -- =========================================================================
    local FreeCard = Instance.new("Frame")
    FreeCard.Size = UDim2.new(0, 195, 0, 210)
    FreeCard.Position = UDim2.new(0, 20, 0, 62)
    FreeCard.BackgroundColor3 = Color3.fromRGB(17, 19, 27)
    FreeCard.BorderSizePixel = 0
    FreeCard.Parent = MainFrame

    Instance.new("UICorner", FreeCard).CornerRadius = UDim.new(0, 10)
    local FreeStroke = Instance.new("UIStroke", FreeCard)
    FreeStroke.Color = Color3.fromRGB(60, 65, 90)
    FreeStroke.Thickness = 1.2

    local FreeTitle = Instance.new("TextLabel")
    FreeTitle.Size = UDim2.new(1, -20, 0, 22)
    FreeTitle.Position = UDim2.new(0, 10, 0, 14)
    FreeTitle.BackgroundTransparency = 1
    FreeTitle.Text = "🆓 EDIÇÃO GRÁTIS"
    FreeTitle.TextColor3 = Color3.fromRGB(235, 240, 255)
    FreeTitle.Font = Enum.Font.GothamBlack
    FreeTitle.TextSize = 13
    FreeTitle.Parent = FreeCard

    local FreeFeatures = Instance.new("TextLabel")
    FreeFeatures.Size = UDim2.new(1, -24, 0, 110)
    FreeFeatures.Position = UDim2.new(0, 12, 0, 42)
    FreeFeatures.BackgroundTransparency = 1
    FreeFeatures.Text = "• Intro 3D Santuário\n• 40 Scripts Recex\n• Spotify 200 Músicas\n• Shaders RTX & Parkour\n• Veículos & Auto-Farm\n• Acesso 100% Livre"
    FreeFeatures.TextColor3 = Color3.fromRGB(160, 165, 185)
    FreeFeatures.Font = Enum.Font.GothamMedium
    FreeFeatures.TextSize = 10
    FreeFeatures.TextXAlignment = Enum.TextXAlignment.Left
    FreeFeatures.TextYAlignment = Enum.TextYAlignment.Top
    FreeFeatures.Parent = FreeCard

    local LaunchFreeBtn = Instance.new("TextButton")
    LaunchFreeBtn.Size = UDim2.new(1, -24, 0, 36)
    LaunchFreeBtn.Position = UDim2.new(0, 12, 1, -48)
    LaunchFreeBtn.BackgroundColor3 = Color3.fromRGB(45, 50, 72)
    LaunchFreeBtn.Text = "ABRIR HUB GRÁTIS"
    LaunchFreeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    LaunchFreeBtn.Font = Enum.Font.GothamBlack
    LaunchFreeBtn.TextSize = 11
    LaunchFreeBtn.Parent = FreeCard
    Instance.new("UICorner", LaunchFreeBtn).CornerRadius = UDim.new(0, 8)

    -- =========================================================================
    -- CARD DIREITO: EDIÇÃO VIP PAGA (SOVEREIGN VIP)
    -- =========================================================================
    local VIPCard = Instance.new("Frame")
    VIPCard.Size = UDim2.new(0, 210, 0, 210)
    VIPCard.Position = UDim2.new(1, -230, 0, 62)
    VIPCard.BackgroundColor3 = Color3.fromRGB(20, 14, 22)
    VIPCard.BorderSizePixel = 0
    VIPCard.Parent = MainFrame

    Instance.new("UICorner", VIPCard).CornerRadius = UDim.new(0, 10)
    local VIPStroke = Instance.new("UIStroke", VIPCard)
    VIPStroke.Color = Color3.fromRGB(225, 45, 85)
    VIPStroke.Thickness = 1.5

    local VIPTitle = Instance.new("TextLabel")
    VIPTitle.Size = UDim2.new(1, -20, 0, 22)
    VIPTitle.Position = UDim2.new(0, 10, 0, 12)
    VIPTitle.BackgroundTransparency = 1
    VIPTitle.Text = "👑 SOVEREIGN VIP"
    VIPTitle.TextColor3 = Color3.fromRGB(245, 195, 70)
    VIPTitle.Font = Enum.Font.GothamBlack
    VIPTitle.TextSize = 13
    VIPTitle.Parent = VIPCard

    local VIPSub = Instance.new("TextLabel")
    VIPSub.Size = UDim2.new(1, -20, 0, 32)
    VIPSub.Position = UDim2.new(0, 10, 0, 34)
    VIPSub.BackgroundTransparency = 1
    VIPSub.Text = "Transição 3D Buraco Negro + Aimbot FOV + Morph Skin + Anti-Mod"
    VIPSub.TextColor3 = Color3.fromRGB(215, 180, 195)
    VIPSub.Font = Enum.Font.GothamMedium
    VIPSub.TextSize = 9
    VIPSub.TextWrapped = true
    VIPSub.Parent = VIPCard

    -- Campo de Key VIP (ou validação por ID do Discord)
    local savedKey = ""
    if isfile and readfile then
        pcall(function()
            if isfile(KEY_FILE) then savedKey = readfile(KEY_FILE) end
        end)
    end

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(1, -24, 0, 30)
    KeyInput.Position = UDim2.new(0, 12, 0, 72)
    KeyInput.BackgroundColor3 = Color3.fromRGB(12, 10, 15)
    KeyInput.Text = savedKey
    KeyInput.PlaceholderText = "Key VIP (ou vazio se aprovado por ID)"
    KeyInput.PlaceholderColor3 = Color3.fromRGB(115, 105, 120)
    KeyInput.TextColor3 = Color3.fromRGB(245, 195, 70)
    KeyInput.Font = Enum.Font.GothamBold
    KeyInput.TextSize = 10
    KeyInput.ClearTextOnFocus = false
    KeyInput.Parent = VIPCard
    Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 6)

    -- Botão Copiar ID para mandar no Discord
    local CopyIDBtn = Instance.new("TextButton")
    CopyIDBtn.Size = UDim2.new(1, -24, 0, 24)
    CopyIDBtn.Position = UDim2.new(0, 12, 0, 108)
    CopyIDBtn.BackgroundColor3 = Color3.fromRGB(32, 24, 38)
    CopyIDBtn.Text = "📋 Copiar Meu ID p/ Discord"
    CopyIDBtn.TextColor3 = Color3.fromRGB(200, 185, 225)
    CopyIDBtn.Font = Enum.Font.GothamBold
    CopyIDBtn.TextSize = 9
    CopyIDBtn.Parent = VIPCard
    Instance.new("UICorner", CopyIDBtn).CornerRadius = UDim.new(0, 6)

    local VIPStatus = Instance.new("TextLabel")
    VIPStatus.Size = UDim2.new(1, -16, 0, 18)
    VIPStatus.Position = UDim2.new(0, 8, 0, 138)
    VIPStatus.BackgroundTransparency = 1
    VIPStatus.Text = "Verificação via Discord / Cloud API"
    VIPStatus.TextColor3 = Color3.fromRGB(150, 145, 165)
    VIPStatus.Font = Enum.Font.GothamMedium
    VIPStatus.TextSize = 9
    VIPStatus.Parent = VIPCard

    local LaunchVIPBtn = Instance.new("TextButton")
    LaunchVIPBtn.Size = UDim2.new(1, -24, 0, 36)
    LaunchVIPBtn.Position = UDim2.new(0, 12, 1, -48)
    LaunchVIPBtn.BackgroundColor3 = Color3.fromRGB(225, 45, 85)
    LaunchVIPBtn.Text = "💎 ENTRAR NO VIP PAGO"
    LaunchVIPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    LaunchVIPBtn.Font = Enum.Font.GothamBlack
    LaunchVIPBtn.TextSize = 11
    LaunchVIPBtn.Parent = VIPCard
    Instance.new("UICorner", LaunchVIPBtn).CornerRadius = UDim.new(0, 8)

    -- =========================================================================
    -- AÇÕES DOS BOTÕES DO SELETOR
    -- =========================================================================
    CopyIDBtn.MouseButton1Click:Connect(function()
        local passport = string.format("Nick: %s | UserId: %s", LocalPlayer.Name, tostring(LocalPlayer.UserId))
        if setclipboard then
            setclipboard(passport)
            VIPStatus.Text = "✅ ID copiado! Envie no Discord do recex."
            VIPStatus.TextColor3 = Color3.fromRGB(245, 195, 70)
        end
    end)

    local function CloseSelectorAndRun(nextCallback)
        TweenService:Create(UIScale, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Scale = 0}):Play()
        TweenService:Create(Blur, TweenInfo.new(0.35), {Size = 0}):Play()
        task.wait(0.35)
        Blur:Destroy()
        ScreenGui:Destroy()
        nextCallback()
    end

    -- Clicou no Hub Grátis
    LaunchFreeBtn.MouseButton1Click:Connect(function()
        PlayUIEffect("rbxassetid://6895079853", 0.5, 1.05)
        CloseSelectorAndRun(function()
            if callbacks.OnSelectFree then
                callbacks.OnSelectFree()
            end
        end)
    end)

    -- Clicou no Hub Pago (VIP)
    LaunchVIPBtn.MouseButton1Click:Connect(function()
        VIPStatus.Text = "⏳ Consultando API VIP..."
        VIPStatus.TextColor3 = Color3.fromRGB(245, 195, 70)

        local typedKey = KeyInput.Text:gsub("^%s*(.-)%s*$", "%1")
        local isApproved, roleTitle, planName = VerifyUserInCloud(typedKey)

        if isApproved then
            if writefile and #typedKey > 0 then
                pcall(writefile, KEY_FILE, typedKey)
            end
            VIPStatus.Text = "✅ ACEITO: " .. roleTitle
            VIPStatus.TextColor3 = Color3.fromRGB(60, 240, 130)
            PlayUIEffect("rbxassetid://6895079853", 0.6, 1.15)
            task.wait(0.4)

            CloseSelectorAndRun(function()
                if callbacks.OnSelectVIP then
                    callbacks.OnSelectVIP({
                        Role = roleTitle,
                        Plan = planName
                    })
                end
            end)
        else
            VIPStatus.Text = "❌ Acesso Negado! Copie seu ID p/ Discord."
            VIPStatus.TextColor3 = Color3.fromRGB(255, 70, 85)
            PlayUIEffect("rbxassetid://6895079853", 0.45, 0.7)

            local origPos = VIPCard.Position
            for i = 1, 4 do
                VIPCard.Position = origPos + UDim2.new(0, (i % 2 == 0 and 6 or -6), 0, 0)
                task.wait(0.04)
            end
            VIPCard.Position = origPos
        end
    end)
end

return OpenRecexLauncher