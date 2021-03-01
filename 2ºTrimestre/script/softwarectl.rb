#!/usr/bin/env ruby

# scripting sin parámetros pidiendo la opción --help
orden = ARGV[0]

if erden.nil?
  puts "Usage:"
  puts "Usa el parámetro (--help) si necesitas ayuda"
  exit 1
end

# scripting pasando el parámetro --help
if orden == "--help"
  puts "Utilizando el parámetro --help"
  puts "Usage:
            systemctl [OPTIONS][FILENAME]"
  puts "Options:
            --help, mostrar esta ayuda.
            --version, mostrar información sobre el autor del script
                       y fecha de creación.
            --status FILENAME, comprueba si puede instalar/desinstalar.
            --run FILENAME, instala/desinstala el software indicado."
  puts "Description:
            Este script se encarga de instalar/desinstalar
            el software indicado en el fichero FILENAME.
            Ejemplo de FILENAME:
            tree:install
            nmap.install
            atomix:remove"
end

# scripting pasando el parámetro --version
if orden == "--version"
  puts "La autora de este script es CarmenMaría"
  system ("date")
end

# scripting pasando los parámetros --status FILENAME
app = ARGV[1]

if ARGV[0] == '--status'
  puts "[INFO]Entrando en la opción de status con el fichero #{ARGV[1]}"
  # indica si el paquete está instalado o no.
  a = `cat app.txt`
  b = a.split("\n")
  b.each do |i|
     c = i.split(":")
     i = `zypper info #{c[0]} |grep Instalado |grep Sí |wc -l`.chop
    if i == "1"
      puts "* Estado del paquete #{c[0]} (Instalado)"
    elsif i == "0"
      puts "* Estado del paquete #{c[0]} (No instalado)"
    end
  end
  exit
end

# scripting pasando los parámetros --run FILENAME
if orden == "--run"
  puts "Comprobar si eres el usuario root"
  usuario = `whoami`.chop
  if usuario != "root"
    puts "[ERROR] Tienes que ejecutar el script como root."
    exit 1
  end
  puts "[INFO] Entrando en la opción de run con el fichero #{ARGV[1]}"

  a =`cat app.txt`
  b = a.split("\n")
  b.each do |i|
    c = i.split(":")
    d = `zypper info #{c[0]} |grep Instalado |grep Sí |wc -l`.chop
    if d == "1" and c[1] == "install"
      puts "* Estado del paquete #{i}(Instalado)"
    elsif d == "1" and c[1] == "remove"
      system("zypper remove -y #{c[0]}")
    elsif d == "0" and c[1] == "install"
       system("zypper install -y #{c[0]}")
    elsif d == "0" and c[1] == "remove"
        puts "* Estado del paquete #{i}(No instalado)"
    end
  end
end

# FILENAME : /etc/home/carmenmaria/Documentos/scripting/app.txt
