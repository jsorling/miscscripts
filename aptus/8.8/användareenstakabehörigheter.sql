select c.Name
	, u.CardLabel Nyckelmärkning
	, u.Name Namn
	, u.Code Kod
	, u.Card Kort
	, u.f0 Fritext1
	, 'Behörighet' Behörighet
	, cast('' as nvarchar(10)) Starttid
	, cast('' as nvarchar(10)) Stopptid
from dbo.Users u
left join dbo.Customer c on c.Id = u.customerId