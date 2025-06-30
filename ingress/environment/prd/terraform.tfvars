project_name = "linuxtips-ingress"

ssm_vpc = "/linuxtips-kubernetes-vpc/vpc/id"
ssm_subnets = [
  "/linuxtips-kubernetes-vpc/subnets/public/us-east-1a/linuxtips-public-1a",
  "/linuxtips-kubernetes-vpc/subnets/public/us-east-1b/linuxtips-public-1b",
  "/linuxtips-kubernetes-vpc/subnets/public/us-east-1c/linuxtips-public-1c",
]

routing_weight = {
  cluster_01 = 0
  cluster_02 = 100
}