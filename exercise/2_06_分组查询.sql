-- 2_06_分组查询



/*
语法：
select 查询列表
from 表名
[where 筛选条件]
group by 分组的字段
[order by 排序的字段];

特点
* 能和分组函数一起出现在select查询列表中的字段必须是group by里的字段
* 筛选分为两类：分组前筛选、分组后筛选

分类          筛选对象            位置          连接的关键字  能否引用字段别名
----------------------------------------------------------------------------------
分组前筛选    原始表              group by前    where         不能        
分组后筛选    group by后的结果集  group by后    having        能

* 问题1：分组函数做筛选能不能放在where后面
答：不能

* 问题2：分组前筛效率高于分组后筛选
一般的，能用分组前筛的，尽量使用分组前筛，提高效率

* 分组可以按单个字段，也可以按多个字段
* 分组可以搭配排序

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


-- 实现分组前的筛选
# 案例1：查询每个部门中邮箱包含a字符的最高工资
SELECT MAX(salary), department_id
FROM employees
WHERE email LIKE '%a%'
GROUP BY department_id;

# 案例2：查询每个领导手下有奖金员工的平均工资
SELECT AVG(salary), manager_id
FROM employees
WHERE commission_pct IS NOT NULL
GROUP BY manager_id;


-- 分组后筛选
# 案例：查询哪个部门的员工个数>5

-- [1] 查询每个部门的员工个数
SELECT department_id, COUNT(*) AS c
FROM employees
GROUP BY department_id;

-- [2] 筛选上面[1]的结果
SELECT department_id, COUNT(*) AS coun
FROM employees
GROUP BY department_id
HAVING coun > 5; -- 这步在查询完结果，设置完别名后，才执行，所以这里可以引用别名


# 案例2：每个工种有奖金的员工的最高工资>12000的工种编号和最高工资
SELECT job_id, MAX(salary) AS higth
FROM employees
WHERE commission_pct IS NOT NULL
GROUP BY job_id
HAVING higth > 12000;


# 案例3：领导编号>102的每个领导手下的最低工资大于5000的领导编号和最低工资
SELECT manager_id, MIN(salary) AS low
FROM employees
WHERE manager_id > 102
GROUP BY manager_id
HAVING low > 5000


-- 分组后再筛选，结果指定排序方式
# 案例：每个工种有奖金的员工的最高工资>6000的工种编号和最高工资,按最高工资升序
SELECT job_id, MAX(salary) m
FROM employees
WHERE commission_pct IS NOT NULL
GROUP BY job_id
HAVING m > 6000
ORDER BY m ASC;


-- 按多个字段分组
# 案例：查询每个工种在每个部门的最低工资,并按最低工资降序
SELECT job_id, department_id, MIN(salary) AS mi
FROM employees
GROUP BY job_id, department_id
ORDER BY mi DESC;

-- 调换分组的字段顺序结果相同
SELECT job_id, department_id, MIN(salary) AS mi
FROM employees
GROUP BY department_id, job_id
ORDER BY mi DESC;
