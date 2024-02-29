#!/usr/bin/env python3

import pathlib
import subprocess
import argparse
import os


SUBDIRS = [
    "Projects",
    "Uni",
    "Private",
    "Zotero",
    "Obsidian",
    "Website",
]


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--input", 
        "-i",
        help="Input directory",
        type=pathlib.Path,
    )
    parser.add_argument(
        "--output",
        "-o",
        help="Output directory",
        type=pathlib.Path,
    )
    return parser.parse_args()


def main():
    args = parse_args()
    input_dir = args.input
    output_dir = args.output

    if not input_dir.exists():
        raise ValueError(f"Input directory {input_dir} does not exist.")
    if not output_dir.exists():
        raise ValueError(f"Output directory {output_dir} does not exist.")

    input(f"Backing up {input_dir} to {output_dir}. Press Enter to continue...")
    input(f"Syncing these subdirectories: {SUBDIRS}. Press Enter to continue...")

    for dir in SUBDIRS:
        ip = f"{input_dir / dir}{os.sep}"
        op = f"{output_dir / dir}{os.sep}"
        
        print(f"Backing up {ip} to {op}...")

        if not pathlib.Path(ip).exists():
            raise ValueError(f"Directory {dir} does not exist, skipping.")
        if not pathlib.Path(op).exists():
            pathlib.Path(op).mkdir(parents=True, exist_ok=True)

        subprocess.run(["rsync", "-avz", "--delete", ip, op])

    print("Backup complete.")


if __name__ == "__main__":
    main()
