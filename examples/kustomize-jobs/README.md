# BRRR Job Examples

This folder contains scientist-facing job configs.

Each workload folder contains only:

- `job-config.yaml` (workload intent)
- `compute-config.yaml` (compute intent)

All platform-owned Kubernetes rendering logic lives in `tools/brrr`.

## CLI workflow

From repo root:

```bash
uv run brrr validate examples/kustomize-jobs/gpu-multinode-dtensor/job-config.yaml
uv run brrr render examples/kustomize-jobs/gpu-multinode-dtensor/job-config.yaml
uv run brrr submit examples/kustomize-jobs/gpu-multinode-dtensor/job-config.yaml
```

## Current examples

- `gpu-multinode-dtensor/`
- `non-ray-hello/`
- `rayjob-remote-task-fanout/`

## Compute naming convention

Use `gpu-*` values in compute config (for example `gpu-t4`, `gpu-h100`) so the
renderer can map directly to existing node labels.
