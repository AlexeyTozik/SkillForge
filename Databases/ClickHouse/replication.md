<div>
<h1>CLCK 11: Настройка репликации в ClickHouse</h1>
<div>
<h3><strong>Описание:</strong></h3>
<p>Теперь, настроив Zookeeper в предыдущем задании, вы готовы внести коррективы в конфигурацию нашего кластера и создать реплицируемые таблицы (а также <code>distributed</code> таблицу для них), а так же проверить вставку данных.</p>
<h4>Конфигурация ClickHouse кластера</h4>
<p>Для репликации данных в кластере нас интересуют следующие параметры в конфиг-файле <code>config.xml</code>:</p>
<ul>
<li><strong>zookeeper &mdash;</strong> конфигурация Zookeeper для ClickHouse кластера.</li>
<li><strong>macros &mdash;</strong> макросы для подстановки параметров реплицируемых таблиц.</li>
</ul>
<pre><code>&lt;zookeeper incl="zookeeper-servers" optional="true" /&gt;
&lt;macros incl="macros" optional="true" /&gt;
</code></pre>
<p>Как и в прошлом задании нам нужно, чтобы данные параметры были пустыми, т.к. мы используем файл с подстановками.</p>
<p>Данный кластер будет состоять из 1-го шарда и 2-х реплик. То есть данные между шардами делиться не будут, поскольку у нас всего лишь один шард. Но они будут реплицироваться в рамках одного шарда, поскольку у нас две реплики в одном шарде. То есть каждая нода ClickHouse в нашем случае является репликой. Полная конфигурация <code>cluster.xml</code> выглядит следующим образом:</p>
<pre><code>&lt;?xml version="1.0"?&gt;
&lt;yandex&gt;
 &lt;clickhouse_remote_servers&gt;
 &lt;mycluster&gt; // Название кластера
 &lt;shard&gt;
 &lt;internal_replication&gt;true&lt;/internal_replication&gt;
 &lt;replica&gt;
 &lt;host&gt;167.99.142.32&lt;/host&gt; // Первая нода одного шарда
 &lt;port&gt;9000&lt;/port&gt;
 &lt;/replica&gt;
 &lt;replica&gt;
 &lt;host&gt;159.65.123.161&lt;/host&gt; // Вторая нода одного шарда
 &lt;port&gt;9000&lt;/port&gt;
 &lt;/replica&gt;
 &lt;/shard&gt;
 &lt;/mycluster&gt;
 &lt;/clickhouse_remote_servers&gt;
 &lt;zookeeper-servers&gt;
 &lt;node index="1"&gt;
 &lt;host&gt;159.65.119.28&lt;/host&gt; // сервер зукипер
 &lt;port&gt;2181&lt;/port&gt; // порт для подключения
 &lt;/node&gt;
 &lt;/zookeeper-servers&gt;
 &lt;macros&gt;
&lt;cluster&gt;mycluster&lt;/cluster&gt; // название кластера
 &lt;replica&gt;167.99.142.32&lt;/replica&gt; // Адрес данной машины
 &lt;shard&gt;01&lt;/shard&gt; // Шард данной машины
 &lt;/macros&gt;
&lt;/yandex&gt;
</code></pre>
<p>То есть структуру нашего кластера мы отобразили в параметре <code>clickhouse_remote_servers</code>.</p>
<p>Параметр <code>internal_replication</code> отвечает за то, будет ли дублировать ClickHouse запросы на запись или редактирование данных автоматически на все реплики или нет при вставке в distributed таблицу. То есть когда вы вставляете данные в distributed таблицу, она сама может увидеть все реплики в шарде и продублировать запрос на вставку на все реплики этого шарда.</p>
<p>Второй же вариант - это настройка репликации для таблиц через zookeeper своими руками. То есть мы создадим две таблицы и скажем, что они реплицируемые. В этом случае нам не потребуется репликация через distributed, поэтому cтавим <code>true</code> в данном параметре.</p>
<p>Кстати, репликацию можно настроить и без distributed таблиц и описания кластера. Вы просто создаете две реплицированные таблицы и они начнут синхронизироваться между собой.</p>
<p>В конфигурации параметра <code>zookeeper</code> мы указываем кол-во нод Zookeeper. В данном случае мы имеем 1-ну ноду, в ней указываем адрес и порт соответственно. Аттрибут <code>index</code> отвечает за Zookeeper ID. Для продакшен сред мы рекомендуем использовать нечетное число нод для соблюдения кворума, а их количество обычно не будет превышать 7 штук даже на очень больших нагрузках.</p>
<p>Последний блок - это макросы. Они нужны для автоматической подстановки значений при создании реплицированных таблиц (через sql) в ClickHouse. Это позволяет избегать опечаток и других ошибок. Макросы привязаны к хосту, где запущен ClickHouse, а поэтому будут иметь разные значения на разных нодах кластера. Я думаю вы будете разливать конфигурацию clickhouse через ansible или любую другую систему управления конфигурациями, поэтому на каждой ноде у вас окажется нужное значение параметра.</p>
<h4>Создание реплицированных таблиц</h4>
<p>Для тестирования кластера создадим на нем реплицируемые таблицы. Напомню, что таблицы должны находиться на всех нодах и называться одинаково.</p>
<pre><code>CREATE TABLE posts_replicated ON CLUSTER mycluster
(
 id Int64,
 title String,
 description String,
 content String,
 date Date
)
ENGINE = ReplicatedMergeTree('/clickhouse/{cluster}/tables/posts_replicated', '{replica}')
PARTITION BY date
ORDER BY id;
</code></pre>
<p>В этом запросе есть секция <code>ON CLUSTER</code>, которая позволяет выполнить запрос на всех узлах кластера. Для подстановки значений для запроса будут использоваться макросы, которые мы описали ранее. Также необходимо подключение к ZooKeeper серверу.</p>
<p>Здесь мы используем движок <code>ReplicatedMergeTree</code>, который ничем не отличается от движка <code>MergeTree</code>, но позволяет дополнительно реплицировать данные. В параметрах мы указываем путь к таблице в Zookeeper, а также название реплики. Реплицируемые таблицы должны иметь одинаковый путь в Zookeeper. То есть если вы хотите чтобы 5 нод реплицировали одну и ту же таблицу - то путь в зукипере у них будет один и тот же - <code>/clickhouse/{cluster}/tables/posts_replicated</code>, а вот индекс реплики будет отличаться.</p>
<p>Значения переменных <code>{cluster}</code> и <code>{replica}</code> автоматически подставятся для каждой ноды на кластере из макросов.</p>
<p>Собственно на этом можно заканчивать рассказ про репликацию, поскольку она уже настроена для данной таблицы. Но мы пойдем дальше и создадим distributed таблицу для чтения данных из реплик.</p>
<h4>Создание Distributed таблиц</h4>
<p>Создадим Distributed таблицы. Опять же они должны иметь такую же структуру, как и реплицируемые таблицы:</p>
<pre><code>CREATE TABLE posts_distributed ON CLUSTER 'mycluster'
(
 id Int64,
 title String,
 description String,
 content String,
 date Date
)
ENGINE = Distributed('{cluster}', 'default', 'posts_replicated', rand());
</code></pre>
<p>В параметрах движка <code>Distributed</code> также используем переменную <code>cluster</code> из макросов.</p>
<h4>Вставка данных в реплицируемый кластер</h4>
<p>Теперь проверим, реплицируются ли данные при вставке. Для этого мы вставим данные в <code>ch1</code> ноду и посмотрим, появятся ли они в <code>ch2</code> ноде.</p>
<pre><code>root@ch1:~# clickhouse-client --query "INSERT INTO posts_replicated FORMAT CSV" &lt; posts.csv
root@ch1:~# clickhouse-client --query "SELECT count() FROM posts_replicated"
500000
</code></pre>
<p>Как мы видим, данные успешно вставились. Теперь сделаем выборку с <code>ch2</code> ноды:</p>
<pre><code>root@ch2:~# clickhouse-client --query "SELECT count() FROM posts_replicated"
500000
root@ch2:~# clickhouse-client --query "SELECT count() FROM posts_distributed"
500000
</code></pre>
<p>Видно, что на другой ноде данные появились, а также, что distributed таблица тоже отображает наши данные и не дублирует их!</p>
<p>Отлично, мы настроили реплицируемый ClickHouse кластер!</p>
<h3><strong>Полезные ссылки:</strong></h3>
<ul>
<li><a href="https://clickhouse.tech/docs/ru/engines/table-engines/mergetree-family/replication/">https://clickhouse.tech/docs/ru/engines/table-engines/mergetree-family/replication/</a></li>
<li><a href="https://clickhouse.tech/docs/ru/development/architecture/#replication">https://clickhouse.tech/docs/ru/development/architecture/#replication</a></li>
<li><a href="https://clickhouse.tech/docs/ru/engines/table-engines/mergetree-family/replication/#creating-replicated-tables">https://clickhouse.tech/docs/ru/engines/table-engines/mergetree-family/replication/#creating-replicated-tables</a></li>
</ul>
</div>
</div>
