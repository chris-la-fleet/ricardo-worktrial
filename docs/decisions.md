- made KubeRay optional. changed my mind and went for generic k8s setup so that we are not forced into Ray JobConfig semantics for non-Ray workloads.
- used Kueue for gang scheduling, and governance features like fair scheduling
- terraform for deployment, to make this infra portable across GKE and EKS
- terraform state tracked by s3, so that anyone can run terraform apply from any host.
- configured the tf state s3 bucket as a versioned bucket, so that we can rollback to older deployments if needed
- added optional compute configs for Ray. (1) added config for dedicated head/driver node, (2) added support for KubeRay
- separated demos based on raw-jobs/ (executed using kubectl) and kustomize-jobs/ (using job templates).

future:
- job templates using Kustomize, to abstract away Helm and k8s manifests from scientists. better ergonomcis and guardrails. users just need to edit image, command, resources, queue. separates job submission from the platform infra
- a bunch of runnable job submission examples
- a UI?
- mirror across GKE and EKS
- multi-node single region jobs, where we can queue in any region but the job remains single-region.
- k8s cluster scales down to zero when idle (except for the system node)

# full e2e demo script

- destroy all terraform infra
- stand up both gcp and eks clouds
- run a few toy gpu workloads across both