-- 2_06_分组查询



/*
语法：
select 查询列表
from 表名
[where 筛选条件]
group by 分组的字段
[order by 排序的字段];


*/


-- 简单分组查询
-- 案例1：查询每个部门的员工个数
SELECT department_id, COUNT(*) 
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id;

-- 案例2：查询每个工种的员工平均工资
SELECT job_id, AVG(salary)
FROM employees
GROUP BY job_id;

-- 案例3：查询每个位置的部门个数
SELECT location_id, COUNT(department_id)
FROM departments
GROUP BY location_id;



