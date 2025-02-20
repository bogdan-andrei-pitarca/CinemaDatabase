use Cinema_LAB1

alter table Movie
add title varchar(200) 

alter table Movie
add genre varchar(200) not null

alter table Actor
add dateOfBirth date check (dateOfBirth < getDate())

alter table Director
add dateOfBirth date check (dateOfBirth < getDate())

ALTER TABLE Actor
DROP CONSTRAINT CK__Actor__dateOfBir__6E01572D;

alter table Director
drop constraint CK__Director__dateOf__6EF57B66;

alter table Actor
drop column dateOfBirth;

alter table Actor
add yearOfBirth int check (yearOfBirth > 1888 and yearOfBirth <= 2024);

alter table Director
drop column dateOfBirth;

alter table Director
add yearOfBirth int check (yearOfBirth > 1888);

-- inserts

insert into Director(dId, dName, nationality, yearOfBirth)
values (1, 'Christopher Nolan', 'British-American', 1970),
(2, 'James Cameron', 'Canadian', 1954),
(3, 'Lana Wachowski', 'American', 1965),
(4, 'Bong Joon-ho', 'South Korean', 1969);

insert into Director(dId, dName, nationality, yearOfBirth)
values (5, 'David Fincher', 'American', 1962),   
       (6, 'Quentin Tarantino', 'American', 1963),
       (7, 'Alejandro González Iñárritu', 'Mexican', 1963); 

insert into Actor(aId, name, nationality, yearOfBirth)
values (1, 'Leonardo DiCaprio', 'American', 1974),
(2, 'Christian Bale', 'British', 1974),
(3, 'Keanu Reeves', 'Canadian', 1964),
(4, 'Kate Winslet', 'British', 1975),
(5, 'Song Kang-ho', 'South Korean', 1967);

insert into Movie(mId, title, dId, yearOfRelease, genre)
values (1, 'Inception', 1, 2010, 'Science Fiction'),
(2, 'The Dark Knight', 1, 2008, 'Action'),
(3, 'Titanic', 2, 1997, 'Romance'),
(4, 'The Matrix', 3, 1999, 'Science Fiction'),
(5, 'Parasite', 4, 2019, 'Thriller');

insert into Review(rId, mId, criticName, opinion, stars)
values (1, 1, 'Pitarca Bogdan', 'Absolutely superb. Mind-bending.', 5),
(2, 2, 'Popescu Ciprian', 'The best superhero movie ever.', 5),
(3, 3, 'Crisciu Dario', 'A tragic love story and a renowned classic.', 4),
--(4, 15, 'Pop Andreea', 'Outstanding visual effects. Paved the way for many films.', 4),
(5, 5, 'Pintea Vlad', 'Sharp, suspenseful, scary and yet funny. Relevant for current times.', 5);

insert into Review(rId, mId, criticName, opinion, stars)
values (6, 5, null, null, 4);

insert into Review(rId, mId, criticName, opinion, stars)
values (7, 4, 'Crisan Cosmin', 'Kinda bad lol', 2)

insert into Trailer(tId, mId, nrOfLikes)
values (1, 1, 15000),
(2, 1, 17000),
(3, 2, 20000),
(4, 3, 30000),
(5, 4, 25000);

insert into Casting (castId, mId, aId, role, salary)
values 
    (1, 1, 1, 'Dom Cobb', 20000000),    -- Leonardo DiCaprio
    (2, 1, 3, 'Arthur', 12000000),      -- Keanu Reeves
    (3, 2, 2, 'Bruce Wayne / Batman', 15000000), -- Christian Bale
    (4, 3, 1, 'Jack Dawson', 25000000),          -- Leonardo DiCaprio
    (5, 3, 4, 'Rose DeWitt Bukater', 18000000),  -- Kate Winslet
    (6, 4, 3, 'Neo', 15000000),         -- Keanu Reeves
    (7, 5, 5, 'Kim Ki-taek', 10000000); -- Song Kang-ho


insert into Movie(mId, title, dId, yearOfRelease, genre)
values (6, 'Fight Club', 6, 1999, 'Drama'),
       (7, 'Once Upon a Time in Hollywood', 6, 2019, 'Comedy-Drama'),
       (8, 'The Revenant', 1, 2015, 'Adventure');

insert into Actor(aId, name, nationality, yearOfBirth)
values (6, 'Brad Pitt', 'American', 1963),
       (7, 'Margot Robbie', 'Australian', 1990),
       (8, 'Tom Hardy', 'British', 1977);

insert into Casting(castId, mId, aId, role, salary)
values (8, 6, 6, 'Tyler Durden', 17000000),   -- Brad Pitt
    (9, 7, 6, 'Cliff Booth', 15000000),    -- Brad Pitt
    (10, 7, 1, 'Rick Dalton', 20000000),   -- Leonardo DiCaprio 
    (11, 8, 1, 'Hugh Glass', 25000000),    -- Leonardo DiCaprio 
    (12, 8, 8, 'John Fitzgerald', 15000000); -- Tom Hardy


insert into Trailer(tId, mId, nrOfLikes)
values (6, 1, 15000),
(7, 1, 15000),
(8, 3, 30000),
(9, 4, 30000)

-- updates

update Trailer
set nrOfLikes = 20000
where tId = 2;

update Review
set opinion = 'Pretty good'
where criticName is null;

update Movie
set genre = 'Drama'
where title like 'P_%' AND genre = 'Thriller'

-- deletes

delete from Trailer
where nrOfLikes between 24000 and 26000

delete from Review
where stars in (2,3)

delete from Casting
where castId = 2