DELIMITER $$

create procedure insert_client_procedure (in client_name varchar(50), in client_surname varchar(50), in client_thirdname varchar(70), in phone_number varchar(11), in email varchar(100))
begin
	insert into client (name, surname, thirdname, id_client_level, phone, email)
    values (client_name, client_surname, client_thirdname, 1, phone_number, email);
end$$

DELIMITER ; 