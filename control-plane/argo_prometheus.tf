resource "kubectl_manifest" "prometheus" {

  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: prometheus
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
      name: prometheus-{{shard}}
    spec:
      project: "system"
      source:
        repoURL: 'https://prometheus-community.github.io/helm-charts'
        chart: prometheus
        targetRevision: 27.11.0
        helm:
          releaseName: prometheus
          valuesObject:
            server:
              global:
                scrape_interval: 15s
                evaluation_interval: 15s
                external_labels:
                    cluster: "{{ cluster }}"
              persistentVolume:
                enabled: false

              remoteWrite:
                - url: "http://mimir.linuxtips-observability.local:80/api/v1/push"
                  queue_config:
                    max_samples_per_send: 1000
                    max_shards: 20
                    capacity: 5000
                
            prometheus-node-exporter:
              enabled: true
            alertmanager:
              enabled: false
              
      destination:
        name: '{{ cluster }}'
        namespace: prometheus
      syncPolicy:
        syncOptions:
          - CreateNamespace=true
        automated: {}
YAML

  depends_on = [
    helm_release.argocd
  ]
}