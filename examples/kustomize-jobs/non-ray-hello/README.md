# BRRR Job: non-Ray hello world

Minimal non-Ray example for the `job` workload path.

## Validate and render

```bash
uv run brrr validate examples/kustomize-jobs/non-ray-hello/job-config.yaml
uv run brrr render examples/kustomize-jobs/non-ray-hello/job-config.yaml
```

## Submit

```bash
uv run brrr submit examples/kustomize-jobs/non-ray-hello/job-config.yaml
```

The rendered `Job` and pods are cleaned up automatically after completion.
The headless `Service` is intentionally kept for DNS and has no compute cost.
