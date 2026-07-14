-- create a new table to insert data into for cleaning
drop table if exists cnet;

create table cnet like netflix_titles;

-- modify the show_id column to an integer and primary key 
alter table cnet
	modify column show_id int primary key not null unique auto_increment;

alter table cnet
	rename column show_id to id;

-- modify the date_added data type into date 
alter table cnet
	modify column date_added date not null;

-- droping rating column
alter table cnet 
	drop column rating;

/* 			DATE_ADDED 			*/
select count(date_added) from netflix_titles where date_added is NULL or date_added = '';
-- 10 MISSING VALUES

-- inserting the original data into the new table
insert into cnet(type, title, director, cast, country, date_added, release_year, duration, listed_in , description) 
	select 
		type, 
        title, 
        director, 
        cast,
        country,
        case 
			when date_added = '' or date_added is NULL then '1900-01-01'
            else str_to_date(date_added, '%M %d, %Y')
        end as date_added,
        release_year, 
        duration,
        listed_in,
        description 
	from netflix_titles;


/* 	**** CHECK FOR MISSING VALUES AND REPLACING THEM **** */

/* 			TYPE 			*/
select distinct type from netflix_titles;
-- type: Movie, TV Show


/* 			TITLE 			*/ 
select count(title) from netflix_titles where title is NULL or title = '';
-- NO MISSING VALUE in the title column
 
-- checking for duplicate titles 
select type, title, count(title) 
from netflix_titles
group by title, type
having count(title) > 1;

select type, title, date_added
from cnet
where title in (
	select title
	from netflix_titles
	group by title, type
	having count(title) > 1)
order by title;
-- there are duplicates titles of the same movie/serie, because they were added in two seperate occasions/points in time, we keep them  


/* 			DIRECTOR 			*/
select count(director) from netflix_titles where director is NULL or director = '';
-- 2634 MISSING VALUES in the director column
 
 
 update cnet 
 set director = 'Unknown'
 where director is Null or director = '';
 
/* 			CAST 			*/
select count(cast) from netflix_titles where cast is NULL or cast = '';
-- 825 MISSING VALUES in the cast column 

update cnet 
set cast = 'Unknown'
where cast is Null or cast = '';


/* 			COUNTRY 			*/
select count(country) from netflix_titles where country is NULL or country = '';
-- 831 MISSING VALUES in the country column 


update cnet 
set country = 'Unknown'
where country is Null or country = '';

update cnet 
set country = replace(country, ',', '')
where country regexp '^,' or country regexp ',$';


/* 			RELEASE_YEAR 			*/
select count(release_year) from netflix_titles where release_year is NULL or release_year = '';
-- NO MISSING VALUES in the release_year column 

/* 			DURATION 			*/
select count(duration) from netflix_titles where duration is NULL or duration = '';
-- 3 MISSING VALUES in the rating column 

update cnet 
set duration = 'Unknown'
where duration is Null or duration = '';

/* 			LISTED_IN 			*/
select count(listed_in) from netflix_titles where listed_in is NULL or listed_in = '';
-- NO MISSING VALUES in the listed_in column 

/* 			DESCRIPTION 			*/
select count(description) from netflix_titles where description is NULL or description = '';
-- NO MISSING VALUES in the description column

