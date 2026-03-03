# BRRR Job Examples

This folder contains scientist-facing job configs.

Each workload folder contains only:

- `job-config.yaml` (workload intent)
- `compute-config.yaml` (compute intent)

All platform-owned Kubernetes rendering logic lives in `tools/brrr`.

## CLI workflow

From repo root:

```bash
uv run brrr validate -f examples/kustomize-jobs/jobs/gpu-multinode-dtensor/job-config.yaml
uv run brrr render -f examples/kustomize-jobs/jobs/gpu-multinode-dtensor/job-config.yaml
uv run brrr submit -f examples/kustomize-jobs/jobs/gpu-multinode-dtensor/job-config.yaml
```

## Current examples

- `jobs/gpu-multinode-dtensor/`
- `jobs/rayjob-remote-task-fanout/`

## Compute naming convention

Use `gpu-*` values in compute config (for example `gpu-t4`, `gpu-h100`) so the
renderer can map directly to existing node labels.
