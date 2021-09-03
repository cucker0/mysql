Mysql JSON
==

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

## json索引优化
[参考 Multi-Valued Indexes](https://dev.mysql.com/doc/refman/8.0/en/create-index.html#create-index-multi-valued)

## 建表
要使用JSON数据类型，指定表字段类型为 `JSON` 即可。

```mysql
CREATE DATABASE jsontest CHARSET 'utf8mb4';
USE jsontest;

-- 员工表 
CREATE TABLE employee (
    id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(64) NOT NULL,
    rest JSON COMMENT '其它信息(json类型)'
);

-- insert record
INSERT INTO employee(`name`, rest) VALUES
('Mally', '{"age":23, "gender":0, "salary": 56000, "positions": "cfo,ceo", "stock": 6000000, "department_id":1}'),
('Jakob', '{"age":22, "gender":1, "salary": 80000, "positions": "Mathematics consultant,cfa", "stock": 96000000,"department_id":1}'),
('Einstein', '{"age":21, "gender":1, "salary": 80000, "positions": "Security consultant,cfa"}')
;
```

## 插入JSON字段
json字段写成json化的字符串
```mysql
INSERT INTO employee(`name`, rest) VALUES
('Mally', '{"age":23, "gender":0, "salary": 56000, "positions": "cfo,ceo", "stock": 6000000, "department_id":1}')
;
```

## JSON字段值的CRUD
### 插入JSON值
```mysql

```

### 查询JSON值

### 更新JSON值

### 删除JSON值


### 使用json字段内的某个值作为连接条件
* 创建部门表
    ```mysql
    CREATE TABLE department_tbl (
        id INT PRIMARY KEY AUTO_INCREMENT,
        `name` VARCHAR(64) NOT NULL
    );
    
    -- insert data
    INSERT INTO department_tbl(`name`) VALUES
    ('行政部'),
    ('财务部'),
    ('销售部'),
    ('客服部')
    ;
    ```
* 连接查询
    ```mysql
    SELECT e.id, e.name, e.rest->>"$.age", e.rest->>"$.salary", d.name department_name FROM department_tbl AS d
    INNER JOIN employee AS e 
    ON d.id = e.rest->>"$.department_id"
    ; 
    ```

    ```mysql
    SELECT e.id, e.name, e.rest->>"$.age", e.rest->>"$.salary", d.name department_name FROM department_tbl AS d
    RIGHT OUTER JOIN employee AS e 
    ON d.id = e.rest->>"$.department_id"
    ;
    ```
    