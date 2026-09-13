#!/usr/bin/env bash

words=(
  AUTOMOBILE NETWORKING PRACTICAL CONGRESS COMMANDER
  STAPLER ENTERPRISE ESCALATION HAPPINESS WEDNESDAY
  THUNDER MARATHON LABORATORY HARBINGER SUNSHINE
  JOURNEY FANTASTIC DISCOVERY BOOKCASE HANGMAN
)

alphabet="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
max_wrong=6
word="${words[$((RANDOM % ${#words[@]}))]}"
mask=""
for ((i=0; i<${#word}; i++)); do mask+="_"; done
misses=0
used=()
for ((i=0; i<26; i++)); do used[i]=0; done
message="Welcome to HANGMAN, (c) B J Good 2009"
outcome=""

prompt() {
  local msg="$1"
  local wrong=""
  for ((i=0; i<26; i++)); do
    if [[ ${used[i]} -eq -1 ]]; then
      wrong+="${alphabet:i:1}"
    fi
  done

  printf "\n\n%s\n\n\tYour word : %s\n\tNo of misses : %s\n\tIncorrect: %s\n\nType a letter and press Enter, or just press Enter to abandon the game, HANGMAN " "$msg" "$mask" "$misses" "$wrong"
  read -r choice
  printf '%s' "$choice"
}

while [[ -z "$outcome" ]]; do
  choice="$(prompt "$message")"

  if [[ -z "$choice" ]]; then
    outcome="abandoned"
  elif (( ${#choice} > 1 )); then
    message="Invalid: You must enter only 1 letter at a time!"
  else
    choice="${choice^^}"
    position="${alphabet%%$choice*}"
    pos_index=${#position}
    if [[ "$choice" =~ [^A-Z] ]]; then
      message="Invalid: The character you typed was not a letter!"
    elif (( ${used[pos_index]} == -1 )); then
      message="Invalid: You've already guessed this letter, and it was wrong!"
    elif (( ${used[pos_index]} == 1 )); then
      message="Invalid: You've already guessed this letter, and it was right!"
    else
      found=false
      for ((i=0; i<${#word}; i++)); do
        if [[ ${word:i:1} == "$choice" ]]; then
          found=true
          local_mask=""
          for ((j=0; j<${#word}; j++)); do
            ch="${word:j:1}"
            if [[ "$ch" == "$choice" ]]; then
              local_mask+="$choice"
            else
              local_mask+="${mask:j:1}"
            fi
          done
          mask="$local_mask"
          used[pos_index]=1
          break
        fi
      done

      if [[ "$found" == false ]]; then
        misses=$((misses + 1))
        used[pos_index]=-1
        if (( misses == max_wrong )); then
          outcome="lost"
        else
          message="Sorry, the word does not contain this letter."
        fi
      elif [[ "$mask" == "$word" ]]; then
        outcome="won"
      else
        message="Well done! A correct letter!"
      fi
    fi
  fi
done

case "$outcome" in
  abandoned)
    printf '\nYou abandoned the game.  The word was %s\n' "$word"
    ;;
  lost)
    printf '\nYou lose.  The word was %s\n' "$word"
    ;;
  won)
    printf '\nCongratulations!  You win!  The word was %s\n' "$word"
    ;;
 esac
