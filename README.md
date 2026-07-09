# MySql Data Cleaning, Normalization and EDA Project

## Purpose of the project
The purpose of this project is to demonstrate my ***data cleaning***, ***database normalization***, and ***exploratory data analysis (EDA)*** skills using a Netflix dataset

##  Dataset
Netflix is one of the world's most popular media streaming platforms. This dataset contains over 8,000 movies and TV shows that were available on Netflix as of mid-2021. It includes information such as cast members, directors, ratings, release year, duration, genres, and more.


## Part 1
### Importing and cleaning data
* String Standardization: Used Regular Expressions (`REGEXP`) to clean up syntax anomalies, such as trailing or leading commas in textual data arrays
* Identified and systematically handled missing data across fields by replacing blanks/nulls with standard (`Unknown`) identifiers
* Remove unnecessary columns and rows
* Type Casting: Refactored raw text-based date fields into native SQL DATE types using `STR_TO_DATE`

## Part 2
### Relational Database Normalization (3NF)

#### Automation via Stored Procedures:
I engineered native **MySQL Stored Procedures** to handle the ETL process. These use custom looping blocks and procedural string parsing (`SUBSTRING_INDEX`) to dynamically extract multi-valued attributes into their respective tables without manual intervention.

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

## Part 3
### Exploratory Data Analysis
* Top 10 Actors with the Most Appearances in Movies and TV Series
    * Directors Who Have Worked with Them
* Number of Movies Added Each Year (2008–2021) 
* Number of Movies Added per Calendar Season (2008–2021)
* Top Three Most Popular Movie/TV Series Categories for Each Season
* Average Movie Runtime
* Average Number of Seasons per TV Series (With and Without Outliers)
* Distribution of TV Series Seasons
* Ditribution of Movie runtimes
  * Dynamic Runtime Binning: Implemented a customizable bucket distribution system using a stored procedure to analyze movie runtimes across adjustable minute intervals (20-minute steps, 10-minute steps, 5-minute steps)


## Technologies Used

- MySQL
- SQL (Joins, CTEs, Window Functions, Aggregations, Stored Procedures)
- Database Normalization
- Data Cleaning
- Exploratory Data Analysis (EDA)

## Reference 
Dataset Source: <https://www.kaggle.com/datasets/shivamb/netflix-shows>
