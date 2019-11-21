#!/bin/bash

echo "user:user4pass" | chpasswd
echo "root:root4pass" | chpasswd
chown -R root:root /root
chown -R user:user /home/user
# usermod -aG sudo user

mkdir -p /home/user/Downloads/profiles/chromium
chown user: /home/user/Downloads/profiles/chromium
ln -s /home/user/Downloads/profiles/chromium/ /home/user/.config/chromium
rm /usr/share/applications/chromium-browser.desktop
cp /home/user/Desktop/chromium-browser.desktop /usr/share/applications/

if [[ ! -v VNC_PW ]]; then
  echo "VNC_PW is not set"
  rm -rf /home/user/.vnc/passwd
elif [[ -z "$VNC_PW" ]]; then
  echo "VNC_PW is set to the empty string"
  rm -rf /home/user/.vnc/passwd
else
  echo "VNC_PW has the value: $VNC_PW"
  mkdir /home/user/.vnc 2> /dev/null
  echo $VNC_PW | vncpasswd -f > /home/user/.vnc/passwd
  chown -R user: /home/user/.vnc
  chmod 0600 /home/user/.vnc/passwd
  echo 'securitytypes=vncauth' >> /home/user/.vnc/config
fi

sudo rm -rf /tmp/.X*
sudo -u user vncserver
mkdir /ssl/
if [ -e /ssl/No.VNC.crt.pem ]
then
  echo "self-signed certificate found"
else
  echo "generating self-signed certificate: $(hostname)"
  openssl req -subj "/CN=$(hostname)/O=NA/C=NA/ST=NA/L=NA"  -sha256 -new -newkey rsa:4096 -days 365 -nodes -x509 -keyout "/ssl/No.VNC.key.pem" -out "/ssl/No.VNC.crt.pem" 
fi

cd /usr/lib/web && ./run.py > /var/log/web.log 2>&1 &
nginx -c /etc/nginx/nginx.conf

exec /bin/tini -- /usr/bin/supervisord -n
