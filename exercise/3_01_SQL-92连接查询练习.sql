-- SQL-92连接查询练习




-- 1.显示所有员工的姓名，部门号和部门名称。
SELECT CONCAT(e.first_name, e.last_name) AS 姓名, d.department_id, d.department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id;

-- 2.查询90号部门员工的job_id和90号部门的location_id
SELECT e.job_id, d.location_id, e.department_id
FROM employees e, departments d
WHERE e.department_id = d.department_id
AND d.department_id = 90;

-- 3.选择所有有奖金的员工的last_name , department_name , location_id , city
SELECT e.last_name, d.department_name, l.location_id, l.city
FROM employees e, departments d, locations l
WHERE e.department_id = d.department_id
AND d.location_id = l.location_id;


-- 4.选择city在Toronto工作的员工的last_name , job_id , department_id , department_name 
SELECT e.last_name, e.job_id, e.department_id, d.department_name
FROM employees e, departments d, locations l
WHERE e.department_id = d.department_id
AND d.location_id = l.location_id
AND l.city = 'Toronto';


-- 5.查询每个工种、每个部门的部门名、工种名和最低工资
SELECT d.department_name, j.job_title, MIN(e.salary)
FROM departments d, employees e, jobs j
WHERE d.department_id = e.department_id
AND e.job_id = j.job_id
GROUP BY j.job_id, d.department_id;


-- 6.查询每个国家下的部门个数大于2的国家编号
SELECT COUNT(*) 部门个数, l.country_id
FROM locations l, departments d
WHERE l.location_id = d.location_id
GROUP BY l.country_id
HAVING COUNT(*) > 2;


-- 7、选择指定员工的姓名，员工号，以及他的管理者的姓名和员工号，结果类似于下面的格式
/*
+---------------------------------------+
|employees	|Emp#	|manager   |Mgr#    |
+-----------+-------+----------+--------+
|kochhar	|101	|king	   |100     |
+---------------------------------------+
*/
SELECT e.first_name AS "employees", e.employee_id AS "Emp#", m.first_name AS manager, m.employee_id AS "Mgr#"
FROM employees e, employees m
WHERE e.manager_id = m.employee_id;


