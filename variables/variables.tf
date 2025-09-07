# Примеры типов переменных

# Строка
variable "hello" {
  type        = string
  default     = "Hello world"
  description = "variable with string type"
}

variable "files" {
  description = "List of files to create"
  type        = list(string)
  default     = ["file1.test", "file2.test", "file3.test"]
}

# Число
variable "num" {
  type        = number
  default     = 1
  description = "number type variable"
}

variable "size" {
  type        = number
  default     = 10
  description = "this is size variable "
}

# Список
variable "list" {
  type        = list(any)
  default     = ["a", "b", "c"]
  description = "this is a example of list variable"
}
# Словарь
variable "map" {
  type = map(any)
  default = {
    key1 = "value1"
    key2 = "value2"
  }
  description = "this is a example of map variable"
}
# Объект с различными типами данных
variable "object" {
  description = "example of structural type object"
  type = object({
    name    = string
    age     = number
    tags    = list(string)
    enabled = bool
  })
  default = {
    name    = "test1"
    age     = 42
    tags    = ["a", "b", "c"]
    enabled = false
  }
}

# Объект список хеш таблиц
variable "list-maps-string" {
  description = "list of different types of var"
  type = list(
    object({
      name = string,
      age  = string,
      tags = string,
    })
  )
  default = [{
    name    = "test1"
    age     = "42"
    tags    = "tag1"
  }]
}
