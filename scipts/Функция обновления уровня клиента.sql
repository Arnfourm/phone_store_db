DELIMITER $$

create function GetClientLevel(client_id int)
returns int
deterministic
begin
	declare volume_client double;
    declare client_level_insert int;
    
    set volume_client = (select volume from client where id_client = client_id);
    set client_level_insert = (
		select cl.id_client_level from clientlevel cl
        where volume_client >= cl.required_value
        order by cl.required_value desc
        limit 1
	);

	return client_level_insert;
end$$

DELIMITER ;