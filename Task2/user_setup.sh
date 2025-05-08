#!/bin/bash

# Define users
USERS=("sarah" "mike")

echo "Creating users and configuring secure environments..."

# Step 1: Create Users
for USER in "${USERS[@]}"; do
    if id "$USER" &>/dev/null; then
        echo "User $USER already exists."
    else
        sudo adduser --disabled-password --gecos "" "$USER"
        echo "$USER:StrongP@ssw0rd123" | sudo chpasswd
        echo "Created user: $USER"
    fi
done

# Step 2: Create and Secure Workspaces
for USER in "${USERS[@]}"; do
    WORKSPACE="/home/$USER/workspace"
    sudo mkdir -p "$WORKSPACE"
    sudo chown "$USER:$USER" "$WORKSPACE"
    sudo chmod 700 "$WORKSPACE"
    echo "Secured workspace for $USER at $WORKSPACE"
done

# Step 3: Set Password Expiry Policy
echo "Updating /etc/login.defs for password expiry..."
sudo sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   30/' /etc/login.defs
sudo sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS   0/' /etc/login.defs
sudo sed -i 's/^PASS_WARN_AGE.*/PASS_WARN_AGE   7/' /etc/login.defs
echo "Password expiry policy set: 30 days max, 7 days warning"

# Step 4: Install and Configure Password Complexity Module
echo "Installing and configuring password complexity..."
sudo apt update
sudo apt install libpam-pwquality -y

# Ensure pam_pwquality is configured
if grep -q "pam_pwquality.so" /etc/pam.d/common-password; then
    sudo sed -i 's/^password.*pam_pwquality\.so.*/password requisite pam_pwquality.so retry=3 minlen=8 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1/' /etc/pam.d/common-password
else
    echo "password requisite pam_pwquality.so retry=3 minlen=8 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1" | sudo tee -a /etc/pam.d/common-password
fi
echo "Password complexity enforced."

# Step 5: Optional - Inactivity lock after 35 days
for USER in "${USERS[@]}"; do
    sudo usermod --inactive 35 "$USER"
done

echo "User inactivity lock set to 35 days."

# Final Verification
echo -e "\n Task 2 completed successfully. Summary:"
for USER in "${USERS[@]}"; do
    sudo ls -ld "/home/$USER/workspace"
done
