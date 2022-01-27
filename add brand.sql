-- DROP PROCEDURE IF EXISTS db.addBrand;
CREATE PROCEDURE db.addBrand(
	in login_time varchar(64), 
	in name varchar(32),
	in dose int,
    in days int, 
	out res char(64)
	)
begin
	set @isDoctor = 0; 
	set @personID = "";
	set @doctorID = "";
	IF (EXISTS (SELECT * FROM `DB`.login WHERE MD5(`DB`.login.login_time) = login_time)) then
        SELECT ID INTO @personID FROM `DB`.login WHERE MD5(`DB`.login.login_time) = login_time;
        if (EXISTS (SELECT * FROM `DB`.doctor WHERE `DB`.doctor.ID = @personID)) then 
       		set @isDoctor = 1;
        	SELECT doctor_ID INTO @doctorID FROM `DB`.doctor WHERE `DB`.doctor.ID = @personID;
			SELECT count(*) into @brandNameCount FROM `DB`.brand WHERE `DB`.brand.name = name;
			set res  = @brandNameCount;
			if (@brandNameCount = 0) then 
				INSERT INTO `DB`.brand values (name, dose, days, @doctorID);
				set res = "Added.";
			end if;
        end if;
		if (@isDoctor = 0) then 
			set res = "This person is not a doctor.";

		elseif (@brandNameCount > 0) then
			set res = "This name already exists.";
		end if;
	else
		set res = "This person is not logged in!";
	end if;
end;

