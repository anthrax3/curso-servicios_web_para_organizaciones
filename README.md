# Servicios Web para Organizaciones
## Requerimientos
Equipo 
- 100 G de Disco Duro disponibles
- Procesador con soporte de virtualizacion - ver artículo URL:
- Sistema Operativo CentOS con GUI
- Creación de usuario "administrador"
- Dirección IP 192.168.1.10


## Uso
#### Crea Llaves SSH
\# mkdir ~/.ssh

\# chmod 700 ~/.ssh

\# ssh-keygen -t rsa

\# ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.1.10

## Ejecuta el Script
\$ su -c "curl -sSL https://jdiazmx.github.io/curso-servicios_web_para_organizaciones/00-lab_servidor-principal.sh | bash"
