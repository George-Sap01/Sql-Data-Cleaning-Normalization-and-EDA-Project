# Notes on Schema Normalization 

## Normalized Schema Architecture

**Example: Splitting the original table into two main tables connected through an intermediate table**

|Name   | Skills|
|------ | ------|
|George | C++, Python, Java|
|Bob    | Python, C++|      

<table>
<tr>
<td valign="top">

|id     | Name  |
|------ | ------|
|1      | George|
|2      | Bob   |      

</td>
<td valign="top">


| Name_id | Skill_id |
|-------- | -------- |
| 1       | 1  |
| 1       | 2  |
| 1       | 3  |
| 2       | 1  |
| 2       | 2  |

</td>
<td valign="top">

| id  | Skill |
|-----|-------|
| 1   | Python|
| 2   | C++   |
| 3   | Java  |
</tr>
</table>

## Core Entity Table
`shows`: Stores the unique core information for each movie or TV show 
* id (PK)
* title 
* date_added 
* release_year
* duration
* description 

## Dimension Tables (Lookup)
To eliminate duplicate text strings and maintain atomicity, independent entities were extracted into their own tables:

`directors`: id (PK), name (Unique)

`actors`: id (PK), name (Unique)

`countries`: id (PK), name (Unique)

`categories`: id (PK), name (Unique)

## Connecting Tables (Many-to-Many Relationships)
Since a show can have multiple directors, actors, countries, or categories, and vice versa, the following mapping tables link them together using *Foreign Keys* (`FK`) with `ON DELETE CASCADE`:

Junction tables use `ON DELETE CASCADE` to maintain referential integrity automatically when a parent record is removed.

`directors_shows`: Links `shows`(id) and `directors`(id)

`actors_shows`: Links `shows`(id) and `actors`(id)

`countries_shows`: Links `shows`(id) and `countries`(id)

`categories_shows`: Links `shows`(id) and `categories`(id)