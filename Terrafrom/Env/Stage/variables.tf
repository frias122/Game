variable "instance_groups" {
  description = "Groups of instances to be created"
  type = map(object({
    ami           = string
    instance_type = string
    count         = number
  }))
}
