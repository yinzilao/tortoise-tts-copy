#!/bin/bash

# Upgrade pip
python -m pip install --upgrade pip

pip --version

# Install project requirements (assuming requirements.txt exists)
pip install -r requirements.txt

pip install build

python -m build

pip install -e .

echo "Setup complete. 
## Usage example
# time python tortoise/do_tts.py
#     --output_path /results
#     --preset ultra_fast
#     --voice geralt
#     --text 'Time flies like an arrow; fruit flies like a bananna.'"
