# Note: for this to do anything, use my starter Dockerfile config (https://gist.github.com/arctic-hen7/10987790b86360820e2790650e289f0b)

# This file contains ZSH configuration for your shell when you interact with a container
# (we wouldn't want any boring `sh` now would we?)
# Please feel free to set up your own ZSH config in here!
# It gets mapped to your `.zshrc` for the root user in the container

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Source Antigen
source ~/.antigen/antigen.zsh
autoload -U colors && colors
setopt promptsubst
# Set up oh-my-zsh
antigen use oh-my-zsh
# Set up plugins
antigen bundle hadenlabs/zsh-starship
antigen bundle git
antigen bundle docker
# Set up our preferred theme
antigen theme cloud
# Run all that config
antigen apply

# Set up Ctrl + Backspace and Ctrl + Del so you can move around and backspace faster (try it!)
bindkey '^H' backward-kill-word
bindkey -M emacs '^[[3;5~' kill-word

# Set up aliases
alias cl="clear"
alias x="exit"

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac


# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

export UPDATE_CHECK="true"
export LOG_STARTUP="true"
export NO_HALF_VAE="true"
export INSECURE_EXTENSION_ACCESS="true"
export DISABLE_MODEL_LOADING_RAM_OPTIMIZATION="true"
export UI_CONFIG_FILE="/workspace/stable-diffusion-webui-forge/config_states/ui_config_pkjApril2024-FINAL.json"
export NO_DOWNLOAD_SD_MODEL="true"
export ALWAYS_HIGH_VRAM="true"
export UNET_IN_FP16="true"
export CLIP_IN_FP16="true"
export VAE_IN_FP32="true"
export CUDA_MALLOC="true"
export CUDA_STREAM="true"
export PIN_SHARED_MEMORY="true"

source /etc/rp_environment
source /etc/rp_environment
source /etc/rp_environment
source /etc/rp_environment
source /etc/rp_environment



