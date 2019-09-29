-- 分组查询



# 查询各job_id的员工工资的最大值，最小值，平均值，总和，并按job_id升序
SELECT job_id, MAX(salary), MIN(salary), AVG(salary), SUM(salary)
FROM employees
GROUP BY job_id
ORDER BY job_id ASC;


# 查询员工最高工资和最低工资的差距（）
SELECT MAX(salary) - MIN(salary) AS DIFFERENCE
FROM employees


# 查询各个管理者手下员工的最低工资，其中最低工资不能低于6000，没有管理者的员工不计算在内
SELECT manager_id, MIN(salary)
FROM employees
WHERE manager_id IS NOT NULL
GROUP BY manager_id
HAVING MIN(salary) >= 6000;


# 查询所有部门的编号，员工数量和工资平均值,并按平均工资降序
SELECT department_id, COUNT(*), TRUNCATE(AVG(salary), 2) AS A
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
ORDER BY A DESC;


# 选择具有各个job_id的员工人数
SELECT COUNT(*), job_id
FROM employees
GROUP BY job_id;



