-- DROP PROCEDURE IF EXISTS db.addHealthCenter;
CREATE PROCEDURE db.addHealthCenter(
	in login_time varchar(64), 
	in name varchar(32),
	in address varchar(512), 
	out res char(64)
	)
begin
	set @isDoctor = 0; 
	set @personID = "";
	set @hCenterNameCount = 0;
-- 	set @doctorID = "";
	IF (EXISTS (SELECT * FROM `DB`.login WHERE MD5(`DB`.login.login_time) = login_time)) then
        SELECT ID INTO @personID FROM `DB`.login WHERE MD5(`DB`.login.login_time) = login_time;
        if (EXISTS (SELECT * FROM `DB`.doctor WHERE `DB`.doctor.ID = @personID)) then 
       		set @isDoctor = 1;
--         	SELECT doctor_ID INTO @doctorID FROM `DB`.doctor WHERE `DB`.doctor.ID = @personID;
			SELECT count(*) into @brandNameCount FROM `DB`.health_center WHERE `DB`.health_center.name = name;
			if (@brandNameCount = 0) then 
				INSERT INTO `DB`.health_center values (name, address);
				set res = "Added.";
			end if;
        end if;
		if (@isDoctor = 0) then 
			set res = "This person is not a doctor.";

		elseif (@hCenterNameCount > 0) then
			set res = "This name already exists.";
		end if;
	else
		set res = "This person is not logged in!";
	end if;
end;

