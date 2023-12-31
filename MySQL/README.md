### Management commands

|||
|---|---|
|sudo apt-get update<br>sudo apt-get install mysql-server|Установка MySQL под Ubuntu|
|mysql -u user -p|Подключение к MySQL с указанием имени пользователя и запросом пароля|
|CREATE DATABASE dbname;|Создание новой базы данных|
|USE dbname;|Выбор активной базы данных для работы|
|CREATE USER 'user'@'localhost|Создание нового пользователя с указанием имени и пароля|
|GRANT ALL PRIVILEGES ON dbname.* TO 'user'@'localhost';|Предоставление полных прав новому пользователю для работы с базой данных|
|FLUSH PRIVILEGES;|Обновление привилегий после изменений в системе привилегий MySQL|
|CREATE TABLE tablename (column1 datatype, column2 datatype, ...)|Создание новой таблицы с указанием столбцов и их типов данных|
|INSERT INTO tablename (column1, column2, ...) VALUES (value1, value2, ...);`|Вставка новых данных в таблицу|
|SELECT * FROM tablename;|Получение всех данных из таблицы|
|UPDATE tablename SET column1 = new_value WHERE condition;|Обновление данных в таблице с заданным условием|
|DELETE FROM tablename WHERE condition;|Удаление данных из таблицы с заданным условием|
|SHOW DATABASES;|Просмотр списка всех баз данных|
|SHOW TABLES;|Просмотр списка таблиц в текущей базе данных|
|SELECT user FROM mysql.user;|Получение списка пользователей в MySQL|
|mysqldump -u user -p dbname > filename.sql|Экспорт данных из базы данных в файл|
|mysql -u user -p dbname < filename.sql|Импорт данных из файла в базу данных|


### Select commands

||||
|---|---|---|
|DISTINCT|Исключает повторяющиеся значения из результата запроса|После SELECT|
|COUNT(column)|	Возвращает количество строк в столбце.|	После SELECT|
|SUM(column)|	Суммирует значения в столбце.|	После SELECT|
|AVG(column)|	Возвращает среднее значение в столбце.|	После SELECT|
|MIN(column)|	Возвращает минимальное значение в столбце.|	После SELECT|
|MAX(column)|	Возвращает максимальное значение в столбце.|После SELECT|
|GROUP_CONCAT(column)|	Конкатенирует строки в столбце для каждой группы.|	После SELECT и GROUP BY|
|CASE WHEN condition THEN result ELSE else_result END|Условное выражение, выполняет различные действия в зависимости от условий.|После SELECT|
|WHERE condition|Условие для фильтрации результатов. Применяется после указания таблицы (FROM) и перед другими дополнительными условиями.|После FROM|
|AND|	Логическое "И", комбинирует условия.|	После WHERE и между условиями|
|OR|	Логическое "ИЛИ", комбинирует условия.|	После WHERE и между условиями|
|IN (value1, value2, ...)|	Проверяет, есть ли значение в списке.|	После WHERE и перед условием|
|NOT IN (value1, value2, ...)|	Проверяет, отсутствует ли значение в списке.|	После WHERE и перед условием|
|BETWEEN min AND max|	Проверяет, находится ли значение в заданном диапазоне.|	После WHERE и перед условием|
|NOT BETWEEN min AND max|	Проверяет, находится ли значение вне заданного диапазона.|	После WHERE и перед условием|
|LIKE pattern|	Поиск с использованием шаблона.|После WHERE и перед условием|
|NOT LIKE pattern|	Поиск с использованием отрицательного шаблона.|	После WHERE и перед условием|
|IS NULL|	Проверка, равно ли значение NULL.|	После WHERE и перед условием|
|IS NOT NULL|	Проверка, не равно ли значение NULL.|	После WHERE и перед условием|
|ORDER BY column [ASC/DESC]|Сортирует результаты по указанному столбцу. Может быть указано в порядке возрастания (ASC, по умолчанию) или убывания (DESC).|После FROM, WHERE, и GROUP BY, но перед LIMIT и OFFSET|
|ORDER BY RAND()|	Случайная сортировка результатов.|	После ORDER BY|
|LIMIT n|Ограничивает количество возвращаемых строк до n.|После ORDER BY|
|OFFSET n|	Пропускает указанное количество строк. Полезно для пагинации результатов.|	После LIMIT|
|GROUP BY column|	Группирует строки по указанному столбцу.|	После FROM и WHERE|
HAVING condition|	Условие для фильтрации результатов после применения GROUP BY.|	После GROUP BY|
|JOIN table ON condition|	Объединение таблицы с другой таблицей с использованием указанного условия.|	После FROM и WHERE|
|LEFT JOIN|	Левое внешнее объединение таблиц.|	После FROM и WHERE|
|RIGHT JOIN|	Правое внешнее объединение таблиц.|	После FROM и WHERE|
|INNER JOIN|	Внутреннее объединение таблиц.|	После FROM и WHERE|
|FULL OUTER JOIN|	Полное внешнее объединение таблиц.|После FROM и WHERE|
|UNION|	Объединяет результаты двух или более запросов, исключая дубликаты.|После каждого SELECT|
|UNION ALL|	Объединяет результаты запросов, включая дубликаты.|После каждого SELECT|
