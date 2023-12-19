# VolSync Template

## Flux Kustomization

This requires `postBuild` configured on the Flux Kustomization

```yaml
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: &app home-assistant
  namespace: flux-system
spec:
  # ...
  postBuild:
    substitute:
      APP: *app
      VOLSYNC_CAPACITY: 5Gi
```

and then call the template in your applications `kustomization.yaml`

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  # ...
  - ../../../../templates/volsync
```

## Required `postBuild` vars:

- `APP`: The application name
- `VOLSYNC_CAPACITY`: The PVC size

## Optional `postBuild` vars:

- `VOLSYNC_ACCESSMODES`: Volume access mode (default `ReadWriteOnce`)
- `VOLSYNC_CACHE_ACCESSMODES`: Cache volume access mode (default `ReadWriteOnce`)
- `VOLSYNC_CACHE_CAPACITY`: The cache PVC size (default `1Gi`)
- `VOLSYNC_CACHE_STORAGECLASS`: The storage class for the cache PVC (default `local-path`)
- `VOLSYNC_COPYMETHOD`: The copy method (default `Snapshot`)
- `VOLSYNC_MOVER_FS_GROUP`: File system group for the mover (default `568`)
- `VOLSYNC_MOVER_GROUP`: Group of the mover's user (default `568`)
- `VOLSYNC_MOVER_USER`: User to run the mover as (default `568`)
- `VOLSYNC_SCHEDULE`: Cron expression for the volume sync schedule (default `0 2 * * *`)
- `VOLSYNC_STORAGECLASS`: The storage class for the PVC (default `local-path`)
