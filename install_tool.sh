curl -sO https://packages.wazuh.com/4.4/wazuh-install.sh && sudo bash ./wazuh-install.sh -a |tee wazuh-install-log-creds.txt
grep -Eo 'User:[[:space:]]*[^[:space:]]+|Password:[[:space:]]*[^[:space:]]+' wazuh-install-log-creds.txt >> wazuh_credentials.txt
