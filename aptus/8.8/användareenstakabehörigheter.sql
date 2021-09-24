select c.Name
	, u.CardLabel
	, cast('' as nvarchar(10)) Namn
	, cast('' as nvarchar(10)) Kod
	, u.Card Kort
	, cast('' as nvarchar(10)) Fritext1
	, 'Behörighet' Behörighet
	, cast('' as nvarchar(10)) Starttid
	, cast('' as nvarchar(10)) Stopptid
from dbo.Users u
left join dbo.Customer c on c.Id = u.customerId