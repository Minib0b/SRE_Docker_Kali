#!/bin/bash

# Nombre del contenedor deseado
CONTAINER_NAME="kali-desktop"
# Nombre de la imagen base a usar si el contenedor no existe
IMAGE_NAME="kali-xrdp"

# --- Variables de Configuración (Personaliza según sea necesario) ---
# Puerto de RDP (mapeado de 3389 del contenedor)
RDP_PORT="13389" 

# RUTA DEL VOLUMEN EN LA MÁQUINA ANFITRIONA
# Este directorio almacenará de forma persistente el contenido de /home/kali del contenedor.
# Se crea en el directorio de usuario del host.
LOCAL_STORAGE_PATH="$HOME/kali-forense-data"

# OPCIONES CORREGIDAS: 
# Se añade -v para la persistencia del volumen.
DOCKER_RUN_OPTIONS="-d --network host --cap-add=NET_ADMIN -v ${LOCAL_STORAGE_PATH}:/home/kali --name ${CONTAINER_NAME}"
# ------------------------------------------------------------------


echo "✨ Iniciando gestión del contenedor Docker: ${CONTAINER_NAME}..."
echo "--------------------------------------------------------"

# 1. Comprobar si el contenedor existe
# Se añade 'sudo' a todos los comandos docker para evitar el error de permisos
if sudo docker inspect --type=container ${CONTAINER_NAME} &> /dev/null; then
    
    echo "✅ Contenedor '${CONTAINER_NAME}' encontrado."
    
    # Comprobar si está parado
    if [ "$(sudo docker inspect -f '{{.State.Running}}' ${CONTAINER_NAME})" == "false" ]; then
        echo "🔄 Iniciando contenedor existente..."
        sudo docker start ${CONTAINER_NAME}
        echo "🎉 Contenedor iniciado. Puedes conectarte por RDP en el puerto ${RDP_PORT}."
    else
        echo "🟢 El contenedor ya está en ejecución."
        echo "🎉 Puedes conectarte por RDP en el puerto ${RDP_PORT}."
    fi

else
    
    # 2. Si no existe, crear uno nuevo
    echo "⚠️ Contenedor '${CONTAINER_NAME}' no encontrado."
    
    # NUEVO: Crear el directorio de volumen en el host si no existe
    if [ ! -d "${LOCAL_STORAGE_PATH}" ]; then
        echo "📂 Creando el directorio de almacenamiento persistente: ${LOCAL_STORAGE_PATH}"
        mkdir -p "${LOCAL_STORAGE_PATH}"
        # Esto da permisos al usuario 'kali' (UID 1000) del contenedor sobre la carpeta del host.
        sudo chown -R 1000:1000 "${LOCAL_STORAGE_PATH}" 2>/dev/null 
    fi
    
    echo "🔨 Creando nuevo contenedor a partir de la imagen '${IMAGE_NAME}'..."
    
    # Comprobar si la imagen existe antes de intentar crear el contenedor
    if sudo docker images -q ${IMAGE_NAME} &> /dev/null; then
        
        # Crear y ejecutar el nuevo contenedor
        sudo docker run ${DOCKER_RUN_OPTIONS} ${IMAGE_NAME}
        
        if [ $? -eq 0 ]; then
            echo "🎉 Contenedor '${CONTAINER_NAME}' creado e iniciado correctamente."
            echo "Los datos persistentes se guardan en: ${LOCAL_STORAGE_PATH}"
            echo "Puedes conectarte por RDP en el puerto ${RDP_PORT}."
        else
            echo "❌ Error al intentar crear y ejecutar el contenedor Docker."
        fi
        
    else
        echo "❌ ERROR: La imagen Docker '${IMAGE_NAME}' no existe localmente."
        echo "Por favor, crea la imagen primero usando 'docker build -t ${IMAGE_NAME} .'."
    fi

fi

echo "--------------------------------------------------------"
