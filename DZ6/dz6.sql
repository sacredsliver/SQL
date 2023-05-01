USE lesson_4;

/*Задача1. Создайте таблицу users_old, аналогичную таблице users. Создайте процедуру,
с помощью которой можно переместить любого (одного) пользователя из таблицы users в таблицу users_old. 
(использование транзакции с выбором commit или rollback – обязательно).*/

DROP TABLE IF EXISTS users_old;

CREATE TABLE users_old (
  id INT AUTO_INCREMENT PRIMARY KEY, 
  firstname VARCHAR(50),
  lastname VARCHAR(50),
  email VARCHAR(120)
  ) ENGINE ARCHIVE;

DROP PROCEDURE IF EXISTS users_old;
delimiter //
CREATE PROCEDURE users_old (
  firstname VARCHAR (50),
  id INT,
  lastname VARCHAR (50),
  email VARCHAR(120)
)
BEGIN
	INSERT INTO users_old (append_firstname, pk_id, append_lastname, append_emai) VALUES (firstname, id, lastname, email);
END //
delimiter ;


START TRANSACTION;

SELECT * FROM users WHERE id = 2;

INSERT INTO users_old  SELECT * FROM users WHERE id = 2;

DELETE FROM users WHERE id = 2; -- Если переместить, то удаляем из таблицы

COMMIT;


/*Задача2. Создайте хранимую функцию hello(), которая будет возвращать приветствие, 
 в зависимости от текущего времени суток. 
 С 6:00 до 12:00  функция  должна возвращать фразу "Доброе утро", 
 с 12:00 до 18:00  функция должна возвращать фразу "Добрый день",
 с 18:00 до 00:00 — "Добрый вечер",
 с 00:00 до 6:00 — "Доброй ночи".*/

USE lesson_4;

drop  function  if  exists hello;

DELIMITER //

create function hello()
returns TEXT
begin
declare hour int
set hour = hour (now())
case
	when hour between 0 and 5 then 
    return  'Доброй ночи'
    when hour between 6 and 11 then 
    return  'Доброе утро'
    when hour between 12 and 17 then 
    return  'Добрый день'
    when hour between 18 and 23 then 
    return  'Добрый вечер'
end case
end //
DELIMITER ;
select now(); hello()// 

/*Задача3. (по желанию)* Создайте таблицу logs типа Archive.
Пусть при каждом создании записи в таблицах users, communities и messages
в таблицу logs помещается время и дата создания записи, название таблицы, 
идентификатор первичного ключа.*/

DROP TABLE IF EXISTS logs;

CREATE TABLE logs (
  append_dt DATETIME DEFAULT CURRENT_TIMESTAMP,
  append_tn VARCHAR (255),
  pk_id INT UNSIGNED NOT NULL,
  append_name VARCHAR (255)
  ) ENGINE ARCHIVE;

DROP PROCEDURE IF EXISTS append_logs;
delimiter //
CREATE PROCEDURE append_logs (
  tn VARCHAR (255),
  id INT,
  an VARCHAR (255)
)
BEGIN
	INSERT INTO logs (append_tn, pk_id, append_name) VALUES (tn, id, an);
END //
delimiter ;

DROP TRIGGER IF EXISTS log_appending_from_communities;
delimiter $$
CREATE TRIGGER log_appending_from_communities
AFTER INSERT ON communities
FOR EACH ROW
BEGIN
	CALL append_logs('communities', NEW.id, NEW.name);
END $$
delimiter ;

DROP TRIGGER IF EXISTS log_appending_from_users;
delimiter //
CREATE TRIGGER log_appending_from_users
AFTER INSERT ON users
FOR EACH ROW
BEGIN
	CALL append_logs('users', NEW.id, NEW.name);
END //
delimiter ;

DROP TRIGGER IF EXISTS log_appending_from_messages;
delimiter //
CREATE TRIGGER log_appending_from_messages
AFTER INSERT ON messages
FOR EACH ROW
BEGIN
	CALL append_logs('messages', NEW.id, NEW.name);
END //
delimiter ;
