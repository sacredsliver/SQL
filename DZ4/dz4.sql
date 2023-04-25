USE lesson_4;

-- Подсчитать общее количество лайков, которые получили пользователи младше 12 лет.
SELECT 
	COUNT(l.id) as like_count
FROM users u
INNER JOIN profiles p ON p.user_id = u.id
INNER JOIN media m on m.user_id = u.id
INNER JOIN likes l ON l.media_id = m.id
WHERE p.birthday > SUBDATE(CURDATE(), INTERVAL 12 YEAR);

-- Определить кто больше поставил лайков (всего): мужчины или женщины.
SELECT
	CASE p.gender
		WHEN 'm' THEN 'men'
		WHEN 'f' THEN 'women'
	END as gender, 
	COUNT(l.id) as like_count
FROM users u
INNER JOIN profiles p ON p.user_id = u.id
INNER JOIN likes l ON l.user_id = u.id
GROUP BY gender
ORDER BY like_count DESC
LIMIT 1;

-- Вывести всех пользователей, которые не отправляли сообщения.
SELECT 
	u.firstname, u.lastname
FROM users u
LEFT JOIN messages m on m.from_user_id = u.id
WHERE m.id IS NULL;

/*
(по желанию)* Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, 
который больше всех написал ему сообщений.
*/
SELECT 
	CONCAT_WS(" ", f.firstname, f.lastname) AS full_name,
	COUNT(m.id) AS messages_count
FROM users u
INNER JOIN friend_requests r ON r.target_user_id = u.id AND r.status = "approved" 
							 OR r.initiator_user_id = u.id AND r.status = "approved" 
INNER JOIN messages m ON m.from_user_id = r.initiator_user_id AND m.to_user_id = u.id
INNER JOIN users f ON f.id = r.initiator_user_id
WHERE u.id = 1
GROUP BY full_name
ORDER BY messages_count DESC
LIMIT 1;