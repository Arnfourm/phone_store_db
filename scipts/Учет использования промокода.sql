DELIMITER $$

create trigger promocode_uses_trigger
after insert on amountdue for each row
begin
	if new.id_promocode_used is not null then
		update promocode
        set uses_left = uses_left - 1
        where id_promocode = new.id_promocode_used;
	end if;
end$$

DELIMITER ;