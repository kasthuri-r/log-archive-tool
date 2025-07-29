#!/bin/bash

log_directory=$1
archive_directory=$2
days_old=$3
retention_days=45 # Number of days to keep old .tar.gz archives
tmp_file="/tmp/log_archive_files.txt"

# validate argument
if [ $# -ne 3 ];then
	echo "Usage: $0 <log-directory> <archive-directory> <days-old>"
	exit 1
fi

# checks whether source directory exits
if [ ! -d "$log_directory" ];then
       echo "Error: Log directory $Source_directory does not exist."
       exit 1
fi

# create archive directory if it doesn't exist
mkdir -p "$archive_directory"

# Archive name with timestamp
time=$(date +"%y-%m-%d_%H:%M:%S")
#echo "$time"
archive_name="logs_archive_${time}.tar.gz"
echo "Archive file name: $archive_name"
archive_path="${archive_directory}/${archive_name}"
echo "Archive file path: $archive_path"

# Find & Archive old logs
echo "Archiving .log files older than $days_old days from $log_directory"
find $log_directory -type f -name "*.log" -mtime +$days_old > "$tmp_file"

if [ -s  "$tmp_file" ];then  # -s -->checks file is non-empty, list
	tar -czf "$archive_path" -T "$tmp_file" 
	echo "Archive created: $archive_path"
	echo "[$(date +'%y-%m-%s %H:%M:%S')] Archived logs to $archive_path" >> "$archive_directory/archive_log.txt"
else
    echo "No .log files older than $days_old days found."
    rm -f "$tmp_file"
    exit 0    
fi

# ===== Ask Before Deleting Original .log Files =====
echo "Do you want to delete the original .log files after archiving? (y/n)"
read -r confirm_delete_logs
if [[ "$confirm_delete_logs" == "y" || "$confirm_delete_logs" == "Y" ]]; then
  echo "Deleting archived log files..."
  while IFS= read -r file; do
    echo "Delete $file? (y/n)"
    read -r confirm < /dev/tty # waits for user input from terminal
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
      rm -v "$file"
    else
      echo "Skipped: $file"
    fi
  done < /tmp/log_archive_files.txt
else
  echo "Skipped deletion of .log files."
fi

# Cleanup Temp File 
rm -f "$tmp_file"

# ===== Cleanup Old Archives =====
echo "Cleaning up archives older than $retention_days days in $archive_directory..."
#For fast and fully automated , ideal for cron jobs use below command. 
#find "$archive_directory" -type f -name "*.tar.gz" -mtime +"$retention_days" -exec rm -f {} \;

find "$archive_directory" -type f -name "*.tar.gz" -mtime +$retention_days | while read -r archive_file; do
  echo "Delete old archive: $archive_file? (y/n)"
  read -r confirm
  if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
    rm -v "$archive_file"
  else
    echo "Skipped: $archive_file"
  fi
done
echo "Done"
