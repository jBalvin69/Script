#!/bin/bash

contenedores_existentes=$(docker ps -a)

echo ""
echo "	CAMBIAR O AÑADIR UNA CONFIGURACIÓN DE UN CONTENEDOR"
echo "---------------------------------------------------------------------------------------------------------------------------------------------------"
echo ""
echo ""

echo "	- LISTA DE CONTENEDORES EXISTENTES EN TU SISTEMA"
echo ""
echo "	$contenedores_existentes"
echo ""
echo ""

read -p "Escoge un contenedor para modificar: " contenedor
echo ""

contenedor_existe=$(docker ps -a | grep "$contenedor")
echo ""

while [[ $contenedor_existe = "" ]]; do
    echo ""
    echo "						ERROR: El contenedor especificado no existe"
    echo ""
    read -p "					Por favor, escoge un contenedor de la lista para modificar: " contenedor
    echo ""
    contenedor_existe=$(docker ps -a | grep "$contenedor")
done

echo ""
echo "								Iniciando contenedor..."
docker start "$contenedor"
echo ""
echo "							Contenedor iniciado, entrando en contenedor..."
echo ""
echo "					Para realizar los cambios, escribe './script.sh' al entrar en el contenedor"
echo ""
docker attach "$contenedor"
