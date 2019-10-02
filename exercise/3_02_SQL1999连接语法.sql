-- SQL:1999连接语法

# SQL-92与SQLSQL:1999对比
/*
功能：SQL:1999比SQL-92的多
可读性：因为SQL:1999的连接条件与筛选条件分离，所有可读性更高

*/


/*
语法：
select 查询列表
from 表1 别名1
连接类型 join 表2 别名2
on 连接条件
[where 筛选条件]
[group by 分组字段或表达式]
[having 分组后筛选条件]
[order by 排序列表];


## 连接类型分类
* 内连接(筛选出的结果为第一张表与第二张表分别对应的记录)
inner join

* 外连接
* 左外连接
    left [outer] join
* 右外连接
    right [outer] join
* 全外连接(mysql不支持,Sqlserver、Oracle、PostgreSQL，mysql用 left outer join +  union  + right outer join代替 )
    full [outer] join

* 交叉连接
cross join

*/


-- 内连接
-- 
/*
语法：
select 查询列表
from 表1 别名1 
[inner] join 表2 别名2
on 连接条件
[inner join 表3 on 连接条件];


## 内连接分类
* 等值内连接
* 非等值内连接
* 自连接内连接


## 特点
* 可以添加筛选、分组、分组后筛选、排序
* inner关键字可以省略，只有join关键字时，表示为内连接
* inner join内连接与sql-92语法中的连接效果是一样的，都是多表的交集
* 查询结果集与两表顺序无关，调换两表的先后顺序查询结果集仍一样

*/


-- 等值内连接
-- 

# 案例1.查询员工名、部门名
SELECT e.first_name, d.department_name 
FROM employees e
INNER JOIN departments d
ON e.department_id = d.department_id;

--
SELECT e.first_name, d.department_name
FROM departments d
INNER JOIN employees e 
ON e.department_id = d.department_id;


# 案例2.查询名字中包含e的员工名和工种名（添加筛选）
SELECT
e.first_name, j.job_title
FROM employees e
INNER JOIN jobs j
ON e.job_id = j.job_id
WHERE e.first_name LIKE '%e%';

--
SELECT
e.first_name, j.job_title
FROM employees e
JOIN jobs j
ON e.job_id = j.job_id
WHERE e.first_name LIKE '%e%';


# 案例3.查询部门个数>3的城市名和部门个数（添加分组+筛选）
SELECT l.city, COUNT(*) 部门个数
FROM locations l
INNER JOIN departments d
ON l.location_id = d.location_id
GROUP BY l.city
HAVING COUNT(*) > 3;


# 案例4.查询哪个部门的员工个数>3的部门名和员工个数，并按个数降序（添加排序）
SELECT d.department_name, COUNT(*) 员工个数
FROM departments d
INNER JOIN employees e
ON d.department_id = e.department_id
GROUP BY d.department_id
HAVING 员工个数 > 3
ORDER BY 员工个数 DESC;

# 5.查询员工名、部门名、工种名，并按部门名降序（添加三表连接）
SELECT e.first_name, d.department_name, j.job_title
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
INNER JOIN jobs j ON e.job_id = j.job_id;



-- 非等值内连接
-- 

# 查询员工的工资级别
SELECT e.salary, g.grade_level
FROM employees e
INNER JOIN job_grades g
ON e.salary >= g.lowest_sal AND e.salary <= g.highest_sal;

--
SELECT e.salary, g.grade_level
FROM employees e
INNER JOIN job_grades g
ON e.salary BETWEEN g.lowest_sal AND g.highest_sal;

# 查询工资级别的员工个数>20的个数，并且按工资级别降序
SELECT COUNT(*) 员工个数, g.grade_level
FROM employees e
INNER JOIN job_grades g
ON e.salary BETWEEN g.lowest_sal AND g.highest_sal
GROUP BY g.grade_level
HAVING COUNT(*) > 20
ORDER BY g.grade_level DESC;


-- 自连接(自连内连接)
-- 

# 查询员工的名字、上级的名字
SELECT e.first_name, e.employee_id, m.first_name AS 上级, e.manager_id
FROM employees e
INNER JOIN employees m
ON e.manager_id = m.employee_id

# 查询姓名中包含字符k的员工的名字、上级的名字
SELECT e.first_name, m.first_name AS 上级
FROM employees e
INNER JOIN employees m
ON e.manager_id = m.employee_id
WHERE e.first_name LIKE '%k%';



-- 外连接
-- 
/*
应用场景：用于查询再一个表中(主表)有，另一个表(从表)没有对应的记录


特点：
* 外连接的查询结果为主表中的所有记录
* 如果从表中有和它匹配的，则显示匹配的值
* 如果从表中没有和它匹配的，则从表该记录所有字段都显示null
* 外连接查询结果 = 内连接结果 + 主表中有而从表中没有匹配的记录
* 左外链接，left join 左边的是主表
* 右外连接，right join 右边的是主表
* 全外连接 = 内连接结果 + 表1中有但表2中没有的 + 表2中有单表1中没有的 记录
或 = 表1 left join 表2结果 + 表1 right join 表2结果 的并集 （这里会出现重叠的集合：表1 inner join 表2）

* 左外连接、右外连接的主表和从表位置不能调换


*/


# 引入：查询男朋友 不在男神表的的女神名
USE girls;

SELECT * FROM beauty;

SELECT * FROM boys;


SELECT * 
FROM beauty, boys;

SELECT * 
FROM beauty
WHERE boyfriend_id NOT IN (SELECT id FROM boys);


# 左外连接
SELECT *
FROM beauty b
LEFT OUTER JOIN boys bo
ON b.boyfriend_id = bo.id
WHERE bo.id IS NULL;

--
SELECT *
FROM beauty b
LEFT OUTER JOIN boys bo
ON b.boyfriend_id = bo.id
WHERE NOT (bo.id <=> NULL);

# 案例1：查询哪个部门没有员工
    -- 左外连接
USE myemployees;

SELECT d.*, ' <--->', e.*
FROM departments d    
LEFT JOIN employees e
ON d.department_id = e.department_id

WHERE e.employee_id IS NULL;

    -- 右外连接
SELECT d.*, ' <--->', e.*
FROM  employees e
RIGHT OUTER JOIN departments d
ON e.department_id = d.department_id
WHERE e.employee_id IS NULL;


# 全外连接
/*
语法：
select 查询列表
from 表1 别名1
full outer join 表2 别名2
on 连接条件
*/


-- 因为mysql不支持全外连接full outer join语法，系列语句执行时报错语法错误
USE girls;

SELECT *
FROM beauty b
FULL OUTER JOIN boys bo
ON b.boyfriend_id = bo.id;

-- mysql中全外连接代替方法
SELECT * 
FROM beauty b
LEFT OUTER JOIN boys bo
ON b.boyfriend_id = bo.id

UNION

SELECT * 
FROM beauty b
RIGHT OUTER JOIN boys bo
ON b.boyfriend_id = bo.id;


-- 交叉链接(即笛卡尔乘积)
-- 
SELECT * 
FROM beauty b
CROSS JOIN boys bo;


-- 效果等效(SQL-92语法)
SELECT *
FROM beauty, boys;


SELECT * FROM boys;

