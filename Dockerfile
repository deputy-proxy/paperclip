# syntax=docker/dockerfile:1

# Official Paperclip production image.
# Pin this tag to a release for reproducible deployments if desired.
FROM ghcr.io/paperclipai/paperclip:latest

# Railway injects PORT at runtime. Paperclip defaults to 3100 locally.
ENV HOST=0.0.0.0 \
    PAPERCLIP_HOME=/paperclip \
    PAPERCLIP_INSTANCE_ID=default \
    PAPERCLIP_DEPLOYMENT_MODE=authenticated \
    PAPERCLIP_DEPLOYMENT_EXPOSURE=public \
    SERVE_UI=true \
    GEMINI_SANDBOX=false

EXPOSE 3100

# Keep the upstream Paperclip entrypoint/CMD.
