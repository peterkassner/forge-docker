#!/usr/bin/env bash

# Function to download models
download_models() {
  local directory=$1
  local models=("${!2}")

  cd "$directory" || exit 1
  for model in "${models[@]}"; do
    wget "$model"
  done
}

# Define the target directory for pulling extensions
target_directory="/workspace/extensions"

# Download animate-diff models
animate_diff_models=(
  "https://huggingface.co/conrevo/AnimateDiff-A1111/resolve/main/motion_module/mm_sdxl_v10_beta.safetensors"
  "https://huggingface.co/conrevo/AnimateDiff-A1111/resolve/main/control/mm_sd15_v3_sparsectrl_scribble.safetensors"
  "https://huggingface.co/conrevo/AnimateDiff-A1111/resolve/main/motion_module/mm_sdxl_hs.safetensors"
)
download_models "/workspace/stable-diffusion-webui-forge/extensions/sd-webui-animatediff/model" animate_diff_models

# Download controlnet models
controlnet_models=(
  "https://huggingface.co/lllyasviel/sd_control_collection/resolve/main/diffusers_xl_depth_mid.safetensors"
  "https://huggingface.co/lllyasviel/sd_control_collection/resolve/main/ip-adapter-plus_sdxl_vit-h.safetensors"
  "https://huggingface.co/lllyasviel/sd_control_collection/resolve/main/diffusers_xl_canny_mid.safetensors"
)
download_models "/workspace/stable-diffusion-webui-forge/models/ControlNet" controlnet_models

# Download sdxl models
sdxl_models=(
  "https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors"
  "https://huggingface.co/stabilityai/stable-diffusion-xl-refiner-1.0/resolve/main/sd_xl_refiner_1.0.safetensors"
)
download_models "/workspace/stable-diffusion-webui-forge/models/Stable-diffusion" sdxl_models

# Download VAE models
vae_model="https://huggingface.co/stabilityai/sdxl-vae/resolve/main/sdxl_vae.safetensors"
download_models "/workspace/stable-diffusion-webui-forge/models/VAE" vae_model

# Pull extensions from the JSON data
extensions_json='{
  "sd-civitai-browser-plus": {
    "path": "/workspace/stable-diffusion-webui-forge/extensions/sd-civitai-browser-plus",
    "remote": "https://github.com/BlafKing/sd-civitai-browser-plus.git"
  },
  "sd-dynamic-prompts": {
    "path": "/workspace/stable-diffusion-webui-forge/extensions/sd-dynamic-prompts",
    "remote": "https://github.com/adieyal/sd-dynamic-prompts.git"
  },
  "sd-webui-agent-scheduler": {
    "path": "/workspace/stable-diffusion-webui-forge/extensions/sd-webui-agent-scheduler",
    "remote": "https://github.com/ArtVentureX/sd-webui-agent-scheduler.git"
  },
  "sd-webui-animatediff": {
    "path": "/workspace/stable-diffusion-webui-forge/extensions/sd-webui-animatediff",
    "remote": "https://github.com/continue-revolution/sd-webui-animatediff.git"
  },
  "sd-webui-infinite-image-browsing": {
    "path": "/workspace/stable-diffusion-webui-forge/extensions/sd-webui-infinite-image-browsing",
    "remote": "https://github.com/zanllp/sd-webui-infinite-image-browsing.git"
  },
  "sd-webui-prompt-all-in-one": {
    "path": "/workspace/stable-diffusion-webui-forge/extensions/sd-webui-prompt-all-in-one",
    "remote": "https://github.com/Physton/sd-webui-prompt-all-in-one"
  },
  "sd-webui-segment-anything": {
    "path": "/workspace/stable-diffusion-webui-forge/extensions/sd-webui-segment-anything",
    "remote": "https://github.com/continue-revolution/sd-webui-segment-anything.git"
  },
  "stable-diffusion-webui-state": {
    "path": "/workspace/stable-diffusion-webui-forge/extensions/stable-diffusion-webui-state",
    "remote": "https://github.com/ilian6806/stable-diffusion-webui-state.git"
  }
}'

for extension in $(jq -r 'keys[]' <<<"$extensions_json"); do
  path=$(jq -r ".$extension.path" <<<"$extensions_json")
  remote=$(jq -r ".$extension.remote" <<<"$extensions_json")

  echo "Pulling $extension from $remote to $target_directory"
  git clone "$remote" "$target_directory/$(basename "$path")"
done
