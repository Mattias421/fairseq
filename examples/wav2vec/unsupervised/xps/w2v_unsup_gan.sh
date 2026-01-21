#!/bin/bash
#SBATCH --time=80:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=64G
#SBATCH --output=logs/slurm/%x-%a-2.out
#SBATCH --partition=gpu,gpu-h100,gpu-h100-nvl
#SBATCH --qos=gpu
#SBATCH --gres=gpu:1

ml binutils GCCcore GCC libsndfile cuDNN bzip2
source .venv/bin/activate

PREFIX=w2v_unsup_gan_xp

# For wav2vec-U, audio features are pre-segmented
CONFIG_NAME=w2vu
TASK_DATA=/path/to/features/precompute_unfiltered_pca512_cls128_mean_pooled

# For wav2vec-U 2.0, use raw audio features
CONFIG_NAME=w2vu2
TASK_DATA=$DATA/LibriSpeech-Clean-NoSil/features/

# Unpaired text input
TEXT_DATA=$DATA/variety-text-corpus/LibriLM/text/phones
KENLM_PATH=$TEXT_DATA/kenlm.phn.o4.bin  # KenLM 4-gram phoneme language model (LM data = GAN data here)

PYTHONPATH=$FAIRSEQ_ROOT PREFIX=$PREFIX fairseq-hydra-train \
    -m --config-dir config/gan \
    --config-name $CONFIG_NAME \
    task.data=${TASK_DATA} \
    task.text_data=${TEXT_DATA} \
    task.kenlm_path=${KENLM_PATH} \
    common.user_dir=${FAIRSEQ_ROOT}/examples/wav2vec/unsupervised \
    model.code_penalty=2,4 model.gradient_penalty=1.5,2.0 \
    model.smoothness_weight=0.5,0.75,1.0 'common.seed=range(0,5)'
