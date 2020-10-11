##############################################################################
# Variables
##############################################################################

variable use_data {
    description = "Use data block to get resource ID"
    default     = false
}

variable name {
    description = "Name of resource. Needed for both data and resource"
}

variable resource_group_id {
    description = "id of resource group for service. Needed for both data and resource"
}

variable service {
    description = "Name of service. Needed for both data and resource. (ex. cloudcerts)"
}

##############################################################################


##############################################################################
# Resource Creation Variables (Optional)
##############################################################################

variable ibm_region {
  description = "IBM Cloud region where resource will be deployed"
  default     = "us-south"
}

variable end_points {
  description = "Sets the endpoints for the resource provisioned. Can be `public` or `private`"
  default     = "public"
}

variable plan {
  description = "service plan for resource. Depends on type of service created"
}

variable HMAC {
    description = "Add HMAC parameters to service. May not be supported by all services"
    default     = false
}

variable tags {
  description = "List of tags for created resource"
  default     = ["resources-module"]
}

##############################################################################