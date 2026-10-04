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

# Railway runs Paperclip as the node user. Prepare the persistent AI-login
# tree as root before the upstream entrypoint drops privileges.
USER root
RUN printf '%s\n' \
    '#!/bin/sh' \
    'set -eu' \
    'mkdir -p /paperclip/instances/default/ai-local-logins' \
    'chown -R 1000:1000 /paperclip/instances/default/ai-local-logins' \
    'exec /usr/bin/tini -- /usr/local/bin/docker-entrypoint.sh "$@"' \
    > /usr/local/bin/paperclip-railway-entrypoint.sh \
    && chmod +x /usr/local/bin/paperclip-railway-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/paperclip-railway-entrypoint.sh"]
CMD ["node", "--import", "./server/node_modules/tsx/dist/loader.mjs", "server/dist/index.js"]

EXPOSE 3100
