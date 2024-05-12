<div>
<h1>CLCK 07: Подключение SSL</h1>
<div>
<h3><strong>Описание:</strong></h3>
<p>Среди настроек безопасности ClickHouse имеет хорошую поддержку шифрования данных с помощью SSL. Его подключение и настройку мы рассмотрим в этом задании. Но перед этим хотелось бы рассказать в каких случаях следуюет использовать tls подключение. На самом деле любой безопасник ответит - что использовать его необходимо всегда. Я же попробую немного дополнить данный ответ и сказать, что в целом если вы доверяете сети по которой передаются данные - то использовать tls большого смысла нет. Это добавит дополнительных расходов на cpu, тем самым нагрузив дополнительно сервер. Но если же вы берете выделенные железки на хецнере и обмениваетесь трафиком с кликхаусом по внешним адресам, то я бы точно вам посоветовал включить TLS для защиты вашего трафика.</p>
<p>Итак, для включения шифрования нам нужно сделать следующее:</p>
<ol>
<li>Заставить кликхаус слушать на всех tls secured портах</li>
<li>Подключить сертификаты и параметры Диффи-Хеллмана для включения шифрования на стороне сервера.</li>
<li>Убедиться, что защищенный клиент работает.</li>
</ol>
<h4>Конфигурация портов</h4>
<p>Для того чтобы включить защищенное соединение, нам необходимо раскомментировать нужные строки в конфигурации <code>config.xml</code>.</p>
<pre><code>&lt;yandex&gt;
 &lt;https_port&gt;8443&lt;/https_port&gt;
 &lt;tcp_port_secure&gt;9440&lt;/tcp_port_secure&gt;
 &lt;!--
 &lt;http_port&gt;8123&lt;/http_port&gt;
 &lt;tcp_port&gt;9000&lt;/tcp_port&gt;
 --&gt;
&lt;/yandex&gt;
</code></pre>
<p>Также хорошей практикой является комментирование портов, которые не используются. Так мы и сделали, включив <code>HTTPS</code>, и <code>TLS</code> поверх <code>TCP</code>.</p>
<h4>Подключение сертификатов</h4>
<p>Для подключения SSL нам нужны валидный X509 сертификат и приватный ключ, который можно сгенерировать несколькими способами, используя тот же <code>openssl</code> или <code>letsencrypt</code>. Главный вопрос в том хотите ли вы использовать самодподписанный сертификат или публичный. В нашем примере мы остановимся на самоподписанном сертификате. Сгенерировать его можно одной командой:</p>
<pre><code>openssl req -subj "/CN=localhost" -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout /etc/clickhouse-server/server.key -out /etc/clickhouse-server/server.crt
</code></pre>
<p>Главное задать common name равным адресу сервера, к которому мы будем подключаться. Мы указали <code>CN=localhost</code> при создании - то есть клиент будет проверять имя сервера к которому он подключился, сравнивая его с common name равное localhost.</p>
<p>Дополнительно мы будем использовать параметры Диффи-Хеллмана (<code>dhParamsFile</code>), которые генерируются следующей командой:</p>
<pre><code>openssl dhparam -out /etc/clickhouse-server/dhparam.pem 4096
</code></pre>
<p>Данная операция будем выполняться некоторое время, но запустить ее нужно только один раз.</p>
<p>Итак, все необходимое подготовили - теперь лезем в настройки кликхаус и добавляем следующие опции:</p>
<pre><code>&lt;yandex&gt;
 &lt;openSSL&gt;
 &lt;server&gt;
 &lt;certificateFile&gt;/etc/clickhouse-server/server.crt&lt;/certificateFile
 &lt;privateKeyFile&gt;/etc/clickhouse-server/server.key&lt;/privateKeyFile&gt;
 &lt;dhParamsFile&gt;/etc/clickhouse-server/dhparam.pem&lt;/dhParamsFile&gt;
 &lt;verificationMode&gt;none&lt;/verificationMode&gt;
 &lt;loadDefaultCAFile&gt;true&lt;/loadDefaultCAFile&gt;
 &lt;cacheSessions&gt;true&lt;/cacheSessions&gt;
 &lt;disableProtocols&gt;sslv2,sslv3&lt;/disableProtocols&gt;
 &lt;preferServerCiphers&gt;true&lt;/preferServerCiphers&gt;
 &lt;/server&gt;
 &lt;/openSSL&gt;
&lt;/yandex&gt;
</code></pre>
<p>Для удобства мы поместили их рядом с конфигурацией сервера в директории <code>/etc/clickhouse-server/</code>. Также следует позаботиться, чтобы ClickHouse имел права на доступ ко всем 3-м файлам. Теперь пройдемся по параметрам.</p>
<p>Путь к файлу с приватным ключом сертификата. Файл может содержать и ключ, и сертификат одновременно.</p>
<p>Путь к файлу с сертификатом Х509, может не указываться, если <code>privateKeyFile</code> уже содержит сертификат.</p>
<p>Путь к файлу с параметрами Диффи-Хеллмана. Этот параметр не обязателен и может быть закомментирован, хотя делать этого настоятельно не рекомендуется.</p>
<p>Параметр, который отвечает за способ проверки сертификата. Допустимые значения &mdash; <code>none</code>, <code>relaxed</code>, <code>strict</code>, <code>once</code>. Рассмотрим, чем они отличаются:</p>
<ul>
<li>none &mdash; не запрашивает сертификат для проверки;</li>
<li>relaxed &mdash; запрашивает сертификат для проверки, если при процессе верификации произошла ошибка, то TLS/SSL соединение разрывается с сообщением об ошибке;</li>
<li>strict &mdash; метод очень похож на relaxed, но если сертификат не возвращается, то соединение также разрывается и будет показано сообщение об ошибке;</li>
<li>once &mdash; сертификат на проверку запрашивается и верифицируется один раз при подключении. При переподключении сертификат дополнительно не запрашивается.</li>
</ul>
<p>Определяет, будут ли использоваться встроенные CA-сертификаты для OpenSSL. Допустимые значения &mdash; <code>true</code>, <code>false</code>.</p>
<p>Определяет, будет ли включено кеширование TLS сессии. Допустимые значения &mdash; <code>true</code>, <code>false</code>.</p>
<p>В этом параметре перечислены протоколы, которые не будут использоваться.</p>
<p>Предпочтение серверных шифров на клиенте. Допустимые значения &mdash; <code>true</code>, <code>false</code>.</p>
<p>В данном примере рассмотрены не все параметры, а только самые основные. Дополнительные опции вы можете найти <a href="https://clickhouse.tech/docs/ru/operations/server-configuration-parameters/settings/#server_configuration_parameters-openssl">здесь</a>.</p>
<h4>Проверка клиента</h4>
<p>Теперь, когда мы закончили с конфигурацией SSL, применяем конфигурацию перезапуском сервиса. Чтобы убедиться, что все работает корректно, можно проверить логи, статус сервиса и доступность защищенных портов, которые мы открыли.</p>
<p>Последним пунктом нужно проверить, успешно ли подключается ClickHouse клиент к серверу.</p>
<pre><code># chown clickhouse:clickhouse dhparam.pem server.*
# chmod 0400 server.key
# clickhouse-client --secure
ClickHouse client version 21.2.5.5 (official build).
Connecting to localhost:9440 as user default.
Code: 210. DB::NetException: SSL Exception: error:1000007d:SSL routines:OPENSSL_internal:CERTIFICATE_VERIFY_FAILED (localhost:9440)
</code></pre>
<p>А вот и ошибочка! Происходит это потому что наш клиент не может проверить валидность ssl сертификата, который отдает нам сервер. Исправить это можно двумя путями - либо подложить клиенту в /etc/clickhouse-client/config.xml CA сертификат, который подписал сертификат сервера. Или же в том же файле можно отключить проверку сертификта на клиенте:</p>
<pre><code> &lt;verificationMode&gt;none&lt;/verificationMode&gt;
</code></pre>
<p>Теперь можем попробовать подключиться еще раз:</p>
<pre><code># clickhouse-client --secure
ClickHouse client version 21.2.5.5 (official build).
Connecting to localhost:9440 as user default.
Connected to ClickHouse server version 21.2.5 revision 54447.
ch1.ru-central1.internal :)
</code></pre>
<p>Подключение прошло успешно!</p>
<h3><strong>Полезные ссылки:</strong></h3>
<ul>
<li><a href="https://clickhouse.tech/docs/ru/operations/server-configuration-parameters/settings/#server_configuration_parameters-openssl">https://clickhouse.tech/docs/ru/operations/server-configuration-parameters/settings/#server_configuration_parameters-openssl</a></li>
</ul>
</div>
</div>
