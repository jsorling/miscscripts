create procedure AddAuthorityByIdName
  @cardid nvarchar(10),
  @authority nvarchar(65),
  @customer nvarchar(65)
as begin
 declare @ui int = (select top 1 u.Id from dbo.Users u where u.Card = @cardid)
 declare @auth int = (select top 1 a.Id from dbo.Authority a where a.Name = @authority)

 if @ui is null begin
     declare @custid int = (select top 1 c.Id from dbo.Customer c where c.Name = @customer)
     if @custid is not null begin
       insert into dbo.Users([Name], [Code], [Card], [Blocked], [customerId])
       values('', '', @cardid, 0, @custid)
       set @ui = (select top 1 u.Id from dbo.Users u where u.Card = @cardid)
       print  @cardid + ' - created' 
     end else begin 
       print @customer + ' - not found'
     end
 end
 
 if @ui is null begin
   print @cardid + ' - not found'  
 end else if @auth is null begin
   print @authority + ' not found'
 end else if exists(select au.Id from dbo.AuthorityInUser au where au.AuthorityId = @auth and au.UserId = @ui) begin
   print @cardid + '-' + @authority + ' already set'
 end else begin   
   insert into AuthorityInUser ([UserId], [AuthorityId], [flags], [removedDate],
    [start], [stop], [ObjectInCustomer_Id], [FastApiGuid], [Version])
   values (@ui, @auth, 0, null, null, null, null, null, 0)
   print @cardid + '-' + @authority + ' added'
 end  
end