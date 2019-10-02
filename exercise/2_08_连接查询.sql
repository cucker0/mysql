-- 连接查询



/*
概念：即多表查询，把多个表根据一定的条件连起来，当成一个大表来查询。
当查询的字段来自多个表时，就会用到连接查询

##笛卡尔乘积现象（等价于交叉连接）：
表1 有m行，
表2 有n行，
查询结果集= m*n 行，即表1中的每行与表2中的所有行都连接

* 发生原因：没有指定有效的连接条件
* 避免方法：添加有效的连接条件

## 连接查询分类
### 按sql标准发布年份分
最新的有SQL:2016标准：增加行模式匹配、多态表函数、JSON功能
* SQL-92(SQL2)
    仅支持内连接

* SQL:1999(SQL3)
推荐使用，功能更强，连接条件与筛选条件分离，可读性更好
支持 内连接、左外连接、右外连接、全外连接(mysql不支持)、交叉连接

### 按功能分类
* 内连接
    * 等值连接
    * 非等值连接
    * 自连接
* 外连接
    * 左外连接
    * 右外连接
    * 全连接
* 交叉连接



*/


-- SQL-92标准连接语法
--
-- 执行girls.sql脚本，创建girls及相应的表


/*
语法：
select 查询列表
from 表1 别名1, 表2 别名2
where 连接条件
[and 其它筛选条件]
[group by 分组字段]
[having 分组后筛选条件]
[order by 排序字段或表达式 排序方式]


其中表1、表2可以为同一个表，表示自连接，
注意：起了别名后，原来的表名在不可用


select 查询列表
from 表1 别名1, 表2 别名2, 表3 别名3
where 表1与表2连接条件
and 表2与表3连接条件或者是表1与表3连接条件
[and 其它筛选条件]
[group by 分组字段]
[having 分组后筛选条件]
[order by 排序字段或表达式 排序方式]

*/

-- 笛卡尔乘积现象（等价于交叉连接）

USE girls;

SELECT * FROM beauty; -- 12行
SELECT * FROM boys; -- 4行

SELECT beauty.*, boys.*
FROM beauty, boys; -- 48行

-- 等值连接(相当于取两表的连接条件相等的交集记录)
--
# 案例1：查询女神名和对应的男神名
SELECT NAME, boyName
FROM beauty, boys
WHERE beauty.`boyfriend_id` = boys.`id`;

--
SELECT *
FROM beauty, boys
WHERE beauty.`boyfriend_id` = boys.`id`;

-- 案例2：查询员工名和对应的部门名
USE myemployees;

SELECT first_name, department_name
FROM employees, departments
WHERE employees.`department_id` = departments.`department_id`;


-- 为表起别名
--
# 查询员工名、工种号、工种名
SELECT first_name, j.job_id, job_title
FROM employees AS e, jobs AS j
WHERE e.`job_id` = j.`job_id`;


-- 两个表的顺序可以调换，结果完全一样
SELECT first_name, j.job_id, job_title
FROM jobs AS j, employees AS e
WHERE e.`job_id` = j.`job_id`;


-- 可以添加筛选条件
# 案例：查询有奖金的员工名、部门名
SELECT e.first_name, d.department_name, e.commission_pct
FROM employees e, departments d
WHERE e.department_id = d.department_id
AND commission_pct IS NOT NULL;

# 案例2：查询城市名中第二个字符为o的部门名和城市名
SELECT city, department_name
FROM locations l, departments d
WHERE d.location_id = l.location_id
AND city LIKE '_o%';


-- 可以加分组
# 案例1：查询每个城市的部门个数
SELECT l.city, COUNT(*)
FROM locations l, departments d
WHERE l.location_id = d.location_id
GROUP BY l.city;

# 案例2：查询每个部门的部门名和部门的领导编号和该部门的最低工资,且该有奖金的
SELECT d.department_name, d.manager_id, MIN(e.salary)
FROM departments d, employees e
WHERE e.department_id = d.department_id
AND e.commission_pct IS NOT NULL
GROUP BY d.department_id;
 
-- 可以加排序
# 案例：查询每个工种的工种名和员工的个数，并且按员工个数降序
SELECT j.job_title, COUNT(*)
FROM jobs j, employees e
WHERE j.job_id = e.job_id
GROUP BY j.job_title
ORDER BY COUNT(*) DESC;


-- 可以实现三表连接(或更多表)
# 案例：查询员工名、部门名和所在的城市
SELECT e.first_name, d.department_name, l.city
FROM employees e, departments d, locations l
WHERE e.department_id = d.department_id
AND d.location_id = l.location_id



-- 非等值连接myemployees
--

# 案例1：查询员工的工资和工资级别
SELECT e.salary, j.grade_level
FROM employees e, job_grades j 
WHERE e.salary >= j.lowest_sal 
AND e.salary <= j.highest_sal;

--
SELECT e.salary, j.grade_level
FROM employees e, job_grades j 
WHERE e.salary BETWEEN j.lowest_sal AND j.highest_sal;


-- 自连接(自连内连接)
-- 
-- 用于表内有自关联，查询时，这个表需要用到两次


#案例：查询 员工名和上级的名称
SELECT e.first_name 员工名, m.first_name 上级名 
FROM employees e, employees m
WHERE e.manager_id = m.employee_id;






