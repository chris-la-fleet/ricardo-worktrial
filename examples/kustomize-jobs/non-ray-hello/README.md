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

## Cleanup

```bash
uv run brrr render examples/kustomize-jobs/non-ray-hello/job-config.yaml | kubectl delete -f -
```
