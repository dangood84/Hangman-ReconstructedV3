# Workings

This project follows the control flow of `HangmanReconstructedv3.vbs` while staying close to the earlier V2 reconstruction. The ports use the same five pieces of game state, with syntax adapted to each language.

## Shared state

| State | Meaning |
| --- | --- |
| Secret word | One word selected randomly from the project word list. |
| Guess mask | Underscores with correctly guessed letters revealed in place. |
| Miss count | Number of wrong letters; the game is lost at six. |
| Letter tracker | One A-Z slot: `0` unused, `1` correct, `-1` wrong. |
| Outcome | Abandoned, lost, or won; set only when the loop ends. |

## V3 translation notes

- The VBScript source uses `InStr`, which is 1-based and returns `0` when a value is absent. Ports using zero-based searches test for `-1` or an equivalent not-found value.
- Wrong guesses update only the miss count and wrong-letter tracker. Correct guesses alone rebuild the mask and mark a letter as correct.
- The prompt is regenerated after every rejected or non-terminal guess, so the displayed mask, miss count, and incorrect-letter list always reflect current state.
- JavaScript and TypeScript use `readline-sync` to preserve the original prompt-and-response feel.
- C, C++, Pascal, and Fortran use fixed-size arrays because the longest source words are short.
- Prolog represents the loop recursively and reveals matching letters through a helper predicate rather than mutating a string in place.

## Shared constants

Words: `AUTOMOBILE`, `NETWORKING`, `PRACTICAL`, `CONGRESS`, `COMMANDER`, `STAPLER`,
`ENTERPRISE`, `ESCALATION`, `HAPPINESS`, `WEDNESDAY`, `THUNDER`, `MARATHON`,
`LABORATORY`, `HARBINGER`, `SUNSHINE`, `JOURNEY`, `FANTASTIC`, `DISCOVERY`,
`BOOKCASE`, `HANGMAN`.

Alphabet: `ABCDEFGHIJKLMNOPQRSTUVWXYZ`. Maximum wrong guesses: `6`.
