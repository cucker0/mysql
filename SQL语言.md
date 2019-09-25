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
    ```text
    函数与方法的类似，分无参函数、有参函数
    ```

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

    * 示例：查询salary，显示结果为out put
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

* 语法
    ```text
    select 查询列表
    from 表名
    where 筛选条件;
    ```

### 条件查询分类
* 按条件表达式筛选  

    **比较运算符**
    ```text
    >  <  =  <>  !=  >=  <=  <=> 安全等于
    ```

* 按逻辑表达式筛选
    ```text
    逻辑运算符
    标准: AND    OR    NOT
    兼容: &&     ||    ! 
    ```

* 模糊查询
    ```text
    like '匹配模式'
    between A and B
    in(set)
    is null
    is not null
    ```

### 按条件表达式筛选
* 示例：查询工资>12000的员工信息
    ```mysql
    SELECT
        *
    FROM
        employees
    WHERE salary > 12000;
    ```

* 案例2：查询部门编号不等于90号的员工名和部门编号
    ```mysql
    SELECT last_name, department_id
    FROM employees
    WHERE department_id <> 90;

    -- 
    SELECT last_name, department_id
    FROM employees
    WHERE department_id != 90;
    ```

### 按逻辑表达式筛选
* 案例1：查询工资在10000到20000之间的员工名、工资以及奖金
    ```mysql
    SELECT
        last_name, salary, commission_pct
    FROM
        employees
    WHERE salary >= 10000
        AND salary <= 20000;
    ```

* 案例2：查询部门编号不是在90到110之间，或者工资高于15000的员工信息
    ```mysql
    SELECT * 
    FROM employees
    WHERE NOT (department_id >= 90 AND department_id <= 110)
        OR salary > 15000;
        
    --
    SELECT * 
    FROM employees
    WHERE !(department_id >= 90 && department_id <= 110)
        || salary > 15000;
    ```

### 模糊查询
```
like '匹配模式'

betwenn A AND B
in(set)
is null
is not null
```
* 通配符
    ```text 
    %：0个或多个任意字符
    
    _: 1个任意字符
    ```
* like '匹配模式'  
一般和通配符搭配使用

    * 案例1：查询员工名中包含字符a的员工信息
        ```mysql
        SELECT * 
        FROM employees
        WHERE first_name LIKE '%a%';
        ```

    * 案例2：查询员工名中第三个字符为e，第五个字符为a的员工名和工资
        ```mysql
        SELECT first_name 名, CONCAT(first_name, ' ',last_name) 姓名,salary
        FROM employees
        WHERE first_name LIKE '__e_a%';
        ```

    * 案例3：查询员工姓中第二个字符为_的员工名
        ```mysql
        -- ESCAPE '标识符' 显式指定转义，建议使用这种
        SELECT last_name 
        FROM employees
        WHERE last_name LIKE '_$_%' ESCAPE '$'; -- 指定$右边第一个字符为转义的，$可以用其他字符来标识
        
        
        SELECT last_name 
        FROM employees
        WHERE last_name LIKE '_\_%'; -- 这种转义方式也可以
        ```

* between A and B
    ```
    字段或变量的取值范围在[A, B]闭区间
    A,B都为数值类型
    ```
    * 案例1：查询员工编号在100到120之间的员工信息
        ```mysql
        SELECT * 
        FROM employees
        WHERE employee_id >= 100 AND employee_id <= 120;
        
        -- 
        SELECT * 
        FROM employees
        WHERE employee_id BETWEEN 100 AND 120;
        ```


* in(set)
    ```
    判断某字段的值是否在集合set中
    注意：
    set表示方式，ele1, ele2,...
    * set集合中的元素类型必须一致或兼容
    * set集合中的元素不支持通配符
    * set里的元素建议不重复
    ```

    * 案例：查询员工的工种编号是 IT_PROG、AD_VP、AD_PRES中的员工名和工种编号
        ```mysql
        SELECT job_id, first_name
        FROM employees
        WHERE job_id = 'IT_PROG'
            OR job_id = 'AD_VP'
            OR job_id = 'AD_PRES';
        
        --
        SELECT job_id, first_name
        FROM employees
        WHERE job_id IN('IT_PROG', 'AD_VP', 'AD_PRES');
        ```


* is null
    ```text
    =、<>、!=不能判断NULL值
    is null、is not null 可以判断null值
    
    
    注意：没有以下写法
    NOT (IS NULL)
    NOT IS NULL
    
    IS 只能判断NULL 或 NOT NULL
    ```

    * 案例1：查询没有奖金的员工名和奖金率
        ```mysql
        SELECT first_name, commission_pct
        FROM employees 
        WHERE commission_pct IS NULL;
        
        --
        SELECT first_name, commission_pct
        FROM employees 
        WHERE commission_pct IS NOT NULL;
        ```


* <=>安全等于
    ```text
    与=功能类似，但可以用于判断NULL值，不能与NOT NULL组合
    =无法判断NULL值，也不能与NOT NULL组合
    <=> (NOT NULL)  结果等效于 <=> NULL
    ```

    * 案例1：查询没有奖金的员工名和奖金率
        ```
        SELECT first_name, commission_pct
        FROM employees 
        WHERE commission_pct <=> NULL;
        ```

    * 案例2：查询工资为12000的员工信息
        ```mysql
        SELECT * 
        FROM employees 
        WHERE salary <=> 12000;
        ```

* IS NULL与<=>
    ```text
    IS NULL: 只能判断NULL值，可读性较高，建议使用
    <=>: 既可以判断NULL值，也可以判断其他类型的值，可读性低
    ```

</details>

## 常见函数
<details>
<summary>常见函数</summary>

</details>

## 分组函数
<details>
<summary>分组函数</summary>

</details>

## 分组查询
<details>
<summary></summary>

</details>

## 连接查询
<details>
<summary>连接查询</summary>

</details>

## 子查询
<details>
<summary>子查询</summary>

</details>

## 分页查询
<details>
<summary>分页查询</summary>

</details>

## union联合查询
<details>
<summary>union联合查询</summary>

</details>

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
