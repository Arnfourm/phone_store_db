DELIMITER $$

create procedure insert_sale_procedure ( in id_promocode int, in id_employee int, in id_retail_outlet int, in id_client int, in id_type_of_delivery int, in id_type_of_payment int, in product_list varchar(255))
BEGIN
	declare bonuses_count_insert double;
    declare promocode_discount double default 0;
    declare client_level_discount double;
    declare purchase_bonuses_insert double;
	declare last_insert_id_value int;
    declare product_id varchar(255);
    declare index_product int default 1;
    declare product_count int;
    declare principal_amount double default 0;
    
    set product_count = string_count (product_list);
    
    while index_product <= product_count do
		set product_id = SUBSTRING_INDEX(SUBSTRING_INDEX(product_list, ',', index_product), ',', -1);
		
        set principal_amount = principal_amount + (select price from phone where id_phone = product_id);
		
        set index_product = index_product + 1;
	end while;
    
    update client c
    set c.volume = c.volume + principal_amount
    where c.id_client = id_client;
    
    set bonuses_count_insert = (select bonuses_count from client c where c.id_client = id_client);
	if promocode_discount is not null then
		set promocode_discount = (select discount from promocode p where p.id_promocode = id_promocode);
    end if;
    set client_level_discount = (select discount from clientlevel cl where cl.id_client_level = (select id_client_level from client c where c.id_client = id_client));
	
    insert into amountdue (principal_amount, bonuses_used, id_promocode_used, amount_due)
    values (principal_amount, bonuses_count_insert, id_promocode, round((principal_amount - bonuses_count_insert - (principal_amount * promocode_discount) - (principal_amount * client_level_discount)), 2));
	
    set last_insert_id_value = last_insert_id();
    set purchase_bonuses_insert = round((select amount_due * 0.005 from amountdue where id_amount_due = last_insert_id_value), 2);
    
    insert into sale (id_employee, id_retail_outlet, id_client, id_amount_due, purchase_bonuses, date, id_type_of_delivery, id_type_of_payment)
	values (id_employee, id_retail_outlet, id_client, last_insert_id_value, purchase_bonuses_insert, NOW(), id_type_of_delivery, id_type_of_payment);
    
    update client c
    set c.bonuses_count = purchase_bonuses_insert
    where c.id_client = id_client;
    
    set last_insert_id_value = last_insert_id();
	set index_product = 1;
    
    while index_product <= product_count do
		set product_id = SUBSTRING_INDEX(SUBSTRING_INDEX(product_list, ',', index_product), ',', -1);
		
		insert into productsale (id_sale, id_product)
		values (last_insert_id_value, product_id);
		
        set index_product = index_product + 1;
	end while;
END $$

DELIMITER ;