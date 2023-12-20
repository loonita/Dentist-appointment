# Clinica dental San Antonio

Software diseñado para apoyar la gestión administrativa en la Clínica Dental San Antonio en Talca


### Instalación
#Ubuntu 20.04

habilitar modo super-user
```bash
sudo su
```

Actualizar paquetes
```bash
apt-get update -y && apt-get upgrade -y
```

Actualizar GNU Privacy Guard
```bash
apt-get install gnupg2
```

Instalar Curl
```bash
apt-get install curl
```

Instalar NodeJS
```bash
curl -sL https://deb.nodesource.com/setup_16.x -o /tmp/nodesource_setup.sh
sudo bash /tmp/nodesource_setup.sh
sudo apt-get install -y nodejs
```

Instalar Yarn
```bash
npm install -g yarn
```
Ejecutar los siguientes comandos sin super-user a menos que se especifique
Descargar e instalar el Gestor de Versiones de Ruby (RVM). Reemplazar <username> con tu nombre de usuario de Unix
```bash
command curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -
\curl -sSL https://get.rvm.io | bash -s stable
source /home/<username>/.rvm/scripts/rvm
```

Install Ruby 3.2.2 via RVM.
```bash
rvm install 3.2.2
```

Instalar Git
```bash
sudo apt-get install git -y
```
Clona este repositorio en tu máquina y navega hacia él
```bash
git clone https://github.com/loonita/Dentist-appointment
cd Dentist-appointment
```

instalar libpq or postgresql
```bash
sudo apt install libpq-dev
```

Asegurar de que Bundler esté instalado
```bash
gem install bundler
bundler install
```
Descargar y instalar dependencias de Ruby
```bash
bundler install
```

Correr yarn install tareas
```bash
yarn install
yarn build
yarn build:css
```
Base de datos
Configurar base de datos
```bash
cd config
nano database.yml
rails s -b 0.0.0.0 -p 80v
```


