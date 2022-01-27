-- DROP PROCEDURE IF EXISTS db.vialCreation;
CREATE PROCEDURE db.vialCreation(
	in login_time varchar(64), 
	in serial_number varchar(64), 
	in dose int,
	in production_date date, 
	in name varchar(32),
	out res char(64)
	)
begin
	set @isNurse = 0; 
	set @nurseLevel = "";
-- 	set @personID = "";
-- 	set @serialCount = 0;
	IF (EXISTS (SELECT * FROM `DB`.login WHERE MD5(`DB`.login.login_time) = login_time)) then
		SELECT ID INTO @personID FROM `DB`.login WHERE MD5(`DB`.login.login_time) = login_time;
		if (EXISTS (SELECT nurse_level FROM `DB`.nurse WHERE `DB`.nurse.ID = @personID)) then 
			SELECT nurse_level into @nurseLevel FROM `DB`.nurse WHERE `DB`.nurse.ID = @personID;
       		set @isNurse = 1;
       		if (@nurseLevel = "matron") then
       			SELECT count(*) into @serialCount FROM `DB`.vial WHERE `DB`.vial.serial_number  = serial_number ;
       			if (@serialCount = 0) then 
       				if (EXISTS (SELECT * FROM `DB`.brand  WHERE `DB`.brand.name = name)) then
       					INSERT INTO `DB`.vial values (serial_number, dose, production_date , name);
       					set res = "Added!";
       				else 
       					set res = "Invalid brand name!";
       				end if;
       			else 
       				set res = "This serial number already exists!";
       			end if;
       		else 
       			set res = "Your level is not MATRON!";
       		end if;
       	else 
       		set res = "You are not nurse!";
       	end if;
	else 
		set res = "This person is not logged in!";

	end if;
end;