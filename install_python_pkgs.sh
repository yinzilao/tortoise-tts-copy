#!/bin/bash

# Set local Python version (assuming you're in the project directory)
pyenv local 3.9.9
python --version

rm -r .venv

# Create and activate virtual environment
python -m venv .venv
source .venv/bin/activate

# Upgrade pip
python -m pip install --upgrade pip

pip --version

# Install project requirements (assuming requirements.txt exists)
pip install -r requirements.txt

python -m build

pip install -e .


echo "Setup complete. 
## Usage example
# time python tortoise/do_tts.py
#     --output_path /results
#     --preset ultra_fast
#     --voice geralt
#     --text 'Time flies like an arrow; fruit flies like a bananna.'"
