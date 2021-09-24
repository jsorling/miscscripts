select c.Name Kundnamn
	, c.Name Objektnamn
	, cast('' as nvarchar(10)) Starttid
	, cast('' as nvarchar(10)) Sluttid
	, a.Name Adress
	, cast('' as nvarchar(10)) F�rnamn
	, cast('' as nvarchar(10)) Efternamn
	, cast('' as nvarchar(10)) F�rnamn2
	, cast('' as nvarchar(10)) Efternamn2
	, o.ApartmentNo Telefonnummer
	, o.EntryPhoneCallCode Anropskod -- o.ApartmentNo 
	, o.ApartmentPhoneAddress Svarsapparat
	, o.Floor V�ning -- o.FloorText
	, o.ApartmentNo L�genhetsnummer
	, 'P-telebeh�righet' PorttelefonBeh�righet
	, 1 VisaIPorttelefon
	, 1 VisaBoendeNamn
from dbo.Customer c
left join dbo.ObjectInCustomer oc on oc.Customer_Id = c.Id
left join dbo.Object o on o.Id = oc.Object_Id
left join dbo.Address a on a.Id = o.Address_Id
where a.Name is not null