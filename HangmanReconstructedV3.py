import random

WORDS = [
    'AUTOMOBILE', 'NETWORKING', 'PRACTICAL', 'CONGRESS', 'COMMANDER',
    'STAPLER', 'ENTERPRISE', 'ESCALATION', 'HAPPINESS', 'WEDNESDAY',
    'THUNDER', 'MARATHON', 'LABORATORY', 'HARBINGER', 'SUNSHINE',
    'JOURNEY', 'FANTASTIC', 'DISCOVERY', 'BOOKCASE', 'HANGMAN'
]
ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
MAX_WRONG = 6


def prompt(message, mask, misses, used):
    wrong = ''.join(letter for letter, state in zip(ALPHABET, used) if state == -1)
    return input(f'\n\n{message}\n\n\tYour word : {mask}\n\tNo of misses : {misses}\n\tIncorrect: {wrong}\n\nType a letter and press Enter, or just press Enter to abandon the game, HANGMAN ')


def main():
    word = random.choice(WORDS)
    mask = '_' * len(word)
    used = [0] * 26
    misses = 0
    message = 'Welcome to HANGMAN, (c) B J Good 2009'
    outcome = None

    while outcome is None:
        choice = prompt(message, mask, misses, used)
        if not choice:
            outcome = 'abandoned'
        elif len(choice) > 1:
            message = 'Invalid: You must enter only 1 letter at a time!'
        else:
            choice = choice.upper()
            position = ALPHABET.find(choice)
            if position < 0:
                message = 'Invalid: The character you typed was not a letter!'
            elif used[position] == -1:
                message = "Invalid: You've already guessed this letter, and it was wrong!"
            elif used[position] == 1:
                message = "Invalid: You've already guessed this letter, and it was right!"
            elif choice not in word:
                misses += 1
                used[position] = -1
                if misses == MAX_WRONG:
                    outcome = 'lost'
                else:
                    message = 'Sorry, the word does not contain this letter.'
            else:
                mask = ''.join(choice if letter == choice else old for letter, old in zip(word, mask))
                used[position] = 1
                if mask == word:
                    outcome = 'won'
                else:
                    message = 'Well done! A correct letter!'

    results = {
        'abandoned': f'You abandoned the game.  The word was {word}',
        'lost': f'You lose.  The word was {word}',
        'won': f'Congratulations!  You win!  The word was {word}'
    }
    print(results[outcome])


if __name__ == '__main__':
    main()
