-- procedure to seperate categories table and categories_shows
drop procedure if exists seperate_categories;

/*
	tables:
		cnet 
		shows
        categories 
        categories_shows
*/

delimiter $$
create procedure seperate_categories()
begin 
	declare buff varchar(500); 					-- this is where we save the category we isolate from the column 
	declare element_cnt int;  					-- counter for the amount of elements in the column 
	declare total_commas int;					-- number of total commas in a specifi row 
    declare total_rows, row_cnt int;			-- number of total rows in the table we seperate, row_cnt: keeps track of the rows in the loop
    declare temp_category_id, temp_show_id int;	-- the ids for the intermediate table 
    set row_cnt = 1;
    -- numbers of rows in the column 
    select count(*) into total_rows from cnet;    
    
    -- we loop for every row
    while row_cnt <= total_rows do
		-- number of commas for each row, to see how many different elements there are 
		select char_length(listed_in) - char_length( replace(listed_in, ',', '') ) into total_commas from cnet where id = row_cnt;
        
        set element_cnt = 1;
        
        -- total_commas = 0, meaning we only have one name in the column
        if total_commas = 0 then   
			select trim(substring_index(listed_in, ',' ,1)), id into buff, temp_show_id
			from cnet
			where id = row_cnt;
        
			-- inserting into the new table the categories, only if it doesn't exist yet 
            insert into categories(name) 
				select buff from cnet where not exists (select 1 from categories inn where inn.name = buff) limit 1;             
			-- getting category_id
			select id into temp_category_id from categories where categories.name = buff;
			-- inserting in the middle table
			insert into categories_shows(show_id, category_id) values(temp_show_id, temp_category_id);
		else -- we have commas in the column, meaning we have at least 2 names in the column
			
            while element_cnt <= total_commas + 1 do 
				if element_cnt = 1 then
					select trim(substring_index(listed_in, ',' ,1)), id into buff, temp_show_id
					from cnet
					where id = row_cnt;
				else 			
					select trim(substring_index(substring_index(listed_in, ',' ,element_cnt), ',' ,-1)), id into buff, temp_show_id
					from cnet
					where id = row_cnt;
				end if;
                
				-- inserting into the new table the categories, only if it doesn't exist yet 
                insert into categories(name) 
					select buff from cnet where not exists (select 1 from categories as inn where inn.name = buff) limit 1; 
				-- getting category_id
				select id into temp_category_id from categories where categories.name = buff;
				-- inserting in the middle table
				insert into categories_shows(show_id, category_id) values(temp_show_id, temp_category_id);
							
				set element_cnt = element_cnt + 1;
			end while;
		end if;
        set row_cnt = row_cnt + 1;
	end while;
end $$
delimiter ;
