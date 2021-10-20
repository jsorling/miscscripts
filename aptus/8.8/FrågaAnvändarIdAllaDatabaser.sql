use master

declare @card varchar(12) = '123456789'
declare @dbsearch nvarchar (65) = '%s_STH%'

select 'select  Card, ''' + name + ''' [DB] from ' + name + '.dbo.Users where Card = ''' + @card + ''';' 
from sys.databases where name like @dbsearch