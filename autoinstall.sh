#!/bin/bash

#----------------------------------------------------
smtpuser="[smtp.gmail.com]:587 cuentadeorigen@gmail.com:contraseña"
destionodealertas="cuentadedestion@sysadmin.com"

#----------------------------------------------------

#Instalacion de paquetes
sudo apt update -y
sudo apt install postfix libsasl2-modules mailutils -y

#borrado de archivo anterior si ya existe y Creacion del nuevo archivo 
rm -r /etc/postfix/sasl/sasl_passwd
echo $smtpuser >> /etc/postfix/sasl/sasl_passwd

#asignacion de permisos
sudo postmap /etc/postfix/sasl/sasl_passwd
sudo chmod 0600 /etc/postfix/sasl/sasl_passwd
sudo chmod 0600 /etc/postfix/sasl/sasl_passwd.db

#configuracion de archivo main.cf
rm -r /etc/postfix/main.cf
echo "#Control" >> /etc/postfix/main.cf
echo "smtpd_banner = $myhostname ESMTP $mail_name (Ubuntu)" >> /etc/postfix/main.cf
echo "biff = no" >> /etc/postfix/main.cf
echo "append_dot_mydomain = no" >> /etc/postfix/main.cf
echo "readme_directory = no" >> /etc/postfix/main.cf
echo "compatibility_level = 2" >> /etc/postfix/main.cf
echo "relayhost = [smtp.gmail.com]:587" >> /etc/postfix/main.cf
echo "mydestination = localhost.localdomain, $localhost" >> /etc/postfix/main.cf
echo "smtp_sasl_auth_enable = yes" >> /etc/postfix/main.cf
echo "smtp_sasl_security_options = noanonymous" >> /etc/postfix/main.cf
echo "smtp_sasl_password_maps = hash:/etc/postfix/sasl/sasl_passwd" >> /etc/postfix/main.cf
echo "smtp_tls_security_level = encrypt" >> /etc/postfix/main.cf
echo "smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt" >> /etc/postfix/main.cf

#Para finalizar la configuración, reiniciamos el servicio

sudo systemctl restart postfix
sudo systemctl enable postfix

#Adicion de regla de lectura de login ssh y activacion de la alerta


echo "#Alerta-SSH-to-mail" >> /etc/profile
echo 'if [ -n "$SSH_CLIENT" ]; then' >> /etc/profile
echo 'TEXT="$(date): ssh login to ${USER}@$(hostname -f)"' >> /etc/profile
echo 'TEXT="$TEXT from $(echo $SSH_CLIENT|awk '{print $1}')"' >> /etc/profile
echo 'echo $TEXT|mail -s "Alert SSH login"' "$destionodealertas" >> /etc/profile
echo 'fi' >> /etc/profile
