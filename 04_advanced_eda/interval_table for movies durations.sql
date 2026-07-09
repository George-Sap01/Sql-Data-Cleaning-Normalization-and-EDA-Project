/* Helper table to calculate movie duration distribution */
drop table if exists intervals_table;

create table if not exists intervals_table(
	id int primary key unique auto_increment,
    val varchar(10) unique not null,
    lower_bound int unique not null,
    upper_bound int unique not null
);

-- creating a table for the distribution of movie's duration
drop procedure if exists interval_proced;

-- step 5, 10, 20
delimiter $$
create procedure interval_proced (in step int)
begin 
	declare cnt int default 0;
	declare upper_bound int;
    
    if step = 20 then 
		set upper_bound = 6;
	elseif step = 10 then 
		set upper_bound = 12;
	elseif step = 5 then 
    	set upper_bound = 24;
	end if;
    
	insert into intervals_table(val, lower_bound, upper_bound) values('<60', 0, 60);
	while cnt < upper_bound do
		insert into intervals_table(val, lower_bound, upper_bound) 
			select concat(60 + step * cnt + 1, ' - ', 60 + step * (cnt + 1)), 60 + step * cnt + 1, 60 + step * (cnt + 1);
        set cnt = cnt + 1;
    end while;
    insert into intervals_table(val, lower_bound, upper_bound) values('>180', 181, 500);
end $$
delimiter ;

call interval_proced(10);

select id, val, lower_bound, upper_bound
from  intervals_table
order by id;

