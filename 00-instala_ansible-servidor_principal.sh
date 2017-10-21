#!/bin/bash -e
###############################################################################
# Script para la instalación de Ansible en Fedora o CentOS
# Nota: Se utiliza la opción -e en la llamada de bash para terminar en caso 
#       de obtener un valor diferente a "0" como resultado de la ejecución de 
#       los comandos del script.
#
# Autor: Jorge A. Díaz Lara - jorge@integraci.com / jorge.diaz@gmail.com
# Licencia: GPL Versión 2
###############################################################################

# Detección de usuario, se debe ejecutar como usuario root de lo contrario
# termina la ejecución.
if [[ $EUID -ne 0 ]]; then
    echo -ne "\nPor favor ejecuta el script como usuario \"root\".\n"
    echo -ne "puedes utilizar el comando \"su\":\n"
    echo -ne "$ su -c \"nombre_script.sh\"\n\n"
    exit 1
fi

if [ -e /etc/os-release ]; then

  # Lee el archivo con las variables de identificación de la distribución.
  # $ID, $VERSION_CODENAME, $VERSION_ID y $PRETTY_NAME
  source /etc/os-release
  dist=$ID

  # Ejecuta los comandos de acuerdo a la distribución identificada
  case "${dist}" in
    fedora)
      echo -ne "${dist}\n"
      dnf -y install ansible
      ;;
    centos)
      echo -ne "${dist}\n"
      yum -y install ansible
      ;;
    *)
      echo "La distribución \"$PRETTY_NAME\" no está soportada" >&2
      exit 1
      ;;
  esac
else
  echo "No se pudo obtener información!" >&2
  exit 1
fi
