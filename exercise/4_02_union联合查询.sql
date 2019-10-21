-- union联合查询


/*
功能：将多个查询语句的结果集合并成一个结果集

## 语法
查询语句1
union
查询语句2
...

## 应用场景：
要查询的结果来自多个表，且多个表之间没有直接的连接关系，但查询的信息一致；
作为full outer join全外连接的替代方案

## 特点
* 要求多个查询语句的查询列数是一致的
* 要求多个查询语句的每一列的类型和顺序最好一致
* union关键字默认去重
* union all关键字可以保留重复的记录
* 列表只会显示第一查询语句的
* 建议每个子查询用()包起来

*/

# 案例1：查询部门id > 90或邮箱包含a的员工信息
SELECT *
FROM employees
WHERE department_id > 90
OR email LIKE '%a%';


-- union联合查询方式
(
    SELECT * 
    FROM employees
    WHERE department_id > 90 -- 8行
)

UNION

(
    SELECT * -- 62行
    FROM employees
    WHERE email LIKE '%a%'
)
; -- 联合查询的结果67行


-- union联合查询，保留重复记录
(
    SELECT * 
    FROM employees
    WHERE department_id > 90 -- 8行
)

UNION ALL

(
    SELECT * -- 62行
    FROM employees
    WHERE email LIKE '%a%'
)
;



# 案例：查询girls库的beauty表中的姓名、出生日期，以及myemployees库的employees表中的姓名、入职日期，要求姓名显示为同一列，出生日期与入职日期显示为同一列 

(
    SELECT `name` 姓名, borndate 日期
    FROM girls.beauty
)

UNION

(
    SELECT CONCAT(first_name, ' ', last_name), hiredate
    FROM myemployees.employees
)
;


-- full outer join全外连接替代方案
# 查询所有女神有无男朋友和所有男神有无女朋友的详情信息
USE girls;

/*
全外连接查询，奈何mysql不支持
SELECT *
FROM beauty b
FULL OUTER JOIN boys bo
ON b.boyfriend_id = bo.id;
*/

-- ①查询beauty表与boys表左外连接，此时主表为beauty
SELECT *
FROM beauty b
LEFT OUTER JOIN boys bo
ON b.boyfriend_id = bo.id
;

-- ②查询beauty表与boys表右外连接，此时主表为boys
SELECT *
FROM beauty b
RIGHT OUTER JOIN boys bo
ON b.boyfriend_id = bo.id
;

-- ③用union把①结果集与②结果集合并，并去重(union默认去重)
(
    SELECT *
    FROM beauty b
    LEFT OUTER JOIN boys bo
    ON b.boyfriend_id = bo.id
)

UNION

(
    SELECT *
    FROM beauty b
    RIGHT OUTER JOIN boys bo
    ON b.boyfriend_id = bo.id
)
;
