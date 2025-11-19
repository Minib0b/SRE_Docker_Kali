# 💻 Entorno de Análisis Forense de Redes (Clase)

Este repositorio contiene la configuración mínima para desplegar un entorno de trabajo forense basado en **Kali Linux** dentro de un contenedor Docker, utilizando un escritorio remoto (XRDP).

El entorno está optimizado para la **ejecución de pruebas de red** ya que comparte la pila de red de la máquina anfitriona (modo `host`).

---

## 🚀 Inicio Rápido

Sigue estos pasos en orden para construir la imagen e iniciar el contenedor.

### Paso 1: Requisitos Previos

Asegúrate de tener instalado y en funcionamiento:

#### En la máquina del laboratorio

1.  **Docker Engine:** Para construir y ejecutar contenedores: `sudo snap install docker `.
3.  **Permisos de `sudo`:** Todos los comandos de Docker y el script de inicio requieren permisos de administrador (_ya deberías contar con esto en las máquinas del laboratorio_).

#### En tu ordenador

1.  **Cliente RDP:** Para conectarte al escritorio (por ejemplo, Remmina en Linux o Conexión a Escritorio Remoto en Windows).

### Paso 2: Construir la Imagen Base

La imagen base se llama `kali-xrdp` y se define en el `Dockerfile` dentro de la carpeta `KaliDocker`.

1.  Navega a la carpeta principal del repositorio.
2.  Ejecuta el siguiente comando para construir la imagen:

    ```bash
    sudo docker build -t kali-xrdp ./KaliDocker
    ```

### Paso 3: Iniciar el Contenedor (Script BASH)

El script `iniciarKali.sh` se encarga de:
1.  Verificar si el contenedor `kali-desktop` ya existe.
2.  Si existe, lo inicia.
3.  Si no existe, crea un nuevo contenedor, asignándole la red `host` y las capacidades `NET_ADMIN` necesarias para las herramientas forenses.

Ejecuta el script desde la carpeta principal del repositorio:

```bash
sudo ./iniciarKali.sh
```
>__Para la primera vez:__
>Si ves que no te deja ejecutar el script _iniciarKali.sh_, prueba a otorgarle permisos de ejecución con el comando `chmod +x iniciarKali.sh`

### Paso 4: Conectarte al escritorio remoto

Para conectarte deberás introducir la dirección de la máquina (rdcXX.redes.upv.es:13389) y usar las credenciales `kali`/`kali`
