<div>
<h1>CLCK 13: Подключение справочников на примере geoip (maxmind)</h1>
<div>
<h3><strong>Описание:</strong></h3>
<p>В данном задании мы рассмотрим что такое справочники в ClickHouse, какие они бывают, в чем их преимущество и как их подключить.</p>
<p>Начнем мы с простого, а именно, что такое справочник или словарь? Это хранение данный в виде <code>ключ - значение</code>. Представьте, что у вас есть таблица с данными вида - date, event_type, user_id. Здесь мы храним дату события, тип события и айдишник пользователя. В финальном отчете мы естественно хотим видеть не внутренний идентификатор пользователя, а его email или имя. Для этого и используются словари - вы можете по айдишнику пользователя получить его имя. При этом заметьте что если вы храните в сырых данных числовые идентификаторы - то выборка происходит быстрее. А уже на финальном этапе вы можете сматчить идентификатор с каким-то строковым значением.</p>
<p>У Кликхауса есть различные специальные функции, которые можно использовать при работе со словарями. Данный метод получается гораздо проще и эффективнее по сравнению с использованием <code>JOIN</code> в таблицах-справочниках, когда матчинг хранится локально в соседних таблицах.</p>
<p>За счет чего работать со словарями в ClickHouse эффективней?</p>
<ul>
<li>ClickHouse полностью или частично хранит словари в оперативной памяти в виде плоского массива данных.</li>
<li>Периодически обновляет словари и динамически подгружает отсутствующие значения.</li>
<li>Позволяет создавать внешние словари с помощью xml-файлов или DDL-запросов (о чем я расскажу дальше).</li>
</ul>
<h4>Типы словарей</h4>
<p>В ClickHouse есть встроенные словари, которые вы можете свободно использовать при работе. Но если их не хватает, вы легко можете подключить любые внешние словари. Именно это мы и будем делать.</p>
<p>Подключить внешний словарь можно многими способами. Будь это локальный текстовый/исполняемый файл, HTTP(S) ресурс или другая СУБД.</p>
<p>Сконфигурировать подключение можно в конфигурационном файле <code>config.xml</code>. За это отвечает параметр <code>dictionaries_config</code>. Также с помощью параметра <code>dictionaries_lazy_load</code> можно указать, будут словари загружаться при старте сервера или непосредственно при их использовании. Еще стоит заметить, что обновление словарей не блокирует обработку запросов. В это время запросы просто используют старую версию словарей.</p>
<p>Для просмотра информации о словарях, сконфигурированных на сервере, можно использовать системную таблицу <code>system.dictionaries</code>, в ней можно найти:</p>
<ul>
<li>статус словаря;</li>
<li>конфигурационные параметры;</li>
<li>метрики, например, количество занятой словарем RAM или количество запросов к нему с момента загрузки.</li>
</ul>
<h4>Конфигурация словарей</h4>
<p>Словари можно конфигурировать через <code>xml</code>-файлы или DDL-запросы. Можете использовать любой удобный вариант, но в примере мы применим DDL-запросы, поскольку это &mdash; самый простой способ создавать и контролировать словари.</p>
<p><strong>Пример шаблона для создания словаря через DDL-запрос:</strong></p>
<pre><code>CREATE DICTIONARY dict_name
(
 attribute_name UInt64 DEFAULT 0
 attribute_name String DEFAULT 'someString'
)
PRIMARY KEY ...
SOURCE(...)
LAYOUT(...)
LIFETIME(...)
</code></pre>
<p>Поля настройки:</p>
<ul>
<li><code>dict_name</code>&nbsp;&mdash; имя словаря.</li>
<li><code>attribute_name</code>&nbsp;&mdash; атрибуты словаря.</li>
<li><code>primary key</code>&nbsp;&mdash; первичный ключ словаря.</li>
<li><code>source</code>&nbsp;&mdash; источник словаря. Подробнее рассмотрим это далее.</li>
<li><code>layout</code> &mdash; размещение словаря в памяти. От этого значения зависит скорость обработки словаря.</li>
<li><code>lifetime</code>&nbsp;&mdash; периодичность обновления словарей в секундах.</li>
</ul>
<h4>Источники внешних словарей</h4>
<p>Внешние словари можно подключить через множество разных источников. Основные из них &mdash; это:</p>
<ul>
<li>локальный файл;</li>
<li>исполняемый файл;</li>
<li>HTTP(s);</li>
<li>СУБД.</li>
</ul>
<p>Самые распространенные способы подключения &mdash; через локальный файл либо СУБД, поэтому именно эти примеры мы и рассмотрим далее.</p>
<h5>Локальный файл</h5>
<p>Пример подключения словаря DDL-запросом через локальный файл имеет следующий вид:</p>
<pre><code>SOURCE(FILE(path '/opt/dictionaries/clients.csv' format 'CSV'))
SETTINGS(format_csv_allow_single_quotes = 0)
</code></pre>
<ul>
<li><code>path</code> &mdash; отвечает за путь к файлу со словарем;</li>
<li><code>format</code> &mdash; отвечает за формат этого файла;</li>
<li><code>settings</code> &mdash; дополнительные параметры (необязательное поле).</li>
</ul>
<h5>СУБД</h5>
<p>Рассмотрим подключение СУБД на примере MySQL базы данных.</p>
<p>Пример настройки:</p>
<pre><code>SOURCE(MYSQL(
 port 3306
 user 'clickhouse'
 password 'secret_password'
 replica(host 'example01-1' priority 1)
 replica(host 'example01-2' priority 1)
 db 'db_name'
 table 'table_name'
 where 'id=10'
 invalidate_query 'SQL_QUERY'
))
</code></pre>
<ul>
<li><code>port</code>&nbsp;&mdash; порт сервера MySQL. Можно задать отдельно для каждой реплики внутри тега <code>&lt;replica&gt;</code>.</li>
<li><code>user</code>&nbsp;&mdash; имя пользователя MySQL. Можно задать отдельно для каждой реплики внутри тега <code>&lt;replica&gt;</code>.</li>
<li><code>password</code>&nbsp;&mdash; пароль пользователя MySQL. Можно задать отдельно для каждой реплики внутри тега <code>&lt;replica&gt;</code>.</li>
<li><code>replica</code>&nbsp;&mdash; блок конфигурации реплики. Блоков может быть несколько.</li>
<li><code>db</code>&nbsp;&mdash; имя базы данных.</li>
<li><code>table</code>&nbsp;&mdash; имя таблицы.</li>
<li><code>where</code>&nbsp;&mdash; условие выбора. Синтаксис полностью совпадает с синтаксисом секции&nbsp;<code>WHERE</code>&nbsp;в MySQL, к примеру,&nbsp;<code>id &gt;= 3 AND id &lt; 10</code> (необязательный параметр).</li>
<li><code>invalidate_query</code>&nbsp;&mdash; запрос для проверки статуса словаря (необязательный параметр).</li>
</ul>
<h4>Хранение словарей в памяти</h4>
<p>Существует много способов хранения словарей в памяти ClickHouse:</p>
<ul>
<li><code>flat</code></li>
<li><code>hashed</code></li>
<li><code>sparse_hashed</code></li>
<li><code>cache</code></li>
<li><code>direct</code></li>
<li><code>range_hashed</code></li>
<li><code>complex_key_hashed</code></li>
<li><code>complex_key_cache</code></li>
<li><code>complex_key_direct</code></li>
<li><code>ip_trie</code></li>
</ul>
<p>Но сам ClickHouse рекомендует использовать только три из них, поскольку в этом случае скорость обработки словарей максимальна, &mdash; это <code>flat</code>, <code>hashed</code> и <code>complex_key_hashed</code>. Примеры этих способов хранения мы и рассмотрим.</p>
<h5>Flat</h5>
<p>В этом способе словари полностью хранятся в оперативной памяти в виде плоских массивов, при этом объем занятой памяти пропорционален размеру самого большого по размеру ключа словаря. Ключ словаря должен иметь тип <code>UInt64</code> и не должен быть длиннее 500 000, иначе ClickHouse бросит исключение и не создаст словарь.</p>
<p>Этот метод обеспечивает максимальную производительность из доступных способов хранения.</p>
<p>Пример конфигурации:</p>
<pre><code>LAYOUT(FLAT())
</code></pre>
<h5>Hashed</h5>
<p>Словарь полностью хранится в оперативной памяти в виде хеш-таблиц и может содержать любое количество элементов с произвольными идентификаторами. На практике количество ключей может достигать десятков миллионов элементов.</p>
<pre><code>LAYOUT(HASHED())
</code></pre>
<h5>Сomplex_key_hashed</h5>
<p>Тип размещения предназначен для использования с составными&nbsp;ключами. Аналогичен&nbsp;<code>hashed</code> способу.</p>
<p>Пример конфигурации:</p>
<pre><code>LAYOUT(COMPLEX_KEY_HASHED())
</code></pre>
<h5>Ключи</h5>
<p>ClickHouse имеет поддержку следующих видов ключей:</p>
<ul>
<li>Числовой ключ.&nbsp;<code>UInt64</code>. Описывается в теге&nbsp;<code>&lt;id&gt;</code>&nbsp;или ключевым словом&nbsp;<code>PRIMARY KEY</code>.</li>
<li>Составной ключ. Набор значений разного типа. Описывается в теге&nbsp;<code>&lt;key&gt;</code>&nbsp;или ключевым словом&nbsp;<code>PRIMARY KEY</code>.</li>
</ul>
<p><strong>Числовой ключ</strong></p>
<p>Тип:&nbsp;<code>UInt64</code>.</p>
<pre><code>CREATE DICTIONARY (
 user_id UInt64,
 ...
)
PRIMARY KEY user_id
...
</code></pre>
<ul>
<li><code>PRIMARY KEY</code> &ndash; имя столбца с ключами.</li>
</ul>
<p><strong>Составной ключ</strong></p>
<p>Ключом может быть кортеж (<code>tuple</code>) из полей произвольных типов. В этом случае&nbsp;<code>layout</code>&nbsp;должен быть&nbsp;<code>complex_key_hashed</code>&nbsp;или&nbsp;<code>complex_key_cache</code>.</p>
<p>Структура ключа задается в элементе&nbsp;<code>&lt;key&gt;</code>. Поля ключа задаются в том же формате, что и&nbsp;атрибуты&nbsp;словаря. Пример:</p>
<pre><code>CREATE DICTIONARY ( field1 String, field2 String ... )
PRIMARY KEY field1, field2
...
</code></pre>
<h4>Пример использования внешних словарей <strong>в ClickHouse</strong></h4>
<p>Один из популярных кейсов использования словарей в ClickHouse &mdash; это&nbsp;<strong>агрегация данных по странам на основе IP (v4) адресов</strong>.</p>
<p>Представим, что перед нами задача: из данных колонки с&nbsp;<code>ip String</code>&nbsp;получить в запросе колонку с&nbsp;<code>country String</code>. Для ее решения возьмем довольно популярные базы&nbsp;<strong>GeoIP2</strong>&nbsp;от MaxMind.</p>
<p>MaxMind предоставляет со своими&nbsp;<strong>.mmdb</strong>&nbsp;базами API для большинства популярных языков программирования.</p>
<p>В ClickHouse нет возможности загрузить в словарь формат&nbsp;<strong>.mmdb</strong>, но нам это и не понадобится &ndash; MaxMind позволяет загрузить свои базы в виде нескольких CSV, чем мы и воспользуемся.</p>
<p>Для того чтобы связать IP со страной, необходимо скачать следующие файлы:</p>
<ul>
<li><code>GeoIP2-Country-Blocks-IPv4.csv</code>&nbsp;&ndash; здесь содержатся связи IP префиксов и ID стран;</li>
<li><code>GeoIP2-Country-Locations-en.csv</code>&nbsp;&ndash; а здесь уже названия стран на английском.</li>
</ul>
<p>Далее заведем соответствующие словари с помощью DDL:</p>
<pre><code>CREATE DICTIONARY dicts.geoip_country_blocks_ipv4 (
 network String DEFAULT '',
 geoname_id UInt64 DEFAULT 0,
 registered_country_geoname_id UInt64 DEFAULT 0,
 represented_country_geoname_id UInt64 DEFAULT 0,
 is_anonymous_proxy UInt8 DEFAULT 0,
 is_satellite_provider UInt8 DEFAULT 0
)
PRIMARY KEY network
SOURCE(FILE(
 path '/var/lib/clickhouse/user_files/GeoIP2-Country-Blocks-IPv4.csv'
 format 'CSVWithNames'
))
LAYOUT(IP_TRIE())
LIFETIME(300);
</code></pre>
<p>В словаре&nbsp;<code>geoip_country_blocks_ipv4</code>&nbsp;мы должны указать два основных атрибута:</p>
<ul>
<li><code>network</code>&nbsp;&ndash; IP префикс сети, он же и будет ключом словаря.</li>
<li><code>geoname_id</code>&nbsp;&ndash; ID страны.</li>
</ul>
<p>Остальные атрибуты &ndash; в соответствии с заголовком в CSV.</p>
<p>Чтобы ClickHouse мог корректно сопоставить префикс сети и ID, нам необходимо использовать тип размещения&nbsp;<code>ip_trie</code>. Для получения значений из такого словаря необходимо будет передавать IP-адрес в числовом представлении.</p>
<p>Теперь&nbsp;<code>geoip_country_locations_en</code>:</p>
<pre><code>CREATE DICTIONARY dicts.geoip_country_locations_en (
 geoname_id UInt64 DEFAULT 0,
 locale_code String DEFAULT '',
 continent_code String DEFAULT '',
 continent_name String DEFAULT '',
 country_iso_code String DEFAULT '',
 country_name String DEFAULT '',
 is_in_european_union UInt8 DEFAULT 0
)
PRIMARY KEY geoname_id
SOURCE(FILE(
 path '/var/lib/clickhouse/user_files/GeoIP2-Country-Locations-en.csv'
 format 'CSVWithNames'
))
LAYOUT(HASHED())
LIFETIME(300);
</code></pre>
<p>Нам нужно связать ID и название страны. В заголовках&nbsp;<code>GeoIP2-Country-Locations-en.csv</code>&nbsp;можно найти следующие атрибуты:</p>
<ul>
<li><code>geoname_id</code>&nbsp;&ndash; ID страны, как в предыдущем словаре, но теперь в качестве ключа.</li>
<li><code>country_name</code>&nbsp;&mdash; название страны.</li>
</ul>
<p>В качестве типа размещения указываем оптимизированный&nbsp;<code>hashed</code>.</p>
<p>В каждом из словарей необходимо указать пути к соответствующим CSV файлам.</p>
<p>Теперь, имея таблицу:</p>
<pre><code>CREATE TEMPORARY TABLE user_visits (user_ip String, user_id UUID);
---INSERT INTO user_visits VALUES
 ('178.248.237.68', generateUUIDv4()),
 ('82.192.95.175', generateUUIDv4());
</code></pre>
<p>Можем посчитать количество уникальных значений по странам. Один из способов это сделать &mdash; использовать функции для работы со словарями&nbsp;<code>dictGet*</code>:</p>
<pre><code>SELECT
 dictGetString('dicts.geoip_city_locations_en', 'country_name', users_country_id) AS users_country,
 uniqs
FROM (
 SELECT
 dictGetUInt64('dicts.geoip_country_blocks_ipv4', 'geoname_id', tuple(IPv4StringToNum(user_ip))) AS users_country_id,
 uniq(user_id) AS uniqs
 FROM user_visits
 GROUP BY users_country_id
);
</code></pre>
<p>Ответ:</p>
<pre><code>┌─users_country─┬─uniqs─┐
│ Russia │ 1 │
│ Netherlands │ 1 │
└───────────────┴───────┘
2 rows in set. Elapsed: 0.003 sec.
</code></pre>
<p>Разберем данный запрос:</p>
<ol>
<li>Конвертируем строковое представление&nbsp;<code>user_ip</code>&nbsp;в числовое и оборачиваем в кортеж, чтобы соответствовать составному ключу&nbsp;<code>ip_trie</code>словаря:&nbsp;<code>tuple(IPv4StringToNum(user_ip))</code>.</li>
<li>Используем получившийся ключ, чтобы забрать ID страны как&nbsp;<code>users_country_id</code>:&nbsp;<code>dictGetUInt64('geoip_country_blocks_ipv4', 'geoname_id', ...) as users_country_id</code>.</li>
<li>Добавляем в запрос саму метрику:&nbsp;<code>uniq(user_id) as uniq_users</code>.</li>
<li>Агрегируем по ID страны, который взяли из словаря:&nbsp;<code>GROUP BY users_country_id</code>.</li>
<li>Результат, содержащий ID стран, сопоставляем с названиями:&nbsp;<code>dictGetString('geoip_city_locations_en', 'country_name', users_country_id) AS users_country</code>.</li>
</ol>
<p>Таким образом возможно сопоставлять не только названия стран. В тех же GeoIP2 базах есть много другой полезной информации, не бойтесь пробовать :)</p>
<h3><strong>Полезные ссылки:</strong></h3>
<ul>
<li><a href="https://clickhouse.tech/docs/ru/sql-reference/dictionaries/external-dictionaries/external-dicts/">https://clickhouse.tech/docs/ru/sql-reference/dictionaries/external-dictionaries/external-dicts/</a></li>
<li><a href="https://clickhouse.tech/docs/ru/sql-reference/dictionaries/internal-dicts/">https://clickhouse.tech/docs/ru/sql-reference/dictionaries/internal-dicts/</a></li>
<li><a href="https://habr.com/ru/company/rebrainme/blog/513972/">https://habr.com/ru/company/rebrainme/blog/513972/</a></li>
</ul>
</div>
</div>
