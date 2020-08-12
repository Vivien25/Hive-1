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

SELECT getrank.bmonth, getrank.bstate FROM
(SELECT final.bmonth, final.bstate, DENSE_RANK() OVER (ORDER BY (final.hits_month_state /final.ab_month_state) ASC) as ranked  FROM
(SELECT joined.bmonth, joined.bstate, SUM(id_sum.hits_sum) AS hits_month_state, SUM(id_sum.ab_sum) AS ab_month_state FROM
(SELECT id, sum(hits) as hits_sum, sum(ab) as ab_sum FROM batting GROUP BY id) id_sum JOIN
(SELECT m.id, get_id.bmonth, get_id.bstate, get_id.id_count FROM master m JOIN
(SELECT counts.bmonth, counts.bstate, counts.id_count FROM
(SELECT bmonth,bstate, count(id) AS id_count FROM master
WHERE bmonth is not null AND bstate !="" 
GROUP BY bmonth, bstate) counts
WHERE counts.id_count >4) get_id
WHERE m.bmonth = get_id.bmonth AND m.bstate = get_id.bstate)joined
WHERE id_sum.id = joined.id
GROUP BY joined.bmonth, joined.bstate) final
WHERE final.ab_month_state >100)getrank
WHERE getrank.ranked =1;