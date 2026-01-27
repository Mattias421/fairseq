#!/usr/bin/env python3 -u
import argparse
import os
import os.path as osp
import tqdm
import soundfile as sf

def get_parser():
    parser = argparse.ArgumentParser(
        description="Scan LibriSpeech TSV for corrupted or unreadable FLAC files"
    )
    parser.add_argument('data', help='location of tsv files')
    parser.add_argument('--split', help='which split to read (e.g. train, valid)', required=True)
    parser.add_argument('--save-dir', help='where to save the corrupt files log', required=True)
    return parser

def main():
    parser = get_parser()
    args = parser.parse_args()

    os.makedirs(args.save_dir, exist_ok=True)
    
    tsv_path = osp.join(args.data, args.split) + ".tsv"
    corrupt_log_path = osp.join(args.save_dir, f"{args.split}_corrupt.txt")
    
    if not osp.exists(tsv_path):
        print(f"Error: {tsv_path} not found.")
        return

    with open(tsv_path, "r") as fp:
        lines = fp.read().splitlines()
        root = lines.pop(0).strip()
        # Handle cases where TSV might have extra tabs or spaces
        files = [osp.join(root, line.split("\t")[0].strip()) for line in lines if len(line) > 0]

    print(f"Checking {len(files)} files from {args.split}...")
    
    corrupt_files = []
    
    with open(corrupt_log_path, "w") as log_f:
        for fname in tqdm.tqdm(files):
            try:
                # We attempt a full read to catch "lost sync" errors that occur mid-file
                wav, sr = sf.read(fname)
                
                # Check for the assertion error you saw earlier
                if sr != 16000:
                    raise ValueError(f"Incorrect sample rate: {sr}")
                
            except Exception as e:
                # Log the path and the specific error (e.g., lost sync, file not found)
                error_msg = f"{fname} | Error: {str(e)}"
                print(f"\n[CORRUPT] {error_msg}")
                log_f.write(error_msg + "\n")
                log_f.flush() # Ensure it writes immediately in case of a crash
                corrupt_files.append(fname)

    print(f"\n--- Scan Complete ---")
    print(f"Total files checked: {len(files)}")
    print(f"Total corrupt files: {len(corrupt_files)}")
    print(f"List of corrupted files saved to: {corrupt_log_path}")

if __name__ == "__main__":
    main()
