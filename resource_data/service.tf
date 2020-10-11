##############################################################################
# Create certificate manager 
##############################################################################

resource ibm_resource_instance service {
  count             = var.use_data ? 0 : 1
  name              = var.name
  service           = var.service
  plan              = var.plan
  location          = var.ibm_region
  resource_group_id = var.resource_group_id != "" ? var.resource_group_id : null

  parameters = {
    "HMAC"            = var.HMAC ? true : null
    service-endpoints = var.end_points
  }

  tags = var.tags

}

##############################################################################


################################################################################
# Get CMS Instance Data
################################################################################

data ibm_resource_instance service {
  count             = var.use_data ? 1 : 0
  name              = var.name
  resource_group_id = var.resource_group_id != "" ? var.resource_group_id : null
  service           = var.service
}

################################################################################


################################################################################
# Locals
################################################################################

locals {
  service_id = (
    var.use_data
    ? data.ibm_resource_instance.service.0.id 
    : ibm_resource_instance.service.0.id
  )
}

################################################################################


################################################################################
# Output
################################################################################

output id {
  description = "ID of service instance"
  value       = local.service_id
}

################################################################################