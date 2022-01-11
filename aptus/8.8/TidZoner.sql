select t.Name 
	, case when t.Type = 1 then 'Läsarstyrd'
		when t.Type = 2 then 'Tid- och ingångsstyrd'
		when t.Type = 3 then 'Tempraturlarm'
		when t.Type = 4 then 'Tider för bokninglista'
		when t.Type = 5 then 'Porttelefoni'		
		else '???'
	end TidzonTyp
	, (select count(*) from TzInAuth ta where ta.TimezoneId = t.Id) AntalBehörigheter
	, (select count(*) from ResourceInTimezone tr where tr.TimezoneId = t.Id) AntalResurser
	, (select count(*) from TimeRow tir where tir.TimezoneId = t.Id) AntalTidsBlock
	, t.*
from TimeZone t
order by t.Name