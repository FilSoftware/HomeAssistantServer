#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: SSH & Web Terminal
# Configures the SSH daemon
# ==============================================================================
readonly SSH_AUTHORIZED_KEYS_PATH=/etc/ssh/authorized_keys
readonly SSH_CONFIG_PATH=/etc/ssh/sshd_config
readonly SSH_HOST_ED25519_KEY=/data/ssh_host_ed25519_key
readonly SSH_HOST_RSA_KEY=/data/ssh_host_rsa_key
declare password
declare port
declare username

port=$(bashio::addon.port 222)

echo "ok" > /log.txt

# Don't execute this when SSH is disabled
if ! bashio::var.has_value "${port}"; then
    exit 0
fi

# Port
sed -i "s/Port\\ .*/Port\\ ${port}/" "${SSH_CONFIG_PATH}" \
    || bashio::exit.nok 'Failed configuring port'


bashio::log.info "Setting up username..."

username=$(bashio::config 'ssh.username')

# Create user account if the user isn't root
if [[ "${username}" != "root" ]]; then

    # Create an user account
    adduser -D "${username}" -s "/bin/sh" \
        || bashio::exit.nok 'Failed creating the user account'

    # Add new user to the wheel group
    adduser "${username}" wheel \
        || bashio::exit.nok 'Failed adding user to wheel group'

    # Ensure new user switches to root after login
    echo 'exec sudo -i' > "/home/${username}/.profile" \
        || bashio::exit.nok 'Failed configuring user profile'
fi

bashio::log.info "Setting up password..."
# We need to set a password for the user account
if bashio::config.has_value 'ssh.password'; then
    password=$(bashio::config 'ssh.password')
else
    # Use a random password in case none is set
    password=$(pwgen 64 1)
fi

chpasswd <<< "${username}:${password}" 2&> /dev/null


bashio::log.info "Allow specified user to log in..."
# Allow specified user to log in
if [[ "${username}" != "root" ]]; then
    sed -i "s/AllowUsers\\ .*/AllowUsers\\ ${username}/" "${SSH_CONFIG_PATH}" \
        || bashio::exit.nok 'Failed opening SSH for the configured user'
else
    sed -i "s/PermitRootLogin\\ .*/PermitRootLogin\\ yes/" "${SSH_CONFIG_PATH}" \
        || bashio::exit.nok 'Failed opening SSH for the root user'
fi