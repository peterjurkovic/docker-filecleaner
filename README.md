# docker-filecleaner
A docker imange containing a script which removes files which removes files based on last modified date. It can be used for cleaning old files on an attached volume. Use case: Kubernetes CronJob executing the script. 



```
Usage:  clean.sh <options>

Parameters:
      -d (--days)  consider just files older then given number of days
      -p (--path) target directory path
      -v (--verbose)  print files matching criteria
      -r (--remove) remove files and empty directories

Examples:
clean.sh -r -d 30 -p <path>    - remove all files and empty directories older then 30 days 
clean.sh -v -r -d 30 -p <path> - prints and remove all files older then 30 days and 20 hours in given path

For safety reason is allowed to remove only files which were modified  more then 2 days since now
```

