# Backup retention policy script

backup-delete.sh is a Bash script for deleting old backups based on a retention policy.

## Usage

    ./backup-delete.sh [-d <days>] [-w <weeks>] [-m <months>] [-y <years>] -p <path>
    
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

Note that when specifying the retention period using the -d, -w, -m, or -y options, you must include a unit of time (d for days, w for weeks, m for months, or y for years). If no unit is specified, the script will default to days.

### Retention Policy

The retention policy is to keep daily backups for a specified number of days, weekly backups for a specified number of weeks, monthly backups for a specified number of months, and yearly backups for a specified number of years. The retention periods are set using the options described above.

### Examples

Clean backups older than the retention period:

    ./backup-delete.sh -d 7 -w 4 -m 12 -y 2 -p /path/to/backup/directory
    
## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
