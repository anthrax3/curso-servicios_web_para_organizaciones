#!/bin/bash -e
###############################################################################
# Nombre: 00-instala_ansible-servidor_principal.sh
# Descripción: Script para la instalación de Ansible en Fedora o CentOS
#
# Nota: Se utiliza la opción -e en la llamada de bash para terminar en caso 
#       de obtener un valor diferente a "0" como resultado de la ejecución de 
#       los comandos del script.
#
# Autor: Jorge A. Díaz Lara - jorge@integraci.com / jorge.diaz@gmail.com
# Licencia: GPL Versión 2
###############################################################################
echo -ne "\n###############################################################################"
echo -ne "\n# Servicios Web para Organizaciones                                           #"
echo -ne "\n# Instalación de Git y Ansible en equipos Fedora y CentOS                     #"
echo -ne "\n# Instalación de SSH para equipos con Fedora                                  #"
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

if [ -e /etc/os-release ]; then

  # Lee el archivo con las variables de identificación de la distribución.
  # $ID, $VERSION_CODENAME, $VERSION_ID y $PRETTY_NAME
  source /etc/os-release
  dist=$ID

  echo -ne "Distribución: $PRETTY_NAME\n\n"

  # Ejecuta los comandos de acuerdo a la distribución identificada
  case "${dist}" in
    fedora)
      dnf -y install git
      dnf -y install ansible
      dnf -y install openssh-server
      systemctl start sshd.service
      systemctl enable sshd.service
      ;;
    centos)
      yum -y install git
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
