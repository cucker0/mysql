-- 单行函数练习


-- 显示系统时间(注：日期+时间)
SELECT NOW();

-- 查询员工号，姓名，工资，以及工资提高百分之 20%后的结果（new salary）
SELECT employee_id, salary, salary * (1 + 0.2) AS "new salary"
FROM employees;

-- 将员工的姓名按首字母排序，并写出姓名的长度（length）
SELECT 
    SUBSTR(first_name, 1, 1) AS 首字母,
    CONCAT(first_name, ' ',last_name) AS 姓名,
    (LENGTH(first_name) + LENGTH(last_name)) 姓名长度
FROM employees
ORDER BY 首字母 DESC;

-- 做一个查询，产生下面的结果
<last_name> earns <salary> monthly but wants <salary*3>

+--------------------------------------------+
|               Dream Salary                 |
+--------------------------------------------+
|King earns 24000 monthly but wants 72000    |
+--------------------------------------------+

SELECT CONCAT(last_name, ' earns ', ROUND(salary), ' monthly but wants ', TRUNCATE(salary * 3, 0)) AS "Dream Salary"
FROM employees
WHERE salary = 24000;



-- 使用 case-when，按照下面的条件：
/*
job grade
AD_PRES A
ST_MAN B
IT_PROG C
SA_REP D
ST_CLERK E


产生下面的结果:
*/
+--------------------------------------------+
|          Last_name Job_id Grade            |
+--------------------------------------------+
|         king AD_PRES A                     |
+--------------------------------------------+

SELECT 
    last_name AS Last_name,
    job_id AS Job_id,
    CASE job_id
WHEN 'AD_PRES' THEN
    'A'
WHEN 'ST_MAN' THEN
    'B'
WHEN 'IT_PROG' THEN
    'C'
WHEN 'SA_REP' THEN
    'D'
WHEN 'ST_CLERK' THEN
    'E'
END AS Grade
FROM employees;

