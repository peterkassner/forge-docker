# Stage 1: Base
#ARG BASE_IMAGE
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04 as base

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=on \
    SHELL=/bin/zsh \
    RUNNING_IN_DOCKER=true

# Install Ubuntu packages
RUN apt update && \
    apt -y upgrade && \
    apt install -y --no-install-recommends \
        software-properties-common \
        build-essential \
        python3.10-venv \
        python3-pip \
        python3-tk \
        python3-dev \
        nginx \
        bash \
        zsh \
        dos2unix \
        git \
        ncdu \
        net-tools \
        openssh-server \
        libglib2.0-0 \
        libsm6 \
        libgl1 \
        libxrender1 \
        libxext6 \
        ffmpeg \
        wget \
        curl \
        psmisc \
        rsync \
        vim \
        zip \
        unzip \
        htop \
        screen \
        tmux \
        bc \
        pkg-config \
        libcairo2-dev \
        libgoogle-perftools4 \
        libtcmalloc-minimal4 \
        apt-transport-https \
        ca-certificates && \
    update-ca-certificates && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen

# Set Python
RUN ln -s /usr/bin/python3.10 /usr/bin/python

# Stage 2: Install Stable Diffusion WebUI Forge and python modules
#FROM base as setup

#WORKDIR /
#RUN mkdir -p /sd-models

# Download the model file from the cloud storage service
# Replace <cloud-storage-url> with the actual URL of the model file in the cloud storage service
#ADD https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors /sd-models/

#COPY sd_xl_base_1.0.safetensors /sd-models/sd_xl_base_1.0.safetensors

# Create and use the Python venv
RUN python3 -m venv /venv

# Clone the git repo of Stable Diffusion WebUI Forge and set version
ARG FORGE_COMMIT
RUN git clone https://github.com/lllyasviel/stable-diffusion-webui-forge.git && \
    cd /stable-diffusion-webui-forge

# Install the dependencies for Stable Diffusion WebUI Forge
ARG INDEX_URL
ARG TORCH_VERSION
ARG XFORMERS_VERSION
WORKDIR /stable-diffusion-webui-forge
ENV TORCH_INDEX_URL=${INDEX_URL}
ENV TORCH_COMMAND="pip install torch==${TORCH_VERSION} torchvision==0.16.0 --index-url ${TORCH_INDEX_URL}"
#ENV XFORMERS_PACKAGE="xformers==${XFORMERS_VERSION} --index-url ${TORCH_INDEX_URL}"
RUN source /venv/bin/activate && \
    ${TORCH_COMMAND} && \
    pip3 install -r requirements_versions.txt --extra-index-url ${TORCH_INDEX_URL} && \
    #pip3 install ${XFORMERS_PACKAGE} &&  \
    deactivate

COPY forge/cache-sd-model.py forge/install-forge.py ./
RUN source /venv/bin/activate && \
    python3 -m install-forge --skip-torch-cuda-test && \
    deactivate

# Cache the Stable Diffusion Models
# SDXL models result in OOM kills with 8GB system memory, need 30GB+ to cache these
#    RUN source /venv/bin/activate && \
#        python3 cache-sd-model.py --no-half-vae --no-half --xformers --use-cpu=all --ckpt /sd-models/sd_xl_base_1.0.safetensors && \
#    deactivate

# Copy Stable Diffusion WebUI Forge config files
COPY forge/relauncher.py forge/webui-user.sh forge/config.json forge/ui_config_pkjApril2024-FINAL.json forge/ui-config.json /stable-diffusion-webui-forge/

# ADD SDXL styles.csv
ADD https://raw.githubusercontent.com/Douleb/SDXL-750-Styles-GPT4-/main/styles.csv /stable-diffusion-webui/styles.csv

# Install Jupyter, gdown and OhMyRunPod
RUN pip3 install -U --no-cache-dir ipykernel \
        ipywidgets \
        gdown \
        OhMyRunPod

# Install RunPod File Uploader
RUN curl -sSL https://github.com/kodxana/RunPod-FilleUploader/raw/main/scripts/installer.sh -o installer.sh && \
    chmod +x installer.sh && \
    ./installer.sh

# Install rclone
RUN curl https://rclone.org/install.sh | bash

# Install runpodctl
ARG RUNPODCTL_VERSION
RUN wget "https://github.com/runpod/runpodctl/releases/download/${RUNPODCTL_VERSION}/runpodctl-linux-amd64" -O runpodctl && \
    chmod a+x runpodctl && \
    mv runpodctl /usr/local/bin

# Install croc
RUN curl https://getcroc.schollz.com | bash

# Install speedtest CLI
RUN curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | bash && \
    apt install speedtest

# Install CivitAI Model Downloader
ARG CIVITAI_DOWNLOADER_VERSION
RUN git clone https://github.com/ashleykleynhans/civitai-downloader.git && \
    cd civitai-downloader && \
    git checkout tags/${CIVITAI_DOWNLOADER_VERSION} && \
    cp download.py /usr/local/bin/download-model && \
    chmod +x /usr/local/bin/download-model && \
    cd .. && \
    rm -rf civitai-downloader

# Remove existing SSH host keys
RUN rm -f /etc/ssh/ssh_host_*

# NGINX Proxy
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/502.html /usr/share/nginx/html/502.html

# Set template version
ARG RELEASE
ENV TEMPLATE_VERSION=${RELEASE}

# Set the venv path
ARG VENV_PATH
ENV VENV_PATH=${VENV_PATH}

# Copy the scripts
WORKDIR /
COPY --chmod=755 scripts/* ./
RUN mkdir -p ./logs

# Start the container
SHELL ["/bin/bash", "--login", "-c"]
CMD [ "/bin/bash", "--login", "-c", "/start.sh 2>&1 | tee /workspace/logs/startup.log" ]

