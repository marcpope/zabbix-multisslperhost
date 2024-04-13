# zabbix-multisslperhost
Monitor Multiple SSL Certificates Per Host with Zabbix (Tested with Zabbix 6.4)

If you run a webserver with multiple websites with SSL, the default SSL monitor doesn't monitor SSL expiration of more than one site per host. Note: This has been only been tested with the zabbix-agent2 and Zabbix 6.4. If you test with other versions, please let me know.

## On Zabbix Endpoint (where agent2 is running)
On your agent machine, put ssl.sh in /var/lib/zabbix This will scan your /etc/httpd/conf.d/ directory and look for <ServerName xyz.com:443> websites and return a list. You may need to modify the location to suit your environment.
```
curl -Os https://raw.githubusercontent.com/marcpope/zabbix-multisslperhost/main/ssl.sh > /var/lib/zabbix/ssl.sh
chmod +x /var/lib/zabbix/ssl.sh
chmod 644 /etc/httpd/conf.d/vhost*.conf  ## ensure zabbix user can read all httpd conf files
```
Now, verify this is returning the sites you expect, if not, make sure your Apache configs are in the location where the script is looking or modify the ssl.sh script to your environment. 
```
cd /var/lib/zabbix/ ; ./ssl.sh
```
Import the ssl.discovery script into your zabbix agent2 conf.d directory:
```
curl -Os https://raw.githubusercontent.com/marcpope/zabbix-multisslperhost/main/ssl.conf > /etc/zabbix/zabbix_agent2.d/ssl.conf
```
Restart your Zabbix Agent2:
```
systemctl restart zabbix-agent2
```
## On Zabbix Server
Now, download the template and import it into your Zabbix Server under "Data Collection > Templates".
https://github.com/marcpope/zabbix-multisslperhost/blob/main/zbx_ssl_template.yaml

Modify your host to include the SSL Custom Template, it will start populating latest data.

There are 3 triggers set for various days of expiration, you can modify those as you desire.
<21 days (WARNING)
<10 days (HIGH)
<1 days (DISASTER)


