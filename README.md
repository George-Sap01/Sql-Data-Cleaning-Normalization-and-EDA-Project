# SQL Data Cleaning, Normalization and EDA Project

## Purpose of the project
The purpose of this project is to demonstrate my ***data cleaning***, ***database normalization***, and ***exploratory data analysis (EDA)*** skills using a Netflix dataset

##  Dataset
Netflix is one of the world's most popular media streaming platforms. This dataset contains over 8,000 movies and TV shows that were available on Netflix as of mid-2021. It includes information such as cast members, directors, ratings, release year, duration, genres, and more.

## Notes on the Raw Data
The original dataset was imported as a single, un-normalized flat table. This structure suffered from several issues:

* **Multi-valued Attributes**: Columns like `director` , `cast`, `country`, and `listed_in` contained comma-separated lists of values within a single cell, violating the First Normal Form (1NF).

* **Missing Data**: Many rows had blank or NULL entries across key attributes.

* **Inconsistent Types**: The `date_added` field was stored as text strings (e.g., "September 25, 2021") instead of a proper `DATE` format.

## Part 1: Data Cleaning & Standardizing
* **Type Conversion**: Text-based dates were converted into a standardized `YYYY-MM-DD` format using `STR_TO_DATE`. Missing dates default to `1900-01-01`.

* **Column Modification**: The `show_id` column was converted to an integer auto-incrementing *Primary Key* (id). Unused columns like rating were dropped.

* **Handling Missing Values**: Missing strings in `director`, `cast`, and `country` were populated with "`Unknown`"

* **String Standardization**: Used Regular Expressions (`REGEXP`) to clean up syntax anomalies, such as trailing or leading commas in textual data arrays
  

## Part 2: Schema Splitting & Normalization
### Automation via Stored Procedures:
I engineered native **MySQL Stored Procedures** to handle the ETL process. These use custom recursive CTEs and procedural string parsing (`SUBSTRING_INDEX`) to dynamically extract multi-valued attributes into their respective tables without manual intervention.

The schema was normalized up to **Third Normal Form** (3NF).

    shows
    ├── actors_shows ───── actors
    ├── directors_shows ── directors
    ├── countries_shows ── countries
    └── categories_shows ─ categories


## Part 3: Exploratory Data Analysis
* Top 10 Actors with the Most Appearances in Movies and TV Series
    * Directors Who Have Worked with Them
* Number of Movies Added Each Year (2008–2021) 
* Number of Movies Added per Calendar Season (2008–2021)
* Top 3 Categories by Season
* Average Movie Runtime
* Average Number of Seasons per TV Series (With and Without Outliers)
* Distribution of TV Series Seasons
* Distribution of Movie Runtimes
  * Dynamic Runtime Binning: Implemented a customizable bucket distribution system using a stored procedure to analyze movie runtimes across adjustable minute intervals (20-minute steps, 10-minute steps, 5-minute steps)


## Technologies Used

- MySQL
- Recursive CTEs
- Stored Procedures
- Window Functions
- Database Design (3NF)
- ETL Pipelines
- Data Cleaning
- Exploratory Data Analysis
- Outlier Detection (`IQR Method`)

## Reference 
Dataset Source: <https://www.kaggle.com/datasets/shivamb/netflix-shows>
