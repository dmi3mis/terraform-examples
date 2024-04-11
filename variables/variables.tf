# Примеры типов переменных

# Строка
variable "hello" {
  type        = string
  default     = "Hello world"
  description = "this is a helloworld striung variable"
}

# Число
variable "num" {
  type        = number
  default     = 123
  description = "this is a 123 number variable"
}

variable "size" {
  type        = number
  default     = 10
  description = "this is a size variable"
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
variable "object_var" {
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
variable "object_var" {
  description = "example of list of map"
  type = list(
    object({
      var1 = string,
      var2 = string,
      var3 = string,
    })
  )
  default = {
    name    = "test1"
    age     = 42
    tags    = ["a", "b", "c"]
    enabled = false
  }
}
