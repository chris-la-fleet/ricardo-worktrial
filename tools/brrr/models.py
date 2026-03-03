"""Pydantic models for BRRR config files."""

from __future__ import annotations

import re
from typing import Literal

from pydantic import BaseModel, Field, model_validator


GPU_TYPE_PATTERN = re.compile(r"^gpu-[a-z0-9-]+$")


class JobConfig(BaseModel):
    """Scientist-facing workload configuration."""

    name: str = Field(min_length=1)
    workload_type: Literal["job", "rayjob"]
    namespace: str = "default"
    queue: str = "default-queue"
    entrypoint: str = Field(min_length=1)
    image_uri: str | None = None
    containerfile: str | None = None
    env_vars: dict[str, str] = Field(default_factory=dict)
    max_retries: int = Field(default=1, ge=0)
    tags: dict[str, str] = Field(default_factory=dict)
    ray_cluster_name: str | None = None
    master_port: int = Field(default=29500, ge=1, le=65535)
    ttl_seconds_after_finished: int = Field(default=600, ge=0)
    suspend: bool = True

    @model_validator(mode="after")
    def validate_image_fields(self) -> "JobConfig":
        if self.image_uri and self.containerfile:
            raise ValueError("Only one of image_uri or containerfile can be set.")

        if self.workload_type == "job" and not (self.image_uri or self.containerfile):
            raise ValueError("workload_type=job requires image_uri or containerfile.")

        return self


class ComputeConfig(BaseModel):
    """Scientist-facing execution configuration."""

    gpu_type: str | None = None
    gpus_per_worker: int | None = Field(default=None, ge=1)
    min_workers: int | None = Field(default=None, ge=1)
    max_workers: int | None = Field(default=None, ge=1)
    cpu: str | None = None
    memory: str | None = None
    ray_cluster_name: str | None = None
    worker_node_selector_overrides: dict[str, str] = Field(default_factory=dict)
    priority: int | None = None

    @model_validator(mode="after")
    def validate_gpu_type(self) -> "ComputeConfig":
        if self.gpu_type and not GPU_TYPE_PATTERN.match(self.gpu_type):
            raise ValueError("gpu_type must match the gpu-* naming convention.")
        return self


def validate_semantics(job: JobConfig, compute: ComputeConfig) -> None:
    """Cross-file validation that depends on workload type."""

    if job.workload_type == "job":
        required = {
            "gpu_type": compute.gpu_type,
            "gpus_per_worker": compute.gpus_per_worker,
            "min_workers": compute.min_workers,
            "max_workers": compute.max_workers,
            "cpu": compute.cpu,
            "memory": compute.memory,
        }
        missing = [field for field, value in required.items() if value is None]
        if missing:
            raise ValueError(
                "workload_type=job requires compute fields: "
                + ", ".join(sorted(missing))
            )

        if compute.max_workers is not None and compute.min_workers is not None:
            if compute.max_workers < compute.min_workers:
                raise ValueError("max_workers must be >= min_workers.")

    if job.workload_type == "rayjob":
        cluster_name = job.ray_cluster_name or compute.ray_cluster_name
        if not cluster_name:
            raise ValueError(
                "workload_type=rayjob requires ray_cluster_name in job-config or compute-config."
            )
