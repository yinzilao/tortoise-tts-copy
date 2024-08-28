from fastapi import FastAPI, HTTPException, BackgroundTasks
from pydantic import BaseModel
from typing import List, Optional
import torch
import torchaudio
import os
import uuid
from tortoise.api import TextToSpeech, MODELS_DIR
from tortoise.utils.audio import load_voices

from starlette.responses import FileResponse

app = FastAPI()

class TTSRequest(BaseModel):
    text: str = "The expressiveness of autoregressive transformers is literally nuts! I absolutely adore them."
    voice: str = "random"
    preset: str = "fast"
    use_deepspeed: bool = False
    kv_cache: bool = True
    half: bool = True
    #output_path: str = "results/"
    model_dir: str = MODELS_DIR
    candidates: int = 3
    seed: Optional[int] = None
    produce_debug_state: bool = True
    cvvp_amount: float = 0.0

@app.post("/tts")
async def text_to_speech(request: TTSRequest, background_tasks: BackgroundTasks):
    try:
        os.makedirs("results/", exist_ok=True)
        
        if torch.backends.mps.is_available():
            request.use_deepspeed = False

        tts = TextToSpeech(models_dir=request.model_dir, use_deepspeed=request.use_deepspeed, 
                           kv_cache=request.kv_cache, half=request.half)

        selected_voices = request.voice.split(',')
        results = []

        for k, selected_voice in enumerate(selected_voices):
            if '&' in selected_voice:
                voice_sel = selected_voice.split('&')
            else:
                voice_sel = [selected_voice]
            
            voice_samples, conditioning_latents = load_voices(voice_sel)

            gen, dbg_state = tts.tts_with_preset(
                request.text, 
                k=request.candidates, 
                voice_samples=voice_samples, 
                conditioning_latents=conditioning_latents,
                preset=request.preset, 
                use_deterministic_seed=request.seed, 
                return_deterministic_state=True, 
                cvvp_amount=request.cvvp_amount
            )

            if isinstance(gen, list):
                for j, g in enumerate(gen):
                    file_name = f'{selected_voice}_{k}_{j}.wav'
                    file_path = os.path.join(request.output_path, file_name)
                    background_tasks.add_task(torchaudio.save, file_path, g.squeeze(0).cpu(), 24000)
                    results.append(file_name)
            else:
                file_name = f'{selected_voice}_{k}.wav'
                file_path = os.path.join(request.output_path, file_name)
                background_tasks.add_task(torchaudio.save, file_path, gen.squeeze(0).cpu(), 24000)
                results.append(file_name)

            if request.produce_debug_state:
                os.makedirs('debug_states', exist_ok=True)
                debug_file = f'debug_states/do_tts_debug_{selected_voice}.pth'
                background_tasks.add_task(torch.save, dbg_state, debug_file)
                results.append(f"Debug state: {debug_file}")

        return {"message": "Audio generation tasks started", "output_files": results}

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/download/{file_name}")
async def download_file(file_name: str):
    file_path = os.path.join("/root/tortoise-tts-copy/results", file_name)
    if os.path.exists(file_path):
        return FileResponse(file_path, media_type="audio/wav", filename=file_name)
    else:
        raise HTTPException(status_code=404, detail="File not found")


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)