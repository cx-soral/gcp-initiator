variable "project_id" {
  type = string
}

variable "repository_name" {
  type = string
}

variable "cloudbuild_filename" {
  type = string
}

variable "branch_name" {
  type = string
  default = null
}

variable "tag_name" {
  type = string
  default = null
}