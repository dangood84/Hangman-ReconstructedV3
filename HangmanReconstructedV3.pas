program HangmanReconstructedV3;

uses
  SysUtils;

const
  MAX_WRONG = 6;
  ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  WORDS: array[1..20] of string = (
    'AUTOMOBILE', 'NETWORKING', 'PRACTICAL', 'CONGRESS', 'COMMANDER',
    'STAPLER', 'ENTERPRISE', 'ESCALATION', 'HAPPINESS', 'WEDNESDAY',
    'THUNDER', 'MARATHON', 'LABORATORY', 'HARBINGER', 'SUNSHINE',
    'JOURNEY', 'FANTASTIC', 'DISCOVERY', 'BOOKCASE', 'HANGMAN'
  );

var
  gameWord, partialSolution, choice, wrongGuesses, message: string;
  used: array[1..26] of Integer;
  misses, letterPosition, i: Integer;
  outcome: string;

function GetChoice(const Msg: string; const Mask: string; Misses: Integer): string;
var
  wrong: string;
  i: Integer;
begin
  wrong := '';
  for i := 1 to Length(ALPHABET) do
    if used[i] = -1 then
      wrong := wrong + ALPHABET[i];

  WriteLn;
  WriteLn(Msg);
  WriteLn;
  WriteLn(#9 + 'Your word : ' + Mask);
  WriteLn(#9 + 'No of misses : ' + IntToStr(Misses));
  WriteLn(#9 + 'Incorrect: ' + wrong);
  WriteLn;
  Write('Type a letter and click on OK, or just click OK to abandon the game, HANGMAN');
  ReadLn(GetChoice);
end;

begin
  Randomize;
  gameWord := WORDS[Random(High(WORDS) - Low(WORDS) + 1) + Low(WORDS)];
  partialSolution := StringOfChar('_', Length(gameWord));
  for i := 1 to 26 do
    used[i] := 0;
  misses := 0;
  message := 'Welcome to HANGMAN, (c) B J Good 2009';
  outcome := '';

  choice := GetChoice(message, partialSolution, misses);

  while outcome = '' do
  begin
    if choice = '' then
      outcome := 'abandoned'
    else if Length(choice) > 1 then
      choice := GetChoice('Invalid: You must enter only 1 letter at a time!', partialSolution, misses)
    else
    begin
      choice := UpperCase(choice);
      letterPosition := Pos(choice, ALPHABET);
      if letterPosition = 0 then
        choice := GetChoice('Invalid: The character you typed was not a letter!', partialSolution, misses)
      else if used[letterPosition] = -1 then
        choice := GetChoice('Invalid: You''ve already guessed this letter, and it was wrong!', partialSolution, misses)
      else if used[letterPosition] = 1 then
        choice := GetChoice('Invalid: You''ve already guessed this letter, and it was right!', partialSolution, misses)
      else
      begin
        if Pos(choice, gameWord) = 0 then
        begin
          Inc(misses);
          used[letterPosition] := -1;
          if misses = MAX_WRONG then
            outcome := 'lost'
          else
            choice := GetChoice('Sorry, the word does not contain this letter.', partialSolution, misses);
        end
        else
        begin
          for i := 1 to Length(gameWord) do
          begin
            if gameWord[i] = choice[1] then
              partialSolution[i] := choice[1];
          end;
          used[letterPosition] := 1;
          if partialSolution = gameWord then
            outcome := 'won'
          else
            choice := GetChoice('Well done! A correct letter!', partialSolution, misses);
        end;
      end;
    end;
  end;

  case outcome[1] of
    'a': WriteLn('You abandoned the game.  The word was ' + gameWord);
    'l': WriteLn('You lose.  The word was ' + gameWord);
    'w': WriteLn('Congratulations!  You win!  The word was ' + gameWord);
  end;
end.
