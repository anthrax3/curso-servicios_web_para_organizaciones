# Servicios Web para Organizaciones
## Requerimientos
Equipo 
- 100 G de Disco Duro disponibles
- Procesador con soporte de virtualizacion - ver artículo URL:
- Sistema Operativo CentOS con GUI


## Crea la llave de SSH del servidor
- mkdir ~/.ssh
- chmod 700 ~/.ssh
- ssh-keygen -t rsa
- ssh-copy-id -i ~/.ssh/id_rsa.pub root@localhost
