-- 分组函数



 -- 查询公司员工工资的最大值，最小值，平均值，总和
SELECT
    MAX (salary) 最高工资, 
    MIN (salary) 最低工作, 
    AVG (salary) 平均工资, 
    SUM (salary) 总工资
FROM
    employees;


-- 查询员工表中的最大入职时间和最小入职时间的相差天数 （DIFFRENCE）
SELECT DATEDIFF(MAX(hiredate), MIN(hiredate)) FROM employees; -- 8735

SELECT DATEDIFF(MIN(hiredate), MAX(hiredate)) FROM employees; -- -8735

-- 查询部门编号为 90 的员工个数
SELECT COUNT(*)
FROM employees
WHERE department_id = 90;