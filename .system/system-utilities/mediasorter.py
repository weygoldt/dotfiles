# !/usr/bin/python

import argparse
import datetime
import os
import shutil

import exifread
from PIL import Image
from PIL.ExifTags import TAGS
from PIL.Image import Exif


def get_exif(file_name) -> Exif:
    image: Image.Image = Image.open(file_name)
    return image.getexif()


def get_exif_ifd(exif):
    for key, value in TAGS.items():
        if value == "ExifOffset":
            break
    info = exif.get_ifd(key)
    return {TAGS.get(key, key): value for key, value in info.items()}


def datemove(file, sink):
    """
    Moves a file (/path/to/file.txt) into a subdirectory named by file creation date into the sink directory.
    """

    filename = os.path.basename(file)

    # get file creation date
    with open(file, "rb") as file:
        exif = exifread.process_file(file)
        if "DateTimeOriginal" in exif:
            dt = str(exif["EXIF DateTimeOriginal"])
            # into date and time
            print(dt)

    # timestamp = os.path.getmtime(file)
    # datestamp = datetime.datetime.fromtimestamp(DTO)

    return None

    # # make dir in sink and move if not exists
    # if os.path.exists(f"{sink}/{datestamp.date()}"):
    #     shutil.move(file, f"{sink}/{datestamp.date()}/{filename}")
    # else:
    #     os.makedirs(f"{sink}/{datestamp.date()}")
    #     shutil.move(file, f"{sink}/{datestamp.date()}/{filename}")


def main():

    # lists to split by file type
    video_extensions = [
        "mp4",
        "m4v",
        "mov",
        "gif",
        "avi",
        "flv",
        "mkv",
        "wmv",
        "webm",
        "MP4",
        "M4V",
        "MOV",
        "GIF",
        "AVI",
        "FLV",
        "MKV",
        "WMV",
        "WEBM",
    ]
    audio_extensions = [
        "mp3",
        "wav",
        "opus",
        "m4a",
        "aiff",
        "aac",
        "ogg",
        "wma",
        "MP3",
        "WAV",
        "OPUS",
        "M4A",
        "AIFF",
        "AAC",
        "OGG",
        "WMA",
    ]
    image_extensions = [
        "jpeg",
        "jpg",
        "png",
        "tiff",
        "tif",
        "psd",
        "eps",
        "ai",
        "indd",
        "raw",
        "dng",
        "cr2",
        "orf",
        "arw",
        "xmp",
        "JPEG",
        "JPG",
        "PNG",
        "TIFF",
        "TIF",
        "PSD",
        "EPS",
        "AI",
        "INDD",
        "RAW",
        "DNG",
        "CR2",
        "ORF",
        "ARW",
        "XMP",
    ]

    # media type subfolder names
    vidname = "video"
    audname = "audio"
    imgname = "image"

    # control parameter
    skipvar = False  # turns true if files are skipped

    # get terminal arguments
    parser = argparse.ArgumentParser()
    parser.add_argument("--source", help="paste path to media source dir.")
    parser.add_argument("--sink", help="paste path to media sink dir.")
    args = parser.parse_args()

    # convert relative to abspath
    source = os.path.abspath(args.source)
    sink = os.path.abspath(args.sink)

    # change dir to source
    os.chdir(source)

    # some terminal feedback
    print(f"Sorting files from {source} to {sink}")

    # list files in source
    file_list = []
    for root, dirs, files in os.walk(".", topdown=False):
        for name in files:
            file_list.append(os.path.join(root, name))

    # iterate over files
    for file in file_list:

        # sort by extension
        _, extension = os.path.splitext(file)
        extension = extension[1:]

        if extension in video_extensions:
            dirname = vidname
            if os.path.exists(f"{sink}/{dirname}"):
                datemove(file, f"{sink}/{dirname}")
            else:
                os.makedirs(f"{sink}/{dirname}")
                datemove(file, f"{sink}/{dirname}")

        elif extension in audio_extensions:
            dirname = audname
            if os.path.exists(f"{sink}/{dirname}"):
                datemove(file, f"{sink}/{dirname}")
            else:
                os.makedirs(f"{sink}/{dirname}")
                datemove(file, f"{sink}/{dirname}")

        elif extension in image_extensions:
            dirname = imgname
            if os.path.exists(f"{sink}/{dirname}"):
                datemove(file, f"{sink}/{dirname}")
            else:
                os.makedirs(f"{sink}/{dirname}")
                datemove(file, f"{sink}/{dirname}")

        else:
            skipvar = True

    if skipvar:
        print("Some files where skipped!")
    else:
        print("All files transferred successfully!")


if __name__ == "__main__":
    main()
