#!/bin/bash

# Agrega la entrada "ferminator" al final del archivo /etc/squid/horariop.conf
sudo bash -c 'echo "rumanitor" > /etc/squid/horariop.conf'

# Elimina las líneas existentes antes de agregar la entrada en /etc/squid/squid.conf
sudo sed -i '/acl horas_permitidas time -f \/etc\/squid\/horariop\.conf/d' /etc/squid/squid.conf
sudo sed -i '/http_access allow horas_permitidas/d' /etc/squid/squid.conf

# Agrega la entrada "acl horas_permitidas time -f /etc/squid/horariop.conf" al final del archivo /etc/squid/squid.conf
sudo bash -c 'echo "acl horas_permitidas time -f /etc/squid/horariop.conf" >> /etc/squid/squid.conf'

# Agrega la entrada "http_access allow horas_permitidas" al final del archivo /etc/squid/squid.conf
sudo bash -c 'echo "http_access allow horas_permitidas" >> /etc/squid/squid.conf'
