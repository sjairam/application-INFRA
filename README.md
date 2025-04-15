## application TEMPLATE

This is an application INFRA repo.  Developers can create their REPOS based on this template.

## Requirements 

- kubectl 
- kustomize

## Migration of Application to K8S

- Once you have cloned this repo, start by editing the files within the 'base' folder

- Within the base folder, modify these files as follows:
  - cron.yaml  (This ia a cron template if your application needs a cron job)
  - config.yaml    (This is the configmap for the application)
  - deploy.yaml    (This is the main yaml file for the deployment of the application)
  - persistent_volume.yaml 
  - persistent_volume_claim.yaml  (This details how the application can use PV / PVCs off 1 EFS mount)
  - secret-store.yaml (This is the secretstore that the application uses to get the secrets)
  - service.yaml   (This details what the application service name should be called)
  - secrets.yaml   (This is the external secrets for ESO.  Each application will have their own external secrets)

### Limit Guidelines

 This template includes CPU and memory minimums and limits for apps. For non-Java applications, you can copy the same limits you've used in swarm. For Java applications, the minimum and limit memory need to be set the same. In addition, for Java applications we recommend starting with 2G memory, and 0.5 CPU minimum and 1.0 CPU limit.

## Istio

We are using a service mesh (istio.io) to integrate the ingress and virtual service for the application.
Therefore, you will need to edit the following files in the 'base' folder

- Within the base folder, modify these files as follows:
  - ingress.yaml    (This defines the gateway the application will use)
  - virtualservice.yaml (This defines the VS for the application)

```yaml
  gateways:
    - application-gateway             # This should tie in with the name in ingress.yaml
```

```yaml
  http:
    - match:
        - uri:
            prefix: /api              # prefix for the application
#      rewrite:                       # rewrite example, if required
#        uri: "/"
      route:
        - destination:
            host: application-service # service name which will tie in with service.yaml
            port:
              number: 12000
```


Within the deploy.yaml is an example of a volume Mount if the application needs it
However we are moving away from .env / env.js file to use configmaps.

First example in the dpeloy.yaml is the section to reference the configmap

```yaml
envFrom:
- configMapRef:
name: application-config-file    # This is the configmaps reference
```

The second example is for the volume mount if the app needs a volume mount

```yaml
  volumeMounts:                         # This is an example of the .env VM
    - name: logs-volume
      mountPath: /home/node/logs
```

## Deploy

For the deployment we are using a PULL model rather than a PUSH model.  (Refer to ArgoCD video)
For this approach, you need to edit the application.yaml in the argocd folder

### Part 1
Within the source section, you will change the 'application-INFRA'  name to your application name
For the moment, the 'path' section is resolving to 'sandbox1'

```yaml
  source:
    repoURL: https://github.huit.harvard.edu/LTS/application-INFRA
    targetRevision: main
    path: envs/sandbox1
```

### Part 2

You need to request the Ops team to link up your repo in ArgoCD and ask them to execute the application.yml

## Kustomization

The kustomization file existsto coordinate overrides based on environments. For example, in production we use a numbered version of an image (my-image:v1.0.0) but in dev we use a different tag (my-image-dev:latest). We want to make sure that in dev we do a deploy using that image so we would use kustomize to override the deploy with the correct deploy.

In your base folder, kustomize has the standard files (usually the dev values are used when values are needed). For your overrides, we would create the required folders (ex: envs/dev envs/qa envs/prod) and put the files we want to use instead of what is in base, as well as a kustomize.yaml that specifies which files are being overriden. This template repository has some examples in the dev and sandbox1 folders.

When configuring your application in Argo, you'll want to make sure you target the correct folder for the correct environment.


## References

* ESO [https://external-secrets.io/latest/]
* Istio [https://istio.io]
* Rancher [https://www.rancher.com/]
