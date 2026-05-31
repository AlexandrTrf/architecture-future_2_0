# Terraform Module — Yandex Cloud VM

Модуль разворачивает инфраструктуру в Yandex Cloud: виртуальную сеть, подсеть, загрузочный диск и одну или несколько compute-инстанций на базе Ubuntu 20.04 LTS.

---

## Что делает модуль

- Создаёт VPC-сеть и подсеть (`192.168.10.0/24`) для указанного окружения
- Создаёт загрузочный диск типа `network-ssd` на базе образа `ubuntu-2004-lts`
- Запускает `N` compute-инстанций (`standard-v2`) с NAT и SSH-доступом

---

## Input Variables

| Переменная         | Тип      | Описание                                                                           |
|--------------------|----------|------------------------------------------------------------------------------------|
| `env_name`         | `string` | Имя окружения (`dev`, `stage`, `prod`). Используется как префикс для всех ресурсов |
| `cloud_id`         | `string` | ID облака в Yandex Cloud                                                           |
| `folder_id`        | `string` | ID каталога в Yandex Cloud                                                         |
| `zone`             | `string` | Зона доступности (например, `ru-central1-d`)                                       |
| `cores`            | `number` | Количество vCPU для каждой инстанции                                               |
| `memory`           | `number` | Объём RAM в ГБ для каждой инстанции                                                |
| `disk_size`        | `number` | Размер загрузочного диска в ГБ                                                     |
| `instance_count`   | `number` | Количество создаваемых инстанций                                                   |
| `ssh_pub_key_path` | `string` | Публичный SSH ключ для доступа к ВМ                                                |
---

## Outputs

| Output           | Тип            | Описание                                                 |
|------------------|----------------|----------------------------------------------------------|
| `vm_external_ip` | `list(string)` | Список внешних (NAT) IP-адресов всех созданных инстанций |
| `vm_name`        | `list(string)` | Список имён инстанций в формате `<env_name>-app-<index>` |
| `vm_id`          | `list(string)` | Список ID инстанций в Yandex Cloud                       |

---

## Структура проекта

```
.
├── modules/
│   └── vm/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── envs/
    ├── dev/
    │   └── terraform.tfvars
    ├── stage/
    │   └── terraform.tfvars
    └── prod/
        └── terraform.tfvars
```

---

## Запуск

### 1. Подготовка

Установить terraform, yc, сформировать ssh ключи для доступа к ВМ.

Выполнить команды
```shell
yc init
yc resource-manager folder list
```

Записать в файл ./modules/vm/variables.tf значение `FOLDER_ID` в переменную `folder_id`.

Указать в файле ./modules/vm/variables.tf путь к публичному ключу SSH в переменной `ssh_pub_key_path`.

Создать service account
```shell
yc iam service-account create --name terraform-sa
yc iam service-account list
```
Запомнить `SERVICE_ACCOUNT_ID`, предоставить права для SA.
```shell
yc resource-manager folder add-access-binding <FOLDER_ID> `
  --role editor `
  --subject serviceAccount:<SERVICE_ACCOUNT_ID>

yc resource-manager folder add-access-binding <FOLDER_ID> `
  --role compute.admin `
  --subject serviceAccount:<SERVICE_ACCOUNT_ID>
  
yc resource-manager folder add-access-binding <FOLDER_ID> `
  --role vpc.admin `
  --subject serviceAccount:<SERVICE_ACCOUNT_ID>

```

Создать key.json для доступа к YC.

```shell
yc iam key create `
  --service-account-id <SERVICE_ACCOUNT_ID> `
  --output key.json
```

Указать в файле ./modules/vm/variables.tf путь к файлу key.json в переменной `keyfile`.



### 1. Инициализировать и применить конфигурацию

Укажите нужное окружение вместо `<env>`:

```shell
# dev
terraform init
terraform validate
terraform apply -var-file=./envs/dev/terraform.tfvars

# stage
terraform init
terraform validate
terraform apply -var-file=./envs/stage/terraform.tfvars

# prod
terraform init
terraform validate
terraform apply -var-file=./envs/prod/terraform.tfvars
```
