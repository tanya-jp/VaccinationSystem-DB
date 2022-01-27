-- DROP PROCEDURE IF EXISTS db.injection;
CREATE PROCEDURE db.injection(
	in login_time varchar(64),
	in person_ID varchar(32),
	in vaccination_center_name varchar(32),
	in vial_serial varchar(32),
	out res char(64)
	)
begin
	set @vaccinatorID = "";
	set @nurseID = "";
	IF (EXISTS (SELECT * FROM `DB`.login WHERE MD5(`DB`.login.login_time) = login_time)) then
		SELECT ID INTO @vaccinatorID FROM `DB`.login WHERE MD5(`DB`.login.login_time) = login_time;
		if (EXISTS (SELECT * FROM `DB`.nurse WHERE `DB`.nurse.ID = @vaccinatorID)) then 
			SELECT nurse_ID  into @nurseID FROM `DB`.nurse WHERE `DB`.nurse.ID = @personID;
			if (EXISTS (SELECT * FROM `DB`.system_info WHERE `DB`.system_info.ID = person_ID)) then 
				if (EXISTS (SELECT * FROM `DB`.health_center WHERE `DB`.health_center.name = vaccination_center_name)) then 
					if (EXISTS (SELECT * FROM `DB`.vial WHERE `DB`.vial.serial_number = vial_serial)) then 
						INSERT INTO `DB`.history values (person_ID, @nurseID, vaccination_center_name ,vial_serial, CURRENT_DATE(), null);
						set res = "Done!";
					else
						set res =	"Invalid serial number.";
					end if;
				else
					set res =	"Invalid health center.";
				end if;
			else
				set res =	"Invalid ID number.";
			end if;
		else
			set res = "Vaccinator is not a nurse.";
		end if;
	else 
		set res = "This person is not logged in!";
	end if;
end