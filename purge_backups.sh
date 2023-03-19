#!/bin/bash

# Function to convert a retention period to seconds
function convertToSeconds {
  value=$(echo "$1" | sed 's/[[:alpha:]]//g')
  unit=$(echo "$1" | sed 's/[[:digit:]]//g')

  case "$unit" in
    d|D)
      echo "$(( $value * 86400 ))"
      ;;
    w|W)
      echo "$(( $value * 604800 ))"
      ;;
    m|M)
      echo "$(( $value * 2592000 ))"
      ;;
    y|Y)
      echo "$(( $value * 31536000 ))"
      ;;
    *)
      echo "Invalid retention period: $value$unit"
      exit 1
      ;;
  esac
}

# Function that prints the help message
printHelp() {
  cat <<EOF
Usage: $0 [-h] [-p backup-path] [-d daily-retention] [-w weekly-retention] [-m monthly-retention] [-y yearly-retention]

Deletes old backup directories according to the specified retention policies.

Required arguments:
  -p|--backup-path <path>        Parent directory of backup directories to be cleaned.

Optional arguments:
  -d|--daily-retention <num>    Number of days to keep daily backups (default: $dailyRetention day(s)).
  -w|--weekly-retention <num>   Number of weeks to keep weekly backups (default: $weeklyRetention week(s)).
  -m|--monthly-retention <num>  Number of months to keep monthly backups (default: $monthlyRetention month(s)).
  -y|--yearly-retention <num>   Number of years to keep yearly backups (default: $yearlyRetention year(s)).
  --dry-run                     Print the directories that would be deleted without actually deleting them.
  -h|--help                     Show this help message.

Backup directory name format:
  <prefix>_<date>_<time>_<suffix>
  - prefix: the name of the backed up entity (e.g., database name).
  - date: the date when the backup was taken in the format yyyy-MM-dd.
  - time: the time when the backup was taken in the format hhmmss.
  - suffix: the retention type, either daily, weekly, monthly, or yearly.
    - Daily backups: suffix is 'daily'.
    - Weekly backups: suffix is 'weekly'.
    - Monthly backups: suffix is 'monthly'.
    - Yearly backups: suffix is 'yearly'.

Examples:
  # Retention policy: keep daily backups for 30 days
  $0 -p /backups/mybackup -d 30d

  # Retention policy: keep monthly backups for 6 months and weekly backups for 4 weeks, and daily backups for 3 days
  $0 -p /backups/mybackup -m 6M -w 4W -d 3D

  # Perform a dry run to print the directories that would be deleted without actually deleting them
  $0 -p /backups/mybackup --dry-run
EOF
}


# Set default values for script arguments
dailyRetention="7d"
weeklyRetention="4w"
monthlyRetention="12M"
yearlyRetention="2y"

# Parse command line options
while [[ $# -gt 0 ]]; do
  case "$1" in
    -p|--backup-path)
      backupPath="$2"
      shift
      ;;
    -d|--daily-retention)
      dailyRetention="$2"
      shift
      ;;
    -w|--weekly-retention)
      weeklyRetention="$2"
      shift
      ;;
    -m|--monthly-retention)
      monthlyRetention="$2"
      shift
      ;;
    -y|--yearly-retention)
      yearlyRetention="$2"
      shift
      ;;
     --dry-run)
      dryRun=true
      shift
      ;;
    -h|--help)
      printHelp
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      echo "Use -h or --help to see available options."
      exit 1
      ;;
  esac
  shift
done

# Check if backup path is provided
if [ -z "$backupPath" ]; then
  echo "Backup path is required. Please provide a value for the -p or --backup-path option."
  printHelp
  exit 1
fi

# Calculate retention time in seconds
dailyRetentionSeconds=$(convertToSeconds "${dailyRetention%${dailyRetention##*[!0-9]}}" "${dailyRetention##*[0-9]}")
weeklyRetentionSeconds=$(convertToSeconds "${weeklyRetention%${weeklyRetention##*[!0-9]}}" "${weeklyRetention##*[0-9]}")
monthlyRetentionSeconds=$(convertToSeconds "${monthlyRetention%${monthlyRetention##*[!0-9]}}" "${monthlyRetention##*[0-9]}")
yearlyRetentionSeconds=$(convertToSeconds "${yearlyRetention%${yearlyRetention##*[!0-9]}}" "${yearlyRetention##*[0-9]}")

# Iterate over the backup directories
for dir in "${backupPath}"/*; do
  if [[ -d "${dir}" ]]; then
    # Get the backup date from the directory name
    backupDate=$(basename "${dir}" | cut -d'_' -f2)

    # Convert the backup date to Unix timestamp
    backupTimestamp=$(date -d "${backupDate}" +%s)

    # Calculate the age of the backup in seconds
    age=$(($(date +%s) - ${backupTimestamp}))

    # Determine the retention period based on the backup type
    if [[ "${dir}" == *"_daily" ]]; then
      retentionSeconds="${dailyRetentionSeconds}"
    elif [[ "${dir}" == *"_weekly" ]]; then
      retentionSeconds="${weeklyRetentionSeconds}"
    elif [[ "${dir}" == *"_monthly" ]]; then
      retentionSeconds="${monthlyRetentionSeconds}"
    elif [[ "${dir}" == *"_yearly" ]]; then
      retentionSeconds="${yearlyRetentionSeconds}"
    else
      echo "Error: Invalid backup directory format: ${dir}" >&2
      exit 1
    fi

    # If the age of the backup is greater than the retention period, delete it
    if [[ ${age} -gt ${retentionSeconds} ]]; then
      if [[ "$dryRun" = true ]]; then
          echo "Would delete ${dir}"
      else
          rm -rf "${dir}"
          echo "Deleted ${dir}"
      fi
    fi
  fi
done