#!/bin/bash
###############################################################################
# Nombre: 02-creacion_bridge.sh
# Descripción: Script para la creación de puente de red 
#
# Autor: Jorge A. Díaz Lara - jorge@integraci.com / jorge.diaz@gmail.com
# Licencia: GPL Versión 2
###############################################################################
echo -ne "\n###############################################################################"
echo -ne "\n# Servicios Web para Organizaciones                                           #"
echo -ne "\n# Creación de interfaz puente para trabajar con las máquinas virtuales        #"
echo -ne "\n#                                                                             #"
echo -ne "\n# Integra Conocimiento e Innovación - http://integraci.com.mx                 #"
echo -ne "\n#                                     contacto@integraci.com.mx               #"
echo -ne "\n###############################################################################\n\n"

# Detección de usuario, se debe ejecutar como usuario root de lo contrario
# termina la ejecución.
if [[ $EUID -ne 0 ]]; then
    echo -ne "\nPor favor ejecuta el script como usuario \"root\".\n"
    echo -ne "puedes utilizar el comando \"su\":\n"
    echo -ne "$ su -c \"00-instala_ansible-servidor_principal.sh\"\n\n"
    exit 1
fi

for ARCHIVO_TARJETA in `find /etc/sysconfig/network-scripts/ -name "ifcfg-e[[:alnum:]]*[[:digit:]]"`;do
  # Eliminar retorno de carro
  sed -i 's/\x0D$//' $ARCHIVO_TARJETA
  
  # Crea respaldo del archivo original
  cp $ARCHIVO_TARJETA $ARCHIVO_TARJETA-$(date "+%Y%m%d-%H%M%S")
done

if [ -e $ARCHIVO_TARJETA  ]; then
  # Lee el archivo con las variables de la tarjeta de red
  source $ARCHIVO_TARJETA
  echo "\n\n\n$UUID, $NAME\n\n\n"
else
  echo -ne "No se pudo obtener información!" >&2
  exit 1
fi

# Creamos el archivo de configuración del puente de red
# KVM requiere de un puente para la comunicación entre el host y guests.
cat <<FIN> /etc/sysconfig/network-scripts/ifcfg-br0
DEVICE=br0
TYPE=Bridge
IPADDR=192.168.1.X
PREFIX=24
GATEWAY=192.168.1.254
DNS1=8.8.8.8
BOOTPROTO=none
ONBOOT=yes
NM_CONTROLLED=no
DELAY=0
DEFROUTE=yes
NAME=br0
FIN

# Cambiamos el valor de la dirección IP del puente
sed -i "s/IPADDR=192\.168\.1\.X/IPADDR=`hostname -i | awk '{print $2}'`/g" /etc/sysconfig/network-scripts/ifcfg-br0

# Volcamos la información al archivo de configuración de la tarjeta de red
cat <<FIN> $ARCHIVO_TARJETA
DEVICE=ethX
TYPE=Ethernet
BOOTPROTO=none
NAME=ethX
UUID=00000000000
ONBOOT=yes
NM_CONTROLLED=no
BRIDGE=br0
FIN

# Cambiamos el valor del nombre
sed -i "s/NAME=ethX/NAME=${NAME}/g" $ARCHIVO_TARJETA

# Cambiamos el valor del dispositivo
sed -i "s/DEVICE=ethX/DEVICE=${DEVICE}/g" $ARCHIVO_TARJETA

# Cambiamos el valor de UUID
sed -i "s/UUID=00000000000/UUID=${UUID}/g" $ARCHIVO_TARJETA

# Reiniciamos el servicio de red
systemctl restart network

# Iniciamos el servicio de red al arrancar el equipo
systemctl enable network
