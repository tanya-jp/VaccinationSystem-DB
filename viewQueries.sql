-- DROP PROCEDURE IF EXISTS db.showScores;
CREATE PROCEDURE db.showScores()
begin 
	SELECT h.vaccination_center_name, cast(avg(h.score) as decimal(10,1)) as average_score
	FROM `DB`.history as h
	GROUP by h.vaccination_center_name
    ORDER by average_score desc;
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