version: '3.8'

services:
  n8n:
    image: n8nio/n8n:latest
    container_name: n8n
    restart: always
    environment:
      - N8N_HOST=0.0.0.0
      - N8N_PORT=5678
      - TELEGRAM_BOT_TOKEN=${TELEGRAM_BOT_TOKEN}
      - GSHEETS_CREDENTIALS=${GSHEETS_CREDENTIALS}
      - MINIO_ENDPOINT=${MINIO_ENDPOINT}
      - MINIO_ACCESS_KEY=${MINIO_ACCESS_KEY}
      - MINIO_SECRET_KEY=${MINIO_SECRET_KEY}
      - CHATTERBOX_TTS_URL=${CHATTERBOX_TTS_URL}
      - LLM_API_URL=${LLM_API_URL}
      - FREESWITCH_API=${FREESWITCH_API}
      - SCRIPT_WARM=${SCRIPT_WARM}
      - SCRIPT_REFERRAL=${SCRIPT_REFERRAL}
      - SCRIPT_GROWTH=${SCRIPT_GROWTH}
      - ADMIN_TELEGRAM_CHAT_ID=${ADMIN_TELEGRAM_CHAT_ID}
    ports:
      - "5678:5678"
    volumes:
      - ./n8n_workflows:/home/node/.n8n

  chatterbox-tts:
    image: custom/chatterbox-tts:latest
    container_name: chatterbox-tts
    build:
      context: ./chatterbox
    environment:
      - CHATTERBOX_AUDIO_DIR=/audio
      - CHATTERBOX_AUDIO_TTL_HOURS=24
    volumes:
      - ./tts_audio:/audio

  freeswitch:
    image: voxbox/freeswitch:latest
    container_name: freeswitch
    ports:
      - "8021:8021"
      - "5060:5060/udp"
      - "16384-16482:16384-16482/udp"

  minio:
    image: minio/minio:latest
    container_name: minio
    command: server /data
    environment:
      - MINIO_ROOT_USER=${MINIO_ACCESS_KEY}
      - MINIO_ROOT_PASSWORD=${MINIO_SECRET_KEY}
    ports:
      - "9000:9000"
    volumes:
      - ./minio_data:/data

  llama-llm:
    image: local/llama3:latest
    container_name: llama-llm
    ports:
      - "8000:8000"
    environment:
      - LLM_MODEL_PATH=/models/llama3
    volumes:
      - ./llama_models:/models
