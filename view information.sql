-- DROP PROCEDURE IF EXISTS db.viewInfo;
CREATE PROCEDURE `DB`.viewInfo (
	in login_time varchar(64)
	)
	begin
		set @id = "";
		SELECT ID into @id FROM `DB`.login WHERE MD5(`DB`.login.login_time) = login_time;
		select *
		from `DB`.system_info
		join `DB`.person_info
		on `DB`.system_info.ID = `DB`.person_info.ID
		WHERE `DB`.system_info.ID = @id;
	end;
	