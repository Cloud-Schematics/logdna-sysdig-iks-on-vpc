##############################################################################
# Account variables
##############################################################################

variable ibmcloud_api_key {
    description = "The IBM Cloud platform API key needed to deploy IAM enabled resources"
    type        = string
}

variable ibm_region {
    description = "IBM Cloud region where all resources will be deployed"
    type        = string
}

variable generation {
    description = "Generation of VPC where cluster is deployed"
    default     = 2
}

variable resource_group {
    description = "Name for IBM Cloud Resource Group where resources will be deployed"
    type        = string
}

variable cluster_name {
    description = "Name of the cluster where resources will be deployed"
    type        = string
}

##############################################################################


##############################################################################
# Logging Variables
##############################################################################

variable provision_activity_tracker {
    description = "Provision activity tracker. Only one instance of Activity Tracker can be created in a region. Can be `true` or `false`"
    type        = bool
    default     = false
}

variable activity_tracker_name {
    description = "Activity tracker name. Only needed if creating activity tracker"
    type        = string
    default     = "activity-tracker"
}


variable bring_your_own_logging {
  description = "True or false. A logging instance will be created if `false`"
  type        = bool
  default     = false
}


variable logging_instance_name {
    description = "Name of logging instance. Name of the instance to be created if not bringing your own instance, otherwise use the name of your existing instance"
    type        = string
    default     = "cluster-logging"
}

variable logging_agent_image {
    description = "ICR image link for logdna agent"
    type        = string
    default     = "icr.io/ext/logdna-agent:latest"
}

variable logging_endpoint {
    description = "API endpoint prefix for LogDNA (private, public)"
    type        = string
    default     = "private"
}

variable logging_plan {
    description = "Only required when creating resource. Plan for logging instance."
    type        = string
    default     = "7-day"
}

##############################################################################


##############################################################################
# Monitoring Variables
##############################################################################


variable bring_your_own_monitor {
    description = "True or false. A monitor instance will be created if `false`"
    type        = bool
    default     = false
}

variable monitor_name {
    description = "Name of monitoring instance. Name of the instance to be created if not bringing your own instance, otherwise use the name of your existing instance"
    type        = string
    default     = "cluster-monitoring"
}

variable monitor_endpoint {
  description = "API endpoint prefix for Sysdig (private, public, direct)"
  type        = string
  default     = "private" 
}

variable monitor_agent_image {
  description = "ICR Image for monitoring agent"
  type        = string
  default     = "icr.io/ext/sysdig/agent:latest"
}

variable monitor_plan {
  description = "Only required when creating resource. Plan for logging instance."
  type        = string
  default     = "graduated-tier"
}


##############################################################################


##############################################################################
# Resources Variables
##############################################################################

variable tags {
    description = "(Optional) List of tags for resource creation"
    type        = list(string)
    default     = []
}

variable service_end_points {
  description = "Sets the endpoints for the resources if not bringing your own. Can be `public` or `private`"
  type        = string
  default     = "private"
}

##############################################################################