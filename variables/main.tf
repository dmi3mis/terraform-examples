# Циклы

resource "terraform_data" "example-singleline" {
  provisioner "local-exec" {
    command = "echo 'Hello World'"
  }
}

resource "terraform_data" "create-files" {
  count = length(var.files)
  provisioner "local-exec" {
    command = "touch ${element(var.files, count.index)}"
  }

}