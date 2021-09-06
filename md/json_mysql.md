Mysql JSON
==

## Table Of Contents
* [什么是mysql json](#什么是mysql-json)
    * [json类型数据的使用场景](#json类型数据的使用场景)
    * [示例](#示例)
    * [包含json类型字段的表的设计原则](#包含json类型字段的表的设计原则)
    * [json数据类型与json格式的字符串相比的优点](#json数据类型与json格式的字符串相比的优点)
* [docs](#docs)
* [以json值建立索引](#以json值建立索引)
* [建表](#建表)
* [插入JSON字段](#插入JSON字段)
* [以json字段内的某个值作为连接查询的条件](#以json字段内的某个值作为连接查询的条件)
* [JSON字段值的CRUD](#JSON字段值的CRUD)
    * [插入JSON值](#插入JSON值)
    * [查询JSON值](#查询JSON值)
    * [更新JSON值](#更新JSON值)
    * [删除JSON值](#删除JSON值)


## 什么是mysql json
mysql json指表字段支持JSON类型的数据(The JSON Data Type)

从mysql 5.7.8版本起，表字段开始支持json类型的数据

### json类型数据的使用场景
因为json文本带有结构信息，很方便与数据库解耦。

* 对象字段需要灵活扩展的场景

### 示例
* 在不使用json的时候，如果我们要设计一个User对象。则数据表中的信息如下
    ```mysql
    CREATE TABLE `user` (
      `id` int(11) NOT NULL AUTO_INCREMENT,
      `name` varchar(50) NOT NULL,
      `email` varchar(255) DEFAULT NULL,
      PRIMARY KEY (`id`)
    );
    ```

    * 设计的这个系统的User的结构信息是这样传递的
        ```text
        表现层（html/css/anjular/reace/vue...）：    根据需求展示学生对象各个属性
      
        模型层（java/php/c++/pyhton...）：           处理用户对象
      
        DAO层（Mybatis/Hibernate...）:              完成对象关系的映射
      
        持久层（MySql/SqlServer...）：               对各个字段进行存储
        ```
        优点：User对象的结构信息是从表现层到持久层是完全贯通且一致的。这样的优点是提高了一致性，使得代码更容易阅读。
        缺点：耦合太高，扩展不灵活。
        
    * 假设我们要增加给User对象增加一个属性age。那我们各个层都要进行修改，例如数据库层结构需要修改为
        ```mysql
        CREATE TABLE `user` (
          `id` int(11) NOT NULL AUTO_INCREMENT,
          `name` varchar(50) NOT NULL,
          `email` varchar(255) DEFAULT NULL,
          `age` int(11) DEFAULT NULL,
          PRIMARY KEY (`id`)
        );
        ```
        同时，其他各层都要进行修改。

* 引入json进行存储之后。假设我们将主要信息字段id、name字段进行保留，而次要信息字段转为json。则数据表中的信息变为
    ```mysql
    CREATE TABLE `user` (
      `id` INT(11) NOT NULL AUTO_INCREMENT,
      `name` varchar(255) NOT NULL,
      `detail` JSON DEFAULT NULL,
      PRIMARY KEY (`id`)
    );
    ```
    
    * 对于已经放入detail中的次要信息而言，Student的结构信息是这样传递的
        ```text
        表现层（html/css/anjular/reace/vue...）：       根据需求展示用户对象各个属性
  
        模型层（java/php/c++/pyhton...）：              进行json结构与模型的映射
  
        DAO层（Mybatis/Hibernate...）:                 无需完成属性与字段的映射
  
        持久层（MySql/SqlServer...）：                  无需了解字段详情
        ```
        
        使得User的次要结构信息可以与数据库解耦。当User中再增加一个属性age时，  
        我们只需要在模型层增加一个age属性，甚至连序列化操作都不需要变动就可以直接在表现层进行使用。
        
### 包含json类型字段的表的设计原则
* 将经常查询的属性采用独立字段。
* 将不经常查询且变动频繁的字段存入json字段中。

从而实现运行效率和可扩展性之间的平衡。

### json数据类型与json格式的字符串相比的优点
* 存储在JSON列中的JSON文档(json字符串)的会被自动验证。无效的文档会产生错误。
* 最佳存储格式。json类型的列会将JSON文档会被转换为允许快速读取文档元素的内部格式

## docs
* [JSON Functions](https://dev.mysql.com/doc/refman/8.0/en/json-functions.html)
* [JSON Function Reference](https://dev.mysql.com/doc/refman/8.0/en/json-function-reference.html)
* [JSON Function Reference](https://dev.mysql.com/doc/refman/8.0/en/json.html)

## 以json值建立索引
[参考 Multi-Valued Indexes](https://dev.mysql.com/doc/refman/8.0/en/create-index.html#create-index-multi-valued)

[JSON_VALUE() 简化在JSON列上创建索引的过程](json_functions.md#JSON_VALUE())

## 建表
要使用JSON数据类型，指定表字段类型为 `JSON` 即可。

```mysql
CREATE DATABASE jsontest CHARSET 'utf8mb4';
USE jsontest;

## 示例  --start
CREATE TABLE department_tbl (
    id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(64) NOT NULL
);

INSERT INTO department_tbl(`name`) VALUES
('行政部'),
('财务部'),
('销售部'),
('客服部')
;

SELECT * FROM department_tbl;
/*
    id  name       
------  -----------
     1  行政部  
     2  财务部  
     3  销售部  
     4  客服部  
*/

-- 职位表
CREATE TABLE positions(
    id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(32) NOT NULL
);

INSERT INTO positions(`name`) VALUES
('行政总监'),
('财务经理'),
('安全顾问'),
('风投首席官'),
('快乐鼓励师');

SELECT * FROM positions;
/*
    id  name             
------  -----------------
     1  行政总监     
     2  财务经理     
     3  安全顾问     
     4  风投首席官  
     5  快乐鼓励师  
*/

-- drop table employee;
-- user table
CREATE TABLE employee (
    id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(64) NOT NULL,
    rest JSON COMMENT '其它信息(json类型)'
);

-- insert record
INSERT INTO employee(`name`, rest) VALUES
('Mally', '{"age":23, "gender":0, "salary": 56000, "positions": [1], "stock": 6000000, "department_id":1}'),
('Jakob', '{"age":22, "gender":1, "salary": 80000, "positions": [2, 3, 4], "stock": 96000000, "department_id":1}'),
('Einstein', '{"age":21, "gender":1, "salary": 80000, "positions": [3], "department_id":2}')
;

SELECT * FROM employee;
/*
    id  name      rest                                                                                                      
------  --------  ----------------------------------------------------------------------------------------------------------
     1  Mally     {"age": 23, "stock": 6000000, "gender": 0, "salary": 56000, "positions": [1], "department_id": 1}         
     2  Jakob     {"age": 22, "stock": 96000000, "gender": 1, "salary": 80000, "positions": [2, 3, 4], "department_id": 1}  
     3  Einstein  {"age": 21, "gender": 1, "salary": 80000, "positions": [3], "department_id": 2}                           
*/
```

## 插入JSON字段
json字段写成json化的字符串
```mysql
INSERT INTO employee(`name`, rest) VALUES
('Mally', '{"age":23, "gender":0, "salary": 56000, "positions": [1], "stock": 6000000, "department_id":1}');
```

## 以json字段内的某个值作为连接查询的条件
* 查询员工信息及员工所有的部门信息

    这里以员工的rest json对象中的department_id与部门id作为连接条件
    ```mysql
    SELECT e.id, e.name, e.rest->>"$.age" AS 'age', e.rest->>"$.salary" AS 'salary', d.id, d.name department_name 
    FROM department_tbl AS d
    INNER JOIN employee AS e 
    ON d.id = e.rest->>"$.department_id"
    ;

    -- 或
    SELECT e.id, e.name, e.rest->"$.age" AS 'age', e.rest->"$.salary" AS 'salary', d.id, d.name department_name 
    FROM department_tbl AS d
    RIGHT OUTER JOIN employee AS e 
    ON d.id = e.rest->>"$.department_id"
    ;
    /*
        id  name      age     salary      id  department_name  
    ------  --------  ------  ------  ------  -----------------
         1  Mally     23      56000        1  行政部        
         2  Jakob     22      80000        1  行政部        
         3  Einstein  21      80000        2  财务部        
    */
    ```

* 查看所有员工的基本信息和职位信息
    ```mysql
    SELECT e.id, e.name, p.id, p.name
    FROM employee AS e
    LEFT OUTER JOIN positions AS p
    ON p.id MEMBER OF (e.rest->>'$.positions')
    ;
    
    -- 或
    SELECT e.id, e.name, p.id, p.name
    FROM employee AS e
    LEFT OUTER JOIN positions AS p
    ON JSON_CONTAINS(e.rest->>'$.positions', CAST(p.id AS JSON))
    ;
    
    -- 或
    SELECT e.id, e.name, p.id, p.name
    FROM employee AS e
    LEFT OUTER JOIN positions AS p
    ON JSON_CONTAINS(e.rest->>'$.positions', JSON_ARRAY(p.id))
    ;
    /*
        id  name          id  name             
    ------  --------  ------  -----------------
         1  Mally          1  行政总监     
         2  Jakob          4  风投首席官  
         2  Jakob          3  安全顾问     
         2  Jakob          2  财务经理     
         3  Einstein       3  安全顾问     
    */
    ```

## JSON字段值的CRUD
JSON字段值的CRUD相对于mysql 表的列来说都是update 列(字段)操作。

### 插入JSON值
* 示例
    ```mysql
    -- 给员工Einstein分配股票 6000000 股。
    UPDATE employee SET rest = JSON_INSERT(rest, '$.stock', 6000000) WHERE `name` = 'Einstein';
    -- 或JSON_SET() 函数，插入或更新
    UPDATE employee SET rest = JSON_SET(rest, '$.stock', 6000000) WHERE `name` = 'Einstein';
    ```

### 查询JSON值
* 示例
```mysql
-- 查询部门id为1的员工信息
SELECT * FROM employee
WHERE rest->'$.department_id' = 1;
/*
    id  name    rest                                                                                                      
------  ------  ----------------------------------------------------------------------------------------------------------
     7  Mally   {"age": 23, "stock": 6000000, "gender": 0, "salary": 56000, "positions": [1], "department_id": 1}         
     8  Jakob   {"age": 22, "stock": 96000000, "gender": 1, "salary": 80000, "positions": [2, 3, 4], "department_id": 1}  
*/
```

### 更新JSON值
```mysql
-- 把员工Mally的年龄修改为24。
UPDATE employee SET rest = JSON_REPLACE(rest, '$.age', 24) WHERE `name` = 'Mally';

-- 把员工Mally的职位替换为 "财务经理"。
-- JSON_SET(json_doc, path, val[, path, val] ...) 插入或更新，若 path存在则替换值，若path不存在则插入值
UPDATE employee SET rest = JSON_SET(rest, '$.positions[0]', 2) WHERE `name` = 'Mally';

-- 员工Einstein兼任"快乐鼓励师"一职。
UPDATE employee SET rest = JSON_ARRAY_APPEND(rest, '$.positions', 5) WHERE `name` = 'Einstein';

-- 员工Einstein再兼任"财务经理"一职，并且要求该职位信息排在他担任的职位信息中的第一个。
UPDATE employee SET rest = JSON_ARRAY_INSERT(rest, '$.positions[0]', 2) WHERE `name` = 'Einstein';

```

### 删除JSON值
```mysql
-- 员工Jakob卸任 "安全顾问" 一职。
UPDATE employee SET rest = JSON_REMOVE(rest, '$.positions[2]') WHERE `name` = 'Jakob';

-- 为保护企业重要人物的个人隐私，现在要求将员工Jakob的年龄信息删除。
UPDATE employee SET rest = JSON_REMOVE(rest, '$.age') WHERE `name` = 'Jakob';
```

