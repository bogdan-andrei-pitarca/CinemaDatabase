use Cinema_LAB1

/*
	Welcome to my Cinema database!

	- each movie can have multiple trailers, but a trailer can only belong to a single movie => 1:n
	- each movie can have multiple reviews, but a review can only belong to a single movie => 1:n
	- each director can direct multiple movies, but a movie can only have one director => 1:n
	- each movie has multiple actors, and an actor can belong to multiple movies => m:n (junction table is Casting)
	- each cinema can screen multiple movies, and a movie can be shown in multiple cinemas => m:n (junction table is Showings)
	- a showing has multiple tickets, but a ticket can only belong to one showing => 1:n
*/

-- directors table
create table Director(
	dId int primary key,
	dName varchar(200) NOT NULL,
	nationality varchar(200) NOT NULL
)

-- actors table
create table Actor(
	aId int primary key,
	name varchar(200) not null,
	nationality varchar(200) not null
)

-- cinemas table
create table Cinema(
	cId int primary key,
	name varchar(200) not null,
	location varchar(200) not null
)

-- movies table
create table Movie(
	mId int primary key,
	dId int foreign key REFERENCES Director,
	yearOfRelease int NOT NULL check (yearofRelease > 1888),
)

-- trailers table
create table Trailer(
	tId int primary key,
	mId int foreign key REFERENCES Movie,
	nrOfLikes int,
)

-- reviews table
create table Review(
	rId int primary key,
	mId int foreign key REFERENCES Movie,
	criticName varchar(200),
	opinion varchar(200),
	stars decimal(2,1) check (stars < 10 AND stars > 0)
)

-- showings table
create table Showings(
	sId int primary key,
	cId int foreign key references Cinema,
	mId int foreign key references Movie,
	dateOfShowing date not null check (dateOfShowing >= getDate()),
	timeOfShowing time not null
)

-- castings table
create table Casting(
	castId int primary key,
	mId int foreign key references Movie,
	aId int foreign key references Actor,
	role varchar(200) not null,
	salary decimal(7,2) NOT NULL check (salary > 0)
)

-- viewers table
create table Viewer(
	vId int primary key,
	name varchar(200) not null
)

-- tickets table
create table Ticket(
	tId int primary key,
	sId int foreign key references Showings,
	seat int not null check (seat > 0),
	price decimal(4,2) not null check (price > 0)
)