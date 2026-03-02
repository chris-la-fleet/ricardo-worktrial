# GPU Testing Example (2-node torch distributed)

This raw-jobs example uses `kubectl` and submits a distributed
PyTorch smoke test that:

- runs with 2 workers (one per GPU node)
- forms a distributed process group across nodes
- builds a simple DTensor shard
- runs an `all_reduce` across both workers
- installs extra Python dependencies at runtime (`einops`, `rich`)

## Platform prerequisite (operator/admin step)

Users submit jobs with `kubectl`, but the platform still needs a matching GPU
capacity profile. Enable it from `environments/eks-dev`:

```bash
terraform apply \
  -var-file=terraform.tfvars \
  -var-file=../../examples/raw-jobs/gpu-testing/eks-dev-gpu-testing.tfvars
```

This creates 2 GPU nodes using `g4dn.xlarge` and labels them with
`accelerator=gpu-testing`.

## Submit the distributed smoke test job

```bash
kubectl apply -f ../../examples/raw-jobs/gpu-testing/torch-distributed-dtensor-job.yaml
```

Kueue will admit the job from `default-queue` once capacity is available.

## Watch it run

```bash
kubectl get jobs
kubectl get pods -l app=dtensor-mesh-test -w
kubectl logs -l app=dtensor-mesh-test --prefix --all-containers=true
```

Expected log lines include:

- `local shard shape=(1, 8)` on each rank
- `all_reduce sum=3.0 (expected 3.0)`
- `distributed smoke test passed`

## Cleanup

```bash
kubectl delete -f ../../examples/raw-jobs/gpu-testing/torch-distributed-dtensor-job.yaml
```

To scale GPU workers back down, remove the test var-file override and apply
your standard `terraform.tfvars` again.
