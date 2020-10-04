-- Выполнить запросы:
create database lab2;
use lab2;
create table Seance
(
    id int,
    filmName varchar(500),
    duration int,
    price DOUBLE PRECISION,
    idCinema int
);
create table Cinemas
(
    id int,
    title varchar(500),
    address varchar(500)
);
insert into Cinemas
values(1, 'Belarus', 'Romanovskaya Sloboda 28');
insert into Cinemas
values(2, '3D kino v Zamke', 'Melezha 1');
insert into Cinemas
values(3, 'Silver Screen Galileo', 'Bobruiskaya 6');
insert into Cinemas
values(4, 'Silver Screen Arena City', 'Pobediteley square 84');
insert into Cinemas
values(5, 'Victory', 'Internationalnaya 20');
insert into Cinemas
values(6, 'Aurora', 'Pritickogo 23');
insert into Cinemas
values(7, 'October', 'Nezalezhnosti square 73');
insert into Cinemas
values(8, 'Moskow', 'Pobediteley square 13');
insert into Cinemas
values(9, 'Pioneer', 'Engelsa 20');
insert into Cinemas
values(10, 'Central Cinema', 'Nezalezhnosti square 13');
insert into Seance
values(1, 'Inception', 148, 12, 1);
insert into Seance
values(2, 'The First Purge', 112, 6.5, 8);
insert into Seance
values(3, 'Shrek 2 Forever', 93, 6, 4);
insert into Seance
values(4, 'Zombieland: Double Tap', 99, 7, 7);
insert into Seance
values(5, 'WALL-E', 98, 7.6, 7);
insert into Seance
values(6, 'Saw', 103, 15, 2);
insert into Seance
values(7, 'Deadpool', 109, 7.2, 3);
insert into Seance
values(8, 'The Blair Witch', 105, 8.8, 4);
insert into Seance
values(9, 'Insidious', 102, 15, 5);
insert into Seance
values(10, 'The Dark Knight', 152, 20, 4);
insert into Seance
values(11, 'Deadpool', 109, 9.6, 7);
insert into Seance
values(12, 'Green Mile', 189, 14.7, 8);
insert into Seance
values(13, 'WALL-E', 98, 5.6, 9);
insert into Seance
values(14, 'Blade 2', 117, 12.2, 1);
insert into Seance
values(15, 'Inception', 102, 13.9, 4);
insert into Seance
values(16, 'Blade 2', 117, 9.6, 2);
insert into Seance
values(17, 'Blade Runner 2049', 164, 14.4, 6);
insert into Seance
values(18, 'Shrek 2 Forever', 93, 9, 8);
insert into Seance
values(19, 'Green Mile', 189, 8.5, 6);
insert into Seance
values(20, 'Insidious', 180, 4.6, 2);
insert into Seance
values(21, 'Chappie', 120, 17.6, 5);
insert into Seance
values(22, 'The Dark Knight', 152, 3.3, 9);
insert into Seance
values(23, 'Inception', 148, 11, 7);
insert into Seance
values(24, 'Blade Runner 2049', 164, 15, 8);
insert into Seance
values(25, 'Martian', 151, 17.1, 3);
insert into Seance
values(26, 'Green Mile', 189, 14.7, 5);

-- ----------------------------------------------------------------------
-- 1.	Создать первичные ключи для таблиц «Seance» и «Cinemas».
-- ----------------------------------------------------------------------
-- Решение:

ALTER TABLE Seance ADD PRIMARY KEY (id)
ALTER TABLE Cinemas ADD PRIMARY KEY (id)



-- ----------------------------------------------------------------------
-- 2.	Создать в таблице «Seance» поле «hallCount».
-- ----------------------------------------------------------------------
-- Решение:

ALTER TABLE Seance
ADD COLUMN hallCount int

-- ----------------------------------------------------------------------
-- 3.	Создать в таблице «Seance» поле «date_session», которое по умолчанию заполняется текущей датой.
-- ----------------------------------------------------------------------
-- Решение:

ALTER TABLE Seance 
ADD COLUMN date_session date;

ALTER TABLE Seance 
ALTER COLUMN date_session
SET
DEFAULT NOW
();


-- ----------------------------------------------------------------------
-- 4.	Установить для поля «idCinema» таблицы «Seance» вторичный ключ с ссылкой на поле «Id» таблицы «Cinemas».
-- ----------------------------------------------------------------------
-- Решение:

ALTER TABLE Seance
    ADD CONSTRAINT fk_seance_cinema FOREIGN KEY (idCinema) REFERENCES cinemas (id);

-- ----------------------------------------------------------------------
-- 5.	Перемеиновать поле «hallCount» в  «CountHall» таблицы Seance.
-- ----------------------------------------------------------------------
-- Решение:

ALTER TABLE Seance
  RENAME COLUMN hallcount TO counthall;

-- ----------------------------------------------------------------------
-- 6.	Удалить поле «CountHall»  из таблицы  «Seance»
-- ----------------------------------------------------------------------
-- Решение:

ALTER TABLE Seance 
DROP COLUMN counthall;

-- ----------------------------------------------------------------------
-- 7.	Посчитать количество фильмов и суммарную стоимость для каждого  «Seance».
-- ----------------------------------------------------------------------
-- Решение:

SELECT count(*) filmcount, sum(price) sumprice, filmname
FROM seance
GROUP BY filmname

-- ----------------------------------------------------------------------
-- 8.	Найти три самых продолжительных фильма.
-- ----------------------------------------------------------------------
-- Решение:

SELECT filmname, duration
FROM seance
GROUP BY filmname, duration
ORDER BY duration DESC
	LIMIT 3

-- ----------------------------------------------------------------------
-- 9.	Посчитать среднюю стоимость фильма.
-- ----------------------------------------------------------------------
-- Решение:

SELECT AVG
(price) avgprice
FROM seance

-- ----------------------------------------------------------------------
-- 10.	Вывести кинотеатр и название фильма отсортировав с начала по названию кинотеатра, затем по названию фильма в обратном порядке.
-- ----------------------------------------------------------------------
-- Решение:

SELECT seance.filmname filmname, cinemas.title cinemaname
FROM seance
    JOIN cinemas ON cinemas.id=seance.idcinema
ORDER BY cinemas.title, seance.filmname DESC


-- ----------------------------------------------------------------------
-- 11.	Вывести самый дешевый фильм для каждого кинотеатра.
-- ----------------------------------------------------------------------
-- Решение:

SELECT seance.filmname, cinemas.title
FROM seance
    JOIN cinemas ON cinemas.id=seance.idcinema
WHERE seance.price IN (
        SELECT MIN(seance.price)
FROM seance
GROUP BY seance.idcinema
    )



-- ----------------------------------------------------------------------
-- 12.	Вывести второй по продолжительности фильм.
-- ----------------------------------------------------------------------
-- Решение:

SELECT DISTINCT seance.duration, seance.filmname
FROM seance
ORDER BY seance.duration DESC
	LIMIT 1 OFFSET
1

-- ###

SELECT seance.duration, seance.filmname
FROM seance
WHERE seance.duration = (
		SELECT MAX(seance.duration)
FROM seance
WHERE seance.duration NOT IN (
				SELECT MAX(seance.duration)
FROM seance
			)
	)




