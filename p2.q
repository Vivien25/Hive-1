DROP TABLE IF EXISTS batting;
CREATE EXTERNAL TABLE IF NOT EXISTS batting(id STRING, year INT, team STRING, league STRING, games INT, ab INT, 
runs INT, hits INT, doubles INT, triples INT, homeruns INT, rbi INT, sb INT, cs INT, walks INT, strikeouts INT,
ibb INT, hbp INT, sh INT, sf INT, gidp INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
LOCATION '/user/maria_dev/hivetest/batting';
DROP TABLE IF EXISTS master;
CREATE EXTERNAL TABLE IF NOT EXISTS master(id STRING, byear INT, bmonth INT, bday INT, bcountry STRING, 
bstate STRING, bcity STRING, dyear INT, dmonth INT, dday INT, dcountry STRING, dstate STRING, dcity STRING, 
fname STRING, lname STRING, name STRING, weight INT, height INT, bats STRING, throws STRING, debut STRING, 
finalgame STRING, retro STRING, bbref STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
LOCATION '/user/maria_dev/hivetest/master';
DROP TABLE IF EXISTS Fielding;
CREATE EXTERNAL TABLE IF NOT EXISTS Fielding
(id STRING, year INT, team STRING, lgid STRING, pos STRING, G INT, GS INT, Innouts INT, PO INT, A INT, 
errors INT, DP INT, PB INT, WP INT, SB INT, CS INT, ZR INT) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/hivetest/fielding';

SELECT getrank.bmonth,getrank.bday FROM (SELECT id_count.bmonth, id_count.bday, id_count.count, DENSE_RANK() OVER (ORDER BY id_count.count DESC) as ranked 
FROM (SELECT bmonth, bday, count(id) AS count FROM master 
WHERE bmonth is not null AND bday is not null
GROUP BY bmonth,bday) id_count) getrank 
WHERE getrank.ranked <4;