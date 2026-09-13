program HangmanReconstructedV3
  implicit none

  character(len=20), parameter :: words(20) = (/ &
       'AUTOMOBILE         ', 'NETWORKING         ', 'PRACTICAL          ', &
       'CONGRESS           ', 'COMMANDER          ', 'STAPLER            ', &
       'ENTERPRISE         ', 'ESCALATION         ', 'HAPPINESS          ', &
       'WEDNESDAY          ', 'THUNDER            ', 'MARATHON           ', &
       'LABORATORY         ', 'HARBINGER          ', 'SUNSHINE           ', &
       'JOURNEY            ', 'FANTASTIC          ', 'DISCOVERY          ', &
       'BOOKCASE           ', 'HANGMAN            ' /)
  character(len=*), parameter :: alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
  integer, parameter :: max_wrong = 6
  integer :: used(26) = 0
  integer :: misses, letter_pos, word_index, i, outcome
  character(len=64) :: game_word, partial_solution, choice, message, response
  real :: r

  call random_seed()
  call random_number(r)
  word_index = int(20.0 * r) + 1
  game_word = trim(words(word_index))
  partial_solution = repeat('_', len_trim(game_word))
  misses = 0
  message = 'Welcome to HANGMAN, (c) B J Good 2009'
  outcome = 0

  response = get_choice(message, partial_solution, misses, used)
  choice = response

  do while (outcome == 0)
     if (trim(choice) == '') then
        outcome = 1
     else if (len_trim(choice) > 1) then
        response = get_choice('Invalid: You must enter only 1 letter at a time!', partial_solution, misses, used)
        choice = response
     else
        choice = upper_case(trim(choice))
        letter_pos = index(alphabet, choice)
        if (letter_pos == 0) then
           response = get_choice('Invalid: The character you typed was not a letter!', partial_solution, misses, used)
           choice = response
        else if (used(letter_pos) == -1) then
           response = get_choice('Invalid: You''ve already guessed this letter, and it was wrong!', partial_solution, misses, used)
           choice = response
        else if (used(letter_pos) == 1) then
           response = get_choice('Invalid: You''ve already guessed this letter, and it was right!', partial_solution, misses, used)
           choice = response
        else
           if (index(game_word, choice) == 0) then
              misses = misses + 1
              used(letter_pos) = -1
              if (misses == max_wrong) then
                 outcome = 2
              else
                 response = get_choice('Sorry, the word does not contain this letter.', partial_solution, misses, used)
                 choice = response
              end if
           else
              do i = 1, len_trim(game_word)
                 if (game_word(i:i) == choice) then
                    partial_solution(i:i) = choice
                 end if
              end do
              used(letter_pos) = 1
              if (trim(partial_solution) == trim(game_word)) then
                 outcome = 3
              else
                 response = get_choice('Well done! A correct letter!', partial_solution, misses, used)
                 choice = response
              end if
           end if
        end if
     end if
  end do

  if (outcome == 1) then
     print *, 'You abandoned the game.  The word was ', trim(game_word)
  else if (outcome == 2) then
     print *, 'You lose.  The word was ', trim(game_word)
  else
     print *, 'Congratulations!  You win!  The word was ', trim(game_word)
  end if

contains

  function upper_case(value) result(result_value)
    character(len=*), intent(in) :: value
    character(len=len(value)) :: result_value
    integer :: i, code

    result_value = value
    do i = 1, len_trim(value)
       code = iachar(value(i:i))
       if (code >= iachar('a') .and. code <= iachar('z')) then
          result_value(i:i) = achar(code - 32)
       end if
    end do
  end function upper_case

  function get_choice(msg, mask, miss_count, tracker) result(response)
    character(len=*), intent(in) :: msg, mask
    integer, intent(in) :: miss_count
    integer, intent(in) :: tracker(26)
    character(len=64) :: response
    character(len=32) :: wrong
    integer :: j

    wrong = ''
    do j = 1, 26
       if (tracker(j) == -1) then
          wrong = trim(wrong) // alphabet(j:j)
       end if
    end do

    print *, ''
    print *, trim(msg)
    print *, ''
    print *, achar(9)//'Your word : ', trim(mask)
    print *, achar(9)//'No of misses : ', miss_count
    print *, achar(9)//'Incorrect: ', trim(wrong)
    print *, ''
    print *, 'Type a letter and press Enter, or just press Enter to abandon the game, HANGMAN'
    read(*, '(A)') response
  end function get_choice

end program HangmanReconstructedV3
