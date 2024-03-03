#!/bin/bash

loop=$(ip a | grep -E '\b[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sed -E "s/ +/:/g" | cut -d: -f3 | head -n1)

ip1=$(ip a | grep -E '\b[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sed -E "s/ +/:/g" | cut -d: -f3 | head -n2 | tail -n1)

ip2=$(ip a | grep -E '\b[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sed -E "s/ +/:/g" | cut -d: -f3 | head -n3 | tail -n1)

gateway=$(ip route | grep "default via" | sed -E "s/ +/:/g" | cut -d: -f3)

c1=$(ip a | sed -E "s/ +/:/g" | grep enp0s3 | grep "inet")

c2=$(ip a | grep enp0s8 | grep "inet")

echo ""

echo ""

echo ""

echo " ¡BIENVENIDO AL SERVICIO!"

echo ""

if [ -n "$c1" ]; then
    echo " Tu IP de la interfaz enp0s3 es: $ip1"
fi

if [ -n "$c2" ]; then
    echo " Tu IP en la interfaz enp0s8 es: $ip2"
fi

echo " La dirección de la puerta de enlace es: $gateway"
echo ""

echo " Antes de nada, el programa requiere de credenciales de administrador"
echo ""

# COMPRUEBA SI NO ESTÁ INSTALADO
if ! command -v squid &> /dev/null; then
    echo ""
    echo " Aún no está instalado el servicio PROXY"
    echo ""
else
    echo ""
    if sudo systemctl is-active squid.service &> /dev/null; then
        echo ""
        echo " El servicio está activo"
   elif sudo systemctl is-inactive squid.service &> /dev/null; then
        echo ""
        echo " El servicio está parado actualmente"
    else
        echo ""
        echo " El servicio está fallando"
    fi
    echo ""
fi

echo ""

op2=""

while [ "$op2" != "exit" -a "$op2" != "EXIT" ]; do
    echo ""
    echo "---------------------------------------------"
    echo "  __________________________________________"
    echo "  |                                         |"
    echo "  | 1--Instalar servicio PROXY              | "
    echo "  |                                         | "
    echo "  | 2--Desinstalar servicio PROXY           | "
    echo "  |                                         | "
    echo "  | 3--Parar servicio PROXY                 | "
    echo "  |                                         | "
    echo "  | 4--Iniciar el Servicio                  | "
    echo "  |                                         | "
    echo "  | 5--Permitir o denegar distintos valores | "
    echo "  |                                         | "
    echo "  | Para salir introduzca 'exit'.           | "
    echo "  |_________________________________________| "
    echo ""
    read -p " Seleccione una opción válida: " op2
    echo ""

    if [ "$op2" == "1" ]; then
        i=""
        while [ "$i" != "4" -a "$i" != "1" -a "$i" != "2" -a "$i" != "3" ]; do
            echo ""
            echo " ¿Cómo quieres instalar el servicio proxy?"
            echo ""
            echo " Elige una de las siguientes opciones"
            echo ""
            echo " 1--Con comandos"
            echo " 2--Con Ansible"
            echo " 3--Con Docker"
            echo ""
            echo " 4--Volver"
            echo ""
            read -p " Seleccione una opción: " i
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
                echo ''
                echo '           88                        88                                '
                echo '           88                        88                                '
                echo '           88                        88                                '
                echo '   ,adPPYb,88  ,adPPYba,   ,adPPYba, 88   ,d8  ,adPPYba, 8b,dPPYba,    '
                echo '  a8"    `Y88 a8"     "8a a8"     "" 88 ,a8"  a8P_____88 88P   "Y8     '
                echo '  8b       88 8b       d8 8b         8888[    8PP""""""" 88            '
                echo '  "8a,   ,d88 "8a,   ,a8" "8a,   ,aa 88`"Yba, "8b,   ,aa 88            '
                echo '    888888      8888888      888888" 88  Y8a     Ybbd8   88            '
                echo ''
                echo ""
                echo ""
                echo "|------------------------------------------------------------------------------------------------------------------------------|"
                echo ""
                echo "                                                  ACTUALIZANDO REPOSITORIOS"
                echo ""
                echo "|------------------------------------------------------------------------------------------------------------------------------|"
                sudo apt update
                echo ""
                echo "|------------------------------------------------------------------------------------------------------------------------------|"
                echo ""
                echo "                                                  REPOSITORIOS ACTUALIZADOS"
                echo ""
                echo "|------------------------------------------------------------------------------------------------------------------------------|"
                echo ""
                echo "|------------------------------------------------------------------------------------------------------------------------------|"
                echo ""
                echo "                                                  INSTALANDO PAQUETES DE DOCKER"
                echo ""
                echo "|------------------------------------------------------------------------------------------------------------------------------|"
                sudo apt install apt-transport-https ca-certificates curl software-properties-common
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
                sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
                sudo apt update
                apt-cache policy docker-ce
                sudo apt install docker-ce
                echo ""
                echo "------------------------------------------------------------------------------------------------------------------------------|"
                echo ""
                echo "                                                  DOCKER HA SIDO INSTALADO"
                echo ""
                echo "------------------------------------------------------------------------------------------------------------------------------|"
                echo ""
                echo "------------------------------------------------------------------------------------------------------------------------------|"
                echo ""
                echo "                                                  OBTENIENDO IMAGEN DE DOCKER"
                echo ""
                echo "------------------------------------------------------------------------------------------------------------------------------|"
                docker pull mi_servicio_proxy
                echo ""
                echo "------------------------------------------------------------------------------------------------------------------------------|"
                echo ""
                echo "                                                  LA IMAGEN HA SIDO DESCARGADA"
                echo ""
                echo "------------------------------------------------------------------------------------------------------------------------------|"
                echo ""
                echo "------------------------------------------------------------------------------------------------------------------------------|"
                echo ""
                echo "                                  ESPECIFICA UN NOMBRE PARA EL CONTENEDOR QUE ALOJARÁ EL SERVICIO"
                echo ""
                echo "------------------------------------------------------------------------------------------------------------------------------|"
                echo ""
                read -p "                                        ¿Qué nombre deseas poner a tu contenedor?: " nombre
                echo ""
                while [[ "$nombre" = "" ]]; do
                    echo ""
                    echo "----------------------------------------------------------------------------------------------------------------------|"
                    echo ""
                    echo "                                  ERROR: Debes ingresar un nombre válido para tu contenedor"
                    echo ""
                    echo ""
                    read -p "                               ¿Qué nombre deseas poner a tu contenedor?" nombre
                    echo ""
                done
                echo ""
                echo "****CREANDO CONTENEDOR****"
                echo ""
                docker run -it --name $nombre mi_servicio_proxy:latest
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
        op5=""
        while [ "$op5" != "3" ]; do
            echo ""
            echo "---------------------------------------------"
            echo "  __________________________________________"
            echo "  |                                         |"
            echo "  | 1--Permitir                             | "
            echo "  |                                         | "
            echo "  | 2--Denegar                              | "
            echo "  |                                         | "
            echo "  | 3--Salir                                | "
            echo "  |_________________________________________| "
            echo ""
            read -p "Seleccione una opción válida: " op5
            echo ""
            if [ "$op5" == "1" ]; then
                op6=""
                while [ "$op6" != "4" ]; do
                    echo ""
                    echo "---------------------------------------------"
                    echo "  __________________________________________"
                    echo "  |                                         |"
                    echo "  | 1--Horario                              | "
                    echo "  |                                         | "
                    echo "  | 2--IP                                   | "
                    echo "  |                                         | "
                    echo "  | 3--Dominio                              | "
		    echo "  |                                         | "
                    echo "  | 4--Salir                                | "
                    echo "  |_________________________________________| "
                    echo ""
                    read -p "Seleccione una opción válida: " op6
                    echo ""
                    if [ "$op6" == "1" ]; then

			read -p "digame la hora inical(00:00): " horai
			hi=`echo $horai | grep -E "\b[0-9]{1,2}:[0-9]{2}\b"`
			if [ $hi != "" ];then
				read -p "digame la hora final(00:00): " horaf
				hf=`echo $horaf | grep -E "\b[0-9]{1,2}:[0-9]{2}\b"`
				if [ $hf != "" ];then
				hora="SMTWHFA $hi-$hf"
				echo $hora
				sudo bash -c  "echo '$hora' > /etc/squid/horariop.conf"

				sudo sed -i '/acl horas_permitidas time -f \/etc\/squid\/horariop\.conf/d' /etc/squid/squid.conf
				sudo sed -i '/http_access allow horas_permitidas/d' /etc/squid/squid.conf

				sudo bash -c 'echo "acl horas_permitidas time -f /etc/squid/horariop.conf" >> /etc/squid/squid.conf'

				sudo bash -c 'echo "http_access allow horas_permitidas" >> /etc/squid/squid.conf'
			else
				echo "Debe introducir la hora final en formato (00:00)"
			fi
	  	   else 
			echo "Debe introducir la hora inicial en formato (00:00)"
		    fi


                    elif [ "$op6" == "2" ]; then

			read -p " (formato xxx.xxx.xxx.xxx): " ipd
			ipd1=`echo $ipd | grep -E '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'

			if [ "$ipd1" != "" ]; then
  

       				 sudo bash -c  "echo '$ipd1' >> /etc/squid/ipp.conf"

       			 	sudo sed -i '/acl ip_permitidas src -f \/etc\/squid\/ipp\.conf/d' /etc/squid/squid.conf
        			sudo sed -i '/http_access allow ip_permitidas/d' /etc/squid/squid.conf

      			        sudo bash -c 'echo "acl ip_permitidas src -f /etc/squid/ipp.conf" >> /etc/squid/squid.conf'
        			sudo bash -c 'echo "http_access allow ip_permitidas" >> /etc/squid/squid.conf'


			else
    				echo "Debe introducir la IP  en formato (xxx.xxx.xxx.xxx)"
			fi


                    elif [ "$op6" == "3" ]; then
                        # Lógica para permitir basado en IP
                        echo "Implementar lógica para permitir basado en IP"
		    elif [ "$op6" == "4" ]; then
				echo ""
				echo "Saliendo..."
				echo ""
                    else
                        echo "Opción no válida. Por favor, seleccione 1, 2 o 3."
                    fi
                done
            elif [ "$op5" == "2" ]; then
                op7=""
                while [ "$op7" != "4" ]; do
                    echo ""
                    echo "---------------------------------------------"
                    echo "  __________________________________________"
                    echo "  |                                         |"
                    echo "  | 1--Horario                              | "
                    echo "  |                                         | "
                    echo "  | 2--IP                                   | "
                    echo "  |                                         | "
                    echo "  | 3--Dominio                              | "
		    echo "  |                                         |"
		    echo "  | 4--Salir                                |"
                    echo "  |_________________________________________| "
                    echo ""
                    read -p "Seleccione una opción válida: " op7
                    echo ""
                    if [ "$op7" == "1" ]; then

			 read -p "digame la hora inical(00:00): " hori
                        hri=`echo $hori | grep -E "\b[0-9]{1,2}:[0-9]{2}\b"`
                        if [ $hri != "" ];then
                                read -p "digame la hora final(00:00): " horf
                                hrf=`echo $horf | grep -E "\b[0-9]{1,2}:[0-9]{2}\b"`
                                if [ $hrf != "" ];then
                                hor="SMTWHFA $hri-$hrf"
				echo $hor
				sudo bash -c  "echo '$hor' > /etc/squid/horariod.conf"

                                sudo sed -i '/acl horas_denegadas time -f \/etc\/squid\/horariod\.conf/d' /etc/squid/squid.conf
                                sudo sed -i '/http_access deny horas_denegadas/d' /etc/squid/squid.conf

                                sudo bash -c 'echo "acl horas_denegadas time -f /etc/squid/horariod.conf" >> /etc/squid/squid.conf'

                                sudo bash -c 'echo "http_access deny horas_denegadas" >> /etc/squid/squid.conf'
                        else
                                echo "Debe introducir la hora final en formato (00:00)"
                        fi
                   else 
                        echo "Debe introducir la hora inicial en formato (00:00)"
                    fi

	
                    elif [ "$op7" == "2" ]; then
				 read -p " (formato xxx.xxx.xxx.xxx): " ipd2
                        ipd3=`echo $ipd2 | grep -E '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'

                        if [ "$ipd3" != "" ]; then
  

                                 sudo bash -c  "echo '$ipd3' >> /etc/squid/ipd.conf"

                                sudo sed -i '/acl ip_denegadas src -f \/etc\/squid\/ipd\.conf/d' /etc/squid/squid.conf
                                sudo sed -i '/http_access deny ip_denegadas/d' /etc/squid/squid.conf

                                sudo bash -c 'echo "acl ip_denegadas src -f /etc/squid/ipd.conf" >> /etc/squid/squid.conf'
                                sudo bash -c 'echo "http_access deny ip_denegadas" >> /etc/squid/squid.conf'


                        else
                                echo "Debe introducir la IP  en formato (xxx.xxx.xxx.xxx)"
                        fi




                    elif [ "$op7" == "3" ]; then
                        # Lógica para denegar basado en IP
                        echo "Implementar lógica para denegar basado en IP"
		    elif [ "$op7" == "4" ]; then
			echo ""
			echo "saliendo"
			echo ""
                    else
                        echo "Opción no válida. Por favor, seleccione 1, 2 o 3."
                    fi
                done
            elif [ "$op5" == "3" ]; then
                echo "Saliendo del menú Permitir/Denegar."
            else
                echo "Opción no válida. Por favor, seleccione 1, 2 o 3."
            fi
        done
    fi
done

