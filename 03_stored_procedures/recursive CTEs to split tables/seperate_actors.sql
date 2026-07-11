-- procedure to seperate actors table and actors_shows
drop procedure if exists seperate_actors;    

/*
	tables i use:
		cnet 
        actors 
        actors_shows
*/

            
delimiter $$
create procedure seperate_actors ()
begin
	create temporary table if not exists temp(
			id int primary key not null auto_increment,
			show_id int not null,
            actor_name varchar(100));
            
	-- in this table a have the show_id and the actor's name
	insert into temp(show_id, actor_name)
    with recursive cte as(
		select 
			id,
            concat(cast, ',') as remaining,
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
    
    -- insert actor_name into actors table
    insert into actors(name) select distinct actor_name from temp;

	-- insert ids into intermediate table
    insert into actors_shows(show_id, actor_id)
		select temp.show_id, actors.id
		from temp inner join actors on temp.actor_name = actors.name;
    
    drop temporary table if exists temp;
end $$
delimiter ;

