-- 1. создать базу данных.
create database A1;
-- 2. создать таблицы:
use A1;
-- manuf : таблица, хранящая названия фирм 
-- 		ГДЕ:
-- IDM : код фирмы (первичный ключ)
-- Name: название фирмы
-- city: город, где находится фирма
create table manuf
(
     IDM int primary key,
     Name varchar(17),
     city varchar(17)
);
-- cpu : таблица, хранящая названия и характеристики процессоров
-- 		ГДЕ:
-- IDС :  код модели процессора (первичный ключ)
-- IDM: код фирмы производителя процессора
-- Name:  название модели процессора
-- clock: частота работы процессора с точностью до одной десятой
create table cpu
(
     IDC int primary key,
     IDM int,
     Name varchar(17),
     clock decimal(60,1)
);
-- hdisk : таблица, хранящая названия и характеристики дисков
-- 		ГДЕ:
-- IDD: код модели диска (первичный ключ)
-- IDM: код фирмы производителя диска
-- Name: название модели диска
-- type: тип диска 
-- size: размер диска
create table hdisk
(
     IDD int primary key,
     IDM int,
     Name varchar(17),
     type varchar(10),
     size int
);
-- nb : таблица, хранящая комплектацию ноутбука
-- 		ГДЕ:
-- IDN: код модели (первичный ключ)
-- IDM: код фирмы производителя ноутбука
-- name: название модели ноутбука
-- IDC: код модели процессора 
-- IDD: код модели диска
create table nb
(
     IDN int primary key,
     IDM int,
     name varchar(10),
     IDC int,
     IDD int
);

-- Phone : таблица, хранящая телефон менеджера 
-- 		ГДЕ:
-- IDP: табельный номер сотрудники (первичный ключ)
-- IDM: код фирмы на которой работает сотрудник 
-- Number: номер телефона
-- NameManager: имя менеджера
create table Phone
(
     IDP int primary key,
     IDM int,
     Number int,
     NameManager varchar(10)
);
-- 3. Выполнить запросы:

insert into manuf
values
     (1, 'Intel', 'Santa Clara'),
     (2, 'AMD', 'Santa Clara'),
     (3, 'WD', 'San Jose'),
     (4, 'seagete', 'Cupertino'),
     (5, 'Asus', 'Taipei'),
     (6, 'Dell', 'Round Rock');

insert into CPU
values
     (1, 1, 'i5', 3.2),
     (2, 1, 'i7', 4.7),
     (3, 2, 'Ryzen 5', 3.2),
     (4, 2, 'Ryzen 7', 4.7),
     (5, 6, 'Power9', 3.5);

insert into hdisk
values
     (1, 3, 'Green', 'hdd', 1000),
     (2, 3, 'Black', 'ssd', 256),
     (3, 1, '6000p', 'ssd', 256),
     (4, 1, 'Optane', 'ssd', 16);

insert into nb
values
     (1, 5, 'Zenbook', 2, 2),
     (2, 6, 'XPS', 2, 2),
     (3, 6, 'Pavilion', 2, 2),
     (4, 9, 'Inspiron', 3, 4),
     (5, 5, 'Vivobook', 1, 1),
     (6, 6, 'XPS', 4, 1);

-- 4. Заполнить таблицу Phone произвольными данными.
insert into Phone
values
     (1, 5, 4, 'Alex'),
     (2, 5, 1, 'Mike'),
     (3, 5, 4, 'Roma'),
     (4, 5, 4, 'Alex'),
     (5, 5, 4, 'Victor');
-- 5. Написать запросы чтобы вывести данные: 

-- 5.1	Название фирмы и модель диска (Список не должен содержать значений NULL)
-- ----------------------------------------------------------------------
-- Решение:

SELECT hdisk.Name model, manuf.Name manufName
FROM hdisk
     JOIN manuf ON manuf.IDM=hdisk.IDM


-- 5.2	Модель процессора и, если есть информация в БД, название фирмы;
-- ----------------------------------------------------------------------
-- Решение:

SELECT cpu.Name cpumodel, manuf.Name manuftitle
FROM cpu
     LEFT JOIN manuf ON manuf.IDM=cpu.IDM



-- ----------------------------------------------------------------------
-- 5.3	Название фирмы, которая производить несколько типов товара;
-- ----------------------------------------------------------------------
-- Решение:

     SELECT manuf.name manufname
     FROM manuf
          JOIN nb ON nb.IDM=manuf.IDM
          JOIN cpu ON cpu.IDM=manuf.IDM

UNION

     SELECT manuf.name manufname
     FROM manuf
          JOIN hdisk ON hdisk.IDM=manuf.IDM
          JOIN nb ON nb.IDM=manuf.IDM

UNION

     SELECT manuf.name manufname
     FROM manuf
          JOIN cpu ON cpu.IDM=manuf.IDM
          JOIN hdisk ON hdisk.IDM=manuf.IDM


-- ###





-- ----------------------------------------------------------------------
-- 5.4	Модели ноутбуков без информации в базе данных о фирме изготовителе;
-- ----------------------------------------------------------------------
-- Решение:

SELECT nb.Name
FROM nb
     LEFT JOIN manuf ON manuf.IDM=nb.IDM
WHERE manuf.IDM IS NULL


-- ----------------------------------------------------------------------
-- 5.5	Модель ноутбука и название производителя ноутбука, название модели процессора, название модели диска.
-- ----------------------------------------------------------------------
-- Решение:

SELECT *
FROM nb
     LEFT JOIN manuf ON manuf.IDM=nb.IDM
     JOIN cpu ON cpu.IDC=nb.IDC
     JOIN hdisk ON hdisk.IDD=nb.IDD



-- ----------------------------------------------------------------------
-- 5.6	Модель ноутбука, фирму производителя ноутбука, а также для этой модели: 
-- 				модель и название фирмы производителя процессора,
-- 				модель и название фирмы производителя диска.
-- ----------------------------------------------------------------------
-- Решение:

SELECT nb.IDN nbmodel, manuf.Name nbmanufname,
     cpumanuf.IDM cpumodel, cpumanuf.Name cpumanufname,
     hdiskmanuf.IDM hdiskmodel, hdiskmanuf.Name hdiskmanufname
FROM nb
     LEFT JOIN manuf ON manuf.IDM=nb.IDM
     JOIN cpu ON cpu.IDC=nb.IDC
     JOIN hdisk ON hdisk.IDD=nb.IDD
     JOIN manuf as cpumanuf ON cpumanuf.idm=cpu.idm
     JOIN manuf as hdiskmanuf ON hdiskmanuf.idm=hdisk.idm



-- ----------------------------------------------------------------------
-- 5.7	 Абсолютно все названия фирмы и все модели процессоров 
-- ----------------------------------------------------------------------
-- Решение:

SELECT manuf.Name manufname, cpu.Name cpuname
FROM manuf
     FULL OUTER JOIN cpu ON manuf.IDM=cpu.IDM

--- ###

     SELECT manuf.Name manufname
     FROM manuf
UNION
     SELECT cpu.Name cpuname
     FROM cpu 




