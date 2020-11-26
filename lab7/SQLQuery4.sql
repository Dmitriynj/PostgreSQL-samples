USE [my]
GO

delimiter //
SELECT A
      ,B
      ,CS
  FROM ex2;
  //
delimiter ;

delimiter //
create procedure some(OUT result)
begin
Declare cur CURSOR for
select C from ex2;

open cur;
fetch cur into result;
close cur;
end;
//
delimiter ;

call some(@result);
select @result;

GO


