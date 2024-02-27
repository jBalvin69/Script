#!/bin/bash
 
loop=$(ip a | grep -E '\b[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sed -E "s/ +/:/g" | cut -d: -f3 | head -n1)
ip1=$(ip a | grep -E '\b[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sed -E "s/ +/:/g" | cut -d: -f3 | head -n2 | tail -n1)
ip2=$(ip a | grep -E '\b[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sed -E "s/ +/:/g" | cut -d: -f3 | head -n3 | tail -n1)
gateway=$(ip route | grep "default via" | sed -E "s/ +/:/g" | cut -d: -f3)
c1=$(ip a | sed -E "s/ +/:/g" | grep enp0s3 | grep "inet")
c2=$(ip a | grep enp0s8 | grep "inet")
 
echo ""
echo "¡BIENVENIDO AL SERVICIO!"
echo ""
 
if [ -n "$c1" ]; then
    echo "Tu IP de la interfaz enp0s3 es: $ip1"
fi
 
if [ -n "$c2" ]; then
    echo "Tu IP en la interfaz enp0s8 es: $ip2"
fi
 
echo "La dirección de la puerta de enlace es: $gateway"
echo ""
 
# COMPRUEBA SI NO ESTÁ INSTALADO
if ! command -v squid &> /dev/null; then
    echo ""
    echo "Aún no está instalado el servicio PROXY"
    echo ""
else
    echo ""
    if sudo systemctl is-active squid.service &> /dev/null; then
        echo "El servicio funciona correctamente"
    elif sudo systemctl is-inactive squid.service &> /dev/null; then
        echo "El servicio está parado actualmente"
    else
        echo "El servicio está fallando"
    fi
    echo ""
fi
 
echo ""
 
op2=""
 
while [ "$op2" != "exit" -a "$op2" != "EXIT" ]; do
 
    echo ""
    echo "__________________________________________"
    echo "|                                         |"
    echo "|1--Instalar servicio PROXY               | "
    echo "|2--Desinstalar servicio PROXY            | "
    echo "|3--Parar servicio PROXY                  | "
    echo "|4--Iniciar el Servicio                   |"
    echo "|5--Permitir o denegar distintos valores  | "
    echo "| Para salir introduzca 'exit'.           |"
    echo "|_________________________________________|"
    read -p "Seleccione una opción válida: " op2
    echo ""
 
    if [ "$op2" == "1" ]; then
        i=""
        while [ "$i" != "4" -a "$i" != "1" -a "$i" != "2" -a "$i" != "3" ]; do
            echo " ______________________________"
            echo "|INSTALACIÓN DEL SERVICIO PROXY|"
            echo "|______________________________|"
            echo ""
            echo "1--Con comandos"
            echo "2--Con Ansible"
            echo "3--Con Docker"
            echo ""
            echo "4--Volver"
            echo ""
            read -p "Seleccione una opción: " i
            echo ""
 
            if [ "$i" == "1" ]; then
                sudo apt update
                sudo apt upgrade
                echo "-----------------------"
                echo "Sistema actualizado."
                echo "-----------------------"
                echo ""
                echo "Instalando squid..."
                echo ""
                sudo apt install squid -y
                echo ""
            elif [ "$i" == "2" ]; then
                echo "ANSIBLE"
                echo ""
                # Agrega aquí los comandos de Ansible si es necesario
            elif [ "$i" == "3" ]; then
                echo "DOCKER"
                echo ""
                # Agrega aquí los comandos de Docker si es necesario
            fi
        done
    elif [ "$op2" == "2" ]; then
        echo ""
        read -p "¿Quiere borrar el servicio?(Y/N): " r
        echo ""
        if [ "$r" == "Y" -o "$r" == "y" ]; then
            if ! command -v squid &> /dev/null; then
                echo ""
                echo "NO SE PUEDE BORRAR, NO ESTÁ INSTALADO EL SERVICIO"
                echo ""
            else
                sudo apt-get remove --purge squid -y
                sudo apt-get autoremove --purge -y
                sudo apt-get clean -y
            fi
        elif [ "$r" == "N" -o "$r" == "n" ]; then
            echo ""
        else
            while [ "$r" != "Y" -a "$r" != "y" -a "$r" != "N" -a "$r" != "n" ]; do
                echo ""
                read -p "Introduzca una respuesta válida: " r
                echo ""
                if [ "$r" == "Y" -o "$r" == "y" ]; then
                    if ! command -v squid &> /dev/null; then
                        echo ""
                        echo "NO SE PUEDE BORRAR, NO ESTÁ INSTALADO EL SERVICIO"
                        echo ""
                    else
                        sudo apt-get remove --purge squid -y
                        sudo apt-get autoremove --purge -y
                        sudo apt-get clean -y
                    fi
                elif [ "$r" == "N" -o "$r" == "n" ]; then
                    echo ""
                fi
            done
        fi
    elif [ "$op2" == "3" ]; then
        if ! command -v squid &> /dev/null; then
            echo ""
            echo "NO SE PUEDE PARAR EL SERVICIO PORQUE NO ESTÁ INSTALADO"
            echo ""
        elif sudo systemctl is-active squid.service &> /dev/null; then
            echo "PARANDO EL SERVICIO..."
            sudo systemctl stop squid.service
        else
            echo "EL SERVICIO YA ESTÁ PARADO"
        fi
    elif [ "$op2" == "4" ]; then
        if ! command -v squid &> /dev/null; then
            echo ""
            echo "NO SE PUEDE INICIAR EL SERVICIO PORQUE NO ESTÁ INSTALADO"
            echo ""
        elif sudo systemctl is-inactive squid.service &> /dev/null; then
            echo "INICIANDO EL SERVICIO..."
            sudo systemctl start squid.service
        else
            echo "YA ESTÁ INICIADO EL SERVICIO"
        fi
    elif [ "$op2" == "5" ]; then
        echo "VARIAS OPCIONES"
    fi
done

