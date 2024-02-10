terraform {
  backend "local" {
    path = "../../../terraform/${var.repository_name}/terraform.tfstate"
  }
}