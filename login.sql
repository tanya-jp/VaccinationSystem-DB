-- DROP PROCEDURE IF EXISTS db.login;
CREATE PROCEDURE `DB`.login(
	in username varchar(30),
    in pw varchar(30),
    out login_time varchar(500),
    out res varchar(500)
)
begin
	IF (EXISTS (SELECT * FROM `DB`.system_info WHERE (`DB`.system_info.ID = username AND `DB`.system_info.pass = MD5(pw)))) then
		INSERT INTO `DB`.login VALUES(username, CURRENT_TIME());
		set login_time = MD5(CURRENT_TIME());
        set res = "success";
	else
		set login_time = MD5(CURRENT_TIME());
		set res = "Wrong username or password!";
	end if;
end;