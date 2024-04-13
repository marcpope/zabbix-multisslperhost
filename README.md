# zabbix-multisslperhost
Monitor Multiple SSL Certificates Per Host with Zabbix (Tested with Zabbix 6.4)

If you run a webserver with multiple websites with SSL, the default SSL monitor doesn't really let you monitor SSL expiration of more than one site per host. I was frustrated with solutions I was finding online so I made my own simpler solution. This has been designed with the zabbix-agent2.

First on your agent machine, put ssl.sh in /var/lib/zabbix This will scan your /etc/httpd/conf.d/ directory and look for <ServerName xyz.com:443> websites and return a list. You may need to modify the location to suit your environment.
```
curl -Os https://raw.githubusercontent.com/marcpope/zabbix-multisslperhost/main/ssl.sh > /var/lib/zabbix/ssl.sh
chmod +x /var/lib/zabbix/ssl.sh
```
Now, verify this is returning the sites you expect, if not, make sure your Apache configs are in the location where the script is looking or modify the ssl.sh script to your environment. 
```
cd /var/lib/zabbix/ ; ./ssl.sh
```
Import the ssl.discovery script into your zabbix agent2 conf.d directory:
```
curl -Os https://github.com/marcpope/zabbix-multisslperhost/blob/main/ssl.conf > /etc/zabbix/zabbix_agent2.d/ssl.conf
```
Restart your Zabbix Agent2:
```
systemctl restart zabbix-agent2
```

Now, download the template and import it into your Zabbix Server under "Data Collection > Templates".
https://github.com/marcpope/zabbix-multisslperhost/blob/main/zbx_ssl_template.yaml

Modify your host to include the SSL Custom Template

