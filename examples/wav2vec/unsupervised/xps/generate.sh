export PYTHONPATH=$PYTHONPATH:$FAIRSEQ_ROOT

python $FAIRSEQ_ROOT/examples/wav2vec/unsupervised/w2vu_generate.py --config-dir $FAIRSEQ_ROOT/examples/wav2vec/unsupervised/config/generate --config-name viterbi \
fairseq.common.user_dir=${FAIRSEQ_ROOT}/examples/wav2vec/unsupervised \
fairseq.task.data=$DATA/LibriSpeech-10hr-rVAD/features/wav2vec_vox fairseq.common_eval.path=$EXP/fairseq/examples/wav2vec/unsupervised/outputs/w2vu2/checkpoint_best.pt fairseq.dataset.gen_subset=valid results_path=$EXP/fairseq/examples/wav2vec/unsupervised/outputs/
cd -
