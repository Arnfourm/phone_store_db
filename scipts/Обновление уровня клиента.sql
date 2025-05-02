DELIMITER $$

create trigger client_level_update_trigger
after insert on sale for each row
begin
    update client
    set id_client_level = GetClientLevel(new.id_client)
    where id_client = new.id_client;
end$$

DELIMITER ;