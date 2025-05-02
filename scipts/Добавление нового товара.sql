	delimiter $$

	create procedure insert_phone_procedure (in phone_title varchar(255), in price double, in id_country_manufacture int, in id_brand int, in id_color int, in availability tinyint(1), in hardware_list varchar(255), in software_list varchar(255))
	BEGIN
		declare phone_index int;
		declare hardware_count int;
		declare software_count int;
		declare temp_index int;
		
		set hardware_count = string_count(hardware_list);
		set software_count = string_count(software_list);
		
		insert into phone (phone_title, price, id_country_manufacture, id_brand, id_color, availability)
		values (phone_title, price, id_country_manufacture, id_brand, id_color, availability);
		
		set phone_index = last_insert_id();
		set temp_index = 1;
		
		while (hardware_count > temp_index) do
			insert into compatibilityhardware (id_phone, id_hardware)
			values (phone_index, SUBSTRING_INDEX(SUBSTRING_INDEX(hardware_list, ',', temp_index), ',', -1));
			set temp_index = temp_index + 1;
		end while;
		
		set temp_index = 1;
		
		while (software_count > temp_index) do
			insert into factorysoftware (id_phone, id_software)
			values (phone_index, SUBSTRING_INDEX(SUBSTRING_INDEX(software_list, ',', temp_index), ',', -1));
			set temp_index = temp_index + 1;
		end while;
		
	END $$

	delimiter ;