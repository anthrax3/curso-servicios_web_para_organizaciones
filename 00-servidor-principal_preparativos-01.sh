#!/bin/bash -e
###############################################################################
# Nombre: 00-servidor-principal_preparativos-01.sh
# Descripción: Script para la instalación de lo necesario para el el servidor
#              principal del estudiante.
#
# Nota: Se utiliza la opción -e en la llamada de bash para terminar en caso 
#       de obtener un valor diferente a "0" como resultado de la ejecución de 
#       los comandos del script.
#
# Autor: Jorge A. Díaz Lara - jorge@integraci.com / jorge.diaz@gmail.com
# Licencia: GPL Versión 2
###############################################################################

# Limpiamos pantalla
clear

echo -ne "\n###############################################################################"
echo -ne "\n# Servicios Web para Organizaciones                                           #"
echo -ne "\n# Instalación de git, ansible y wget en equipos y CentOS.                     #"
echo -ne "\n# Instalación de git, ansible y openssh para equipos con Fedora.              #"
echo -ne "\n#                                                                             #"
echo -ne "\n# Integra Conocimiento e Innovación - http://integraci.com.mx                 #"
echo -ne "\n#                                     contacto@integraci.com.mx               #"
echo -ne "\n###############################################################################\n\n"

# Detección de usuario, se debe ejecutar como usuario root (Usuario "0") de lo contrario
# termina la ejecución.
if [[ $EUID -ne 0 ]]; then
    echo -ne "\nPor favor ejecuta el script como usuario \"root\".\n"
    echo -ne "puedes utilizar el comando \"su\":\n"
    echo -ne "$ su -c \"00-instala_ansible-servidor_principal.sh\"\n\n"
    exit 1
fi

# En caso de existir el archvio "os-release"
if [ -e /etc/os-release ]; then

  # Lee el archivo con las variables de identificación de la distribución.
  # $ID, $VERSION_CODENAME, $VERSION_ID y $PRETTY_NAME
  source /etc/os-release
  
  # Asigna el valor de la variable ID del sistema obtenida mediante el comando source, 
  # a la variable del "DISTRIBUCION" script
  DISTRIBUCION=$ID

  echo -ne "Distribución: $PRETTY_NAME\n\n"

  # Compara el valor de la variable DISTRIBUCION y ejecuta los comandos de acuerdo a 
  # la distribución.
  case "${DISTRIBUCION}" in
    fedora)
      # Instalación Git
      dnf -y install git

      # Instalación de Ansible
      dnf -y install ansible
      
      # Instalación de libreria para módulo firewalld de Ansible
      dnf -y install python-firewall
      
      # Instalación de OpenSSH
      dnf -y install openssh-server
      
      # Iniciao del servicio SSH
      systemctl start sshd.service
      
      # Ejecución del servicio SSH al arrancar el equipo
      systemctl enable sshd.service
      
      # Se añade el servicio de SSH a las reglas del Firewall
      firewall-cmd --add-service=ssh --permanent
      
      # Recarga de reglas del Firewall
      firewall-cmd --reload
      ;;
    centos)
      # Instalación de wget
      yum -y install wget
      
      # Instalación de Git
      yum -y install git
      
      # Instalación de Ansible
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
