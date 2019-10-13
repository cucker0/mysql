-- view视图


/*
概念：虚拟表，值保存了sql逻辑，不保存结果，使用视图时动态生成表数据。
相当于给一组sql语句起了别名
与普通表一样使用。mysql 5.1开始添加此特性

## 使用场景
* 多个地方用到同样的查询结果
* 该查询结果使用的sql语句比较复杂

## 好处
* 重用sql语句
* 简化复杂的sql语句，不必知道它的查询细节
* 保护数据，提高安全性

## view视图与表对比
类型      关键字         占用空间                    使用
视图      create view    只保存sql逻辑，不保存数据   主要是查，增删改只能是特殊的操作(简单的，也不建议增删改)
表        create table   保存表数据                  增删改查


## view视图的生命周期是永久，一旦创建后，不手动删除是一直存在的
*/


-- 创建视图
/*
## 语法
create view 视图
as
查询语句
;

*/


# 案例1：查询姓张的学生名和专业名
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


# 案例2：查询各部门的平均工资级别

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

# 案例3：查询平均工资最低的部门信息
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



-- 视图的修改
-- 
/*
## 语法1
create or replace view 视图名
as
查询语句
;


## 语法2
alter view 视图名
as
查询语句
;

*/


