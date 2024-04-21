# VolSync Template

## Flux Kustomization

This requires `postBuild` configured on the Flux Kustomization

```yaml
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: &app backup-t480s
  namespace: flux-system
spec:
  # ...
  path: ./kubernetes/storage/templates/volsync
  # ...
  postBuild:
    substitute:
      APP: t480s
      VOLSYNC_CAPACITY: 5Gi
```

## Required `postBuild` vars:

- `APP`: The application name
- `VOLSYNC_CAPACITY`: The PVC size

## Optional `postBuild` vars:

- `VOLSYNC_ACCESSMODES`: Volume access mode (default `ReadWriteOnce`)
- `VOLSYNC_CACHE_ACCESSMODES`: Cache volume access mode (default `ReadWriteOnce`)
- `VOLSYNC_CACHE_CAPACITY`: The cache PVC size (default `1Gi`)
- `VOLSYNC_HOSTPATH`: Path to the backup directory in the host (default `/io/backup/${APP}`)
- `VOLSYNC_MOVER_FS_GROUP`: File system group for the mover (default `1000`)
- `VOLSYNC_MOVER_GROUP`: Group of the mover's user (default `1000`)
- `VOLSYNC_MOVER_USER`: User to run the mover as (default `1000`)
- `VOLSYNC_SCHEDULE_B2`: Cron expression for the volume sync schedule for b2 (default `0 2 * * 0`)
- `VOLSYNC_SCHEDULE_MINIO`: Cron expression for the volume sync schedule for minio (default `0 2 * * *`)
