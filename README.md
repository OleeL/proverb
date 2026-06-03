# Jack Trot Proverb Game

`JACK TROT(c)..words ex proverbs` was originally a BBC BASIC word game about rebuilding and guessing proverbs from small word fragments.

This project remakes the idea in Lua using [LÖVE](https://love2d.org/). The game reads its proverb data from `proverblist`, where each line is one proverb.

## What the original game does

The BBC BASIC version is a two-player proverb/word-fragment game:

- It loads a list of proverbs and splits them into words.
- Each player is assigned a different proverb.
- Player 1 is the computer/Jack Trot.
- Player 2 is the human player.
- The game repeatedly shows a tile containing three small text fragments.
- A fragment can fit a word if:
  - it is a one-letter fragment matching the first letter of the word,
  - it appears directly inside the word, or
  - its letters appear in order through the word.
- Players race to claim a tile and place it into a matching word box.
- Correct placements gradually reveal words in the proverb.
- Bad placements or bad guesses award small penalty points to the opponent.
- The human can guess Jack's hidden proverb once enough information has been revealed.
- Completing a proverb or guessing correctly awards points.
- First player past the target score wins.
- The original also allowed the player to type in a new proverb and append it to the proverb list.

In short: it is part word puzzle, part reaction game, and part proverb guessing game.

## What this Lua remake does

The Lua/LÖVE version keeps the main features but modernizes the interaction:

- Loads one proverb per line from `proverblist`.
- Chooses one hidden proverb for Jack and one visible proverb for you.
- Generates tiles with three fragments taken from proverb words.
- Lets you place a tile into a matching box in your proverb.
- Jack automatically places tiles into his hidden proverb after a short delay.
- Reveals Jack's words only when he successfully places tiles.
- Lets you guess Jack's full proverb.
- Scores completed proverbs, correct guesses, and penalties.
- Lets you add a new proverb during play.
- First player to `100` points wins.

## How to play

Run the project with LÖVE from this directory:

```sh
love .
```

### Controls

| Key / action | Effect |
| --- | --- |
| `Y` | Choose a box for the current tile |
| Click your proverb box | Shortcut for placing the current tile |
| `G` | Guess Jack's hidden proverb |
| `N` | Add a new proverb |
| `R` | Restart the game |
| `E` or `Esc` | Quit |
| `Enter` | Submit typed input |
| `Backspace` | Delete typed input |

## Screen layout

- Top row: Jack's hidden proverb. Unrevealed words show only box numbers.
- Middle: the current tile, showing three fragments and a point value.
- Bottom row: your visible proverb.
- Top-right: scores.
- Bottom line: control reminder.

## Tile matching rules

A tile has three fragments. You only need one fragment to match the selected word box.

Examples:

- Fragment `a` fits `Actions` because it matches the first letter.
- Fragment `old` fits `gold` because it appears inside the word.
- Fragment `gt` fits `glitters` because `g` and then `t` appear in order.

This follows the spirit of the BBC BASIC routines that checked direct substring matches and an extended ordered-letter fit.

## Proverb list format

`proverblist` should contain one proverb per line:

```text
A picture is worth a thousand words
A stitch in time saves nine
Actions speak louder than words
```

The original BASIC program used a more structured format with word counts and one word per line. This remake intentionally uses the simpler line-based file already present in this project.

## Notes

The original program contains several quirks and typos typical of old BASIC listings. The remake preserves the game idea rather than translating every line literally. The goal is to keep the important features: proverb selection, fragment tiles, placement checks, guessing, scoring, and adding new proverbs.
