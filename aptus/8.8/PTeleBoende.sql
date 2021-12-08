select 
    o.Name [Lägenhet]
  , o.ApartmentNo [Lägenhetsnummer]
  , a.Name [Adress]
  , c.Name [Boende]
  , cp.FirstName [Förnamn]
  , cp.Surname [Efternamn]
  , cp.PhoneNumber [Telefonnummer]
  , case when coalesce(cp.SortOrder, 0) = 0 
      then cp.EntryPhoneCallCode 
    else o.EntryPhoneCallCode 
    end Anropskod
  , coalesce(cast(cp.SortOrder as nvarchar(10)), 'Extra') [Namnordning]
from dbo.Object o
inner join dbo.ObjectInCustomer oc on oc.Object_Id = o.Id
inner join dbo.Address a on a.Id = o.Address_Id
inner join dbo.Customer c on c.Id = oc.Customer_Id
left join dbo.CustomerPerson cp on cp.ObjectInCustomer_Id = oc.Id
order by a.Name, o.Name, coalesce(cp.SortOrder, 100)