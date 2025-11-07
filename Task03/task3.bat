#!/bin/bash
chcp 65001

sqlite3 movies_rating.db < db_init.sql

echo "1. Составить список фильмов, имеющих хотя бы одну оценку. Список фильмов отсортировать по году выпуска и по названиям. В списке оставить первые 10 фильмов."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT DISTINCT m.title, m.year FROM movies m WHERE m.id IN (SELECT r.movie_id FROM ratings r WHERE r.rating IS NOT NULL) ORDER BY m.year, m.title LIMIT 10;"
echo " "

echo "2. Вывести список всех пользователей, фамилии (не имена!) которых начинаются на букву 'A'. Полученный список отсортировать по дате регистрации. В списке оставить первых 5 пользователей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT id, name, email, gender, register_date, occupation FROM users WHERE name LIKE '%% A%%' ORDER BY register_date LIMIT 5;"
echo " "

echo "3. Написать запрос, возвращающий информацию о рейтингах в более читаемом формате: имя и фамилия эксперта, название фильма, год выпуска, оценка и дата оценки в формате ГГГГ-ММ-ДД. Отсортировать данные по имени эксперта, затем названию фильма и оценке. В списке оставить первые 50 записей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT u.name, m.title, m.year, r.rating, date(r.timestamp, 'unixepoch') FROM ratings r INNER JOIN users u ON r.user_id = u.id INNER JOIN movies m ON r.movie_id = m.id ORDER BY u.name, m.title, r.rating LIMIT 50;"
echo " "

echo "4. Вывести список фильмов с указанием тегов, которые были им присвоены пользователями. Сортировать по году выпуска, затем по названию фильма, затем по тегу. В списке оставить первые 40 записей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT m.title, m.year, t.tag, u.name FROM movies m INNER JOIN tags t ON m.id = t.movie_id INNER JOIN users u ON t.user_id = u.id ORDER BY m.year, m.title, t.tag LIMIT 40;"
echo " "

echo "5. Вывести список самых свежих фильмов. В список должны войти все фильмы последнего года выпуска, имеющиеся в базе данных. Запрос должен быть универсальным, не зависящим от исходных данных (нужный год выпуска должен определяться в запросе, а не жестко задаваться)."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT m.title, m.year, m.genres FROM movies m WHERE m.year = (SELECT MAX(year) FROM movies) ORDER by m.title;"
echo " "

echo "6. Найти все драмы, выпущенные после 2005 года, которые понравились женщинам (оценка не ниже 4.5). Для каждого фильма в этом списке вывести название, год выпуска и количество таких оценок. Результат отсортировать по году выпуска и названию фильма."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT m.title, m.year, COUNT(r.rating) FROM movies m INNER JOIN ratings r ON m.id = r.movie_id INNER JOIN users u ON r.user_id = u.id WHERE m.genres LIKE '%Drama%' AND m.year > 2005 AND u.gender = 'female' AND r.rating >= 4.5 GROUP BY m.id ORDER BY m.year, m.title;"
echo " "

echo "7. Провести анализ востребованности ресурса - вывести количество пользователей, регистрировавшихся на сайте в каждом году. Найти, в каких годах регистрировалось больше всего и меньше всего пользователей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT STRFTIME('%Y', register_date) AS reg_year, COUNT(id) AS user_count FROM users GROUP BY reg_year ORDER BY reg_year;"
echo " "

echo "Больше всего пользователей регистрировалось в следующем году:"
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT STRFTIME('%Y', register_date) AS reg_year, COUNT(id) AS user_count FROM users GROUP BY reg_year ORDER BY user_count DESC LIMIT 1;"
echo " "

echo "Меньше всего пользователей регистрировалось в следующем году:"
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT STRFTIME('%Y', register_date) AS reg_year, COUNT(id) AS user_count FROM users GROUP BY reg_year ORDER BY user_count ASC LIMIT 1;"
echo " "