#!/bin/bash

DAYS=0
PRINT=0
REMOVE=0

# help
function show_help {
    echo "Usage:  clean.sh <options>"
    echo "" 
    echo "Parameters:"
    echo "      -d (--days)  consider just files older then given number of days"
    echo "      -p (--path) target directory path"
    echo "      -v (--verbose)  print files matching criteria"
    echo "      -r (--remove) remove files and empty directories"
    echo "" 
    echo "Examples:"    
    echo "clean.sh -r -d 30 -p <path>    - remove all files and empty directories older then 30 days "
    echo "clean.sh -v -r -d 30 -p <path> - prints and remove all files older then 30 days and 20 hours in given path"
    echo "" 
    echo "For safety reason is allowed to remove only files which were modified  more then 2 days since now"
}

# read parameters
while [[ $# -gt 0 ]]
do

    key="${1}"
    case ${key} in

    -v|--verbose)
        PRINT=1;
        ;;
    -r|--remove)
        REMOVE=1;
        ;;      
    -d|--days)
        DAYS="$(($2+0))"
        ;;
    -p|--path)
        MEDIA_MOUNT_PATH="${2}"
        ;;
    -h|--help)
        show_help
        exit 0;
        ;;
    esac
    shift

done

# validation
if [ $PRINT -eq 0 -a $REMOVE -eq 0 ]; then
    echo "No action selected"
    exit 1
fi  

# for safety reasons only allow to delete files older then 2 days
if [ $DAYS -lt 3 ]; then 
    echo "Only files older then 2 days can be removed"
    exit 1
fi

if [ -z "$MEDIA_MOUNT_PATH" ]; then
    echo "No directory specified. Use -p <path>"
    exit 1
fi  

if [ ! -d "$MEDIA_MOUNT_PATH" ]; then
    echo "Directory '$MEDIA_MOUNT_PATH' does not exist"
    exit 1
fi  

# actions
echo "Files in $MEDIA_MOUNT_PATH older then $DAYS days"
echo "------------------------------------------------"
echo "Before:  $(du -sh $MEDIA_MOUNT_PATH | awk '{print $1}')"
echo "------------------------------------------------"

# prints files matching criteria
if [ $PRINT -eq 1 ]; then
  find $MEDIA_MOUNT_PATH -type f -mtime +$((DAYS)) -exec stat  -c "File %n Size [ %s ] bytes" {} \;
fi

# remove files and empty directories matching criteria
# note -empty can not be used on alpine, 3.9 that the reason why is used
# -exec rmdir {} + 2>/dev/null
if [ $REMOVE -eq 1 ]; then
  find $MEDIA_MOUNT_PATH -type f -mtime +$((DAYS)) -exec rm {} \;
  find $MEDIA_MOUNT_PATH -depth -type d -exec rmdir {} + 2>/dev/null
fi

echo "------------------------------------------------"
echo "After:  $(du -sh $MEDIA_MOUNT_PATH | awk '{print $1}')"
echo "------------------------------------------------"
echo "Done"