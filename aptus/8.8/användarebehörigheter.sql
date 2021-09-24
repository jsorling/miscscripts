select max(c.Id) [KundId], max(c.Name) [KundNamn], u.Id [AnvändarId], max(coalesce(u.Name, '')) [BrickNamn], 
  max(coalesce(u.CardLabel, '')) [BrickMärkning], max(coalesce(u.Code, '')) [Kod], max(coalesce(u.Card, '')) [BrickId], 
  max(coalesce(convert(varchar, u.Start,20), '')) [Start], 
  max(coalesce(convert(varchar, u.Stop, 20), '')) [Stop], 
  max(case when u.Blocked = 1 then 'Ja' else 'Nej' end) [Spärrad],
  max(u.createdTime) [Skapad],
  string_agg(coalesce(a.Name, ''), ' | ') [Behörigheter] 
from Users u
left join customer c on c.Id = u.customerId
left join AuthorityInUser au on au.UserId = u.Id 
  and ((au.stop IS NOT NULL AND au.stop > GETDATE()) OR au.stop IS NULL) 
  and ((au.removedDate IS NOT NULL AND au.removedDate > GETDATE()) OR au.removedDate IS NULL)
left join Authority a on a.Id = au.AuthorityId
group by u.Id
order by max(c.Name),  max(u.Name), max(u.CardLabel), max(coalesce(u.Card, ''))