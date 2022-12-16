-- Exercise 1: ​Using any methods you like determine if you can you trust this events table.

SELECT date(event_time) AS date,
COUNT(*) AS rows
FROM dsv1069.events_201701
GROUP BY date;

-- NO NULL values were returned. 
-- This table is considered to be very limited in scope.
-- So in this case, don't use the table due to the limited time frame
-- unless the scope of the project is focused on January 2017.


-- Exercise 2:
-- Using any methods you like, determine if you can you trust this events table. (HINT: When did we start recording events on mobile)

SELECT MIN(date(event_time)) as dater, MAX(platform)
FROM dsv1069.events_ex2
GROUP BY platform;

-- From analysis, capturing of Android and iOS data started in 2016, 
--compared to mobile web 2013 and server and web data starting capture in 2012.

-- Exercise 3:
-- Count item views by category
-- You found this table item_views_temp -- can you use it?
-- hint: this table doesn't have dates.

SELECT *
FROM dsv1069.item_views_by_category_temp


-- not a good idea to use this table, as it has temp in the name...




