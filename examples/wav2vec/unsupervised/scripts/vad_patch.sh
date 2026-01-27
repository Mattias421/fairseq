# Splend1d

export GAN_SPEECH_DATA=$DATA/LibriSpeech-10hr
export LIBRI_ROOT=~/$GAN_SPEECH_DATA
export SAVE_ROOT=workspace/$GAN_SPEECH_DATA
export RVAD_ROOT=$EXP/rVADfast


python scripts/divide_and_conquer_data.py $GAN_SPEECH_DATA

for i in {0..100};
do
    echo "splt ${i}"
    python scripts/vads_multiprocess.py -r $RVAD_ROOT --ori_file $GAN_SPEECH_DATA/train.tsv.${i} --vad_file $GAN_SPEECH_DATA/train.vads.${i};
done;

python scripts/divide_and_conquer_data.py $GAN_SPEECH_DATA
