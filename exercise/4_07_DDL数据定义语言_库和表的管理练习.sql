-- 库和表的管理



# 1.创建表dept1
/* 
+-------+-----------+
|NAME	|TYPE       |
+-------+-----------+
|id		|INT(7)     |
|name   |VARCHAR(25)|
+-------+-----------+

*/

CREATE TABLE test.dept1 (
    id INT,
    `name` VARCHAR (25)
);

USE test;
DESC dept1;

# 2.将库myemployees表departments中的数据插入新表dept2中
CREATE TABLE dept2
SELECT employee_id id, CONCAT(first_name, ' ', last_name) AS `name` FROM myemployees.`employees`;

SELECT * FROM dept2;

# 3.创建表emp5
/*
+-----------+-------------+
|NAME       |TYPE         |
+-----------+-------------+
|id		    |INT(7)       |
|first_name	|VARCHAR (25) |
|last_name	|VARCHAR(25)  |
|dept_id	|INT(7)       |
+-----------+-------------+
*/
CREATE TABLE emp5 (
    id INT (7),
    first_name VARCHAR (25),
    last_name VARCHAR (25),
    dept_id INT (7)
);

DESC emp5;

# 4.将列last_name的长度增加到50
ALTER TABLE emp5 MODIFY COLUMN last_name VARCHAR (50);

# 5.根据myemployees库的表employees创建employees2(在test库中)
CREATE TABLE employees2 LIKE
myemployees.`employees`;

DESC employees2;
SELECT * FROM employees2;


INSERT INTO employees2
SELECT * FROM  myemployees.`employees`;

# 6.删除表emp5
DROP TABLE emp5;

# 7.将表employees2重命名为emp5
ALTER TABLE employees2 RENAME emp5;
DESC emp5;

SELECT * FROM emp5;

# 8.在表dept1和emp5中添加新列test_column，并检查所作的操作
ALTER TABLE dept1 ADD COLUMN test_column INT;
DESC dept1;

ALTER TABLE emp5 ADD COLUMN test_column INT;
DESC emp5;

# 9.直接删除表emp5中的列 department_id
ALTER TABLE emp5 DROP COLUMN department_id;



