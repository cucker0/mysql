# Trigger触发器

# 准备工作
CREATE DATABASE trigg;
USER trigg;

CREATE TABLE test_trigger (
id INT PRIMARY KEY AUTO_INCREMENT,
t_node VARCHAR(32)
);

CREATE TABLE trigger_log (
id INT PRIMARY KEY AUTO_INCREMENT,
t_log VARCHAR(255)
);



# 示例1
/*
创建名称为"before_insert_trigger"的触发器，向 test_trigger表 中插入数据之前，
向 trigger_log 表插入日志信息
*/
DELIMITER $$

CREATE TRIGGER before_insert_trigger
BEFORE INSERT ON test_trigger
FOR EACH ROW
BEGIN
    DECLARE tab_id INT;
    SELECT AUTO_INCREMENT INTO tab_id FROM information_schema.`TABLES` 
    WHERE Table_Schema='trigg' AND table_name = 'test_trigger' LIMIT 1;
    
    INSERT INTO trigger_log(t_log) VALUES
    (CONCAT(NOW(), ' [BEFORE INSERT]  test_trigger.id: ', tab_id, '. record insert'));
END;
$$

DELIMITER ;

## 注意
/*
NEW：表示要插入的这条记录对象
OLD：表示这条记录值为被更新之前的对象
*/

-- 测试
INSERT INTO test_trigger(t_node) VALUES
('so good.');

-- 查看数据
SELECT * FROM test_trigger;
/*
    id  t_node    
------  ----------
     1  so good.  
*/

SELECT * FROM trigger_log;
/*
    id  t_log                                                                   
------  ------------------------------------------------------------------------
     1  2022-01-03 15:07:53 [BEFORE INSERT]  test_trigger.id: 1. record insert   
*/

# 示例2
/*
创建名称为"after_insert_trigger"的触发器，向 test_trigger表 中插入数据之后，
向 trigger_log 表插入'[AFTER INSERT]'日志信息
*/
DELIMITER $$

CREATE TRIGGER after_insert_trigger
AFTER INSERT ON test_trigger
FOR EACH ROW
BEGIN
    INSERT INTO trigger_log(t_log) VALUES
    (CONCAT(NOW(), ' [AFTER INSERT]'));
END;
$$

DELIMITER ;

-- 测试
INSERT INTO test_trigger(t_node) VALUES
('so funny.');

-- 查看数据
SELECT * FROM test_trigger;
/*
    id  t_node     
------  -----------
     1  so good.   
     2  so funny.   
*/

SELECT * FROM trigger_log;
/*
    id  t_log                                                                   
------  ------------------------------------------------------------------------
     1  2022-01-03 15:22:44 [BEFORE INSERT]  test_trigger.id: 1. record insert  
     2  2022-01-03 15:23:50 [BEFORE INSERT]  test_trigger.id: 2. record insert  
     3  2022-01-03 15:23:50 [AFTER  INSERT]                                                                               
*/

# 示例3
/*
定义触发器"salary_check_trigger"，基于员工表"employees"的INSERT事件，
在INSERT之前检查将要添加的新员工的薪资是否大于他领导的薪资，如果大于他
领导的薪资，则报SQLSATE值为'HY000'的错误，从而使得添加记录操作失败

*/

## 数据准备
CREATE TABLE employees AS
SELECT * FROM myemployees.employees;

CREATE TABLE departments AS
SELECT * FROM myemployees.departments;

-- 创建触发器
DELIMITER $$

CREATE TRIGGER salary_check_trigger
BEFORE INSERT ON employees
FOR EACH ROW 
BEGIN
    -- 
    DECLARE manager_salary DOUBLE;
    SELECT salary INTO manager_salary FROM employees
    WHERE employee_id = NEW.manager_id;
    
    IF NEW.salary > manager_salary THEN
        -- 抛出异常
        SIGNAL SQLSTATE 'HY000' SET MESSAGE_TEXT = '薪资高于领导薪资错误';
    END IF;
END;
$$

DELIMITER ;


-- 测试
SELECT salary FROM employees WHERE employee_id = 100;  -- 24000

-- 插入失败
INSERT INTO employees (first_name, last_name, manager_id, salary) VALUES
('Bo', 'Yanyi', 100, 80000);
/*
1 queries executed, 0 success, 1 errors, 0 warnings

查询：insert into employees (first_name, last_name, manager_id, salary) values ('Bo', 'Yanyi', 100, 80000)

错误代码： 1644
薪资高于领导薪资错误

*/

INSERT INTO employees (first_name, last_name, manager_id, salary) VALUES
('Bo', 'Yanyi', 100, 10000);   -- 能够正常插入，这里同样也会激活触发器salary_check_trigger


# 查看当前数据库的触发器，方式1
SHOW TRIGGERS;
/*
mysql> show triggers \G;
*************************** 1. row ***************************
             Trigger: salary_check_trigger
               Event: INSERT
               Table: employees
           Statement: begin
    --
    declare manager_salary double;
    select salary into manager_salary from employees
    where employee_id = NEW.manager_id;

    if NEW.salary > manager_salary then
        -- 抛出异常
        SIGNAL sqlstate 'HY000' set MESSAGE_TEXT = '薪资高于领导薪资错误';
    end if;
end
              Timing: BEFORE
             Created: 2022-01-03 15:52:09.78
            sql_mode: ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION
             Definer: root@localhost
character_set_client: utf8
collation_connection: utf8_general_ci
  Database Collation: utf8_general_ci
*************************** 2. row ***************************
             Trigger: before_insert_trigger
               Event: INSERT
               Table: test_trigger
           Statement: begin
    declare tab_id int;
    SELECT AUTO_INCREMENT into tab_id FROM information_schema.`TABLES`
    WHERE Table_Schema='trigg' AND table_name = 'test_trigger' LIMIT 1;

    insert into trigger_log(t_log) values
    (concat(NOW(), ' [BEFORE INSERT]  test_trigger.id: ', tab_id, '. record insert'));
end
              Timing: BEFORE
             Created: 2022-01-03 15:22:40.74
            sql_mode: ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION
             Definer: root@localhost
character_set_client: utf8
collation_connection: utf8_general_ci
  Database Collation: utf8_general_ci
*************************** 3. row ***************************
             Trigger: after_insert_trigger
               Event: INSERT
               Table: test_trigger
           Statement: BEGIN
    INSERT INTO trigger_log(t_log) VALUES
    (CONCAT(NOW(), ' [AFTER INSERT]'));
END
              Timing: AFTER
             Created: 2022-01-03 15:23:46.92
            sql_mode: ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION
             Definer: root@localhost
character_set_client: utf8
collation_connection: utf8_general_ci
  Database Collation: utf8_general_ci
3 rows in set (0.00 sec)

*/

-- 查看触发器方式2
SHOW CREATE TRIGGER before_insert_trigger;

-- 查看触发器方式3
SELECT * FROM information_schema.TRIGGERS;


# 删除触发器
DROP TRIGGER before_insert_trigger;

DROP TRIGGER IF EXISTS before_insert_trigger;


