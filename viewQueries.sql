DROP PROCEDURE IF EXISTS db.showScores;
CREATE PROCEDURE db.showScores(in startNum int, out endNum int)
begin 
	set endNum = startNum + 5;
	WITH NumberedScoreTable AS
	(
    	select scoreTable.*,
        ROW_NUMBER() OVER (ORDER BY scoreTable.average_score desc) AS RowNumber
    	FROM
        	(SELECT h.vaccination_center_name, cast(avg(h.score) as decimal(10,1)) as average_score
			FROM `DB`.history as h
			GROUP by h.vaccination_center_name
    		ORDER by average_score desc)as scoreTable
	)
	select *
	FROM
    	NumberedScoreTable
	WHERE
    	RowNumber BETWEEN startNum AND endNum-1;
end;

-- DROP PROCEDURE IF EXISTS db.vaccinationNum;
CREATE PROCEDURE db.vaccinationNum()
begin 
	SELECT h.vaccination_date, count(*) 
	FROM `DB`.history as h
	GROUP by h.vaccination_date
    ORDER by h.vaccination_date desc;
end;


-- DROP PROCEDURE IF EXISTS db.showVaccinateds;
CREATE PROCEDURE db.showVaccinateds()
begin 
	select total.brand_name, count(*) as people
	from 
		(select v.name as brand_name, count(*) as num
		from `DB`.vial as v
		join `DB`.history as h 
		on h.vial_serial = v.serial_number
		GROUP by h.person_ID)total
	join `DB`.brand as b 
	on b.name = total.brand_name 
	where total.num = b.dose
	GROUP by b.name;
end;

-- DROP PROCEDURE IF EXISTS db.showTop3OfEachBrand;
CREATE PROCEDURE db.showTop3OfEachBrand()
begin 
	SELECT *
    FROM (
        SELECT *, Rank() 
          over (Partition BY selected.brand_name
                ORDER BY selected.scores DESC ) AS Rank
        FROM (
        select v.name as brand_name, h.vaccination_center_name, sum(h.score) as scores
		from `DB`.vial as v
		join `DB`.history as h 
		on h.vial_serial = v.serial_number
		GROUP by v.name, h.vaccination_center_name
		order by brand_name, scores desc)as selected
        ) rs WHERE Rank <= 3;
end;

DROP PROCEDURE IF EXISTS db.showSecondDoseCenter;
CREATE PROCEDURE db.showSecondDoseCenter(in login_time varchar(64))
begin 
	SELECT ID INTO @personID FROM `DB`.login WHERE MD5(`DB`.login.login_time) = login_time;
	SELECT vial_serial INTO @vialSerial FROM `DB`.history WHERE`DB`.history.person_ID = @personID;
	SELECT name INTO @brandName FROM `DB`.vial WHERE`DB`.vial.serial_number = @vialSerial;
	select v.name as brand_name, h.vaccination_center_name, sum(h.score) as scores
		from `DB`.vial as v
		join `DB`.history as h 
		on h.vial_serial = v.serial_number
		where v.name = @brandName
		GROUP by v.name, h.vaccination_center_name
		order by brand_name, scores desc;
end;




























