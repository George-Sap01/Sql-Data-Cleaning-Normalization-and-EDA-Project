/* average number of seasons of a series */
select 
	round(avg(dur), 2) as 'Average number of seasons of a series',
    round(stddev(dur), 2) as 'Stddev'
from (
	select cast(trim(left(duration, 2)) as unsigned) dur
	from shows
	where type = 'TV Show') as a;
-- avg = 1.76, stddev = 1.58

/* 	average number of seasons of a series 
	using interquartile method for detecting outliers	*/
with data_table as (  
	select cast(trim(left(duration, 2)) as unsigned) num
	from shows
	where type = 'TV Show'
),
percent_table as(
	select num, percent_rank() over(order by num) as p
	from data_table
),
final_table as (
	select num
    from data_table
    where num between (
			select 
				distinct first_value(num) over(order by case when p <= 0.25 then p end desc) - 1.5 * 
				( first_value(num) over(order by case when p <= 0.75 then p end desc) -
				  first_value(num) over(order by case when p <= 0.25 then p end desc) ) 
			from percent_table)
		AND (
			select 
				distinct first_value(num) over(order by case when p <= 0.75 then p end desc) + 1.5 * 
				( first_value(num) over(order by case when p <= 0.75 then p end desc) -
				  first_value(num) over(order by case when p <= 0.25 then p end desc) ) 
			from percent_table)
)

select 
	round(avg(num), 2) as 'Average number of seasons of a series',
	round(stddev(num), 2) as 'Stddev'
from final_table;
-- avg = 1.34, stddev = 0.62
