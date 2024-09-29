-- Variables
local proverbWordCounts = {}       -- Number of words in each proverb
local proverbs = {}                -- Words in each proverb
local wordList = {}                -- List of all words from proverbs and additional words
local tileWords = {}               -- Tile words (ti)
local currentTileWords = {}        -- Current tile words (td)
local duplicateWords = {}          -- Duplicate words (sw)

local playerProverbWordCounts = {} -- Number of words in the proverb for each player (K)
local selectedProverbIndices = {}  -- Selected proverb index for each player (c)
local playerProverbs = {}          -- Player's proverb words (cp)
local playerProverbBoxes = {}      -- Player's proverb box statuses (ppb)
local scores = { 0, 0 }            -- Scores for each player
local tileMatchFlags = {}          -- Tile match flag for each player (q)
local tileCounts = { 0, 0 }        -- Count of tiles placed by each player (count)
local currentProverbPositions = {} -- Current position in the proverb (cpos)
local grabs = { 0, 0 }             -- Grabs for each player (grab)

local totalWords = 0               -- Total words count (t)
local totalProverbs = 0            -- Total proverbs count (p_global)
local tileIndex = 1                -- Tile index (gut)
local tileNumber = 1               -- Tile number (rug)
local wordListDividedBy15 = 0      -- totalWords / 15 (hgt)
local gameRound = 1                -- Game round counter (nous)
local tileRound = 1                -- Tile round counter (we)

local windowWidth, windowHeight = 500, 220
local gameState = "start" -- Game state (e.g., "start", "playing", "gameover")

-- Flags to control function calls
local wordsRandomizedForRound = false
local tileShownForRound = false
local currentPlayer = 1 -- Current player (1 or 2)

local function duplicateWordList()
    duplicateWords = {}
    for index, word in ipairs(wordList) do
        duplicateWords[index] = word
    end
end

local function selectProverbForPlayer(p)
    local selectedIndex = math.random(1, totalProverbs)
    local playerWordCount = proverbWordCounts[selectedIndex]

    -- Ensure proverbs are different for each player
    if p == 2 then
        while selectedIndex == selectedProverbIndices[1] or playerWordCount == 0 do
            selectedIndex = math.random(1, totalProverbs)
            playerWordCount = proverbWordCounts[selectedIndex]
        end
    end

    selectedProverbIndices[p] = selectedIndex
    playerProverbWordCounts[p] = playerWordCount
    playerProverbs[p] = {}
    playerProverbBoxes[p] = {}

    for b = 1, playerProverbWordCounts[p] do
        playerProverbs[p][b] = proverbs[selectedIndex][b]
        playerProverbBoxes[p][b] = ''
    end

    grabs[p] = 0
    tileCounts[p] = 0
    tileMatchFlags[p] = 0
    currentProverbPositions[p] = 0
end

local function initializePlayerProverbBoxes(p)
    local boxes = {}
    for a = 0, playerProverbWordCounts[p] - 1 do
        local x = 5 + a * (480 / playerProverbWordCounts[p])
        local y = 1 + (p - 1) * 155
        local width = (480 / playerProverbWordCounts[p])
        local height = 52
        boxes[a + 1] = { x = x, y = y, width = width, height = height }
    end
    playerProverbBoxes[p].boxes = boxes
end

local function readProverbsFromFile(filename)
    local file = io.open(filename, "r")
    if not file then
        error("Cannot open file: " .. filename)
    end

    local pList = {}
    for line in file:lines() do
        local pv = {}
        for word in line:gmatch("%S+") do
            table.insert(pv, word)
        end
        table.insert(pList, pv)
    end

    file:close()
    return pList
end

local function readProverbs()
    totalProverbs = 0
    totalWords = 0
    wordList = {}

    local proverbsList = readProverbsFromFile("proverblist")

    for _, proverb in ipairs(proverbsList) do
        totalProverbs = totalProverbs + 1
        proverbWordCounts[totalProverbs] = #proverb
        proverbs[totalProverbs] = {}
        for wordIndex, word in ipairs(proverb) do
            proverbs[totalProverbs][wordIndex] = word
            table.insert(wordList, word)
            totalWords = totalWords + 1
        end
    end

    local additionalWords = {
        "b", "c", "d", "e", "f", "g", "h", "I", "J", "k", "l", "m", "n", "o", "p", "q", "r", "S", "t", "u", "v", "w",
        "in", "on", "by", "at", "he", "no", "an", "is", "ho", "ma", "be", "hi", "yo",
        "jack", "il", "bo", "un", "con", "do", "ex", "if", "lo", "so",
        "zo"
    }

    for _, word in ipairs(additionalWords) do
        if word == "zo" then
            break
        end
        table.insert(wordList, word)
        totalWords = totalWords + 1
    end
end

local function randomizeWords()
    local remainingWords = {}
    for i, word in ipairs(duplicateWords) do
        remainingWords[i] = word
    end

    tileWords = {}
    local totalTiles = wordListDividedBy15
    for a = 1, totalTiles do
        tileWords[a] = {}
        for b = 1, 3 do
            if #remainingWords == 0 then
                break
            end
            local randomIndex = math.random(1, #remainingWords)
            tileWords[a][b] = remainingWords[randomIndex]
            table.remove(remainingWords, randomIndex)
        end
    end
end

local function showTile()
    if tileWords[tileIndex] then
        currentTileWords = tileWords[tileIndex]
        tileIndex = tileIndex + 1
    else
        gameState = "gameover"
    end
end

local function checkTileMatch(p)
    tileMatchFlags[p] = 0
    local playerProverb = playerProverbs[p]
    local playerBoxStatus = playerProverbBoxes[p]
    for m = 1, #currentTileWords do
        local tileWord = currentTileWords[m]
        if tileWord ~= "" then
            for n = 1, playerProverbWordCounts[p] do
                if playerBoxStatus[n] ~= "filled" then
                    if tileWord == playerProverb[n] then
                        tileMatchFlags[p] = 1
                        currentProverbPositions[p] = n
                        return
                    end
                end
            end
        end
    end
end

local function updatePlayerScore(p)
    local points = grabs[p] + 10
    scores[p] = scores[p] + points
    grabs[p] = grabs[p] + 1
end

local function updatePlayerProverb(p)
    local position = currentProverbPositions[p]
    if position and position > 0 then
        playerProverbBoxes[p][position] = "filled"
        tileCounts[p] = tileCounts[p] + 1
    end
end

local function handlePlayerTileChoice(p)
    checkTileMatch(p)
    if tileMatchFlags[p] == 1 then
        updatePlayerScore(p)
        updatePlayerProverb(p)
    end
end

function love.load()
    love.window.setMode(windowWidth, windowHeight)
    love.window.setTitle("Jack Trot - Words from Proverbs")

    readProverbs()
    duplicateWordList()
    wordListDividedBy15 = math.floor(totalWords / 15)

    for p = 1, 2 do
        selectProverbForPlayer(p)
        initializePlayerProverbBoxes(p)
    end

    tileNumber = 1
    tileIndex = 1
    gameRound = 1
    tileRound = 1
    gameState = "playing"

    randomizeWords() -- Randomize words once at the start
    wordsRandomizedForRound = true
end

function love.update(dt)
    if gameState == "playing" then
        if gameRound <= 5 then
            if tileRound == 1 and not wordsRandomizedForRound then
                randomizeWords()
                wordsRandomizedForRound = true
            end

            if tileRound <= wordListDividedBy15 then
                if not tileShownForRound then
                    showTile()
                    tileShownForRound = true
                end
            else
                tileRound = 1
                gameRound = gameRound + 1
                wordsRandomizedForRound = false
            end
        else
            gameState = "gameover"
        end
    end
end

function love.draw()
    if gameState == "playing" then
        for p = 1, 2 do
            local boxes = playerProverbBoxes[p].boxes or {}
            for index, box in ipairs(boxes) do
                love.graphics.rectangle("line", box.x, box.y, box.width, box.height)
                if playerProverbBoxes[p][index] == "filled" then
                    love.graphics.print(playerProverbs[p][index], box.x + 5, box.y + 5)
                end
            end
            love.graphics.print("Player " .. p .. " Score: " .. scores[p], 10, 180 + (p - 1) * 20)
        end

        love.graphics.rectangle("line", 20, 77, 120, 51)
        for i, word in ipairs(currentTileWords) do
            love.graphics.print(word, 30, 90 + (i - 1) * 16)
        end
        love.graphics.print("Tile No: " .. tileNumber, 150, 100)
    elseif gameState == "gameover" then
        love.graphics.print("Game Over", windowWidth / 2 - 50, windowHeight / 2 - 20)
        for p = 1, 2 do
            love.graphics.print("Player " .. p .. " Final Score: " .. scores[p],
                windowWidth / 2 - 70, windowHeight / 2 + (p - 1) * 20)
        end
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif gameState == "playing" then
        if key == "space" then
            handlePlayerTileChoice(currentPlayer)
            tileNumber = tileNumber + 1
            tileRound = tileRound + 1
            tileShownForRound = false

            if tileCounts[currentPlayer] >= playerProverbWordCounts[currentPlayer] then
                gameState = "gameover"
                print("Player " .. currentPlayer .. " has completed their proverb!")
            else
                currentPlayer = 3 - currentPlayer -- Switch between 1 and 2
            end
        end
    end
end
