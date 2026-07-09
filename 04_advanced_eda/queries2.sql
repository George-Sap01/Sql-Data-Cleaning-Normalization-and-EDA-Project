/* --------------------  more queries  -------------------- */ 

select max(year) max_year, min(year) as min_year
from (
	select extract(year from date_added) as year
	from shows
    where date_added != '1900-01-01') as a;    
/* the column date_added is keeping  track of movies that were added between 2008 and 2021 */


-- Number of movies added each year from 2008-2008
with table_a as(
	select 
		id,
        title,
        date_added,
        extract(year from date_added) as year
	from shows
    where date_added != '1900-01-01'
)

select year, count(id) '# of movies/series added each year'
from table_a
group by year
order by year asc;

		
-- Number of movies added in each season from 2008-2021, in descending order.
with table_a as (
	select 
		id, 
		title,
        date_added,
		case 
			when extract(month from date_added) in (1, 2, 12) then 1
			when extract(month from date_added) in (3, 4, 5)  then 2
			when extract(month from date_added) in (6, 7, 8)  then 3
			when extract(month from date_added) in (9, 10, 11)  then 4
			end as season
	from shows
    where date_added != '1900-01-01'
)

select 
	case 
		when season=1 then 'December - January - February'
		when season=2 then 'March - April - May'
		when season=3 then 'June - July - August'
		when season=4 then 'September - October - November'
	end as season,
    count(*) as '# of movies/series'
from table_a
group by season
order by 2 desc;

-- 3 most famous categerories for each season
with table_a as (
	select id, title,
		case 
			when extract(month from date_added) in (1, 2, 12) then 1
			when extract(month from date_added) in (3, 4, 5)  then 2
			when extract(month from date_added) in (6, 7, 8)  then 3
			when extract(month from date_added) in (9, 10, 11)  then 4
			end as season
	from shows
    where date_added != '1900-01-01'
),
table_b as (
	select season, categories.name, count(*) as num
	from table_a
		inner join categories_shows cs on cs.show_id = table_a.id
		inner join categories on categories.id = cs.category_id
	group by season, categories.name
)

select case 
		when season=1 then 'December - January - February'
		when season=2 then 'March - April - May'
		when season=3 then 'June - July - August'
		when season=4 then 'September - October - November'
	end as season,
    name, num as '# of appearances in each season'
from (
	select season, name, num, dense_rank() over(partition by season order by num desc) as r
	from table_b) as a 
where r < 4
order by season, r asc;
