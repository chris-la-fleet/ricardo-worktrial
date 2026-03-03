# RayJob: remote task fanout

This example is **job logic only** and demonstrates fanning out Ray remote tasks to report cluster usage.

## Prerequisites

Provision infra first with Terraform and set the required flags/variables:

- `enable_kuberay = true`
- `enable_ray_cluster = true`
- `enable_head_node_group = true`
- CPU workers enabled (create CPU worker node group/workers)
- `ray_cluster_cpu_worker_replicas` set to at least `1`

If you customize infra variables, keep these aligned with `rayjob-remote-task-fanout.yaml`:
- `ray_cluster_name` <-> `spec.clusterSelector.ray.io/cluster`
- `ray_cluster_namespace` <-> RayJob namespace
- `ray_cluster_queue_name` / `kueue_local_queue_name` <-> `kueue.x-k8s.io/queue-name`

Commands below assume you run them from the repo root.

## Apply

```bash
kubectl apply -f examples/raw-jobs/rayjob-remote-task-fanout/rayjob-remote-task-fanout.yaml
```

## Check status and logs

```bash
kubectl get rayjobs -n default
kubectl get jobs -n default
kubectl logs -n default job/<submitter-job-name>
```
The submitter job name is shown by `kubectl get jobs -n default` and typically starts with the RayJob name.

## Cleanup

```bash
kubectl delete -f examples/raw-jobs/rayjob-remote-task-fanout/rayjob-remote-task-fanout.yaml
```
