What We Want

A platform with three layers:

A GKE cluster with GPU nodes that provisions GPUs on demand (via DWS) and releases them when idle. Must support multiple GPU types.

A job queue that manages submissions, enforces fair scheduling, and ensures distributed jobs get all their resources at once (gang scheduling) — no partial starts.

Library-agnostic job execution. A user submits a container image, a command, and resource requirements. The platform handles everything needed for multi-node distributed training. It should not matter whether the job uses PyTorch DDP, DeepSpeed, Megatron, TorchTitan, or anything else — the platform doesn't know and doesn't care.