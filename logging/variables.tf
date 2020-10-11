##############################################################################
# Variables
##############################################################################

variable ibm_region {
    description = "IBM Region where resource will be provisioned"
}

variable name {
    description = "Name for logDNA instance"
}

variable resource_group_id {
    description =  "ID of resource groupr for logdna instance"
}

variable use_data {
    description = "Use data block for logdna instance"
    default     = true
}

variable logdna_agent_image {
    description = "ICR image for logdna agent"
    default     = "uk.icr.io/asset-bp2i-test/logdna-agent:latest"
}

variable logdna_endpoint {
    description = "API endpoint prefix for LogDNA (private, public, direct)"
    default     = "private"
}

variable log_role {
    description  = "Role for logdna secret"
    default      = "Manager"
}

##############################################################################


##############################################################################
# Resource Creation Variables
##############################################################################

variable logging_plan {
    description = "Optional when creating resource. Plan for LogDNA instance"
    default     = "7-day"
}

variable tags {
    description = "(Optional) List of tags for resource creation"
    default     = []
}

variable end_points {
  description = "Sets the endpoints for the resources provisioned. Can be `public` or `private`"
  default     = "public"
}

##############################################################################