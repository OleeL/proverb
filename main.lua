-- Jack Trot: words ex proverbs
-- A LÖVE remake of the old BBC BASIC proverb tile game.

local WIDTH, HEIGHT = 500, 220
local WIN_SCORE = 100

local proverbs = {}
local wordPool = {}

local game = {
    score = { 0, 0 },
    round = 1,
    tileNo = 1,
    message = "",
    messageTimer = 0,
    mode = "play",
    input = "",
    selectedBox = nil,
    currentTile = nil,
    computerClaimTimer = 0,
    computerClaimDelay = 2.0,
    over = false,
}

local players = {
    [1] = { name = "Jack Trot", isComputer = true, proverb = nil, revealed = {}, grab = 0 },
    [2] = { name = "You", isComputer = false, proverb = nil, revealed = {}, grab = 0 },
}

local function trim(s)
    return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function splitWords(line)
    local words = {}
    for word in line:gmatch("%S+") do
        table.insert(words, word)
    end
    return words
end

local function joinWords(words)
    return table.concat(words, " ")
end

local function addProverb(line)
    line = trim(line)
    if line == "" then return false end

    local words = splitWords(line)
    if #words < 2 then return false end

    local proverb = { text = joinWords(words), words = words }
    table.insert(proverbs, proverb)

    for _, word in ipairs(words) do
        local clean = word:gsub("^[%p]+", ""):gsub("[%p]+$", "")
        if #clean > 0 then
            table.insert(wordPool, clean)
        end
    end

    return true
end

local function loadProverbs()
    proverbs = {}
    wordPool = {}

    local contents = love.filesystem.read("proverblist")
    if contents then
        for line in contents:gmatch("[^\r\n]+") do
            addProverb(line)
        end
    end

    -- Safety fallback so the game still runs if the file is missing/empty.
    if #proverbs == 0 then
        addProverb("A stitch in time saves nine")
        addProverb("Actions speak louder than words")
        addProverb("Every cloud has a silver lining")
    end
end

local function saveAddedProverb(line)
    -- In fused/release builds source files may not be writable. The in-memory
    -- proverb is still used even if appending to the source list fails.
    local existing = love.filesystem.read("proverblist") or ""
    local prefix = existing
    if prefix ~= "" and not prefix:match("\n$") then
        prefix = prefix .. "\n"
    end
    love.filesystem.write("proverblist", prefix .. line .. "\n")
end

local function shallowCopyWords(words)
    local copy = {}
    for i, word in ipairs(words) do copy[i] = word end
    return copy
end

local function randomProverb(except)
    if #proverbs == 1 then return proverbs[1] end

    local chosen
    repeat
        chosen = proverbs[love.math.random(#proverbs)]
    until chosen ~= except
    return chosen
end

local function resetPlayer(p, except)
    local player = players[p]
    player.proverb = randomProverb(except)
    player.revealed = {}
    player.grab = 0
    for i = 1, #player.proverb.words do
        player.revealed[i] = false
    end
end

local function setMessage(text, seconds)
    game.message = text
    game.messageTimer = seconds or 2.5
end

local function startRound()
    resetPlayer(1)
    resetPlayer(2, players[1].proverb)
    game.round = game.round + 1
    game.selectedBox = nil
    game.mode = "play"
    game.input = ""
    setMessage("New proverbs selected. Place tiles or guess Jack's proverb.", 3)
end

local function fragmentFitsWord(fragment, word)
    fragment = fragment:lower()
    word = word:lower():gsub("^[%p]+", ""):gsub("[%p]+$", "")

    if fragment == "" or word == "" then return false end

    -- BASIC rule: one-letter tiles match a word's first letter.
    if #fragment == 1 then
        return word:sub(1, 1) == fragment
    end

    -- Direct substring match.
    if word:find(fragment, 1, true) then
        return true
    end

    -- Elaborated fit: all fragment letters appear in order inside the word.
    local pos = 1
    for i = 1, #fragment do
        local c = fragment:sub(i, i)
        local found = word:find(c, pos, true)
        if not found then return false end
        pos = found + 1
    end

    return true
end

local function tileFitsBox(tile, playerNo, box)
    local player = players[playerNo]
    if not player.proverb or player.revealed[box] then return false end

    local word = player.proverb.words[box]
    for _, fragment in ipairs(tile.fragments) do
        if fragmentFitsWord(fragment, word) then
            return true
        end
    end
    return false
end

local function findFit(playerNo, tile)
    local player = players[playerNo]
    for i = 1, #player.proverb.words do
        if tileFitsBox(tile, playerNo, i) then
            return i
        end
    end
    return nil
end

local function makeFragmentFromWord(word)
    word = word:gsub("^[%p]+", ""):gsub("[%p]+$", "")
    if #word <= 1 then return word:lower() end

    local choice = love.math.random(4)
    if choice == 1 then
        return word:sub(1, 1):lower()
    elseif choice == 2 and #word >= 3 then
        local start = love.math.random(1, #word - 1)
        local len = love.math.random(2, math.min(4, #word - start + 1))
        return word:sub(start, start + len - 1):lower()
    elseif choice == 3 and #word >= 4 then
        return (word:sub(1, 1) .. word:sub(3, 3)):lower()
    end

    return word:sub(1, math.min(3, #word)):lower()
end

local function newTile()
    local fragments = {}

    -- Bias one fragment toward a currently useful word so most tiles are playable.
    local targetPlayer = love.math.random(2)
    local target = players[targetPlayer]
    local hidden = {}
    for i, wasRevealed in ipairs(target.revealed) do
        if not wasRevealed then table.insert(hidden, target.proverb.words[i]) end
    end

    if #hidden > 0 then
        table.insert(fragments, makeFragmentFromWord(hidden[love.math.random(#hidden)]))
    end

    while #fragments < 3 do
        local word = wordPool[love.math.random(#wordPool)] or "proverb"
        table.insert(fragments, makeFragmentFromWord(word))
    end

    -- Shuffle the three fragments.
    for i = #fragments, 2, -1 do
        local j = love.math.random(i)
        fragments[i], fragments[j] = fragments[j], fragments[i]
    end

    game.currentTile = {
        fragments = fragments,
        value = math.max(1,
            math.floor((#fragments[1] + #fragments[2] + #fragments[3]) / 3))
    }
    game.tileNo = game.tileNo + 1

    local fit = findFit(1, game.currentTile)
    game.computerClaimTimer = 0
    game.computerClaimDelay = fit and love.math.random(9, 22) / 10 or 999
end

local function countRevealed(playerNo)
    local count = 0
    for _, shown in ipairs(players[playerNo].revealed) do
        if shown then count = count + 1 end
    end
    return count
end

local function finishProverb(playerNo)
    local player = players[playerNo]
    game.score[playerNo] = game.score[playerNo] + player.grab

    if game.score[playerNo] >= WIN_SCORE then
        game.over = true
        setMessage(player.name .. " wins with " .. game.score[playerNo] .. " points!", 99)
        return
    end

    setMessage(player.name .. " completed a proverb for " .. player.grab .. " points.", 3)

    if playerNo == 1 then
        resetPlayer(1, players[2].proverb)
    else
        resetPlayer(2, players[1].proverb)
        game.mode = "askNew"
        game.input = ""
        setMessage("You completed yours. Press N to add your own proverb, or Enter to continue.", 8)
    end
end

local function placeTile(playerNo, box)
    local player = players[playerNo]
    player.revealed[box] = true
    player.grab = player.grab + game.currentTile.value

    local word = player.proverb.words[box]
    setMessage(player.name .. " placed tile in box " .. box .. " (" .. word .. ").", 2)

    if countRevealed(playerNo) == #player.proverb.words then
        finishProverb(playerNo)
    end

    newTile()
end

local function badGuessPenalty(toPlayer)
    game.score[toPlayer] = game.score[toPlayer] + 2
    if game.score[toPlayer] >= WIN_SCORE then
        game.over = true
        setMessage(players[toPlayer].name .. " wins with " .. game.score[toPlayer] .. " points!", 99)
    end
end

local function playerTryBox(box)
    if game.over or game.mode ~= "play" then return end
    if not box or box < 1 or box > #players[2].proverb.words then
        setMessage("No such box. Choose a numbered word box in your proverb.", 2)
        return
    end
    if players[2].revealed[box] then
        badGuessPenalty(2)
        setMessage("That box is already used. You lose 2 points.", 2.5)
        return
    end
    if tileFitsBox(game.currentTile, 2, box) then
        placeTile(2, box)
    else
        badGuessPenalty(1)
        setMessage("Wrong box. Jack gets 2 points.", 2.5)
    end
end

local function normalizeGuess(s)
    return trim(s:lower():gsub("[%p]", ""):gsub("%s+", " "))
end

local function submitGuess()
    local guess = normalizeGuess(game.input)
    local answer = normalizeGuess(players[1].proverb.text)
    game.mode = "play"
    game.input = ""

    if guess == "" then
        setMessage("Guess cancelled.", 1.5)
        return
    end

    if guess == answer then
        local remaining = #players[1].proverb.words - countRevealed(1)
        local points = players[1].grab + remaining * 2
        game.score[2] = game.score[2] + points
        setMessage("Excellent guess! You steal " .. points .. " points.", 3)

        if game.score[2] >= WIN_SCORE then
            game.over = true
            setMessage("You win with " .. game.score[2] .. " points!", 99)
        else
            resetPlayer(1, players[2].proverb)
        end
    else
        badGuessPenalty(1)
        setMessage("Poor guess. Jack gets 2 points.", 2.5)
    end
end

local function submitNewProverb()
    local line = trim(game.input)
    game.mode = "play"
    game.input = ""

    if line == "" then
        setMessage("No proverb added.", 2)
        return
    end

    local words = splitWords(line)
    if #words > 12 then
        setMessage("That proverb has more than 12 words; not added.", 3)
        return
    end

    if addProverb(line) then
        saveAddedProverb(joinWords(words))
        players[2].proverb = proverbs[#proverbs]
        players[2].revealed = {}
        players[2].grab = 0
        for i = 1, #players[2].proverb.words do players[2].revealed[i] = false end
        setMessage("Added your proverb and made it your new target.", 3)
    else
        setMessage("Please enter a proverb with at least two words.", 3)
    end
end

local function drawBox(x, y, w, h, text, revealed, index)
    love.graphics.setColor(0.95, 0.92, 0.82)
    love.graphics.rectangle("fill", x, y, w, h)
    love.graphics.setColor(0.2, 0.16, 0.1)
    love.graphics.rectangle("line", x, y, w, h)

    love.graphics.setColor(0.15, 0.12, 0.08)
    if revealed then
        love.graphics.printf(text, x + 2, y + 15, w - 4, "center")
    else
        love.graphics.printf(tostring(index), x, y + 16, w, "center")
    end
end

local function drawProverb(playerNo, y, title, hideUnrevealed)
    local player = players[playerNo]
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(title, 6, y - 14)

    local words = player.proverb.words
    local gap = 2
    local boxW = (WIDTH - 10 - gap * (#words - 1)) / #words
    for i, word in ipairs(words) do
        local x = 5 + (i - 1) * (boxW + gap)
        local revealed = player.revealed[i] or not hideUnrevealed
        drawBox(x, y, boxW, 52, word, revealed, i)
    end
end

local function drawTile()
    love.graphics.setColor(0.9, 0.88, 0.72)
    love.graphics.rectangle("fill", 20, 80, 105, 50)
    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.rectangle("line", 20, 80, 105, 50)
    for i, fragment in ipairs(game.currentTile.fragments) do
        love.graphics.print(fragment, 32, 83 + (i - 1) * 15)
    end
    love.graphics.print("Tile No " .. game.tileNo, 135, 94)
    love.graphics.print("value " .. game.currentTile.value, 135, 110)
end

local function drawHud()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Jack: " .. game.score[1], 390, 8)
    love.graphics.print("You: " .. game.score[2], 390, 24)

    local help = "Y: place tile  G: guess Jack's proverb  N: add proverb  R: restart  Esc/E: quit"
    love.graphics.setColor(0.82, 0.86, 0.9)
    love.graphics.print(help, 6, 205)

    if game.message ~= "" then
        love.graphics.setColor(1, 0.95, 0.5)
        love.graphics.printf(game.message, 190, 80, 300, "left")
    end

    if game.mode == "chooseBox" then
        love.graphics.setColor(0, 0, 0, 0.78)
        love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Which proverb box? Type a number, then Enter. Esc cancels.", 40, 80, 420, "center")
        love.graphics.printf(game.input, 40, 105, 420, "center")
    elseif game.mode == "guess" then
        love.graphics.setColor(0, 0, 0, 0.78)
        love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Guess Jack's hidden proverb. Enter submits, Esc cancels.", 25, 62, 450, "center")
        love.graphics.rectangle("line", 45, 95, 410, 24)
        love.graphics.printf(game.input, 50, 100, 400, "left")
    elseif game.mode == "addProverb" then
        love.graphics.setColor(0, 0, 0, 0.78)
        love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Type a new proverb (2-12 words). Enter saves, Esc cancels.", 25, 58, 450, "center")
        love.graphics.rectangle("line", 30, 92, 440, 42)
        love.graphics.printf(game.input, 36, 98, 428, "left")
    elseif game.mode == "askNew" then
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Press N to type your own proverb, or Enter to keep playing.", 20, 184, 460, "center")
    end
end

function love.load()
    love.window.setMode(WIDTH, HEIGHT, { resizable = false })
    love.window.setTitle("JACK TROT(c)..words ex proverbs")
    love.graphics.setFont(love.graphics.newFont(11))
    love.math.setRandomSeed(os.time())

    loadProverbs()
    resetPlayer(1)
    resetPlayer(2, players[1].proverb)
    newTile()
    setMessage("Jack's proverb is hidden. Your proverb is visible. First to 100 wins.", 4)
end

function love.update(dt)
    if game.messageTimer > 0 then
        game.messageTimer = game.messageTimer - dt
        if game.messageTimer <= 0 then game.message = "" end
    end

    if game.over or game.mode ~= "play" then return end

    game.computerClaimTimer = game.computerClaimTimer + dt
    if game.computerClaimTimer >= game.computerClaimDelay then
        local box = findFit(1, game.currentTile)
        if box then
            placeTile(1, box)
        else
            newTile()
        end
    end
end

function love.draw()
    love.graphics.clear(0.08, 0.12, 0.16)
    drawProverb(1, 20, "Jack's hidden proverb", true)
    drawTile()
    drawProverb(2, 142, "Your proverb", false)
    drawHud()
end

function love.textinput(text)
    if game.mode == "chooseBox" then
        if text:match("%d") and #game.input < 2 then
            game.input = game.input .. text
        end
    elseif game.mode == "guess" or game.mode == "addProverb" then
        if #game.input < 120 then
            game.input = game.input .. text
        end
    end
end

function love.keypressed(key)
    if (key == "escape" or key == "e") and game.mode == "play" then
        love.event.quit()
        return
    end

    if key == "backspace" and (game.mode == "chooseBox" or game.mode == "guess" or game.mode == "addProverb") then
        game.input = game.input:sub(1, -2)
        return
    end

    if game.mode == "chooseBox" then
        if key == "return" or key == "kpenter" then
            local box = tonumber(game.input)
            game.mode = "play"
            game.input = ""
            playerTryBox(box)
        elseif key == "escape" then
            game.mode = "play"
            game.input = ""
        end
        return
    end

    if game.mode == "guess" then
        if key == "return" or key == "kpenter" then
            submitGuess()
        elseif key == "escape" then
            game.mode = "play"
            game.input = ""
            setMessage("Guess cancelled.", 1.5)
        end
        return
    end

    if game.mode == "addProverb" then
        if key == "return" or key == "kpenter" then
            submitNewProverb()
        elseif key == "escape" then
            game.mode = "play"
            game.input = ""
            setMessage("New proverb cancelled.", 1.5)
        end
        return
    end

    if game.mode == "askNew" then
        if key == "n" then
            game.mode = "addProverb"
            game.input = ""
        elseif key == "return" or key == "kpenter" then
            game.mode = "play"
            setMessage("Continuing with a random proverb.", 2)
        end
        return
    end

    if key == "r" then
        game.score = { 0, 0 }
        game.tileNo = 1
        game.over = false
        startRound()
        newTile()
    elseif key == "y" and not game.over then
        game.mode = "chooseBox"
        game.input = ""
    elseif key == "g" and not game.over then
        if countRevealed(1) < 1 then
            setMessage("Try at least one tile before guessing.", 2)
        else
            game.mode = "guess"
            game.input = ""
        end
    elseif key == "n" and not game.over then
        game.mode = "addProverb"
        game.input = ""
    end
end

function love.mousepressed(x, y, button)
    if button ~= 1 or game.mode ~= "play" or game.over then return end

    -- Click a word in the player's proverb as a shortcut for Y + box number.
    local words = players[2].proverb.words
    local gap = 2
    local boxW = (WIDTH - 10 - gap * (#words - 1)) / #words
    if y >= 142 and y <= 194 then
        local index = math.floor((x - 5) / (boxW + gap)) + 1
        if index >= 1 and index <= #words then
            playerTryBox(index)
        end
    end
end
