-- 子查询
 /*
## 概念
出现在其他语句中的select语句，称为子查询 或 内查询。
在其他语句可以是 select、update、insert、delete、create等语句

外部的查询语句，称为主查询 或 外查询

## 分类
### 按子句出现的位置分
* select后面
    仅仅支持标量子查询
* from后面
    支持表子查询
* where或having后面
    标量子查询(结果集只有一行一列)
    列子查询(结果集为多行一列)
    行子查询(结果集一行多列或多行多列，总之一定是大于1列)
* exists后面(也叫相关子查询)
    表子查询

### 按结果集的行数列数不同分
* 标量子查询(结果集只有一行一列)
* 列子查询(结果集为多行一列)
* 行子查询(结果集一行多列或多行多列，总之一定是大于1列)
* 表子查询(结果集一般为多行多列，也可以为任意行任意列)

*/
-- where或having后面
--
 /*
标量子查询(结果集只有一行一列)
列子查询(结果集为多行一列)
行子查询(结果集一行多列)

## 特点
* 子查询放在小括号内，即(语句)
* 子查询一般放在条件的右侧
* 标量子查询，一般搭配着单行操作符使用
    >  <  >=  <=  =  <>  <=>

* 列子查询，一般搭配多行操作符使用
    in/not in  any/some  all
    * any、some效果一样
    
    * in (...) 表示括号集合里的任意一个元素
        等效于 = any (...)
        等效于 = some (...)
        
    * not in () 不在括号集合的范围内。即括号集合的范围外的
        等效于 <> all (...)
* 子查询的执行优先于主查询执行，因为主查询的条件用到了子查询的结果

*/

## 1.标量子查询
# 案例1：谁的工资比 姓Abel 高
-- ①查询出Abel的工资
SELECT salary
FROM employees
WHERE last_name = 'Abel' 
;

-- ②查询员工信息，满足 salary > ① 的结果
SELECT *
FROM employees
WHERE salary > (
    SELECT salary
    FROM employees
    WHERE last_name = 'Abel'
);

#案例2：返回job_id与141号员工相同，并且salary比143号员工多的员工 姓名，job_id 和工资

-- ①查询141号员工的job_id
SELECT job_id
FROM employees
WHERE employee_id = 141
;

-- ②查询143号员工的salary
SELECT salary
FROM employees
WHERE employee_id = 143
;

-- ③查询姓名,job_id 和工资，满足 job_id = ① 并且 salary > ②
SELECT CONCAT(first_name, ' ',last_name) 姓名, job_id, salary AS 工资
FROM employees
WHERE job_id = (
    SELECT job_id
    FROM employees
    WHERE employee_id = 141
)
AND salary > (
    SELECT salary
    FROM employees
    WHERE employee_id = 143
);

# 案例3：返回公司工资最少的员工的last_name,job_id和salary
-- ①查询公司工资最少的salary
SELECT MIN(salary)
FROM employees
;

-- ②查询员工last_name,job_id和salary，满足 salary = ①
SELECT last_name, job_id, salary
FROM employees
WHERE salary = (
    SELECT MIN(salary)
    FROM employees
);

# 案例4：查询最低工资大于50号部门最低工资的部门id和其最低工资
-- ①查询id为50的部门的最低工资
SELECT MIN(salary)
FROM employees
WHERE department_id = 50
;

-- ②查询部门id，该部门最低工资，满足该部门的最低工资 > ①
SELECT department_id, MIN(salary)
FROM employees
GROUP BY department_id
HAVING MIN(salary) > (
    SELECT MIN(salary)
    FROM employees
    WHERE department_id = 50
);


# 非法使用标量子查询
/*
当子查询无结果返回或返回为空，则主查询也将返回空结果
一般要求子查询要有结果返回
*/

SELECT department_id, MIN(salary)
FROM employees
GROUP BY department_id
HAVING MIN(salary) > (
    SELECT MIN(salary)
    FROM employees
    WHERE department_id = 350
);


-- 列子查询
# 案例1：返回location_id是1400或1700的部门中的所有员工姓名

-- 内连接查询方式
SELECT CONCAT(first_name, ' ', last_name), e.department_id
FROM employees e
INNER JOIN departments d
ON e.department_id = d.department_id
WHERE d.location_id IN (1400, 1700);

-- 列子查询方式
-- ①查询location_id是1400或1700的部门编号
SELECT DISTINCT department_id
FROM departments
WHERE location_id IN (1400, 1700)
;

-- ②查询员工姓名，满足department_id在①结果集中，即查询出①结果集内所有department_id对应的员工
SELECT CONCAT(first_name, ' ', last_name), department_id
FROM employees
WHERE department_id IN (
    SELECT department_id
    FROM departments
    WHERE location_id IN (1400, 1700)
);

-- 或
SELECT CONCAT(first_name, ' ', last_name), department_id
FROM employees
WHERE department_id = ANY (
    SELECT department_id
    FROM departments
    WHERE location_id IN (1400, 1700)
);


-- 或
SELECT CONCAT(first_name, ' ', last_name), department_id
FROM employees
WHERE department_id = SOME (
    SELECT department_id
    FROM departments
    WHERE location_id IN (1400, 1700)
);


# 案例2：返回location_id不是1400或1700的部门中的所有员工姓名
-- ①location_id是1400或1700的部门编号
SELECT department_id
FROM departments
WHERE location_id = 1400
OR location_id = 1700
;

-- ②查询所有员工姓名，满足department_id不在①结果集中
SELECT CONCAT(first_name, ' ', last_name)
FROM employees
WHERE department_id NOT IN (
    SELECT department_id
    FROM departments
    WHERE location_id = 1400
    OR location_id = 1700
);

-- 或
SELECT CONCAT(first_name, ' ', last_name)
FROM employees
WHERE department_id <> ALL (
    SELECT department_id
    FROM departments
    WHERE location_id = 1400
    OR location_id = 1700
);

# 案例3：返回其它工种中比job_id为'IT_PROG'工种任一工资低的员工的员工号、姓名、job_id 以及salary
-- ①查询job_id为'IT_PROG'工种的所有员工的工资
SELECT DISTINCT salary
FROM employees
WHERE job_id = 'IT_PROG'
;

-- ②查询员工号、姓名、job_id 以及salary，满足job_id不为'IT_PROG'，且salary < ①结果集任意一个。可以转化salary < ①结果集中最大的salary
SELECT 
    employee_id, 
    CONCAT(first_name, ' ', last_name) AS 姓名,
    job_id,
    salary
FROM employees
WHERE job_id != 'IT_PROG'
AND salary < ANY (
    SELECT DISTINCT salary
    FROM employees
    WHERE job_id = 'IT_PROG'
);

-- 或
SELECT 
    employee_id, 
    CONCAT(first_name, ' ', last_name) AS 姓名,
    job_id,
    salary
FROM employees
WHERE job_id != 'IT_PROG'
AND salary < (
    SELECT MAX(salary)
    FROM employees
    WHERE job_id = 'IT_PROG'
);


# 案例4：返回其它部门中比job_id为'IT_PROG'部门所有工资都低的员工   的员工号、姓名、job_id 以及salary
-- ①查询job_id为'IT_PROG'部门的所有员工工资
SELECT DISTINCT salary 
FROM employees
WHERE job_id = 'IT_PROG'
;

-- ②查询员工号、姓名、job_id 以及salary，满足job_id != 'IT_PROG'，且salary < ①结果集中所有的salary。可以转化为salary < ①结果集中最小的salary
SELECT employee_id, 
    CONCAT(first_name, ' ', last_name),
    job_id,
    salary
FROM employees
WHERE job_id <> 'IT_PROG'
AND salary < ALL (
    SELECT DISTINCT salary 
    FROM employees
    WHERE job_id = 'IT_PROG'
);

-- 或
SELECT employee_id, 
    CONCAT(first_name, ' ', last_name),
    job_id,
    salary
FROM employees
WHERE job_id <> 'IT_PROG'
AND salary < (
    SELECT MIN(salary)
    FROM employees
    WHERE job_id = 'IT_PROG'
);


-- 行子查询
-- 可以用列表来接收子查询结果集
# 案例：查询员工编号最小并且工资最高的员工信息
SELECT *
FROM employees
WHERE (employee_id, salary) = (
    SELECT MIN(employee_id), MAX(salary)
    FROM employees
);


-- 常规查询方法
-- ①查询最小的员工编号
SELECT MIN(employee_id)
FROM employees
;

-- ②查询最高的工资
SELECT MAX(salary)
FROM employees
;

-- ③查询员工信息，满足employee_id = ①，且salary = ②
SELECT * 
FROM employees
WHERE employee_id = (
    SELECT MIN(employee_id)
    FROM employees
)
AND salary = (
    SELECT MAX(salary)
    FROM employees
);



-- select后面
--
/*
仅仅支持标量子查询
*/


# 案例1：查询每个部门的员工个数
SELECT DISTINCT d.department_id, (
    SELECT COUNT(*)
    FROM employees e
    WHERE e.department_id = d.department_id

) 个数
FROM departments d


# 案例2：查询员工号=102的部门名
-- ①查询员工号=102所在的部门编号
SELECT department_id
FROM employees
WHERE employee_id = 102
;

-- ②查询部门名，满足department_id = ①
SELECT e.department_id, (
    SELECT d.department_name
    FROM departments d
    WHERE e.department_id = d.department_id
) AS 部门名
FROM employees e
WHERE employee_id = 102;


-- from后面
-- 
/*
将子查询结果集充当一张表，要求必须起别名
*/

# 案例：查询每个部门的平均工资的工资等级
-- ①查询每个部门的平均工资
SELECT department_id, AVG(salary)
FROM employees
GROUP BY department_id
;

-- ②把①的结果集与job_grades连接查询，①的结果集做主表，因为有可能没有匹配的等级
SELECT g.grade_level, t.avg_salary, t.department_id
FROM job_grades g
RIGHT OUTER JOIN (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
) t
ON t.avg_salary BETWEEN g.lowest_sal AND g.highest_sal;


-- exists后面
-- 
/*
功能：用于判断结果集是否存在记录，即是否不为空。返回boolean值(1或0)
是：返回 1
否：返回 0

## 语法
exists (查询语句)

*/

SELECT EXISTS (
    SELECT *
    FROM employees
    WHERE salary < 0 -- 工资 < 0的员工不存在
); -- 0

# 案例1：查询有员工的部门名
-- 常规方法
SELECT d.department_id, d.department_name
FROM departments d
WHERE d.department_id = SOME (
    SELECT DISTINCT department_id 
    FROM employees
);

-- exists方式
SELECT d.department_id, d.department_name
FROM departments d
WHERE EXISTS (
    SELECT *
    FROM employees e
    WHERE e.department_id = d.department_id
);

# 案例2：查询没有女朋友的男生信息
USE girls;

-- 连接查询方式
SELECT * 
FROM boys bo
LEFT OUTER JOIN beauty b
ON b.boyfriend_id = bo.id
WHERE b.id IS NULL;


-- in方式
SELECT *
FROM boys bo
WHERE bo.id NOT IN (
    SELECT DISTINCT boyfriend_id
    FROM beauty
);


-- exists方式
SELECT * 
FROM boys bo
WHERE NOT EXISTS (
    SELECT *
    FROM beauty b
    WHERE b.boyfriend_id = bo.id
);


