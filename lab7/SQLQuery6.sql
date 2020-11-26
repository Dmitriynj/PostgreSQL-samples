USE [my]
GO

CREATE TABLE Firm (
IDF int IDENTITY(1,1) primary key,
FirmName varchar(25),
Address varchar(25),
Rate decimal(10, 2)
) ;

insert into firm (FirmName, Address, Rate)
select 
firm FirmName, address Address, 
CASE
    WHEN avg(rate) < 10 THEN 0.1
    WHEN avg(rate) > 10 and avg(rate) < 20 THEN 0.2
	WHEN avg(rate) > 20 and avg(rate) < 30 THEN 0.3
    ELSE 0.4
END AS Rate
from supply group by firm, address;

GO


