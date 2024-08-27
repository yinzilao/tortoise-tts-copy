#!/bin/bash

# Array of text examples
texts=(
    "[Reading a cheerful story slowly to a 5-year-old,] One day, Amelia's mother took her to see the first-ever airplane."
    "[Reading a cheerful story slowly to a 5-year-old,] As she watched the magnificent machine take to the skies, Amelia's eyes grew wide with wonder."
    "[mimicing Amelia's voice when she was 5]'Someday, I'll be up there too!'"
    "[Reading a cheerful story slowly to a 5-year-old,] she said with excitement."
)

# Loop through each text example
for i in "${!texts[@]}"; do
    # Increment i by 1 for output numbering
    number=$((i+1))
    
    # Run the TTS command
    time python tortoise/do_tts.py \
        --output_path "./results/$number" \
        --seed 12345 \
        --preset ultra_fast \
        --voice train_kennard \
        --text "${texts[$i]}"
    
    echo "Completed processing text $number"
    echo "-------------------------"
done

echo "All text-to-speech conversions completed."