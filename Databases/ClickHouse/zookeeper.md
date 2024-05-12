<div>
<h1>CLCK 10: Установка Zookeeper (репликация в ClickHouse)</h1>
<div>
<h3><strong>Описание:</strong></h3>
<p>В прошлом практикуме мы сконфигурировали кластер из 2-х CH нод. Учитывая то, что наши данные лежат частями на разных серверах нужно позаботиться об их репликации. Чтобы данные внутри одной шарды могли реплицироваться на другие ноды той же шарды и мы были защищены от внезапных падений железа.</p>
<p>Для решения этой задачи мы будем применять реплицируемые таблицы в ClickHouse, а для того чтобы данные были консистентными на всех нодах, &mdash; Zookeeper. ClickHouse использует ZooKeeper для хранения метаданных о реплицированных таблицах на кластере. Сама репликация является физической: между узлами передаются только сжатые части, а не запросы.</p>
<p>Вообще-то вы конечно можете установить zookeeper из стандартных репозиториев ubuntu, но мы советуем вам поставить его из официальных источников, чтобы получить последнюю версию. Итак, поехали.</p>
<h4>Установка Java</h4>
<p>Zookeeper написан на Java, поэтому первое, что нам понадобится для установки и работы, &mdash; это установить Java на машину. Мы будем использовать <code>apt</code> для установки пакета <code>default-jre-headless</code>. Теперь убедимся, что Java была установлена корректно, командой <code>java --version</code>.</p>
<pre><code>root@zk:~# java --version
openjdk 11.0.8 2020-07-14
OpenJDK Runtime Environment (build 11.0.8+10-post-Ubuntu-0ubuntu120.04)
OpenJDK 64-Bit Server VM (build 11.0.8+10-post-Ubuntu-0ubuntu120.04, mixed mode, sharing)
</code></pre>
<h4>Установка Zookeeper</h4>
<p>Теперь перейдем к Zookeeper. По ссылке <a href="https://zookeeper.apache.org/releases.html">https://zookeeper.apache.org/releases.html</a> вы можете скачать архив zookeeper себе на машину (я буду использовать для этого <code>wget</code> и путь <code>/opt/zookeeper</code>).</p>
<p>После скачивания и разархивации файла видна структура папок:</p>
<pre><code>root@zk:/opt/zookeeper# ls
LICENSE.txt NOTICE.txt README.md README_packaging.md bin conf docs lib
</code></pre>
<p>Основные папки, которые нас интересуют, &mdash; это <code>bin</code>, где лежат бинарники сервиса, и <code>conf</code>, где мы будем его конфигурировать.</p>
<h4>Конфигурация Zookeeper</h4>
<p>Для начала создадим простой конфигурационный файл в папке <code>conf/zoo.cfg</code>.</p>
<pre><code>tickTime=2000
dataDir=/var/lib/zookeeper
clientPort=2181
</code></pre>
<p>Основные параметры, которые мы использовали:</p>
<ul>
<li><strong>tickTime</strong>&nbsp;- базовая единица времени в миллисекундах, используемая zookeeper. Она используется для проверки статуса клиента.</li>
<li><strong>dataDir</strong>&nbsp;- основная директорая для данных zookeeper</li>
<li><strong>clientPort</strong>&nbsp;- порт для подключения клиента, который слушает zookeeper</li>
</ul>
<p>Теперь можем запустить zookeeper сервер и проверить, все ли работает корректно. Для запуска сервера воспользуемся командой:</p>
<pre><code>root@zk:/opt/zookeeper# ./bin/zkServer.sh start
/usr/bin/java
ZooKeeper JMX enabled by default
Using config: /opt/zookeeper/bin/../conf/zoo.cfg
Starting zookeeper ... STARTED
</code></pre>
<p>Судя по сообщениям, мы видим, что сервер был успешно запущен. Теперь мы можем подключиться к нему клиентом и посмотреть, что находится внутри. Для этого воспользуемся консольной утилитой zkCli.sh:</p>
<pre><code>root@zk:/opt/zookeeper# ./bin/zkCli.sh -server localhost:2181
/usr/bin/java
Connecting to localhost:2181
2020-10-20 20:26:31,667 [myid:] - INFO [main:Environment@98] - Client environment:zookeeper.version=3.6.2--803c7f1a12f85978cb049af5e4ef23bd8b688715, built on 09/04/2020 12:44 GMT
2020-10-20 20:26:31,672 [myid:] - INFO [main:Environment@98] - Client environment:host.name=zk
2020-10-20 20:26:31,672 [myid:] - INFO [main:Environment@98] - Client environment:java.version=11.0.8
...
2020-10-20 20:26:31,833 [myid:localhost:2181] - INFO [main-SendThread(localhost:2181):ClientCnxn$SendThread@999] - Socket connection established, initiating session, client: /127.0.0.1:46944, server: localhost/127.0.0.1:2181
2020-10-20 20:26:31,855 [myid:localhost:2181] - INFO [main-SendThread(localhost:2181):ClientCnxn$SendThread@1433] - Session establishment complete on server localhost/127.0.0.1:2181, session id=0x1000538ba020002, negotiated timeout = 30000
WATCHER::
WatchedEvent state:SyncConnected type:None path:null
[zk: localhost:2181(CONNECTED) 0]
</code></pre>
<p>При подключении мы использовали флаг <code>-server</code>, в котором указали <code>host:port</code> сервера, куда мы подключаемся. Последняя строка вывода команды показывает, что мы успешно к нему подключились.</p>
<p>Zookeeper CLI имеет достаточно простой интерфейс, вы можете посмотреть список доступных команд с помощью команды <code>help</code>.</p>
<p>Давайте глянем, что там лежит:</p>
<pre><code>[zk: localhost:2181(CONNECTED) 0] ls /
[zookeeper]
</code></pre>
<p>Пока здесь находится только одна zookeeper нода, она создается по умолчанию. Можно посмотреть ее содержимое командой <code>ls /zookeeper</code>. Для выхода из CLI просто введите <code>quit</code> или нажмите <code>Ctrl+C</code>. Остановим zookeeper сервер командой:</p>
<pre><code>root@zk:/opt/zookeeper# ./bin/zkServer.sh stop
/usr/bin/java
ZooKeeper JMX enabled by default
Using config: /opt/zookeeper/bin/../conf/zoo.cfg
Stopping zookeeper ... STOPPED
</code></pre>
<h4>Создание Zookeeper сервиса</h4>
<p>Последнее, что осталось сделать для удобного использования Zookeeper &mdash; это вынести его в сервис.</p>
<p>Создадим отдельного пользователя <code>zookeeper</code> для сервиса: <code>useradd -M zookeeper</code>. Флаг <code>-M</code> означает, что для него не будет создана домашняя директория. Также нам нужно, чтобы пользователь имел доступ к самому zookeeper. Сделаем мы это командой: <code>chown -R zookeeper:zookeeper /opt/zookeeper</code>.</p>
<p>Затем создадим и сконфигурируем сервис-файл по указанному пути: <code>/lib/systemd/system/zookeeper.service</code>.</p>
<pre><code>Description=zookeeper:3.6.2
After=network.target
[Service]
Type=forking
User=zookeeper
Group=zookeeper
WorkingDirectory=/opt/zookeeper
ExecStart=/opt/zookeeper/bin/zkServer.sh start
ExecStop=/opt/zookeeper/bin/zkServer.sh stop
ExecReload=/opt/zookeeper/bin/zkServer.sh restart
RestartSec=30
Restart=always
PrivateTmp=yes
PrivateDevices=yes
LimitCORE=infinity
LimitNOFILE=500000
[Install]
WantedBy=multi-user.target
Alias=zookeeper.service
</code></pre>
<p>Теперь все готово, можем запустить сервис и проверить его статус.</p>
<pre><code>root@zk:~# service zookeeper start
root@zk:~# service zookeeper status
● zookeeper.service
 Loaded: loaded (/lib/systemd/system/zookeeper.service; disabled; vendor preset: enabled)
 Active: active (running) since Tue 2020-10-20 21:30:12 UTC; 3s ago
 Process: 36816 ExecStart=/opt/zookeeper/bin/zkServer.sh start (code=exited, status=0/SUCCESS)
 Main PID: 36840 (java)
 Tasks: 32 (limit: 1137)
 Memory: 44.6M
 CGroup: /system.slice/zookeeper.service
 └─36840 java -Dzookeeper.log.dir=/opt/zookeeper/bin/../logs -Dzookeeper.log.file=zookeeper-zookeeper-server-zk.log -&gt;
Oct 20 21:30:11 zk systemd[1]: Starting zookeeper.service...
Oct 20 21:30:11 zk zkServer.sh[36816]: /usr/bin/java
Oct 20 21:30:11 zk zkServer.sh[36816]: ZooKeeper JMX enabled by default
Oct 20 21:30:11 zk zkServer.sh[36816]: Using config: /opt/zookeeper/bin/../conf/zoo.cfg
Oct 20 21:30:12 zk zkServer.sh[36816]: Starting zookeeper ... STARTED
Oct 20 21:30:12 zk systemd[1]: Started zookeeper.service.
</code></pre>
<p>Отлично, все работает и Zookeeper был успешно установлен!</p>
<p>Кстати, такой небольшой ликбез по зукипер не пройдет даром - иногда действительно требуется зайти в него и посмотреть какие данные там насоздавал clickhouse и почему вдруг репликация перестала работать.</p>
<h3><strong>Полезные ссылки:</strong></h3>
<ul>
<li><a href="https://zookeeper.apache.org/">https://zookeeper.apache.org/</a></li>
<li><a href="https://zookeeper.apache.org/doc/current/zookeeperOver.html">https://zookeeper.apache.org/doc/current/zookeeperOver.html</a></li>
</ul>
</div>
</div>
