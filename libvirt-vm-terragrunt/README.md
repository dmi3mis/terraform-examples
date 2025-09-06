## 1. Установите Terragrunt:

 Для Ubuntu/Debian

```console
wget https://github.com/gruntwork-io/terragrunt/releases/download/v0.87.0/terragrunt_linux_amd64
sudo mv terragrunt_linux_amd64 /usr/local/bin/terragrunt
sudo chmod +x /usr/local/bin/terragrunt
```

Или используйте менеджер пакетов

## 2. Разверните 

для всех окружений
```console
terragrunt run --all --non-interactive init 
terragrunt run --all --non-interactive plan
terragrunt run --all --non-interactive apply
terragrunt run --all --non-interactive output
```

на конкретном окружении:

Для development

```console
cd environments/dev
terragrunt init
terragrunt plan
terragrunt apply
```

# Для QA

```console
cd environments/qa
terragrunt init
terragrunt plan
terragrunt apply
```

# Для production

```console
cd environments/prod
terragrunt init
terragrunt plan
terragrunt apply
```

## 3. Просмотрите выходные данные:

```console
terragrunt output
```

## 4. Уничтожьте ресурсы:


```console
terragrunt run --all destroy
```

Преимущества этого подхода:
* Мульти-хост поддержка - разные хосты для разных окружений
* Изоляция окружений - отдельные конфигурации для dev/qa/prod
* Гибкость - легко добавлять новые окружения и хосты
* Повторное использование - один Terraform код для всех окружений
* Безопасность - разные учетные данные для разных хостов

Теперь вы можете легко управлять виртуальными машинами на разных libvirt хостах с помощью Terragrunt!
