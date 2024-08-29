variable "function_name" {
  type = string 
}
variable "runtime" {
  type = string
}
variable "handler" {
  type = string
  default = "handler.main"
}

variable "zip_path" {
  type = string 
  default = "./lambda.zip"
}

