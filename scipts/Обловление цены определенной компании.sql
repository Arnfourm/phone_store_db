DELIMITER $$

create procedure update_phone_price_by_manufacturer (in brand_title varchar(50), in percent_price_change double)
begin
	declare id_brand_update int;
    set id_brand_update = (select id_brand from brand b where b.brand_title = brand_title);
    
	update phone p
	set p.price = round(p.price * percent_price_change, 2)
	where p.id_brand = id_brand_update;
end$$
    
DELIMITER ;