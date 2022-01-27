-- DROP PROCEDURE IF EXISTS db.deleteAccount;
CREATE PROCEDURE db.deleteAccount(
	in login_time varchar(64), 
	in deleted_ID varchar(64),
	out res char(64)
	)
begin
	set @isDoctor = 0; 
	set @deleteCount = 0;
	IF (EXISTS (SELECT * FROM `DB`.login WHERE MD5(`DB`.login.login_time) = login_time)) then
        SELECT ID INTO @personID FROM `DB`.login WHERE MD5(`DB`.login.login_time) = login_time;
        if (EXISTS (SELECT * FROM `DB`.doctor WHERE `DB`.doctor.ID = @personID)) then 
       		set @isDoctor = 1;
			SELECT count(*) into @deleteCount FROM `DB`.System_info WHERE `DB`.System_info.ID = deleted_ID;
			if (@deleteCount > 0) then 
				DELETE FROM `DB`.System_info WHERE `DB`.System_info.ID = deleted_ID ;
				set res = "Deleted!";
			end if;
        end if;
		if (@isDoctor = 0) then 
			set res = "This person is not a doctor.";

		elseif (@deleteCount = 0) then
			set res = "Invalid ID!";
		end if;
	else
		set res = "This person is not logged in!";
	end if;
end;
-- 	set @isDoctor = 0; 
-- 	if (EXISTS (SELECT * FROM `DB`.doctor WHERE `DB`.doctor.doctor_ID  = doctor_ID)) then 
-- 		set @isDoctor = 1;
-- 	
-- 		if ((EXISTS (SELECT * FROM `DB`.doctor WHERE `DB`.doctor.ID = deleted_ID))) then 
-- 			set @personDoctorID = "";
-- 			SELECT doctor_ID INTO @personDoctorID FROM `DB`.doctor WHERE `DB`.doctor.ID = deleted_ID;
-- 			if ((EXISTS (SELECT * FROM `DB`.brand WHERE `DB`.brand.doctor_ID = @personDoctorID))) then 
-- 				DELETE FROM `DB`.brand WHERE `DB`.brand.doctor_ID = @personDoctorID;
-- 			end if;
-- 			DELETE FROM `DB`.doctor WHERE `DB`.doctor.ID = deleted_ID;
-- 		end if;
-- 	
-- 		if ((EXISTS (SELECT * FROM `DB`.nurse WHERE `DB`.nurse.ID = deleted_ID))) then 
-- 			set @personNurseID = "";
-- 			SELECT nurse_ID INTO @personNurseID FROM `DB`.nurse WHERE `DB`.nurse = deleted_ID;
-- 			if ((EXISTS (SELECT * FROM `DB`.history WHERE `DB`.history.vaccinator_ID = @personNurseID))) then 
-- 				DELETE FROM `DB`.history WHERE `DB`.history.vaccinator_ID = @personNurseID;
-- 			end if;
-- 			DELETE FROM `DB`.nurse WHERE `DB`.nurse.ID = deleted_ID;
-- 		end if;
-- 		
-- 		DELETE FROM `DB`.login WHERE `DB`.login.ID = deleted_ID;
-- 	
-- 	
-- 		DELETE FROM `DB`.person_info WHERE `DB`.person_info.ID = deleted_ID;
-- 		DELETE FROM `DB`.System_info WHERE `DB`.System_info.ID = deleted_ID;
-- 	
-- 	else
-- 		set res = "You are not doctor!";
-- 	end if;
-- end;