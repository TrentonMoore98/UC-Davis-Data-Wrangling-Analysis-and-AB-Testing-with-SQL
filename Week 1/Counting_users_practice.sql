-- Exercise 1:
-- We’ll be using the users table to answer the question “How many new users are added each day?“. 
-- Start by making sure you understand the columns in the table.

SELECT DATE(created_at) AS date,
COUNT(DISTINCT id) as id
FROM dsv1069.users
GROUP BY date

-- Depending on which day, it is different.

-- Exercise 2:
-- WIthout worrying about deleted user or merged users, count the number of users added each day.

SELECT DATE(created_at) AS date,
COUNT(DISTINCT id) as id
FROM dsv1069.users
GROUP BY date

-- same answer as above

-- Exercise 3:
-- Consider the following query. Is this the right way to count merged or deleted users? 
-- If all of our users were deleted tomorrow what would the result look like?

SELECT
date(created_at) AS day,
COUNT(*) AS users
FROM
dsv1069.users
WHERE
deleted_at IS NULL
AND
(id <> parent_user_id OR parent_user_id IS NULL)
GROUP BY date(created_at)

-- this is semi-correct on how to count merged and deleted users..
-- the issue is why only count null values..


-- Exercise 4:
-- Exercise 4: ​Count the number of users deleted each day. Then count the number of users removed due to merging in a similar way.

SELECT date(deleted_at) AS day,
COUNT(*) AS deleted_users
FROM dsv1069.users
WHERE deleted_at IS NOT NULL
GROUP BY day


-- Exercise 5:
-- Use the pieces you’ve built as subtables and create a table that has 
-- a column for the date, 
-- the number of users created, 
-- the number of users deleted and 
-- the number of users merged that day.

SELECT
    new.day,
    new.new_users_added,
    deleted.deleted_users,
    merged.merged_users
FROM
    (SELECT DATE(created_at) AS day,
    COUNT(*) AS new_users_added
    FROM dsv1069.users
    GROUP BY day) new
LEFT JOIN 
(SELECT date(deleted_at) AS day,
COUNT(*) AS deleted_users
FROM dsv1069.users
WHERE deleted_at IS NOT NULL
GROUP BY day) deleted
ON deleted.day = new.day 
LEFT JOIN 
(SELECT DATE(created_at) AS day,
COUNT(DISTINCT id) as merged_users
FROM dsv1069.users
WHERE id <> parent_user_id
AND parent_user_id IS NOT NULL
GROUP BY day) merged
ON merged.day = new.day 

-- this query gives us clear counts on new users, deleted and merged per day. 
-- we want to make it to where SQL will do the math of taking these numbers out to return the
-- real result of "how many new users are we adding daily?"

-- exercise 6:
-- Refine query from #5 so that it returns one nice number.


SELECT
    new.day,
    new.new_users_added,
    COALESCE(deleted.deleted_users,0) AS ddeleted_users,
    COALESCE(merged.merged_users,0) AS mmerged_users,
    (new.new_users_added - COALESCE(deleted.deleted_users,0) - COALESCE(merged.merged_users,0)) AS net_users_added
FROM
    (SELECT DATE(created_at) AS day,
    COUNT(*) AS new_users_added
    FROM dsv1069.users
    GROUP BY day) new
LEFT JOIN 
(SELECT date(deleted_at) AS day,
COUNT(*) AS deleted_users
FROM dsv1069.users
WHERE deleted_at IS NOT NULL
GROUP BY day) deleted
ON deleted.day = new.day 
LEFT JOIN 
(SELECT DATE(created_at) AS day,
COUNT(DISTINCT id) as merged_users
FROM dsv1069.users
WHERE id <> parent_user_id
AND parent_user_id IS NOT NULL
GROUP BY day) merged
ON merged.day = new.day 


