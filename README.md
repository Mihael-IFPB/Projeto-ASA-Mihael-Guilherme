# Projeto-ASA-Mihael-Guilherme
Segundo repositorio criado para o projeto 01


# Projeto - Administração de Sistemas Abertos

## Integrantes

- **Mihael Reinaldo** — Matrícula: 20232380012  
- **Guilherme Manoel** — Matrícula: 20232380026  

## Disciplina

**Administração de Sistemas Abertos**  
Professor: *Leonidas Francisco de Lima Júnior*

---

##  Descrição do Projeto

Este projeto tem como objetivo a automatização da configuração de um ambiente de rede utilizando **Ansible** e **Vagrant**, com os seguintes componentes:

-  **Servidor `arq`**:
  - Servidor **DHCP**
  - Servidor **NFS**
  - Configuração de **discos com LVM**

- **Servidor `db`**:
  - Banco de dados **MariaDB**
  - Cliente NFS via `autofs`

-  **Servidor `app`**:
  - Servidor **Apache**
  - Página HTML personalizada
  - Cliente NFS via `autofs`

-  **Cliente `cli`**:
  - Cliente X11 com **Firefox**
  - Cliente NFS via `autofs`

- Todas as VMs possuem:
  - Sincronização de horário com o `chrony`
  - Segurança via chaves SSH
  - Grupo administrativo `ifpb` com permissões `sudo`

---

## Execução do Projeto

Siga os passos abaixo para executar o ambiente em sua máquina local:

### 1. Clone o repositório:

```bash
git clone https://github.com/usuario/repositorio-projeto.git
cd repositorio-projeto

### 2. Desative o DHCP padrão do VirtualBox:

```bash

vboxmanage dhcpserver stop --interface=vboxnet0


### 3. Suba a VM arq primeiro:

```bash

vagrant up arq


### 4.Suba as demais VMs:

```bash

   vagrant up app db cli

OBS: Como o final da minha matricula é 12 e a de guilherme é 6, iria ficar 26, só que esse é o final da matricula de guilherme, logo para não ter conflito nos IPs, colocamos a soma das nossas matriculas.
