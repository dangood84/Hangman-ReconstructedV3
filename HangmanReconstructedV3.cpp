#include <iostream>
#include <string>
#include <vector>
#include <cstdlib>
#include <ctime>

using namespace std;

const vector<string> WORDS = {
    "AUTOMOBILE", "NETWORKING", "PRACTICAL", "CONGRESS", "COMMANDER",
    "STAPLER", "ENTERPRISE", "ESCALATION", "HAPPINESS", "WEDNESDAY",
    "THUNDER", "MARATHON", "LABORATORY", "HARBINGER", "SUNSHINE",
    "JOURNEY", "FANTASTIC", "DISCOVERY", "BOOKCASE", "HANGMAN"
};
const string ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
const int MAX_WRONG = 6;
int used[26] = {0};

static string getChoice(const string& message, const string& partialSolution, int misses) {
    string wrongGuesses;
    for (int i = 0; i < 26; ++i) {
        if (used[i] == -1) wrongGuesses += ALPHABET[i];
    }

    cout << "\n\n" << message << "\n\n\tYour word : " << partialSolution
         << "\n\tNo of misses : " << misses
         << "\n\tIncorrect: " << wrongGuesses
         << "\n\nType a letter and click on OK, or just click OK to abandon the game, HANGMAN";

    string input;
    getline(cin, input);
    return input;
}

int main() {
    srand(static_cast<unsigned>(time(nullptr)));
    string gameWord = WORDS[rand() % WORDS.size()];
    string partialSolution(gameWord.length(), '_');
    int misses = 0;
    string choice = getChoice("Welcome to HANGMAN, (c) B J Good 2009", partialSolution, misses);
    string outcome;

    while (outcome.empty()) {
        if (choice.empty()) {
            outcome = "abandoned";
        } else if (choice.length() > 1) {
            choice = getChoice("Invalid: You must enter only 1 letter at a time!", partialSolution, misses);
        } else {
            char c = static_cast<char>(toupper(static_cast<unsigned char>(choice[0])));
            int letterPosition = ALPHABET.find(c);

            if (letterPosition == string::npos) {
                choice = getChoice("Invalid: The character you typed was not a letter!", partialSolution, misses);
            } else if (used[letterPosition] == -1) {
                choice = getChoice("Invalid: You've already guessed this letter, and it was wrong!", partialSolution, misses);
            } else if (used[letterPosition] == 1) {
                choice = getChoice("Invalid: You've already guessed this letter, and it was right!", partialSolution, misses);
            } else {
                bool found = false;
                for (size_t i = 0; i < gameWord.length(); ++i) {
                    if (gameWord[i] == c) {
                        partialSolution[i] = c;
                        found = true;
                    }
                }

                if (!found) {
                    misses += 1;
                    used[letterPosition] = -1;
                    if (misses == MAX_WRONG) {
                        outcome = "lost";
                    } else {
                        choice = getChoice("Sorry, the word does not contain this letter.", partialSolution, misses);
                    }
                } else {
                    used[letterPosition] = 1;
                    if (partialSolution == gameWord) {
                        outcome = "won";
                    } else {
                        choice = getChoice("Well done! A correct letter!", partialSolution, misses);
                    }
                }
            }
        }
    }

    if (outcome == "abandoned") {
        cout << "\nYou abandoned the game.  The word was " << gameWord << '\n';
    } else if (outcome == "lost") {
        cout << "\nYou lose.  The word was " << gameWord << '\n';
    } else {
        cout << "\nCongratulations!  You win!  The word was " << gameWord << '\n';
    }

    return 0;
}
