# Azure ops workspace

## Environment
- Tenant: 66f15b3d-3ce8-4e2f-8e25-5db984fb6416   Subscription: 116d0970-4c1d-4a54-97b8-7abc77b7c78d
- App registration: graph-connector (client ID 54c8e712-427a-4a75-a3f3-41fae728ba1c), app-only Graph access
- Service principal has Reader on the subscription (no write access through it)

## Tools available
- `azure` MCP server: preferred for Azure resource queries.
- `az` CLI: runs as the signed-in human user. Use `-o table` or `-o json --query` to keep output short.
- Graph (app-only): `.venv/bin/python graph_test.py` to verify; `az rest --method get --url https://graph.microsoft.com/v1.0/...` for ad-hoc delegated reads.

## Rules
- Read before you change. Show the exact command and wait for approval before any create/update/delete.
- Never print, echo, or write secrets, keys, or tokens.
- Prefer resource-group scope over subscription scope for any change.
- When a command fails, show the error and the `request-id`/correlation ID; don't retry destructive commands.
