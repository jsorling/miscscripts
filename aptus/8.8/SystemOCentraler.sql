declare @types table(type1 smallint, type2 tinyint, func smallint, typetext nvarchar (65), functext nvarchar(65))
insert @types (type1, type2, func, typetext, functext)
values (1, 0, 0, 'Ingång', 'Används ej')
	, (1, 0, 28, 'Ingång', 'Låsstatus')
	, (1, 1, 0, 'Sabotagekontakt', 'Används ej')
	, (2, 0, 0, 'Utgång', 'Används ej')
	, (2, 2, 0, 'Summer', 'Används ej')
	, (2, 2, 4, 'Summer', 'Förlarm')
	, (2, 3, 0, 'Utgång (Baskort/AX)', 'Används ej')
	, (2, 3, 1, 'Utgång (Baskort/AX)', 'Låsöppning')
	, (2, 4, 0, 'Utgång (Koppla)', 'Används ej')
	, (2, 4, 1, 'Utgång (Koppla)', 'Låsöppning')
	, (2, 4, 9, 'Utgång (Koppla)', 'Tvättstuga')
	, (2, 4, 10, 'Utgång (Koppla)', 'Startknapp')
	, (2, 6, 0, 'Röd lysdiod', 'Används ej')
	, (2, 6, 7, 'Röd lysdiod', 'Röd lysdiod')
	, (2, 5, 0, 'Grön lysdiod', 'Används ej')
	, (2, 5, 8, 'Grön lysdiod', 'Grön lysdiod')
	, (2, 7, 0, 'Utgång (Låsa Låsöppning)', 'Används ej')
	, (2, 7, 1, 'Utgång (Låsa Låsöppning)', 'Låsöppning')
	, (2, 10, 0, 'Bakgrundsbelysning', 'Används ej')
	, (2, 10, 12, 'Bakgrundsbelysning', 'Bakgrundsbelysning')
	, (3, 0, 0, 'Balanserad ingång', 'Används ej')
	, (3, 12, 0, 'Balanserad ingång (Koppla)', 'Används ej')
	, (3, 12, 21, 'Balanserad ingång (Koppla)', 'Aktivera tidzon')
	, (3, 12, 22, 'Balanserad ingång (Koppla)', 'Dörrkontakt')
	, (3, 12, 28, 'Balanserad ingång (Koppla)', 'Låsstatus')
	, (7, 0, 0, 'Tangentbord', 'Används ej')
	, (7, 0, 1000, 'Tangentbord', 'Används')
	, (8, 0, 0, 'Beröringsfri läsare', 'Används ej')
	, (8, 0, 1000, 'Beröringsfri läsare', 'Används')
	, (15, 0, 0, 'Porttelefon med display', 'Används ej')
	, (15, 0, 1000, 'Porttelefon med display', 'Används')
	, (17, 0, 0, 'Bokningspanel', 'Används ej')
	, (17, 0, 1000, 'Bokningspanel', 'Används')
	, (18, 0, 0, 'Repeater', 'Används ej')
	, (19, 0, 0, 'Telefonväxel', 'Används ej')
	, (900, 0, 0, 'Larmförbikopplingsgrupp', 'Används ej')
	, (1001, 0, 0, 'Dörr', 'Används ej')
	, (1001, 0, 1000, 'Dörr', 'Används')
	, (1003, 0, 1000,'Bokningsgrupp', 'Bokning')

select d.Name Domän
	, s.Name System
	, c.Name Central
	, b.Name Kort
	, b.Description KortTyp
	, b.Serial KortSerieNr
	, r.Name Resurs
	, coalesce(t.typetext, '???') ResursTyp
	, coalesce(t.functext, '???') ResursFunktion
	, (select count(*) from ResourceInTimezone ri where ri.ResourceID = r.Id) IAntalTidzoner
	, (select count(*) from ResourceInBookingObject rb where rb.Resource_Id = r.Id) IAntalBokningsObjekt
	, r.*
	, d.Id DomainId
	, s.Id SystemId
	, b.Id BoardId
	, r.Id ResourceId
from Domain d
left join System s on s.Domain_Id = d.Id
left join Control c on c.SystemId = s.Id
left join Board b on b.ControlId = c.Id
left join Resource r on r.BoardId = b.Id
left join @types t on t.type1 = r.Type and t.type2 = r.SubType and r.Func = t.func
order by s.Name, c.Address, b.Address

-- select distinct Type from Resource