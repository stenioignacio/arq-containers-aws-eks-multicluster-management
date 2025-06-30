resource "kubectl_manifest" "kiali" {

  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: kiali
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
      name: kiali-{{shard}}
    spec:
      project: "system"
      source:
        repoURL: 'https://kiali.org/helm-charts'
        chart: kiali
        targetRevision: "2.5"
        helm:
          releaseName: kiali
      destination:
        name: '{{ cluster }}'
        namespace: istio-system
      syncPolicy:
        syncOptions:
          - CreateNamespace=true
        automated: {}
YAML

  depends_on = [
    helm_release.argocd
  ]

}