##############################################################################
# Locally define image pull secrets to copy to ibm-observe namespace 
##############################################################################

locals {
  image_pull_secrets = [
      "all-icr-io"
    ]
} 

##############################################################################


##############################################################################
# Create Namespace
##############################################################################

resource kubernetes_namespace ibm_observe {
  metadata {
    name = "ibm-observe"
  }
}

##############################################################################


##############################################################################
# Default pull secret
##############################################################################

data kubernetes_secret image_pull_secret {
  count = length(local.image_pull_secrets)
  metadata {
    name = "default-${element(local.image_pull_secrets, count.index)}"
  }
}

##############################################################################


##############################################################################
# Copy image pull secret to ibm-observe
##############################################################################

resource kubernetes_secret copy_image_pull_secret {
  count = length(local.image_pull_secrets)
  metadata {
    name      = "ibm-observe-${element(local.image_pull_secrets, count.index)}"
    namespace = kubernetes_namespace.ibm_observe.metadata.0.name
  }
  data      = {
    ".dockerconfigjson" = data.kubernetes_secret.image_pull_secret[count.index].data[".dockerconfigjson"]
  }
  type = "kubernetes.io/dockerconfigjson"
}

##############################################################################