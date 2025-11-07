#!/bin/bash
chcp 65001

sqlite3 movies_rating.db < db_init.sql

echo "1. Найти все пары пользователей, оценивших один и тот же фильм. Устранить дубликаты, проверить отсутствие пар с самим собой. Для каждой пары должны быть указаны имена пользователей и название фильма, который они ценили. В списке оставить первые 100 записей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT DISTINCT u1.name AS 'user1', u2.name AS 'user2', m.title FROM ratings r1 JOIN ratings r2 ON r1.movie_id = r2.movie_id AND r1.user_id < r2.user_id JOIN users u1 ON r1.user_id = u1.id JOIN users u2 ON r2.user_id = u2.id JOIN movies m ON r1.movie_id = m.id LIMIT 100;"
echo " "

echo "2. Найти 10 самых старых оценок от разных пользователей, вывести названия фильмов, имена пользователей, оценку, дату отзыва в формате ГГГГ-ММ-ДД."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT m.title, u.name, r.rating, date(r.timestamp, 'unixepoch') AS date_rating FROM ratings r JOIN users u ON u.id = r.user_id JOIN movies m ON m.id = r.movie_id GROUP BY u.name ORDER BY date_rating ASC LIMIT 10;"
echo " "

echo "3. Вывести в одном списке все фильмы с максимальным средним рейтингом и все фильмы с минимальным средним рейтингом. Общий список отсортировать по году выпуска и названию фильма. В зависимости от рейтинга в колонке 'Рекомендуем' для фильмов должно быть написано 'Да' или 'Нет'."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "WITH avg_ratings AS (SELECT movie_id, AVG(rating) AS avg_rating FROM ratings GROUP BY movie_id), max_min AS (SELECT MAX(avg_rating) as max_r, MIN(avg_rating) as min_r FROM avg_ratings) SELECT m.title AS 'Название', m.year AS 'Год', ar.avg_rating AS 'Средний рейтинг', CASE WHEN ar.avg_rating = (SELECT max_r FROM max_min) THEN 'Да' ELSE 'Нет' END AS Рекомендуем FROM movies m JOIN avg_ratings ar ON m.id = ar.movie_id WHERE ar.avg_rating = (SELECT max_r FROM max_min) OR ar.avg_rating = (SELECT min_r FROM max_min) ORDER BY m.year, m.title;"
echo " "

echo "4. Вычислить количество оценок и среднюю оценку, которую дали фильмам пользователи-мужчины в период с 2011 по 2014 год."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT COUNT(*) AS 'Количество оценок', ROUND(AVG(r.rating), 3) AS 'Средняя оценка' FROM ratings r JOIN users u ON r.user_id = u.id WHERE u.gender = 'male' AND strftime('%Y', datetime(r.timestamp, 'unixepoch')) BETWEEN '2011' AND '2014';"
echo " "

echo "5. Составить список фильмов с указанием средней оценки и количества пользователей, которые их оценили. Полученный список отсортировать по году выпуска и названиям фильмов. В списке оставить первые 20 записей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT m.title, m.year, AVG(r.rating) AS 'Средняя оценка', COUNT(DISTINCT r.user_id) AS 'Количество пользователей' FROM movies m JOIN ratings r ON m.id = r.movie_id GROUP BY m.id ORDER BY m.year, m.title LIMIT 20;"
echo " "

echo "6. Определить самый распространенный жанр фильма и количество фильмов в этом жанре. Отдельную таблицу для жанров не использовать, жанры нужно извлекать из таблицы movies."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "WITH RECURSIVE split(genre, rest) AS (SELECT '', genres || '|' FROM movies WHERE genres != '' UNION ALL SELECT substr(rest, 0, instr(rest, '|')), substr(rest, instr(rest, '|')+1) FROM split WHERE rest != ''), genre_counts AS (SELECT trim(genre) AS genre, COUNT(*) AS count FROM split WHERE genre != '' GROUP BY trim(genre)) SELECT genre AS 'Жанр фильма', count AS 'Количество фильмов' FROM genre_counts ORDER BY count DESC LIMIT 1;"
echo " "

echo "7. Вывести список из 10 последних зарегистрированных пользователей в формате 'Фамилия Имя|Дата регистрации' (сначала фамилия, потом имя)."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT SUBSTR(name, INSTR(name, ' ') + 1) || ' ' || SUBSTR(name, 1, INSTR(name, ' ') - 1) || '|' || register_date FROM users ORDER BY register_date DESC LIMIT 10;"
echo " "

echo "8. С помощью рекурсивного CTE определить, на какие дни недели приходился ваш день рождения в каждом году."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT ..."