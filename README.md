# Clinica Dental San Antonio

Software diseñado para apoyar la gestión administrativa en la Clínica Dental San Antonio en Talca

## Construido con
- [Ruby 3.2.2](https://www.ruby-lang.org/en/) - Lenguaje de programación
- [Ruby on Rails 6.1.4](https://rubyonrails.org/) - Framework de desarrollo
- [PostgreSQL](https://www.postgresql.org/) - Base de datos
- [Bootstrap 5](https://getbootstrap.com/) - Framework de diseño
- [Yarn](https://yarnpkg.com/) - Manejador de dependencias
- [NodeJS](https://nodejs.org/es/) - Entorno de ejecución para JavaScript
- [Git](https://git-scm.com/) - Control de versiones

### Instalación
### Ubuntu 20.04

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
## Ejecutar los siguientes comandos sin super-user a menos que se especifique
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

instalar libpq o postgresql
```bash
sudo apt install libpq-dev
```

Asegurar de que Bundler esté instalado
```bash
gem install bundler
```
Descargar y instalar dependencias de Ruby
```bash
bundler install
```

Correr yarn install tareas
```bash
yarn install
```
Configurar la Base de datos
Ir a  la carpeta config
```bash
cd config
```
Luego entrar a database.yml
```bash
nano database.yml
```
Este proyecto viene configurado para utilizar variables de entorno para conectarse a una base de datos, como puede verse a continuación:
```yml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  host: <%= ENV['POSTGRES_HOST'] %>
  port: 5432

development:
  <<: *default
  database: <%= ENV['POSTGRES_DB'] %>
  username: <%= ENV['POSTGRES_USER'] %>
  password: <%= ENV['POSTGRES_PASSWORD'] %>

test:
  <<: *default
  database: <%= ENV['POSTGRES_DB'] %>
  username: <%= ENV['POSTGRES_USER'] %>
  password: <%= ENV['POSTGRES_PASSWORD'] %>

production:
  <<: *default
  database: <%= ENV['POSTGRES_DB'] %>
  username: <%= ENV['POSTGRES_USER'] %>
  password: <%= ENV['POSTGRES_PASSWORD'] %>
```

Declarar variables de entorno:
```bash
nano .env
```
Según como se haya configurado la base de datos, y el entorno en el que se desea hacer funcionar el proyecto, definir la siguientes variables de entorno:
```
RAILS_ENV=
POSTGRES_HOST=
POSTGRES_DB=
POSTGRES_USER=
POSTGRES_PASSWORD=
```
Ingresar el siguiente comando para iniciar la aplicación
```bash
rails s -b 0.0.0.0 -p 80
```




