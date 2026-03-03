"""Typer CLI for BRRR job submission workflow."""

from __future__ import annotations

import subprocess
from pathlib import Path

import typer
import yaml

from .models import ComputeConfig, JobConfig, validate_semantics
from .renderers import render_yaml


app = typer.Typer(no_args_is_help=True, help="BRRR: render and submit jobs.")


def _load_yaml(path: Path) -> dict:
    if not path.exists():
        raise typer.BadParameter(f"File not found: {path}")
    with path.open("r", encoding="utf-8") as file:
        raw = yaml.safe_load(file) or {}
    if not isinstance(raw, dict):
        raise typer.BadParameter(f"YAML root must be a mapping in {path}")
    return raw


def _resolve_compute_path(job_path: Path, compute_override: Path | None) -> Path:
    if compute_override:
        return compute_override
    return job_path.parent / "compute-config.yaml"


def _load_configs(job_path: Path, compute_override: Path | None) -> tuple[JobConfig, ComputeConfig]:
    compute_path = _resolve_compute_path(job_path, compute_override)
    job_data = _load_yaml(job_path)
    compute_data = _load_yaml(compute_path)

    try:
        job = JobConfig.model_validate(job_data)
        compute = ComputeConfig.model_validate(compute_data)
        validate_semantics(job, compute)
    except Exception as exc:
        raise typer.BadParameter(str(exc)) from exc

    return job, compute


@app.command()
def validate(
    file: Path = typer.Option(..., "--file", "-f", help="Path to job-config.yaml."),
    compute_config: Path | None = typer.Option(
        None, "--compute-config", help="Optional path to compute-config.yaml."
    ),
) -> None:
    """Validate job and compute configuration files."""
    _load_configs(file, compute_config)
    typer.echo("Config is valid.")


@app.command()
def render(
    file: Path = typer.Option(..., "--file", "-f", help="Path to job-config.yaml."),
    compute_config: Path | None = typer.Option(
        None, "--compute-config", help="Optional path to compute-config.yaml."
    ),
) -> None:
    """Render Kubernetes manifests to stdout."""
    job, compute = _load_configs(file, compute_config)
    typer.echo(render_yaml(job, compute), nl=False)


@app.command()
def submit(
    file: Path = typer.Option(..., "--file", "-f", help="Path to job-config.yaml."),
    compute_config: Path | None = typer.Option(
        None, "--compute-config", help="Optional path to compute-config.yaml."
    ),
    dry_run: str | None = typer.Option(
        None,
        "--dry-run",
        help="Optional kubectl dry-run mode (client or server).",
    ),
) -> None:
    """Render manifests and apply with kubectl."""
    job, compute = _load_configs(file, compute_config)
    rendered = render_yaml(job, compute)

    command = ["kubectl", "apply", "-f", "-"]
    if dry_run:
        command.append(f"--dry-run={dry_run}")

    process = subprocess.run(
        command,
        input=rendered,
        text=True,
        capture_output=True,
        check=False,
    )
    if process.returncode != 0:
        typer.echo(process.stderr.strip() or process.stdout.strip(), err=True)
        raise typer.Exit(code=process.returncode)

    typer.echo(process.stdout.strip())


def main() -> None:
    """Console entrypoint for brrr."""
    app()


if __name__ == "__main__":
    main()
