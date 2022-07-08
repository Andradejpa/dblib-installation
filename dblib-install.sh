#!/bin/bash
#Sistema que instala e configura o binário do DBLIB para conexão com o SQLSERVER
#Autor: João Pedro de Andrade

# Verificando o UID do usuário que executou o script para apenas ser executado por "ROOT"
if [ $UID -ne 0 ]; then

    # Se for diferente de 0, imprime mensagem de erro.
    echo "Requer privilégio de root."

    # Finaliando o script
    exit 1
fi

echo " _____    ______   _        _____  ______  
(____ \  (____  \ | |      (_____)(____  \ 
 _   \ \  ____)  )| |         _    ____)  )
| |   | ||  __  ( | |        | |  |  __  ( 
| |__/ / | |__)  )| |_____  _| |_ | |__)  )
|_____/  |______/ |_______)(_____)|______/ v0.1"

#Confirmação do usuário para execução do script.
echo "DBLIB Installation deseja continuar [Yn]"
read RESPONSE

#Interropendo Script em caso de negação
test "$RESPONSE" = "n" && exit

echo "Preparando diretório para download do binário..."

#Criando diretório para download do binário.
PATH_DOWNLOAD=$(pwd)
echo "#############################################################"
echo "Diretório para download do binário criado em: $PATH_DOWNLOAD "
echo "#############################################################"

#Realizando Download do 'freetds-0.95.95'
wget https://www.freetds.org/files/stable/freetds-0.95.95.tar.gz

#Decompactando binário baixado
echo "Descompactado o zip do binário baixado em $PATH_DOWNLOAD"
tar -zxf freetds-0.95.95.tar.gz

#Instalação unixodbc-dev
sudo apt-get install unixodbc unixodbc-dev gcc nano wget make

#Aplicando permissão recursiva no diretório baixado
chmod -R 777 freetds-0.95.95/
echo "Permissoes aplicadas"

#Entrando no diretório baixado
cd freetds-0.95.95/

#Instalano build-essential
sudo apt-get install build-essential

#Executando configuração do binário para DBLIB utilizando FreeTds
echo "Executando configuração do binário para instalação do Freetds"
sudo ./configure --with-tdsver=7.4 --with-unixodbc=/usr --disable-libiconv --disable-static --disable-threadsafe --enable-msdblib --disable-sspi --with-gnu-ld --enable-sybase-compat && make && make install
echo "#############################################################"
echo "Fim da instalação e configuração do binário."

#Visualilzação do binário compilado para o DBLIB juntamente com o caminho do arquivo freetds.conf
tsql -C

