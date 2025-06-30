resource "kubectl_manifest" "argo_rollouts" {

  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: argo-rollouts
  namespace: argocd
spec:
  generators:
    - list:
        elements:
        - cluster: linuxtips-cluster-01
          shard: "01"
        - cluster: linuxtips-cluster-02
          shard: "02"
  template:
    metadata:
      name: argo-rollouts-{{shard}}
    spec:
      project: "system"
      source:
        repoURL: 'https://argoproj.github.io/argo-helm'
        chart: argo-rollouts
        targetRevision: 2.34.1
        helm:
          releaseName: argo-rollouts
          valuesObject:
            dashboard:
              enabled: true
              controller:
                metrics:
                  enabled: true
                  serviceMonitor:
                    enabled: true
      destination:
        name: '{{ cluster }}'
        namespace: argo-rollouts
      syncPolicy:
        syncOptions:
          - CreateNamespace=true
        automated: {}             
YAML

  depends_on = [
    helm_release.argocd
  ]

}