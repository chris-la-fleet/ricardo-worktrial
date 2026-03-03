# Examples

Examples are organized by submission mode:

- `raw-jobs/`: direct Kubernetes manifests submitted with `kubectl`.
  - `raw-jobs/gpu-multinode-dtensor/`: 2-node GPU distributed smoke test using PyTorch distributed + DTensor.
  - `raw-jobs/rayjob-remote-task-fanout/`: RayJob demo that fans out Ray remote tasks and summarizes cluster resources.
- `kustomize-jobs/`: template-driven job submission with Anyscale-style `JobConfig` + `ComputeConfig` patches.
