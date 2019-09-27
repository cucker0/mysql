-- 排序数据


-- 查询员工的姓名和部门号和年薪，按年薪降序 按姓名升序
SELECT 
    CONCAT(first_name, ' ', last_name) AS 姓名,
    department_id,
    (salary * 12 * (1 + (IFNULL(commission_pct, 0)))) AS 年薪
FROM employees
ORDER BY 年薪 ASC;


-- 选择工资不在 8000 到 17000 的员工的姓名和工资，按工资降序
SELECT
    CONCAT(first_name, ' ', last_name) AS 姓名,
    salary
FROM employees
WHERE salary NOT BETWEEN 8000 AND 17000
ORDER BY salary DESC;

IFNULL(

-- 查询邮箱中包含 e 的员工信息，并先按邮箱的字节数降序，再按部门号升序
SELECT *
FROM employees
WHERE email LIKE '%e%'
ORDER BY LENGTH(email) DESC, department_id ASC;