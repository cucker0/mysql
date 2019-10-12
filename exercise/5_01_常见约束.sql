-- 常见约束


/*
功能：用于限制表中的数据，为了保证表中的数据的准确性和可靠性


## 按功能分类(6大约束)
* not null
>非空值，限制值不能为null，即必须填入数据。没有此约束表示该字段可以填写null，且可以多行都填null

* default 值
>默认值， 保证该字段有默认值，插入数据是不填写此值时，自动为默认值

* primary key
>主键，用于保证该字段的所有行的值都是唯一的，且不能为null值。相当于 唯一约束 + 非null值约束

* unique
>值唯一，用于保证该字段的所有行的值都是唯一的，且最多允许有一个null值。

* check
MySQL 8.0.16开始支持此约束，之前的版本虽然语法不报错，但不生效)
```text
>检查约束，用于该字段检查插入的值是否符合check设置的表达式条件
check (expr)

参考 https://dev.mysql.com/doc/refman/8.0/en/create-table-check-constraints.html
```

* foreign key
>外键，用于限制两个表的关系，用于保证该字段的值必须来自于主表关联列的值，引用主表对应列的值
在从表中添加外键约束



## 添加约束的时机
* 创建表时
* 修改表时

## 按作用范围分类
* 列级约束
>6大约束在语法上都支持，但外键约束没有效果。

* 表级约束
>除了not null、默认值约束外，其他的都可以(主键、唯一、外键、check)

* 通常primary key、not null、default、unique、check用列级，
    外键约束用表级
    

## 主键约束、唯一约束对比
类型      保证唯一性   值是否可为null值      一个表中可有多少个这类约束   是否可以多个字段组合
主键约束  是           否              0     最多1个                      是，不推荐，组合的每个字段不许为null,组合的值唯一
唯一约束  是           是，最多一个null值    可有多个                     是，不推荐，表示多个字段组合后的值是唯一


## 外键
* 必修在从表设置外键约束
* 从表的外键列的类型与主表的关联列的类型要求一致或兼容，列名相同或不同均可
* 主表的关联列必须是一个key(一般是主键或唯一键)
* 插入数据时，先插入主表数据，再插入从表数据
* 删除数据时，先删除从表数据，再删除主表数据

*/

/*
## 语法
create table 表名 (
    字段名1 字段类型 列级约束,
    字段名2 字段类型,
    
    表级约束
);

*/


-- 创建表时添加约束
-- 

# 添加列级约束
/*
## 语法
直接在列类型后追加,约束即可，可有多个约束
只支持：默认约束、非空not null、主键、唯一

*/

USE test;

CREATE TABLE major (
    id INT PRIMARY KEY,
    majorName VARCHAR (20)
);

CREATE TABLE stuinfo (
    id INT PRIMARY KEY, -- 主键
    `name` VARCHAR (32) NOT NULL UNIQUE, -- 非空值、唯一
    gender CHAR (1) CHECK(gender IN ('男', '女')), -- 检查约束
    seat INT UNIQUE, -- 唯一
    age INT DEFAULT 1, # 默认值
    majorId INT REFERENCES major (id) -- 外键
);

DESC stuinfo;

-- 查看表中所有的约束，包括主键、外键、唯一键等
SHOW INDEX FROM stuinfo;


# 添加表级约束
/*
## 语法
在最后字段下面添加
[constraint 约束名] 约束类型 (被约束的字段)

* 主键的约束名只能为PRIMARY，即使指定了也不会生效，不会报错
* 同一个表中的约束名不能重复

*/


DROP TABLE IF EXISTS stuinfo;
CREATE TABLE stuinfo (
    id INT,
    `name` VARCHAR(32),
    gender CHAR(1),
    seat INT,
    age INT,
    majorId INT,
    
    CONSTRAINT pk PRIMARY KEY (id),  -- 主键，主键约束名只能为PRIMARY，所以即使这是约束名也不生效
    CONSTRAINT uq UNIQUE (seat), -- 唯一
    CONSTRAINT ck CHECK (gender = '男' OR gender = '女'), -- 检查约束
    CONSTRAINT stuinfo__majorId_fk_major__id FOREIGN KEY (majorId) REFERENCES major (id), -- 外键
    CONSTRAINT uq_name_seat UNIQUE (`name`, seat) -- 组合的唯一约束
);

DESC stuinfo;
SHOW INDEX FROM stuinfo;

INSERT INTO major VALUES
(1, 'python'),
(2, 'java')
;

INSERT INTO stuinfo VALUES (1, 'lily', '中', 3, 18, 1);


-- 修改表时添加约束
--

/*
## 添加列级约束
alter table 表名 modify column 字段名 字段烈性 约束;


## 添加表及约束
alter table 表名 add [constraint 约束名] 约束类型 (字段名);


-- 添加外键
alter table 表名 add [constraint 约束名] foreign key (本表关联的字段名) references 主表名 (主表中关联的列名);

*/


DROP TABLE IF EXISTS stuinfo;

CREATE TABLE stuinfo (
    id INT,
    `name` VARCHAR(32),
    gender CHAR(1),
    seat INT,
    age INT,
    majorId INT
)

DESC stuinfo;
SHOW INDEX FROM stuinfo;

# 添加非空值约束
ALTER TABLE stuinfo MODIFY COLUMN `name` VARCHAR(32) NOT NULL;

# 添加默认值约束
ALTER TABLE stuinfo MODIFY COLUMN age INT DEFAULT 1;

# 添加主键约束
    -- 列级约束方式
ALTER TABLE stuinfo MODIFY COLUMN id INT PRIMARY KEY;

    -- 表级约束方式
ALTER TABLE stuinfo ADD PRIMARY KEY (id);

# 添加值唯一约束
    -- 列级约束方式
ALTER TABLE stuinfo MODIFY COLUMN seat INT UNIQUE;

    -- 表级约束方式
ALTER TABLE stuinfo ADD UNIQUE (seat);

# 添加外键约束
ALTER TABLE stuinfo ADD CONSTRAINT stuinfo__majorId_fk_major__id FOREIGN KEY (majorId) REFERENCES major (id);

# 添加检查约束
ALTER TABLE stuinfo ADD CONSTRAINT stuinfo_ck_gender CHECK (gender IN ('男', '女'));



-- 修改表时删除约束
-- 

# 删除非空值约束
ALTER TABLE stuinfo MODIFY COLUMN `name` VARCHAR(32);

# 删除默认值约束
ALTER TABLE stuinfo MODIFY COLUMN age INT;

# 删除主键约束
ALTER TABLE stuinfo DROP PRIMARY KEY;

# 删除值唯一约束
ALTER TABLE stuinfo DROP INDEX seat;

# 删除外键约束
ALTER TABLE stuinfo DROP FOREIGN KEY stuinfo__majorId_fk_major__id; -- 执行了这步后，外键已删除，此key:stuinfo__majorId_fk_major__id 还在
ALTER TABLE stuinfo DROP KEY stuinfo__majorId_fk_major__id; -- 对于取了约束名的还要执行这步

# 删除检查约束
ALTER TABLE stuinfo DROP CHECK stuinfo_ck_gender;


DESC stuinfo;

SHOW INDEX FROM stuinfo;

SHOW CREATE TABLE stuinfo;


-- 外键
--

# 多列外键组合
-- 主表
CREATE TABLE classes (
    id INT,
    `name` VARCHAR(20),
    number INT,
    PRIMARY KEY (`name`, number)
);

DESC classes;

-- 从表
DROP TABLE IF EXISTS student; 
CREATE TABLE student (
    id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(32),
    classes_name VARCHAR(20),
    classes_number INT,
    
    CONSTRAINT student_fk_classes FOREIGN KEY (classes_name, classes_number)
    REFERENCES classes (`name`, number)
);

SHOW CREATE TABLE student;

INSERT INTO classes VALUES
(1, 'c191', 191),
(2, 'c192', 192),
(3, 'c193', 193);



INSERT INTO student (classes_name, classes_number, `name`) VALUES ('c193', 193, '张杨');

INSERT INTO student
SELECT NULL, '黑蒙', c.name, c.number
FROM classes c
WHERE number = 191
;

INSERT INTO student (classes_name, classes_number, `name`) VALUES ('c193', 194, '王丰'); -- 插入失败


SELECT * FROM student;


-- 级联删除(ON DELETE CASCADE)
-- 当删除主表中的记录时，从表中关联此记录的相关记录也被自动同时删除
DROP TABLE IF EXISTS major;
CREATE TABLE major1 ( -- 主表
    id INT PRIMARY KEY,
    `name` VARCHAR(20)
);

DROP TABLE IF EXISTS stu1;
CREATE TABLE stu1 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(32),
    major_id INT,
    CONSTRAINT stu1__major_id_fk_major1__id FOREIGN KEY (major_id) REFERENCES major1 (id) ON DELETE CASCADE
);

SHOW CREATE TABLE stu1;

INSERT INTO major1 VALUES
(1, 'java'),
(2, 'GO'),
(3, 'python');

SELECT * FROM major1;


INSERT INTO stu1 VALUES
(NULL, 'jacy1', 1),
(NULL, 'jacy2', 1),
(NULL, 'jacy3', 2),
(NULL, 'jacy4', 2),
(NULL, 'jacy5', 1),
(NULL, 'jacy6', 1),
(NULL, 'jacy7', 3),
(NULL, 'jacy8', 1),
(NULL, 'jacy9', 1),
(NULL, 'jacy10', 3),
(NULL, 'jacy11', 1);

SELECT * FROM stu1;

DELETE FROM major1 WHERE id = 3;
SELECT * FROM stu1;


-- 级联置空(ON DELETE SET NULL)
-- 当删除主表中的记录时，从表中关联此记录的相关记录外键列值也被自动同时设置为null值，不会被删除
DROP TABLE IF EXISTS stu1;
CREATE TABLE stu1 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(32),
    major_id INT DEFAULT 1,
    CONSTRAINT stu1__major_id_fk_major1__id FOREIGN KEY (major_id) REFERENCES major1 (id) ON DELETE SET NULL
);

SHOW CREATE TABLE stu1;
INSERT INTO stu1 VALUES
(NULL, 'jacy1', 1),
(NULL, 'jacy2', 1),
(NULL, 'jacy3', 2),
(NULL, 'jacy4', 2),
(NULL, 'jacy5', 1),
(NULL, 'jacy6', 1),
(NULL, 'jacy8', 1),
(NULL, 'jacy9', 1),
(NULL, 'jacy11', 1);

SELECT * FROM stu1;

DELETE FROM major1 WHERE id = 1;

SELECT * FROM stu1;
