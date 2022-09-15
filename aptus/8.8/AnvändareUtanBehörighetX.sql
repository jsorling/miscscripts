declare @auth nvarchar (65) = 'Behörighet X'
declare @aid int = (select a.id from Authority a where a.Name = @auth)

select c.Id [KundId], c.Name [KundNamn], u.Id [AnvändarId], coalesce(u.Name, '') [BrickNamn], 
  coalesce(u.CardLabel, '') [BrickMärkning], coalesce(u.Code, '') [Kod], coalesce(u.Card, '') [BrickId], 
  coalesce(convert(varchar, u.Start,20), '') [Start], 
  coalesce(convert(varchar, u.Stop, 20), '') [Stop], 
  case when u.Blocked = 1 then 'Ja' else 'Nej' end [Spärrad],
  u.createdTime [Skapad]  
from Users u
left join customer c on c.Id = u.customerId
left join AuthorityInUser au on au.UserId = u.Id and au.AuthorityId = @aid
  and ((au.stop IS NOT NULL AND au.stop > GETDATE()) OR au.stop IS NULL) 
  and ((au.removedDate IS NOT NULL AND au.removedDate > GETDATE()) OR au.removedDate IS NULL)
where au.UserId is null
order by c.Name, u.Name, u.CardLabel, coalesce(u.Card, '')
