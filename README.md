Necessário para rodar:

Haskell Stack -> https://docs.haskellstack.org/en/stable/README/

postgresql -> https://www.postgresql.org/

* Simplificando, basta execultar os seguintes comandos em um terminal:
$ curl -sSL https://get.haskellstack.org/ | sh
$ sudo apt-get update
$ sudo apt-get install postgresql postgresql-contrib
$ sudo apt-get install libpq-dev

Para executar o programa, navegue ate a o diretório 

tcc-fuba/fuba/

e execute os comandos a seguir:

$ stack build

$ stack exec fuba

Será iniciado um servidor e o sistema poderá ser acessado através de 
um navegador no endereço 127.0.0.1:5432