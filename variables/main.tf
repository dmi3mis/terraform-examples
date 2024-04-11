# Циклы

resource "null_resource" "default" {
  count = 10
  provisioner "local-exec" {
    command = "echo 'Hello World'"
  }
}

variable "files" {
  description = "List of files to create"
  default     = ["file1.txt", "note123.txt", "viz.ps"]
}

resource "null_resource" "create_files" {
  count = length(var.files)
  provisioner "local-exec" {
    command = "touch ${element(var.files, count.index)}"
  }

}