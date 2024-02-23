#!/usr/bin/env python3

import pathlib
import time
import subprocess
import argparse
import getpass

DIRS = [
    "/home/$USER/Projects",
    "/home/$USER/Uni",
    "/home/$USER/Private",
    "/home/$USER/Zotero",
    "/home/$USER/Obsidian",
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

    for dir in DIRS:
        dir = pathlib.Path(dir.replace("$USER", getpass.getuser()))
        if not dir.exists():
            raise ValueError(f"Directory {dir} does not exist, skipping.")



