docker run --rm -i -p 5901:5901 -p 8082:80 -p 8443:443 -v /opt/storage2/docker_dev/v/:/home/user/Downloads/ -e VNC_PW=pass123 shrek/ubuntu-openbox-tigervnc-novnc-firefox-esr 
