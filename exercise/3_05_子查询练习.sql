-- 子查询练习



# 1.查询和姓Zlotkey相同部门的员工姓名和工资
-- ①查询姓为Zlotkey所在的部门
USE myemployees;

SELECT department_id
FROM employees
WHERE last_name = 'Zlotkey'
;

-- ②查询员工姓名和工资，满足department_id = ①
SELECT CONCAT(first_name, ' ', last_name), salary
FROM employees
WHERE department_id = (
    SELECT department_id
    FROM employees
    WHERE last_name = 'Zlotkey'
);


# 2.查询工资比公司平均工资高的员工的员工号、姓名和工资。
-- ①查询公司平均工资
SELECT AVG(salary)
FROM employees
;

-- ②查询员工号、姓名和工资，满足salary > ①
SELECT employee_id, CONCAT(first_name, ' ', last_name), salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);



# 3.查询各部门中工资比本部门平均工资高的员工的员工号、姓名和工资
-- ①查询指定部门ID的平均工资
SELECT AVG(salary)
FROM employees
WHERE department_id = 部门ID

-- ②查询员工号、姓名和工资，满足salary > ①
SELECT e.employee_id, CONCAT(first_name, ' ', last_name), e.salary, department_id
FROM employees e
WHERE e.salary > (
    SELECT AVG(salary) avg_salary
    FROM employees e2
    WHERE e2.department_id = e.department_id
);

-- 
SELECT employee_id,last_name,salary,e.department_id
FROM employees e
INNER JOIN (
	SELECT AVG(salary) ag,department_id
	FROM employees
	GROUP BY department_id
) ag_dep
ON e.department_id = ag_dep.department_id
WHERE salary>ag_dep.ag ;

# 4.查询和姓名中包含字母u的员工在相同部门的员工的员工号和姓名
-- ①查询姓名中包含字母u的员工所在的部门ID
SELECT DISTINCT department_id
FROM employees
WHERE first_name LIKE '%u%'
OR last_name LIKE '%u%'
;

-- ②查询员工号和姓名，满足department_id in ①结果集中
SELECT employee_id, CONCAT(first_name, ' ', last_name)
FROM employees
WHERE department_id IN (
    SELECT DISTINCT department_id
    FROM employees
    WHERE first_name LIKE '%u%'
    OR last_name LIKE '%u%' 
)


# 5.查询在部门的location_id为1700的部门工作的员工的员工号
-- ①查询部门的location_id为1700的部门ID，结果集可能有多个(多行一列)
SELECT DISTINCT department_id
FROM departments
WHERE location_id = 1700
;

-- ②查询员工号，满足 department_id in 在①结果集中
SELECT employee_id, department_id
FROM employees
WHERE department_id IN (
    SELECT DISTINCT department_id
    FROM departments
    WHERE location_id = 1700
);

-- 或
SELECT employee_id, department_id
FROM employees
WHERE department_id = ANY (
    SELECT DISTINCT department_id
    FROM departments
    WHERE location_id = 1700
);


-- 或
SELECT employee_id, department_id
FROM employees
WHERE 
    department_id = SOME (
        SELECT DISTINCT department_id
        FROM departments
        WHERE location_id = 1700
    );

# 6.查询管理者姓是K_ing的员工姓名和工资
-- ①查询姓是K_ing的员工ID
SELECT employee_id
FROM employees
WHERE last_name = 'K_ing'
;

-- ②员工姓名和工资，满足 manager_id = ①结果集中任意一个
SELECT CONCAT(first_name, ' ', last_name), salary, manager_id
FROM employees
WHERE manager_id = ANY (
    SELECT employee_id
    FROM employees
    WHERE last_name = 'K_ing'
);


# 7.查询工资最高的员工的姓名，要求first_name和last_name显示为一列，列名为 姓.名
-- ①查询工资最高的员工Id
SELECT MAX(salary)
FROM employees
;

-- ②查询员工信息，满足 salary = ①
SELECT CONCAT(first_name, '.', last_name) AS "姓.名"
FROM employees
WHERE salary = (
    SELECT MAX(salary)
    FROM employees
);

