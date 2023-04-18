# \`purge-backups-scheduler\` script

The `purge-backups-scheduler` script is a Bash script that automates the process of purging old backups based on a set of retention periods. 
The script is intended to be called daily from crontab and reads configuration files ending in `.cfg` from a specified directory, extracts the backup path, backup prefix, and retention periods from each file, and then calls the `purge-backups` command with the extracted parameters.

## Usage

To use the `purge-backups-scheduler` script, you'll need to do the following:

1. Set the configuration directory:

   By default, the script reads configuration files from the `/etc/purge-backups` directory. 
   You can specify a different configuration directory using the `-c` or `--config-dir` option.

   ```bash
   purge-backups-scheduler --config-dir /path/to/your/config/dir

2. Schedule the script:

   The purge-backups-scheduler script is intended to be called daily from crontab. 
   To schedule the script to run every day at 2am, add the following line to your crontab:

       0 2 * * * /path/to/purge-backups-scheduler

   Make sure to replace `/path/to/purge-backups-scheduler` with the path to the script.

3. Customize the configuration files:

   The script reads configuration files ending in .cfg from the specified configuration directory. 
   You can create new configuration files or modify existing ones to specify the backup path, backup prefix, and retention periods.

   Here's an example configuration file:

   ```bash
   #!/bin/bash

   # Path to backup destination
   BACKUP_PATH="/backup/my_system"
    
   # The backup prefix
   BACKUP_PREFIX="my_system"
    
   # Daily backups retention
   DAILY=7d
    
   # Weekly backups retention
   WEEKLY=4w
    
   # Monthly backups retention
   MONTHLY=12m
    
   # Yearly backups retention
   YEARLY=3y
   ```
   You can create new configuration files in the specified configuration directory by creating new files with a `.cfg` extension:

## Options

The `purge-backups-scheduler` script supports the following options:

| Option                     | Description                                                     |
|----------------------------|-----------------------------------------------------------------|
| `-h, --help`               | Print a help message and exit                                   |
| `-c DIR, --config-dir DIR` | Set the configuration directory (default: `/etc/purge-backups`) |
| `-d, --dry-run`            | Print what the script would do without actually doing it        |
