-- 外连接练习



# 一、查询编号>3的女神的男朋友信息，如果有则列出详细，如果没有，用null填充
USE girls;

SELECT b.name, bo.*
FROM beauty b
LEFT JOIN boys bo
ON b.boyfriend_id = bo.id
WHERE b.id > 3;

--
SELECT b.name, bo.*
FROM boys bo 
RIGHT JOIN beauty b
ON b.boyfriend_id = bo.id
WHERE b.id > 3;


# 二、查询哪个城市没有部门
USE myemployees;

SELECT l.city, d.*
FROM locations l
LEFT JOIN departments d
ON d.location_id = l.location_id
WHERE d.department_id IS NULL;

# 三、查询部门名为SAL或IT的员工信息
-- 主表为departments，有可能会出现部门没有的情况，所以需要用外连接
SELECT d.department_name, e.*
FROM employees e
RIGHT JOIN departments d
ON e.department_id = d.department_id
WHERE d.department_name IN ('SAL', 'IT')



