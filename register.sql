-- DROP PROCEDURE IF EXISTS db.register;
CREATE PROCEDURE `DB`.register(
	in ID varchar(32),
    in pw varchar(30),
    in fist_name varchar(512),
	in last_name varchar(512),
	in gender varchar(16),
	in disease varchar(4),
	in birthday date,
	in accountType varchar(16),
    in job_ID varchar(10),
	in nurse_level varchar(32),
    out res varchar(500),
    out job_res varchar (500)
    )
begin
	SET @usernameCount = 0;
	SELECT count(*) into @usernameCount FROM `DB`.system_info WHERE `DB`.system_info.ID = ID;
	
	SET @isIDValid = 0;
    SELECT (ID regexp '[[:alpha:]]+') INTO @isIDValid;
    IF CHAR_LENGTH(ID) <10 or CHAR_LENGTH(ID) >10 THEN
		set @isIDValid = 1;
	END IF;
	
	SET @isPasswordValid = 0;
    SELECT ((pw regexp '[[:digit:]]+') AND (pw regexp '[[:alpha:]]+')) INTO @isPasswordValid;
    IF CHAR_LENGTH(pw) < 8 THEN
		set @isPasswordValid = 0;
	END IF;

	IF @usernameCount = 0 and @isIDValid = 0 and @isPasswordValid > 0 then
	
		INSERT INTO `DB`.System_info values (ID, MD5(pw), CURRENT_DATE() ,CURRENT_TIME()); 
 		INSERT into `DB`.person_info values(ID, fist_name, last_name, gender, disease, birthday);
 	
 		IF accountType = "doctor" THEN 
			SET @doctorIDCount = 0;
			SELECT count(*) into @doctorIDCount FROM `DB`.doctor  WHERE `DB`.doctor .doctor_ID  = job_ID ;

			SET @isDoctorIDValid = 0;
    		SELECT (job_ID  regexp '[[:alpha:]]+') INTO @isDoctorIDValid;
    		IF CHAR_LENGTH(job_ID) <5 or CHAR_LENGTH(job_ID) >5 THEN
				set @isDoctorIDValid = 1;
			END IF;

			IF @doctorIDCount = 0 and @isDoctorIDValid = 0 then
				INSERT INTO `DB`.doctor values (ID, job_ID);
				SET job_res = "Doctor added";
			ELSEIF @doctorIDCount > 0 then
				SET job_res = "Doctor already exists";
			
			ELSEIF @isDoctorIDValid > 0 then
				SET job_res = "Doctor ID must be 5 digits";
			end if;
		END IF;
	
		IF accountType = "nurse" THEN 
			
			SET @nurseIDCount = 0;
			SELECT count(*) into @nurseIDCount FROM `DB`.nurse  WHERE `DB`.nurse .nurse_ID  = job_ID ;

			SET @isNurseIDValid = 0;
    		SELECT (job_ID  regexp '[[:alpha:]]+') INTO @isNurseIDValid;
    		IF CHAR_LENGTH(job_ID) <8 or CHAR_LENGTH(job_ID) >8 THEN
				set @isNurseIDValid = 1;
			END IF;
	
			SET @isnurseLevelValid =0;
			if nurse_level= "matron" or nurse_level="supervisor" or nurse_level="nurse" or nurse_level="paramadic" then 
				set @isnurseLevelValid = 1;
			end if;
		
			IF @isNurseIDValid = 0 AND @nurseIDCount = 0 and @isnurseLevelValid = 1 then
				INSERT INTO `DB`.nurse values (ID, job_ID, nurse_level);
				SET job_res = "Nurse added";
			ELSEIF @nurseIDCount > 0 then
				SET job_res = "Nurse already exists";
		
			ELSEIF @isnurseLevelValid > 0 then
				SET job_res = "Nurse ID must be 8 digits";
 			
			ELSEIF @isnurseLevelValid = 0 then
				SET job_res = "Nurse level is not valid";
			end if;
		end if;
	
		SET res = "Success. Account created";
	ELSEIF @usernameCount > 0 THEN
		SET res = "Username already exists";
	ELSEIF @isIDValid > 0 THEN
    	SET res = "Invalid national ID";
	ELSEIF CHAR_LENGTH(pw) < 8 THEN
    	SET res = "Password must be at leaset 8 letters&numbers";
	ELSE
		SET res = "Password must be a combination of letters and numbers";
 	END IF;
end;