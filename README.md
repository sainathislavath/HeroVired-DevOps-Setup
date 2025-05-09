# HeroVired-DevOps-Setup

# Task 1: System Monitoring Setup

---

## Objective

Configure a monitoring system to track **CPU**, **memory**, **disk usage**, and **processes**. 
Ensure logs are saved for capacity planning and performance monitoring.

---

## Tools Used

- **htop**: Real-time process viewer.
- **df**: Disk space usage.
- **du**: Directory-level space usage.
- **ps/top**: Resource-intensive process tracking.
- **Bash script**: For automation and logging.

---

## Log File Structure

```
/system_log/
├── system_monitor_YYYY-MM-DD.log
├── disk_usage_YYYY-MM-DD.log
├── home_dir_usage_YYYY-MM-DD.log
├── top_mem_processes_YYYY-MM-DD.log
└── top_cpu_processes_YYYY-MM-DD.log

```

## Output

Run the script with: `./monitor.sh`

You’ll see log files generated under /system_log/ relative to the script.
Use ls to view them and cat <filename> to verify the content.

---

![System Monitoring](./Task1/images/1.png)


![Disk Usage](./Task1/images/2.png)


![Directory Usage](./Task1/images/3.png)


![Top Memory](./Task1/images/4.png)


![Top CPU](./Task1/images/5.png)


![Log Files](./Task1/images/6.png)

---

# Task 2: User Management and Access Control

---

## Objective

Set up secure and isolated user environments for new developers **Sarah** and **Mike**.  
Ensure proper user creation, directory access control, password expiration, and complexity policies as per organizational security standards.

---

## Users and Workspaces

| Username | Workspace Directory         |
|----------|-----------------------------|
| sarah    | `/home/sarah/workspace`     |
| mike     | `/home/mike/workspace`      |

---

## Tasks Completed via Bash Script

### 1. Created users `sarah` and `mike` with default strong passwords

```bash
sudo adduser sarah
sudo adduser mike
```

### 2. Created private workspaces

``` bash
sudo mkdir -p /home/sarah/workspace
sudo mkdir -p /home/mike/workspace
```

### 3. Applied strict ownership and permissions

```bash
sudo chown sarah:sarah /home/sarah/workspace
sudo chmod 700 /home/sarah/workspace

sudo chown mike:mike /home/mike/workspace
sudo chmod 700 /home/mike/workspace
```
`chmod 700` ensures only the user can access their workspace.

### 4. Enforced password expiration policy

Modified `/etc/login.defs`:
```bash
PASS_MAX_DAYS   30
PASS_MIN_DAYS   0
PASS_WARN_AGE   7
```

### 5. Enforced password complexity policy

Installed and configured `libpam-pwquality`:
```bash
sudo apt install libpam-pwquality
```

Edited `/etc/pam.d/common-password` to include:
```bash
password requisite pam_pwquality.so retry=3 minlen=8 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1
```

This enforces:

   - Minimum 8 characters
   - At least 1 uppercase, 1 lowercase, 1 digit, and 1 special character
   
### 6. Set account inactivity lock (35 days)

```bash
sudo usermod --inactive 35 sarah
sudo usermod --inactive 35 mike
```

---

## Output

### Workspace Permissions Verified:
```bash
sudo ls -ld /home/sarah/workspace
sudo ls -ld /home/mike/workspace
```

Expected output:

```bash
drwx------ 2 sarah sarah 4096 May 8 10:15 /home/sarah/workspace
drwx------ 2 mike  mike  4096 May 8 10:15 /home/mike/workspace
```

---

![User Creation](./Task2/images/1.png)


![Secured workspace](./Task2/images/2.png)


![Password Complexity](./Task2/images/3.png)


![Successful completion](./Task2/images/4.png)

---

# Task 3: Backup Configuration for Web Servers

---

## Objective

Automate backup procedures for two web servers:

- **Sarah's Apache server**
- **Mike's Nginx server**

The backups should:

- Include server configurations and document root
- Be saved in `/backups/` directory
- Run automatically **every Tuesday at 12:00 AM**
- Include **compressed backup files** and **verification logs**

---

## Backup Targets

| User   | Configuration Path         | Document Root              |
|--------|----------------------------|----------------------------|
| Sarah  | `/etc/apache2/`            | `/var/www/html/`           |
| Mike   | `/etc/nginx/`              | `/usr/share/nginx/html/`   |

---

## Backup Output

- Backup files:
```bash
/backups/apache_backup_YYYY-MM-DD.tar.gz
/backups/nginx_backup_YYYY-MM-DD.tar.gz
```

- Verification logs:
```bash
/backups/apache_verify_YYYY-MM-DD.log
/backups/nginx_verify_YYYY-MM-DD.log
```

---

## Steps Performed by Script

### 1. Created `/backups/` directory with proper permissions:
```bash
sudo mkdir -p /backups
sudo chmod 775 /backups
sudo chown root:root /backups
```

### 2. Created Backup Scripts
   - `/home/sarah/apache_backup.sh`
   - `/home/mike/nginx_backup.sh`

Each script performs:
```bash
sudo tar -czf /backups/backup.tar.gz /target/paths
sudo bash -c "tar -tzf /backups/backup.tar.gz > /backups/verify.log"
```

### 3. Scheduled Cron Jobs
Cron entries for each user:
```bash
0 0 * * 2 /home/sarah/apache_backup.sh
0 0 * * 2 /home/mike/nginx_backup.sh
```
These run every Tuesday at 12:00 AM.

### 4. Configured Minimal Sudo Permissions
Created secure sudoers files:
```bash
/etc/sudoers.d/sarah-tar
/etc/sudoers.d/mike-tar
```

With this content:
```bash
sarah ALL=(ALL) NOPASSWD: /bin/tar, /usr/bin/bash
mike  ALL=(ALL) NOPASSWD: /bin/tar, /usr/bin/bash
```

This allows each user to only run `tar` and `bash` (used for redirection) with `sudo`.

---

## Manual Test Output
After running the final script:
```bash
sudo -u sarah /home/sarah/apache_backup.sh
sudo -u mike /home/mike/nginx_backup.sh
```

You should see:
```bash
Apache backup complete: /backups/apache_backup_YYYY-MM-DD.tar.gz
Nginx backup complete: /backups/nginx_backup_YYYY-MM-DD.tar.gz
```

---

![Backup Configuration](./Task3/images/1.png)


![cron job](./Task3/images/2.png)


![Backup Scripts](./Task3/images/3.png)


![Permissions](./Task3/images/4.png)


![Successful completion](./Task3/images/5.png)
