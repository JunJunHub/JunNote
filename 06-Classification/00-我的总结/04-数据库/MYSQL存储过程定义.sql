USE mpuaps;
SET global log_bin_trust_function_creators=TRUE;


-- 此函数是将一个中文字符串的第一个汉字转成拼音字母 （例如：“李”->l）,包括特殊字符处理，可以进行动态添加
DELIMITER $$
CREATE DEFINER=`root`@`%` FUNCTION `get_first_pinyin_char`(PARAM VARCHAR(255)) RETURNS varchar(2) CHARSET utf8mb4
BEGIN
	DECLARE V_RETURN VARCHAR(255);
	DECLARE V_FIRST_CHAR VARCHAR(2);
	SET V_FIRST_CHAR = UPPER(LEFT(PARAM,1));
	SET V_RETURN = V_FIRST_CHAR;
	IF LENGTH( V_FIRST_CHAR) <> CHARACTER_LENGTH( V_FIRST_CHAR ) THEN
	SET V_RETURN = ELT(INTERVAL(CONV(HEX(LEFT(CONVERT(PARAM USING gbk),1)),16,10),
		0xB0A1,0xB0C5,0xB2C1,0xB4EE,0xB6EA,0xB7A2,0xB8C1,0xB9FE,0xBBF7,
		0xBFA6,0xC0AC,0xC2E8,0xC4C3,0xC5B6,0xC5BE,0xC6DA,0xC8BB,
		0xC8F6,0xCBFA,0xCDDA,0xCEF4,0xD1B9,0xD4D1),
	'A','B','C','D','E','F','G','H','J','K','L','M','N','O','P','Q','R','S','T','W','X','Y','Z');
	END IF;
	RETURN V_RETURN;
END $$

DELIMITER ;


DELIMITER $$

CREATE DEFINER=`root`@`%` FUNCTION `get_first_pinyin_char`(PARAM VARCHAR(255)) RETURNS VARCHAR(2) CHARSET utf8mb4
BEGIN
    DECLARE V_FIRST_CHAR VARCHAR(2);
    
    SET V_FIRST_CHAR = UPPER(LEFT(PARAM, 1));

    IF LENGTH(V_FIRST_CHAR) <> CHARACTER_LENGTH(V_FIRST_CHAR) THEN
        SET V_FIRST_CHAR = ELT(
            INTERVAL(
                CONV(
                    HEX(LEFT(CONVERT(PARAM USING gbk), 1)),
                    16,
                    10
                ),
                0xB0A1,0xB0C5,0xB2C1,0xB4EE,0xB6EA,0xB7A2,0xB8C1,0xB9FE,0xBBF7,
                0xBFA6,0xC0AC,0xC2E8,0xC4C3,0xC5B6,0xC5BE,0xC6DA,0xC8BB,
                0xC8F6,0xCBFA,0xCDDA,0xCEF4,0xD1B9,0xD4D1
            ),
            'A','B','C','D','E','F','G','H','J','K','L','M','N','O','P','Q','R','S','T','W','X','Y','Z'
        );
    END IF;

    RETURN V_FIRST_CHAR;
END $$

DELIMITER ;


DELIMITER $$

CREATE DEFINER=`root`@`%` FUNCTION `pinyin`(P_NAME VARCHAR(255)) RETURNS VARCHAR(255) CHARSET utf8mb4
BEGIN
    DECLARE V_RETURN VARCHAR(255);
    DECLARE V_COMPARE VARCHAR(255);
    DECLARE I INT;

    SET I = 1;
    SET V_RETURN = '';

    WHILE I < LENGTH(P_NAME) DO
        SET V_COMPARE = SUBSTR(P_NAME, I, 1);
        IF V_COMPARE != '' THEN
            SET V_RETURN = CONCAT(V_RETURN, get_first_pinyin_char(V_COMPARE));
        END IF;
        SET I = I + 1;
    END WHILE;

    IF ISNULL(V_RETURN) OR V_RETURN = '' THEN
        SET V_RETURN = P_NAME;
    END IF;

    RETURN V_RETURN;
END $$

DELIMITER ;




-- 此函数是将一个中文字符串对应拼音字母每个相连 (例如：“李佳航”->ljh（或者说”张伟“-zw）)
DELIMITER $$
CREATE DEFINER=`root`@`%` FUNCTION `pinyin`(P_NAME VARCHAR(255)) RETURNS varchar(255) CHARSET utf8mb4
BEGIN
    DECLARE V_COMPARE VARCHAR(255);
    DECLARE V_RETURN VARCHAR(255);
    DECLARE I INT;
  
    SET I = 1;
    SET V_RETURN = '';
    while I < LENGTH(P_NAME) do
        SET V_COMPARE = SUBSTR(P_NAME, I, 1);
        IF (V_COMPARE != '') THEN
            #SET V_RETURN = CONCAT(V_RETURN, ',', V_COMPARE);
            SET V_RETURN = CONCAT(V_RETURN, get_first_pinyin_char(V_COMPARE));
            #SET V_RETURN = fristPinyin(V_COMPARE);
        END IF;
        SET I = I + 1;
    end while;
    IF (ISNULL(V_RETURN) or V_RETURN = '') THEN
        SET V_RETURN = P_NAME;
    END IF;
    RETURN V_RETURN;
END $$
DELIMITER ;

-- where pinyin ( ‘字段’) LIKE concat( ‘%’, #{dto.firstChar},‘%’ );


DELIMITER $$
CREATE FUNCTION InitAreaTable (minNum INT)
	RETURNS INT
	
	BEGIN
		DECLARE areaTableRowCount INT;
		select count(*) into areaTableRowCount from casbin_rule where 1=1;
		IF areaTableRowCount<minNum THEN SET areaTableRowCount=0;
		END IF;
		
		RETURN areaTableRowCount;
	END $$
DELIMITER ;


InitAreaTable(100);


-- SQL存储过程 修改新增表字段前判断字段是否存在

-- 判断字段不存在则增加该字段
DROP PROCEDURE if EXISTS proc_add_column;
delimiter $$
CREATE PROCEDURE `proc_add_column`(in var_table_name varchar(64),in var_column_name varchar(64),in var_sqlstr varchar(1024))
top:begin
    -- 表不存在则直接返回
    set @p_tablenum='';
    set @sqlstr1=concat('select count(table_name)into @p_tablenum from information_schema.tables where table_schema=database() and table_name=\'',var_table_name,'\' limit 1;');
    prepare stmt1 from @sqlstr1;
    execute stmt1;
    deallocate prepare stmt1;
    if(@p_tablenum<1)then
        leave top;
    end if;

    -- 字段已存在则直接返回
    set @p_columnnum='';
    set @sqlstr=concat('select count(column_name) into @p_columnnum from information_schema.columns where table_schema=database() and table_name=\'',var_table_name,'\'and column_name =\'',var_column_name,'\';');
    prepare stmt2 from @sqlstr;
    execute stmt2;
    deallocate prepare stmt2;
    if(@p_columnnum>0)then
        leave top;
    end if;

    -- 表存在且字段不存在则创建新字段
    set @sqlcmd=var_sqlstr;
    prepare stmt3 from @sqlcmd;
    execute stmt3;
    deallocate prepare stmt3;
end $$
delimiter ;




-- 修改表字段的函数
DROP PROCEDURE if EXISTS proc_modify_column;
delimiter $$
CREATE PROCEDURE `proc_modify_column`(in var_table_name varchar(64),in var_column_name varchar(64),in var_sqlstr varchar(1024))
top:begin

    -- 表不存在则直接返回
    set @p_tablenum='';
    set @sqlstr1=concat('select count(table_name)into @p_tablenum from information_schema.tables where table_schema=database() and table_name=\'',var_table_name,'\' limit 1;');
    prepare stmt1 from @sqlstr1;
    execute stmt1;
    deallocate prepare stmt1;
    if(@p_tablenum<1)then
        leave top;
    end if;

    -- 字段不存在则直接返回
    set @p_columnnum='';
    set @sqlstr=concat('select count(column_name) into @p_columnnum from information_schema.columns where table_schema=database() and table_name=\'',var_table_name,'\'and column_name =\'',var_column_name,'\';');
    prepare stmt2 from @sqlstr;
    execute stmt2;
    deallocate prepare stmt2;
    if(@p_columnnum<=0)then
        leave top;
    end if;


    -- 表存在且字段存在则修改字段
     set @sqlcmd=var_sqlstr;
     prepare stmt3 from @sqlcmd;
     execute stmt3;
     deallocate prepare stmt3;

    end $$
delimiter ;

-- 新增字段
call proc_add_column(
        '表名',
        '新增字段名',
        'ALTER TABLE `表名` ADD COLUMN `新增字段名` double(11, 4) NULL COMMENT ''字段说明'' AFTER`id`');
		
-- 修改字段
call proc_modify_column(
        '表名',
        '字段名',
        'ALTER TABLE `表名` MODIFY COLUMN `字段名` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) AFTER `id`');