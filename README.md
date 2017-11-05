# Servicios Web para Organizaciones

## Requerimientos
Equipo con CentOS
- 100 G de Disco Duro
- Procesador con soporte de virtualizacion - ver artículo URL:

## Creación de Llaves SSH
- mkdir ~/.ssh
- chmod 700 ~/.ssh
- ssh-keygen -t rsa
- ssh-copy-id -i ~/.ssh/id_rsa.pub root@servidor-principal
