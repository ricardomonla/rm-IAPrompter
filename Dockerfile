#  -----------------------------------------------------------------------------
#  Project:     rm-Prompter
#  File:        Dockerfile
#  Version:     1.0.0
#  Date:        2025-12-06
#  Author:      Lic. Ricardo MONLA
#  Email:       rmonla@gmail.com
#  Description: Dockerfile para el contenedor del backend Flask.
#  -----------------------------------------------------------------------------
FROM python:3.11-slim

WORKDIR /app

# Instalamos dependencias del sistema necesarias para criptografía
RUN apt-get update && apt-get install -y \
    gcc \
    libffi-dev \
    musl-dev \
    && rm -rf /var/lib/apt/lists/*

# Instalamos las librerías de Python UNA SOLA VEZ al construir la imagen
RUN pip install --no-cache-dir flask google-generativeai cryptography

# Copiamos el código
COPY app.py .

EXPOSE 5000

CMD ["python", "app.py"]