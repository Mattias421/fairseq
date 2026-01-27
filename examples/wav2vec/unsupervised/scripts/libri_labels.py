#!/usr/bin/env python3
import argparse
import os

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("tsv", help="Path to your edited .tsv file (e.g., valid.tsv)")
    parser.add_argument("--libri-root", required=True, help="Path to the original train-clean-100 folder")
    parser.add_argument("--output-dir", required=True)
    parser.add_argument("--output-name", required=True)
    args = parser.parse_args()

    os.makedirs(args.output_dir, exist_ok=True)

    # Cache for transcriptions to avoid re-reading files
    transcriptions = {}

    with open(args.tsv, "r") as tsv, open(
        os.path.join(args.output_dir, args.output_name + ".ltr"), "w"
    ) as ltr_out, open(
        os.path.join(args.output_dir, args.output_name + ".wrd"), "w"
    ) as wrd_out:

        root = next(tsv).strip() # Skip header line
        for line in tsv:
            line = line.strip()
            if not line: continue

            # Extract the filename only: 446-123501-0015
            file_path = line.split()[0]
            base_filename = os.path.basename(file_path).replace(".flac", "")

            # LibriSpeech format is ALWAYS: SpeakerID-ChapterID-UtteranceID
            parts = base_filename.split("-")
            speaker_id = parts[0]
            chapter_id = parts[1]

            chapter_key = f"{speaker_id}-{chapter_id}"

            if chapter_key not in transcriptions:
                # Construct path to original .trans.txt
                # Standard path: libri_root/speaker/chapter/speaker-chapter.trans.txt
                trans_path = os.path.join(args.libri_root, speaker_id, chapter_id, f"{chapter_key}.trans.txt")

                if not os.path.exists(trans_path):
                    print(f"Warning: Transcription not found at {trans_path}")
                    continue

                texts = {}
                with open(trans_path, "r") as trans_f:
                    for tline in trans_f:
                        items = tline.strip().split()
                        texts[items[0]] = " ".join(items[1:])
                transcriptions[chapter_key] = texts

            if base_filename in transcriptions[chapter_key]:
                transcript = transcriptions[chapter_key][base_filename]

                # Write .wrd file
                print(transcript, file=wrd_out)

                # Write .ltr file (characters separated by space, | for space)
                ltr_str = " ".join(list(transcript.replace(" ", "|"))) + " |"
                print(ltr_str, file=ltr_out)
            else:
                print(f"Warning: ID {base_filename} not found in {chapter_key}.trans.txt")

if __name__ == "__main__":
    main()
