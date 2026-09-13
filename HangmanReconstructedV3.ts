import readline from 'readline-sync';

const words: string[] = [
  'AUTOMOBILE', 'NETWORKING', 'PRACTICAL', 'CONGRESS', 'COMMANDER',
  'STAPLER', 'ENTERPRISE', 'ESCALATION', 'HAPPINESS', 'WEDNESDAY',
  'THUNDER', 'MARATHON', 'LABORATORY', 'HARBINGER', 'SUNSHINE',
  'JOURNEY', 'FANTASTIC', 'DISCOVERY', 'BOOKCASE', 'HANGMAN'
];
const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
const maxWrong = 6;
const used = Array<number>(26).fill(0);
const gameWord = words[Math.floor(Math.random() * words.length)];
let partialSolution = '_'.repeat(gameWord.length);
let misses = 0;
let choice = getChoice('Welcome to HANGMAN, (c) B J Good 2009');
let outcome: 'abandoned' | 'lost' | 'won' | undefined;

while (outcome === undefined) {
  if (choice === '') {
    outcome = 'abandoned';
  } else if (choice.length > 1) {
    choice = getChoice('Invalid: You must enter only 1 letter at a time!');
  } else {
    choice = choice.toUpperCase();
    const letterPosition = alphabet.indexOf(choice);
    if (letterPosition === -1) {
      choice = getChoice('Invalid: The character you typed was not a letter!');
    } else if (used[letterPosition] === -1) {
      choice = getChoice("Invalid: You've already guessed this letter, and it was wrong!");
    } else if (used[letterPosition] === 1) {
      choice = getChoice("Invalid: You've already guessed this letter, and it was right!");
    } else if (!gameWord.includes(choice)) {
      misses += 1;
      used[letterPosition] = -1;
      if (misses === maxWrong) outcome = 'lost';
      else choice = getChoice('Sorry, the word does not contain this letter.');
    } else {
      partialSolution = [...gameWord].map((letter, index) =>
        letter === choice ? choice : partialSolution[index]).join('');
      used[letterPosition] = 1;
      if (partialSolution === gameWord) outcome = 'won';
      else choice = getChoice('Well done! A correct letter!');
    }
  }
}

if (outcome === 'abandoned') {
  console.log(`You abandoned the game.  The word was ${gameWord}`);
} else if (outcome === 'lost') {
  console.log(`You lose.  The word was ${gameWord}`);
} else {
  console.log(`Congratulations!  You win!  The word was ${gameWord}`);
}

function getChoice(message: string): string {
  const wrongGuesses = alphabet.split('').filter((_, index) => used[index] === -1).join('');
  return readline.question(`\n\n${message}\n\n\tYour word : ${partialSolution}\n\tNo of misses : ${misses}\n\tIncorrect: ${wrongGuesses}\n\nType a letter and click on OK, or just click OK to abandon the game, HANGMAN`);
}
