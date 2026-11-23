-- [[ RECEX HUB — MODULES/SPOTIFY.LUA ]] --
-- [[ Recexify: Music Studio & Spotify Player (Lo-Fi, Chill Hip-Hop, Synth & Reverb) ]] --

return function(Hub, Tabs)
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local SoundService = game:GetService("SoundService")
    local Players = game:GetService("Players")

    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    -- Cria a Aba exclusiva do Spotify no Hub
    local TabSpotify = Hub:CreateTab("♪ Spotify")

    local Palette = {
        BgDark       = Color3.fromRGB(11, 11, 16),
        Card         = Color3.fromRGB(18, 19, 27),
        Border       = Color3.fromRGB(36, 38, 52),
        SpotifyGreen = Color3.fromRGB(30, 215, 96),
        Gold         = Color3.fromRGB(255, 202, 122),
        PureWhite    = Color3.fromRGB(245, 246, 252),
        MutedText    = Color3.fromRGB(140, 145, 165)
    }

    -- =========================================================================
    -- BIBLIOTECA DE MÚSICAS (LO-FI, CHILL HIP-HOP, JAZZ, SYNTHWAVE & PHONK)
    -- =========================================================================
    local Playlist = {
        -- Lo-Fi & Study Beats
        { Title = "Relaxed Scene",       Genre = "Lo-Fi Study",    Id = 1848354536 },
        { Title = "Cozy Night",          Genre = "Lo-Fi Chill",    Id = 9043887091 },
        { Title = "Late Night Coding",   Genre = "Lo-Fi Beats",    Id = 1841647093 },
        { Title = "Rainy Window",        Genre = "Lo-Fi Ambient",  Id = 9046863253 },
        { Title = "Midnight Coffee",     Genre = "Lo-Fi Vibes",    Id = 1837849285 },
        { Title = "Dreamy Bedroom",      Genre = "Lo-Fi Sleep",    Id = 1845341094 },

        -- Chill Hip-Hop & Boom Bap
        { Title = "Street Chill Hop",    Genre = "Chill Hip-Hop",  Id = 9047105533 },
        { Title = "Urban Sunset",        Genre = "Instrumental",   Id = 1845756489 },
        { Title = "Boom Bap Freestyle",  Genre = "Hip-Hop Beat",   Id = 1839841807 },
        { Title = "Subway Dreams",       Genre = "Chill Hop",      Id = 9048375035 },
        { Title = "Skatepark Vibes",     Genre = "Oldschool Hop",  Id = 1842802203 },

        -- Jazz Lounge & Smooth
        { Title = "Chill Jazz Cafe",     Genre = "Jazz Hop",       Id = 1837879082 },
        { Title = "Smooth Rhodes",       Genre = "Velvet Jazz",    Id = 1845016311 },
        { Title = "Tokyo Lounge",        Genre = "Midnight Jazz",  Id = 1843404009 },

        -- Synthwave, Cyber & Trap Beats
        { Title = "Neon Horizon",        Genre = "Synthwave",      Id = 1841979451 },
        { Title = "Night Drive 1984",    Genre = "Retrowave",      Id = 9045766377 },
        { Title = "Dark Drift Beat",     Genre = "Trap / Phonk",   Id = 1838674668 },
        { Title = "Astral Bassline",     Genre = "Future Bass",    Id = 1846458016 }
    }

    local CurrentIndex = 1
    local IsPlaying = true
    local ShuffleMode = false
    local CurrentVolume = 0.35

    -- Conecta ao player já existente da UILibrary (para não tocar 2 músicas juntas!)
    local MainSound = SoundService:FindFirstChild("RecexLofiPlayer")
    if not MainSound then
        MainSound = Instance.new("Sound", SoundService)
        MainSound.Name = "RecexLofiPlayer"
        MainSound.Looped = true
    end
    MainSound.Volume = CurrentVolume

    -- Efeitos de Estúdio (Reverb e Equalizador Bass Boost)
    local ReverbEffect = MainSound:FindFirstChildOfClass("ReverbSoundEffect") or Instance.new("ReverbSoundEffect", MainSound)
    ReverbEffect.Enabled = false
    ReverbEffect.DecayTime = 2.8
    ReverbEffect.Density = 0.85
    ReverbEffect.WetLevel = -4

    local BassEffect = MainSound:FindFirstChildOfClass("EqualizerSoundEffect") or Instance.new("EqualizerSoundEffect", MainSound)
    BassEffect.Enabled = false
    BassEffect.LowGain = 9
    BassEffect.MidGain = -2
    BassEffect.HighGain = 2

    -- Som extra de Chuva Relaxante (Toca junto com a música se ativado)
    local RainSound = SoundService:FindFirstChild("RecexRainLayer") or Instance.new("Sound", SoundService)
    RainSound.Name = "RecexRainLayer"
    RainSound.SoundId = "rbxassetid://9112758449"
    RainSound.Volume = 0.18
    RainSound.Looped = true

    -- =========================================================================
    -- MINI-PLAYER FLUTUANTE ESTILO SPOTIFY (COM EQUALIZADOR ANIMADO)
    -- =========================================================================
    local HubGui = PlayerGui:FindFirstChild("RecexStudioHub")
    local MiniPlayer, SongTitleLbl, SongGenreLbl, PlayPauseBtn
    local EqBars = {}

    if HubGui then
        MiniPlayer = Instance.new("Frame", HubGui)
        MiniPlayer.Name = "SpotifyMiniPlayer"
        MiniPlayer.Size = UDim2.new(0, 235, 0, 52)
        MiniPlayer.Position = UDim2.new(0, 20, 1, -72)
        MiniPlayer.BackgroundColor3 = Palette.BgDark
        MiniPlayer.BackgroundTransparency = 0.05
        Instance.new("UICorner", MiniPlayer).CornerRadius = UDim.new(0, 10)

        local MiniStroke = Instance.new("UIStroke", MiniPlayer)
        MiniStroke.Color = Palette.Border
        MiniStroke.Thickness = 1.2

        -- Caixa do Equalizador Verde Estilo Spotify
        local EqBox = Instance.new("Frame", MiniPlayer)
        EqBox.Size = UDim2.new(0, 36, 0, 36)
        EqBox.Position = UDim2.new(0, 8, 0.5, -18)
        EqBox.BackgroundColor3 = Palette.Card
        Instance.new("UICorner", EqBox).CornerRadius = UDim.new(0, 8)

        for i = 1, 4 do
            local bar = Instance.new("Frame", EqBox)
            bar.Size = UDim2.new(0, 4, 0, 12)
            bar.Position = UDim2.new(0, 5 + (i - 1) * 7, 1, -6)
            bar.AnchorPoint = Vector2.new(0, 1)
            bar.BackgroundColor3 = Palette.SpotifyGreen
            bar.BorderSizePixel = 0
            Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
            table.insert(EqBars, bar)
        end

        SongTitleLbl = Instance.new("TextLabel", MiniPlayer)
        SongTitleLbl.Size = UDim2.new(0, 110, 0, 16)
        SongTitleLbl.Position = UDim2.new(0, 52, 0, 9)
        SongTitleLbl.BackgroundTransparency = 1
        SongTitleLbl.Text = Playlist[1].Title
        SongTitleLbl.TextColor3 = Palette.PureWhite
        SongTitleLbl.Font = Enum.Font.GothamBold
        SongTitleLbl.TextSize = 11
        SongTitleLbl.TextTruncate = Enum.TextTruncate.AtEnd
        SongTitleLbl.TextXAlignment = Enum.TextXAlignment.Left

        SongGenreLbl = Instance.new("TextLabel", MiniPlayer)
        SongGenreLbl.Size = UDim2.new(0, 110, 0, 14)
        SongGenreLbl.Position = UDim2.new(0, 52, 0, 26)
        SongGenreLbl.BackgroundTransparency = 1
        SongGenreLbl.Text = "♪ " .. Playlist[1].Genre
        SongGenreLbl.TextColor3 = Palette.SpotifyGreen
        SongGenreLbl.Font = Enum.Font.GothamMedium
        SongGenreLbl.TextSize = 9
        SongGenreLbl.TextXAlignment = Enum.TextXAlignment.Left

        -- Botões do Mini-Player (Play/Pause e Próxima)
        PlayPauseBtn = Instance.new("TextButton", MiniPlayer)
        PlayPauseBtn.Size = UDim2.new(0, 26, 0, 26)
        PlayPauseBtn.Position = UDim2.new(1, -64, 0.5, -13)
        PlayPauseBtn.BackgroundColor3 = Palette.SpotifyGreen
        PlayPauseBtn.Text = "❚❚"
        PlayPauseBtn.TextColor3 = Palette.BgDark
        PlayPauseBtn.Font = Enum.Font.GothamBlack
        PlayPauseBtn.TextSize = 10
        Instance.new("UICorner", PlayPauseBtn).CornerRadius = UDim.new(1, 0)

        local NextMiniBtn = Instance.new("TextButton", MiniPlayer)
        NextMiniBtn.Size = UDim2.new(0, 26, 0, 26)
        NextMiniBtn.Position = UDim2.new(1, -32, 0.5, -13)
        NextMiniBtn.BackgroundColor3 = Palette.Card
        NextMiniBtn.Text = "►|"
        NextMiniBtn.TextColor3 = Palette.PureWhite
        NextMiniBtn.Font = Enum.Font.GothamBold
        NextMiniBtn.TextSize = 10
        Instance.new("UICorner", NextMiniBtn).CornerRadius = UDim.new(1, 0)

        local function PlayTrack(idx)
            CurrentIndex = idx
            local track = Playlist[CurrentIndex]
            MainSound.SoundId = "rbxassetid://" .. tostring(track.Id)
            MainSound:Play()
            IsPlaying = true
            if SongTitleLbl then SongTitleLbl.Text = track.Title end
            if SongGenreLbl then SongGenreLbl.Text = "♪ " .. track.Genre end
            if PlayPauseBtn then PlayPauseBtn.Text = "❚❚" end
            Hub.Notify("Recexify (Spotify)", "Tocando: " .. track.Title .. " [" .. track.Genre .. "]", 2.5)
        end

        local function NextTrack()
            if ShuffleMode then
                PlayTrack(math.random(1, #Playlist))
            else
                PlayTrack((CurrentIndex % #Playlist) + 1)
            end
        end

        PlayPauseBtn.MouseButton1Click:Connect(function()
            IsPlaying = not IsPlaying
            if IsPlaying then
                MainSound:Resume()
                PlayPauseBtn.Text = "❚❚"
            else
                MainSound:Pause()
                PlayPauseBtn.Text = "▶"
            end
        end)

        NextMiniBtn.MouseButton1Click:Connect(NextTrack)

        -- Animação das Barras do Equalizador reagindo à batida da música!
        RunService.RenderStepped:Connect(function(dt)
            if not MiniPlayer or not MiniPlayer.Parent then return end
            local loudness = MainSound.Playing and math.clamp(MainSound.PlaybackLoudness / 220, 0.15, 1) or 0.1
            for i, bar in ipairs(EqBars) do
                local wave = MainSound.Playing and (math.sin(tick() * (8 + i * 2)) * 0.35 + 0.65) or 0.2
                local h = math.clamp(math.floor(24 * loudness * wave), 4, 24)
                bar.Size = bar.Size:Lerp(UDim2.new(0, 4, 0, h), dt * 14)
            end
        end)

        -- =========================================================================
        -- ELEMENTOS DA ABA SPOTIFY NO HUB
        -- =========================================================================
        TabSpotify:AddSection("Controles do Player (Recexify)")

        TabSpotify:AddButton("⏯ Pausar / Retomar Música", "Pausa ou continua a faixa atual imediatamente", function()
            IsPlaying = not IsPlaying
            if IsPlaying then
                MainSound:Resume()
                if PlayPauseBtn then PlayPauseBtn.Text = "❚❚" end
            else
                MainSound:Pause()
                if PlayPauseBtn then PlayPauseBtn.Text = "▶" end
            end
        end)

        TabSpotify:AddButton("⏭ Próxima Música da Playlist", "Pula para a próxima batida Lo-Fi / Hip-Hop", function()
            NextTrack()
        end)

        TabSpotify:AddButton("⏮ Música Anterior", "Volta para a faixa anterior da lista", function()
            local prev = CurrentIndex - 1
            if prev < 1 then prev = #Playlist end
            PlayTrack(prev)
        end)

        TabSpotify:AddToggle("Mostrar Mini-Player Spotify na Tela", "Exibe ou oculta o card flutuante com equalizador no canto inferior", true, function(enabled)
            if MiniPlayer then MiniPlayer.Visible = enabled end
        end)

        TabSpotify:AddToggle("Modo Aleatório (Shuffle)", "Escolhe a próxima música de forma aleatória", false, function(enabled)
            ShuffleMode = enabled
        end)

        TabSpotify:AddSlider("Volume da Música (%)", 0, 100, 35, function(val)
            CurrentVolume = val / 100
            MainSound.Volume = CurrentVolume
        end)

        -- =========================================================================
        -- EFEITOS DE ESTÚDIO (SLOWED + REVERB, NIGHTCORE, CHUVA, BASS BOOST)
        -- =========================================================================
        TabSpotify:AddSection("Efeitos de Áudio & Ambiente")

        TabSpotify:AddToggle("Efeito Slowed + Reverb (Aesthetic)", "Deixa a música mais lenta (0.82x) com eco profundo de estúdio", false, function(enabled)
            ReverbEffect.Enabled = enabled
            MainSound.PlaybackSpeed = enabled and 0.82 or 1.0
            Hub.Notify("Estúdio de Áudio", enabled and "Modo Slowed + Reverb ativado!" or "Velocidade original restaurada.", 2.5)
        end)

        TabSpotify:AddToggle("Efeito Nightcore (Speed Up)", "Acelera a batida e o tom da música (1.22x)", false, function(enabled)
            MainSound.PlaybackSpeed = enabled and 1.22 or 1.0
            Hub.Notify("Estúdio de Áudio", enabled and "Modo Nightcore ativado!" or "Velocidade original restaurada.", 2.5)
        end)

        TabSpotify:AddToggle("Bass Boost (Reforço de Graves)", "Aumenta os graves do Hip-Hop e Lo-Fi no equalizador", false, function(enabled)
            BassEffect.Enabled = enabled
            Hub.Notify("Equalizador", enabled and "Bass Boost ativado!" or "Equalizador normal.", 2)
        end)

        TabSpotify:AddToggle("🌧️ Camada de Chuva Suave no Fundo", "Adiciona barulho relaxante de chuva na janela junto com a música", false, function(enabled)
            if enabled then
                RainSound:Play()
                Hub.Notify("Ambiente Lo-Fi", "Som de chuva ativado no fundo!", 2.5)
            else
                RainSound:Stop()
            end
        end)

        -- =========================================================================
        -- SELEÇÃO DIRETA DE TODAS AS 18 MÚSICAS POR ESTILO
        -- =========================================================================
        TabSpotify:AddSection("PlaylistCompleta (Clique para Tocar)")

        for idx, song in ipairs(Playlist) do
            TabSpotify:AddButton("♪ " .. song.Title, "Estilo: " .. song.Genre .. "  •  ID: " .. tostring(song.Id), function()
                PlayTrack(idx)
            end)
        end
    end
end
