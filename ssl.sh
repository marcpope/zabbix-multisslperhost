#!/bin/bash

## ssl.sh - Scan Apache for SSLs to Monitor
## place in /var/lib/zabbix or whatever your zabbix home directory is.

dir="/etc/httpd/conf.d"
pattern="vhost*.conf"

read -r -d '' awkScript <<'EOF'
/<VirtualHost.*:443>/ {
  inBlock=1
}
/\/VirtualHost>/ {
  if (inBlock && foundServerName) {
    print serverName
    foundServerName=0
  }
  inBlock=0
}
{ if (inBlock && /ServerName/) {
    serverName = $2
    foundServerName=1
  }
}
EOF

serverNames=()

for file in "$dir"/$pattern; do
  while IFS= read -r line; do
    serverNames+=("$line")
  done < <(awk "$awkScript" "$file")
done

# Generate JSON output for Zabbix
echo -n '{"data":['
for domain in "${serverNames[@]}"; do
    echo -n "{\"{#SSLDOMAIN}\":\"$domain\"},"
done | sed 's/,$//'
echo -n ']}'
