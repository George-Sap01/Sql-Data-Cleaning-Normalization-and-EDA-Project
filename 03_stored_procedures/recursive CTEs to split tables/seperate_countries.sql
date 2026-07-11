-- procedure to seperate countries table and countries_shows
drop procedure if exists seperate_countries;    

/*
	tables:
		cnet 
	    countries
        countries_shows
*/

delimiter $$
create procedure seperate_countries ()
begin 
	create temporary table if not exists temp(
			id int primary key not null auto_increment,
			show_id int not null,
            country_name varchar(100));
            
	-- in this table a have the show_id and the country's name
	insert into temp(show_id, country_name )
    with recursive cte as(
		select 
			id,
            concat(country, ',') as remaining,
            cast('' as char(500)) as token
		from cnet
        UNION ALL
        select 
			id,
            substring(remaining, locate(',', remaining) + 1), 
            trim(substring_index(remaining, ',', 1))
		from cte
        where remaining != ''
    )
	select id, token 
    from cte 
    where token != '';
    
    -- insert country_name  into countries table
    insert into countries(name) select distinct country_name  from temp;

	-- insert ids into intermediate table
    insert into countries_shows(show_id, country_id)
		select temp.show_id, countries.id
		from temp inner join countries on temp.country_name = countries.name;
    
    drop temporary table if exists temp;
end $$
delimiter ;
