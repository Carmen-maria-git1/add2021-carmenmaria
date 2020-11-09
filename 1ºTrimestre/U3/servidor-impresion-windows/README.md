# Servidor de Impresión en Windows

Necesitaremos 2 MV:

-Instalé : MV windows server 16

_Instalé : MV windows 10 pro


#  1. Impresora compartida

##    1.1 Rol impresión

        Vamos al servidor
        Instalar rol/función de servidor de impresión. Incluir impresión por Internet.

        DUDA: Instalar rol/función de cliente de impresión por Internet.

        **MV1: Windows Server**

![1](./images/Cap1.png)
![2](./images/Cap2.png)

    He creado una máquina servidor dns y con servicios de impresión entre otros. para poder conectar la mv cliente con este dominio.

    hostname: **server12w**

    netbios: **ADD2021**

    servidor dns: **ADD2021Carmen.Maria**

    IP de clase: 172.19.12.30

    IP de casa: 192.168.8.130

        **MV2: Windows 10 cliente**

        Agregé esta MV **cliente12w1** al servidor DNS con una IP fija y el servidor dns con la IP de este servidor server12w.
        Con el usuario **carmenmaria**


![3](./images/Cap3.png)  

##    1.2 Instalar impresora PDF

    Vamos a conectar e instalar localmente una impresora al servidor Windows Server, de modo que estén disponibles para ser accedidas por los clientes del dominio.

    En nuestro caso, dado que es posible de que no tengan una impresora física en casa y no es de mucho interés forzar la instalación de una impresora que no se tiene, vamos a instalar un programa que simule una impresora de PDF.

    PDFCreator es una utilidad completamente gratuita con la que podrás crear archivos PDF desde cualquier aplicación, desde el Bloc de notas hasta Word, Excel, etc. Este programa funciona simulando ser una impresora, de esta forma, instalando PDFCreator todas tus aplicaciones con opción para imprimir te permitirán crear archivos PDF en cuestión de segundos.

    -Descargar PDFCreator (URL recomendada www.pdfforge.org/pdfcreator/download) e instalar.

![4](./images/Cap4.png)  

    -En PDFCreator, configurar en perfiles -> Guardar -> Automático. Ahí establecemos la carpeta destino.

![5](./images/Cap5.png)

#    1.3 Probar la impresora en local

    Para crear un archivo PDF no hará falta que cambies la aplicación que estés usando, simplemente ve a la opción de imprimir y selecciona "Impresora PDF", en segundos tendrás creado tu archivo PDF.

    Puedes probar la nueva impresora abriendo el Bloc de notas y creando un fichero luego selecciona imprimir. Cuando finalice el proceso se abrirá un fichero PDF con el resultado de la impresión.

        -Probar la impresora remota imprimiendo documento imprimirXXs-local.
![6](./images/Cap6.png)
![7](./images/Cap7.png)


#        2. Compartir por red
##      2.1 En el servidor

      Vamos a la MV del servidor.

          -Ir al Administrador de Impresión -> Impresoras

          -Elegir impresora PDFCreator.

              *Botón derecho -> Propiedades -> Compartir

              *Como nombre del recurso compartido utilizar PDFnombrealumnoXX.

              **PDFCarmenMaria12**

![8](./images/Cap8.png)          

##      2.2 Comprobar desde el cliente

      Vamos al cliente:

          -Buscar recursos de red del servidor. Si tarda en aparecer ponemos \\ip-del-servidor **IP del servidor de clase 172.19.12.30** en la barra de navegación.

          -Seleccionar impresora -> botón derecho -> conectar.

              *Ponemos usuario/clave del Windows Server.

          -Ya tenemos la impresora remota configurada en el cliente.

![9](./images/Cap9.png)        

          -Probar la impresora remota imprimiendo documento imprimirXXw-remoto.

![10](./images/Cap10.png)

![11](./images/Cap11.png)  

#          3. Acceso Web

          Realizaremos una configuración para habilitar el acceso web a las impresoras del dominio.
##          3.1 Instalar característica impresión WEB

              -Vamos al servidor.

              -Nos aseguramos de tener instalado el servicio "Impresión de Internet".

##          3.2 Configurar impresión WEB

          En este apartado vamos a volver a agregar la impresora de red remota en el cliente, pero usando otra forma diferente de localizar la impresora.

          Vamos a la MV cliente:

              -Abrimos un navegador Web.

              -Ponemos URL http://<ip-del-servidor>/printers (o http://<nombre-del-servidor>/printers) para que aparezca en nuestro navegador un entorno que permite gestionar las impresoras de dicho equipo, previa autenticación como uno de los usuarios del habilitados para dicho fin (por ejemplo el "Administrador").


              -Pincha en la opción propiedades y captura lo que se ve. Apuntar el URL asociado al nombre de red de la impresora para usarlo más adelante.

              **Http://172.19.12.30/printers/PDFCarmenMaria/.printer**

![12](./images/Capt12.png)            

              -Agregar impresora (NO es local)

              -Crear nueva impresora usando el URL nombre de red de la impresora anterior.

![14](./images/Cap14.png)  

![15](./images/Cap15.png)

![16](./images/Cap16.png)            


##          3.3 Comprobar desde el navegador

Vamos a realizar seguidamente una prueba sencilla en tu impresora de red:

-Accede a la configuración de la impresora a través del navegador.

    *Poner en pausa los trabajos de impresión de la impresora.

![17](./images/Cap17.png)  

-Ir a MV cliente.

-Probar la impresora remota imprimiendo documento imprimirXXw-web.

    *Comprobar que al estar la impresora en pausa, el trabajo aparece en cola de impresión.

![18](./images/Cap18.png)  

-Finalmente pulsa en reanudar el trabajo para que tu documento se convierta a PDF.

-Si tenemos problemas para que aparezca el PDF en el servidor, iniciar el programa PDFCreator y esperar un poco.

![19](./images/Cap19.png)
