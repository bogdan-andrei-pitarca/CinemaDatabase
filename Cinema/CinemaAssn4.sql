use Cinema_LAB1

-- create some tables in order to test the performance of my design

create table Ratings(
	rId int primary key,
	review varchar(200) not null
)

create table TicketType (
    ttId int primary key,
    typeName varchar(100) not null
)


create table ScreeningTypes (
    sId int primary key,
    ticketTypeId int not null,
    description varchar(200) not null,
    foreign key (ticketTypeId) references TicketType(ttId)
)

create table Sales (
    screeningTypeId int not null,
    saleDate date not null,
    nrSold int not null,
    revenue decimal(10, 2) not null,
    primary key (screeningTypeId, saleDate),
    foreign key (screeningTypeId) references ScreeningTypes(sId)
)

-- predefined SQL script, used to create and ensure the assignment's relational structure

if exists (select * from dbo.sysobjects where id = object_id(N'[FK_TestRunTables_Tables]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)

ALTER TABLE [TestRunTables] DROP CONSTRAINT FK_TestRunTables_Tables

GO



if exists (select * from dbo.sysobjects where id = object_id(N'[FK_TestTables_Tables]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)

ALTER TABLE [TestTables] DROP CONSTRAINT FK_TestTables_Tables

GO



if exists (select * from dbo.sysobjects where id = object_id(N'[FK_TestRunTables_TestRuns]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)

ALTER TABLE [TestRunTables] DROP CONSTRAINT FK_TestRunTables_TestRuns

GO



if exists (select * from dbo.sysobjects where id = object_id(N'[FK_TestRunViews_TestRuns]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)

ALTER TABLE [TestRunViews] DROP CONSTRAINT FK_TestRunViews_TestRuns

GO



if exists (select * from dbo.sysobjects where id = object_id(N'[FK_TestTables_Tests]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)

ALTER TABLE [TestTables] DROP CONSTRAINT FK_TestTables_Tests

GO



if exists (select * from dbo.sysobjects where id = object_id(N'[FK_TestViews_Tests]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)

ALTER TABLE [TestViews] DROP CONSTRAINT FK_TestViews_Tests

GO



if exists (select * from dbo.sysobjects where id = object_id(N'[FK_TestRunViews_Views]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)

ALTER TABLE [TestRunViews] DROP CONSTRAINT FK_TestRunViews_Views

GO



if exists (select * from dbo.sysobjects where id = object_id(N'[FK_TestViews_Views]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)

ALTER TABLE [TestViews] DROP CONSTRAINT FK_TestViews_Views

GO



if exists (select * from dbo.sysobjects where id = object_id(N'[Tables]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)

drop table [Tables]

GO



if exists (select * from dbo.sysobjects where id = object_id(N'[TestRunTables]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)

drop table [TestRunTables]

GO



if exists (select * from dbo.sysobjects where id = object_id(N'[TestRunViews]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)

drop table [TestRunViews]

GO



if exists (select * from dbo.sysobjects where id = object_id(N'[TestRuns]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)

drop table [TestRuns]

GO



if exists (select * from dbo.sysobjects where id = object_id(N'[TestTables]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)

drop table [TestTables]

GO



if exists (select * from dbo.sysobjects where id = object_id(N'[TestViews]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)

drop table [TestViews]

GO



if exists (select * from dbo.sysobjects where id = object_id(N'[Tests]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)

drop table [Tests]

GO



if exists (select * from dbo.sysobjects where id = object_id(N'[Views]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)

drop table [Views]

GO

-- this holds the data about tables that can take part in tests

CREATE TABLE [Tables] (

	[TableID] [int] IDENTITY (1, 1) NOT NULL ,

	[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 

) ON [PRIMARY]

GO

-- contains performance data for INSERT operations for each table in each test run

CREATE TABLE [TestRunTables] (

	[TestRunID] [int] NOT NULL ,

	[TableID] [int] NOT NULL ,

	[StartAt] [datetime] NOT NULL ,

	[EndAt] [datetime] NOT NULL 

) ON [PRIMARY]

GO

-- contains performance data for each view in each test run

CREATE TABLE [TestRunViews] (

	[TestRunID] [int] NOT NULL ,

	[ViewID] [int] NOT NULL ,

	[StartAt] [datetime] NOT NULL ,

	[EndAt] [datetime] NOT NULL 

) ON [PRIMARY]

GO

-- contains data about different test runs
-- a test can be run multiple times. it involves:
/*
	- deleting the data from test T’s tables, in the order specified by the Position field in table TestTables;
	- inserting data into test T’s tables in reverse deletion order; the number of records to insert into each table is stored in the NoOfRows field in table TestTables;
	- evaluating test T’s views;
*/

CREATE TABLE [TestRuns] (

	[TestRunID] [int] IDENTITY (1, 1) NOT NULL ,

	[Description] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,

	[StartAt] [datetime] NULL ,

	[EndAt] [datetime] NULL 

) ON [PRIMARY]

GO

-- junction table between Tests and Tables (which tables take part in which tests)

CREATE TABLE [TestTables] (

	[TestID] [int] NOT NULL ,

	[TableID] [int] NOT NULL ,

	[NoOfRows] [int] NOT NULL ,

	[Position] [int] NOT NULL 

) ON [PRIMARY]

GO

-- junction table between Tests and Views (which views take part in which tests)

CREATE TABLE [TestViews] (

	[TestID] [int] NOT NULL ,

	[ViewID] [int] NOT NULL 

) ON [PRIMARY]

GO

-- holds data about different tests

CREATE TABLE [Tests] (

	[TestID] [int] IDENTITY (1, 1) NOT NULL ,

	[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 

) ON [PRIMARY]

GO

-- holds data about a set of views from the DB, used to assess the performance of certain SQL queries

CREATE TABLE [Views] (

	[ViewID] [int] IDENTITY (1, 1) NOT NULL ,

	[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 

) ON [PRIMARY]

GO



ALTER TABLE [Tables] WITH NOCHECK ADD 

	CONSTRAINT [PK_Tables] PRIMARY KEY  CLUSTERED 

	(

		[TableID]

	)  ON [PRIMARY] 

GO



ALTER TABLE [TestRunTables] WITH NOCHECK ADD 

	CONSTRAINT [PK_TestRunTables] PRIMARY KEY  CLUSTERED 

	(

		[TestRunID],

		[TableID]

	)  ON [PRIMARY] 

GO



ALTER TABLE [TestRunViews] WITH NOCHECK ADD 

	CONSTRAINT [PK_TestRunViews] PRIMARY KEY  CLUSTERED 

	(

		[TestRunID],

		[ViewID]

	)  ON [PRIMARY] 

GO



ALTER TABLE [TestRuns] WITH NOCHECK ADD 

	CONSTRAINT [PK_TestRuns] PRIMARY KEY  CLUSTERED 

	(

		[TestRunID]

	)  ON [PRIMARY] 

GO



ALTER TABLE [TestTables] WITH NOCHECK ADD 

	CONSTRAINT [PK_TestTables] PRIMARY KEY  CLUSTERED 

	(

		[TestID],

		[TableID]

	)  ON [PRIMARY] 

GO



ALTER TABLE [TestViews] WITH NOCHECK ADD 

	CONSTRAINT [PK_TestViews] PRIMARY KEY  CLUSTERED 

	(

		[TestID],

		[ViewID]

	)  ON [PRIMARY] 

GO



ALTER TABLE [Tests] WITH NOCHECK ADD 

	CONSTRAINT [PK_Tests] PRIMARY KEY  CLUSTERED 

	(

		[TestID]

	)  ON [PRIMARY] 

GO



ALTER TABLE [Views] WITH NOCHECK ADD 

	CONSTRAINT [PK_Views] PRIMARY KEY  CLUSTERED 

	(

		[ViewID]

	)  ON [PRIMARY] 

GO



ALTER TABLE [TestRunTables] ADD 

	CONSTRAINT [FK_TestRunTables_Tables] FOREIGN KEY 

	(

		[TableID]

	) REFERENCES [Tables] (

		[TableID]

	) ON DELETE CASCADE  ON UPDATE CASCADE ,

	CONSTRAINT [FK_TestRunTables_TestRuns] FOREIGN KEY 

	(

		[TestRunID]

	) REFERENCES [TestRuns] (

		[TestRunID]

	) ON DELETE CASCADE  ON UPDATE CASCADE 

GO



ALTER TABLE [TestRunViews] ADD 

	CONSTRAINT [FK_TestRunViews_TestRuns] FOREIGN KEY 

	(

		[TestRunID]

	) REFERENCES [TestRuns] (

		[TestRunID]

	) ON DELETE CASCADE  ON UPDATE CASCADE ,

	CONSTRAINT [FK_TestRunViews_Views] FOREIGN KEY 

	(

		[ViewID]

	) REFERENCES [Views] (

		[ViewID]

	) ON DELETE CASCADE  ON UPDATE CASCADE 

GO



ALTER TABLE [TestTables] ADD 

	CONSTRAINT [FK_TestTables_Tables] FOREIGN KEY 

	(

		[TableID]

	) REFERENCES [Tables] (

		[TableID]

	) ON DELETE CASCADE  ON UPDATE CASCADE ,

	CONSTRAINT [FK_TestTables_Tests] FOREIGN KEY 

	(

		[TestID]

	) REFERENCES [Tests] (

		[TestID]

	) ON DELETE CASCADE  ON UPDATE CASCADE 

GO



ALTER TABLE [TestViews] ADD 

	CONSTRAINT [FK_TestViews_Tests] FOREIGN KEY 

	(

		[TestID]

	) REFERENCES [Tests] (

		[TestID]

	),

	CONSTRAINT [FK_TestViews_Views] FOREIGN KEY 

	(

		[ViewID]

	) REFERENCES [Views] (

		[ViewID]

	)

GO

-- procedure to add data to [Tables]

create or alter procedure addToTables (@tableName varchar(200)) 
as
	if @tableName in (select Name from Tables)
		begin
			raiserror('Table already exists!', 16, 1)
			return
		end
	if @tableName not in (select TABLE_NAME from INFORMATION_SCHEMA.TABLES) 
		begin
			raiserror ('No such table!', 16 , 1)
			return
		end
	insert into Tables (Name) values (@tableName)
go

-- procedure to add data to [Views]

create or alter proc addToViews (@viewName varchar(200))
as
	if @viewName in (select Name from Views) 
		begin
			raiserror ('View already exists!', 16, 1)
			return
		end
	if @viewName not in (select TABLE_NAME from INFORMATION_SCHEMA.VIEWS)
		begin
			raiserror ('No such view!', 16, 1)
			return
		end
	insert into Views (Name) values (@viewName)
go

-- procedure to add data to [Tests]

create or alter proc addToTests (@testName varchar(200))
as
	if @testName in (select Name from Tests)
		begin
			raiserror ('Test already exists!', 16, 1)
			return
		end
	insert into Tests (Name) values (@testName)
go

-- procedure that takes care of the junction between [Tables] and [Tests]

create or alter proc junctionTableTest (@tableName varchar(200), @testName varchar(200), @rows int, @position int)
as
	if @tableName not in (select Name from Tables)
		begin
			raiserror('No such table', 16, 1)
			return
		end
	if @testName not in (select Name from Tests)
		begin
			raiserror ('No such test', 16, 1)
			return
		end
	if exists(
		select *
		from TestTables T1 join Tests T2 on T1.TestID = T2.TestID
		where T2.Name = @testName and Position = @position)
			begin
				raiserror ('Position confliction', 16, 1)
				return
			end
		insert into TestTables (TestID, TableId, NoOfRows, Position) values(
			(select Tests.TestID from Tests where Name = @testName),
			(select Tables.TableID from Tables where Name = @tableName),
			@rows,
			@position)
go


-- procedure that takes care of the junction between [Views] and [Tests]

create or alter proc junctionViewTest (@viewName varchar(200), @testName varchar(200))
as
	if @viewName not in (select Name from Views)
		begin
			raiserror ('No such view!', 16, 1)
			return
		end
	if @testName not in (select Name from Tests)
		begin
			raiserror ('No such test!', 16, 1)
			return
		end
	insert into TestViews (TestID, ViewID) values(
		(select Tests.TestID from Tests where Name = @testName),
		(select Views.ViewID from Views where NAme = @viewName)
	)
go

-- procedure to run a test

create or alter proc runTest (@testName varchar(200))
as
	-- raise error if the test name not defined
	if @testName not in (select Name from Tests)
		begin
			raiserror('Test not in Tests', 16, 1)
			return
		end
	declare @command varchar(100), @testStartTime datetime2, @startTime datetime2, @endTime datetime2, @table varchar(200), @rows int,
	@pos int, @view varchar(200), @testId int
	select @testId = TestID from Tests where Name = @testName

	declare @testRunId int
	set @testRunId = ISNULL((select max(TestRunID) + 1 from TestRuns), 0)

	declare tableCursor cursor scroll for
		select T1.Name, T2.NoOfRows, T2.Position
		from Tables T1 join TestTables T2 on T1.TableID = T2.TableID
		where T2.TestID = @testId
		order by T2.Position
	
	declare viewCursor cursor for
		select V.Name
		from Views V join TestViews TV on V.ViewID = TV.ViewID
		where TV.TestID = @testId

	set @testStartTime = SYSDATETIME()
	-- deleting the data from test T’s tables, in the order specified by the Position field in table TestTables;
	open tableCursor
	fetch last from tableCursor into @table, @rows, @pos
	while @@FETCH_STATUS = 0 begin
		exec ('delete from ' + @table)
		fetch prior from tableCursor into @table, @rows, @pos
	end
	close tableCursor

	-- inserting data into test T’s tables in reverse deletion order;
	-- the number of records to insert into each table is stored in the NoOfRows field in table TestTables;
	open tableCursor
	set identity_insert TestRuns on
	insert into TestRuns(TestRunID, Description, StartAt)
	values (@testRunId, 'Test eval for: ' + @testName, @testStartTime)
	set identity_insert TestRuns off
	fetch tableCursor into @table, @rows, @pos
	while @@FETCH_STATUS = 0 
	begin
		set @command = 'addTo' + @table
		if @command not in
			(select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES)
		begin
			raiserror ('Command does not exist', 16, 1)
			return
		end

		set @startTime = SYSDATETIME()
		exec @command @rows
		set @endTime = SYSDATETIME()

		insert into TestRunTables(TestRunID, TableId, StartAt, EndAt)
		values (@testRunId, (select TableID from Tables where Name = @table), @startTime, @endTime)
		fetch tableCursor into @table, @rows, @pos
	end

	close tableCursor
	deallocate tableCursor

	-- evaluating test T’s views;
	open viewCursor
	fetch viewCursor into @view
	while @@FETCH_STATUS = 0
	begin
		set @command = 'select * from ' + @view
		set @startTime = SYSDATETIME()
		exec (@command)
		set @endTime = SYSDATETIME()
		insert into TestRunViews (TestRunID, ViewID, StartAt, EndAt)
		values (@testRunId, (select ViewID from Views where Name = @view), @startTime, @endTime)
		fetch viewCursor into @view
	end

	close viewCursor
	deallocate viewCursor

	update TestRuns
	set EndAt = SYSDATETIME()
	where TestRunID = @testRunId
go

-- first test

create or alter proc addToRatings(@rows int) as
	declare @i int
	set @i = 0
	while @i < @rows begin
		insert into Ratings values(@i, 'Rating nr ' + cast(@i as varchar(200)))
		set @i = @i + 1
	end
go

create view ratingsView as
	select * from Ratings
go

exec addToTables 'Ratings'
exec addToViews 'ratingsView'
exec addToTests 'Test1'
exec junctionTableTest 'Ratings', 'Test1', 1000, 1
exec junctionViewTest 'ratingsView', 'Test1'
exec runTest 'Test1'
go

drop proc runTest

-- second test
go
create or alter proc addToTicketType(@rows int) as
	declare @i int
	set @i = 0
	while @i < @rows begin
		insert into TicketType values (@i, 'Name ' + cast(@i as varchar(100)))
		set @i = @i + 1
	end
go

delete from TicketType
exec addToTicketType 30
select * from TicketType
go

go
create or alter proc addToScreeningTypes(@rows int) as
	delete from ScreeningTypes
	declare @i int
	set @i = 0
	while @i < @rows begin
		insert into ScreeningTypes values(@i, @i, 'Description ' + cast(@i as varchar(200)))
		set @i = @i + 1
	end
go

exec addToScreeningTypes 30
select * from ScreeningTypes

go
create or alter view screeningTypesView as
	select sId as 'Screening Type Id', typeName as 'Ticket Type'
	from ScreeningTypes S inner join TicketType T
	on S.ticketTypeId = T.ttId
go

select * from screeningTypesView
go

exec addToTests 'Test2'
exec addToTables 'TicketType'
exec addToTables 'ScreeningTypes'

exec addToViews 'screeningTypesView'

exec junctionTableTest 'TicketType', 'Test2', 1000, 2
exec junctionTableTest 'ScreeningTypes', 'Test2', 1000, 3

exec junctionViewTest 'screeningTypesView', 'Test2'
go
exec runTest 'Test2'
go

-- third test

create or alter proc addToSales(@rows int) as
	declare @i int
	set @i = 0
	while @i < @rows begin
		insert into Sales values (@i, dateadd(day, @i, '2024-01-01'), @i, cast(@i as decimal(10, 2)))
		set @i = @i + 1
	end
go

create or alter view salesView as
	select ST.description as 'Description',
	TT.typeName as 'Ticket Type',
	sum(S.nrSold) as 'Total Tickets Sold',
	sum(S.revenue) as 'Total Revenue'
	from sales S inner join ScreeningTypes ST on S.screeningTypeId = ST.sId
	inner join TicketType TT on St.ticketTypeId = TT.ttId
	group by ST.description, TT.typeName
go


exec addToTables 'Sales'

exec addToViews 'salesView'

exec addToTests 'Test3'

exec junctionTableTest 'TicketType', 'Test3', 1000, 4
exec junctionTableTest 'ScreeningTypes', 'Test3', 1000, 5
exec junctionTableTest 'Sales', 'Test3', 1000, 6

exec junctionViewTest 'salesView', 'Test3'

exec runTest 'Test3'

-- view the results of the tests
select * from TestRuns
select * from TestRunTables
select * from TestRunViews