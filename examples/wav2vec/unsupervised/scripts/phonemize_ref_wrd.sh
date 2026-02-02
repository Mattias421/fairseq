#!/bin/bash

# --ipa=1: Use a simpler IPA output
# sed: removes primary stress (ˈ), secondary stress (ˌ), and the tie-bar (͡)
# tr -s ' ': squeezes multiple spaces into one
file=$DATA/LibriSpeech-10hr-rVAD/valid

while read -r line; do
    echo "$line" | espeak-ng -q -v en-us --ipa=1 --sep=' '
done < $file.wrd > $file.phn

# espeak-ng -q -v "$ph_lg" --ipa=1 --sep=' ' -f "$file.wrd" | \
# sed "s/[ˈˌ͡]//g" | tr -s ' ' > "$file.phn"
