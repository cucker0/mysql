SQL语言
==

# 本次测试练习的表关系模型
[sql 文件](./sql/myemployees.sql)  
![](./images/myemployees库的表关系模型.png)  
![](./images/myemployees库的表关系模型2.png)  


# SQL语句的3种类型
* DML数据操作语句
* DDL数据定义语句
* DCL数据控制语句

# DQL查询语句
DML数据处理操作语句中的查询操作

* 单引号' 和 双引号"
    * 在标准 SQL 中，字符串使用的是单引号
    * 如果字符串本身也包括单引号，则使用两个单引号（注意，不是双引号，字符串中的双引号不需要另外转义）
    * MySQL对 SQL 的扩展，允许使用单引号和双引号两种
* 反引号 \`
```text
为了区分MySQL的保留字与普通字符，可以包裹字段、表名、数据库等
```

```mysql
create table desc; -- 报错 
create table `desc`; -- 成功
```
* 一般我们建表时都会将表名，库名都加上反引号来保证语句的执行度。


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
    in (set)
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
    * where子句中使用别名注意事项  
    示例：选择姓名中有字母 a 和 e 的员工姓名
        ```text
        sql是在where后order by前加别名，即生成结果集后加别名，
        where是在生成结果集前的操作，
        order by是生成结果集后的操作，
        因为where要生成结果集，而order by是对结果集的操作。
        如果非要用别名，那么只能用派生表，即先生成别名再where
        
        -- 在where中保用别名会报错，错误代码： 1054, UNKNOWN COLUMN 'fullname' IN 'where clause'
        SELECT CONCAT(first_name, ' ', last_name) AS fullname
        FROM employees
        WHERE fullname LIKE '%a%' AND first_name LIKE '%e%';
        
        -- 正确写法
        SELECT CONCAT(first_name, ' ', last_name) AS 姓名
        FROM employees
        WHERE CONCAT(first_name, ' ', last_name) LIKE '%a%' AND first_name LIKE '%e%';
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
        
        -- 与上面的写法等价
        SELECT * 
        FROM employees
        WHERE employee_id BETWEEN 100 AND 120;
        ```


* in (set)
    ```
    判断某字段的值是否在集合set中
    如：in (ele1, ele2, ...)
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
        WHERE job_id IN ('IT_PROG', 'AD_VP', 'AD_PRES');
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

## 排序查询
<details>
<summary>排序查询</summary>

### 排序查询语法
```text
select 查询列表
from 表名
[where 筛选条件]
order by 排序列表 [asc |desc]


特点：
asc: 升序
desc: 降序
不指定排序方式默认为asc升序

* order by 子句可以支持 单个字段、别名、表达式、函数、多个字段
* order by 子句放在查询语句的最后面，除了limit子句
```

* 按单个字段排序
    ```mysql
    SELECT * 
    FROM employees
    ORDER BY salary DESC;
    ```

* 筛选条件过滤后再排序

    **案例：查询部门编号>=90的员工信息，并按员工编号降序**
    ```mysql
    SELECT * 
    FROM employees
    WHERE department_id >= 90
    ORDER BY department_id DESC;
    ```


* 按表达式排序

    **案例：查询员工信息 按年薪降序**
    ```mysql
    SELECT
        *, (
            salary * 12 * (1 + IFNULL(commission_pct, 0))
        ) AS 年薪
    FROM
        employees
    ORDER BY (salary * 12 * (1 + IFNULL(commission_pct, 0))) DESC;
    ```

* 按别名排序

    **案例：查询员工信息 按年薪升序**
    ```mysql
    SELECT
        *, (
            salary * 12 * (1 + IFNULL(commission_pct, 0))
        ) AS 年薪
    FROM
        employees
    ORDER BY 年薪 DESC;
    ```

* 按函数排序
    **案例：查询员工名，并且按名字的长度降序**
    ```mysql
    SELECT first_name, LENGTH(first_name) AS 名字长度
    FROM employees
    ORDER BY LENGTH(first_name) DESC;
    ```


* 按多个字段排序
    ```text
    按多个字段排序时，
    第一个字段为主排序关键字，后面的为次排序关键字
    先按第一个字段指定的排序方式排序，
    当按第一个字段排序好后，第一个字段相同的记录再按第二个字段排序方式排序，
    依此类推
    ```

    **案例：查询员工信息，要求先按工资降序，再按employee_id升序**
    ```mysql
    SELECT *
    FROM employees
    ORDER BY salary DESC, employee_id ASC;
    ```
</details>

## 常见函数
<details>
<summary>常见函数</summary>

### 函数概念
类似于java中的方法，将一组逻辑语句封装在方法体中，对外暴露方法名

### 函数分类
* 单行函数
```text
这里的单行，指输入一行的数据，返回一个值。

如 concat(str1, str2, ...), length(str), ifnull(expr1, expr2)
```
* 分组函数
```text
分组值，指输入一组(多行)的数据，返回一个值。

功能：用于统计，也称统计函数、聚合函数、组函数
如SUM(expr)、AVG(expr)、MAX(expr)、MIN(expr)、COUNT(expr)
```

### 单行函数
* 字符函数
    ```text
    lenght(str) 获取字符串字节长度(在utf8字符集中一个汉字占3个字节, gbk为2字节)
    CONCAT(str1,str2,...) 拼接字符串
    UPPER(str)字符串转大写
    LOWER(str)字符串转小写
    SUBSTR(str,pos)、SUBSTRING(str,pos)
    SUBSTR(str,pos,len)、SUBSTRING(str,pos, len) 截取子字符串
    INSTR(str,substr) 返回子串第一次出现的首地址索引，如果找不到返回0
    TRIM(str) 去掉字符串str首尾的空格
    TRIM(remstr FROM str) 从字符串str中去掉首尾指定的字符remstr
    LPAD(str,len,padstr) 用指定的字符padstr左填充str，保证填充后的字符串长度为len，并返回充后的字符串
    RPAD(str,len,padstr) 用指定的字符padstr右填充str，保证填充后的字符串长度为len，并返回充后的字符串
    REPLACE(str,from_str,to_str) 把字符串str中所有的from_str字符替换成字符to_str
    ```
* 数学函数
    ```text
    ROUND(X) 数X的绝对值做四舍五入运算，精确到个位，符号不变
    ROUND(X,D) 小数X的绝对值做四舍五入运算，精确到第D位小数，符号不变
    CEIL(X) 向上取整，返回>= X的最小整数
    FLOOR(X) 向下取整，返回 <= X的最大整数
    TRUNCATE(X,D) 截断数X小数点后第D位之后所有小数，直接截断(填补0)，不做四舍五入
    MOD(N,M) 取模运算，求余数，数N模以数M
    ```
* 日期、时间函数
    ````text
    NOW()返回服务器当前 日期时间，属于date,也属于time
    CURDATE() 返回服务期系统当前日期，不包括时间
    CURTIME() 返回服务期系统当前时间，不包括日期
    从指定的日期或时间对象中获取年、月、日、时、分、秒，月份名称
    YEAR(date) 从日期date中获取年
    MONTH(date) 从日期date中获取月
    DAY(date) 从日期date中获取日
    HOUR(time) 从时间time中获取时
    MINUTE(time) 从时间time中获取分
    SECOND(time) 从时间time中获取秒
    MONTHNAME(date) 从日期date中获取月份名称
    STR_TO_DATE(str,format) 根据日期格式format将字符创str转成日期，并返回
    DATE_FORMAT(date,format) 格式化date对象，根据日期格式format将日期date转换成字符串，并返回
    DATEDIFF(expr1,expr2) 计算expr1, expr2的天数差值,日期时间expr1 - 日期时间expr2的天数
    ````
* 其他函数
    ```text
    SELECT VERSION(); 查看服务端mysql版本
    SELECT DATABASE(); 查看当前连接的库
    SELECT USER(); 查看当前使用的连接用户
    ```
* 控制函数
    ```text
           IF(expr1,expr2,expr3) 如果逻辑表达式expr1为true,则返回表达式expr2，否则返回表达式expr3
           case用于字段或表达式值枚举处理
           case用于字段或表达式值范围枚举处理
           ```


#### 字符函数
* lenght(str) 获取字符串字节长度(在utf8字符集中一个汉字占3个字节, gbk为2字节)
    ```mysql
    SELECT LENGTH('trip');
    SELECT LENGTH('神功盖世'); -- 长度为：12
    
    SHOW VARIABLES LIKE '%char%'; -- 查看服务端使用的字符集
    ```

* CONCAT(str1,str2,...)拼接字符串
    ```mysql
    SELECT CONCAT(first_name, ' ', last_name) AS 姓名
    FROM employees;
    ```

* UPPER(str)字符串转大写
    >SELECT UPPER('abcdef');

* LOWER(str)字符串转小写
    >SELECT LOWER('Guang Dong');

    **示例：将姓变大写，名变小写，然后拼接**
    ```mysql
    SELECT CONCAT(UPPER(first_name), ' ',LOWER(last_name)) 姓名
    FROM employees
    ```

* 截取子字符串(SUBSTR、SUBSTRING)
    ```text
    字符串的索引从1开始计数
    
    SUBSTR(str,pos) 截取指定str字符串从第pos个字符开始到结尾的子字符串
    SUBSTR(str,pos,len) 截取str字符串从第pos个字符开始，长度为len的子字符串的子字符串
    SUBSTR(str FROM pos) 与SUBSTR(str,pos)功能相同，截取str字符串从第pos个字符开始到结尾的子字符串
    SUBSTR(str FROM pos FOR len) 与SUBSTR(str,pos,len)功能相同，截取str字符串从第pos个字符开始，长度为len的子字符串
    
    SUBSTRING(str,pos) 对应SUBSTR(str,pos)
    SUBSTRING(str,pos,len) 对应SUBSTR(str,pos,len)
    SUBSTRING(str FROM pos) 对应SUBSTR(str FROM pos)
    SUBSTRING(str FROM pos FOR len) 对应SUBSTR(str FROM pos FOR len)
    ```

    **截取从指定索引处后面所有字符**
    >SELECT SUBSTR('习近平致信祝贺大庆油田发现60周年全文', 4) out_put; -- 致信祝贺大庆油田发现60周年全文

    **截取从指定索引处指定字符长度的字符**
    ```mysql
    SELECT SUBSTR('习近平致信祝贺大庆油田发现60周年全文', 4, 2) out_put; -- 致信
    SELECT SUBSTR('abcdef' FROM 2); -- bcdef
    SELECT SUBSTR('abcdef' FROM 2 FOR 3); -- bcd
    
    SELECT SUBSTRING('习近平致信祝贺大庆油田发现60周年全文', 4);
    ```

    **案例：姓名中首字符大写，其他字符小写然后用_拼接，显示出来**
    ```mysql
    SELECT
        CONCAT (
            UPPER(SUBSTR(first_name, 1, 1)),
            LOWER(SUBSTR(first_name, 2)),
            ' ',
            LOWER(last_name)
        )
    FROM
        employees;
      
    -- 方法2
    SELECT
        CONCAT (UPPER(SUBSTR(fname, 1, 1)), LOWER(SUBSTR(fname, 2))) AS 姓名
    FROM
        (SELECT CONCAT (first_name, ' ', last_name) AS fname FROM employees) employees;
    ```

* INSTR(str,substr) 返回子串第一次出现的首地址索引，如果找不到返回0
    ```text
    SQL中，0表示false, 1表示true
    ```
    
    >SELECT INSTR('上海自来水来自海上,山西运煤车煤运西山,自来水', '自来水'); -- 结果：3

* TRIM(str) 去掉字符串str首尾的空格
* TRIM(remstr FROM str) 从字符串str中去掉首尾指定的字符remstr
    ```mysql
    SELECT LENGTH(TRIM('    Good    ')); -- 4
    SELECT TRIM('e' FROM 'eeeeeeee张eee教主eeeeeeeeeeeeeeeeeee'); -- 张eee教主
    ```

* LPAD(str,len,padstr) 用指定的字符padstr左填充str，保证填充后的字符串长度为len，并返回充后的字符串
    ```text
    当len小于str的长度时，会截断右边多余的字符 (保留左边的)
    ```

    ```mysql
    SELECT LPAD('2', 3,'0'); -- '002'
    
    SELECT LPAD('中国海军', 2,'c'); -- '中国'
    ```

* RPAD(str,len,padstr) 用指定的字符padstr右填充str，保证填充后的字符串长度为len，并返回充后的字符串
    ```text
    当len小于str的长度时，会截断右边多余的字符 (保留左边的)
    ```
    
    ```mysql
    SELECT RPAD('中国海军', 12,'c'); -- 中国海军cccccccc
    SELECT RPAD('中国海军', 2,'c'); -- '中国'
    ```

* REPLACE(str,from_str,to_str) 把字符串str中所有的from_str字符替换成字符to_str
    >SELECT REPLACE('周芷若周芷若周芷若周芷若张无忌爱上了周芷若', '周芷若', '赵敏');

#### 数学函数
* ROUND数值做四舍五入运算
    ```text
    ROUND(X) 数X的绝对值做四舍五入运算，精确到个位，符号不变
    ROUND(X,D) 小数X的绝对值做四舍五入运算，精确到第D位小数，符号不变
    ```
    
    ```mysql
    SELECT ROUND(1.55); -- 2
    SELECT ROUND(-1.55); -- 结果：-2
    SELECT ROUND(-3.1415, 3); -- 3.142
    ```

* CEIL(X) 向上取整，返回>= X的最小整数
    ```mysql
    SELECT CEIL(2.11); -- 3
    SELECT CEIL(-2.11); -- -2
    ```

* FLOOR(X) 向下取整，返回 <= X的最大整数
    ```mysql
    SELECT FLOOR(3.11); -- 3
    SELECT FLOOR(-3.11); -- -4
    ```

* TRUNCATE(X,D) 截断数X小数点后第D位之后所有小数，直接截断(填补0)，不做四舍五入
    ```text
    D必须是整数，
    D为0：表示小数点后所以小数截断不要
    D为负数，表示小数点左边D位内的都取0
    ```
    
    ```mysql
    SELECT TRUNCATE(3.333333, 1); -- 3.3
    SELECT TRUNCATE(3.333333, 0); -- 3
    SELECT TRUNCATE(33, 1); -- 33
    SELECT TRUNCATE(3333, -2); -- 3300
    ```

* MOD(N,M) 取模运算，求余数，数N模以数M
    ```text
    MOD(N,M) ==> N - N/M * M
    ```
    
    ```mysql
    SELECT MOD(10, 3); -- 1
    SELECT MOD(10, -3); -- 1
    SELECT MOD(-10, -3); -- -1
    SELECT MOD(-10, 3); -- -1
    SELECT 10 % 3;
    ```
    
#### 日期、时间函数
* NOW()返回服务器当前 日期时间，属于date,也属于time
    >SELECT NOW(); -- 2019-09-27 10:31:58

* CURDATE() 返回服务期系统当前日期，不包括时间
    >SELECT CURDATE(); -- 2019-09-27

* CURTIME() 返回服务期系统当前时间，不包括日期
    >SELECT CURTIME(); -- 10:34:07

* 从指定的日期或时间对象中获取年、月、日、时、分、秒，月份名称
    ```text
    now() 获取的日期时间对象，属于date和time类型
    
    YEAR(date) 从日期date中获取年
    MONTH(date) 从日期date中获取月
    DAY(date) 从日期date中获取日
    HOUR(time) 从时间time中获取时
    MINUTE(time) 从时间time中获取分
    SECOND(time) 从时间time中获取秒
    MONTHNAME(date) 从日期date中获取月份名称
    DATEDIFF(expr1,expr2) 日期时间expr1 - 日期时间expr2的天数
    ```
    
    ```mysql
    SET @now=NOW(); -- 设置局部变量，引用变量 @变量名
    SELECT @now;
    
    SELECT YEAR(@now);
    SELECT YEAR(NOW());
    SELECT YEAR('2008-01-10'); -- 2008
    SELECT YEAR('2008/01/10'); -- 2008
    SELECT YEAR('2008.1.10'); -- 2008
    SELECT YEAR(hiredate) AS 年 FROM employees;
    
    --
    SELECT MONTH(NOW()); 
    SELECT MONTH('2019-06-01');
    
    --
    SELECT MONTHNAME(@now); -- September
    
    -- 
    SELECT DAY(NOW());
    
    --
    SELECT HOUR(NOW());
    SELECT HOUR(CURTIME());
    
    --
    SELECT MINUTE(NOW());
    
    --
    SELECT SECOND(NOW());
    SELECT SECOND('12:00:13');
    ```

##### format匹配模式字母定义
格式 |定义 
:--- |:---
%Y |4位的年份
%y |2位的年份
%m |2位的月份(01, 02...11, 12)
%c |自然月份(1, 2...11, 12)
%d |2位的日(01, 02...31)
%H |2位的小时(24小时制)
%h |小时(12小时制)
%i |2位的分钟(01, 02...59)
%s |2位的秒(01, 02...59)


* STR_TO_DATE(str,format) 根据日期格式format将字符创str转成日期，并返回
    >SELECT STR_TO_DATE('1999-12-31', '%Y-%c-%d');

    **示例：查询入职日期为1992-4-3的员工信息**
    ```mysql
    SELECT * 
    FROM employees
    WHERE hiredate = '1992-4-3';
    --
    SELECT * FROM employees
    WHERE hiredate = STR_TO_DATE('4-3 1992', '%c-%d %Y');
    ```

* DATE_FORMAT(date,format) 格式化date对象，根据日期格式format将日期date转换成字符串，并返回
    >SELECT DATE_FORMAT(NOW(), '%Y年%m月%d日'); -- 2019年09月27日

    **查询有奖金的员工名和入职日期(xx月/xx日 xx年)**
    ```mysql
    SELECT first_name, DATE_FORMAT(hiredate, '%m月/%d日 %y年') AS 入职日期
    FROM employees
    WHERE commission_pct IS NOT NULL;
    ```
    
#### 其他函数
* SELECT VERSION(); 查看服务端mysql版本
* SELECT DATABASE(); 查看当前连接的库
* SELECT USER(); 查看当前使用的连接用户

    ```mysql
    SELECT VERSION();
    SELECT DATABASE();
    SELECT USER(); -- root@localhost
    ```

#### 流程分支控制函数
* IF(expr1,expr2,expr3) 如果逻辑表达式expr1为true,则返回表达式expr2，否则返回表达式expr3
    ```text
    功能类似三目运算：expr1 ? expr2 : expr3
    
    expr2,expr3的类型要求相同或能兼容
    ```

    ```mysql
    SELECT IF(2 < 4, '小', '大'); -- 小
    
    SELECT 
        first_name,
        commission_pct,
        IF(commission_pct IS NULL, '无', '有') AS 是否有奖金
    FROM employees;
    ```

* IFNULL(expr1,expr2) 如果表达式expr1为null，则返回expr2, 否则返回expr1
    ```mysql
    SELECT IFNULL(commission_pct, '无奖金')
    FROM employees;
    ```

* case用于字段或表达式值枚举处理
    ```text
    
    功能类似java中的case
    switch(变量或表达式或枚举类) {
        case 常量1:
            语句1;
            break;
        case 常量2:
            语句2;
            break;
        ...
        default:
            语句n;
            break;
    }
    
    
    mysql中的case:
    case 字段或表达式
    when 常量1 then
        返回的值1或语句1
    when 常量2 then
        返回的值2或语句2
    ...
    [else 返回的值n或语句n]
    end
    
    ```

    **案例：查询员工的工资，要求如下：**
    ```text
    部门号=30，显示的工资为1.1倍
    部门号=40，显示的工资为1.2倍
    部门号=50，显示的工资为1.3倍
    其他部门，显示的工资为原工资
    ```

    ```mysql
    SELECT
        department_id,
        salary 原工资,
        CASE department_id
    WHEN 30 THEN
        salary * 1.1
    WHEN 40 THEN
        salary * 1.2
    WHEN 50 THEN
        salary * 1.3
    ELSE salary
    END AS 新工资
    FROM employees;
    ```

* case用于字段或表达式值范围枚举处理
    ```text
    功能类似java中的多重if：
    
    if(逻辑表达式1) {
        语句1;
    } else if(逻辑表达式2) {
        语句2;
    } 
    ...
    else {
        语句n;
    }
    
    
    mysql中:
    case
    when 逻辑表达式1 then 返回的值1或语句1
    when 逻辑表达式2 then 返回的值2或语句2
    ...
    [else 默认返回的值n或语句n]
    end
    ```

    **案例：查询员工的工资的情况**
    ```text
    如果工资>20000,显示A级别
    如果工资>15000,显示B级别
    如果工资>10000，显示C级别
    否则，显示D级别
    ```

    ```mysql
    SELECT 
        salary,
        CASE
    WHEN salary > 20000 THEN
        'A'
    WHEN salary > 15000 THEN
        'B'
    WHEN salary > 10000 THEN
        'C'
    ELSE 'D'
    END AS 级别
    FROM employees;
    ```
</details>

## 分组函数
<details>
<summary>分组函数</summary>

### 分组函数概念与功能
```text
功能：用于统计，有称为聚合函数、统计函数、组函数
输入多个值（多行的值），最后返回一个值，不能与返回多行的组合使用
```

###  分组函数概览与总结
```text
SUM(expr) 求和
SUM([DISTINCT] expr) 去重后求和
AVG([DISTINCT] expr) 求平均值(去重后求平均值)
MAX(expr) 求最大值
MAX([DISTINCT] expr) 去重后求最大值
MIN(expr) 求最小值
MIN([DISTINCT] expr) 去重后求最小值
COUNT(expr) 计算非null值的行个数
COUNT(DISTINCT expr,[expr...]) 返回列出的字段不全为NULL值的行，再去重的数目, 可以写多个字段，expr不能为*
```

* 特点
    * sum, avg一般用于处理数值型
    * 以上分组函数都忽略所提供字段全为null的记录
    * count(expr)一般用于统计行数
    * 与分组函数一起查询的字段要求是group by后的字段


* 分组函数基本使用
    ```mysql
    SELECT SUM(salary) FROM employees;
    SELECT AVG(salary) FROM employees;
    SELECT MAX(salary) FROM employees;
    SELECT MIN(salary) FROM employees;
    SELECT COUNT(salary) FROM employees;
    
    SELECT
        SUM(salary) AS 和, AVG(salary) 平均值, MAX(salary) 最大值, MIN(salary) 最小值, COUNT(salary) 计数
    FROM
        employees;
    ```

* 参数支持的类型
    ```mysql
    SELECT SUM(last_name), AVG(last_name) FROM employees; -- 结果：0， 0，结论SUM(expr), AVG(expr)不支持字符型
    SELECT SUM(hiredate), AVG(hiredate) FROM employees; -- 日期、时间无意义
    ```
    
    * max(expr), min(expr)支持可排序的类型，如字符、数值、日期时间等
        ```mysql
        SELECT MAX(last_name), MIN(last_name) FROM employees; -- 支持字符
        SELECT MAX(hiredate), MIN(hiredate) FROM employees; -- 支持日期、时间
        
        SELECT COUNT(commission_pct) FROM employees; -- 35, 值为null的不计算
        SELECT COUNT(last_name) FROM employees;
        SELECT COUNT(*) FROM employees;
        ```

* 忽略所选字段全为NULL值的记录
    ```mysql
    SELECT SUM(commission_pct), AVG(commission_pct), SUM(commission_pct)/35, SUM(commission_pct)/107  FROM employees;
    
    SELECT MAX(commission_pct), MIN(commission_pct) FROM employees;
    
    SELECT COUNT(commission_pct) FROM employees; -- 35
    SELECT commission_pct FROM employees;
    ```

* 都可以和distinct去重搭配
    ```mysql
    SELECT SUM(DISTINCT salary), SUM(salary) FROM employees;
    
    SELECT COUNT(DISTINCT salary), COUNT(salary) FROM employees;
    ```

* count函数详细介绍
    ```mysql
    SELECT COUNT(salary) FROM employees;
    
    SELECT COUNT(*) FROM employees;
    
    SELECT COUNT(1) FROM employees; -- 相当于SELECT *, 1 FROM employees;的每行后加一列值为1，然后统计新加这列值不为null的行数
    
    SELECT COUNT(NULL) FROM employees; -- 0
    ```

    * count(表达式)
    ```mysql
    SELECT COUNT(DISTINCT last_name, department_id)
    FROM employees;
    
    SELECT (salary = 24000) FROM employees;
    
    SELECT COUNT(DISTINCT salary = 24000) FROM employees; -- 结果：2，因为salary要么等于24000，要么不等于
    ```

    * 效率比较
        ```text
        MYISAM存储引擎下，COUNT(*)的效率高，有一个值专门统计行数，直接返回该值
        INNODB存储引擎下，COUNT(*)和COUNT(1)的效率差不多，比COUNT(字段)要高一些
        ```

* 分组函数与字段查询有限制
    ```text
    因为分组函数值返回一个值，不能与多行的结果的组合使用
    ```
    
    **错误写法**
    ```mysql
    SELECT AVG(salary), first_name FROM employees; -- 错误
    ```
</details>

## 分组查询
<details>
<summary>分组查询</summary>

### 分组查询语法
```text
语法：
select 分组函数, 分组字段
from 表名
[where 筛选条件]
group by 分组的字段
[order by 排序的字段];


```

* 分组查询特点
    * 能和分组函数一起出现在select查询列表中的字段必须是group by里的字段，因为group by里的字段与组合函数的结果是一一对应的
    * 筛选分为两类：分组前筛选、分组后筛选
    * 分组可以按单个字段，也可以按多个字段
    * 分组可以搭配排序
    * 分组函数做筛选能不能放在where子句中
    * 分组前筛效率高于分组后筛选，一般的，能用分组前筛的，尽量使用分组前筛，提高效率
    
* 分组前筛选 与 分组后筛选比较

分类 |筛选对象 |位置 |连接的关键字 |能否引用字段别名
:--- |:--- |:--- |:--- |:---
分组前筛选 |原始表 |group by前 |where |不能
分组后筛选 |group by后的结果集 |group by后 |having |能


* 简单分组查询
    * 案例1：查询每个部门的员工个数
        ```mysql
        SELECT department_id, COUNT(*) 
        FROM employees
        WHERE department_id IS NOT NULL
        
        GROUP BY department_id;
        ```

    * **案例2：查询每个工种的员工平均工资**
        ```mysql
        SELECT job_id, AVG(salary)
        FROM employees
        GROUP BY job_id;
        ```

    * 案例3：查询每个位置的部门个数
        ```mysql
        SELECT location_id, COUNT(department_id)
        FROM departments
        GROUP BY location_id;
        ```


* 实现分组前的筛选
    * 案例1：查询每个部门中邮箱包含a字符的最高工资
        ```mysql
        SELECT MAX(salary), department_id
        FROM employees
        WHERE email LIKE '%a%'
        GROUP BY department_id;
        ```

    * 案例2：查询每个领导手下有奖金员工的平均工资
        ```mysql
        SELECT AVG(salary), manager_id
        FROM employees
        WHERE commission_pct IS NOT NULL
        GROUP BY manager_id;
        ```
        
* 分组后筛选
    * 案例1：查询哪个部门的员工个数>5
    
        **[1] 查询每个部门的员工个数**
        ```mysql
        SELECT department_id, COUNT(*) AS c
        FROM employees
        GROUP BY department_id;
        ```

        **[2] 筛选上面[1]的结果**
        ```mysql
        SELECT department_id, COUNT(*) AS coun
        FROM employees
        GROUP BY department_id
        HAVING coun > 5; -- 这步在查询完结果，设置完别名后，才执行，所以这里可以引用别名
        ```

    * 案例2：每个工种有奖金的员工的最高工资>12000的工种编号和最高工资
        ```mysql
        SELECT job_id, MAX(salary) AS higth
        FROM employees
        WHERE commission_pct IS NOT NULL
        GROUP BY job_id
        HAVING higth > 12000;
        ```
        
    * 案例3：领导编号>102的每个领导手下的最低工资大于5000的领导编号和最低工资
        ```mysql
        SELECT manager_id, MIN(salary) AS low
        FROM employees
        WHERE manager_id > 102
        GROUP BY manager_id
        HAVING low > 5000;
        ```

* 分组后再筛选，结果指定排序方式
    * 案例：每个工种有奖金的员工的最高工资>6000的工种编号和最高工资,按最高工资升序
        ```mysql
        SELECT job_id, MAX(salary) m
        FROM employees
        WHERE commission_pct IS NOT NULL
        GROUP BY job_id
        HAVING m > 6000
        ORDER BY m ASC;
        ```

* 按多个字段分组
    * 案例：查询每个工种在每个部门的最低工资,并按最低工资降序
        ```mysql
        SELECT job_id, department_id, MIN(salary) AS mi
        FROM employees
        GROUP BY job_id, department_id
        ORDER BY mi DESC;
        
        -- 调换分组的字段顺序结果相同
        SELECT job_id, department_id, MIN(salary) AS mi
        FROM employees
        GROUP BY department_id, job_id
        ORDER BY mi DESC;
        ```
</details>

## 连接查询
<details>
<summary>连接查询</summary>


### 连接查询分类
* 按sql标准发布年份分  
    * SQL-92(SQL2)
        ```text
        仅支持内连接，根据连接条件，查询结果集为能在表1、表2中找到互相对应的记录
        ```
      
    * SQL:1999(SQL3)
        ```text
        推荐使用，功能更强，连接条件与筛选条件分离，可读性更好
        支持 内连接、左外连接、右外连接、全外连接(mysql不支持)、交叉连接
        ```
    * ... ...
    * SQL:2016
        ```text
        最新的sql标准，增加行模式匹配、多态表函数、JSON功能
        ```
* 按功能分类
    * 内连接
        * 等值内连接
        * 非等值内连接
        * 自连内连接
    * 外连接
        * 左外连接
        * 右外连接
        * 全外连接
    * 交叉连接
    
### SQL-92连接语法(仅支持内连接)
补充测试库和表，执行girls.sql脚本，创建girls库及相应的表  
![](./images/girls库的表关系模型.png)  

#### SQL-92语法
```text
select 查询列表
from 表1 别名1, 表2 别名2
where 连接条件
[and 其它筛选条件]
[group by 分组字段]
[having 分组后筛选条件]
[order by 排序字段或表达式 排序方式]


其中表1、表2可以为同一个表，表示自连接，
注意：起了别名后，原来的表名将不可用


select 查询列表
from 表1 别名1, 表2 别名2, 表3 别名3
where 表1与表2连接条件
and 表2与表3连接条件或者是表1与表3连接条件
[and 其它筛选条件]
[group by 分组字段]
[having 分组后筛选条件]
[order by 排序字段或表达式 排序方式]
```

#### 笛卡尔乘积现象(交叉连接)
```text
表1 有m行，
表2 有n行，
查询结果集= m*n 行，即表1中的每行与表2中的所有行都连接

* 发生原因：没有指定有效的连接条件
* 避免方法：添加有效的连接条件
```

```mysql
USE girls;

SELECT * FROM beauty; -- 12行
SELECT * FROM boys; -- 4行

SELECT beauty.*, boys.*
FROM beauty, boys; -- 48行
```

#### 等值连接
相当于取两表的连接条件相等的交集记录
* 案例1：查询女神名和对应的男神名
    ```mysql
    SELECT NAME, boyName
    FROM beauty, boys
    WHERE beauty.`boyfriend_id` = boys.`id`;
    
    --
    SELECT *
    FROM beauty, boys
    WHERE beauty.`boyfriend_id` = boys.`id`;
    ```

* 案例2：查询员工名和对应的部门名
    ```mysql
    USE myemployees;
    
    SELECT first_name, department_name
    FROM employees, departments
    WHERE employees.`department_id` = departments.`department_id`;
    ```

* 为表起别名
    * 查询员工名、工种号、工种名
        ```mysql
        SELECT first_name, j.job_id, job_title
        FROM employees AS e, jobs AS j
        WHERE e.`job_id` = j.`job_id`;
        ```

    * 两个表的顺序可以调换，结果完全一样
        ```mysql
        SELECT first_name, j.job_id, job_title
        FROM jobs AS j, employees AS e
        WHERE e.`job_id` = j.`job_id`;
        ```    
        
* 可以添加筛选条件
    * 案例：查询有奖金的员工名、部门名
        ```mysql
        SELECT e.first_name, d.department_name, e.commission_pct
        FROM employees e, departments d
        WHERE e.department_id = d.department_id
        AND commission_pct IS NOT NULL;
        ```

    * 案例2：查询城市名中第二个字符为o的部门名和城市名
        ```mysql
        SELECT city, department_name
        FROM locations l, departments d
        WHERE d.location_id = l.location_id
        AND city LIKE '_o%';
        ```

* 可以加分组
    * 案例1：查询每个城市的部门个数
    ```mysql
    SELECT l.city, COUNT(*)
    FROM locations l, departments d
    WHERE l.location_id = d.location_id
    GROUP BY l.city;
    ```

* 案例2：查询每个部门的部门名和部门的领导编号和该部门的最低工资,且该有奖金的
    ```mysql
    SELECT d.department_name, d.manager_id, MIN(e.salary)
    FROM departments d, employees e
    WHERE e.department_id = d.department_id
    AND e.commission_pct IS NOT NULL
    GROUP BY d.department_id;
    ```
 
* 可以加排序
    * 案例：查询每个工种的工种名和员工的个数，并且按员工个数降序
        ```mysql
        SELECT j.job_title, COUNT(*)
        FROM jobs j, employees e
        WHERE j.job_id = e.job_id
        GROUP BY j.job_title
        ORDER BY COUNT(*) DESC;
        ```

* 可以实现三表连接(或更多表)
    * 案例：查询员工名、部门名和所在的城市
        ```mysql
        SELECT e.first_name, d.department_name, l.city
        FROM employees e, departments d, locations l
        WHERE e.department_id = d.department_id
        AND d.location_id = l.location_id
        ```

#### 非等值连接
* 案例1：查询员工的工资和工资级别
    ````mysql
    SELECT e.salary, j.grade_level
    FROM employees e, job_grades j 
    WHERE e.salary >= j.lowest_sal 
    AND e.salary <= j.highest_sal;
    
    --
    SELECT e.salary, j.grade_level
    FROM employees e, job_grades j 
    WHERE e.salary BETWEEN j.lowest_sal AND j.highest_sal;
    ````


#### 自连接(自连内连接)
用于表内有自关联，查询时，这个表需要用到两次或两次以上

* 案例：查询 员工名和上级的名称
    ```mysql
    SELECT e.first_name 员工名, m.first_name 上级名 
    FROM employees e, employees m
    WHERE e.manager_id = m.employee_id;
    ```

### SQL:1999连接语法

#### SQL-92与SQLSQL:1999对比
```text
功能：SQL:1999比SQL-92的多
可读性：因为SQL:1999的连接条件与筛选条件分离，所有可读性更高
```

#### SQL:1999连接语法结构
```text
语法：
select 查询列表
from 表1 别名1
连接类型 join 表2 别名2
on 连接条件
[where 筛选条件]
[group by 分组字段或表达式]
[having 分组后筛选条件]
[order by 排序列表];
```

#### SQL:1999连接类型分类
* 内连接: inner join
    ```text
    筛选出的结果为第一张表与第二张表分别对应的记录
    ```
    * 等值内连接
    * 非等值内连接
    * 自连内连接
* 外连接
    * 左外连接: left [outer] join
    * 右外连接: right [outer] join
    * 全外连接: full [outer] join
        ```text
        mysql不支持,Sqlserver、Oracle、PostgreSQL，mysql用 left outer join +  union  + right outer join代替
        ```
* 交叉连接: cross join
    ```text
    与SQL-92对应的为笛卡尔乘积结果集
    ```

#### 内连接
##### SQL:1999内连接语法
```text
select 查询列表
from 表1 别名1 
[inner] join 表2 别名2
on 连接条件
[inner join 表3 on 连接条件];
```

##### SQL:1999内连接分类
* 等值内连接
* 非等值内连接
* 自连接内连接

##### SQL:1999内连特点
* 可以添加筛选、分组、分组后筛选、排序
* inner关键字可以省略，只有join关键字时，表示为内连接
* inner join内连接与sql-92语法中的连接效果是一样的，都是多表的交集
* 查询结果集与两表顺序无关，调换两表的先后顺序查询结果集仍一样

##### 等值内连接
* 案例1.查询员工名、部门名
    ```mysql
    SELECT e.first_name, d.department_name 
    FROM employees e
    INNER JOIN departments d
    ON e.department_id = d.department_id;
    
    --
    SELECT e.first_name, d.department_name
    FROM departments d
    INNER JOIN employees e 
    ON e.department_id = d.department_id;
    ```

* 案例2.查询名字中包含e的员工名和工种名（添加筛选）
    ```mysql
    SELECT
    e.first_name, j.job_title
    FROM employees e
    INNER JOIN jobs j
    ON e.job_id = j.job_id
    WHERE e.first_name LIKE '%e%';
    
    --
    SELECT
    e.first_name, j.job_title
    FROM employees e
    JOIN jobs j
    ON e.job_id = j.job_id
    WHERE e.first_name LIKE '%e%';
    ```

* 案例3.查询部门个数>3的城市名和部门个数（添加分组+筛选）
    ```mysql
    SELECT l.city, COUNT(*) 部门个数
    FROM locations l
    INNER JOIN departments d
    ON l.location_id = d.location_id
    GROUP BY l.city
    HAVING COUNT(*) > 3;
    ```

* 案例4.查询哪个部门的员工个数>3的部门名和员工个数，并按个数降序（添加排序）
    ```mysql
    SELECT d.department_name, COUNT(*) 员工个数
    FROM departments d
    INNER JOIN employees e
    ON d.department_id = e.department_id
    GROUP BY d.department_id
    HAVING 员工个数 > 3
    ORDER BY 员工个数 DESC;
    ```

* 5.查询员工名、部门名、工种名，并按部门名降序（添加三表连接）
```mysql
SELECT e.first_name, d.department_name, j.job_title
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
INNER JOIN jobs j ON e.job_id = j.job_id;
```

##### 非等值内连接

* 查询员工的工资级别
    ```mysql
    SELECT e.salary, g.grade_level
    FROM employees e
    INNER JOIN job_grades g
    ON e.salary >= g.lowest_sal AND e.salary <= g.highest_sal;
    
    --
    SELECT e.salary, g.grade_level
    FROM employees e
    INNER JOIN job_grades g
    ON e.salary BETWEEN g.lowest_sal AND g.highest_sal;
    ```

* 查询工资级别的员工个数>20的个数，并且按工资级别降序
```mysql
SELECT COUNT(*) 员工个数, g.grade_level
FROM employees e
INNER JOIN job_grades g
ON e.salary BETWEEN g.lowest_sal AND g.highest_sal
GROUP BY g.grade_level
HAVING COUNT(*) > 20
ORDER BY g.grade_level DESC;
```

##### 自连接(自连内连接)
* 查询员工的名字、上级的名字
    ```mysql
    SELECT e.first_name, e.employee_id, m.first_name AS 上级, e.manager_id
    FROM employees e
    INNER JOIN employees m
    ON e.manager_id = m.employee_id
    ```

* 查询姓名中包含字符k的员工的名字、上级的名字
    ```mysql
    SELECT e.first_name, m.first_name AS 上级
    FROM employees e
    INNER JOIN employees m
    ON e.manager_id = m.employee_id
    WHERE e.first_name LIKE '%k%';
    ```

#### 外连接
应用场景：用于查询再一个表中(主表)有，另一个表(从表)没有对应的记录

##### 外连接特点
* 外连接的查询结果为主表中的所有记录
* 如果从表中有和它匹配的，则显示匹配的值
* 如果从表中没有和它匹配的，则从表该记录所有字段都显示null
* 外连接查询结果 = 内连接结果 + 主表中有而从表中没有匹配的记录
* 左外链接，left join 左边的是主表
* 右外连接，right join 右边的是主表
* 全外连接 = 内连接结果 + 表1中有但表2中没有的 + 表2中有单表1中没有的 记录  
或 = 表1 left join 表2结果 + 表1 right join 表2结果 的并集 （这里会出现重叠的集合：表1 inner join 表2）
* 左外连接、右外连接的主表和从表位置不能调换


* 引入：查询男朋友 不在男神表的的女神名
```mysql
USE girls;

SELECT * FROM beauty;

SELECT * FROM boys;


SELECT * 
FROM beauty, boys;

SELECT * 
FROM beauty
WHERE boyfriend_id NOT IN (SELECT id FROM boys);
```


##### 左外连接
```mysql
SELECT *
FROM beauty b
LEFT OUTER JOIN boys bo
ON b.boyfriend_id = bo.id
WHERE bo.id IS NULL;

--
SELECT *
FROM beauty b
LEFT OUTER JOIN boys bo
ON b.boyfriend_id = bo.id
WHERE NOT (bo.id <=> NULL);
```

* 案例1：查询哪个部门没有员工
```mysql
-- 左外连接
USE myemployees;

SELECT d.*, ' <--->', e.*
FROM departments d    
LEFT JOIN employees e
ON d.department_id = e.department_id

WHERE e.employee_id IS NULL;

--
-- 右外连接
SELECT d.*, ' <--->', e.*
FROM  employees e
RIGHT OUTER JOIN departments d
ON e.department_id = d.department_id
WHERE e.employee_id IS NULL;
```

#### 全外连接
##### 全外连接语法
```text
select 查询列表
from 表1 别名1
full outer join 表2 别名2
on 连接条件
```

* 因为mysql不支持全外连接full outer join语法，系列语句执行时报错语法错误
```sql
USE girls;

SELECT *
FROM beauty b
FULL OUTER JOIN boys bo
ON b.boyfriend_id = bo.id;
```

* mysql中全外连接代替方法
    ```mysql
    SELECT * 
    FROM beauty b
    LEFT OUTER JOIN boys bo
    ON b.boyfriend_id = bo.id
    
    UNION
    
    SELECT * 
    FROM beauty b
    RIGHT OUTER JOIN boys bo
    ON b.boyfriend_id = bo.id;
    ```


#### 交叉链接(即笛卡尔乘积)
```mysql
SELECT * 
FROM beauty b
CROSS JOIN boys bo;


-- 效果等效(SQL-92语法)
SELECT *
FROM beauty, boys;
```
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
