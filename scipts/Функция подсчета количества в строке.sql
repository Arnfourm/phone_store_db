DELIMITER $$

create function string_count(StringList varchar(255))
returns int
deterministic
begin
	declare count int;
    
    set count = (LENGTH(StringList) - LENGTH(REPLACE(StringList, ',', '')) + 1);
    
    return count;
end $$

DELIMITER ;