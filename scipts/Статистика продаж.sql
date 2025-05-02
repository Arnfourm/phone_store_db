DELIMITER $$

create procedure getStatistics(client_level int, job_title int, retail_outlet int)
deterministic
begin
	declare count int default 0;
    declare all_volume double default 0;
    declare last_date date default null;
    declare finished int default 0;
    
    declare v_id_retail_outlet int;
    declare v_date date;
    declare v_id_job_title int;
    declare v_id_client_level int;
    declare v_amount_due double;
    
    declare sale_cursor cursor for
		SELECT s.id_retail_outlet, s.date, e.id_job_title, c.id_client_level, ad.amount_due
        from Sale s
        join Employee e on s.id_employee = e.id_employee
        join Client c on s.id_client = c.id_client
        join AmountDue ad on s.id_amount_due = ad.id_amount_due;
        
	declare continue handler for not found set finished = 1;
    
    create temporary table if not exists temp_sale_statistics(
        id_client_level int,
        id_job_title int,
        id_retail_outlet int,
        count_sale int default 0,
        sales_volume double default 0,
        last_sale_date date
	);
    
    truncate table temp_sale_statistics;
    
    open sale_cursor;
    
    findLoop:loop
		fetch sale_cursor into v_id_retail_outlet, v_date, v_id_job_title, v_id_client_level, v_amount_due;

		if finished = 1 then
			leave findLoop;
		End if;
		
        if (client_level is null or v_id_client_level = client_level)
        and (job_title is null or v_id_job_title = job_title)
        and (retail_outlet is null or v_id_retail_outlet = retail_outlet)
		then
			set count = count + 1;
            set all_volume = all_volume + v_amount_due;
            
            if (last_date is null or v_date > last_date) then
				set last_date = v_date;
			end if;
		end if;
	end loop;
    
    close sale_cursor;
    
    insert into temp_sale_statistics (id_retail_outlet, id_job_title, id_client_level, count_sale, sales_volume, last_sale_date)
    values (retail_outlet, job_title, client_level, count, round(all_volume, 2), last_date);
    
    select * from temp_sale_statistics;
end $$

DELIMITER ;