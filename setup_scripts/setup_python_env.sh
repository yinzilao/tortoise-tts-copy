#!/bin/bash


# Runpod Template: https://github.com/yinzilao/tortoise-tts-copy.git

# Install dependencies
apt-get update
apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
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

echo "Config github"

git config --global user.email "yinzilao@outlook.com"
git config --global user.name "yinzilao"

echo "run command:

source ~/.bashrc

Then:

bash install_python_pkgs.sh"

