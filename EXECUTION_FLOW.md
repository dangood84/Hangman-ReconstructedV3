# Execution Flow

All ports follow the same V2-style sequence, even where a language expresses the loop differently.

```mermaid
flowchart TD
    A[Start] --> B[Choose a random word]
    B --> C[Create underscore mask]
    C --> D[Display prompt and read input]
    D --> E{Input empty?}
    E -->|Yes| F[Outcome: abandoned]
    E -->|No| G{One character?}
    G -->|No| D
    G -->|Yes| H[Convert to uppercase]
    H --> I{A-Z letter?}
    I -->|No| D
    I -->|Yes| J{Already guessed?}
    J -->|Yes| D
    J -->|No| K{Letter in word?}
    K -->|No| L[Increment misses and mark wrong]
    L --> M{Six misses?}
    M -->|Yes| N[Outcome: lost]
    M -->|No| D
    K -->|Yes| O[Reveal every matching letter]
    O --> P{Mask equals word?}
    P -->|Yes| Q[Outcome: won]
    P -->|No| D
    F --> R[Report outcome and secret word]
    N --> R
    Q --> R
    R --> S[End]
```

## Detailed loop

1. Choose a word, create a same-length underscore mask, clear the tracker, and set misses to zero.
2. Display the current message, mask, miss count, and incorrect-letter list.
3. Treat empty input as abandonment. Reject input longer than one character.
4. Uppercase one-character input and reject anything outside A-Z.
5. Reject a letter already recorded as right or wrong.
6. For a new wrong letter, increment misses and end after the sixth miss.
7. For a new correct letter, reveal all of its occurrences and end when the mask matches the secret word.
8. Print the outcome and the secret word.
