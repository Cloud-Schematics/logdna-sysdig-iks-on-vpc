##############################################################################
# Variables
##############################################################################

variable resource_group_id {
  description = "ID of resource group for sysdig instance"
}

variable use_data {
  description = "Use a data block to create sysdig instance"
}

variable name {
  description = "Name of sysdig instance"
}

variable sysdig_role {
  description = "Role for sysdig agent"
  default     = "Manager"
}

variable ibm_region {
  description = "IBM region for sysdig"
  default     = "us-south"
}

variable cluster_name {
  description = "Name of cluster where sysdig agents will be installed"
}

variable sysdig_endpoint {
  description = "API endpoint prefix for Sysdig (private, public, direct)"
  default     = "private" 
}

variable sysdig_image {
  description = "Sysdig image"
  default     = "icr.io/ext/sysdig/agent:latest"
}

##############################################################################


##############################################################################
# Optional Variables for resource creation
##############################################################################

variable monitor_plan {
  description = "service plan for Monitoring"
  default     = "graduated-tier"
}

variable tags {
  description = "tags for sysdig instance"
  default     = []
}

variable end_points {
  description = "Sets the endpoints for the resources provisioned. Can be `public` or `private`"
  default     = "private"
}

##############################################################################
