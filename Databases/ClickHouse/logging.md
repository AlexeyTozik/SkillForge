<div>
<h1>CLCK 03: Настройка логирования в ClickHouse</h1>
<div>
<h3><strong>Описание:</strong></h3>
<h4>Основное логирование</h4>
<p>В ClickHouse по умолчанию включено логирование событий на сервере, настроить его можно в секции <code>logger</code>. На самом деле это очень важная часть по настройке кликхауса. Практически всегда и везде вам придется идти в логи, чтобы найти почему clickhouse ведет себя не так как задумано. А при каких-то ошибках и попытке задать вопрос в телеграм чат с разработчиками вас точно спросят про дебаг логи. Кстати, мы даже писали совсем небольшую утилитку, которая парсит логи кликхауса и выдает собранные метрики через prometheus - сколько времени заняли запросы, использование cpu, памяти и так далее. Посмотреть на нее можно <a href="https://github.com/vozerov/prometheus-clickhouselog-exporter">здесь</a>.</p>
<pre><code>&lt;yandex&gt;
&lt;logger&gt;
 &lt;level&gt;trace&lt;/level&gt;
 &lt;log&gt;/var/log/clickhouse-server/clickhouse-server.log&lt;/log&gt;
 &lt;errorlog&gt;/var/log/clickhouse-server/clickhouse-server.err.log&lt;/errorlog&gt;
 &lt;size&gt;1000M&lt;/size&gt;
 &lt;count&gt;10&lt;/count&gt;
&lt;/logger&gt;
&lt;/yandex&gt;
</code></pre>
<p>Пройдемся по параметрам. За уровень логирования отвечает <code>level</code> параметр и он может быть: <code>trace</code>, <code>debug</code>, <code>information</code>, <code>warning</code>, <code>error</code>. <code>trace</code> уровень логирования является самым подробным и рекомендуется к использованию в продакшене.</p>
<p>Пути, где будут лежать логи сервера и логи ошибок, задаются параметрами <code>log</code> и <code>errorlog</code>. <code>size</code> &mdash; это максимальный размер файла с логами, при достижении этого размера ClickHouse архивирует файл и создает новый. Максимальное количество заархивированных файлов с логами задается параметром <code>count</code>.</p>
<p>Собственно настройки достаточно простые, но мы советуем вам выставить уровень логирования в трейс, перезапустить сервер и посмотреть на то что будет писать внутри вашего лог файла. Обещаю - вы удивитесь количеству строк на одно подключение клиента :)</p>
<h4>Дополнительное логирование</h4>
<p>Помимо базовых логов, которые вы можете увидеть в секции <code>logger</code>, вы так же можете включить дополнительную отладку интересующих вас вещей:</p>
<ul>
<li><code>query_log</code> - логирует запросы пользователей в системную таблицу</li>
<li><code>trace_log</code> - логирует трейс запроса, собранного профайлерами запросов</li>
<li><code>query_thread_log</code> - информация по всем потокам, которые выполнялись при обработке запроса</li>
<li><code>part_log</code> - информация по всем действиям с частями данных для движков merge tree. Информацию по партам мы будем изучать чуть дальше, а пока стоит сказать, что кликхаус, когда записывает данные создает отдельные файлы с ними - парты. А уже дальше, в фоне, спокойно их сортирует и объединяет между собой. Собственно данный лог и относится к процессам создания партов, их слияния и удаления</li>
<li><code>text_log</code> - текстовый лог сервера, который мы настраивали в файле в самом начале. Хранится в системной таблице и позволяет получить доступ к логам, используя sql запрос</li>
<li><code>crash_log</code> - лог падений - в нормальном состоянии он пуст, но если случится что-то непоправимое, то смотреть трейс фатальной ошибки можно будет здесь.</li>
</ul>
<p>Все эти секции настраиваются практически одинаково и требуют для себя только название базы и таблицы куда необходимо записывать данные. Помимо этого указывается flush_interval - как часто кликхаус будет сбрасывать накопленные логи в таблицу. Иногда еще встречается параметр <code>partition_by</code>, который указывает как разбивать таблицу на части. Например, можно делать это каждый день - <code>&lt;partition_by&gt;toYYYYMM(event_date)&lt;/partition_by&gt;</code>, в таком случае таблица будет разбита на части и каждая часть будет содержать в себе данные за один день.</p>
<p>Итак, давайте вкючим логирование запросов, а так же query_thread_log:</p>
<pre><code> &lt;!-- Query log. Used only for queries with setting log_queries = 1. --&gt;
 &lt;query_log&gt;
 &lt;database&gt;system&lt;/database&gt;
 &lt;table&gt;query_log&lt;/table&gt;
 &lt;partition_by&gt;toYYYYMM(event_date)&lt;/partition_by&gt;
 &lt;flush_interval_milliseconds&gt;7500&lt;/flush_interval_milliseconds&gt;
 &lt;/query_log&gt;
 &lt;!-- Trace log. Stores stack traces collected by query profilers.
 See query_profiler_real_time_period_ns and query_profiler_cpu_time_period_ns settings. --&gt;
 &lt;trace_log&gt;
 &lt;database&gt;system&lt;/database&gt;
 &lt;table&gt;trace_log&lt;/table&gt;
 &lt;partition_by&gt;toYYYYMM(event_date)&lt;/partition_by&gt;
 &lt;flush_interval_milliseconds&gt;7500&lt;/flush_interval_milliseconds&gt;
 &lt;/trace_log&gt;
 &lt;!-- Query thread log. Has information about all threads participated in query execution.
 Used only for queries with setting log_query_threads = 1. --&gt;
 &lt;query_thread_log&gt;
 &lt;database&gt;system&lt;/database&gt;
 &lt;table&gt;query_thread_log&lt;/table&gt;
 &lt;partition_by&gt;toYYYYMM(event_date)&lt;/partition_by&gt;
 &lt;flush_interval_milliseconds&gt;7500&lt;/flush_interval_milliseconds&gt;
 &lt;/query_thread_log&gt;
</code></pre>
<p>Теперь перезапустим наш кликхаус и попробуем выполнить простой запрос и посмотреть на него:</p>
<pre><code>root@ch1:/etc/clickhouse-server# /etc/init.d/clickhouse-server restart
root@ch1:/etc/clickhouse-server# clickhouse-client
ClickHouse client version 21.2.5.5 (official build).
Connecting to localhost:9000 as user default.
Connected to ClickHouse server version 21.2.5 revision 54447.
ch1.ru-central1.internal :) set log_queries = 1
ch1.ru-central1.internal :) set log_query_threads = 1
ch1.ru-central1.internal :) select 1;
SELECT 1
Query id: 029b0df1-0a66-40c0-a44c-45fb0b3f46de
┌─1─┐
│ 1 │
└───┘
1 rows in set. Elapsed: 0.002 sec.
ch1.ru-central1.internal :) quit
Bye.
root@ch1:/etc/clickhouse-server#
</code></pre>
<p>Итак, в начале мы перезапустили кликхаус сервер, после чего подключились к нему, используя командную утилиту clickhouse-client. Дальше мы задали параметры подключения - log_queries = 1 и log_query_threads = 1, чтобы кликхаус начал логировать наши запросы в системные таблицы. Настройки в кликхаусе по большей части задаются на уровне клиента, а не сервера. Это мы будем обсуждать в 4ом задании. В данном случае мы включили на клиенте логирование запросов. Я не советую включать его вообще для всех запросов - иначе нагрузка может стать по-настоящему большой :)</p>
<p>Итак, давайте переподключимся к серверу еще раз, чтобы сбросить параметры логирования запросов и посмотрим на наш query_log:</p>
<pre><code>ch1.ru-central1.internal :) select * from system.query_log where query='select 1;';
SELECT *
FROM system.query_log
WHERE query = 'select 1;'
Query id: 5695328f-8063-4d55-a6af-163ef7c9ea0b
┌─type────────┬─event_date─┬──────────event_time─┬────event_time_microseconds─┬────query_start_time─┬─query_start_time_microseconds─┬─query_duration_ms─┬─read_rows─┬─read_bytes─┬─written_rows─┬─written_bytes─┬─result_rows─┬─result_bytes─┬─memory_usage─┬─current_database─┬─query─────┬─normalized_query_hash─┬─query_kind─┬─databases──┬─tables─────────┬─columns──────────────┬─exception_code─┬─exception─┬─stack_trace─┬─is_initial_query─┬─user────┬─query_id─────────────────────────────┬─address──────────┬──port─┬─initial_user─┬─initial_query_id─────────────────────┬─initial_address──┬─initial_port─┬─interface─┬─os_user─┬─client_hostname──────────┬─client_name─┬─client_revision─┬─client_version_major─┬─client_version_minor─┬─client_version_patch─┬─http_method─┬─http_user_agent─┬─http_referer─┬─forwarded_for─┬─quota_key─┬─revision─┬─log_comment─┬─thread_ids──┬─ProfileEvents.Names────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┬─ProfileEvents.Values─────────────────────────────────────┬─Settings.Names───────────────────────────────────────────────────────────────────────────────────┬─Settings.Values──────────────────────┬─used_aggregate_functions─┬─used_aggregate_function_combinators─┬─used_database_engines─┬─used_data_type_families─┬─used_dictionaries─┬─used_formats─┬─used_functions─┬─used_storages─┬─used_table_functions─┐
│ QueryStart │ 2021-03-09 │ 2021-03-09 14:10:08 │ 2021-03-09 14:10:08.484932 │ 2021-03-09 14:10:08 │ 2021-03-09 14:10:08.484932 │ 0 │ 0 │ 0 │ 0 │ 0 │ 0 │ 0 │ 0 │ default │ select 1; │ 17481869692703361983 │ Select │ ['system'] │ ['system.one'] │ ['system.one.dummy'] │ 0 │ │ │ 1 │ default │ 029b0df1-0a66-40c0-a44c-45fb0b3f46de │ ::ffff:127.0.0.1 │ 39458 │ default │ 029b0df1-0a66-40c0-a44c-45fb0b3f46de │ ::ffff:127.0.0.1 │ 39458 │ 1 │ vozerov │ ch1.ru-central1.internal │ ClickHouse │ 54447 │ 21 │ 2 │ 5 │ 0 │ │ │ │ │ 54447 │ │ [] │ [] │ [] │ ['use_uncompressed_cache','load_balancing','log_queries','max_memory_usage','log_query_threads'] │ ['0','random','1','10000000000','1'] │ [] │ [] │ [] │ [] │ [] │ [] │ [] │ [] │ [] │
</code></pre>
<p>Я опустил весь вывод данной команды, поскольку она содержит очень много выходной информации. Но базовые вещи вы можете увидеть невооруженным взглядом - тип запроса, время начала, продолжительность, количество прочитанных байт и так далее. Это очень мощный инструмент для отладки вашей установки кликхауса.</p>
<h3><strong>Полезные ссылки:</strong></h3>
<ul>
<li><a href="https://clickhouse.tech/docs/ru/operations/server-configuration-parameters/settings/#server_configuration_parameters-logger">https://clickhouse.tech/docs/ru/operations/server-configuration-parameters/settings/#server_configuration_parameters-logger</a></li>
<li><a href="https://clickhouse.tech/docs/ru/operations/server-configuration-parameters/settings/#server_configuration_parameters-part-log">https://clickhouse.tech/docs/ru/operations/server-configuration-parameters/settings/#server_configuration_parameters-part-log</a></li>
</ul>
</div>
</div>
