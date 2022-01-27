-- DROP PROCEDURE IF EXISTS db.changePass;
CREATE PROCEDURE `DB`.changePass (
	in login_time varchar(64),
	in newPass varchar(32),
	out res varchar(16)
	)
	begin
		set @id = "";
		SELECT ID into @id FROM `DB`.login WHERE MD5(`DB`.login.login_time) = login_time;
	
		SET @isPasswordValid = 0;
    	SELECT ((newPass regexp '[[:digit:]]+') AND (newPass regexp '[[:alpha:]]+')) INTO @isPasswordValid;
    	IF CHAR_LENGTH(newPass) < 8 THEN
			set @isPasswordValid = 0;
		END IF;
		if  @isPasswordValid > 0 then
			UPDATE `DB`.system_info SET `DB`.system_info.pass = MD5(newPass) WHERE `DB`.system_info.ID = @id;
			set res = "Updated";
		else
			set res = "Invalid pass";
		end if;
	end;