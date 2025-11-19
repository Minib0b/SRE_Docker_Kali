#!/bin/bash

# Nombre del contenedor deseado
CONTAINER_NAME="kali-desktop"
# Nombre de la imagen base a usar si el contenedor no existe
IMAGE_NAME="kali-xrdp"

# --- Variables de Configuración (Personaliza según sea necesario) ---
# Puerto de RDP (mapeado de 3389 del contenedor)
RDP_PORT="13389" 

# Opciones de ejecución avanzadas (importantes para forense/redes)
# Usaremos 'bridge' por defecto, pero se recomienda cambiarlo a 'host' o 'macvlan' para el análisis real.
DOCKER_RUN_OPTIONS="-d --network host --cap-add=NET_ADMIN --name ${CONTAINER_NAME}"
# ------------------------------------------------------------------


echo "✨ Iniciando gestión del contenedor Docker: ${CONTAINER_NAME}..."
echo "--------------------------------------------------------"

# 1. Comprobar si el contenedor existe
if sudo docker inspect --type=container ${CONTAINER_NAME} &> /dev/null; then
    
    echo "✅ Contenedor '${CONTAINER_NAME}' encontrado."
    
    # Comprobar si está parado
    if [ "$(docker inspect -f '{{.State.Running}}' ${CONTAINER_NAME})" == "false" ]; then
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
    echo "🔨 Creando nuevo contenedor a partir de la imagen '${IMAGE_NAME}'..."
    
    # Comprobar si la imagen existe antes de intentar crear el contenedor
    if sudo docker images -q ${IMAGE_NAME} &> /dev/null; then
        
        # Crear y ejecutar el nuevo contenedor
        sudo docker run ${DOCKER_RUN_OPTIONS} ${IMAGE_NAME}
        
        if [ $? -eq 0 ]; then
            echo "🎉 Contenedor '${CONTAINER_NAME}' creado e iniciado correctamente."
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
