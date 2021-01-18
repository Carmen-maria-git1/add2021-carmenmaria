# 1. Contenedores con Docker
Teoria:

Es muy común que nos encontremos desarrollando una aplicación, y llegue el momento que decidamos tomar todos sus archivos y migrarlos, ya sea al ambiente de producción, de prueba, o simplemente probar su comportamiento en diferentes plataformas y servicios.

Para situaciones de este estilo existen herramientas que, entre otras cosas, nos facilitan el embalaje y despliegue de la aplicación, es aquí donde entra en juego los contenedores (Por ejemplo Docker o Podman).

Esta herramienta nos permite crear "contenedores", que son aplicaciones empaquetadas auto-suficientes, muy livianas, capaces de funcionar en prácticamente cualquier ambiente, ya que tiene su propio sistema de archivos, librerías, terminal, etc.

Docker es una tecnología contenedor de aplicaciones construida sobre LXC.
## 1.1 Instalación

Ejecutar como superusuario:

**•	zypper in docker**, instalar docker en OpenSUSE (apt install docker en Debian/Ubuntu).

**•	systemctl start docker**, iniciar el servicio. NOTA: El comando docker daemon hace el mismo efecto.

**•	systemctl enable docker**, si queremos que el servicio de inicie automáticamente al encender la máquina.

![1](./images/Cap1.png)

•	IMPORTANTE: Incluir a nuestro usuario (nombre-del-alumno) como miembro del grupo docker. Solamente los usuarios dentro del grupo docker tendrán permiso para usarlo.

**cat /etc/group**

**usermod -a -G docker carmenmaria**

![2](./images/Cap2.png)
Iniciar sesión como usuario normal.

•	docker version, comprobamos que se muestra la información de las versiones cliente y servidor.

•	OJO: A partir de ahora todo lo haremos con nuestro usuario, sin usar sudo.

## 1.2 Habilitar el acceso a la red externa a los contenedores

Si queremos que nuestro contenedor tenga acceso a la red exterior, debemos activar tener activada la opción IP_FORWARD (net.ipv4.ip_forward). ¿Recuerdas lo que implica forwarding en los dispositivos de red?

•	cat /proc/sys/net/ipv4/ip_forward para consultar el estado de IP_FORWARD (desactivado=0, activo=1). Para activarlo podemos hacerlo de diversas formas:

o	Poner el valor 1 en el fichero de texto indicado.

o	O ejecutar el siguiente comando sysctl -w net.ipv4.ip_forward=1

o	También podemos crear el fichero /etc/sysctl.d/alumnoXX.conf y poner dentro lo siguiente:

•	## Configuración para docker de alumnoXX

•	net.ipv4.ip_forward = 1

•	También podemos Usar YAST para activar IP_FORWARD:

Sistema operativo	Activar "forwarding"
OpenSUSE Leap (configuración de red es Wicked)	Yast -> Dispositivos de red -> Encaminamiento -> Habilitar reenvío IPv4
Cuando la red está gestionada por Network Manager	En lugar de usar YaST debemos editar el fichero "/etc/sysconfig/SuSEfirewall2" y poner FW_ROUTE="yes"
OpenSUSE Tumbleweed	Yast -> Sistema -> Configuración de red -> Menú de encaminamiento

![3](./images/Cap3.png)

•	Reiniciar el equipo para que se aplique el cambio de configuración anterior.

## 1.3 Primera prueba

•	docker run hello-world, este comando hace lo siguiente:

o	Descarga una imagen "hello-world"

o	Crea un contenedor y

o	ejecuta la aplicación que hay dentro.

![3-1](./images/Cap3-1.png)

•	docker images, ahora vemos la nueva imagen "hello-world" descargada en nuestro equipo local.

•	docker ps -a, vemos que hay un contenedor en estado 'Exited'.

![4](./images/Cap4.png)

•	docker stop IDContainer, parar el conteneder.

•	docker rm IDContainer,
eliminar el contenedor.

![5](./images/Cap5.png)

## 1.4 Sólo para LEER

Veamos un poco de teoría.
Tabla de referencia para no perderse:

Software|	Base|	Sirve para crear	Aplicaciones

VirtualBox|	ISO|	Máquinas virtuales	N

Vagrant|	Box|	Máquinas virtuales	N

Docker|	Imagen|	Contenedores	1

Comandos útiles de Docker:

Comando  |   Descripción

docker stop CONTAINERID =>	Parar un contenedor

docker start CONTAINERID => Iniciar un contenedor

docker attach CONTAINERID =>	Conectar el terminal actual con el contenedor

docker ps => 	mostrar los contenedores en ejecución

docker ps -a =>	mostrar todos los contenedores (en ejecución o no)

docker rm CONTAINERID => 	Eliminar un contenedor

docker rmi IMAGENAME => 	Eliminar una imagen

## 1.5 Alias
Para ayudarnos a trabajar de forma más rápida con la línea de comandos podemos agregar los siguientes alias al fichero /home/nombre-alumno/.alias:

alias di='docker images'

alias dp='docker ps'

alias dpa='docker ps -a'

alias drm='docker rm '

alias drmi='docker rmi '

alias ds='docker stop '

![6](./images/Cap6.png)



# 2. Creación manual de nuestra imagen

Nuestro SO base es OpenSUSE, pero vamos a crear un contenedor Debian, y dentro instalaremos Nginx.

## 2.1 Crear un contenedor manualmente

Descargar una imagen

•	**docker search debian**, buscamos en los repositorios de Docker Hub contenedores con la etiqueta debian.

•	**docker pull debian**, descargamos una imagen en local.

•	**docker images**, comprobamos.

![7](./images/Cap7.png)

### Crear un contenedor:

 Vamos a crear un contenedor con nombre app1debian a partir de la imagen debian, y ejecutaremos el programa /bin/bash dentro del contendor:

•	**docker run --name=app1debian -i -t debian /bin/bash**

![8](./images/Cap8.png)

## 2.2 Personalizar el contenedor

Ahora estamos dentro del contenedor, y vamos a personalizarlo a nuestro gusto:

**Instalar aplicaciones dentro del contenedor**

root@IDContenedor:/# cat /etc/motd            # Comprobamos que estamos en Debian

root@IDContenedor:/# apt-get update

root@IDContenedor:/# apt-get install -y nginx # Instalamos nginx en el contenedor

![9](./images/Cap9.png)

root@IDContenedor:/# apt-get install -y vim   # Instalamos editor vi en el contenedor

Utilisé el editor nano en lugar de vim.

![10](./images/Cap10.png)

**Crear un fichero HTML** holamundo1.html.

root@IDContenedor:/# echo "<p>Hola nombre-del-alumno</p>" > /var/www/html/holamundo1.html

**Crear un script**  /root/server.sh con el siguiente contenido:
#!/bin/bash
echo "Booting Nginx!"
/usr/sbin/nginx &

echo "Waiting..."
while(true) do
  sleep 60
done

![11](./images/Cap11.png)

Para volver a acceder al contenedor una vez hemos salido o serrado la terminal usamos los comandos:

**docker start app1debian**

**docker attach app1debian**

![12](./images/Cap12.png)

![13](./images/Cap13.png)

Recordatorio:

•	Hay que poner permisos de ejecución al script para que se pueda ejecutar.

Utilizaremos: **chmod 775 server.sh**

Con **ls -la server.sh** vemos los permisos concedidos.

![15](./images/Cap15.png)

•	La primera línea de un script, siempre debe comenzar por #!/, sin espacios.

![14](./images/Cap14.png)

•	Este script inicia el programa/servicio y entra en un bucle, para mantener el contenedor activo y que no se cierre al terminar la aplicación.

## 2.3 Crear una imagen a partir del contenedor

Ya tenemos nuestro contenedor auto-suficiente de Nginx, ahora debemos vamos a crear una nueva imagen que incluya los cambios que hemos hecho.

•	Abrir otra ventana de terminal.

•	docker commit app1debian nombre-del-alumno/nginx1, a partir del CONTAINERID vamos a crear la nueva imagen que se llamará "nombre-del-alumno/nginx1".

![16](./images/Cap16.png)

NOTA:

•	Los estándares de Docker estipulan que los nombres de las imágenes deben seguir el formato nombreusuario/nombreimagen.

•	Todo cambio realizado que se acompañe de un commit a la imagen, se perderá en cuanto se cierre el contenedor.

•	docker images, comprobamos que se ha creado la nueva imagen.

•	Ahora podemos parar el contenedor, docker stop app1debian y

•	Eliminar el contenedor, docker rm app1debian.

![17](./images/Cap17.png)

# 3. Crear contenedor a partir de nuestra imagen

## 3.1 Crear contenedor con Nginx

Ya tenemos una imagen "dvarrui/nginx" con Nginx instalado.

•	docker run --name=app2nginx1 -p 80 -t dvarrui/nginx1 /root/server.sh, iniciar el contenedor a partir de la imagen anterior.

>Nota: volví a repetir el paso 2 completo pues en el script hubo un fallo de escritura , borré el app2nginx1 pero me sigue saliendo, y creé el app2nginx11.

![18](./images/Cap18.png)

El argumento -p 80 le indica a Docker que debe mapear el puerto especificado del contenedor, en nuestro caso el puerto 80 es el puerto por defecto sobre el cual se levanta Nginx.

## 3.2 Comprobamos

•	Abrimos una nueva terminal.

•	docker ps, nos muestra los contenedores en ejecución. Podemos apreciar que la última columna nos indica que el puerto 80 del contenedor está redireccionado a un puerto local 0.0.0.0.:PORT -> 80/tcp.

![19](./images/Cap19.png)

•	Abrir navegador web y poner URL 0.0.0.0.:PORT.
 De esta forma nos conectaremos con el servidor Nginx que se está ejecutando dentro del contenedor.

![20](./images/Cap20.png)

•	Comprobar el acceso a holamundo1.html.

![21](./images/Cap21.png)

•	Paramos el contenedor app2nginx1 y lo eliminamos.

**docker stop app2nginx1**

**docker rm app2nginx1**

![22](./images/Cap22.png)

Como ya tenemos una imagen docker con Nginx (Servidor Web), podremos crear nuevos contenedores cuando lo necesitemos.

## 3.3 Migrar la imagen a otra máquina

¿Cómo puedo llevar los contenedores Docker a un nuevo servidor?

Exportar imagen Docker a fichero tar:

•	docker save -o alumnoXXdocker.tar nombre-alumno/nginx1, guardamos la imagen "nombre-alumno/nginx1" en un fichero tar.

![23](./images/Cap23.png)

Intercambiar nuestra imagen exportada con la de un compañero de clase.

Importar imagen Docker desde fichero:

•	Coger la imagen de un compañero de clase.

•	Nos llevamos el tar a otra máquina con docker instalado, y restauramos.

•	docker load -i alumnoXXdocker.tar,

*  docker load -i /home/carmenmaria/descargas/diego14docker.tar

 cargamos la imagen docker a partir del fichero tar.
 Cuando se importa una imagen se muestra en pantalla las capas que tiene. Las capas las veremos en un momento.

![21-1](./images/Cap21-1.png)
•	docker images, comprobamos que la nueva imagen está disponible.

![21-2](./images/Cap21-2.png)

>NOTA: Creé este contenedor después lo paré y lo borré para crearlo con el fichero server.sh

*  docker run --name=app3carmenmaria -p 80 -t diego/nginx1

*  docker stop app3carmenmaria

*  docker rm app3carmenmaria

•	Probar a crear un contenedor (app3alumno), a partir de la nueva imagen.

* docker run --name=app3carmenmaria -p 80 -t diego/nginx1 /root/server.sh

*  En otra terminal: docker ps

Vemos la imagen, el contenedor creado y el puerto de acceso, entre otras cosas.

*  URL:  localhost:32769/



![21-3](./images/Cap21-3.png)

## 3.4 Capas

Teoría sobre las capas. Las imágenes de docker están creadas a partir de capas que van definidas en el fichero Dockerfile. Una de las ventajas de este sistema es que esas capas son cacheadas y se pueden compartir entre distintas imágenes, esto es que si por ejemplo la creación de nuestra imagen consta de 10 capas, y modificamos una de esas capas, a la hora de volver a construir la imagen solo se debe ejecutar esta nueva capa, el resto permanecen igual.

Estas capas a parte de ahorrarnos peticiones de red al bajarnos una nueva versión de una imagen también ahorra espacio en disco, ya que las capas que no se hayan cambiado entre versiones no se descargarán.

•	docker image history nombre_imagen:version, para consultar las capas de la imagen del compañero.

*  docker image history diego/ngnix1:latest

![21-4](./images/Cap21-4.png)

# 4. Dockerfile

Ahora vamos a conseguir el mismo resultado del apartado anterior, pero usando un fichero de configuración. Esto es, vamos a crear un contenedor a partir de un fichero Dockerfile.

## 4.1 Preparar ficheros

•	Crear directorio /home/nombre-alumno/dockerXXa.

•	Entrar el directorio anterior.

•	Crear fichero holamundo2.html con:
o	Proyecto: dockerXXa
o	Autor: Nombre del alumno
o	Fecha: Fecha actual

![24](./images/Cap24.png)

•	Crear el fichero Dockerfile con el siguiente contenido:
FROM debian

MAINTAINER nombre-del-alumnoXX 1.0

RUN apt-get update
RUN apt-get install -y apt-utils
RUN apt-get install -y nginx

COPY holamundo2.html /var/www/html
RUN chmod 666 /var/www/html/holamundo2.html

EXPOSE 80

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]

![25](./images/Cap25.png)

## 4.2 Crear imagen a partir del Dockerfile

El fichero Dockerfile contiene toda la información necesaria para construir el contenedor, veamos:

•	cd dockerXXa, entramos al directorio con el Dockerfile.

•	docker build -t nombre-alumno/nginx2 ., construye una nueva imagen a partir del Dockerfile. OJO: el punto final es necesario.

•	docker images, ahora debe aparecer nuestra nueva imagen.
![26](./images/Cap26.png)

![27](./images/Cap27.png)

## 4.3 Crear contenedor y comprobar

A continuación vamos a crear un contenedor con el nombre app4nginx2, a partir de la imagen nombre-alumno/nginx2. Probaremos con:

docker run --name=app4nginx2 -p 8082:80 -t nombre-alumno/nginx2

![28](./images/Cap28.png)

Desde otra terminal:

•	docker ps, para comprobar que el contenedor está en ejecución y en escucha por el puerto deseado.

•	Comprobar en el navegador:

o	URL http://localhost:PORTNUMBER

![28-1](./images/Cap28-1.png)

o	URL http://localhost:PORTNUMBER/holamundo2.html

![29](./images/Cap29.png)

Ahora que sabemos usar los ficheros Dockerfile, nos damos cuenta que es más sencillo usar estos ficheros para intercambiar con nuestros compañeros que las herramientas de exportar/importar que usamos anteriormente.

## 4.4 Usar imágenes ya creadas
El ejemplo anterior donde creábamos una imagen Docker con Nginx se puede simplificar aún más aprovechando imágenes oficiales que ya existen.
Enlace de interés:

•	[nginx - Docker Official Images] https://hub.docker.com/_/nginx

•	Crea el directorio dockerXXb. Entrar al directorio


•	Crear fichero holamundo3.html con:
o	Proyecto: dockerXXb
o	Autor: Nombre del alumno
o	Fecha: Fecha actual

![30](./images/Cap30.png)

•	Crea el siguiente Dockerfile
FROM nginx

COPY holamundo3.html /usr/share/nginx/html
RUN chmod 666 /usr/share/nginx/html/holamundo3.html

![31](./images/Cap31.png)

•	Poner el el directorio dockerXXb los ficheros que se requieran para construir el contenedor.

•	docker build -t nombre-alumno/nginx3 ., crear la imagen.

![32](./images/Cap32.png)

•	docker run --name=app5nginx3 -d -p 8083:80 nombre-alumno/nginx3, crear contenedor.

![33](./images/Cap33.png)

•	Comprobar el acceso a "holamundo3.html".

![34](./images/Cap34.png)

docker stop app4nginx2

docker stop app5nginx3

![35](./images/Cap35.png)

#	5. Docker Hub

Ahora vamos a crear un contenedor "hola mundo" y subirlo a Docker Hub.

*  Crear carpeta dockerXXc. Entrar en la carpeta.


![29-1](./images/Cap29-1.png)

*  Crear un script (holamundoXX.sh) con lo siguiente:

#!/bin/sh

echo "Hola Mundo!"

echo "nombre-del-alumnoXX"

echo "Proyecto dockerXXc"

date

![36](./images/Cap36.png)

Este script muestra varios mensajes por pantalla al ejecutarse.

*  Crear fichero Dockerfile

FROM busybox

MAINTAINER nombre-del-alumnoXX 1.0

COPY holamundoXX.sh /root

RUN chmod 755 /root
/holamundoXX.sh

CMD ["/root/holamundoXX.sh"]

![37](./images/Cap37.png)

*  A partir del Dockerfile anterior crearemos la imagen nombre-alumno/holamundo.

**docker build -t carmenmaria/holamundo .**
 => crea la imagen.

*  Comprobar que docker run nombre-alumno/holamundo se crea un contenedor que ejecuta el script.

**docker run carmenmaria/holamundo**

![38](./images/Cap38.png)

### 5.1. Subir la imagen a Docker Hub:

*  Registrarse en Docker Hub.
 *    Se crea una cuenta en docker hub
 -usuario: **carmenmary**
 -correo: carmenmaria1973modista@gmail.com
 -contraseña: carmenmary

*  docker login -u USUARIO-DOCKER, para abrir la conexión.

 USUARIO-DOCKER => carmenmary

**docker login -u carmenmary**

*  docker tag nombre-alumno/holamundo:latest USUARIO-DOCKER/holamundo:version1, etiquetamos la imagen con "version1".

**docker tag carmenmaria/holamundo:latest carmenmary/holamundo:version1**

*  docker push USUARIO-DOCKER/holamundo:version1, para subir la imagen (version1) a los repositorios de Docker.

**docker push carmenmary/holamundo:version1**

![39](./images/Cap39.png)

![40](./images/Cap40.png)

# 6. Limpiar contenedores e imágenes

Cuando terminamos con los contenedores, y ya no lo necesitamos, es buena idea pararlos y/o destruirlos.

•	docker ps -a, identificar todos los contenedores que tenemos.

•	docker stop ..., parar todos los contenedores.

•	docker rm ..., eliminar los contenedores.

![41](./images/Cap41.png)

Hacemos lo mismo con las imágenes. Como ya no las necesitamos las eliminamos:

•	docker images, identificar todas las imágenes.

![42](./images/Cap42.png)

•	docker rmi ..., eliminar las imágenes.

![43](./images/Cap43.png)
