<div>
<h1>CLCK 02: Базовая конфигурация ClickHouse</h1>
<div>
<h3><strong>Описание:</strong></h3>
<p>Теперь, когда ClickHouse уже установлен, мы можем более детально посмотреть на его конфигурацию. Основной конфигурационный файл - это <code>config.xml</code>, который расположен в папке по умолчанию <code>/etc/clickhouse-server</code>.</p>
<p>Любые изменения можно вносить сразу в этот файл, либо создать отдельный файл конфигурации и положить его в папку <code>/etc/clickhouse-server/config.d/</code>. В этом случае данные отдельного конфига перепишут значения по-умолчанию. Помимо этого кликхаус для части параметров может обновлять их значения на лету - достаточно всего лишь обновить параметр в файле и кликхаус применит его. Давайте рассмотрим некоторые ключевые параметры:</p>
<h4>&lt;http_port&gt;/&lt;https_port&gt;</h4>
<p>Порт для обращений к серверу по протоколу HTTP(s). При использовании <code>https</code> нужна конфигурация <code>openSSL</code>.</p>
<p><strong>Пример:</strong> <code>&lt;https_port&gt;9999&lt;/https_port&gt;</code> <code>&lt;http_port&gt;8123&lt;/http_port&gt;</code></p>
<h4><strong>&lt;tcp_port&gt;</strong></h4>
<p>Порт для общения с клиентами по TCP протоколу. Здесь стоит отметить, что кликхаус поддерживает два режима подключений - по http и по бинарному протоколу. Очевидно, что общение по бинарному протоколу идет быстрее чем по http, но http наиболее распространен и его очень легко интегрировать в ваше приложение для чтения и записи данных, поэтому определяющим фактором выбора протокола (как чаще всего и бывает) будет именно скорость внедрения в ваши сервисы.</p>
<p><strong>Пример:</strong> <code>&lt;tcp_port&gt;9000&lt;/tcp_port&gt;</code></p>
<h4>&lt;interserver_http_port&gt;</h4>
<p>Порт для обмена репликационными данными с серверами ClickHouse.</p>
<p><strong>Пример:</strong> <code>&lt;interserver_http_port&gt;9009&lt;/interserver_http_port&gt;</code></p>
<h4>&lt;listen_host&gt;</h4>
<p>На каких хостах слушать входящие подключения.</p>
<p><strong>Примеры:</strong> <code>&lt;listen_host&gt;::&lt;/listen_host&gt;</code> &mdash; сервер слушает все адреса. <code>&lt;listen_host&gt;::1&lt;/listen_host&gt;</code> &mdash; сервер слушает ipv6 localhost. <code>&lt;listen_host&gt;127.0.0.1&lt;/listen_host&gt;</code> &mdash; сервер слушает только запросы с localhost. <code>&lt;listen_host&gt;0.0.0.0&lt;/listen_host&gt;</code> &mdash; сервер слушает все запросы с ipv4 адресов.</p>
<h4>&lt;max_connections&gt;</h4>
<p>Максимальное количество входящих соединений.</p>
<p><strong>Примеры:</strong> <code>&lt;max_connections&gt;4096&lt;/max_connections&gt;</code></p>
<h4>&lt;max_concurrent_queries&gt;</h4>
<p>Максимальное количество одновременно обрабатываемых запросов. Очень важный параметр, поскольку иногда быстрее обработать 100 запросов последовательно с максимальным параллелизом 10 штук, нежели пытаться обработать сразу все 100 запросов в параллель.</p>
<p><strong>Примеры:</strong> <code>&lt;max_concurrent_queries&gt;100&lt;/max_concurrent_queries&gt;</code></p>
<h4>&lt;users_config&gt;</h4>
<p>Путь к файлу, который отвечает за конфигурацию пользователей, права, профили и квоты. Мы затронем эту тему в следующем задании.</p>
<p><strong>Пример:</strong> <code>&lt;users_config&gt;users.xml&lt;/users_config&gt;</code></p>
<h4>&lt;http_server_default_response&gt;</h4>
<p>Контент, который возвращается при обращении к HTTP(s) серверу. По умолчанию сервер отдает "Ok." Таким образом вы сможете настроить базовую проверку доступности вашего кликхаус сервера - если подключение на http порт удалось и сервер вернул код ответа 200 - значит он по крайней мере запущен.</p>
<p><strong>Пример:</strong> <code>&lt;http_server_default_response&gt;Success!&lt;/http_server_default_response&gt;</code></p>
<p>Путь к данным ClickHouse. Завершающий слеш обязателен. На самом деле данный путь вам понадобится либо при создании бекапов, либо при восстановлении после сбоя. Мы не рекомендуем менять дефолтное расположение, чтобы не сбивать с толку других участников команды поддержки. Если же вы хотите вынести ваши данные на более быстрые диски - то есть смысл подмонтировать их напрямую в /var/lib/clickhouse.</p>
<p><strong>Пример:</strong> <code>&lt;path&gt;/var/lib/clickhouse/&lt;/path&gt;</code></p>
<p>Здесь были выделены только основные пункты конфигурации ClickHouse, все возможные опции вы можете найти <a href="https://clickhouse.tech/docs/ru/operations/server-configuration-parameters/settings/">здесь</a>. Часть из них мы будем обсуждать в следующих заданиях при настройке соответствующих функций.</p>
<p>В завершении хотелось бы отметить, что если вы хотите переопределить какие-либо настройки, то есть смысл записать их в отдельный файл в директорию <code>/etc/clickhouse-server/config.d/</code>. Например, вы можете создать файл <code>my-config.xml</code> по пути <code>/etc/clickhouse-server/config.d/my-config.xml</code>, который переопределяет http port, который будет слушать сервер.</p>
<pre><code>&lt;?xml version="1.0"?&gt;
&lt;yandex&gt;
 &lt;http_port&gt;8663&lt;/http_port&gt;
&lt;/yandex&gt;
</code></pre>
<p>Мы советуем использовать этот функционал по максимому и переопределять настройки КХ в отдельных файлах, тогда у вас не возникнет проблем с обновлением сервера - дефолтная конфигурация может быть легко перезаписана, поскольку все изменения вы вынесли в отдельные файлы.</p>
<h3><strong>Полезные ссылки:</strong></h3>
<ul>
<li><a href="https://clickhouse.tech/docs/ru/operations/configuration-files/">https://clickhouse.tech/docs/ru/operations/configuration-files/</a></li>
<li><a href="https://clickhouse.tech/docs/ru/operations/server-configuration-parameters/settings/">https://clickhouse.tech/docs/ru/operations/server-configuration-parameters/settings/</a></li>
</ul>
</div>
</div>
