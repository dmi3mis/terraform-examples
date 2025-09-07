output "hello" {
  value = var.hello
}
output "number" {
  value = var.num
}
output "list" {
  value = var.list
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

output "output_of_list" {
  value = var.list[*]
}

output "object" {
  value = var.object
}

output "list-maps-string" {
  value = var.list-maps-string
}
