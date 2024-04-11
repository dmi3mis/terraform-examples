output "hello" {
  value = var.hello
}
output "number" {
  value = var.num
}
output "list" {
  value = var.list
}
output "object_var" {
  value = var.object_var
}

output "size_in_KB" {
  value = var.size * pow(2, 10)
}
output "size_in_MB" {
  value = var.size * pow(2, 20)
}
output "size_in_GB" {
  value = var.size * pow(2, 30)
}

variable "list" {
  description = "List of elements"
  default     = ["file1.txt", "note123.txt", "viz.ps"]
}

output "output_of_list" {
  value = var.list[*]
}

  