# Hangman Reconstructed V3

A single-player, command-line Hangman game reconstructed from the Windows-only
`HangmanReconstructedv3.vbs` source. This version keeps the V2-style loop and rules,
while adding a more robust word list setup and a cleaner V3-oriented structure.

- A random word is selected from the project word list.
- The player guesses one letter at a time.
- Empty input abandons the game.
- Six wrong guesses lose the game.

See [EXECUTION_FLOW.md](EXECUTION_FLOW.md) for the game loop and [WORKINGS.md](WORKINGS.md)
for the shared state model and porting notes.

## Versions and commands

| Language | File | Command |
| --- | --- | --- |
| JavaScript | [HangmanReconstructedV3.js](HangmanReconstructedV3.js) | `npm install && npm start` |
| TypeScript | [HangmanReconstructedV3.ts](HangmanReconstructedV3.ts) | `node --experimental-strip-types HangmanReconstructedV3.ts` |
| Bash | [HangmanReconstructedV3.sh](HangmanReconstructedV3.sh) | `chmod +x HangmanReconstructedV3.sh && ./HangmanReconstructedV3.sh` |
| Java | [HangmanReconstructedV3.java](HangmanReconstructedV3.java) | `javac HangmanReconstructedV3.java && java HangmanReconstructedV3` |
| C | [HangmanReconstructedV3.c](HangmanReconstructedV3.c) | `cc HangmanReconstructedV3.c -o hangman_c && ./hangman_c` |
| C++ | [HangmanReconstructedV3.cpp](HangmanReconstructedV3.cpp) | `c++ -std=c++17 HangmanReconstructedV3.cpp -o hangman_cpp && ./hangman_cpp` |
| Pascal | [HangmanReconstructedV3.pas](HangmanReconstructedV3.pas) | `fpc HangmanReconstructedV3.pas && ./HangmanReconstructedV3` |
| Python | [HangmanReconstructedV3.py](HangmanReconstructedV3.py) | `python3 HangmanReconstructedV3.py` |
| Fortran | [HangmanReconstructedV3.f90](HangmanReconstructedV3.f90) | `gfortran HangmanReconstructedV3.f90 -o hangman_f90 && ./hangman_f90` |
| Prolog | [HangmanReconstructedV3.pl](HangmanReconstructedV3.pl) | `swipl HangmanReconstructedV3.pl` |
| VBScript | [HangmanReconstructedv3.vbs](HangmanReconstructedv3.vbs) | `cscript HangmanReconstructedv3.vbs` (Windows only) |

## Prerequisites

- Node.js 22.6+ for the JavaScript/TypeScript path, plus `npm install`.
- Python 3 and Bash 4+.
- A Java JDK, C/C++ compiler, Free Pascal, `gfortran`, and SWI-Prolog for the other ports.

The ports are intentionally small and self-contained. Native compilers may leave build
products in the folder; the shared `.gitignore` excludes those products and dependencies.
