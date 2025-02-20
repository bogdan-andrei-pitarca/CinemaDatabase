use Cinema_LAB1

/*
create a versioning mechanism that 
allows the user to easily switch between DB versions
*/

create table EmployeeSchedules(
	scheduleId int primary key,
	eId int not null,
	cId int foreign key references Cinema(cId),
	shiftStart datetime not null,
	shiftEnd datetime not null,
	constraint chk_shift_end check (shiftEnd > shiftStart),
	unique(eId, shiftStart, shiftEnd)
)

alter table EmployeeSchedules
add tipsReceived int

alter table EmployeeSchedules
add employeeRole varchar(200)

alter table EmployeeSchedules
add constraint UQ_EmployeeSchedules_eId unique(eId);

-- a) modify the type of a column (+ undo)

go
create or alter proc USP_ModifyColumn
AS
	begin
		alter table EmployeeSchedules
		alter column tipsReceived float
	end
go

exec USP_ModifyColumn

go
create or alter proc USP_UndoModifyColumn
as
	begin
		alter table EmployeeSchedules
		alter column tipsReceived int
	end
go

exec USP_UndoModifyColumn


-- b) add/remove a column
go
create or alter proc USP_AddColumn
AS
	begin
		alter table EmployeeSchedules
		add overTime time
	end
go

exec USP_AddColumn

go
create or alter proc USP_RemoveColumn
as
	begin
		alter table EmployeeSchedules
		drop column overTime
	end
go

exec USP_RemoveColumn


-- c) add/remove a default constraint

go
create or alter proc USP_AddConstraint
as
	begin
		alter table EmployeeSchedules
		add constraint df_tipsReceived default 0 for tipsReceived
	end
go

exec USP_AddConstraint

go
create or alter proc USP_RemoveConstraint
as
	begin
		alter table EmployeeSchedules
		drop constraint df_tipsReceived
	end
go

exec USP_RemoveConstraint

-- d) add/remove a primary key

go
create or alter proc USP_RemovePrimaryKey
as
	begin
		alter table EmployeeSchedules
		drop constraint PK__Employee__A532EDD40174AD6A
	end
go

exec USP_RemovePrimaryKey

go
create or alter proc USP_AddPrimaryKey
as
	begin
		alter table EmployeeSchedules
		add constraint PK__Employee__A532EDD40174AD6A primary key(scheduleId)
	end
go

exec USP_AddPrimaryKey

-- e) add/remove a candidate key

go
create or alter proc USP_RemoveCandidateKey
as
	begin
		alter table EmployeeSchedules
		drop constraint UQ__Employee__7E7AE869AAFFFCA8
	end
go

exec USP_RemoveCandidateKey

go
create or alter proc USP_AddCandidateKey
as
	begin
		alter table EmployeeSchedules
		add constraint UQ__Employee__7E7AE869AAFFFCA8 unique(eId, shiftStart, shiftEnd)
	end
go

exec USP_AddCandidateKey

-- f) add/remove a foreign key

go
create or alter proc USP_RemoveForeignKey
as
	begin
		alter table EmployeeSchedules
		drop constraint FK__EmployeeSch__cId__03F0984C
	end
go

exec USP_RemoveForeignKey

go
create or alter proc USP_AddForeignKey
as
	begin
		alter table EmployeeSchedules
		add constraint FK__EmployeeSch__cId__03F0984C foreign key(cId) references Cinema(cId)
	end
go

exec USP_AddForeignKey

-- g) create/drop a table

go
create or alter proc USP_CreateTable
as
	begin
		create table EmployeePerformance(
			pId int primary key,
			eId int not null foreign key references EmployeeSchedules(eId),
			reviewDate date not null,
			score decimal(4,2) not null check(score between 0 and 100),
			feedback varchar(200)
		)
	end
go

exec USP_CreateTable

go
create or alter proc USP_DropTable
as
	begin
		drop table EmployeePerformance
	end
go

exec USP_DropTable

go

-- create a procedure table, that holds all of the above procedures, along with their corresponding version
-- (e.g: we modify a column - we go from version 0 to 1; we undo the modify - we go from 1 to 0, so on so forth)

create table ProcTable(
	oldVersion int,
	newVersion int,
	procName varchar(200)
	)


insert into ProcTable
values(0, 1, 'USP_ModifyColumn'),       
      (1, 0, 'USP_UndoModifyColumn'),    
      (1, 2, 'USP_AddColumn'),           
      (2, 1, 'USP_RemoveColumn'),        
      (2, 3, 'USP_AddConstraint'),       
      (3, 2, 'USP_RemoveConstraint'),    
      (3, 4, 'USP_RemovePrimaryKey'),    
      (4, 3, 'USP_AddPrimaryKey'),       
      (4, 5, 'USP_RemoveCandidateKey'),  
      (5, 4, 'USP_AddCandidateKey'),     
      (5, 6, 'USP_RemoveForeignKey'),    
      (6, 5, 'USP_AddForeignKey'),       
      (6, 7, 'USP_CreateTable'),         
      (7, 6, 'USP_DropTable')

-- table that memorizes the current version

create table Versions(
	version int primary key
	)

insert into Versions
values (0)

/*
	This procedure receives as a parameter the version number,
	and allows us to bring the database to that version.
*/

go
create or alter proc BringToVersion(@version int)
as
	begin
		declare @currentVersion int
		declare @procName varchar(200)

		-- select the current version (from the Versions table)
		select @currentVersion = version from Versions

		-- raise an error if the version is not between 0 and 7
		if @version < 0 or @version > 7
			begin
				raiserror('Invalid data!', 16, 1)
				return
			end

		-- if the version we want to bring our DB to is greater than the current version, we do the following:
		while @currentVersion < @version
			begin
				-- get the corresponding procedure from our ProcTable
				-- change the version step by step, increment the current version
				-- execute the procedure
				-- update the versions table
				select @procName = procName from ProcTable
				where oldVersion = @currentVersion and newVersion = @currentVersion + 1

				exec @procName

				set @currentVersion = @currentVersion + 1

				update Versions
				set version = @currentVersion
				-- until the current version is equal to the one we want to bring it to
			end

		-- otherwise, we use the same logic, but apply it in reverse order
		while @currentVersion > @version 
			begin
				select @procName = procName from ProcTable
				where oldVersion = @currentVersion and newVersion = @currentVersion - 1

				exec @procName

				set @currentVersion = @currentVersion - 1
				
				update Versions
				set version = @currentVersion
			end
		end
go


exec BringToVersion @version = 3

