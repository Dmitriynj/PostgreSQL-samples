USE [my]
GO


IF Object_Id('some', 'P') IS NOT NULL 
  DROP PROCEDURE [dbo].[some];
GO
CREATE PROC [dbo].[some] @SecondResult integer OUT

AS
  BEGIN
	IF CURSOR_STATUS('global','cur')>=-1
		DEALLOCATE cur

	Declare cur CURSOR for
	select C from ex2;
	

	SET @SecondResult =  1;
    OPEN cur;
	-- open cur;
    -- Second result set saved as JSON in an output variable  
    -- SELECT @SecondResult = (SELECT C from ex2);
  END;
GO



DECLARE @RC NVARCHAR(max)
DECLARE @SecondResult nvarchar(max)

-- TODO: Set parameter values here.

EXECUTE @RC = [dbo].[some] 
   @SecondResult OUTPUT 
   select @SecondResult;
GO



DECLARE @RC NVARCHAR(max)
DECLARE @SecondResult nvarchar(max)

EXECUTE @RC = [dbo].[some] 
  @SecondResult OUTPUT 
WITH RESULT SETS
(
 ( 
  C NVARCHAR(max)
 ) 
) 



IF CURSOR_STATUS('global','cur')>=-1
	DEALLOCATE cur

DECLARE @tempTable TABLE(
	id INT,
	full_name VARCHAR(max),
	reduced_name VARCHAR(max)
);
DECLARE @A VARCHAR(max),
		@B VARCHAR(max),
		@C VARCHAR(max);
DECLARE 
	cur CURSOR 
	FOR select A, B, C from ex2;

OPEN cur;

FETCH NEXT FROM cur INTO 
	@A, @B, @C;

WHILE @@FETCH_STATUS = 0
    BEGIN
		IF @B = 2
		BEGIN
			INSERT INTO @tempTable VALUES(@A, @C, '');
		END;

		IF @B = 3
		BEGIN
			UPDATE @tempTable
				SET reduced_name = @C
				WHERE id = @A;
		END;

        FETCH NEXT FROM cur INTO 
            @A, @B, @C;
    END;

CLOSE cur;

DEALLOCATE cur;

select * from @tempTable;





