-- procedure to seperate categories table and categories_shows
drop procedure if exists seperate_categories;

/*
	tables:
		cnet 
        categories 
        categories_shows
*/

delimiter $$
create procedure seperate_categories()
begin 
create temporary table if not exists temp(
			id int primary key not null auto_increment,
			show_id int not null,
            category_name varchar(100));
            
	-- in this table a have the show_id and the category's name
	insert into temp(show_id, category_name)
    with recursive cte as(
		select 
			id,
            concat(listed_in, ',') as remaining,
            cast('' as char(300)) as token
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
    
    -- insert category_name into categories table
    insert into categories(name) select distinct category_name from temp;

	-- insert ids into intermediate table
    insert into categories_shows(show_id, category_id)
		select temp.show_id, categories.id
		from temp inner join categories on temp.category_name = categories.name;
    
    drop temporary table if exists temp;
end $$
delimiter ;
