variable "aws_region" {
  type = string
}

variable "name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "public_access_cidrs" {
  type = list(string)

  validation {
    condition     = length(var.public_access_cidrs) > 0
    error_message = "At least one public_access_cidrs entry is required."
  }
}

variable "instance_types" {
  type = list(string)
}

variable "capacity_type" {
  type = string

  validation {
    condition     = contains(["ON_DEMAND", "SPOT"], var.capacity_type)
    error_message = "capacity_type must be ON_DEMAND or SPOT."
  }
}

variable "desired_size" {
  type = number
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}
