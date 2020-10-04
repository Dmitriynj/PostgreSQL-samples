create table sklad
(
    Tovar varchar(25),
    price int,
    kol int,
    postavka Date,
    Primary KEY(tovar)
);
COPY sklad FROM 'C:/Users/Dzmitry_Tamashevich/Documents/BSUIR/Lab3_-_data.txt';

-------------------------------------------------------------------
-- 1) For Postgresql
-- Вставки записи и ее обновления
--
CREATE OR REPLACE FUNCTION insert_or_update(
    _tovar varchar(25),
    _price integer,
    _kol integer,
    _postavka date
    ) RETURNS void 

AS $BODY$
BEGIN

    if (EXISTS (SELECT * FROM sklad WHERE sklad.tovar = _tovar)) THEN
        UPDATE sklad SET price = _price, kol = _kol, postavka = _postavka WHERE Tovar = _tovar;
    else
        INSERT INTO sklad VALUES(_tovar, _price, _kol, _postavka);
    END if;
END
$BODY$

LANGUAGE 'plpgsql';

--
select * from insert_or_update('some', 100, 20, '2020-01-16');
--
SELECT * FROM sklad;

-------------------------------------------------------------------
-- 2) For psql
--	Подсчет налога со всех товаров
--
CREATE OR REPLACE PROCEDURE calculate_total_tax(
    in _ratio Numeric,
    INOUT _tax Numeric
    )  
LANGUAGE SQL
AS $BODY$
SELECT SUM(price)*_ratio _tax 
FROM sklad
$BODY$;
-- wrapper for calling 'calculate_total_tax'
CREATE OR REPLACE PROCEDURE call_calculate_total_tax()
LANGUAGE plpgsql
AS $$
Declare
   tax Numeric;
BEGIN
    call calculate_total_tax(0.38, tax);
    raise info 'tax is : %',tax;
END;
$$;

--
call call_calculate_total_tax();

-------------------------------------------------------------------
-- 3) Точное название товара по первым буквам
-- 
CREATE OR REPLACE PROCEDURE search_tovar(
      IN starts_with varchar(25),
	  INOUT tovar_name varchar(25)
    )  
LANGUAGE SQL
AS $BODY$
SELECT sklad.tovar tovar_name
FROM sklad 
    WHERE sklad.tovar like CONCAT(starts_with, '%');
$BODY$;

-- wrapper for call search_tovar(...)
CREATE OR REPLACE PROCEDURE call_search_tovar()
LANGUAGE plpgsql
AS $$
Declare
   tovar_name varchar(25);
BEGIN
    call search_tovar('cu', tovar_name);
    raise info 'tovar is : %',tovar_name;
END;
$$;

--
call call_search_tovar();

-------------------------------------------------------------------
-- 4)	Работы с курсором 
-- (подсчитать число  записей с одинаковым названием товара).
CREATE OR REPLACE PROCEDURE count_matched_tovar_titles(
      IN title varchar(25),
	  INOUT amount int
    )  
LANGUAGE plpgsql
AS $$
DECLARE 
count_cursor cursor  
    for SELECT count(*) 
        FROM sklad
            WHERE sklad.tovar IN (
                SELECT sklad.tovar
                FROM sklad
                    WHERE sklad.tovar like title
            );
BEGIN
OPEN count_cursor;
FETCH count_cursor into amount;
CLOSE count_cursor;
END$$;

-- call count_matched_tovar_titles(...)
CREATE OR REPLACE PROCEDURE call_count_matched_tovar_titles()
LANGUAGE plpgsql
AS $$
Declare
   amount Integer;
BEGIN
    call count_matched_tovar_titles('some', amount);
    raise info 'tovar name matches amount is : %',amount;
END;
$$;

-- 
ALTER TABLE sklad DROP CONSTRAINT tovar;
insert into sklad values('some', 123, 125, '2020-01-12');
call call_count_matched_tovar_titles();


-------------------------------------------------------------------
-- 5)	Вычисления налога в зависимости от цены и количества товара
--
CREATE OR REPLACE FUNCTION calc_complicated_tax(
    IN price integer,
    IN kol integer
    ) RETURNS NUMERIC 
LANGUAGE 'plpgsql'
AS $BODY$
    DECLARE ratio NUMERIC;
    DECLARE _tax NUMERIC;
BEGIN
    if (price < 100) THEN
        ratio := 0.1;
    elsif (price >= 100 and kol > 1) THEN
        ratio := 0.2;
    else
        ratio := 0.15;
    END if;

    _tax := (SELECT SUM(sklad.price)*ratio FROM sklad);
    return _tax;
END$BODY$;

--
select * from calc_complicated_tax(120, 100);



-------------------------------------------------------------------
-- 6)	Вычисления средней цены товара по таблице
--
CREATE OR REPLACE FUNCTION calc_avg_price_by_table_name(
    IN table_name character varying,
    OUT result NUMERIC
    ) 
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
    EXECUTE format('SELECT (SELECT AVG(price) FROM %s)::numeric', table_name)
    INTO result;
END$BODY$;
 
--
select * from calc_avg_price_by_table_name('"sklad"');

