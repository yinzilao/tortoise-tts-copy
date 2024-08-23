#!/bin/bash


time python tortoise/do_tts.py
    --output_path /results
    --preset ultra_fast
    --voice geralt
    --text "Time flies like an arrow; fruit flies like a bananna."