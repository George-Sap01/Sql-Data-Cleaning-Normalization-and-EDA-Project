set foreign_key_checks = 0;

-- creating the shows table 
drop table if exists shows;
create table if not exists shows(
	id 			 int primary key not null auto_increment unique,
    type 		 enum('Movie', 'TV Show') not null, 
    title 		 varchar(150) not null,
    date_added 	 date not null,
    release_year int not null,
    duration 	 varchar(50) not null,
    description  text not null
);

insert into shows(type, title, date_added, release_year, duration, description) 
	select type, title, date_added, release_year, duration, description from cnet;

-- creating the directors table 
drop table if exists directors;
create table if not exists directors(
	id 		int auto_increment primary key unique not null,
    name 	varchar(200) unique not null
);

-- creating the "middle"/connecting table between directors and shows 
drop table if exists directors_shows;
create table if not exists directors_shows(
	id 			int auto_increment primary key not null unique,
    show_id 	int not null,
    director_id int not null, 
	constraint directors_shows_show_fk foreign key (show_id) references shows(id) on delete cascade,
    constraint directors_shows_director_fk foreign key (director_id) references directors(id) on delete cascade
);

-- creating the actors table 
drop table if exists actors;
create table if not exists actors(
	id int primary key auto_increment not null,
    name varchar(300) unique not null
);

-- creating the "middle"/connecting table between actors and shows 
drop table if exists actors_shows;
create table if not exists actors_shows(
	id 			int auto_increment primary key not null unique,
    show_id 	int not null,
    actor_id int not null, 
	constraint actors_shows_show_fk foreign key (show_id) references shows(id) on delete cascade,
    constraint actors_shows_actor_fk foreign key (actor_id) references actors(id) on delete cascade
);

-- creating the countries table
drop table if exists countries;
create table if not exists countries(
	id int primary key auto_increment not null,
    name varchar(200) unique not null
);

-- creating the "middle"/connecting table between countries and shows 
drop table if exists countries_shows;
create table if not exists countries_shows(
	id 			int auto_increment primary key not null unique,
    show_id 	int not null,
    country_id int not null, 
	constraint countries_shows_show_fk foreign key (show_id) references shows(id) on delete cascade,
    constraint countries_shows_country_fk foreign key (country_id) references countries(id) on delete cascade
);

-- creating the category table
drop table if exists categories;
create table if not exists categories(
	id int primary key auto_increment not null,
    name varchar(200) unique not null
);

-- creating the "middle"/connecting table between categories and shows 
drop table if exists categories_shows;
create table if not exists categories_shows(
	id 			int auto_increment primary key not null unique,
    show_id 	int not null,
    category_id int not null, 
	constraint categories_shows_show_fk foreign key (show_id) references shows(id) on delete cascade,
    constraint categories_shows_category_fk foreign key (category_id) references categories(id) on delete cascade
);

set foreign_key_checks = 1;
