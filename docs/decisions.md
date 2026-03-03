- made KubeRay optional. changed my mind and went for generic k8s setup so that we are not forced into Ray JobConfig semantics for non-Ray workloads.
- used Kueue for gang scheduling, and governance features like fair scheduling
- terraform for deployment, to make this infra portable across GKE and EKS
- terraform state tracked by s3, so that anyone can run terraform apply from any host.
- configured the tf state s3 bucket as a versioned bucket, so that we can rollback to older deployments if needed
- added optional compute configs for Ray. (1) added config for dedicated head/driver node, (2) added support for KubeRay
- separated demos based on raw-jobs/ (executed using kubectl) and kustomize-jobs/ (using job templates).
- OpenLens for k8s observability
- k8s cluster scales down to zero when idle (except for the system node)
- job templates using `brrr` (high-level JobConfig/ComputeConfig rendered to k8s), to abstract away Helm and raw manifests from scientists. users edit job + compute config while platform guardrails stay centralized.
- chose manual Jinja temlpating over Kustomize plugin because the latter was a leaky abstraction and I wanted a clean UX.

# future
- mirror across GKE and EKS
- make explicit teardown unnecessary
- multi-node single region jobs, where we can queue in any region but the job remains single-region. and demo gang scheduling (the job gets places when all requried machines are available)

# Example jobs
- hello world CPU queue
- toy multi-node GPU jobs. (1) pytorch distributed dtensor, 2x gpu nodes (2) ray cluster_resources and spread tasks, heterogeneous workers (2 different gpu types, and 2 different cpu types)
- gang scheduling of a 4 8xH100 cluster in gcp. let it pick a region based on availability

# full e2e demo script

- stand up both gcp and eks clouds
- run the above example jobs
- demonstrate queuing
- demonstrate framework agnosticness

# bonus features
- validating capabilities. validate that a job request is schedulable before hitting Kueue.
