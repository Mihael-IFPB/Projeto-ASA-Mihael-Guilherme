#!/bin/bash

echo "### Iniciando checagem do ambiente do projeto ###"

# Função para exibir OK/FAIL
check_result() {
  if [ $1 -eq 0 ]; then
    echo "  [OK] $2"
  else
    echo "  [FAIL] $2"
  fi
}

echo
echo "1. Verificando hostname (deve conter 'mihael' e 'guilherme'):"
hostname | grep -i "mihael" &>/dev/null && hostname | grep -i "guilherme" &>/dev/null
check_result $? "Hostname válido: $(hostname)"

echo
echo "2. Verificando memória RAM mínima configurada:"
mem_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
mem_mb=$((mem_kb / 1024))
if [[ $mem_mb -ge 512 ]]; then
  echo "  [OK] Memória RAM: ${mem_mb}MB"
else
  echo "  [FAIL] Memória RAM insuficiente: ${mem_mb}MB"
fi

echo
echo "3. Verificando existência do grupo 'ifpb':"
getent group ifpb &>/dev/null
check_result $? "Grupo 'ifpb' existe"

echo
echo "4. Verificando existência dos usuários 'mihael' e 'guilherme':"
for user in mihael guilherme; do
  id "$user" &>/dev/null
  check_result $? "Usuário '$user' existe"
done

echo
echo "5. Verificando se usuários 'mihael' e 'guilherme' estão no grupo 'ifpb':"
for user in mihael guilherme; do
  id -nG "$user" | grep -qw ifpb
  check_result $? "Usuário '$user' pertence ao grupo 'ifpb'"
done

echo
echo "6. Verificando se sudo está configurado para grupo 'ifpb':"
sudo grep -q '^%ifpb' /etc/sudoers
check_result $? "Sudoers configurado para grupo 'ifpb'"

echo
echo "7. Verificando configuração SSH:"
# Root login proibido
grep -q "^PermitRootLogin no" /etc/ssh/sshd_config
check_result $? "SSH - root login proibido"

# Apenas autenticação com chave pública
grep -q "^PasswordAuthentication no" /etc/ssh/sshd_config
check_result $? "SSH - PasswordAuthentication desabilitado"

# Grupos permitidos (vagrant e ifpb)
grep -q "^AllowGroups vagrant ifpb" /etc/ssh/sshd_config
check_result $? "SSH - AllowGroups vagrant ifpb configurado"

# Banner configurado
grep -q "^Banner /etc/issue.net" /etc/ssh/sshd_config
check_result $? "SSH - Banner configurado"

echo
echo "8. Verificando serviço NTP (chrony) e fuso horário:"
systemctl is-active chrony &>/dev/null
check_result $? "Serviço chrony ativo"

timedatectl | grep "Time zone" | grep -q "America/Recife"
check_result $? "Fuso horário configurado para America/Recife"

echo
echo "9. Verificando instalação cliente NFS:"
dpkg -l | grep -qw nfs-common
check_result $? "Cliente NFS instalado"

echo
echo "10. Verificando servidor DHCP (apenas para 'arq'):"
if hostname | grep -q "arq"; then
  dpkg -l | grep -qw isc-dhcp-server
  check_result $? "DHCP server instalado"

  systemctl is-active isc-dhcp-server &>/dev/null
  check_result $? "DHCP server ativo"
fi

echo
echo "11. Verificando LVM e montagem em /dados (apenas para 'arq'):"
if hostname | grep -q "arq"; then
  vgdisplay dados &>/dev/null
  check_result $? "Volume Group 'dados' existe"

  lvdisplay /dev/dados/ifpb &>/dev/null
  check_result $? "Logical Volume 'ifpb' existe"

  mountpoint -q /dados
  check_result $? "/dados está montado"
fi

echo
echo "12. Verificando servidor NFS (apenas para 'arq'):"
if hostname | grep -q "arq"; then
  dpkg -l | grep -qw nfs-kernel-server
  check_result $? "Servidor NFS instalado"

  systemctl is-active nfs-kernel-server &>/dev/null
  check_result $? "Servidor NFS ativo"

  grep -q "/dados/nfs" /etc/exports
  check_result $? "Diretório /dados/nfs exportado via NFS"
fi

echo
echo "13. Verificando usuário nfs-ifpb (apenas para 'arq'):"
if hostname | grep -q "arq"; then
  id nfs-ifpb &>/dev/null
  check_result $? "Usuário nfs-ifpb existe"
fi

echo
echo "14. Verificando MariaDB e autofs (apenas para 'db'):"
if hostname | grep -q "db"; then
  dpkg -l | grep -qw mariadb-server
  check_result $? "MariaDB instalado"

  dpkg -l | grep -qw autofs
  check_result $? "Autofs instalado"

  systemctl is-active autofs &>/dev/null
  check_result $? "Autofs ativo"

  grep -q "/var/nfs" /etc/auto.master
  check_result $? "Autofs configurado para /var/nfs"
fi

echo
echo "15. Verificando Apache e autofs (apenas para 'app'):"
if hostname | grep -q "app"; then
  dpkg -l | grep -qw apache2
  check_result $? "Apache instalado"

  dpkg -l | grep -qw autofs
  check_result $? "Autofs instalado"

  systemctl is-active autofs &>/dev/null
  check_result $? "Autofs ativo"

  grep -q "/var/nfs" /etc/auto.master
  check_result $? "Autofs configurado para /var/nfs"

  if [ -f /var/www/html/index.html ]; then
    grep -q "Projeto Adminstraçao Sistemas Abertos" /var/www/html/index.html
    check_result $? "Arquivo index.html personalizado existe"
  else
    echo "  [FAIL] Arquivo index.html não encontrado"
  fi
fi

echo
echo "16. Verificando cliente 'cli':"
if hostname | grep -q "cli"; then
  dpkg -l | grep -qw firefox-esr
  check_result $? "Firefox instalado"

  dpkg -l | grep -qw xauth
  check_result $? "xauth instalado"

  grep -q "^X11Forwarding yes" /etc/ssh/sshd_config
  check_result $? "Encaminhamento X11 ativo no SSH"

  dpkg -l | grep -qw autofs
  check_result $? "Autofs instalado"

  grep -q "/var/nfs" /etc/auto.master
  check_result $? "Autofs configurado para /var/nfs"
fi

echo
echo "### Checagem finalizada ###"
