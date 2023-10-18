#!/usr/bin/env python3

import csv
import glob
import os

# Script that can:
# 1. Produce a csv file with a list of files in the directory
# 2. Rename the files base on new names specified in the csv file.


def getfilenames(extension):
    """
    Writes all names of files of a given type in the directory of the script
    into a csv file

    Parameters
    ----------
    extension : string
        The extension of the filetype of interest.

    Returns
    -------
    filenames.csv with the filenames
    returns error message if operation failed

    """
    abspath = os.path.abspath(__file__)  # file path
    dname = os.path.dirname(abspath)  # directory path (without file)
    os.chdir(dname)  # set directory path to wd
    name = "filenames.csv"  # name of output file

    ext = ("*") + extension
    globlet = glob.glob(ext)  # specify extension

    with open(name, "w", newline="") as file:
        w = csv.writer(file)  # create csv
        verify = True
        for k in range(len(globlet)):  # write rows
            try:
                w.writerow([globlet[k]])
            except:
                print(
                    "ERROR: Filename " + [globlet[k]] + " could not be written to csv"
                )
                verify = False
        if verify == True:
            print("filenames.csv succesfully created")
        else:
            print("Check filenames.csv for completeness")


def renamefiles(extension):
    """
    Renames all files of a given type in the directory of the script
    accroding to the new names specified in the csv file

    Parameters
    ----------
    extension : string
        The extension of the filetype of interest.

    Returns
    -------
    returns error message if operation failed

    """
    abspath = os.path.abspath(__file__)  # file path
    dname = os.path.dirname(abspath)  # directory path (without file)
    os.chdir(dname)  # set directory path to wd

    IDs = {}

    with open("filenames.csv") as csvfile:
        namereader = csv.reader(csvfile, delimiter=",")
        for row in namereader:
            IDs[row[0]] = row[1] + extension

    path = os.getcwd()
    ext = ("*") + extension
    for filename in glob.glob(ext):
        if filename in IDs:
            newname = IDs[filename]
            if (newname.replace(extension, "")) == (""):
                print(
                    "ERROR 2: newnames.csv contains "
                    + filename
                    + " but no new name is specified"
                )
                os.rename(os.path.join(path, filename), os.path.join(path, filename))
            else:
                try:
                    os.rename(
                        os.path.join(path, filename), os.path.join(path, IDs[filename])
                    )
                    print(filename + "renamed successfully")
                except:
                    print(
                        "ERROR 3: File "
                        + filename
                        + " could not be renamed to "
                        + IDs[filename]
                    )
        if filename not in IDs:
            print("ERROR 1: newnames.csv does not contain " + filename)


def interface():
    var = input("Create a file list [l], rename files [r] or exit [q]? ")
    return var


def main():
    var = interface()
    if var not in "qlr":
        print("Invalid input, try again!")
        var = interface()
    elif var in "q":
        quit()
    elif var in "lr":
        extension = input("Provide a filetype (.md, .sh, .jpg, etc.) ")
        if var in "l":
            getfilenames(extension)
            print("Write new filenames next to the old ones without extensions.")
        elif var in "r":
            renamefiles(extension)


if __name__ == "__main__":
    main()
