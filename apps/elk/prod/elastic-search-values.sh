replicas: 1
minimumMasterNodes: 1
resources:
  requests:
    memory: "1Gi"
    cpu: "500m"
volumeClaimTemplate:
  resources:
    requests:
      storage: 5Gi
