-- [[ RECEX HUB — CORE/INTRO3D.LUA ]] --
-- [[ Módulo da Cinemática 3D Studio ]] --

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

local Palette = {
    Obsidian  = Color3.fromRGB(10, 11, 15),
    Titanium  = Color3.fromRGB(24, 26, 34),
    Gold      = Color3.fromRGB(255, 200, 115),
    Violet    = Color3.fromRGB(145, 95, 255),
    PureWhite = Color3.fromRGB(255, 255, 255),
    MutedText = Color3.fromRGB(150, 155, 170)
}

local function PlayUISound(id, vol, pitch)
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://" .. tostring(id)
    s.Volume = vol or 0.4
    s.PlaybackSpeed = pitch or 1
    s.Parent = SoundService
    s:Play()
    task.delay(4, function() if s then s:Destroy() end end)
    return s
end

local function RunStudioIntro(onComplete)
    if PlayerGui:FindFirstChild("RecexStudioIntro") then PlayerGui.RecexStudioIntro:Destroy() end
    if Camera:FindFirstChild("RecexSanctuary3D") then Camera.RecexSanctuary3D:Destroy() end

    local SavedLighting = {
        ClockTime = Lighting.ClockTime,
        Brightness = Lighting.Brightness,
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        CamType = Camera.CameraType,
        CamFOV = Camera.FieldOfView
    }

    local CineBloom = Instance.new("BloomEffect", Lighting)
    CineBloom.Intensity = 1.4; CineBloom.Size = 32; CineBloom.Threshold = 0.82

    local CineColor = Instance.new("ColorCorrectionEffect", Lighting)
    CineColor.Contrast = 0.22; CineColor.Saturation = 0.15; CineColor.TintColor = Color3.fromRGB(245, 238, 255)

    local CineDOF = Instance.new("DepthOfFieldEffect", Lighting)
    CineDOF.FarIntensity = 0.35; CineDOF.NearIntensity = 0.15; CineDOF.FocusDistance = 25; CineDOF.InFocusRadius = 20

    local Origin = Vector3.new(20000, 8000, 20000)
    local CorePos = Origin + Vector3.new(0, 16, 0)

    local Scene = Instance.new("Folder", Camera)
    Scene.Name = "RecexSanctuary3D"

    local function Part(size, cf, color, mat, trans, shape)
        local p = Instance.new("Part")
        p.Size = size; p.CFrame = cf; p.Color = color
        p.Material = mat or Enum.Material.SmoothPlastic
        p.Transparency = trans or 0
        if shape then p.Shape = shape end
        p.Anchored = true; p.CanCollide = false; p.CastShadow = false
        p.Parent = Scene
        return p
    end

    local SkyVault = Part(Vector3.new(2000, 2000, 2000), CFrame.new(Origin), Color3.fromRGB(5, 5, 8))
    local VaultMesh = Instance.new("SpecialMesh", SkyVault)
    VaultMesh.MeshType = Enum.MeshType.Sphere; VaultMesh.Scale = Vector3.new(-1, -1, -1)

    local WaterMirror = Part(Vector3.new(1000, 1, 1000), CFrame.new(Origin - Vector3.new(0, 0.5, 0)), Palette.Obsidian, Enum.Material.Glass, 0.05)
    WaterMirror.Reflectance = 0.45

    Part(Vector3.new(10, 0.6, 160), CFrame.new(Origin + Vector3.new(0, 0.1, 55)), Palette.Titanium, Enum.Material.Metal)
    Part(Vector3.new(0.25, 0.65, 160), CFrame.new(Origin + Vector3.new(-4.6, 0.1, 55)), Palette.Gold, Enum.Material.Neon)
    Part(Vector3.new(0.25, 0.65, 160), CFrame.new(Origin + Vector3.new(4.6, 0.1, 55)), Palette.Gold, Enum.Material.Neon)

    for i = 1, 4 do
        local stepRadius = 26 - (i * 4.5)
        local stepHeight = i * 0.8
        Part(Vector3.new(stepRadius, 0.8, stepRadius), CFrame.new(Origin + Vector3.new(0, stepHeight - 0.4, 0)) * CFrame.Angles(0, math.rad(i * 22.5), 0), Palette.Titanium, Enum.Material.Metal)
        Part(Vector3.new(stepRadius + 0.3, 0.15, stepRadius + 0.3), CFrame.new(Origin + Vector3.new(0, stepHeight, 0)) * CFrame.Angles(0, math.rad(i * 22.5), 0), Palette.Gold, Enum.Material.Neon)
    end

    for i = 1, 5 do
        local zPos = 22 + (i * 18)
        for _, side in ipairs({-1, 1}) do
            local baseCF = CFrame.new(Origin + Vector3.new(side * 16, 16, zPos)) * CFrame.Angles(0, 0, math.rad(side * 8))
            Part(Vector3.new(2.2, 34, 3.5), baseCF, Palette.Titanium, Enum.Material.Metal)
            Part(Vector3.new(0.3, 32, 0.4), baseCF * CFrame.new(-side * 1.15, 0, 0), Palette.Gold, Enum.Material.Neon)
        end
    end

    for i = 1, 4 do
        local topAttPart = Part(Vector3.new(1, 1, 1), CFrame.new(CorePos + Vector3.new((i - 2.5) * 14, 85, -15)), Palette.PureWhite, Enum.Material.SmoothPlastic, 1)
        local botAttPart = Part(Vector3.new(1, 1, 1), CFrame.new(Origin + Vector3.new((i - 2.5) * 8, 0, 0)), Palette.PureWhite, Enum.Material.SmoothPlastic, 1)
        local godRay = Instance.new("Beam", topAttPart)
        godRay.Attachment0 = Instance.new("Attachment", topAttPart)
        godRay.Attachment1 = Instance.new("Attachment", botAttPart)
        godRay.Width0 = 14; godRay.Width1 = 26; godRay.LightEmission = 1
        godRay.Color = ColorSequence.new(Palette.Gold, Palette.Violet)
        godRay.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.3, 0.91),
            NumberSequenceKeypoint.new(0.8, 0.94),
            NumberSequenceKeypoint.new(1, 1)
        })
        godRay.FaceCamera = true
    end

    local function BuildAstrolabeRing(radius, segs, thick, depth, accentColor, hasFins)
        local group = {}
        local segLen = (2 * math.pi * radius) / segs * 1.03
        for i = 1, segs do
            local ang = (i / segs) * math.pi * 2
            local baseOffset = CFrame.Angles(0, ang, 0) * CFrame.new(0, 0, -radius)
            local hull = Part(Vector3.new(segLen, thick, depth), CFrame.new(CorePos) * baseOffset, Palette.Titanium, Enum.Material.Metal)
            table.insert(group, {part = hull, offset = baseOffset})

            local innerRimOffset = baseOffset * CFrame.new(0, 0, depth * 0.48)
            local innerRim = Part(Vector3.new(segLen * 0.95, thick * 0.35, 0.18), CFrame.new(CorePos) * innerRimOffset, accentColor, Enum.Material.Neon)
            table.insert(group, {part = innerRim, offset = innerRimOffset})

            if hasFins and (i % 3 == 0) then
                local finOffset = baseOffset * CFrame.new(0, 0, -depth * 0.65)
                local fin = Part(Vector3.new(thick * 0.5, thick * 1.7, depth * 0.8), CFrame.new(CorePos) * finOffset, Palette.Obsidian, Enum.Material.Metal)
                table.insert(group, {part = fin, offset = finOffset})

                local finTipOffset = finOffset * CFrame.new(0, 0, -depth * 0.45)
                local finTip = Part(Vector3.new(thick * 0.25, thick * 1.4, 0.15), CFrame.new(CorePos) * finTipOffset, accentColor, Enum.Material.Neon)
                table.insert(group, {part = finTip, offset = finTipOffset})
            end
        end
        return group
    end

    local function TransformGroup(group, centerCF)
        for _, item in ipairs(group) do item.part.CFrame = centerCF * item.offset end
    end

    Part(Vector3.new(4.8, 4.8, 4.8), CFrame.new(CorePos), Color3.fromRGB(0, 0, 0), Enum.Material.SmoothPlastic, 0, Enum.PartType.Ball)
    Part(Vector3.new(5.3, 5.3, 5.3), CFrame.new(CorePos), Palette.Gold, Enum.Material.ForceField, 0.15, Enum.PartType.Ball)
    Part(Vector3.new(6.4, 6.4, 6.4), CFrame.new(CorePos), Palette.Violet, Enum.Material.ForceField, 0.45, Enum.PartType.Ball)

    local Ring1 = BuildAstrolabeRing(6.8,  24, 0.55, 0.9, Palette.Gold, false)
    local Ring2 = BuildAstrolabeRing(9.2,  30, 0.75, 1.3, Palette.Violet, true)
    local Ring3 = BuildAstrolabeRing(12.2, 36, 0.95, 1.6, Palette.Gold, true)
    local Ring4 = BuildAstrolabeRing(15.8, 42, 0.50, 0.8, Palette.PureWhite, false)

    local OrbitLightTrails = {}
    for i = 1, 4 do
        local orb = Part(Vector3.new(0.45, 0.45, 0.45), CFrame.new(CorePos), Palette.Gold, Enum.Material.Neon, 0, Enum.PartType.Ball)
        local attTop = Instance.new("Attachment", orb); attTop.Position = Vector3.new(0, 0.3, 0)
        local attBot = Instance.new("Attachment", orb); attBot.Position = Vector3.new(0, -0.3, 0)
        local trail = Instance.new("Trail", orb)
        trail.Attachment0 = attTop; trail.Attachment1 = attBot
        trail.Lifetime = 0.65; trail.LightEmission = 1
        trail.Color = ColorSequence.new((i % 2 == 0) and Palette.Gold or Palette.Violet, Palette.PureWhite)
        trail.Transparency = NumberSequence.new(0.1, 1); trail.WidthScale = NumberSequence.new(1, 0)
        table.insert(OrbitLightTrails, {part = orb, radius = 7.5 + (i * 1.8), speed = 2.2 + (i * 0.4), phase = i * (math.pi / 2), tilt = math.rad(i * 40)})
    end

    local Gui = Instance.new("ScreenGui", PlayerGui)
    Gui.Name = "RecexStudioIntro"; Gui.IgnoreGuiInset = true; Gui.ResetOnSpawn = false

    local TopLetterbox = Instance.new("Frame", Gui)
    TopLetterbox.Size = UDim2.new(1, 0, 0.10, 0); TopLetterbox.BackgroundColor3 = Color3.fromRGB(0, 0, 0); TopLetterbox.BorderSizePixel = 0

    local BotLetterbox = Instance.new("Frame", Gui)
    BotLetterbox.Size = UDim2.new(1, 0, 0.12, 0); BotLetterbox.Position = UDim2.new(0, 0, 0.88, 0); BotLetterbox.BackgroundColor3 = Color3.fromRGB(0, 0, 0); BotLetterbox.BorderSizePixel = 0

    local CenterTitleBox = Instance.new("Frame", Gui)
    CenterTitleBox.Size = UDim2.new(0, 600, 0, 140); CenterTitleBox.Position = UDim2.new(0.5, 0, 0.16, 0); CenterTitleBox.AnchorPoint = Vector2.new(0.5, 0); CenterTitleBox.BackgroundTransparency = 1

    local TitleLayout = Instance.new("UIListLayout", CenterTitleBox)
    TitleLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; TitleLayout.VerticalAlignment = Enum.VerticalAlignment.Center; TitleLayout.Padding = UDim.new(0, 10); TitleLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local StudioTag = Instance.new("TextLabel", CenterTitleBox)
    StudioTag.LayoutOrder = 1; StudioTag.Size = UDim2.new(1, 0, 0, 16); StudioTag.BackgroundTransparency = 1; StudioTag.Text = "R E C E X   S T U D I O S   P R E S E N T S"; StudioTag.TextColor3 = Palette.Gold; StudioTag.Font = Enum.Font.GothamBold; StudioTag.TextSize = 11; StudioTag.TextTransparency = 1

    local BigTitle = Instance.new("TextLabel", CenterTitleBox)
    BigTitle.LayoutOrder = 2; BigTitle.Size = UDim2.new(1, 0, 0, 46); BigTitle.BackgroundTransparency = 1; BigTitle.Text = "R E C E X   H U B"; BigTitle.TextColor3 = Palette.PureWhite; BigTitle.Font = Enum.Font.GothamBlack; BigTitle.TextSize = 42; BigTitle.TextTransparency = 1

    local TitleGrad = Instance.new("UIGradient", BigTitle)
    TitleGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Palette.PureWhite), ColorSequenceKeypoint.new(0.6, Color3.fromRGB(235, 225, 255)), ColorSequenceKeypoint.new(1, Palette.Gold)}); TitleGrad.Rotation = 90

    local GoldLine = Instance.new("Frame", CenterTitleBox)
    GoldLine.LayoutOrder = 3; GoldLine.Size = UDim2.new(0, 0, 0, 1); GoldLine.BackgroundColor3 = Palette.Gold; GoldLine.BorderSizePixel = 0

    local SubCaption = Instance.new("TextLabel", CenterTitleBox)
    SubCaption.LayoutOrder = 4; SubCaption.Size = UDim2.new(1, 0, 0, 18); SubCaption.BackgroundTransparency = 1; SubCaption.Text = "UNIVERSAL SUITE  •  MADE BY RECEX"; SubCaption.TextColor3 = Palette.MutedText; SubCaption.Font = Enum.Font.GothamMedium; SubCaption.TextSize = 12; SubCaption.TextTransparency = 1

    local BottomHUD = Instance.new("Frame", BotLetterbox)
    BottomHUD.Size = UDim2.new(0, 520, 0, 42); BottomHUD.Position = UDim2.new(0.5, 0, 0.5, 0); BottomHUD.AnchorPoint = Vector2.new(0.5, 0.5); BottomHUD.BackgroundTransparency = 1

    local ModuleLabel = Instance.new("TextLabel", BottomHUD)
    ModuleLabel.Size = UDim2.new(0.75, 0, 0, 18); ModuleLabel.BackgroundTransparency = 1; ModuleLabel.Text = "Inicializando ambiente..."; ModuleLabel.TextColor3 = Palette.MutedText; ModuleLabel.Font = Enum.Font.GothamMedium; ModuleLabel.TextSize = 12; ModuleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local PercentLabel = Instance.new("TextLabel", BottomHUD)
    PercentLabel.Size = UDim2.new(0.25, 0, 0, 18); PercentLabel.Position = UDim2.new(0.75, 0, 0, 0); PercentLabel.BackgroundTransparency = 1; PercentLabel.Text = "0%"; PercentLabel.TextColor3 = Palette.Gold; PercentLabel.Font = Enum.Font.GothamBold; PercentLabel.TextSize = 12; PercentLabel.TextXAlignment = Enum.TextXAlignment.Right

    local TrackBar = Instance.new("Frame", BottomHUD)
    TrackBar.Size = UDim2.new(1, 0, 0, 2); TrackBar.Position = UDim2.new(0, 0, 0, 26); TrackBar.BackgroundColor3 = Color3.fromRGB(28, 30, 38); TrackBar.BorderSizePixel = 0

    local FillBar = Instance.new("Frame", TrackBar)
    FillBar.Size = UDim2.new(0, 0, 1, 0); FillBar.BackgroundColor3 = Palette.Gold; FillBar.BorderSizePixel = 0

    local SkipBtn = Instance.new("TextButton", BotLetterbox)
    SkipBtn.Size = UDim2.new(0, 110, 0, 28); SkipBtn.Position = UDim2.new(1, -25, 0.5, 0); SkipBtn.AnchorPoint = Vector2.new(1, 0.5); SkipBtn.BackgroundColor3 = Color3.fromRGB(18, 19, 24); SkipBtn.Text = "PULAR INTRO ›"; SkipBtn.TextColor3 = Palette.MutedText; SkipBtn.Font = Enum.Font.GothamSemibold; SkipBtn.TextSize = 11
    Instance.new("UICorner", SkipBtn).CornerRadius = UDim.new(0, 4)
    local SkipStroke = Instance.new("UIStroke", SkipBtn); SkipStroke.Color = Color3.fromRGB(40, 42, 52); SkipStroke.Thickness = 1

    local WhiteOut = Instance.new("Frame", Gui)
    WhiteOut.Size = UDim2.new(1, 0, 1, 0); WhiteOut.BackgroundColor3 = Palette.Obsidian; WhiteOut.BackgroundTransparency = 0; WhiteOut.BorderSizePixel = 0

    local skipped = false
    local totalDuration = 6.8
    local elapsed = 0
    local coreAngle = 0

    Lighting.ClockTime = 0; Lighting.Brightness = 0.5
    Lighting.Ambient = Color3.fromRGB(18, 18, 25); Lighting.OutdoorAmbient = Color3.fromRGB(18, 18, 25)
    Camera.CameraType = Enum.CameraType.Scriptable

    local droneSound = PlayUISound(9114221580, 0.45, 0.85)
    PlayUISound(9119713951, 0.5, 1.0)

    local renderConn
    local function CleanUpAndFinish()
        if renderConn then renderConn:Disconnect() end
        if droneSound then droneSound:Stop() end
        if Scene then Scene:Destroy() end
        if CineBloom then CineBloom:Destroy() end
        if CineColor then CineColor:Destroy() end
        if CineDOF then CineDOF:Destroy() end

        Lighting.ClockTime = SavedLighting.ClockTime
        Lighting.Brightness = SavedLighting.Brightness
        Lighting.Ambient = SavedLighting.Ambient
        Lighting.OutdoorAmbient = SavedLighting.OutdoorAmbient
        Camera.FieldOfView = SavedLighting.CamFOV
        Camera.CameraType = SavedLighting.CamType

        if Gui then Gui:Destroy() end
        if onComplete then onComplete() end
    end

    SkipBtn.MouseButton1Click:Connect(function()
        if skipped then return end
        skipped = true
        PlayUISound(6895079853, 0.5, 1.1)
        CleanUpAndFinish()
    end)

    local modulesList = {
        "Conectando ao GitHub RecexHub/Core...",
        "Sincronizando geometria do Astrolábio...",
        "Autenticando sessão (" .. LocalPlayer.Name .. ")...",
        "Carregando RecexHub/Core/UILibrary.lua...",
        "Importando pasta RecexHub/Modules/...",
        "Pronto."
    }

    renderConn = RunService.RenderStepped:Connect(function(dt)
        if skipped then return end
        elapsed = elapsed + dt
        local progress = math.clamp(elapsed / totalDuration, 0, 1)
        local spinVel = 0.7 + (progress ^ 2) * 6.5
        coreAngle = coreAngle + (dt * spinVel)

        PercentLabel.Text = math.floor(progress * 100) .. "%"
        FillBar.Size = UDim2.new(progress, 0, 1, 0)
        ModuleLabel.Text = modulesList[math.clamp(math.ceil(progress * #modulesList), 1, #modulesList)]

        local cCF = CFrame.new(CorePos)
        TransformGroup(Ring1, cCF * CFrame.Angles(coreAngle * 1.5, coreAngle * 0.8, 0))
        TransformGroup(Ring2, cCF * CFrame.Angles(-coreAngle * 0.9, coreAngle * 1.1, math.rad(35)))
        TransformGroup(Ring3, cCF * CFrame.Angles(coreAngle * 0.5, -coreAngle * 0.7, math.rad(-28)))
        TransformGroup(Ring4, cCF * CFrame.Angles(math.rad(15), coreAngle * 0.3, math.rad(15)))

        for _, orbData in ipairs(OrbitLightTrails) do
            local a = (elapsed * orbData.speed) + orbData.phase
            orbData.part.CFrame = cCF * CFrame.Angles(orbData.tilt, a, 0) * CFrame.new(0, 0, -orbData.radius)
        end

        if elapsed < 2.3 then
            local t = elapsed / 2.3
            Camera.FieldOfView = 62 - (t * 6); CineDOF.FocusDistance = 55
            Camera.CFrame = CFrame.new(Origin + Vector3.new(0, 3.2 + (t * 2.5), 68 - (t * 24)), CorePos - Vector3.new(0, 3, 0))
        elseif elapsed < 4.5 then
            local t = (elapsed - 2.3) / 2.2
            Camera.FieldOfView = 45; CineDOF.FocusDistance = 14
            local angle = math.rad(-35 + (t * 50))
            Camera.CFrame = CFrame.new(CorePos + Vector3.new(math.sin(angle) * 14.5, -2.5 + (t * 4), math.cos(angle) * 14.5), CorePos + Vector3.new(0, 0.5, 0))
        else
            local t = math.clamp((elapsed - 4.5) / 2.3, 0, 1)
            Camera.FieldOfView = 58 + (t ^ 3) * 35; CineDOF.FocusDistance = 30
            Camera.CFrame = CFrame.new(Origin + Vector3.new(0, 11 - (t * 2), 32 - (t ^ 4) * 28), CorePos)
        end
    end)

    TweenService:Create(WhiteOut, TweenInfo.new(1.1, Enum.EasingStyle.Sine), {BackgroundTransparency = 1}):Play()
    task.wait(1.2); if skipped then return end
    TweenService:Create(StudioTag, TweenInfo.new(0.8), {TextTransparency = 0}):Play()
    task.wait(0.25); if skipped then return end
    TweenService:Create(BigTitle, TweenInfo.new(0.9), {TextTransparency = 0}):Play()
    TweenService:Create(GoldLine, TweenInfo.new(1.0, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 280, 0, 1)}):Play()
    task.wait(0.3); if skipped then return end
    TweenService:Create(SubCaption, TweenInfo.new(0.9), {TextTransparency = 0}):Play()

    task.wait(totalDuration - 2.15); if skipped then return end
    PlayUISound(9114224721, 0.65, 1.0)
    WhiteOut.BackgroundColor3 = Palette.PureWhite
    local finalFlash = TweenService:Create(WhiteOut, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 0})
    finalFlash:Play()
    finalFlash.Completed:Wait()
    if skipped then return end
    CleanUpAndFinish()
end

return RunStudioIntro
