:- initialization(main).

words(["AUTOMOBILE","NETWORKING","PRACTICAL","CONGRESS","COMMANDER",
       "STAPLER","ENTERPRISE","ESCALATION","HAPPINESS","WEDNESDAY",
       "THUNDER","MARATHON","LABORATORY","HARBINGER","SUNSHINE",
       "JOURNEY","FANTASTIC","DISCOVERY","BOOKCASE","HANGMAN"]).

alphabet("ABCDEFGHIJKLMNOPQRSTUVWXYZ").
max_wrong(6).

main :-
    words(Words),
    random_member(GameWord, Words),
    string_chars(GameWord, GameChars),
    length(GameChars, Len),
    maplist(=('_'), Chars),
    atom_chars(Mask, Chars),
    used_list(Used, 26),
    misses(0),
    get_choice('Welcome to HANGMAN, (c) B J Good 2009', Mask, 0, Used, Choice),
    game_loop(GameWord, Mask, 0, Used, Choice, Outcome),
    report(Outcome, GameWord).

used_list(Used, N) :-
    length(Used, N),
    maplist(=(:=), Used).

game_loop(GameWord, Mask, Misses, Used, Choice, Outcome) :-
    (   Choice = '' -> Outcome = abandoned
    ;  string_length(Choice, L), L > 1 ->
       get_choice('Invalid: You must enter only 1 letter at a time!', Mask, Misses, Used, NewChoice),
       game_loop(GameWord, Mask, Misses, Used, NewChoice, Outcome)
    ;  atom_chars(Choice, [Letter]),
       upcase_atom(Letter, Upper),
       alphabet(Alphabet),
       string_chars(Alphabet, Letters),
       (   member(Upper, Letters) ->
            index_of(Letters, Upper, Position),
            nth0(Position, Used, State),
            (   State =:= -1 ->
                get_choice("Invalid: You've already guessed this letter, and it was wrong!", Mask, Misses, Used, NewChoice),
                game_loop(GameWord, Mask, Misses, Used, NewChoice, Outcome)
            ;   State =:= 1 ->
                get_choice("Invalid: You've already guessed this letter, and it was right!", Mask, Misses, Used, NewChoice),
                game_loop(GameWord, Mask, Misses, Used, NewChoice, Outcome)
            ;   sub_atom(GameWord, _, _, _, Upper) ->
                reveal_letters(GameWord, Mask, Upper, NewMask),
                replace_at(Used, Position, 1, NewUsed),
                (   NewMask = GameWord -> Outcome = won
                ;   get_choice('Well done! A correct letter!', NewMask, Misses, NewUsed, NewChoice),
                    game_loop(GameWord, NewMask, Misses, NewUsed, NewChoice, Outcome)
                )
            ;   Misses1 is Misses + 1,
                replace_at(Used, Position, -1, NewUsed),
                (   Misses1 =:= 6 -> Outcome = lost
                ;   get_choice('Sorry, the word does not contain this letter.', Mask, Misses1, NewUsed, NewChoice),
                    game_loop(GameWord, Mask, Misses1, NewUsed, NewChoice, Outcome)
                )
            )
       ;   get_choice('Invalid: The character you typed was not a letter!', Mask, Misses, Used, NewChoice),
           game_loop(GameWord, Mask, Misses, Used, NewChoice, Outcome)
       )
    ).

reveal_letters(GameWord, Mask, Letter, NewMask) :-
    string_chars(GameWord, GChars),
    string_chars(Mask, MChars),
    maplist(reveal_one(Letter), GChars, MChars, Result),
    atom_chars(NewMask, Result).

reveal_one(Letter, GChar, MChar, Out) :-
    (   GChar =:= Letter -> Out = Letter ; Out = MChar ).

replace_at(List, Index, Value, NewList) :-
    nth0(Index, List, _, Rest),
    nth0(Index, NewList, Value, Rest).

index_of([Element|_], Element, 0).
index_of([_|Tail], Element, Index) :-
    index_of(Tail, Element, Rest),
    Index is Rest + 1.

get_choice(Message, Mask, Misses, Used, Choice) :-
    wrong_guesses(Used, Wrong),
    format('~n~n~w~n~n\tYour word : ~w~n\tNo of misses : ~w~n\tIncorrect: ~w~n~nType a letter and press Enter, or just press Enter to abandon the game, HANGMAN ',
           [Message, Mask, Misses, Wrong]),
    read_line_to_string(user_input, Choice).

wrong_guesses(Used, Wrong) :-
    findall(L, (nth0(I, Used, -1), atom_chars('ABCDEFGHIJKLMNOPQRSTUVWXYZ', Letters), nth0(I, Letters, L)), WrongChars),
    atomic_list_concat(WrongChars, Wrong).

report(abandoned, Word) :- format('~nYou abandoned the game.  The word was ~w~n', [Word]).
report(lost, Word)      :- format('~nYou lose.  The word was ~w~n', [Word]).
report(won, Word)       :- format('~nCongratulations!  You win!  The word was ~w~n', [Word]).
