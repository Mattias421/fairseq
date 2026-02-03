export PYTHONPATH=$PYTHONPATH:$FAIRSEQ_ROOT
ckpt=$EXP/fairseq/examples/wav2vec/unsupervised/outputs/checkpoint_best.pt

out=$EXP/fairseq/examples/wav2vec/unsupervised/outputs/w2vu2

for model in "$out"/*; do
    python $FAIRSEQ_ROOT/examples/wav2vec/unsupervised/w2vu_generate.py --config-dir $FAIRSEQ_ROOT/examples/wav2vec/unsupervised/config/generate --config-name viterbi \
    fairseq.common.user_dir=${FAIRSEQ_ROOT}/examples/wav2vec/unsupervised \
    fairseq.task.data=$DATA/LibriSpeech-10hr-rVAD/features/wav2vec_vox fairseq.common_eval.path=$model/0/checkpoint_last.pt fairseq.dataset.gen_subset=valid results_path=$model
done

