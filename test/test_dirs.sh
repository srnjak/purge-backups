#!/bin/bash

if [ $# -lt 4 ] || [ $# -gt 5 ]; then
  echo "Usage: $0 <daily iterations> <weekly iterations> <monthly iterations> <yearly iterations> [backup path]"
  exit 1
fi

dailyIter=$1
weeklyIter=$2
monthlyIter=$3
yearlyIter=$4
backupPath=${5:-"/tmp/backups-test"}  # Use /tmp/backups-test as the default backup path if one is not provided

# Create daily backups
for (( i=1; i<=$dailyIter; i++ ))
do
  backupDate=$(date -d "-$i days" "+%Y-%m-%d_%H%M%S")
  dirName="testbackup_${backupDate}_daily"
  mkdir -p "${backupPath}/${dirName}"
done

# Create weekly backups
for (( i=1; i<=$weeklyIter; i++ ))
do
  backupDate=$(date -d "-$(( i * 7 )) days" "+%Y-%m-%d_%H%M%S")
  dirName="testbackup_${backupDate}_weekly"
  mkdir -p "${backupPath}/${dirName}"
done

# Create monthly backups
for (( i=1; i<=$monthlyIter; i++ ))
do
  backupDate=$(date -d "-$i months" "+%Y-%m-%d_%H%M%S")
  dirName="testbackup_${backupDate}_monthly"
  mkdir -p "${backupPath}/${dirName}"
done

# Create yearly backups
for (( i=1; i<=$yearlyIter; i++ ))
do
  backupDate=$(date -d "-$i years" "+%Y-%m-%d_%H%M%S")
  dirName="testbackup_${backupDate}_yearly"
  mkdir -p "${backupPath}/${dirName}"
done
