# 条件查询
-- 语法
 /*
select 查询列表
from 表名
where 筛选条件;


分类
* 按条件表达式筛选
比较运算符
>  <  =  <>  !=  >=  <=  <=> 安全等于

* 按逻辑表达式筛选
逻辑运算符
标准: AND OR NOT
兼容: && || ! 

* 模糊查询
like '匹配模式'
between A and B
in(set)
is null
is not null

*/


-- 按条件表达式筛选
# 示例：查询工资>12000的员工信息
SELECT
    *
FROM
    employees
WHERE salary > 12000;

# 案例2：查询部门编号不等于90号的员工名和部门编号
SELECT last_name, department_id
FROM employees
WHERE department_id <> 90;


SELECT last_name, department_id
FROM employees
WHERE department_id != 90;


-- 按逻辑表达式筛选
# 案例1：查询工资在10000到20000之间的员工名、工资以及奖金
SELECT
    last_name, salary, commission_pct
FROM
    employees
WHERE salary >= 10000
    AND salary <= 20000;
    
# 案例2：查询部门编号不是在90到110之间，或者工资高于15000的员工信息
SELECT * 
FROM employees
WHERE NOT (department_id >= 90 AND department_id <= 110)
    OR salary > 15000;
    
--
SELECT * 
FROM employees
WHERE !(department_id >= 90 && department_id <= 110)
    || salary > 15000;



-- 模糊查询
 /*
like

betwenn A AND B
in(set)
is null
is not null

*/
-- like '匹配模式'
 /*
一般和通配符搭配使用
通配符：
%：0个或多个任意字符
_: 1个任意字符
*/

# 案例1：查询员工名中包含字符a的员工信息
SELECT * 
FROM employees
WHERE first_name LIKE '%a%';


# 案例2：查询员工名中第三个字符为e，第五个字符为a的员工名和工资
SELECT first_name 名, CONCAT(first_name, ' ',last_name) 姓名,salary
FROM employees
WHERE first_name LIKE '__e_a%';

# 案例3：查询员工姓中第二个字符为_的员工名
-- ESCAPE '标识符' 显式指定转义，建议使用这种
SELECT last_name 
FROM employees
WHERE last_name LIKE '_$_%' ESCAPE '$'; -- 指定$右边第一个字符为转义的，$可以用其他字符来标识


SELECT last_name 
FROM employees
WHERE last_name LIKE '_\_%'; -- 这种转义方式也可以


-- between A and B
/*
在[A, B]闭区间
A,B都为数值类型
*/
# 案例1：查询员工编号在100到120之间的员工信息
SELECT * 
FROM employees
WHERE employee_id >= 100 AND employee_id <= 120;

-- 

SELECT * 
FROM employees
WHERE employee_id BETWEEN 100 AND 120;


-- IN(set)
/*
判断某字段的值是否在集合set中
注意：
set表示方式，ele1, ele2,...
* set集合中的元素类型必须一致或兼容
* set集合中的元素不支持通配符
* set里的元素建议不重复

*/

# 案例：查询员工的工种编号是 IT_PROG、AD_VP、AD_PRES中的员工名和工种编号
SELECT job_id, first_name
FROM employees
WHERE job_id = 'IT_PROG'
    OR job_id = 'AD_VP'
    OR job_id = 'AD_PRES';

--
SELECT job_id, first_name
FROM employees
WHERE job_id IN('IT_PROG', 'AD_VP', 'AD_PRES');


-- is null
/*
=、<>、!=不能判断NULL值
is null、is not null 可以判断null值


注意：没有以下写法
NOT (IS NULL)
NOT IS NULL

且IS 只能判断NULL 或 NOT NULL
*/

# 案例1：查询没有奖金的员工名和奖金率
SELECT first_name, commission_pct
FROM employees 
WHERE commission_pct IS NULL;

--
SELECT first_name, commission_pct
FROM employees 
WHERE commission_pct IS NOT NULL;


-- <=>安全等于
/*
与=功能类似，但可以用于判断NULL值，不能与NOT NULL组合
=无法判断NULL值，也不能与NOT NULL组合
<=> (NOT NULL)  结果等效于 <=> NULL

*/

# 案例1：查询没有奖金的员工名和奖金率
SELECT first_name, commission_pct
FROM employees 
WHERE commission_pct <=> NULL;

# 案例2：查询工资为12000的员工信息
SELECT * 
FROM employees 
WHERE salary <=> 12000;

-- IS NULL与<=>
/*
IS NULL: 只能判断NULL值，可读性较高，建议使用
<=>: 既可以判断NULL值，也可以判断其他类型的值，可读性低

*/











