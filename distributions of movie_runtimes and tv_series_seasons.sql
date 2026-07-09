/* distribution of TV Series seasons */
select dur, count(dur) as '#'
from (
	select cast(trim(left(duration, 2)) as unsigned) dur
	from shows
	where type = 'TV Show') as a
group by dur
order by dur asc;

/* distribution of movies runtime */ 

-- average duration of a movie
select concat( round(avg(dur), 2), ' ', 'minutes' ) as 'Average duration of a movie'
from (
	select cast(trim(replace(duration, 'min', '')) as unsigned) as dur
	from shows
	where type = 'Movie' and duration != 'Unknown') as a;


select min(dur) as min_dur, max(dur) as max_dur
from (
	select cast(trim(replace(duration, 'min', '')) as unsigned) as dur
	from shows
	where type = 'Movie' and duration != 'Unknown') as a;    


-- for this to work we need to call first the interval_proced to make the interval table
-- the steps we can choose are 5, 10, 20 minutes 
with table_a as(
	select title, cast(trim(replace(duration, 'min', '')) as unsigned) as dur
	from shows
	where type = 'Movie'
),
table_b as
(
	select val, dur
	from intervals_table as inter
		left outer join table_a on  
			inter.lower_bound < table_a.dur and table_a.dur < inter.upper_bound
)

select val, count(dur) '# of values'
from table_b
group by val;


