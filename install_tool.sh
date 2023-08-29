# curl -sO https://packages.wazuh.com/4.4/wazuh-install.sh && sudo bash ./wazuh-install.sh -a |tee wazuh-install-log-creds.txt
# grep -Eo 'User:[[:space:]]*[^[:space:]]+|Password:[[:space:]]*[^[:space:]]+' wazuh-install-log-creds.txt >> wazuh_credentials.txt
apt-get install apt-transport-https zip unzip lsb-release curl gnupg -y
echo "deb [signed-by=/usr/share/keyrings/elasticsearch.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-7.x.list
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch.gpg
apt-get update
apt-get install elasticsearch=7.17.11
curl -so /usr/share/elasticsearch/instances.yml https://packages.wazuh.com/4.5/tpl/elastic-basic/instances_aio.yml
curl -so /etc/elasticsearch/elasticsearch.yml https://packages.wazuh.com/4.5/tpl/elastic-basic/elasticsearch_all_in_one.yml
/usr/share/elasticsearch/bin/elasticsearch-certutil cert ca --pem --in instances.yml --keep-ca-key --out ~/certs.zip
unzip ~/certs.zip -d ~/certs
mkdir /etc/elasticsearch/certs/ca -p
cp -R ~/certs/ca/ ~/certs/elasticsearch/* /etc/elasticsearch/certs/
chown -R elasticsearch: /etc/elasticsearch/certs
chmod -R 500 /etc/elasticsearch/certs
chmod 400 /etc/elasticsearch/certs/ca/ca.* /etc/elasticsearch/certs/elasticsearch.*
rm -rf ~/certs/ ~/certs.zip
systemctl daemon-reload
systemctl enable elasticsearch
systemctl start elasticsearch
yes | /usr/share/elasticsearch/bin/elasticsearch-setup-passwords auto >> ./elastic-creds.txt

# Wazuh Server Installation from below
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/wazuh.gpg --import && chmod 644 /usr/share/keyrings/wazuh.gpg
echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list
apt-get update
apt-get install wazuh-manager
systemctl daemon-reload
systemctl enable wazuh-manager
systemctl start wazuh-manager
systemctl status wazuh-manager
apt-get install filebeat=7.17.11
curl -so /etc/filebeat/filebeat.yml https://packages.wazuh.com/4.5/tpl/elastic-basic/filebeat_all_in_one.yml
curl -so /etc/filebeat/wazuh-template.json https://raw.githubusercontent.com/wazuh/wazuh/4.5/extensions/elasticsearch/7.x/wazuh-template.json
chmod go+r /etc/filebeat/wazuh-template.json
curl -s https://packages.wazuh.com/4.x/filebeat/wazuh-filebeat-0.2.tar.gz | tar -xvz -C /usr/share/filebeat/module
elastic_pass=$(cat elastic-creds.txt  | grep -i "PASSWORD elastic" | awk '{print $4}')
sed "s/output.elasticsearch.password: <elasticsearch_password>/output.elasticsearch.password: $elastic_pass/g" /etc/filebeat/filebeat.yml >> /etc/filebeat/filebeat.yml.new
mv /etc/filebeat/filebeat.yml /etc/filebeat/filebeat.yml.old
mv /etc/filebeat/filebeat.yml.new /etc/filebeat/filebeat.yml
cp -r /etc/elasticsearch/certs/ca/ /etc/filebeat/certs/
cp /etc/elasticsearch/certs/elasticsearch.crt /etc/filebeat/certs/filebeat.crt
cp /etc/elasticsearch/certs/elasticsearch.key /etc/filebeat/certs/filebeat.key
systemctl daemon-reload
systemctl enable filebeat
systemctl start filebeat
filebeat test output
apt-get install kibana=7.17.11
mkdir /etc/kibana/certs/ca -p
cp -R /etc/elasticsearch/certs/ca/ /etc/kibana/certs/
cp /etc/elasticsearch/certs/elasticsearch.key /etc/kibana/certs/kibana.key
cp /etc/elasticsearch/certs/elasticsearch.crt /etc/kibana/certs/kibana.crt
chown -R kibana:kibana /etc/kibana/
chmod -R 500 /etc/kibana/certs
chmod 440 /etc/kibana/certs/ca/ca.* /etc/kibana/certs/kibana.*
curl -so /etc/kibana/kibana.yml https://packages.wazuh.com/4.5/tpl/elastic-basic/kibana_all_in_one.yml
sed "s/elasticsearch.password: <elasticsearch_password>/elasticsearch.password: $elastic_pass/g" /etc/kibana/kibana.yml >> /etc/kibana/kibana.yml.new
mv /etc/kibana/kibana.yml /etc/kibana/kibana.yml.old
mv /etc/kibana/kibana.yml.new /etc/kibana/kibana.yml
mkdir /usr/share/kibana/data
chown -R kibana:kibana /usr/share/kibana
cd /usr/share/kibana
sudo -u kibana /usr/share/kibana/bin/kibana-plugin install https://packages.wazuh.com/4.x/ui/kibana/wazuh_kibana-4.5.1_7.17.11-1.zip
setcap 'cap_net_bind_service=+ep' /usr/share/kibana/node/bin/node
systemctl daemon-reload
systemctl enable kibana
systemctl start kibana
sed -i "s/^deb/#deb/" /etc/apt/sources.list.d/wazuh.list
sed -i "s/^deb/#deb/" /etc/apt/sources.list.d/elastic-7.x.list
apt-get update
