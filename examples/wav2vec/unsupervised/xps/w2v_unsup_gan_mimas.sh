#!/bin/bash
source .venv/bin/activate

PREFIX=w2v_unsup_gan_xp

# For wav2vec-U 2.0, use raw audio features
CONFIG_NAME=w2vu2
TASK_DATA=$DATA/LibriSpeech-10hr-rVAD/features/wav2vec_vox

# Unpaired text input
TEXT_DATA=$DATA/variety-text-corpus/LibriLM/text/phones
KENLM_PATH=$TEXT_DATA/lm.phones.filtered.04.bin  # KenLM 4-gram phoneme language model (LM data = GAN data here)

PYTHONPATH=$FAIRSEQ_ROOT PREFIX=$PREFIX fairseq-hydra-train \
    -m --config-dir config/gan \
    --config-name $CONFIG_NAME \
    task.data=${TASK_DATA} \
    task.text_data=${TEXT_DATA} \
    task.kenlm_path=${KENLM_PATH} \
    common.user_dir=${FAIRSEQ_ROOT}/examples/wav2vec/unsupervised \
    model.code_penalty=2 model.gradient_penalty=1.5 \
    model.smoothness_weight=0.75

# PYTHONPATH=$FAIRSEQ_ROOT PREFIX=$PREFIX fairseq-hydra-train \
#     -m --config-dir config/gan \
#     --config-name $CONFIG_NAME \
#     task.data=${TASK_DATA} \
#     task.text_data=${TEXT_DATA} \
#     task.kenlm_path=${KENLM_PATH} \
#     common.user_dir=${FAIRSEQ_ROOT}/examples/wav2vec/unsupervised \
#     model.code_penalty=2,4 model.gradient_penalty=1.5,2.0 \
#     model.smoothness_weight=0.5,0.75,1.0 'common.seed=range(0,5)'
