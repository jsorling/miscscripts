declare @funclevels table (funclevel int, functext nvarchar(65))
insert @funclevels(funclevel, functext)
values (0, 'Ingen effekt')
	, (2, 'Kort')
	, (3, 'Kort')
	, (4, 'Kod')
	, (14, 'Ingångsstyrd, flank')
	, (21, 'Kan ej bokas')
	, (22, 'Intervall 1, 3, 5...')
	, (23, 'Intervall 2, 4, 6...')
	, (32, 'Telefonnummer')
	, (31, 'Anropskod eller telefonnummer')

select tz.Name 
	, case when t.RowTime = 0 then '00:00'
		else format(floor(t.RowTime / 60), '00') + ':' + format(floor(t.RowTime % 60), '00')
	end Start
	, coalesce(mon.functext, '??') Mån
	, coalesce(tue.functext, '??') Tis
	, coalesce(wed.functext, '??') Ons
	, coalesce(thu.functext, '??') Tor
	, coalesce(fri.functext, '??') Fre
	, coalesce(sat.functext, '??') Lör
	, coalesce(sun.functext, '??') Sön
	, coalesce(sp1.functext, '??') SP1
	, coalesce(sp2.functext, '??') SP2
	, coalesce(sp3.functext, '??') SP3
	, t.* from TimeRow t
left join TimeZone tz on tz.Id = t.TimezoneId
left join @funclevels mon on d0 = mon.funclevel
left join @funclevels tue on d1 = tue.funclevel
left join @funclevels wed on d2 = wed.funclevel
left join @funclevels thu on d3 = thu.funclevel
left join @funclevels fri on d4 = fri.funclevel
left join @funclevels sat on d5 = sat.funclevel
left join @funclevels sun on d6 = sun.funclevel
left join @funclevels sp1 on d7 = sp1.funclevel
left join @funclevels sp2 on d8 = sp2.funclevel
left join @funclevels sp3 on d9 = sp3.funclevel
order by t.TimezoneId, t.RowTime