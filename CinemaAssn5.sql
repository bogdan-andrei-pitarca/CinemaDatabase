use Cinema_LAB1
go

-- we create 3 tables of the form:
-- Ta(aid, a2, …), Tb(bid, b2, …), Tc(cid, aid, bid, …), where:
-- aid, bid, cid, a2, b2 are integers;
-- the primary keys are underlined;
-- a2 is UNIQUE in Ta;
-- aid and bid are foreign keys in Tc, referencing the primary keys in Ta and Tb, respectively.

-- Ta
create table Awards(
	aId int primary key,
	awardCode int unique
)

-- Tb
create table FilmFestivals(
	fId int primary key,
	yearEstablished int 
)

-- Tc
create table FestivalWinners(
	fwId int primary key,
	fId int not null references FilmFestivals(fId),
	aId int not null references Awards(aId),
	winnerId int not null references Movie(mId),
	yearWon int not null
)

-- some procedures to add data to our tables
go
create or alter proc addToAwards(@rows int) as
	declare @i int
	set @i = 0
	while @i < @rows begin
		insert into Awards values(@i, @i + 299)
		set @i = @i + 1
	end
go

exec addToAwards 1000

go
create or alter proc addToFilmFestivals(@rows int) as
	declare @i int
	set @i = 0
	while @i < @rows begin
		insert into FilmFestivals values(@i, FLOOR(RAND(CHECKSUM(NEWID())) * (2024 - 1965 + 1)) + 1965)
		set @i = @i + 1
	end
go

exec addToFilmFestivals 1000

go
create or alter proc addToFestivalWinners(@rows int) as
	declare @i int
	set @i = 0
	while @i < @rows begin
		insert into FestivalWinners values(@i, @i, @i, FLOOR(RAND(CHECKSUM(NEWID())) * (8 - 1 + 1)) + 1, FLOOR(RAND(CHECKSUM(NEWID())) * (2024 - 1965 + 1)) + 1965)
		set @i = @i + 1
	end
go

exec addToFestivalWinners 1000




-- clustered index scan

select *
from Awards
order by aId

-- clustered index seek

select *
from Awards
where aId > 500

-- nonclustered index scan

create nonclustered index codeIndex on Awards(awardCode)
go

select * from Awards
order by awardCode desc

-- nonclustered index seek

select * from Awards
where awardCode > 700

-- key lookup


select aId, awardCode from Awards
where awardCode between 300 and 500

-- B) Write a query on table Tb with a WHERE clause of the form WHERE b2 = value and analyze its execution plan. 
-- Create a nonclustered index that can speed up the query. Examine the execution plan again.

select *
from FilmFestivals
where yearEstablished > 2000

-- estimated cost: 0.0058635 (without index)

create nonclustered index indexYear on FilmFestivals(yearEstablished)
drop index indexYear on FilmFestivals
go

-- estimated cost: 0.0037264 (with index)


-- C) Create a view that joins at least 2 tables. Check whether existing indexes are helpful;
-- if not, reassess existing indexes / examine the cardinality of the tables.

go
create or alter view joinTables as
	select 
		ff.fId,
		ff.yearEstablished,
		aw.aId,
		aw.awardCode,
		fw.winnerId,
		fw.yearWon
	from
		FilmFestivals ff join FestivalWinners fw on ff.fId = fw.fId join Awards aw on fw.aId = aw.aId
	where ff.yearEstablished > 1990 and aw.awardcode > 700
go

select * from joinTables


create nonclustered index codeIndex on Awards(awardCode)
drop index codeIndex on Awards

create nonclustered index yearIndex on FilmFestivals(yearEstablished)
drop index yearIndex on FilmFestivals

create nonclustered index fwIndex on FestivalWinners(fId, aId)
drop index winningYearIndex on FestivalWinners


-- cost is slightly higher with indexes