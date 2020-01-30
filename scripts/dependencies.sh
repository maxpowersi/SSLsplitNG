#!/bin/sh
# 2015 - Original: Whistle Master
# 2019 - Modified by: Andreas Nilsen <adde88@gmail.com>
# 2020 - Fixed by Maxpowersi

[[ -f /tmp/SSLsplitNG.progress ]] && {
  exit 0
}

touch /tmp/SSLsplitNG.progress

SSLSPLIT="sslsplit_0.5.5-1_mips_24kc.ipk"

opkg update

if [ "$1" = "install" ]; then
  if [ "$2" = "internal" ]; then
  	opkg install openssl-util libevent2-6 libevent2-6-core libevent2-6-extra libevent2-6-openssl libevent2-6-pthreads "$SSLSPLIT"
  elif [ "$2" = "sd" ]; then
	opkg install openssl-util libevent2-6 libevent2-6-core libevent2-6-extra libevent2-6-openssl libevent2-6-pthreads "$SSLSPLIT" --dest sd
  fi

	openssl genrsa -out /pineapple/modules/SSLsplitNG/cert/certificate.key 1024
	openssl req -new -nodes -x509 -sha1 -out /pineapple/modules/SSLsplitNG/cert/certificate.crt -key /pineapple/modules/SSLsplitNG/cert/certificate.key -config /pineapple/modules/SSLsplitNG/cert/openssl.cnf -extensions v3_ca -subj '/O=SSLsplit Root CA/CN=SSLsplit Root CA/' -set_serial 0 -days 3650

	touch /etc/config/sslsplitng
	echo "config sslsplitng 'module'" > /etc/config/sslsplitng

	uci set sslsplitng.module.installed=1
	uci commit sslsplitng.module.installed

elif [ "$1" = "remove" ]; then
	opkg remove sslsplit
	rm -rf /etc/config/sslsplitng
fi

rm -rf /tmp/SSLsplitNG.progress
