# Backup retention policy script

purge_backups.sh is a Bash script for deleting old backups based on a retention policy.

## Usage

    ./purge_backups.sh [-d <days>] [-w <weeks>] [-m <months>] [-y <years>] -p <path>
    
### Options

| Option                        | Description | Default Value |
|-------------------------------| ----------- |------|
| -d, --daily &lt;DAILY&gt;     | Retention period for daily backups in days. | 7d   |
| -w, --weekly &lt;WEEKLY&gt;   | Retention period for weekly backups in weeks. | 4w   |
| -m, --monthly &lt;MONTHLY&gt; | Retention period for monthly backups in months. | 12m  |
| -y, --yearly &lt;YEARLY&gt;   | Retention period for yearly backups in years. | 2y   |
| -p, --path &lt;PATH&gt;       | The path to the directory containing the backup directories. |      |
| --dry-run                     | Show which backups would be deleted without actually deleting them. |      |
| -h, --help                    | Show help message. |      |

Note that when specifying the retention period using the -d, -w, -m, or -y options, you must include a unit of time (d for days, w for weeks, m for months, or y for years). 
If no unit is specified, the script will default to days.

### Retention Policy

The retention policy is to keep daily backups for a specified number of days, weekly backups for a specified number of weeks, monthly backups for a specified number of months, and yearly backups for a specified number of years. 
The retention periods are set using the options described above.

### Requirements

Backup directory name format is important for efficient management and organization of backup files. 
In some cases, backup directories need to be pruned based on their name. 
Therefore, it is essential to follow a specific naming convention to ensure that the backup files are correctly identified and retained. 
The following is a backup directory name format that can be used for various backup types:

    <prefix>_<date>_<time>_<suffix>

- prefix: the name of the backed up entity (e.g., database name).
- date: the date when the backup was taken in the format yyyy-MM-dd.
- time: the time when the backup was taken in the format hhmmss.
- suffix: the retention type, either daily, weekly, monthly, or yearly.
  - Daily backups: suffix is 'daily'.
  - Weekly backups: suffix is 'weekly'.
  - Monthly backups: suffix is 'monthly'.
  - Yearly backups: suffix is 'yearly'.


### Examples
Retention policy: keep daily backups for 30 days

    ./purge_backups.sh -p /backups/mybackup -d 30d

Retention policy: keep monthly backups for 6 months and weekly backups for 4 weeks, and daily backups for 3 days

    ./purge_backups.sh -p /backups/mybackup -m 6M -w 4W -d 3D

Perform a dry run to print the directories that would be deleted without actually deleting them

    ./purge_backups.sh -p /backups/mybackup --dry-run

    
## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
