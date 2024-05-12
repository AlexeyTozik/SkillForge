<div>
<h1>CLCK 06: Настройка квот</h1>
<div>
<h3><strong>Описание:</strong></h3>
<p>Итак, сегодня мы поговорим про квоты в кликхаусе - в отличие от профилей в read write режиме они позволяют ограничивать потребление ресурсов пользователями за определенный промежуток времени. По сути они позволяют сказать какое кол-во ресурсов может быть использовано пользователем. Задаются они в конфиг файле <code>users.xml</code>. Пример конфигурации квот вы можете увидеть ниже:</p>
<pre><code>&lt;yandex&gt;
&lt;quotas&gt;
 &lt;default&gt;
 &lt;interval&gt;
 &lt;duration&gt;3600&lt;/duration&gt;
 &lt;queries&gt;0&lt;/queries&gt;
 &lt;errors&gt;0&lt;/errors&gt;
 &lt;result_rows&gt;0&lt;/result_rows&gt;
 &lt;read_rows&gt;0&lt;/read_rows&gt;
 &lt;execution_time&gt;0&lt;/execution_time&gt;
 &lt;/interval&gt;
 &lt;/default&gt;
&lt;test&gt;
&lt;interval&gt;
 &lt;duration&gt;120&lt;/duration&gt;
 &lt;queries&gt;3&lt;/queries&gt;
 &lt;errors&gt;2&lt;/errors&gt;
 &lt;result_rows&gt;10000&lt;/result_rows&gt;
 &lt;read_rows&gt;100000000000&lt;/read_rows&gt;
 &lt;execution_time&gt;900&lt;/execution_time&gt;
 &lt;/interval&gt;
&lt;interval&gt;
 &lt;duration&gt;86400&lt;/duration&gt;
 &lt;queries&gt;1000&lt;/queries&gt;
 &lt;errors&gt;100&lt;/errors&gt;
 &lt;result_rows&gt;1000000000&lt;/result_rows&gt;
 &lt;read_rows&gt;100000000000&lt;/read_rows&gt;
 &lt;execution_time&gt;10000&lt;/execution_time&gt;
 &lt;/interval&gt;
&lt;/test&gt;
&lt;/quotas&gt;
&lt;/yandex&gt;
</code></pre>
<p>Мы создали отдельную квоту <code>test</code>, которую можем использовать в настройках пользователей. Квота может содержать в себе любое множество интервалов времени (<code>&lt;interval&gt;</code>), каждый из которых имеет свою конфигурацию. Некоторые значения параметров в примере равны <code>0</code>, в таком случае на данный параметр не накладываются никакие квоты.</p>
<p>Время (в секундах), через которое будут сброшены все значения счетчиков интервала.</p>
<p>Общее количество запросов.</p>
<p>Количество запросов, которые при выполнении выдали ошибку.</p>
<h4>&lt;result_rows&gt;</h4>
<p>Количество строк, которые были отданы при выполнении запросов.</p>
<h4>&lt;read_rows&gt;</h4>
<p>Количество строк, которые доступны для чтения при выполнении запросов.</p>
<h4>&lt;execution_time&gt;</h4>
<p>Суммарное время выполнения всех запросов.</p>
<p>При достижении лимита по любому интервалу будет отображаться информация о том, какое значение превышено и когда начнется следующий интервал.</p>
<p>Также просмотреть на значения квот в реальном времени можно в таких системных таблицах, как <code>system.quotas</code>, <code>system.quotas_usage</code>, <code>system.quota_limits</code>.</p>
<p>Стоить заметить, что при распределенном запросе все значения квот подсчитываются только на сервере, который инициировал запрос. На каждом сервере ClickHouse счетчики квот для пользователей отдельные. Также счетчики сбрасываются при каждом перезапуске сервера.</p>
<p>Давайте попробуем повторить эксперимент с пользователем test, указав ему данную квоту в конфигурации, а так же сменив его профиль на default - чтобы он не запрещал менять нам настройки профилей:</p>
<pre><code>ch1.ru-central1.internal :) select * from logs.data;
0 rows in set. Elapsed: 0.002 sec.
Received exception from server (version 21.2.5):
Code: 201. DB::Exception: Received from localhost:9000. DB::Exception: Quota for user `test` for 120s has been exceeded: queries = 4/3. Interval will end at 2021-03-09 15:42:00. Name of quota template: `test`.
</code></pre>
<p>В данном случае мы пытались быстро выполнить несколько запросов и превысили квоту максимального количества запросов для пользователя. И кликхаус сообщил нам, что мы можем повторить наш запрос через 120 секунд.</p>
<p>Таким образом вы можете установить лимиты по использованию ресурсов для различных пользователей на основе квот.</p>
<h3><strong>Полезные ссылки:</strong></h3>
<ul>
<li><a href="https://clickhouse.tech/docs/ru/operations/configuration-files/">https://clickhouse.tech/docs/ru/operations/configuration-files/</a></li>
<li><a href="https://clickhouse.tech/docs/ru/operations/quotas/">https://clickhouse.tech/docs/ru/operations/quotas/</a></li>
</ul>
</div>
<br />
</div>
