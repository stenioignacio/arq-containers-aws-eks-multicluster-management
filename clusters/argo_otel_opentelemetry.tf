resource "kubectl_manifest" "otel" {

  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: opentelemetry-collector
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
      name: opentelemetry-collector-{{shard}}
    spec:
      project: "system"
      source:
        repoURL: 'https://open-telemetry.github.io/opentelemetry-helm-charts'
        chart: opentelemetry-collector
        targetRevision: "0.122.0"
        helm:
          releaseName: opentelemetry-collector
          valuesObject:
            mode: deployment
            image:
              repository: otel/opentelemetry-collector-k8s
              pullPolicy: IfNotPresent
              tag: 0.122.0
            config:
              receivers:
                otlp:
                  protocols:
                    grpc:
                      endpoint: 0.0.0.0:4317
                    http:
                      endpoint: 0.0.0.0:4318
                zipkin: {}
              processors:
                batch: {}
              exporters:
                otlphttp:
                  endpoint: "http://tempo.linuxtips-observability.local"
                  tls:
                    insecure: true
              service:
                pipelines:
                  traces:
                    receivers:
                      - otlp
                      - zipkin
                    processors:
                      - batch
                    exporters:
                      - otlphttp
      destination:
        name: '{{ cluster }}'
        namespace: opentelemetry
      syncPolicy:
        syncOptions:
          - CreateNamespace=true
        automated: {}
YAML

  depends_on = [
    helm_release.argocd
  ]

}