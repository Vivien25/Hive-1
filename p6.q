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

SELECT getrank.id FROM
(SELECT scores.id, scores.score, DENSE_RANK() OVER (ORDER BY scores.score DESC) as ranked FROM
(SELECT no_null.id, (joined.hits / joined.ab_sum - no_null.errors /no_null.g_sum) as score FROM
(SELECT id, sum(errors) as errors, sum(g) as g_sum FROM fielding
WHERE year >2004 AND year <2010
AND NOT (gs is null and Innouts is null and po is null and a is null and errors is null and dp is null 
and pb is null and wp is null and sb is null and cs is null and zr is null)
GROUP BY id)no_null JOIN
(SELECT id, sum(hits) as hits,sum(ab) as ab_sum FROM batting 
WHERE year >2004 AND year <2010
GROUP BY id) joined
WHERE no_null.id = joined.id AND joined.ab_sum >39 AND no_null.g_sum >19)scores) getrank
WHERE getrank.ranked <4;