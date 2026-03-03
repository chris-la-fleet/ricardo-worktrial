# BRRR Job: Ray remote task fanout

This example mirrors `examples/raw-jobs/rayjob-remote-task-fanout/` using
high-level config files for `brrr`.

## Validate and render

```bash
uv run brrr validate -f examples/kustomize-jobs/jobs/rayjob-remote-task-fanout/job-config.yaml
uv run brrr render -f examples/kustomize-jobs/jobs/rayjob-remote-task-fanout/job-config.yaml
```

## Submit

```bash
uv run brrr submit -f examples/kustomize-jobs/jobs/rayjob-remote-task-fanout/job-config.yaml
```

## Cleanup

```bash
uv run brrr render -f examples/kustomize-jobs/jobs/rayjob-remote-task-fanout/job-config.yaml | kubectl delete -f -
```
