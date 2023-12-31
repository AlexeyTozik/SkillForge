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

<h1>Job Scheduling</h1>

|command|description|
|---|---|
| CRON | Cистемный планировщик задач, который позволяет запускать задачи в определенное время или периодически.Конфигурация cron выполняется с помощью файла crontab, который содержит список задач и времени их выполнения. |
| anacron | Асинхронный планировщик заданий. Не поддерживает запуск заданий по расписанию, но позволяет запускать задания с заданным интервалом времени (не быстрее         1 раз/день)|
| AT | Позволяет запускать одноразовые задачи в определенное время. Задачи, запланированные с помощью at, выполняются только один раз в указанное время.|

<h1>System Monitoring</h1>

|command|description|
|---|---|
| top | Как было упомянуто ранее, команда top предоставляет информацию в реальном времени о процессах и использовании системных ресурсов. Она показывает использование ЦП, потребление памяти, средние загрузки и другую информацию.|
| htop | Аналогично команде top, htop является интерактивным просмотрщиком процессов, предоставляющим более удобный пользовательский интерфейс.|
| vmstat | Команда vmstat предоставляет информацию о использовании виртуальной памяти, включая сведения о процессах, памяти, пейджинге, блочном вводе-выводе (I/O) и активности ЦП|
| iostat | Показывает нагрузку ввода-вывода и активность использования дисков|
| dstat | Универсальный инструмент для создания статистики системных ресурсов|
| df | Команда df показывает объем использованного и доступного дискового пространства на файловых системах. Она предоставляет обзор использования дискового пространства для различных разделов или файловых систем, примонтированных в системе.|
| du | Команда du вычисляет использование дискового пространства для файлов и каталогов. Она помогает определить размер отдельных файлов или каталогов, помогая выявить элементы, потребляющие много места.|
| ncdu | Является инструментом для анализа использования дискового пространства в командной строке Unix или Linux с использованием интерфейса NCurses.|
| free | Команда free предоставляет информацию о использовании памяти системы, включая общий объем, используемую и свободную память, а также буферы и кэши памяти. Она помогает отслеживать и анализировать использование памяти. |
| sar | Для сбора и отображения статистики производительности системы в определенные интервалы времени.|
| strace | Команда strace используется для отслеживания и анализа системных вызовов, выполняемых процессами.|

<h1>File and Text Manipulation</h1>

|command|describe|
|---|---|
| grep | Поиск заданного шаблона или регулярного выражения в файлах.|
| awk | Универсальный язык обработки текста, работает с полями в строках. Часто используется для извлечения, преобразования и отчетности данных.|
| sed (stream editor) | Потоковый редактор для фильтрации и преобразования текста. Выполняет поиск, замену, вставку, удаление и другие операции.|
| sort | Сортирует строки в файле по алфавиту или числовому значению|
| cut | Извлекает определенные разделы (колонки) из файлов на основе разделителя.|
| diff/colordiff (diff с подсветкой изменений) | Сравнивает файлы и отображает их различия|
| wc | Подсчитывает строки, слова и символы в файле|
| head | Отображает начальные строки файла (10).|
| tail | Отображает конечные строки файла (10).|
| find | Ищет файлы и каталоги на основе различных критериев.|
| uniq | Команда uniq удаляет повторяющиеся строки из входного потока или файла.|
| tr | Команда tr используется для трансляции или замены символов во входных данных.|
| paste | Команда paste используется для объединения строк файлов или файловых дескрипторов по горизонтали.|
| join | Команда join используется для объединения строк файлов на основе совпадающих полей.|
| split | Команда split используется для разделения файла на несколько файлов более маленького размера.|
| comm | Команда comm используется для сравнения двух сортированных файлов по строкам и выводит их общие строки и уникальные строки каждого файла.|
| column | Команда column используется для форматирования текстовых столбцов для лучшей читабельности.|
| fmt | Команда fmt используется для форматирования текста с заданным ограничением ширины строки.|
| expand | Команда expand используется для замены символов табуляции пробелами в текстовых файлах.|

<h1>Input/Output Redirection and Pipelines</h1>

|command|description|
|---|---|
| > | Перенаправление вывода команды в файл|
| >> | Добавление вывода команды в конец файла|
| < | Перенаправление ввода команды из файла|
| I | Создание конвейера (pipeline) для передачи вывода одной команды на вход другой команды|
| tee | Запись вывода команды в файл и передача его на стандартный вывод|

<h1>Shell Environment</h1>

|command|description|
|---|---|
| Переменные окружения и экспорт | Переменные окружения представляют информацию о вашей оболочке, системе и пользовательском окружении|
| .bashrc и .bash_profile | bashrc - скрипт, выполняющийся при запуске интерактивной оболочки (non-login shell). bash_profile - скрипт, выполняющийся при входе в систему или запуске login shell.|
| Псевдонимы (alias) | Псевдонимы позволяют создавать сокращенные формы команд для удобства использования.|
| set | Команда set отображает список переменных окружения, псевдонимов и других настроек текущей оболочки.|
| export | Команда для пометки переменных оболочки в текущей среде для экспорта с любыми недавно разветвленными дочерними процессами.|
| unset | Удалить переменную среды  |

<h1>Networking</h1>

|command|description|
|---|---|
| ping | Используется для проверки доступности узлов сети (хостов) и измерения времени, необходимого для передачи сетевых пакетов (ICMP-пакетов) до узла и обратно. Команда ping также позволяет определить задержку (задержку времени) и потерю пакетов в сети.|
| netstat | Отображение сетевых соединений, таблицы маршрутизации и другой сетевой статистики.|
| netcat | Команда netcat, также известная как nc, позволяет устанавливать соединения с удаленными хостами по TCP или UDP и выполнять простую сетевую передачу данных.|
| netdiscover | Является инструментом для обнаружения устройств в локальной сети. Она позволяет сканировать сеть и определять IP-адреса, MAC-адреса и другую информацию о доступных устройствах.|
| nmap | Команда nmap используется для сканирования сети и определения активных хостов, открытых портов и других сетевых служб.|
| traceroute | Команда traceroute используется для отслеживания пути, которым проходят сетевые пакеты от исходного хоста до указанного назначения.|
| dig | Используется для выполнения DNS-запросов и получения информации о доменных именах и их связанных записях.|
| host | Используется для выполнения DNS-запросов и получения информации об указанном доменном имени или IP-адресе. Она позволяет получить информацию о доменных именах, преобразовать доменные имена в IP-адреса и наоборот.|
| arp | Команда arp (Address Resolution Protocol) используется для отображения или изменения таблицы преобразования IP-адресов в MAC-адреса на локальной сети.Позволяет получить информацию об ARP-таблице и решать проблемы сетевого соединения.|
| iptables | Команда iptables является мощным инструментом для настройки правил межсетевого экрана (firewall) в Linux. Позволяет управлять трафиком, настраивать фильтрацию пакетов, перенаправление портов и множество других операций сетевой безопасности. |
| curl | curl - это утилита командной строки, используемая для отправки и получения данных по протоколу HTTP, HTTPS, FTP и другим протоколам. Она поддерживает множество функций и параметров для выполнения различных задач.|
|ifup|Используется для включения сетевого интерфейса (интерфейса сетевой карты) на компьютере. Когда интерфейс включается, он начинает принимать и передавать сетевой трафик. Это позволяет установить соединение с сетью и интернетом.|
|ifdown|Используется для выключения сетевого интерфейса (интерфейса сетевой карты) на компьютере. Когда интерфейс выключается, он перестает принимать и передавать сетевой трафик. Это позволяет разорвать соединение с сетью и интернетом.|
|ifconfig|Используется для отображения информации о сетевых интерфейсах на компьютере. Эта команда позволяет просматривать текущую конфигурацию сетевых интерфейсов, таких как IP-адреса, MAC-адреса, состояние интерфейсов и другие параметры.|
|route|Используется для просмотра или настройки таблицы маршрутизации на компьютере. Таблица маршрутизации определяет путь, который пакеты данных должны пройти, чтобы достичь указанного адресата.|
|ip|Используется для работы с сетевыми интерфейсами и настройки сетевых параметров. Это более современная замена устаревшей команды ifconfig. Команда ip предоставляет более широкие возможности для управления сетью и является стандартным инструментом для работы с сетью в современных дистрибутивах Linux.|
|tcpdump|Является утилитой командной строки для захвата и анализа сетевого трафика.|


<h1>SSH</h1>

|command|description|
|---|---|
| ssh | Secure Shell - это протокол и программа для безопасного удаленного доступа к компьютерам и выполнения команд через сеть. Он позволяет вам подключаться к удаленному компьютеру через зашифрованное соединение. |
| scp | Копирование файлов между локальной и удаленной системами по протоколу SSH.|
| ssh-keygen | для генерации пары ключей SSH (Secure Shell) - приватного и публичного ключей. Ключи SSH используются для аутентификации при подключении к удаленному серверу по протоколу SSH. Приватный ключ хранится на локальном компьютере, а публичный ключ передается на удаленный сервер.|
| ssh-copy-id | Копирует публичный ключ на удаленный сервер в файл ~/.ssh/authorized_keys, чтобы разрешить аутентификацию по ключу. |
| sftp | Интерактивный протокол передачи файлов через SSH. Позволяет передавать файлы между локальной и удаленной системами, подобно команде ftp. |
| ssh-add | Добавляет приватные ключи SSH в агент аутентификации, чтобы обеспечить автоматическую аутентификацию при подключении к удаленным хостам. |
| ssh-agent | Запускает агент аутентификации, который хранит приватные ключи SSH и предоставляет их при необходимости. |
| ssh-keyscan | Сканирует удаленный хост на предмет публичных ключей SSH и выводит их в консоль. |
| sshfs | Позволяет монтировать удаленную файловую систему на локальном хосте через SSH. |
| gpg | GPG (GNU Privacy Guard) - это свободное программное обеспечение для шифрования и цифровой подписи данных. Оно предоставляет инструменты для создания и управления ключами шифрования, а также для шифрования, расшифрования и подписи файлов и сообщений.|

<h1>Disk Management</h1>

|command|description|
|---|---|
| fdisk | Команда для разбиения диска на разделы.|
| parted | Интерактивная команда для разбиения диска на разделы.|
| mkfs | Команда для создания файловой системы на разделе.|
| mount | Команда для монтирования файловой системы на указанную точку монтирования.|
| umount | Команда для размонтирования файловой системы.|
| lsblk | Отображает информацию о структуре и свойствах блочных устройств.|
| pvcreate | Команда pvcreate используется для создания физического тома (Physical Volume) на блочном устройстве, таком как жесткий диск или раздел.|
| vgcreate | Команда vgcreate используется для создания группы томов (Volume Group), объединяющей несколько физических томов в единую единицу управления.|
| lvcreate | Команда lvcreate используется для создания логического тома (Logical Volume) внутри группы томов.|
| lvs | Команда lvs используется для отображения информации о логических томах, группах томов и их свойствах.|

<h1>Archiving and Compression</h1>

|command|description|
|---|---|
| tar | Команда для создания и распаковки архивов (tarballs).|
| gzip | Команда для сжатия файлов с помощью алгоритма GZIP.|
| gunzip | Команда для распаковки сжатых файлов формата GZIP.|
| bzip2 | Команда для сжатия файлов с помощью алгоритма BZIP2.|
| zip | Команда для создания и распаковки ZIP-архивов.|

<h1>System Logs</h1>

|command|description|
|---|---|
| syslog | Файл /var/log/syslog содержит системные сообщения, включая информацию о ядре, службах и процессах.|
| auth.log | Файл /var/log/auth.log содержит информацию о процессе аутентификации и авторизации пользователей.|
| kern.log | Файл /var/log/kern.log содержит сообщения ядра Linux, такие как информация о загрузке ядра, ошибки ядра и другие события, связанные с работой ядра. |
| dmesg | Команда dmesg отображает вывод системного буфера сообщений ядра, который содержит информацию о загрузке ядра и оборудовании. |
| messages | Файл /var/log/messages содержит общие системные сообщения, которые не попали в другие журналы.|
| wtmp (+ last - для просмотра) | Содержит информацию о истории входов и выходов пользователей в системе. Используется для отслеживания сеансов входа в систему, записи времени начала и окончания сеанса, а также связанных с ними событий.|
| btmp (+ lastb - для просмотра) | Содержит информацию о неудачных попытках входа в систему (ошибочных попытках логина). Записывает информацию о неудачных попытках входа, которые происходят при неправильном вводе пароля или других проблемах с аутентификацией пользователя. |
| dnf.log (Debian) | Записываются различные операции, такие как установка пакетов, обновление, удаление, поиск и другие операции, связанные с управлением пакетами.Каждая запись в файле обычно содержит информацию о времени выполнения операции, идентификаторе пакета, его версии, результате операции и другие сведения, которые могут быть полезными для отслеживания и анализа изменений, связанных с пакетами. |
| /var/log/apt (Ubuntu) | Записываются различные операции, такие как установка пакетов, обновление, удаление, поиск и другие операции, связанные с управлением пакетами. |

<h1>Regular Expressions</h1>

|command|description|
|---|---|
|.|Соответствует любому символу, кроме символа новой строки|
|^|Соответствует началу строки.|
|$|Соответствует концу строки.|
|[ ]|Соответствует любому символу в указанном диапазоне или наборе символов.|
|I|Соответствует одному из нескольких шаблонов.|
|*|Соответствует нулю или более повторений предыдущего символа или группы символов.|
|+|Соответствует одному или более повторений предыдущего символа или группы символов.|
|?|Соответствует нулю или одному повторению предыдущего символа или группы символов.|
|{n}|Соответствует ровно n повторениям предыдущего символа или группы символов.|
|{n, m}|Соответствует от n до m повторений предыдущего символа или группы символов.|
| \ |Используется для экранирования специальных символов или обозначения специальных конструкций.|
|()|Используются для группировки символов и создания подвыражений.|
|\b|Соответствует границе слова.|
|\d, \w, \s|Соответствуют цифре, слову или пробельному символу соответственно.|
|/pattern/|Соответствует строке, содержащей указанный шаблон.|
|/^pattern/|Соответствует строке, начинающейся с указанного шаблона.|
|/pattern$/|Соответствует строке, заканчивающейся указанным шаблоном.|
|/[0-9]+/|Соответствует любой последовательности цифр.|
|/(abIcd)/|Соответствует строке, содержащей "ab" или "cd".|

<h1>Systemctl & Journalctl</h1>

|command|description|
|---|---|
|systemctl start <service>|запуск службы|
|systemctl stop <service>|остановка службы|
|systemctl restart <service>|перезапуск службы|
|systemctl enable <service>|включение автозапуска службы при загрузке системы|
|systemctl disable <service>|отключение автозапуска службы при загрузке системы|
|systemctl status <service>|получение информации о состоянии службы|
|systemctl reload <service>|обновить конфигурационные файлы (без перезапуска службы)|
|systemctl edit <service>|редактирование служебного файла systemd|
|systemctl daemon-reload|выполняет перезагрузку демона systemd, обновляя его конфигурацию и перечитывая все измененные файлы в директориях /etc/systemd/system/ и /run/systemd/system/|
|journalctl|используется для просмотра системного журнала|

<h1>Backups</h1>

|command|description|
|---|---|
|rsync|Используется для синхронизации и резервного копирования файлов и директорий. Она позволяет копировать только измененные или добавленные файлы, минимизируя время и объем передаваемых данных. Перед выполнением: проверить, есть ли доступ к директориям и файлам|
|tar|Команда tar используется для создания архивов и резервных копий файлов и директорий.|