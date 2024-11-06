# atos_task1_uefa_database
# Overview
Atos, recognizing the pivotal role of sports in our lives, proudly partners with UEFA to support this passion. In line with this collaboration, we've created the Football Database, designed to meticulously manage, and analyze data from various football leagues. This detailed and comprehensive database covers teams, players, matches, player statistics, and transfer history, making it an indispensable tool for football analysts, team managers, and enthusiasts. It facilitates performance tracking, strategic team planning, and monitoring player and team progress throughout the league.

# Task
Design an ERD for the database and create a materialized view using SQL

# Database Structure
Players - Contains player details such as PlayerID, Name, DateOfBirth, Nationality, and TeamID
Teams - Stores team information, including TeamID, TeamName, and Country
Matches - Contains match details like MatchID, Date, and participating teams
Player_Stats - Holds player statistics for each match, including goals scored, assists, and minutes played
Transfer_History - Tracks player transfers with details on transfer dates and teams involved

# SQL Script

1- Player Information Retrieval - Fetch player profiles along with their current team and nationality
2- Performance Analysis - Calculate goals, assists, and average minutes played for players across matches
3- Transfer Insights - Determine transfer history, including first dates for players who joined a French or a German team

# Solution Steps
1- Designed an ERD using draw.io
2- Created the database schema using DDL
3- Converted the xlsx file to separate csv files for each table
4- Imported the tables into the database
5- Wrote the query to materialize the required view
6- Prepared a detailed presentation to review and address data quality issues
