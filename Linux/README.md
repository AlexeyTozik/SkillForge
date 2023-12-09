<h1>File System Hierarchy</h1>

| command | description |
| --- | --- |
| / | корневая директория  |
| /bin | содержит исполняемые файлы утилит командной строки (cat, ls…) |
| /boot | содержит необходимые файлы для загрузки системы (grub, ядро) |
| /dev | находятся файлы всех устройств |
| /etc | все конфигурационные файлы (при переопределении конфигурационных файлов использует впервую очередь эти настройки) |
| /lib | библиотеки, необходимые для программ, лежащих в каталоге /bin |
| /lib32, /lib64 | 32, 64-х битные библиотеки (для определённых программ) |
| /media | съемные носители |
| /mnt | для сохранения совместимости (теперь /media), для монтирования |
| /opt | проприетарное ПО, самозборные программы и портабл версии софта |
| /proc | отображает системную инф-ю о процессах, можно получить инф-ю о железе |
| /run | инф-я о запускаемых с системой службах (демонах) (удаляется при каждой перезагрузке) |
| /sbin | утилиты для администрования (iptables, useradd и т.д.) |
| /srv | сервисы, предоставляемые веб-серверами (нигде не используется) |
| /sys | инф-я об устройствах от ядра (температура процессора, количество оборотов вентилятора) |
| /tmp | временные файлы, пакеты обновления системы |
| /var | все системые журналы, логи, кэш, вспомогательные файлы |
| /usr | всё, что касается юзера  |


<h1>Command Line Interface (CLI)</h1>

| command | description |
| --- | --- |
| cd | Переход в другую директорию. |
| ls | Просмотр содержимого текущей директории или указанной директории. |
| pwd | Отображение текущей рабочей директории. |
| cp | Копирование файлов и директорий. |
| mv | Перемещение и переименование файлов и директорий. |
| rm | Удаление файлов и директорий. |
| cat | Вывод содержимого файла в терминал. |
| echo | Вывод аргументов в терминал или запись текста в файл. |
| touch | Создание пустого файла или обновление времени модификации существующего файла. |

<h1>Users & Permissions</h1>


| command | description |
| --- | --- |
| useradd | Добавить пользователя |
| passwd | Используется для задания пароля пользователю |
| usermod | Для редактирования пользователя |
| userdel | Удалить пользователя |
| groupadd | Добавить группу |
| groupmod | Изменить свойства группы |
| groupdel | Удалить группу |
| chmod | Используется для изменения прав доступа к файлам. |
| chown | Используется для смены владельца файла или каталога. |
| chgrp | Используется для изменения принадлежности группы к файлу или каталогу. Это позволяет вам назначить другую группу для файла или каталога. |
| ulimit | Позволяет управлять ограничениями ресурсов для текущего сеанса пользователя. 
| SUID (Set User ID) | Разрешение SUID позволяет выполнять файл с привилегиями владельца файла. |
| SGID (Set Group ID) | Разрешение SGID позволяет выполнять файл с привилегиями группы владельца файла. |
| Запрет на изменение (Sticky Bit) | Запрет на изменение применяется к директориям и ограничивает возможность удаления или переименования файлов в этой директории только владельцем файла или администратором системы.|
| ACL (Access Control Lists) | Список контроля доступа (ACL) расширяет стандартные разрешения файловой системы, предоставляя более гибкий уровень контроля доступа. |

<h1>Package Management</h1>

| command | description |
| --- | --- |
| sudo apt-get update | обновить информацию о локальном репозитории пакетов. |
| sudo apt-get install имя_пакета | установить определенный пакет. |
| sudo apt-get upgrade | обновить установленные пакеты до последних версий. |
| sudo apt-get remove имя_пакета | удалить определенный пакет. |
| sudo apt-cache search search_term | поиск пакетов, соответствующих определенному термину. |

<h1>Process & Jobs</h1>

|command|description|
|---|---|
|ps|Команда ps используется для получения информации о активных процессах, работающих в системе. Она отображает снимок текущих выполняющихся процессов.|
|top|Команда top предоставляет информацию в режиме реального времени о процессах и использовании системных ресурсов|
|kill|Команда kill используется для прекращения работы процесса путем отправки ему сигнала. По умолчанию она отправляет сигнал SIGTERM, который запрашивает процесс завершиться корректно|
|pkill|Команда pkill используется для отправки сигнала процессам на основе их имен. Она ищет процессы, соответствующие указанному шаблону, и завершает их работу. |
|pgrep|Для поиска идентификаторов процессов на основе их имен. |
|jobs|Команда jobs используется для отображения статуса выполняющихся или фоновых процессов в текущей сеансе оболочки.|
|nice|Команда nice используется для запуска процесса с измененным приоритетом.|
|renice|Как и команда nice, только её улучшенная версия|
|disown|Команда disown позволяет открепить задание от текущего терминала, чтобы оно продолжало выполняться независимо от него.|
|nohup|Команда nohup используется для запуска процесса, который будет продолжать работу после завершения текущего сеанса пользователя.|
|& (амперсанд)|Символ & используется для запуска процесса в фоновом режиме.|
|bg|Возобновляет приостановленные задания (например, с помощью Ctrl + Z) и поддерживает их выполнение в фоновом режиме.|
|fg|Запускать задания на переднем плане.|
|lsof|Отображения списка файлов, открытых конкретным процессом.|
|fuser|Ищет процессы, которые занимает конкретный файл|