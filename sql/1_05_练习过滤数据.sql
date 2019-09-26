-- 查询工资大于 12000 的员工姓名和工资
SELECT CONCAT(first_name, ' ',last_name) AS 姓名, salary
FROM employees
WHERE salary > 12000;


-- 查询员工号为 176 的员工的姓名和部门号和年薪
SELECT 
    CONCAT(first_name, ' ',last_name) AS 姓名,
    department_id,
    (salary * 12 * (1 + IFNULL(commission_pct, 0))) AS 年薪
FROM employees
WHERE employee_id = 176;


-- 选择工资不在 5000 到 12000 的员工的姓名和工资
SELECT CONCAT(first_name, ' ',last_name) AS 姓名, salary
FROM employees
WHERE salary NOT BETWEEN 5000 AND 12000;


-- 选择在 20 或 50 号部门工作的员工姓名和部门号
SELECT
    CONCAT(first_name, ' ',last_name) AS 姓名, department_id
FROM
    employees
WHERE department_id IN (20, 50);


-- 选择公司中没有管理者的员工姓名及 job_id
SELECT last_name, job_id, manager_id
FROM employees
WHERE manager_id IS NULL;


-- 选择公司中有奖金的员工姓名，工资和奖金级别
SELECT last_name, salary, commission_pct
FROM employees
WHERE commission_pct IS NOT NULL;


-- 选择员工姓名的第三个字母是 a 的员工姓名
SELECT last_name
FROM employees
WHERE last_name LIKE '__a%';


-- 选择姓名中有字母 a 和 e 的员工姓名
/*
sql是在where后order by前加别名，即生成结果集后加别名，
where是在生成结果集前的操作，
order by是生成结果集后的操作，
因为where要生成结果集，而order by是对结果集的操作。
如果非要用别名，那么只能用派生表，即先生成别名再where
*/

-- 在where中保用别名会报错，错误代码： 1054, UNKNOWN COLUMN 'fullname' IN 'where clause'

SELECT CONCAT(first_name, ' ', last_name) AS fullname
FROM employees
WHERE fullname LIKE '%a%' AND first_name LIKE '%e%';

-- 正确写法
SELECT CONCAT(first_name, ' ', last_name) AS 姓名
FROM employees
WHERE CONCAT(first_name, ' ', last_name) LIKE '%a%' AND first_name LIKE '%e%';


-- 显示出表 employees 表中 first_name 以 'e'结尾的员工信息
-- where子句中使用别名注意事项
SELECT * 
FROM employees
WHERE first_name LIKE '%e';

-- 显示出表 employees 部门编号在 80-100 之间 的姓名、职位
SELECT last_name, job_id, department_id
FROM employees
WHERE department_id BETWEEN 80 AND 100;


-- 显示出表 employees 的 manager_id 是 100,101,110 的员工姓名、职位
SELECT last_name, job_id, manager_id
FROM employees
WHERE manager_id IN (100, 101, 110);
