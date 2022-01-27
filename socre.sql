-- DROP PROCEDURE IF EXISTS db.scoring;
CREATE PROCEDURE `DB`.scoring (
	in login_time varchar(64),
	in score int,
	in health_center_name varchar(32),
	out res varchar(64)
	)
	begin
		set @id = "";
-- 		set @hasScore;
		SELECT ID into @id FROM `DB`.login WHERE MD5(`DB`.login.login_time) = login_time;
		if score>=1 and score<=5 then
			if (EXISTS (SELECT * FROM `DB`.history WHERE (@id = `DB`.history.person_ID and health_center_name = `DB`.history.vaccination_center_name))) then
			SELECT `DB`.history.score into @hasScore FROM `DB`.history 
				WHERE (@id = `DB`.history.person_ID and health_center_name = `DB`.history.vaccination_center_name);
				if @hasScore = 0 then 
					UPDATE `DB`.history SET  `DB`.history.score = score 
						where `DB`.history.vaccination_center_name = health_center_name and `DB`.history.person_ID = @id;
					set res = "Submitted";
				else
					set res = "You have scored this health center.";
				end if;
			else 
				set res = "You have not vaccinated here.";
			end if;
		else 
			set res = "Invalid score";
		end if;
				
	end;