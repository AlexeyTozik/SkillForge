<div>
<h1>CLCK 04: Настройка пользователей</h1>
<div>
<h3><strong>Описание:</strong></h3>
<p>Еще один немаловажный файл для настройки кликхаус сервера - это <code>users.xml</code>, который лежит в директории <code>/etc/clickhouse-server/</code>. В нем можно добавить пользователей, настроить для них профили и квоты. Но в этом задании мы начнем с создания пользователей.</p>
<p>Структура конфигурации пользователей выглядит следующим образом:</p>
<pre><code>&lt;yandex&gt;
&lt;users&gt;
&lt;user_name&gt;
 &lt;password&gt;&lt;/password&gt;
 &lt;!-- Или --&gt;
 &lt;password_sha256_hex&gt;&lt;/password_sha256_hex&gt;
 &lt;access_management&gt;0|1&lt;/access_management&gt;
 &lt;networks incl="networks" replace="replace"&gt;
&lt;ip&gt;::1&lt;/ip&gt;
&lt;ip&gt;0.0.0.0&lt;/ip&gt;
&lt;host&gt;host.example.com&lt;/host&gt;
&lt;host_regexp&gt;.*\.example\.com$&lt;/host_regexp&gt;
 &lt;/networks&gt;
 &lt;profile&gt;profile_name&lt;/profile&gt;
 &lt;quota&gt;default&lt;/quota&gt;
 &lt;databases&gt;
 &lt;database_name&gt;
 &lt;table_name&gt;
 &lt;filter&gt;role = 'user'&lt;/filter&gt;
 &lt;table_name&gt;
 &lt;/database_name&gt;
 &lt;/databases&gt;
 &lt;/user_name&gt;
&lt;/users&gt;
&lt;/yandex&gt;
</code></pre>
<h4>&lt;user_name&gt;</h4>
<p>Имя пользователя. Если оно не указано, то будет использоваться пользователь <code>default</code>.</p>
<p>Пароль пользователя. Может быть пустым. Пароли хранятся либо в текстовом варианте, либо в хэшированом (sha256, double_sha1). Мы рекомендуем использовать хешированный вариант записи, чтобы при получении доступа к серверу было невозможно прочитать конфигурационный файл и получить пароль в открытом виде.</p>
<h4>&lt;access_management&gt;</h4>
<p>Параметр, который отвечает за управление доступом для пользователя, подобно MySQL. По факту разрешает данному пользователю управление другими пользователями. По-умолчанию данная опция выключена (0).</p>
<p>Список сетей, из которых пользователь может подключиться к ClickHouse. Обычно доступ пользователям разрешается со всех айпи адресов, поскольку безопасность по сети регулируются ее приватностью и настройкой фаервола. То есть мы советуем выделять кластер кликхауса в отдельуню приватную сеть с запретом доступа всем, кроме разрешенных хостов, а для разработчиков и административных пользователей советуем использовать VPN.</p>
<ul>
<li><strong>ip -</strong> &mdash; задает адрес или диапазон адресов;</li>
<li><strong>host -</strong> &mdash; имя хоста;</li>
<li><strong>host_regexp</strong> &mdash; регулярное выражение для имен хостов.</li>
</ul>
<p>Профиль для указаного пользователя. Профили конфигурируются в отдельной секции файла <code>users.xml</code>. Их мы рассмотрим в следующем задании.</p>
<p>Квоты для указанного пользователя. Квоты конфигурируются в отдельной секции файла <code>users.xml</code>. Их мы так же рассмотрим в следующем задании.</p>
<p>Позволяет ограничить выдачу данных запросом <code>SELECT</code> для пользователя. Этот параметр содержит список баз и таблиц (<code>database_name</code> и <code>table_name</code> в примере), к которым будут применяться ограничения. Параметр <code>filter</code> содержать выражение любого вида, которое возвращает число. Строки в ответе на запрос, для которых фильтр возвращает 0 не будут отображаться в конечном запросе.</p>
<p>Давайте попробуем создать нашего пользователя и попробовать настроить для него фильтрацию строк из нашей таблицы. Для начала создадим таблицу и занесем в нее некоторые данные:</p>
<pre><code>ch1.ru-central1.internal :) create database logs;
ch1.ru-central1.internal :) create table logs.data (ev DateTime, a Int, role String) ENGINE MergeTree PARTITION BY toYYYYMM(ev) ORDER BY ev;
ch1.ru-central1.internal :) insert into logs.data values ('2021-03-09T12:00:00', 1, 'admin');
ch1.ru-central1.internal :) insert into logs.data values ('2021-03-09T12:01:00', 2, 'user');
ch1.ru-central1.internal :) insert into logs.data values ('2021-03-09T12:02:00', 3, 'test');
ch1.ru-central1.internal :) select * from data;
┌──────────────────ev─┬─a─┬─role──┐
│ 2021-03-09 12:00:00 │ 1 │ admin │
└─────────────────────┴───┴───────┘
┌──────────────────ev─┬─a─┬─role─┐
│ 2021-03-09 12:01:00 │ 2 │ user │
└─────────────────────┴───┴──────┘
┌──────────────────ev─┬─a─┬─role─┐
│ 2021-03-09 12:02:00 │ 3 │ test │
└─────────────────────┴───┴──────┘
3 rows in set. Elapsed: 0.003 sec.
ch1.ru-central1.internal :)
</code></pre>
<p>Итак, в начале мы создали базу данных logs, а потом таблицу data внутри этой базы. Таблица у нас достаточно простая и содержит всего лишь три колонки - время события, числовое значение события и role - строку. После создания мы сразу же добавили три строки в нашу таблицу.</p>
<p>Давайте теперь создадим пользователя test без пароля и попробуем разрешить ему выводить строки только с типом role = test:</p>
<pre><code> &lt;test&gt;
 &lt;password&gt;&lt;/password&gt;
 &lt;access_management&gt;0&lt;/access_management&gt;
 &lt;networks incl="networks" replace="replace"&gt;
 &lt;ip&gt;0.0.0.0/0&lt;/ip&gt;
 &lt;/networks&gt;
 &lt;profile&gt;default&lt;/profile&gt;
 &lt;quota&gt;default&lt;/quota&gt;
 &lt;databases&gt;
 &lt;logs&gt;
 &lt;data&gt;
 &lt;filter&gt;role = 'test'&lt;/filter&gt;
&lt;/data&gt;
 &lt;/logs&gt;
 &lt;/databases&gt;
 &lt;/test&gt;
</code></pre>
<p>И теперь попробуем от его имени посмотреть данные в таблице logs.data:</p>
<pre><code>root@ch1:/etc/clickhouse-server# clickhouse-client -u test
ch1.ru-central1.internal :) use logs;
ch1.ru-central1.internal :) select * from data;
┌──────────────────ev─┬─a─┬─role─┐
│ 2021-03-09 12:02:00 │ 3 │ test │
└─────────────────────┴───┴──────┘
1 rows in set. Elapsed: 0.003 sec.
ch1.ru-central1.internal :)
</code></pre>
<p>Отлично! Кликхаус выдал нам только одну строку, которая соответствует нашему условию!</p>
<h3><strong>Полезные ссылки:</strong></h3>
<ul>
<li><a href="https://clickhouse.tech/docs/ru/operations/configuration-files/">https://clickhouse.tech/docs/ru/operations/configuration-files/</a></li>
<li><a href="https://clickhouse.tech/docs/ru/operations/settings/settings-users/">https://clickhouse.tech/docs/ru/operations/settings/settings-users/</a></li>
</ul>
</div>
<div>
<div>
</div>
</div>
<br />
</div>
