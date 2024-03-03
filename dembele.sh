#!/bin/bash

# Almacena el resultado de `ip a` en una variable para evitar repeticiones
ip_info=$(ip a)

loop=$(echo "$ip_info" | grep -E '\b[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sed -E "s/ +/:/g" | cut -d: -f3 | head -n1)
ip1=$(echo "$ip_info" | grep -E '\b[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sed -E "s/ +/:/g" | cut -d: -f3 | head -n2 | tail -n1)
ip2=$(echo "$ip_info" | grep -E '\b[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sed -E "s/ +/:/g" | cut -d: -f3 | head -n3 | tail -n1)
gateway=$(ip route | grep "default via" | sed -E "s/ +/:/g" | cut -d: -f3)

c1=$(echo "$ip_info" | sed -E "s/ +/:/g" | grep enp0s3 | grep "inet")
c2=$(echo "$ip_info" | grep enp0s8 | grep "inet")

# Elimina echo vacíos y mejora la presentación
echo -e "\n\n\n ¡BIENVENIDO AL SERVICIO!\n"

if [ -n "$c1" ]; then
    echo " Tu IP de la interfaz enp0s3 es: $ip1"
fi

if [ -n "$c2" ]; then
    echo " Tu IP en la interfaz enp0s8 es: $ip2"
fi

echo -e " La dirección de la puerta de enlace es: $gateway\n"
echo -e " Antes de nada, el programa requiere de credenciales de administrador\n"

# COMPRUEBA SI NO ESTÁ INSTALADO
if ! command -v squid &> /dev/null; then
    echo -e " Aún no está instalado el servicio PROXY\n"
else
    echo -e ""
    if sudo systemctl is-active squid.service &> /dev/null; then
        echo " El servicio está activo"
    elif sudo systemctl is-inactive squid.service &> /dev/null; then
        echo " El servicio está parado actualmente"
    else
        echo " El servicio está fallando"
    fi
    echo -e ""
fi

while [ "$op2" != "exit" -a "$op2" != "EXIT" ]; do

echo -e "---------------------------------------------"
echo -e "  __________________________________________"
echo -e "  |                                         |"
echo -e "  | 1--Instalar servicio PROXY              | "
echo -e "  |                                         | "
echo -e "  | 2--Desinstalar servicio PROXY           | "
echo -e "  |                                         | "
echo -e "  | 3--Parar servicio PROXY                 | "
echo -e "  |                                         | "
echo -e "  | 4--Iniciar el Servicio                  | "
echo -e "  |                                         | "
echo -e "  | 5--Permitir o denegar distintos valores | "
echo -e "  |                                         | "
echo -e "  | Para salir introduzca 'exit'.           | "
echo -e "  |_________________________________________| \n"

op2=""
read -p " Seleccione una opción válida: " op2

    if [ "$op2" == "1" ]; then
        i=""
        while [ "$i" != "4" -a "$i" != "1" -a "$i" != "2" -a "$i" != "3" ]; do
            echo -e " ¿Cómo quieres instalar el servicio proxy?"
            echo -e " Elige una de las siguientes opciones\n"
            echo -e " 1--Con comandos"
            echo -e " 2--Con Ansible"
            echo -e " 3--Con Docker\n"
            echo -e " 4--Volver\n"
            read -p " Seleccione una opción: " i
            echo -e ""

            if [ "$i" == "1" ]; then
                sudo apt update
                sudo apt upgrade
                echo -e "-----------------------\nSistema actualizado.\n-----------------------\n"
                echo -e "Instalando squid...\n"
                sudo apt install squid -y
                echo -e ""
            elif [ "$i" == "2" ]; then
                echo "ANSIBLE"
                echo ""
                # Agrega aquí los comandos de Ansible si es necesario
            elif [ "$i" == "3" ]; then
                echo -e ''
                echo -e '           88                        88                                '
                echo -e '           88                        88                                '
                echo -e '           88                        88                                '
                echo -e '   ,adPPYb,88  ,adPPYba,   ,adPPYba, 88   ,d8  ,adPPYba, 8b,dPPYba,    '
                echo -e '  a8"    `Y88 a8"     "8a a8"     "" 88 ,a8"  a8P_____88 88P   "Y8     '
                echo -e '  8b       88 8b       d8 8b         8888[    8PP""""""" 88            '
                echo -e '  "8a,   ,d88 "8a,   ,a8" "8a,   ,aa 88`"Yba, "8b,   ,aa 88            '
                echo -e '    888888      8888888      888888" 88  Y8a     Ybbd8   88            '
                echo -e ''
                echo -e "|------------------------------------------------------------------------------------------------------------------------------|\n"
                echo -e "                                                  ACTUALIZANDO REPOSITORIOS\n"
                echo -e "|------------------------------------------------------------------------------------------------------------------------------|\n"
                sudo apt update
                echo -e "|------------------------------------------------------------------------------------------------------------------------------|\n"
                echo -e "                                                  REPOSITORIOS ACTUALIZADOS\n"
                echo -e "|------------------------------------------------------------------------------------------------------------------------------|\n"
                echo -e "|------------------------------------------------------------------------------------------------------------------------------|\n"
                echo -e "                                                  INSTALANDO PAQUETES DE DOCKER\n"
                echo -e "|------------------------------------------------------------------------------------------------------------------------------|\n"
                sudo apt install apt-transport-https ca-certificates curl software-properties-common
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
                sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
                sudo apt update
                apt-cache policy docker-ce
                sudo apt install docker-ce
                echo -e "|------------------------------------------------------------------------------------------------------------------------------|\n"
                echo -e "                                                  DOCKER HA SIDO INSTALADO\n"
                echo -e "------------------------------------------------------------------------------------------------------------------------------|\n"
                echo -e "|------------------------------------------------------------------------------------------------------------------------------|\n"
                echo -e "                                                  OBTENIENDO IMAGEN DE DOCKER\n"
                echo -e "|------------------------------------------------------------------------------------------------------------------------------|\n"
                docker pull mi_servicio_proxy
                echo -e "|------------------------------------------------------------------------------------------------------------------------------|\n"
                echo -e "                                                  LA IMAGEN HA SIDO DESCARGADA\n"
                echo -e "------------------------------------------------------------------------------------------------------------------------------|\n"
                echo -e "|------------------------------------------------------------------------------------------------------------------------------|\n"
                echo -e "                                  ESPECIFICA UN NOMBRE PARA EL CONTENEDOR QUE ALOJARÁ EL SERVICIO\n"
                echo -e "|------------------------------------------------------------------------------------------------------------------------------|\n"
                read -p "                                        ¿Qué nombre deseas poner a tu contenedor?: " nombre
                echo -e ""
                while [[ "$nombre" = "" ]]; do
                    echo -e "|----------------------------------------------------------------------------------------------------------------------|\n"
                    echo -e "                                  ERROR: Debes ingresar un nombre válido para tu contenedor\n"
                    echo -e "\n"
                    read -p "                               ¿Qué nombre deseas poner a tu contenedor?" nombre
                    echo -e ""
                done
                echo -e "****CREANDO CONTENEDOR****\n"
                docker run -it --name $nombre mi_servicio_proxy:latest
            fi
        done
    elif [ "$op2" == "2" ]; then
        echo -e ""
        read -p "¿Quiere borrar el servicio?(Y/N): " r
        echo -e ""
        if [ "$r" == "Y" -o "$r" == "y" ]; then
            if ! command -v squid &> /dev/null; then
                echo -e "NO SE PUEDE BORRAR, NO ESTÁ INSTALADO EL SERVICIO\n"
            else
                sudo apt-get remove --purge squid -y
                sudo apt-get autoremove --purge -y
                sudo apt-get clean -y
            fi
        elif [ "$r" == "N" -o "$r" == "n" ]; then
            echo -e ""
        fi
    elif [ "$op2" == "3" ]; then
        if ! command -v squid &> /dev/null; then
            echo -e "NO SE PUEDE PARAR EL SERVICIO PORQUE NO ESTÁ INSTALADO\n"
        elif sudo systemctl is-active squid.service &> /dev/null; then
            echo "PARANDO EL SERVICIO..."
            sudo systemctl stop squid.service
        else
            echo "EL SERVICIO YA ESTÁ PARADO"
        fi
    elif [ "$op2" == "4" ]; then
        if ! command -v squid &> /dev/null; then
            echo -e "NO SE PUEDE INICIAR EL SERVICIO PORQUE NO ESTÁ INSTALADO\n"
        elif sudo systemctl is-inactive squid.service &> /dev/null; then
            echo "INICIANDO EL SERVICIO..."
            sudo systemctl start squid.service
        else
            echo "YA ESTÁ INICIADO EL SERVICIO"
        fi
    elif [ "$op2" == "5" ]; then
        op5=""
        while [ "$op5" != "3" ]; do
            echo -e "---------------------------------------------"
            echo -e "  __________________________________________"
            echo -e "  |                                         |"
            echo -e "  | 1--Permitir                             | "
            echo -e "  |                                         | "
            echo -e "  | 2--Denegar                              | "
            echo -e "  |                                         | "
            echo -e "  | 3--Salir                                | "
            echo -e "  |_________________________________________| \n"
            read -p "Seleccione una opción válida: " op5
            echo -e ""
            if [ "$op5" == "1" ]; then
                op6=""
                while [ "$op6" != "4" ]; do
                    echo -e "---------------------------------------------"
                    echo -e "  __________________________________________"
                    echo -e "  |                                         |"
                    echo -e "  | 1--Horario                              | "
                    echo -e "  |                                         | "
                    echo -e "  | 2--IP                                   | "
                    echo -e "  |                                         | "
                    echo -e "  | 3--Dominio                              | "
                    echo -e "  |                                         | "
                    echo -e "  | 4--Salir                                | "
                    echo -e "  |_________________________________________| \n"
                    read -p "Seleccione una opción válida: " op6
                    echo -e ""
                    if [ "$op6" == "1" ]; then
                        read -p "digame la hora inical(00:00): " horai
                        hi=$(echo $horai | grep -E "\b[0-9]{1,2}:[0-9]{2}\b")
                        if [ "$hi" != "" ]; then
                            read -p "digame la hora final(00:00): " horaf
                            hf=$(echo $horaf | grep -E "\b[0-9]{1,2}:[0-9]{2}\b")
                            if [ "$hf" != "" ]; then
                                hora="SMTWHFA $hi-$hf"
                                echo $hora
                                sudo bash -c "echo '$hora' > /etc/squid/hora.txt"
                            fi
                        fi
                    elif [ "$op6" == "2" ]; then
                        read -p "Ingrese la IP que desea permitir: " ip_permitida
                        ip_valida=$(echo $ip_permitida | grep -E '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b')
                        if [ "$ip_valida" != "" ]; then
                            sudo bash -c "echo '$ip_valida' > /etc/squid/ip.txt"
                        else
                            echo -e "IP no válida\n"
                        fi
                    elif [ "$op6" == "3" ]; then
                        read -p "Ingrese el dominio que desea permitir: " dominio_permitido
                        sudo bash -c "echo '$dominio_permitido' > /etc/squid/dominio.txt"
                    fi
                done
            elif [ "$op5" == "2" ]; then
                op7=""
                while [ "$op7" != "4" ]; do
                    echo -e "---------------------------------------------"
                    echo -e "  __________________________________________"
                    echo -e "  |                                         |"
                    echo -e "  | 1--Horario                              | "
                    echo -e "  |                                         | "
                    echo -e "  | 2--IP                                   | "
                    echo -e "  |                                         | "
                    echo -e "  | 3--Dominio                              | "
                    echo -e "  |                                         | "
                    echo -e "  | 4--Salir                                | "
                    echo -e "  |_________________________________________| \n"
                    read -p "Seleccione una opción válida: " op7
                    echo -e ""
                    if [ "$op7" == "1" ]; then
                        read -p "digame la hora inical(00:00): " horai
                        hi=$(echo $horai | grep -E "\b[0-9]{1,2}:[0-9]{2}\b")
                        if [ "$hi" != "" ]; then
                            read -p "digame la hora final(00:00): " horaf
                            hf=$(echo $horaf | grep -E "\b[0-9]{1,2}:[0-9]{2}\b")
                            if [ "$hf" != "" ]; then
                                hora="SMTWHFA $hi-$hf"
                                echo $hora
                                sudo bash -c "echo '$hora' > /etc/squid/hora_deny.txt"
                            fi
                        fi
                    elif [ "$op7" == "2" ]; then
                        read -p "Ingrese la IP que desea denegar: " ip_denegada
                        ip_valida=$(echo $ip_denegada | grep -E '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b')
                        if [ "$ip_valida" != "" ]; then
                            sudo bash -c "echo '$ip_valida' > /etc/squid/ip_deny.txt"
                        else
                            echo -e "IP no válida\n"
                        fi
                    elif [ "$op7" == "3" ]; then
                        read -p "Ingrese el dominio que desea denegar: " dominio_denegado
                        sudo bash -c "echo '$dominio_denegado' > /etc/squid/dominio_deny.txt"
                    fi
                done
            fi
        done
    fi
done


