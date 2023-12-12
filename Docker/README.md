docker run [OPTIONS] IMAGE [COMMAND] [ARG...]

> **it** — интерактивный режим. Перейти в контейнер и запустить внутри контейнера команду<br>
**-d** — запустить контейнер в фоне (демоном) и вывести его ID<br>
**-p** port_localhost:port_docker_image — порты из докера на локалхост<br>
**-e** «TZ=Europe/Moscow» — указываем нашему контейнеру timezone<br>
**-h** HOSTNAME — присвоить имя хоста контейнеру<br>
**—link** <имя контейнера> — связать контейнеры с другим<br>
**-v** /local/path:/container/path/ — прокидываем в контейнер докера директорию с локальной машины<br>
**--name** CONTAINERNAME — присвоить имя нашему контейнеру<br>
**--restart**=[no/on-failure/always/unless-stopped] — варианты перезапуска контейнера при крэше<br>
> 

	
					

### RUNNING CONTAINER COMMANDS

|||
| --- | --- |
| docker run [IMAGE NAME/ID] | запуск |
| docker rename <OLD CONTAINERNAME> <NEW CONTAINERNAME> | переименовать контейнер |
| docker rename <OLD CONTAINERNAME> <NEW CONTAINERNAME> | удалить контейнер |
| docker update --cpu-shares 512 -m 300M <CONTAINERNAME or CONTAINERID> | обновить контейнер |

### COINTAINER LIFECYCLE

|||
| --- | --- |
| docker start [CONTAINERNAME] | Запуск остановленного контейнера |
| docker stop [CONTAINERNAME] | Остановка |
| docker restart [CONTAINERNAME] | Перезагрузка |
| docker pause [CONTAINERNAME] | Пауза (приостановка всех процессов контейнера) |
| docker unpause [CONTAINERNAME] | Снятие паузы |
| docker wait [CONTAINERNAME] | Блокировка (до остановки контейнера) |
| docker kill [CONTAINERNAME] | Отправка SIGKILL (завершающего сигнала) |
| docker kill -s HUP [CONTAINERNAME] | Отправка другого сигнала |
| docker attach [CONTAINERNAME] | Подключение к существующему контейнеру |

### CONTAINER MANAGEMENT

| docker ps | Вывести работающие контейнеры |
| --- | --- |
| docker ps -a | Вывести все контейнеры |
| docker logs <CONTAINERNAME or CONTAINERID> | Информация о контейнере |
| docker events <CONTAINERNAME or CONTAINERID> | События контейнера |
| docker port <CONTAINERNAME or CONTAINERID> | Публичные порты |
| docker top <CONTAINERNAME or CONTAINERID> | Выполняющиеся процессы |
| docker stats <CONTAINERNAME or CONTAINERID> | Использование ресурсов |
| docker diff <CONTAINERNAME or CONTAINERID> | Изменения в файлах или директориях файловой системы контейнера |
| docker exec -it name_of_container /bin/bash | Зайти в уже запущенный контейнер (точнее выполнить команду внутри контейнера) |
| docker run -it -d --name my_container CONTAINER_ID /bin/bash | Запустить контейнер и открыть в нём bash |
| docker cp some_files.conf docker_container:/home/docker/ | Копирование файлов внутрь контейнера |

### IMAGES

|||
| --- | --- |
| docker images | Список образов |
| docker images -f dangling=true | Вывести все неиспользуемые образы |
| docker images -a | Вывести все образы (images) |
| docker build -t my_docker .
docker build .
docker build github.com/creack/docker-firefox
docker build - < Dockerfile
docker build - < context.tar.gz
docker build -t eon/infinite .
docker build -f myOtherDockerfile .
docker build -t shykes/myapp:1.0.2 -t shykes/myapp:latest
curl example.com/remote/Dockerfile | docker build -f - . | Создание образа (флаг -f, чтобы задать другое местоположение Dockerfile в файловой системе) |
| docker rmi nginx | Удаление образа (с ключом --force удалит контейнер и образ) |
| docker images prune
docker rmi $(docker images -f dangling=true -q) | Удаление всех неиспользуемых образов |
| docker rmi -f $(docker images | grep "^[none]" | awk "{print $3}") | Удаление всех образов без тегов |
| docker rmi $(docker images -a -q) | Удаление всех образов |
| docker load < ubuntu.tar.gz
docker load --input ubuntu.tar | Загрузка репозитория в tar (из файла или стандартного ввода) |
| docker save busybox > ubuntu.tar | Сохранение образа в tar-архив |
| docker history | Просмотр истории образа |
| docker commit nginx | Создание образа из контейнера |
| docker tag nginx eon01/nginx | Тегирование образа |
| docker system prune | Удаление всех неиспользуемых (не связанных с контейнерами) образов (Если добавить к команде ключ -a, то произойдет удаление всех остановленных контейнеров и неиспользуемых образов) |

### VOLUMES

> Если монтируем пустой том с хоста, а в контейнере уже есть файлы, то они скопируются в том
Если монтируем с хоста том с файлами, то они окажутся в контейнере
Если мы монтируем не пустой том с хоста, а в контейнере по этому пути уже есть файлы, то они будут скрыты
> 

|||
| --- | --- |
| docker volume create <VOLUME-NAME> | Создание тома |
| docker run --mount source=<VOLUME-NAME>,target=/path/to/folder/in/container -d [IMAGE] | Монтируем с хоста в контейнер |
| docker run --mount type=bind,source=/host/folder,target=/container/folder -d [IMAGE] | Монтируем с контейнера на хост |
| docker volumes inspect <VOLUME-NAME> | Посмотреть настройки тома |
| docker volume ls | Вывести список всех томов с их названиями |
| docker volume ls -f dangling=true | Вывести список всех томов не связанных с контейнерами |
| docker volume rm <VOLUME-NAME> | Удаление volumes по названию |
| docker volume prune<br>docker volume rm $(docker volume ls -f dangling=true -q) | Удаление томов (volumes) несвязанных с контейнерами |
| docker volume prune --filter "label!=keep” | Удаление неиспользуемых (dangling) томов по фильтру |
| docker system prune | Удаление всех неиспользуемых объектов |
| Host Volumes:<br><br>docker run -v /opt/mysql_data:/var/lib/mysql mysql<br>docker run -v /opt/app_conf:/etc/app/configs app | происходит монтирование с жёсткого диска (из указанной директории), в контейнер |
| Anonymous Volumes:<br><br>docker run -v /var/lib/mysql mysql<br>docker run -v /etc/app/configs app | происходит создание /var/bin/docker/volumes/HASH/_data, где хранятся данные, которые находятся в /var/lib/mysql |
| Named Volumes:<br><br>docker run -v mysql_data:/var/lib/mysql mysql<br>docker run -v app_conf:/etc/app/configs | на хосте происходит создание volume по адресу /var/lib/docker/volumes/mysql_data/_data, далее эта директория монтируется в контейнер по адресу /var/lib/mysql |

### DOCKERFILE

|||
| --- | --- |
| FROM | устанавливает базовый образ, на основе которого вы строите свой образ. |
| LABEL | добавляет метаданные к образу, такие как автор, версия и описание. |
| RUN | выполняет команды внутри контейнера во время построения образа. Используется для установки пакетов, обновления системы и других задач. |
| COPY и ADD | копируют файлы из локальной файловой системы в образ. COPY просто копирует файлы, а ADD может также распаковывать архивы и загружать файлы из URL. |
| WORKDIR | устанавливает рабочую директорию для последующих инструкций. |
| EXPOSE | объявляет порты, которые контейнер будет слушать во время выполнения. |
| CMD | задает команду, которая будет выполнена при запуске контейнера. |
| ENTRYPOINT | делает то же самое, но позволяет передавать параметры при запуске командой строки. |
| ENV | устанавливает переменные среды в контейнере. |
| USER | устанавливает пользователя, от которого выполняются инструкции RUN, CMD и ENTRYPOINT. |
| VOLUME | создает точку монтирования для постоянных данных, которые могут быть обменены между контейнером и хост-системой или другими контейнерами. |
| ARG | задает аргументы, которые могут быть переданы при сборке образа. |
| ONBUILD | добавляет инструкции, которые будут выполнены при использовании вашего образа в качестве базового для другого образа. |

### NETWORS

> Если запуск без параметра --net (--network), то сеть default, к контейнерам можно подключаться, могут общаться между собой по внутренним IP внутри сети, но не могут общаться, используя свои имена при создании
> 

|||
| --- | --- |
| Bridge:<br><br> docker network create --drive bridge NAME | создание сети типа BRIDGE (создаётся по умолчанию)<br><br>контейнеры могут общаться между собой по IP-адресам и по DNS именам (--name NAME) |
| Host:<br><br>docker network create --drive host NAME | контейнеры не получают своего IP-адреса, а используют IP-адрес хоста<br><br>если хотим подключится к контейнеру из вне, указываем IP сервера |
| None:<br><br>docker network create --drive none NAME | контейнеры изолированы, нельзя подключиться по IP-адресам к портам, но можно запустить команды локально<br><br>сети не могут общаться между собой (из соображений безопасности) |
| docker network create -d bridge --subnet 192.168.56.0/24 --gateway 192.168.56.1 myNet02 | создать сеть с именем myNet02, с заданным IP |
| docker network ls | cписок всех существующих сетей |
| docker network inspect myNet02 | инспектирование сети |
| docker network rm <NET_NAME/ID> | Удалить сеть с именем <NET_NAME/ID> |
| docker network connect myBridgeNet01 container3 | подключение контейнера (container3) к существующей сети myBridgeNet01 |
| docker network disconnect myBridgeNet01 container3 | отключить контейнер (container3) от сети myBridgeNet01 |

MACVLAN vs IPVLAN

|||
| --- | --- |
| macvlan | у сервера имеется сетевая карта, которая имеет свой IP-адрес и MAC, контейнеры в этой сети также получают IP-адреса<br><br>также сервер имеет свой MAC-адрес, а контейнеры в этой сети имеют свои MAC-адреса, по которым можно определить нужный контейнер |
| ipvlan | имеется сервер со своим IP-адресом, также контейнеры в этой сети имеют свои IP-адреса<br><br>MAC-адрес остаётся без изменений (одинаковых у сервера и контейнеров) |

### DOCKER SWARM

|||
| --- | --- |
| docker swarm init | инициализация Swarm на текущей машине (менеджере). |
| docker swarm join-token worker | команда для присоединения рабочего узла к Swarm |
| docker swarm join-token manager | команда для присоединения дополнительного менеджера к Swarm |
| docker service create --name [service_name] | создание сервиса |
| docker service ls | список сервисов и их состояния. |
| docker node ls | список узлов в Swarm |
| docker service scale [service_name]=[replica_count] | масштабирование количества реплик сервиса |
| docker service logs [service_name] | просмотр журналов сервиса |
| docker service ps [service_name] | просмотр статуса реплик сервиса |
| docker service update [service_name] | обновление конфигурации сервиса |
| docker service rm [service_name] | удаление сервиса |
| docker swarm leave --force | покидание Swarm на текущем узле |

### COMPOSE

|||
| --- | --- |
| version | Версия синтаксиса Docker Compose. Обычно устанавливается на текущую поддерживаемую версию, например, "3". |
| services | Начало раздела для определения служб (контейнеров) в вашем приложении. |
| service_name | Название службы. |
| image | Указывает образ Docker, который будет использоваться для создания контейнера. |
| ports | Определяет порты, которые будут проксироваться из контейнера в хост-систему. |
| volumes | Монтирует тома или папки из хост-системы в контейнер. |
| environment | Устанавливает переменные среды для контейнера. |
| command | Позволяет задать команду, которая будет выполнена при запуске контейнера. |
| depends_on | Определяет зависимости между службами, гарантирует, что одна служба запустится после другой. |
| restart | Настройка поведения перезапуска контейнера. |
| networks | Раздел для определения пользовательских сетей Docker. |
| build | Сборка образа контейнера из указанных исходных кодов. |