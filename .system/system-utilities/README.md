# Toolbox
... a collection of simple utilities to do simple things.

## mediasorter
recursively moves all media files (images, videos, audio) in a source directory to a sink directory containing subdirectories for the media type, which in turn contain subdirectories for the day of creation of each file. Particularly useful for importing images and videos from cameras or smartphones.

```{sh}
python mediasorter.py --source /path/to/files --sink /path/to/put/files
```

## renamer
can create a csv containing the names of all files in the directory. To rename the files, put new names into the csv into the newname column next to the oldname. Then run the script again and select the option to rename from the csv.