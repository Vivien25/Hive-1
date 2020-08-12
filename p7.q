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

SELECT getrank.bcity, getrank.bstate FROM
(SELECT rank.bcity, rank.bstate, rank.hits_sum, DENSE_RANK() OVER (ORDER BY rank.hits_sum DESC) as ranked 
FROM (SELECT birth_hits.bcity, birth_hits.bstate, SUM(birth_hits.hits) AS hits_sum FROM
(SELECT hits_sum.id, hits_sum.hits, m.bcity, m.bstate FROM 
(SELECT id, SUM(doubles + triples) AS hits FROM batting GROUP BY id) hits_sum JOIN master m
WHERE m.id =hits_sum.id AND m.bcity !='' AND m.bstate !='') birth_hits
GROUP BY birth_hits.bcity, birth_hits.bstate) rank) getrank
WHERE getrank.ranked <6;