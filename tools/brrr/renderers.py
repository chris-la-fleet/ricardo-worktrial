"""Render Kubernetes manifests from BRRR config objects."""

from __future__ import annotations

from typing import Any

import yaml

from .models import ComputeConfig, JobConfig


QUEUE_LABEL_KEY = "kueue.x-k8s.io/queue-name"
DEFAULT_TTL_SECONDS_AFTER_FINISHED = 600


def render_manifests(job: JobConfig, compute: ComputeConfig) -> list[dict[str, Any]]:
    """Render one or more Kubernetes manifests from the inputs."""
    if job.workload_type == "job":
        return _render_batch_job(job, compute)
    if job.workload_type == "rayjob":
        return [_render_ray_job(job, compute)]
    raise ValueError(f"Unsupported workload_type: {job.workload_type}")


def render_yaml(job: JobConfig, compute: ComputeConfig) -> str:
    """Render YAML string for all Kubernetes documents."""
    manifests = render_manifests(job, compute)
    return yaml.safe_dump_all(manifests, sort_keys=False)


def _render_batch_job(job: JobConfig, compute: ComputeConfig) -> list[dict[str, Any]]:
    if job.containerfile:
        raise ValueError("containerfile is not supported yet; use image_uri for now.")

    assert job.image_uri is not None
    assert compute.gpu_type is not None
    assert compute.gpus_per_worker is not None
    assert compute.max_workers is not None
    assert compute.cpu is not None
    assert compute.memory is not None

    app_name = job.name
    namespace = job.namespace
    world_size = str(compute.max_workers)
    master_addr = f"{app_name}-0.{app_name}.{namespace}.svc.cluster.local"

    env = [
        {"name": "WORLD_SIZE", "value": world_size},
        {
            "name": "RANK",
            "valueFrom": {
                "fieldRef": {
                    "fieldPath": "metadata.annotations['batch.kubernetes.io/job-completion-index']"
                }
            },
        },
        {"name": "MASTER_ADDR", "value": master_addr},
        {"name": "MASTER_PORT", "value": str(job.master_port)},
    ]
    for key, value in job.env_vars.items():
        if key == "RANK":
            continue
        env = [item for item in env if item["name"] != key]
        env.append({"name": key, "value": value})

    resources = {
        "requests": {
            "cpu": compute.cpu,
            "memory": compute.memory,
            "nvidia.com/gpu": str(compute.gpus_per_worker),
        },
        "limits": {
            "cpu": compute.cpu,
            "memory": compute.memory,
            "nvidia.com/gpu": str(compute.gpus_per_worker),
        },
    }

    node_selector = {"role": "gpu-worker", "accelerator": compute.gpu_type}
    node_selector.update(compute.worker_node_selector_overrides)

    service_manifest = {
        "apiVersion": "v1",
        "kind": "Service",
        "metadata": {
            "name": app_name,
            "namespace": namespace,
            "labels": {"app": app_name},
        },
        "spec": {"clusterIP": "None", "selector": {"app": app_name}},
    }

    job_manifest = {
        "apiVersion": "batch/v1",
        "kind": "Job",
        "metadata": {
            "name": app_name,
            "namespace": namespace,
            "labels": {"app": app_name, QUEUE_LABEL_KEY: job.queue},
        },
        "spec": {
            "parallelism": compute.max_workers,
            "completions": compute.max_workers,
            "completionMode": "Indexed",
            "backoffLimit": 0,
            "suspend": job.suspend,
            "ttlSecondsAfterFinished": DEFAULT_TTL_SECONDS_AFTER_FINISHED,
            "template": {
                "metadata": {"labels": {"app": app_name}},
                "spec": {
                    "restartPolicy": "Never",
                    "subdomain": app_name,
                    "nodeSelector": node_selector,
                    "tolerations": [
                        {
                            "key": "nvidia.com/gpu",
                            "operator": "Equal",
                            "value": "present",
                            "effect": "NoSchedule",
                        },
                        {
                            "key": "ray.io/node-type",
                            "operator": "Equal",
                            "value": "worker",
                            "effect": "NoSchedule",
                        },
                    ],
                    "affinity": {
                        "podAntiAffinity": {
                            "requiredDuringSchedulingIgnoredDuringExecution": [
                                {
                                    "labelSelector": {"matchLabels": {"app": app_name}},
                                    "topologyKey": "kubernetes.io/hostname",
                                }
                            ]
                        }
                    },
                    "containers": [
                        {
                            "name": "worker",
                            "image": job.image_uri,
                            "imagePullPolicy": "IfNotPresent",
                            "resources": resources,
                            "env": env,
                            "command": ["/bin/bash", "-lc", job.entrypoint],
                        }
                    ],
                },
            },
        },
    }

    return [service_manifest, job_manifest]


def _render_ray_job(job: JobConfig, compute: ComputeConfig) -> dict[str, Any]:
    cluster_name = job.ray_cluster_name or compute.ray_cluster_name
    assert cluster_name is not None
    return {
        "apiVersion": "ray.io/v1",
        "kind": "RayJob",
        "metadata": {
            "name": job.name,
            "namespace": job.namespace,
            "labels": {QUEUE_LABEL_KEY: job.queue},
        },
        "spec": {
            "entrypoint": job.entrypoint,
            "clusterSelector": {"ray.io/cluster": cluster_name},
            "submissionMode": "K8sJobMode",
            "suspend": job.suspend,
            "ttlSecondsAfterFinished": DEFAULT_TTL_SECONDS_AFTER_FINISHED,
        },
    }
