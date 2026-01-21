export FAIRSEQ_ROOT=$EXP/fairseq
export RVAD_ROOT=$EXP/rVADfast
export KENLM_ROOT=$EXP/kenlm/build/bin
export KALDI_ROOT=$EXP/pykaldi/tools/kaldi
export OPENFST_ROOT=$KALDI_ROOT/tools/openfst-1.6.7

# 2. Add BOTH library paths to LD_LIBRARY_PATH
# This includes:
#   - Kaldi libs (src/lib)
#   - OpenFST libs (lib)
export LD_LIBRARY_PATH=$KALDI_ROOT/src/lib:$OPENFST_ROOT/lib:$LD_LIBRARY_PATH
