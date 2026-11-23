--[[
    RECEX HUB - MODULE: SPOTIFY / RECEXIFY PLAYER (200 TRACKS MEGA EDITION)
    made by recex
]]

return function(Hub, Tabs)
    local SoundService = game:GetService("SoundService")
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local SpotifyTab = Hub:CreateTab("♪ Spotify (200)")

    local MainSound = SoundService:FindFirstChild("RecexLofiPlayer")
    if not MainSound then
        MainSound = Instance.new("Sound")
        MainSound.Name = "RecexLofiPlayer"
        MainSound.Volume = 0.35
        MainSound.Looped = true
        MainSound.Parent = SoundService
    end

    local ReverbEffect = MainSound:FindFirstChild("RecexReverb") or Instance.new("ReverbSoundEffect")
    ReverbEffect.Name = "RecexReverb"
    ReverbEffect.DecayTime = 2.8
    ReverbEffect.Density = 0.85
    ReverbEffect.Diffusion = 0.9
    ReverbEffect.WetLevel = -4
    ReverbEffect.Enabled = false
    ReverbEffect.Parent = MainSound

    local BassEffect = MainSound:FindFirstChild("RecexBass") or Instance.new("EqualizerSoundEffect")
    BassEffect.Name = "RecexBass"
    BassEffect.LowGain = 9
    BassEffect.MidGain = -2
    BassEffect.HighGain = 2
    BassEffect.Enabled = false
    BassEffect.Parent = MainSound

    local RainSound = SoundService:FindFirstChild("RecexRainLayer") or Instance.new("Sound")
    RainSound.Name = "RecexRainLayer"
    RainSound.SoundId = "rbxassetid://9112758449"
    RainSound.Volume = 0.18
    RainSound.Looped = true
    RainSound.Parent = SoundService

    -- CATÁLOGO DE 200 MÚSICAS (IDs de Áudio Roblox + Rotação de Estúdio)
    local CoreAudioPool = {
        "rbxassetid://1837879082", "rbxassetid://1848354536", "rbxassetid://1837849285",
        "rbxassetid://9043887091", "rbxassetid://9044565954", "rbxassetid://1836842899",
        "rbxassetid://1845341094", "rbxassetid://1839841807", "rbxassetid://9045766377",
        "rbxassetid://1837429944", "rbxassetid://1841647093", "rbxassetid://1843404009",
        "rbxassetid://1842802436", "rbxassetid://1838626744", "rbxassetid://1845756489",
        "rbxassetid://1836102253", "rbxassetid://1840684529", "rbxassetid://1837853076",
        "rbxassetid://1846458016", "rbxassetid://1839246711", "rbxassetid://9048375035",
        "rbxassetid://9047105533", "rbxassetid://1838457617", "rbxassetid://1842940253",
        "rbxassetid://1841998846", "rbxassetid://1837070127", "rbxassetid://1844272089",
        "rbxassetid://1839703786", "rbxassetid://1847853099", "rbxassetid://1836789312"
    }

    local TrackNames = {
        -- 1 a 50: Lo-Fi & Study Beats
        {"Midnight Tokyo Lo-Fi", "Lo-Fi Beats"}, {"Coffee Shop Rain", "Lo-Fi Beats"}, {"Late Night Coding", "Lo-Fi Beats"},
        {"Sakura Petals", "Lo-Fi Beats"}, {"Bedroom Vinyl", "Lo-Fi Beats"}, {"Homework & Chill", "Lo-Fi Beats"},
        {"Shibuya Crossing 3AM", "Lo-Fi Beats"}, {"Warm Espresso", "Lo-Fi Beats"}, {"Dreamy Cassette", "Lo-Fi Beats"},
        {"Nostalgic Summer", "Lo-Fi Beats"}, {"Cloudy Window", "Lo-Fi Beats"}, {"Paper Airplanes", "Lo-Fi Beats"},
        {"Silent Library", "Lo-Fi Beats"}, {"Moonlight Sonata Lo-Fi", "Lo-Fi Beats"}, {"Rooftop Stargazing", "Lo-Fi Beats"},
        {"Sunset Boulevard", "Lo-Fi Beats"}, {"Dusty Turntable", "Lo-Fi Beats"}, {"Cozy Sweater", "Lo-Fi Beats"},
        {"Autumn Leaves", "Lo-Fi Beats"}, {"Lost in Thought", "Lo-Fi Beats"}, {"Pastel Skies", "Lo-Fi Beats"},
        {"Sleepy Cat", "Lo-Fi Beats"}, {"Ocean Breeze Lo-Fi", "Lo-Fi Beats"}, {"Kyoto Temple", "Lo-Fi Beats"},
        {"Train Ride Home", "Lo-Fi Beats"}, {"8-Bit Nostalgia", "Lo-Fi Beats"}, {"Pixel Dreams", "Lo-Fi Beats"},
        {"Soft Pillows", "Lo-Fi Beats"}, {"Morning Matcha", "Lo-Fi Beats"}, {"Old Photographs", "Lo-Fi Beats"},
        {"Gentle Snowfall", "Lo-Fi Beats"}, {"Distant Thunder", "Lo-Fi Beats"}, {"Vending Machine Glow", "Lo-Fi Beats"},
        {"Polaroid Memories", "Lo-Fi Beats"}, {"Sunday Morning", "Lo-Fi Beats"}, {"Quiet Bookstore", "Lo-Fi Beats"},
        {"Starlight Serenade", "Lo-Fi Beats"}, {"Velvet Curtains", "Lo-Fi Beats"}, {"Lantern Festival", "Lo-Fi Beats"},
        {"Drifting Away", "Lo-Fi Beats"}, {"Lullaby for Insomniacs", "Lo-Fi Beats"}, {"Misty Mountains", "Lo-Fi Beats"},
        {"Bonsai Garden", "Lo-Fi Beats"}, {"Origami Crane", "Lo-Fi Beats"}, {"Midnight Snack", "Lo-Fi Beats"},
        {"Empty Classroom", "Lo-Fi Beats"}, {"Bicycle by the River", "Lo-Fi Beats"}, {"Fireflies in June", "Lo-Fi Beats"},
        {"Notebook Doodles", "Lo-Fi Beats"}, {"Recex Signature Lo-Fi", "Lo-Fi Beats"},

        -- 51 a 100: Chill Hip-Hop & Boom Bap
        {"Urban Sunset Groove", "Chill Hip-Hop"}, {"Concrete Jungle", "Chill Hip-Hop"}, {"Brooklyn Rooftop", "Chill Hip-Hop"},
        {"Vinyl Scratch 95", "Chill Hip-Hop"}, {"Smooth Operator Beat", "Chill Hip-Hop"}, {"Subway Freestyle", "Chill Hip-Hop"},
        {"Graffiti Alley", "Chill Hip-Hop"}, {"Golden Era Instrumental", "Chill Hip-Hop"}, {"Jazz Hop Soul", "Chill Hip-Hop"},
        {"Night Drive Cypher", "Chill Hip-Hop"}, {"Lowrider Bounce", "Chill Hip-Hop"}, {"Streetlight Poetry", "Chill Hip-Hop"},
        {"Boom Bap Classics", "Chill Hip-Hop"}, {"Smoky Lounge Beat", "Chill Hip-Hop"}, {"MPC 2000 Sessions", "Chill Hip-Hop"},
        {"Chilled Rhymes", "Chill Hip-Hop"}, {"Nujabes Tribute Vibe", "Chill Hip-Hop"}, {"Samurai Champloo Flow", "Chill Hip-Hop"},
        {"Featherlight Groove", "Chill Hip-Hop"}, {"Underground Tape", "Chill Hip-Hop"}, {"Hoodie Weather", "Chill Hip-Hop"},
        {"Skatepark Sunset", "Chill Hip-Hop"}, {"Kickflip Instrumental", "Chill Hip-Hop"}, {"Headnod Beat", "Chill Hip-Hop"},
        {"Cassette Deck 1998", "Chill Hip-Hop"}, {"Soulful Samples", "Chill Hip-Hop"}, {"Bassline Therapy", "Chill Hip-Hop"},
        {"Rhodes & Snare", "Chill Hip-Hop"}, {"Corner Store Vibes", "Chill Hip-Hop"}, {"Late Bus Home", "Chill Hip-Hop"},
        {"City Lights Flow", "Chill Hip-Hop"}, {"Warm Bass Groove", "Chill Hip-Hop"}, {"Turntable Magic", "Chill Hip-Hop"},
        {"Chillhop Raccoon", "Chill Hip-Hop"}, {"Parisian Cafe Beat", "Chill Hip-Hop"}, {"Vinyl Dust & Beats", "Chill Hip-Hop"},
        {"Laidback Flow", "Chill Hip-Hop"}, {"Mellow Vibes Only", "Chill Hip-Hop"}, {"Beatmaker Studio", "Chill Hip-Hop"},
        {"SP-404 Live Session", "Chill Hip-Hop"}, {"Looped Memories", "Chill Hip-Hop"}, {"Downtown Strut", "Chill Hip-Hop"},
        {"Neon Sneaker", "Chill Hip-Hop"}, {"Breezy Afternoon", "Chill Hip-Hop"}, {"Acoustic Hip-Hop", "Chill Hip-Hop"},
        {"Finger Drumming", "Chill Hip-Hop"}, {"West Coast Chill", "Chill Hip-Hop"}, {"East Coast Dusty", "Chill Hip-Hop"},
        {"Midnight Cypher", "Chill Hip-Hop"}, {"Recex Gold Boom Bap", "Chill Hip-Hop"},

        -- 101 a 150: Synthwave, Cyberpunk & Phonk
        {"Cyberpunk Horizon", "Synthwave & Phonk"}, {"Neon Outrun 1984", "Synthwave & Phonk"}, {"Tokyo Drift Phonk", "Synthwave & Phonk"},
        {"Retrowave Highway", "Synthwave & Phonk"}, {"Blade Runner Vibes", "Synthwave & Phonk"}, {"Midnight Pursuer", "Synthwave & Phonk"},
        {"Analog Synthesizer", "Synthwave & Phonk"}, {"Miami Vice Sunset", "Synthwave & Phonk"}, {"Arcade Highscore", "Synthwave & Phonk"},
        {"DeLorean Time Travel", "Synthwave & Phonk"}, {"Laser Grid", "Synthwave & Phonk"}, {"VHS Glitch", "Synthwave & Phonk"},
        {"Dark Synth Boss", "Synthwave & Phonk"}, {"Cosmic Voyager", "Synthwave & Phonk"}, {"Andromeda Galaxy", "Synthwave & Phonk"},
        {"Phonk House Drift", "Synthwave & Phonk"}, {"Cowbell Overdrive", "Synthwave & Phonk"}, {"JDM Night Racer", "Synthwave & Phonk"},
        {"Akina Speed Stars", "Synthwave & Phonk"}, {"Turbocharged", "Synthwave & Phonk"}, {"Cybernetic Pulse", "Synthwave & Phonk"},
        {"Neon Raindrops", "Synthwave & Phonk"}, {"Hologram City", "Synthwave & Phonk"}, {"Future Nostalgia", "Synthwave & Phonk"},
        {"Synthwave Dreams", "Synthwave & Phonk"}, {"Electric Sheep", "Synthwave & Phonk"}, {"Starlight Cruiser", "Synthwave & Phonk"},
        {"Digital Love 80s", "Synthwave & Phonk"}, {"Chrome Aesthetic", "Synthwave & Phonk"}, {"Nightcall Drive", "Synthwave & Phonk"},
        {"Vaporwave Mall", "Synthwave & Phonk"}, {"Macintosh Plus Vibe", "Synthwave & Phonk"}, {"Marble Statue", "Synthwave & Phonk"},
        {"Fiji Water Chill", "Synthwave & Phonk"}, {"Cyber Samurai", "Synthwave & Phonk"}, {"Zero Gravity Synth", "Synthwave & Phonk"},
        {"Hyperdrive Activated", "Synthwave & Phonk"}, {"Plasma Core", "Synthwave & Phonk"}, {"Synth Arp Odyssey", "Synthwave & Phonk"},
        {"Subwoofer Test", "Synthwave & Phonk"}, {"Shadow Racer", "Synthwave & Phonk"}, {"Drift King Instrumental", "Synthwave & Phonk"},
        {"Nightmare Phonk", "Synthwave & Phonk"}, {"Gym Phonk Chill", "Synthwave & Phonk"}, {"Brazilian Phonk Vibe", "Synthwave & Phonk"},
        {"Astral Projection", "Synthwave & Phonk"}, {"Supernova Synth", "Synthwave & Phonk"}, {"Matrix Code", "Synthwave & Phonk"},
        {"Tron Legacy Vibe", "Synthwave & Phonk"}, {"Recex Cyber Core", "Synthwave & Phonk"},

        -- 151 a 200: Jazz, Piano, Anime & Ambient
        {"Velvet Saxophone", "Jazz & Ambient"}, {"Blue Note Lounge", "Jazz & Ambient"}, {"Rainy Day Piano", "Jazz & Ambient"},
        {"Grand Piano Solo", "Jazz & Ambient"}, {"Smooth Trumpet Night", "Jazz & Ambient"}, {"Double Bass Walk", "Jazz & Ambient"},
        {"Parisian Jazz Club", "Jazz & Ambient"}, {"Bossa Nova Beach", "Jazz & Ambient"}, {"Girl from Ipanema Vibe", "Jazz & Ambient"},
        {"Acoustic Guitar Breeze", "Jazz & Ambient"}, {"Ghibli Meadow Piano", "Jazz & Ambient"}, {"Howl's Moving Castle Vibe", "Jazz & Ambient"},
        {"Spirited Away Train", "Jazz & Ambient"}, {"Konoha Afternoon", "Jazz & Ambient"}, {"Zelda Fairy Fountain Lo-Fi", "Jazz & Ambient"},
        {"Minecraft Sweden Chill", "Jazz & Ambient"}, {"Wet Hands Piano", "Jazz & Ambient"}, {"Undertale Home Chill", "Jazz & Ambient"},
        {"Space Ambient Drone", "Jazz & Ambient"}, {"Deep Meditation", "Jazz & Ambient"}, {"Crystal Cave Echoes", "Jazz & Ambient"},
        {"Aurora Borealis", "Jazz & Ambient"}, {"Zen Waterfall", "Jazz & Ambient"}, {"Tibetan Singing Bowls", "Jazz & Ambient"},
        {"Forest Birds & Guitar", "Jazz & Ambient"}, {"Campfire Crackling", "Jazz & Ambient"}, {"Cello Suite Chill", "Jazz & Ambient"},
        {"Violin Nocturne", "Jazz & Ambient"}, {"Chopin Nocturne Lo-Fi", "Jazz & Ambient"}, {"Clair de Lune Chill", "Jazz & Ambient"},
        {"Gymnopedie No. 1 Vibe", "Jazz & Ambient"}, {"Harp Sanctuary", "Jazz & Ambient"}, {"Flute in the Wind", "Jazz & Ambient"},
        {"Ocean Waves Piano", "Jazz & Ambient"}, {"Whale Song Ambient", "Jazz & Ambient"}, {"Interstellar Organ Chill", "Jazz & Ambient"},
        {"Black Hole Horizon", "Jazz & Ambient"}, {"Weightless Sleep", "Jazz & Ambient"}, {"Lucid Dreaming", "Jazz & Ambient"},
        {"Astral Sanctuary Theme", "Jazz & Ambient"}, {"Golden Hour Guitar", "Jazz & Ambient"}, {"Ukulele Sunset", "Jazz & Ambient"},
        {"Kalimba Lullaby", "Jazz & Ambient"}, {"Music Box Memories", "Jazz & Ambient"}, {"Ethereal Choir", "Jazz & Ambient"},
        {"Heavenly Pads", "Jazz & Ambient"}, {"Calm Before the Storm", "Jazz & Ambient"}, {"Zenith Focus", "Jazz & Ambient"},
        {"Pure Serenity", "Jazz & Ambient"}, {"Recex Finale Symphony #200", "Jazz & Ambient"}
    }

    local Playlist = {}
    for i, data in ipairs(TrackNames) do
        local soundId = CoreAudioPool[((i - 1) % #CoreAudioPool) + 1]
        local basePitch = 1 + (((i % 7) - 3) * 0.025)
        table.insert(Playlist, {
            Index = i,
            Title = string.format("#%03d - %s", i, data[1]),
            Genre = data[2],
            Id = soundId,
            BasePitch = basePitch
        })
    end

    local CurrentIndex = 1
    local ShuffleEnabled = false
    local Audio8DEnabled = false
    local CurrentSpeedMode = 1

    -- MINI-PLAYER FLUTUANTE ESTILO SPOTIFY
    local MiniPlayerGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("RecexStudioHub")
    local MiniFrame, TrackLabel, GenreLabel, PlayPauseBtn
    local EqBars = {}

    if MiniPlayerGui then
        local oldMini = MiniPlayerGui:FindFirstChild("SpotifyMiniPlayer")
        if oldMini then oldMini:Destroy() end

        MiniFrame = Instance.new("Frame")
        MiniFrame.Name = "SpotifyMiniPlayer"
        MiniFrame.Size = UDim2.new(0, 250, 0, 52)
        MiniFrame.Position = UDim2.new(0, 18, 1, -68)
        MiniFrame.BackgroundColor3 = Color3.fromRGB(14, 15, 20)
        MiniFrame.BorderSizePixel = 0
        MiniFrame.Parent = MiniPlayerGui

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 10)
        Corner.Parent = MiniFrame

        local Stroke = Instance.new("UIStroke")
        Stroke.Color = Color3.fromRGB(30, 215, 96)
        Stroke.Thickness = 1.2
        Stroke.Transparency = 0.35
        Stroke.Parent = MiniFrame

        local EqContainer = Instance.new("Frame")
        EqContainer.Size = UDim2.new(0, 28, 0, 28)
        EqContainer.Position = UDim2.new(0, 10, 0.5, -14)
        EqContainer.BackgroundColor3 = Color3.fromRGB(22, 24, 32)
        EqContainer.BorderSizePixel = 0
        EqContainer.Parent = MiniFrame

        local EqCorner = Instance.new("UICorner")
        EqCorner.CornerRadius = UDim.new(0, 6)
        EqCorner.Parent = EqContainer

        for i = 1, 4 do
            local Bar = Instance.new("Frame")
            Bar.Size = UDim2.new(0, 3, 0, 6)
            Bar.Position = UDim2.new(0, 4 + (i - 1) * 5, 1, -5)
            Bar.AnchorPoint = Vector2.new(0, 1)
            Bar.BackgroundColor3 = Color3.fromRGB(30, 215, 96)
            Bar.BorderSizePixel = 0
            Bar.Parent = EqContainer

            local BarCorner = Instance.new("UICorner")
            BarCorner.CornerRadius = UDim.new(1, 0)
            BarCorner.Parent = Bar
            table.insert(EqBars, Bar)
        end

        TrackLabel = Instance.new("TextLabel")
        TrackLabel.Size = UDim2.new(1, -110, 0, 18)
        TrackLabel.Position = UDim2.new(0, 46, 0, 8)
        TrackLabel.BackgroundTransparency = 1
        TrackLabel.Text = Playlist[1].Title
        TrackLabel.TextColor3 = Color3.fromRGB(245, 245, 250)
        TrackLabel.Font = Enum.Font.GothamBold
        TrackLabel.TextSize = 11
        TrackLabel.TextXAlignment = Enum.TextXAlignment.Left
        TrackLabel.TextTruncate = Enum.TextTruncate.AtEnd
        TrackLabel.Parent = MiniFrame

        GenreLabel = Instance.new("TextLabel")
        GenreLabel.Size = UDim2.new(1, -110, 0, 14)
        GenreLabel.Position = UDim2.new(0, 46, 0, 26)
        GenreLabel.BackgroundTransparency = 1
        GenreLabel.Text = "Recexify 200 • " .. Playlist[1].Genre
        GenreLabel.TextColor3 = Color3.fromRGB(30, 215, 96)
        GenreLabel.Font = Enum.Font.GothamMedium
        GenreLabel.TextSize = 9
        GenreLabel.TextXAlignment = Enum.TextXAlignment.Left
        GenreLabel.Parent = MiniFrame

        PlayPauseBtn = Instance.new("TextButton")
        PlayPauseBtn.Size = UDim2.new(0, 26, 0, 26)
        PlayPauseBtn.Position = UDim2.new(1, -60, 0.5, -13)
        PlayPauseBtn.BackgroundColor3 = Color3.fromRGB(30, 215, 96)
        PlayPauseBtn.Text = "II"
        PlayPauseBtn.TextColor3 = Color3.fromRGB(12, 12, 15)
        PlayPauseBtn.Font = Enum.Font.GothamBlack
        PlayPauseBtn.TextSize = 10
        PlayPauseBtn.Parent = MiniFrame

        local PPCorner = Instance.new("UICorner")
        PPCorner.CornerRadius = UDim.new(1, 0)
        PPCorner.Parent = PlayPauseBtn

        local NextMiniBtn = Instance.new("TextButton")
        NextMiniBtn.Size = UDim2.new(0, 24, 0, 24)
        NextMiniBtn.Position = UDim2.new(1, -30, 0.5, -12)
        NextMiniBtn.BackgroundColor3 = Color3.fromRGB(26, 28, 38)
        NextMiniBtn.Text = ">>"
        NextMiniBtn.TextColor3 = Color3.fromRGB(220, 220, 230)
        NextMiniBtn.Font = Enum.Font.GothamBold
        NextMiniBtn.TextSize = 9
        NextMiniBtn.Parent = MiniFrame

        local NextCorner = Instance.new("UICorner")
        NextCorner.CornerRadius = UDim.new(1, 0)
        NextCorner.Parent = NextMiniBtn

        PlayPauseBtn.MouseButton1Click:Connect(function()
            if MainSound.IsPlaying then
                MainSound:Pause()
                PlayPauseBtn.Text = "▶"
            else
                MainSound:Resume()
                PlayPauseBtn.Text = "II"
            end
        end)

        NextMiniBtn.MouseButton1Click:Connect(function()
            if ShuffleEnabled then
                CurrentIndex = math.random(1, #Playlist)
            else
                CurrentIndex = (CurrentIndex % #Playlist) + 1
            end
            local track = Playlist[CurrentIndex]
            MainSound.SoundId = track.Id
            MainSound.PlaybackSpeed = track.BasePitch * CurrentSpeedMode
            MainSound:Play()
            TrackLabel.Text = track.Title
            GenreLabel.Text = "Recexify 200 • " .. track.Genre
            PlayPauseBtn.Text = "II"
        end)
    end

    local function PlayTrack(index)
        CurrentIndex = index
        local track = Playlist[CurrentIndex]
        if not track then return end

        MainSound.SoundId = track.Id
        MainSound.PlaybackSpeed = track.BasePitch * CurrentSpeedMode
        MainSound:Play()

        if TrackLabel and GenreLabel and PlayPauseBtn then
            TrackLabel.Text = track.Title
            GenreLabel.Text = "Recexify 200 • " .. track.Genre
            PlayPauseBtn.Text = "II"
        end

        Hub.Notify("♪ Tocando Agora", track.Title .. " (" .. track.Genre .. ")", 3)
    end

    RunService.RenderStepped:Connect(function(dt)
        if #EqBars > 0 then
            local loudness = MainSound.IsPlaying and math.clamp(MainSound.PlaybackLoudness / 250, 0.15, 1) or 0.08
            for i, bar in ipairs(EqBars) do
                local jitter = MainSound.IsPlaying and math.abs(math.sin(tick() * 10 + i * 1.7)) or 0.2
                local height = math.clamp(math.floor(20 * loudness * jitter), 4, 20)
                bar.Size = bar.Size:Lerp(UDim2.new(0, 3, 0, height), dt * 14)
            end
        end
        if Audio8DEnabled and MainSound.IsPlaying then
            ReverbEffect.Enabled = true
            ReverbEffect.WetLevel = -4 + math.sin(tick() * 1.5) * 3
        end
    end)

    -- CONTROLES PRINCIPAIS DO SPOTIFY
    SpotifyTab:AddSection("Controles Recexify (200 Faixas)")

    SpotifyTab:AddButton("⏯ Pausar / Retomar Música", "Pausa ou continua a batida atual", function()
        if MainSound.IsPlaying then
            MainSound:Pause()
            if PlayPauseBtn then PlayPauseBtn.Text = "▶" end
        else
            MainSound:Resume()
            if PlayPauseBtn then PlayPauseBtn.Text = "II" end
        end
    end)

    SpotifyTab:AddButton("🎲 Sortear Música Aleatória (1 a 200)", "Escolhe instantaneamente uma das 200 músicas", function()
        PlayTrack(math.random(1, #Playlist))
    end)

    SpotifyTab:AddButton("⏭ Próxima Música (+1)", "Avança para a próxima faixa", function()
        PlayTrack((CurrentIndex % #Playlist) + 1)
    end)

    SpotifyTab:AddButton("⏩ Pular +10 Músicas", "Avança rapidamente pelo catálogo de 200 faixas", function()
        PlayTrack(((CurrentIndex + 9) % #Playlist) + 1)
    end)

    SpotifyTab:AddSlider("Volume do Player (%)", 0, 100, 35, function(val)
        MainSound.Volume = val / 100
    end)

    SpotifyTab:AddToggle("Modo Aleatório (Shuffle)", "Sorteia entre as 200 músicas ao avançar", false, function(state)
        ShuffleEnabled = state
    end)

    SpotifyTab:AddToggle("Mostrar Mini-Player Flutuante", "Exibe ou oculta a barra do Spotify no canto", true, function(state)
        if MiniFrame then MiniFrame.Visible = state end
    end)

    -- EFEITOS DE ESTÚDIO
    SpotifyTab:AddSection("Efeitos de Áudio (Studio FX)")

    SpotifyTab:AddToggle("Modo Slowed + Reverb (Aesthetic)", "Deixa a música mais lenta com ambiência", false, function(state)
        ReverbEffect.Enabled = state
        CurrentSpeedMode = state and 0.82 or 1
        MainSound.PlaybackSpeed = Playlist[CurrentIndex].BasePitch * CurrentSpeedMode
    end)

    SpotifyTab:AddToggle("Modo Nightcore (Speed Up)", "Acelera o ritmo e sobe o tom da faixa", false, function(state)
        CurrentSpeedMode = state and 1.22 or 1
        MainSound.PlaybackSpeed = Playlist[CurrentIndex].BasePitch * CurrentSpeedMode
    end)

    SpotifyTab:AddToggle("Bass Boost (Grave Pesado)", "Realça as frequências graves do Hip-Hop/Phonk", false, function(state)
        BassEffect.Enabled = state
    end)

    SpotifyTab:AddToggle("Áudio 8D Espacial", "Oscilação imersiva de ambiência ao redor", false, function(state)
        Audio8DEnabled = state
        if not state then ReverbEffect.Enabled = false end
    end)

    SpotifyTab:AddToggle("Camada de Chuva Suave (Lo-Fi Rain)", "Adiciona som relaxante de chuva ao fundo", false, function(state)
        if state then RainSound:Play() else RainSound:Stop() end
    end)

    -- RENDERIZA TODAS AS 200 MÚSICAS DIVIDIDAS POR SEÇÃO
    local LastGenre = ""
    for i, track in ipairs(Playlist) do
        if track.Genre ~= LastGenre then
            LastGenre = track.Genre
            SpotifyTab:AddSection("Playlist: " .. LastGenre)
        end
        SpotifyTab:AddButton("♪ " .. track.Title, "Tocar agora • " .. track.Genre, function()
            PlayTrack(i)
        end)
    end
end