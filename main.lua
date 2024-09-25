
-- Variables
local proverbWordCounts = {}      -- Number of words in each proverb
local proverbs = {}               -- Words in each proverb
local wordList = {}               -- List of all words from proverbs and additional words
local tileWords = {}              -- Tile words (ti)
local currentTileWords = {}       -- Current tile words (td)
local guessWords = {}             -- Guess words (gu)
local randomizedWords = {}        -- Randomized words (r_arr)
local duplicateWords = {}         -- Duplicate words (sw)

local playerProverbWordCounts = {} -- Number of words in the proverb for each player (K)
local selectedProverbIndices = {}  -- Selected proverb index for each player (c)
local playerProverbs = {}          -- Player's proverb words (cp)
local playerProverbBoxes = {}      -- Player's proverb box statuses (ppb)
local scores = {0, 0}              -- Scores for each player
local tileMatchFlags = {}          -- Tile match flag for each player (q)
local tileCounts = {0, 0}          -- Count of tiles placed by each player (count)
local currentProverbPositions = {} -- Current position in the proverb (cpos)
local choiceTimings = {}           -- Timing variables for choices (pot)
local grabs = {0, 0}               -- Grabs for each player (grab)
local guessHelpers = {}            -- Guess helper variables (blob)
local inputProverbWords = {}       -- Proverb words input by user (p_arr)

local totalWords = 0               -- Total words count (t)
local totalProverbs = 0            -- Total proverbs count (p_global)
local pauseCounter = 100           -- Timing variable (cor)
local tileIndex = 1                -- Tile index (gut)
local maxWaitTime = 200            -- Maximum wait time for input (ke)
local tileNumber = 1               -- Tile number (rug)
local wordListDividedBy5 = 0       -- totalWords / 5 (ht)
local wordListDividedBy15 = 0      -- totalWords / 15 (hgt)
local gameRound = 1                -- Game round counter (nous)
local tileRound = 1                -- Tile round counter (we)

local windowWidth, windowHeight = 500, 220
local gameState = "start"          -- Game state (e.g., "start", "playing", "gameover")

local function duplicateWordList()
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
        playerProverbBoxes[p][b] = ''  -- Initialize box as empty
    end

    grabs[p] = 0
    tileCounts[p] = 0
    tileMatchFlags[p] = 0
    currentProverbPositions[p] = 0
    choiceTimings[p] = 0
    guessHelpers[p] = 1
end

-- Initialize player proverb boxes (visual representation)
local function initializePlayerProverbBoxes(p)
    local boxes = {}
    for a = 0, playerProverbWordCounts[p]-1 do
        local x = 5 + a * (480 / playerProverbWordCounts[p])
        local y = 1 + (p - 1) * 155
        local width = (480 / playerProverbWordCounts[p])
        local height = 52
        boxes[a+1] = {x = x, y = y, width = width, height = height}
    end
    playerProverbBoxes[p].boxes = boxes
end

local function readProverbs()
    local proverbsList = {
        {"A", "stitch", "in", "time", "saves", "nine"},
        {"Actions", "speak", "louder", "than", "words"},
        {"Better", "late", "than", "never"},
        {"Birds", "of", "a", "feather", "flock", "together"},
        {"Don't", "count", "your", "chickens", "before", "they", "hatch"},
        {"Every", "cloud", "has", "a", "silver", "lining"},
        {"Too", "many", "cooks", "spoil", "the", "broth"}
    }

    totalProverbs = 0
    totalWords = 0

    for _, proverb in ipairs(proverbsList) do
        totalProverbs = totalProverbs + 1
        proverbWordCounts[totalProverbs] = #proverb
        proverbs[totalProverbs] = {}
        for wordIndex, word in ipairs(proverb) do
            totalWords = totalWords + 1
            proverbs[totalProverbs][wordIndex] = word
            wordList[totalWords] = word
        end
    end

    local additionalWords = {
        "b","c","d","e","f","g","h","I","J","k","l","m","n","o","p","q","r","S","t","u","v","w",
        "in","on","by","at","he","no","an","is","ho","ma","be","hi","yo",
        "jack","il","bo","un","con","do","ex","if","lo","so",
        "zo"
    }

    for _, word in ipairs(additionalWords) do
        if word == "zo" then
            break
        end
        totalWords = totalWords + 1
        wordList[totalWords] = word
    end
end

-- Initialize Love2D window
function love.load()
    love.window.setMode(windowWidth, windowHeight)
    love.window.setTitle("Jack Trot - Words from Proverbs")

    -- Read proverbs and words
    readProverbs()
    duplicateWordList()
    wordListDividedBy5 = math.floor(totalWords / 5)
    wordListDividedBy15 = math.floor(totalWords / 15)

    -- Initialize game for each player
    for p = 1, 2 do
        selectProverbForPlayer(p)
        initializePlayerProverbBoxes(p)
    end

    -- Initialize other variables
    tileNumber = 1
    tileIndex = 1
    gameRound = 1
    tileRound = 1
    pauseCounter = 100
    maxWaitTime = 200

    -- Start the game
    gameState = "playing"
end

-- Randomize words and assign to tiles
local function randomizeWords()
    local remainingWords = {}
    for i, word in ipairs(duplicateWords) do
        remainingWords[i] = word
    end

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

-- Show current tile
local function showTile()
    -- Display current tile words
    if tileWords[tileIndex] then
        currentTileWords = tileWords[tileIndex]
        tileIndex = tileIndex + 1
        if tileIndex > #tileWords then
            tileIndex = 1
        end
    else
        -- No more tiles
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

-- Update player's score
local function updatePlayerScore(p)
    local points = grabs[p] + 10  -- Points can be adjusted
    scores[p] = scores[p] + points
    grabs[p] = grabs[p] + 1
end

-- Update player's proverb with the matched tile
local function updatePlayerProverb(p)
    local position = currentProverbPositions[p]
    if position and position > 0 then
        playerProverbBoxes[p][position] = "filled"
        tileCounts[p] = tileCounts[p] + 1
    end
end

-- Handle player's tile choice
local function handlePlayerTileChoice(p)
    -- Simulate timing (choiceTimings)
    local startTime = love.timer.getTime()
    choiceTimings[p] = 0
    checkTileMatch(p)
    if tileMatchFlags[p] == 1 then
        choiceTimings[p] = love.timer.getTime() - startTime
        updatePlayerScore(p)
        updatePlayerProverb(p)
    end
end

-- Main game loop
function love.update(dt)
    if gameState == "playing" then
        -- Game rounds
        if gameRound <= 5 then
            -- Randomize words for this round
            randomizeWords()
            -- Tile rounds within the game round
            if tileRound <= wordListDividedBy15 then
                showTile()
                -- Player 1's turn
                handlePlayerTileChoice(1)
                -- Player 2's turn
                handlePlayerTileChoice(2)
                -- Update counters
                pauseCounter = pauseCounter - 1
                maxWaitTime = maxWaitTime - 1
                tileNumber = tileNumber + 1
                tileRound = tileRound + 1
            else
                -- Reset tile round for next game round
                tileRound = 1
                gameRound = gameRound + 1
            end
        else
            -- Game over after 5 rounds
            gameState = "gameover"
        end
    end
end

-- Draw function
function love.draw()
    if gameState == "playing" then
        -- Draw the proverb boxes for each player
        for p = 1, 2 do
            local boxes = playerProverbBoxes[p].boxes or {}
            for index, box in ipairs(boxes) do
                love.graphics.rectangle("line", box.x, box.y, box.width, box.height)
                if playerProverbBoxes[p][index] == "filled" then
                    love.graphics.print(playerProverbs[p][index], box.x + 5, box.y + 5)
                end
            end
            -- Display scores
            love.graphics.print("Player " .. p .. " Score: " .. scores[p], 10, 180 + (p - 1) * 20)
        end

        -- Draw current tile
        love.graphics.rectangle("line", 20, 77, 120, 51)
        for i, word in ipairs(currentTileWords) do
            love.graphics.print(word, 30, 90 + (i - 1) * 16)
        end
        love.graphics.print("Tile No: " .. tileNumber, 150, 100)
    elseif gameState == "gameover" then
        -- Display game over message and final scores
        love.graphics.print("Game Over", windowWidth / 2 - 50, windowHeight / 2 - 20)
        for p = 1, 2 do
            love.graphics.print("Player " .. p .. " Final Score: " .. scores[p], windowWidth / 2 - 70, windowHeight / 2 + (p - 1) * 20)
        end
    end
end

-- Handle key presses
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif gameState == "playing" then
        if key == "space" then
            -- Players can make guesses or request tiles
            -- For simplicity, we'll assume space triggers tile matching
            -- Handle player tile choices here if needed
        end
    end
end
