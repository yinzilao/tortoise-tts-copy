# Tortoise on Runpod
Template: https://www.runpod.io/console/explore/runpod-vscode
Code repo: https://github.com/yinzilao/tortoise-tts-copy.git

* Deploy -> Select GPU (Community Cloud: RTX A4000) -> Deploy

First time connect:
* When ready: Connect -> Configure Public Key: ssh-keygen -t xxx -C "your_email@example.com"
* Run the script in your local terminal.
``` bash
ssh-keygen -t xxx -C "your_email@example.com"
cat cat ~/.ssh/id_xxx.pub
To see your public key
```
* Connection Options -> find bash ssh command -> run basic ssh in local terminal

* When connected, run 
cat ~/.ssh/authorized_keys

* Check whether your public key is in the ~/.ssh/authorized_keys
* If not, add using 
```bash
cat << 'EOF' >> ~/.ssh/authorized_keys
YOUR-PUB-KEY
EOF
```


in VS Code
* Ctl+Shift+P 
* Select Remote-ssh: Open Ssh configuration file. add
```
Host RunPod-VSCode
    HostName <pod-public-ip>
    User root
    Port <pod-external-port>
    IdentityFile ~/.ssh/id_<your-key-file>
```
* Ctl+Shift+P
* Remote-ssh: connect to host -> RunPod-VSCode

Reconnect to a new VS Code Pod:

* Ctl+Shift+P in VS Code
* Select Remote-ssh: Open Ssh configuration file
```
Host RunPod-VSCode
    HostName <pod-public-ip>
    User root
    Port <pod-external-port>
    IdentityFile ~/.ssh/id_<your-key-file>
```
* Ctl+Shift+P
* Remote-ssh: connect to host -> RunPod-VSCode

If it fails, in a terminal, try
```bash
ssh root@<pod-public-ip> -p <pod-external-port> -i ~/.ssh/id_<your-key-file>
```
 
* Ctl+Shift+P
* Remote-ssh: connect to host -> RunPod-VSCode

## Clone from Github
https://github.com/yinzilao/tortoise-tts-copy.git

clone to /root/

new terminal

run 
```bash
bash setup_python_env.sh # or run line by line (recommended)
bash install_python_pkgs.sh # or run line by line (recommended)

```

Install python extension in VS Code

## Test on host
```bash
time python tortoise/do_tts.py --preset ultra_fast --voice 'train_atkins&train_kennard' --text "\[I am really sad,\] Please feed me."
```

```bash
time python3 tortoise/do_tts.py \
    --output_path ./results \
    --seed 12345 \
    --preset ultra_fast \
    --voice train_kennard \
    --text "One day, Amelia's mother took her to see the first-ever airplane. As she watched the magnificent machine take to the skies, Amelia's eyes grew wide with wonder. 'Someday, I'll be up there too\!' she said with excitement."
```

Custom voice:
```bash
time python tortoise/do_tts.py \
    --output_path ./results \
    --seed 54321 \
    --preset standard \
    --voice 'custom_milli' \
    --text "One day, Amelia's mother took her to see the first-ever airplane. As she watched the magnificent machine take to the skies, Amelia's eyes grew wide with wonder. 'Someday, I'll be up there too\!' she said with excitement."
```
 
#### trained good quality voices suitable for book reading
train_kennard
train_atkins

custom voice:
custom_milli

## Debugging in Code VS (remote host) 
To set up debugging for a Python script in VS Code while handling the various arguments, you need to configure the `launch.json` file to include all the arguments as needed. 

### 1. **Open the `launch.json` File**

If you don’t have a `launch.json` file yet:
1. Go to the Run and Debug view in VS Code (`Ctrl+Shift+D`).
2. Click on **create a launch.json file**.
3. Select **Python** when prompted.

If you already have a `launch.json` file, open it from the `.vscode` directory in your project.

### 2. **Edit the `launch.json` File**

Here's how to configure `launch.json` to include all the arguments for your script. Replace the placeholder values with actual values or leave them as they are if you want to specify them when starting the debug session.

```json
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Python Debugger: Current File with Arguments",
            "type": "debugpy",
            "request": "launch",
            "program": "${file}",
            "console": "integratedTerminal",
            "args": [
                "-p", "ultra_fast",
                "-O", "./results",
                "-v", "train_kennard,train_atkins",
                "--candidates", "5",
            ]
        }
    ]
}
```

### 3. **Start Debugging**

1. Save the `launch.json` file.
2. Go to the Run and Debug view (`Ctrl+Shift+D`).
3. Select the configuration you created (`Python: Script with Args`).
4. Click the green play button or press `F5` to start debugging.

### 4. **Interact with the Debugging Session**

While debugging, you can:
- **Use Breakpoints**: Click in the margin next to line numbers to set breakpoints.
- **Inspect Variables**: Check variable values in the **Variables** panel.
- **Evaluate Expressions**: Use the **Debug Console** to run code snippets and evaluate expressions.
- **Step Through Code**: Use the step-over, step-into, and step-out buttons to navigate through your code.


## Start API Server
```bash
uvicorn server.main:app --host 0.0.0.0 --port 8000
```

## Client usage example

```bash
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
```

# TorToiSe

Tortoise is a text-to-speech program built with the following priorities:

1. Strong multi-voice capabilities.
2. Highly realistic prosody and intonation.
   
This repo contains all the code needed to run Tortoise TTS in inference mode.

Manuscript: https://arxiv.org/abs/2305.07243
## Hugging Face space

A live demo is hosted on Hugging Face Spaces. If you'd like to avoid a queue, please duplicate the Space and add a GPU. Please note that CPU-only spaces do not work for this demo.

https://huggingface.co/spaces/Manmay/tortoise-tts

## Install via pip
```bash
pip install tortoise-tts
```

If you would like to install the latest development version, you can also install it directly from the git repository:

```bash
pip install git+https://github.com/neonbjb/tortoise-tts
```

## What's in a name?

I'm naming my speech-related repos after Mojave desert flora and fauna. Tortoise is a bit tongue in cheek: this model
is insanely slow. It leverages both an autoregressive decoder **and** a diffusion decoder; both known for their low
sampling rates. On a K80, expect to generate a medium sized sentence every 2 minutes.

well..... not so slow anymore now we can get a **0.25-0.3 RTF** on 4GB vram and with streaming we can get < **500 ms** latency !!! 

## Demos

See [this page](http://nonint.com/static/tortoise_v2_examples.html) for a large list of example outputs.

A cool application of Tortoise + GPT-3 (not affiliated with this repository): https://twitter.com/lexman_ai. Unfortunately, this project seems no longer to be active.

## Usage guide

### Local installation

If you want to use this on your own computer, you must have an NVIDIA GPU.

On Windows, I **highly** recommend using the Conda installation method. I have been told that if you do not do this, you
will spend a lot of time chasing dependency problems.

First, install miniconda: https://docs.conda.io/en/latest/miniconda.html

Then run the following commands, using anaconda prompt as the terminal (or any other terminal configured to work with conda)

This will:
1. create conda environment with minimal dependencies specified
1. activate the environment
1. install pytorch with the command provided here: https://pytorch.org/get-started/locally/
1. clone tortoise-tts
1. change the current directory to tortoise-tts
1. run tortoise python setup install script

```shell
conda create --name tortoise python=3.9 numba inflect
conda activate tortoise
conda install pytorch torchvision torchaudio pytorch-cuda=11.7 -c pytorch -c nvidia
conda install transformers=4.29.2
git clone https://github.com/neonbjb/tortoise-tts.git
cd tortoise-tts
python setup.py install
```

Optionally, pytorch can be installed in the base environment, so that other conda environments can use it too. To do this, simply send the `conda install pytorch...` line before activating the tortoise environment.

> **Note:** When you want to use tortoise-tts, you will always have to ensure the `tortoise` conda environment is activated.

If you are on windows, you may also need to install pysoundfile: `conda install -c conda-forge pysoundfile`

### Docker

An easy way to hit the ground running and a good jumping off point depending on your use case.

```sh
git clone https://github.com/neonbjb/tortoise-tts.git
cd tortoise-tts

docker build . -t tts

docker run --gpus all \
    -e TORTOISE_MODELS_DIR=/models \
    -v /mnt/user/data/tortoise_tts/models:/models \
    -v /mnt/user/data/tortoise_tts/results:/results \
    -v /mnt/user/data/.cache/huggingface:/root/.cache/huggingface \
    -v /root:/work \
    -it tts
```
This gives you an interactive terminal in an environment that's ready to do some tts. Now you can explore the different interfaces that tortoise exposes for tts.

For example:

```sh
cd app
conda activate tortoise
time python tortoise/do_tts.py \
    --output_path /results \
    --preset ultra_fast \
    --voice geralt \
    --text "Time flies like an arrow; fruit flies like a bananna."
```

## Apple Silicon

On macOS 13+ with M1/M2 chips you need to install the nighly version of PyTorch, as stated in the official page you can do:

```shell
pip3 install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cpu
```

Be sure to do that after you activate the environment. If you don't use conda the commands would look like this:

```shell
python3.10 -m venv .venv
source .venv/bin/activate
pip install numba inflect psutil
pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cpu
pip install transformers
git clone https://github.com/neonbjb/tortoise-tts.git
cd tortoise-tts
pip install .
```

Be aware that DeepSpeed is disabled on Apple Silicon since it does not work. The flag `--use_deepspeed` is ignored.
You may need to prepend `PYTORCH_ENABLE_MPS_FALLBACK=1` to the commands below to make them work since MPS does not support all the operations in Pytorch.


### do_tts.py

This script allows you to speak a single phrase with one or more voices.
```shell
python tortoise/do_tts.py --text "I'm going to speak this" --voice random --preset fast
```
### do socket streaming
```socket server
python tortoise/socket_server.py 
```
will listen at port 5000


### faster inference read.py

This script provides tools for reading large amounts of text.

```shell
python tortoise/read_fast.py --textfile <your text to be read> --voice random
```

### read.py

This script provides tools for reading large amounts of text.

```shell
python tortoise/read.py --textfile <your text to be read> --voice random
```

This will break up the textfile into sentences, and then convert them to speech one at a time. It will output a series
of spoken clips as they are generated. Once all the clips are generated, it will combine them into a single file and
output that as well.

Sometimes Tortoise screws up an output. You can re-generate any bad clips by re-running `read.py` with the --regenerate
argument.

### API

Tortoise can be used programmatically, like so:

```python
reference_clips = [utils.audio.load_audio(p, 22050) for p in clips_paths]
tts = api.TextToSpeech()
pcm_audio = tts.tts_with_preset("your text here", voice_samples=reference_clips, preset='fast')
```

To use deepspeed:

```python
reference_clips = [utils.audio.load_audio(p, 22050) for p in clips_paths]
tts = api.TextToSpeech(use_deepspeed=True)
pcm_audio = tts.tts_with_preset("your text here", voice_samples=reference_clips, preset='fast')
```

To use kv cache:

```python
reference_clips = [utils.audio.load_audio(p, 22050) for p in clips_paths]
tts = api.TextToSpeech(kv_cache=True)
pcm_audio = tts.tts_with_preset("your text here", voice_samples=reference_clips, preset='fast')
```

To run model in float16:

```python
reference_clips = [utils.audio.load_audio(p, 22050) for p in clips_paths]
tts = api.TextToSpeech(half=True)
pcm_audio = tts.tts_with_preset("your text here", voice_samples=reference_clips, preset='fast')
```
for Faster runs use all three:

```python
reference_clips = [utils.audio.load_audio(p, 22050) for p in clips_paths]
tts = api.TextToSpeech(use_deepspeed=True, kv_cache=True, half=True)
pcm_audio = tts.tts_with_preset("your text here", voice_samples=reference_clips, preset='fast')
```

## Acknowledgements

This project has garnered more praise than I expected. I am standing on the shoulders of giants, though, and I want to
credit a few of the amazing folks in the community that have helped make this happen:

- Hugging Face, who wrote the GPT model and the generate API used by Tortoise, and who hosts the model weights.
- [Ramesh et al](https://arxiv.org/pdf/2102.12092.pdf) who authored the DALLE paper, which is the inspiration behind Tortoise.
- [Nichol and Dhariwal](https://arxiv.org/pdf/2102.09672.pdf) who authored the (revision of) the code that drives the diffusion model.
- [Jang et al](https://arxiv.org/pdf/2106.07889.pdf) who developed and open-sourced univnet, the vocoder this repo uses.
- [Kim and Jung](https://github.com/mindslab-ai/univnet) who implemented univnet pytorch model.
- [lucidrains](https://github.com/lucidrains) who writes awesome open source pytorch models, many of which are used here.
- [Patrick von Platen](https://huggingface.co/patrickvonplaten) whose guides on setting up wav2vec were invaluable to building my dataset.

## Notice

Tortoise was built entirely by the author (James Betker) using their own hardware. Their employer was not involved in any facet of Tortoise's development.

## License

Tortoise TTS is licensed under the Apache 2.0 license.

If you use this repo or the ideas therein for your research, please cite it! A bibtex entree can be found in the right pane on GitHub.
