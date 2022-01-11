declare @types table(type1 smallint, type2 tinyint, func smallint, typetext nvarchar (65), functext nvarchar(65))
insert @types (type1, type2, func, typetext, functext)
values (1, 0, 0, 'Ing�ng', 'Anv�nds ej')
	, (1, 0, 28, 'Ing�ng', 'L�sstatus')
	, (1, 1, 0, 'Sabotagekontakt', 'Anv�nds ej')
	, (2, 0, 0, 'Utg�ng', 'Anv�nds ej')
	, (2, 2, 0, 'Summer', 'Anv�nds ej')
	, (2, 2, 4, 'Summer', 'F�rlarm')
	, (2, 3, 0, 'Utg�ng (Baskort/AX)', 'Anv�nds ej')
	, (2, 3, 1, 'Utg�ng (Baskort/AX)', 'L�s�ppning')
	, (2, 4, 0, 'Utg�ng (Koppla)', 'Anv�nds ej')
	, (2, 4, 1, 'Utg�ng (Koppla)', 'L�s�ppning')
	, (2, 4, 9, 'Utg�ng (Koppla)', 'Tv�ttstuga')
	, (2, 4, 10, 'Utg�ng (Koppla)', 'Startknapp')
	, (2, 6, 0, 'R�d lysdiod', 'Anv�nds ej')
	, (2, 6, 7, 'R�d lysdiod', 'R�d lysdiod')
	, (2, 5, 0, 'Gr�n lysdiod', 'Anv�nds ej')
	, (2, 5, 8, 'Gr�n lysdiod', 'Gr�n lysdiod')
	, (2, 7, 0, 'Utg�ng (L�sa L�s�ppning)', 'Anv�nds ej')
	, (2, 7, 1, 'Utg�ng (L�sa L�s�ppning)', 'L�s�ppning')
	, (2, 10, 0, 'Bakgrundsbelysning', 'Anv�nds ej')
	, (2, 10, 12, 'Bakgrundsbelysning', 'Bakgrundsbelysning')
	, (3, 0, 0, 'Balanserad ing�ng', 'Anv�nds ej')
	, (3, 12, 0, 'Balanserad ing�ng (Koppla)', 'Anv�nds ej')
	, (3, 12, 21, 'Balanserad ing�ng (Koppla)', 'Aktivera tidzon')
	, (3, 12, 22, 'Balanserad ing�ng (Koppla)', 'D�rrkontakt')
	, (3, 12, 28, 'Balanserad ing�ng (Koppla)', 'L�sstatus')
	, (7, 0, 0, 'Tangentbord', 'Anv�nds ej')
	, (7, 0, 1000, 'Tangentbord', 'Anv�nds')
	, (8, 0, 0, 'Ber�ringsfri l�sare', 'Anv�nds ej')
	, (8, 0, 1000, 'Ber�ringsfri l�sare', 'Anv�nds')
	, (15, 0, 0, 'Porttelefon med display', 'Anv�nds ej')
	, (15, 0, 1000, 'Porttelefon med display', 'Anv�nds')
	, (17, 0, 0, 'Bokningspanel', 'Anv�nds ej')
	, (17, 0, 1000, 'Bokningspanel', 'Anv�nds')
	, (18, 0, 0, 'Repeater', 'Anv�nds ej')
	, (19, 0, 0, 'Telefonv�xel', 'Anv�nds ej')
	, (900, 0, 0, 'Larmf�rbikopplingsgrupp', 'Anv�nds ej')
	, (1001, 0, 0, 'D�rr', 'Anv�nds ej')
	, (1001, 0, 1000, 'D�rr', 'Anv�nds')
	, (1003, 0, 1000,'Bokningsgrupp', 'Bokning')

select d.Name Dom�n
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