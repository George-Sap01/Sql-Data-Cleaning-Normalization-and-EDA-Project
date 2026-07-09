/* ----------------  some queries  ---------------- */
    
-- movies/series that have at least 3 directors
select shows.id, shows.title
from shows 
	inner join directors_shows ds on ds.show_id = shows.id
    inner join directors on directors.id = ds.director_id
group by shows.id
having count(shows.id) > 2
order by 1 asc;

-- number of movies that have at least 2 directors
select count(id)
from (
	select shows.id
	from shows 
		inner join directors_shows ds on ds.show_id = shows.id
		inner join directors on directors.id = ds.director_id
	where shows.type = 'Movie'
	group by shows.id
	having count(shows.id) > 1) as a;


-- actors with at least one movies/series
select actors.id, actors.name
from shows 
	inner join actors_shows as acs on shows.id = acs.show_id
    inner join actors on acs.actor_id = actors.id
where actors.name != 'Unknown'
group by actors.id
having count(actors.id) > 1;


-- top 10 actors with most appearances in all series/movies in netflix
with table_a as (
	select actors.id, actors.name, count(actors.id) as num
	from shows 
		inner join actors_shows as acs on shows.id = acs.show_id
		inner join actors on acs.actor_id = actors.id
	where actors.name != 'Unknown'
	group by actors.id
)

select 	name, num as 'number of appearances in series/movies in netflix'
from (
	select *, dense_rank() over(order by num desc) as dr
    from table_a) as table_b
where dr < 11
order by dr asc;


-- top 10 actors with most appearances in movies and top 10 actors with most appearances in series 
with movies_table as (
	select actors.id, shows.type, actors.name, count(actors.id) as num
	from shows 
		inner join actors_shows as acs on shows.id = acs.show_id
		inner join actors on acs.actor_id = actors.id
	where actors.name != 'Unknown' and shows.type = 'Movie'
	group by actors.id
),
series_table as(
	select actors.id, shows.type, actors.name, count(actors.id) as num
	from shows 
		inner join actors_shows as acs on shows.id = acs.show_id
		inner join actors on acs.actor_id = actors.id
	where actors.name != 'Unknown' and shows.type = 'TV Show'
	group by actors.id
)

select 	name, num as 'number of appearances in series/movies in netflix', 'Movies' as 'Movie or Tv'
from ( 
	select name, num, dense_rank() over(order by num desc) as dr from movies_table) as a
where dr < 11
UNION 
select 	name, num as 'number of appearances in series/movies in netflix', 'Series'
from (
	select name, num, dense_rank() over(order by num desc) as dr from series_table) as a
where dr < 11;


-- directors who has worked with at least 6 of these actors
 with movies_table as (
	select actors.id, shows.type, actors.name, count(actors.id) as num
	from shows 
		inner join actors_shows as acs on shows.id = acs.show_id
		inner join actors on acs.actor_id = actors.id
	where actors.name != 'Unknown' and shows.type = 'Movie'
	group by actors.id
),
series_table as(
	select actors.id, shows.type, actors.name, count(actors.id) as num
	from shows 
		inner join actors_shows as acs on shows.id = acs.show_id
		inner join actors on acs.actor_id = actors.id
	where actors.name != 'Unknown' and shows.type = 'TV Show'
	group by actors.id
),
actors_table as(
	select 	id
	from ( 
		select id, dense_rank() over(order by num desc) as dr from movies_table) as a
	where dr < 11
	UNION 
	select 	id
	from (
		select id, dense_rank() over(order by num desc) as dr from series_table) as a
	where dr < 11
)

select 
	directors.name
from 
	directors
	inner join directors_shows as ds on directors.id = ds.director_id
    inner join shows on shows.id = ds.show_id
    inner join actors_shows as acs on acs.show_id = shows.id
    inner join actors on actors.id = acs.actor_id
where 
	actors.id in (select id from actors_table) and directors.name != 'Unknown'
group by directors.name
having count(*) > 5;


