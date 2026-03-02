- made KubeRay optional
- used Kueue for gang scheduling, and governance features like fair scheduling
- terraform for deployment, to make this infra portable across GKE and EKS
- terraform state tracked by s3, so that anyone can run terraform

future:
- job templates using Kustomize, to abstract away Helm and k8s manifests from scientists. better ergonomcis and guardrails. users just need to edit image, command, resources, queue. separates job submission from the platform infra
- a bunch of examples
- a UI?
