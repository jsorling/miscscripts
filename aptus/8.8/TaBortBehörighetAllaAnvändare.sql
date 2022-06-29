declare @auth nvarchar (65) = 'BehörighetX'
declare @aid int = (select a.id from Authority a where a.Name = @auth)

delete from dbo.AuthorityInUser where AuthorityId = @aid
