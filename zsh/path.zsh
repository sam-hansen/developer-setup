#!/usr/bin/env zsh
# My common paths for executables
# PATH
PATH="/home/sam/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# fzf
export PATH="$PATH:$HOME/.fzf/bin"

# Anaconda3
export PATH="/opt/anaconda/bin:$PATH"

# NEURAL
export CUDA_HOME=/usr/local/cuda-8.0
export LD_LIBRARY_PATH=/usr/local/cuda/lib64/
export PATH=${CUDA_HOME}/bin:$PATH
# . /opt/torch/install/bin/torch-activate
