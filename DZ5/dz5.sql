USE lesson_4;
/*
1. Создайте представление, в которое попадет информация о пользователях (имя, фамилия, город и пол), которые не старше 20 лет.
2. Найдите кол-во, отправленных сообщений каждым пользователем и выведите ранжированный список пользователь, 
	указав указать имя и фамилию пользователя, количество отправленных сообщений и место в рейтинге (первое место у пользователя с максимальным количеством сообщений) . (используйте DENSE_RANK)
3. Выберите все сообщения, отсортируйте сообщения по возрастанию даты отправления (created_at) и найдите разницу дат отправления между соседними сообщениями, 
	получившегося списка. (используйте LEAD или LAG)
*/
-- 1. Создайте представление, в которое попадет информация о пользователях (имя, фамилия, город и пол), которые не старше 20 лет.
CREATE OR REPLACE VIEW v_users AS 
SELECT 
	firstname, lastname, hometown, gender
FROM users u
INNER JOIN profiles p ON p.user_id = u.id
WHERE SUBDATE(CURDATE(), INTERVAL 20 YEAR) < p.birthday;

SELECT * FROM v_users; 

-- 2. Найдите кол-во, отправленных сообщений каждым пользователем и выведите ранжированный список пользователь, 
-- указав указать имя и фамилию пользователя, количество отправленных сообщений и место в рейтинге 
-- (первое место у пользователя с максимальным количеством сообщений) . (используйте DENSE_RANK)
SELECT 
	u.firstname, 
	u.lastname,
	COUNT(m.id) AS count_message,
	DENSE_RANK() OVER(ORDER BY COUNT(m.id) DESC) AS rank_user 
FROM users u
LEFT JOIN messages m ON u.id = m.from_user_id
GROUP BY u.firstname, u.lastname;

-- 3. Выберите все сообщения, отсортируйте сообщения по возрастанию даты отправления (created_at) 
-- и найдите разницу дат отправления между соседними сообщениями, 
-- получившегося списка. (используйте LEAD или LAG)
SELECT 
	id, 
	from_user_id, 
	to_user_id, body, 
	created_at, 
	TIMEDIFF(LEAD(created_at) OVER(ORDER BY created_at), created_at) as diff
FROM messages 
ORDER BY created_at;