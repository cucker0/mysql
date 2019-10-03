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
    行子查询(结果集一行多列)
* exists后面(也叫相关子查询)
    表子查询

### 按结果集的行数列数不同分
* 标量子查询(结果集只有一行一列)
* 列子查询(结果集为多行一列)
* 行子查询(结果集一行多列)
* 表子查询(结果集一般为多行多表，也可以为任意的情况)

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
    in  any/some  all
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
)

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

-- ③








