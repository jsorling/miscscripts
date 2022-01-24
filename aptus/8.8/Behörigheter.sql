declare @querytype int = 0 -- 0 all, 1 timezones, 2 user, 3 object, 4 resource
declare @id int = 0

select a.Name
	, case when a.IsPhoneAuthority = 1 then 'P-tele'
	else 'Normal' end Typ
	, a.AutoGenerated
	, d.Name Domain
	, a.Resource_Id ResursId
	, r.Name Resource 
	, (select count(*) from AuthorityInUser au where au.AuthorityId = a.Id) Anv�ndare
	, (select count(*) from AuthorityInObject ao where ao.Authority_Id = a.Id) Objekt
	, (select count(*) from TzInAuth tz where tz.AuthorityId = a.Id) Tidzoner
	, a.Id 
from Authority a
left join Domain d on d.Id = a.Domain_Id
left join Resource r on r.Id = a.Resource_Id
left join TzInAuth ta on ta.AuthorityId = a.Id and @querytype = 1
left join AuthorityInUser aiu on aiu.AuthorityId = a.Id and @querytype = 2
left join AuthorityInObject aio on aio.Authority_Id = a.Id and @querytype = 3
where (@querytype = 1 and ta.TimezoneId = @id)
	or (@querytype = 2 and aiu.UserId = @id)
	or (@querytype = 3 and aio.Object_Id = @id)
	or (@querytype = 4 and a.Resource_Id = @id)
	or @querytype = 0
order by a.Name