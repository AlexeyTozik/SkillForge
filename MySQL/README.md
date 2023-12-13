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
