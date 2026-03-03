# BRRR Job: Ray remote task fanout

This example mirrors `examples/raw-jobs/rayjob-remote-task-fanout/` using
high-level config files for `brrr`.

## Validate and render

```bash
uv run brrr validate examples/kustomize-jobs/rayjob-remote-task-fanout/job-config.yaml
uv run brrr render examples/kustomize-jobs/rayjob-remote-task-fanout/job-config.yaml
```

## Submit

```bash
uv run brrr submit examples/kustomize-jobs/rayjob-remote-task-fanout/job-config.yaml
```

The rendered RayJob resources are cleaned up automatically after completion.
