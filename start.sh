#!/bin/sh

# configs
AUUID=a6afcd7e-b6bf-4e6c-a142-19bd76e185a2
CADDYIndexPage=https://github.com/fhfuirekig/wz/raw/main/mucsictap.zip
CONFIGCADDY=https://raw.githubusercontent.com/fhfuirekig/ohiyou/master/etc/Caddyfile
CONFIGXRAY=https://raw.githubusercontent.com/fhfuirekig/ohiyou/master/etc/xray.json
ParameterSSENCYPT=chacha20-ietf-poly1305
StoreFiles=https://raw.githubusercontent.com/fhfuirekig/ohiyou/master/etc/StoreFiles
#PORT=4433
mkdir -p /etc/caddy/ /usr/share/caddy && echo -e "User-agent: *\nDisallow: /" >/usr/share/caddy/robots.txt
wget $CADDYIndexPage -O /usr/share/caddy/index.html && unzip -qo /usr/share/caddy/index.html -d /usr/share/caddy/ && mv /usr/share/caddy/*/* /usr/share/caddy/
cat $CONFIGCADDY | sed -e "1c :$PORT" -e "s/\$AUUID/$AUUID/g" -e "s/\$MYUUID-HASH/$(caddy hash-password --plaintext $AUUID)/g" >/etc/caddy/Caddyfile
cat $CONFIGXRAY | sed -e "s/\$AUUID/$AUUID/g" -e "s/\$ParameterSSENCYPT/$ParameterSSENCYPT/g" >/xray.json

# storefiles
#mkdir -p /usr/share/caddy/$AUUID && wget -O /usr/share/caddy/$AUUID/StoreFiles $StoreFiles
#wget -P /usr/share/caddy/$AUUID -i /usr/share/caddy/$AUUID/StoreFiles

#for file in $(ls /usr/share/caddy/$AUUID); do
#    [[ "$file" != "StoreFiles" ]] && echo \<a href=\""$file"\" download\>$file\<\/a\>\<br\> >>/usr/share/caddy/$AUUID/ClickToDownloadStoreFiles.html
#done

# start
tor &

/xray -config /xray.json &

caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
