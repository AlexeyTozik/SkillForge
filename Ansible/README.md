Для запуска необходимо прокинуть **ssh ключи** на все подчиненные хосты (ssh-keygen, ssh-copy-id)

ansible.cnf - конфигурационный файл, в котором настраиваются хосты и их опции

any_name.yml - создание playbook

| Команда/Ключ | Описание |
| --- | --- |
| ansible | Основная команда для выполнения операций Ansible. |
| ansible-playbook | Запуск плейбука. |
| -i | Указание файла инвентаризации. |
| -m | Выбор модуля (например, ping, command, copy). |
| -a | Аргументы для передачи модулям (если больше одного аргумента - ставить “”) |
| -u | Имя пользователя, под которым выполняется задача. |
| --become | Выполнение задач от имени суперпользователя. |
| --ask-become-pass | Запрос пароля для sudo (если нужно). |
| -t | Теги - выполнение только определенных задач. |
| --syntax-check | Проверка синтаксиса плейбука. |
| --list-hosts | Вывод списка хостов, которые будут задействованы. |
| --check | Режим проверки (проверяет, но не вносит изменения). |
| --diff | Показывает различия при изменении конфигурации. |
| --limit | Ограничивает группу хостов для выполнения. |
| --start-at-task | Запускает выполнение с определенной задачи. |
| --list-tasks | Выводит список задач из плейбука. |
| --list-tags | Выводит список тегов из плейбука. |
| -e | Передача переменных через командную строку. |
| --extra-vars | Передача переменных в формате JSON или YAML. |
| -vvv | Увеличивает уровень вывода для отладки (verbose). |

| --- | Начало YAML файла (требуется в начале каждого playbook). |
| --- | --- |
| name | Описание плейбука. |
| hosts | Группа хостов, к которым применяется плейбук. |
| become | Указывает, что задачи должны быть выполнены от имени суперпользователя. |
| become_user | Устанавливает пользователя, от которого выполняются задачи. |
| become_method | Метод привилегий, например, sudo или su. |
| vars | Определение переменных (глобальных для плейбука). |
| tasks | Список задач, выполняемых в плейбуке. |
| handlers | Обработчики - задачи, которые выполняются при изменении состояния. |
| roles | Подключение ролей к плейбуку. |
| include | Включение внешних файлов (других плейбуков). |
| import_tasks | Импорт задач из внешнего файла. |
| import_role | Импорт роли из внешнего каталога. |
| tags | Теги для задачи или роли (используется с --tags при выполнении). |
| when | Условие выполнения задачи. |
| ignore_errors | Продолжить выполнение плейбука, даже если задача завершается с ошибкой. |


Все сервера делятся на 2 группы:

- all
- ungrouped

---

ansible -i hosts all -m ping

Если прописали путь к inventory файлу:
ansible all -m ping

---

Выдаёт данные о сервере (группе):

ansible all -m setup

---

Запуск shell команд:

ansible all -m shell -a "uptime"
ansible all -m shell -a "ls /etc | grep upd"
ansible all -m shell -a "ls -la /home"

Как и shell, только без "|;<>&" и переменных окружения:
ansible all -m command -a "pwd"
ansible all -m command -a "ls -la"

---

Копировать файлы из локального на другие сервера:

ansible all -m copy -a "src=hello.txt dest=/home mode=777" -b

"-b" - become sudo
"-a" - attribute

---

Можно работать с файлами, директориями:

ansible all -m file -a "path=/home/hello.txt state=absent"

---

Скачать по указанному url:

ansible all -m get_url -a "url=https://collectors.sumologic.com/rest/download/linux/64 dest=/home" -b

---

Работа с пакетами:

ansible all -m yum "name=stress state=installed" -b
ansible all -m yum "name=httpd state=installed" -b

---

Коннект к сайту:

ansible all -m uri -a "url=https://google.com"
ansible all -m uri -a "url=https://google.com return_content=true"

---

Параметры для дебага:

-v
-vv
-vvv
-vvvv
-vvvvv

---

Посмотреть список доступных модулей:

ansible-doc -l

---

Правила написания yml/yaml:

---

- fruits:
  - apple
  - orange
  - mango
- vegetables:

  - carrots
  - cucumbers

- vasya:
  nick: vasek
  position: developer
  skills:

  - python
  - perl
  - php

- petya:
  nick: petek
  position: manager
  skills:

  - manage
  - make_noise

- kolya: { nick: kolyan, position: administrator, skills: ['killer', 'cleaner'] }

  fruits: ['apple', 'orange', 'mango']

---

в корне создать директорию group_vars, а в файл с названием группы (web-servers). Начало писать через "---". Можно писать КАПСОМ

---

Посмотреть все переменные:

ansible-inventory --list

---

debug - дебаг позволяет вывести сообщение или значение переменной

set_fact - позволяет динамически создавать переменные в скриптах Ansible. Это очень полезно, если новые данные нужно внести в процессе выполнения, не тратя время на этапе проработки. Но у переменных, создаваемых «на лету», есть несколько недостатков:

- высокий приоритет;
- риск сбоев из-за отсутствия
- предварительного тестирования переменной;
- невозможность переопределения переменной.

register - можно записать результат работы модуля shell в переменную с произвольным именем

---

handlers - для обработки
notify - для вызова

---

Блоки и условия:

ansible_os_type - для того, чтобы выбрать тип дистра
when - условие, при котором будет выполняться
block - чтобы избежать множественных when можно описать сразу блок с замыкающим when

---

Циклы:

loop/with*items (старая) - для создания цикла
delay - задержка перед итерациями цикла (OPTIONAL)
retries - количество итераций (по умолчанию 3) (OPTIONAL)
until - до какого момента
with_fileglob - так же, как и loop (указываем "{{ source }}/*.\_")

---

Роли:

Role - это способ структурировать громадные playbook'и чтобы было удобнее управлять

Для инициализации роли:

ansible-galaxy init <role_name>

---

Внешние переменные:

1. Определяем в файле "{{ NAME }}"
2. Вызываем ansible-playbook <playbook_name> --extra-var "NAME=Alexis"

Переменные extra-vars имеют наивысший приоритет и переопределяют все остальные

---

Path будет создавать весь путь, даже если такого не было, т.е.
выражение /secret/creds/key1 создаст весь путь, если он не был создан до этого

import - перед запуском тасков ansible проходится по playbook'у, видит слово import, видит всё, что в это файле, и, сразу же копирует туда. Также сразу же вставляет переменные
include - перед запуском тасков ansible проходится по playbook'у, видит слово include, ничего не делает, а начинает запускать таски, и, лишь тогда, когда дошёл до таски с include, запускает его. Можно именовать, как угодно (include_alexis, include_ansible). Можно переопределять стандартные переменные

include игнорирует tags тасков инклюженого файла
соответственно, если нужно что-то выполнить по тегу, то сработает только импортированные таски, инклюженые не отработают

---

delegate_to - это параметр, который позволяет задать удаленный хост для выполнения конкретной задачи. Он используется в модуле delegate_to, чтобы указать, на каком хосте должна быть выполнена задача, в отличие от основного хоста, на котором выполняется плейбук. Можно использовать как на клиентах, так и на мастере (127.0.0.1)

Если необходимо запустить один раз (выполняется на каком-то из серверов):
run_once: true

---

Асинхронные задачи:

async - позволяет указать время ожидания выполнения задачи в секундах. Он задается на уровне задачи и указывает Ansible на то, что данная задача должна быть выполнена асинхронно
poll - указывает интервал в секундах, с которым Ansible будет проверять статус асинхронной задачи после ее запуска. Если параметр poll не указан, Ansible будет ожидать завершения задачи до тех пор, пока она не выполнится или не истечет время ожидания, указанное в параметре async
wait_for - если вам необходимо дождаться завершения асинхронной задачи перед переходом к следующим шагам плейбука

---

Error handlers:

ignore_errors: yes - позволяет игнорировать ошибки и продолжить выполнение следующих задач
failed_when: <condition> - выборка результатов выполнения успешно или нет исходя из контента
any_errors_fatal: true - любая ошибка будет прекращать выполнение таска

---

Хранение секретов:

ansible-vault create <vault_name> - создать зашифрованный файл vault (запрашивает пароль для шифровки/расшифровки)
ansible-vault view <vault_name> - посмотреть содержимое vault (запрашивает пароль при create)
ansible-vault rekey <vault_name> - изменить пароль на vault (запрашивает пароль при create, предлагает внести новый)
ansible-vault encrypt <file_name> - зашифровать любой файл при помощи vault (запрашивает пароль)
ansible-vault decrypt <file_name> - зашифровать любой файл при помощи vault (запрашивает пароль при encrypt)

ansible-playbook <playbook_name> --ask-vault-pass <password_file> - запускать зашифрованный playbook (также можно указать файл, из которого брать пароль)

ansible-vault encrypt_string - ввести строку, которая будет зашифрована (запрашивает пароль) (начинается с !vault)
echo -n "secretword" | ansible-vault encrypt_string - более практичная структура
