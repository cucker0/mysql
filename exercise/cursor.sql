# 游标的使用

USE myemployees;

DELIMITER $
    
CREATE PROCEDURE get_count_by_limit_total_salary(IN limit_total_salary DOUBLE, OUT total_count INT)
/*
工资从高到低累加，当累加金额超过指定金额时，所需要的员工数

IN 
	limit_total_salary DOUBLE: 要超过的工资总额数
OUT
	total_count INT: 需要累加的人数
		-1: 表示所有员工工资累加起都不够指定的金额
*/
BEGIN
    -- 声明局部变量
    DECLARE total_salary DOUBLE DEFAULT 0.0;  -- 累加的工资金额总和
    DECLARE n INT DEFAULT 0;  -- 累加员工数量
    DECLARE sal DOUBLE;  -- 临时保存读取到的员工工资
    -- 设置一个标记，表示游标是否为最后一行，0：未到最后一行，1: 到了最后一行
    DECLARE tag TINYINT DEFAULT 0;      
    
    -- 1. 声明游标
    DECLARE deployee_cursor CURSOR FOR SELECT salary FROM myemployees.employees ORDER BY salary DESC;
    -- 设置一个终止标记，当游标无下一行时把tag设置为1
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET tag = 1;
    
    -- 2. 打开游标
    OPEN deployee_cursor;
	
    -- 循环读取游标
    loop1:
    WHILE tag <> 1 DO
        -- 3. 读取游标
        -- 获取游标当前指针的记录，读取一行数据并传给变量a,b，并把游标指针指向下一行(若有下一行)
        -- 每次操作游标前都会触发前面的②语句
        FETCH deployee_cursor INTO sal;
        SET total_salary = total_salary + sal;
        SET n = n + 1;
        -- 跳出循环
        IF total_salary >= limit_total_salary THEN
            LEAVE loop1;
        END IF;
    END WHILE;
	
    IF total_salary >= limit_total_salary THEN
        SET total_count = n;
    ELSE
        SET total_count = -1;
    END IF;

    -- 4. 关闭游标
    CLOSE deployee_cursor;

END$

DELIMITER ;

-- 调用
CALL get_count_by_limit_total_salary(100000, @emp_count);
SELECT @emp_count;

CALL get_count_by_limit_total_salary(900000, @emp_count);
SELECT @emp_count;