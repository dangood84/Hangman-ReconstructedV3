#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <time.h>

#define WORD_COUNT 20
#define ALPHABET_LEN 26
#define MAX_WRONG 6

const char *words[WORD_COUNT] = {
    "AUTOMOBILE", "NETWORKING", "PRACTICAL", "CONGRESS", "COMMANDER",
    "STAPLER", "ENTERPRISE", "ESCALATION", "HAPPINESS", "WEDNESDAY",
    "THUNDER", "MARATHON", "LABORATORY", "HARBINGER", "SUNSHINE",
    "JOURNEY", "FANTASTIC", "DISCOVERY", "BOOKCASE", "HANGMAN"
};
const char alphabet[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

static int used[ALPHABET_LEN] = {0};

static char *read_line(void) {
    size_t size = 64;
    char *buffer = malloc(size);
    if (!buffer) return NULL;

    if (fgets(buffer, (int)size, stdin) == NULL) {
        free(buffer);
        return NULL;
    }

    size_t len = strlen(buffer);
    while (len > 0 && (buffer[len - 1] == '\n' || buffer[len - 1] == '\r')) {
        buffer[len - 1] = '\0';
        len--;
    }

    return buffer;
}

static char *get_choice(const char *message, const char *mask, int misses) {
    char wrong[ALPHABET_LEN + 1] = {0};
    int w = 0;
    for (int i = 0; i < ALPHABET_LEN; i++) {
        if (used[i] == -1) {
            wrong[w++] = alphabet[i];
        }
    }
    printf("\n\n%s\n\n\tYour word : %s\n\tNo of misses : %d\n\tIncorrect: %s\n\nType a letter and click on OK, or just click OK to abandon the game, HANGMAN", message, mask, misses, wrong);
    return read_line();
}

int main(void) {
    srand((unsigned) time(NULL));
    const char *gameWord = words[rand() % WORD_COUNT];
    int length = (int)strlen(gameWord);
    char *mask = malloc(length + 1);
    if (!mask) return 1;

    for (int i = 0; i < length; i++) {
        mask[i] = '_';
    }
    mask[length] = '\0';

    int misses = 0;
    char *choice = get_choice("Welcome to HANGMAN, (c) B J Good 2009", mask, misses);
    char *outcome = NULL;

    while (outcome == NULL) {
        if (choice == NULL || strcmp(choice, "") == 0) {
            outcome = "abandoned";
        } else if (strlen(choice) > 1) {
            free(choice);
            choice = get_choice("Invalid: You must enter only 1 letter at a time!", mask, misses);
        } else {
            char c = toupper((unsigned char) choice[0]);
            int letterPosition = -1;
            for (int i = 0; i < ALPHABET_LEN; i++) {
                if (alphabet[i] == c) {
                    letterPosition = i;
                    break;
                }
            }

            if (letterPosition == -1) {
                free(choice);
                choice = get_choice("Invalid: The character you typed was not a letter!", mask, misses);
            } else if (used[letterPosition] == -1) {
                free(choice);
                choice = get_choice("Invalid: You've already guessed this letter, and it was wrong!", mask, misses);
            } else if (used[letterPosition] == 1) {
                free(choice);
                choice = get_choice("Invalid: You've already guessed this letter, and it was right!", mask, misses);
            } else {
                int found = 0;
                for (int i = 0; i < length; i++) {
                    if (gameWord[i] == c) {
                        mask[i] = c;
                        found = 1;
                    }
                }

                if (!found) {
                    misses += 1;
                    used[letterPosition] = -1;
                    if (misses == MAX_WRONG) {
                        outcome = "lost";
                    } else {
                        free(choice);
                        choice = get_choice("Sorry, the word does not contain this letter.", mask, misses);
                    }
                } else {
                    used[letterPosition] = 1;
                    if (strcmp(mask, gameWord) == 0) {
                        outcome = "won";
                    } else {
                        free(choice);
                        choice = get_choice("Well done! A correct letter!", mask, misses);
                    }
                }
            }
        }
    }

    if (strcmp(outcome, "abandoned") == 0) {
        printf("\nYou abandoned the game.  The word was %s\n", gameWord);
    } else if (strcmp(outcome, "lost") == 0) {
        printf("\nYou lose.  The word was %s\n", gameWord);
    } else {
        printf("\nCongratulations!  You win!  The word was %s\n", gameWord);
    }

    free(mask);
    free(choice);
    return 0;
}
