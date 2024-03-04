#!/bin/bash
if [ "$1" == "-instalar" ]; then
    if [ "$2" == "-comandos" ]; then
	 sudo apt update -y
                sudo apt upgrade -y
                echo -e "-----------------------\nSistema actualizado.\n-----------------------\n"
                echo -e "Instalando squid...\n"
                sudo apt install squid -y
                echo -e ""
        echo "Instalando el servicio con comandos..."
    elif [ "$2" == "-ansible" ]; then
		echo "ansible"
    elif [ "$2" == "-docker" ]; then
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


    else
        echo "Parámetro inválido. Las opciones válidas son: --comandos, --ansible, --docker"
        
    fi


elif [ "$1" == "-desinstalar" ]; then
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

elif [ "$1" == "-parar" ]; then
	
	  if ! command -v squid &> /dev/null; then
            echo -e "NO SE PUEDE PARAR EL SERVICIO PORQUE NO ESTÁ INSTALADO\n"
        elif sudo systemctl is-active squid.service &> /dev/null; then
            echo "PARANDO EL SERVICIO..."
            sudo systemctl stop squid.service
        else
            echo "EL SERVICIO YA ESTÁ PARADO"
        fi


elif [ "$1" == "-iniciar" ]; then

	if ! command -v squid &> /dev/null; then
            echo -e "NO SE PUEDE INICIAR EL SERVICIO PORQUE NO ESTÁ INSTALADO\n"
        elif sudo systemctl is-inactive squid.service &> /dev/null; then
            echo "INICIANDO EL SERVICIO..."
            sudo systemctl start squid.service
        else
            echo "YA ESTÁ INICIADO EL SERVICIO"
        fi


elif [ "$1" == "-acl" ]; then
	if [ "$2" == "-permitir" ]; then
		if [ "$3" == "-horario" ];then		
			 read -p "digame la hora inical(00:00): " horai
                        hi=$(echo $horai | grep -E "\b[0-9]{1,2}:[0-9]{2}\b")
                        if [ "$hi" != "" ]; then
                            read -p "digame la hora final(00:00): " horaf
                            hf=$(echo $horaf | grep -E "\b[0-9]{1,2}:[0-9]{2}\b")
                            if [ "$hf" != "" ]; then
                                hora="SMTWHFA $hi-$hf"
                                echo $hora
                                sudo bash -c "echo '$hora' > /etc/squid/hora.txt"
                                sudo sed -i '/acl horas_permitidas time -f \/etc\/squid\/hora.txt/d' /etc/squid/squid.conf
                                sudo sed -i '/http_access allow horas_permitidas/d' /etc/squid/squid.conf

                                sudo bash -c 'echo "acl horas_permitidas time -f /etc/squid/hora.txt" >> /etc/squid/squid.conf'

                                sudo bash -c 'echo "http_access allow horas_permitidas" >> /etc/squid/squid.conf'

                            fi
                        fi

		elif [ "$3" == "-ip" ];then
			 read -p " (formato xxx.xxx.xxx.xxx): " ipd2
                                ipd3=$(echo $ipd2 | grep -E '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$')

                                 if [ "$ipd3" != "" ]; then     
                                          # Verifica si la IP ya está en deny.txt
                                         if grep -q "^$ipd3$" /etc/squid/ip.txt; then
                                         echo "La IP ya está en deny.txt. Sustituyendo la existente."
                                         sudo sed -i "s/^$ipd3$/^/d" /etc/squid/ip.txt
                                 fi
                                         # Añade la IP al archivo ip.txt
                                        sudo bash -c "echo '$ipd3' >> /etc/squid/ip.txt"
                                         # Verifica si la línea ya está en squid.conf
                                         if grep -q "^acl ip_permitidas src -f /etc/squid/ip.txt" /etc/squid/squid.conf; then
                                                 # Si está, elimina la existente
                                                sudo sed -i "/^acl ip_permitidas src -f \/etc\/squid\/ip.txt/d" /etc/squid/squid.conf
                                                      sudo sed -i "/^http_access allow ip_permitidas/d" /etc/squid/squid.conf
                                        fi
                                        # Añade la línea a squid.conf
                                        sudo bash -c 'echo "acl ip_permitidas src -f /etc/squid/ip.txt" >> /etc/squid/squid.conf'
                                        sudo bash -c 'echo "http_access allow ip_permitidas" >> /etc/squid/squid.conf'
                                        echo "IP añadida a ip.txt y a la configuración de Squid."
                               else
                                         echo -e "IP no válida\n"
                                fi

		elif [ "$3" == "-dominio" ]; then
			 read -p "Ingrese el dominio que desea permitir: " dom
                        sudo bash -c "echo '$dominio_permitido' > /etc/squid/dominio.txt"
                        if [ "$dom" == "" ];then
                                echo "Debes introducir un dominio"
                        else
                                 sudo bash -c "echo '$dom' >> /etc/squid/dominio.txt"
                                 sudo sed -i "/^acl dominios_permitidos dstdomain -f \/etc\/squid\/dominio.txt/d" /etc/squid/squid.conf
                                 sudo sed -i "/^http_access allow dominios_permitidos/d" /etc/squid/squid.conf

                                sudo bash -c "echo 'acl dominios_permitidos dstdomain -f dominio.txt' >> /etc/squid/squid.conf"
                                 # Añade la regla de acceso permitido para los dominios
                                 sudo bash -c "echo 'http_access allow dominios_permitidos' >> /etc/squid/squid.conf"

                        fi

		else 
			echo "Debes introducir una de las opciones válidas: -horario, -ip, -dominio"
		fi
	elif [ "$2" == "-denegar" ]; then
		if [ "$3" == "-horario" ];then
			 read -p "digame la hora inical(00:00): " horai
                        hi=$(echo $horai | grep -E "\b[0-9]{1,2}:[0-9]{2}\b")
                        if [ "$hi" != "" ]; then
                            read -p "digame la hora final(00:00): " horaf
                            hf=$(echo $horaf | grep -E "\b[0-9]{1,2}:[0-9]{2}\b")
                            if [ "$hf" != "" ]; then
                                hora="SMTWHFA $hi-$hf"
                                echo $hora
                                sudo bash -c "echo '$hora' > /etc/squid/hora_deny.txt"
                                sudo sed -i '/acl horas_denegadas time -f \/etc\/squid\/hora_deny.txt/d' /etc/squid/squid.conf
                                sudo sed -i '/http_access deny  horas_denegadas/d' /etc/squid/squid.conf

                                sudo bash -c 'echo "acl horas_denagadas time -f /etc/squid/hora_deny.txt" >> /etc/squid/squid.conf'

                                sudo bash -c 'echo "http_access deny horas_denegadas" >> /etc/squid/squid.conf'

                            fi
                        fi

                elif [ "$3" == "-ip" ];then
			 read -p " (formato xxx.xxx.xxx.xxx): " ipd2
                                ipd3=$(echo $ipd2 | grep -E '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$')

                                 if [ "$ipd3" != "" ]; then
                                          # Verifica si la IP ya está en deny.txt
                                         if grep -q "^$ipd3$" /etc/squid/ip_deny.txt; then
                                         echo "La IP ya está en deny.txt. Sustituyendo la existente."
                                         sudo sed -i "s/^$ipd3$/^/d" /etc/squid/ip_deny.txt
                                 fi
                                         # Añade la IP al archivo deny.txt
                                        sudo bash -c "echo '$ipd3' >> /etc/squid/ip_deny.txt"
                                         # Verifica si la línea ya está en squid.conf
                                         if grep -q "^acl ip_denegadas src -f /etc/squid/ip_deny.txt" /etc/squid/squid.conf; then
                                                 # Si está, elimina la existente
                                                sudo sed -i "/^acl ip_denegadas src -f \/etc\/squid\/ip_deny.txt/d" /etc/squid/squid.conf
                                                      sudo sed -i "/^http_access deny ip_denegadas/d" /etc/squid/squid.conf
                                        fi
                                        # Añade la línea a squid.conf
                                        sudo bash -c 'echo "acl ip_denegadas src -f /etc/squid/ip_deny.txt" >> /etc/squid/squid.conf'
                                        sudo bash -c 'echo "http_access deny ip_denegadas" >> /etc/squid/squid.conf'
                                        echo "IP añadida a deny.txt y a la configuración de Squid."
                               else
                                         echo -e "IP no válida\n"
                                fi

                elif [ "$3" == "-dominio" ]; then
			 read -p "Ingrese el dominio que desea denegar: " dom
                        if [ "$dom" == "" ];then
                                echo "Debes intoducir un dominio"
                        else
                                 sudo bash -c "echo '$dom' >> /etc/squid/dominio_deny.txt"
                                 sudo sed -i "/^acl dominios_denegados dstdomain -f \/etc\/squid\/dominio_deny.txt/d" /etc/squid/squid.conf
                                 sudo sed -i "/^http_access deny dominios_denegados/d" /etc/squid/squid.conf

                                 sudo bash -c "echo 'acl dominios_denegados dstdomain -f $dominio_deny.txt' >> /etc/squid/squid.conf"
                                 # Añade la regla de acceso permitido para los dominios
                                 sudo bash -c "echo 'http_access deny dominios_denegados' >> /etc/squid/squid.conf"
                        fi

                else 
                        echo "Debes introducir una de las opciones válidas: -horario, -ip, -dominio"
		fi
	else 
		echo "Debes introducir o '-permitir' o '-denegar'"
	fi

elif [ "$1" == "--help" ]; then
       	 echo "------------------"
	 echo " AYUDA DEl SCRIPT"
	 echo "------------------"
	 echo "Este script ayudará al usuario a instalar, configurar y mantener el servicio proxy"
	 echo "Si ejecutas el script sin ningún parámetro, sale por pantalla un menú con todas las opciones"
	 echo "-------------"
	 echo "PARÁMETROS"
	 echo "-------------"
	 echo "mediante parámetros también puedes hacer todo lo del menú, pero debes ser mucho más precisco. Aquí te dejo todas las posibles combinaciones"
	 echo ""
	 echo "-instalar (-comandos, -ansible, -docker )"
	 echo "-desinstalar"
	 echo "-parar"
	 echo "-inicar"
	 echo "-acl (-permitir, -denegar) (-horario, -ip, -dominio)"

elif [ "$1" == "-ipa" ]; then
	ip_info=$(ip a)

	loop=$(echo "$ip_info" | grep -E '\b[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sed -E "s/ +/:/g" | cut -d: -f3 | head -n1)
	ip1=$(echo "$ip_info" | grep -E '\b[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sed -E "s/ +/:/g" | cut -d: -f3 | head -n2 | tail -n1)
	ip2=$(echo "$ip_info" | grep -E '\b[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sed -E "s/ +/:/g" | cut -d: -f3 | head -n3 | tail -n1)
	gateway=$(ip route | grep "default via" | sed -E "s/ +/:/g" | cut -d: -f3)

	c1=$(echo "$ip_info" | sed -E "s/ +/:/g" | grep enp0s3 | grep "inet")
	c2=$(echo "$ip_info" | grep enp0s8 | grep "inet")
	if [ -n "$c1" ]; then
    		echo " Tu IP de la interfaz enp0s3 es: $ip1"
	fi

	if [ -n "$c2" ]; then
    		echo " Tu IP en la interfaz enp0s8 es: $ip2"
	fi

		echo -e " La dirección de la puerta de enlace es: $gateway\n"

elif [ "$1" == "-status" ]; then
	sudo systemctl status squid.service | grep 'Active:'
else
    echo "Parámetro inválido. Las opciones válidas son:-ipa,-status, -instalar, -desinstalar, -parar, -iniciar, -acl, --help"
   
fi

if [ $# -lt 1 ];then
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
        echo " El servicio no está activo"
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
                sudo apt update -y
                sudo apt upgrade -y
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
                sudo docker pull nachoasir/proxy:latest
                echo -e "|------------------------------------------------------------------------------------------------------------------------------|\n"
                echo -e "                                                  LA IMAGEN HA SIDO DESCARGADA\n"
                echo -e "------------------------------------------------------------------------------------------------------------------------------|\n"
                echo -e "|------------------------------------------------------------------------------------------------------------------------------|\n"
                echo -e "                                  ESPECIFICA UN NOMBRE PARA EL CONTENEDOR QUE ALOJARÁ EL SERVICIO\n"
                echo -e "|------------------------------------------------------------------------------------------------------------------------------|\n"
                read -p "                                        ¿Qué nombre deseas poner a tu contenedor?: " nombre
                echo -e ""
		echo "------------------------------------------------------------------------------------------------------------------------------|"
                echo ""
                echo "                                        ESPECIFICA QUE PUERTOS UTILIZARÁ TU CONTENEDOR"
                echo ""
                echo "------------------------------------------------------------------------------------------------------------------------------|"
                echo ""
                read -p "                                        Puerto que se abrirá en la máquina: " puerto1
                echo ""
		echo ""
		read -p "                                        Puerto que se abrirá en el contenedor: " puerto2
                echo ""
		puerto1_no_es_numero=$( echo $puerto1 | grep -vE '[a-z]')
		puerto2_no_es_numero=$( echo $puerto2 | grep -vE '[a-z]')
		echo ""
                        if [ "$puerto1_no_es_numero" == "" -a "$puerto2_no_es_numero" == "" ]; then
                                echo ""
                                echo ""
                                echo "                          ERROR: Los puertos introducidos deben ser números"
                                echo ""
                                read -p "                               Puerto que se abrirá en la máquina: " puerto1
                                echo ""
                                echo ""
                                read -p "                               Puerto que se abrirá en el contenedor: " puerto2
                                echo ""

                        fi


		while [[ "$nombre" = "" && "$puerto1" = "" && "$puerto2" = "" ]]; do
			echo ""
			echo "----------------------------------------------------------------------------------------------------------------------|"
			echo ""
    			echo "						ERROR: Falta alguno de los datos"
			echo ""
    			echo ""
    			read -p "		                  ¿Qué nombre deseas poner a tu contenedor?" nombre
    			echo ""
			echo ""
			read -p "                       	      Puerto que se abrirá en la máquina: " puerto1
               		echo ""
                	echo ""
               		read -p "                                     Puerto que se abrirá en el contenedor: " puerto2
			echo ""
			echo ""
			if [[ $comprobacion_puerto1 == "" && $comprobacion_puerto2 == "" ]]; then
				echo ""
				echo ""
				echo "                          ERROR: Los puertos introducidos deben ser números"
				echo ""
				echo ""
                        	read -p "                               Puerto que se abrirá en la máquina: " puerto1
                        	echo ""
                        	echo ""
                        	read -p "                               Puerto que se abrirá en el contenedor: " puerto2
                        	echo ""

			fi

		done

		echo ""
		echo "							CREANDO CONTENEDOR..."
		echo ""
		echo "				Nota: El contenedor creado contiene la configuración por defecto de squid"
		echo ""
		echo " 		   Si deseas añadir alguna configuración o cambiar una existente, escribe 'cambiar' al abrir el contenedor"
		echo ""
		echo "		   Si has salido del contenedor puedes volver a entrar para modificarlo usando la opcion 5 del menú de inicio"
		echo ""
		echo "		  				 Para salir del contenedor, escribe 'exit'"
		echo ""
		sudo docker run -it --name $nombre -p $puerto1:$puerto2 nachoasir/proxy:latest
		echo ""


                
                
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
	    echo -e "  |                                         | "
	    echo -e "  | 4--Modificar un contenedor de Docker    | "
	    echo -e "  |                                         | "
            echo -e "  |_________________________________________| \n"
	    echo ""
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
				sudo sed -i '/acl horas_permitidas time -f \/etc\/squid\/hora.txt/d' /etc/squid/squid.conf
                                sudo sed -i '/http_access allow horas_permitidas/d' /etc/squid/squid.conf

                                sudo bash -c 'echo "acl horas_permitidas time -f /etc/squid/hora.txt" >> /etc/squid/squid.conf'

                                sudo bash -c 'echo "http_access allow horas_permitidas" >> /etc/squid/squid.conf'

                            fi
                        fi
                    elif [ "$op6" == "2" ]; then
			   read -p " (formato xxx.xxx.xxx.xxx): " ipd2
                                ipd3=$(echo $ipd2 | grep -E '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$')

                                 if [ "$ipd3" != "" ]; then     
                                          # Verifica si la IP ya está en deny.txt
                                         if grep -q "^$ipd3$" /etc/squid/ip.txt; then
                                         echo "La IP ya está en deny.txt. Sustituyendo la existente."
                                         sudo sed -i "s/^$ipd3$/^/d" /etc/squid/ip.txt
                                 fi
                                         # Añade la IP al archivo ip.txt
                                        sudo bash -c "echo '$ipd3' >> /etc/squid/ip.txt"
                                         # Verifica si la línea ya está en squid.conf
                                         if grep -q "^acl ip_permitidas src -f /etc/squid/ip.txt" /etc/squid/squid.conf; then
                                                 # Si está, elimina la existente
                                                sudo sed -i "/^acl ip_permitidas src -f \/etc\/squid\/ip.txt/d" /etc/squid/squid.conf
                                                      sudo sed -i "/^http_access allow ip_permitidas/d" /etc/squid/squid.conf
                                        fi
                                        # Añade la línea a squid.conf
                                        sudo bash -c 'echo "acl ip_permitidas src -f /etc/squid/ip.txt" >> /etc/squid/squid.conf'
                                        sudo bash -c 'echo "http_access allow ip_permitidas" >> /etc/squid/squid.conf'
                                        echo "IP añadida a ip.txt y a la configuración de Squid."
                               else
                                         echo -e "IP no válida\n"
                                fi



                    elif [ "$op6" == "3" ]; then
                        read -p "Ingrese el dominio que desea permitir: " dom
                        sudo bash -c "echo '$dominio_permitido' > /etc/squid/dominio.txt"
                        if [ "$dom" == "" ];then
				echo "Debes introducir un dominio"
			else
                                 sudo bash -c "echo '$dom' >> /etc/squid/dominio.txt"
                                 sudo sed -i "/^acl dominios_permitidos dstdomain -f \/etc\/squid\/dominio.txt/d" /etc/squid/squid.conf
                                 sudo sed -i "/^http_access allow dominios_permitidos/d" /etc/squid/squid.conf

				sudo bash -c "echo 'acl dominios_permitidos dstdomain -f dominio.txt' >> /etc/squid/squid.conf"
       				 # Añade la regla de acceso permitido para los dominios
       				 sudo bash -c "echo 'http_access allow dominios_permitidos' >> /etc/squid/squid.conf"

                        fi

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
				sudo sed -i '/acl horas_denegadas time -f \/etc\/squid\/hora_deny.txt/d' /etc/squid/squid.conf
                                sudo sed -i '/http_access deny  horas_denegadas/d' /etc/squid/squid.conf

                                sudo bash -c 'echo "acl horas_denagadas time -f /etc/squid/hora_deny.txt" >> /etc/squid/squid.conf'

                                sudo bash -c 'echo "http_access deny horas_denegadas" >> /etc/squid/squid.conf'

                            fi
                        fi

		    elif [ "$op7" == "2" ]; then
			    read -p " (formato xxx.xxx.xxx.xxx): " ipd2
    				ipd3=$(echo $ipd2 | grep -E '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$')

   				 if [ "$ipd3" != "" ]; then
      					  # Verifica si la IP ya está en deny.txt
       					 if grep -q "^$ipd3$" /etc/squid/ip_deny.txt; then
           				 echo "La IP ya está en deny.txt. Sustituyendo la existente."
            				 sudo sed -i "s/^$ipd3$/^/d" /etc/squid/ip_deny.txt
       				 fi
       					 # Añade la IP al archivo deny.txt
        				sudo bash -c "echo '$ipd3' >> /etc/squid/ip_deny.txt"
       					 # Verifica si la línea ya está en squid.conf
       					 if grep -q "^acl ip_denegadas src -f /etc/squid/ip_deny.txt" /etc/squid/squid.conf; then
           					 # Si está, elimina la existente
            					sudo sed -i "/^acl ip_denegadas src -f \/etc\/squid\/ip_deny.txt/d" /etc/squid/squid.conf
      						      sudo sed -i "/^http_access deny ip_denegadas/d" /etc/squid/squid.conf
        				fi
        				# Añade la línea a squid.conf
        				sudo bash -c 'echo "acl ip_denegadas src -f /etc/squid/ip_deny.txt" >> /etc/squid/squid.conf'
        				sudo bash -c 'echo "http_access deny ip_denegadas" >> /etc/squid/squid.conf'
        				echo "IP añadida a deny.txt y a la configuración de Squid."
    		               else
       					 echo -e "IP no válida\n"
    				fi



                    elif [ "$op7" == "3" ]; then
                        read -p "Ingrese el dominio que desea denegar: " dom
			if [ "$dom" == "" ];then
				echo "Debes intoducir un dominio"
			else
                       		 sudo bash -c "echo '$dom' >> /etc/squid/dominio_deny.txt"
			 	 sudo sed -i "/^acl dominios_denegados dstdomain -f \/etc\/squid\/dominio_deny.txt/d" /etc/squid/squid.conf
                                 sudo sed -i "/^http_access deny dominios_denegados/d" /etc/squid/squid.conf

				 sudo bash -c "echo 'acl dominios_denegados dstdomain -f $dominio_deny.txt' >> /etc/squid/squid.conf"
                                 # Añade la regla de acceso permitido para los dominios
                                 sudo bash -c "echo 'http_access deny dominios_denegados' >> /etc/squid/squid.conf"
			fi
                    fi
                done
            fi
        done
    fi
done

fi
