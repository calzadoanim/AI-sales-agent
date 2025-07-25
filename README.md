# AI Sales Booking Agent

This is a one-click deployable, open-source AI sales booking agent using n8n, Chatterbox TTS, FreeSWITCH, local LLM, and MinIO.

## Features
- Telegram-based lead intake
- Automated script delivery via TTS
- Outbound calling with FreeSWITCH
- Conversation intent analysis via local LLM
- Full logging to Google Sheets and MinIO
- Error handling and admin notifications
- Manual approval step (optional)

## Deployment
1. Clone repo and create a `.env` file
2. Add your API keys and Google credentials
3. Run `docker compose up` on Fly.io, Railway, or Render.com

## Folder Structure
- `n8n_workflows`: Contains the n8n workflow JSON
- `example_scripts`: Prewritten call scripts
- `tts_training`: Upload your voice training audio (WAV)
- `services`: Dockerfiles for TTS and LLM services

## License
MIT
