<div>
<h1>CLCK 05: Настройка профилей</h1>
<div>
<h3><strong>Описание:</strong></h3>
<p>Итак, мы наконец-то добрались до настроек пользователей. На самом деле большинство настроек пользователь задает сам при подключении к кликхаусу. Помните мы выполняли запрос для включения логирования - <code>SET log_query = 1</code>. В данном случае мы задаем настройку для пользователя - log_query = 1. Но действовать она будет только в рамках той сессии, в которой работает пользователь. В файле users.xml мы можем указать дефолтные параметры настроек для пользователя, чтобы он каждый раз не вводил их вручную или не тратил время на их применение.</p>
<p>На самом деле профили и настройки вынесены на клиента для более гибкого управления конфигурацией. Клиент сам может в случае необходимости поменять какие-то значения для корректной работы. То есть важно понимать, что профили используются именно для задания настроек по умолчанию, а не лимитирования. Для лимитирования пользователя используются квоты - их мы рассмотрим в следующем задании.</p>
<p>Ниже приведен пример конфигурации профилей, которые вы можете потом указывать в настройках пользователей.</p>
<pre><code>&lt;yandex&gt;
&lt;profiles&gt;
&lt;default&gt;
 &lt;use_uncompressed_cache&gt;0&lt;/use_uncompressed_cache&gt;
 &lt;load_balancing&gt;random&lt;/load_balancing&gt;
&lt;/default&gt;
 &lt;myprofile&gt;
 &lt;max_memory_usage&gt;20000000000&lt;/max_memory_usage&gt;
&lt;max_rows_to_read&gt;1000000000&lt;/max_rows_to_read&gt;
&lt;max_bytes_to_read&gt;100000000000&lt;/max_bytes_to_read&gt;
&lt;max_result_rows&gt;1000000&lt;/max_result_rows&gt;
&lt;max_execution_time&gt;600&lt;/max_execution_time&gt;
&lt;max_columns_to_read&gt;30&lt;/max_columns_to_read&gt;
&lt;readonly&gt;1&lt;/readonly&gt;
 &lt;/myprofile&gt;
&lt;/profiles&gt;
&lt;/yandex&gt;
</code></pre>
<p>Давайте рассмотрим некоторые настройки из него.</p>
<h4>&lt;max_memory_usage&gt;</h4>
<p>Максимально допустимое количество памяти, которое может быть использовано для выполнения запроса. По-умолчанию в основной конфигурации выставлено значение в 10Гб. Данный параметр не учитывает количество имеющейся свободной памяти на машине, а используется для ограничение запроса пользователя если он вдруг введет запрос, который использует больше 10 Gb оперативной памяти. Мы так же советуем всем выставлять данный параметр для всех пользователей достаточно низким, а тем кому действительно надо поднимать его в отдельном профиле. Например, это может быть сервис, который пересчитывает статистику за неделю и ему действительно требуется использовать много памяти. Кстати, вы можете посмотреть потребление памяти для каждого запроса через <code>SHOW PROCESSLIST</code>.</p>
<h4>&lt;max_rows_to_read&gt;</h4>
<p>Максимальное количество строк, которое можно прочитать при выполнении запроса.</p>
<h4>&lt;max_bytes_to_read&gt;</h4>
<p>Максимальное количество байт, которое можно прочитать при выполнении запроса.</p>
<h4>&lt;max_result_rows&gt;</h4>
<p>Максимальное количество строк, которое будет выдано запросом после его выполнения.</p>
<h4>&lt;max_execution_time&gt;</h4>
<p>Максимальное количество времени (в секундах), которое дается на выполнение запроса.</p>
<h4>&lt;max_columns_to_read&gt;</h4>
<p>Максимальное количество доступных колонок для чтения при выполнении запроса.</p>
<p>Режим, который обеспечивает доступ только на чтение. Для его активации укажите в значении <code>1</code>.</p>
<p>Как вы могли заметить - профили по сути описывают стандартные настройки для пользователя, который может их изменить в процессе работы. Среди профилей есть <code>default</code>, который обязателен и используется при запуске сервера.</p>
<p>В данном случае мы создали новый <code>myprofile</code>, в котором указали некоторые параметры, отличные от тех, что идут по умолчанию.</p>
<p>Чтобы применить настройки, нужно установить настройку <code>profile</code>. Команда выглядит следующим образом:</p>
<pre><code>SET profile = 'myprofile';
</code></pre>
<p>Проверить, применились ли они, мы можем, посмотрев в системную таблицу <code>system.settings</code> и найдя значение нужного параметра. Если у вас не хватает прав на просмотр системных таблиц для <code>default</code> пользователя, убедитесь, что в настройках пользователей включен параметр <code>&lt;access_management&gt;</code>.</p>
<p>Давайте попробуем создать отдельный профиль нашему пользователю <code>test</code> и проверить его работу. Добавляем опции в users.xml:</p>
<pre><code> &lt;test&gt;
 &lt;max_memory_usage&gt;20000000000&lt;/max_memory_usage&gt;
&lt;max_rows_to_read&gt;1000000000&lt;/max_rows_to_read&gt;
&lt;max_bytes_to_read&gt;100000000000&lt;/max_bytes_to_read&gt;
&lt;max_result_rows&gt;1&lt;/max_result_rows&gt;
&lt;max_execution_time&gt;600&lt;/max_execution_time&gt;
&lt;max_columns_to_read&gt;30&lt;/max_columns_to_read&gt;
&lt;readonly&gt;0&lt;/readonly&gt;
 &lt;/test&gt;
</code></pre>
<p>Здесь мы указали одну очень маленькую опцию - max_result_rows, которая не будет возвращать больше 1 строки нашему пользователю. А так же отключили режим только для чтения для нашего пользователя. Давайте теперь изменим параметр для нашего пользователя и зададим ему профиль по умолчанию <code>&lt;profile&gt;test&lt;/profile&gt;</code>, а так же уберем фильтр на вывод строк из таблицы. То есть просто удалим вот этот блок в описании пользователя:</p>
<pre><code> &lt;databases&gt;
 &lt;database_name&gt;
 &lt;table_name&gt;
 &lt;filter&gt;role = 'user'&lt;/filter&gt;
 &lt;table_name&gt;
 &lt;/database_name&gt;
 &lt;/databases&gt;
</code></pre>
<p>Теперь можно рестартовать кликхаус и тестировать:</p>
<pre><code>clickhouse-client -u test
ClickHouse client version 21.2.5.5 (official build).
Connecting to localhost:9000 as user test.
Connected to ClickHouse server version 21.2.5 revision 54447.
ch1.ru-central1.internal :) Cannot load data for command line suggestions: Code: 396, e.displayText() = DB::Exception: Received from localhost:9000. DB::Exception: Limit for result exceeded, max rows: 1.00, current rows: 922.00. (version 21.2.5.5 (official build))
ch1.ru-central1.internal :) select * from logs.data;
&rarr; Progress: 3.00 rows, 64.00 B (29.54 rows/s., 630.16 B/s.) 99%
0 rows in set. Elapsed: 0.102 sec.
Received exception from server (version 21.2.5):
Code: 396. DB::Exception: Received from localhost:9000. DB::Exception: Limit for result exceeded, max rows: 1.00, current rows: 3.00.
ch1.ru-central1.internal :)
</code></pre>
<p>Смотрите как интересно - сразу при подключении мы получили ошибку от кликхауса. Произошло это потому что кликхаус хочет подгрузить данные для автодополнения команд из внутренней таблицы, но лимит на количество строк для чтения у нас выставлен в единицу, а список дополнений - 922 штуки. Отсюда и ошибка.</p>
<p>Та же ошибка возникает при попытке прочитать таблицу logs.data, которая содержит три строки (помните мы убрали фильтр на них). Давайте попробуем поменять данные найстройки прямо в текущей сессии:</p>
<pre><code>ch1.ru-central1.internal :) set max_result_rows = 100;
Ok.
ch1.ru-central1.internal :) select * from logs.data;
SELECT *
FROM logs.data
Query id: 232c3e85-bcc4-4e9a-8217-c643e46d642a
┌──────────────────ev─┬─a─┬─role──┐
│ 2021-03-09 12:00:00 │ 1 │ admin │
│ 2021-03-09 12:01:00 │ 2 │ user │
│ 2021-03-09 12:02:00 │ 3 │ test │
└─────────────────────┴───┴───────┘
3 rows in set. Elapsed: 0.002 sec.
ch1.ru-central1.internal :)
</code></pre>
<p>Как видите - наш запрос успешно отработал. То есть пользователь может изменить свои дефолтные настройки при возникновении каких-либо ошибок. По-другому дело обстоит если у профиля задана опция readonly = true - она запрещает изменение текущие настроек пользователя. Давайте попробуем включить ее в конфигурации для профиля test и воспроизвести наш пример <code>&lt;readonly&gt;1&lt;/readonly&gt;</code>:</p>
<pre><code>ch1.ru-central1.internal :) set max_result_rows = 100;
0 rows in set. Elapsed: 0.001 sec.
Received exception from server (version 21.2.5):
Code: 164. DB::Exception: Received from localhost:9000. DB::Exception: Cannot modify 'max_result_rows' setting in readonly mode.
ch1.ru-central1.internal :)
</code></pre>
<p>Ага! То есть кликхаус не дает нам поменять наши конфигурационные параметры при работе в readonly режиме. Так же он не даст нам изменить настройку readonly в readonly режиме :)</p>
<h3><strong>Полезные ссылки:</strong></h3>
<ul>
<li><a href="https://clickhouse.tech/docs/ru/operations/configuration-files/">https://clickhouse.tech/docs/ru/operations/configuration-files/</a></li>
<li><a href="https://clickhouse.tech/docs/ru/operations/settings/settings-profiles/">https://clickhouse.tech/docs/ru/operations/settings/settings-profiles/</a></li>
<li><a href="https://clickhouse.tech/docs/ru/operations/settings/query-complexity">https://clickhouse.tech/docs/ru/operations/settings/query-complexity</a></li>
</ul>
</div>
<br />
</div>
