SQL语言
==

# 本次测试练习的表关系模型
[sql 文件](./sql/myemployees.sql)  
![](./images/myemployees库的表关系模型.png) 

# SQL语句的3种类型
* DML数据操作语句
* DDL数据定义语句
* DCL数据控制语句

# DQL查询语句
DML数据处理操作语句中的查询操作

## 基础查询
<details>
<summary>基础查询</summary>

* 语法
```text
select 查询列表 from 表名;

SELECT *|{[DISTINCT] column|expression [alias],...}
FROM table;

* | 表示或
* { }里面有多种情况，使用其中的一种
* [] 此项为可选
* 查询列表：表中的字段、常量、表达式、函数
* 查询的结果是一个虚拟的表格
```

* 查询表中的单个字段
```mysql
USE myemployees;
SELECT salary FROM employees;
```

* 查询表中的多个字段
>SELECT employee_id, first_name, last_name FROM employees;


* 查询表中的所有字段
    * 方式1  
        ```mysql
        SELECT
            `employee_id`,
            `first_name`,
            `last_name`,
            `email`,
            `phone_number`,
            `job_id`,
            `salary`,
            `commission_pct`,
            `manager_id`,
            `department_id`,
            `hiredate`
        FROM
            employees;
        ```
    * 方式2
        >SELECT * FROM employees;


* 查询常量值
```mysql
SELECT 200;
SELECT '使命必达';
```

* 查询表达式
```
支持常规的算术运算符
+ - * / %
```
```mysql
SELECT 3600 + 24;
SELECT 'a' + 'baaaaaa';
```


* 查询函数

    函数与方法的类似，无参函数、有参函数

```mysql
SELECT VERSION(); -- 查看mysql版本
SELECT DATABASE(); -- 查看当前所在的数据库
SELECT USER(); -- 查看当前连接使用的用户
```


* 起别名
    ```text
    
    功能：相当于对一个字段、函数、一个子句赋值给一个变量(别名)，
    这个变量可以在其他地方引用
    
    * 便于理解
    * 如果查询的字段中有重名的情况，可使用不同别名类区别
    
    注意：
    当别名中有特殊字符（如含空格），别名需要用双引号包起来
    ```

    * 方式1：使用AS 别名
        ```
        SELECT '建国70周年' AS 信息;
        SELECT last_name AS 姓, first_name AS 姓  FROM employees;
        ```
    * 方式2：使用空格 别名
        ```mysql
        SELECT last_name 姓, first_name 姓  FROM employees;
        ```

\# 示例：查询salary，显示结果为out put
```text
SELECT salary AS "out put" FROM employees;
```

* DISTINCT去重
```mysql
-- 示例：查询employees表中涉及到的所有部门编号
SELECT DISTINCT department_id FROM employees;
```


* +的作用
```text
mysql中+仅仅是加法运算符

* 当操作数中有字符型时，试图将字符型数值转换成数值型，
如果转换成功，则转换后值为字符对应的数值，
如果转换失败，则转换后值0，
最后用转换后的数值进行做加法运算

注意：NULL与任何数做+运算，结果都为NULL

java中的+作用
* 运算符：连个操作数的类型都为数值类型
* 连接符：只要有一个操作数的类型为字符串

```

```mysql
SELECT 10 + 9;
SELECT '90' + 10; -- 结果：100
# 当操作数为字符型是，试图将字符型数值转换成数值型，如果转换成功，用转换后的数值进行做加法运算

SELECT '10' + '20'; -- 结果：30
SELECT 'coco' + 123; -- 结果：123
-- 字符型转换成数值型失败时，其转换值为0

SELECT 'aa' + 'b'; -- 结果: 0
SELECT NULL + 10; -- 结果：NULL
```

</details>

## 条件查询
<details>
<summary>条件查询</summary>

</details>

## 常见函数
## 分组函数
## 分组查询
## 连接查询
## 子查询
## 分页查询
## union联合查询

# DML数据操作语句
## 插入语句
## 修改语句
## 删除语句

# DDL数据定义语句
## 库和表的管理
## 常见数据结构类型介绍
## 常见约束

# DCL数据控制语句
## 事务和事务管理
