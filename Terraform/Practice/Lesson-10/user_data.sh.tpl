#!/bin/bash

sudo apt update
sudo apt install apache2 -y


myip=$(curl ifconfig.me)

cat <<EOF > /var/www/html/index.html
<html>
<h2>Server with IP: $myip</h2>
<h4>Owner ${f_name} ${l_name}</h4>

%{ for name in names ~}
Hello to ${name} from ${f_name}<br>
%{ endfor ~}

</html>
EOF

sudo service apache2 start
sudo systemctl enable apache2