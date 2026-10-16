#!/bin/bash

echo "===== $(date '+%Y-%m-%d %H:%M:%S') ====="

# --- DISCO ---

DISCO=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

echo "Uso de disco: $DISCO%" 

LIMITE_DISCO=80

if [ "$DISCO" -gt "$LIMITE_DISCO" ]; then
    echo "⚠️ ALERTA: disco al $DISCO%"
fi

# --- RAM ---

RAM=$(free | awk '/Mem:/ {printf "%d", $3/$2*100}')

echo "Uso de RAM: $RAM%"

LIMITE_RAM=80

if [ "$RAM" -gt "$LIMITE_RAM" ]; then
    echo "⚠️ ALERTA: Uso de la RAM al $RAM%"
fi

# --- CONTENEDORES ---
CAIDOS=$(docker ps -a --filter "status=exited" --format "{{.Names}}")

if [ -n "$CAIDOS" ]; then
    echo "⚠️ ALERTA: contenedores caídos: $CAIDOS"
else
    echo "Contenedores: todos en marcha ✅"
fi
