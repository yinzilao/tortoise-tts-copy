# !/bin/bash

# request tts
curl -X POST "http://localhost:8000/tts" \
     -H "Content-Type: application/json" \
     -d '{
         "text": "'Wow! There is a BIG airplane!' said Amelia excitedly.",
         "voice": "custom_milli",
         "preset": "ultra_fast",
         "seed": "12345"
     }'

# download generated file
curl -o custom_milli_0_0.wav http://localhost:8000/download/custom_milli_0_0.wav