-- Active: 1763755261268@@127.0.0.1@3306

-- Создать команды для добавления пяти новых пользователей, в том числе себя и четырех ближайших 
-- соседей по списку вашей группы. Дата регистрации должна определяться по системному времени.

INSERT INTO users (name, email, gender, register_date, occupation) 
VALUES ('Тульсков Илья', 'tulskovi@mail.ru', 'male', datetime('now', 'localtime'), 'student');

INSERT INTO users (name, email, gender, register_date, occupation) 
VALUES ('Фирстов Артем', 'firstova@mail.ru', 'male', datetime('now', 'localtime'), 'student');

INSERT INTO users (name, email, gender, register_date, occupation) 
VALUES ('Четайкин Владислав', 'chetaikinv@mail.ru', 'male', datetime('now', 'localtime'), 'student');

INSERT INTO users (name, email, gender, register_date, occupation) 
VALUES ('Шарунов Максим', 'sharunovm@mail.ru', 'male', datetime('now', 'localtime'), 'student');

INSERT INTO users (name, email, gender, register_date, occupation) 
VALUES ('Шушев Денис', 'shusevd@mail.ru', 'male', datetime('now', 'localtime'), 'student');

--Создать команды для добавления трех новых фильмов разных жанров.

INSERT INTO movies (title, year)
VALUES ('1+1', 2011);

INSERT INTO movie_genres (movie_id, genre_id)
VALUES (
    (SELECT id FROM movies WHERE title = '1+1' AND year = 2011),
    (SELECT id FROM genres WHERE name = 'Drama')
);

INSERT INTO movies (title, year)
VALUES ('The Gentlemen', 2019);

INSERT INTO movie_genres (movie_id, genre_id)
VALUES (
    (SELECT id FROM movies WHERE title = 'The Gentlemen' AND year = 2019),
    (SELECT id FROM genres WHERE name = 'Crime')
);

INSERT INTO movies (title, year)
VALUES ('Green Book', 2018);

INSERT INTO movie_genres (movie_id, genre_id)
VALUES (
    (SELECT id FROM movies WHERE title = 'Green Book' AND year = 2018),
    (SELECT id FROM genres WHERE name = 'Comedy')
);

--Создать команды для добавления трех новых отзывов о добавленных фильмах от себя.

INSERT INTO ratings (user_id, movie_id, rating, timestamp)
VALUES (
    (SELECT id FROM users WHERE email = 'tulskovi@mail.ru'),
    (SELECT id FROM movies WHERE title = '1+1' AND year = 2011),
    4.7,
    strftime('%s', 'now')
);

INSERT INTO ratings (user_id, movie_id, rating, timestamp)
VALUES (
    (SELECT id FROM users WHERE email = 'tulskovi@mail.ru'),
    (SELECT id FROM movies WHERE title = 'The Gentlemen' AND year = 2019),
    4.5,
    strftime('%s', 'now')
);

INSERT INTO ratings (user_id, movie_id, rating, timestamp)
VALUES (
    (SELECT id FROM users WHERE email = 'tulskovi@mail.ru'),
    (SELECT id FROM movies WHERE title = 'Green Book' AND year = 2018),
    4.9,
    strftime('%s', 'now')
);
