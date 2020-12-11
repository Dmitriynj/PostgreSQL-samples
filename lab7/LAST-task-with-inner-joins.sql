create table sityOS (
	sity varchar(25),
	OS varchar(25)
);

insert into SityOS values
('London', 'Linux'),
('London', 'Linux'),
('London', 'Linux'),
('London', 'Win95'),
('London', 'Win95'),
('Moscow', 'Milenium'),
('Moscow', 'Milenium'),
('Moscow', 'Linux'),
('Bangladesh', 'Win10'),
('Bangladesh', 'Win10'),
('Bangladesh','Win7');

SELECT 
	inner1.sity, inner1.OS
	FROM (SELECT sity, OS, count(OS) count_os
				FROM sityOS 
				group by sity, OS) as inner1
	where inner1.count_os in (
		SELECT count(OS) count_os
				FROM sityOS 
				group by sity, OS
	)
	
select t_max.sity, t_count2.os, t_max.count_os
	from (
		select t_count.sity, max(t_count.count_os) as count_os
			from (
				select sity, os, count(os) as count_os
					from sityOS
					group by sity, os
			) as t_count
		group by t_count.sity
	) as t_max
	inner join (
		select sity, os, count(os) as count_os
			from sityOS
			group by sity, os
	) as t_count2
	on t_count2.count_os = t_max.count_os and t_count2.sity = t_max.sity;
	
	
SELECT sss.sity, max(sss.count_os)
		FROM (SELECT sity, OS, count(OS) count_os
			FROM sityOS 
			group by sity, OS) as sss
		group by sss.sity
	
SELECT sity, OS
	FROM sityOS;