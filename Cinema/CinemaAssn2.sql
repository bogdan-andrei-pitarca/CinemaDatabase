use Cinema_LAB1


-- a
-- this selects the top 20% of movies (ID + title) that are either released
-- before 2000 or have an american / south korean director
select top 20 percent mId, title
from Movie
where dId IN (select dId 
from Director 
where nationality = 'American' or nationality = 'South Korean')
union
select mId, title
from Movie
where yearOfRelease < 2000
order by title asc


-- b
-- select movies (ID + title) that are SF and rated at least 4 stars
SELECT mId, title
FROM Movie 
WHERE genre = 'Science Fiction'
INTERSECT
SELECT mId, title
FROM Movie 
WHERE mId in (select mId from Review where stars >= 4);


-- c
-- select all movies that have neither a 5 star rating, nor a trailer with more than 25000 likes
select mId, title
from Movie 
where mId not in(
	select R.mId
	from Review R
	where R.stars = 5
	)
except
select mId,title
from Movie
where mId in(
	select T.mId
	from Trailer T
	where T.mId <= 25000
	)

-- d

-- inner
-- all distinct nationalities for actors in movies released after 2000
select distinct A.nationality
from Actor A
inner join Casting C on A.aId = C.aId
inner join Movie M on M.mId = C.mId
where M.yearOfRelease > 2000

-- left outer
-- maps all movies to their respective actors and cinemas where they are shown
select M.mId, M.title, A.name AS actor, Ci.name
from Movie M LEFT OUTER JOIN Casting C ON M.mId = C.mId
LEFT OUTER JOIN Actor A ON C.aId = A.aId
LEFT OUTER JOIN Showings S ON M.mId = S.mId
LEFT OUTER JOIN Cinema Ci ON S.cId = Ci.cId;

-- right outer
--maps every trailer to their respective movie
select T.mId, M.title, T.nrOfLikes
from Trailer T RIGHT OUTER JOIN Movie M on T.mId = M.mId

-- full outer
-- maps each movie to its review, ordered by stars
select M.title, R.opinion, R.stars
from Movie M FULL OUTER JOIN Review R on M.mId = R.mId
order by R.stars


-- e
-- select the top 20 percent of all movies directed by directors born in the 60s

select top 20 percent M.mId, M.title
from Movie M
where M.dId in(
	select D.dId
	from Director D
	where D.yearOfBirth between 1960 and 1969
	)

-- actors who have acted in 5 star rated movies
select A.aId, A.name
from Actor A
where A.aId in(
	select C.aId
	from Casting C
	where C.mId in(
		select R.mId
		from Review R
		where R.stars = 5
		)
	)

-- f
-- select actors who acted in movies that received reviews

select A.aId, A.name
from Actor A
where exists(
	select *
	from Casting C
	where C.aId = A.aId and exists(
		select *
		from Review R
		where R.mId = C.mId
		)
	)

-- select movies with actors that were paid more than 15 million dollars for their role

select M.mId, M.title
from Movie M
where exists(
	select *
	from Casting C
	where C.mId = m.mId and C.salary > 15000000
	)

-- g
-- movies w/ american actors
select M.mId, M.title, Actors.aName
from Movie M, (select C.mId, A.name as aName
from Casting C inner join Actor A on C.aId = A.aId
where A.nationality = 'American') as Actors
where M.mId = Actors.mId;

-- average salary for movies w/ reviews
select M.mId, M.title, AVG(SalaryByMovie.salary) as AvgSalary
from Movie M, (select C.mId, C.salary
from Casting C
where exists(select *
from Review R
where R.mId = C.mId)) as SalaryByMovie
where M.mId = SalaryByMovie.mId
group by M.mId, M.title

-- h
-- nr of movies for each genre

select M.genre, COUNT(M.mId) as NrOfMovies
from Movie M
group by m.genre

-- avg salary by movie, for movies w/ total salaries over 20 mil

select M.mId, M.title, avg(C.salary) as Total
from Movie M
inner join Casting C on M.mId = C.mId
group by M.mId, M.title
having sum(C.salary) > 20000000


-- avg salary of actors w/ at least 2 roles

select A.aId, A.name, avg(C.salary) as AvgSalary
from Actor A
inner join Casting C on A.aId = C.aId
group by A.aId, A.name
having (select count(*) 
from Casting Ca
where Ca.aId = A.aId) >= 2

-- movies w/ total above average salaries

select M.mId, M.title, sum(C.salary) as Total
from Movie M
inner join Casting C on M.mId = C.mId
group by M.mId, M.title
having sum(C.salary) 
> 
(select avg(TotalSalary)
from(
select sum(Ca.Salary) as TotalSalary
from Casting Ca
inner join Movie Mo on Ca.mId = Mo.mId
group by Mo.mId) AS AvgSalaries)

-- i
-- get distinct movies w/ trailers that have more likes
-- than all distinct trailers for Inception
select distinct M.mId, M.title
from Movie M
inner join Trailer T on M.mId = T.mId
where T.nrOfLikes > ALL(
	select distinct Tr.nrOfLikes
	from Trailer Tr
	inner join Movie Mo on Tr.mId = Mo.mId
	where Mo.title = 'Inception')

--
select distinct M.mId, M.title
from Movie M
inner join Trailer T on M.mId = T.mId
where T.nrOfLikes > (
	select MAX(Tr.nrOfLikes)
	from Trailer Tr
	inner join Movie Mo on Tr.mId = Mo.mId
	where Mo.title = 'Inception')

-- get actors who have starred in movies w/ trailers that
-- have less likes than all drama movie trailers
select distinct A.aId, A.name
from Actor A
inner join Casting C on A.aId = C.aId
inner join Movie M on C.mId = M.mId
inner join Trailer T on M.mId = T.mId
where T.nrOfLikes < ALL(
	select Tr.nrOfLikes
	from Trailer Tr
	inner join Movie Mo on Tr.mId = Mo.mId
	where Mo.genre = 'Drama'
	)

--
select distinct A.aId, A.name
from Actor A
inner join Casting C on A.aId = C.aId
inner join Movie M on C.mId = M.mId
inner join Trailer T on M.mId = T.mId
where T.nrOfLikes NOT IN (
	select Tr.nrOfLikes
	from Trailer Tr
	inner join Movie Mo on Tr.mId = Mo.mId
	where Mo.genre = 'Drama'
	and Tr.nrOfLikes >= T.nrOfLikes
	)



-- get directors who have directed a movie whose
-- trailer received more likes than average
select distinct D.dId, D.dName
from Director D
inner join Movie M on D.dId = M.dId
where M.mId = ANY(
	select T.mId
	from Trailer T
	group by T.mId
	having MAX(T.nrOfLikes) > (
		select AVG(Tr.nrOfLikes)
		from Trailer Tr
		)
	)
	
--
select distinct D.dId, D.dName
from Director D
inner join Movie M on D.dId = M.dId
where M.mId IN (
	select T.mId
	from Trailer T
	group by T.mId
	having MAX(T.nrOfLikes) > (
		select AVG(Tr.nrOfLikes)
		from Trailer Tr
		)
	)


-- get distinct movies that have
-- at least one actor with a salary greater than any actor in a SF film
select distinct M.mId, M.title
from Movie M
inner join Casting C on M.mId = C.mId
where C.salary > ANY(
	select Ca.salary
	from Movie Mo
	inner join Casting Ca on Mo.mId = Ca.mId
	where Mo.genre = 'Science Fiction')

--
select distinct M.mId, M.title
from Movie M
inner join Casting C on M.mId = C.mId
where C.salary > (
	select MIN(Ca.salary)
	from Movie Mo
	inner join Casting Ca on Mo.mId = Ca.mId
	where Mo.genre = 'Science Fiction')