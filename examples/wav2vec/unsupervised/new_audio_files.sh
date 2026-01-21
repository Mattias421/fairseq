#!/bin/bash
#SBATCH --time=80:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8G
#SBATCH --output=logs/slurm/%x-%a-2.out

echo "starting experiment"

cd $EXP/fairseq/examples/wav2vec/unsupervised

ml binutils GCCcore GCC libsndfile cuDNN bzip2

source .venv/bin/activate
# python $FAIRSEQ_ROOT/examples/wav2vec/wav2vec_manifest.py $DATA/LibriSpeech --dest ./outputs/librispeech

# python scripts/vads.py -r $RVAD_ROOT < ./outputs/librispeech/train.tsv > ./outputs/librispeech/train.vads

# python scripts/remove_silence.py --tsv ./outputs/librispeech/train.tsv --vads ./outputs/librispeech/train.vads --out ./outputs/librispeech

python $FAIRSEQ_ROOT/examples/wav2vec/wav2vec_manifest.py $DATA/LibriSpeech-Clean-NoSil --dest $DATA/LibriSpeech-Clean-NoSil --valid-percent 0.01

#SBATCH --partition=gpu,gpu-h100,gpu-h100-nvl
#SBATCH --qos=gpu
#SBATCH --gres=gpu:1

