-- procedure to seperate countries table and countries_shows
drop procedure if exists seperate_countries;    

/*
	tables:
		cnet 
		shows
        countries
        countries_shows
*/

delimiter $$
create procedure seperate_countries ()
begin 
	declare buff varchar(500); 					-- this is where we save the country we isolate from the column 
	declare element_cnt int;  					-- counter for the amount of elements in the column 
	declare total_commas int;					-- number of total commas in a specifi row 
    declare total_rows, row_cnt int;			-- number of total rows in the table we seperate, row_cnt: keeps track of the rows in the loop
    declare temp_country_id, temp_show_id int;	-- the ids for the intermediate table 
    set row_cnt = 1;
    -- numbers of rows in the column 
    select count(*) into total_rows from cnet;    
    
    -- we loop for every row
    while row_cnt <= total_rows do
		-- number of commas for each row, to see how many different elements there are 
		select char_length(country) - char_length( replace(country, ',', '')) into total_commas from cnet where id = row_cnt;
        
        set element_cnt = 1;
        
        -- total_commas = 0, meaning we only have one name in the column 
        if total_commas = 0 then
			select trim(substring_index(country, ',' ,1)), id into buff, temp_show_id
			from cnet
			where id = row_cnt;
        
			-- inserting into the new table the countries, only if it doesn't exist yet 
            insert into countries(name) 
				select buff from cnet where not exists (select 1 from countries inn where inn.name = buff) limit 1;             
			-- getting country_id
			select id into temp_country_id from countries where countries.name = buff;
			-- inserting in the middle table
			insert into countries_shows(show_id, country_id) values(temp_show_id, temp_country_id);
		else -- we have commas in the column, meaning we have at least 2 names in the column
			
            while element_cnt <= total_commas + 1 do 
				if element_cnt = 1 then
					select trim(substring_index(country, ',' ,1)), id into buff, temp_show_id
					from cnet
					where id = row_cnt;
				else 			
					select trim(substring_index(substring_index(country, ',' ,element_cnt), ',' ,-1)), id into buff, temp_show_id
					from cnet
					where id = row_cnt;
				end if;
				-- inserting into the new table the country, only if it doesn't exist yet 
                insert into countries(name) 
					select buff from cnet where not exists (select 1 from countries as inn where inn.name = buff) limit 1; 
				-- getting country_id
				select id into temp_country_id from countries where countries.name = buff;
				-- inserting in the middle table
				insert into countries_shows(show_id, country_id) values(temp_show_id, temp_country_id);
							
				set element_cnt = element_cnt + 1;
			end while;
		end if;
        set row_cnt = row_cnt + 1;
	end while;
end $$
delimiter ;
