# Use the official n8n image as a base
FROM n8nio/n8n:latest

# Install required system dependencies for TTS (Chatterbox), Gemini, and Google Sheets
USER root
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-dev \
    build-essential \
    libpq-dev \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Docker (for Docker-in-Docker on cloud platforms)
RUN curl -fsSL https://get.docker.com | sh

# Install Docker Compose (For managing multi-service containers)
RUN curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

# Install MinIO client (mc) for MinIO interaction
RUN curl -sL https://dl.min.io/client/mc/release/linux-amd64/mc -o /usr/local/bin/mc && chmod +x /usr/local/bin/mc

# Install Python dependencies for Chatterbox TTS, Gemini, and Google Sheets integration
RUN pip3 install --upgrade pip
RUN pip3 install Flask chatterbox freeSWITCH-client google-auth google-auth-oauthlib google-auth-httplib2 google-api-python-client requests

# Create necessary directories for services
RUN mkdir -p /app/tts_audio /app/minio_data /app/n8n_workflows

# Set environment variables
ENV N8N_BASIC_AUTH_ACTIVE=false
ENV N8N_HOST=0.0.0.0
ENV N8N_PORT=5678
ENV N8N_PROTOCOL=http
ENV N8N_LOG_LEVEL=debug
ENV N8N_WEBHOOK_URL=https://your-cloud-instance-url.com

# Configure environment variables for services and credentials
ENV TELEGRAM_BOT_TOKEN=your_telegram_bot_token
ENV GSHEETS_CREDENTIALS=your_google_sheets_credentials_file
ENV MINIO_ENDPOINT=http://minio:9000
ENV MINIO_ACCESS_KEY=minio
ENV MINIO_SECRET_KEY=minio123
ENV CHATTERBOX_TTS_URL=http://chatterbox-tts:5000/api/v1/synthesize
ENV GEMINI_API_URL=https://gemini-api-url.com/infer
ENV FREESWITCH_API=http://freeswitch:8080/api/originate
ENV SCRIPT_WARM="Hi there! Thanks for reaching out. I’d love to help you with your sales questions."
ENV SCRIPT_REFERRAL="Thanks for the referral! We’d be happy to help your friend or colleague."
ENV SCRIPT_GROWTH="You're part of our growth journey! Let’s talk about how we can grow together."
ENV ADMIN_TELEGRAM_CHAT_ID=123456789

# Set work directory for n8n
WORKDIR /home/node/.n8n

# Expose necessary ports
EXPOSE 5678
EXPOSE 5000
EXPOSE 8080
EXPOSE 9000

# Run n8n as the main process
CMD ["n8n"]
