-- 子查询、分页查询练习


# 1. 查询工资最低的员工信息: last_name, salary
-- ①查询最低工资
SELECT MIN(salary)
FROM employees
;

-- ②查询员工信息，满足员工salary = ①
SELECT last_name, first_name
FROM employees
WHERE salary = (
    SELECT MIN(salary)
    FROM employees
);

-- 或
SELECT last_name, first_name
FROM employees
ORDER BY salary
LIMIT 1;


# 2. 查询平均工资最低的部门信息
-- ①查询平均工资最低的部门id
SELECT department_id
FROM employees
GROUP BY department_id
ORDER BY AVG(salary) ASC
LIMIT 0, 1
;


-- ②查询部门信息，满足department_id = ①
SELECT *
FROM departments
WHERE department_id = (
    SELECT department_id
    FROM employees
    GROUP BY department_id
    ORDER BY AVG(salary) ASC
    LIMIT 0, 1
);


# 3. 查询平均工资最低的部门信息和该部门的平均工资
-- ①查询平均工资最低的部门id
SELECT department_id
FROM employees
GROUP BY department_id
ORDER BY AVG(salary) ASC
LIMIT 1
;


-- ②查询部门信息、部门的平均工资， 满足department_id = ①
SELECT *, (
    SELECT AVG(salary) 
    FROM employees
    WHERE department_id = (
        SELECT department_id
        FROM employees
        GROUP BY department_id
        ORDER BY AVG(salary) ASC
        LIMIT 1
    ) 
) AS 平均工资
FROM departments
WHERE department_id = (
    SELECT department_id
    FROM employees
    GROUP BY department_id
    ORDER BY AVG(salary) ASC
    LIMIT 1
);

-- 或
SELECT *
FROM departments d
INNER JOIN (
    SELECT department_id, AVG(salary) 平均工资
    FROM employees
    GROUP BY department_id
    ORDER BY AVG(salary) ASC
    LIMIT 1
) t
ON t.department_id = d.department_id;



# 4. 查询平均工资最高的 job 信息
-- ①查询平均工资最高的job_id
SELECT job_id
FROM employees
GROUP BY job_id
ORDER BY AVG(salary)
LIMIT 1
;

-- ②查询job信息，满足job_id = ①
SELECT * 
FROM jobs
WHERE job_id = (
    SELECT job_id
    FROM employees
    GROUP BY job_id
    ORDER BY AVG(salary)
    LIMIT 1
);


# 5. 查询平均工资高于公司平均工资的部门有哪些?
-- ①查询公司平均工资
SELECT AVG(salary)
FROM employees
;

-- ②查询部门平均工资，满足 部门平均工资 > ①
SELECT AVG(salary), department_id
FROM employees
GROUP BY department_id
HAVING AVG(salary) > (
    SELECT AVG(salary)
    FROM employees
);

# 6. 查询出公司中所有 manager 的详细信息.
-- ①查询所有的manager的employee_id
SELECT DISTINCT manager_id
FROM employees
WHERE manager_id IS NOT NULL
;

-- ②查询员工信息，满足 employee_id 在①结果集中
SELECT * 
FROM employees
WHERE employee_id = IN(
    SELECT DISTINCT manager_id
    FROM employees
    WHERE manager_id IS NOT NULL
);

--
SELECT * 
FROM employees
WHERE employee_id = ANY(
    SELECT DISTINCT manager_id
    FROM employees
    WHERE manager_id IS NOT NULL
);

--
SELECT * 
FROM employees
WHERE employee_id = SOME(
    SELECT DISTINCT manager_id
    FROM employees
    WHERE manager_id IS NOT NULL
);


# 7. 各个部门的最高工资中，最低的那个部门的 最低工资是多少
-- ①查询各部门的最高工资，排序，取出最低的那个部门id
SELECT department_id
FROM employees
GROUP BY department_id
ORDER BY MAX(salary) DESC
LIMIT 1
;

-- ②查询部门的最低工资，满足该部门id = ①
SELECT MIN(salary), department_id
FROM employees
WHERE department_id = (
    SELECT department_id
    FROM employees
    GROUP BY department_id
    ORDER BY MAX(salary) DESC
    LIMIT 1
)
GROUP BY department_id
;


# 8. 查询平均工资最高的部门的 manager 的详细信息: last_name, department_id, email, salary
-- ①查询平均工资最高的部门id、manger_id
SELECT department_id, manager_id
FROM employees
WHERE manager_id IS NOT NULL
GROUP BY department_id, manager_id
ORDER BY AVG(salary) DESC
LIMIT 0, 1
;


-- ②employees表与①内连接,查询部门manager信息，满足 department_id = ①
SELECT e.last_name, e.department_id, e.email, e.salary 
FROM employees e
INNER JOIN (
    SELECT department_id, manager_id
    FROM employees
    WHERE manager_id IS NOT NULL
    GROUP BY department_id, manager_id
    ORDER BY AVG(salary) DESC
    LIMIT 0, 1
) t
ON e.employee_id = t.manager_id;


-- 或
-- ①查询平均工资最高的部门编号
SELECT department_id
FROM employees
GROUP BY department_id
ORDER BY AVG (salary) DESC
LIMIT 1
;

-- ②将employees和departments连接查询，筛选条件是①
SELECT last_name, d.department_id, email, salary
FROM employees e
INNER JOIN departments d
ON d.manager_id = e.employee_id
WHERE d.department_id =(
    SELECT department_id
    FROM employees
    GROUP BY department_id
    ORDER BY AVG (salary) DESC
    LIMIT 1
);

