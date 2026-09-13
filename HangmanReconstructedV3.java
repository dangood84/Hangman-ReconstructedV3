import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class HangmanReconstructedV3 {
    private static final String[] WORDS = {
        "AUTOMOBILE", "NETWORKING", "PRACTICAL", "CONGRESS", "COMMANDER",
        "STAPLER", "ENTERPRISE", "ESCALATION", "HAPPINESS", "WEDNESDAY",
        "THUNDER", "MARATHON", "LABORATORY", "HARBINGER", "SUNSHINE",
        "JOURNEY", "FANTASTIC", "DISCOVERY", "BOOKCASE", "HANGMAN"
    };
    private static final String ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    private static final int MAX_WRONG = 6;
    private static final int[] USED = new int[26];
    private static String gameWord;
    private static String partialSolution;
    private static int misses;
    private static String choice;

    public static void main(String[] args) throws IOException {
        gameWord = WORDS[(int)(Math.random() * WORDS.length)];
        partialSolution = "_".repeat(gameWord.length());
        misses = 0;
        choice = getChoice("Welcome to HANGMAN, (c) B J Good 2009");
        String outcome = null;

        while (outcome == null) {
            if (choice.isEmpty()) {
                outcome = "abandoned";
            } else if (choice.length() > 1) {
                choice = getChoice("Invalid: You must enter only 1 letter at a time!");
            } else {
                choice = choice.toUpperCase();
                int letterPosition = ALPHABET.indexOf(choice);
                if (letterPosition == -1) {
                    choice = getChoice("Invalid: The character you typed was not a letter!");
                } else if (USED[letterPosition] == -1) {
                    choice = getChoice("Invalid: You've already guessed this letter, and it was wrong!");
                } else if (USED[letterPosition] == 1) {
                    choice = getChoice("Invalid: You've already guessed this letter, and it was right!");
                } else if (!gameWord.contains(choice)) {
                    misses += 1;
                    USED[letterPosition] = -1;
                    if (misses == MAX_WRONG) {
                        outcome = "lost";
                    } else {
                        choice = getChoice("Sorry, the word does not contain this letter.");
                    }
                } else {
                    StringBuilder newMask = new StringBuilder();
                    for (int i = 0; i < gameWord.length(); i++) {
                        char current = gameWord.charAt(i);
                        if (current == choice.charAt(0)) {
                            newMask.append(choice.charAt(0));
                        } else {
                            newMask.append(partialSolution.charAt(i));
                        }
                    }
                    partialSolution = newMask.toString();
                    USED[letterPosition] = 1;
                    if (partialSolution.equals(gameWord)) {
                        outcome = "won";
                    } else {
                        choice = getChoice("Well done! A correct letter!");
                    }
                }
            }
        }

        if (outcome.equals("abandoned")) {
            System.out.println("You abandoned the game.  The word was " + gameWord);
        } else if (outcome.equals("lost")) {
            System.out.println("You lose.  The word was " + gameWord);
        } else {
            System.out.println("Congratulations!  You win!  The word was " + gameWord);
        }
    }

    private static String getChoice(String message) throws IOException {
        BufferedReader input = new BufferedReader(new InputStreamReader(System.in));
        String wrongGuesses = "";
        for (int i = 0; i < ALPHABET.length(); i++) {
            if (USED[i] == -1) {
                wrongGuesses += ALPHABET.charAt(i);
            }
        }
        System.out.print("\n\n" + message + "\n\n\tYour word : " + partialSolution + "\n\tNo of misses : " + misses + "\n\tIncorrect: " + wrongGuesses + "\n\nType a letter and click on OK, or just click OK to abandon the game, HANGMAN");
        return input.readLine();
    }
}
