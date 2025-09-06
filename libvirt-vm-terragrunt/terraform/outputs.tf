# You can connect to vm with this command
# 
# ssh -oStrictHostKeyChecking=no  ubuntu@$(terraform output -no-color  -json virtual_machines |jq -r '.fs1.ip')

output "virtual_machines" {
  description = "Информация о созданных виртуальных машинах"
  value = {
    for vm_name, vm_module in module.vms :
    vm_name => {
      id   = vm_module.vm_id
      name = vm_module.vm_name
      ip   = vm_module.vm_ip
    }
  }
}

