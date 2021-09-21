select
  s.Name [SystemNamn]
  ,case when c.Address = 0 then 'Master' else 'Slav ' + cast(c.Address as nvarchar (3)) end + ' - ' + c.Name [CentralNamn]
  ,b.Name [EnhetsNamn]
  ,b.Description as [EnhetsTyp]
  ,r.Name [ResursNamn]
  ,r.Address [Adress]
  ,r.Type [Typ]
  ,r.Func [Funktion]
  ,r.Doors [Dörrar]
  ,r.Flags [Flaggor]
  ,b.Serial
from dbo.Control c
inner join dbo.System s ON c.SystemId = s.Id
inner join dbo.Board b ON b.ControlId = c.Id
left join dbo.Resource r on r.BoardId = b.Id
order by s.Name
  , c.Address
  , b.Address
  , case when r.Address > 1000 then 0 else 1 end
  , case when r.Type = 2 then 0 else 1 end
  , r.Address