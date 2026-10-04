# Paperclip on Railway

A minimal Railway deployment wrapper for [Paperclip](https://github.com/paperclipai/paperclip).

This repository intentionally uses Paperclip's official published Docker image instead of vendoring the Paperclip source code.

## Railway architecture

Deploy the following:

- **Paperclip service** from this repository
- **Railway PostgreSQL** service
- **Railway Volume** mounted at `/paperclip`

Paperclip uses PostgreSQL for its hosted database and `/paperclip` for persistent instance data, uploaded assets, secrets, and agent workspaces.

## Deploy

1. Create a new Railway project.
2. Add a PostgreSQL service.
3. Add a service from this GitHub repository.
4. Add a Railway Volume to the Paperclip service and mount it at:

   `/paperclip`

5. Set the following variables on the Paperclip service.

### Required

```text
DATABASE_URL=${{Postgres.DATABASE_URL}}
BETTER_AUTH_SECRET=<generate-a-long-random-secret>
PAPERCLIP_PUBLIC_URL=https://<your-paperclip-domain>
```

If your PostgreSQL service has a different Railway reference name, adjust the `${{Postgres.DATABASE_URL}}` reference accordingly.

### Recommended

```text
HOST=0.0.0.0
PAPERCLIP_HOME=/paperclip
PAPERCLIP_INSTANCE_ID=default
PAPERCLIP_DEPLOYMENT_MODE=authenticated
PAPERCLIP_DEPLOYMENT_EXPOSURE=public
SERVE_UI=true
```

Railway supplies `PORT` automatically. Do not hard-code a public port.

## Custom domain

After deployment, add a Railway-generated domain or your own custom domain and set:

```text
PAPERCLIP_PUBLIC_URL=https://your-domain.example
```

The URL should be the exact external URL users will use to access Paperclip.

## LLM providers

Add only the provider credentials you intend to use:

```text
OPENAI_API_KEY=...
ANTHROPIC_API_KEY=...
GEMINI_API_KEY=...
```

Paperclip can run without these keys, but the corresponding adapters will not be usable.

## Persistence

The `/paperclip` volume is important. Without it, redeployments/restarts can lose Paperclip's local persistent state.

The PostgreSQL database should remain a separate Railway service.

## Health check

Railway uses:

```text
GET /api/health
```

as the service health check.

## Updating Paperclip

The Dockerfile tracks:

```text
ghcr.io/paperclipai/paperclip:latest
```

A new deployment will therefore pull the current published image.

For production environments where reproducibility matters, replace `latest` with a specific Paperclip release tag.

## Local smoke test

```bash
docker build -t paperclip-railway .
docker run --rm -p 3100:3100 \
  -e HOST=0.0.0.0 \
  -e PAPERCLIP_HOME=/paperclip \
  paperclip-railway
```

Open http://localhost:3100.

## Sources

- Paperclip Docker deployment documentation
- Paperclip environment variable reference
- Paperclip repository Dockerfile
