#!/bin/bash

# Set local Python version (assuming you're in the project directory)

pyenv install 3.9.9
pyenv local 3.9.9
python --version

rm -r .venv

# Create and activate virtual environment
python -m venv .venv


echo "run command:
source .venv/bin/activate

Then:

bash install_python_pkgs.sh"
