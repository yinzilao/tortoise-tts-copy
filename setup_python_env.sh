#!/bin/bash


# Runpod Template: https://github.com/yinzilao/tortoise-tts-copy.git

# Install dependencies
sudo apt-get update
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev libffi-dev liblzma-dev python-openssl git

# Install pyenv
curl https://pyenv.run | bash

# Add pyenv to shell configuration
cat << 'EOF' >> ~/.bashrc

# Pyenv configuration
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
EOF

# Reload shell configuration
source ~/.bashrc

# Install Python versions
# pyenv install 3.8.12
pyenv install 3.9.9
# pyenv install 3.10.4

# Set global Python version
pyenv global 3.9.9

# Verify Python and pip versions
python --version
pip --version

# Upgrade pip
python -m pip install --upgrade pip

# Set local Python version (assuming you're in the project directory)
pyenv local 3.9.9

# Create and activate virtual environment
python -m venv .venv
source .venv/bin/activate

# Install project requirements (assuming requirements.txt exists)
pip install -r requirements.txt

echo "Setup complete. Remember to activate the virtual environment with 'source .venv/bin/activate' when working on this project."

python -m build

pip install -e .

## Usage example
# time python tortoise/do_tts.py
#     --output_path /results
#     --preset ultra_fast
#     --voice geralt
#     --text "Time flies like an arrow; fruit flies like a bananna."
