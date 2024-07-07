view视图
==


# view视图
```text
概念：虚拟表，值保存了sql语句逻辑，不保存结果，使用视图时动态生成表数据。
相当于给一组sql语句起了别名，保存在数据库中

view视图主要用于表数据的查询。

使用与普通表一样。
mysql 5.1开始添加此特性
```

## 使用场景
* 多个地方用到同样的查询结果
* 该查询结果使用的sql语句比较复杂

## 使用视图好处
* 重复使用sql语句
* 简化复杂的sql语句，不必知道它的查询细节
* 保护数据，提高安全性

## view视图与表对比
类型      |关键字         |占用空间                    |使用
:--- |:--- |:--- |:---
视图      |create view    |只保存sql逻辑，不保存数据   |主要是查，增删改只能是特殊的操作(简单的，也不建议增删改)
表        |create table   |保存表数据                  |增删改查


## view视图的生命周期
view视图的生命周期是永久，一旦创建后，不手动删除是一直存在的



## 创建视图
* 语法
    ```text
    create view 视图
    as
    查询语句
    ;
    ```

* 案例1：查询姓张的学生名和专业名
    ```mysql
    USE student;
    
    -- 一般的方法
    SELECT s.studentname, m.majorname
    FROM student s
    INNER JOIN major m
    ON s.majorid = m.majorid
    WHERE s.studentname LIKE '张%';
    
    -- view 视图
    -- ①创建视图
    CREATE VIEW myv1
    AS
    SELECT s.studentname, m.majorname
    FROM student s
    INNER JOIN major m
    ON s.majorid = m.majorid
    ;
    
    -- ②使用视图
    SELECT * FROM myv1
    WHERE studentname LIKE '张%';
    ```

* 案例2：查询各部门的平均工资级别
    ```mysql
    -- 常规方法
    -- ①先查询各部门平均工资
    USE myemployees;
    
    SELECT AVG(salary)
    FROM employees
    GROUP BY department_id
    ;
    
    -- ② 将①结果集与工资级别表连接查询
    SELECT avg_dept.s_avg, j.grade_level
    FROM (
        SELECT AVG(salary) AS s_avg
        FROM employees
        GROUP BY department_id
    ) avg_dept
    INNER JOIN job_grades j
    ON avg_dept.s_avg BETWEEN j.lowest_sal AND j.highest_sal;
    
    -- view视图方法
    -- ①创建视图，先查询各部门平均工资
    CREATE VIEW myv2
    AS
    SELECT AVG(salary) AS s_avg
    FROM employees
    GROUP BY department_id;
    
    -- ②使用视图，将①中创建的视图与job_grades连接查询工资等级
    SELECT m.s_avg, j.grade_level
    FROM myv2 AS m
    INNER JOIN job_grades j
    ON m.s_avg BETWEEN j.lowest_sal AND j.highest_sal
    ;
    ```

* 案例3：查询平均工资最低的部门信息
    ```mysql
    -- ①创建视图，查询平均工资最低的部门id
    CREATE VIEW myv3
    AS
    SELECT department_id, AVG(salary)
    FROM employees
    GROUP BY department_id
    ORDER BY AVG(salary)
    LIMIT 1;
    
    
    -- 查看当前库中所有的所有视图
    SHOW TABLE STATUS WHERE COMMENT='view';
    
    -- ②将①视图与departments连接查询部门信息
    SELECT *
    FROM myv3 
    INNER JOIN departments d
    ON myv3.department_id = d.department_id;
    ```

## 修改视图的sql语句
* 语法1
    ```text
    create or replace view 视图名
    as
    查询语句
    ;
    ```
    
* 语法2
    ```text
    alter view 视图名
    as
    查询语句
    ;
    ```

* 示例
    ```mysql
    DESC myv3;
    
    SHOW CREATE VIEW myv3;
    
    -- 方式1
    CREATE OR REPLACE VIEW myv3
    AS
    SELECT AVG(salary), job_id
    FROM employees
    GROUP BY job_id;
    
    SHOW CREATE VIEW myv3;
    
    
    -- 方式2
    ALTER VIEW myv3
    AS 
    SELECT * FROM employees;
    
    SELECT * FROM myv3;
    ```


## 查看视图
* 语法
    ```text
    desc 视图名;
    
    show create view 视图名;
    
    -- 查看本库所有已建的视图
    SHOW TABLE STATUS WHERE COMMENT='view';
    
    ```

* 示例
    ```mysql
    DESC myv3;
    
    SHOW CREATE VIEW myv3;
    
    SHOW TABLE STATUS WHERE COMMENT='view';
    ```

## 删除视图
* 语法
    ```text
    drop view 视图名1 [, 视图名2, ...];
    
    需要有相应的权限才能执行
    ```

* 示例
    ```mysql
    DROP VIEW myv2, myv3;
    
    SHOW TABLE STATUS WHERE COMMENT='view';
    ```

## 视图虚拟表数据可更新情况
```mysql
USE myemployees;

CREATE OR REPLACE VIEW myv1
AS
SELECT last_name, email
FROM employees;

```

* 插入数据
    ```mysql
    SELECT * FROM myv1;
    
    INSERT INTO myv1 VALUES ('张飞', 'zhangfei@qq.com');
    
    SELECT * FROM myv1; -- 已经添加
    
    SELECT * FROM employees; -- 表中已经添加插入的数据，其他字段为null。实际上是对表的更新
    ```

* 修改表数据
    ```mysql
    UPDATE myv1 SET email = 'zf@qq.com' WHERE last_name = '张飞';
    ```

* 删除表记录
    ```mysql
    DELETE FROM myv1 WHERE last_name = '张飞'; 
    ```

## 具备以下特点的视图不可更新(增删改)
1. 包含下列关键字的sql语句
    ```mysql
    -- 分组函数、distinct、group by、having、 union、union all
    USE myemployees;
    
    CREATE OR REPLACE VIEW myv10
    AS
    SELECT AVG(salary) mx, department_id
    FROM employees
    GROUP BY department_id;
    
    SELECT * FROM myv10;
    
    -- 
    UPDATE myv10 SET mx = 20000 WHERE department_id = 10;  -- The target table myv10 of the UPDATE is not updatable
    ```

1. 常量视图
    ```mysql
    CREATE VIEW myv11
    AS
    SELECT 'tuolaji' AS `name`;
    
    --
    SELECT * FROM myv11;
    
    UPDATE myv11 SET `name` = 'aotuo';  -- 不可更新
    ```
1. select中包含字查询的视图
    ```mysql
    CREATE OR REPLACE VIEW myv13
    AS
    SELECT COUNT(*) ct, (SELECT MAX(salary) FROM employees) max_salary
    FROM departments;
    
    --
    SELECT * FROM myv13;
    UPDATE myv13 SET max_salary = 30000;  -- 不可更新

    ```
1. join连表的视图
    ```mysql
    CREATE VIEW myv14
    AS
    SELECT e.last_name, d.department_name
    FROM employees e
    INNER JOIN departments d
    ON e.department_id = d.department_id;
    
    -- 
    SELECT * FROM myv14;
    INSERT INTO myv14 (last_name, department_name) VALUES ('汪洋', 'Adm');  -- 不可插入数据
    UPDATE myv14 SET last_name = 'daerwen' WHERE last_name = 'Whalen';  -- 更新成功
    UPDATE myv14 SET department_name = 'IT' WHERE department_name = 'Adm';  -- 更新成功
    ```
    
1. from 一个不能更新的视图
    ```mysql
    CREATE VIEW myv15
    AS
    SELECT * FROM myv10;
    
    --
    SELECT * FROM myv15;
    UPDATE myv15 set mx = 100000 WHERE department_id = 100; -- 不可更新
    ```

1. where子句的子查询引用了from子句中的表构成的视图
    ```mysql
    CREATE VIEW myv16
    AS
    SELECT employee_id, last_name, email, salary  -- 查询所有管理者信息
    FROM employees
    WHERE employee_id = ANY (
        SELECT DISTINCT manager_id
        FROM employees
        WHERE manager_id IS NOT NULL
    )
    ;
    
    --
    SELECT * FROM myv16;
    UPDATE myv16 SET salary = 90000 WHERE last_name = 'Weiss';  -- 不可更新
    ```