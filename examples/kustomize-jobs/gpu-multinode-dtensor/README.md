# BRRR Job: GPU multinode DTensor

This example mirrors `examples/raw-jobs/gpu-multinode-dtensor/` using high-level
config files for `brrr`.

## Validate and render

```bash
uv run brrr validate examples/kustomize-jobs/gpu-multinode-dtensor/job-config.yaml
uv run brrr render examples/kustomize-jobs/gpu-multinode-dtensor/job-config.yaml
```

## Submit

```bash
uv run brrr submit examples/kustomize-jobs/gpu-multinode-dtensor/job-config.yaml
```

## Watch logs

```bash
kubectl get jobs
kubectl get pods -l app=dtensor-mesh-test -w
kubectl logs -l app=dtensor-mesh-test --prefix --all-containers=true
```

The rendered `Job` and pods are cleaned up automatically after completion.
The headless `Service` is intentionally kept for DNS and has no compute cost.
