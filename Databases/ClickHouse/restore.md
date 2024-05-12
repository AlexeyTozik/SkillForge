<div>
<h1>CLCK 12: Восстановление после сбоя</h1>
<div>
<h3><strong>Описание:</strong></h3>
<p>В этом задании мы расскажем про основные моменты, которые вам необходимо знать при работе с репликами и шардами в кликхаусе.</p>
<h4>Отвал реплики в ClickHouse</h4>
<p>Если реплика отвалилась при вставке данных через <strong>Distributed</strong> таблицу, будет выбрана следующая живая реплика. В нашем случае мы имеем по 2 реплики в каждом шарде, поэтому все данные будут вставлены в рабочую реплику.</p>
<p>Как только реплика будет восстановлена &mdash; она автоматически попытается установить соединение с <strong>Zookeeper</strong>. Когда это произойдет, будут обнаружены все недостающие данные, которые будут скачаны с актуальной реплики.</p>
<h4>Отвал шарда в ClickHouse</h4>
<p>В случае отвала целого шарда вставки через <strong>Distributed</strong> таблицу в него будут недоступны. Данные не будут пропадать, но будут храниться в соответствующей поддиректории, созданной движком <strong>Distributed</strong>. Как только состояние шарда вернется в рабочее &mdash; все данные будут автоматически вставлены туда.</p>
<p>Если же за время падения в конфигурации кластера ClickHouse изменились названия хостов, входящих в шард, то данные не будут автоматически вставлены. Вместо этого движком <strong>Distributed</strong> будут созданы новые поддиректории с обновленными названиями хостов. ClickHouse не будет совершать никаких деструктивных действий по удалению данных. Данные, которые не были перенесены, придется перенести вручную.</p>
<h4>Отвал ноды Zookeeper</h4>
<p>Если при запуске сервера Zookeeper оказался недоступным &mdash; все <strong>Replicated</strong> таблицы в кластере перейдут в режим только для чтения. Также при попытке сделать INSERT будет показана ошибка. ClickHouse будет периодически пытаться установить соединение с Zookeeper.</p>
<p>Когда соединение будет успешно установлено, сервер проверит соответствие существующих данных и данных, которые нода запросит у Zookeeper. Если изменения были небольшими, то сервер дополнит данные с других реплик. Если были обнаружены битые данные или неизвестные куски данных, о которых нет информации в Zookeeper, система перенесет эти куски в поддиректорию <strong>detached</strong>. Если обнаружится, что локальные данные сильно отличаются от ожидаемых &mdash; сработает защитный механизм и сервер не запустится. Сообщение о таком поведении можно найти в логах. Оно было задумано на случай ошибки в конфигурации кластера или других подобных ситуаций.</p>
<p>Восстановление можно инициализировать 2-мя способами:</p>
<ul>
<li>создав соответствующий узел в Zookeeper с любым содержимым по пути <code>/path_to_table/replica_name/flags/force_restore_data</code></li>
<li>создав файл <code>force_restore_data</code> в директории сервера:</li>
</ul>
<pre><code>$ sudo -u clickhouse touch /var/lib/clickhouse/flags/force_restore_data
</code></pre>
<h3>Отвал реплики в реплицированном кластере ClickHouse</h3>
<p>Давайте теперь рассмотрим это все на практике. Для этого мы будем использовать нефункционирующий кластер из 1-го шарда по 2 реплики и ноды Zookeeper для репликации. В нашем случае с нашим кластером что-то не так, а именно со второй нодой ClickHouse.</p>
<p>Давайте зайдём на неё и посмотрим что там:</p>
<pre><code>root@ch2:/# clickhouse-client
ClickHouse client version 21.2.4.6 (official build).
Connecting to localhost:9000 as user default.
Connected to ClickHouse server version 21.2.4 revision 54447.
ch2 :) show tables
SHOW TABLES
Query id: ad47c2dd-167c-47b7-ac42-ca84b24bc713
┌─name────────────┐
│ cars_replicated │
└─────────────────┘
1 rows in set. Elapsed: 0.005 sec.
ch2 :)
</code></pre>
<p>Как мы видим нас пускает в клиент, и у нас есть всего одна таблица, которая называется <code>cars_replicated</code>. Теперь давайте попробуем сделать выборку из этой таблицы.</p>
<pre><code>ch2 :) SELECT * FROM cars_replicated
│ Datsun 310 GX │ 38 │ 4 │ 91 │ 67 │ 1995 │ 16.2 │ 82 │ Japan │
│ Toyota Celica GT │ 32 │ 4 │ 144 │ 96 │ 2665 │ 13.9 │ 82 │ Japan │
└─────────────────────────────┴──────┴───────────┴──────────────┴────────────┴────────┴──────────────┴───────┴────────┘
↘ Progress: 79.00 rows, 6.73 KB (749.21 rows/s., 63.84 KB/s.)
79 rows in set. Elapsed: 0.107 sec.
Received exception from server (version 21.2.4):
Code: 1000. DB::Exception: Received from localhost:9000. DB::Exception: File not found: /var/lib/clickhouse/store/fe8/fe86f2fb-fd1f-4e99-887f-5ac2190d4da9/d7870d806368315708ebb3c8f4bbe1ec_0_0_0/data.mrk3.
ch2 :)
</code></pre>
<p>Мы видим, что что-то случилось с нашей репликой, и теперь она некорректно работает. Так как мы имеем реплицируемый кластер мы можем просто создать её заново. Поэтому давайте удалим эту таблицу.</p>
<pre><code>ch2 :) DROP TABLE cars_replicated
</code></pre>
<p>Теперь мы можем создать её заново.</p>
<pre><code>ch2 :) CREATE TABLE cars_replicated
(
 Car String,
 MPG Float64,
 Cylinders Int32,
 Displacement Float64,
 Horsepower Float64,
 Weight Float64,
 Acceleration Float64,
 Model Int32,
 Origin String
)
ENGINE = ReplicatedMergeTree('/clickhouse/{cluster}/tables/cars_replicated', '{replica}')
PARTITION BY Origin
ORDER BY Origin;
Query id: 53623dbf-905f-41b0-ae30-1de289938f3c
0 rows in set. Elapsed: 0.011 sec.
Received exception from server (version 21.2.4):
Code: 253. DB::Exception: Received from localhost:9000. DB::Exception: Replica /clickhouse/ch_cluster/tables/cars_replicated/replicas/ch2 already exists..
ch2 :)
</code></pre>
<p>Как мы видим, мы получаем ошибку, которая говорит нам, что в Zookeeper все еще осталась наша реплика и поэтому мы не можем её создать. Для решения этой проблемы нам нужно зайти на ноду Zookeeper и удалить эту реплику оттуда.</p>
<pre><code>root@zk1:/# /opt/zookeeper/bin/zkCli.sh -server localhost:2181
...
WatchedEvent state:SyncConnected type:None path:null
[zk: localhost:2181(CONNECTED) 0] deleteall /clickhouse/ch_cluster/tables/cars_replicated/replicas/ch2
</code></pre>
<p>Здесь я делаю <code>deleteall</code>, что позволяет нам удалить выбранную ноду и всё, что в ней находится. А путь я указываю тот же, что мы использовали при создании реплицированных таблиц, и в нём я указываю вторую реплику.</p>
<p>После того, как мы удалили реплику из Zookeeper мы можем вернуться к нашему клиенту и попробовать выполнить наш запрос снова.</p>
<pre><code>ch2 :) CREATE TABLE cars_replicated
(
 Car String,
 MPG Float64,
 Cylinders Int32,
 Displacement Float64,
 Horsepower Float64,
 Weight Float64,
 Acceleration Float64,
 Model Int32,
 Origin String
)
ENGINE = ReplicatedMergeTree('/clickhouse/{cluster}/tables/cars_replicated', '{replica}')
PARTITION BY Origin
ORDER BY Origin;
Query id: bae59315-c805-4af5-96c7-ccaa566cfce7
Ok.
0 rows in set. Elapsed: 0.031 sec.
ch2 :)
</code></pre>
<p>В этот раз как видите мы успешно создали таблицу и теперь давайте проверим, появились ли наши данные там.</p>
<pre><code>ch2 :) SELECT * FROM cars_replicated
Query id: 8f8f0baf-5a46-4c33-a8d5-61cdee6d1a02
...
│ Dodge Rampage │ 32 │ 4 │ 135 │ 84 │ 2295 │ 11.6 │ 82 │ US │
│ Ford Ranger │ 28 │ 4 │ 120 │ 79 │ 2625 │ 18.6 │ 82 │ US │
│ Chevy S-10 │ 31 │ 4 │ 119 │ 82 │ 2720 │ 19.4 │ 82 │ US │
└──────────────────────────────────────┴──────┴───────────┴──────────────┴────────────┴────────┴──────────────┴───────┴────────┘
406 rows in set. Elapsed: 0.003 sec.
ch2 :)
</code></pre>
<p>Как мы видим, данные снова появились на реплики и наш кластер вернулся в нормальное состояние.</p>
<h3><strong>Полезные ссылки:</strong></h3>
<ul>
<li><a href="https://clickhouse.tech/docs/ru/engines/table-engines/mergetree-family/replication/#vosstanovlenie-posle-sboia">https://clickhouse.tech/docs/ru/engines/table-engines/mergetree-family/replication/#vosstanovlenie-posle-sboia</a></li>
<li><a href="https://clickhouse.tech/docs/ru/engines/table-engines/mergetree-family/replication/#vosstanovlenie-v-sluchae-poteri-vsekh-dannykh">https://clickhouse.tech/docs/ru/engines/table-engines/mergetree-family/replication/#vosstanovlenie-v-sluchae-poteri-vsekh-dannykh</a></li>
</ul>
</div>
</div>
