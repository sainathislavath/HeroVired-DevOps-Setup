#!/bin/bash

echo "Web Server Backup Configuration..."

# Step 1: Create /backups directory
echo "Creating /backups directory..."
sudo mkdir -p /backups
sudo chmod 775 /backups
sudo chown root:root /backups
echo "/backups directory is ready."

# Step 2: Create Apache backup script for Sarah
echo "Creating Apache backup script for Sarah..."

sudo tee /home/sarah/apache_backup.sh > /dev/null << 'EOF'
#!/bin/bash

DATE=$(date +%F)
BACKUP_FILE="/backups/apache_backup_$DATE.tar.gz"
LOG_FILE="/backups/apache_verify_$DATE.log"

sudo tar -czf "$BACKUP_FILE" /etc/apache2 /var/www/html
sudo bash -c "tar -tzf '$BACKUP_FILE' > '$LOG_FILE'"

echo "Apache backup complete: $BACKUP_FILE"
EOF

sudo chmod +x /home/sarah/apache_backup.sh
sudo chown sarah:sarah /home/sarah/apache_backup.sh
echo "Script created: /home/sarah/apache_backup.sh"

# Step 3: Create Nginx backup script for Mike
echo "Creating Nginx backup script for Mike..."

sudo tee /home/mike/nginx_backup.sh > /dev/null << 'EOF'
#!/bin/bash

DATE=$(date +%F)
BACKUP_FILE="/backups/nginx_backup_$DATE.tar.gz"
LOG_FILE="/backups/nginx_verify_$DATE.log"

sudo tar -czf "$BACKUP_FILE" /etc/nginx /usr/share/nginx/html
sudo bash -c "tar -tzf '$BACKUP_FILE' > '$LOG_FILE'"

echo "Nginx backup complete: $BACKUP_FILE"
EOF

sudo chmod +x /home/mike/nginx_backup.sh
sudo chown mike:mike /home/mike/nginx_backup.sh
echo "Script created: /home/mike/nginx_backup.sh"

# Step 4: Schedule Cron Jobs
echo "Scheduling cron jobs..."

# Sarah's Cron
sudo bash -c "sudo crontab -u sarah -l 2>/dev/null | grep -v 'apache_backup.sh' > /tmp/sarah_cron"
echo "0 0 * * 2 /home/sarah/apache_backup.sh" | sudo tee -a /tmp/sarah_cron > /dev/null
sudo crontab -u sarah /tmp/sarah_cron
sudo rm -f /tmp/sarah_cron
echo "Cron job set for Sarah"

# Mike's Cron
sudo bash -c "sudo crontab -u mike -l 2>/dev/null | grep -v 'nginx_backup.sh' > /tmp/mike_cron"
echo "0 0 * * 2 /home/mike/nginx_backup.sh" | sudo tee -a /tmp/mike_cron > /dev/null
sudo crontab -u mike /tmp/mike_cron
sudo rm -f /tmp/mike_cron
echo "Cron job set for Mike"

# Step 5: Add sudoers rules via /etc/sudoers.d/
echo "Granting sudo permission for /bin/tar and /usr/bin/bash..."

# For Sarah
echo "sarah ALL=(ALL) NOPASSWD: /bin/tar, /usr/bin/bash" | sudo tee /etc/sudoers.d/sarah-tar > /dev/null
sudo chmod 440 /etc/sudoers.d/sarah-tar
echo "Sudoers rule added for sarah."

# For Mike
echo "mike ALL=(ALL) NOPASSWD: /bin/tar, /usr/bin/bash" | sudo tee /etc/sudoers.d/mike-tar > /dev/null
sudo chmod 440 /etc/sudoers.d/mike-tar
echo "Sudoers rule added for mike."

# Step 6: Manual test
echo -e "\n Running backup scripts manually..."

echo "Testing Sarah's backup script:"
sudo -u sarah /home/sarah/apache_backup.sh

echo "Testing Mike's backup script:"
sudo -u mike /home/mike/nginx_backup.sh

echo -e "\n Verifying contents of /backups:"
ls -lh /backups | grep backup

echo -e "\n Setup completed successfully and securely!"
