#!/usr/bin/env bash

#animate-diff models
cd /workspace/stable-diffusion-webui-forge/extensions/sd-webui-animatediff/model && \
wget https://huggingface.co/conrevo/AnimateDiff-A1111/resolve/main/motion_module/mm_sdxl_v10_beta.safetensors && \
wget https://huggingface.co/conrevo/AnimateDiff-A1111/resolve/main/control/mm_sd15_v3_sparsectrl_scribble.safetensors && \
wget https://huggingface.co/conrevo/AnimateDiff-A1111/resolve/main/motion_module/mm_sdxl_hs.safetensors && \

#controlnet models
cd /workspace/stable-diffusion-webui-forge/models/ControlNet && \
wget https://huggingface.co/lllyasviel/sd_control_collection/resolve/main/diffusers_xl_depth_mid.safetensors && \
wget https://huggingface.co/lllyasviel/sd_control_collection/resolve/main/ip-adapter-plus_sdxl_vit-h.safetensors && \ 
wget https://huggingface.co/lllyasviel/sd_control_collection/resolve/main/diffusers_xl_canny_mid.safetensors && \ 

#sdxl models
cd /workspace/stable-diffusion-webui-forge/models/Stable-diffusion && \
wget https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors && \
wget https://huggingface.co/stabilityai/stable-diffusion-xl-refiner-1.0/resolve/main/sd_xl_refiner_1.0.safetensors && \ 

cd /workspace/stable-diffusion-webui-forge/models/VAE && \
wget https://huggingface.co/stabilityai/sdxl-vae/resolve/main/sdxl_vae.safetensors
