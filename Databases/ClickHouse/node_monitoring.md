<div>
<h1>CLCK 08: Мониторинг ноды ClickHouse</h1>
<div>
<h3><strong>Описание:</strong></h3>
<p>В предыдущих практикумах мы работали над установкой и настройкой ClickHouse ноды, но как отслеживать её состояние и работоспособность? По факту мы научились только сохранять серверные логи, а так же профилировать и трейсить сами запросы. Но нам точно необходимо видеть основные метрики в графане для отслеживания состояния сервера.</p>
<p>И для этого ClickHouse поддерживает сбор метрик о том, как сервер использует вычислительные ресурсы, общую статистику обработки запросов, а также имеет настройки для интеграцией с такими системами мониторинга, как Prometheus или Graphite.</p>
<h4>Метрики</h4>
<p>ClickHouse хранит свои метрики в системных таблицах, которые и будут использоваться системами мониторинга. Их можно посмотреть в следующих системных таблицах:</p>
<ul>
<li>
<p><code>system.metrics</code> &mdash; отвечает за актуальные метрики, которые имеют текущее значение или могут быть рассчитаны мгновенно.</p>
<pre><code class="language-sql hljs">ch1 :) <span class="hljs-keyword">SELECT</span> * <span class="hljs-keyword">FROM</span> system.metrics <span class="hljs-keyword">LIMIT</span> <span class="hljs-number">5</span>;

<span class="hljs-keyword">SELECT</span> \*
<span class="hljs-keyword">FROM</span> system.metrics
<span class="hljs-keyword">LIMIT</span> <span class="hljs-number">5</span>

<p>Пример:</p>

┌─metric──────────┬─<span class="hljs-keyword">value</span>─┬─description─────────────────────────────────────┐
│ <span class="hljs-keyword">Query</span> │ <span class="hljs-number">1</span> │ <span class="hljs-built_in">Number</span> <span class="hljs-keyword">of</span> executing queries │
│ <span class="hljs-keyword">Merge</span> │ <span class="hljs-number">0</span> │ <span class="hljs-built_in">Number</span> <span class="hljs-keyword">of</span> executing background merges │
│ PartMutation │ <span class="hljs-number">0</span> │ <span class="hljs-built_in">Number</span> <span class="hljs-keyword">of</span> mutations (<span class="hljs-keyword">ALTER</span> <span class="hljs-keyword">DELETE</span>/<span class="hljs-keyword">UPDATE</span>) │
│ ReplicatedFetch │ <span class="hljs-number">0</span> │ <span class="hljs-built_in">Number</span> <span class="hljs-keyword">of</span> <span class="hljs-keyword">data</span> parts being fetched <span class="hljs-keyword">from</span> replica │
│ ReplicatedSend │ <span class="hljs-number">0</span> │ <span class="hljs-built_in">Number</span> <span class="hljs-keyword">of</span> <span class="hljs-keyword">data</span> parts being sent <span class="hljs-keyword">to</span> replicas │
└─────────────────┴───────┴─────────────────────────────────────────────────┘

<span class="hljs-number">5</span> <span class="hljs-keyword">rows</span> <span class="hljs-keyword">in</span> set. Elapsed: <span class="hljs-number">0.003</span> sec.
</code></pre>

</li>
<li>
<p><code>system.events</code> — содержит информацию о количестве событий, произошедших в системе.</p>
<p>Пример:</p>
<pre><code class="language-sql hljs">ch1 :) <span class="hljs-keyword">SELECT</span> * <span class="hljs-keyword">FROM</span> system.events <span class="hljs-keyword">LIMIT</span> <span class="hljs-number">5</span>;

<span class="hljs-keyword">SELECT</span> \*
<span class="hljs-keyword">FROM</span> system.events
<span class="hljs-keyword">LIMIT</span> <span class="hljs-number">5</span>

┌─<span class="hljs-keyword">event</span>───────────────────────┬───<span class="hljs-keyword">value</span>─┬─description──────────────────────────────────────┐
│ SelectQuery │ <span class="hljs-number">65</span> │ Same <span class="hljs-keyword">as</span> <span class="hljs-keyword">Query</span>, but <span class="hljs-keyword">only</span> <span class="hljs-keyword">for</span> <span class="hljs-keyword">SELECT</span> queries. │
│ FailedQuery │ <span class="hljs-number">1</span> │ <span class="hljs-built_in">Number</span> <span class="hljs-keyword">of</span> <span class="hljs-keyword">failed</span> queries. │
│ QueryTimeMicroseconds │ <span class="hljs-number">388037</span> │ Total <span class="hljs-built_in">time</span> <span class="hljs-keyword">of</span> <span class="hljs-keyword">all</span> queries. │
│ SelectQueryTimeMicroseconds │ <span class="hljs-number">106115</span> │ Total <span class="hljs-built_in">time</span> <span class="hljs-keyword">of</span> <span class="hljs-keyword">SELECT</span> queries. │
│ FileOpen │ <span class="hljs-number">2570879</span> │ <span class="hljs-built_in">Number</span> <span class="hljs-keyword">of</span> files opened. │
│ Seek │ <span class="hljs-number">597120</span> │ <span class="hljs-built_in">Number</span> <span class="hljs-keyword">of</span> times the <span class="hljs-string">'lseek'</span> <span class="hljs-keyword">function</span> was called. │
└─────────────────────────────┴─────────┴──────────────────────────────────────────────────┘

<span class="hljs-number">5</span> <span class="hljs-keyword">rows</span> <span class="hljs-keyword">in</span> set. Elapsed: <span class="hljs-number">0.004</span> sec.
</code></pre>

</li>
<li>
<p><code>system.asynchronous_metrics</code> — содержит метрики, которые обновляются и вычисляются в фоновом режиме раз в минуту.</p>
<p>Пример:</p>
<pre><code class="language-sql hljs">ch1 :) <span class="hljs-keyword">SELECT</span> * <span class="hljs-keyword">FROM</span> system.asynchronous_metrics <span class="hljs-keyword">LIMIT</span> <span class="hljs-number">5</span>;

<span class="hljs-keyword">SELECT</span> \*
<span class="hljs-keyword">FROM</span> system.asynchronous_metrics
<span class="hljs-keyword">LIMIT</span> <span class="hljs-number">5</span>

┌─metric───────────────────────────────────┬────<span class="hljs-keyword">value</span>─┐
│ CPUFrequencyMHz_0 │ <span class="hljs-number">1799.998</span> │
│ jemalloc.arenas.all.pmuzzy │ <span class="hljs-number">4273</span> │
│ jemalloc.arenas.all.pdirty │ <span class="hljs-number">931</span> │
│ jemalloc.background_thread.run_intervals │ <span class="hljs-number">0</span> │
│ jemalloc.background_thread.num_runs │ <span class="hljs-number">0</span> │
└──────────────────────────────────────────┴──────────┘

<span class="hljs-number">5</span> <span class="hljs-keyword">rows</span> <span class="hljs-keyword">in</span> set. Elapsed: <span class="hljs-number">0.003</span> sec.
</code></pre>

</li>
</ul>
<p>Кстати, настраиваются они в стандартом конфигурационном файле сервера и имеют следующий вид:</p>
<pre><code> &lt;!-- Metric log contains rows with current values of ProfileEvents, CurrentMetrics collected with "collect_interval_milliseconds" interval. --&gt;
 &lt;metric_log&gt;
 &lt;database&gt;system&lt;/database&gt;
 &lt;table&gt;metric_log&lt;/table&gt;
 &lt;flush_interval_milliseconds&gt;7500&lt;/flush_interval_milliseconds&gt;
 &lt;collect_interval_milliseconds&gt;1000&lt;/collect_interval_milliseconds&gt;
 &lt;/metric_log&gt;
 &lt;!--
 Asynchronous metric log contains values of metrics from
 system.asynchronous_metrics.
 --&gt;
 &lt;asynchronous_metric_log&gt;
 &lt;database&gt;system&lt;/database&gt;
 &lt;table&gt;asynchronous_metric_log&lt;/table&gt;
 &lt;!--
 Asynchronous metrics are updated once a minute, so there is
 no need to flush more often.
 --&gt;
 &lt;flush_interval_milliseconds&gt;60000&lt;/flush_interval_milliseconds&gt;
 &lt;/asynchronous_metric_log&gt;
</code></pre>
<p>Здесь так же указывается база и таблица, в которую необходимо записывать все серверные метрики.</p>
<h4>Использование систем мониторинга</h4>
<p>ClickHouse поддерживает экспорт метрик в такие системы мониторинга, как Graphite и Prometheus. В их параметрах флагами <code>true/false</code> можно задать метрики для экспорта:</p>
<pre><code>&lt;yandex&gt;
&lt;graphite&gt;
 &lt;host&gt;localhost&lt;/host&gt;
 &lt;port&gt;42000&lt;/port&gt;
 &lt;timeout&gt;0.1&lt;/timeout&gt;
 &lt;interval&gt;1&lt;/interval&gt;
 &lt;root_path&gt;one_sec&lt;/root_path&gt;
 &lt;metrics&gt;true&lt;/metrics&gt;
 &lt;events&gt;true&lt;/events&gt;
 &lt;events_cumulative&gt;false&lt;/events_cumulative&gt;
 &lt;asynchronous_metrics&gt;false&lt;/asynchronous_metrics&gt;
&lt;/graphite&gt;
&lt;prometheus&gt;
 &lt;endpoint&gt;/metrics&lt;/endpoint&gt;
 &lt;port&gt;9363&lt;/port&gt;
 &lt;metrics&gt;true&lt;/metrics&gt;
 &lt;events&gt;true&lt;/events&gt;
 &lt;asynchronous_metrics&gt;true&lt;/asynchronous_metrics&gt;
 &lt;status_info&gt;true&lt;/status_info&gt;
&lt;/prometheus&gt;
&lt;/yandex&gt;
</code></pre>
<p>В настройках Graphite:</p>
<ul>
<li><code>host/port</code> &mdash; хост и порт сервера Graphite;</li>
<li><code>timeout</code> &mdash; тайм-аут отправки метрик в секундах;</li>
<li><code>interval</code> &mdash; период отправки метрик в секундах;</li>
<li><code>root_path</code> &mdash; префикс для ключей.</li>
</ul>
<p>В настройках Prometheus:</p>
<ul>
<li><code>endpoint</code> &mdash; путь, по которому будет идти экспорт метрик по HTTP-протоколу. Должен начинаться с <code>/</code>.</li>
<li><code>port</code> - порт, по которому будет доступен endpoint.</li>
</ul>
<p>На саммом деле для их включения всего лишь достаточно раскомментировать соответствующую секцию в конфигурационном файле - все настройки по умолчанию вполне валидны для продакшен среды.</p>
<h4>Проверка доступности сервера</h4>
<p>Как мы уже обсуждали ранее - можно проверить доступность ClickHouse сервера отправив ему <code>GET</code> запрос <code>/ping</code> на <code>HTTP API</code>. Если сервер доступен - он ответит <code>200 OK</code>.</p>
<h4>Дашбоард в графане</h4>
<p>К сожалению, в данном практикуме мы не разбираем графану от слова совсем. Но если она у вас установлена и настроена, то вы можете найти готовые дашбоарды на grafana.net и импортировать готовый дашбоард, например <a href="https://grafana.com/grafana/dashboards/882">такой</a>. Схема будет выглядеть достаточно просто - включаем прометеус мониторинг в кликхаусе, настраиваем прометеус на сбор метрик с кликхауса и импортируем дашбоард в графану. Все! Можно наслаждаться графиками :)</p>
<h3><strong>Полезные ссылки:</strong></h3>
<ul>
<li><a href="https://clickhouse.tech/docs/ru/operations/monitoring/">https://clickhouse.tech/docs/ru/operations/monitoring/</a></li>
</ul>
</div>
<div>
<div>
</div>
</div>
</div>
