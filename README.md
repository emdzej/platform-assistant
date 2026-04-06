# Platform Assistant

AI-powered platform assistant for Kubernetes — ships [OpenCode](https://opencode.ai) pre-configured with MCP servers for cluster ops, ArgoCD, and RAG search.

## What's Inside

| Component | Description | Default |
|-----------|-------------|---------|
| **OpenCode** | AI coding assistant web UI | Always on |
| **Kubernetes MCP** | Read-only cluster introspection via MCP | Always on |
| **Ollama** | Local LLM inference (qwen3.5:0.8b) | Enabled |
| **RagClaw MCP** | RAG search over indexed documents/code | Enabled |
| **ArgoCD MCP** | GitOps operations via MCP | Disabled |

## Quick Start

```bash
helm install platform-assistant \
  oci://ghcr.io/emdzej/charts/platform-assistant \
  -n platform-assistant --create-namespace
```

Then access the UI:

```bash
kubectl port-forward svc/platform-assistant-opencode 4096:4096 -n platform-assistant
# Open http://localhost:4096
```

No API keys needed — Ollama runs locally with `qwen3.5:0.8b` out of the box.

## Documentation

See the full chart documentation in [charts/platform-assistant/README.md](charts/platform-assistant/README.md) for:

- Configuration reference for all components
- Provider setup (Anthropic, GitHub Copilot, custom OpenAI-compatible)
- ArgoCD integration
- Secrets management
- Persistence options
- GPU acceleration

## Prerequisites

- Kubernetes 1.26+
- Helm 3.12+

## Development

```bash
# Lint
helm lint charts/platform-assistant

# Unit tests
helm plugin install https://github.com/helm-unittest/helm-unittest.git
helm unittest charts/platform-assistant

# Chart-testing lint
ct lint --config ct.yaml
```

## Support

If you find this project useful, consider [buying me a coffee](https://buymeacoffee.com/emdzej) ☕ or [sponsoring on GitHub](https://github.com/sponsors/emdzej).

## License

MIT
