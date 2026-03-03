- made KubeRay optional. changed my mind and went for generic k8s setup so that we are not forced into Ray JobConfig semantics for non-Ray workloads.
- used Kueue for gang scheduling, and governance features like fair scheduling
- terraform for deployment, to make this infra portable across GKE and EKS
- terraform state tracked by s3, so that anyone can run terraform apply from any host.
- configured the tf state s3 bucket as a versioned bucket, so that we can rollback to older deployments if needed
- added optional compute configs for Ray. (1) added config for dedicated head/driver node, (2) added support for KubeRay
- separated demos based on raw-jobs/ (executed using kubectl) and kustomize-jobs/ (using job templates).
- OpenLens for k8s observability
- k8s cluster scales down to zero when idle (except for the system node)

future:
- job templates using `brrr` (high-level JobConfig/ComputeConfig rendered to k8s), to abstract away Helm and raw manifests from scientists. users edit job + compute config while platform guardrails stay centralized.
- mirror across GKE and EKS
- make explicit teardown unnecessary
- multi-node single region jobs, where we can queue in any region but the job remains single-region. and demo gang scheduling (the job gets places when all requried machines are available)


# full e2e demo script

- destroy all terraform infra
- stand up both gcp and eks clouds
- run a few toy multi-node gpu jobs across both
- demonstrate queuing
- demo multi-gpu types
-  demonstrate framework agnosticness