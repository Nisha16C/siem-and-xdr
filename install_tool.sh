touch /ankit.txt
curl -sO https://packages.wazuh.com/4.4/wazuh-install.sh && sudo bash ./wazuh-install.sh -a |tee wazuh-install-log-creds.txt
grep -E "User:|Password:" wazuh-install-log-creds.txt >> wazuh_credentials.txt
