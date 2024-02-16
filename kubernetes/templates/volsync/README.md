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
- `VOLSYNC_BACKUP_MOVER_FS_GROUP`: File system group for the mover (defaults to the value of `VOLSYNC_MOVER_FS_GROUP`)
- `VOLSYNC_BACKUP_MOVER_GROUP`: Group of the mover's user (defaults to the value of `VOLSYNC_MOVER_GROUP`)
- `VOLSYNC_BACKUP_MOVER_USER`: User to run the mover as (defaults to the value of `VOLSYNC_MOVER_USER`)
- `VOLSYNC_CACHE_ACCESSMODES`: Cache volume access mode (default `ReadWriteOnce`)
- `VOLSYNC_CACHE_CAPACITY`: The cache PVC size (default `1Gi`)
- `VOLSYNC_CACHE_STORAGECLASS`: The storage class for the cache PVC (default `local-path`)
- `VOLSYNC_COPYMETHOD`: The copy method (default `Snapshot`)
- `VOLSYNC_MOVER_FS_GROUP`: File system group for the mover (default `568`)
- `VOLSYNC_MOVER_GROUP`: Group of the mover's user (default `568`)
- `VOLSYNC_MOVER_USER`: User to run the mover as (default `568`)
- `VOLSYNC_RESTORE_MOVER_FS_GROUP`: File system group for the mover (defaults to the value of `VOLSYNC_MOVER_FS_GROUP`)
- `VOLSYNC_RESTORE_MOVER_GROUP`: Group of the mover's user (defaults to the value of `VOLSYNC_MOVER_GROUP`)
- `VOLSYNC_RESTORE_MOVER_USER`: User to run the mover as (defaults to the value of `VOLSYNC_MOVER_USER`)
- `VOLSYNC_SCHEDULE_B2`: Cron expression for the volume sync schedule for b2 (default `0 2 * * 0`)
- `VOLSYNC_SCHEDULE_MINIO`: Cron expression for the volume sync schedule for minio (default `0 2 * * *`)
- `VOLSYNC_SNAPSHOTCLASS`: The storage class for volume snapshots (default `longhorn`)
- `VOLSYNC_STORAGECLASS`: The storage class for the PVC (default `longhorn`)
